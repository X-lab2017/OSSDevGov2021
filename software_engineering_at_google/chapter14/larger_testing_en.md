In previous chapters, we have recounted how a testing culture was established at
Google and how small unit tests became a fundamental part of the developer work‐
flow. But what about other kinds of tests? It turns out that Google does indeed use
many larger tests, and these comprise a significant part of the risk mitigation strategy
necessary for healthy software engineering. But these tests present additional chal‐
lenges to ensure that they are valuable assets and not resource sinks. In this chapter,
we’ll discuss what we mean by “larger tests,” when we execute them, and best practi‐
ces for keeping them effective. 	
## What Are Larger Tests?

As mentioned previously, Google has specific notions of test size. Small tests are
restricted to one thread, one process, one machine. Larger tests do not have the same
restrictions. But Google also has notions of test scope. A unit test necessarily is of
smaller scope than an integration test. And the largest-scoped tests (sometimes called
end-to-end or system tests) typically involve several real dependencies and fewer test
doubles.
Larger tests are many things that small tests are not. They are not bound by the same
constraints; thus, they can exhibit the following characteristics:
• They may be slow. Our large tests have a default timeout of 15 minutes or 1 hour,
but we also have tests that run for multiple hours or even days.
• They may be nonhermetic. Large tests may share resources with other tests and
traffic.
• They may be nondeterministic. If a large test is nonhermetic, it is almost impos‐
sible to guarantee determinism: other tests or user state may interfere with it.

So why have larger tests? Reflect back on your coding process. How do you confirm
that the programs you write actually work? You might be writing and running unit
tests as you go, but do you find yourself running the actual binary and trying it out
yourself? And when you share this code with others, how do they test it? By running
your unit tests, or by trying it out themselves?

Also, how do you know that your code continues to work during upgrades? Suppose
that you have a site that uses the Google Maps API and there’s a new API version.
Your unit tests likely won’t help you to know whether there are any compatibility
issues. You’d probably run it and try it out to see whether anything broke.

Unit tests can give you confidence about individual functions, objects, and modules,
but large tests provide more confidence that the overall system works as intended.
And having actual automated tests scales in ways that manual testing does not.

### Fidelity
The primary reason larger tests exist is to address delity. Fidelity is the property by
which a test is reflective of the real behavior of the system under test (SUT).

