# frozen_string_literal: true

module SafeCracker
  class Solver
    attr_accessor :n, :restricted_combinations, :target_state, :initial_state

    # @param initial_state [Array<Integer>] Starting combination of the safe
    # @param target_state [Array<Integer>] Target combination to reach
    # @param restricted_combinations [Array<Array<Integer>>] Array of forbidden combinations
    # @raise [ValidationError] if any input parameters are invalid
    def initialize(initial_state, target_state, restricted_combinations)
      @initial_state = initial_state
      @target_state = target_state
      @restricted_combinations = restricted_combinations
      @n = initial_state.length
    end

    # Finds the shortest path from initial to target state
    # @return [Array<Array<Integer>>] Array of states from initial to target, or nil if no solution
    def solve
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
      states = []

      n.times do |i|
        up_value = (state[i] + 1) % 10
        down_value = (state[i] - 1) % 10
        down_value = 9 if state[i] == 0

        new_state_up = state.dup
        new_state_up[i] = up_value
        states << new_state_up

        new_state_down = state.dup
        new_state_down[i] = down_value
        states << new_state_down
      end

      states
    end

    def restricted?(state)
      restricted_combinations.any? { |combo| combo == state }
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
