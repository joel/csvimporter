# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Model
    describe Base do
      describe "instance" do
        let(:options)  { {} }
        let(:instance) { BasicRowModel.new(options) }

        describe "#initialized_at" do
          subject(:initialized_at) { instance.initialized_at }

          let(:date_time) { DateTime.now }

          it "gives the time" do
            allow(DateTime).to receive(:now).and_return(date_time)
            expect(initialized_at).to eql date_time
          end
        end
      end
    end
  end
end