One way of envisioning fidelity is in terms of the environment. As Figure 14-1 illus‐
trates, unit tests bundle a test and a small portion of code together as a runnable unit,
which ensures the code is tested but is very different from how production code runs.
Production itself is, naturally, the environment of highest fidelity in testing. There is
also a spectrum of interim options. A key for larger tests is to find the proper fit,
because increasing fidelity also comes with increasing costs and (in the case of pro‐
duction) increasing risk of failure.
![Figure 14-1. Scale of increasing delity](https://img-blog.csdnimg.cn/20210425151002831.png)
Figure 14-1. Scale of increasing fidelity

Tests can also be measured in terms of how faithful the test content is to reality. Many
handcrafted, large tests are dismissed by engineers if the test data itself looks unrealis‐
tic. Test data copied from production is much more faithful to reality (having been
captured that way), but a big challenge is how to create realistic test traffic before
launching the new code. This is particularly a problem in artificial intelligence (AI),
for which the “seed” data often suffers from intrinsic bias. And, because most data for
unit tests is handcrafted, it covers a narrow range of cases and tends to conform to the biases of the author. The uncovered scenarios missed by the data represent a fidel‐
ity gap in the tests.

## Common Gaps in Unit Tests
Larger tests might also be necessary where smaller tests fail. The subsections that fol‐
low present some particular areas where unit tests do not provide good risk mitiga‐
tion coverage.

### Unfaithful doubles
A single unit test typically covers one class or module. Test doubles (as discussed in
Chapter 13) are frequently used to eliminate heavyweight or hard-to-test dependen‐
cies. But when those dependencies are replaced, it becomes possible that the replace‐
ment and the doubled thing do not agree.

Almost all unit tests at Google are written by the same engineer who is writing the
unit under test. When those unit tests need doubles and when the doubles used are
mocks, it is the engineer writing the unit test defining the mock and its intended
behavior. But that engineer usually did not write the thing being mocked and can be
misinformed about its actual behavior. The relationship between the unit under test
and a given peer is a behavioral contract, and if the engineer is mistaken about the
actual behavior, the understanding of the contract is invalid.

Moreover, mocks become stale. If this mock-based unit test is not visible to the
author of the real implementation and the real implementation changes, there is no
signal that the test (and the code being tested) should be updated to keep up with the
changes.

Note that, as mentioned in Chapter 13, if teams provide fakes for their own services,
this concern is mostly alleviated.

### Configuration issues
Unit tests cover code within a given binary. But that binary is typically not completely
self-sufficient in terms of how it is executed. Usually a binary has some kind of
deployment configuration or starter script. Additionally, real end-user-serving pro‐
duction instances have their own configuration files or configuration databases.

If there are issues with these files or the compatibility between the state defined by these stores and the binary in question, these can lead to major user issues. Unit tests
alone cannot verify this compatibility.Incidentally, this is a good reason to ensure that your configuration is in version control as well as your code, because then,changes to configuration can be identified as the source of bugs as opposed to introducing random external flakiness and can be built in to large tests.

At Google, configuration changes are the number one reason for our major outages.
This is an area in which we have underperformed and has led to some of our most
embarrassing bugs. For example, there was a global Google outage back in 2013 due
to a bad network configuration push that was never tested. Configurations tend to be
written in configuration languages, not production code languages. They also often
have faster production rollout cycles than binaries, and they can be more difficult to
test. All of these lead to a higher likelihood of failure. But at least in this case (and
others), configuration was version controlled, and we could quickly identify the cul‐
prit and mitigate the issue.

### Issues that arise under load
At Google, unit tests are intended to be small and fast because they need to fit into
our standard test execution infrastructure and also be run many times as part of a
frictionless developer workflow. But performance, load, and stress testing often
require sending large volumes of traffic to a given binary. These volumes become dif‐
ficult to test in the model of a typical unit test. And our large volumes are big, often
thousands or millions of queries per second (in the case of ads, real-time bidding)!

### Unanticipated behaviors, inputs, and side effects
Unit tests are limited by the imagination of the engineer writing them. That is, they
can only test for anticipated behaviors and inputs. However, issues that users find
with a product are mostly unanticipated (otherwise it would be unlikely that they
would make it to end users as issues). This fact suggests that different test techniques
are needed to test for unanticipated behaviors.

Hyrum’s Law is an important consideration here: even if we could test 100% for con‐
formance to a strict, specified contract, the effective user contract applies to all visible
behaviors, not just a stated contract. It is unlikely that unit tests alone test for all visi‐
ble behaviors that are not specified in the public API.



### Emergent behaviors and the “vacuum effect”
Unit tests are limited to the scope that they cover (especially with the widespread use
of test doubles), so if behavior changes in areas outside of this scope, it cannot be
detected. And because unit tests are designed to be fast and reliable, they deliberately
eliminate the chaos of real dependencies, network, and data. A unit test is like a prob‐
lem in theoretical physics: ensconced in a vacuum, neatly hidden from the mess of
the real world, which is great for speed and reliability but misses certain defect 
categories.

## Why Not Have Larger Tests?
In earlier chapters, we discussed many of the properties of a developer-friendly test.
In particular, it needs to be as follows:

Reliable
It must not be flaky and it must provide a useful pass/fail signal.
Fast
It needs to be fast enough to not interrupt the developer workflow.
Scalable
Google needs to be able to run all such useful affected tests efficiently for presub‐
mits and for post-submits.

Good unit tests exhibit all of these properties. Larger tests often violate all of these
constraints. For example, larger tests are often flakier because they use more infra‐
structure than does a small unit test. They are also often much slower, both to set up
as well as to run. And they have trouble scaling because of the resource and time
requirements, but often also because they are not isolated—these tests can collide
with one another.

Additionally, larger tests present two other challenges. First, there is a challenge of
ownership. A unit test is clearly owned by the engineer (and team) who owns the
unit. A larger test spans multiple units and thus can span multiple owners. This
presents a long-term ownership challenge: who is responsible for maintaining the test
and who is responsible for diagnosing issues when the test breaks? Without clear
ownership, a test rots.

The second challenge for larger tests is one of standardization (or the lack thereof).
Unlike unit tests, larger tests suffer a lack of standardization in terms of the infra‐
structure and process by which they are written, run, and debugged. The approach to
larger tests is a product of a system’s architectural decisions, thus introducing var‐
iance in the type of tests required. For example, the way we build and run A-B diff
regression tests in Google Ads is completely different from the way such tests are
built and run in Search backends, which is different again from Drive. They use dif‐
ferent platforms, different languages, different infrastructures, different libraries, and
competing testing frameworks.

This lack of standardization has a significant impact. Because larger tests have so
many ways of being run, they often are skipped during large-scale changes. (See
Chapter 22.) The infrastructure does not have a standard way to run those tests, and
asking the people executing LSCs to know the local particulars for testing on every
team doesn’t scale. Because larger tests differ in implementation from team to team,
tests that actually test the integration between those teams require unifying incompat‐
ible infrastructures. And because of this lack of standardization, we cannot teach a single approach to Nooglers (new Googlers) or even more experienced engineers,
which both perpetuates the situation and also leads to a lack of understanding about
the motivations of such tests.

## Larger Tests at Google
When we discussed the history of testing at Google earlier (see Chapter 11), we men‐
tioned how Google Web Server (GWS) mandated automated tests in 2003 and how
this was a watershed moment. However, we actually had automated tests in use before
this point, but a common practice was using automated large and enormous tests. For
example, AdWords created an end-to-end test back in 2001 to validate product sce‐
narios. Similarly, in 2002, Search wrote a similar “regression test” for its indexing
code, and AdSense (which had not even publicly launched yet) created its variation
on the AdWords test.

Other “larger” testing patterns also existed circa 2002. The Google search frontend
relied heavily on manual QA—manual versions of end-to-end test scenarios. And
Gmail got its version of a “local demo” environment—a script to bring up an end-toend Gmail environment locally with some generated test users and mail data for local
manual testing.

When C/J Build (our first continuous build framework) launched, it did not distin‐
guish between unit tests and other tests, but there were two critical developments that
led to a split. First, Google focused on unit tests because we wanted to encourage the
testing pyramid and to ensure the vast majority of written tests were unit tests. Sec‐
ond, when TAP replaced C/J Build as our formal continuous build system, it was only
able to do so for tests that met TAP’s eligibility requirements: hermetic tests buildable
at a single change that could run on our build/test cluster within a maximum time
limit. Although most unit tests satisfied this requirement, larger tests mostly did not.
However, this did not stop the need for other kinds of tests, and they have continued
to fill the coverage gaps. C/J Build even stuck around for years specifically to handle
these kinds of tests until newer systems replaced it.



### Larger Tests and Time
Throughout this book, we have looked at the influence of time on software engineer‐
ing, because Google has built software running for more than 20 years. How are
larger tests influenced by the time dimension? We know that certain activities make
more sense the longer the expected lifespan of code, and testing of various forms is an
activity that makes sense at all levels, but the test types that are appropriate change
over the expected lifetime of code.

As we pointed out before, unit tests begin to make sense for software with an
expected lifespan from hours on up. At the minutes level (for small scripts), manual testing is most common, and the SUT usually runs locally, but the local demo likely is
production, especially for one-off scripts, demos, or experiments. At longer lifespans,
manual testing continues to exist, but the SUTs usually diverge because the produc‐
tion instance is often cloud hosted instead of locally hosted.

The remaining larger tests all provide value for longer-lived software, but the main
concern becomes the maintainability of such tests as time increases.

Incidentally, this time impact might be one reason for the development of the “ice
cream cone” testing antipattern, as mentioned in the Chapter 11 and shown again in
Figure 14-2.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425153107511.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjgyMzAxOQ==,size_16,color_FFFFFF,t_70)
Figure 14-2. The ice cream cone testing antipattern

