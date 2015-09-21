# An RSpec extension for building failure messages
module RSpec
  module Matchers
    module DSL
      class Matcher
        class << self
          def failure_messages(&block)
            define_method :failure_message do
              failures = instance_eval(&block).compact.join(' and ')
              [super(), failures].join(' but ')
            end
          end
        end
      end
    end
  end
end
