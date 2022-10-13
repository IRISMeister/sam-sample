# System Alerting and Monitoring (SAM) 
https://github.com/intersystems-community/sam を事前展開したもの、プラスアルファ。

オリジナルを変更している。
1. 監視対象のirisとしてiris1:52773, iris2:52773を自動起動している。

2. alerts managerを公開している。

## 起動
```
$ cd sam-<version>
$ ./start.sh
```
   
The first time you run SAM, Docker takes several seconds 
(depending on your network) to pull the various containers. 
When the command is finished (and on subsequent runs), you should 
see the following lines confirming that SAM is up and running:   
```  
Creating sam_iris_1 ... done  
Creating sam_prometheus_1 ... done  
Creating sam_grafana_1    ... done   
Creating sam_alertmanager_1 ... done  
Creating sam_nginx_1      ... done  
```   
   
You can verify that all four containers are running by via *docker ps*, such as: or 
```
$ docker-compose -p sam ps
       Name                     Command                       State                                   Ports
------------------------------------------------------------------------------------------------------------------------------------
sam_alertmanager_1   /bin/alertmanager --config ...   Up                      9093/tcp
sam_grafana_1        /run.sh                          Up                      3000/tcp
sam_iris-init_1      chown -R 51773:51773 /dur        Exit 0
sam_iris1_1          /tini -- /iris-main --chec ...   Up (health: starting)   0.0.0.0:1972->1972/tcp,:::1972->1972/tcp, 2188/tcp,
                                                                              0.0.0.0:52773->52773/tcp,:::52773->52773/tcp,
                                                                              53773/tcp, 54773/tcp
sam_iris2_1          /tini -- /iris-main --chec ...   Up (health: starting)   1972/tcp, 2188/tcp, 52773/tcp, 53773/tcp, 54773/tcp
sam_iris_1           /tini -- /iris-main --chec ...   Up (health: starting)   1972/tcp, 2188/tcp,
                                                                              0.0.0.0:52774->52773/tcp,:::52774->52773/tcp,
                                                                              53773/tcp, 54773/tcp
sam_nginx_1          nginx -g daemon off;             Up                      80/tcp, 0.0.0.0:8080->8080/tcp,:::8080->8080/tcp
sam_prometheus_1     /bin/prometheus --web.enab ...   Up                      9090/tcp

```
## アラートのテスト
```
$ docker compose -p sam exec iris1 iris session iris
USER>Do ##class(%SYS.System).WriteToConsoleLog("Severe error xxx",,2)
```

## 停止 
```$ ./stop.sh```

## 完全削除
```$ ./rm.sh```

## CONNECT TO SAM WITH YOUR BROWSER
In your browser, visit:  
	```http://<ip-address-of-host-where-SAM-runs>:8080/api/sam/app/index.csp```  
You'll be prompted to login. You can use standard InterSystems IRIS credentials like _SYSTEM/SYS. You'll be prompted to change the password.

## LEARN MORE ABOUT SAM
[SAM documentation](https://docs.intersystems.com/sam/csp/docbook/Doc.View.cls?KEY=ASAM)

[IRIS native Prometheus exporter documentation](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCM_rest)

## 番外編
SAMを使用せず、prometheus + Grafanaだけを利用する方法は[こちら](nosam/README.md)。
