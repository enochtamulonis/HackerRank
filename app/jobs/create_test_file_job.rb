class CreateTestFileJob < ApplicationJob
  queue_as :default

  def perform(challenge_id)
    @challenge = Challenge.find(challenge_id)

    @challenge.tests
    file_path = "tmp/#{SecureRandom.uuid}_test.rb"
    class_name = "Challenge#{challenge_id}Test"
    File.open(file_path, "w") do |file|
      # Write content to the file
      file.puts "class #{class_name} < ActiveSupport::TestCase"
      file.puts @challenge.tests
      file.puts "end"
    end

    File.open(file_path) do |local_file|
      @challenge.test_file.attach(io: local_file, filename: "#{class_name}.rb")
    end
    
    File.delete(file_path)
  end
end
