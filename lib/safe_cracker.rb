# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module SafeCracker
  class Error < StandardError; end
  class ValidationError < StandardError; end
end
