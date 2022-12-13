# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::Base do
  describe "instance" do
    let(:source_row)      { %w[alpha beta] }
    let(:options)         { {} }
    let(:row_model_class) { BasicImportModel }
    let(:instance)        { row_model_class.new(source_row, options) }

    describe "#valid?" do
      subject { instance.valid? }

      it "defaults to true" do
        expect(subject).to be true
      end

      context "with Exception given" do
        let(:instance) { row_model_class.new(StandardError.new("msg")) }

        it "is invalid and has empty row as source" do
          expect(subject).to be false
          expect(instance.errors.full_messages).to eql ["Csv has msg"]
          expect(instance.source_row).to eql []
        end
      end
    end

    describe "#source_attributes" do
      subject { instance.source_attributes }

      it "returns a map of `column_name => source_row[index_of_column_name]" do
        expect(subject).to eql({ alpha: "alpha", beta: "beta" })
      end
    end

    describe "#free_previous" do
      subject { instance.free_previous }

      let(:options) { { previous: row_model_class.new([]) } }

      it "makes previous nil" do
        expect { subject }.to change(instance, :previous).to(nil)
      end

      context "when the class depends on the previous.previous" do
        let(:row_model_class) do
          Class.new(BasicImportModel) do
            def alpha
              @alpha ||= original_attribute(:alpha) || previous.try(:alpha)
            end
          end
        end
        let(:source_row) { [] }
        let(:options) { { previous: row_model_class.new([], previous: row_model_class.new(%w[1.01 b])) } }

        it "grabs alpha from previous.previous" do
          expect(instance.alpha).to eql "1.01"
        end
      end
    end

    describe "#skip?" do
      subject { instance.skip? }

      it "is false when valid" do
        expect(subject).to be false
      end

      it "is true when invalid" do
        expect(instance).to receive(:valid?).and_return(false)
        expect(subject).to be true
      end
    end

    describe "#abort?" do
      subject { instance.skip? }

      it "is always false" do
        expect(subject).to be false
      end
    end
  end
end
