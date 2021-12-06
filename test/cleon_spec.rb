# frozen_string_literal: true

require_relative "spec_helper"

describe Cleon do
  it 'must have version number' do
    _(::Cleon::VERSION).wont_be_nil
  end
end
