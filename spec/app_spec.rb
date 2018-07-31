# frozen_string_literal: true

require_relative './spec_helper.rb'

feature App do
  describe 'index page' do
    before { visit '/' }
    scenario 'show login form to new user' do
      expect(page).to have_content 'Codebreaker App'
      expect(page).to have_button 'Start'
    end

    context 'when user log in' do
      before do
        fill_in 'player_name', with: 'John Kramer'
        click_button 'Start'
      end

      scenario 'show game interface, after user log in' do
        expect(page).to have_content 'Codebreaker App'
        expect(page).to have_content 'Guess code with number from 1 to 6'
        expect(page).to have_button 'Submit'
        expect(page).to have_button 'Hint'
      end

      scenario 'show remaining attempts and game log, if user enter code' do
        fill_in 'breaker_code', with: '1111'
        click_button 'Submit'
        expect(page).to have_content 'Attempts: 4/5'
        expect(page).to have_table 'game_log'
      end

      scenario 'show hint, if user asq about it' do
        click_button 'Hint'
        expect(page).to have_content 'Your hint'
      end

      scenario 'show message to user and forms with buttons after game' do
        5.times do
          fill_in 'breaker_code', with: '1111'
          click_button 'Submit'
        end
        expect(page).to have_content 'John Kramer'
        expect(page).to have_button 'Save results'
        expect(page).to have_button 'Restart game'
      end
    end
  end

  describe 'page game scores' do
    scenario 'show table with saved scores' do
      visit '/scores'
      expect(page).to have_content 'Codebreaker App'
      expect(page).to have_content 'Statistics:'
      expect(page).to have_table 'game_log'
    end
  end

  describe 'page 404' do
    scenario 'show 404 error response if page not found' do
      visit '/nopage'
      expect(page.status_code).to eq(404)
    end
  end
end
