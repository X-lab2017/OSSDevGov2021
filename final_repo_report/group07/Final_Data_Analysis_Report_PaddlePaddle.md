### 项目介绍

我们本次选择分析的项目是PaddlePaddle/Paddle,飞桨(PaddlePaddle)是集深度学习核心框架、工具组件和服务平台为一体的技术先进、功能完备的开源深度学习平台，已被中国企业广泛使用，深度契合企业应用需求，拥有活跃的开发者社区生态。提供丰富的官方支持模型集合，并推出全类型的高性能部署和集成方案供开发者使用。

### 数据分析

####  基础数据分析

<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\排名前十的项目.png">

图一为仓库活跃度排名前十的项目。排名第一的是kubernetes，score达到了100K。

<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\mergePRIssue.png">

图2 为Paddle项目在2020年1月到2020年12月之间开发人员提交的PR数目、issue comment和merge的数目，从图中我们可以看出提交的PR数目和issue comment的数目在2月到5月和6月到8月有明显的上升趋势，在8月达到顶峰，从这里可以看出开发的趋势是间歇性的。



####  开发者数据分析

<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\merge前十的开发者.png">

图三是merge数目排名前十的开发者名单，其中，merge最多的开发者是luotao1，接近项目merge数目的一半；其次是chenwhql，merge的数目也是接近1k。可以看出对项目做出主要贡献的人肯定离不开luotao1。



<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\活跃度前十的开发者.png">

图四是Paddle项目活跃度排名前十的开发者，其中，活跃度最高的开发者是luotao1，达到了1.1K；其次是 chenwhql ，merge的数目也是接近1k。可以看出对项目做出主要贡献的人肯定离不开luotao1。

### 项目关联数据分析

#### 项目关系网络图

通过 Hypertrons-crx 插件我们可以获得 PaddlePaddle/Paddle 项目的协作网络关系图。

项目关系网络图展示了在给定的时间段内，项目与项目之间的联结关系，用于项目间关系的追踪与挖掘。从该网络图中，可以找出与该项目有联结关系的其他项目。

- 节点：一个节点表示一个项目，节点大小与颜色的深浅表示项目活跃度的大小。
- 边：表示项目与项目之间存在联结关系，值的大小表示项目间联系的紧密程度。

<img src="E:/graduate/00_courses/研一_下学期/开源软件开发与社区治理 王伟/OSSDevGov2021/final_repo_report/group07/img/项目关系网络图.png">

项目关系网络图中间的节点是当前项目，我们可以看到 PaddlePaddle/Paddle 的项目活跃度是 3426.28，与其关联度最大的项目是 pytorch/pytorch，该项目的活跃度是 9723.67。

关联项目的活跃度比当前项目的活跃度更高，这似乎比较奇怪，但 PaddlePaddle/Paddle 作为重度依赖 Python 语言的人工智能项目， pytorch 又是能够提供强GPU加速的张量计算（如 NumPy）和基于磁带的自动标签系统的深度神经网络的 Python 包，那么这种活跃度差异又是可以理解的了。

| <img src="img\项目关系网络图-1.png"> | <img src="img\项目关系网络图-2.png"> |
| ------------------------------------ | ------------------------------------ |



PS：项目活跃度，其定义为某项目在一段时间内的活跃评价指标。其活跃度由单开发者在一天内的活跃度加总算得（时间点与时间段计算方式均基于开发者个人活跃度方式计算）：

$$
A_r=\sum(A_{u\_d}/day\_count)
$$


#### 项目活跃开发者协作网络图

通过 Hypertrons-crx 插件我们同样可以获得 PaddlePaddle/Paddle 项目的项目活跃开发者协作网络图。

项目活跃开发者协作网络图展示了在给定的时间段内，项目内部活跃的开发者之间的协作关系，用于项目内部开发者关系的追踪与挖掘。从该网络图中，可以找出该项目中最活跃的开发者，及开发者之间的协作关系。

- 节点：一个节点表示一个开发者，节点大小与颜色的深浅表示开发者对项目活跃度的贡献值。
- 边：开发者与开发者之间的连接关系，值的大小表示开发者间联系的紧密程度。

