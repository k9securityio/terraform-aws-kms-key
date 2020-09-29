require 'json'
require 'awspec'

expect_env = "testenv"
expect_app = "testapp"
expect_owner = "platform"

actual_key_id = attribute 'module_under_test-key_id', {}
actual_key_alias = attribute 'module_under_test-key_alias', {}
testing_suffix_hex = attribute 'module_under_test-testing_suffix_hex', {}

expect_logical_name = "testkey-#{testing_suffix_hex}"

all_managed_key_aliases = [actual_key_alias]

# require 'pry'; binding.pry; #uncomment to jump into the debugger

control 'kms' do

  describe "common properties for managed KMS keys" do
    all_managed_key_aliases.each do |key_alias|
      describe kms(key_alias) do
        it { should exist }
        it { should be_enabled }

        its(:key_state) { should eq 'Enabled' }
        it { should have_key_policy('default') }
      end
    end
  end

  describe "minimal KMS key #{actual_key_alias}" do
    describe kms(actual_key_alias) do
      its(:key_id) { should eq actual_key_id }
      its(:description) { should eq "Key for #{expect_logical_name} in #{expect_env}" }
      its(:customer_master_key_spec) { should eq "SYMMETRIC_DEFAULT" }
      its(:key_usage) {should eq 'ENCRYPT_DECRYPT'}
    end
  end

end

