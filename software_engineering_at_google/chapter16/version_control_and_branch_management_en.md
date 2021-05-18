**Scenario: no clear source of truth**

Imagine that your team adheres to the DVCS philosophy enough to avoid defining a
specific branch+repository as the ultimate source of truth.

In some respects, this is reminiscent of the Presentation v5 - final - redlines - Josh’s ver‐
sion v2 model—after you pull from a teammate’s repository, it isn’t necessarily clear
which changes are present and which are not. In some respects, it’s better than that
because the DVCS model tracks the merging of individual patches at a much finer
granularity than those ad hoc naming schemes, but there’s a difference between the
DVCS knowing which changes are incorporated and every engineer being sure they
have all the past/relevant changes represented.

Consider what it takes to ensure that a release build includes all of the features that
have been developed by each developer for the past few weeks. What (noncentralized,
scalable) mechanisms are there to do that? Can we design policies that are fundamen‐
tally better than having everyone sign off? Are there any that require only sublinear
human effort as the team scales up? Is that going to continue working as the number
of developers on the team scales up? As far as we can see: probably not. Without a
central Source of Truth, someone is going to keep a list of which features are poten‐
tially ready to be included in the next release. Eventually that bookkeeping is repro‐
ducing the model of having a centralized Source of Truth.

Further imagine: when a new developer joins the team, where do they get a fresh,
known-good copy of the code?

DVCS enables a lot of great workflows and interesting usage models. But if you’re
concerned with finding a system that requires sublinear human effort to manage as
the team grows, it’s pretty important to have one repository (and one branch) actually
defined to be the ultimate source of truth.

There is some relativity in that Source of Truth. That is, for a given project, that
Source of Truth might be different for a different organization. This caveat is impor‐
tant: it’s reasonable for engineers at Google or RedHat to have different Sources of
Truth for Linux Kernel patches, still different than Linus (the Linux Kernel main‐
tainer) himself would. DVCS works fine when organizations and their Sources of
Truth are hierarchical (and invisible to those outside the organization)—that is per‐
haps the most practically useful effect of the DVCS model. A RedHat engineer can
commit to the local Source of Truth repository, and changes can be pushed from
there upstream periodically, while Linus has a completely different notion of what is
the Source of Truth. So long as there is no choice or uncertainty as to where a change
should be pushed, we can avoid a large class of chaotic scaling problems in the DVCS
model.

In all of this thinking, we’re assigning special significance to the trunk branch. But of
course, “trunk” in your VCS is only the technology default, and an organization can

choose different policies on top of that. Perhaps the default branch has been aban‐
doned and all work actually happens on some custom development branch—other
than needing to provide a branch name in more operations, there’s nothing inher‐
ently broken in that approach; it’s just nonstandard. There’s an (oft-unspoken) truth
when discussing version control: the technology is only one part of it for any given
organization; there is almost always an equal amount of policy and usage convention
on top of that.

No topic in version control has more policy and convention than the discussion of
how to use and manage branches. We look at branch management in more detail in
the next section.

##### Version Control Versus Dependency Management

There’s a lot of conceptual similarity between discussions of version control policies
and dependency management (see Chapter 21). The differences are primarily in two
forms: VCS policies are largely about how you manage your own code, and are usu‐
ally much finer grained. Dependency management is more challenging because we
primarily focus on projects managed and controlled by other organizations, at a
higher granularity, and these situations mean that you don’t have perfect control.
We’ll discuss a lot more of these high-level issues later in the book.

#### Branch Management

Being able to track different revisions in version control opens up a variety of differ‐
ent approaches for how to manage those different versions. Collectively, these differ‐
ent approaches fall under the term branch management, in contrast to a single
“trunk.”

##### Work in Progress Is Akin to a Branch

Any discussion that an organization has about branch management policies ought to
at least acknowledge that every piece of work-in-progress in the organization is
equivalent to a branch. This is more explicitly the case with a DVCS in which devel‐
opers are more likely to make numerous local staging commits before pushing back
to the upstream Source of Truth. This is still true of centralized VCSs: uncommitted
local changes aren’t conceptually different than committed changes on a branch,
other than potentially being more difficult to find and diff against. Some centralized
systems even make this explicit. For example, when using Perforce, every change is
given two revision numbers: one indicating the implicit branch point where the
change was created, and one indicating where it was recommitted, as illustrated in
Figure 16-1. Perforce users can query to see who has outstanding changes to a given
file, inspect the pending changes in other users’ uncommitted changes, and more.

