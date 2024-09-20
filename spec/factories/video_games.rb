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
FactoryBot.define do
  factory :video_game do
    title { 'Pacman' }
    year { 1950 }
  end
end
