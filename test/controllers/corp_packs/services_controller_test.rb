require 'test_helper'

class CorpPacks::ServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get corp_packs_services_index_url
    assert_response :success
  end

end
