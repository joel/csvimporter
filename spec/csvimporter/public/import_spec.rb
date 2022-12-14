# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe Import do
    context "without including Csvimporter::Model" do
      let(:klass) do
        Class.new do
          include Import

          column :alpha
          column :beta
        end
      end

      it do
        expect(klass.new(%w[alpha beta]).attributes).to eql(alpha: "alpha", beta: "beta")
      end

      it "has Csvimporter::Model included" do
        expect(klass.ancestors).to include Csvimporter::Model
      end
    end
  end
end
