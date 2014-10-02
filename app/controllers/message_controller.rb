class MessageController < ApplicationController
  #before_action :authenticate_user!
  def incoming_message
  	
  	if params['text']
      #user = User.find_by(phone: params['msisdn'].sub('1', ''))
      user = User.first
      puts "incoming"
      @note = user.notes.create(content: params["text"]) if user
      $redis.publish("howard", @note.to_json)
    end

    respond_to do |format|
      format.all { render nothing: true, status: :ok }
    end
  end
end