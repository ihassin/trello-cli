require 'colorize'

class Display
  def self.display_cards(card_list:, board_name:)
    return unless card_list

    puts "Your tasks for #{board_name.yellow} are:"
    puts "Due Date\tPriority\tCard\t\t\t\tStatus\tCard".bold

    card_list.each do |card|
      due = card[3].nil? ? 'No date   ' : card[3].strftime('%m/%d/%Y')
      print "#{due.red}\t"
      print case card[2]
            when 'Highest'
              "#{card[2].red}\t"
            else
              "#{card[2]}\t"
            end

      print "\t#{card[0].blue}\t#{card[4]}\t#{card[1].green}\n"
    end
  end
end