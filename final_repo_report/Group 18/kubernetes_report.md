# Kubernetes 2020 数据分析报告

对仓库kubernetes/kubernetes进行了分析

可视化图表采用echarts制作

## 数据类

### 关联数据的分析

首先统计Kubernetes项目内的所有活跃贡献者（取事件数>200），并排除了这`k8s-ci-robot`和`fejta-bot`两个Bot账户。

对这111名贡献者，分析他们活跃的其他仓库（取事件数>200），以这种方式获取其他项目与Kubernetes的关联度。

![2222](kubernetes_report.assets/2222.gif)

可以从关系图看出，与`kubernetes/kubernetes`关联度较大的仓库有

- `kubernetes/test-infra`
- `kubernetes/enhancement`
- `kubernetes-sigs/kind`
- `cri-o/cri-o`
- `kubernetes/release`

## 流程类

### 项目CI/CD的流程调研

Kubernetes仓库本身并不包含CI/CD流程，但会对所有PR进行机器人review check。利用K8S自己的自动化测试网站https://prow.k8s.io/来测试预合并后的代码，只有所有测试都通过的PR才会交给审查者来决定最终是否进行合并。

![image-20210628182758007](kubernetes_report.assets/image-20210628182758007.png)

