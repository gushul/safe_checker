# frozen_string_literal: true

RSpec.describe SafeCracker::Solver do
  describe '#solve' do
    context 'with examples from task' do
      let(:initial_state) { [0, 0, 0] }
      let(:target_state) { [1, 1, 1] }
      let(:restricted_combinations) { [[0, 0, 1], [1, 0, 0]] }
      let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

      it 'find correct solution' do
        expect(solver.call).to eq([
                                    [0, 0, 0],
                                    [0, 1, 0],
                                    [1, 1, 0],
                                    [1, 1, 1]
                                  ])
      end
    end

    context 'when happy path' do
      let(:initial_state) { [0, 0] }
      let(:target_state) { [1, 1] }
      let(:restricted_combinations) { [[0, 1], [1, 0]] }
      let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

      it 'finds shortest valid solution avoiding restricted combinations' do
        expect(solver.call).to eq([
                                    [0, 0],
                                    [9, 0],
                                    [9, 1],
                                    [9, 2],
                                    [0, 2],
                                    [1, 2],
                                    [1, 1]
                                  ])
      end
    end

    context 'when solution is impossible' do
      context 'when target is surrounded by restricted combinations' do
        let(:initial_state) { [0, 0] }
        let(:target_state) { [1, 1] }
        let(:restricted_combinations) { [[0, 1], [1, 0], [2, 1], [1, 2]] }
        let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

        it 'returns nil' do
          expect(solver.call).to be_nil
        end
      end

      context 'when initial state is restricted' do
        let(:initial_state) { [0, 0] }
        let(:target_state) { [1, 1] }
        let(:restricted_combinations) { [[0, 0]] }
        let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

        it 'returns nil' do
          expect(solver.call).to be_nil
        end
      end

      context 'when target state is restricted' do
        let(:initial_state) { [0, 0] }
        let(:target_state) { [1, 1] }
        let(:restricted_combinations) { [[1, 1]] }
        let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

        it 'returns nil' do
          expect(solver.call).to be_nil
        end
      end
    end

    context 'with boundary cases' do
      context 'with single digit' do
        let(:initial_state) { [0] }
        let(:target_state) { [9] }
        let(:restricted_combinations) { [[5]] }
        let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

        it 'finds path avoiding restricted state' do
          solution = solver.call
          expect(solution).not_to be_nil
          expect(solution).not_to include([5])
          expect(solution.first).to eq([0])
          expect(solution.last).to eq([9])
        end
      end

      context 'when crossing through 9/0 boundary' do
        let(:initial_state) { [9, 9] }
        let(:target_state) { [0, 0] }
        let(:restricted_combinations) { [[9, 0], [0, 9]] }
        let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

        it 'finds correct path crossing boundary' do
          solution = solver.call
          expect(solution).not_to be_nil
          expect(solution).not_to include([9, 0])
          expect(solution).not_to include([0, 9])
        end
      end
    end

    describe 'path validity' do
      let(:initial_state) { [0, 0] }
      let(:target_state) { [1, 1] }
      let(:restricted_combinations) { [[0, 1]] }
      let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

      it 'changes only one digit at a time' do
        solution = solver.call
        return if solution.nil?

        solution.each_cons(2) do |current, next_state|
          differences = current.zip(next_state).count { |a, b| a != b }
          expect(differences).to eq(1),
                                 "Invalid transition from #{current} to #{next_state}: multiple digits changed"
        end
      end

      it 'changes digits only by +1 or -1' do
        solution = solver.call
        return if solution.nil?

        solution.each_cons(2) do |current, next_state|
          current.zip(next_state).each do |a, b|
            next if a == b

            difference = (b - a) % 10
            expect([1, 9]).to include(difference),
                              "Invalid transition from #{a} to #{b}: changed by more than 1"
          end
        end
      end

      it 'avoids restricted combinations' do
        solution = solver.call
        return if solution.nil?

        restricted_combinations.each do |restricted|
          expect(solution).not_to include(restricted),
                                  "Solution contains restricted combination #{restricted}"
        end
      end
    end

    context 'with maximum number of dials (N=6)' do
      let(:initial_state) { [0, 0, 0, 0, 0, 0] }
      let(:target_state) { [1, 1, 1, 1, 1, 1] }
      let(:restricted_combinations) { [[0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0]] }
      let(:solver) { described_class.new(initial_state, target_state, restricted_combinations) }

      it 'finds solution for maximum N' do
        solution = solver.call
        expect(solution).not_to be_nil
        expect(solution.first).to eq(initial_state)
        expect(solution.last).to eq(target_state)
      end
    end
  end
end
