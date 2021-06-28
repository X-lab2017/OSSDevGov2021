# Atom项目2020年深入数据分析

## 目录

[toc]

## 1、引言

## 2、总体概况

## 3、报告内容分析

### 3.1、数据类分析

#### 3.1.1、Atom基础的统计数据分析、可视化

#### 3.1.2、Atom开发者数据统计、可视化

#### 3.1.3、Atom关联数据的分析、可视化

##### 与Atom具有最多共同开发者的项目Top10

​                 ![img](https://gitee.com/yyjjtt/picture_bed/raw/master/img/DDnih5OTotVaYq-kvcr5Jg)        

图3.1.3.1

​		拥有共同开发者是衡量项目关联程度的重要指标。同时根据拥有共同开发者项目的级别，也从侧面表现当前项目开发者质量，以及项目本身在业界受关注程度。

​		在图3.1.3.1中可以看到与Atom拥有共同开发者较多的项目大多是也是开源届比较顶级的项目，其中vscode与Atom拥有最多的共同开发者。这也是比较有意思的地方，Atom作为编辑器中的后期之秀，与vscode这种编辑器界的集大成者，有很多相同的开发者，一方面让人感叹圈子真小，另一方面也表现了同类开源产品的交流之密切。

##### 与Atom具有最多共同开发者的组织Top10

​                 ![img](https://gitee.com/yyjjtt/picture_bed/raw/master/img/FQMUiLgvixbXU2uBQ1UpvQ)        

图3.1.3.2

​		分析与Atom拥有共同开发者比较多的项目所属的组织，可以业界关注该项目的组织。一方面可以看出项目质量，另一方面在项目本身已经是同类顶级项目的情况下，可以判断相关组织在该领域的投入情况。

​		图3.1.3.2中可以看到和Atom共同开发者较多的组织可以说各个都是鼎鼎大名，microsoft、google、facebook这前三名的分量已经充分说明Atom受到很多顶级公司的关注。第一名是微软，这和上面项目分析的结果相符。可以看出微软在编辑器界的投入颇多，结合微软收购Github，还有投入巨大的各种ide，微软对开发者使用工具的重视，也侧面说明互联网世界得开发者才能得天下吧

### 3.2、流程类分析

#### 3.2.1、项目的日常协作流程调研

##### Atom日常协作分类

Atom日常协作主要分为一下4类：

1. 修改bug
2. 性能改进
3. 文档更新
4. 功能修改

##### 基本流程

1. 修改并填充PULL_REQUEST_TEMPLATE.md, 这是一个模板文件，初始化内容有以上四种工作的提交模板，需要按照模板填充内容。
2. 提交pull request
3. 检查pull request是否提交成功
   1. 如果pull request提交失败， 而你认为失败与你的修改无关，可以在拉动请求上留下评论，解释为什么认为失败是无关的。会有相关维护者重新进行状态检查。

##### Atom四种说明文档介绍

线上协作比较重要的一点是如何用文字表达清楚自己做了什么。Atom提供4种不同的贡献文档模板，内容详细，具有较高参考价值，简单介绍下相关内容，对于相同字段不做解释。

修改bug说明模板

1. 识别Bug：此处提供你修改的Bug对应issue链接，如果没有创建相关issue，需要先创建。
2. 变更说明：描述变更内容，用于PR维护者审查。
3. 替代设计：可能的替代方案
4. 可能的缺点：改动可能带来的负面影响
5. 验证过程：详细说明基于什么流程来体现修改的作用
6. 发行说明：用一句用户易于理解的话描述更改

性能改进说明模板

1. 变更说明
2. 定量性能优势：描述观察到的确切的性能改价（如完成操作的时间减少、内存使用减少）
3. 可能的缺点
4. 验证过程
5. 适用问题：该性能改进使用的场景。
6. 发行说明

文档更新说明模板

1. 变更说明
2. 发行说明

功能修改说明模板

1. Atom维护者认可的Issue：Issue链接
2. 变更说明
3. 替代设计
4. 可能的缺点
5. 验证过程
6. 发行说明

#### 3.2.2、开发者参与流程调研

#### 3.2.3、项目CI/CD的流程调研

## 4、总结

## 5、附录(SQL代码)

**与Atom具有最多共同开发者的项目Top10**

```sql
SELECT repo_name , COUNT(*)from (select  distinct repo_name, actor_id  from year2020  where actor_id in (select DISTINCT actor_id from year2020 where repo_name = 'atom/atom' ) and repo_name != 'atom/atom') GROUP BY repo_name ORDER BY count(*) desc limit 10;
```

**与Atom具有最多共同开发者的组织Top10**

```sql
SELECT org_login , COUNT(*)from (select  distinct org_login, actor_id  from year2020  where actor_id in (select DISTINCT actor_id from year2020 where repo_name = 'atom/atom' ) and repo_name != 'atom/atom') GROUP BY org_login ORDER BY count(*) desc limit 20;
```

