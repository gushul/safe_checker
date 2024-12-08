# frozen_string_literal: true

module SafeCracker
  class Interface
    class << self
      def run
        n = read_n
        initial_state = read_state(n, 'beginning state')
        target_state = read_state(n, 'target state')
        restricted_combinations = read_restricted_combinations(n)

        solver = Solver.new(initial_state, target_state, restricted_combinations)
        solution = solver.solve

        if solution
          puts "\nSolution finded:"
          solution.each { |state| puts state.inspect }
        else
          puts "\nSolution not exists!"
        end
      rescue ValidationError => e
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

      def read_n
        loop do
          print 'Enter N (number of dials, 1-6): '
          input = STDIN.gets.to_i
          Validator.validate_n(input)
          return input
        rescue ValidationError => e
          puts e.message
        end
      end

      def read_state(n, description)
        loop do
          print "Enter #{description} (#{n} digits separated by space): "
          input = STDIN.gets.split.map(&:to_i)
          Validator.validate_state(input, n)
          return input
        rescue ValidationError => e
          puts e.message
        end
      end

      def read_restricted_combinations(n)
        loop do
          print 'Enter the number of restricted combinations: '
          count = STDIN.gets.to_i
          Validator.validate_combinations_count(count)

          combinations = []
          count.times do |i|
            loop do
              print "Enter restricted combination #{i + 1} (#{n} digits separated by space): "
              combination = STDIN.gets.split.map(&:to_i)
              Validator.validate_state(combination, n)
              combinations << combination
              break
            rescue ValidationError => e
              puts e.message
            end
          end

          Validator.validate_unique_combinations(combinations)
          return combinations
        rescue ValidationError => e
          puts e.message
          combinations = []
        end
      end
    end
  end
end
