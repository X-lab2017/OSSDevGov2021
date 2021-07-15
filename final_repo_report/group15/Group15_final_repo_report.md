<p align="center" style="font-weight:bold;font-size:36px">Final Repository Report</p>

<p align="center" style="font-weight:bold;font-size:30px">Group 15</p>

<p align="center" style="font-weight:bold;font-size:26px">苏巨亮、于春琳</p>

## 数据类

### 1. 基础的统计数据分析、可视化

在Pytorch仓库中，过去的一月里，除去合并，共有301个作者向master提交了879个提交，向所有分支提交了2754个提交。在master上，1586个文件发生了变化，增加了61,271个文件，删除了43,562个文件。

<div align="center"><img src="images\img1.png" alt="img"/></div>

<p align="center">图1 pytorch仓库2017-2020年基础数据变化分析图</p>

如图1所示，我们用百分比图展示了pytorch仓库在2017-2020这四年中每一年的六项基础数据所占相关数据指标四年总数的比重。基础数据指标在图表中从左到右依次为issue_comment数，open_issue数，open_pull数，pull_review_comment数，merge_pull数，以及repo_acitivity数。在2017年(蓝色)，每项指标占总数比率分别为8.4%、12%、6%、5%、37%、10%，可以看出，在这一阶段pytorch仓库的开发过程处于刚起步的阶段，所以各项基础数据指标占四年比重相比其他年份都比较小。而在2018年(红色)，各项指标占比分别为17.9%、22.7%、20.5%、19.4%、50.1%、20.6%，可以看到merge_pull数的比率占到了该项数据指标的最大值。到了2019年(灰色)，各项指标占比分别为30%、31%、34%、31%、4%、30.1%，说明pytorch仓库开发处于一个逐渐活跃的过程中。在2020年(黄色)，各项基础数据指标占四年比重分别为43%，34.1%，39.6%，43.5%，8.6%，39%，数据指标进一步提升，说明pytorch仓库处于快速发展期。从上面这些数据可以看出，pytorch仓库的参与度和活跃度在逐年不断提高。这也与我们所知道的pytorch在最近几年成为最受开发者欢迎的深度学习开发平台的事实相吻合。

<div align="center"><img src="images\img2.png" alt="img"/></div>

<p align="center">图2 pytorch仓库2020全年每天的新增star数、fork数和issue数</p>

如图2所示，我们用折线图展示了2020全年每天的数据变化，指标包含新增star数，新增fork数和新增issue数，三者总体来说变化趋势还是比较一致的，这和我们的认知也是比较接近的。



### 2. 开发者数据统计、可视化

由于 GitHub 事件日志具有详细的时间戳信息，故可以通过对时间维度的统计分析进行洞察，pytorch仓库的工作时间分布如图所示，图中横坐标表示一天中的24个小时，纵坐标表示日志数，七条折线分别为周一到周日。

<div align="center"><img src="images\img3.png" alt="img"/></div>

<p align="center">图3 2021年pytorch仓库日志时间分布情况</p>

如图3所示，通过日志量，可以看到2021年pytorch仓库上的开发者活跃的时间主要从每日14点到第二天5点。而且周六、周日的活跃度明显低于周一到周五。

<div align="center"><img src="images\img4.png" alt="img"/></div>

<p align="center">图4 pytorch仓库前十位贡献者commits数量饼状图</p>

如图4所示，我们用饼状图展示了pytorch仓库前十位贡献者的commits数量饼状图，排名第一的名为ezyang的贡献者共提交了1594个commits，第十位名为zou3519的贡献者共提交了564个commits。前十位贡献者平均提交数目为809个。

<div align="center"><img src="images\img5.png" alt="img"/></div>

<p align="center">图5 pytorch仓库前十位贡献者add/remove lines组合图</p>

如图5所示，我们用组合图展示了pytorch仓库前十位贡献者的add lines和remove lines数量组合图，排名第一的名为Yangqing的贡献者共增加了451782行，移除了306321行。第十位名为zou3519的贡献者共增加了51474行，移除了22384行。前十位贡献者平均增加行数为144118行，平均移除行数为110327行。

<div align="center"><img src="images\img6.png" alt="img"/></div>

<p align="center">图6 2015-2020年pytorch仓库开发者活跃度前20</p>