<img src="E:/graduate/00_courses/研一_下学期/开源软件开发与社区治理 王伟/OSSDevGov2021/final_repo_report/group07/img/项目活跃开发者协作网络图.png">

在上面这张图中，我们可以发现 PaddlePaddle/Paddle 项目有很多活跃的开发者，其中 zhiqu、chenwhql 是最活跃的两个开发者,活跃度分别为 40.64 和 40.22。

| <img src="img\项目活跃开发者协作网络图-1.png"> | <img src="img\项目活跃开发者协作网络图-2.png"> |
| ---------------------------------------------- | ---------------------------------------------- |



### 项目的日常协作流程调研

由提交次数图可以看出，每周一的提交记录最多的，周二——周五提交次数次数基本持平，周六和周日没有提交记录，这是因为周一要处理周末两天的问题，所以对程序的改动较大，不过这也侧面反映了该公司不是996工作模式。

<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\程序每日提交次数图.png">

由程序提交频率可以看出，每隔3个月，项目会有一次大的更新。

<img src="E:\graduate\00_courses\研一_下学期\开源软件开发与社区治理 王伟\OSSDevGov2021\final_repo_report\group07\img\程序提交频率.png">

#### PaddlePaddle发行规范

PaddlePaddle使用git-flow branching model做分支管理，使用Semantic Versioning标准表示PaddlePaddle版本号。

**PaddlePaddle每次发新的版本，遵循以下流程:**

1. 从`develop`分支派生出新的分支，分支名为`release/版本号`。例如，`release/0.10.0`

2. 将新分支的版本打上tag，tag为`版本号rc.Patch号`。第一个tag为`0.10.0rc1`，第二个为`0.10.0rc2`，依次类推。

3. 对这个版本的提交，做如下几个操作:

   - 修改`python/setup.py.in`中的版本信息,并将`istaged`字段设为`True`。

   - 编译这个版本的Docker发行镜像，发布到dockerhub。如果失败，修复Docker编译镜像问题，Patch号加一，返回第二步

   - 编译这个版本的Ubuntu Deb包。如果失败，修复Ubuntu Deb包编译问题，Patch号加一，返回第二步。

   - 使用Regression Test List作为检查列表，测试Docker镜像/ubuntu安装包的功能正确性

     - 如果失败，记录下所有失败的例子，在这个`release/版本号`分支中，修复所有bug后，Patch号加一，返回第二步

   - 编译这个版本的python wheel包，并发布到pypi。

     - 由于pypi.python.org目前遵循严格的命名规范PEP 513，在使用twine上传之前，需要重命名wheel包中platform相关的后缀，比如将`linux_x86_64`修改成`manylinux1_x86_64`。

     - pypi上的package名称为paddlepaddle和paddlepaddle_gpu，如果要上传GPU版本的包，需要修改build/python/setup.py中，name: "paddlepaddle_gpu"并重新打包wheel包：`python setup.py bdist_wheel`。

     - 上传方法：

       ```
        cd build/python
        pip install twine
        twine upload dist/[package to upload]
       ```

4. 第三步完成后，将`release/版本号`分支合入master分支，并删除`release/版本号`分支。将master分支的合入commit打上tag，tag为`版本号`。同时再将`master`分支合入`develop`分支。最后删除`release/版本号`分支。

5. 编译master分支的Docker发行镜像，发布到dockerhub。编译ubuntu的deb包，发布到github release页面

6. 协同完成Release Note的书写

**需要注意的是:**

- `release/版本号`分支一旦建立，一般不允许再从`develop`分支合入`release/版本号`。这样保证`release/版本号`分支功能的封闭，方便测试人员测试PaddlePaddle的行为。
- 在`release/版本号`分支存在的时候，如果有bugfix的行为，需要将bugfix的分支同时merge到`master`, `develop`和`release/版本号`这三个分支。

#### PaddlePaddle 分支规范

PaddlePaddle开发过程使用git-flow分支规范，并适应github的特性做了一些区别。

- PaddlePaddle的主版本库遵循git-flow分支规范。其中:
  - `master`分支为稳定(stable branch)版本分支。每一个`master`分支的版本都是经过单元测试和回归测试的版本。
  - `develop`分支为开发(develop branch)版本分支。每一个`develop`分支的版本都经过单元测试，但并没有经过回归测试。
  - `release/版本号`分支为每一次Release时建立的临时分支。在这个阶段的代码正在经历回归测试。
