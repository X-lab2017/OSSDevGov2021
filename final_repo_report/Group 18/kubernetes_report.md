# Kubernetes 2020 Report

## 数据类分析

### 开发者数据统计、可视化

查询项目2020分数最高的10个开发者

> select * from annual_score where repo_name = 'kubernetes/kubernetes' and year = 2020 order by score desc limit 11

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



#### Top10 commits Top10 开发者

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



## 流程类分析

### 开发者参与流程调研