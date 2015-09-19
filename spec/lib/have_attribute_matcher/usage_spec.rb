require 'spec_helper'

class Person
  attr_accessor :name
  attr_reader   :age
  attr_writer   :status

  protected

  attr_accessor :address

  private

  attr_accessor :ssn
end

describe Person do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to have_attribute(:age) }
  it { is_expected.to have_attribute(:status) }

  it { is_expected.to have_attribute(:name).read_write }
  it { is_expected.to have_attribute(:age).read_only }
  it { is_expected.to have_attribute(:status).write_only }

  it { is_expected.to have_attribute(:address).with_reader(:protected) }
  it { is_expected.to have_attribute(:address).with_writer(:protected) }

  it { is_expected.to have_attribute(:ssn).with_reader(:private) }
  it { is_expected.to have_attribute(:ssn).with_writer(:private) }
end
