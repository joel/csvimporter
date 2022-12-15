# frozen_string_literal: true

module Csvimporter
  module Proxy
    extend ActiveSupport::Concern

    class_methods do
      def proxy
        @proxy ||= Module.new.tap { |mod| include mod }
      end

      def define_proxy_method(*args, &block)
        proxy.send(:define_method, *args, &block)
      end
    end
  end
end
