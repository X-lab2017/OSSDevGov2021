# 第23章 持续集成

由Rachel Tannenbaum撰写，Lisa Carey编辑

*连续集成*（CI）通常被定义为”团队成员需要频繁集成他们工作的软件开发工作[...]每次集成都通过自动构建（包括测试）进行验证，以检测集成错误。“<sup>1</sup>简而言之，持续集成的基本目标是尽早自动发现有问题的代码更新。

“持续集成”对于现代的分布式应用有什么意义？当今的系统除了仓库中的最新版本代码外，还有许多其他不错的部分。实际上，随着微服务的最新趋势，破坏程序的代码更新不太可能存在于项目的当前仓库中，而更有可能出现在网络调用另一端的松耦合微服务中。传统的连续构建会测试二进制文件中的更新，在这上的扩展可能会测试上游微服务的更改。依赖关系只是从函数调用堆栈转移到HTTP请求或远程过程调用（RPC）。

即使远离代码依赖关系，程序也可能会定期提取数据或更新机器学习模型。它可能在不断发展的操作系统，内存管理，云托管服务和设备上执行。它可能是一个位于不断发展的平台之上的功能，也可能是必须适应不断增长的功能的基础平台。所有这些东西都应被视为依赖项，我们也应致力于“持续集成”它们的更新。更复杂的是，这些不断变化的模块通常由我们团队，组织或公司之外的开发人员拥有，并按自己的进度进行部署。

因此，对于当今的持续集成，尤其是在大规模开发时，可能有一个更好的定义：

> *持续集成（2）*：对我们整个复杂而迅速发展的系统环境的不断合并和测试。

从测试的角度对持续集成进行概念化是很自然的，因为两者紧密相关，我们将在本章中继续进行。在前面的章节中，我们讨论了从单元到集成，再到更大范围的系统的全面测试。

从测试方面来说，持续集成是一个介绍以下部分的范例：

• 在开发/发布开发过程中，随着代码（和其他部分）的更新的不断集成，要运行哪些测试

• 如何在每个测试点上组成被测系统（SUT），平衡准确性和启动成本等

例如，我们在提交前运行哪些测试，在提交后保存哪些测试，甚至在以后进行暂存部署之前保存哪些测试？因此，我们如何在这些测试点上划分我们的SUT？就像你想象的那样，预提交SUT的要求可能与测试中的过渡环境的要求有很大不同。例如，在代码审核前提交前的程序与真实的生产后端进行交互（可能存在安全性和配额漏洞问题）可能很危险，但对于过渡环境而言，这通常是可以接受的。

为何我们还要尝试通过持续集成在“合适的时间”测试“合适的事物”达成这一通常微妙的平衡呢？大量的先前工作已经建立了持续集成对开发团队和整个业务的好处。<sup>2</sup>这些结果是由有力的证据所驱动的：即时的可验证的程序可以很好地发展到下一个阶段。我们不需要只是希望所有贡献者都非常谨慎，负责和透彻；相反，我们可以保证从构建到发行的各个阶段，我们的应用程序都处于工作状态，从而提高了我们对产品的信心和质量以及团队的生产力。

在本章的其余部分中，我们将介绍一些关键的CI概念，最佳实践和挑战，然后介绍我们在Google上如何管理持续集成，并且将通过一个程序在持续集成转换上的深入研究来介绍我们的持续构建工具TAP。

## 持续集成概念

首先，让我们开始研究持续集成的一些核心概念。

## 快速反馈循环

正如第11章所讨论的，一个错误越晚被发现它所花费的成本会成倍的增加。图23-1展示了所有有问题的代码在时间线中可能被发现的时间节点。

![image-20210413195010773](/Users/xuhuan/Library/Application Support/typora-user-images/image-20210413195010773.png)

* 图23-1. 代码更新的时间线

通常来说，随着问题发展到图表的右边，它们被发现的所消耗的成本更多，主要因为以下原因：

- 它们肯定是由不熟悉代码更改的工程师对它们进行分类。
- 它们需要代码更新的坐着消耗更多的工作了来收集和调查代码更新。
- 它们会对他人产生负面影响，无论是工作中的工程师还是最终用户。

为了最大程度地减少错误的成本，持续集成鼓励我们使用*快速反馈循环。*<sup> 3</sup>每当我们将代码（或其他部分）更新集成到测试环境中并观察结果时，我们都会得到一个新的*反馈循环*。反馈可以采取多种形式，以下是一些常见的（从最快到最慢的顺序排列）：

