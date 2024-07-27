# frozen_string_literal: true

class Board
  def initialize(trello_board:)
    @trello_board = trello_board
  end

  def get_boards(board_list:)
    @trello_board.all.select { |element| board_list.include?(element.name) }
  end

  def get_tasks_for_member_by_board(board:, member:)
    card_list = member.get_assigned_tasks(trello_board: Trello::Board,
                                          trello_custom_field: Trello::CustomField,
                                          for_board: board)

    card_list&.sort_by { |element| Priority.priority_map(tag: element[2])[0][1] }

  end
end
