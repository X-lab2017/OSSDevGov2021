**Resource constraints**
Although engineers can run tests locally, most test executions happen in a distributed
build-and-test system called Forge. Forge allows engineers to run their builds and
tests in our datacenters, which maximizes parallelism. At our scale, the resources
required to run all tests executed on-demand by engineers and all tests being run as
part of the CB process are enormous. Even given the amount of compute resources
we have, systems like Forge and TAP are resource constrained. To work around these
constraints, engineers working on TAP have come up with some clever ways to determine
which tests should be run at which times to ensure that the minimal amount of
resources are spent to validate a given change.
The primary mechanism for determining which tests need to be run is an analysis of
the downstream dependency graph for every change. Google’s distributed build tools,
Forge and Blaze, maintain a near-real-time version of the global dependency graph
and make it available to TAP. As a result, TAP can quickly determine which tests are
downstream from any change and run the minimal set to be sure the change is safe.
Another factor influencing the use of TAP is the speed of tests being run. TAP is often
able to run changes with fewer tests sooner than those with more tests. This bias
encourages engineers to write small, focused changes. The difference in waiting time
between a change that triggers 100 tests and one that triggers 1,000 can be tens of
minutes on a busy day. Engineers who want to spend less time waiting end up making
smaller, targeted changes, which is a win for everyone.
**CI Case Study: Google Takeout**
Google Takeout started out as a data backup and download product in 2011. Its
founders pioneered the idea of “data liberation”—that users should be able to easily
take their data with them, in a usable format, wherever they go. They began by integrating
Takeout with a handful of Google products themselves, producing archives of
users’ photos, contact lists, and so on for download at their request. However, Takeout
didn’t stay small for long, growing as both a platform and a service for a wide
variety of Google products. As we’ll see, effective CI is central to keeping any large
project healthy, but is especially critical when applications rapidly grow.
**Scenario #1: Continuously broken dev deploys**
Problem: As Takeout gained a reputation as a powerful Google-wide data fetching,
archiving, and download tool, other teams at the company began to turn to it,
requesting APIs so that their own applications could provide backup and download
functionality, too, including Google Drive (folder downloads are served by Takeout)
and Gmail (for ZIP file previews). All in all, Takeout grew from being the backend for
just the original Google Takeout product, to providing APIs for at least 10 other Google
products, offering a wide range of functionality.
496 | Chapter 23: Continuous Integration



