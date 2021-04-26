CB 持续构建

CD 持续交付

RC 预发布版

cherry-pick 择优挑选

test suite 测试集

SRE ？？？

---

icy:

在共享环境中包含一些RC的人工QA测试也是很常见的。

针对RC运行一个全面自动化的测试集是很重要的，即使它和CB在提交后对代码运行的测试集相同(假设CD是通过的)。这么做有以下几点理由:

*作一次全面检查*

​	我们再次检查代码在RC中被剪切和重新编译时没有发生任何奇怪的事情。

*用于审核*

​	如果一个工程师想要检查一个RC的测试结果，它们是现成的，并且与RC本身相关联，所以他们不需要挖掘CB的日志来找到它们。

*允许cherry-pick（择优挑选）*

​	如果你对RC应用一个cherry-pick，你的源代码现在已经与CB测试的最新版本不同了。

*紧急推送*

​	在这种情况下，CD不必等待完整的CB通过，就可以从真正的head中删除并运行所需的最小测试集，以此对紧急推送感到自信。

### 生产测试

我们持续自动化的测试过程一直延伸到最终部署的环境:生产环境。我们应该对生产版本(有时称为探测程序)运行与之前对RC所做的相同的测试集，以验证：1)由测试结果得出的生产环境的工作状态 2)由生产环境表现出的我们测试的相关性。。

在应用程序的每一步进程执行持续测试,每种方法都有自己的利弊,提醒人们利用“纵深防御”方法的优势来捕获错误——我们保证质量和稳定性依靠的不只是这一个技术或政策,这是许多测试方法的总和。

#### CI是一种警报

*Titus Winters*

与负责任地运行生产系统一样，可持续地维护软件系统也需要持续的自动化监控。正如我们使用监视和警报系统来理解生产系统如何响应变化一样，CI揭示了我们的软件如何响应其环境中的变化。生产监控依赖于运行系统的被动警报和主动探测器，而CI使用单元和集成测试检测软件在部署之前的更改。

---

比较CI和警报这两个领域可以让我们把知识从一个领域运用到另一个领域。

CI和警报在开发人员工作流程中的总目标是一样的——尽可能快地发现问题。CI强调开发人员早期的工作流程，并通过显示失败的测试来捕获问题。警报重点关注同一工作流的后期，并通过监控指标，在它们超过某个阈值时发起报告来捕获问题。两者都是“尽快自动发现问题”的形式。

一个管理有方的警报系统有助于令你的服务等级目标(service-level objective, SLOs)得到满足。一个好的CI系统有助于确保你的构建处于良好的状态——代码编译、然后测试通过，之后如果需要还可以部署一个新发布。这两个领域的最佳实践策略都着重于逼真度和可操作的警报:只有违反重要的基本不变量时，测试才会失败，而不是因为测试脆弱或不稳定。每隔几次CI运行就失败一次的不稳定测试，或者每隔几分钟就发出一次虚假警报并为on-call生成一个页面，都是有很大问题的。如果没法采取行动，就不应该发出警报。如果它实际上没有违反SUT的不变量，那么它就不该是失败的测试。

CI和警报共享一个基本的概念框架。例如，在局部信号(单元测试、监视独立统计信息/基于原因的警报)和交叉依赖信号(集成和发布测试、黑盒探测)之间存在类似的关系。衡量一个综合系统是否在工作的最高逼真度指标是端到端信号，但这种逼真度是不稳定的、而且增加了资源成本，并且不容易调试根本的原因。

类似地，我们在两个领域的故障模式中看到一个基本联系。基于原因的警报出现不稳定是因为数据超出了一个随意的阈值(例如，失败请求在过去一小时内的重试次数)，而该阈值与最终用户所看到的系统健康状况之间不一定存在根本联系。当一个任意的测试需求或不变条件被违反时，不稳定的测试就会失败，但这个不变条件和被测试软件的正确性之间不一定存在基本联系。在大多数情况下，这些代码很容易编写，并且可能有助于调试更大的问题。在这两种情况下，它们都是粗略的表现了整体的健康/正确性，无法捕获整体的具体行为。如果你没有一个简单的端到端探针，但你确实使收集一些汇总统计数据变得容易，那么团队将根据任意的统计数据编写阈值警报。如果你没有高等级的方法来解释这样的故障：”编码前的图像与解码后的图像不太相同”，那么测试失败，团队将构建一个断言测试：字节流是否相同的。

