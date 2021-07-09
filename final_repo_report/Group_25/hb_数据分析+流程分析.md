# 数据分析+流程分析

## 1 数据分析

### 1.2 开发者数据分析
GitHub开发者活跃度显示一个开源项目的热度。本节将展示开发者相关的数据分析，旨在用数据了说明K8s在开源社区的热度。

<img src="./images/GitHub%20Apps%20日志时间分布图.png" alt="GitHub apps日志时间分布图" width="500"/>

上图为K8s开发者在2020年GitHub apps日志时间分布图，工作日和周末不同时段总的commit提交数目。可以看到，开发者在工作日提交的commit比休息日提交的commit多50%-300%，这说明开发者在工作日更愿意参与到开源项目中，在周末开发者的提交热情有所下降。此外，开发者提交开源项目commit的时间段主要集中在一天的14-22时，这可能是因为在其他时间段开发者正忙于自己工作中的事情。

<img src="./images/2020年每月开发者数目.png" alt="2020年每月开发者数目" width="500"/>

上图展示了K8s项目，2020年每月开发者的数目。在1-7月开发者数目是要多于8-12月的。在7月开发者数目达到了顶峰，8月有比较明显的开发者数目的减少。

## 2 流程分析
### 2.3 项目CI/CD的流程
Kubernetes通过一个k8s-ci-robot来负责项目的CI/CD。它能帮助管理上游点的PR&Issue，无处不在。k8s-ci-robot其背后通过[Prow](https://github.com/kubernetes/test-infra/tree/master/prow#bots-home)系统来管理Kubernetes的CI/CD。

#### Prow
Prow 的出现称得上是顺势而为。在它诞生前夕，Kubernetes 正值快速发展，开发者们每天需要在数个 GitHub 组织的 100 多个代码库中执行超过 10,000 个 CI/CD job。为了简化工作，Kubernetes 测试特别兴趣小组（sig-testing）创建了一系列工具和服务，其中就包括 Prow。

Prow是基于Kubernetes的CI/CD系统。作业可以由各种类型的事件触发，并向许多不同的服务报告它们的状态。除了作业执行之外，Prow还提供了GitHub的自动化功能，包括策略执行、通过/foo风格命令的聊天操作以及自动PR合并。

##### Prow的功能和特性
* 用于测试、批处理、工件发布的作业执行。
  - GitHub事件用于触发pr后合并(postsubmit)作业和pr上更新(presubmit)作业。
  - 支持多个执行平台和源代码审查站点。
* 可插入的GitHub机器人自动化实现/foo风格的命令和执行配置的策略/进程。
* GitHub将自动化与批量测试逻辑合并。
* 用于查看作业、合并队列状态、动态生成帮助信息等的前端。
* 基于配置的源代码控制的自动部署。
* 在源代码控制中配置的自动GitHub /repo管理。
* 设计为多组织规模与数十个存储库。(Kubernetes Prow实例只使用了一个GitHub bot token!)
* 高可用性是在Kubernetes上运行的好处。(复制、负载平衡、滚动更新…)
* JSON结构日志。

#### 使用Prow的项目
Prow由以下机构和项目使用:
* Kubernetes
  - 包括kubernetes, kubernetes-client, kubernetes-csi, and kubernetes-sigs.
* OpenShift
  - 包括 openshift, openshift-s2i, operator-framework
* Istio
* Knative
* Jetstack
* Kyma
* Metal
* Prometheus
* Caicloud
* Kubeflow
* Azure AKS Engine
* tensorflow/minigo
* Daisy (Google Compute Image Tools)
* KubeEdge (Kubernetes Native Edge Computing Framework)
* Volcano (Kubernetes Native Batch System)
* Loodse
* Feast
* Falco
* TiDB
* Amazon EKS Distro
Jenkins X使用Prow作为无服务器Jenkins的一部分。