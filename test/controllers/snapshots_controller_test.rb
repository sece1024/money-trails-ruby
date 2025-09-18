require "test_helper"

class SnapshotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @snapshot = snapshots(:one)
  end

  test "should get index" do
    sign_in_as @user
    get snapshots_url
    assert_response :success
  end

  test "should get show" do
    sign_in_as @user
    get snapshot_url(@snapshot)
    assert_response :success
  end

  test "should create snapshot" do
    sign_in_as @user
    assert_difference("Snapshot.count") do
      post snapshots_url
    end

    assert_redirected_to snapshots_path
  end

  test "should destroy snapshot" do
    sign_in_as @user
    assert_difference("Snapshot.count", -1) do
      delete snapshot_url(@snapshot)
    end

    assert_redirected_to snapshots_path
  end
end