When development starts with manual testing (when engineers think that code is
meant to last only for minutes), those manual tests accumulate and dominate the ini‐
tial overall testing portfolio. For example, it’s pretty typical to hack on a script or an
app and test it out by running it, and then to continue to add features to it but con‐
tinue to test it out by running it manually. This prototype eventually becomes func‐
tional and is shared with others, but no automated tests actually exist for it.

Even worse, if the code is difficult to unit test (because of the way it was implemented
in the first place), the only automated tests that can be written are end-to-end ones,
and we have inadvertently created “legacy code” within days.

It is critical for longer-term health to move toward the test pyramid within the first
few days of development by building out unit tests, and then to top it off after that
point by introducing automated integration tests and moving away from manual end-to-end tests. We succeeded by making unit tests a requirement for submission, but covering the gap between unit tests and manual tests is necessary for long-term
health.

### Larger Tests at Google Scale
It would seem that larger tests should be more necessary and more appropriate at
larger scales of software, but even though this is so, the complexity of authoring, run‐
ning, maintaining, and debugging these tests increases with the growth in scale, even
more so than with unit tests.

In a system composed of microservices or separate servers, the pattern of intercon‐
nections looks like a graph: let the number of nodes in that graph be our N. Every
time a new node is added to this graph, there is a multiplicative effect on the number
of distinct execution paths through it.

