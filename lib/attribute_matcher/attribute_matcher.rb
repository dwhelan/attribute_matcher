module RSpec
  module Matchers
    module DSL
      class Matcher
        class << self
          def chain_value(value, &actual_definition)
            attr_accessor "expected_#{value}", :"expected_#{value}_set"

            chain(value) do |expected_value|
              send(:"expected_#{value}=",     expected_value)
              send(:"expected_#{value}_set=", true)
            end

            define_method "#{value}_match?" do
              send(:"expected_#{value}_set").nil? || send(:"expected_#{value}").eql?(instance_eval(&actual_definition))
            end

            # TBD
            # if chained_values.nil?
            #   self.chained_values = ["#{value}_match?"]
            #
            #   define_method(:matches?) do |foo|
            #     super() && chained_values.map{|m| send(m)}.all?
            #   end
            # else
            #   chained_values << "#{value}_match?"
            # end
          end

          private

          attr_accessor :chained_values
        end
      end
    end
  end
end

RSpec::Matchers.define(:have_attribute) do
  match do
    exists? && access_match? && visibility_match?(:reader) && visibility_match?(:writer) && with_value_match? && of_type_match?
  end

  chain_group :access, :read_only, :write_only, :read_write

  chain(:with_reader) { |visibility| self.reader_visibility = ensure_valid_visibility(visibility) }
  chain(:with_writer) { |visibility| self.writer_visibility = ensure_valid_visibility(visibility) }
  # chain(:with_value)  { |value|      self.value             = value; self.value_set = true }
  # chain(:of_type)     { |type|       self.type              = type;  self.type_set  = true }

  chain_value('with_value') { attribute_value }
  chain_value('of_type')    { attribute_value.class }

  private

  attr_accessor :reader_visibility, :writer_visibility # , :value, :value_set, :type, :type_set

  def attribute_value
    actual.send(expected)
  end

  def exists?
    reader || writer
  end

  def read_only_match?
    reader_ok? && writer.nil?
  end

  def write_only_match?
    writer_ok? && reader.nil?
  end

  def read_write_match?
    reader_ok? && writer_ok?
  end

  def reader_ok?
    reader && reader.arity.eql?(0)
  end

  def writer_ok?
    writer && writer.arity.eql?(1)
  end

  def reader
    method(expected)
  end

  def writer
    method("#{expected}=")
  end

  def method(name)
    actual.method(name)
  rescue NameError
    nil
  end

  failure_messages do
    [
      arity_failure_message(reader, 0),
      arity_failure_message(writer, 1),
    ]
  end

  def arity_failure_message(method, expected_arity)
    format('%s() takes %d argument%s instead of %d', method.name, method.arity, method.arity == 1 ? '' : 's', expected_arity) if method && method.arity != expected_arity
  end

  def visibility_match?(accessor)
    method = accessor == :reader ? reader : writer
    expected_visibility = instance_variable_get(:"@#{accessor}_visibility")

    method.nil? || expected_visibility.nil? || expected_visibility == visibility(method)
  end

  def visibility(method)
    klass = method.receiver.class

    case
    when klass.private_method_defined?(method.name)
      :private
    when klass.protected_method_defined?(method.name)
      :protected
    else
      :public
    end
  end

  VALID_VISIBILITIES ||= [:private, :protected, :public]

  def ensure_valid_visibility(visibility)
    fail format('%s is an invalid visibility; should be one of %s', visibility, VALID_VISIBILITIES.join(', ')) unless VALID_VISIBILITIES.include?(visibility)
    visibility
  end

  # def value_match?
  #   value_set.nil? || actual.send(expected).eql?(value)
  # end
  #
  # def type_match?
  #   type_set.nil? || actual.send(expected).class.eql?(type)
  # end
end
