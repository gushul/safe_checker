module SafeCracker
  class ValidationError < StandardError; end

  class Validator
    class << self
      def validate_n(n)
        raise ValidationError, 'N should be a number from 1 to 6' unless (1..6).include?(n)

        true
      end

      def validate_state(state, n)
        raise ValidationError, "The number of digits should be equal to #{n}" if state.length != n

        unless state.all? { |digit| (0..9).include?(digit) }
          raise ValidationError, 'All digits should be from 0 to 9'
        end

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

      def validate_all_states(initial_state, target_state, restricted_combinations, n)
        validate_state(initial_state, n)
        validate_state(target_state, n)
        restricted_combinations.each { |combo| validate_state(combo, n) }
        validate_unique_combinations(restricted_combinations)
        true
      end
    end
  end
end
