NEED FOR CUSTOMIZATION
However, a growing organization will have increasingly diverse needs. For instance, when Google launched the Google Compute Engine (the “VM as a Service” public cloud offering) in 2012, the VMs, just as most everything else at Google, were managed by Borg. This means that each VM was running in a separate container controlled by Borg. However, the “cattle” approach to task management did not suit Cloud’s workloads, because each particular container was actually a VM that some particular user was running, and Cloud’s users did not, typically, treat the VMs as cattle.18
然而，一个成长中的组织会有越来越多的不同需求。例如，当谷歌在2012年推出谷歌计算引擎（"虚拟机即服务 "的公共云产品）时，就像谷歌的大多数其他东西一样，其虚拟机是由Borg管理的。这意味着每个虚拟机都运行在一个由Borg控制的独立容器中。然而，这种 "牛 "的任务管理方式并不适合云计算的工作负载，因为每个特定的容器实际上是某个特定用户正在运行的虚拟机，而云计算的用户通常不会把虚拟机当作牛。[^18]

Reconciling this difference required considerable work on both sides. The Cloud organization made sure to support live migration of VMs; that is, the ability to take a VM running on one machine, spin up a copy of that VM on another machine, bring the copy to be a perfect image, and finally redirect all traffic to the copy, without causing a noticeable period when service is unavailable.19 Borg, on the other hand, had to be adapted to avoid at-will killing of containers containing VMs (to provide the time to migrate the VM’s contents to the new machine), and also, given that the whole migration process is more expensive, Borg’s scheduling algorithms were adapted to optimize for decreasing the risk of rescheduling being needed.20 Of course, these modifications were rolled out only for the machines running the cloud workloads, leading to a (small, but still noticeable) bifurcation of Google’s internal compute offering.
调和这种差异需要双方做大量的工作。云计算组织确保支持虚拟机的实时迁移；也就是说，能够在一台机器上运行的虚拟机，在另一台机器上启动该虚拟机的副本，使该副本成为一个完美的图像，并最终将所有流量重定向到该副本，而不会造成明显的服务不可用期。另一方面，Borg必须进行调整，以避免随意杀死包含虚拟机的容器（以提供时间将虚拟机的内容迁移到新的机器上），同时，鉴于整个迁移过程更加昂贵，Borg的调度算法被调整为优化，以减少需要重新调度的风险。20 当然，这些修改只针对运行云工作负载的机器，导致谷歌内部计算产品的分叉（很小，但仍然很明显）。

A different example—but one that also leads to a bifurcation—comes from Search. Around 2011, one of the replicated containers serving Google Search web traffic had a giant index built up on local disks, storing the less-often-accessed part of the Google index of the web (the more common queries were served by in-memory caches from other containers). Building up this index on a particular machine required the capacity of multiple hard drives and took several hours to fill in the data. However, at the time, Borg assumed that if any of the disks that a particular container had data on had gone bad, the container will be unable to continue, and needs to be rescheduled to a different machine. This combination (along with the relatively high failure rate of spinning disks, compared to other hardware) caused severe availability problems; containers were taken down all the time and then took forever to start up again. To address this, Borg had to add the capability for a container to deal with disk failure by itself, opting out of Borg’s default treatment; while the Search team had to adapt the process to continue operation with partial data loss.
一个不同的例子--但也导致了分叉--来自于搜索。2011年左右，一个为谷歌搜索网络流量服务的复制容器在本地磁盘上建立了一个巨大的索引，存储了谷歌网络索引中不常被访问的部分（更常见的查询由其他容器的内存缓存提供）。在一台特定的机器上建立这个索引需要多个硬盘的容量，并且需要几个小时来填入数据。然而，在当时，Borg假设，如果某个特定容器的数据所在的任何一块磁盘坏了，该容器将无法继续，需要重新安排到不同的机器上。这种组合（与其他硬件相比，旋转磁盘的故障率相对较高）造成了严重的可用性问题；容器总是被拆掉，然后又要花很长时间才能重新启动。为了解决这个问题，Borg必须增加容器自己处理磁盘故障的能力，选择不使用Borg的默认处理方式；而搜索团队必须调整流程，以便在部分数据丢失的情况下继续运行。

Multiple other bifurcations, covering areas like filesystem shape, filesystem access, memory control, allocation and access, CPU/memory locality, special hardware, special scheduling constraints, and more, caused the API surface of Borg to become large and unwieldy, and the intersection of behaviors became difficult to predict, and even more difficult to test. Nobody really knew whether the expected thing happened if a container requested both the special Cloud treatment for eviction and the custom Search treatment for disk failure (and in many cases, it was not even obvious what “expected” means).
其他多个分叉，涵盖了文件系统形状、文件系统访问、内存控制、分配和访问、CPU/内存定位、特殊硬件、特殊调度约束等领域，导致Borg的API表面变得庞大而笨重，各种行为的交叉点变得难以预测，甚至更难测试。没有人真正知道，如果一个容器同时请求对驱逐的特殊云处理和对磁盘故障的自定义搜索处理，是否会发生预期的事情（在许多情况下，甚至不清楚 "预期 "是什么意思）。

