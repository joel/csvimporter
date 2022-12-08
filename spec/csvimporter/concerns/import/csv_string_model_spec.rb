# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::ParsedModel do
  describe "instance" do
    let(:source_row) { %w[1.01 b] }
    let(:options) { {} }
    let(:klass) { BasicImportModel }
    let(:instance) { klass.new(source_row, options) }

    describe "#parsed_model" do
      subject { instance.parsed_model }

      it "returns parsed_model with methods working" do
        expect(subject.string1).to eql "1.01"
        expect(subject.string2).to eql "b"
      end

      context "with format_cell" do
        it "format_cells first" do
          expect(klass).to receive(:format_cell).with("1.01", :string1, kind_of(OpenStruct)).and_return(nil)
          expect(klass).to receive(:format_cell).with("b", :string2, kind_of(OpenStruct)).and_return(nil)
          expect(subject.string1).to be_nil
          expect(subject.string2).to be_nil
        end
      end
    end

    describe "#valid?" do
      subject { instance.valid? }

      let(:klass) do
        Class.new do
          include Csvimporter::Model
          include Csvimporter::Import

          column :id

          def self.name
            "TwoLayerValid"
          end
        end
      end

      context "with 1 validation" do
        before do
          klass.class_eval { validates :id, presence: true }
        end

        it "works" do
          expect(subject).to be true
        end

        context "with empty row" do
          let(:source_row) { %w[] }

          it "works" do
            expect(subject).to be false
          end
        end
      end

      context "when setting default, but invalid parsed_model validation" do
        let(:source_row) { ["1", ""] }

        before do
          klass.class_eval do
            column :name, default: "the default!"
            parsed_model { validates :name, presence: true }
          end
        end

        it "returns just invalid" do
          expect(subject).to be false
          expect(instance.errors.full_messages).to eql ["Name can't be blank"]
        end
      end

      context "overriding validations" do
        before do
          klass.class_eval do
            validates :id, length: { minimum: 5 }
            parsed_model { validates :id, presence: true }
          end
        end

        it "takes the parsed_model_class validation first then the row_model validation" do
          expect(subject).to be false
          expect(instance.errors.full_messages).to eql ["Id is too short (minimum is 5 characters)"]
        end

        context "with empty row" do
          let(:source_row) { [""] }

          it "just shows the parsed_model_class validation" do
            expect(subject).to be false
            expect(instance.errors.full_messages).to eql ["Id can't be blank"]
          end
        end

        context "with errors has a key with empty value" do
          before do
            expect(instance.parsed_model).to receive(:valid?).at_least(:once).and_wrap_original do |original, *args|
              result = original.call(*args)
              # this makes instance.parsed_model.errors.messages = { id: [] }
              instance.parsed_model.errors[:id]
              result
            end
          end

          it "still shows the non-string validation" do
            expect(subject).to be false
            expect(instance.parsed_model.errors.messages).to eql(id: [])
            expect(instance.errors.full_messages).to eql ["Id is too short (minimum is 5 characters)"]
          end
        end
      end

      context "with warnings" do
        before do
          klass.class_eval do
            warnings { validates :id, length: { minimum: 5 } }
            parsed_model do
              warnings { validates :id, presence: true }
            end
          end
        end

        context "with empty row" do
          let(:source_row) { [""] }

          it "just shows the parsed_model_class validation" do
            expect(subject).to be true
            expect(instance.safe?).to be false
            expect(instance.warnings.full_messages).to eql ["Id can't be blank"]
          end
        end
      end
    end
  end

  describe described_class::Model do
    describe "instance" do
      let(:instance) { described_class.new(string1: "abc", string2: "efg") }

      describe "attribute methods" do
        it "works" do
          expect(instance.string1).to eql "abc"
          expect(instance.string2).to eql "efg"
        end
      end
    end
  end
end
