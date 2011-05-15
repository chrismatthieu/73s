require File.dirname(__FILE__) + '/../test_helper'

class HambriefsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:hambriefs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_hambrief
    assert_difference('Hambrief.count') do
      post :create, :hambrief => { }
    end

    assert_redirected_to hambrief_path(assigns(:hambrief))
  end

  def test_should_show_hambrief
    get :show, :id => hambriefs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => hambriefs(:one).id
    assert_response :success
  end

  def test_should_update_hambrief
    put :update, :id => hambriefs(:one).id, :hambrief => { }
    assert_redirected_to hambrief_path(assigns(:hambrief))
  end

  def test_should_destroy_hambrief
    assert_difference('Hambrief.count', -1) do
      delete :destroy, :id => hambriefs(:one).id
    end

    assert_redirected_to hambriefs_path
  end
end