After 2012, the Borg team devoted significant time to cleaning up the API of Borg. It discovered some of the functionalities Borg offered were no longer used at all.21 The more concerning group of functionalities were those that were used by multiple containers, but it was unclear whether intentionally—the process of copying the configuration files between projects led to proliferation of usage of features that were originally intended for power users only. Whitelisting was introduced for certain features to limit their spread and clearly mark them as poweruser–only. However, the cleanup is still ongoing, and some changes (like using labels for identifying groups of containers) are still not fully done.22
2012年后，Borg团队花了大量时间来清理Borg的API。21 更令人担忧的是那些被多个容器使用的功能，但不清楚是否有意为之--在项目之间复制配置文件的过程导致了原本只为高级用户准备的功能的使用扩散。某些功能被引入了白名单，以限制它们的传播，并明确地将它们标记为仅适用于电源用户。然而，清理工作仍在进行，一些变化（如使用标签来识别容器组）仍未完全完成。

As usual with trade-offs, although there are ways to invest effort and get some of the benefits of customization while not suffering the worst downsides (like the aforementioned whitelisting for power functionality), in the end there are hard choices to be made. These choices usually take the form of multiple small questions: do we accept expanding the explicit (or worse, implicit) API surface to accommodate a particular user of our infrastructure, or do we significantly inconvenience that user, but maintain higher coherence?
就像通常的权衡一样，虽然有一些方法可以投入精力，获得一些定制化的好处，同时不遭受最坏的坏处（比如前面提到的权力功能的白名单），但最终还是要做出艰难的选择。这些选择通常以多个小问题的形式出现：我们是接受扩大显式（或更糟糕的是隐式）API表面以适应我们基础设施的特定用户，还是给该用户带来极大不便，但保持更高的一致性？

Level of Abstraction: Serverless

The description of taming the compute environment by Google can easily be read as a tale of increasing and improving abstraction—the more advanced versions of Borg took care of more management responsibilities and isolated the container more from the underlying environment. It’s easy to get the impression this is a simple story: more abstraction is good; less abstraction is bad.
谷歌对驯服计算环境的描述很容易被解读为一个增加和改善抽象的故事--更高级的Borg版本承担了更多的管理责任，并将容器与底层环境更多地隔离。这很容易让人觉得这是一个简单的故事：更多的抽象是好的；更少的抽象是坏的。

Of course, it is not that simple. The landscape here is complex, with multiple offerings. In “Taming the Compute Environment”, we discussed the progression from dealing with pets running on bare-metal machines (either owned by your organization or rented from a colocation center) to managing containers as cattle. In between, as an alternative path, are VM-based offerings in which VMs can progress from being a more flexible substitute for bare metal (in Infrastructure as a Service offerings like Google Compute Engine [GCE] or Amazon EC2) to heavier substitutes for containers (with autoscaling, rightsizing, and other management tools).
当然，事情没有那么简单。这里的情况很复杂，有多种产品。在 "驯服计算环境 "中，我们讨论了从处理在裸机上运行的宠物（要么是你的组织拥有的，要么是从主机托管中心租来的）到管理容器的进展情况。在这两者之间，作为一个替代路径，是基于虚拟机的产品，其中虚拟机可以从更灵活地替代裸机（在基础设施即服务产品中，如谷歌计算引擎[GCE]或亚马逊EC2）发展到更重地替代容器（具有自动缩放、权限调整和其他管理工具）。

In Google’s experience, the choice of managing cattle (and not pets) is the solution to managing at scale. To reiterate, if each of your teams will need just one pet machine in each of your datacenters, your management costs will rise superlinearly with your organization’s growth (because both the number of teams and the number of datacenters a team occupies are likely to grow). And after the choice to manage cattle is made, containers are a natural choice for management; they are lighter weight (implying smaller resource overheads and startup times) and configurable enough that should you need to provide specialized hardware access to a specific type of workload, you can (if you so choose) allow punching a hole through easily.
根据谷歌的经验，选择管理牛（而不是宠物）是规模管理的解决方案。重申一下，如果你的每个团队在每个数据中心只需要一台宠物机，那么你的管理成本将随着你的组织的增长而超线性上升（因为团队的数量和一个团队所占用的数据中心的数量都可能增长）。而在选择管理牛之后，容器是管理的自然选择；它们的重量更轻（意味着更小的资源开销和启动时间），而且可配置，如果你需要为特定类型的工作负载提供专门的硬件访问，你可以（如果你选择的话）允许轻松打洞通过。

The advantage of VMs as cattle lies primarily in the ability to bring our own operating system, which matters if your workloads require a diverse set of operating systems to run. Multiple organizations will also have preexisting experience in managing VMs, and preexisting configurations and workloads based on VMs, and so might choose to use VMs instead of containers to ease migration costs.
虚拟机作为牛的优势主要在于能够带来我们自己的操作系统，如果你的工作负载需要一套多样化的操作系统来运行，这一点很重要。多个组织也会有管理虚拟机的预存经验，以及基于虚拟机的预存配置和工作负载，因此可能会选择使用虚拟机而不是容器来减轻迁移成本。

WHAT IS SERVERLESS?

An even higher level of abstraction is serverless offerings.23 Assume that an organization is serving web content and is using (or willing to adopt) a common server framework for handling the HTTP requests and serving responses. The key defining trait of a framework is the inversion of control—so, the user will only be responsible for writing an “Action” or “Handler” of some sort—a function in the chosen language that takes the request parameters and returns the response.
假设一个组织正在为网络内容提供服务，并且正在使用（或愿意采用）一个通用的服务器框架来处理HTTP请求和提供响应。框架的关键特征是控制权的倒置，因此，用户只负责编写某种 "行动 "或 "处理程序"--所选语言中接收请求参数并返回响应的函数。

