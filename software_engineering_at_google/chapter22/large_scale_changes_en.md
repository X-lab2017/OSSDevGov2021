### Testing

Every change should be tested (a process we’ll talk about more in just a moment), but the larger the change, the more difficult it is to actually test it appropriately. Google’s CI system will run not only the tests immediately impacted by a change, but also any tests that transitively depend on the changed files.[6]This means a change gets broad coverage, but we’ve also observed that the farther away in the dependency graph a test is from the impacted files, the more unlikely a failure is to have been caused by the change itself.

Small, independent changes are easier to validate, because each of them affects a smaller set of tests, but also because test failures are easier to diagnose and fix. Finding the root cause of a test failure in a change of 25 files is pretty straightforward; finding 1 in a 10,000-file change is like the proverbial needle in a haystack. 

The trade-off in this decision is that smaller changes will cause the same tests to be run multiple times, particularly tests that depend on large parts of the codebase. Because engineer time spent tracking down test failures is much more expensive than the compute time required to run these extra tests, we’ve made the conscious decision that this is a trade-off we’re willing to make. That same trade-off might not hold for all organizations, but it is worth examining what the proper balance is for yours.

> **Case Study: Testing LSCs**
>
> Adam Bender
>
> Today it is common for a double-digit percentage (10% to 20%) of the changes in a project to be the result of LSCs, meaning a substantial amount of code is changed in projects by people whose full-time job is unrelated to those projects. Without good tests, such work would be impossible, and Google’s codebase would quickly atrophy under its own weight. LSCs enable us to systematically migrate our entire codebase to newer APIs, deprecate older APIs, change language versions, and remove popular but dangerous practices.
>
> Even a simple one-line signature change becomes complicated when made in a thou‐ sand different places across hundreds of different products and services.[7]After the change is written, you need to coordinate code reviews across dozens of teams. Lastly, after reviews are approved, you need to run as many tests as you can to be sure the change is safe.[8]We say “as many as you can,” because a good-sized LSC could trigger a rerun of every single test at Google, and that can take a while. In fact, many LSCs have to plan time to catch downstream clients whose code backslides while the LSC makes its way through the process.
>
> Testing an LSC can be a slow and frustrating process. When a change is sufficiently large, your local environment is almost guaranteed to be permanently out of sync with head as the codebase shifts like sand around your work. In such circumstances, it is easy to find yourself running and rerunning tests just to ensure your changes continue to be valid. When a project has flaky tests or is missing unit test coverage, it can require a lot of manual intervention and slow down the entire process. To help speed things up, we use a strategy called the TAP (Test Automation Platform) train.
>
> **Riding the TAP Train**
>
> The core insight to LSCs is that they rarely interact with one another, and most affected tests are going to pass for most LSCs. As a result, we can test more than one change at a time and reduce the total number of tests executed. The train model has proven to be very effective for testing LSCs.
>
> The TAP train takes advantage of two facts:
>
> - LSCs tend to be pure refactorings and therefore very narrow in scope, preserving local semantics.
>
> - Individual changes are often simpler and highly scrutinized, so they are correct more often than not.
>
> The train model also has the advantage that it works for multiple changes at the same time and doesn’t require that each individual change ride in isolation.[9]
>
> The train has five steps and is started fresh every three hours:
>
> 1. For each change on the train, run a sample of 1,000 randomly-selected tests.
> 2. Gather up all the changes that passed their 1,000 tests and create one uberchange from all of them: “the train.”
> 3. Run the union of all tests directly affected by the group of changes. Given a large enough (or low-level enough) LSC, this can mean running every single test in Google’s repository. This process can take more than six hours to complete.
> 4. For each nonflaky test that fails, rerun it individually against each change that made it into the train to determine which changes caused it to fail.
> 5. TAP generates a report for each change that boarded the train. The report describes all passing and failing targets and can be used as evidence that an LSC is safe to submit.

### Code Review

Finally, as we mentioned in Chapter 9, all changes need to be reviewed before submission, and this policy applies even for LSCs. Reviewing large commits can be tedious, onerous, and even error prone, particularly if the changes are generated by hand (a process you want to avoid, as we’ll discuss shortly). In just a moment, we’ll look at how tooling can often help in this space, but for some classes of changes, we still want humans to explicitly verify they are correct. Breaking an LSC into separate shards makes this much easier.

