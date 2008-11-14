Then /^I should see a full list of options for 'test_app'$/ do
  actual_output = File.read(File.join(@tmp_root, "executable.out"))
  expected_output = %w[--extra --help -h -x].join("\n")
  expected_output.should == actual_output
end

Then /^I should see a partial list of options for 'test_app' starting with '--'$/ do
  actual_output = File.read(File.join(@tmp_root, "executable.out"))
  expected_output = %w[--extra --help].join("\n")
  expected_output.should == actual_output
end