基于原因的警报和不稳定测试仍然是有用的，只不过它们并不是在警报场景中发现潜在问题的理想方式。在实际发生故障的情况下，提供更多的调试细节是很有用的。当SRE调试断电时，如果有“一小时前的用户，开始经历更多失败请求。大约在同一时间，重试次数开始增加。让我们开始调查吧。”这样的表单信息，就会很有用。类似地，不稳定的测试仍然可以提供额外的调试信息:“图像渲染管道开始吐出垃圾。其中一个单元测试表明，我们从JPEG压缩器得到了不同的字节。让我们从这里开始调查吧。”

---

尽管监视和警报被认为是SRE/生产管理领域的一部分，它们对于“错误预算”的观点也被充分的理解[^9] ，但CI仍然倾向于绝对的视角。将CI定义为警示的“左移”就是开始建议推行这些策略及其更好的最佳实践：

- 在CI上拥有100%的绿色率，就像生产服务拥有100%的正常运行时间一样，是非常昂贵的。如果这确实是你的目标，那么最大的问题之一就是测试和提交之间的竞争条件。
- 一般来说，不应该把每一次警报当作同等原因来处理。如果在生产中触发警报，但服务实际上没有受到影响，那么关闭警报才是正确的选择。对于测试失败也是如此：在我们的CI系统学会如何说明“这个测试因为不相关的原因失败了”之前，我们或许应该对禁用失败的测试更包容一点，因为并不是所有的测试失败都预示着即将到来的生产问题。
- “如果我们最新的CI运行结果不是绿色的，所有人都不能提交”，这种策略可能是一种误导。如果CI报告了一个问题，那么在让人们提交或加重这个问题之前，肯定应该对此类失败进行调查。但是，如果很好地理解了根本原因，而且很明显不会影响生产，那么阻塞提交是不合理的

这种“CI是一种警报”的观点仍是初步提出，我们还在研究如何完全将两者划成等号。考虑到所涉及的较高风险，SRE在围绕监视和警报的最佳实践方面投入了大量精力也就不足为奇了，而CI则被视为一种更奢侈的功能。[^10]在接下来的几年里,软件工程的任务将是见证现有CI环境的行为实践被赋予新的概念，来帮助调整测试和CI景观，测试中的最佳实践可以帮助明确监控和报警的目标和策略。

[^9]: 不应该以100%正常的运行时间作为目标。而是选择99.9%或99.999%作为业务或产品的取舍，定义并监控你的实际正常运行时间，并使用“预算”作为你愿意以多大的力度推送风险版本。
[^10]:  我们相信CI对于软件工程生态系统实际上是至关重要的:是必须的，而不是奢侈的。但这一点还没有得到普遍理解。

---

### CI的挑战

我们已经讨论了一些已实行的最佳CI实践，并引入了一些涉及的挑战，例如不稳定的、缓慢的、相互冲突的工程生产团队，或者只是在预提交时测试太多这样的潜在隐患。在实现CI时，一些常见的额外挑战包括:

- *预提交优化*，包括根据我们已经描述的潜在问题，确定哪些测试要在预提交时运行，以及如何运行它们。
- *找出罪魁祸首*和*故障隔离*：问题是被哪些代码或者其他改动导致的？它发生在哪个系统上？“集成上游微服务”是一种分布式架构中进行故障隔离的方法，当你想要确定问题是源于你本地的服务器还是后端时。在这种方法中，你可以组合稳定服务器和上游微服务的新服务器。（因此，你正在将微服务的最新更改集成到你的测试中。）由于版本倾斜，这种方法可能特别具有挑战性:不仅这些环境经常不兼容，而且你还可能遇到在特定的集成中出现的误报问题，而在生产中实际上不会发现这些问题。
- *资源约束*：测试需要资源来运行，大型测试可能非常昂贵。此外，在整个过程中插入自动化测试的基础设施的成本是相当大的。

