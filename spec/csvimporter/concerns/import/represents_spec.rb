# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::Represents do
  let(:klass) do
    Class.new(BasicImportModel) do
      def self.name
        "RepresentsTestModel"
      end
    end
  end
  let(:instance) { klass.new }

  describe "instance" do
    describe "#representation_objects" do
      subject { instance.representation_objects }

      before do
        klass.send(:represents_one, :test_model) { "test" }
        klass.send(:represents_many, :test_models) { %w[test test] }
      end

      before { klass.send(:represents_one, :test_model) { "test" } }

      it "returns a mapping of presentation_name => representation" do
        expect(subject.keys).to eql %i[test_model test_models]
        expect(subject.values.map(&:name)).to eql %i[test_model test_models]
        expect(subject.values.map(&:lambda_value)).to eql ["test", %w[test test]]
      end
    end

    describe "#representation_value" do
      subject { instance.representation_value(:test_model) }

      before { klass.send(:represents_one, :test_model) { return "test" } }

      it "returns the value of the representation" do
        expect(subject).to eql "test"
      end

      context "with invalid representation" do
        subject { instance.representation_value(:some_invalid_name) }

        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      context "with representation having a representation as a dependency" do
        subject { instance.representation_value(:test_models) }

        before do
          klass.send(:represents_one, :test_model) { "test" }
          klass.send(:represents_many, :test_models, dependencies: :test_model) { return [test_model] * 2 }
        end

        it "works" do
          expect(subject).to eql %w[test test]
        end
      end
    end

    describe "#representations" do
      subject { instance.representations }

      before { klass.send(:represents_one, :test_model) { "test" } }

      it "includes representations" do
        expect(subject).to eql(test_model: "test")
      end
    end

    describe "#all_attributes" do
      subject { instance.all_attributes }

      let(:instance) { klass.new(%w[a b]) }

      before { klass.send(:represents_one, :test_model, dependencies: %i[string1 string2]) { "test" } }

      it "includes representations" do
        expect(subject).to eql(string1: "a", string2: "b", test_model: "test")
        expect(subject).not_to eql instance.attributes
      end
    end

    describe "#valid?" do
      subject { instance.valid? }

      it "calls #filter_errors and returns valid" do
        expect(instance).to receive(:filter_errors)
        expect(subject).to be true
      end

      context "when invalid" do
        before { klass.send(:validates, :string1, presence: true) }

        it "returns invalid and has errors" do
          expect(subject).to be false
          expect(instance.errors.full_messages).to eql ["String1 can't be blank"]
        end
      end
    end

    describe "#filter_errors" do
      subject { instance.send :filter_errors }

      before do
        klass.send(:represents_one, :test_model, dependencies: %i[string1]) { "test" }
        instance.errors.add(:test_model)
        instance.errors.add(:string2)
      end

      it "errors doesn't do anything with unrelated errors" do
        subject
        expect(instance.errors.keys).to eql %i[test_model string2]
      end

      context "with an dependency errors" do
        before { instance.errors.add(:string1) }

        it "removes the representation error" do
          subject
          expect(instance.errors.keys).to eql %i[string2 string1]
        end
      end
    end
  end

  describe "class" do
    describe "::represents_one" do
      subject { klass.send(:represents_one, :test_model) { "test" } }

      it "adds the named method to the class" do
        subject
        expect(instance.test_model).to eql "test"
      end

      it "calls the helper methods" do
        expect(klass).to receive(:define_representation_method).with(:test_model).and_yield
        subject
      end
    end

    describe "::represents_many" do
      subject { klass.send(:represents_many, :test_models) { %w[test test] } }

      it "adds the named method to the class" do
        subject
        expect(instance.test_models).to eql %w[test test]
      end

      it "calls the helper methods" do
        expect(klass).to receive(:define_representation_method).with(:test_models, { empty_value: [] }).and_yield
        subject
      end
    end

    describe "::define_representation_method" do
      subject { klass.send(:define_representation_method, :test_model, options) { "test" } }

      let(:options) { {} }

      it "creates the memoized representation_method method" do
        subject
        expect(instance).to receive(:representation_value).with(:test_model).exactly(3).times.and_call_original
        expect(instance.test_model).to eql "test"
        expect(instance.test_model.object_id).to eql instance.test_model.object_id
      end

      it "works with subclassing and overriding" do
        subject
        expect(Class.new(klass).new.test_model).to eql "test"

        instance = Class.new(klass) do
          def test_model
            "overwritten"
          end
        end.new
        expect(instance.test_model).to eql "overwritten"
        expect(instance.__test_model).to eql "test"
      end
    end
  end
end
