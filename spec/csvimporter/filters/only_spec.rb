# frozen_string_literal: true

module Csvimporter
  module Filters
    RSpec.describe Only do
      subject(:instance) do
        described_class.new(headers: headers, headers_to_filter: only_headers)
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

      let(:only_headers) do
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
            "Last name",
            "Openness"
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
            %w[
              Doe
              NO
            ]
          )
        end
      end
    end
  end
end
