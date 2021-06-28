# Kubernetes 2020 Report

## 数据类分析

### 开发者数据统计、可视化

查询项目2020分数最高的10个开发者

> select * from annual_score where repo_name = 'kubernetes/kubernetes' and year = 2020 order by score desc limit 10

> select actor_login, count( open_issue), COUNT( issue_comment), COUNT( open_pull), 
> COUNT( pull_review_comment), count(merge_pull)
> from daily_score 
> where repo_name = 'kubernetes/kubernetes' and actor_login in
> (select actor_login from annual_score where repo_name = 'kubernetes/kubernetes' and year = 2020 order by score desc limit 10 OFFSET 1) 
> and toYear(date_time) = 2020
> GROUP BY actor_login

> select actor_login, sum( open_issue), sum( issue_comment), sum( open_pull),
> sum( pull_review_comment), sum(merge_pull),sum(star), sum(fork), count( daily_score) as score
> from daily_score 
> where repo_name = 'kubernetes/kubernetes' and actor_login in
> (select actor_login from annual_score where repo_name = 'kubernetes/kubernetes' and year = 2020 order by score desc limit 10 OFFSET 1) 
> and toYear(date_time) = 2020
> GROUP BY actor_login ORDER BY score desc



#### 2020 commits Top10 开发者数据统计

对仓库中2020年Commits数量前十的开发者进行了统计，具体指标有commits、additions、deletions，统计数据如下：

| 开发者账号                         | Commits | Additions | Deletions |
| ---------------------------------- | ------- | --------- | --------- |
| Jordan Liggitt (liggitt)           | 237     | 205382    | 184420    |
| Davanum Srinivas (dims)            | 154     | 76242     | 152708    |
| Caleb Woodbine (BobyMCbobs)        | 144     | 3343      | 1172      |
| Andrew Sy Kim (andrewsykim)        | 102     | 16145     | 9859      |
| Aldo Culquicondor (alculquicondor) | 96      | 15859     | 7312      |
| Stephen Augustus (justaugustus)    | 94      | 36293     | 37529     |
| Antonio Ojea (aojea)               | 92      | 5859      | 1760      |
| Wojciech Tyczynski (wojtek-t)      | 88      | 7149      | 6011      |
| Wei Huang (Huang-Wei)              | 81      | 8660      | 7117      |
| David Eads (deads2k)               | 73      | 8014      | 60147     |

#### 2020 Activity Scores Top10 开发者数据统计

对仓库中各项Activity总分最高的十个开发者进行了各项数据的统计，具体指标包括Open Issue、Issue Comment、Open Pull、Pull Review Comment、Merge Pull，统计数据如下：

| 开发者账号     | Open Issue | Issue Comment | Open Pull | Pull Review Comment | Merge Pull | Score  |
| -------------- | ---------- | ------------- | --------- | ------------------- | ---------- | ------ |
| k8s-ci-robot   | 0          | 126577        | 0         | 0                   | 3983.44    | 355.78 |
| fejta-bot      | 12         | 15097         | 0         | 0                   | 0          | 122.97 |
| liggitt        | 66         | 5062          | 211       | 2664                | 0          | 129.72 |
| neolit123      | 4          | 2526          | 70        | 796                 | 0          | 77.74  |
| aojea          | 29         | 2038          | 118       | 795                 | 0          | 75.93  |
| alculquicondor | 53         | 1863          | 92        | 1213                | 0          | 85.12  |
| Huang-Wei      | 24         | 1327          | 87        | 679                 | 0          | 66.98  |
| wojtek-t       | 16         | 1136          | 100       | 666                 | 0          | 65.48  |
| ahg-g          | 48         | 1291          | 46        | 612                 | 0          | 63.63  |
| andrewsykim    | 6          | 922           | 70        | 954                 | 0          | 71.07  |

#### 2020 Commits 开发者分布

对仓库中2020年的贡献者进行了commits数量的统计并绘制，共59名贡献者，其中22名贡献者commits数量小于20，4名贡献者commits数量大于100。

![1](./1.png)

## 流程类分析

### 开发者参与流程调研