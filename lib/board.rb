# frozen_string_literal: true

class Board
  def self.get_boards(trello_board:, board_list:)
    trello_board.all.select { |element| board_list.include?(element.name) }
  end
end