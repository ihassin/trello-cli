#!/usr/bin/env ruby
# frozen_string_literal: true

require 'trello'
require 'colorize'
require_relative './lib/priority'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_API_KEY']
  config.member_token = ENV['TRELLO_RUBY_TOKEN']
  config.http_client = 'faraday'
end

def get_cards(for_member_id:, board_id:)
  Trello::Board.find(board_id).cards.select do |card|
    card.member_ids.include?(for_member_id) && !card.due_complete &&
      card.list.name.downcase != 'done' &&
      card.list.name.downcase != '🎉 done'
  end
end

def get_priority(item, priority_fields)
  priority_field = priority_fields.select { |p| p['id'] == item.option_id }
  priority_field[0]['value']['text']
end

def create_card_list(cards:, priority_field_id:)
  card_list = []

  priority_options = Trello::CustomField.find(priority_field_id).checkbox_options

  cards.each do |card|
    priority_value = Priority::NO_PRIORITY
    card.custom_field_items.each do |item|
      priority_value = get_priority(item, priority_options) if item.custom_field_id == priority_field_id
    end
    due = card.due.nil? ? 'No date   ' : card.due.to_date.strftime('%m/%d/%Y')
    card_list << [card.short_url, card.name, priority_value, due, card.list.name]
  end
  return if card_list.empty?

  card_list.sort_by { |element| Priority.priority_map(tag: element[2])[0][1] }
end

def display_cards(card_list:, board_name:)
  return unless card_list

  puts "Your tasks for #{board_name.yellow} are:"
  puts "Due Date\tPriority\tCard\t\t\t\tStatus\tCard".bold

  card_list.each do |card|
    # print card[3].length.positive? ? "#{card[3].red}\t" : ''
    print "#{card[3].red}\t"
    print case card[2]
          when 'Highest'
            "#{card[2].red}\t"
          else
            "#{card[2]}\t"
          end

    print "\t#{card[0].blue}\t#{card[4]}\t#{card[1].green}\n"
  end
end

def list_tasks(member:, board_name:, board_id:)
  return unless (cards = get_cards(for_member_id: member.id, board_id: board_id))
  return if cards.empty?

  board = Trello::Board.find(board_id)
  priority_field = board.custom_fields.select { |field| field.name.downcase == 'priority' }
  priority_field_id = (priority_field[0].id if priority_field.length.positive?)
  card_list = create_card_list(cards: cards, priority_field_id: priority_field_id)
  display_cards(card_list: card_list, board_name: board_name)
end

def find_member(member_name:)
  Trello::Member.find(member_name)
rescue StandardError
  nil
end

def list_assigned_tasks(member_name:)
  all_boards = Trello::Board.all
  matching_boards = all_boards.select { |element| ENV['TRELLO_BOARDS'].include?(element.name) }

  member = find_member(member_name: member_name)
  return if member.nil?

  matching_boards.each do |board|
    list_tasks(member: member, board_id: board.id, board_name: board.name)
  end
end

member_name = ARGV[0] || ENV['TRELLO_MEMBER']
puts "Drumroll for #{member_name}..."
list_assigned_tasks(member_name: member_name)
