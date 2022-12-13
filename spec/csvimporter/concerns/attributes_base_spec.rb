# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe AttributesBase do
    let(:row_model_class) do
      Class.new do
        include BasicAttributes

        column :string1
        column :string2
      end
    end
    let(:instance)   { row_model_class.new(*attributes.values) }
    let(:attributes) { { string1: "haha", string2: "baka" } }

    describe "instance" do
      describe "define methods" do
        it { expect(instance).to respond_to(:string1) }
      end

      describe "#attributes" do
        subject(:attr_base_attributes) { instance.attributes }

        it "returns the map of column_name => public_send(column_name)" do
          expect(attr_base_attributes).to eql attributes
        end

        context "with no methods defined" do
          before do
            row_model_class.send :undef_method, :string1
            row_model_class.send :undef_method, :string2
          end

          it "returns a hash with nils" do
            expect(attr_base_attributes).to eql(string1: nil, string2: nil)
          end
        end

        context "with one method defined" do
          before do
            row_model_class.send :undef_method, :string2
          end

          it "returns a hash with a nil" do
            expect(attr_base_attributes).to eql(string1: "haha", string2: nil)
          end
        end

        context "with nil returned in method" do
          let(:attributes) { { string1: nil, string2: "baka" } }

          it "returns a hash with a nil" do
            expect(attr_base_attributes).to eql attributes
          end
        end
      end

      describe "#original_attributes" do
        subject(:original_attributes) { instance.original_attributes }

        it "returns the attributes hash" do
          expect(original_attributes).to eql(string1: "haha", string2: "baka")
        end
      end

      describe "#formatted_attributes" do
        subject(:formatted_attributes) { instance.formatted_attributes }

        before do
          row_model_class.class_eval do
            def self.format_cell(*args)
              args.join("__")
            end
          end
        end

        it "returns the attributes hash" do
          expect(formatted_attributes).to eql(string1: "haha_source__string1__#<OpenStruct>",
                                              string2: "baka_source__string2__#<OpenStruct>")
        end
      end

      describe "#source_attributes" do
        subject(:source_attributes) { instance.source_attributes }

        it "returns the attributes hash" do
          expect(source_attributes).to eql(string1: "haha_source", string2: "baka_source")
        end
      end

      describe "#original_attribute" do
        it_behaves_like "attribute_object_value", :original_attribute, :value, string1: "haha"
      end

      describe "#to_json" do
        it "returns the attributes json" do
          expect(instance.to_json).to eql(instance.attributes.to_json)
        end
      end

      describe "#eql?" do
        it "removes duplicate entries" do
          expect([row_model_class.new, row_model_class.new].uniq.size).to be(1)
        end
      end

      describe "#hash" do
        subject(:hash) { instance.hash }

        it "is the attributes hash" do
          expect(hash).to eql attributes.hash
        end
      end
    end
  end
end
