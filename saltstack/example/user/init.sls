#用户管理
admin:
  user.present:
    - shell: /bin/bash
    - home: /home/admin
    - uid: 500
    - gid: 300
    - password: '$1$Rz9mYVoV$47aviFN43h5/JJNl9FmSF1'
    - require:
      - group: app
user1:
  user.present:
    - uid: 501
user2:
  user.absent:
    - purge: True // 为True 删除用户家目录以及下面的文件（userdel -r）
    - force: True // 为True 即使用户当前在线也强制删除