> **Case Study: scoped_ptr to std::unique_ptr**
>
> Since its earliest days, Google’s C++ codebase has had a self-destructing smart pointer for wrapping heap-allocated C++ objects and ensuring that they are destroyed when the smart pointer goes out of scope. This type was called scoped_ptr and was used extensively throughout Google’s codebase to ensure that object lifetimes were appropriately managed. It wasn’t perfect, but given the limitations of the then-current C++ standard (C++98) when the type was first introduced, it made for safer programs.[9]
>
> In C++11, the language introduced a new type: std::unique_ptr. It fulfilled the same function as scoped_ptr, but also prevented other classes of bugs that the language now could detect. std::unique_ptr was strictly better than scoped_ptr, yet Google’s codebase had more than 500,000 references to scoped_ptr scattered among millions of source files. Moving to the more modern type required the largest LSC attempted to that point within Google.
>
> Over the course of several months, several engineers attacked the problem in parallel. Using Google’s large-scale migration infrastructure, we were able to change references to scoped_ptr into references to std::unique_ptr as well as slowly adapt scoped_ptr to behave more closely to std::unique_ptr. At the height of the migration process, we were consistently generating, testing and committing more than 700 independent changes, touching more than 15,000 files per day. Today, we sometimes manage 10 times that throughput, having refined our practices and improved our tooling.
>
> Like almost all LSCs, this one had a very long tail of tracking down various nuanced behavior dependencies (another manifestation of Hyrum’s Law), fighting race conditions with other engineers, and uses in generated code that weren’t detectable by our automated tooling. We continued to work on these manually as they were discovered by the testing infrastructure.
>
> scoped_ptr was also used as a parameter type in some widely used APIs, which made small independent changes difficult. We contemplated writing a call-graph analysis system that could change an API and its callers, transitively, in one commit, but were concerned that the resulting changes would themselves be too large to commit atomically.
>
> In the end, we were able to finally remove scoped_ptr by first making it a type alias of std::unique_ptr and then performing the textual substitution between the old alias and the new, before eventually just removing the old scoped_ptr alias. Today, Google’s codebase benefits from using the same standard type as the rest of the C++ ecosystem, which was possible only because of our technology and tooling for LSCs.

## LSC Infrastructure

Google has invested in a significant amount of infrastructure to make LSCs possible. This infrastructure includes tooling for change creation, change management, change review, and testing. However, perhaps the most important support for LSCs has been the evolution of cultural norms around large-scale changes and the oversight given to them. Although the sets of technical and social tools might differ for your organization, the general principles should be the same.

### Policies and Culture

As we’ve described in Chapter 16, Google stores the bulk of its source code in a single monolithic repository (monorepo), and every engineer has visibility into almost all of this code. This high degree of openness means that any engineer can edit any file and send those edits for review to those who can approve them. However, each of those edits has costs, both to generate as well as review.[10]

Historically, these costs have been somewhat symmetric, which limited the scope of changes a single engineer or team could generate. As Google’s LSC tooling improved, it became easier to generate a large number of changes very cheaply, and it became equally easy for a single engineer to impose a burden on a large number of reviewers across the company. Even though we want to encourage widespread improvements to our codebase, we want to make sure there is some oversight and thoughtfulness behind them, rather than indiscriminate tweaking.[11]

The end result is a lightweight approval process for teams and individuals seeking to make LSCs across Google. This process is overseen by a group of experienced engineers who are familiar with the nuances of various languages, as well as invited domain experts for the particular change in question. The goal of this process is not to prohibit LSCs, but to help change authors produce the best possible changes, which make the most use of Google’s technical and human capital. Occasionally, this group might suggest that a cleanup just isn’t worth it: for example, cleaning up a common typo without any way of preventing recurrence.

Related to these policies was a shift in cultural norms surrounding LSCs. Although it is important for code owners to have a sense of responsibility for their software, they also needed to learn that LSCs were an important part of Google’s effort to scale our software engineering practices. Just as product teams are the most familiar with their own software, library infrastructure teams know the nuances of the infrastructure, and getting product teams to trust that domain expertise is an important step toward social acceptance of LSCs. As a result of this culture shift, local product teams have grown to trust LSC authors to make changes relevant to those authors’ domains.

Occasionally, local owners question the purpose of a specific commit being made as part of a broader LSC, and change authors respond to these comments just as they would other review comments. Socially, it’s important that code owners understand the changes happening to their software, but they also have come to realize that they don’t hold a veto over the broader LSC. Over time, we’ve found that a good FAQ and a solid historic track record of improvements have generated widespread endorsement of LSCs throughout Google.

### Codebase Insight

To do LSCs, we’ve found it invaluable to be able to do large-scale analysis of our code‐ base, both on a textual level using traditional tools, as well as on a semantic level. For example, Google’s use of the semantic indexing tool Kythe provides a complete map of the links between parts of our codebase, allowing us to ask questions such as “Where are the callers of this function?” or “Which classes derive from this one?” Kythe and similar tools also provide programmatic access to their data so that they can be incorporated into refactoring tools. (For further examples, see Chapters 17 and 20.)

