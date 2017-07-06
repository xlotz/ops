# Managed by Puppet
JAVA_HOME=/usr/local/jdk
JRE_Home=/usr/local/jdk/jre
CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH:$HOME/bin:/bin:/usr/sbin
export JAVA_HOME JRE_Home CLASSPATH PATH