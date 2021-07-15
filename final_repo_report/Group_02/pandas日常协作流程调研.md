## pandas社区协作流程调研

### 1 项目的日常协作流程调研

#### 1.1贡献工作

​	**1 Bug reports and enhancement requests**

​	错误报告是使 Pandas 更加稳定的重要组成部分。完整的错误报告将有助于其他人重现错误并提供修复的见解。编写错误报告需要按照格式规范完成。在提交错误报告前需在 master 分支上测试产生错误的代码，以确认错误仍然存在。还要搜索现有的错误报告和拉取请求，以查看问题是否已被报告或修复。

​	**2 Contributing to the documentation**

​	对文档的贡献使使用 Pandas 的每个人都受益。

​	**3 Contributing to the code base**

​	贡献代码有规范的流程，这一部分在开发者参与流程调研中详细说明。

#### 1.2 维护工作

​	**1 Issue triage**

​	issue分类主要有以下几步：

- 感谢报告着开启issue

- 确认issue中提供了必要的信息

- 确认是否是重复issue

- 问题是否最小化且可重现

- 问题是否有用

- 应该添加哪些标签和里程碑

  **2 Closing issues**

​	许多人认为结束issue是对话结束了。通常最好给issue报告者一些时间来回应或自行关闭他们的问题。有时issue报告者会忘记，那么应该在对话结束后关闭issue。

​	**3 Reviewing pull requests**

​	任何人都可以审查pull requests：常规贡献者、分类人员或核心团队成员。但是只有核心团队成员准备好后才能合并 pull request。

​	**4 Cleaning up old issues**

​	有时，bug已经被修复，但问题并未与pull request相关联。在这些情况下，给issue评论“这已经修复，但需要测试。并将问题标记为“Good first issue”和“Needs Test”。

​	如果较旧的问题缺少可重现的示例，请将其标记为“Needs Info”并要求提供一个（或如果可能的话自己写一个）。如果没有尽快提供，根据关闭issue中的政策关闭它。

​	**5 Cleaning up old pull requests**

​	有时，贡献者无法完成pull request。如果距离上次审查请求更改已经过了一段时间（比如说两周），那么可以礼貌地问他们是否仍有兴趣进行此项工作。如果再过两个星期左右没有任何回应，感谢他们的工作并关闭pull request。在最初的问题上评论“在#1234有一个可能有用的停滞PR”，如果PR比较完整了的话，也许可以给issue贴上“Good first issue”的标签。

​	**6 Merging pull requests**

​	只有核心团队成员可以合并拉取请求。

### 2 开发者参与流程调研

 	**1 start**

​	找到未被分配并且感兴趣的issue，并将issue分配给自己。如果由于某种原因无法继续处理该问题，请尝试取消分配，以便其他人知道当前issue再次可用。

​	**2 Version control, Git, and GitHub**

​	代码托管在 GitHub 上。要做出贡献，需要注册一个免费的 GitHub 帐户。项目使用 Git 进行版本控制，以允许许多人一起在项目上工作。

​	**3 Forking**

​	在github的pandas页面上fork仓库，并将仓库克隆到本地

​	**4 Creating a development environment**

​	要测试代码就需要从源代码构建 Pandas，这需要 C/C++ 编译器和 Python 环境。可以使用 Docker 来自动创建环境，而不是手动设置开发环境。

​	**5 Creating a branch**

​	master 分支存放预生产代码，因此需要创建一个feature分支来更改代码。

​	**6 Code standards**

​	良好的风格是向 Pandas 提交代码的必要条件。

​	代码在提交前必须经过测试。

​	更改代码时要注意兼容性，不要是当前版本的正确代码在之后的版本中失效。

​	**7 commit**

​	提交代码前应该充分检查代码规范性正确性。提交时解释性消息要按照指定规范书写，包括消息前缀和规范的约定。

​	**8 make the pull request**

​	如果一切正常，您就可以发出pull request了。pull request将本地存储库中的代码提供给 GitHub 社区，可以查看并最终合并到主版本中。此pull request及其相关更改最终将提交到主分支并在下一个版本中可用。

​	**9 Delete your merged branch (optional)**

​	分支在代码被合并后可以删除。

​	**10 Tips for a successful pull request**

​	为了提高您的拉取请求被审查的机会，您应该：

​		引用未被更改的issue以阐明 PR 的目的；

​		确保有适当的测试；

​		使pull request尽可能简单，较大的 PR 需要更长的时间来审查；

​		确保 CI 处于绿色状态

### 3项目CI/CD的流程调研

​	  开发者提交拉取请求后，pandas 测试套件将在 Travis-CI 和 Azure Pipelines 持续集成服务上自动运行。 但是，如果开发者希望在提交拉取请求之前在分支上运行测试套件，则需要将持续集成服务挂钩到自己的 GitHub 仓库。

#### 3.1 基于Travis CI的持续集成

​	Travis CI 提供的是持续集成服务（Continuous Integration，简称 CI）。它绑定 Github 上面的项目，只要有新的代码，就会自动抓取。然后，提供一个运行环境，执行测试，完成构建，还能部署到服务器。

​	持续集成指的是只要代码有变更，就自动运行构建和测试，反馈运行结果。确保符合预期以后，再将新代码"集成"到主干。

##### 使用准备：

- 拥有 GitHub 帐号
- 该帐号下面有一个项目
- 该项目里面有可运行的代码
- 该项目还包含构建或测试脚本

##### 监听仓库：

​	首先，访问官方网站 [travis-ci.org](https://travis-ci.org/)，点击右上角的个人头像，使用 Github 账户登入 Travis CI。             Travis 会列出 Github 上面你的所有仓库，以及你所属于的组织。此时，选择你需要 Travis 帮你构建的仓库，打开仓库旁边的开关。一旦激活了一个仓库，Travis 会监听这个仓库的所有变化。

##### 准备.travis.yml文件：

Travis 要求项目的根目录下面，必须有一个`.travis.yml`文件。这是配置文件，指定了 Travis 的行为。该文件必须保存在 Github 仓库里面，一旦代码仓库有新的 Commit，Travis 就会去找这个文件，执行里面的命令。

这个文件采用 [YAML](https://www.ruanyifeng.com/blog/2016/07/yaml.html) 格式。下面是一个最简单的 Python 项目的`.travis.yml`文件：

```
language: python
sudo: required
before_install: sudo pip install foo
script: py.test
```

##### install阶段：

install字段用来指定安装脚本。

```
install: ./install-dependencies.sh
```

##### script阶段：

script字段用来指定构建或者测试脚本

```javascript
script: bundle exec thor build
```

如果有多个脚本可以写成下面的形式

```javascript
script:
  - command1
  - command2
```

注意，`script`与`install`不一样，如果`command1`失败，`command2`会继续执行。但是，整个构建阶段的状态是失败。

如果`command2`只有在`command1`成功后才能执行，就要写成下面这样。

```javascript
script: command1 && command2
```

#### 3.2 基于Azure Pipelines实现持续交付

##### 1、为应用代码创建存储库

如果已有一个应用可以使用，请确保已将其提交到 GitHub 存储库

##### 2、预配目标Azure 应用服务

创建应用服务实例的最快方法是通过交互式 (CLI) Azure 命令行Azure Cloud Shell。

##### 3、创建Azure DevOps项目并连接到 Azure

若要从 Azure 应用服务部署Azure Pipelines，需要在两个 *服务之间* 建立服务连接。

##### 4、创建特定于该应用程序的管道以部署到应用服务

##### 5、运行管道及部署脚本并且清理资源