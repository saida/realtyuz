require 'test_helper'

class MetroPropertiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metro_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metro_property" do
    assert_difference('MetroProperty.count') do
      post :create, :metro_property => { }
    end

    assert_redirected_to metro_property_path(assigns(:metro_property))
  end

  test "should show metro_property" do
    get :show, :id => metro_properties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => metro_properties(:one).to_param
    assert_response :success
  end

  test "should update metro_property" do
    put :update, :id => metro_properties(:one).to_param, :metro_property => { }
    assert_redirected_to metro_property_path(assigns(:metro_property))
  end

  test "should destroy metro_property" do
    assert_difference('MetroProperty.count', -1) do
      delete :destroy, :id => metro_properties(:one).to_param
    end

    assert_redirected_to metro_properties_path
  end
end
