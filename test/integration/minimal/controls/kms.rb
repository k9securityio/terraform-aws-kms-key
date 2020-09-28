require 'json'
require 'awspec'

expect_env = "testenv"
expect_app = "testapp"
expect_owner = "platform"

actual_key_alias = attribute 'module_under_test-key_alias', {}

all_managed_key_aliases = [actual_key_alias]

# require 'pry'; binding.pry; #uncomment to jump into the debugger

control 'kms' do

  describe "common properties for managed KMS keys" do
    all_managed_key_aliases.each do | key_alias |
      describe kms(key_alias) do
        it { should exist }
        it { should be_enabled }


        #it { should have_tag('Owner').value(expect_owner) }
        #it { should have_tag('Name').value(key_alias) }
        #it { should have_tag('Environment').value(expect_env) }
        #it { should have_tag('Application').value(expect_app) }
        #it { should have_tag('ManagedBy').value('Terraform') }
      end
    end
  end

  #describe "KMS key #{actual_key_alias}" do
  #  subject { kms(actual_key_alias) }
  #
  #  its('policy.policy.read') {
  #    should match /AllowRestrictedAdministerResource/
  #    should match /AllowRestrictedReadData/
  #    should match /AllowRestrictedWriteData/
  #    should match /AllowRestrictedDeleteData/
  #    should match /AllowRestrictedCustomActions/
  #    should match /DenyEveryoneElse/
  #  }
  #
  #  #it { should have_tag('Role').value('blob store') }
  #  #it { should have_tag('BusinessUnit').value('Enterprise Solutions') }
  #  #it { should have_tag('BusinessProcess').value('Product') }
  #  #it { should have_tag('CostCenter').value('C1234') }
  #  #it { should have_tag('ComplianceScheme').value('HIPAA') }
  #  #
  #  #it { should have_tag('Confidentiality').value('Internal') }
  #  #it { should have_tag('Integrity').value("0.9999") }
  #  #it { should have_tag('Availability').value("0.999") }
  #  #
  #  #it { should have_tag('CustomKey').value('CustomValue') }
  #end

end