另外还需要面临*失败管理*的挑战——当测试失败时该怎么做。尽管较小的问题通常可以很快得到解决，但我们的许多团队发现，当涉及到大型端到端测试时，很难有一个一致通过的测试集。它们本身就是残缺的或者不稳定的，难以调试；需要有一种机制来暂时禁用并跟踪它们，这样发布才能继续进行。谷歌的一项常见技术是使用由on-call或设计发布工程师提交的bug“热点列表”，并将其划分到合适的团队。这些错误如果可以自动生成和归档就更好了——我们的一些较大的产品都是这样做的，如谷歌Web服务器(GWS)和谷歌助理。为了确保任何阻止发布的bug都能被立即修复，这些热点列表应该被妥善管理。非发布版本的断点也应该被修复；它们不那么紧急，但也应该被优先考虑，这样测试集仍然有用，而不仅仅是一堆被禁用的、旧的测试。通常，端到端测试失败所捕获的问题实际上与测试有关，而不是代码。

不稳定的测试给这个过程带来了另一个问题。它们类似于残缺的测试，降低了团队的信心，而且更难找到一个代码变更来回滚，因为失败不会一直发生。一些团队依赖于某种工具，在这些不稳定的测试被调查和修复的时候，暂时从预提交中删除这些不稳定的测试。这样可以保持较高的信心，同时留出更多时间来解决问题。

---

*测试不稳定性*是另一个重要的挑战，这个在预提交的背景下就已经被我们所考虑。处理这一问题的一个策略是允许测试多次尝试运行。这是团队常常使用的一个测试配置。同样，在测试代码中，可以在不同的特定点引入重试。

另一种有助于解决测试不稳定性（和其他CI挑战）的方法是密封测试，我们将在下一节中讨论。

### 密封测试

因为与在线的后端通信并不可靠，所以我们经常使用密封的后端来进行更大范围的测试。当我们想在预提交版本上运行这些测试时，这特别有用，因为稳定性是最重要的。在第11章中，我们介绍了密封测试的概念:

> *密封测试*：针对完全自包含的测试环境（即应用程序服务器和资源）运行的测试（即没有类似生产后端那样的外部依赖）。

密封测试有两个重要的特性：更高的确定性（即稳定性）和隔离性。密封的服务器仍然容易受到一些不确定性的影响，比如系统时间、随机数生成和竞态条件。但是，参与测试的内容不会根据外部依赖项而改变，所以当你使用相同的应用程序和测试代码再次运行测试时，应该会得到相同的结果。如果密封测试失败，你知道这是由于应用程序代码或测试的更改所致（有一个小警告：它们也可能由于密封测试环境的重新构造而失败，不过环境不常发生变化）。因此，当CI系统在数小时或数天之后重新运行测试以提供额外的信号时，密封测试失败更容易缩小范围。

另外还有一个重要的特性，隔离性，意味着生产中的问题应该不会影响这些测试。我们通常也会在同一台机器上运行这些测试，所以我们不必担心网络连接问题。反过来也成立：运行密封测试引起的问题应该不会影响生产。

密封测试的成功应该不会依赖于运行测试的用户。这允许人们重新运行由CI系统运行的测试，并允许人们（例如，lib库开发人员）运行其他团队的测试。

有一种专门仿造的密封后端。正如第13章所讨论的，这些可能比运行一个真正的后端成本更低，但是它们需要维护并且逼真度有限。要实现预提交版本的集成测试，最纯净的选择是使用一个完全密封的设置，即启动整个沙盒化堆栈[^11]，然后谷歌为流行的组件(如数据库)提供开箱即用的沙箱配置，使设置起来更加容易。小型应用程序的组件越少，实行起来就越容易，但在谷歌有例外，即使是一个DisplayAds的应用，都会在每次预提交和连续提交时从头启动大约400个服务器。自从系统创建以来，记录/重放模式已经流行于更大的系统，而且比启动一个大型沙盒化堆栈更便宜。

----

