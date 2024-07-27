require 'colorize'

class Display
  def self.display_cards(card_list:, board_name:)
    return unless card_list

    puts "Tasks for #{board_name.yellow} are:\nDue Date\tPriority\tCard\t\t\t\tStatus\tCard".bold

    card_list.each do |card|
      due = card[3]&.strftime('%m/%d/%Y') || 'No date   '
      priority = card[2] == 'Highest' ? card[2].red : card[2]

      puts "#{due.red}\t#{priority}\t\t#{card[0].blue}\t#{card[4]}\t#{card[1].green}"
    end
    puts
  end
end
