# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Visitor Features' do
  feature 'Browse Video Games' do
    let!(:video_game_one) do
      create(:video_game, title: 'Game One', year: 1971, publisher: 'Publisher One', genre: 'Action')
    end
    let!(:video_game_two) do
      create(:video_game, title: 'Game Two', year: 1970, publisher: 'Publisher Two', genre: 'Adventure')
    end

    scenario 'Viewing the video game index page content' do
      visit video_games_path

      aggregate_failures do
        expect(page).to have_css('h1', text: 'Video Games DB')
        within('table') do
          within('thead') do
            within('tr') do
              expect(page).to have_css('th', text: 'Title')
              expect(page).to have_css('th', text: 'Year')
              expect(page).to have_css('th', text: 'Publisher')
              expect(page).to have_css('th', text: 'Genre')
              expect(page).to have_css('th', exact_text: '', count: 1)
            end
          end
          within('tbody') do
            expect(page).to have_css('tr', count: 2)

            within('tr:nth-child(1)') do
              expect(page).to have_css('td', text: video_game_one.title)
              expect(page).to have_css('td', text: video_game_one.year)
              expect(page).to have_css('td', text: video_game_one.publisher)
              expect(page).to have_css('td', text: video_game_one.genre)
              expect(page).to have_button('delete')
            end

            within('tr:nth-child(2)') do
              expect(page).to have_css('td', text: video_game_two.title)
              expect(page).to have_css('td', text: video_game_two.year)
              expect(page).to have_css('td', text: video_game_two.publisher)
              expect(page).to have_css('td', text: video_game_two.genre)
              expect(page).to have_button('delete')
            end
          end
        end
        expect(page).to have_link('Create video game')
      end
    end

    scenario 'Redirecting from the root page to the video_games page' do
      visit root_path

      expect(page).to have_current_path(video_games_path, ignore_query: true)
    end
  end

  feature 'Create New Video Game' do
    scenario 'Viewing the new video game form page' do
      visit new_video_game_path

      aggregate_failures do
        expect(page).to have_css('h1', text: 'New Video Game')
        expect(page).to have_field('Title')
        expect(page).to have_field('Year')
        expect(page).to have_field('Publisher')
        expect(page).to have_field('Genre')
        expect(page).to have_button('Create Video game')
      end
    end

    scenario 'Creating a new video_game with valid details' do
      visit new_video_game_path

      fill_in 'Title', with: 'New Game'
      fill_in 'Year', with: 1950
      fill_in 'Publisher', with: 'New Publisher'
      select 'Strategy', from: 'Genre'
      click_on 'Create Video game'

      expect(VideoGame.last).to have_attributes(title: 'New Game', publisher: 'New Publisher', genre: 'Strategy',
                                                year: 1950)
      expect(page).to have_current_path(video_games_path, ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'New video game successfully added!')
      expect(page).to have_css('tbody tr', count: 1)
    end

    scenario 'Creating a new video_game with missing title', :js do
      visit new_video_game_path

      fill_in 'Year', with: 1950
      fill_in 'Publisher', with: 'New Publisher'
      select 'Strategy', from: 'Genre'
      click_on 'Create Video game'

      expect(VideoGame.count).to eq(0) # No new video_game should be created
      message = page.find_by_id('video_game_title').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end

    scenario 'Creating a new video_game with invalid year' do
      visit new_video_game_path

      fill_in 'Title', with: 'Invalid Game'
      fill_in 'Year', with: 0
      fill_in 'Publisher', with: 'New Publisher'
      select 'Strategy', from: 'Genre'
      click_on 'Create Video game'

      expect(VideoGame.count).to eq(0) # No new video_game should be created
      expect(page).to have_css('.alert-danger', text: 'Video game creation failed.')
      expect(page).to have_content('Year must be greater than or equal to 1950', normalize_ws: true)
    end

    scenario 'Creating a new video_game with no year' do
      visit new_video_game_path

      fill_in 'Title', with: 'Invalid Game'
      fill_in 'Publisher', with: 'New Publisher'
      select 'Strategy', from: 'Genre'
      click_on 'Create Video game'

      expect(VideoGame.count).to eq(0) # No new video_game should be created
      expect(page).to have_css('.alert-danger', text: 'Video game creation failed.')
      expect(page).to have_content('Year is not a number', normalize_ws: true)
    end

    scenario 'Creating a new video_game with no genre' do
      visit new_video_game_path

      fill_in 'Title', with: 'New Game'
      fill_in 'Year', with: 1950
      fill_in 'Publisher', with: 'New Publisher'
      click_on 'Create Video game'

      expect(VideoGame.last).to have_attributes(title: 'New Game', publisher: 'New Publisher', genre: '',
                                                year: 1950)
      expect(page).to have_current_path(video_games_path, ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'New video game successfully added!')
      expect(page).to have_css('tbody tr', count: 1)
    end

    scenario 'Navigating to the new video_game page from the index page' do
      visit video_games_path

      click_on 'Create video game'

      expect(page).to have_current_path(new_video_game_path, ignore_query: true)
    end

    scenario 'Navigating back to the video_game index page from the new page' do
      visit new_video_game_path

      click_on 'Cancel'

      expect(page).to have_current_path(video_games_path, ignore_query: true)
    end
  end

  feature 'Destroy Video Game' do
    let!(:video_game) { create(:video_game) }

    scenario 'Deleting a video_game from the index page' do
      visit video_games_path

      expect(page).to have_content(video_game.title)
      expect do
        click_on 'delete', match: :first
      end.to change(VideoGame, :count).by(-1)

      expect(page).to have_current_path(video_games_path, ignore_query: true)
      expect(page).to have_css('.alert-success', text: 'Video game successfully removed')
      expect(page).to have_no_content(video_game.title)
    end
  end
end
