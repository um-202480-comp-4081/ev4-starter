# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes follow resource naming' do
  context 'when routing' do
    specify 'VideoGames index' do
      expect(get: video_games_path).to route_to 'video_games#index'
    end

    specify 'VideoGames new' do
      expect(get: new_video_game_path).to route_to 'video_games#new'
    end

    specify 'VideoGames create' do
      expect(post: video_games_path).to route_to 'video_games#create'
    end

    specify 'VideoGames destroy' do
      expect(delete: video_game_path(1)).to route_to controller: 'video_games', action: 'destroy', id: '1'
    end

    specify 'VideoGames show' do
      expect(get: 'video_games/1').not_to be_routable
    end

    specify 'VideoGames edit' do
      expect(get: 'video_games/1/edit').not_to be_routable
    end

    specify 'VideoGames update' do
      expect(patch: 'video_games/1').not_to be_routable
    end
  end

  context 'when creating path helpers' do
    specify 'video_games_path' do
      expect(video_games_path).to eq '/video_games'
    end

    specify 'video_game_path' do
      expect(video_game_path(1)).to eq '/video_games/1'
    end

    specify 'new_video_game_path' do
      expect(new_video_game_path).to eq '/video_games/new'
    end
  end
end
