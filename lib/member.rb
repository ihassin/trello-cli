# frozen_string_literal: true
require_relative './display'
require_relative './priority'

class Member
  def initialize(trello_member:)
    @trello_member = trello_member
  end

  def find_member(member_name:)
    @member_name = member_name
    @member = @trello_member.find(@member_name)
  rescue StandardError
    nil
  end

  def get_assigned_tasks(trello_board:, trello_custom_field:, for_board:)
    cards = get_cards(trello_board: trello_board, for_member_id: @member.id, board_id: for_board.id)
    return if cards.nil? || cards.empty?

    priority_field_id = Priority.get_priority_field_id_for_board(board: trello_board.find(for_board.id))
    create_card_list(trello_custom_field, cards: cards, priority_field_id: priority_field_id)
  end

  def create_card_list(trello_custom_field, cards:, priority_field_id:)
    priority_options = trello_custom_field.find(priority_field_id).checkbox_options

    cards.map do |card|
      priority_value = set_priority(card, priority_field_id, priority_options)
      [card.short_url, card.name, priority_value, card.due, card.list.name]
    end
  end

  def get_cards(trello_board:, for_member_id:, board_id:)
    board = trello_board.find(board_id)
    board.cards.select do |card|
      card.member_ids.include?(for_member_id) && in_progress?(completed: card.due_complete, list_name: card.list.name)
    end
  end

  def in_progress?(completed:, list_name:)
    !completed && !list_name.downcase.include?('done')
  end

  private

  def set_priority(card, priority_field_id, priority_options)
    item = card.custom_field_items.find { |item| item.custom_field_id == priority_field_id }
    item ? Priority.get_priority(item, priority_options) : Priority::NO_PRIORITY
  end

end