The team decided to deploy each of the new APIs as a customized instance, using the
same original Takeout binaries but configuring them to work a little differently. For
example, the environment for Drive bulk downloads has the largest fleet, the most
quota reserved for fetching files from the Drive API, and some custom authentication
logic to allow non-signed-in users to download public folders.
Before long, Takeout faced “flag issues.” Flags added for one of the instances would
break the others, and their deployments would break when servers could not start up
due to configuration incompatibilities. Beyond feature configuration, there was security
and ACL configuration, too. For example, the consumer Drive download service
should not have access to keys that encrypt enterprise Gmail exports. Configuration
quickly became complicated and led to nearly nightly breakages.
Some efforts were made to detangle and modularize configuration, but the bigger
problem this exposed was that when a Takeout engineer wanted to make a code
change, it was not practical to manually test that each server started up under each
configuration. They didn’t find out about configuration failures until the next day’s
deploy. There were unit tests that ran on presubmit and post-submit (by TAP), but
those weren’t sufficient to catch these kinds of issues.
**What the team did.** The team created temporary, sandboxed mini-environments for
each of these instances that ran on presubmit and tested that all servers were healthy
on startup. Running the temporary environments on presubmit prevented 95% of
broken servers from bad configuration and reduced nightly deployment failures by
50%.
Although these new sandboxed presubmit tests dramatically reduced deployment
failures, they didn’t remove them entirely. In particular, Takeout’s end-to-end tests
would still frequently break the deploy, and these tests were difficult to run on presubmit
(because they use test accounts, which still behave like real accounts in some
respects and are subject to the same security and privacy safeguards). Redesigning
them to be presubmit friendly would have been too big an undertaking.
If the team couldn’t run end-to-end tests in presubmit, when could it run them? It
wanted to get end-to-end test results more quickly than the next day’s dev deploy and
decided every two hours was a good starting point. But the team didn’t want to do a
full dev deploy this often—this would incur overhead and disrupt long-running processes
that engineers were testing in dev. Making a new shared test environment for
these tests also seemed like too much overhead to provision resources for, plus culprit
finding (i.e., finding the deployment that led to a failure) could involve some undesirable
manual work.
So, the team reused the sandboxed environments from presubmit, easily extending
them to a new post-submit environment. Unlike presubmit, post-submit was compliant
with security safeguards to use the test accounts (for one, because the code has
CI at Google | 497



been approved), so the end-to-end tests could be run there. The post-submit CI runs
every two hours, grabbing the latest code and configuration from green head, creates
an RC, and runs the same end-to-end test suite against it that is already run in dev.
**Lesson learned.** Faster feedback loops prevent problems in dev deploys:
• Moving tests for different Takeout products from “after nightly deploy” to presubmit
prevented 95% of broken servers from bad configuration and reduced
nightly deployment failures by 50%.
• Though end-to-end tests couldn’t be moved all the way to presubmit, they were
still moved from “after nightly deploy” to “post-submit within two hours.” This
effectively cut the “culprit set” by 12 times.
**Scenario #2: Indecipherable test logs**
**Problem:** As Takeout incorporated more Google products, it grew into a mature platform
that allowed product teams to insert plug-ins, with product-specific datafetching
code, directly into Takeout’s binary. For example, the Google Photos plug-in
knows how to fetch photos, album metadata, and the like. Takeout expanded from its
original “handful” of products to now integrate with more than 90.
Takeout’s end-to-end tests dumped its failures to a log, and this approach didn’t scale
to 90 product plug-ins. As more products integrated, more failures were introduced.
Even though the team was running the tests earlier and more often with the addition
of the post-submit CI, multiple failures would still pile up inside and were easy to
miss. Going through these logs became a frustrating time sink, and the tests were
almost always failing.
**What the team did.** The team refactored the tests into a dynamic, configuration-based
suite (using a parameterized test runner) that reported results in a friendlier UI,
clearly showing individual test results as green or red: no more digging through logs.
They also made failures much easier to debug, most notably, by displaying failure
information, with links to logs, directly in the error message. For example, if Takeout
failed to fetch a file from Gmail, the test would dynamically construct a link that
searched for that file’s ID in the Takeout logs and include it in the test failure message.
This automated much of the debugging process for product plug-in engineers and
required less of the Takeout team’s assistance in sending them logs, as demonstrated
in Figure 23-3.
498 | Chapter 23: Continuous Integration



**Lesson learned.** Accessible, actionable feedback from CI reduces test failures and
improves productivity. These initiatives reduced the Takeout team’s involvement in
debugging client (product plug-in) test failures by 35%.
**Scenario #3: Debugging “all of Google”**
**Problem:** An interesting side effect of the Takeout CI that the team did not anticipate
was that, because it verified the output of 90-some odd end-user–facing products, in
the form of an archive, they were basically testing “all of Google” and catching issues
that had nothing to do with Takeout. This was a good thing—Takeout was able to
help contribute to the quality of Google’s products overall. However, this introduced a
problem for their CI processes: they needed better failure isolation so that they could
determine which problems were in their build (which were the minority) and which
lay in loosely coupled microservices behind the product APIs they called.
**What the team did.** The team’s solution was to run the exact same test suite continuously
against production as it already did in its post-submit CI. This was cheap to
implement and allowed the team to isolate which failures were new in its build and
which were in production; for instance, the result of a microservice release somewhere
else “in Google.”
**Lesson learned.** Running the same test suite against prod and a post-submit CI (with
newly built binaries, but the same live backends) is a cheap way to isolate failures.
CI at Google | 499



**Remaining challenge.** Going forward, the burden of testing “all of Google” (obviously,
this is an exaggeration, as most product problems are caught by their respective
teams) grows as Takeout integrates with more products and as those products
become more complex. Manual comparisons between this CI and prod are an expensive
use of the Build Cop’s time.
**Future improvement.** This presents an interesting opportunity to try hermetic testing
with record/replay in Takeout’s post-submit CI. In theory, this would eliminate failures
from backend product APIs surfacing in Takeout’s CI, which would make the
suite more stable and effective at catching failures in the last two hours of Takeout
changes—which is its intended purpose.
**Scenario #4: Keeping it green**
**Problem:** As the platform supported more product plug-ins, which each included
end-to-end tests, these tests would fail and the end-to-end test suites were nearly
always broken. The failures could not all be immediately fixed. Many were due to
bugs in product plug-in binaries, which the Takeout team had no control over. And
some failures mattered more than others—low-priority bugs and bugs in the test
code did not need to block a release, whereas higher-priority bugs did. The team
could easily disable tests by commenting them out, but that would make the failures
too easy to forget about.
One common source of failures: tests would break when product plug-ins were rolling
out a feature. For example, a playlist-fetching feature for the YouTube plug-in
might be enabled for testing in dev for a few months before being enabled in prod.
The Takeout tests only knew about one result to check, so that often resulted in the
test needing to be disabled in particular environments and manually curated as the
feature rolled out.
**What the team did.** The team came up with a strategic way to disable failing tests by
tagging them with an associated bug and filing that off to the responsible team (usually
a product plug-in team). When a failing test was tagged with a bug, the team’s
testing framework would suppress its failure. This allowed the test suite to stay green
and still provide confidence that everything else, besides the known issues, was passing,
as illustrated in Figure 23-4.
500 | Chapter 23: Continuous Integration



