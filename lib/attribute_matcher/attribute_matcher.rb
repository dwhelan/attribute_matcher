RSpec::Matchers.define(:have_attribute) do
  match do
    exists? && access_match? && visibility_match?(:reader) && visibility_match?(:writer) && value_match?
  end

  chain_group :access, :read_only, :write_only, :read_write

  chain(:with_reader) { |visibility| @reader_visibility = ensure_valid_visibility(visibility) }
  chain(:with_writer) { |visibility| @writer_visibility = ensure_valid_visibility(visibility) }
  chain(:with_value)  { |value|      @value             = value; @value_set = true }

  private

  attr_reader :value, :value_set

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

  def value_match?
    value_set.nil? || actual.send(expected).eql?(value)
  end
end
