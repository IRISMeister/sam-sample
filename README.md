# sam-sample
<PRE>
$ git clone https://github.com/IRISMeister/sam-sample.git
$ cd sam-sample/sam-1.0.0.115-unix
$ ./start.sh

SAM main page
http://<ip-address-of-host-where-SAM-runs>:8080/api/sam/app/index.csp

Portal
http://<ip-address-of-host-where-SAM-runs>:8080/csp/sys/%25CSP.Portal.Home.zen

Login as SuperUser/SYS .
Add new cluster.
name: (anything)

Add new instance.
ip : iris1
port: 52773
instance name: iris

$ ./stop.sh
Removes every thing (sam database, configurations).
You can start form scratch by ./start.sh .

</PRE>
