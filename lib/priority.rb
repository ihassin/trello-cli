# frozen_string_literal: true

class Priority
  NO_PRIORITY = 'Missing'

  def self.priority_map(tag:)
    priorities.select { |priority_name| priority_name[0] == tag }
  end

  def self.priorities
    [
      ['Highest', 1],
      ['High', 2],
      ['Medium', 3],
      ['Low', 4],
      ['Lowest', 5],
      ['Unsure', 6],
      ['Missing', 7],
      [NO_PRIORITY, 8]
    ]
  end

end
