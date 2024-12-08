require 'spec_helper'

RSpec.describe SafeCracker::Validator do
  describe '.validate_n' do
    it 'accepts numbers from 1 to 6' do
      (1..6).each do |n|
        expect(described_class.validate_n(n)).to be true
      end
    end

    it 'rejects numbers outside the range' do
      [0, 7, -1].each do |n|
        expect do
          described_class.validate_n(n)
        end.to raise_error(SafeCracker::ValidationError)
      end
    end
  end

  describe '.validate_state' do
    it 'accepts the correct state' do
      expect(described_class.validate_state([0, 1, 2], 3)).to be true
    end

    it 'rejects the wrong length' do
      expect do
        described_class.validate_state([0, 1], 3)
      end.to raise_error(SafeCracker::ValidationError)
    end

    it 'rejects digits outside the range' do
      expect do
        described_class.validate_state([0, 10, 2], 3)
      end.to raise_error(SafeCracker::ValidationError)
    end
  end

  describe '.validate_unique_combinations' do
    it 'accepts unique combinations' do
      combinations = [[0, 0, 1], [1, 0, 0]]
      expect(described_class.validate_unique_combinations(combinations)).to be true
    end

    it 'rejects repeated combinations' do
      combinations = [[0, 0, 1], [0, 0, 1]]
      expect do
        described_class.validate_unique_combinations(combinations)
      end.to raise_error(SafeCracker::ValidationError)
    end
  end
end
