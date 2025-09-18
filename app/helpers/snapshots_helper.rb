module SnapshotsHelper
  def format_currency(amount)
    number_with_delimiter(amount, delimiter: ",")
  end

  def snapshot_date_format(date)
    date.strftime("%Y年%m月%d日")
  end

  def snapshot_datetime_format(datetime)
    datetime.strftime("%Y-%m-%d %H:%M")
  end
end