![16-1](images\16-1.png)

Figure 16-1. Two revision numbers in Perforce

This “uncommitted work is akin to a branch” idea is particularly relevant when think‐
ing about refactoring tasks. Imagine a developer being told, “Go rename Widget to
OldWidget.” Depending on an organization’s branch management policies and
understanding, what counts as a branch, and which branches matter, this could have
several interpretations:

- Rename Widget on the trunk branch in the Source of Truth repository
- Rename Widget on all branches in the Source of Truth repository
- Rename Widget on all branches in the Source of Truth repository, and find all
  devs with outstanding changes to files that reference Widget

If we were to speculate, attempting to support that “rename this everywhere, even in
outstanding changes” use case is part of why commercial centralized VCSs tend to
track things like “which engineers have this file open for editing?” (We don’t think
this is a scalable way to perform a refactoring task, but we understand the point of
view.)

##### Dev Branches

In the age before consistent unit testing (see Chapter 11), when the introduction of
any given change had a high risk of regressing functionality elsewhere in the system,
it made sense to treat trunk specially. “We don’t commit to trunk,” your Tech Lead
might say, “until new changes have gone through a full round of testing. Our team
uses feature-specific development branches instead.”

A development branch (usually “dev branch”) is a halfway point between “this is done
but not committed” and “this is what new work is based on.” The problem that these
are attempting to solve (instability of the product) is a legitimate one—but one that


we have found to be solved far better with more extensive use of tests, Continuous
Integration (CI) (see Chapter 23), and quality enforcement practices like thorough
code review.

We believe that a version control policy that makes extensive use of dev branches as a
means toward product stability is inherently misguided. The same set of commits are
going to be merged to trunk eventually. Small merges are easier than big ones. Merges
done by the engineer who authored those changes are easier than batching unrelated
changes and merging later (which will happen eventually if a team is sharing a dev
branch). If presubmit testing on the merge reveals any new problems, the same argu‐
ment applies: it’s easier to determine whose changes are responsible for a regression if
there is only one engineer involved. Merging a large dev branch implies that more
changes are happening in that test run, making failures more difficult to isolate. Tri‐
aging and root-causing the problem is difficult; fixing it is even worse.

Beyond the lack of expertise and inherent problems in merging a single branch, there
are significant scaling risks when relying on dev branches. This is a very common
productivity drain for a software organization. When there are multiple branches
being developed in isolation for long periods, coordinating merge operations
becomes significantly more expensive (and possibly riskier) than they would be with
trunk-based development.

**How did we become addicted to dev branches?**

It’s easy to see how organizations fall into this trap: they see, “Merging this long-lived
development branch reduced stability” and conclude, “Branch merges are risky.”
Rather than solve that with “Better testing” and “Don’t use branch-based develop‐
ment strategies,” they focus on slowing down and coordinating the symptom: the
branch merges. Teams begin developing new branches based on other in-flight
branches. Teams working on a long-lived dev branch might or might not regularly
have that branch synched with the main development branch. As the organization
scales up, the number of development branches grows as well, and the more effort is
placed on coordinating that branch merge strategy. Increasing effort is thrown at
coordination of branch merges—a task that inherently doesn’t scale. Some unlucky
engineer becomes the Build Master/Merge Coordinator/Content Management Engi‐
neer, focused on acting as the single point coordinator to merge all the disparate
branches in the organization. Regularly scheduled meetings attempt to ensure that
the organization has “worked out the merge strategy for the week.”^8 The teams that
aren’t chosen to merge often need to re-sync and retest after each of these large
merges.

```
8 Recent informal Twitter polling suggests about 25% of software engineers have been subjected to “regularly
scheduled” merge strategy meetings.
```

All of that effort in merging and retesting is pure overhead. The alternative requires a
different paradigm: trunk-based development, rely heavily on testing and CI, keep the
build green, and disable incomplete/untested features at runtime. Everyone is respon‐
sible to sync to trunk and commit; no “merge strategy” meetings, no large/expensive
merges. And, no heated discussions about which version of a library should be used
—there can be only one. There must be a single Source of Truth. In the end, there will
be a single revision used for a release: narrowing down to a single source of truth is
just the “shift left” approach for identifying what is and is not being included.

