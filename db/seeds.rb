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

user1=User.create(:name=>"Doug",:email=>"dscheirer@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure", :admin=>'t')
user2=User.create(:name=>"Phil",:email=>"phil@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
user3=User.create(:name=>"Joe",:email=>"joe@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
user4=User.create(:name=>"Wendy",:email=>"wendy@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
user5=User.create(:name=>"Dave",:email=>"dave@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
user6=User.create(:name=>"Alex",:email=>"alex@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")
user7=User.create(:name=>"Alau_branch",:email=>"alau@perforce.com",:password=>"notsecure",:password_confirmation=>"notsecure")

base_retro = Retro.create(:meeting_date=>Date.today().to_date.to_s, :project_id=>base_project.id, :status=>"New")
Retro.create(:meeting_date=>Date.today().to_date.to_s, :project_id=>base_project.id, :status=>"New")
Retro.create(:meeting_date=>Date.today().to_date.to_s, :project_id=>base_project.id, :status=>"New")
Retro.create(:meeting_date=>Date.today().to_date.to_s, :project_id=>base_project.id, :status=>"New")

Issue.create(:issue_type=>"Good",:member=>"Phil",:description=>"that was awesome",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Meh",:member=>"Phil",:description=>"that was ok",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Bad",:member=>"Phil",:description=>"that was terrible",:retro_id=>base_retro.id)
Issue.create(:issue_type=>"Good",:member=>"Doug",:description=>"that was great",:retro_id=>base_retro.id)