In the Borg world, the way you run this code is that you stand up a replicated container, each replica containing a server consisting of framework code and your functions. If traffic increases, you will handle this by scaling up (adding replicas or expanding into new datacenters). If traffic decreases, you will scale down. Note that a minimal presence (Google usually assumes at least three replicas in each datacenter a server is running in) is required.
在博格的世界里，你运行这段代码的方式是，你建立一个复制的容器，每个副本包含一个由框架代码和你的功能组成的服务器。如果流量增加，你将通过扩大规模来处理（增加副本或扩展到新的数据中心）。如果流量减少，你将缩小规模。请注意，需要一个最小的存在（谷歌通常假设服务器运行的每个数据中心至少有三个副本）。

However, if multiple different teams are using the same framework, a different approach is possible: instead of just making the machines multitenant, we can also make the framework servers themselves multitenant.  In this approach, we end up running a larger number of framework servers, dynamically load/unload the action code on different servers as needed, and dynamically direct requests to those servers that have the relevant action code loaded. Individual teams no longer run servers, hence “serverless.”
但是，如果多个不同的团队使用同一个框架，就可以采用不同的方法：不只是让机器多租，我们也可以让框架服务器本身多租。 在这种方法中，我们最终会运行更多的框架服务器，根据需要在不同的服务器上动态加载/卸载动作代码，并将请求动态地引导到那些加载了相关动作代码的服务器。各个团队不再运行服务器，因此 "无服务器"。

Most discussions of serverless frameworks compare them to the “VMs as pets” model. In this context, the serverless concept is a true revolution, as it brings in all of the benefits of cattle management—autoscaling, lower overhead, lack of explicit provisioning of servers. However, as described earlier, the move to a shared, multitenant, cattle-based model should already be a goal for an organization planning to scale; and so the natural comparison point for serverless architectures should be “persistent containers” architecture like Borg, Kubernetes, or Mesosphere.
大多数关于无服务器框架的讨论都将其与 "虚拟机作为宠物 "的模式相比较。在这种情况下，无服务器概念是一场真正的革命，因为它带来了牛群管理的所有好处--自动缩放、更低的开销、缺乏明确的服务器供应。然而，正如前文所述，对于计划扩展的组织来说，转向共享、多租户、基于牛的模式应该已经是一个目标；因此，无服务器架构的自然比较点应该是 "持久性容器 "架构，如Borg、Kubernetes或Mesosphere。

PROS AND CONS

First note that a serverless architecture requires your code to be truly stateless; it’s unlikely we will be able to run your users’ VMs or implement Spanner inside the serverless architecture. All the ways of managing local state (except not using it) that we talked about earlier do not apply. In the containerized world, you might spend a few seconds or minutes at startup setting up connections to other services, populating caches from cold storage, and so on, and you expect that in the typical case you will be given a grace period before termination. In a serverless model, there is no local state that is really persisted across requests; everything that you want to use, you should set up in request-scope.
首先要注意的是，无服务器架构要求你的代码是真正的无状态；我们不太可能在无服务器架构内运行你用户的虚拟机或实现Spanner。我们之前谈到的所有管理本地状态的方法（除了不使用它）都不适用。在容器化的世界里，你可能会在启动时花几秒钟或几分钟的时间来设置与其他服务的连接，从冷存储中填充缓存，等等，你期望在典型的情况下，你会在终止前得到一个宽限期。在无服务器模型中，不存在真正跨请求持久化的本地状态；所有你想使用的东西，你都应该在请求范围内设置。

In practice, most organizations have needs that cannot be served by truly stateless workloads. This can either lead to depending on specific solutions (either home grown or third party) for specific problems (like a managed database solution, which is a frequent companion to a public cloud serverless offering) or to having two solutions: a container-based one and a serverless one. It’s worth mentioning that many or most serverless frameworks are built on top of other compute layers: AppEngine runs on Borg, Knative runs on Kubernetes, Lambda runs on Amazon EC2. 
在实践中，大多数组织的需求都无法由真正的无状态工作负载来满足。这可能会导致依赖特定的解决方案（无论是本土的还是第三方的）来解决特定的问题（比如管理数据库的解决方案，这是公有云无服务器产品的常见配套），或者拥有两个解决方案：一个基于容器的解决方案和一个无服务器的解决方案。值得一提的是，许多或大多数无服务器框架是建立在其他计算层之上的。AppEngine运行在Borg上，Knative运行在Kubernetes上，Lambda运行在Amazon EC2上。

The managed serverless model is attractive for adaptable scaling of the resource cost, especially at the low-traffic end. In, say, Kubernetes, your replicated container cannot scale down to zero containers (because the assumption is that spinning up both a container and a node is too slow to be done at request serving time). This means that there is a minimum cost of just having an application available in the persistent cluster model. On the other hand, a serverless application can easily scale down to zero; and so the cost of just owning it scales with the traffic.
管理型无服务器模式对于资源成本的适应性扩展很有吸引力，特别是在低流量的一端。在比如说Kubernetes中，你的复制容器不能扩展到零容器（因为假设在请求服务时间内同时启动一个容器和一个节点太慢）。这意味着，在持久化集群模型中，仅仅拥有一个应用程序是有最低成本的。另一方面，无服务器应用程序可以很容易地扩展到零；因此，仅仅拥有它的成本随着流量的增加而增加。