- 其他用户的fork版本库并不需要严格遵守git-flow分支规范，但所有fork的版本库的所有分支都相当于特性分支。
  - 建议，开发者fork的版本库使用`develop`分支同步主版本库的`develop`分支
  - 建议，开发者fork的版本库中，再基于`develop`版本fork出自己的功能分支。
  - 当功能分支开发完毕后，向PaddlePaddle的主版本库提交`Pull Reuqest`，进而进行代码评审。
    - 在评审过程中，开发者修改自己的代码，可以继续在自己的功能分支提交代码。
- BugFix分支也是在开发者自己的fork版本库维护，与功能分支不同的是，BugFix分支需要分别给主版本库的`master`、`develop`与可能有的`release/版本号`分支，同时提起`Pull Request`。

#### 交流沟通

- Github提交issue：错误报告、功能请求、安装问题、使用问题等。
- QQ 讨论群: 793866180 (名词：PaddlePaddle).
- 论坛:讨论实施、研究等问题，地址：https://ai.baidu.com/forum/topic/list/168?pageNo=1

------

### 开发者参与流程调研

#### 贡献者许可协议

为了阐明任何个人或实体的贡献所授予的知识产权许可，开源项目 PaddlePaddle必须有一份由每个贡献者签署的贡献者许可协议 (CLA)，表明同意许可条款如下。此许可证是为了保护您作为贡献者以及 PaddlePaddle 及其用户的保护；它不会改变您将自己的贡献用于任何其他目的的权利。

您接受并同意您现在和未来提交给 PaddlePaddle 的贡献的以下条款和条件。除了此处授予 PaddlePaddle 和 PaddlePaddle 分发的软件接收者的许可外，您保留对您的贡献的所有权利、所有权和利益。

1、定义。“您”是指与 PaddlePaddle 签订本协议的版权所有者或版权所有者授权的法律实体。对于法人实体，作出贡献的实体以及控制该实体、受其控制或与该实体处于共同控制下的所有其他实体均被视为单一贡献者。就本定义而言，“控制”是指 (i) 通过合同或其他方式直接或间接导致对该实体进行指导或管理的权力，或 (ii) 百分之五十 (50%) 或更多已发行股份，或 (iii) 该实体的实益拥有权。“贡献”是指作者的代码、文档或任何原创作品，包括对现有作品的任何修改或添加，由您有意提交给 PaddlePaddle 以包含在 PaddlePaddle 拥有或管理的任何产品（“作品”）中或对其进行记录。就本定义而言，“提交”是指发送给 PaddlePaddle 或其代表的任何形式的电子、口头或书面通信，包括但不限于电子邮件列表、源代码控制系统和问题跟踪系统上的通信。由 PaddlePaddle 或代表 PaddlePaddle 管理，以讨论和改进作品，但不包括明显标记或您以其他方式书面指定为“非贡献”的通信。
2、授予版权许可。根据本协议的条款和条件，您在此授予 PaddlePaddle 和 PaddlePaddle 分发的软件的接收者永久的、全球性的、非排他性的、免费的、免版税的、不可撤销的版权许可，以复制、准备、公开展示、公开表演、再许可和分发您的贡献和此类衍生作品。
3、授予专利许可。根据本协议的条款和条件，您特此授予 PaddlePaddle 和 PaddlePaddle 分发的软件的接收者一项永久性的、全球性的、非排他性的、免费的、免版税的、不可撤销的（本节中规定的除外）专利制作、已经制作、使用、提供销售、销售、进口和以其他方式转让作品的许可，如果此类许可仅适用于您可授权的那些专利权利要求，但您的贡献单独或组合侵犯了这些权利您对提交此类贡献的作品的贡献。如果任何实体对您或任何其他实体提起专利诉讼（包括诉讼中的交叉索赔或反索赔），声称您的贡献或您所贡献的作品，
4、您声明您在法律上有权授予上述许可。如果您是实体，则您进一步声明，您指定的每位员工均有权代表您提交捐款。如果您是个人并且您的雇主对您创建的包括您的贡献在内的知识产权拥有权利，则您进一步声明您已获得代表该雇主做出贡献的许可，您的雇主已放弃为您提供此类权利。对 PaddlePaddle 的贡献，或者您的雇主已经与 PaddlePaddle 签署了单独的 CLA。
5、如果您在 PaddlePaddle 上发布内容或提交材料，除非我们另有说明，您授予 PaddlePaddle 非排他性、免版税、永久、不可撤销和完全可再许可的使用、复制、修改、改编、发布、执行、翻译、创建的权利衍生作品、分发和在世界各地的任何媒体中展示此类内容。您授予 PaddlePaddle 和再许可持有人使用您提交的与此类内容相关的 GitHub 公共资料（包括但不限于名称）的权利。您声明并保证您拥有或以其他方式控制您发布的内容的所有权利；内容准确；使用您提供的内容不违反本政策，并且不会对任何个人或实体造成伤害；并且您将赔偿 PaddlePaddle 因您提供的内容而导致的所有索赔。PaddlePaddle 有权但无义务监控和编辑或删除任何活动或内容。PaddlePaddle 对您或任何第三方发布的任何内容不承担任何责任。
6、您声明您的每一项贡献都是您的原创。如果您希望提交的作品不是您的原创作品，您可以将其与任何贡献分开提交给 PaddlePaddle，确定其来源和任何许可或其他限制（包括但不限于相关专利、商标）的完整详细信息，和许可协议），您个人知道，并显着地将作品标记为“代表第三方提交：[在此处命名]”。
7、您不需要为您的贡献提供支持，除非您希望提供支持。您可以免费、收费或根本不提供支持。除非适用法律要求或书面同意，否则您按“原样”提供您的贡献，没有任何形式的明示或暗示的保证或条件，包括但不限于标题的任何保证或条件，非-侵权、适销性或特定用途的适用性。
8、您同意通知 PaddlePaddle 您所知道的任何事实或情况，虽然这些陈述在某些方面不准确

