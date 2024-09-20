# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideoGamesController do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new VideoGame' do
        expect {
          post :create, params: { video_game: attributes_for(:video_game) }
        }.to change(VideoGame, :count).by(1)
      end

      it 'redirects to the created video_game' do
        post :create, params: { video_game: attributes_for(:video_game) }
        expect(response).to redirect_to(video_games_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new VideoGame' do
        expect {
          post :create, params: { video_game: attributes_for(:video_game, title: nil) }
        }.not_to change(VideoGame, :count)
      end

      it 're-renders the new template' do
        post :create, params: { video_game: attributes_for(:video_game, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:video_game) { create(:video_game) }

    it 'destroys the requested video_game' do
      expect {
        delete :destroy, params: { id: video_game }
      }.to change(VideoGame, :count).by(-1)
    end

    it 'redirects to the video_games list' do
      delete :destroy, params: { id: video_game }
      expect(response).to redirect_to(video_games_url)
    end
  end
end