##### Release Branches

If the period between releases (or the release lifetime) for a product is longer than a
few hours, it may be sensible to create a release branch that represents the exact code
that went into the release build for your product. If any critical flaws are discovered
between the actual release of that product into the wild and the next release cycle,
fixes can be cherry-picked (a minimal, targeted merge) from trunk to your release
branch.

By comparison to dev branches, release branches are generally benign: it isn’t the
technology of branches that is troublesome, it’s the usage. The primary difference
between a dev branch and a release branch is the expected end state: a dev branch is
expected to merge back to trunk, and could even be further branched by another
team. A release branch is expected to be abandoned eventually.

In the highest-functioning technical organizations that Google’s DevOps Research
and Assessment (DORA) organization has identified, release branches are practically
nonexistent. Organizations that have achieved Continuous Deployment (CD)—the
ability to release from trunk many times a day—likely tend to skip release branches:
it’s much easier to simply add the fix and redeploy. Thus, cherry-picks and branches
seem like unnecessary overhead. Obviously, this is more applicable to organizations
that deploy digitally (such as web services and apps) than those that push any form of
tangible release to customers; it is generally valuable to know exactly what has been
pushed to customers.

That same DORA research also suggests a strong positive correlation between “trunk-
based development,” “no long-lived dev branches,” and good technical outcomes. The
underlying idea in both of those ideas seems clear: branches are a drag on productiv‐
ity. In many cases we think complex branch and merge strategies are a perceived
safety crutch—an attempt to keep trunk stable. As we see throughout this book, there
are other ways to achieve that outcome.



#### Version Control at Google

At Google, the vast majority of our source is managed in a single repository (mono‐
repo) shared among roughly 50,000 engineers. Almost all projects that are owned by
Google live there, except large open source projects like Chromium and Android.
This includes public-facing products like Search, Gmail, our advertising products,
our Google Cloud Platform offerings, as well as the internal infrastructure necessary
to support and develop all of those products.

We rely on an in-house-developed centralized VCS called Piper, built to run as a dis‐
tributed microservice in our production environment. This has allowed us to use
Google-standard storage, communication, and Compute as a Service technology to
provide a globally available VCS storing more than 80 TB of content and metadata.
The Piper monorepo is then simultaneously edited and committed to by many thou‐
sands of engineers every day. Between humans and semiautomated processes that
make use of version control (or improve things checked into VCS), we’ll regularly
handle 60,000 to 70,000 commits to the repository per work day. Binary artifacts are
fairly common because the full repository isn’t transmitted and thus the normal costs
of binary artifacts don’t really apply. Because of the focus on Google-scale from the
earliest conception, operations in this VCS ecosystem are still cheap at human scale: it
takes perhaps 15 seconds total to create a new client at trunk, add a file, and commit
an (unreviewed) change to Piper. This low-latency interaction and well-understood/
well-designed scaling simplifies a lot of the developer experience.

By virtue of Piper being an in-house product, we have the ability to customize it and
enforce whatever source control policies we choose. For instance, we have a notion of
granular ownership in the monorepo: at every level of the file hierarchy, we can find
OWNERS files that list the usernames of engineers that are allowed to approve com‐
mits within that subtree of the repository (in addition to the OWNERS that are listed
at higher levels in the tree). In an environment with many repositories, this might
have been achieved by having separate repositories with filesystem permissions
enforcement controlling commit access or via a Git “commit hook” (action triggered
at commit time) to do a separate permissions check. By controlling the VCS, we can
make the concept of ownership and approval more explicit and enforced by the VCS
during an attempted commit operation. The model is also flexible: ownership is just a
text file, not tied to a physical separation of repositories, so it is trivial to update as the
result of a team transfer or organization restructuring.

##### One Version

The incredible scaling powers of Piper alone wouldn’t allow the sort of collaboration
that we rely upon. As we said earlier: version control is also about policy. In addition
to our VCS, one key feature of Google’s version control policy is what we’ve come to
refer to as “One Version.” This extends the “Single Source of Truth” concept we