At the very high-traffic end, you will necessarily be limited by the underlying infrastructure, regardless of the compute solution. If your application needs to use 100,000 cores to serve its traffic, there needs to be 100,000 physical cores available in whatever physical equipment is backing the infrastructure you are using. At the somewhat lower end, where your application does have enough traffic to keep multiple servers busy but not enough to present problems to the infrastructure provider, both the persistent container solution and the serverless solution can scale to handle it, although the scaling of the serverless solution will be more reactive and more granular than that of the persistent container one.
在非常高的流量端，你将必然受到底层基础设施的限制，不管是什么计算解决方案。如果你的应用程序需要使用100,000个核心来服务于它的流量，那么在你所使用的基础设施的任何物理设备中需要有100,000个物理核心可用。在较低端的情况下，如果你的应用有足够的流量让多个服务器忙碌，但又不足以给基础设施提供商带来问题，那么持久化容器解决方案和无服务器解决方案都可以扩展来处理，尽管无服务器解决方案的扩展将比持久化容器解决方案更加反应灵敏，更加细化。

Finally, adopting a serverless solution implies a certain loss of control over your environment. On some level, this is a good thing: having control means having to exercise it, and that means management overhead. But, of course, this also means that if you need some extra functionality that’s not available in the framework you use, it will become a problem for you.
最后，采用无服务器解决方案意味着在一定程度上失去了对环境的控制。在某种程度上，这是一件好事：拥有控制权意味着必须行使它，而这意味着管理开销。但当然，这也意味着，如果你需要一些你所使用的框架中没有的额外功能，这将成为你的一个问题。

To take one specific instance of that, the Google Code Jam team (running a programming contest for thousands of participants, with a frontend running on Google AppEngine) had a custom-made script to hit the contest webpage with an artificial traffic spike several minutes before the contest start, in order to warm up enough instances of the app to serve the actual traffic that happened when the contest started. This worked, but it’s the sort of hand-tweaking (and also hacking) that one would hope to get away from by choosing a serverless solution.
举个具体的例子，谷歌Code Jam团队（为数千名参赛者举办的编程比赛，其前端运行在谷歌AppEngine上）有一个定制的脚本，在比赛开始前几分钟给比赛网页带来了人为的流量高峰，以便为应用程序的足够实例预热，为比赛开始时的实际流量提供服务。这很有效，但这是人们希望通过选择无服务器解决方案来摆脱的那种手工调整（也是黑客行为）。

THE TRADE-OFF

Google’s choice in this trade-off was not to invest heavily into serverless solutions. Google’s persistent containers solution, Borg, is advanced enough to offer most of the serverless benefits (like autoscaling, various frameworks for different types of applications, deployment tools, unified logging and monitoring tools, and more). The one thing missing is the more aggressive scaling (in particular, the ability to scale down to zero), but the vast majority of Google’s resource footprint comes from high-traffic services, and so it’s comparably cheap to overprovision the small services. At the same time, Google runs multiple applications that would not work in the “truly stateless” world, from GCE, through home-grown database systems like BigQuery or Spanner, to servers that take a long time to populate the cache, like the aforementioned long-tail search serving jobs. Thus, the benefits of having one common unified architecture for all of these things outweigh the potential gains for having a separate serverless stack for a part of a part of the workloads.
谷歌在这种权衡中的选择是不对无服务器解决方案进行大量投资。谷歌的持久化容器解决方案Borg足够先进，可以提供大部分无服务器的好处（比如自动伸缩、针对不同类型应用的各种框架、部署工具、统一的日志和监控工具等等）。缺少的是更积极的扩展（特别是将规模缩小到零的能力），但谷歌的绝大部分资源足迹来自高流量服务，因此过度配置小服务的成本相对较低。同时，谷歌运行着多个在 "真正无状态 "的世界中无法运行的应用程序，从GCE，到自制的数据库系统，如BigQuery或Spanner，到需要长时间填充缓存的服务器，如上述的长尾搜索服务工作。因此，对所有这些事情采用一个共同的统一架构的好处超过了对一部分工作负载采用单独的无服务器堆栈的潜在收益。

However, Google’s choice is not necessarily the correct choice for every organization: other organizations have successfully built out on mixed container/serverless architectures, or on purely serverless architectures utilizing third-party solutions for storage.
然而，谷歌的选择并不一定是每个组织的正确选择：其他组织已经成功地建立了混合容器/无服务器架构，或在纯粹的无服务器架构上利用第三方解决方案进行存储。

