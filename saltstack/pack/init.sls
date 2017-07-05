#包管理
#如在linux下即调用系统yum命令安装相关包，常用于初始化环境或者其他模块调用依赖

install_packages:
  pkg.latest:
    - pkgs:
      - aspell
      - ncurses
      - ncurses-devel
      - pcre-devel
      - telnet
      - libcurl
      - libcurl-devel