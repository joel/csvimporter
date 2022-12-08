# frozen_string_literal: true

module Csvimporter
  RSpec.describe Column do
    let(:klass) do
      Class.new do
        include Column

        column :foo
      end
    end

    it { expect(klass).to respond_to(:columns) }
    it { expect(klass.columns).to have_key(:foo) }
    it { expect(klass.columns[:foo]).to have_key(:header) }
    it { expect(klass.columns[:foo]).to have_key(:column) }
    it { expect(klass.columns[:foo][:header]).to be(:foo) }

    context "when column already defined in ancestors classes" do
      it do
        expect do
          Class.new(klass) do
            column :foo
          end
        end.to raise_error Column::DuplicateColumnDefinitionError,
                           "Already defined column [foo], please use override: true"
      end

      it do
        inherited_klass = nil
        expect do
          inherited_klass = Class.new(klass) do
            column :foo, override: true, header: "New Header"
          end
        end.not_to raise_error
        expect(inherited_klass.columns[:foo][:header]).to eql("New Header")
      end
    end
  end
end
