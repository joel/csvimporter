# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::Attribute do
  describe "instance" do
    let(:instance) { described_class.new(:string1, source_value, parsed_model_errors, row_model) }
    let(:source_value) { "1.01" }
    let(:parsed_model_errors) { nil }

    let(:row_model_class) { Class.new BasicImportModel }
    let(:row_model) do
      row_model_class.new(source_row)
    end
    let(:options) { {} }
    let(:source_row) { [source_value, "original_string2"] }

    it_behaves_like "has_needed_value_methods"

    describe "#value" do
      subject { instance.value }

      it "memoizes the result" do
        expect(subject).to eql "1.01"
        expect(subject.object_id).to eql instance.value.object_id
      end

      it "calls format_cell and returns the result" do
        expect(instance).to receive(:formatted_value).twice.and_return("waka")
        expect(subject).to eql("waka")
      end

      context "with empty parsed_model_errors" do
        let(:parsed_model_errors) { [] }

        it "returns the result" do
          expect(subject).to eql("1.01")
        end
      end

      context "with all options" do
        let(:options) { { default: -> { "123" }, parse: ->(s) { s.to_f } } }

        it "returns the parsed result" do
          expect(subject).to eql("1.01".to_f)
        end

        context "with empty string" do
          let(:source_value) { "" }

          it "returns the default" do
            expect(subject).to eql("123")
          end
        end
      end

      context "with invalid parsed_model" do
        let(:parsed_model_errors) { ["must be Integer"] }
        let(:options) { { type: Integer } }

        it "returns nil" do
          expect(subject).to be_nil
        end

        context "with default" do
          let(:options) { super().merge(default: 123) }

          it "returns nil" do
            expect(subject).to be_nil
          end
        end
      end
    end

    describe "#parsed_value" do
      subject { instance.parsed_value }

      context "with :type option" do
        {
          nil => "1.01",
          Boolean => true,
          String => "1.01",
          Integer => 1,
          Float => 1.01
        }
          .each do |type, expected_result|
          context "of #{type.nil? ? "nil" : type}" do
            let(:source_value) { "1.01" }
            let(:options) { { type: type } }

            it "returns the parsed type" do
              expect(subject).to eql expected_result
            end
          end
        end

        {
          Date => ["15/12/30", Date.new(2015, 12, 30)],
          DateTime => ["15/12/30 09:00:00", DateTime.new(2015, 12, 30, 9, 0o0, 0o0)]
        }
          .each do |type, (source_value, expected_result)|
          context "of #{type.nil? ? "nil" : type}" do
            let(:source_value) { source_value }
            let(:options) { { type: type } }

            it "returns the parsed type" do
              expect(subject).to eql expected_result
            end
          end
        end

        context "with nil source_value" do
          let(:source_value) { nil }

          Csvimporter::Import::Attributes::CLASS_TO_PARSE_LAMBDA.each_key do |type|
            context "with #{type.nil? ? "nil" : type} :type" do
              let(:options) { { type: type } }

              it "doesn't return an exception" do
                expect { subject }.not_to raise_error
              end
            end
          end
        end
      end

      context "with row_model_class::class_to_parse_lambda defined" do
        before do
          _override = override
          row_model_class.define_singleton_method(:class_to_parse_lambda) { super().merge(_override) }
        end

        let(:override) { { Hash => ->(s) { JSON.parse(s) } } }
        let(:options) { { type: Hash } }
        let(:source_value) { '{ "key": 1 }' }

        it "returns does the correct parsing for the class" do
          expect(subject).to eql("key" => 1)
        end

        context "with custom String" do
          let(:override) { { "CommaList" => ->(s) { s.split(",").map(&:strip) } } }
          let(:options) { { type: "CommaList" } }
          let(:source_value) { "   thing1 , thing2" }

          it "raises a new type of exception" do
            expect(subject).to eql %w[thing1 thing2]
          end
        end
      end

      context "with :parse option" do
        let(:options) { { parse: ->(_s) { "haha" } } }

        it "returns what the parse returns" do
          expect(subject).to eql "haha"
        end

        context "when calling another attribute" do
          let(:options) { { parse: ->(_s) { string2 } } }

          it "returns the other attribute" do
            expect(subject).to eql "original_string2"
          end
        end
      end
    end

    describe "#default_value" do
      subject { instance.default_value }

      it "returns nil without option" do
        expect(subject).to be_nil
      end

      context "with default" do
        let(:options) { { default: 123 } }

        it "returns the default" do
          expect(subject).to be 123
        end
      end

      context "with Proc default" do
        let(:options) { { default: -> { "#{string1}_defaulted" } } }

        it "returns the default from the proc" do
          expect(subject).to eql "#{source_value}_defaulted"
        end

        context "when calling another attribute" do
          let(:options) { { default: -> { string2 } } }

          it "calls the other attribute" do
            expect(subject).to eql "original_string2"
          end
        end
      end
    end

    describe "#default?" do
      subject { instance.default? }

      it "returns false without option" do
        expect(subject).to be false
      end

      context "with default" do
        let(:options) { { default: 123 } }

        it "returns false with original value" do
          expect(subject).to be false
        end

        context "with format_cell returning no value" do
          before { expect(instance).to receive(:formatted_value).and_return("") }

          it "returns true" do
            expect(subject).to be true
          end

          context "with false default" do
            let(:options) { { default: false } }

            it "returns the default" do
              expect(subject).to be true
            end
          end
        end

        context "without original value" do
          let(:source_value) { "" }

          it "returns true" do
            expect(subject).to be true
          end
        end
      end
    end

    describe "#default_change" do
      subject { instance.default_change }

      let(:options) { { default: "default" } }

      it "returns nil" do
        expect(subject).to be_nil
      end

      context "when defaulted" do
        it "returns the formatted_value and default_value" do
          expect(instance).to receive(:default?).once.and_return(true)
          expect(subject).to eql ["1.01", "default"]
        end
      end
    end
  end
end
