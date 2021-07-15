# 0.前言

​		&ensp;&ensp;&ensp;&ensp;本小组选择了vuejs/vue开源项目对其日常协作流程进行调研，其在github上的仓库地址为https://github.com/vuejs/vue。Vue是前端的主流框架之一，和Angular.js、React.js一起，成为前端三大主流框架。你可以通过访问vuejs的官网https://cn.vuejs.org/对这个项目进行初步的了解，在其官网上包括了vue相关的教程、简单介绍、论坛、团队介绍等内容。

​		&ensp;&ensp;&ensp;&ensp;接下来按照课程要求分项目的日常协作流程调研、开发者参与流程调研、CI/CD流程调研三部分展开，其中第一部分项目的日常协作流程调研主要专注于开源项目中不同的角色及行为进行介绍，而第二部分则专注于对开发者这一角色的贡献行为进行流程调研，第三部分则是调研了vue项目的相关CI/CD内容。

# 1.项目的日常协作流程调研

​		&ensp;&ensp;&ensp;&ensp;一般来说，开源项目针对贡献者角色和身份遵循相似的结构，但同时这些角色实际上意味着什么又有可能因项目的不同而有细微差别。举例来说可以将项目中的开源角色分为“维护者”、“贡献者”、“修订者”三种角色，其中“维护者”一般指拥有提交权限的人，作为一名“维护者”，不一定非得一定要为项目攥写代码。他也有可能是项目的步道师，为项目的宣传做了很多的工作，又或者是撰写文档让更多的人参与进来。不管他们每天做什么，维护者就是那些对项目方向负责的人，并致力于项目的改进。而作为“贡献者”，则可以是任何人，只要他提出issue或者PR就可以被叫做贡献者，以及为项目做出有价值行为的任何人都可以被归为贡献者。最后是“修订者”，该角色用于区分其他形式的贡献的提交访问，这是一种特定类型的责任。

​		&ensp;&ensp;&ensp;&ensp;再举gitlab用户在组中权限的例子，gitlab将用户在组中权限分为Guest、Reporter、Developer、Master、Owner五种，也可以将这五种权限视为五种角色。其中Guest用户在项目中拥有创建issue、发表评论的权限；Reporter用户可以克隆代码，但是不能提交，质量保证员以及项目管理员很适合被赋予这样的权限；Developer用户可以克隆代码、开发、提交、push等权限，该权限很适合被赋予给研发工程师；至于Master用户则可以创建项目，添加tag、保护分支、添加团队成员、编辑项目，那么核心开发者可以被赋予该角色；最后是Owner用户、则可以设置项目访问权限、删除项目、迁移项目、管理组成员，作为项目负责人可以被赋予该角色。

​		&ensp;&ensp;&ensp;&ensp;具体到vuejs/vue仓库的项目协作流程，vuejs/vue仓库属于vuejs，vuejs有50位Members(This user is a member of vuejs organization)，这其中也包括了Vue.js的作者尤雨溪，另外vuejs/vue仓库下的参与者还有399位Contributors(This user has previously commited to the vue repository)，以及超过150k的user。

​		&ensp;&ensp;&ensp;&ensp;首先假设A为仓库主人，A可以为仓库创建不同的分支，比如vuejs/vue仓库下就有dev、master、patreon-update等分支分别用于管理不同开发状态下的代码。假设B为vuejs/vue仓库的user，在使用过程中如果发现与项目相关的问题或者改进方案，则可以到github上提交issue，那么这个时候B就会作为vuejs/vue仓库的一个“参与者”。在提出issue后，就会有更多的人参与讨论和交流，假设C为另一位参与vuejs/vue其中的用户，C可以将仓库fork到自己的仓库并完成开发解决问题，在此之后将代码以pr的形式提交到vuejs/vue仓库之中，这个时候A以及其他用户可以对该pr进行review，当认为能够成功解决问题后，就会由vuejs的member成员将代码合并进入vuejs/vue仓库之中。至此，C用户也成为了vuejs/vue仓库的一名contributor了，并且由A、B、C等用户完成了一次代码日常协作流程。我们可以将在vuejs/vue项目下的协作流程总结为如下：

1.vuejs/vue项目的某一位user假设为B用户发现某个bug或者是待优化的地方(诸如文档、功能、注释)；  
2.用户B在vuejs/vue在项目内以issue的方式发起讨论；  
3.关注该issue的用户(不限于user、contributor、member)进行讨论或交流；  
4.关注该issue的用户将仓库fork到本地并进行解决，假设用户C完成解决，将以pr的形式提交回vuejs/vue项目；  
5.关注该issue的用户可以对改动进行review，当然这时候大家也可以对其进行修改，直至认为符合要求，则有仓库member假设为A负责Confirm merge；
6.至此，在vuejs/vue项目下完成了一次问题的协作解决流程。

# 2.开发者参与流程调研

