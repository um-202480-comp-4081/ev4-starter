# frozen_string_literal: true

class VideoGamesController < ApplicationController
  def index
    @games = VideoGame.order(year: :desc)
    render :index
  end
end
