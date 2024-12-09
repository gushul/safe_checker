# frozen_string_literal: true

module SafeCracker
  class Interface
    class << self
      def run # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        handles_count = read_handles_count
        initial_state = read_state(handles_count, 'beginning state')
        target_state = read_state(handles_count, 'target state')
        restricted_combinations = read_restricted_combinations(handles_count)

        solver = Solver.new(initial_state, target_state, restricted_combinations)
        solution = solver.call

        if solution
          puts "\nSolution finded:"
          solution.each { |state| puts state.inspect }
        else
          puts "\nSolution not exists!"
        end
      rescue SafeCracker::ValidationError => e
        puts "\nValidation error: #{e.message}"
        retry
      rescue Interrupt
        puts "\nProgram interrupted by user"
        exit
      rescue StandardError => e
        puts "\nUnexpected error: #{e.message}"
        exit
      end

      private

      def read_handles_count
        loop do
          print 'Enter handles count (number of dials, 1-6): '
          input = $stdin.gets.to_i
          SafeCracker::Validator.validate_n(input)
          return input
        rescue ValidationError => e
          puts e.message
        end
      end

      def read_state(handles_count, description)
        loop do
          print "Enter #{description} (#{handles_count} digits separated by space): "
          input = $stdin.gets.split.map(&:to_i)
          Validator.validate_state(input, handles_count)
          return input
        rescue SafeCracker::ValidationError => e
          puts e.message
        end
      end

      def read_restricted_combinations(handles_count) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        loop do
          print 'Enter the number of restricted combinations: '
          count = $stdin.gets.to_i
          Validator.validate_combinations_count(count)

          combinations = []
          count.times do |i|
            loop do
              print "Enter restricted combination #{i + 1} (#{handles_count} digits separated by space): "
              combination = $stdin.gets.split.map(&:to_i)
              Validator.validate_state(combination, handles_count)
              combinations << combination
              break
            rescue SafeCracker::ValidationError => e
              puts e.message
            end
          end

          Validator.validate_unique_combinations(combinations)
          return combinations
        rescue SafeCracker::ValidationError => e
          puts e.message
          combinations = []
        end
      end
    end
  end
end
