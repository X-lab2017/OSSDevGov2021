# CHAPTER 13 Test Doubles

## Real Implementations

At Google, the preference for real implementations developed over time as we saw
that overuse of mocking frameworks had a tendency to pollute tests with repetitive
code that got out of sync with the real implementation and made refactoring difficult.
We’ll look at this topic in more detail later in this chapter.

Preferring real implementations in tests is known as *classical testing*. There is also a
style of testing known as mockist testing, in which the preference is to use mocking
frameworks instead of real implementations. Even though some people in the software
industry practice mockist testing (including the creators of the first mocking
frameworks), at Google, we have found that this style of testing is difficult to scale. It
requires engineers to follow strict guidelines when designing the system under test,
and the default behavior of most engineers at Google has been to write code in a way
that is more suitable for the classical testing style.

### Prefer Realism Over Isolation

Using real implementations for dependencies makes the system under test more realistic
given that all code in these real implementations will be executed in the test. In contrast, a test that utilizes test doubles isolates the system under test from its dependencies
so that the test does not execute code in the dependencies of the system
under test.

We prefer realistic tests because they give more confidence that the system under test
is working properly. If unit tests rely too much on test doubles, an engineer might
need to run integration tests or manually verify that their feature is working as
expected in order to gain this same level of confidence. Carrying out these extra tasks
can slow down development and can even allow bugs to slip through if engineers skip
these tasks entirely when they are too time consuming to carry out compared to running
unit tests.

Replacing all dependencies of a class with test doubles arbitrarily isolates the system
under test to the implementation that the author happens to put directly into the class
and excludes implementation that happens to be in different classes. However, a good
test should be independent of implementation—it should be written in terms of the
API being tested rather than in terms of how the implementation is structured.

Using real implementations can cause your test to fail if there is a bug in the real
implementation. This is good! You want your tests to fail in such cases because it
indicates that your code won’t work properly in production. Sometimes, a bug in a
real implementation can cause a cascade of test failures because other tests that use
the real implementation might fail, too. But with good developer tools, such as a Continuous Integration (CI) system, it is usually easy to track down the change that
caused the failure.

#### Case Study: @DoNotMock

At Google, we’ve seen enough tests that over-rely on mocking frameworks to motivate
the creation of the @DoNotMock annotation in Java, which is available as part of the
ErrorProne static analysis tool. This annotation is a way for API owners to declare,
“this type should not be mocked because better alternatives exist.”

If an engineer attempts to use a mocking framework to create an instance of a class or
interface that has been annotated as @DoNotMock, as demonstrated in Example 13-10,
they will see an error directing them to use a more suitable test strategy, such as a real
implementation or a fake. This annotation is most commonly used for value objects
that are simple enough to use as-is, as well as for APIs that have well-engineered fakes
available.

Example 13-10. The @DoNotMock annotation

```java
@DoNotMock("Use SimpleQuery.create() instead of mocking.")
public abstract class Query {
public abstract String getQueryValue();
}
```

Why would an API owner care? In short, it severely constrains the API owner’s ability
to make changes to their implementation over time. As we’ll explore later in the chapter,
every time a mocking framework is used for stubbing or interaction testing, it
duplicates behavior provided by the API.

When the API owner wants to change their API, they might find that it has been
mocked thousands or even tens of thousands of times throughout Google’s codebase!
These test doubles are very likely to exhibit behavior that violates the API contract of
the type being mocked—for instance, returning null for a method that can never
return null. Had the tests used the real implementation or a fake, the API owner could
make changes to their implementation without first fixing thousands of flawed tests.

### How to Decide When to Use a Real Implementation

A real implementation is preferred if it is fast, deterministic, and has simple dependencies.
For example, a real implementation should be used for a *value object*. Examples
include an amount of money, a date, a geographical address, or a collection class
such as a list or a map.

However, for more complex code, using a real implementation often isn’t feasible.
There might not be an exact answer on when to use a real implementation or a test
double given that there are trade-offs to be made, so you need to take the following
considerations into account

#### Execution time

One of the most important qualities of unit tests is that they should be fast—you want
to be able to continually run them during development so that you can get quick
feedback on whether your code is working (and you also want them to finish quickly
when run in a CI system). As a result, a test double can be very useful when the real
implementation is slow.

How slow is too slow for a unit test? If a real implementation added one millisecond
to the running time of each individual test case, few people would classify it as slow.
But what if it added 10 milliseconds, 100 milliseconds, 1 second, and so on?

There is no exact answer here—it can depend on whether engineers feel a loss in productivity,
and how many tests are using the real implementation (one second extra
per test case may be reasonable if there are five test cases, but not if there are 500).
For borderline situations, it is often simpler to use a real implementation until it
becomes too slow to use, at which point the tests can be updated to use a test double
instead.

Parellelization of tests can also help reduce execution time. At Google, our test infrastructure
makes it trivial to split up tests in a test suite to be executed across multiple
servers. This increases the cost of CPU time, but it can provide a large savings in
developer time. We discuss this more in Chapter 18.

