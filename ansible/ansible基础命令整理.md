Ansible 学习

ansible 语法

        被管理组、机器             模块              内容
ansible <pattern_goes_here> -m <module_name> -a <arguments>

一、模块：

1.command 模块 // 默认模块，用于在各个被管理几点运行指定的命令（不支持管道和变量）
eg.
$ ansible all -m command -a "hostname"
hadoop.so.com | SUCCESS | rc=0 >>
hadoop.so.com

2.shell 模块  // 与command 模块功能相同，但比command 模块功能强大（支持管道和变量）
eg.
# ansible all -m shell -a "cat /etc/passwd|grep root"
hadoop.so.com | SUCCESS | rc=0 >>
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin

3.user 模块  // 用户模块，用于在各管理节点管理用户使用
eg.
（创建一个test用户，uid=505,home_path=/home/test, shell 是nologin）

# ansible hadoop.so.com -m user -a 'name=test uid=505 home=/home/test shell=/sbin/nologin'
hadoop.so.com | SUCCESS => {
    "changed": true,
    "comment": "",
    "createhome": true,
    "group": 505,
    "home": "/home/test",
    "name": "test",
    "shell": "/sbin/nologin",
    "state": "present",
    "system": false,
    "uid": 505
}
# ansible hadoop.so.com -m shell -a "cat /etc/passwd|grep test"
hadoop.so.com | SUCCESS | rc=0 >>
test:x:505:505::/home/test:/sbin/nologin

(删除用户)
eg.
# ansible hadoop.so.com -m user -a "name=test uid=505 state=absent remove=yes" // remove=yes 删除家目录
hadoop.so.com | SUCCESS => {
    "changed": true,
    "force": false,
    "name": "test",
    "remove": false,
    "state": "absent"
}
# ansible hadoop.so.com -m shell -a "cat /etc/passwd|grep test"
hadoop.so.com | FAILED | rc=1 >>


4.group 模块  // 用户组模块
eg.
# ansible hadoop.so.com -m group -a "name=testgroup gid=1000"
hadoop.so.com | SUCCESS => {
    "changed": true,
    "gid": 1000,
    "name": "testgroup",
    "state": "present",
    "system": false
}
# ansible hadoop.so.com -m shell -a "cat /etc/group|grep testgroup"
hadoop.so.com | SUCCESS | rc=0 >>
testgroup:x:1000:

5.cron 模块 计划定时任务，用户在各管理节点管理计划任务 (切换用户使用 -S -R)
eg.
#ansible all -m cron -a "name=time minute='*/2' job='/usr/sbin/ntpdate'"
hadoop.so.com | SUCCESS => {
    "changed": true,
    "envs": [],
    "jobs": [
        "time"
    ]
}
# ansible all -m shell -a "crontab -l"
hadoop.so.com | SUCCESS | rc=0 >>
#Ansible: time
*/2 * * * * /usr/sbin/ntpdate

6.copy 模块  // 复制文件或目录到节点
eg:
# ansible all -m copy -a "src=/root/test.py dest=/tmp mode=644 owner=test"
hadoop.so.com | SUCCESS => {
    "changed": true,
    "checksum": "bfdfd0908a275ee501a1b4cd9daf1881acde6dbe",
    "dest": "/tmp/test.py",
    "gid": 0,
    "group": "root",
    "mode": "0644",
    "owner": "test",
    "path": "/tmp/test.py",
    "size": 783,
    "state": "file",
    "uid": 507
}

# ansible all -m shell -a 'ls -l /tmp'
hadoop.so.com | SUCCESS | rc=0 >>
-rw-r--r--  1 test root  783 6月  30 21:22 test.py


7.file 模块   // 文件模块， 修改各个文件的属性
注：state的其他选项：link(链接)、hard(硬链接)
（创建文件或目录）
eg.
# ansible all -m file -a 'path=/tmp/test.py mode=777 owner=root'
hadoop.so.com | SUCCESS => {
    "changed": true,
    "gid": 0,
    "group": "root",
    "mode": "0777",
    "owner": "root",
    "path": "/tmp/test.py",
    "size": 783,
    "state": "file",
    "uid": 0
}
# ansible all -m shell -a 'ls -l /tmp'
hadoop.so.com | SUCCESS | rc=0 >>
-rwxrwxrwx  1 root root  783 6月  30 21:22 test.py

eg.
# ansible all -m file -a 'dest=/tmp/tt.txt mode=733 owner=root group=root state=directory'
hadoop.so.com | SUCCESS => {
    "changed": true,
    "gid": 0,
    "group": "root",
    "mode": "0733",
    "owner": "root",
    "path": "/tmp/tt.txt",
    "size": 4096,
    "state": "directory",
    "uid": 0
}
# ansible all -m shell -a 'ls -l /tmp'
hadoop.so.com | SUCCESS | rc=0 >>
drwx-wx-wx  2 root root 4096 6月  30 21:34 tt.txt

(删除文件或目录)
eg.
# ansible all -m file -a 'dest=/tmp/tt.txt state=absent'
hadoop.so.com | SUCCESS => {
    "changed": true,
    "path": "/tmp/tt.txt",
    "state": "absent"
}
# ansible all -m shell -a 'ls -l /tmp|grep tt.txt'
hadoop.so.com | FAILED | rc=1 >>

