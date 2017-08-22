module ActiveResource
  module Batches
    module ClassMethods

      def find_each(options = {})
        find_in_batches(options) do |batch|
          batch.each do |entry|
            yield entry
          end
        end
      end

      def find_in_batches(options = {})
        finished = false
        page = 1
        while not finished do
          begin
            batch = find(:all, :params => options.merge(:page => page))
            if batch.empty?
              finished = true
            else
              yield batch
            end
            page += 1
          end
        end
      end
    end

  end
end

ActiveResource::Base.extend(ActiveResource::Batches::ClassMethods)