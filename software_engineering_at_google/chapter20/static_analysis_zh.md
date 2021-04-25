## CHAPTER 20

# Static Analysis

*Written by Caitlin Sadowski  
Edited by Lisa Carey*

Static analysis refers to programs analyzing source code to find potential issues such as bugs, antipatterns, and other issues that can be diagnosed without executing the program. The “static” part specifically refers to analyzing the source code instead of a running program (referred to as “dynamic” analysis). Static analysis can find bugs in programs early, before they are checked in as production code. For example, static analysis can identify constant expressions that overflow, tests that are never run, or invalid format strings in logging statements that would crash when executed.<sup id="a1">[[1]](#f1)</sup> However, static analysis is useful for more than just finding bugs. Through static analysis at Google, we codify best practices, help keep code current to modern API versions, and prevent or reduce technical debt. Examples of these analyses include verifying that naming conventions are upheld, flagging the use of deprecated APIs, or pointing out simpler but equivalent expressions that make code easier to read. Static analysis is also an integral tool in the API deprecation process, where it can prevent backsliding during migration of the codebase to a new API (see [Chapter 22](../chapter22/large_scale_changes_zh.md)). We have also found evidence that static analysis checks can educate developers and actually prevent antipatterns from entering the codebase.<sup id="a2">[[2]](#f2)</sup>)



In this chapter, we’ll look at what makes effective static analysis, some of the lessons we at Google have learned about making static analysis work, and how we implemented these best practices in our static analysis tooling and processes.<sup id="a3">[[3]](#f3)</sup>

## Characteristics of Effective Static Analysis
Although there have been decades of static analysis research focused on developing new analysis techniques and specific analyses, a focus on approaches for improving scalability and usability of static analysis tools has been a relatively recent development.
### Scalability
Because modern software has become larger, analysis tools must explicitly address scaling in order to produce results in a timely manner, without slowing down the software development process. Static analysis tools at Google must scale to the size of Google’s multibillion-line codebase. To do this, analysis tools are shardable and incremental. Instead of analyzing entire large projects, we focus analyses on files affected by a pending code change, and typically show analysis results only for edited files or lines. Scaling also has benefits: because our codebase is so large, there is a lot of low-hanging fruit in terms of bugs to find. In addition to making sure analysis tools can run on a large codebase, we also must scale up the number and variety of analyses available. Analysis contributions are solicited from throughout the company. Another component to static analysis scalability is ensuring the process is scalable. To do this, Google static analysis infrastructure avoids bottlenecking analysis results by showing them directly to relevant engineers.
### Usability
When thinking about analysis usability, it is important to consider the cost-benefit trade-off for static analysis tool users. This “cost” could either be in terms of developer time or code quality. Fixing a static analysis warning could introduce a bug. For code that is not being frequently modified, why “fix” code that is running fine in production? For example, fixing a dead code warning by adding a call to the previously dead code could result in untested (possibly buggy) code suddenly running. There is unclear benefit and potentially high cost. For this reason, we generally focus on newly introduced warnings; existing issues in otherwise working code are typically only worth highlighting (and fixing) if they are particularly important (security issues, significant bug fixes, etc.). Focusing on newly introduced warnings (or warnings on modified lines) also means that the developers viewing the warnings have the most relevant context on them.

Also, developer time is valuable! Time spent triaging analysis reports or fixing highlighted issues is weighed against the benefit provided by a particular analysis. If the analysis author can save time (e.g., by providing a fix that can be automatically applied to the code in question), the cost in the trade-off goes down. Anything that can be fixed automatically should be fixed automatically. We also try to show developers reports about issues that actually have a negative impact on code quality so that they do not waste time slogging through irrelevant results.

To further reduce the cost of reviewing static analysis results, we focus on smooth developer workflow integration. A further strength of homogenizing everything in one workflow is that a dedicated tools team can update tools along with workflow and code, allowing analysis tools to evolve with the source code in tandem.

We believe these choices and trade-offs that we have made in making static analyses scalable and usable arise organically from our focus on three core principles, which we formulate as lessons in the next section.

## Key Lessons in Making Static Analysis Work
There are three key lessons that we have learned at Google about what makes static analysis tools work well. Let’s take a look at them in the following subsections.

### Focus on Developer Happiness
We mentioned some of the ways in which we try to save developer time and reduce the cost of interacting with the aforementioned static analysis tools; we also keep track of how well analysis tools are performing. If you don’t measure this, you can’t fix problems. We only deploy analysis tools with low false-positive rates (more on that in a minute). We also actively solicit and act on feedback from developers consuming static analysis results, in real time. Nurturing this feedback loop between static analysis tool users and tool developers creates a virtuous cycle that has built up user trust and improved our tools. User trust is extremely important for the success of static analysis tools.

For static analysis, a “false negative” is when a piece of code contains an issue that the analysis tool was designed to find, but the tool misses it. A “false positive” occurs when a tool incorrectly flags code as having the issue. Research about static analysis tools traditionally focused on reducing false negatives; in practice, low false-positive rates are often critical for developers to actually want to use a tool—who wants to wade through hundreds of false reports in search of a few true ones?<sup id="a4">[[4]](#f4)</sup>

Furthermore, perception is a key aspect of the false-positive rate. If a static analysis tool is producing warnings that are technically correct but misinterpreted by users as false positives (e.g., due to confusing messages), users will react the same as if those warnings were in fact false positives. Similarly, warnings that are technically correct but unimportant in the grand scheme of things provoke the same reaction. We call the user-perceived false-positive rate the “effective false positive” rate. An issue is an “effective false positive” if developers did not take some positive action after seeing the issue. This means that if an analysis incorrectly reports an issue, yet the developer happily makes the fix anyway to improve code readability or maintainability, that is not an effective false positive. For example, we have a Java analysis that flags cases in which a developer calls the contains method on a hash table (which is equivalent to containsValue) when they actually meant to call containsKey—even if the developer correctly meant to check for the value, calling containsValue instead is clearer. Similarly, if an analysis reports an actual fault, yet the developer did not understand the fault and therefore took no action, that is an effective false positive.

### Make Static Analysis a Part of the Core Developer Workflow
At Google, we integrate static analysis into the core workflow via integration with code review tooling. Essentially all code committed at Google is reviewed before being committed; because developers are already in a change mindset when they send code for review, improvements suggested by static analysis tools can be made without too much disruption. There are other benefits to code review integration. Developers typically context switch after sending code for review, and are blocked on reviewers— there is time for analyses to run, even if they take several minutes to do so. There is also peer pressure from reviewers to address static analysis warnings. Furthermore, static analysis can save reviewer time by highlighting common issues automatically; static analysis tools help the code review process (and the reviewers) scale. Code review is a sweet spot for analysis results.<sup id="a5">[[5]](#f5)</sup>

### Empower Users to Contribute
There are many domain experts at Google whose knowledge could improve code produced. Static analysis is an opportunity to leverage expertise and apply it at scale by having domain experts write new analysis tools or individual checks within a tool.

For example, experts who know the context for a particular kind of configuration file can write an analyzer that checks properties of those files. In addition to domain experts, analyses are contributed by developers who discover a bug and would like to prevent the same kind of bug from reappearing anywhere else in the codebase. We focus on building a static analysis ecosystem that is easy to plug into instead of integrating a small set of existing tools. We have focused on developing simple APIs that can be used by engineers throughout Google—not just analysis or language experts— to create analyses; for example, Refaster<sup id="a6">[[6]](#f6)</sup> enables writing an analyzer by specifying pre- and post-code snippets demonstrating what transformations are expected by that analyzer.

## Tricorder: Google’s Static Analysis Platform
Tricorder, our static analysis platform, is a core part of static analysis at Google.<sup id="a7">[[7]](#f7)</sup> Tricorder came out of several failed attempts to integrate static analysis with the developer workflow at Google;<sup id="a8">[[8]](#f8)</sup> the key difference between Tricorder and previous attempts was our relentless focus on having Tricorder deliver only valuable results to its users. Tricorder is integrated with the main code review tool at Google, Critique. Tricorder warnings show up on Critique’s diff viewer as gray comment boxes, as demonstrated in [Figure 20-1](https://i.loli.net/2021/04/13/xfsrGWhi5HlumwB.jpg).
![figure20-1.jpg](https://i.loli.net/2021/04/13/xfsrGWhi5HlumwB.jpg)
*Figure 20-1. Critique’s diff viewing, showing a static analysis warning from Tricorder in gray*

To scale, Tricorder uses a microservices architecture. The Tricorder system sends analyze requests to analysis servers along with metadata about a code change. These servers can use that metadata to read the versions of the source code files in the change via a FUSE-based filesystem and can access cached build inputs and outputs. The analysis server then starts running each individual analyzer and writes the output to a storage layer; the most recent results for each category are then displayed in Critique. Because analyses sometimes take a few minutes to run, analysis servers also post status updates to let change authors and reviewers know that analyzers are running and post a completed status when they have finished. Tricorder analyzes more than 50,000 code review changes per day and is often running several analyses per second.

Developers throughout Google write Tricorder analyses (called “analyzers”) or contribute individual “checks” to existing analyses. There are four criteria for new Tricorder checks:

Be understandable
    
- Be easy for any engineer to understand the output.

Be actionable and easy to fix
- The fix might require more time, thought, or effort than a compiler check, and the result should include guidance as to how the issue might indeed be fixed.

Produce less than 10% effective false positives
- Developers should feel the check is pointing out an actual issue at least 90% of the time.

Have the potential for significant impact on code quality
- The issues might not affect correctness, but developers should take them seriously and deliberately choose to fix them.

Tricorder analyzers report results for more than 30 languages and support a variety of analysis types. Tricorder includes more than 100 analyzers, with most being contributed from outside the Tricorder team. Seven of these analyzers are themselves plug-in systems that have hundreds of additional checks, again contributed from developers across Google. The overall effective false-positive rate is just below 5%.

### Integrated Tools
There are many different types of static analysis tools integrated with Tricorder.

Error Prone and clang-tidy extend the compiler to identify AST antipatterns for Java and C++, respectively. These antipatterns could represent real bugs. For example, consider the following code snippet hashing a field f of type long:

- result = 31 * result + (int) (f ^ (f >>> 32));

Now consider the case in which the type of f is int. The code will still compile, but the right shift by 32 is a no-op so that f is XORed with itself and no longer affects the value produced. We fixed 31 occurrences of this bug in Google’s codebase while enabling the check as a compiler error in Error Prone. There are many more such examples. AST antipatterns can also result in code readability improvements, such as removing a redundant call to .get() on a smart pointer.

Other analyzers showcase relationships between disparate files in a corpus. The Deleted Artifact Analyzer warns if a source file is deleted that is referenced by other non-code places in the codebase (such as inside checked-in documentation). IfThisThenThat allows developers to specify that portions of two different files must be changed in tandem (and warns if they are not). Chrome’s Finch analyzer runs on configuration files for A/B experiments in Chrome, highlighting common problems including not having the right approvals to launch an experiment or crosstalk with other currently running experiments that affect the same population. The Finch analyzer makes Remote Procedure Calls (RPCs) to other services in order to provide this information.

In addition to the source code itself, some analyzers run on other artifacts produced by that source code; many projects have enabled a binary size checker that warns when changes significantly affect a binary size.

Almost all analyzers are intraprocedural, meaning that the analysis results are based on code within a procedure (function). Compositional or incremental interprocedural analysis techniques are technically feasible but would require additional infrastructure investment (e.g., analyzing and storing method summaries as analyzers run).

### 集成化的反馈通道

正如前面提到的，在analysis consumers和analysis writers之间建立一个反馈循环对于跟踪和维持开发人员的积极性是至关重要的。 使用Tricorder时，我们会在分析结果中显示“无用”的选项按钮; 单击此按钮，可以直接对analyzer writer提出一个反馈，说明为什么分析结果是没用的。 代码审阅者还可以通过单击“Please fix”按钮来请求change authors修改分析结果。Tricorder团队会追踪具有高“无用”点击率的analyzer，特别是经常被要求修改分析结果的analyzer，如果它们不能解决问题并降低“无用”按钮的点击率，则团队会禁用这个analyzer。 建立和调整这个反馈循环将会花费大量的工作，但能够有效改善分析结果和获得更好的用户体验(UX)，因为在我们建立清晰的反馈渠道之前，许多开发人员会忽略他们不理解的分析结果。

有时修复一个问题是很简单的--比如改进一个analyzer输出的提示信息! 例如，我们曾经推出一个错误分析器叫 Error Prone ，它的功能是当太多的参数被传递给一个类似于Guava的printf的函数时，它会提示错误，且这个函数仅接受 %s (不接受其他类型的占位符)。但是在推出后 Error Prone 团队每周都会收到提示信息“无用”的错误报告，报告里称当占位符的数量与参数的数量相同时分析器却提示错误，其原因是用户试图传递%s以外的占位符导致了错误提示。在团队更改诊断信息并声明该函数只接受%s占位符后，Error Prone团队就不再继续收到错误报告了。 从上面的例子可以知道提示信息应该尽可能详细，如说明哪里是错的、为什么错、以及修复它的方法，并且可以使开发人员在阅读提示信息时学到一些东西。

### 修复建议

Tricorder 会在可能的情况下提供错误修复建议，如下图所示 [图 20-2]([figure20-2.png](https://i.loli.net/2021/04/13/bNEeaMWyr7T4PtQ.png)).

![figure20-2.png](https://i.loli.net/2021/04/13/bNEeaMWyr7T4PtQ.png)
*图 20-2. 一个通过静态分析修复错误的例子*

当信息不清楚时，自动修复可以作为额外的参考文档，并且如前文所述，这可以降低解决静态分析问题的成本。开发者可以直接点击提示信息来应用自动修复，或者通过命令行工具应用于整个代码更改。虽然不是所有的分析器都支持代码修复，但是大部分分析器都提供了这个功能。我们认为代码格式问题应该由分析器自动解决；例如，自动格式化代码文件的格式化程序。谷歌对每种语言都有指定了代码风格指南；修复格式问题会浪费开发者的时间。审阅者每天点击“请修复”数千次，作者每天应用自动修复约3000次。并且Tricorder分析器每天收到250次“无用”点击。

### 基于项目的可定制化
在我们通过只显示高可信度的分析结果建立了用户信任的基础之后，除了默认的分析结果之外，我们还为特定的项目增加了运行额外的“可选的”分析器的支持。Proto Best Practices分析器是可自定义分析器的一个例子。这个分析器会高亮那些可能会对协议缓冲区(google的独立于语言的数据序列化格式)数据格式破坏的更改。只有当序列化数据存储在某个地方(例如，在服务器日志中)时，这些更改才会中断；没有存储序列化数据的项目的协议缓冲区不需要启用检查。我们还增加了定制现有分析器的功能，尽管这种定制通常是有限的，并且默认情况下，在代码库中使用统一的检查方式。

有些分析器甚至开始是可定制的，然后根据用户反馈进行改进，建立庞大的用户基础，一旦我们能够取得我们用户的信任，分析器的配置就逐步进入默认状态。例如，我们有一个分析器，它用于提高Java代码的可读性，但通常不会真正改变代码行为。Tricorder的用户最初担心这种分析过于“啰嗦”，但他们最终还是希望获得更多的分析结果。

成功定制的关键在于关注项目级定制，而不是用户级定制。项目级定制确保所有团队成员对其项目的分析结果有一致的看法，并防止一个开发人员试图解决问题而另一个开发人员引入问题的情况。

在Tricorder开发的早期，一组相对简单的样式检查器(“linters”)在Critical中显示结果，Critical提供用户设置来选择结果的置信度，以显示和抑制特定分析的结果。当我们从Critique中删除了所有这些用户可定制选项后，立即开始收到用户对恼人的分析结果的投诉。面对这个问题我们没有重新启用可定制的功能，而是询问用户为什么他们感到恼火，并发现了各种各样的错误和误报。例如，C++ linter也在Objective-C文件上运行，但是产生了不正确的、无用的结果。我们修复了linter的基础框架，避免了这种情况再发生。HTML linter具有极高的误报率，而且几乎没有有用的提示，因此通常被编写HTML的开发人员屏蔽掉。因为HTML linter很少给出有用的提示，所以我们禁用了这个linter。简而言之，用户定制导致了Bug难以被发现并减少了用户的反馈。

### 预提交
除了代码审查之外，谷歌还有其他用于静态分析的工作流集成点。因为开发人员可以选择忽略代码审查中显示的静态分析警告，谷歌还能够分析并阻止提交待定代码更改，我们称之为预提交检查。预提交检查包括对更改的内容或元数据的非常简单的可定制的内置检查，例如确保提交信息没有说“不要提交”，或者测试代码文件总是包含在相应的代码文件中。团队还可以指定一套测试，这些测试必须通过或验证代码没有Tricorder指定的某一类别问题。预提交还检查代码是否格式良好。预提交检查通常发生在开发人员将更改发送出去的时候，并在提交过程中再次运行，但检查也可以在这些点之间临时触发。关于预提交的更多细节请参见[第23章](../chapter23/continuous_integration_zh.md)。

一些团队已经编写了他们自己的定制预提交检查。这些是基础预提交检查之上的额外检查，可以提高比整个公司更高的最佳实践标准，并添加特定于项目的分析。这使得新项目比具有大量遗留代码的项目具有更严格的最佳实践指导方针。团队定制的预提交检查可能会使项目大规模变更(LSC)更加困难(见[第22章](../chapter22/large_scale_changes_zh.md))，因此有些变更会在变更描述中使用“CLEANUP=”跳过。

### 编译器集成
虽然用静态分析阻止提交很好，但是在工作流中更早地通知开发人员问题更好。 在可能的情况下，我们尝试将静态分析集成入编译器。构建失败是一个不可忽视的警告，但在许多情况下这种方式是不可行的。然而，有些分析是高度机械的，没有有效的假阳性。一个例子是Error Prone 的“ERROR”检查。这些检查都是在谷歌的Java编译器中启用的，防止错误实例再次被引入我们的代码库中。编译器检查需要足够快，这样才不会降低构建速度。此外，我们强制执行这三个标准(C++编译器也存在类似的标准):
- 可操作且易于修复(只要有可能，错误应该包括可以机械应用的建议修复)
- 不会产生有效的误报(分析永远不会停止构建正确的代码)
- 报告仅影响正确性而非代码风格或最佳实践的问题

为了启用新的检查，我们首先需要清理代码库中该问题的所有实例，这样我们就不会因为编译器升级而破坏现有项目的构建。这也意味着部署新的基于编译器的检查的效果必须足够好，以保证修复它的所有现有实例。谷歌通过集群在整个代码库并行运行各种编译器(如clang和javac)--作为一个MapReduce操作。当编译器以这种MapReduce方式运行时，运行的静态分析检查必须产生修复，以便自动清理。在一个待定的代码变更被准备和测试，并在整个代码库中应用修复之后，我们提交该变更并移除所有有问题的实例。然后，我们在编译器中打开检查，以便在不破坏构建的情况下，不会提交有问题的新实例。构建中断是在我们的连续集成系统提交之后，或者在预提交检查提交之前被捕获的(参见前面的讨论)。

我们的目标是编译器永远不发出警告。但是我们不断发现开发人员会忽略编译器警告。我们要么启用编译器检查作为错误(并中断构建)，要么不在编译器输出中显示它。因为在整个代码库中使用相同的编译器标志，所以这个配置是全局的。无法中断构建的检查要么被忽略，要么在代码检查中显示(例如，通过Tricorder)。虽然不是谷歌的每种语言都有这个配置，但最常用的语言有。Java和C++编译器都配置为避免显示编译器警告。Go编译器把这一点发挥到了极致；其他语言会认为是警告的一些东西(如未使用的变量或包导入)在Go编译器中是错误。
### 在编辑和浏览时进行代码分析
静态分析的另一个潜在集成点是集成开发环境(IDE)。然而，集成开发环境分析需要极短的分析时间(通常少于1秒，理想情况下少于100毫秒)，因此一些工具不适合在此集成。此外，还有一个问题是要确保相同的分析在多个IDE中以相同的方式运行。我们还注意到集成开发环境的受欢迎程度可能会有所上升或下降(我们并不强制使用单一的IDE)；因此，IDE集成往往比插入审查过程更混乱。代码审查对于显示分析结果也有特定的好处。分析可以考虑变更的整个背景；某些分析可能对部分代码不准确(例如在添加调用点之前实现函数时的死代码分析)。在代码评审中显示分析结果也意味着如果代码作者想要忽略分析结果，他们也必须说服评审员。也就是说，在集成开发环境进行适当的分析是有帮助的。

虽然我们主要关注于显示新引入的静态分析警告，或者编辑代码上的警告，但是对于某些分析，开发人员实际上确实希望能够在代码浏览期间查看整个代码库的分析结果。这方面的一个例子是一些安全分析。谷歌的特定安全团队希望看到问题所有实例的整体视图。开发人员还喜欢在清理代码时通过代码库查看分析结果。换句话说，有时在代码浏览时显示分析结果是正确的选择。

## 结论
静态分析是一个很好的工具，可以改进代码库，早期发现错误，并允许更宝贵的资源(如人工审查和测试)专注于不能机械验证的问题。通过提高静态分析基础软件的可扩展性和可用性，我们已经使静态分析成为谷歌软件开发的重要组成部分。

## TL;DRs
- 关注开发者。我们在工具中的analysis users和analysis writers之间建立反馈渠道方面投入了大量精力，并积极调整分析软程序以减少误报数量。
- 将静态分析作为核心开发人员工作流程的一部分。谷歌静态分析的主要集成点是通过代码审查，其中分析工具提供修复并涉及审查者。然而，我们也集成了其他分析工具(编译器检查、检查代码提交、在IDEs中以及浏览代码时静态分析)。
- 让用户贡献力量。通过利用领域专家的专业知识，我们可以扩展构建和维护分析工具和平台的工作。开发人员不断增加新的分析和检查工具，使他们的生活更容易，我们的代码库更好。

## References

1. <span id="f1">[^](#a1)</span> See http://errorprone.info/bugpatterns.
2. <span id="f2">[^](#a2)</span> Caitlin Sadowski et al. Tricorder: Building a Program Analysis Ecosystem, International Conference on Software Engineering (ICSE), May 2015.
3. <span id="f3">[^](#a3)</span> A good academic reference for static analysis theory is: Flemming Nielson et al. Principles of Program Analysis (Gernamy: Springer, 2004).
4. <span id="f4">[^](#a4)</span> Note that there are some specific analyses for which reviewers might be willing to tolerate a much higher false-positive rate: one example is security analyses that identify critical problems.
5. <span id="f5">[^](#a5)</span> See later in this chapter for more information on additional integration points when editing and browsing code.
6. <span id="f6">[^](#a6)</span> Louis Wasserman, “Scalable, Example-Based Refactorings with Refaster.” Workshop on Refactoring Tools, 2013.
7. <span id="f7">[^](#a7)</span> Caitlin Sadowski, Jeffrey van Gogh, Ciera Jaspan, Emma Söderberg, and Collin Winter, Tricorder: Building a Program Analysis Ecosystem, International Conference on Software Engineering (ICSE), May 2015.
8. <span id="f8">[^](#a8)</span> Caitlin Sadowski, Edward Aftandilian, Alex Eagle, Liam Miller-Cushon, and Ciera Jaspan, “Lessons from Building Static Analysis Tools at Google”, Communications of the ACM, 61 No. 4 (April 2018): 58–66, https://cacm.acm.org/magazines/2018/4/226371-lessons-from-building-static-analysis-tools-at-google/fulltext.