9、PaddlePaddle 保留随时更新或更改本协议的权利，方法是在 PaddlePaddle 上发布最新版本的协议，并显示新的生效日期为 2019 年 12 月 9 日。协议中的所有此类更改自生效之日起生效。在我们发布任何此类更改后，您继续使用 PaddlePaddle 表示您同意这些更改。如果您不同意当时的协议，您必须立即停止使用 PaddlePaddle。

#### 贡献代码的要求及流程

##### 前提

要为 PaddlePaddle 做出贡献，您必须同意 PaddlePaddle 贡献者许可协议

##### 代码要求

- 代码注释请遵守 Doxygen 的样式。


- 确保编译器选项 WITH_STYLE_CHECK 已打开，并且编译能通过代码样式检查。


- 所有代码必须具有单元测试。


- 通过所有单元测试。


- 请遵守提交代码的一些约定。

##### 代码提交流程

1. 在PaddlePaddle的GitHub首页，即https://github.com/PaddlePaddle/Paddle单击 `Fork` 按钮，生成自己目录下的仓库，例如：https://github.com/Ruizzzzzz/Paddle

2. 将远程仓库克隆到本地

   ```
   git clone https://github.com/Ruizzzzzz/Paddle
   cd Paddle
   ```

3. 创建本地分支

   Paddle 目前使用Git流分支模型进行开发，测试，发行和维护，具体请参考Paddle 分支规范

   所有的 feature 和 bug fix 的开发工作都应该在一个新的分支上完成，一般从 `develop` 分支上创建新分支。

   使用 `git checkout -b` 创建并切换到新分支。

   ```
   git checkout -b my-cool-stuff
   ```

   值得注意的是，在 checkout 之前，需要保持当前分支目录 clean，否则会把 untracked 的文件也带到新分支上，这可以通过 `git status` 查看。

4. 使用 `pre-commit `钩子

   Paddle 开发人员使用 pre-commit 工具来管理 Git 预提交钩子。 它可以帮助我们格式化源代码（C++，Python），在提交（commit）前自动检查一些基本事宜（如每个文件只有一个 EOL，Git 中不要添加大文件等）。

   `pre-commit`测试是 Travis-CI 中单元测试的一部分，不满足钩子的 PR 不能被提交到 Paddle，首先安装并在当前目录运行它：

   ```
   pip install pre-commit
   pre-commit install
   ```

   Paddle 使用 `clang-format` 来调整 C/C++ 源代码格式，请确保 `clang-format` 版本在 3.8 以上。

   注：通过`pip install pre-commit`和`conda install -c conda-forge pre-commit`安装的`yapf`稍有不同的，Paddle 开发人员使用的是`pip install pre-commit`。

