# TiDB2020年深入数据分析

## TiDB简介
[TiDB](https://github.com/pingcap/tidb) 是 [PingCAP](https://pingcap.com/about-cn/) 公司自主设计、研发的开源分布式关系型数据库，是一款同时支持在线事务处理与在线分析处理 (Hybrid Transactional and Analytical Processing, HTAP) 的融合型分布式数据库产品，具备水平扩容或者缩容、金融级高可用、实时 HTAP、云原生的分布式数据库、兼容 MySQL 5.7 协议和 MySQL 生态等重要特性。目标是为用户提供一站式 OLTP (Online Transactional Processing)、OLAP (Online Analytical Processing)、HTAP 解决方案。TiDB 适合高可用、强一致要求较高、数据规模较大等各种应用场景。

### 五大核心特性

- 一键水平扩容或者缩容

  得益于 TiDB 存储计算分离的架构的设计，可按需对计算、存储分别进行在线扩容或者缩容，扩容或者缩容过程中对应用运维人员透明。

- 金融级高可用

  数据采用多副本存储，数据副本通过 Multi-Raft 协议同步事务日志，多数派写入成功事务才能提交，确保数据强一致性且少数副本发生故障时不影响数据的可用性。可按需配置副本地理位置、副本数量等策略满足不同容灾级别的要求。

- 实时 HTAP

  提供行存储引擎TiKV、列存储引擎TiFlash两款存储引擎，TiFlash 通过 Multi-Raft Learner 协议实时从 TiKV 复制数据，确保行存储引擎 TiKV 和列存储引擎 TiFlash 之间的数据强一致。TiKV、TiFlash 可按需部署在不同的机器，解决 HTAP 资源隔离的问题。

- 云原生的分布式数据库

  专为云而设计的分布式数据库，通过TiDB Operator可在公有云、私有云、混合云中实现部署工具化、自动化。

- 兼容 MySQL 5.7 协议和 MySQL 生态

  兼容 MySQL 5.7 协议、MySQL 常用的功能、MySQL 生态，应用无需或者修改少量代码即可从 MySQL 迁移到 TiDB。提供丰富的数据迁移工具帮助应用便捷完成数据迁移。

## 数据分析类

### 基础的统计数据分析、可视化

TiDB在2020年不同月份提交Pull Requests的数量相对稳定，总体为略微上升趋势，其中4月份PR数量显著高于其他月份。
![](./pull_request_count.png)

TiDB在2020年每月完成Issue数量的趋势和提交Pull Requests数量的趋势保持一致，其中4月份和12月份完成Issue的数量达到高峰，稳步上升的趋势让我们可以期待TiDB在2021年的表现。
![](./issue_count.png)

2020年TiDB项目中的不同事件呈现多样化，其中IssueCommentEvent占比超过50%，PullRequestReviewCommentEvent和PullRequestEvent分列二三位，由此可以看出TiDB在开源社区表现十分活跃，受到了广大开发者的关注，开发者也乐于为TiDB做出自己的贡献。TiDB也是2020年GitHub的明星项目，引发了不少的讨论。
![](./event.png)

### 开发者数据统计、可视化

### 关联数据的分析


## 流程类分析

### 项目的日常协作流程调研

### 开发者参与流程调研

### 项目CI/CD的流程调研