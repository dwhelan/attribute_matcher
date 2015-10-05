require 'spec_helper'
require 'virtus'

class VirtusPerson
  include Virtus.model

  attribute :name
  attribute :age
  attribute :status

  attribute :ssn,     String, reader: :private,   writer: :private
  attribute :address, String, reader: :protected, writer: :protected

  def initialize
    self.name = 'Joe'
  end
end

describe VirtusPerson do
  it { is_expected.to have_attribute(:name)   }
  it { is_expected.to have_attribute(:age)    }
  it { is_expected.to have_attribute(:status) }

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