记录/回放系统（见第14章）记录并缓存实时的后端响应，然后在密封测试环境中回放它们。记录/回放是减少测试不稳定性的强大工具，但它的一个缺点是导致测试不稳定，很难在以下两者之间取得平衡：

*漏报率*

​	测试在不应该通过的情况下通过了，因为我们访问了太多次缓存从而错过了在捕捉新响应时可能出现的问题。	

*误报率*

​	测试在不应该失败的情况下失败了，因为我们命中的缓存太少。这需要对响应进行更新，可能耗时较长并导致一些需要修复的测试失败，其中许多可能不是真正的问题。这个过程通常是阻塞提交的，这并不理想。

理想情况下，记录/重放系统应该只检测有问题的更改，并且只在请求以有意义的方式更改时避开缓存。如果该更改产生了新的问题，代码更改的作者将使用更新的响应重新运行测试，查看测试是否仍然失败，并因此得到该问题的警报。实际上，在一个不断变化的大型系统中，是很难知道一个请求何时以一种有意义的方式改变的。

[^11]: 实际上，通常很难创建一个完全的沙盒化测试环境，但是可以通过减少外部依赖来实现所需的稳定性。

#### 密封的Google Assistant

Google Assistant为工程师提供了一个框架来运行端到端测试，包括一个Test Fixture（测试固件），该测试固件具有设置查询的功能，还能指定在电话上或者智能家居设备上进行模拟，以及验证与Google Assistant之间的响应。它最成功的是使它的测试集在预提交上完全密封。当团队以前在预提交上运行非密封测试时，测试通常会失败。甚至某些时候，团队将看到超过50个代码更改绕过并忽略了测试结果。而通过将预提交移至密封环境，团队将运行时间缩短了14倍，几乎没有任何不稳定性。它仍然可以看到失败，但这些失败往往相当容易找到并回滚。

---

现在非密封测试已经被推送到提交后，它反而导致失败在那里累积。调试失败的端到端测试仍然很困难，一些团队甚至没有时间去尝试，所以他们只能禁用它们。让它停止所有人的开发进度相比这还算好，但它可能会导致生产环境报错。

该团队目前面临的挑战之一是继续微调其缓存机制，以便预提交能够捕获更多类型的问题，这些问题在过去只在提交后才发现，而不会带来太多的脆弱性。

另一个问题是如何为去中心化的Assistant进行预提交测试，因为组件正在将它们转换为微服务。由于Assistant有一个庞大而复杂的堆栈，在预提交上运行一个密封堆栈，其工程工作、协调和资源方面的成本，都将是非常高的。

最后，该团队正在以一种聪明的后提交的失败隔离策略来利用这种去中心化环境。对于Assistant中的每个*N*微服务，团队将运行一个提交后的环境，其中包含在头部构建的微服务，以及其他*N-1*个服务的生产（或接近它的）版本，以将问题隔离到新构建的服务器上。
这种设置通常需要*O(N<sup>2</sup>)*成本才能实现，但该团队使用一个名为*热交换*的功能将成本降至*O(N)*。原理是，热交换允许请求指示服务器去“交换”后端地址，而不是通常的地址。所以只需要运行*N*个服务器，每个微服务都需要一个，并且它们可以在这N个环境中重用交换同一组生产后端。

正如我们在本节中所看到的，密封测试可以减少更大范围测试中的不稳定性，并帮助隔离故障，解决在前一节中我们所阐述的两个重要CI挑战。然而，密封后端也可能更昂贵，因为它们使用更多的资源，并且设置更慢。许多团队在他们的测试环境中组合使用密封后端和在线后端。

### 在谷歌的CI

现在让我们更详细地看看CI是如何在谷歌实现的。首先，我们将看看我们的全局持续构建，即被谷歌的绝大多数团队所使用的TAP，以及它如何使一些实践成为可能，并解决我们在上一节中所看到的一些挑战。我们还将讨论谷歌Takeout这一应用，以及它在转变为CI的过程中，CI是如何帮助它扩展为平台和服务的。

---

#### TAP: Google’s Global Continuous Build

*Adam Bender*

