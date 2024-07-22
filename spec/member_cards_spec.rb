require 'trello'
require 'spec_helper'
require_relative '../lib/member_cards'

RSpec.describe 'Get Member cards API' do
  let(:mock_card) { instance_double(Trello::Card, name: 'Test Card', list: mock_list) }
  let(:mock_list) { instance_double(Trello::List, name: 'Done') }

  let(:mock_board) { double(Trello::Board, name: 'Test Board', id: '12345', cards: [mock_card]) }

  let(:mock_member) { double(Trello::Member, username: 'member', id: 1) }

  before do
    allow(mock_board).to receive(:find).with('12345').and_return(mock_board)

    allow(mock_card).to receive(:member_ids).with(any_args).and_return([mock_member.id])
    allow(mock_card).to receive(:due_complete).with(any_args).and_return(false)
  end

  it 'Returns an empty list of cards given all are in the done column' do
    cards = MemberCards.get_cards(trello_board: mock_board, for_member_id: mock_member.id, board_id: mock_board.id)
    expect(cards).to be_empty
  end

  it 'Returns false for a card that is done' do
    in_progress = MemberCards.in_progress?(participants: [1], completed: true, list_name: 'Done', for_member_id: 1)
    expect(in_progress).to be false
  end

  it 'Returns false for a card that is for someone else' do
    in_progress = MemberCards.in_progress?(participants: [2], completed: true, list_name: 'Done', for_member_id: 1)
    expect(in_progress).to be false
  end

  it 'Returns false for a card that is in a list with a variation of the name done' do
    in_progress = MemberCards.in_progress?(participants: [1], completed: true, list_name: 'Nearly rDone',
                                           for_member_id: 1)
    expect(in_progress).to be false
  end

  it 'Returns true for a card that is not completed' do
    in_progress = MemberCards.in_progress?(participants: [1], completed: false, list_name: 'In progress',
                                           for_member_id: 1)
    expect(in_progress).to be true
  end

end