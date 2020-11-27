require 'json'
require 'awspec'

expect_env = "testenv"

actual_key_id = attribute 'module_under_test-key_id', {}
actual_key_arn = attribute 'module_under_test-key_arn', {}
actual_key_alias = attribute 'module_under_test-key_alias', {}
testing_suffix_hex = attribute 'module_under_test-testing_suffix_hex', {}
actual_ddb_table_id = attribute 'module_under_test-encrypted_ddb_table_id', {}

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

  describe 'encryption config of DynamoDB table' do
    describe dynamodb_table(actual_ddb_table_id) do
      it { should exist }
      its(:sse_description){
        should have_attributes(
                   :status => 'ENABLED',
                   :sse_type => 'KMS',
                   :kms_master_key_arn => actual_key_arn,
                   # verify encrypted data is accessible by checking inaccessible_encryption_date_time
                   :inaccessible_encryption_date_time => nil
               )
      }
    end
  end

end

