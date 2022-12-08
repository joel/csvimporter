# frozen_string_literal: true

module Csvimporter
  RSpec.describe Exporter do
    include_context "with model"

    context "with columns" do
      let(:options) { {} }
      let(:collection) { [model.new] }

      let(:exporter) do
        Class.new do
          include Column
          include Exporter

          column :full_name
          column :first_name
          column :last_name
        end
      end

      it do
        expect(exporter.headers).to eql(["Full name", "First name", "Last name"])
        expect(
          exporter.content(
            collection,
            row_object_type,
            options
          )
        ).to eql([["Sr. John Doe", "John", "Doe"]])
        expect(
          exporter.generate(
            collection,
            row_object_type,
            options
          )
        ).to eql("Full name,First name,Last name\nSr. John Doe,John,Doe\n")
      end
    end

    context "with dynamic columns" do
      let(:traits) do
        %w[
          openness
          conscientiousness
          extraversion
          agreeableness
        ]
      end
      let(:options) { { context: { record: model.new, traits: traits } } }
      let(:collection) { [model.new] }

      let(:exporter) do
        Class.new do
          include Column
          include DynamicColumn
          include Exporter

          column :full_name, header: -> { "Full Name of [#{first_name}]" }
          column :first_name
          column :last_name
          dynamic_column :traits
        end
      end

      it do
        expect(
          exporter.headers([], row_object_type, options)
        ).to eql(["Full Name of [John]",
                  "First name",
                  "Last name",
                  "Openness",
                  "Conscientiousness",
                  "Extraversion",
                  "Agreeableness"])
      end

      it do
        expect(
          exporter.generate(collection, row_object_type, options)
        ).to eql(
          "Full Name of [John],First name,Last name,Openness,Conscientiousness,Extraversion,Agreeableness\n" \
          "Sr. John Doe,John,Doe,NO,NO,NO,YES\n"
        )
      end

      context "with except" do
        let(:options) do
          opts = super()
          opts[:context] = opts[:context].merge({ except: ["Last name", "Openness"] })
          opts
        end

        it do
          expect(
            exporter.generate(collection, row_object_type, options)
          ).to eql(
            "Full Name of [John],First name,Conscientiousness,Extraversion,Agreeableness\n" \
            "Sr. John Doe,John,NO,NO,YES\n"
          )
        end
      end

      context "with only" do
        let(:options) do
          opts = super()
          opts[:context] = opts[:context].merge({ only: ["Last name", "Openness"] })
          opts
        end

        it do
          expect(
            exporter.generate(collection, row_object_type, options)
          ).to eql(
            "Last name,Openness\n" \
            "Doe,NO\n"
          )
        end
      end

      context "with both only and except" do
        let(:options) do
          opts = super()
          opts[:context] = opts[:context].merge({ only: ["Last name", "Openness"], except: ["First name"] })
          opts
        end

        it do
          expect do
            exporter.generate(collection, row_object_type, options)
          end.to raise_error(":only and :except headers are mutually exclusive")
        end
      end
    end
  end
end
