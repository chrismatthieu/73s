require File.dirname(__FILE__) + '/../test_helper'

class GearsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:gears)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_gear
    assert_difference('Gear.count') do
      post :create, :gear => { }
    end

    assert_redirected_to gear_path(assigns(:gear))
  end

  def test_should_show_gear
    get :show, :id => gears(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => gears(:one).id
    assert_response :success
  end

  def test_should_update_gear
    put :update, :id => gears(:one).id, :gear => { }
    assert_redirected_to gear_path(assigns(:gear))
  end

  def test_should_destroy_gear
    assert_difference('Gear.count', -1) do
      delete :destroy, :id => gears(:one).id
    end

    assert_redirected_to gears_path
  end
end
