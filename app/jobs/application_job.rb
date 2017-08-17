class ApplicationJob < ActiveJob::Base
  rescue_from(StandardError) do |exception|
    puts "======================"
    puts exception
    puts "======================"

  end
end
