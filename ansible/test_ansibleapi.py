#!/usr/bin/env python
# coding:utf-8

#官网示例

import sys
import ansible.runner

results = ansible.runner.Runner(
    pattern='*',
    module_name='shell',
    module_args='/usr/bin/uptime',
    forks=10,
).run()

if results is None:
    print "No hosts found"
    sys.exit(1)

print "UP "+"*"*10
for (hostname, result) in results['contacted'].items():
    if not 'failed' in result:
        print "%s >>> %s"%(hostname, result['stdout'])

print "FAILED "+"*"*10
for (hostname, result) in results['contacted'].items():
    if not 'failed' in result:
        print "%s >>> %s"%(hostname, result['stdout'])

print "DOWN "+"*"*10
for (hostname, result) in results['dark'].items():
    print "%s >>> %s"%(hostname, result)
