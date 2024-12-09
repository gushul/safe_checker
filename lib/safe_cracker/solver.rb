# frozen_string_literal: true

module SafeCracker
  class Solver
    attr_accessor :handles_count, :restricted_combinations, :target_state, :initial_state

    # @param initial_state [Array<Integer>] Starting combination of the safe
    # @param target_state [Array<Integer>] Target combination to reach
    # @param restricted_combinations [Array<Array<Integer>>] Array of forbidden combinations
    # @raise [ValidationError] if any input parameters are invalid
    def initialize(initial_state, target_state, restricted_combinations)
      @initial_state = initial_state
      @target_state = target_state
      @restricted_combinations = restricted_combinations
      @handles_count = initial_state.length
    end

    # Finds the shortest path from initial to target state
    # @return [Array<Array<Integer>>] Array of states from initial to target, or nil if no solution
    def call # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      return nil if restricted?(initial_state) || restricted?(target_state)

      visited = { initial_state => nil }
      queue = [initial_state]

      until queue.empty?
        current_state = queue.shift

        return build_path(visited, current_state) if current_state == target_state

        next_states(current_state).each do |next_state|
          next if visited.key?(next_state) || restricted?(next_state)

          visited[next_state] = current_state
          queue.push(next_state)
        end
      end

      nil
    end

    private

    def next_states(state)
      (0...handles_count).flat_map do |i|
        [
          state.dup.tap { |s| s[i] = (s[i] + 1) % 10 },
          state.dup.tap { |s| s[i] = ((s[i] - 1) % 10) + (10 % 10) }
        ]
      end
    end

    def restricted?(state)
      restricted_combinations.any?(state)
    end

    def build_path(visited, current_state)
      path = []
      while current_state
        path.unshift(current_state)
        current_state = visited[current_state]
      end
      path
    end
  end
end
