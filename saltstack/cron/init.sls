# 定时任务
# 1、添加删除命令
salt '*' cron.set_job root 0 3 '*' '*' '*' "echo 'abc'" "mytest"
salt '*' cron.rm_job root "echo 'abc'"
# 2、sls

cron.present:
  - dientifier: test cron
  - user: root
  - minute: '0'
  - hour: '4'