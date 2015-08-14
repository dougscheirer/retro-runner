# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

base_project = Project.create(:name=>"Test one",:description=>"Test project number one",:owner_id=>1)
Project.create(:name=>"Test two",:description=>"Test project number two",:owner_id=>1)
Project.create(:name=>"Test three",:description=>"Test project number three",:owner_id=>1)
Project.create(:name=>"Test four",:description=>"Test project number four",:owner_id=>1)

doug=User.create(:name=>"Doug",:email=>"dscheirer@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure", :admin=>'t')
phil=User.create(:name=>"Phil",:email=>"phorowitz@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
joe=User.create(:name=>"Joe",:email=>"jrobinson@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
wendy=User.create(:name=>"Wendy",:email=>"wsadeh@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
dave=User.create(:name=>"Dave",:email=>"dgeorge@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
alex=User.create(:name=>"Alex",:email=>"alex@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
alex_the_intern=User.create(:name=>"Alex_the_Intern",:email=>"ashankland@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure", :admin=>'t')
alau=User.create(:name=>"Alau_branch",:email=>"alau@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")

base_retro = Retro.create(:meeting_date=>Date.today(), :project_id=>base_project.id, :status=>'not_started', :creator_id => doug.id)
Retro.create(:meeting_date=>Date.tomorrow(), :project_id=>base_project.id, :status=>'not_started', :creator_id => doug.id)
Retro.create(:meeting_date=>1.days.ago, :project_id=>base_project.id, :status=>'not_started', :creator_id => doug.id)
Retro.create(:meeting_date=>-2.days.ago, :project_id=>base_project.id, :status=>'not_started', :creator_id => doug.id)

Issue.create(:issue_type=>"Good",:creator_id=>phil.id,:description=>"that was awesome",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Meh",:creator_id=>phil.id,:description=>"that was ok",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Bad",:creator_id=>phil.id,:description=>"that was terrible",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Good",:creator_id=>doug.id,:description=>"that was great",:retro_id=>base_retro.id)
