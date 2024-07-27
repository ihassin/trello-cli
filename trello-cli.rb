#!/usr/bin/env ruby
# frozen_string_literal: true

require 'trello'
require_relative './lib/member'
require_relative './lib/board'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_API_KEY']
  config.member_token = ENV['TRELLO_RUBY_TOKEN']
  config.http_client = 'faraday'
end

member = Member.new(trello_member: Trello::Member)
member_name = ARGV[0] || ENV['TRELLO_MEMBER']
wanted_member = member.find_member(member_name: member_name)
return if wanted_member.nil?

board = Board.new(trello_board: Trello::Board)
boards = board.get_boards(board_list: ENV['TRELLO_BOARDS'])

boards.each do |their_board|
  card_list = board.get_cards_for_member_by_board(board: their_board, member: member)
  Display.display_cards(card_list: card_list, board_name: their_board.name)
end
