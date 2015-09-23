require 'spec_helper'

class Person
  attr_accessor :name
  attr_reader   :age
  attr_writer   :status

  def initialize
    self.name = 'Joe'
  end

  protected

  attr_accessor :address

  private

  attr_accessor :ssn
end

describe Person do
  it { is_expected.to have_attribute(:name)   }
  it { is_expected.to have_attribute(:age)    }
  it { is_expected.to have_attribute(:status) }

  describe 'accessors' do
    it { is_expected.to have_attribute(:name).read_write   }
    it { is_expected.to have_attribute(:age).read_only     }
    it { is_expected.to have_attribute(:status).write_only }
  end

  describe 'visibility' do
    it { is_expected.to have_attribute(:address).with_reader(:protected) }
    it { is_expected.to have_attribute(:address).with_writer(:protected) }
    it { is_expected.to have_attribute(:ssn).with_reader(:private)       }
    it { is_expected.to have_attribute(:ssn).with_writer(:private)       }
  end

  describe 'values' do
    it { is_expected.to have_attribute(:name).with_value('Joe') }
    it { is_expected.to have_attribute(:age).with_value(nil)    }
  end
end
