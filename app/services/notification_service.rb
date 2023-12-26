class NotificationService
  attr_reader :fcm_client
  def initialize
    @fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
  end

  def send_notification(message, title, registration_ids, options= nil)
    if registration_ids.present?
      data = notification_options(message, title, options)
      registration_ids.each_slice(20) do |registration_id|
        response = fcm_client.send(registration_id, data)
      end
    end  
  end

  def notification_options(message, title, options)
    data_hash = {}
    data_hash[:priority] = 'high'
    data_hash[:data] = options
    data_hash[:notification] = { body: message, title: title,
                                 sound: 'default' } #, icon: 'image.png'}
    data_hash
  end  
end 
