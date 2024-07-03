#!/usr/bin/env ruby
require 'trello'
require 'colorize'

PRIORITY_FIELD_ID='6672dca4540038366de7e33d'.freeze

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_API_KEY']
  config.member_token = ENV['TRELLO_RUBY_TOKEN']
  config.http_client = 'faraday'
end

def priority_map(tag:)
  map = [
    ['Highest', 1],
    ['High', 2],
    ['Medium', 3],
    ['Low', 4],
    ['Lowest', 5],
    ['Unsure', 6],
    ['Missing', 7]]
  map.select { |f| f[0] == tag }
end

def get_cards(member_id:, board_id:)
  Trello::Board.find(board_id).cards.select { |card| card.member_ids.include?(member_id) && card.list.name.downcase != 'done'}
end

def assign_priority(cards:, priority_field_id:)
  return unless priority_field_id
  card_list = []
  priority_fields = Trello::CustomField.find(priority_field_id).checkbox_options

  cards.each do |card|
    priority_value = 'Not set'
    card.custom_field_items.each do |item|
      if item.custom_field_id == priority_field_id
        priority_field = priority_fields.select{ |p|p['id']==item.option_id }
        priority_value = priority_field[0]['value']['text']
      end
    end
    due = card.due.nil? ? '00/00/0000' : card.due.to_date.strftime('%m/%d/%Y')
    card_list << [card.short_url, card.name, priority_value, due]
  end
  return if card_list.empty?

  card_list.sort_by { |element| priority_map(tag: element[2])[0][1] }
end

def display_cards(card_list:, board_name:, member:)
  return unless card_list

  puts "#{member.full_name}, your tasks for #{board_name.yellow} are:"
  card_list.each do |card|
    print card[3].length.positive? ? "#{card[3].red}\t" : ''
    print case card[2]
          when 'Highest'
            card[2].red
          when 'Missing'
            ''
          else
            card[2]
          end

    print "\t\t#{card[0].blue}\t#{card[1].green}\n"
  end
  
end

def list_tasks(member:, board_name:, board_id:)
  return unless (cards = get_cards(member_id: member.id, board_id: board_id))
  return if cards.empty?

  board = Trello::Board.find(board_id)
  priority_field = board.custom_fields.select { |field| field.name.downcase == 'priority' }
  priority_field_id = if priority_field.length.positive?
                        priority_field[0].id
                      end
  card_list = assign_priority(cards: cards, priority_field_id: priority_field_id)
  display_cards(card_list: card_list, board_name: board_name, member: member)
end

def list_assigned_tasks(member_name:)
  all_boards = Trello::Board.all
  matching_boards = all_boards.select { |element| ENV['TRELLO_BOARDS'].include?(element.name) }

  member = begin
             Trello::Member.find(member_name)
           rescue
             nil
           end
  return if member.nil?

  matching_boards.each do |board|
    list_tasks(member: member, board_id: board.id, board_name: board.name)
  end
end

member_name = ARGV[0] || ENV['TRELLO_MEMBERS']
puts "Checking #{ENV['TRELLO_BOARDS']} for #{member_name}"
list_assigned_tasks(member_name: member_name)
