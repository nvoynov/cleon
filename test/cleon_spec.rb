# frozen_string_literal: true

require_relative "spec_helper"

describe Cleon do
  it 'must have version number' do
    _(::Cleon::VERSION).wont_be_nil
  end

  let(:temp) { 'temp' }
  let(:thing){ 'thing para1 para2' }

  describe 'helpers dry-run' do

    it 'must provide #clone_cleon' do
      SpecClone.(temp) { Cleon.clone_cleon }
    end

    it 'must provide #clone_service' do
      SpecGem.(temp) { Cleon.clone_service(thing) }
    end

    it 'must provide #clone_entity' do
      SpecGem.(temp) { Cleon.clone_entity(thing) }
    end
  end
end