We also use compiler-based indices to run abstract syntax tree-based analysis and transformations over our codebase. Tools such as ClangMR, JavacFlume, or Refaster, which can perform transformations in a highly parallelizable way, depend on these insights as part of their function. For smaller changes, authors can use specialized, custom tools, perl or sed, regular expression matching, or even a simple shell script.

Whatever tool your organization uses for change creation, it’s important that its human effort scale sublinearly with the codebase; in other words, it should take roughly the same amount of human time to generate the collection of all required changes, no matter the size of the repository. The change creation tooling should also be comprehensive across the codebase, so that an author can be assured that their change covers all of the cases they’re trying to fix.

As with other areas in this book, an early investment in tooling usually pays off in the short to medium term. As a rule of thumb, we’ve long held that if a change requires more than 500 edits, it’s usually more efficient for an engineer to learn and execute our change-generation tools rather than manually execute that edit. For experienced “code janitors,” that number is often much smaller.

### Change Management

Arguably the most important piece of large-scale change infrastructure is the set of tooling that shards a master change into smaller pieces and manages the process of testing, mailing, reviewing, and committing them independently. At Google, this tool is called Rosie, and we discuss its use more completely in a few moments when we examine our LSC process. In many respects, Rosie is not just a tool, but an entire platform for making LSCs at Google scale. It provides the ability to split the large sets of comprehensive changes produced by tooling into smaller shards, which can be tested, reviewed, and submitted independently.

### Testing

Testing is another important piece of large-scale-change–enabling infrastructure. As discussed in Chapter 11, tests are one of the important ways that we validate our soft‐ ware will behave as expected. This is particularly important when applying changes that are not authored by humans. A robust testing culture and infrastructure means that other tooling can be confident that these changes don’t have unintended effects.

Google’s testing strategy for LSCs differs slightly from that of normal changes while still using the same underlying CI infrastructure. Testing LSCs means not just ensuring the large master change doesn’t cause failures, but that each shard can be submitted safely and independently. Because each shard can contain arbitrary files, we don’t use the standard project-based presubmit tests. Instead, we run each shard over the transitive closure of every test it might affect, which we discussed earlier.

### Language Support 

LSCs at Google are typically done on a per-language basis, and some languages sup‐ port them much more easily than others. We’ve found that language features such as type aliasing and forwarding functions are invaluable for allowing existing users to continue to function while we introduce new systems and migrate users to them non- atomically. For languages that lack these features, it is often difficult to migrate systems incrementally.[12]

We’ve also found that statically typed languages are much easier to perform large automated changes in than dynamically typed languages. Compiler-based tools along with strong static analysis provide a significant amount of information that we can use to build tools to affect LSCs and reject invalid transformations before they even get to the testing phase. The unfortunate result of this is that languages like Python, Ruby, and JavaScript that are dynamically typed are extra difficult for maintainers. Language choice is, in many respects, intimately tied to the question of code lifespan: languages that tend to be viewed as more focused on developer productivity tend to be more difficult to maintain. Although this isn’t an intrinsic design requirement, it is where the current state of the art happens to be.

Finally, it’s worth pointing out that automatic language formatters are a crucial part of the LSC infrastructure. Because we work toward optimizing our code for readability, we want to make sure that any changes produced by automated tooling are intelligible to both immediate reviewers and future readers of the code. All of the LSC-generation tools run the automated formatter appropriate to the language being changed as a separate pass so that the change-specific tooling does not need to concern itself with formatting specifics. Applying automated formatting, such as google-java-format or clang-format, to our codebase means that automatically produced changes will “fit in” with code written by a human, reducing future development friction. Without automated formatting, large-scale automated changes would never have become the accepted status quo at Google.

> **Case Study: Operation RoseHub**
>
> LSCs have become a large part of Google’s internal culture, but they are starting to have implications in the broader world. Perhaps the best known case so far was “Operation RoseHub.”
>
> In early 2017, a vulnerability in the Apache Commons library allowed any Java application with a vulnerable version of the library in its transitive classpath to become susceptible to remote execution. This bug became known as the Mad Gadget. Among other things, it allowed an avaricious hacker to encrypt the San Francisco Municipal Transportation Agency’s systems and shut down its operations. Because the only requirement for the vulnerability was having the wrong library somewhere in its classpath, anything that depended on even one of many open source projects on GitHub was vulnerable.
>
> To solve this problem, some enterprising Googlers launched their own version of the LSC process. By using tools such as BigQuery, volunteers identified affected projects and sent more than 2,600 patches to upgrade their versions of the Commons library to one that addressed Mad Gadget. Instead of automated tools managing the process, more than 50 humans made this LSC work.