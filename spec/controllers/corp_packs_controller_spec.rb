describe CorpPacksController do
  let(:corp_pack) { create(:corp_pack) }
  login_user

  describe "#index" do
    before(:each) do
      2.times { create(:corp_pack) }
    end

    it "should work" do
      get :index
      assert_response 200
    end
  end

  describe "#show" do
    xit "should work" do
      get :show, params: { id: corp_pack.id }
      assert_response 200
    end
  end

  describe "#new" do
    it "should work" do
      get :new
      assert_response 200
    end
  end

  describe "#create" do
    let(:create_params) { attributes_for(:new_corp_pack) }

    def create_request(params = {})
      post :create, params: { corp_pack: create_params.merge(params) }
    end

    it "should create new corp_pack" do
      expect { create_request }.to change { CorpPack.count }.from( 0 ).to( 1 )
    end

    it "should correctly update date and time and set datetime" do
      create_request(date: "01.01.2030", time: "17:45")
      corp_pack = CorpPack.first

      expect( corp_pack.date ).to eq( Date.new(2030, 1, 1) )
      expect( corp_pack.time ).to eq( "17:45" )

      expect( corp_pack.datetime ).to eq( Time.new(2030, 1, 1, 17, 45, 0) )
    end
  end

  describe "#edit" do
    it "should work" do
      get :edit, params: { id: corp_pack.id }
      assert_response 200
    end
  end


  describe "#update" do
    let(:new_email) {
      'edited_email@whatever.com'
    }

    let(:update_params) {
      { date: corp_pack.date, time: "15:00" }
    }

    def update_request(params = {})
      patch :update, params: { id: corp_pack.id, corp_pack: update_params.merge(params) }
    end

    it "should redirect to corp_packs listing" do
      # request
      # expect(response).to redirect_to(corp_packs_path) # TODO this variant fails( find out why..
      expect(update_request).to redirect_to(corp_packs_path) # TODO this variant fails( find out why..
    end

    it "should update corp_pack fields" do
      expect { update_request }.to change { corp_pack.reload.time }
      expect(corp_pack.reload.time).to eq("15:00")
    end

    describe("date and time") do
      let(:update_params) {
        { date: corp_pack.date, time: "" }
      }

      it "should require presence of time" do
        expect { update_request(time: "") }.to_not change { corp_pack.reload.time }
        expect(response).to render_template('corp_packs/new')
      end

      it "should require presence of date" do
        expect { update_request(date: "") }.to_not change { corp_pack.reload.date }
        expect(response).to render_template('corp_packs/new')
      end


      it "should correctly update date and time and set datetime" do
        update_request(date: "01.01.2030", time: "17:45")
        corp_pack.reload

        expect( corp_pack.date ).to eq( Date.new(2030, 1, 1) )
        expect( corp_pack.time ).to eq( "17:45" )

        expect( corp_pack.datetime ).to eq( Time.new(2030, 1, 1, 17, 45, 0) )
      end

    end
  end


end