5. 开发

   贡献者编写对项目进行改进的代码

6. 编译和单元测试

   贡献值编译程序并且确保可以通过所有单元测试

7. 提交

   贡献值提交自己对项目所做的修改，并编写提交说明，

   ```
   git add .
   git commit
   git push
   ```

8. 保持本地仓库更新

   在准备发起 Pull Request 之前，需要同步原仓库最新的代码。

   首先通过 `git remote` 查看当前远程仓库的名字。

   ```
   git remote
   ```

   origin

   ```
   git remote -v
   ```

   origin	https://github.com/USERNAME/Paddle (fetch)
   origin	https://github.com/USERNAME/Paddle (push)

   这里 origin 是贡献者 clone 的远程仓库的名字，也就是自己用户名下的 Paddle，接下来创建一个原始 Paddle 仓库的远程主机，命名为 upstream。

   ```
   git remote add upstream https://github.com/PaddlePaddle/Paddle
   git remote
   ```

   origin
   upstream

   获取 upstream 的最新代码并更新当前分支。

   ```
   git fetch upstreamgit pull upstream develop
   ```

9. 提交PR，等待项目工作人员审核

##### 提交PR注意事项

1. **建立 Issue 并完成 Pull Request**

   建立一个 Issue 描述问题，并记录它的编号。

   切换到所建分支，然后点击 `New pull request`。

   在 PR 的描述说明中，填写 `resolve #Issue编号` 可以在这个 PR 被 merge 后，自动关闭对应的 Issue。

   接下来等待 review，如果有需要修改的地方，参照上述步骤更新 origin 中的对应分支即可。

2. **签署CLA协议和通过单元测试**

   **签署CLA：**

   在首次向PaddlePaddle提交Pull Request时，您需要您签署一次CLA(Contributor License Agreement)协议，以保证您的代码可以被合入，具体签署方式如下：

   （1）请您查看PR中的Check部分，找到license/cla，并点击右侧detail，进入CLA网站

   （2）请您点击CLA网站中的“Sign in with GitHub to agree”,点击完成后将会跳转回您的Pull Request页面

   **通过单元测试：**

   您在Pull Request中每提交一次新的commit后，会触发CI单元测试，请确认您的commit message中已加入必要的说明

   请您关注您Pull Request中的CI单元测试进程，它将会在几个小时内完成

   您仅需要关注和自己提交的分支相关的CI项目，例如您向develop分支提交代码，则无需关注release/1.1一栏是否通过测试

   当所需的测试后都出现了绿色的对勾，表示您本次commit通过了各项单元测试

   如果所需的测试后出现了红色叉号，代表您本次的commit未通过某项单元测试，在这种情况下，请您点击detail查看报错详情，并将报错原因截图，以评论的方式添加在您的Pull Request中，我们的工作人员将帮您查看

3. **删除远程分支**

   在 PR 被 merge 进主仓库后，可以在 PR 的页面删除远程仓库的分支，也可以使用 `git push origin 分支名` 删除远程分支

4. **删除本地分支**

   使用 `git checkout 分支名`切换到本地分支，使用 `git branch -D 分支名`删除分支  

5. **提交代码的一些约定**

   为了使评审人在评审代码时更好地专注于代码本身，请您每次提交代码时，遵守以下约定：

   （1）请保证Travis-CI 中单元测试能顺利通过。如果没过，说明提交的代码存在问题，评审人一般不做评审。

   （2）提交PUll Request前：

   - 请注意commit的数量：

   原因：如果仅仅修改一个文件但提交了十几个commit，每个commit只做了少量的修改，这会给评审人带来很大困扰。评审人需要逐一查看每个commit才能知道做了哪些修改，且不排除commit之间的修改存在相互覆盖的情况。

   建议：每次提交时，保持尽量少的commit，可以通过`git commit --amend`补充上次的commit。

   - 请注意每个commit的名称：应能反映当前commit的内容，不能太随意。

   3）如果解决了某个Issue的问题，请在该PUll Request的**第一个**评论框中加上：`fix #issue_number`，这样当该PUll Request被合并后，会自动关闭对应的Issue。关键词包括：close, closes, closed, fix, fixes, fixed, resolve, resolves, resolved，请选择合适的词汇。

