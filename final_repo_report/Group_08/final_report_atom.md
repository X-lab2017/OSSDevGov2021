# Atom项目2020年深入数据分析

## 1、引言

​		2020注定是个不平凡的数字，开源的2020也是如此。

​		开源推动者与 Android 专家 Jack Wallen 近日发表了一篇文章，预测了未来的开源局势，他们认为 2020 年的开源前途一片光明。如，Deepin Linux，Deepin 15.11 计划发布一项功能 --- Deepin Cloud Sync，该功能可能会改变Linux发行版的版图；更强的开源自动化效率，由于推动了更高效率的 CI/CD 管道的发展，我们见证了令人印象深刻的自动化技术的兴起。借助 Helm、Terraform 和其它以 Kubernetes 为中心的工具，可以创建可自我更新、测试代码并且在出现问题时不将其推向生产的系统。

​		2020年众多开源项目做出巨大的变化，本报告对Atom项目2020年的数据进行分析。

## 2、总体概况

​		在代码编辑器、文本编辑器领域，有着不少的**神器级**的产品，如历史悠久的 VIM、Emacs 以及如今当红的 SublimeText。另外还有 VS Code、EditPlus、NotePad++、UltraEdit 等一大堆流行的利器，可谓百家争鸣。然而，作为目前全球范围内影响力最大的代码仓库/开源社区，GitHub 的程序员们并不满足于此。他们使用目前最先进流行的技术重新打造了一款称为“属于21世纪”的代码编辑 --- Atom， 它开源免费跨平台，并且整合 GIT 并提供类似 SublimeText 的包管理功能，支持插件扩展，可配置性非常高。Atom 代码编辑器支持 Windows、Mac、Linux 三大桌面平台，完全免费，并且已经在 GitHub 上开放了全部的源代码。在经过一段长时间的迭代开发和不断改进后，Atom 终于从早期的测试版达到了 1.0 正式版了！相比之前的版本，在性能和稳定性方面都有着显著的改善。

​        开发团队将 Atom 称为一个“为 21 世纪创造的可配置的编辑器”，它拥有非常精致细腻的界面，可配置项丰富，加上它提供了与 SublimeText 上类似的包管理功能，人们可以非常方便地安装和管理各种插件，并将 Atom 打造成真正适合自己的开发工具。作为一个现代的代码编辑器，Atom 有着各种流行编辑器都有的特性，功能上非常丰富，支持各种编程语言的代码高亮，与大多数其他编辑器相比，Atom 的语言支持已经算是覆盖非常全面了。另外，它的代码补全功能也非常好用，你只需输入几个字符即可展开成各种常用代码，极大提高编程效率。

​        Atom具有非常多的优点，同时它是世界上最大的开源项目之一，今天我们的报告主要从数据分析和流程调研两个方面对Atom项目进行深入分析。

## 3、报告内容分析

### 3.1、数据类分析

#### 3.1.1、Atom基础的统计数据分析、可视化
##### 项目2020年每月pull Request的数量

