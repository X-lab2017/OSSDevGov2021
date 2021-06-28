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

> select month, actor_login , count(*) from daily_score where actor_login in (
> 	select actor_login from annual_score where repo_name = 'kubernetes/kubernetes' and year = 2020 order by score desc limit 10
> ) and toYear( date_time) = 2020 and repo_name = 'kubernetes/kubernetes'
> GROUP BY toMonth( date_time) as month, actor_login 
> ORDER BY actor_login,  month 

```
option = {
    title: {
        text: '折线图堆叠'
    },
    tooltip: {
        trigger: 'axis'
    },
    legend: {
        data: ['Huang-Wei', 'ahg-g', 'alculquicondor', 
        'andrewsykim', 'aojea','liggitt','neolit123','wojtek-t']
    },
    grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
    },
    toolbox: {
        feature: {
            saveAsImage: {}
        }
    },
    xAxis: {
        type: 'category',
        boundaryGap: false,
        data: ['1月', '2月', '3月', '4月', '5月', '6月',
            '7月', '8月', '9月', '10月', '11月', '12月']
    },
    yAxis: {
        type: 'value'
    },
    series: [
        {
            name: 'Huang-Wei',
            type: 'line',
            data: [101,106,72,82,172,169,253,69,49,76,98,30]
        },
        {
            name: 'ahg-g',
            type: 'line',
            data: [241,105,65,55,124,122,107,55,80,54,70,37]
        },
        {
            name: 'alculquicondor',
            type: 'line',
            data: [135,182,184,149,203,172,94,73,139,163,107,55]
        },
        {
            name: 'andrewsykim',
            type: 'line',
            data: [55,67,87,77,100,32,93,57,82,103,183,60]
        },
        {
            name: 'aojea',
            type: 'line',
            data: [162,92,117,146,138,148,133,91,166,235,185,132]
        },
        {
            name: 'liggitt',
            type: 'line',
            data: [523,427,405,394,369,435,562,487,344,260,305,97]
        },
        {
            name: 'neolit123',
            type: 'line',
            data: [239,213,194,188,171,142,162,219,256,149,141,105]
        },
        {
            name: 'wojtek-t',
            type: 'line',
            data: [84,86,37,145,103,148,79,90,144,113,71,38]
        },
    ]
};

```



#### 2020 commits Top10 开发者数据统计

对项目中2020年Commits数量前十的开发者进行了统计，具体指标有commits、additions、deletions，统计数据如下：

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

对项目中各项Activity总分最高的十个开发者进行了各项数据的统计，具体指标包括Open Issue、Issue Comment、Open Pull、Pull Review Comment、Merge Pull，统计数据如下：

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

#### 2020 Activity Scores Top10 开发者月度趋势

对中各项Activity总分最高的十个开发者的月度趋势进行了统计（对两个bot进行剔除），如下图所示。可以看出开发者liggitt对项目的贡献最大，在全年都对项目进行着较多的贡献。7月为主力开发者贡献较多的月份，12月是贡献者贡献较少的月份。

![3](./3.png)



#### 2020 Commits 开发者分布

对项目中2020年的贡献者进行了commits数量的统计并绘制，共59名贡献者，其中22名贡献者commits数量小于20，4名贡献者commits数量大于100。

![1](./1.png)

#### 2020 开发者区域分布

对项目中2020年中的全部开发者进行区域分布的统计，区域分布如下图所示。在2020年中有过贡献的开发者共59人，其中位置未知的开发者共15人。其中，开发者区域为美国的共23人，为中国的共9人，其他区域还有意大利、印度、德国、罗马尼亚、保加利亚、波兰、新西兰、西班牙、加拿大等。

![2](./2.png)

## 流程类分析

### 开发者参与流程调研