The main pull of serverless, however, comes not in the case of a large organization making the choice, but in the case of a smaller organization or team; in that case, the comparison is inherently unfair. The serverless model, though being more restrictive, allows the infrastructure vendor to pick up a much larger share of the overall management overhead and thus decrease the management overhead for the users. Running the code of one team on a shared serverless architecture, like AWS Lambda or Google’s Cloud Run, is significantly simpler (and cheaper) than setting up a cluster to run the code on a managed container service like GKE or AKS if the cluster is not being shared among many teams. If your team wants to reap the benefits of a managed compute offering but your larger organization is unwilling or unable to move to a persistent containers-based solution, a serverless offering by one of the public cloud providers is likely to be attractive to you because the cost (in resources and management) of a shared cluster amortizes well only if the cluster is truly shared (between multiple teams in the organization).
然而，无服务器的主要拉力不是来自于大型组织的选择，而是来自于小型组织或团队的选择；在这种情况下，这种比较本身就是不公平的。无服务器模式虽然限制更多，但它允许基础设施供应商承担更大份额的整体管理费用，从而减少用户的管理费用。在共享的无服务器架构上运行一个团队的代码，如AWS Lambda或谷歌的Cloud Run，如果集群不被许多团队共享，则明显比建立集群在GKE或AKS等管理的容器服务上运行代码更简单（更便宜）。如果你的团队想获得管理计算服务的好处，但你的大型组织不愿意或无法转移到基于持久性容器的解决方案，那么公共云供应商之一的无服务器产品可能对你有吸引力，因为只有当集群真正被共享（在组织中的多个团队之间）时，共享集群的成本（资源和管理）才会摊薄。

Note, however, that as your organization grows and adoption of managed technologies spreads, you are likely to outgrow the constraints of a purely serverless solution. This makes solutions where a break-out path exists (like from KNative to Kubernetes) attractive given that they provide a natural path to a unified compute architecture like Google’s, should your organization decide to go down that path.
然而，请注意，随着企业的发展和管理技术的普及，你很可能会超越纯粹的无服务器解决方案的限制。这使得存在突破路径的解决方案（比如从KNative到Kubernetes）很有吸引力，因为它们提供了一条通往像谷歌这样的统一计算架构的自然路径，如果你的组织决定走这条路的话。

Public Versus Private

Back when Google was starting, the CaaS offerings were primarily homegrown; if you wanted one, you built it. Your only choice in the public-versus-private space was between owning the machines and renting them, but all the management of your fleet was up to you.
早在Google开始的时候，CaaS产品主要是自制的；如果你想要一个，你就建造它。在公共和私人空间中，你唯一的选择是在拥有机器和租用机器之间，但你的车队的所有管理都由你自己决定。

In the age of public cloud, there are cheaper options, but there are also more choices, and an organization will have to make them.
在公有云时代，有更便宜的选择，但也有更多的选择，而一个组织将不得不做出选择。

An organization using a public cloud is effectively outsourcing (a part of) the management overhead to a public cloud provider. For many organizations, this is an attractive proposition—they can focus on providing value in their specific area of expertise and do not need to grow significant infrastructure expertise. Although the cloud providers (of course) charge more than the bare cost of the metal to recoup the management expenses, they have the expertise already built up, and they are sharing it across multiple customers.
使用公共云的机构实际上是将管理费用（部分）外包给公共云供应商。对于许多组织来说，这是一个有吸引力的提议--他们可以专注于在其特定的专业领域提供价值，不需要增长大量的基础设施专业知识。虽然云供应商（当然）收取的费用超过了金属的最低成本，以收回管理费用，但他们已经建立了专业知识，并在多个客户之间共享。

Additionally, a public cloud is a way to scale the infrastructure more easily. As the level of abstraction grows—from colocations, through buying VM time, up to managed containers and serverless offerings—the ease of scaling up increases—from having to sign a rental agreement for colocation space, through the need to run a CLI to get a few more VMs, up to autoscaling tools for which your resource footprint changes automatically with the traffic you receive. Especially for young organizations or products, predicting resource requirements is challenging, and so the advantages of not having to provision resources up front are significant.
此外，公共云是一种更容易扩展基础设施的方式。随着抽象水平的提高--从主机托管，到购买虚拟机时间，再到管理容器和无服务器产品--扩展的难度也在增加--从必须签署主机托管空间的租赁协议，到需要运行CLI来获得更多的虚拟机，再到自动扩展工具，你的资源足迹随着你收到的流量而自动变化。特别是对于年轻的组织或产品，预测资源需求是具有挑战性的，因此，不必预先配置资源的优势是非常显著的。

One significant concern when choosing a cloud provider is the fear of lock-in—the provider might suddenly increase their prices or maybe just fail, leaving an organization in a very difficult position. One of the first serverless offering providers, Zimki, a Platform as a Service environment for running JavaScript, shut down in 2007 with three months’ notice.
在选择云计算供应商时，一个重要的顾虑是担心被锁定--供应商可能会突然涨价，或者直接倒闭，让企业陷入非常困难的境地。最早的无服务器提供商之一Zimki，一个运行JavaScript的平台即服务环境，在2007年关闭，只提前三个月通知。

A partial mitigation for this is to use public cloud solutions that run using an open source architecture (like Kubernetes). This is intended to make sure that a migration path exists, even if the particular infrastructure provider becomes unacceptable for some reason. Although this mitigates a significant part of the risk, it is not a perfect strategy. Because of Hyrum’s Law, it’s difficult to guarantee no parts that are specific to a given provider will be used.
对此的部分缓解措施是使用使用开源架构（如Kubernetes）运行的公共云解决方案。这是为了确保存在一个迁移路径，即使特定的基础设施供应商由于某种原因变得不可接受。虽然这减轻了很大一部分风险，但这并不是一个完美的策略。由于海勒姆定律，很难保证不使用特定供应商的特定部分。

