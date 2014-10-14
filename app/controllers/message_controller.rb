class MessageController < ApplicationController
  #before_action :authenticate_user!
  def incoming_message
  	
  	if params['text']
      #user = User.find_by(phone: params['msisdn'])
      user = User.first
      @note = user.notes.create(content: params["text"]) if user
      $redis.publish("howard", {note: @note, phone: user.phone}.to_json)
    end

    respond_to do |format|
      format.all { render nothing: true, status: :ok }
    end
  end
end