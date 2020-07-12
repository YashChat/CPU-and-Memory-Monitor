# CPU-and-Memory-Monitor
A script to monitor CPU and memory usage for a given process id.


Imagine that you are a system administrator and you want to write a script to monitor CPU and memory usage for a given process id. 
You would like to write a script that: 
(1) generates CPU and memory usage reports and stores them in a directory; and 
(2) notifies you by email whenever CPU or memory usage exceeds certain thresholds that you set.

In order to get usage information on UNIX-like operating systems, you will go to the directory /proc. 
This directory is a virtual filesystem which does not contain “real” files; /proc contains system runtime information 
(e.g. system memory, process information, hardware configuration, etc). 
Every process created in the operating system has its own directory under /proc/{pid}, where {pid} is a process id. 
All information relevant to the process with ID {pid} is stored under that directory (including how long the process has been running, 
its CPU usage, its memory usage, etc). You will need to dive into the /proc filesystem in order to monitor CPU and memory usage for a given process. 

For more information about the /proc filesystem, run the command “man proc”. 
In order to list the processes running under your username, run the command: “ps -u $USER”.

The skeleton code in monitor.sh has several instructional comments to guide you through your implementation. 
You will also find a script called “script-consumer.sh”, which is a script that you can use to test the monitor with 
(it allocates a lot of memory and has a relatively high CPU usage). 

Note that you do not need to test the monitor with that script, but you may find it helpful.

Implementing the CPU Monitor

First, let’s focus on implementing the monitor script for CPU usage. Your script should support inputs in the following format:

./monitor.sh {process id} -cpu {cpu usage percentage} {maximum reports} {time interval}

Note that {X} indicates that X is a mandatory argument. In the above shell command, a number of inputs are required:
process id: the process id of the process to be monitored.
cpu usage percentage: the percentage of CPU usage that the process should not exceed. If this is exceeded, a report will be generated.
maximum reports: the maximum number of usage reports stored in the “./reports_dir” directory.
time interval: a time in seconds. This represents the amount of time which should pass between checks of CPU usage. 

Fortunately, information about CPU usage is readily available to you through the /proc filesystem; 
the file /proc/{pid}/stat provides a set of values separated with whitespaces. 
We will use two of these values to calculate CPU usage:
Column #14 utime - CPU time in user mode
Column #15 stime - CPU time in kernel mode
Both of the above values are given in jiffies. A jiffy is 1/100 seconds.

You will need to parse the file  /proc/{pid}/stat to extract the above values from the indicated column numbers. 
awk is a powerful tool that allows you to extract text sections that match certain patterns from text files.

The skeleton code monitor.sh includes a function “jiffies_to_percentage” that will take the above values 
(measured before and after {time interval}) in jiffies and convert them into a CPU usage percentage over the provided time period {time interval}.

In order to catch a usage spike early, we are only interested in measuring CPU usage over the period {time interval}. 
For example, if the time interval is 5 seconds, then you will always report the CPU usage for the last 5 seconds 
(and not from the time the monitored process started). 

One way to check if the CPU usage percentages you are computing are reasonable is to compare them to those reported by the command top
CPU usage report
You will generate usage reports containings CPU usage information. The reports should be stored in the subdirectory “~/cs252/lab2-src/reports_dir/”. 
Each report should use the following format:

PROCESS ID: {pid}
PROCESS NAME: {name of the process, extracted from column 2 in /proc/{pid}/stat}
CPU USAGE: {CPU usage percentage}

There should be no more than the specified maximum number of reports ({maximum reports}) in the reports subdirectory. When this limit is reached, the script should delete the oldest report and replace it with the newest one; this way only the most recent set of reports will be kept.

Email notification
Whenever the CPU usage exceeds the provided maximum CPU usage, an email is sent to the current user ($USER) containing the last usage report.

Implementing the Memory Monitor

Now, let’s implement memory monitoring for processes. 
Your script will now take extra arguments to indicate the maximum physical memory that the process should not exceed.

monitor {process id} -cpu {cpu usage percentage} -mem {maximum memory in kB} {maximum reports} {time interval}

The physical memory used by the process is found in the file /proc/{pid}/status. You should extract the value of “VmRSS”. 
As opposed to CPU usage, we are  now interested in measuring the used memory from the time the process started.

CPU and Memory Usage Report
Expand the CPU Usage report to contain a field for memory as well.

PROCESS ID: {pid}
PROCESS NAME: {name of the process, extracted from column 2 in /proc/{pid}/stat}
CPU USAGE: {CPU usage percentage}
MEMORY USAGE: {memory usage in kB}

Email notification
Whenever the memory usage exceeds the provided maximum memory, an email is sent to $USER containing the last usage report. At this point, your script should be generating reports if a user exceeds either the memory or CPU threshold.