Two extensions of that strategy are possible. One is to use a lower-level public cloud solution (like Amazon EC2) and run a higher-level open source solution (like OpenWhisk or KNative) on top of it. This tries to ensure that if you want to migrate out, you can take whatever tweaks you did to the higher-level solution, tooling you built on top of it, and implicit dependencies you have along with you. The other is to run multicloud; that is, to use managed services based on the same open source solutions from two or more different cloud providers (say, GKE and AKS for Kubernetes). This provides an even easier path for migration out of one of them, and also makes it more difficult to depend on specific implementation details available in one one of them.
该策略有两个延伸的可能性。一种是使用较低级别的公共云解决方案（如亚马逊EC2），并在其上运行较高级别的开源解决方案（如OpenWhisk或KNative）。这试图确保如果你想迁移出去，你可以带着你对高级解决方案所做的任何调整，你在它上面建立的工具，以及你拥有的隐性依赖。另一种是运行多云；也就是说，使用基于两个或多个不同的云供应商的相同开源解决方案的管理服务（例如，Kubernetes的GKE和AKS）。这为迁移出其中一个提供了更容易的路径，同时也使你更难依赖其中一个的具体实施细节。

One more related strategy—less for managing lock-in, and more for managing migration—is to run in a hybrid cloud; that is, have a part of your overall workload on your private infrastructure, and part of it run on a public cloud provider. One of the ways this can be used is to use the public cloud as a way to deal with overflow. An organization can run most of its typical workload on a private cloud, but in case of resource shortage, scale some of the workloads out to a public cloud. Again, to make this work effectively, the same open source compute infrastructure solution needs to be used in both spaces.
还有一个相关的策略--不是为了管理锁定，而是为了管理迁移--是在混合云中运行；也就是说，在你的私有基础设施上有一部分整体工作负载，而在公共云供应商上运行一部分。其中一个方法是将公共云作为处理溢出的一种方式。一个组织可以在私有云上运行其大部分典型的工作负载，但在资源短缺的情况下，将一些工作负载扩展到公共云上。同样，为了使其有效运作，需要在两个空间使用相同的开源计算基础设施解决方案。

Both multicloud and hybrid cloud strategies require the multiple environments to be connected well, through direct network connectivity between machines in different environments and common APIs that are available in both.
多云和混合云战略都需要将多个环境很好地连接起来，通过不同环境中的机器之间的直接网络连接和两个环境中都有的通用API。

Conclusion

Over the course of building, refining, and running its compute infrastructure, Google learned the value of a well-designed, common compute infrastructure. Having a single infrastructure for the entire organization (e.g., one or a small number of shared Kubernetes clusters per region) provides significant efficiency gains in management and resource costs and allows the development of shared tooling on top of that infrastructure. In the building of such an architecture, containers are a key tool to allow sharing a physical (or virtual) machine between different tasks (leading to resource efficiency) as well as to provide an abstraction layer between the application and the operating system that provides resilience over time.
在建设、完善和运行其计算基础设施的过程中，谷歌了解到设计良好的通用计算基础设施的价值。整个组织拥有一个单一的基础设施（例如，每个区域有一个或少量的共享Kubernetes集群），在管理和资源成本方面有显著的效率提升，并允许在该基础设施之上开发共享工具。在构建这样的架构时，容器是一个关键工具，允许在不同的任务之间共享一个物理（或虚拟）机器（导致资源效率），以及在应用程序和操作系统之间提供一个抽象层，提供长期的弹性。

Utilizing a container-based architecture well requires designing applications to use the “cattle” model: engineering your application to consist of nodes that can be easily and automatically replaced allows scaling to thousands of instances. Writing software to be compatible with that model requires different thought patterns; for example, treating all local storage (including disk) as ephemeral and avoiding hardcoding hostnames.
要很好地利用基于容器的架构，需要设计应用程序来使用 "牛 "模型：将你的应用程序设计成由可以轻松自动替换的节点组成，从而可以扩展到成千上万的实例。编写与该模型兼容的软件需要不同的思维模式；例如，将所有本地存储（包括磁盘）视为短暂的，避免硬编码主机名。

That said, although Google has, overall, been both satisfied and successful with its choice of architecture, other organizations will choose from a wide range of compute services—from the “pets” model of hand-managed VMs or machines, through “cattle” replicated containers, to the abstract “serverless” model, all available in managed and open source flavors; your choice is a complex trade-off of many factors.
也就是说，尽管谷歌总体上对其架构的选择感到满意和成功，但其他组织将从广泛的计算服务中进行选择--从手工管理的虚拟机或机器的 "宠物 "模式，通过 "牛 "复制的容器，到抽象的 "无服务器 "模式，都有管理和开源的味道；你的选择是对许多因素的复杂权衡。

TL;DRs

Scale requires a common infrastructure for running workloads in production.
规模化需要一个共同的基础设施来运行生产中的工作负载。

A compute solution can provide a standardized, stable abstraction and environment for software.
一个计算解决方案可以为软件提供一个标准化的、稳定的抽象和环境。

Software needs to be adapted to a distributed, managed compute environment.
软件需要适应分布式、管理式的计算环境。

