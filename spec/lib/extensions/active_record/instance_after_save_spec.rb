require 'rails_helper'

describe 'InstanceAfterSave' do
  let(:any_model) { build(:church) }

  describe User, '#after_save' do
    it 'runs the callback :run_instance_after_save' do
      rails_internal_list_of_callbacks = subject._save_callbacks.bypass.chain.map(&:filter)
      expect(rails_internal_list_of_callbacks).to include :run_instance_after_save
    end
  end

  context "with an #after_save instance method" do
    subject do
      model = any_model
      def model.after_save; end
      return model
    end

    it "runs #after_save on save" do
      expect(subject).to receive( :after_save ).once
      subject.save!
    end
  end

  context "with NO #after_save instance method" do
    subject { any_model }

    it "skips #after_save on save" do
      # should_receive gives a false positive
      expect(lambda { subject.save! }).to_not raise_error
      expect(lambda { subject.after_save }).to raise_error NoMethodError
    end
  end
end