Another trade-off to be aware of: using a real implementation can result in increased
build times given that the tests need to build the real implementation as well as all of
its dependencies. Using a highly scalable build system like Bazel can help because it
caches unchanged build artifacts.

#### Determinism

A test is *deterministic* if, for a given version of the system under test, running the test
always results in the same outcome; that is, the test either always passes or always
fails. In contrast, a test is *nondeterministic* if its outcome can change, even if the system
under test remains unchanged.

Nondeterminism in tests can lead to flakiness—tests can occasionally fail even when
there are no changes to the system under test. As discussed in Chapter 11, flakiness
harms the health of a test suite if developers start to distrust the results of the test and
ignore failures. If use of a real implementation rarely causes flakiness, it might not
warrant a response, because there is little disruption to engineers. But if flakiness happens often, it might be time to replace a real implementation with a test double because doing so will improve the fidelity of the test.

A real implementation can be much more complex compared to a test double, which
increases the likelihood that it will be nondeterministic. For example, a real implementation
that utilizes multithreading might occasionally cause a test to fail if the
output of the system under test differs depending on the order in which the threads
are executed.

A common cause of nondeterminism is code that is not hermetic; that is, it has
dependencies on external services that are outside the control of a test. For example, a
test that tries to read the contents of a web page from an HTTP server might fail if the
server is overloaded or if the web page contents change. Instead, a test double should
be used to prevent the test from depending on an external server. If using a test double
is not feasible, another option is to use a hermetic instance of a server, which has
its life cycle controlled by the test. Hermetic instances are discussed in more detail in
the next chapter.

Another example of nondeterminism is code that relies on the system clock given
that the output of the system under test can differ depending on the current time.
Instead of relying on the system clock, a test can use a test double that hardcodes a
specific time.

#### Dependency construction

When using a real implementation, you need to construct all of its dependencies. For
example, an object needs its entire dependency tree to be constructed: all objects that
it depends on, all objects that these dependent objects depend on, and so on. A test
double often has no dependencies, so constructing a test double can be much simpler
compared to constructing a real implementation.

As an extreme example, imagine trying to create the object in the code snippet that
follows in a test. It would be time consuming to determine how to construct each
individual object. Tests will also require constant maintenance because they need to
be updated when the signature of these objects’ constructors is modified:

Foo foo = new Foo(new A(new B(new C()), new D()), new E(), ..., new Z());

It can be tempting to instead use a test double because constructing one can be trivial.
For example, this is all it takes to construct a test double when using the Mockito
mocking framework:

@Mock Foo mockFoo;

Although creating this test double is much simpler, there are significant benefits to
using the real implementation, as discussed earlier in this section. There are also
often significant downsides to overusing test doubles in this way, which we look at
later in this chapter. So, a trade-off needs to be made when considering whether to
use a real implementation or a test double.

Rather than manually constructing the object in tests, the ideal solution is to use the
same object construction code that is used in the production code, such as a factory
method or automated dependency injection. To support the use case for tests, the
object construction code needs to be flexible enough to be able to use test doubles
rather than hardcoding the implementations that will be used for production.

## Faking

If using a real implementation is not feasible within a test, the best option is often to
use a fake in its place. A fake is preferred over other test double techniques because it
behaves similarly to the real implementation: the system under test shouldn’t even be
able to tell whether it is interacting with a real implementation or a fake.
Example 13-11 illustrates a fake file system.

Example 13-11. A fake file system

```java
// This fake implements the FileSystem interface. This interface is also
// used by the real implementation.
public class FakeFileSystem implements FileSystem {
// Stores a map of file name to file contents. The files are stored in
// memory instead of on disk since tests shouldn’t need to do disk I/O.
private Map<String, String> files = new HashMap<>();
@Override
public void writeFile(String fileName, String contents) {
// Add the file name and contents to the map.
files.add(fileName, contents);
}
@Override
public String readFile(String fileName) {
String contents = files.get(fileName);
// The real implementation will throw this exception if the
// file isn’t found, so the fake must throw it too.
if (contents == null) { throw new FileNotFoundException(fileName); }
return contents;
}
}
```

### Why Are Fakes Important?

Fakes can be a powerful tool for testing: they execute quickly and allow you to effectively
test your code without the drawbacks of using real implementations.

A single fake has the power to radically improve the testing experience of an API. If
you scale that to a large number of fakes for all sorts of APIs, fakes can provide an
enormous boost to engineering velocity across a software organization.

At the other end of the spectrum, in a software organization where fakes are rare,
velocity will be slower because engineers can end up struggling with using real implementations
that lead to slow and flaky tests. Or engineers might resort to other test
double techniques such as stubbing or interaction testing, which, as we’ll examine
later in this chapter, can result in tests that are unclear, brittle, and less effective.

### When Should Fakes Be Written?

