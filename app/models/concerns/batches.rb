# Client side
# app/models/concerns/batches.rb
module Concerns
  module Batches
    extend ActiveSupport::Concern

    module ClassMethods
      def find_in_batches(options={})
        start      = options.delete(:start).to_i
        batch_size = options.delete(:batch_size) || 1000

        begin
          records      = find(:all, params: { offset: start, limit: batch_size })
          records_size = records.size
          start       += batch_size

          yield records

          break if records_size < batch_size
        end while records.any?
      end

      def find_each(options={})
        find_in_batches(options) do |records|
          records.each { |record| yield record }
        end
      end
    end
  end
end