require 'test_helper'

class CorpPackServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get corp_pack_services_index_url
    assert_response :success
  end

  test "should get create" do
    get corp_pack_services_create_url
    assert_response :success
  end

  test "should get new" do
    get corp_pack_services_new_url
    assert_response :success
  end

  test "should get edit" do
    get corp_pack_services_edit_url
    assert_response :success
  end

  test "should get update" do
    get corp_pack_services_update_url
    assert_response :success
  end

  test "should get destroy" do
    get corp_pack_services_destroy_url
    assert_response :success
  end

end
