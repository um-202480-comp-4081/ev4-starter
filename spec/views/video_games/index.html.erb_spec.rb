# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'video_games/index.html.erb' do
  before do
    assign :games, build_stubbed_list(:video_game, 2)

    allow(view).to receive(:link_to).and_call_original
    allow(view).to receive(:button_to).and_call_original
    allow(view).to receive(:video_game_path).and_call_original
    allow(view).to receive(:new_video_game_path).and_call_original

    render
  end

  it 'uses link_to helper for links' do
    expect(view).to have_received(:link_to).exactly(1).times
  end

  it 'uses button_to helper for links' do
    expect(view).to have_received(:button_to).exactly(2).times
  end

  it 'uses appropriate route helper(s)' do
    expect(view).to have_received(:video_game_path).exactly(2).times
    expect(view).to have_received(:new_video_game_path).exactly(1).times
  end

  it 'has properly closed HTML tags' do
    %w[h1 h2 h3 h4 h5 h6 p a div span ul ol li b i strong table thead tbody tr th td].each do |tag|
      expect(rendered.scan(/<#{tag}[ >]/).size).to eq(rendered.scan("</#{tag}>").size), -> { "check #{tag} tags" }
    end
  end

  it 'does not duplicate elements from layout' do
    %w[head style body].each do |el|
      expect(rendered.scan(/<#{el}[ >]/).size).to eq(0)
    end
  end
end
