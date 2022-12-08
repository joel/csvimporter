# frozen_string_literal: true

module Csvimporter
  RSpec.describe DynamicColumn do
    let(:klass) do
      Class.new do
        include DynamicColumn

        dynamic_column :skills
      end
    end

    it { expect(klass).to respond_to(:dynamic_columns) }

    context "when column already defined in ancestors classes" do
      it do
        expect do
          Class.new(klass) do
            dynamic_column :skills
          end
        end.to raise_error DynamicColumn::DuplicateColumnDefinitionError, "Already defined column [skills]"
      end
    end
  end
end
