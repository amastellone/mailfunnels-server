class ApplicationJob < ActiveJob::Base
  rescue_from(StandardError) do |exception|
    puts exception
  end
end
