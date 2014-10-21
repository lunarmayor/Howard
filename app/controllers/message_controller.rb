class MessageController < ApplicationController
  #before_action :authenticate_user!
  def incoming_message
  	
  	if params['text']
      user = User.find_by(phone: params['msisdn'])
      if user
        if ['stop', 'pleasestop', 'stoptextingme', 'shutup'].include?(params['text'].downcase.gsub(/[^a-z]/, ''))
          user.prompt = false
          user.save
          $nexmo.send_message(from: '12134657992', to: params['msisdn'], text: 'Okay, sorry, I won\'t text you anymore.')
        else
          @note = user.notes.create(content: params["text"])
          $redis.publish("howard", {note: @note, phone: user.phone}.to_json)
        end
      else
        $nexmo.send_message(from: '12134657992', to: params['msisdn'], text: 'Hello, I\'m Howard. Text me your ideas, goals, hopes, dreams, and fears. I\'ll keep them safe. sign up at www.howardapp.com')
      end
    end

    respond_to do |format|
      format.all { render nothing: true, status: :ok }
    end
  end

  def sms_all
    if params['text']
      User.where(prompt: true).each do |user|
        #$nexmo.send_message(from: '12134657992', to: user.phone, text: params['text'])
      end
    end

    respond_to do |format|
      format.all { render nothing: true, status: :ok }
    end
  end
end