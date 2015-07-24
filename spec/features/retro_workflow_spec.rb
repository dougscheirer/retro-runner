# test signing up
require 'rails_helper'
require_relative '../helpers/retro'

RSpec.configure do |c|
  c.include Helpers
end

feature 'Retro workflow' do
  feature 'as the retro creator' do
    scenario 'with a new retro' do
      create_project_and_retro
      expect(find_button('submit')).to have_content('Start Retro')
    end

    scenario 'with retro started' do
      create_project_and_retro
      click_button 'Start Retro'

      expect(find_button('submit')).to have_content('Add Issues')
    end

    scenario 'with past reviewed' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues

      # add some checks that the issues are here?
      #expect(find_link())
      expect(find_button('submit')).to have_content('Review Issues')
    end

    scenario 'with issues added' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues
      click_button 'Review Issues'

      expect(find_button('submit')).to have_content('Begin Voting')
      expect(find_button('next_issue')).to have_content('00:30 seconds remaining, click to proceed to next topic')
    end

    scenario 'with review completed' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues
      click_button 'Review Issues'
      click_button 'Begin Voting'

      expect(find_button('submit')).to have_content('Close Voting')
      expect(find_button('clear_votes')).to have_content('clear votes')
    end

    scenario 'with voting completed' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues
      click_button 'Review Issues'
      click_button 'Begin Voting'
      click_button 'Close Voting'

      expect(find_button('submit')).to have_content('Finish Retro')
    end

    scenario 'with retro completed' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues
      click_button 'Review Issues'
      click_button 'Begin Voting'
      click_button 'Close Voting'
      click_button 'Finish Retro'

      expect(find_button('submit')).to have_content('Restart')
    end

    scenario 'with retro restarted' do
      create_project_and_retro
      click_button 'Start Retro'
      click_button 'Add Issues'
      add_issues
      click_button 'Review Issues'
      click_button 'Begin Voting'
      click_button 'Close Voting'
      click_button 'Finish Retro'
      click_button 'Restart'

      expect(find_button('submit')).to have_content('Start Retro')
    end

    # add more tests here for:
    #   walking through each
    #   adding tasks that come out of the discussion
    #   opt-ing out of the rest of the issues
    #   finish the retro

  end
end