The compute solution for an organization should be chosen thoughtfully to provide appropriate levels of abstraction.
一个组织的计算解决方案应该被深思熟虑地选择，以提供适当的抽象层次。

1 Disclaimer: for some applications, the “hardware to run it” is the hardware of your customers (think, for example, of a shrink-wrapped game you bought a decade ago). This presents very different challenges that we do not cover in this chapter.
1 免责声明：对于某些应用，"运行它的硬件 "是你的客户的硬件（例如，想想你十年前买的收缩包装的游戏）。这带来了非常不同的挑战，我们在本章中没有涉及。

2 Abhishek Verma, Luis Pedrosa, Madhukar R Korupolu, David Oppenheimer, Eric Tune, and John Wilkes, “Large-scale cluster management at Google with Borg,” EuroSys, Article No.: 18 (April 2015): 1–17.

3 Note that this and the next point apply less if your organization is renting machines from a public cloud provider.
3 请注意，如果你的组织从公共云提供商那里租用机器，那么这一点和下一点就不太适用。

4 Google has chosen, long ago, that the latency degradation due to disk swap is so horrible that an out-of-memory kill and a migration to a different machine is universally preferable—so in Google’s case, it’s always an out-of-memory kill.
4 谷歌很早以前就选择了，由于磁盘交换导致的延迟下降是如此可怕，以至于内存外杀和迁移到不同的机器是普遍可取的，所以在谷歌的情况下，总是内存外杀。

5 Although a considerable amount of research is going into decreasing this overhead, it will never be as low as a process running natively.
5 尽管在减少这种开销方面正在进行大量的研究，但它永远不会像原生运行的进程那样低。

6 The scheduler does not do this arbitrarily, but for concrete reasons (like the need to update the kernel, or a disk going bad on the machine, or a reshuffle to make the overall distribution of workloads in the datacenter bin-packed better). However, the point of having a compute service is that as a software author, I should neither know nor care why regarding the reasons this might happen.
6 调度器并不是任意地这样做，而是出于具体的原因（比如需要更新内核，或者机器上的磁盘坏了，或者重新洗牌以使数据中心中工作负载的整体分布bin-packed更好）。然而，拥有计算服务的意义在于，作为一个软件作者，我既不应该知道也不应该关心关于这可能发生的原因。

7 The “pets versus cattle” metaphor is attributed to Bill Baker by Randy Bias and it’s become extremely popular as a way to describe the “replicated software unit” concept. As an analogy, it can also be used to describe concepts other than servers; for example, see Chapter 22.
7 "宠物与牛 "的比喻是由Randy Bias归功于Bill Baker的，它作为描述 "复制的软件单元 "概念的一种方式，已经变得非常流行。作为一种比喻，它也可以用来描述服务器以外的概念；例如，见第22章。

8 Like all categorizations, this one isn’t perfect; there are types of programs that don’t fit neatly into any of the categories, or that possess characteristics typical of both serving and batch jobs. However, like most useful categorizations, it still captures a distinction present in many real-life cases.
8 像所有的分类法一样，这个分类法并不完美；有一些程序类型并不适合任何一个类别，或者拥有服务和批处理工作的典型特征。然而，像大多数有用的分类法一样，它仍然捕捉到了许多现实生活中的区别。

9 See Jeffrey Dean and Sanjay Ghemawat, “MapReduce: Simplified Data Processing on Large Clusters,” 6th Symposium on Operating System Design and Implementation (OSDI), 2004.
9 见Jeffrey Dean和Sanjay Ghemawat，"MapReduce。简化大型集群上的数据处理"，第六届操作系统设计与实现研讨会（OSDI），2004。

10 Craig Chambers, Ashish Raniwala, Frances Perry, Stephen Adams, Robert Henry, Robert Bradshaw, and Nathan Weizenbaum, “Flume‐Java: Easy, Efficient Data-Parallel Pipelines,” ACM SIGPLAN Conference on Programming Language Design and Implementation (PLDI), 2010.

11 See also Atul Adya et al. “Auto-sharding for datacenter applications,” OSDI, 2019; and Atul Adya, Daniel Myers, Henry Qin, and Robert Grandl, “Fast key-value stores: An idea whose time has come and gone,” HotOS XVII, 2019.
11 另见Atul Adya等人，"数据中心应用的自动分片"，OSDI，2019；以及Atul Adya、Daniel Myers、Henry Qin和Robert Grandl，"快速键值存储。一个时代已经到来的想法，" HotOS XVII，2019年。

12 Note that, besides distributed state, there are other requirements to setting up an effective “servers as cattle” solution, like discovery and load-balancing systems (so that your application, which moves around the datacenter, can be accessed effectively). Because this book is less about building a full CaaS infrastructure and more about how such an infrastructure relates to the art of software engineering, we won’t go into more detail here.
12 请注意，除了分布式状态，建立一个有效的 "服务器即牛 "解决方案还有其他要求，比如发现和负载平衡系统（以便你的应用程序，在数据中心内移动，可以被有效访问）。因为这本书与其说是关于建立一个完整的CaaS基础设施，不如说是关于这样的基础设施与软件工程艺术的关系，所以我们在这里就不多说了。

