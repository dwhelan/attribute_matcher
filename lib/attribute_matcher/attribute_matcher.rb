RSpec::Matchers.define(:have_attribute) do
  match do
    exists? && visibility_match?(:reader) && visibility_match?(:writer) && all_values_match?
  end

  chain(:with_reader) { |visibility| self.reader_visibility = visibility }
  chain(:with_writer) { |visibility| self.writer_visibility = visibility }

  chain_value('with_value') { attribute_value }
  chain_value('of_type')    { attribute_value.class }

  chain_value('read_write') {  reader_ok? &&  writer_ok? }
  chain_value('read_only')  {  reader_ok? && !writer_ok? }
  chain_value('write_only') { !reader_ok? &&  writer_ok? }

  private

  attr_accessor :reader_visibility, :writer_visibility

  def attribute_value
    actual.send(expected)
  end

  def exists?
    reader || writer
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

    return true if method.nil? || expected_visibility.nil?

    ensure_valid_visibility(expected_visibility)
    expected_visibility == visibility(method)
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
end
