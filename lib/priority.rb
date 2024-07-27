# frozen_string_literal: true

class Priority
  NO_PRIORITY = 'Missing'

  def self.get_priority_field_id_for_board(board:)
    priority_field = board.custom_fields.find { |field| field.name.casecmp('priority').zero? }
    priority_field&.id
  end
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

  def self.get_priority(item, priority_fields)
    priority_field = priority_fields.find { |p| p['id'] == item.option_id }
    priority_field&.dig('value', 'text')
  end
end