Figure 14-3 depicts an imagined SUT: this system consists of a social network with
users, a social graph, a stream of posts, and some ads mixed in. The ads are created by advertisers and served in the context of the social stream. This SUT alone consists of two groups of users, two UIs, three databases, an indexing pipeline, and six servers.
There are 14 edges enumerated in the graph. Testing all of the end-to-end possibilities
is already difficult. Imagine if we add more services, pipelines, and databases to this
mix: photos and images, machine learning photo analysis, and so on?
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425153254943.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjgyMzAxOQ==,size_16,color_FFFFFF,t_70)
Figure 14-3. Example of a fairly small SUT: a social network with advertising

The rate of distinct scenarios to test in an end-to-end way can grow exponentially or
combinatorially depending on the structure of the system under test, and that growth
does not scale. Therefore, as the system grows, we must find alternative larger testing
strategies to keep things manageable.

However, the value of such tests also increases because of the decisions that were necessary to achieve this scale. This is an impact of fidelity: as we move toward larger-N-layers of software, if the service doubles are lower fidelity (1-epsilon), the chance of bugs when putting it all together is exponential in N. Looking at this example SUT again, if we replace the user server and ad server with doubles and those doubles are
low fidelity (e.g., 10% accurate), the likelihood of a bug is 99% (1 – (0.1 ∗ 0.1)). And
that’s just with two low-fidelity doubles.

Therefore, it becomes critical to implement larger tests in ways that work well at this
scale but maintain reasonably high fidelity.

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425153351733.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjgyMzAxOQ==,size_16,color_FFFFFF,t_70)
## Structure of a Large Test
Although large tests are not bound by small test constraints and could conceivably
consist of anything, most large tests exhibit common patterns. Large tests usually
consist of a workflow with the following phases:
• Obtain a system under test
• Seed necessary test data
• Perform actions using the system under test
• Verify behaviors