8.stat 模块  // 获取远程文件状态信息，包含 atime, ctime, mtime, md5, uid, gid 等
eg.
#ansible all -m stat -a 'path=/tmp/test.py'
hadoop.so.com | SUCCESS => {
    "changed": false,
    "stat": {
        "atime": 1498829327.2549946,
        "attr_flags": "e",
        "attributes": [
            "extents"
        ],
        "block_size": 4096,
...

9.template 模块    // 用于jinjia2格式的文件模板，每次都会被标记为change状态

10. yum 模块    // 用于管理节点安装软件所用
eg.
# ansible all -m yum -a 'name=nginx state=present'
卸载的软件只需要将 name=nginx state=absent
安装特定版本 name=nginx-1.6.2 state=present
指定某个源仓库安装软件包name=htop enablerepo=epel state=present
更新软件到最新版 name=nginx state=latest

11. service 模块 //管理各节点的服务
eg.
# ansible all -m service -a 'name=httpd enabled=true state=started'
hadoop.so.com | SUCCESS => {
    "changed": true,
    "enabled": true,
    "name": "httpd",
    "state": "started"
}

# ansible all -m shell -a "netstat -nltp|grep httpd"
hadoop.so.com | SUCCESS | rc=0 >>
tcp        0      0 :::80                       :::*                        LISTEN      4718/httpd

eg. 启动服务、判断服务是否启动
ansible testservers -m service -a "name=httpd state=started"

eg. 关闭服务、判断服务是否关闭
ansible testservers -m service -a "name=httpd state=stopped"

12. script 模块  // 自动复制脚本到远程节点，并运行
eg.
#cat test.sh
echo $(pwd)

#ansible all -m script -a "test.sh"
hadoop.so.com | SUCCESS => {
    "changed": true,
    "rc": 0,
    "stderr": "Shared connection to hadoop.so.com closed.\r\n",
    "stdout": "/root\r\n",
    "stdout_lines": [
        "/root"
    ]
}

13. setup 模块   // 用于实际ansible的facts信息
eg.
# ansible all -m setup
hadoop.so.com | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.16.33.138"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::20c:29ff:fef6:2df9"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
......

14. 其他

使用git
ansible testservers -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"

放到后台执行，不获取返回信息
ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"    // B 最多运行一个小时； P 每隔0秒获取一次状态信息

检查运行状态
ansible test1.so.com -m async_status -a "jid=488359678239.2844"

动态获取运行状态
ansible all -B 1800 -P 60 -a "/usr/bin/long_running_operation --do-stuff"



二、通配符
1、主机组可以作为另一个组的成员
[group1]
xxx
[group2]
xxx
[group-group1]
group1
group2

2、通配所有的主机
all

3、通配有特征的主机
a.so.com
b.so.com
==> .so.com
10.10.1.10
10.10.1.11
==> 10.10.1.

4、通配组，组名间用: 分开，表示or的意思
group1:group2

5、非模式，A组不在B组中
group1:!group2

6、交集模式， host同时在group1,group2组
group1:&group2

7、匹配组的第1到25个主机
group1[0-25]

8、匹配一个组的特定编号的主机，从0计算
group[0]

9、组合匹配
在 A 或者 B，必须在C，但不在D
A:B:&C:!D

10、大部分人都在patterns应用正则表达式,但你可以.只需要以 ‘~’ 开头即可:
~(web|db).*.example.com

11、同时让我们提前了解一些技能,除了如上,你也可以通过 --limit 标记来添加排除条件,/usr/bin/ansible or /usr/bin/ansible-playbook都支持:
ansible-playbook site.yml --limit datacenter2

12、如果你想从文件读取hosts,文件名以@为前缀即可.从Ansible 1.2开始支持该功能:
ansible-playbook site.yml --limit @retry_hosts.txt


三、yaml、playbook
yaml: 指定什么主机执行什么任务的一个列表

eg.
- hosts: hadoop.so.com  //主机
  remote_user: root  //执行任务用户
  tasks:            //任务,git获取代码放在本地
    - name: git clone
      git: repo=git@github.com:yourproject.git
           dest=/home/yourhome/git/
           accept_hostkey=yes
           force=yes
           recursive=no
           key_file=/home/user/.ssh/id_rsa.github-{{ item.repo }}

playbook: 主要文件是用来指定tasks
包含：
Inventory 主机库文件
modules   调用模块
Ad Hoc Commands 指定主机运行的命令
Playbooks 剧本文件
    tasks 任务，调用模块去执行某些命令
    varable 变量
    Template 模板
    Handlers 处理器，由某些事件触发某些行为
    Roles 角色

eg.

# webservice 服务运行
tasks:
  - name: make server running
    service: name="webservice" state="ruuning"
# 执行某个命令
tasks:
  - name: kill services
    shell: kill -9 {{service_PID}}
# 执行某个命令
tasks:
  - name: kill services
    shell: kill -9 {{service_PID}}
# 忽略脚本返回值
tasks:
  - name: some shell running
    shell: xxxxx.sh || /bin/true
# 忽略错误信息
tasks:
  - name: ignore errors
    shell: /tomcatpath/bin/startup.sh
    ignore_errors: True

YAML文件扩展名通常为.yaml，如example.yaml。
注意，代码的排版有严格要求，
    缩进为2个字符
    序列项的 - 后必须跟一个空格
    : 后也要跟一个空格
    list列表的所有元素均使用“-”打头
    dictionary字典通过key与valuef进行标识,也可以将key:value放置于{}中进行表示

