require 'test_helper'

class UtypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:utypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create utype" do
    assert_difference('Utype.count') do
      post :create, :utype => { }
    end

    assert_redirected_to utype_path(assigns(:utype))
  end

  test "should show utype" do
    get :show, :id => utypes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => utypes(:one).to_param
    assert_response :success
  end

  test "should update utype" do
    put :update, :id => utypes(:one).to_param, :utype => { }
    assert_redirected_to utype_path(assigns(:utype))
  end

  test "should destroy utype" do
    assert_difference('Utype.count', -1) do
      delete :destroy, :id => utypes(:one).to_param
    end

    assert_redirected_to utypes_path
  end
end