6. **回复评审人意见时的一些约定**

   此外，在回复评审人意见时，请您遵守以下约定：

   1）评审人的每个意见都必须回复（这是开源社区的基本礼貌，别人帮了忙，应该说谢谢）：

   - 对评审意见同意且按其修改完的，给个简单的`Done`即可；
   - 对评审意见不同意的，请给出您自己的反驳理由。

   2）如果评审意见比较多：

   - 请给出总体的修改情况。
   - 请采用start a review进行回复，而非直接回复的方式。原因是每个回复都会发送一封邮件，会造成邮件灾难。

------

### 项目的CI/CD流程调研

如果一个团队缺乏统一标准的环境，再努力，也是事倍功半。而使用容器化技术、CI/CD，不仅能让开发环境、测试环境、预发环境、生产环境保持一致，同时也对测试和质量保证有至关重要的作用，能达到事半功倍的效果。

由于项目同时部署在Gitee平台上，地址为：https://gitee.com/paddlepaddle/Paddle，所以可以使用平台提供的一些CI/CD集成工具。

#### Gitee Go

Gitee Go (Beta) 是 Gitee 平台的 CI 持续集成服务，可实现自动测试、编译构建、持续集成、部署等需求，可用来替代类似 Jenkins 服务，是 Gitee DevOps 能力的重要一环。目前支持 Java、Maven、Gradle、Ant、NPM、Python、PHP、Go 、Docker 等类型项目。

注意：Gitee Go 为增值服务，计费方式为预付费，按构建时长购买。付费企业套餐资费不包含 Gitee Go 等增值服务，如需使用需单独购买。

![image-20210710154904643](C:\Users\RUI\AppData\Roaming\Typora\typora-user-images\image-20210710154904643.png)

#### 百度效率云

百度效率云是百度云上DevOps平台，使用百度效率云-iPipe连接 Gitee 代码库，可以使您方便地编译、扫描、测试、部署您的应用程序。效率云-iPipe支持Python、Java、Javascript、C、C++、PHP、Go等主流语言的编译、Docker构建、镜像制品管理以及云端部署。您还可以使用百度效率云iScan进行源码扫描、使用iTest进行自动化接口测试和性能测试。灵活的流水线自定义编排可以满足您的需求。

#### Jenkins 插件

