require File.dirname(__FILE__) + '/../test_helper'

class GroupersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:groupers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_grouper
    assert_difference('Grouper.count') do
      post :create, :grouper => { }
    end

    assert_redirected_to grouper_path(assigns(:grouper))
  end

  def test_should_show_grouper
    get :show, :id => groupers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => groupers(:one).id
    assert_response :success
  end

  def test_should_update_grouper
    put :update, :id => groupers(:one).id, :grouper => { }
    assert_redirected_to grouper_path(assigns(:grouper))
  end

  def test_should_destroy_grouper
    assert_difference('Grouper.count', -1) do
      delete :destroy, :id => groupers(:one).id
    end

    assert_redirected_to groupers_path
  end
end
