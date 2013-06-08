Given(/^I am a business analyst$/) do; end

When(/^I write a feature, docbert\-style$/) do; end

Then(/^my feature writing skill level automatically surpasses (\d+)$/) do |level|
end

Given(/^I am on the signup page$/) do; end

When(/^I submit the signup form with valid data$/) do; end

Then(/^I should be signed up$/) do; end

When(/^I run "(.*?)"$/) do |command|
  unless File.directory?("features")
    raise "This scenario must be run from the project root"
  end

  system "ruby -Ilib bin/#{command}"
end

Then(/^it should generate the feature "(.*?)"$/) do |file|
  expect(File.exist?(file)).to be_true
end

Then(/^"(.*?)" should contain the following scenarios:$/) do |file, table|
  table.diff! scenarios(file).map { |s| [s] }
end

def scenarios(file)
  IO.
    read(file).
    split(/\n/).
    grep(/Scenario:/).
    map { |s| s.gsub(/Scenario:/, '').strip }
end
