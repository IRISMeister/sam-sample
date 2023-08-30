# Prometheus and Grafana only
prometheus + Grafanaだけ(SAM無し)で監視する試み。
dockerのvolume mountもcpfや各コンフィグ以外には使わないようにする。

利便性等のために、[grafana.ini](config/grafana/grafana.ini)をあれこれ(編集を許可、URLなど)変更している。[SAM用のものと](../sam-1.1.0.107-unix/config/grafana/grafana.ini)と比較すると変更点がわかる。

# 準備
webhookのテスト用に[webhook.site](https://webhook.site/)を利用する。起動する前に、同サイトにて自分用のURLを取得し、[isc_alertmanager.yml](config/alertmanager/isc_alertmanager.yml)のurlに上書き保存する。

```
- name: 'isc_sam_default'
  webhook_configs:
  - url: https://webhook.site/xxxxx-xxx-xxxx-xxxx-xxxxxxx
```

# 起動
```
$ cd nosam-1.1.0.107
$ docker compose up -d
```

# 各種エンドポイント

## IRIS metrics endpoint   

```
 $ curl http://localhost:52773/api/monitor/metrics
(prometheus内からは http://iris1:52773/api/monitor/metrics ) 

   ・
   ・
iris_glo_a_seize_per_sec 0
iris_glo_n_seize_per_sec 0
iris_glo_ref_per_sec 116
iris_glo_ref_rem_per_sec 0
iris_glo_seize_per_sec 0
iris_glo_update_per_sec 20
iris_glo_update_rem_per_sec 0
   ・
   ・
```

## IRIS alert endpoint

強制的にアラートレベルのメッセージを送信することで、テストできる。
```
$ docker compose exec iris1 iris session iris
USER> Do ##class(%SYS.System).WriteToConsoleLog("Severe error xxx",,2)

$ curl http://localhost:52773/api/monitor/metrics | grep alert
iris_system_alerts 1
iris_system_alerts_log 1
iris_system_alerts_new 1

$ curl http://localhost:52773/api/monitor/alerts
[{"time":"2022-10-07T07:19:55.997Z","severity":"2","message":"Severe error xxx"}]
```
一度alertsを取得すると、再取得されなくなる。また、metricsの_newが0に戻る。(つまり_newは未取得のalert件数)

```
$ curl http://localhost:52773/api/monitor/alerts
[]
$ curl http://localhost:52773/api/monitor/metrics | grep alert
iris_system_alerts 1
iris_system_alerts_log 1
iris_system_alerts_new 0
```


## prometheus U/I
http://localhost:9090/

node exporterの例
```
Expression: rate(node_cpu_seconds_total{mode="system"}[1m])
```

IRISの例
```
Expression: rate(iris_glo_ref_per_sec{instance="iris1:52773"}[1m])
```

PromQLを使用。
https://qiita.com/tatsurou313/items/64fcaae3567f24d13dd5

アラート(件数)の表示

http://localhost:9090/alerts

取得対象の表示

http://localhost:9090/targets

## Grafana U/I
http://localhost:3000

SAM Dashboardを選ぶとダッシュボードが表示できる。

Grafanaから見たprometheusのエンドポイントは、http://prometheus:9090/ になっている。[datasource.yml](config/grafana/datasource.yml)で指定している。

## alertmanager
http://localhost:9093  

prometheusのalertmanagerはアラート発生時にその情報を送信する先(mailやwebhook)を要する。SAMでは送信先がSAM用のirisインスタンスになっているが、ここではひとまず[webhook.site](https://webhook.site/)を利用している。

alertが発生すると、[このような](alert.json)がPOSTされるので、受信側はこの情報からalertの取得先URL(*)を生成し、必要な操作を行う。
> (*)アラート発生源の"instance": "iris1:52773"なので、iris1インスタンスのURL+/api/monitor/alerts  
> iris1はdocker-compose でport:52773で公開しているので、URLは、http://localhost:52773/api/monitor/alerts

```
$ curl http://localhost:52773/api/monitor/alerts
[{"time":"2022-10-13T02:09:10.554Z","severity":"2","message":"Severe error xxx"}]
```



## node exporter
テスト用のメトリック収集
```
$ curl http://localhost:9100/metrics
   ・
   ・
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 227229.61
node_cpu_seconds_total{cpu="0",mode="iowait"} 425.96
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 59.25
node_cpu_seconds_total{cpu="0",mode="softirq"} 191.11
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 311.73
node_cpu_seconds_total{cpu="0",mode="user"} 608.48
node_cpu_seconds_total{cpu="1",mode="idle"} 226832.41
node_cpu_seconds_total{cpu="1",mode="iowait"} 103.55
node_cpu_seconds_total{cpu="1",mode="irq"} 0
   ・
   ・
```

# 参考
https://amateur-engineer-blog.com/getting-started-prometheus/

