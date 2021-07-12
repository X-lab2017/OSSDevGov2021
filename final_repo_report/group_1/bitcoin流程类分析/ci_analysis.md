### 项目的CI/CD流程
此项目中的ci文件夹包含了ci脚本，其可用于测试阶段的每一个步骤。ci系统确保了对项目所提交的PR能够在 Windows, Linux, and macOS等系统环境下进行单元测试，并可以实现测试的自动运行。
ci的很多操作在docker容器中执行。并且为了测试环境的多样性，也为了某些情况得以复现，测试阶段需要docker。测试环境的容器化保证了不同测试环境之间的隔离性以及保证了测试环境的轻量级启动、使用。

在ci阶段的测试过程中，项目会在不同环境下进行测试。如下图琐事我们是可以看到多种类型的环境。
<img src="https://xlab-video.oss-cn-shanghai.aliyuncs.com/xlab-work/image1.png">

举个例子来看，比如在centos的测试环境中，会在docker容器中加载各种工具包，然后设置相应的运行时环境，以及容器的名称等基本信息。
<img src="https://xlab-video.oss-cn-shanghai.aliyuncs.com/xlab-work/image2.png"> 

为保证测试时的项目版本一致性，测试者将使用./depends文件夹下的依赖生成器，而并非使用测试系统中的包管理器去加载依赖。此外，为避免每次"构建项目"时依赖的重复下载，在某次"项目构建"时这些依赖将会被缓存，以备之后的重复使用。
<img src="https://xlab-video.oss-cn-shanghai.aliyuncs.com/xlab-work/image3.png">

此项目中没有使用.gitlab-ci.yml文件来定义基础的CI流程，而是更关注于项目新增变更在多个使用环境中的兼容性。
项目的测试多是使用脚本文件去运行项目，不同脚本文件之间存在较松的耦合。