looked at earlier—ensuring that a developer knows which branch and repository is
their source of truth—to something like “For every dependency in our repository,
there must be only one version of that dependency to choose.”<sup>9</sup> For third-party pack‐
ages, this means that there can be only a single version of that package checked into
our repository, in the steady state.<sup>10</sup> For internal packages, this means no forking
without repackaging/renaming: it must be technologically safe to mix both the origi‐
nal and the fork into the same project with no special effort. This is a powerful feature
for our ecosystem: there are very few packages with restrictions like “If you include
this package (A), you cannot include other package (B).”

This notion of having a single copy on a single branch in a single repository as our
Source of Truth is intuitive but also has some subtle depth in application. Let’s investi‐
gate a scenario in which we have a monorepo (and thus arguably have fulfilled the
letter of the law on Single Source of Truth), but have allowed forks of our libraries to
propagate on trunk.

```
9 For example, during an upgrade operation, there might be two versions checked in, but if a developer is
adding a new dependency on an existing package, there should be no choice in which version to depend upon.
10 That said, we fail at this in many cases because external packages sometimes have pinned copies of their own
dependencies bundled in their source release. You can read more on how all of this goes wrong in Chapter 21.
```



##### Scenario: Multiple Available Versions

Imagine the following scenario: some team discovers a bug in common infrastructure
code (in our case, Abseil or Guava or the like). Rather than fix it in place, the team
decides to fork that infrastructure and tweak it to work around the bug—without
renaming the library or the symbols. It informs other teams near them, “Hey, we have
an improved version of Abseil checked in over here: check it out.” A few other teams
build libraries that themselves rely on this new fork.

As we’ll see in Chapter 21, we’re now in a dangerous situation. If any project in the
codebase comes to depend on both the original and the forked versions of Abseil
simultaneously, in the best case, the build fails. In the worst case, we’ll be subjected to
difficult-to-understand runtime bugs stemming from linking in two mismatched ver‐
sions of the same library. The “fork” has effectively added a coloring/partitioning
property to the codebase: the transitive dependency set for any given target must
include exactly one copy of this library. Any link added from the “original flavor” par‐
tition of the codebase to the “new fork” partition will likely break things. This means
that in the end that something as simple as “adding a new dependency” becomes an
operation that might require running all tests for the entire codebase, to ensure that
we haven’t violated one of these partitioning requirements. That’s expensive, unfortu‐
nate, and doesn’t scale well.

In some cases, we might be able to hack things together in a way to allow a resulting
executable to function correctly. Java, for instance, has a relatively standard practice
called shading, which tweaks the names of the internal dependencies of a library to
hide those dependencies from the rest of the application. When dealing with func‐
tions, this is technically sound, even if it is theoretically a bit of a hack. When dealing
with types that can be passed from one package to another, shading solutions work
neither in theory nor in practice. As far as we know, any technological trickery that
allows multiple isolated versions of a library to function in the same binary share this
limitation: that approach will work for functions, but there is no good (efficient) solu‐
tion to shading types—multiple versions for any library that provides a vocabulary
type (or any higher-level construct) will fail. Shading and related approaches are
patching over the underlying issue: multiple versions of the same dependency are
needed. (We’ll discuss how to minimize that in general in Chapter 21.)
Any policy system that allows for multiple versions in the same codebase is allowing
for the possibility of these costly incompatibilities. It’s possible that you’ll get away
with it for a while (we certainly have a number of small violations of this policy), but
in general, any multiple-version situation has a very real possibility of leading to big
problems.

##### The “One-Version” Rule

With that example in mind, on top of the Single Source of Truth model, we can hope‐
fully understand the depth of this seemingly simple rule for source control and
branch management:
Developers must never have a choice of “What version of this component should I
depend upon?”
Colloquially, this becomes something like a “One-Version Rule.” In practice, “One-
Version” is not hard and fast,<sup>11</sup> but phrasing this around limiting the versions that can
be chosen when adding a new dependency conveys a very powerful understanding.
For an individual developer, lack of choice can seem like an arbitrary impediment.
Yet we see again and again that for an organization, it’s a critical component in effi‐
cient scaling. Consistency has a profound importance at all levels in an organization.
From one perspective, this is a direct side effect of discussions about consistency and
ensuring the ability to leverage consistent “choke points.”

```
11 For instance, if there are external/third-party libraries that are periodically updated, it might be infeasible to
update that library and update all use of it in a single atomic change. As such, it is often necessary to add a
new version of that library, prevent new users from adding dependencies on the old one, and incrementally
switch usage from old to new.
```

