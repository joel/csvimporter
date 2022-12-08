# frozen_string_literal: true

require "spec_helper"
class InspectObject
  include Csvimporter::Inspect
  INSPECT_METHODS = %i[var3 var1 var2].freeze
  attr_accessor :var1, :var2, :var3

  def initialize
    @var1 = "dog"
    @var2 = { a: "dug", b: "the" }
    @var3 = OpenStruct.new(c: "waka")
  end
end

describe Csvimporter::Inspect do
  describe "instance" do
    let(:instance) { InspectObject.new }

    describe "#inspect" do
      subject { instance.inspect }

      it "is clean" do
        expect(subject).to match(/#<InspectObject:0x\w{14} var3=#<OpenStruct c="waka">, var1="dog", var2={:a=>"dug", :b=>"the"}>/)
      end
    end
  end
end
