require File.dirname(__FILE__) + '/../test_helper'

class AdvertsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:adverts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_advert
    assert_difference('Advert.count') do
      post :create, :advert => { }
    end

    assert_redirected_to advert_path(assigns(:advert))
  end

  def test_should_show_advert
    get :show, :id => adverts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => adverts(:one).id
    assert_response :success
  end

  def test_should_update_advert
    put :update, :id => adverts(:one).id, :advert => { }
    assert_redirected_to advert_path(assigns(:advert))
  end

  def test_should_destroy_advert
    assert_difference('Advert.count', -1) do
      delete :destroy, :id => adverts(:one).id
    end

    assert_redirected_to adverts_path
  end
end
