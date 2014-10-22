class MessageController < ApplicationController
  #before_action :authenticate_user!
  def incoming_message
  	
  	if params['text']
      user = User.find_by(phone: params['msisdn'])
      if user
        if ['stop', 'pleasestop', 'stoptextingme', 'shutup'].include?(params['text'].downcase.gsub(/[^a-z]/, ''))
          $nexmo.send_message(from: '12134657992', to: params['msisdn'], text: 'Okay, sorry, I won\'t text you anymore.') if user.prompt 
          user.prompt = false
          user.save
        else
          parse_text(params["text"], user)
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


  def parse_text(text, user)
    ending_char = (/[:][^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]]/ =~ text)
    
    if ending_char.present?
      to_list(text, ending_char, user)
    else
      @note = user.notes.create(content: params["text"])
      $redis.publish("howard", {note: @note, phone: user.phone}.to_json)
    end
  end

  def to_list(text, ending_char, user)
    list_name = text[0...ending_char].downcase
    note_content = text[(ending_char+1)..-1]

    if note_content.present?
      list = user.lists.where('lower(name) = ?', list_name).first

      if list.present?
        @note = user.notes.create(content: note_content, list_id: list.id)
        $redis.publish("howard", {note: @note, phone: user.phone}.to_json)
      else
        new_list = user.lists.create(name: list_name)
        @note = user.notes.create(content: note_content, list_id: new_list.id)
      end
    end
  end
end
















