describe CallsController do
  let(:call) { create(:call) }
  login_user
  #
  # describe "#index" do
  #   before(:each) do
  #     2.times { create(:call) }
  #   end
  #
  #   it "should work" do
  #     get :index
  #     assert_response 200
  #   end
  # end
  #
  # describe "#show" do
  #   xit "should work" do
  #     get :show, params: { id: call.id }
  #     assert_response 200
  #   end
  # end
  #
  # describe "#edit" do
  #   it "should work" do
  #     get :edit, params: { id: call.id }
  #     assert_response 200
  #   end
  # end
  #
  #
  # xdescribe "#update" do
  #   let(:new_email) {
  #     'edited_email@whatever.com'
  #   }
  #
  #   let(:make_request) {
  #     patch :update, params: { id: call.id, call: { email: new_email } }
  #   }
  #
  #   it "should redirect to calls listing" do
  #     # request
  #     # expect(response).to redirect_to(calls_path) # TODO this variant fails( find out why..
  #     expect(make_request).to redirect_to(calls_path) # TODO this variant fails( find out why..
  #   end
  #
  #   it "should update user fields" do
  #     make_request
  #     expect(call.reload.email).to eq(new_email)
  #   end
  # end
  #

end
