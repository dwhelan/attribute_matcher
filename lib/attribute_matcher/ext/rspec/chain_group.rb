# An RSpec extension for mutually exclusive chained methods
module RSpec
  module Matchers
    module DSL
      class Matcher
        class << self
          def chain_group(group_name, *method_names)
            create_match_method(group_name, *method_names)
            create_description_method(group_name, method_names)
            chain_methods(method_names)
          end

          private

          def create_match_method(group_name, *method_names)
            define_method :"#{group_name}_match?" do
              active_method_name = method_names.find { |method_name| instance_variable_get("@#{method_name}") }
              active_method_name ? send("#{active_method_name}_match?") : true
            end
          end

          def create_description_method(group_name, method_names)
            define_method :"#{group_name}_description" do
              method_names.find { |method_name| instance_variable_get("@#{method_name}") }.to_s.gsub(%r{[_/]}, ' ')
            end
          end

          def chain_methods(method_names)
            method_names.each do |method_name|
              chain(method_name) { instance_variable_set("@#{method_name}", true) }
            end
          end
        end
      end
    end
  end
end
