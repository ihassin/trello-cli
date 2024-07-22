# frozen_string_literal: true

class MemberCards
  def self.get_cards(trello_board:, for_member_id:, board_id:)
    trello_board.find(board_id).cards.select do |card|
      card.member_ids.include?(for_member_id) && in_progress?(completed: card.due_complete, list_name: card.list.name)
    end
  end

  def self.in_progress?(completed:, list_name:)
    !completed && !list_name.downcase.include?('done')
  end
end
