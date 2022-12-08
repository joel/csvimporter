# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::Representation do
  describe "instance" do
    let(:instance) { described_class.new(:string1, options, row_model) }
    let(:row_model) { BasicImportModel.new }
    let(:options) { {} }

    let(:block) { proc { "string1" } }

    before { described_class.define_lambda_method(row_model.class, :string1, &block) }

    describe "#value" do
      subject { instance.value }

      before do
        allow(instance).to receive(:dependencies_value).and_return("dep")
        allow(instance).to receive(:memoize?).and_return(memoize)
      end

      context "with memoization" do
        let(:memoize) { true }

        it "returns the #memoized_value" do
          expect(subject).to eql "dep"
          expect(subject.object_id).to eql instance.value.object_id
        end
      end

      context "without memoization" do
        let(:memoize) { false }

        it "returns the #memoized_value" do
          expect(subject).to eql "dep"
          expect(subject.object_id).not_to eql instance.value.object_id
        end
      end
    end

    describe "#memoized_value" do
      subject { instance.memoized_value }

      before { allow(instance).to receive(:dependencies_value) { rand } }

      it "memoizes the value" do
        expect(instance.dependencies_value).not_to eql instance.dependencies_value
        expect(subject.object_id).to eql instance.memoized_value.object_id
      end
    end

    describe "#memoize?" do
      subject { instance.memoize? }

      it "by default returns true" do
        expect(subject).to be true
      end

      context "with :memoize option" do
        let(:options) { { memoize: false } }

        it "returns false" do
          expect(subject).to be false
        end
      end
    end

    describe "#dependencies_value" do
      subject { instance.dependencies_value }

      before do
        allow(instance).to receive(:lambda_value).and_return("lamb")
        allow(instance).to receive(:empty_value).and_return("emp")
        allow(instance).to receive(:valid_dependencies?).and_return(valid_dependencies)
      end

      context "with valid dependency" do
        let(:valid_dependencies) { true }

        it "returns the #lambda_value" do
          expect(subject).to eql "lamb"
        end
      end

      context "with valid dependency" do
        let(:valid_dependencies) { false }

        it "returns the #lambda_value" do
          expect(subject).to eql "emp"
        end
      end
    end

    describe "#valid_dependencies?" do
      subject { instance.valid_dependencies? }

      it "returns true" do
        expect(subject).to be true
      end

      context "dependency is provided" do
        let(:options) { { dependencies: %i[string1 string1] } }

        it "returns false" do
          expect(subject).to be false
        end

        context "when dependency is not blank" do
          let(:row_model) { BasicImportModel.new(%w[dep1 dep2]) }

          it "returns true" do
            expect(subject).to be true
          end
        end
      end
    end

    describe "#empty_value" do
      subject { instance.empty_value }

      it "returns the empty value" do
        expect(subject).to be_nil
      end

      context "with :empty_value option" do
        let(:options) { { empty_value: "emp" } }

        it "returns the option value" do
          expect(subject).to eql "emp"
        end
      end
    end

    describe "#lambda_value" do
      subject { instance.lambda_value }

      it "returns the value of the block" do
        expect(subject).to eql "string1"
      end

      context "with return statement inside" do
        let(:block) { proc { return "string1_string1" } }

        it "allows the return statement" do
          expect(subject).to eql "string1_string1"
        end
      end
    end

    describe "#dependencies" do
      subject { instance.dependencies }

      it "defaults to empty array" do
        expect(subject).to eql []
      end

      context "with non-array given" do
        let(:options) { { dependencies: "dep" } }

        it "converts it to an array" do
          expect(subject).to eql ["dep"]
        end
      end

      context "with array given" do
        let(:options) { { dependencies: %i[a b c] } }

        it "returns the array" do
          expect(subject).to eql %i[a b c]
        end
      end
    end
  end

  describe "class" do
    describe "::lambda_name" do
      subject { described_class.lambda_name(:some_name) }

      it "returns the underscored name" do
        expect(subject).to be :__some_name
      end
    end

    describe "::define_lambda_method" do
      subject { described_class.define_lambda_method(klass, :some_name) { return "test" } }

      let(:klass) { Class.new { include Csvimporter::HiddenModule } }

      it "adds the process method to the class" do
        subject
        expect(klass.new.__some_name).to eql "test"
      end
    end
  end
end
