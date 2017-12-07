#!/bin/bash
## Check the existence of jstack command!
if ! which jstack &> /dev/null; then
    [ -n "$JAVA_HOME"  ] && [ -f "$JAVA_HOME/bin/jstack"  ] && [ -x "$JAVA_HOME/bin/jstack"  ] && {
            export PATH="$JAVA_HOME/bin:$PATH"
                
        } || {
                redEcho "Error: jstack not found on PATH and JAVA_HOME!"
                        exit 1
                            
    }
fi
 echo "ps -Leo pid , lwp,user,pcpu,pmem,cmd > / tmp/pthreads . log" >> /tmp/pthreads.log
 ps -Leo pid,lwp,user,pcpu,pmem,cmd >> /tmp/pthreads.log
 echo `date` >> /tmp/pthreads.log
 echo 'step 1 get the pid'
 pid=`ps aux|grep EventManagementService1|awk 'END {print $2}'`
 echo 'step 2 pstack ${pid}'
 echo ${pid} >> /tmp/pthreads.log
 pstack $pid >> /tmp/pthreads.log
 echo `date` >>/tmp/pthreads.log
 echo 'step 3 lsof -p'
 echo 'lsof -p $pid >> /tmp/sys-p-files.log' >> /tmp/sys-p-files.log
 lsof -p $pid>>/tmp/sys-p-files.log
 echo 'step 4 jstack log'
 echo 'jstack -l $pid>>/tmp/jstack.log' >> /tmp/jstack.log
 jstack -l $pid >> /tmp/jstack.log
 echo `date`

 echo 'step 5 free -m' 
 echo 'free -m >>/tmp/free.log' >> /tmp/free.log
 free -m >> /tmp/free.log
 echo `date` >>/tmp/free.log
 echo 'step 6 vmstat' 
 echo 'vmstat 2 1 >>/tmp/vmstat.log' >> /tmp/vmstat.log
 vmstat 2 1 >> /tmp/vmstat.log
 echo 'step 7 jmap' 
 echo 'jmap -dump:format=b,file=/tmp/heap.hprof $pid' >> /tmp/jmap.log
 jmap -dump:format=b,file=/tmp/heap.hprof $pid >> /tmp/jmap.log
 echo `date` >> /tmp/jmap.log
 echo 'end' 