Gitee Jenkins Plugin 是Gitee基于 [GitLab Plugin](https://github.com/jenkinsci/gitlab-plugin) 开发的 Jenkins 插件。用于配置 Jenkins 触发器，接受Gitee平台发送的 WebHook 触发 Jenkins 进行自动化持续集成或持续部署，并可将构建状态反馈回Gitee平台。

#####  目前支持特性：

- 推送代码到Gitee时，由配置的 WebHook 触发 Jenkins 任务构建。
- 评论提交记录触发提交记录对应版本 Jenkins 任务构建
- 提交 Pull Request 到Gitee项目时，由配置的 WebHook 触发 Jenkins 任务构建，支持PR动作：新建，更新，接受，关闭，审查通过，测试通过。
- 支持 [ci-skip] 指令过滤 或者 [ci-build] 指令触发构建。
- 过滤已经构建的 Commit 版本，若是分支 Push，则相同分支Push才过滤，若是 PR，则是同一个PR才过滤。
- 按分支名过滤触发器。
- 正则表达式过滤可触发的分支。
- 设置 WebHook 验证密码。
- 构建后操作可配置 PR 触发的构建结果评论到Gitee对应的PR中。
- 构建后操作可配置 PR 触发的构建成功后可自动合并对应PR。
- 对于 PR 相关的所有事件，若 PR 代码冲突不可自动合并，则不触发构建；且若配置了评论到PR的功能，则评论到 PR 提示冲突。
- PR 评论可通过 WebHook 触发构建（可用于 PR 触发构建失败是便于从Gitee平台评论重新触发构建）
- 支持配置 PR 不要求必须测试时过滤触发构建。（可用于不需测试则不构建部署测试环境）
- 支持相同 PR 触发构建时，取消进行中的未完成构建，进行当前构建（相同 PR 构建不排队，多个不同 PR 构建仍需排队）

#### 腾讯云 Serverless Framework

Serverless Framework是业界非常受欢迎的无服务器应用框架，开发者无需关心底层资源，即可部署完整的 Serverless 应用架构。Serverless Framework 具有资源编排、自动伸缩、事件驱动等能力，覆盖编码、调试、测试、部署等全生命周期，帮助开发者通过联动云资源，迅速构建 Serverless 应用。

目前，Serverless Framework 与 Gitee 全面达成合作，托管在 Gitee 的项目代码，可以通过 Serverless 应用控制台直接进行部署，实现传统 Web 框架快速上云与管理。

##### 功能优势

- **低改造成本：** Serverless 组件自动帮助用户完成框架上云的适配转换，用户只需聚焦业务代码，部分框架甚至不需要改造一行代码，即可完成云端部署。
- **应用层级资源展示与管理:** 部署成功后，用户可以方便地通过 Serverless 应用控制台将查看和管理创建的云端资源，无需多个页面切换，实现多资源的集中管理。
- **基于代码托管持续构建：** 支持持续构建，当 Gitee 仓库的项目有更新时，可以自动触发重新部署。
- **应用层级监控图表:** 提供了应用层级的监控能力，用户不仅可以看到每个资源的调用次数、错误次数等信息，还可以看到应用层级的监控指标，方便运维。

#### Azure PipeLine

`Azure Pipeline` 是由微软推出的 `Azure Devops` 的 `CI` 部分，其前身是 `VSTS` 。目前 `Azure Pipeline` 支持 `Node.js`、`Python`、`Java`、`PHP`、`Ruby`、`C`/`C++`、`.NET`、`Android`、`iOS` 等语言在 `Linux`、`macOS` 和 `Windows` 操作系统的云上进行构建和部署，可谓是非常强大。

除此之外，`Azure Pipelines` 为开源项目免费地提供 `CI`/`CD` 不限时服务和10个并行作业。所有开源项目都免费运行在同样的基础架构上，也就意味着具有同样性能和服务质量。对于开源项目而言，这是极大的方便并节省了开发者需要付出的成本。

通过将 `Gitee` 的代码仓库与 `Azure Devops Pipelines`对接，开发者可以轻松完成项目的`持续集成(CI)`工作，在持续的基础上收到项目的反馈并进行改进，进而提升开发效率，缩短研发周期，不必等到开发周期后期才寻找和修复缺陷。作为现代软件开发技术的基础，`持续集成`在研发环节起到至关重要的作用，值得每个人去关注和学习。

------

### 开发合作流程中可能出现的问题以及解决方案

1. ##### CLA签署不成功，怎么办？

  由于 CLA 是第三方开源库，有时候会不稳定。如果确定自己已签署CLA，但CLA没触发成功，可尝试：

  （1）关闭并重新开启本PR，来重新触发CLA。点击 Close pull request ，再点击 Reopen pull request ，并等待几分钟。

  （2）如果上述操作重复2次仍未生效，请重新提一个PR或评论区留言。

2. ##### **CI没有触发，怎么办？**

   （1）请在commit信息中添加正确的CI触发规则：

  a、develop分支请添加 test=develop

  b、release分支请添加如 test=release/1.4 来触发release/1.4分支

  c、文档预览请添加 test=document_preview

  （2）该CI触发规则以commit为单位，即对同一个PR来说，不管前面的commit是否已经添加，如果新commit想继续触发CI，那么仍然需要添加。

  （3）添加CI触发规则后，仍有部分CI没有触发：请关闭并重新开启本PR，来重新触发CI。

3. ##### **CI随机挂，即错误信息与本PR无关，怎么办？**

   由于develop分支代码的不稳定性，CI可能会随机挂。 如果确定CI错误和本PR无关，请在评论区贴上错误截图和错误链接。

4. ##### **如何修改API.spec？**

   为了保证API接口/文档的稳定性，我们对API进行了监控，即API.spec文件。 修改方法请参考 diff_api.py 。

  注意：提交PR后请查看下diff，不要改到非本PR修改的API上。