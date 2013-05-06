require 'spec_helper'

describe 'matches/index.html.erb' do
  before(:each) do
    @matches = build_list(:match, 3)
    # we need to assign the ID, since we use match_path(match) in the template
    @matches.each_with_index { |match, index| match.id = index + 1 }
  end
  it 'displays a table of Matches' do
    assign(:matches, @matches)
    render

    rendered.should have_content('Matches')
  end
end
