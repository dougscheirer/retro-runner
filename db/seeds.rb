# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Issue.create(:issue_type=>"Good",:member=>"Phil",:description=>"that was awesome")
Issue.create(:issue_type=>"Meh",:member=>"Phil",:description=>"that was ok")
Issue.create(:issue_type=>"Bad",:member=>"Phil",:description=>"that was terrible")
Issue.create(:issue_type=>"Good",:member=>"Doug",:description=>"that was great")