A fake requires more effort and more domain experience to create because it needs to
behave similarly to the real implementation. A fake also requires maintenance: whenever
the behavior of the real implementation changes, the fake must also be updated
to match this behavior. Because of this, the team that owns the real implementation
should write and maintain a fake.

If a team is considering writing a fake, a trade-off needs to be made on whether the
productivity improvements that will result from the use of the fake outweigh the costs
of writing and maintaining it. If there are only a handful of users, it might not be
worth their time, whereas if there are hundreds of users, it can result in an obvious
productivity improvement.

To reduce the number of fakes that need to be maintained, a fake should typically be
created only at the root of the code that isn’t feasible for use in tests. For example, if a
database can’t be used in tests, a fake should exist for the database API itself rather
than for each class that calls the database API.

Maintaining a fake can be burdensome if its implementation needs to be duplicated
across programming languages, such as for a service that has client libraries that
allow the service to be invoked from different languages. One solution for this case is
to create a single fake service implementation and have tests configure the client
libraries to send requests to this fake service. This approach is more heavyweight
compared to having the fake written entirely in memory because it requires the test to
communicate across processes. However, it can be a reasonable trade-off to make, as
long as the tests can still execute quickly.

### The Fidelity of Fakes

Perhaps the most important concept surrounding the creation of fakes is fidelity; in
other words, how closely the behavior of a fake matches the behavior of the real
implementation. If the behavior of a fake doesn’t match the behavior of the real
implementation, a test using that fake is not useful—a test might pass when the fake is
used, but this same code path might not work properly in the real implementation.

Perfect fidelity is not always feasible. After all, the fake was necessary because the real
implementation wasn’t suitable in one way or another. For example, a fake database
would usually not have fidelity to a real database in terms of hard drive storage
because the fake would store everything in memory.

Primarily, however, a fake should maintain fidelity to the API contracts of the real
implementation. For any given input to an API, a fake should return the same output
and perform the same state changes of its corresponding real implementation. For
example, for a real implementation of database.save(itemId), if an item is successfully
saved when its ID does not yet exist but an error is produced when the ID
already exists, the fake must conform to this same behavior.

One way to think about this is that the fake must have perfect fidelity to the real
implementation, but only from the perspective of the test. For example, a fake for a
hashing API doesn’t need to guarantee that the hash value for a given input is exactly
the same as the hash value that is generated by the real implementation—tests likely
don’t care about the specific hash value, only that the hash value is unique for a given
input. If the contract of the hashing API doesn’t make guarantees of what specific
hash values will be returned, the fake is still conforming to the contract even if it
doesn’t have perfect fidelity to the real implementation.

Other examples where perfect fidelity typically might not be useful for fakes include
latency and resource consumption. However, a fake cannot be used if you need to
explicitly test for these constraints (e.g., a performance test that verifies the latency of
a function call), so you would need to resort to other mechanisms, such as by using a
real implementation instead of a fake.

A fake might not need to have 100% of the functionality of its corresponding real
implementation, especially if such behavior is not needed by most tests (e.g., error
handling code for rare edge cases). It is best to have the fake fail fast in this case; for
example, raise an error if an unsupported code path is executed. This failure communicates
to the engineer that the fake is not appropriate in this situation.

### Fakes Should Be Tested

A fake must have its own tests to ensure that it conforms to the API of its corresponding
real implementation. A fake without tests might initially provide realistic behavior,
but without tests, this behavior can diverge over time as the real implementation
evolves.

One approach to writing tests for fakes involves writing tests against the API’s public
interface and running those tests against both the real implementation and the fake
(these are known as *contract tests*). The tests that run against the real implementation
will likely be slower, but their downside is minimized because they need to be run
only by the owners of the fake.

### What to Do If a Fake Is Not Available

If a fake is not available, first ask the owners of the API to create one. The owners
might not be familiar with the concept of fakes, or they might not realize the benefit
they provide to users of an API.

If the owners of an API are unwilling or unable to create a fake, you might be able to
write your own. One way to do this is to wrap all calls to the API in a single class and
then create a fake version of the class that doesn’t talk to the API. Doing this can also
be much simpler than creating a fake for the entire API because often you’ll need to
use only a subset of the API’s behavior anyway. At Google, some teams have even
contributed their fake to the owners of the API, which has allowed other teams to
benefit from the fake.

Finally, you could decide to settle on using a real implementation (and deal with the
trade-offs of real implementations that are mentioned earlier in this chapter), or
resort to other test double techniques (and deal with the trade-offs that we will mention
later in this chapter).

In some cases, you can think of a fake as an optimization: if tests are too slow using a
real implementation, you can create a fake to make them run faster. But if the
speedup from a fake doesn’t outweigh the work it would take to create and maintain
the fake, it would be better to stick with using the real implementation.

## Stubbing

As discussed earlier in this chapter, stubbing is a way for a test to hardcode behavior
for a function that otherwise has no behavior on its own. It is often a quick and easy
way to replace a real implementation in a test. For example, the code in
Example 13-12 uses stubbing to simulate the response from a credit card server.
