Given /^I have (\d+) matches$/ do |num_matches|
  FactoryGirl.create_list(:match, 2)
end

Then /^I should see (\d+) matches$/ do |num_matches|
    pending # express the regexp above with the code you wish you had
end

