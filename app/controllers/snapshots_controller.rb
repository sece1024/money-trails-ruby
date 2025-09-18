class SnapshotsController < ApplicationController
  before_action :require_authentication
  before_action :set_snapshot, only: [ :show, :destroy ]

  def index
    @snapshots = Current.user.snapshots.recent.limit(50)
    @latest_snapshot = Current.user.snapshots.recent.first
    @total_asset_today = Snapshot.calculate_total_asset(Current.user)
  end

  def show
  end

  def create
    @snapshot = Snapshot.create_or_update_for_date(Current.user, Date.current)

    if @snapshot.persisted?
      redirect_to snapshots_path, notice: "快照已创建"
    else
      redirect_to snapshots_path, alert: "创建快照失败"
    end
  end

  def destroy
    @snapshot.destroy
    redirect_to snapshots_path, notice: "快照已删除"
  end

  private

  def set_snapshot
    @snapshot = Current.user.snapshots.find(params[:id])
  end
end
