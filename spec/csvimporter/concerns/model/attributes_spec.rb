# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Model::Attributes do
  describe "class" do
    let(:klass) { BasicRowModel }

    describe "::column_names" do
      subject { klass.column_names }

      specify { expect(subject).to eql %i[string1 string2] }
    end

    describe "::format_header" do
      subject { BasicRowModel.format_header(header, nil) }

      let(:header) { "user_name" }

      it "returns the header" do
        expect(subject).to eql header
      end
    end

    describe "::headers" do
      subject { klass.headers }

      let(:headers) { [:string1, "String 2"] }

      it "returns an array with header column names" do
        expect(subject).to eql headers
      end
    end

    describe "::format_cell" do
      subject { BasicRowModel.format_cell(cell, nil, nil) }

      let(:cell) { "the_cell" }

      it "returns the cell" do
        expect(subject).to eql cell
      end
    end

    context "with custom class" do
      let(:klass) { Class.new { include Csvimporter::Model } }

      describe "::column" do
        subject { klass.send(:column, :blah) }

        it "calls ::check_options with the args" do
          expect(klass).to receive(:check_options).with(Csvimporter::Model::Header,
                                                        Csvimporter::Import::ParsedModel::Model,
                                                        Csvimporter::Import::Attribute,
                                                        klass,
                                                        {}).once.and_call_original
          subject
        end

        context "with invalid option" do
          subject { klass.send(:column, :blah, invalid_option: true) }

          it "raises error" do
            expect { subject }.to raise_error("Invalid option(s): [:invalid_option]")
          end
        end
      end

      describe "::merge_options" do
        subject { klass.send(:merge_options, :blah, default: 1) }

        before { klass.send(:column, :blah, type: Integer) }

        it "merges the option" do
          result = { blah: { type: Integer, default: 1 } }

          expect { subject }.to change(klass, :columns).from(blah: { type: Integer }).to(result)
          expect(klass.columns_object.raw_value).to eql(result)
        end

        context "with child class class" do
          subject do
            klass.send(:merge_options, :blah, default: 1)
            child_class.send(:merge_options, :blah, header: "Blah")
          end

          let(:child_class) { Class.new(klass) }

          it "passes merged option to child, but not to parent" do
            expect(klass.columns).to eql(blah: { type: Integer })
            expect(klass.columns_object.raw_value).to eql(blah: { type: Integer })

            expect(child_class.columns).to eql(blah: { type: Integer })
            expect(child_class.columns_object.raw_value).to eql({})

            subject

            expect(klass.columns).to eql(blah: { type: Integer, default: 1 })
            expect(klass.columns_object.raw_value).to eql(blah: { type: Integer, default: 1 })

            expect(child_class.columns).to eql(blah: { type: Integer, default: 1, header: "Blah" })
            expect(child_class.columns_object.raw_value).to eql(blah: { header: "Blah" })
          end

          context "with multiple columns" do
            subject { child_class.send(:merge_options, :blah1, default: 1) }

            before { %i[blah1 blah2].each { |column_name| klass.send(:column, column_name, type: Integer) } }

            it "keeps the column_names in the same order" do
              subject
              expect(child_class.column_names).to eql %i[blah blah1 blah2]
            end
          end
        end
      end

      describe "::class_to_parse_lambda" do
        subject { klass.class_to_parse_lambda }

        it "returns the CLASS_TO_PARSE_LAMBDA" do
          expect(subject).to eql Csvimporter::Import::Attributes::CLASS_TO_PARSE_LAMBDA
        end
      end

      describe "::custom_check_options" do
        subject { klass.custom_check_options(options) }

        context "with invalid :type Option" do
          let(:options) { { type: Object } }

          it "raises exception" do
            expect { subject }.to raise_error(":type must be Boolean, String, Integer, Float, DateTime, Date")
          end

          context "with ::class_to_parse_lambda overwritten" do
            before do
              _override = override
              klass.define_singleton_method(:class_to_parse_lambda) { super().merge(_override) }
            end

            let(:override) { { Hash => ->(s) { JSON.parse(s) } } }

            it "raises a new type of exception" do
              expect { subject }.to raise_error(":type must be Boolean, String, Integer, Float, DateTime, Date, Hash")
            end
          end
        end
      end
    end
  end
end
