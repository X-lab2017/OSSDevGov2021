# Elasticsearch 2020 数据年报

摘要：在开源日益重要的今天，我们需要一份简历在全域大数据基础上的相对完整、可以反复进行推演的数据报告（报告、数据、算法均需要开源）。本项目为 OSSDevGov2021 的 06 小组发起，旨在通过分析 Elasticsearch 在 Github 仓库中所有的开发者行为日志，来观察 2020 年内该项目在 Github 中的活跃程度，希望以此得到该项目的开源现状、进展趋势、演化特征、以及未来挑战等问题。同时我们还结合该项目在 2019 年的开源表现，分析其在项目演进的过程中所做出的调整和发展。本报告中使用 2020 年 Elasticsearch 项目全年日志进行统计，总日志数约 12 万条。



关键词：开源、Elasticsearch、开发者行为、数据报告

## 1、背景

Elasticsearch 是一个分布式的免费开源搜索和分析引擎，适用于包括文本、数字、地理空间、结构化和非结构化数据等在内的所有类型的数据。Elasticsearch 在 Apache Lucene 的基础上开发而成，由 Elasticsearch N.V.（即现在的 Elastic）于 2010 年首次发布。Elasticsearch 以其简单的 REST 风格 API、分布式特性、速度和可扩展性而闻名，是 Elastic Stack 的核心组件；Elastic Stack 是一套适用于数据采集、扩充、存储、分析和可视化的免费开源工具。人们通常将 Elastic Stack 称为 ELK Stack（代指 Elasticsearch、Logstash 和 Kibana），目前 Elastic Stack 包括一系列丰富的轻量型数据采集代理，这些代理统称为 Beats，可用来向 Elasticsearch 发送数据。

## 2、数据类分析

### 2.1 基础统计数据分析

本次使用 2020 年全年 Github 日志进行统计，总日志数约 12 万条，相较 2019 年的 11 万条增长约 4.19%。其中项目中的基本数据细分内容：

| 字段名                 | 值                 |
| ---------------------- | ------------------ |
| issue                  | 40330              |
| open issue             | 3610               |
| open pull              | 12515              |
| pull review comment    | 22599              |
| merge pull             | 9791.75            |
| star                   | 7848               |
| fork                   | 4202               |
| repo acitivity (daily) | 319.48295248704335 |

对比 2019 年全年 Github 日志可以得出，变化比较明显的有：`issue` 数量由 105845 降至 40330，降低幅度为 61.89%，这说明该项目代码和内容都趋于完善，用户所提的问题大幅度减少；`merge pull  `数量由 2900 升至 9791，提升幅度为 237.62%，这也表明了该项目中 contributor 数量越来越多，同时对该项目的积极性大大增加。

其中该项目中 issue 数量每月相对平均，均在 680 左右浮动，最高 2 月份 issue 数量为 731，最低 12 月份数量为 473，也就表明该项目的每个 reslease 版本对项目造成的影响相对比较稳定。

<img src="./assets/issue数量月份分布图.png" alt="issue数量月份分布图" style="zoom: 50%;" />

​                                                                   **图1 issue 数量月份分布图**

同时该项目中 PR 数量每月浮动明显，最高 2 月份 PR 数量为 2272，最低 12 月份数量为 1058。

![PR数量月份分布图](./assets/PR数量月份分布图.png)

​                                                                   **图2 PR 数量月份分布图**

### 2.2 开发者数据分析

### 2.3 关联数据分析

## 3、流程类分析

### 3.1 项目日常协作流程调研

该项目的 CONTRIBUTING 文件中详细说明了写作流程，其中包括了项目分支拉取，环境配置，开发配置，提交PR等等。详细内容主要如下：

1. JDK配置。

构建 Elasticsearch 需要 JDK 16。必须有一个 JDK 16 的安装，环境变量 JAVA_HOME 参考了 JDK 16 安装的 Java home 的路径。默认情况下，测试使用与 JAVA_HOME 相同的运行时间。然而，由于Elasticsearch 支持 JDK 11，构建时支持用 JDK 16 编译，并在 JDK 11 运行时上进行测试；要做到这一点，需要设置 RUNTIME_JAVA_HOME，指向 JDK 11 安装的 Java 首页。注意，这种机制也可以用来对其他 JDK 进行测试，这不仅限于 JDK 11。

2. 将项目导入 IDEA

导入 Elasticsearch 项目所需的最小 IntelliJ IDEA 版本是 2020.1 Elasticsearch 使用 Java 16 构建。当导入 IntelliJ 时，需要定义一个合适的 SDK。按照惯例，这个 SDK 应该被命名为 "16"，这样项目导入时就会自动检测到它。关于在 IntelliJ 中定义 SDK 的更多细节，请参考他们的文档。SDK 的定义是全局性的，所以可以从任何项目中添加 JDK，或者在项目导入后添加。如果导入的 JDK 缺失，仍然可以工作，IntelliJ 只是报告一个问题，并拒绝构建，直到解决。

3. REST 端点约束

Elasticsearch 在 URL 中通常使用单数名词而不是复数。比如说：

```
/_ingest/pipeline
/_ingest/pipeline/{id}
```

而不是：

```
/_ingest/pipelines
/_ingest/pipelines/{id}
```

你可能会找到反例，但新的端点应该使用单数形式。

4. Java 语言格式化指南

Elasticsearch 代码库中的 Java 文件是使用 Spotless Gradle 插件自动格式化的。所有的新项目都会被自动格式化，而现有的项目也在逐渐被选择加入。格式化检查可以通过以下方式明确运行：

```
./gradlew spotlessJavaCheck
```

5. Javadoc

好的 Javadoc 可以帮助浏览和理解代码。Elasticsearch 有一些关于什么时候写 Javadoc 和什么时候不写 Javadoc 的指导原则，但请注意，我们不希望有过度的规定性。这些指南的目的是为了提供帮助，而不是把写代码变成一件苦差事。

6. 许可证标题

要求所有的 Java 文件都有许可证头。除了顶层的 x-pack 目录之外，所有贡献的代码都应该有以下许可头，除非另有指示。

```
    /*
     * Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
     * or more contributor license agreements. Licensed under the Elastic License
     * 2.0 and the Server Side Public License, v 1; you may not use this file except
     * in compliance with, at your election, the Elastic License 2.0 or the Server
     * Side Public License, v 1.
     */
```

7. 创建 Distribution
8. 单元测试
9. 项目布局构建

### 3.2 开发者参与流程调研

### 3.3 项目 CI/CD 的流程调研

## 4、总结

Elasticsearch 作为 Github 2020 年中活跃度排名 18 的项目，其影响力还是非常的大。由本篇数据年报能看出这个项目吸引到了不少的开发者一起协作，同时项目中社区交流也非常的积极密切，许多 issue 都能得到回复，所提 bug 大部分都能及时修复，项目协作流程以及相关文档编辑都非常完善，开发者能够从文档中就能得到该项目的基本开发流程，这也有利于该项目的开发迭代升级。希望 Elasticsearch 这个项目能够继续保持这样的开源精神，为开源届贡献更多力量。

