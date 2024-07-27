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

member_name = ARGV[0] || ENV['TRELLO_MEMBER']
member = Member.new(trello_member: Trello::Member)
wanted_member = member.find_member(member_name: member_name)
return if wanted_member.nil?

puts "Drumroll for #{member_name}..."

boards = Board.get_boards(trello_board: Trello::Board, board_list: ENV['TRELLO_BOARDS'])

boards.each do |board|
  card_list = member.get_assigned_tasks(trello_board: Trello::Board,
                                        # trello_member: Trello::Member,
                                        trello_custom_field: Trello::CustomField,
                                        for_board: board)
  card_list = card_list&.sort_by { |element| Priority.priority_map(tag: element[2])[0][1] }

  Display.display_cards(card_list: card_list, board_name: board.name)
end
