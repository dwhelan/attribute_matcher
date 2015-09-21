require 'spec_helper'

describe 'Version' do
  before { load './lib/attribute_matcher/version.rb' }

  it('should be present') { expect(HaveAttributeMatcher::VERSION).to_not be_empty }
end
