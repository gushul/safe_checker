# frozen_string_literal: true

RSpec.describe SafeCracker::Interface do
  describe '.run' do
    it 'successfully processes user input' do
      input = [
        "3\n",          # N
        "0 0 0\n",      # initial_state
        "1 1 1\n",      # target_state
        "2\n",          # number of restricted combinations
        "0 0 1\n",      # first restricted combination
        "1 0 0\n"       # second restricted combination
      ].join

      puts 'join'
      # summilate user input
      allow($stdin).to receive(:gets).and_return(*input.split("\n").map { |l| "#{l}\n" })

      # check the output
      expect { described_class.run }.to output(include('Solution finded:')).to_stdout
    end
  end
end