For the rollout problem, the team added capability for plug-in engineers to specify
the name of a feature flag, or ID of a code change, that enabled a particular feature
along with the output to expect both with and without the feature. The tests were
equipped to query the test environment to determine whether the given feature was
enabled there and verified the expected output accordingly.
When bug tags from disabled tests began to accumulate and were not updated, the
team automated their cleanup. The tests would now check whether a bug was closed
by querying our bug system’s API. If a tagged-failing test actually passed and was
passing for longer than a configured time limit, the test would prompt to clean up the
tag (and mark the bug fixed, if it wasn’t already). There was one exception for this
strategy: flaky tests. For these, the team would allow a test to be tagged as flaky, and
the system wouldn’t prompt a tagged “flaky” failure for cleanup if it passed.
These changes made a mostly self-maintaining test suite, as illustrated in Figure 23-5.
CI at Google | 501



**Lessons learned.** Disabling failing tests that can’t be immediately fixed is a practical
approach to keeping your suite green, which gives confidence that you’re aware of all
test failures. Also, automating the test suite’s maintenance, including rollout management
and updating tracking bugs for fixed tests, keeps the suite clean and prevents
technical debt. In DevOps parlance, we could call the metric in Figure 23-5 MTTCU:
mean time to clean up.
**Future improvement.** Automating the filing and tagging of bugs would be a helpful
next step. This is still a manual and burdensome process. As mentioned earlier, some
of our larger teams already do this.
**Further challenges.** The scenarios we’ve described are far from the only CI challenges
faced by Takeout, and there are still more problems to solve. For example, we mentioned
the difficulty of isolating failures from upstream services in “CI Challenges” on
page 490. This is a problem that Takeout still faces with rare breakages originating
with upstream services, such as when a security update in the streaming infrastructure
used by Takeout’s “Drive folder downloads” API broke archive decryption when
it deployed to production. The upstream services are staged and tested themselves,
but there is no simple way to automatically check with CI if they are compatible with
Takeout after they’re launched into production. An initial solution involved creating
an “upstream staging” CI environment to test production Takeout binaries against
the staged versions of their upstream dependencies. However, this proved difficult to
maintain, with additional compatibility issues between staging and production
versions.
502 | Chapter 23: Continuous Integration



**But I Can’t Afford CI**
You might be thinking that’s all well and good, but you have neither the time nor
money to build any of this. We certainly acknowledge that Google might have more
resources to implement CI than the typical startup does. Yet many of our products
have grown so quickly that they didn’t have time to develop a CI system either (at
least not an adequate one).
In your own products and organizations, try and think of the cost you are already
paying for problems discovered and dealt with in production. These negatively affect
the end user or client, of course, but they also affect the team. Frequent production
fire-fighting is stressful and demoralizing. Although building out CI systems is
expensive, it’s not necessarily a new cost as much as a cost shifted left to an earlier—
and more preferable—stage, reducing the incidence, and thus the cost, of problems
occurring too far to the right. CI leads to a more stable product and happier developer
culture in which engineers feel more confident that “the system” will catch problems,
and they can focus more on features and less on fixing.
**Conclusion**
Even though we’ve described our CI processes and some of how we’ve automated
them, none of this is to say that we have developed perfect CI systems. After all, a CI
system itself is just software and is never complete and should be adjusted to meet the
evolving demands of the application and engineers it is meant to serve. We’ve tried to
illustrate this with the evolution of Takeout’s CI and the future areas of improvement
we point out.
**TL;DRs**
• A CI system decides what tests to use, and when.
• CI systems become progressively more necessary as your codebase ages and
grows in scale.
• CI should optimize quicker, more reliable tests on presubmit and slower, less
deterministic tests on post-submit.
• Accessible, actionable feedback allows a CI system to become more efficient.
Conclusion | 503