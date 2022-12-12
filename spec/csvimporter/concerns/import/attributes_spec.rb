# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::Attributes do
  let(:row_model_class) { Class.new BasicImportModel }
  let(:source_row)      { %w[1.01 b] }
  let(:instance)        { row_model_class.new(source_row) }

  describe "instance" do

    describe "define methods" do
      it { expect(instance).to respond_to(:string1) }
    end

    describe "#attribute_objects" do
      subject { instance.attribute_objects }

      it "returns a hash of cells mapped to their column_name" do
        expect(subject.keys).to eql row_model_class.column_names
        expect(subject.values.map(&:class)).to eql [Csvimporter::Import::Attribute] * 2
      end

      context "invalid and invalid parsed_model" do
        let(:row_model_class) do
          Class.new(BasicImportModel) do
            validates :string1, presence: true
          end
        end
        let(:source_row) { [] }

        it "returns the cells with the right attributes" do
          # values = subject.values
          # expect(values.map(&:column_name)).to eql %i[string1 string2]
          # expect(values.map(&:source_value)).to eql [nil, nil]
          # expect(values.map(&:parsed_model_errors)).to eql [[], ["can't be blank"]]
        end
      end
    end

    describe "#formatted_attributes" do
      subject { instance.formatted_attributes }

      let(:row_model_class) do
        Class.new(super()) do
          def self.format_cell(*args)
            args.join("__")
          end
        end
      end

      it "returns the formatted_headers" do
        expect(subject).to eql(string1: "1.01__string1__#<OpenStruct>", string2: "b__string2__#<OpenStruct>")
      end
    end
  end

  describe "class" do
    let(:row_model_class) do
      Class.new do
        include Csvimporter::Model
        include Csvimporter::Import
      end
    end

    describe ":column" do
      it_behaves_like "column_method", Csvimporter::Import, string1: "1.01", string2: "b"
    end

    describe "::define_attribute_method" do
      subject { row_model_class.send(:define_attribute_method, :waka) }

      it "makes an attribute that calls original_attribute" do
        subject
        expect(instance).to receive(:original_attribute).with(:waka).and_return("tested")
        expect(instance.waka).to eql "tested"
      end

      context "with another validation added" do
        it_behaves_like "define_attribute_method"
      end
    end
  end
end
