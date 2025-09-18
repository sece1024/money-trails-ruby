# 资产快照功能

## 功能概述

资产快照功能允许用户自动或手动记录特定日期的总资产情况，支持每日、每周、每月的自动快照创建。

## 主要功能

### 1. 自动快照创建
- **每日快照**: 每天凌晨1点自动创建所有用户的资产快照
- **每周快照**: 每周一凌晨2点自动创建所有用户的资产快照
- **每月快照**: 每月1号凌晨3点自动创建所有用户的资产快照

### 2. 手动快照创建
用户可以通过Web界面手动创建当前日期的资产快照。

### 3. 快照查看和管理
- 查看快照历史列表
- 查看特定快照的详细信息
- 删除不需要的快照

## 技术实现

### 模型层 (Snapshot)
- `calculate_total_asset(user)`: 计算用户的总资产（资产 - 负债）
- `create_or_update_for_date(user, date)`: 创建或更新指定日期的快照
- `create_daily_snapshots`: 为所有用户创建每日快照
- `create_weekly_snapshots`: 为所有用户创建每周快照
- `create_monthly_snapshots`: 为所有用户创建每月快照

### 控制器层 (SnapshotsController)
- `index`: 显示快照列表和当前总资产
- `show`: 显示特定快照的详细信息
- `create`: 创建新的快照
- `destroy`: 删除快照

### 视图层
- `index.html.erb`: 快照列表页面，显示当前总资产、最新快照和快照历史
- `show.html.erb`: 快照详情页面，显示快照信息和资产构成分析

### 定时任务配置
在 `config/recurring.yml` 中配置了三个定时任务：
- `daily_snapshots`: 每日快照任务
- `weekly_snapshots`: 每周快照任务  
- `monthly_snapshots`: 每月快照任务

## 使用方法

### Web界面使用
1. 访问 `/snapshots` 查看快照列表
2. 点击"创建今日快照"按钮手动创建快照
3. 点击"查看"查看快照详情
4. 点击"删除"删除不需要的快照

### Rake任务使用
```bash
# 手动创建所有用户的每日快照
rake snapshots:daily

# 手动创建所有用户的每周快照
rake snapshots:weekly

# 手动创建所有用户的每月快照
rake snapshots:monthly

# 为特定用户创建快照
rake snapshots:create_for_user[USER_ID]

# 查看快照统计信息
rake snapshots:stats
```

## 数据计算逻辑

总资产 = 所有资产账户余额 - 所有负债账户余额

其中：
- 资产账户余额 = 初始余额 + 所有交易金额之和
- 负债账户余额 = 初始余额 + 所有交易金额之和

## 注意事项

1. 每个用户每天只能有一个快照记录
2. 快照创建时会自动计算当前的总资产
3. 定时任务只在生产环境中运行
4. 快照记录会永久保存，除非手动删除
5. 建议定期清理过期的快照记录以节省存储空间