![image-20210628192156155](https://gitee.com/yyjjtt/picture_bed/raw/master/img/image-20210628192156155.png)

图 3.1.1.1

​		上图表示Atom项目在2020年每月pull request的数量，从上图可以看出1-10月份提交pull request的数量呈递增趋势，而从10-12月份提交pull request数量呈减少趋势，提交pull requests 主要集中在9，10，11月份，这可能是Atom项目开发的活跃期。

##### 项目中完成issue的数量

![image-20210628192417425](https://gitee.com/yyjjtt/picture_bed/raw/master/img/image-20210628192417425.png)

图 3.1.1.2

​		上图表示Atom项目在2020年每个月完成的issue的数量，相对较多的月份是5月，9月，以及10月份，但整体来看，除了年末的12月份，其他月份相差不大，相对来说比较平均。可以看出Atom项目的开发相对比较稳定，参与项目的开发者们能够比较稳定的对这个项目做出贡献，保证Atom的活力。

##### 项目不同事件发起数量

![image-20210628192529145](https://gitee.com/yyjjtt/picture_bed/raw/master/img/image-20210628192529145.png)

图 3.1.1.3

​		上图表示2020年关于该项目的不同种类的项目的发起数量。占据主要比重的是WatchEvent，IssueCommentEvent以及ForkEvent，数量分别是5316，3933，1832。说明Atom受到非常大的关注，并且关注这些项目的人也乐于参与到项目的讨论中。

#### 3.1.2、Atom开发者数据统计、可视化

##### 开发者参与项目方式

![图3.1.2.1](https://gitee.com/yyjjtt/picture_bed/raw/master/img/%E5%9B%BE3.1.2.1.png)

图3.1.2.1

​		2020年对Atom项目感兴趣的开发者共9537位，总共涉及16632条贡献数据。根据已有的数据，从开发者对项目的感兴趣角度来看，开发者对 Atom 项目的兴趣事件分为十三类，具体的分类情况如图3.1.2.1所示，多数开发者以WatchEvent、IssuesEvent、PullRequestEvent、ForkEvent、IssueCommentEvent等事件参与项目。

##### 开发者参与项目时间段

![图3.1.2.2](https://gitee.com/yyjjtt/picture_bed/raw/master/img/%E5%9B%BE3.1.2.2.png)

图3.1.2.2

​		开发者对项目的感兴趣方向是重点，参与项目的时间也是重点，根据已有数据分析了开发者参与项目的时间分布，如图3.1.2.2 所示，开源社区中的大部分开发者遵循工作日工作原则，工作日期间开发者对项目进行贡献的热度明显较周末对项目进行贡献来得高。

##### 开发者每日贡献度波动

![图3.1.2.3](https://gitee.com/yyjjtt/picture_bed/raw/master/img/%E5%9B%BE3.1.2.3.png)

图3.1.2.3

​		Atom 项目是顶级的开源项目之一，按照数据将开发者每天对Atom项目的贡献做成折线图，如图3.1.2.3，从图中分析，开发者对项目最低日贡献为17左右，对项目最高日贡献为78左右，每天都有开发者对项目进行贡献和讨论，开发者对Atom项目贡献稳定认可度大，侧面来说，对于顶级项目开发者粘度大。

#### 3.1.3、Atom关联数据的分析、可视化

##### 与Atom具有最多共同开发者的项目Top10

​      ![image-20210628204623193](https://gitee.com/yyjjtt/picture_bed/raw/master/img/image-20210628204623193.png)        

图3.1.3.1

​		拥有共同开发者是衡量项目关联程度的重要指标。同时根据拥有共同开发者项目的级别，也从侧面表现当前项目开发者质量，以及项目本身在业界受关注程度。

​		在图3.1.3.1中可以看到与Atom拥有共同开发者较多的项目大多是也是开源届比较顶级的项目，其中vscode与Atom拥有最多的共同开发者。这也是比较有意思的地方，Atom作为编辑器中的后期之秀，与vscode这种编辑器界的集大成者，有很多相同的开发者，一方面让人感叹圈子真小，另一方面也表现了同类开源产品的交流之密切。

##### 与Atom具有最多共同开发者的组织Top10

![image-20210628204723678](https://gitee.com/yyjjtt/picture_bed/raw/master/img/image-20210628204723678.png)        

图3.1.3.2

​		分析与Atom拥有共同开发者比较多的项目所属的组织，可以业界关注该项目的组织。一方面可以看出项目质量，另一方面在项目本身已经是同类顶级项目的情况下，可以判断相关组织在该领域的投入情况。

​		图3.1.3.2中可以看到和Atom共同开发者较多的组织可以说各个都是鼎鼎大名，microsoft、google、facebook这前三名的分量已经充分说明Atom受到很多顶级公司的关注。第一名是微软，这和上面项目分析的结果相符。可以看出微软在编辑器界的投入颇多，结合微软收购Github，还有投入巨大的各种ide，微软对开发者使用工具的重视，也侧面说明互联网世界得开发者才能得天下吧

### 3.2、流程类分析

#### 3.2.1、项目的日常协作流程调研

##### Atom日常协作分类

​		Atom日常协作主要分为一下4类：

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

​		线上协作比较重要的一点是如何用文字表达清楚自己做了什么。Atom提供4种不同的贡献文档模板，内容详细，具有较高参考价值，简单介绍下相关内容，对于相同字段不做解释。

​		修改bug说明模板

1. 识别Bug：此处提供你修改的Bug对应issue链接，如果没有创建相关issue，需要先创建。
2. 变更说明：描述变更内容，用于PR维护者审查。
3. 替代设计：可能的替代方案
4. 可能的缺点：改动可能带来的负面影响
5. 验证过程：详细说明基于什么流程来体现修改的作用
6. 发行说明：用一句用户易于理解的话描述更改

​		性能改进说明模板

1. 变更说明
2. 定量性能优势：描述观察到的确切的性能改价（如完成操作的时间减少、内存使用减少）
3. 可能的缺点
4. 验证过程
5. 适用问题：该性能改进使用的场景。
6. 发行说明

​		文档更新说明模板

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

​		开发者参与流程调研主要分为5类：

##### 开发者参与项目的行为准则

​       开发者可以被接受的行为示例：使用受欢迎和包容的语言、尊重不同的观点和经验、优雅地接受建设性的批评、专注于对社区最有利的事情。

​       开发者不被接受的行为示例：使用色情语言或图像以及不受欢迎的性关注或性挑逗、发布侮辱或贬损评论以及个人或政治攻击、公共或私人骚扰、未经明确许可，发布他人私人信息。

##### 开发者提问或讨论的方式

​       不要采用 Issue 的方式提问题，采用官方 Atom 和 Electron 留言板进行讨论或者加入 Atom 和 Electron Slack 团队，Slack 是一种聊天服务，有时社区成员需要需要几个小时才能回复，在其中使用 #atom 频道进行关于Atom的一般问题或讨论，使用 #electron 频道询问有关Electron 的问题，使用 #packages 频道进行编写或贡献 Atom 包的问题的讨论，使用 #ui 频道进行有关 Atom UI 和主题的问题的讨论。

##### 开发者参与项目前的准备

​        开发者在进行贡献前需要了解200多个存储库中哪一个实现想要更改或报告错误的功能，可以在 Atom 中 Settings > Packages 查看核心软件包位置，从 atom/design-decisions 存储库中查看重大决策记录

##### 开发者报告错误的方式

​        在创建错误报告时，包含尽可能多的详细信息，填写所需的模板，有助于更快地解决问题。如果发现一个 Closed 问题与遇到的问题相同，请打开一个新问题并在新问题的正文中包含指向原始问题的链接。

​        在提交错误报告之前：检查调试指南，或许能够找到问题的原因并自行解决问题。最重要的是，检查是否可以在最新版本的 Atom 中重现该问题，是否在安全模式下运行 Atom 时出现问题，以及是否可以通过更改Atom 或包的配置设置来获得所需的行为。查看论坛上的常见问题解答以获取常见问题和问题的列表。确定应该在哪个存储库中报告问题。执行粗略搜索以查看问题是否已报告。如果有并且问题仍然存在，请为现有问题添加评论，而不是打开一个新问题。

​		如何提交（好的）错误报告？错误被跟踪为GitHub 问题。在确定错误与哪个存储库相关后，在该存储库上创建问题并通过填写模板来提供以下信息。解释问题并包含其他详细信息以帮助维护人员重现问题，为问题使用清晰的描述性标题来识别问题。尽可能详细地描述重现问题的确切步骤。例如，首先解释你如何启动 Atom 的，例如在终端中使用了哪个命令，或者如何以其他方式启动 Atom。在列出步骤时，不要只说你做了什么，而是解释你是如何做的。例如，如果你将光标移动到一行的末尾，请说明你是否使用了鼠标、键盘快捷键或 Atom 命令，如果使用了，是哪一个。提供具体的例子来演示这些步骤。包括指向文件或 GitHub 项目的链接，或复制粘贴片段，你在这些示例中使用。如果你在问题中提供片段，请使用Markdown 代码块。描述在遵循这些步骤后观察到的行为，并指出该行为的问题究竟是什么。解释你希望看到的行为以及原因。如果你报告 Atom crashed，请包含一份带有来自操作系统的堆栈跟踪的崩溃报告。在 macOS 上，崩溃报告将 `Console.app` 在 “诊断和使用信息” > “用户诊断报告”下提供。将问题中的崩溃报告包含在代码块、文件附件中，或将其放入要点并提供指向该要点的链接。如果问题与性能或内存有关，请在报告中包含CPU 配置文件捕获。如果 Chrome 的开发人员工具窗格在你未触发的情况下显示，这通常意味着你的主题之一或 `styles.less`。 尝试在安全模式下运行并使用不同的主题或注释掉你的内容 `styles.less` 以查看是否可以解决问题。

​		如果问题不是由特定操作触发的，请描述问题发生前你正在做什么，并使用以下指南分享更多信息。通过回答以下问题提供更多背景信息。你能在安全模式下重现这个问题吗？问题是最近开始发生的（例如，在更新到新版本的 Atom 之后）还是这一直是一个问题？如果问题最近开始发生，能否在旧版本的 Atom 中重现该问题？没有出现问题的最新版本是什么？可以从发布页面下载旧版本的 Atom 。你能可靠地重现这个问题吗？如果没有，请提供有关问题发生的频率以及通常发生的条件的详细信息。如果问题与处理文件有关（例如打开和编辑文件），问题是所有文件和项目都会出现，还是仅部分出现？问题是否仅在处理本地或远程文件（例如在网络驱动器上）、特定类型的文件（例如仅 JavaScript 或 Python 文件）、大文件或行很长的文件或特定文件中的文件时发生？编码？使用的文件还有什么特别之处吗？包括有关你的配置和环境的详细信息，使用的是哪个版本的 Atom? 可以以通过 `atom -v` 在终端中运行或通过启动 Atom 并 `Application: About` 从命令面板运行命令来获取确切版本。你使用的操作系统的名称和版本是什么？你是在虚拟机中运行 Atom 吗？如果是这样，使用的是哪种 VM 软件以及主机和使用哪些操作系统和版本？你安装了哪些软件包，可以通过运行获取该列表 `apm list --installed`。是否使用本地配置文件 `config.cson`，`keymap.cson`，`snippets.cson`，`styles.less` 和 `init.coffee` 定制的Atom？如果是这样，请提供这些文件的内容，最好在代码块中链接。你是否在多台显示器上使用 Atom？如果是这样，当你使用单个显示器时，你能重现该问题吗？你使用的是哪种键盘布局？你使用的是美国布局还是其他布局？

##### 参与者参与项目拉取请求的模式

​		这里描述的过程有几个目标。保持 Atom 的质量、修复对用户很重要的问题、让社区参与到尽可能最好的 Atom 中、为 Atom 的维护者提供一个可持续的系统来审查贡献。

​		请按照以下步骤让维护者考虑你的贡献。遵循模板中的所有说明、遵循风格指南、提交拉取请求后，验证所有状态检查是否通过如果状态检查失败怎么办？

​		虽然在审查拉取请求之前必须满足上述先决条件，但在拉取请求最终被接受之前，审查者可能会要求你完成额外的设计工作、测试或其他更改。

#### 3.2.3、项目CI/CD的流程调研

#### Atom的CI的脚本

##### 不同的系统构建Atom包的模板并运行其规范：

* Windows, macOS 和 Ubuntu Linux：使用https://github.com/features/actions
* macOS 和 Ubuntu Linux：使用https://travis-ci.org/
* Windows：使用https://www.appveyor.com/
* Ubuntu Linux / Docker：使用https://circleci.com/

##### 为你的包设置CI

**GitHub操作**

* 将 [.github/workflows/main.yml](https://raw.githubusercontent.com/atom/ci/master/.github/workflows/main.yml) 复制到包的存储库树中的同一位置
* 您的包现在就将构建并运行其规范；您可以在这里看到一个配置包的示例：https://github.com/thumperward/auto-create-files/actions

**Travis CI**

* 在Travis CI上注册帐户
* 将https://raw.githubusercontent.com/atom/ci/master/.travis.yml复制到包存储库的根目录
* 在包的存储库上设置Travis CI hook：https://docs.travis-ci.com/user/tutorial/
* 您的包现在将构建并运行其规范；您可以在这里看到一个配置包的示例：https://travis-ci.org/github/atom/wrap-guide

**Appveyor**

* 在Appveyor上注册帐户
* 添加新项目
* 保未选中“设置”>“常规”中的“Ignore appveyor.yml”设置
* 将appveyor.yml复制到包存储库的根目录：https://raw.githubusercontent.com/atom/ci/master/appveyor.yml
* 您的包现在将构建并运行其规范；您可以在这里看到一个配置包的示例：https://ci.appveyor.com/project/Atom/wrap-guide

**CircleCI**

* 在CircleCI注册帐户
* 在项目的根目录下创建一个.circleci目录
* 将config.yml复制到新目录：https://raw.githubusercontent.com/atom/ci/master/.circleci/config.yml
* 提交更改并将其推送到GitHub
* 在CircleCI上添加新项目：https://circleci.com/docs/2.0/hello-world/
* 您的包现在将构建并运行其规范；您可以在这里看到一个配置包的示例：https://circleci.com/vcs-authorize/?return-to=https%3A%2F%2Fapp.circleci.com%2Fpipelines%2Fgithub%2FAtomLinter%2Flinter-stylelint

##### 常见问题

**如何安装包构建所依赖的其他Atom包?**

​		将CI配置文件中的APM_TEST_PACKAGES环境变量设置为在运行包的测试之前要安装的包的以空格分隔的列表。

```
 env:
 \- APM_TEST_PACKAGES="autocomplete-plus some-other-package-here
```



**哪个版本的Atom用于运行规范？**

​		它将始终下载最新的可用版本。您可以在这里阅读有关最新Atom版本的更多信息：https://atom.io/releases

**它是如何工作的？**

​		apm test命令假定您的包使用Jasmine规范。您可以使用Atom的specrunner UI从View>Developer>runpackagespecs菜单或按cmd-ctrl-alt-p本地运行规范。您可以运行apm help test来了解有关该命令的更多信息。

**GitHub操作**

​		CI模板使用Atom设置操作在运行程序上安装和设置Atom。然后，脚本从包中安装依赖项，并运行apm test命令来运行包的规范。

**Travis CI, CircleCI**

​		CI模板从此存储库下载build-package.sh。然后，这个脚本下载最新的Atom版本，安装包的依赖项，并运行apmtest命令来运行包的规范。

**Appveyor**

​		appveyor.yml模板使用chocooley下载并安装最新版本的Atom。apm安装在包目录中运行，以确保任何节点依赖项都可用。最后，脚本运行apm test命令来运行包的规范。


## 4、总结

​		Atom从开始时候对C，Go，Python等语言支持不好，首先没有ctags插件，没有支持gocode补全的插件, 也没有python的代码补全，基本只有高亮。从开发者参与和Atom管理来看。随着Atom的不断发展和各位开发者的不断贡献，Atom未来的发展是可期的。

## 5、附录(SQL代码)

**与Atom具有最多共同开发者的项目Top10**

```sql
SELECT repo_name , COUNT(*)from (select  distinct repo_name, actor_id  from year2020  where actor_id in (select DISTINCT actor_id from year2020 where repo_name = 'atom/atom' ) and repo_name != 'atom/atom') GROUP BY repo_name ORDER BY count(*) desc limit 10;
```

**与Atom具有最多共同开发者的组织Top10**

```sql
SELECT org_login , COUNT(*)from (select  distinct org_login, actor_id  from year2020  where actor_id in (select DISTINCT actor_id from year2020 where repo_name = 'atom/atom' ) and repo_name != 'atom/atom') GROUP BY org_login ORDER BY count(*) desc limit 20;
```

**开发者参与项目的方式**

```sql
SELECT type, count(*)
FROM ( 
SELECT type, actor_id, repo_name, org_id, created_at, issue_number, issue_title, issue_body, issue_author_id, issue_author_type, issue_comments, repo_description, repo_size, 
repo_stargazers_count, repo_forks_count, repo_language, repo_created_at, repo_updated_at, repo_pushed_at
FROM year2020
WHERE repo_name = 'atom/atom'
)
GROUP BY type;
```

**开发者参与项目的时间段**

```sql
SELECT toDayOfWeek( created_at ) as weekday, count(*)
FROM ( 
SELECT type, actor_id, repo_name, org_id, created_at, issue_number, issue_title, issue_body, issue_author_id, issue_author_type, issue_comments, repo_description, repo_size, 
repo_stargazers_count, repo_forks_count, repo_language, repo_created_at, repo_updated_at, repo_pushed_at
FROM year2020
WHERE repo_name = 'atom/atom'
)
GROUP BY toDayOfWeek( created_at );
```

**参与者每日贡献波动**

```sql
SELECT * 
FROM daily_activity
WHERE repo_name = 'atom/atom' and toYear( date_time)=2020
ORDER BY date_time ; 
```

**参与者人数**

```sql
SELECT count( * )
FROM (
    SELECT distinct actor_id
	FROM year2020
	WHERE repo_name = 'atom/atom'
) 
```

**参与者涉及数据数目**

```sql
SELECT count( * )
FROM year2020
WHERE repo_name = 'atom/atom';
```

**2020年Atom不同月份提交pull requests的数量**

```sql
SELECT COUNT(id) AS Count,toMonth(created_at)
  FROM year2020
 WHERE repo_name= 'atom/atom'
   AND type= 'PullRequestEvent'
 GROUP BY toMonth(created_at)

```

**2020年Atom不同月份完成issue的数量**

```sql
SELECT COUNT(issue_closed_at) AS countOfclosed,toDate(issue_closed_at)
  FROM year2020
 WHERE repo_name= 'atom/atom'
GROUP BY toDate(issue_closed_at) 
```

**统计2020年Atom不同事件的数量**

```sql
SELECT COUNT(*) AS Count, type 
  FROM year2020
 WHERE repo_name= 'atom/atom'
GROUP BY type
```
**2020年Atom不同月份提交pull requests的数量**

```sql
SELECT COUNT(id) AS Count,toMonth(created_at)
  FROM year2020
 WHERE repo_name= 'atom/atom'
   AND type= 'PullRequestEvent'
 GROUP BY toMonth(created_at)

```

**2020年Atom不同月份完成issue的数量**

```sql
SELECT COUNT(issue_closed_at) AS countOfclosed,toDate(issue_closed_at)
  FROM year2020
 WHERE repo_name= 'atom/atom'
GROUP BY toDate(issue_closed_at) 
```

**统计2020年Atom不同事件的数量**

```sql
SELECT COUNT(*) AS Count, type 
  FROM year2020
 WHERE repo_name= 'atom/atom'
GROUP BY type
```
