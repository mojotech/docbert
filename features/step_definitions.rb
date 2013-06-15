Given(/^I am a (?:business analyst|software developer|tester)$/) do; end

When(/^I write a feature, docbert\-style$/) do; end

When(/^I include some random multi\-line text:$/) do |string| end

Then(/^my feature writing skill level automatically surpasses (\d+)$/) do |level|
end

Given(/^I am on the signup page$/) do; end

Then(/^I should be signed up$/) do; end

When(/^I run "(.*?)"$/) do |command|
  unless File.directory?("features")
    raise "This scenario must be run from the project root"
  end

  system "ruby -Ilib bin/#{command}"
end

When(/^I fill in the signup form with the following values:$/) do |table| end

When(/^I submit the signup form$/) do; end

When(/^I am on the sign in page$/) do; end

When(/^I submit the sign in form as business analyst$/) do; end

Then(/^I should be signed in$/) do; end

Then(/^it should generate the feature "(.*?)"$/) do |file|
  expect(File.exist?(file)).to be_true
end

Then(/^"(.*?)" should contain the following scenarios:$/) do |file, table|
  table.diff! scenarios(/Scenario:/, file).map { |s| [s] }
end

Then(/^"(.*?)" should contain the following scenario outlines:$/) do |file, table|
  table.diff! scenarios(/Scenario Outline:/, file).map { |s| [s] }
end

def scenarios(regexp, file)
  IO.
    read(file).
    split(/\n/).
    grep(regexp).
    map { |s| s.gsub(regexp, '').strip }
end