​        &ensp;&ensp;&ensp;&ensp;开发者参与贡献vuejs/vue仓库的开发需要遵守vue.js的贡献指南https://github.com/vuejs/vue/blob/656a3cbda089c26938802707223254990631b91f/.github/CONTRIBUTING.md，用户可以通过发布issue、发布功能请求、更新文档、提交PR或补丁以及其它方式做出贡献。大致上开发者参与流程分为提交issue和提交pr两步。

## 2.1 Submitting an issue

​		&ensp;&ensp;&ensp;&ensp;可以将issue看作是专门用于报告错误或者是功能请求的列表，需要注意的是在vuejs/vue仓库中，issue并不用于提问，如果提出了一个提问式的issue，该issue将会被要求立即关闭。事实上关于提问式的内容，vuejs/vue仓库更鼓励用户参考vuejs官网的教程以及在论坛提出。

​		&ensp;&ensp;&ensp;&ensp;除此以外，vuejs/vue仓库建议用户在提issue前先对issue进行检索，这是因为用户提出的issue很有可能已经在此之前就被提出了，甚至有可能已经被修复了。

​		&ensp;&ensp;&ensp;&ensp;总得来说，所支持的用户提的issue分为Bug Report和Feature Request两种。
1.Bug Report Issue：需要在issue中指定issue的标题，以及发现该问题存在的version，即仓库分支号。此外还需要复述一遍bug的复现流程，以及相应的期待的复现结果和实际的复现结果。以上是一个Bug Report的issue必要的内容，除此以外还可以添加其它你觉得重要的额外信息。
2.Feature Request：和Bug Report Issue一致的地方是需要填写issue的标题，之后是填写该featur所需要解决的问题，解释此功能请求背后的用例，使用场景和基本原理。更重要的是填写是什么样的最终用户体验会需要增加这种功能。除此以外，最好还能描述如何解决该需求，并提供API实施后如何工作的代码示例。

## 2.2 Submitting a Pull Request

​		  &ensp;&ensp;&ensp;&ensp;开发者在本地完成开发工作后需要通过Pull Request来将修改提交回vuejs/vue仓库。在此之前，需要明确一下vuejs/vue仓库的各个主要分支的作用。首先是master分支，该分支是最新稳定版的快照，因此所有开发都不应该在master分支中完成，也不应该针对master分支提交pr。其次开发工作应该从相关分支切出新分支，比如从dev分支切出的新分支上完成开发任务，在merge回原切出分支。最后还需要注意的是在src文件夹中的开发工作，最后提交时请不要包含dist目录。提交pr前也请保证npm测试能够通过。如果是添加新功能，则需要提供令人信服的理由，一般来说最好能先开一个issue进行讨论，在issue被批准后再继续开发工作。如果是解决bug，则最好在pr标题中添加(fix #xxxx)，这样讲有助于获得更好的发布日志，因为这可以关联到相关的issue。除此以外，最好可以添加适当的测试用例及覆盖率。接下来详细介绍一下具体的提交pr流程。

1.Fork and clone the repository.  
2.Create a new branch.  
3.Commit your changes.  
4.Sync your local repository with the upstream.  
5.Push your branch to GitHub.  
6.Create a Pull Request.  

# 3.CI/CD流程调研

​		&ensp;&ensp;&ensp;&ensp;GitHub Actions可以使用世界一流的 CI/CD 轻松自动化所有软件工作流程。用户可以直接从 GitHub 构建、测试和部署您的代码。GitHub Actions 是微软于 2018 年秋季推出的一个平台。这一平台可以让开发者实现定制化的程序逻辑，而不需要专门创建一个应用去完成需要的任务。开发者可以借助 Actions 平台建立工作流，使用他们代码仓库中定义好的 action、或者 GitHub 公开代码库中的 action，甚至是一个公开的 Docker 容器镜像。action 在这里指的是开发、测试、部署和发布代码中的各种流程，举个例子，一个 action 可以是公开发布某个 npm 模块，在创建紧急 issue 时为开发者发送 SMS 警告，或者部署生产流程中的代码的过程。这些工作流程过去需要开发者自己去手动实现。现在有了 Actions 平台后，借助 Actions 平台和 GitHub 中百万级别的公开库，任何一个开发者都可以直接建立上述工作流程，不需要专门去创建实现这些 action 的应用了。此外，开发者创建的工作流也可以分享给 GitHub 社区供其他人使用。github actions的配置文件叫做workflow文件，workflow文件采用YAML格式，文件后缀名统一为.yml。github会按照触发条件在符合条件时自动运行该文件中的工作流程。具体到vuejs/vue仓库介绍如下：

​		&ensp;&ensp;&ensp;&ensp;vuejs/vue仓库的workflow文件为.circleci目录下的config.yml文件。根据该文件，可以看出vuejs/vue仓库使用docker镜像vuejs/ci进行测试，工作目录为/project/vue，执行的命令有npm install，npm run lint，npm run flow，npm run test:type等命令。具体地主要是完成test-cover，test-e2e，test-ssr-weex，trigger-regression-test、install-and-parallel-test等共13个CI任务。