We run a massive continuous build, called the Test Automation Platform (TAP), of our entire codebase. It is responsible for running the majority of our automated tests. As a direct consequence of our use of a monorepo, TAP is the gateway for almost all changes at Google. Every day it is responsible for handling more than 50,000 unique changes and running more than four billion individual test cases. 

TAP is the beating heart of Google’s development infrastructure. Conceptually, the process is very simple. When an engineer attempts to submit code, TAP runs the associated tests and reports success or failure. If the tests pass, the change is allowed into the codebase.

##### Presubmit optimization

To catch issues quickly and consistently, it is important to ensure that tests are run against every change. Without a CB, running tests is usually left to individual engineer discretion, and that often leads to a few motivated engineers trying to run all tests and keep up with the failures.

As discussed earlier, waiting a long time to run every test on presubmit can be severely disruptive, in some cases taking hours. To minimize the time spent waiting, Google’s CB approach allows potentially breaking changes to land in the repository (remember that they become immediately visible to the rest of the company!). All we ask is for each team to create a fast subset of tests, often a project’s unit tests, that can be run before a change is submitted (usually before it is sent for code review)—the presubmit. Empirically, a change that passes the presubmit has a very high likelihood (95%+) of passing the rest of the tests, and we optimistically allow it to be integrated so that other engineers can then begin to use it.

After a change has been submitted, we use TAP to asynchronously run all potentially affected tests, including larger and slower tests.

When a change causes a test to fail in TAP, it is imperative that the change be fixed quickly to prevent blocking other engineers. We have established a cultural norm that strongly discourages committing any new work on top of known failing tests, though flaky tests make this difficult. Thus, when a change is committed that breaks a team’s build in TAP, that change may prevent the team from making forward progress or building a new release. As a result, dealing with breakages quickly is imperative.

To deal with such breakages, each team has a “Build Cop.” The Build Cop’s responsibility is keeping all the tests passing in their particular project, regardless of who breaks them. When a Build Cop is notified of a failing test in their project, they drop whatever they are doing and fix the build. This is usually by identifying the offending change and determining whether it needs to be rolled back (the preferred solution) or can be fixed going forward (a riskier proposition).

---

In practice, the trade-off of allowing changes to be committed before verifying all tests has really paid off; the average wait time to submit a change is around 11 minutes, often run in the background. Coupled with the discipline of the Build Cop, we are able to efficiently detect and address breakages detected by longer running tests with a minimal amount of disruption.

##### Culprit finding

One of the problems we face with large test suites at Google is finding the specific change that broke a test. Conceptually, this should be really easy: grab a change, run the tests, if any tests fail, mark the change as bad. Unfortunately, due to a prevalence of flakes and the occasional issues with the testing infrastructure itself, having confidence that a failure is real isn’t easy. To make matters more complicated, TAP must evaluate so many changes a day (more than one a second) that it can no longer run every test on every change. Instead, it falls back to batching related changes together, which reduces the total number of unique tests to be run. Although this approach can make it faster to run tests, it can obscure which change in the batch caused a test to break.

To speed up failure identification, we use two different approaches. First, TAP automatically splits a failing batch up into individual changes and reruns the tests against each change in isolation. This process can sometimes take a while to converge on a failure, so in addition, we have created culprit finding tools that an individual developer can use to binary search through a batch of changes and identify which one is the likely culprit.

##### Failure management

After a breaking change has been isolated, it is important to fix it as quickly as possible. The presence of failing tests can quickly begin to erode confidence in the test suite. As mentioned previously, fixing a broken build is the responsibility of the Build Cop. The most effective tool the Build Cop has is the *rollback*.

Rolling a change back is often the fastest and safest route to fix a build because it quickly restores the system to a known good state.[^12] In fact, TAP has recently been upgraded to automatically roll back changes when it has high confidence that they are
the culprit.

Fast rollbacks work hand in hand with a test suite to ensure continued productivity. Tests give us confidence to change, rollbacks give us confidence to undo. Without tests, rollbacks can’t be done safely. Without rollbacks, broken tests can’t be fixed quickly, thereby reducing confidence in the system.

[^12]: Any change to Google’s codebase can be rolled back with two clicks!

---

