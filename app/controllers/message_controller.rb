class MessageController < ApplicationController
  #before_action :authenticate_user!
  def incoming_message
    puts params
    $redis.publish("howard", {text: params['text']}.to_json)
    respond_to do |format|
      format.all { render nothing: true, status: :ok }
    end
  end
end