# frozen_string_literal: true

# == Schema Information
#
# Table name: video_games
#
#  id         :bigint           not null, primary key
#  genre      :string
#  publisher  :string
#  title      :string
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class VideoGame < ApplicationRecord
  GENRES = ['Action', 'Action-adventure', 'Adventure', 'Gacha Game', 'Role-playing', 'Simulation', 'Strategy',
            'Horror', 'Massively multiplayer online'].freeze
  validates :title, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1950 }
  validates :genre, inclusion: { in: GENRES }, allow_blank: true
end
