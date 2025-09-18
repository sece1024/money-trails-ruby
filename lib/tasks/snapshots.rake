namespace :snapshots do
  desc "Create daily snapshots for all users"
  task daily: :environment do
    puts "Creating daily snapshots for all users..."
    Snapshot.create_daily_snapshots
    puts "Daily snapshots created successfully!"
  end

  desc "Create weekly snapshots for all users (only runs on Monday)"
  task weekly: :environment do
    puts "Creating weekly snapshots for all users..."
    Snapshot.create_weekly_snapshots
    puts "Weekly snapshots created successfully!"
  end

  desc "Create monthly snapshots for all users (only runs on 1st day of month)"
  task monthly: :environment do
    puts "Creating monthly snapshots for all users..."
    Snapshot.create_monthly_snapshots
    puts "Monthly snapshots created successfully!"
  end

  desc "Create snapshot for specific user"
  task :create_for_user, [ :user_id ] => :environment do |t, args|
    user_id = args[:user_id]
    if user_id.blank?
      puts "Usage: rake snapshots:create_for_user[USER_ID]"
      exit 1
    end

    user = User.find(user_id)
    puts "Creating snapshot for user: #{user.full_name} (#{user.email_address})"
    snapshot = Snapshot.create_or_update_for_date(user)
    puts "Snapshot created: #{snapshot.snapshot_date} - ¥#{snapshot.total_asset}"
  end

  desc "Show snapshot statistics"
  task stats: :environment do
    total_snapshots = Snapshot.count
    total_users = User.count
    latest_snapshot = Snapshot.recent.first

    puts "=== Snapshot Statistics ==="
    puts "Total snapshots: #{total_snapshots}"
    puts "Total users: #{total_users}"
    puts "Latest snapshot: #{latest_snapshot&.snapshot_date || 'None'}"
    puts "Average snapshots per user: #{total_users > 0 ? (total_snapshots.to_f / total_users).round(2) : 0}"
  end
end
