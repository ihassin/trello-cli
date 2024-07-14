# frozen_string_literal: true

class MemberCards
  def self.get_cards(trello_board:, for_member_id:, board_id:)
    trello_board.find(board_id).cards.select do |card|
      in_progress?(participants: card.member_ids,
                   completed: card.due_complete,
                   list_name: card.list.name,
                   for_member_id: for_member_id)
    end
  end

  def self.in_progress?(participants:, completed:, list_name:, for_member_id:)
    participants.include?(for_member_id) &&
      !completed &&
      !list_name.downcase.include?('done')
  end
end