- 本地开发的编写-编译-调试循环
- 代码更新作者在提交前的自动化测试结果
- 在两个项目的更新一起提交并测试后检测到的两个项目的更新之间的集成错误（在提交后）
- 当上游服务部署其最新更改时，我们的项目与上游微服务依赖项之间的不兼容性（由过渡环境中的QA测试人员检测到）
- 内测用户发现的错误报告，他们比起外部用户更先尝试新功能
- 由外部用户或媒体发现的错误或中断报告

*金丝雀*—或者先部署一小部分代码到生产环境—可以通过在全部代码部署到生产环境之前进行生产子集的初始反馈循环，来最大程度地减少生产环境中遇到的问题。但是，金丝雀也会引起问题，尤其是在一次部署多个版本时，部署之间的兼容性问题。这有时被称为*版本倾斜*, 这是分布式系统的一种状态，其中它包含代码，数据和配置的多个不兼容版本。就像我们在本书中讨论的许多问题一样，版本倾斜是一个挑战性的例子，当尝试随着时间的推移开发和管理软件时，可能会出现挑战性的问题。

*实验* 和 *特征标记* 是极其强大的反馈循环。它们通过隔离可在生产环境中动态切换的模块化组件中的更改来降低部署风险。高度依赖功能标记保护是持续交付的常见范例，我们将在第24章中进一步探讨。

### 访问和可行反馈

持续集成反馈能够广泛可访问也很重要。除了围绕代码可见性的开源文化之外，我们对测试报告的感受也类似。我们拥有一个统一的测试报告系统，在该系统中，任何人都可以轻松地查找构建或测试运行，包括所有日志（不包括用户个人身份信息），无论是针对单个工程师的本地运行还是在自动化开发或分阶段构建中。

除日志外，我们的测试报告系统还提供了有关构建或测试目标何时开始失败的详细历史记录，包括审核每次运行时切片的位置，运行的位置以及由谁进行的审核。我们还提供了切片分类系统，该系统使用统计信息在Google范围内对切片进行分类，因此工程师无需自己弄清楚这一点来确定他们的变更是否破坏了另一个项目的测试（如果测试是片状：可能不是）。

测试历史记录的可视性使工程师能够共享反馈并在反馈上进行协作，这是不同团队从系统之间的集成故障中诊断和学习的基本要求。同样，Google的错误（例如票证或问题）也会打开，其中包含完整的评论历史记录，供所有人查看和学习（客户除外）。

最后，来自持续集成测试的任何反馈不仅应该可以访问，而且应该可行-易于使用来查找和解决问题。在本章稍后的案例研究中，我们将看一个改善一个用户不友好反馈的示例。通过提高测试输出的可读性，您可以很容易理解反馈。

## Automation

It’s well known that automating development-related tasks saves engineering resour‐ ces in the long run. Intuitively, because we automate processes by defining them as code, peer review when changes are checked in will reduce the probability of error. Of course, automated processes, like any other software, will have bugs; but when imple‐ mented effectively, they are still faster, easier, and more reliable than if they were attempted manually by engineers.

CI, specifically, automates the *build* and *release* processes, with a Continuous Build and Continuous Delivery. Continuous testing is applied throughout, which we’ll look at in the next section.

### Continuous Build

The *Continuous Build* (CB) integrates the latest code changes at head4 and runs an automated build and test. Because the CB runs tests as well as building code, “break‐ ing the build” or “failing the build” includes breaking tests as well as breaking compilation.

After a change is submitted, the CB should run all relevant tests. If a change passes all tests, the CB marks it passing or “green,” as it is often displayed in user interfaces (UIs). This process effectively introduces two different versions of head in the reposi‐ tory: *true head*, or the latest change that was committed, and *green head,* or the latest change the CB has verified. Engineers are able to sync to either version in their local development. It’s common to sync against green head to work with a stable environ‐ ment, verified by the CB, while coding a change but have a process that requires changes to be synced to true head before submission.

### Continuous Delivery

The first step in Continuous Delivery (CD; discussed more fully in Chapter 24) is *release automation*, which continuously assembles the latest code and configuration from head into release candidates. At Google, most teams cut these at green, as opposed to true, head.

> *Release candidate* (RC): A cohesive, deployable unit created by an automated process,5 assembled of code, configuration, and other dependencies that have passed the contin‐ uous build.

Note that we include configuration in release candidates—this is extremely impor‐ tant, even though it can slightly vary between environments as the candidate is pro‐ moted. We’re not necessarily advocating you compile configuration into your binaries —actually, we would recommend dynamic configuration, such as experiments or fea‐ ture flags, for many scenarios.6

