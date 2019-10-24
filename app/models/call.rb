class Call < ApplicationRecord
  scope :recent,  -> { order( "time desc")   }
  scope :inbound, -> { where(call_type: 'inbound')  }
  scope :outbound, -> { where(call_type: 'outbound') }

  scope :today, -> { where(time: (Time.now.at_midnight .. Time.now))}

  ATTR_VALUES = {
    status: [ 'Новый', 'В работе', 'В корзине' ]
  }

  def self.import(date = Date.today, api_method = :calls_on)
      calls = OnlinePbx::Api.new.send(api_method, date)["data"]

    calls.each do |call|
      update_from_api!(call)
    end
  end

  def self.import_from(date = 1.week.ago.to_date)
    import(date, :calls_from)
  end

  def self.update_from_api!(call_json)
    call = Call.where(uuid: call_json.delete('uuid')).first_or_create
    call.update_from_api!(call_json)
  end

  def update_from_api!(call_json)
    attrs = call_json.dup
    attrs['time'] = Time.at attrs.delete('date').to_i
    attrs['call_type'] = attrs.delete('type')

    # %(duration billsec).each do |attr|
    #   call_json[attr] = call_json[attr].to_i
    # end

    self.attributes = attrs
    save!
  end

  def self.update_from_webhook!(params)
    call = Call.where(uuid: params[:uuid]).first_or_create
    call.update_from_webhook!(params)
  end

  def update_from_webhook!(params)
    call_params = {}

    [:from_domain, :to_domain, :gateway, :caller, :hangup_cause].each do |param|
      call_params[param] = params[param]
    end

    {duration: :"call_duration", billsec: :"dialog_duration", to: :callee, call_type: :direction}.each do |param, param_alias|
      call_params[param] = params[param_alias]
    end

    call_params[:time] = Time.at params["date"].to_i
    self.attributes = call_params
    save!
  end

  def time_tag
    time.strftime("[%H:%M] %d.%m.%Y")
  end

  def data(options = {})
    options.merge(uuid: self.uuid)
    response = OnlinePbx::Api.new.history options.merge(uuid: self.uuid)

    if response['status'] == 1
      data = response['data']
      data.is_a?(Array) ? data[0] : data
    end
  end

  def download_link
    data(download: 1)
  end
end
