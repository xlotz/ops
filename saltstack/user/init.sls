#用户管理
admin:
  user.present:
    - shell: /bin/bash
    - home: /home/admin
    - uid: 500
user1:
  user.present:
    - udi: 501
user2:
  user.absent:
    - purge: True // 为True 删除用户家目录以及下面的文件（userdel -r）
    - force: True // 为True 即使用户当前在线也强制删除
