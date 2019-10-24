describe PlayersController do
  let(:player) { create(:player) }
  login_user

  describe "#index" do

    before(:each) do
      2.times { create(:player) }
    end

    it "should work" do
      get :index
      assert_response 200
    end
  end

  describe "#show" do
    xit "should work" do
      get :show, params: { id: player.id }
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
    let(:create_params) { attributes_for(:player) }

    def create_request(params = {})
      post :create, params: { player: create_params.merge(params) }
    end

    it "should create new player" do
      expect { create_request }.to change { Player.count }.from( 0 ).to( 1 )
    end
  end

  describe "#edit" do
    it "should work" do
      get :edit, params: { id: player.id }
      assert_response 200
    end
  end

  describe "#update" do
    let(:new_email) {
      'edited_email@whatever.com'
    }

    let(:make_request) {
      patch :update, params: { id: player.id, player: { email: new_email } }
    }

    it "should redirect to players listing" do
      # request
      # expect(response).to redirect_to(players_path) # TODO this variant fails( find out why..
      expect(make_request).to redirect_to(players_path) # TODO this variant fails( find out why..
    end

    it "should update user fields" do
      make_request
      expect(player.reload.email).to eq(new_email)
    end
  end


end
