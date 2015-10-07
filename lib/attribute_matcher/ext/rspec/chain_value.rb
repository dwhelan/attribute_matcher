module RSpec
  module Matchers
    module DSL
      class Matcher
        class << self
          def chain_value(value, &actual_definition)
            attr_accessor :chained_values, :"expected_#{value}", :"expected_#{value}_set"

            create_chain_method(value)
            create_all_values_match_method
            create_value_match_method(value, actual_definition)
          end

          private

          def create_chain_method(value)
            chain(value) do |expected_value = true|
              self.chained_values ||= []
              chained_values << :"#{value}_match?"

              send(:"expected_#{value}=", expected_value)
              send(:"expected_#{value}_set=", true)
            end
          end

          def create_all_values_match_method
            return if instance_methods(false).include?(:values_match?)

            define_method(:all_values_match?) do
              chained_values.nil? || chained_values.map { |m| send(m) }.all?
            end
          end

          def create_value_match_method(value, actual_definition)
            define_method :"#{value}_match?" do
              send(:"expected_#{value}_set").nil? || send(:"expected_#{value}").eql?(instance_eval(&actual_definition))
            end
          end
        end
      end
    end
  end
end
