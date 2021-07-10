# 开源项目ClickHouse分析
**摘要：** ClickHouse是一个用于联机分析(OLAP)的列式数据库管理系统(DBMS)
## 一、数据类分析
### 1.1 基础的统计数据分析
&emsp;&emsp;
ClickHouse在2020年共有7091名用户活跃用户，共产生75926次事件操作，其中共有13种事件类型，包括IssueCommentEvent,PushEvent,PullRequestEvent,PullRequestReviewCommentEvent,IssueEvent,CreateEvent,WatchEvent,DeleteEvent,ForkEvent,ReleaseEvent,CommitCommentEvent,MemberEvent,GollumEvent，其中IssueCommentEvent,PushEvent两个事件最多，可以看出ClickHouse社区非常繁荣，问题讨论与项目开源质量都非常高。
![avatar](./pic/type.png)
&emsp;&emsp;
同时根据月份划分事件数量，可以看到ClickHouse社区活跃度随着月份不断提高。尤其是7，8，9月份的社区活跃度，全年最高。
![avatar](./pic/month.png)
### 1.2 开发者数据统计、可视化
&emsp;&emsp;
从之前的分析可以看出，ClickHouse作为一个成熟的开源项目，其问题评论是相当多的，在此我们统计比较活跃的问题评论用户，提交问题评论大多数情况下是为了解决问题，可以从侧面反应活跃用户对于社区项目的理解。
![avatar](./pic/count.png)
### 1.3 关联数据分析
&emsp;&emsp;
我们通过统计在ClickHouse上触发事件的用户，在其他项目上的贡献，来找出与ClickHouse相关联的项目，以下是统计出的前十五个比较相关的项目：
![avatar](./pic/relation.png)
### 1.4 用户活跃图
&emsp;&emsp;
我们通过用户统计，筛选出了所有用户在2020年本项目中的用户活跃图，可以看到在2020年7月末期，有大量的用户活跃度，并且在之后的活跃度也明显比之前的高，说明有更多的用户在参与这个项目，更加活跃。
![avatar](./pic/user.jpg)