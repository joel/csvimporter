# frozen_string_literal: true

require "spec_helper"

describe "Csvimporter::Import::ParsedModel" do
  describe "instance" do
    let(:source_row) { %w[1.01 b] }
    let(:options)    { { foo: :bar } }
    let(:klass)      { BasicImportModel }
    let(:instance)   { klass.new(source_row, options) }

    describe "#parsed_model" do
      subject { instance.parsed_model }

      it "returns parsed_model with methods working" do
        expect(subject.string1).to eql "1.01"
        expect(subject.string2).to eql "b"
      end

      # context "with format_cell" do
      #   it "format_cells first" do
      #     expect(klass).to receive(:format_cell).with("1.01", :string1, kind_of(OpenStruct)).and_return(nil)
      #     expect(klass).to receive(:format_cell).with("b", :string2, kind_of(OpenStruct)).and_return(nil)
      #     expect(subject.string1).to be_nil
      #     expect(subject.string2).to be_nil
      #   end
      # end
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

      context "overriding validations" do
        before do
          klass.class_eval do
            validates :id, length: { minimum: 5 }
            parsed_model { validates :id, presence: true }
          end
        end

        it "takes the parsed_model_class validation into account" do
          expect(subject).to be false
          expect(instance.errors.full_messages).to eql ["Id is too short (minimum is 5 characters)"]
        end

        context "with empty row" do
          let(:source_row) { [""] }

          it "just shows the parsed_model_class validation too" do
            expect(subject).to be false
            expect(instance.errors.full_messages).to eql ["Id is too short (minimum is 5 characters)",
                                                          "Id can't be blank"]
          end
        end
      end
    end
  end
end
