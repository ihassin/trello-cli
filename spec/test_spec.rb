require 'trello'
require 'spec_helper'

RSpec.describe 'Trello API' do
  let(:mock_member) { instance_double(Trello::Member, username: 'test_user') }
  let(:mock_card) { instance_double(Trello::Card, name: 'Test Card') }

  before do
    allow(Trello::Member).to receive(:find).with('me').and_return(mock_member)
    allow(Trello::Card).to receive(:create).with(any_args).and_return(mock_card)
  end

  it 'finds a member' do
    member = Trello::Member.find('me')
    expect(member.username).to eq('test_user')
  end

  it 'creates a card' do
    card = Trello::Card.create(name: 'New Card')
    expect(card.name).to eq('Test Card')
  end
end
