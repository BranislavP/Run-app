require 'test_helper'

class RunsControllerTest < ActionController::TestCase

  def setup
    @main_user = users(:main)
    @second_user = users(:secondary)
    @run = runs(:first)
  end

  test 'should view index when not logged in' do
    get :index
    assert flash.empty?, 'No message should be showm'
    assert_response :success, 'Should get index even when not logged in'
  end

  test 'should view index when logged in' do
    sign_in @main_user
    get :index
    assert flash.empty?, 'No message should be showm'
    assert_response :success, 'Should get index even when not logged in'
  end

  test 'Should not be able to get new when no logged in' do
    get :new
    assert_not flash.empty?, 'There should be a message'
    assert_redirected_to new_user_session_path
  end

  test 'Should get new when logged in' do
    sign_in @main_user
    get :new
    assert flash.empty?, 'No message should be showm'
    assert_response :success, 'Should get index even when not logged in'
  end

  test 'Should not be able to get edit when no logged in' do
    get :new
    assert_not flash.empty?, 'There should be a message'
    assert_redirected_to new_user_session_path
  end

  test 'Should get edit when logged in' do
    sign_in @main_user
    get :edit, params: {id: @run}
    assert flash.empty?, 'No message should be showm'
    assert_response :success, 'Should get index even when not logged in'
  end

  test 'Should no be able to get edit on non-existant run' do
    sign_in @main_user
    get :edit, params: {id: @run.id + 1}
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Not authorized', flash[:danger], 'Messages should be same'
    assert_redirected_to root_path
  end

  test 'Should not get edit on other users run' do
    sign_in @second_user
    get :edit, params: {id: @run.id}
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Not authorized', flash[:danger], 'Messages should be same'
    assert_redirected_to root_path
  end

  test 'Should not be able to create run when not logged in' do
    assert_no_difference 'Run.count' do
      post :create, params: {run: {distance: 2, duration: Time.now, date: Time.now}}
    end
    assert_not flash.empty?, 'Message should be shown'
    assert_redirected_to new_user_session_path
  end

  test 'should be able to create a new run when logged in' do
    sign_in @second_user
    assert_difference 'Run.count' do
      post :create, params: {run: {id: @run, distance: 2, duration: Time.now, date: Time.now}}
    end
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Run successfuly created', flash[:success], 'Message should be equal'
    assert_redirected_to runs_path
  end

  test 'Create should fail with insufficient parameters' do
    sign_in @second_user
    assert_no_difference 'Run.count' do
      post :create, params: {run: {id: @run, distance: 2}}
    end
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Creating run failed, please correct mistakes', flash[:danger], 'Message should be equal'
  end

  test 'Check params after creation' do
    sign_in @second_user
    time = Time.zone.now
    assert_difference 'Run.count' do
      post :create, params: {run: {id: @run, distance: 275, duration: time, date: time, user_id: @main_user.id - 2}}
    end
    run = Run.last
    assert_equal 275, run.distance, 'Values should be same'
    assert_not_equal @main_user.id - 2, run.user_id, 'Values should not be same'
  end

  test 'Should not be able to update run when not logged in' do
    time = Time.zone.now
    patch :update, params: {id: @run, run: {id: @run, distance: 275, duration: time, date: time}}
    assert_not flash.empty?, 'Message should be shown'
    assert_redirected_to new_user_session_path
  end

  test 'Should not be able to update other users run' do
    sign_in @second_user
    time = Time.zone.now
    patch :update, params: {id: @run, run: {id: @run, distance: 275, duration: time, date: time}}
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Not authorized', flash[:danger], 'Messages should be same'
    assert_redirected_to root_path
  end

  test 'should be able to update run when logged in as correct user' do
    sign_in @main_user
    time = Time.zone.now
    patch :update, params: {id: @run, run: {id: @run, distance: 275, duration: time, date: time}}
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Run successfuly updated', flash[:success], 'Message should be equal'
    assert_redirected_to runs_path
  end

  test 'Update should fail with insufficient parameters' do
    sign_in @main_user
    patch :update, params: {id: @run, run: {id: @run, distance: 275, duration: time, date: time}}
    assert_not flash.empty?, 'Message should be shown'
    assert_equal 'Updating run failed, please correct mistakes', flash[:danger], 'Message should be equal'
  end

  test 'Check params after update' do
    sign_in @main_user
    time = Time.zone.now
    patch :update, params: {id: @run, run: {id: @run, distance: 275, duration: time, date: time}}
    run = Run.last
    assert_equal 275, run.distance, 'Values should be same'
    assert_not_equal @main_user.id - 2, run.user_id, 'Values should not be same'
  end

end
