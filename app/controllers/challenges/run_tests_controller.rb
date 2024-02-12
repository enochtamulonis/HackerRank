require "minitest/autorun"

class BroadcastLiveResults
  attr_reader :output

  def initialize(challenge, output=STDOUT) 
    @output= output
    @challenge = challenge
  end

  def some_callback(content)
    @challenge.broadcast_update_to(@challenge, target: "results", html: content.join )
  end 

  def method_missing(method_name,*args,**kwargs,&block) 
     if @output.respond_to?(method_name) 
       some_callback(args)
       @output.public_send(method_name,*args,**kwargs,&block) 
     else 
       super
     end 
  end 

  def respond_to_missing?(method_name, include_private = false)
    @output.respond_to?(method_name, include_private) || super
  end
end

module Challenges
  class RunTestsController < ApplicationController
    def create
      @challenge = Challenge.find(params[:challenge_id])
      @user_challenge = @challenge.user_challenges.find_or_create_by(user_id: current_user.id)
      @user_challenge.update(code: params[:code])
      $stdout = BroadcastLiveResults.new(@challenge)
      test_class = Class.new(Minitest::Test)
      test_class.class_eval(@challenge.test_file.download)
      test_instance = test_class.new("Challenge#{@challenge.id}Test")
      eval(params[:code])
      result = Minitest.run([test_instance])
      if result
        @user_challenge.update(status: :completed)
        @challenge.broadcast_append_to(@challenge, target: "results", partial: "challenges/complete")
      else
        @challenge.broadcast_append_to(@challenge, target: "results", partial: "challenges/failed")
      end
    end
  end
end