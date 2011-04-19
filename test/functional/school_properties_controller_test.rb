require 'test_helper'

class SchoolPropertiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_property" do
    assert_difference('SchoolProperty.count') do
      post :create, :school_property => { }
    end

    assert_redirected_to school_property_path(assigns(:school_property))
  end

  test "should show school_property" do
    get :show, :id => school_properties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => school_properties(:one).to_param
    assert_response :success
  end

  test "should update school_property" do
    put :update, :id => school_properties(:one).to_param, :school_property => { }
    assert_redirected_to school_property_path(assigns(:school_property))
  end

  test "should destroy school_property" do
    assert_difference('SchoolProperty.count', -1) do
      delete :destroy, :id => school_properties(:one).to_param
    end

    assert_redirected_to school_properties_path
  end
end
