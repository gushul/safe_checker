# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SafeCracker::Interface, :last do
  describe '.run' do
    it 'successfully processes user input' do
      input = <<~INPUT
        3
        0 0 0
        1 1 1
        2
        0 0 1
        1 0 0
      INPUT

      $stdin = StringIO.new(input)

      expect { described_class.run }.to output(/Solution finded:/).to_stdout
    ensure
      $stdin = STDIN
    end
  end
end
