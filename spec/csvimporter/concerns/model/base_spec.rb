# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Model::Base do
  describe "instance" do
    let(:options)  { {} }
    let(:instance) { BasicRowModel.new(options) }

    describe "#initialized_at" do
      subject { instance.initialized_at }

      let(:date_time) { DateTime.now }

      it "gives the time" do
        expect(DateTime).to receive(:now).and_return(date_time)
        expect(subject).to eql date_time
      end
    end
  end
end
