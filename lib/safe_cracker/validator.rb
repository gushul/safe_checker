# frozen_string_literal: true

module SafeCracker
  class Validator
    class << self
      def validate_n(handles_count)
        unless (1..6).cover?(handles_count)
          raise ValidationError,
                'handles count should be a number from 1 to 6'
        end

        true
      end

      def validate_state(state, handles_count)
        if state.length != handles_count
          raise ValidationError,
                "The number of digits should be equal to #{handles_count}"
        end

        raise ValidationError, 'All digits should be from 0 to 9' unless state.all? { |digit| (0..9).cover?(digit) }

        true
      end

      def validate_combinations_count(count)
        unless count.positive?
          raise ValidationError, 'The number of restricted combinations should be a positive number'
        end

        true
      end

      def validate_unique_combinations(combinations)
        if combinations.uniq.length != combinations.length
          raise ValidationError, 'Restricted combinations should not be repeated'
        end

        true
      end

      def validate_all_states(initial_state, target_state, restricted_combinations, handles_count)
        validate_state(initial_state, handles_count)
        validate_state(target_state, handles_count)
        restricted_combinations.each { |combo| validate_state(combo, handles_count) }
        validate_unique_combinations(restricted_combinations)
        true
      end
    end
  end
end