如图6的雷达图所示，我们将daily_score作为活跃度排序指标，以逆时针的顺序展示各开发者的各项指标数，图中最上方0点钟位置的开发者apaszke排名第一，gchanan排名第二，以此类推。图中展示数据包含issue_comment数，open_issue数，open_pull数，pull_review_comment数和merge_pull数。



### 3. 关联数据的分析

由于pytorch仓库带有许多标签，标签本身便是对仓库的属性特征的归类，于是我们通过其标签寻找仓库的有关关联关系。

<div align="center"><img src="images\img7.png" alt="img"/></div>

<p align="center">图7 pytorch仓库标签关联仓库</p>

如图7所示，我们通过pytorch仓库标签查询关联仓库，将每个标签对应的全部仓库中star数最多的三个，其中pytorch仓库本身不计入。图中发现几个仓库在多个关联标签中进入前三，如tensorflow / tensorflow和chenyuntc / pytorch-book，可见许多仓库的关联特征都是较为广泛的。



## 流程类

### 1. 项目日常协助流程调研

#### 沟通

- 论坛：讨论实现、研究等。[https://discuss.pytorch.org](https://discuss.pytorch.org/)
- GitHub 问题：错误报告、功能请求、安装问题、RFC、想法等。
- Slack：[PyTorch Slack](https://pytorch.slack.com/)的主要受众是中等到有经验的 PyTorch 用户和开发人员，用于一般聊天、在线讨论、协作等。如果您是寻求帮助的初学者，主要媒体是[PyTorch 论坛](https://discuss.pytorch.org/)。如果您需要 Slack 邀请，请填写此表格：[https](https://goo.gl/forms/PP1AGvNHpSaJP8to1) : [//goo.gl/forms/PP1AGvNHpSaJP8to1](https://goo.gl/forms/PP1AGvNHpSaJP8to1)
- 时事通讯：No-noise，一种单向电子邮件时事通讯，其中包含有关 PyTorch 的重要公告。您可以在这里注册：[https](https://eepurl.com/cbG0rv) : [//eepurl.com/cbG0rv](https://eepurl.com/cbG0rv)
- Facebook 页面：关于 PyTorch 的重要公告。https://www.facebook.com/pytorch
- 有关品牌指南，请访问我们的网站[pytorch.org](https://pytorch.org/)

#### 发布和贡献

PyTorch 的发布周期为 90 天（主要版本）。如果您遇到错误，请通过[提交问题](https://github.com/pytorch/pytorch/issues)告诉我们。

我们感谢所有贡献。如果您打算回馈错误修复，请不要进一步讨论。

如果您计划为核心贡献新功能、实用功能或扩展，请先打开一个问题并与我们讨论该功能。未经讨论就发送 PR 可能最终导致 PR 被拒绝，因为我们可能会将核心转向与您可能意识到的不同的方向。

要了解有关为 Pytorch 做出贡献的更多信息，请参阅我们的[贡献页面](https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md)。

#### 承诺

为了营造一个开放和热情的环境，我们作为贡献者和维护者承诺，无论年龄、体型、残疾、种族、性别特征、性别认同如何，参与我们的项目和我们的社区的每个人都将获得无骚扰的体验和表达、经验水平、教育程度、社会经济地位、国籍、个人外表、种族、宗教或性身份和性取向。

#### 标准

有助于创造积极环境的行为示例包括：

- 使用欢迎和包容的语言
- 尊重不同的观点和经历
- 优雅地接受建设性的批评
- 专注于对社区最有利的事情
- 对其他社区成员表示同情

参与者不可接受的行为示例包括：

- 使用色情语言或图像以及不受欢迎的性关注或性挑逗
- 拖钓、侮辱/贬损评论以及个人或政治攻击
- 公共或私人骚扰
- 未经明确许可，发布他人的私人信息，例如物理地址或电子地址
- 在专业环境中可以合理地被认为不适当的其他行为

#### 责任

项目维护者负责阐明可接受行为的标准，并期望对任何不可接受行为的实例采取适当和公平的纠正措施。

项目维护者有权利和责任删除、编辑或拒绝与本行为准则不一致的评论、提交、代码、wiki 编辑、问题和其他贡献，或暂时或永久禁止任何贡献者的其他行为他们认为不恰当、具有威胁性、令人反感或有害。

#### 范围

本行为准则适用于所有项目空间，也适用于个人在公共场所代表项目或其社区的情况。代表项目或社区的示例包括使用官方项目电子邮件地址、通过官方社交媒体帐户发帖或在在线或离线活动中担任指定代表。项目的表示可以由项目维护者进一步定义和澄清。

#### 执法

可以通过[opensource-conduct@fb.com](mailto:opensource-conduct@fb.com)联系项目团队报告辱骂、骚扰或其他不可接受的行为。所有投诉都将受到审查和调查，并将做出被认为必要且适合具体情况的回应。项目团队有义务为事件报告者保密。具体执法政策的更多细节可能会单独发布。

不善意遵守或执行行为准则的项目维护者可能面临项目领导其他成员确定的暂时或永久影响



### 2. 开发者参与流程调研

#### PyTorch 贡献过程

PyTorch 组织由[:doc:`PyTorch Governance ` 管理](https://github.com/chunlindase/pytorch/blob/master/docs/source/community/contribution_guide.rst#id1)。

PyTorch 开发过程涉及核心开发团队和社区之间的大量公开讨论。

PyTorch 的操作是类似于 GitHub 上的大多数开源项目。但是，如果开发者以前从未为开源项目做出过贡献，那么必须遵循下面的基本过程。

- 弄清楚你要做什么。

  大多数开源贡献来自开发者对自己开发过程中问题的解决。但是，如果开发者不知道自己想从事什么工作，或者只是想更熟悉该项目，这里有一些关于如何找到合适任务的提示：

  - 查看[问题跟踪器](https://github.com/pytorch/pytorch/issues/)，看看是否有任何开发者知道如何解决的问题。其他贡献者确认的问题往往更适合调查。仓库为可能对开发者有用的问题保留了一些标签，例如**bootcamp**和**1hr**，尽管这些标签维护得并不算不太好。
  - 加入pytorch社区核心开发团队的 Slack，让社区知道开发者有兴趣了解 PyTorch。社区将很高兴帮助研究人员和合作伙伴快速了解代码库。

- 弄清楚您的更改范围，如果 GitHub 问题很大，请联系设计评论。

  大多数拉取请求都很小；在这种情况下，无需让核心开发团队知道您想做什么，只需做即可。但是，如果更改会很大，那么首先获得一些关于它的设计评论通常是个好主意。

  - 如果开发者不知道会有多大的变化，核心开发团队可以帮你搞清楚！只需在问题或 Slack 上发布它。
  - 一些功能添加非常标准化；例如，很多开发者向 PyTorch 添加新的运算符或优化器。这些情况下的设计讨论主要归结为“我们想要这个运算符/优化器吗？” 提供其效用的证据，例如，在同行评审论文中的使用，或在其他框架中的存在，在提出这种情况时会有所帮助。
    - **从最近发表的研究论文中添加算子/算法** 通常不被接受，除非有压倒性的证据表明这项新发表的工作具有开创性的成果并最终成为该领域的标准。如果您不确定您的方法在哪里，请在实施 PR 之前先打开一个问题。
  - 核心更改和重构可能很难协调，因为 PyTorch master 上的开发速度非常快。肯定会就根本性或跨领域的变化进行接触；我们通常可以提供有关如何将此类更改分阶段为更易于审查的部分的指导。

- 码出来！

  - 有关以技术形式使用 PyTorch 的建议，请参阅技术指南。

- 打开拉取请求。

  - 如果您尚未准备好审查拉取请求，请使用 [WIP] 标记它。在进行审核通过时，核心开发团队将忽略它。如果开发者正在处理复杂的变更，最好将事情作为 WIP 开始，因为您需要花时间查看 CI 结果，看看事情是否成功。
  - 为您的更改寻找合适的审阅者。核心开发团队有一些人会定期查看 PR 队列并尝试查看所有内容，但是如果开发者碰巧知道受补丁影响的给定子系统的维护者是谁，请随时将他们直接包含在拉取请求中。您可以在 PyTorch 子系统所有权中了解有关此结构的更多信息。

- 迭代拉取请求，直到它被接受！

  - 核心开发团队会尽量减少审查往返次数，只有在出现重大问题时才会阻止 PR。对于拉取请求中最常见的问题，请查看[常见错误](https://github.com/chunlindase/pytorch/blob/master/docs/source/community/contribution_guide.rst#common-mistakes-to-avoid)。
  
  - 一旦一个 pull request 被接受并且 CI 通过了，开发者就不需要做其他的事情了；核心开发团队将为开发者合并 PR。



### 3. 项目CI/CD的流程调研

#### 运行特定 CI 作业流程

您可以生成一个提交，将 CI 限制为仅运行特定作业，tools/testing/explicit_ci_jobs.py 如下所示：

```
# --job: specify one or more times to filter to a specific job + its dependencies
# --make-commit: commit CI changes to git with a message explaining the change
python tools/testing/explicit_ci_jobs.py --job binary_linux_manywheel_3_6m_cpu_devtoolset7_nightly_test --make-commit

# Make your changes

ghstack submit
```

注意：不建议使用此工作流程，除非您也使用 ghstack. 它创建了一个对审阅者来说信号非常低的大型提交。

#### CI失败提示

一旦您提交 PR 或将新提交推送到处于活动 PR 中的分支，CI 作业将自动运行。其中一些可能会失败，您需要通过查看日志找出原因。

通常情况下，CI 失败可能与您的更改无关。在这种情况下，您通常可以忽略故障。有关更多详细信息，请参阅以下小节。

某些故障可能与特定硬件或环境配置有关。在这种情况下，如果作业由 CircleCI 运行，您可以使用以下步骤通过 ssh 进入作业的会话以执行手动调试：

1. 在失败作业的 CircleCI 页面中，确保您已登录，然后单击右上角的Rerun操作下拉按钮。单击Rerun Job with SSH。

2. 当作业重新运行时，将在STEPS标签为的选项卡中添加一个新步骤Set up SSH。该选项卡内将是一个 ssh 命令，您可以在 shell 中执行该命令。

3. 通过 ssh 连接后，您可能需要进入一个 docker 容器。运行docker ps以检查是否有任何 docker 容器正在运行。请注意，您的 CI 作业可能正在启动 docker 容器，这意味着它还不会显示。最好等到 CI 作业到达构建 pytorch 或运行 pytorch 测试的步骤。如果作业确实有一个 docker 容器，请运行docker exec -it IMAGE_ID /bin/bash以连接到它。

4. 现在您可以找到 pytorch 工作目录，可以是 ~/workspace或~/project，并在本地运行命令以调试故障。


对于某些 Windows 故障，拥有完整的远程桌面连接可能很有用。请参阅[此处的](https://github.com/pytorch/pytorch/wiki/Debugging-Windows-with-Remote-Desktop-or-CDB-(CLI-windbg)-on-CircleCI)详细说明，了解如何在重新运行作业后进行设置。

##### CI中使用了哪个提交？

对于 CI run on master，针对给定master 提交检出此存储库，并在该提交上运行 CI（实际上没有任何其他选择）。然而，对于 PR，它有点复杂。考虑这个提交图，其中 master在 commit 处A，PR #42（只是一个占位符）的分支在 commit 处B：

```
       o---o---B (refs/pull/42/head)
      /         \
     /           C (refs/pull/42/merge)
    /           /
---o---o---o---A (refs/heads/master)
```

有两种可能的选择用于提交使用：

1. Checkout commit B，PR 的负责人（由 PR 作者手动提交）。

2. Checkout commit C，如果 PR 被合并到master（由 GitHub 自动生成）会发生什么的假设结果。


这种选择取决于几个因素；这是截至 2021-03-30 的决策树：

- 对于 CircleCI 上的 CI 作业：
  - 如果作业的名称（或其在工作流 DAG 中的祖先之一）包含“xla”或“gcc5”，则使用选项2。这包括以下工作：
    - pytorch_linux_xenial_py3_6_gcc5_4_build
      - pytorch_cpp_doc_build
      - pytorch_doc_test
      - pytorch_linux_backward_compatibility_check_test
      - pytorch_linux_xenial_py3_6_gcc5_4_jit_legacy_test
      - pytorch_linux_xenial_py3_6_gcc5_4_test
      - pytorch_python_doc_build
    - pytorch_xla_linux_bionic_py3_6_clang9_build
      - pytorch_xla_linux_bionic_py3_6_clang9_test
  - 否则，使用选项1。
- 对于 GitHub Actions 上的 CI 作业：
  - 如果 PR 是使用 创建的ghstack，则使用选项1。
  - 否则，使用选项2。

需要注意这一点很重要，因为如果您在 PR 上看到 CI 失败并且该 CI 作业正在使用选项2，则该失败可能是由您的祖先中不存在的提交不确定地引起的。公关部门。如果您碰巧拥有此 repo 的写入权限，您可以选择使用ghstack来消除 PR 上 GitHub Actions 作业的这种不确定性，但对于上面列出的选定 CircleCI 作业，它仍将存在。