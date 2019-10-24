module OnlinePbx
  class WsApi
    ApiError = Class.new StandardError

    URL_BASE = "experimentikum.onpbx.ru"
    DOMAIN   = "experimentikum.onpbx.ru"

    FILE_CONFIG = Rails.application.credentials.online_pbx
    API_KEY  = FILE_CONFIG && FILE_CONFIG[:api_key] || ENV['ONLINE_PBX_API_KEY']

    def connect
      @thread = Thread.new { run }
    end

    def run
      EM.run do
        url = "https://#{DOMAIN}:8093?key=#{API_KEY}&domain=#{DOMAIN}"
        ws = Faye::WebSocket::Client.new(url)

        ws.on :open do |event|
          p [:open]
        end

        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close, event.code, event.reason]
          ws = nil
        end
      end
    end
  end
end
