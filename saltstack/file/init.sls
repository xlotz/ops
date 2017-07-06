#文件管理
# 文件上传 file.managed
    name: 要同步到minion的文件路径和文件
    source: 同步文件源为master上的文件及路径
    backup: 有改动时备份
    backup: monion 会备份到minion下的/var/cache/salt/minion/backup_files目录下
    mode: 权限设置
    owner: 所属设置
    group: 所属组设置
# 文件附加内容 file.append

/usr/local/nginx-1.10.tar.gz
file.managed:
  - source:salt://nginx/nginx-xxxx.tar.gz
  - user: root
  - group: root
  - mode: 755
  - backup: minion
  - template: jinja

#先备份在minion端的目录/var/cache/salt/minion/file_backup下，然后上传，长期使用备份目录会增大，恢复可用salt命令恢复或者直接手动考备份文件均可

/etc/profile:
  file.append:
    - text:
      - "export JAVA_HOME=/usr/local/jdk1.7"
      - "export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH"
      - "exportCLASSPATH=$JAVA_HOME/lib/:$JAVA_HOME/jre/lib:$CLASSPATH"

#目录管理
# file.recurse 将目录下的所有文件覆盖到minion目录， 目录递归复制（rsync）,
# 如果master 端减少文件， minion端默认不会删除
makedirs: 目录不存在就创建(mkdir -p)
recurse: 属性权限递归到文件夹的文件上
user: 目录所属用户
group: 目录所属组
mode: 文件权限
dir_mode: 目录权限
file_mode: 文件夹下文件权限


# copy 目录
/usr/local/nginx/conf:
  file.recurse:
    - source: salt://nginx/conf
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - template: jinja
    - backup: minion
    - makedirs: True
    - include_empty: True
    - recurse:
      - user
      - group
      - mode
    - watch_in:
      - cmd: nginx_reload

# 新建目录
/web/logstash:
  file.directory:
     - user: web
     - group: web
     - file_mode: 644
     - dir_mode: 755
     - makedirs: True
     - include_empty: True
     - template: jinja
       - backup: minion


