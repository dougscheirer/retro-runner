# test signing up
require 'rails_helper'

feature 'Retro workflow' do
  scenario 'with new retro' do
    create_project_and_retro
    expect(page).to have_content('Start retro')
  end

  feature 'as the retro creator' do
    scenario 'with started retro' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues

      # add some checks that the issues are here
      expect(page).to have_content('Review issues')
    end

    scenario 'with issues added' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues
      click_button 'Review issues'

      expect(page).to have_content('Next issue')
      # expect(page).to have_content('Timer')
    end

    scenario 'with issues reviewed' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues
      click_button 'Review issues'

      while page.match /Next issue/ do
        click_button 'Next issue'
      end

      expect(page).to have_content 'Start pointing'
    end

    scenario 'with issues reviewed' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues
      click_button 'Review issues'

      while page.match /Next issue/ do
        click_button 'Next issue'
      end

      expect(page).to have_content 'Start pointing'
    end

    scenario 'with issues reviewed' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues
      click_button 'Review issues'

      while page.match /Next issue/ do
        click_button 'Next issue'
      end

      click_button 'Start pointing'

      expect(page).to have_content 'Finish pointing'
    end

    scenario 'with pointing completed' do
      create_project_and_retro
      click_button 'Start retro'
      add_issues
      click_button 'Review issues'

      while page.match /Next issue/ do
        click_button 'Next issue'
      end

      click_button 'Start pointing'
      add_points
      click_button 'Finish pointing'

      expect(page).to have_content 'Review top issues'
    end

    # add more tests here for:
    #   walking through each
    #   adding tasks that come out of the discussion
    #   opt-ing out of the rest of the issues
    #   finish the retro

  end
end

