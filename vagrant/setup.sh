#!/bin/bash

function die()
{
	echo "$*" && exit 1
}

echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bash_profile
echo 'export PATH=$PATH:/usr/local/bin' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> /home/vagrant/.bash_profile

RUSER=retro

RHOME=/home/$RUSER
GITDIR=$RHOME/retro-runner.git
DEPLOY=$RHOME/retro-runner.deploy

yum install -y git-core zlib zlib-devel gcc-c++ patch \
								readline readline-devel libyaml-devel libffi-devel \
							  openssl-devel make bzip2 autoconf automake libtool \
							  bison postgresql-devel wget glibc-static docker || die "failed to install base packages"

MAKEUSER=$(cut -d: -f1 /etc/passwd | grep -w $RUSER)
if [ "$MAKEUSER" == "" ]; then
	# add a retro user
	adduser --home=$RHOME -m $RUSER || die "Failed to add user"
	mkdir $RHOME/.ssh && chown $RUSER:$RUSER $RHOME/.ssh || die "Failed to create .ssh dir for keys"
	echo "export PATH=$PATH:/usr/local/bin" >> $RHOME/.bash_profile || die "Failed to add /usr/local/bin path"
else
	echo "Skipping $USER user creation"
fi

if [ ! -e /usr/local/bin/rvm/bin/rvm ]; then
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || die "Failed to add rvm key"
	curl -sSL https://get.rvm.io | bash -s stable || die "Failed to install rvm"
else
	echo "Skipping rvm install"
fi

source /etc/profile.d/rvm.sh
rvm install 2.3.6
gem install bundler

if [ ! -e /usr/local/bin/node ] ; then
	cd /tmp
	wget -q http://nodejs.org/dist/latest/node-v9.5.0-linux-x64.tar.gz || die "Failed to download node tarball"
	tar --strip-components 1 -xzvf node-v* -C /usr/local || die "Failed to unpack node tarball"
else
	echo "Skipping execjs installation"
fi

# set up git repo with auto-deploy on push
mkdir -p $GITDIR $DEPLOY && chown $RUSER:$RUSER $GITDIR $DEPLOY || die "Failed to make git dirs"
if [ ! -e $GITDIR/HEAD ] ; then
	git init --bare $GITDIR || die "Failed to init git repo"
else
	echo "Skipping git init"
fi

if [ ! -e $GITDIR/hooks/post-receive ]; then
	cat > $GITDIR/hooks/post-receive <<EOF
#!/bin/bash

while read oldrev newrev ref
do
    if [[ $ref =~ .*/master$ ]];
    then
      echo "Master ref received.  Deploying master branch to production..."
			git --work-tree=$DEPLOY --git-dir=$GITDIR checkout -f

    else
      echo "Ref $ref successfully received.  Doing nothing: only the master branch may be deployed on this server."
    fi
done
EOF
else
	echo "Skipping post-receive hook creation"
fi

chmod +x $GITDIR/hooks/post-receive || die "Failed to +x post-receive hook"

# set up runsv for the rails app
if [ ! -e /usr/local/bin/runsv ] ; then
	mkdir -p /package && chmod 1755 /package || die "Failed to make package dir"
	cd /package && wget -q http://smarden.org/runit/runit-2.1.2.tar.gz	|| die "Failed to get runit source"
 	gunzip runit-2.1.2.tar && tar -xpf runit-2.1.2.tar &&	rm runit-2.1.2.tar || die "Failed to unpack runit source"
 	pushd admin/runit-2.1.2 && package/install && popd || die "Failed to install runit"

	install -m0750 /package/admin/runit/etc/2 /sbin/runsvdir-start && mkdir -p /etc/service && ln -s /etc/service /service || die "failed to install runit startup"
	cat > /etc/systemd/system/runit.service <<EOT
[Unit]
Description=Runit service supervision
Documentation=http://smarden.org/runit/

[Service]
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/bin"
ExecStart=/usr/local/bin/runsvdir -P /etc/service 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'
KillSignal=SIGHUP
KillMode=process
Restart=always
SuccessExitStatus=111

[Install]
WantedBy=multi-user.target
EOT
	chmod +x /etc/systemd/system/runit.service && systemctl enable runit || die "Failed to enable runit for system boot"
	service runit start || die "Failed to start runit"
else
	echo "Skipping runit installation"
fi

# start a docker DB
service docker start || die "Failed to start docker service"
systemctl enable docker || die "Failed to enable docker to run at boot"

DOCKER_NAME=pg_retrorunner
DBPORT=5432
DBPASS='pa55word'
DB='retrorunner_dev'
DBURL="postgres://postgres:$DBPASS@localhost:$DBPORT/$DB"

DOCKER_DB=$(docker ps -qf name=$DOCKER_NAME)
if [ "$DOCKER_DB" == "" ]; then
	DOCKER_DB=$(docker ps -aqf name=$DOCKER_NAME)

	if [ "$DOCKER_DB" == "" ]; then
		docker run --restart on-failure --name $DOCKER_NAME -p $DBPORT:$DBPORT -e POSTGRES_PASSWORD=$DBPASS -d postgres
	else
		docker start $DOCKER_NAME
	fi
else
	echo "already running: $DOCKER_DB"
fi

# make a run file
mkdir -p /etc/sv/rails /etc/sv/rails/log
cat > /etc/sv/rails/run <<EOF
#!/usr/bin/env bash

source /usr/local/rvm/scripts/rvm
source $RHOME/.bashrc

exec 2>&1

cd $DEPLOY
export RAILS_ENV=development
export DATABASE_URL=$DBURL

if [ ! -d /var/run/rails ]
then
  mkdir /var/run/rails
  chown $RUSER:$RUSER /var/run/rails
fi

# run bundle install
/usr/local/bin/chpst -u$RUSER env HOME=/home/$RUSER \
	bundle install --path vendor/bundle

# db:create (?) and migrate
/usr/local/bin/chpst -u$RUSER env HOME=/home/$RUSER \
	bundle exec rake db:create
/usr/local/bin/chpst -u$RUSER env HOME=/home/$RUSER \
	bundle exec rake db:migrate

# Start the rails process
exec /usr/local/bin/chpst -u$RUSER env HOME=/home/$RUSER \
  bundle exec rails server -b 0.0.0.0
EOF

cat > /etc/sv/rails/log/run <<EOF
#!/usr/bin/env bash

exec 2>&1

mkdir -p /var/log/rails

exec svlogd /var/log/rails
EOF

# make them executable
chmod +x /etc/sv/rails/run /etc/sv/rails/log/run

# clone the first one
git clone https://github.com/dougscheirer/retro-runner $DEPLOY || die "failed to init the git deploy dir"
chown $RUSER:$RUSER -R $RHOME || die "Failed to own $RHOME for $RUSER"

# enable the runsv tasks
ln -s /etc/sv/rails /etc/service/rails || die "Failed to enable rails as a runit task"

