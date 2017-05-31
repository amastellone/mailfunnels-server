require "erb"

class BatchEmailJobJob < ApplicationJob
  queue_as :default

  def perform(emailJob)
      puts "JOB EXECUTED"
  end
end
