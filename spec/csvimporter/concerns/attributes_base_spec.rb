# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe AttributesBase do
    let(:row_model_class) do
      Class.new do
        include BasicAttributes

        column :alpha
        column :beta
      end
    end
    let(:instance)   { row_model_class.new(*attributes.values) }
    let(:attributes) { { alpha: "alpha one", beta: "beta two" } }

    describe "instance" do
      describe "define methods" do
        it { expect(instance).to respond_to(:alpha) }
      end

      describe "#attributes" do
        subject(:attr_base_attributes) { instance.attributes }

        it "returns the map of column_name => public_send(column_name)" do
          expect(attr_base_attributes).to eql attributes
        end

        context "with no methods defined" do
          before do
            row_model_class.send :undef_method, :alpha
            row_model_class.send :undef_method, :beta
          end

          it "returns a hash with nils" do
            expect(attr_base_attributes).to eql(alpha: nil, beta: nil)
          end
        end

        context "with one method defined" do
          before do
            row_model_class.send :undef_method, :beta
          end

          it "returns a hash with a nil" do
            expect(attr_base_attributes).to eql(alpha: "alpha one", beta: nil)
          end
        end

        context "with nil returned in method" do
          let(:attributes) { { alpha: nil, beta: "beta two" } }

          it "returns a hash with a nil" do
            expect(attr_base_attributes).to eql attributes
          end
        end
      end

      describe "#original_attributes" do
        subject(:original_attributes) { instance.original_attributes }

        it "returns the attributes hash" do
          expect(original_attributes).to eql(alpha: "alpha one", beta: "beta two")
        end
      end

      describe "#formatted_attributes" do
        subject(:formatted_attributes) { instance.formatted_attributes }

        before do
          row_model_class.class_eval do
            def self.format_cell(*args)
              args[0..1].join(" - ")
            end
          end
        end

        it "returns the attributes hash" do
          expect(formatted_attributes).to eql(alpha: "alpha one_source - alpha",
                                              beta: "beta two_source - beta")
        end
      end

      describe "#source_attributes" do
        subject(:source_attributes) { instance.source_attributes }

        it "returns the attributes hash" do
          expect(source_attributes).to eql(alpha: "alpha one_source", beta: "beta two_source")
        end
      end

      describe "#original_attribute" do
        it { expect(instance.original_attribute(:alpha)).to eql "alpha one" }
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
