describe OnlinePbx::EventsController do
  describe "post #create" do
    def webhook_params
      {
        :"domain" => "onlinepbx.ru",
        :"event" => "call_start",
        :"direction" => "outbound",
        :"uuid" => "d02d3dd1-36f9-41g8-9055-3139369h6h90",
        :"caller" => "505",
        :"callee" => "79111117960",
        :"from_domain" => "onlinepbx.ru",
        :"to_domain" => "",
        :"gateway" => "74991111282",
        :"date" => "1528886454"
      }
    end

    def webhook_end_params
      {
        :"domain" => "onlinepbx.ru",
        :"event" => "call_end",
        :"direction" => "outbound",
        :"uuid" => "d02d3dd1-36f9-41g8-9055-3139369h6h90",
        :"caller" => "505",
        :"callee" => "79111117960",
        :"from_domain" => "onlinepbx.ru",
        :"to_domain" => "",
        :"gateway" => "74991111282",
        :"date" => "1528886454",
        :"call_duration" => "149",
        :"dialog_duration" => "135",
        :"hangup_cause" => "NORMAL_CLEARING",
        :"hangup_by" => "caller"
      }
    end

    def send_request
      post :create, params: webhook_params
    end

    def send_end_request
      post :create, params: webhook_end_params
    end

    it "should work" do
      send_request
      assert_response 200
    end

    it "should create Call in db" do
      send_request
      expect(Call.count).to eq(1)
      call = Call.first

      expect(call.uuid).to eq(webhook_params[:uuid])
      expect(call.caller).to eq(webhook_params[:caller])
      expect(call.to).to eq(webhook_params[:callee])
      expect(call.call_type).to eq(webhook_params[:direction])
      expect(call.time).to eq(Time.at(webhook_params[:date].to_i))
    end

    it "should update call with the same uuid on end webhook" do
      send_request
      send_end_request

      expect(Call.count).to eq(1)
      call = Call.first

      expect(call.duration).to eq(149)
    end
  end
end



# Пропущенный звонок
# {
#
# "domain":"onlinepbx.ru",
# "event":"call_missed",
# "uuid":"5329a333-ss32-4dd9-ff0f-gh84g32h5g22",
# "caller":"79221111123",
# "from_domain":"onlinepbx.ru",
# "to_domain":"onlinepbx.ru",
# "gateway":"73431111137",
# "date":"1529406933"
# }



# Ответили на звонок
# {
# "domain":"onlinepbx.ru",
# "event":"call_answered",
# "direction":"outbound",
# "uuid":"2c033c12-7310-4v4v-9b42-8bb207b17322",
# "caller":"505",
# "callee":"79111117799",
# "to_domain":"",
# "gateway":"74991111112",
# "date":"1528888621"
# }



# Начался звонок
# {
# "domain":"onlinepbx.ru",
# "event":"call_start",
# "direction":"outbound",
# "uuid":"d02d3dd1-36f9-41g8-9055-3139369h6h90",
# "caller":"505",
# "callee":"79111117960",
# "from_domain":"onlinepbx.ru",
# "to_domain":"",
# "gateway":"74991111282",
# "date":"1528886454"
# }


# Завершился звонок

# {
# "domain":"onlinepbx.ru",
# "event":"call_end",
# "direction":"outbound",
# "uuid":"6q5qq87q-0w32-4e23-8570-3r6rr6rrrr2r",
# "caller":"145",
# "callee":"79502222919",
# "from_domain":"onlinepbx.ru",
# "to_domain":"onlinepbx.ru",
# "gateway":"74991111282",
# "date":"1528884937",
# "call_duration":"149",
# "dialog_duration":"135",
# "hangup_cause":"NORMAL_CLEARING",
# "hangup_by":"caller"
# }
