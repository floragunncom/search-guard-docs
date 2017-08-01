# Using Search Guard with X-Pack Alerting

Zugriff auf watches

[2017-06-29T12:11:45,935][INFO ][c.f.s.c.IndexBaseConfigurationRepository] Node 'rj6PW6V' initialized
[2017-06-29T12:12:06,830][INFO ][c.f.s.c.PrivilegesEvaluator] No index-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=logstash-*, type=*]] [Action [indices:admin/mappings/fields/get]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:12:06,831][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {sg_public=[IndexType [index=logstash-*, type=*]], sg_human_resources=[IndexType [index=logstash-*, type=*]]}
[2017-06-29T12:12:22,419][INFO ][c.f.s.c.PrivilegesEvaluator] No cluster-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=_all, type=*]] [Action [indices:data/read/scroll]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:12:22,419][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {}

cluster:admin/xpack/watcher/watch/put

[2017-06-29T12:31:04,690][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {}
[2017-06-29T12:31:05,993][INFO ][o.e.x.w.a.l.ExecutableLoggingAction] [rj6PW6V] There are 79544 documents in your index. Threshold is 10.
[2017-06-29T12:31:07,067][INFO ][c.f.s.c.PrivilegesEvaluator] No cluster-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=_all, type=*]] [Action [cluster:monitor/xpack/watcher/watch/get]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:31:07,068][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {}
[2017-06-29T12:31:08,702][INFO ][c.f.s.c.PrivilegesEvaluator] No cluster-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=_all, type=*]] [Action [cluster:monitor/xpack/watcher/watch/get]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:31:08,702][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {}
[2017-06-29T12:31:12,037][INFO ][o.e.x.w.a.l.ExecutableLoggingAction] [rj6PW6V] There are 79569 documents in your index. Threshold is 10.
[2017-06-29T12:31:18,079][INFO ][o.e.x.w.a.l.ExecutableLoggingAction] [rj6PW6V] There are 79571 documents in your index. Threshold is 10.

[2017-06-29T12:35:26,619][INFO ][c.f.s.c.PrivilegesEvaluator] No cluster-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=_all, type=*]] [Action [cluster:admin/xpack/watcher/watch/delete]] [RolesChecked [sg_human_resources, sg_public]]


[2017-06-29T12:36:18,897][INFO ][o.e.c.m.MetaDataMappingService] [rj6PW6V] [.monitoring-kibana-2-2017.06.29/FwsSCS7TQHSScFDcPkaysA] update_mapping [kibana_stats]
[2017-06-29T12:36:28,976][INFO ][c.f.s.c.PrivilegesEvaluator] No cluster-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=_all, type=*]] [Action [cluster:admin/xpack/watcher/watch/execute]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:36:28,976][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {}
[2017-06-29T12:36:58,456][INFO ][c.f.s.c.PrivilegesEvaluator] No index-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=.monitoring-kibana-2-2017.06.27, type=*], IndexType [index=.monitoring-kibana-2-2017.06.28, type=*], IndexType [index=.monitoring-kibana-2-2017.06.29, type=*], IndexType [index=.monitoring-es-2-2017.06.27, type=*], IndexType [index=.watcher-history-3-2017.06.29, type=*], IndexType [index=.monitoring-es-2-2017.06.28, type=*], IndexType [index=.kibana_-1799980989_management, type=*], IndexType [index=.monitoring-data-2, type=*], IndexType [index=.triggered_watches, type=*], IndexType [index=.monitoring-es-2-2017.06.29, type=*], IndexType [index=.watches, type=*], IndexType [index=.monitoring-alerts-2, type=*], IndexType [index=.kibana_1593390681_performancedata, type=*], IndexType [index=.kibana_-523190050_businessintelligence, type=*], IndexType [index=searchguard, type=*], IndexType [index=.kibana, type=*]] [Action [indices:data/read/search]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:36:58,458][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {sg_public=[IndexType [index=.monitoring-kibana-2-2017.06.27, type=*], IndexType [index=.monitoring-kibana-2-2017.06.28, type=*], IndexType [index=.monitoring-kibana-2-2017.06.29, type=*], IndexType [index=.monitoring-es-2-2017.06.27, type=*], IndexType [index=.watcher-history-3-2017.06.29, type=*], IndexType [index=.monitoring-es-2-2017.06.28, type=*], IndexType [index=.kibana_-1799980989_management, type=*], IndexType [index=.monitoring-data-2, type=*], IndexType [index=.triggered_watches, type=*], IndexType [index=.monitoring-es-2-2017.06.29, type=*], IndexType [index=.watches, type=*], IndexType [index=.monitoring-alerts-2, type=*], IndexType [index=.kibana_1593390681_performancedata, type=*], IndexType [index=.kibana_-523190050_businessintelligence, type=*], IndexType [index=searchguard, type=*], IndexType [index=.kibana, type=*]], sg_human_resources=[IndexType [index=.watcher-history-3-2017.06.29, type=*], IndexType [index=.kibana_-1799980989_management, type=*], IndexType [index=.triggered_watches, type=*], IndexType [index=.kibana_1593390681_performancedata, type=*], IndexType [index=.kibana_-523190050_businessintelligence, type=*], IndexType [index=searchguard, type=*]]}
[2017-06-29T12:36:58,460][ERROR][o.e.x.w.i.s.ExecutableSimpleInput] [rj6PW6V] failed to execute [search] input for watch [_inlined_], reason [no permissions for indices:data/read/search]
[2017-06-29T12:36:58,465][INFO ][c.f.s.c.PrivilegesEvaluator] No index-level perm match for User [name=hr_employee, roles=[]] [IndexType [index=.triggered_watches, type=triggered_watch]] [Action [indices:data/write/delete]] [RolesChecked [sg_human_resources, sg_public]]
[2017-06-29T12:36:58,465][INFO ][c.f.s.c.PrivilegesEvaluator] No permissions for {sg_public=[IndexType [index=.triggered_watches, type=triggered_watch]], sg_human_resources=[IndexType [index=.triggered_watches, type=triggered_watch]]}
[2017-06-29T12:36:58,475][ERROR][o.e.x.w.e.ExecutionService] [rj6PW6V] failed to delete triggered watch [_inlined__7468091c-df30-4e61-934d-52a8c202c39c-2017-06-29T10:36:58.452Z]
org.elasticsearch.ElasticsearchSecurityException: no permissions for indices:data/write/delete
	at com.floragunn.searchguard.filter.SearchGuardFilter.apply(SearchGuardFilter.java:147) ~[?:?]
	at org.elasticsearch.action.support.TransportAction$RequestFilterChain.proceed(TransportAction.java:168) ~[elasticsearch-5.4.0.jar:5.4.0]


sg_human_resources:
  cluster:
    - CLUSTER_COMPOSITE_OPS
    - indices:data/read/scroll
    - cluster:admin/xpack/watcher/watch/put
    - cluster:admin/xpack/watcher/watch/delete
  indices:
    'humanresources':
      '*':
        - CRUD
    '?kibana':
      '*':
        - ALL
    '?monitoring*':
      '*':
        - READ  
    '?watches*':
      '*':
        - CRUD
        