Rather, we are saying that any static configuration you *do* have should be promoted as part of the release candidate so that it can undergo testing along with its correspond‐ ing code. Remember, a large percentage of production bugs are caused by “silly” con‐ figuration problems, so it’s just as important to test your configuration as it is your code (and to test it along *with* the same code that will use it). Version skew is often caught in this release-candidate-promotion process. This assumes, of course, that your static configuration is in version control—at Google, static configuration is in version control along with the code, and hence goes through the same code review process.

We then define CD as follows:

> *Continuous Delivery* (CD): a continuous assembling of release candidates, followed by the promotion and testing of those candidates throughout a series of environments— sometimes reaching production and sometimes not.

The promotion and deployment process often depends on the team. We’ll show how our case study navigated this process.

For teams at Google that want continuous feedback from new changes in production (e.g., Continuous Deployment), it’s usually infeasible to continuously push entire binaries, which are often quite large, on green. For that reason, doing a *selective* Con‐ tinuous Deployment, through experiments or feature flags, is a common strategy.7

As an RC progresses through environments, its artifacts (e.g., binaries, containers) ideally should not be recompiled or rebuilt. Using containers such as Docker helps enforce consistency of an RC between environments, from local development onward. Similarly, using orchestration tools like Kubernetes (or in our case, usually Borg), helps enforce consistency between deployments. By enforcing consistency of our release and deployment between environments, we achieve higher-fidelity earlier testing and fewer surprises in production.

## Continuous Testing

Let’s look at how CB and CD fit in as we apply Continuous Testing (CT) to a code change throughout its lifetime, as shown Figure 23-2.

![image-20210413200312251](/Users/xuhuan/Library/Application Support/typora-user-images/image-20210413200312251.png)

*Figure 23-2. Life of a code change with CB and CD*

The rightward arrow shows the progression of a single code change from local devel‐ opment to production. Again, one of our key objectives in CI is determining *what* to test *when* in this progression. Later in this chapter, we’ll introduce the different test‐ ing phases and provide some considerations for what to test in presubmit versus post-submit, and in the RC and beyond. We’ll show that, as we shift to the right, the code change is subjected to progressively larger-scoped automated tests.

### Why presubmit isn’t enough

With the objective to catch problematic changes as soon as possible and the ability to run automated tests on presubmit, you might be wondering: why not just run all tests on presubmit?

The main reason is that it’s too expensive. Engineer productivity is extremely valua‐ ble, and waiting a long time to run every test during code submission can be severely disruptive. Further, by removing the constraint for presubmits to be exhaustive, a lot of efficiency gains can be made if tests pass far more frequently than they fail. For example, the tests that are run can be restricted to certain scopes, or selected based on a model that predicts their likelihood of detecting a failure.

Similarly, it’s expensive for engineers to be blocked on presubmit by failures arising from instability or flakiness that has nothing to do with their code change.

Another reason is that during the time we run presubmit tests to confirm that a change is safe, the underlying repository might have changed in a manner that is incompatible with the changes being tested. That is, it is possible for two changes that touch completely different files to cause a test to fail. We call this a mid-air collision, and though generally rare, it happens most days at our scale. CI systems for smaller repositories or projects can avoid this problem by serializing submits so that there is no difference between what is about to enter and what just did.

### Presubmit versus post-submit

So, which tests *should* be run on presubmit? Our general rule of thumb is: only fast, reliable ones. You can accept some loss of coverage on presubmit, but that means you need to catch any issues that slip by on post-submit, and accept some number of roll‐ backs. On post-submit, you can accept longer times and some instability, as long as you have proper mechanisms to deal with it.

![image-20210413200701892](/Users/xuhuan/Library/Application Support/typora-user-images/image-20210413200701892.png)

We don’t want to waste valuable engineer productivity by waiting too long for slow tests or for too many tests—we typically limit presubmit tests to just those for the project where the change is happening. We also run tests concurrently, so there is a resource decision to consider as well. Finally, we don’t want to run unreliable tests on presubmit, because the cost of having many engineers affected by them, debugging the same problem that is not related to their code change, is too high.

Most teams at Google run their small tests (like unit tests) on presubmit8—these are the obvious ones to run as they tend to be the fastest and most reliable. Whether and how to run larger-scoped tests on presubmit is the more interesting question, and this varies by team. For teams that do want to run them, hermetic testing is a proven approach to reducing their inherent instability. Another option is to allow large- scoped tests to be unreliable on presubmit but disable them aggressively when they start failing.

### Release candidate testing

After a code change has passed the CB (this might take multiple cycles if there were failures), it will soon encounter CD and be included in a pending release candidate.

As CD builds RCs, it will run larger tests against the entire candidate. We test a release candidate by promoting it through a series of test environments and testing it at each deployment. This can include a combination of sandboxed, temporary environments and shared test environments, like dev or staging.