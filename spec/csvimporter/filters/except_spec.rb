# frozen_string_literal: true

module Csvimporter
  module Filters
    RSpec.describe Except do
      subject(:instance) do
        described_class.new(headers: headers, headers_to_filter: except_headers)
      end

      let(:headers) do
        [
          "Full Name of [John]",
          "First name",
          "Last name",
          "Openness",
          "Conscientiousness",
          "Extraversion",
          "Agreeableness"
        ]
      end

      let(:except_headers) do
        [
          "Last name",
          "Openness"
        ]
      end

      it "#filtered_headers" do
        expect(
          instance.filtered_headers
        ).to eql(
          [
            "Full Name of [John]",
            "First name",
            "Conscientiousness",
            "Extraversion",
            "Agreeableness"
          ]
        )
      end

      describe "filtered_cells" do
        let(:values) do
          [
            "Sr. John Doe",
            "John",
            "Doe",
            "NO",
            "NO",
            "NO",
            "YES"
          ]
        end

        it "filters the cells" do
          expect(
            instance.filtered_cells(values)
          ).to eql(
            [
              "Sr. John Doe",
              "John",
              "NO",
              "NO",
              "YES"
            ]
          )
        end
      end
    end
  end
end
