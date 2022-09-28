クラウド上のサービスとの連携を見据えて、prometheus + Grafanaだけで(SAM無しで)監視する試み。
volume mountもconfig以外には使わないようにする。

利便性等のために、prometheus/config/grafana/grafana.iniをあれこれ変更している。
sam-1.1.0.107-unix/config/grafana/grafana.iniと比較すると変更点がわかる。

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

prometheus U/I
http://localhost:9090/targets
http://localhost:9090/graph

node exporterの例
Expression: rate(node_cpu_seconds_total{mode="system"}[1m])

IRISの例
Expression: rate(iris_glo_ref_per_sec{instance="iris1:52773"}[1m])

Grafana U/I
http://localhost:3000

Grafanaから見たprometheusのエンドポイント
http://prometheus:9090/ --> datasource.ymlで指定

prometheus Alerts U/I
http://localhost:9093
未使用。機能させるには、下記のurl(samのエンドポイント)の代わりになるものが必要。
- name: 'isc_sam_default'
  webhook_configs:
  - url: http://iris:52773/api/sam/private/alerts


参考
https://amateur-engineer-blog.com/getting-started-prometheus/

