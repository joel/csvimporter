# frozen_string_literal: true

module Csvimporter
  module Inspect
    def inspect
      s = self.class::INSPECT_METHODS.map { |method| "#{method}=#{public_send(method).inspect}" }.join(", ")
      address = format("%x", (object_id << 1)).rjust(14, "0")
      "#<#{self.class.name}:0x#{address} #{s}>"
    end
  end
end
