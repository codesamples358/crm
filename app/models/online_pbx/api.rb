module OnlinePbx
  class Api
    ApiError = Class.new StandardError

    URL_BASE = "api.onlinepbx.ru/experimentikum.onpbx.ru"

    FILE_CONFIG = Rails.application.credentials.online_pbx
    API_KEY  = FILE_CONFIG && FILE_CONFIG[:api_key] || ENV['ONLINE_PBX_API_KEY']

    attr_reader :key, :key_id

    delegate :post, to: RestClient

    def __call(method, params=nil)
      retryable(tries: 3) do
        params_json = authenticated(method, params)
        response = post URL, params_json
        JSON(response).fetch('data') { raise ApiError, response }
      end
    end

    def url(relative_url)
      "https://" + URL_BASE + '/' + relative_url
    end

    def api_url(path)
      URL_BASE + '/' + path
    end

    def call(rel_url, params)
      auth_url = url rel_url
      response = post auth_url, params
      JSON(response)
    end

    KEY_FILE = "#{Rails.root}/tmp/onpbx.yml"

    def load_keys
      if File.exists?(KEY_FILE) && File.mtime(KEY_FILE) > 2.5.days.ago && (yaml = YAML.load_file(KEY_FILE))
        @key    = yaml[:key]
        @key_id = yaml[:key_id]
      end
    end

    def auth
      response = call 'auth.json', { auth_key: API_KEY }

      if response['status'] == 1
        # success

        @key    = response['data']['key']
        @key_id = response['data']['key_id']

        File.write(KEY_FILE, {key: @key, key_id: @key_id}.to_yaml)
      else
        puts response
      end
    end

    def history(params)
      signed_call "history/search.json", params
    end

    def calls_on(date)
      date_from = date.rfc2822
      date_to   = (date + 1).rfc2822

      history(date_from: date_from, date_to: date_to)
    end

    def calls_from(date)
      date_from = date.rfc2822
      date_to   = (Date.today + 1).rfc2822

      history(date_from: date_from, date_to: date_to)
    end

    def call_by_uuid(uuid)
      history(uuid: uuid)
    end

    def today_calls
      calls_on Date.today
    end

    def generate_signature(method, params, date, content_type, rel_url)
      body           = URI.encode_www_form(params).gsub("+", "%20")
      body_md5       = Digest::MD5.hexdigest(body)
      string_to_sign = method + "\n" + body_md5 + "\n" + content_type + "\n" + date + "\n" + rel_url + "\n"

      digest = OpenSSL::Digest.new('sha1')
      hmac   = OpenSSL::HMAC.hexdigest(digest, @key, string_to_sign)

      signature = Base64.encode64 hmac
      [signature, body, body_md5]
    end


    def signed_call(path, params)
      load_keys unless @key
      auth      unless @key


      method       = 'POST'
      rel_url      = api_url path

      date         = Time.now.utc.rfc2822.gsub("-0000", "GMT")
      content_type = 'application/x-www-form-urlencoded; charset=UTF-8;'

      signature, body, body_md5 = generate_signature method, params, date, content_type, rel_url

      headers = {
        'x-pbx-date'           => date,
        'Accept'               => 'application/json',
        'Content-Type'         => content_type,
        'Content-MD5'          => body_md5,
        'x-pbx-authentication' => @key_id+':'+signature
      }

      response = post(url(path), body, headers)
      JSON response
    end

    def authenticated(method, params)
      request_params = {
        method:         method,
        param:          params,
        application_id: key,
        token:          token
      }

      JSON request_params
    end
  end
end
