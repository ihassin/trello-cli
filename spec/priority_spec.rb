# frozen_string_literal: true

require_relative './spec_helper'
require_relative '../lib/priority'

describe Priority do
  it 'Finds a known priority' do
    tag = Priority.priorities[0][0]
    found = Priority.priority_map(tag: tag)
    expect(tag).to eq(found[0][0])
  end

  it 'Skips an unknown priority' do
    tag = 'Mickey mouse'
    found = Priority.priority_map(tag: tag)
    expect(found).to be_empty
  end

  it 'Skips a null priority' do
    tag = nil
    found = Priority.priority_map(tag: tag)
    expect(found).to be_empty
  end
end
