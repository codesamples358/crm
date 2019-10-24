Snippet.add(:online_pbx) do
  on

  def api
    @api ||= OnlinePbx::Api.new
  end


  def ws_api
    @ws_api ||= OnlinePbx::WsApi.new
  end

  def today_calls
    t = Date.today.rfc2822
    n = (Date.today + 1).rfc2822

    api.load_keys
    api.history({date_from: t, date_to: n})
  end

  def hist_params
    t = Date.today.rfc2822
    n = (Date.today + 1).rfc2822
    {date_from: t, date_to: n}
  end

  def enc

    URI.encode_www_form(hist_params).gsub("+", "%20")
  end
end