13 See, for example, Sanjay Ghemawat, Howard Gobioff, and Shun-Tak Leung, “The Google File System,” Proceedings of the 19th ACM Symposium on Operating Systems, 2003; Fay Chang et al., “Bigtable: A Distributed Storage System for Structured Data,” 7th USENIX Symposium on Operating Systems Design and Implementation (OSDI); or James C. Corbett et al., “Spanner: Google’s Globally Distributed Database,” OSDI, 2012.
13 例如，见Sanjay Ghemawat, Howard Gobioff, and Shun-Tak Leung, "The Google File System," Proceedings of the 19th ACM Symposium on Operating Systems, 2003; Fay Chang等人, "Bigtable: 一个结构化数据的分布式存储系统，"第七届USENIX操作系统设计与实现研讨会（OSDI）；或James C. Corbett等人，"Spanner。谷歌的全球分布式数据库"，OSDI，2012。

14 Note that retries need to be implemented correctly—with backoff, graceful degradation and tools to avoid cascading failures like jitter. Thus, this should likely be a part of Remote Procedure Call library, instead of implemented by hand by each developer. See, for example, Chapter 22: Addressing Cascading Failures in the SRE book.
14 请注意，重试需要正确地实现--用后退、优雅的退化和工具来避免像抖动这样的级联故障。因此，这可能应该是远程过程调用库的一部分，而不是由每个开发人员手工实现。例如，见SRE书中的第22章：解决级联故障。

15 This has happened multiple times at Google; for instance, because of someone leaving load-testing infrastructure occupying a thousand Google Compute Engine VMs running when they went on vacation, or because a new employee was debugging a master binary on their workstation without realizing it was spawning 8,000 full-machine workers in the background.
15 这种情况在谷歌发生过多次；例如，因为有人在休假时留下了占用一千台谷歌计算引擎虚拟机的负载测试基础设施，或者因为一个新员工在他们的工作站上调试一个主二进制文件，而没有意识到它在后台催生了8000个全机器工人。

16 As in any complex system, there are exceptions. Not all machines owned by Google are Borg-managed, and not every datacenter is covered by a single Borg cell. But the majority of engineers work in an environment in which they don’t touch non-Borg machines, or nonstandard cells.
16 正如任何复杂的系统一样，也有例外。并非所有谷歌拥有的机器都由博格管理，也不是每个数据中心都由一个博格单元覆盖。但大多数工程师的工作环境是，他们不接触非博格机，也不接触非标准的单元。

17 This particular command is actively harmful under Borg because it prevents Borg’s mechanisms for dealing with failure from kicking in. However, more complex wrappers that echo parts of the environment to logging, for example, are still in use to help debug startup problems.
17 这个特殊的命令在Borg下是积极有害的，因为它阻止了Borg处理故障的机制的启动。然而，更复杂的包装器，例如将环境的一部分回显到日志中，仍然被用来帮助调试启动问题。

18 My mail server is not interchangeable with your graphics rendering job, even if both of those tasks are running in the same form of VM.
18 我的邮件服务器与你的图形渲染工作是不能互换的，即使这两个任务是在同一形式的虚拟机中运行。

19 This is not the only motivation for making user VMs possible to live migrate; it also offers considerable user-facing benefits because it means the host operating system can be patched and the host hardware updated without disrupting the VM. The alternative (used by other major cloud vendors) is to deliver “maintenance event notices,” which mean the VM can be, for example, rebooted or stopped and later started up by the cloud provider.
19 这并不是使用户虚拟机可以实时迁移的唯一动机；它还提供了相当大的面向用户的好处，因为它意味着可以在不中断虚拟机的情况下对主机操作系统进行修补和主机硬件的更新。另一种方法（其他主要云供应商使用）是提供 "维护事件通知"，这意味着虚拟机可以，例如，重新启动或停止，随后由云供应商启动。

20 This is particularly relevant given that not all customer VMs are opted into live migration; for some workloads even the short period of degraded performance during the migration is unacceptable. These customers will receive maintenance event notices, and Borg will avoid evicting the containers with those VMs unless strictly necessary.
20 考虑到并非所有客户的虚拟机都选择实时迁移，这一点尤其重要；对于一些工作负载来说，即使是迁移过程中短时间的性能下降也是不可接受的。这些客户将收到维护事件通知，除非绝对必要，Borg将避免驱逐带有这些虚拟机的容器。

21 A good reminder that monitoring and tracking the usage of your features is valuable over time.
21 一个很好的提醒，监测和跟踪你的功能的使用情况是有价值的，随着时间的推移。

22 This means that Kubernetes, which benefited from the experience of cleaning up Borg but was not hampered by a broad existing userbase to begin with, was significantly more modern in quite a few aspects (like its treatment of labels) from the beginning. That said, Kubernetes suffers some of the same issues now that it has broad adoption across a variety of types of applications.
22 这意味着Kubernetes受益于清理Borg的经验，但一开始就没有受到广泛的现有用户群的阻碍，从一开始就在相当多的方面（比如它对标签的处理）明显更现代化。也就是说，Kubernetes现在也遇到了一些同样的问题，因为它已经在各种类型的应用中被广泛采用。

23 FaaS (Function as a Service) and PaaS (Platform as a Service) are related terms to serverless. There are differences between the three terms, but there are more similarities, and the boundaries are somewhat blurred.
23 FaaS（功能即服务）和PaaS（平台即服务）是与无服务器相关的术语。这三个术语之间有区别，但更多的是相似之处，而且界限有些模糊不清。
