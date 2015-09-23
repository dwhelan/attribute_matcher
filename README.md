[![Gem Version](https://badge.fury.io/rb/attribute_matcher.png)](http://badge.fury.io/rb/attribute_matcher)
[![Build Status](https://travis-ci.org/dwhelan/attribute_matcher.png?branch=master)](https://travis-ci.org/dwhelan/attribute_matcher)
[![Code Climate](https://codeclimate.com/github/dwhelan/attribute_matcher/badges/gpa.svg)](https://codeclimate.com/github/dwhelan/attribute_matcher)
[![Coverage Status](https://coveralls.io/repos/dwhelan/attribute_matcher/badge.svg?branch=master&service=github)](https://coveralls.io/github/dwhelan/attribute_matcher?branch=master)

# Attribute Matcher

An RSpec matcher for validating attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attribute_matcher'
```

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install attribute_matcher

## Usage

```ruby
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
```

## Contributing

1. Fork it ( https://github.com/dwhelan/attribute_matcher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
