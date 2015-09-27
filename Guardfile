guard :rspec , cmd: 'bundle exec rspec' do
  watch(%r{^lib/(.+)\.rb$})        { 'spec' }
  watch(%r{^spec/spec_helper.rb$}) { 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
end
