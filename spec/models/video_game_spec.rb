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
require 'rails_helper'

RSpec.describe VideoGame do
  it 'has the correct non-string column types' do
    columns = ActiveRecord::Base.connection.columns(:video_games)

    expect(columns.find { |c| c.name == 'year' }.sql_type).to eq 'integer'
  end

  it 'has seeds' do
    load Rails.root.join('db/seeds.rb').to_s

    expect(described_class.count).to eq 5
    expect(described_class.order(:year).pluck(:title, :year, :publisher, :genre))
      .to eq [['Asteroids', 1981, 'Atari', 'Action'],
              ['Pitfall!', 1982, 'Activision', 'Action-adventure'],
              ['Polaris', 1983, 'Tigervision', 'Action'],
              ['Q*bert', 1983, 'Parker Brothers', 'Action'],
              ['Millipede', 1984, 'Atari', 'Action']]
  end
end
