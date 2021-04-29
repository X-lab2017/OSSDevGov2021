# 第十三章 测试替身

单元测试是保持开发人员生产力和减少代码缺陷的关键工具。虽然对于简单的代码来说编写单元测试很容易，但是当代码变得更复杂时，编写它们就很困难了。

例如，设想为一个函数编写测试，该函数的作用是向外部服务器发送请求，然后将响应存储在数据库中。编写少量测试可能是可行的，但是如果你需要编写成百上千个这样的测试，那么你的这些测试很可能需要运行数小时，并且可能会因为随机的网络故障或者测试覆盖了其他数据等问题而变得不稳定。

在这种情况下，测试替身（Test doubles）就派上用场了。测试替身是一个对象或函数，可以在测试中代替真实的实现，类似于替身可以代替电影中的演员。测试替身的使用通常被称为模拟，但我们在本章中会避免使用这个术语，因为我们将看到，这个术语也被用来指代测试替身的更具体的方面。

或许最明显的测试替身的类型就是其行为与真实的实现类似的对象，但是是一个更简单的实现，比如内存数据库。其他类型的测试替身能够验证系统特定的细节，例如通过触发罕见的错误条件，或者确保在不实际执行函数实现的情况下调用重量级函数。

前两章介绍了小型测试的概念，并讨论了为什么它们应该组成测试套件中的大多数测试。然而，由于跨多个进程或机器通信，生产代码通常不适合小型测试的约束。测试替身比真正的实现要轻量得多，从而允许您编写许多快速执行且不易出错的小型测试。

## 测试替身对软件开发的影响

测试替身的使用给软件开发带来了一些复杂性，这需要进行一些权衡。本章将对这里介绍的概念进行更深入的讨论。

### 可测试性（Testability）

要使用测试替身，必须将一个代码库设计成可测试的，以便测试能够用测试替身来交换真实的实现。例如，调用数据库的代码需要足够灵活以便能够使用测试替身来代替真实的数据库。
如果您在设计代码库时没有考虑到测试，而后来又决定需要测试，那么这可能需要投入大量精力来重构代码以支持使用测试替身。

### 适用性（Applicability）

虽然正确地应用测试替身可以大大提高工程速度，但不正确使用它们会导致测试变得脆弱、复杂和低效。当在大型代码库中不恰当地使用测试替身时，这些缺点会被放大，这可能会极大地影响工程师的生产力。在很多情况下，测试替身是不合适的，工程师应该更倾向于使用真实的实现。

### 保真度（Fidelity）

保真度指的是测试替身的行为与它所替代的真实实现的行为有多相似。如果一个测试替身的行为与真正的实现明显不同，测试使用的测试替身可能不会提供多少价值。例如，假设您试图为一个数据库编写一个带有测试替身的测试，测试忽略了任何添加到数据库的数据，并且总是返回空的结果。但是，完美的保真度可能并不可行；为了适合在测试中使用，测试替身通常需要比实际实现简单得多。在很多情况下，即使没有完全的保真度，也应该使用测试替身。使用测试替身的单元测试通常需要由实际实现的更大范围的测试来补充。

## Google中的测试替身

在Google上，我们已经看到了无数的例子，这些例子说明了测试替身给代码库带来的生产力和软件质量方面的好处，以及它们在使用不当时可能造成的负面影响。基于这些经验，我们在Google所遵循的做法随着时间的推移而不断发展。从历史上看，关于如何有效使用测试替身的指导原则很少，但是随着我们看到许多团队代码库中出现了通用模式和反模式，最佳实践也在不断发展。

我们从惨痛的教训中学到的一课是过度使用模拟框架的危险，它允许你轻松地创建测试替身(我们将在本章后面更详细地讨论模拟框架)。当模拟框架第一次在谷歌上使用时，它们就像是铁锤打在钉子上，可以很容易地针对孤立的代码片段编写高度集中的测试，而不必担心如何构造代码的依赖关系。直到数年和无数次的测试之后，我们才开始意识到这种测试的成本：虽然这些测试很容易编写，但考虑到它们需要不断地维护，而很少发现错误，因此我们遭受了很大的痛苦。现在，Google的钟摆已经开始向另一个方向摆动，许多工程师避免使用模拟框架，而倾向于编写更实际的测试。

尽管本章中讨论的实践在Google上已经普遍得到了认可，但各个团队之间的实际应用差异很大。这种差异来自于工程师对这些实践的不一致的知识，现有代码库中的惯性不符合这些实践，或者团队只做短期内最容易的事情而不考虑长期影响。

## 基本概念

在深入研究如何有效地使用测试替身之前，我们先介绍一些与之相关的基本概念。这些为我们将在本章后面讨论的最佳实践奠定了基础。

### 测试替身的一个例子

假设一个电子商务网站需要处理信用卡支付。其核心部分可能类似于示例13-1中所示的代码。

例子13-1. 信用卡服务

```java
class PaymentProcessor {
private CreditCardService creditCardService;
...
boolean makePayment(CreditCard creditCard, Money amount) {
if (creditCard.isExpired()) { return false; }
boolean success =
creditCardService.chargeCreditCard(creditCard, amount);
return success;
}
}
```

在测试中使用真实的信用卡服务是不可行的(想象一下运行测试产生的所有交易费用!)，但是可以使用一个测试替身来模拟真实系统的行为。示例13-2中的代码显示了一个非常简单的测试替身。

例子 13-2. 一个简单的测试替身

```java
class TestDoubleCreditCardService implements CreditCardService {
@Override
public boolean chargeCreditCard(CreditCard creditCard, Money amount) {
return true;
}
}
```

尽管这个测试替身看起来不是很有用，但在测试中使用它仍可以让我们能够测试makePayment()方法中的一些逻辑。例如，在示例13-3中，我们可以验证信用卡过期时方法是否正确，因为测试所执行的代码路径并不依赖于信用卡服务的行为。

例子 13-3. 使用测试替身

```java
@Test public void cardIsExpired_returnFalse() {
boolean success = paymentProcessor.makePayment(EXPIRED_CARD, AMOUNT);
assertThat(success).isFalse();
}
```

本章的下面几节将讨论如何在比这更复杂的情况下使用测试替身。

### 接缝（Seams）

如果代码的编写方式允许为代码编写单元测试，那么它就被称为可测试的。接缝是一种通过允许使用测试替身来使代码可测试的方法，它可以对被测试系统使用不同的依赖关系，而不是生产环境中使用的依赖关系。

依赖项注入是引入接缝的常用技术。简而言之，当一个类使用依赖项注入时，它需要使用的任何类(即类的依赖项)都被传递给它，而不是直接实例化，这使得这些依赖项可以在测试中替换。
例13-4展示了一个依赖注入的例子。它接受实例作为参数，而不是用构造器创建CreditCardService的实例

例子 13-4. 依赖项注入

```java
class PaymentProcessor {
private CreditCardService creditCardService;
PaymentProcessor(CreditCardService creditCardService) {
this.creditCardService = creditCardService;
}
...
}
```

调用此构造函数的代码负责创建适当的creditcardservice实例。尽管生产代码可以通过与外部服务器通信的CreditCardService的实现，但测试可以通过测试替身，如示例13-5所示。

例子 13-5. 通过测试替身

```java
PaymentProcessor paymentProcessor =
new PaymentProcessor(new TestDoubleCreditCardService());
```

为了减少与手动指定构造函数相关的引用，可以使用自动依赖注入框架来自动构造对象图。在Google，Guice和Dagger是Java代码中常用的自动依赖注入框架。
对于Python或JavaScript这样的动态类型语言，可以动态地替换单个函数或对象方法。依赖注入在这些语言中不那么重要，因为这种功能可以在测试中使用依赖的真正实现，同时仅覆盖不适合测试的依赖函数或方法。

编写可测试代码需要预先投入。它在代码库生命周期的早期尤其关键，因为考虑可测试性的时间越晚，就越难应用到代码库。在没有考虑测试的情况下编写的代码通常需要进行重构或重写，然后才能添加适当的测试。

### 模拟框架（Mocking Frameworks）

模拟框架是一个软件库，它可以简化在测试中创建测试替身的过程；它允许您用模拟来替换对象，该模拟是测试替换，其行为是在测试中内联指定的。模拟框架的使用减少了样板代码，因为您不需要在每次需要测试替身时都定义一个新类。

示例13-6演示了Mockito的使用，这是一个针对Java的模拟框架。Mockito为CreditCardService创建一个替身，并让它返回一个特定的值。

例子 13-6. 模拟框架

```java
class PaymentProcessorTest {
...
PaymentProcessor paymentProcessor;
// 只用一行代码创建CreditCardService的测试替身
@Mock CreditCardService mockCreditCardService;
@Before public void setUp() {
// 被测系统通过测试替身
paymentProcessor = new PaymentProcessor(mockCreditCardService);
}
@Test public void chargeCreditCardFails_returnFalse() {
// Give some behavior to the test double: it will return false
// anytime the chargeCreditCard() method is called. The usage of
// “any()” for the method’s arguments tells the test double to
// return false regardless of which arguments are passed.
when(mockCreditCardService.chargeCreditCard(any(), any())
.thenReturn(false);
boolean success = paymentProcessor.makePayment(CREDIT_CARD, AMOUNT);
assertThat(success).isFalse();
}
}
```

大多数主流编程语言都有模拟框架。在Google，我们在Java中使用Mockito，在c++中使用Googletest中的googlemock组件，以及Python的unittest。
尽管模拟框架简化了测试替身的使用，但它们也带来了一些重要的警告，因为它们的过度使用通常会使代码库更加难以维护。我们将在本章后续讨论这些问题。

## 使用测试替身的技术

使用测试替身有三种主要的技术。本节将简要介绍这些技术，让您快速了解它们是什么以及它们之间的区别。本章后面的章节将详细介绍如何有效地应用它们。
了解这些技术之间区别的工程师，在需要使用测试替身时，更有可能知道使用哪种合适的技术。

### 伪造（Faking）

伪造是API的轻量级实现，它的行为类似于真正的实现，但不适合生产；例如，内存数据库。例子13-7展示了一个伪造的例子。

例子 13-7. 一个简单的伪造

```java
// Creating the fake is fast and easy.
AuthorizationService fakeAuthorizationService =
new FakeAuthorizationService();
AccessManager accessManager = new AccessManager(fakeAuthorizationService):
// Unknown user IDs shouldn’t have access.
assertFalse(accessManager.userHasAccess(USER_ID));
// The user ID should have access after it is added to
// the authorization service.
fakeAuthorizationService.addAuthorizedUser(new User(USER_ID));
assertThat(accessManager.userHasAccess(USER_ID)).isTrue();
```

当需要使用测试替身时，使用伪造品通常是理想的技术，但是对于需要在测试中使用的对象，伪造品可能不存在，并且编写伪造品可能有一定挑战性，因为您需要确保它和现在到将来的真正实现具有相似的行为。

### 打桩（Stubbing）

打桩是向某个函数赋予行为的过程，否则该函数本身就没有行为，您可以向函数确切指定要返回的值（也就是说，对返回值进行打桩）。

示例13-8演示了打桩。来自Mockito模拟框架的when(…). thenreturn(…)方法调用指定了lookupUser()方法的行为。

例子 13-8. 打桩

```java
// 通过由模拟框架创建的测试替身
AccessManager accessManager = new AccessManager(mockAuthorizationService):
// 如果返回null，用户ID不应该被获取
when(mockAuthorizationService.lookupUser(USER_ID)).thenReturn(null);
assertThat(accessManager.userHasAccess(USER_ID)).isFalse();
// 如果返回非null值，用户ID应该可以被获取
when(mockAuthorizationService.lookupUser(USER_ID)).thenReturn(USER);
assertThat(accessManager.userHasAccess(USER_ID)).isTrue();
```

### 交互测试（Interaction Testing）

交互测试是一种验证如何调用函数而不实际调用函数实现的方法。如果一个函数没有被正确调用，测试就会失败。例如，如果这个函数根本没有被调用，它被调用了很多次，或者它被调用时使用了错误的参数。

例13-9展示了一个交互测试的实例。来自Mockito模拟框架的verify(…)方法用于验证lookupUser()是否按预期被调用。

例子 13-9. 交互测试

```java
// 通过由模拟框架创建的测试替身
AccessManager accessManager = new AccessManager(mockAuthorizationService);
accessManager.userHasAccess(USER_ID);
// 如果没有调用accessManager.userHasAccess(USER_ID)，测试将会失败
// mockAuthorizationService.lookupUser(USER_ID).
verify(mockAuthorizationService).lookupUser(USER_ID);
```

与打桩类似，交互测试通常是通过模拟框架完成的。与手工创建包含跟踪函数调用频率和传入参数的代码的新类相比，这减少了样板代码。

交互测试有时被称为模拟。我们在本章中避免使用这个术语，因为它可能会与模拟框架混淆，模拟框架既可以用于打桩测试，也可以用于交互测试。正如本章后面所讨论的，交互测试在某些情况下是有用的，但应该在可能的时候避免，因为过度使用很容易导致脆弱的测试。

## 真实的实现

在谷歌，对真实的实现的偏爱是随着时间的推移而发展起来的，因为我们看到过度使用模拟框架有一种倾向，即用重复的代码污染测试，与真实实现不同步，使重构变得困难。我们将在本章后面更详细地讨论这个话题。

在测试中更倾向于真实的实现，这被称为*经典测试*。还有一种测试风格被称为mockist测试，在这种测试中，倾向于使用模拟框架而不是真实实现。尽管软体行业的一些人在进行mockist测试（包括第一个模拟框架的创造者），但在Google，我们发现这种测试方式很难扩展。它要求工程师在设计被测系统时遵循严格的准则，而谷歌大多数工程师的默认行为是以一种更适合经典测试风格的方式来编写代码。

### 偏爱现实主义而非孤立

对依赖关系使用真实的实现，使被测系统更加真实，因为这些真实实现中的所有代码都将在测试中执行。相反，利用测试替换将被测系统与其依赖关系隔离开来，这样测试就不会执行被测系统依赖关系中的代码。

我们更喜欢现实的测试，因为它们能给被测系统正常工作带来更多的信心。如果单元测试过于依赖测试替换，工程师可能需要运行集成测试或手动验证他们的功能是否按预期工作，以获得同样的信心。执行这些额外的任务可能会减慢开发速度甚至可能会让错误漏掉，如果工程师完全跳过这些任务，当这些任务太耗时了，与运行单元测试相比。

用测试替身替换类的所有依赖关系会任意地将被测系统与作者恰好直接放在该类中的实现隔离，并排除恰好在不同类中的实现。然而，一个好的测试应该是独立于实现的--它应该从被测试的API的角度来编写，而不是从实现的结构来编写。

如果真实实现中存在bug，使用真实的实现会导致你的测试失败。这是好的，如果你希望你的测试在这种情况下失败，因为这表明你的代码在生产中无法正常工作。有时，真实实现中的一个bug会导致测试失败，因为使用真实实现的其他测试也可能失败。但如果有好的开发者工具，比如持续集成（CI）系统，通常很容易追踪到导致失败的变化。

#### 案例研究: @DoNotMock

在Google，我们已经看到了足够多的过度依赖模拟框架的测试，这促使我们在Java中创建了@DoNotMock注解，它可以作为ErrorProne静态分析工具的一部分。这个注解是API所有者声明的一种方式，"这个类型不应该被mock，因为存在更好的替代方案"。

如果工程师试图使用模拟框架来创建一个被注解为@DoNotMock的类或接口的实例，如例13-10所示，他们会看到一个错误，指示他们使用更合适的测试策略，如真实的实现或伪造的实现。这个注解最常用于那些简单到可以按原样使用的价值对象，以及那些有精心设计的伪造的API。

例子 13-10. @DoNotMock的注释

```java
@DoNotMock("Use SimpleQuery.create() instead of mocking.")
public abstract class Query {
public abstract String getQueryValue();
}
```

为什么API所有者会关心这个问题呢？简而言之，它严重限制了API所有者随着时间的推移对其实现进行修改的能力。正如我们在本章后面所探讨的，每当模拟框架被用于打桩或交互测试时，它都会重复API所提供的行为。

当API所有者想要改变他们的API时，他们可能会发现它已经在整个Google的代码库中被模拟了几千甚至几万次！这些测试替身很可能表现出违反被模拟类型的API要求的行为--例如，为一个永远不能返回空的方法返回空。如果测试使用的是真正的实现或伪造的，API所有者可以对他们的实现进行修改，而不需要先修复成千上万的有缺陷的测试。

### 如何决定何时使用真实的实施方案

如果一个真实的实现是快速的、确定的，并且有简单的依赖关系，那么它就是首选。例如，一个真实的实现应该被用于一个*价值对象*。这方面的例子包括一笔钱、一个日期、一个地理位置，或者一个集合类，如列表或地图。

然而，对于更复杂的代码，使用真实实现往往是不可行的。考虑到要进行权衡，什么时候使用真实实现或测试替身可能没有一个确切的答案，所以你需要考虑以下因素。

#### 执行时间

单元测试最重要的要求之一是它们应该是快速的--你希望能够在开发过程中不断地运行它们，这样你就可以快速得到关于你的代码是否能运行的反馈（你也希望它们在CI系统中运行时能够快速完成）。因此，当真正的实现很慢时，测试替身可以非常有用。

对于一个单元测试来说，多慢才算慢？如果一个真正的实现在每个单独的测试用例的运行时间上增加一毫秒，很少有人会把它归类为慢。但如果它增加了10毫秒，100毫秒，1秒，等等呢？

这里没有确切的答案--它可能取决于工程师是否感觉到生产力的损失，以及有多少测试在使用真实的实现（如果有5个测试用例，每个测试用例多一秒钟可能是合理的，但如果有500个测试用例就不一样了）。对于边界情况，通常更简单的是使用真正的实现，直到它变得太慢，在这一点上，测试可以被更新为使用一个测试替身。

并行测试也可以帮助减少执行时间。在谷歌，我们的测试基础设施使得将测试套件中的测试拆分到多个服务器上执行变得非常简单。这增加了CPU时间的成本，但它可以为开发人员节省大量时间。我们将在第18章中进一步讨论这个问题。

鉴于测试需要构建真正的实现以及所有的依赖关系，使用真正的实现会导致构建时间的增加。使用像Bazel这样的高度可扩展的构建系统会有帮助，因为它可以缓存未改变的构建工件。

#### 决定论

如果对于被测系统的给定版本，运行测试的结果总是相同的，也就是说，测试要么总是通过，要么总是失败，那么这个测试就是*确定性的*。相反，如果一个测试的结果可以改变，即使被测系统保持不变，那么该测试就是*非确定性的*。

测试中的非确定性会导致浮动性--即使被测系统没有变化，测试也会偶尔失败。正如第11章所讨论的，如果开发人员开始不相信测试的结果并忽视失败，那么飘忽不定就会损害测试套件的健康。如果使用一个真实的实现很少会引起故障，它可能不值得回应，因为对工程师的干扰很小。但是，如果经常发生故障，可能是时候用一个测试替身来取代真实的实现了，因为这样做会提高测试的保真度。

真正的实现比测试替身复杂得多，这增加了它的非确定性的可能性。例如，如果被测系统的输出因线程执行的顺序不同而不同，利用多线程的真实实现可能偶尔会导致测试失败。

非确定性的一个常见原因是代码不是密封的；也就是说，它对外部服务有依赖性，而这些服务是在测试的控制之外的。例如，一个试图从HTTP服务器上读取网页内容的测试，如果服务器过载或网页内容改变，可能会失败。相反，应该使用一个测试替身来防止测试依赖于外部服务器。如果使用测试替身是不可行的，另一个选择是使用服务器的密封实例，它的生命周期由测试控制。下一章将更详细地讨论密封的实例。

非确定性的另一个例子是依赖于系统时钟的代码，因为被测系统的输出会因当前的时间而不同。一个测试可以使用一个测试替身来硬编码一个特定的时间来代替依赖系统时钟。

#### 依赖关系的构建

当使用一个真正的实现时，你需要构建它所有的依赖关系。例如，一个对象需要构建它的整个依赖树：它所依赖的所有对象，这些依赖对象所依赖的所有对象，等等。一个测试替身通常没有依赖关系，所以与构造一个真实的实现相比，构造一个测试替身可能要简单得多。

作为一个极端的例子，想象一下试图在测试中创建下面代码片断中的对象。要确定如何构建每个单独的对象是很耗时的。测试也将需要不断的维护，因为当这些对象的构造器的签名被修改时，它们需要被更新。

Foo foo = new Foo(new A(new B(new C()), new D()), new E(), ..., new Z());

使用测试替身是很诱人的，因为构建一个测试替身是很简单的。例如，在使用Mockito模拟框架时，只需要构建测试替身：

 @Mock Foo mockFoo;

 尽管创建这个测试替身要简单得多，但使用真正的实现有很大的好处，正如本节前面所讨论的。以这种方式过度使用测试替身往往也有很大的弊端，我们在本章后面会看一下。所以，在考虑是使用真实实现还是测试替身时，需要做一个权衡。

与其在测试中手动构建对象，理想的解决方案是使用生产代码中使用的相同对象构建代码，如工厂方法或自动依赖注入。为了支持测试的使用情况，对象构造代码需要足够灵活，以便能够使用测试替身，而不是用于生产的实现方式的硬编码。

## 伪造

如果在测试中使用一个真实的实现是不可行的，最好的选择往往是使用一个伪造的测试来代替它。伪造的比其他测试的测试替身更受欢迎，因为它的行为与真实的实现相似：被测试的系统甚至不应该能够分辨出它是在与真实的实现还是伪造的进行交互。例13-11说明了一个伪造的文件系统。

例子 13-11. 一个伪造的文件系统

```java
// 这个伪造的测试实现了FileSystem接口。真正的实现也使用该接口。
public class FakeFileSystem implements FileSystem {
// 存储一个文件名到文件内容的映射。文件被存储在内存中，而不是磁盘上，因为测试不需要做磁盘I/O。
private Map<String, String> files = new HashMap<>();
@Override
public void writeFile(String fileName, String contents) {
// 将文件名和内容添加到map上。
files.add(fileName, contents);
}
@Override
public String readFile(String fileName) {
String contents = files.get(fileName);
// 如果没有找到文件，真正的实现会抛出这个异常，所以伪造的也必须抛出这个异常。
if (contents == null) { throw new FileNotFoundException(fileName); }
return contents;
}
}
```

### 为什么fakes很重要？

fakes可以是一个强大的测试工具：它们执行得很快，并允许你有效地测试你的代码，而没有使用真实实现的缺点。

一个fakes就能从根本上改善一个API的测试体验。如果你把它扩展到各种API的大量伪造的测试，fakes可以为整个软件组织的工程速度提供巨大的提升。

另一种做法，在一个很少有伪造的软件组织中，速度会比较慢，因为工程师最终会在使用真实的实现中挣扎，从而导致缓慢和不稳定的测试。或者，工程师们可能会求助于其他测试替身的技术，如插桩或交互测试，正如我们在本章后面要研究的那样，这可能会导致测试不明确、脆弱和低效率。

### 什么时候应该写fakes？

创建一个fake需要更多的努力和更多的领域经验，因为它需要与真实的实现有类似的行为。fake也需要维护：当真实实现的行为发生变化时，fake也必须被更新以适应这种行为。正因为如此，拥有真实实现的团队应该编写和维护一个fake。

如果一个团队正在考虑编写一个fake，就需要权衡使用伪造的所带来的生产力的提高是否超过编写和维护它的成本。如果只有少数几个用户，可能不值得他们花费时间，而如果有几百个用户，则可能会带来明显的生产力提高。

为了减少需要维护的fake的数量，通常应该只在不会在测试中使用的代码的根部创建一个fake。例如，如果一个数据库不能在测试中使用，那么数据库API本身应该存在一个fake，而不是每个调用数据库API的类。

如果fake服务的实现需要在不同的编程语言中重复，那么维护fake服务的工作就会很繁重，例如对于允许从不同语言调用服务的客户端库的服务。这种情况下的一个解决方案是创建一个单一的fake服务，并让测试配置客户端库来向这个fake服务发送请求。这种方法与完全写在内存中的fake服务相比更加沉重，因为它要求测试跨进程通信。然而，只要测试仍能快速执行，这可能是一个合理的权衡。

### Fakes的正确性

也许围绕着创建fake的最重要的概念是正确性；换句话说，fake的行为与真实实现的行为有多密切。如果fake的行为与真实实现的行为不匹配，那么使用该fake的测试就没有用处--当使用该fake时，测试可能会通过，但同样的代码路径在真实实现中可能无法正常工作。

完美的保真并不总是可行的。毕竟，fake是必要的，因为真正的实现在某种程度上并不适合。例如，在硬盘存储方面，一个伪造的数据库通常不会与真正的数据库保真，因为伪造的数据库会把所有东西都存储在内存中。

然而，主要的是，伪造的应该保持对真实实现的API要求的一致性。对于API的任何给定的输入，伪造的应该返回相同的输出，并执行其相应的真实实现的相同的状态变化。例如，对于数据库.save(itemId)的真实实现，如果一个项目在其ID不存在的情况下被成功地保存，但在ID已经存在的情况下会产生错误，那么伪造的必须符合这种相同的行为。

一种思考方式是，伪造的必须对真实的实现有完美的保真度，但只是从测试的角度来看。例如，一个伪造的散列API不需要保证给定输入的散列值与真实实现产生的散列值完全相同--测试可能不关心具体的散列值，只关心给定输入的散列值是唯一的。如果散列API的要求没有对返回的具体散列值作出保证，那么即使伪造的散列值没有完全和真正的实现一致，因为它仍然符合API要求的规定。

其他典型的完美保真例子可能对fake没有用的，如延迟和资源消耗。然而，如果你需要明确地测试这些约束条件（例如，验证函数调用延迟的性能测试），就不能使用fake，所以你需要借助其他机制，例如使用真正的实现而不是fake。

一个fake可能不需要拥有其对应的真实实现的100%的功能，特别是如果这种行为不是大多数测试所需要的（例如，罕见的边缘情况的错误处理代码）。在这种情况下，最好是让fake快速失败；例如，如果执行了不支持的代码路径，就会引发一个错误。这种失败向工程师表明，在这种情况下，fake是不合适的。

### Fakes应该被测试

一个fake必须有自己的测试，以确保它符合其对应的真实实现的API。没有测试的fake最初可能会提供真实的行为，但如果没有测试，随着时间的推移，这种行为会随着真实实现的发展而发生变化。

为fake编写测试的一种方法是针对API的公共接口编写测试，并针对真正的实现和fake运行这些测试（这些被称为*契约测试*）。针对真实实现运行的测试可能会比较慢，但是他们的缺点被最小化了，因为他们只需要由fake的所有者运行。

### 如果没有fake，该怎么办？

如果没有fake，首先要求API的所有者创建一个。所有者可能不熟悉fake的概念，或者他们可能没有意识到fake对API用户的好处。

如果一个API的所有者不愿意或不能创建一个fake，你也许可以自己写一个。一种方法是将所有对API的调用都封装在一个单一的类中，然后创建一个不与API对话的伪造的类版本。这样做也比为整个API创建一个伪造的要简单得多，因为无论如何你往往只需要使用API的一个子集的行为。在谷歌，一些团队甚至将他们的fake贡献给了API的所有者，这使得其他团队能够从fake中受益。

最后，你可以决定使用一个真实的实现（并处理本章前面提到的真实实现的权衡问题），或者采用其他测试替身技术（并处理本章后面提到的权衡问题）。

在某些情况下，你可以把fake看作是一种优化：如果使用真实实现的测试太慢，你可以创建一个fake来使其运行更快。但是，如果fake速度提高并不超过创建和维护fake的工作，那么最好还是坚持使用真实的实现。

## 打桩

正如本章前面所讨论的，打桩是一种测试的方式，为一个函数硬编码行为，否则它本身就没有行为。它通常是一种快速而简单的方法来替代测试中的真实实现。例如，例13-12中的代码使用打桩来模拟信用卡服务器的响应

例子 13-12. 使用打桩来模拟信用卡服务器的响应

```java
@Test public void getTransactionCount() {
 transactionCounter = new TransactionCounter(mockCreditCardServer);
 // Use stubbing to return three transactions.
 when(mockCreditCardServer.getTransactions()).thenReturn(
 newList(TRANSACTION_1, TRANSACTION_2, TRANSACTION_3));
 assertThat(transactionCounter.getTransactionCount()).isEqualTo(3);
}
```

### 过度使用打桩的危害

因为打桩在测试中很容易使用，所以很多时候都会想使用，因为进行真正的调用是非常不容易的。然而，对于需要维护这些测试的工程师而言，过度使用打桩测试会导致生产力的重大损失。

#### 测试变得不清晰

打桩测试需要编写大量额外的代码来定义被测试的函数行为。如果不熟悉被测系统的具体实现，这些额外的代码就很难理解。一个打桩不适合作为测试方法的重要标志是，当你发现你自己看被测系统时，是为了理解为什么某些函数需要被打桩测试，这个时候打桩就不是一个合适的测试方法了。

#### 测试变得脆弱

stubbing将代码的实现细节暴露在测试中。当你的生产代码中的实现细节发生变化时，你需要更新你的测试来反映这些变化。理想情况下，一个好的测试应该只在面向用户的API行为发生改变的时候才需要改变，他应该不收API的实现细节影响。

#### 测试变得低效

对于打桩测试，没有办法确保被打桩测试的方法和真正实现的时候一样的，如下面所示语句的部分硬编码对add()方法（“如果传入1和2，则应该返回3”）；

```java
when(stubCalculator.add(1, 2)).thenReturn(3);
```

如果被测系统依赖于真实实现的内容，那么打桩是一个很糟糕的选择，因为你将被迫重复实现的细节，而且无法保证实现的正确性（例如，被测试的函数和真实的实现一致）
此外，使用打桩没有办法存储状态，这会导致测试代码的某一方面十分困难。例如：如果你在真实或伪造的实现上调用database.save(item),你可以通过调用database.get(item.id())来获得这个item，因为这两个调用在内部都是可访问的，但如果使用stubbing，就无法做到这一点。

#### 过度使用打桩的例子

例13-13. 大量使用打桩

```java
@Test public void creditCardIsCharged() {
 // 模拟框架生成的单元测试
 paymentProcessor =
 new PaymentProcessor(mockCreditCardServer, mockTransactionProcessor);
 // 为这些单元测试生成打桩
 when(mockCreditCardServer.isServerAvailable()).thenReturn(true);
 when(mockTransactionProcessor.beginTransaction()).thenReturn(transaction);
 when(mockCreditCardServer.initTransaction(transaction)).thenReturn(true);
 when(mockCreditCardServer.pay(transaction, creditCard, 500))
 .thenReturn(false);
 when(mockTransactionProcessor.endTransaction()).thenReturn(true);
 // 调用被测系统
 paymentProcessor.processPayment(creditCard, Money.dollars(500));
 // 这里没有办法知道pay()方法是否真正在事务中调用
 // 所以在该测试中唯一可以被验证的只是
 // pay() 方法被调用
 verify(mockCreditCardServer).pay(transaction, creditCard, 500);
}
```

例13-14 重写了上面的测试，但避免使用打桩测试。可以感受到测试的简介以及实现细节（例如交易processor的使用方法）并不暴露在测试中。并不需要特殊的配置，因为credit card server知道如何运行。

例 13-14 重写测试来避免打桩

```java
@Test public void creditCardIsCharged() {
 paymentProcessor =
 new PaymentProcessor(creditCardServer, transactionProcessor);
 // 调用被测系统
 paymentProcessor.processPayment(creditCard, Money.dollars(500));
 // 查看信用卡服务状态来判断交易是否进行
 assertThat(creditCardServer.getMostRecentCharge(creditCard))
 .isEqualTo(500);
}
```

我们显然不希望测试与外部信用卡服务进行交流，所以使用一个虚拟的信用卡服务会更适合。如果不能使用虚拟的，另一个选择是使用一个server的真实实现，与另一个信用卡服务进行交流，虽然这回增加测试的执行时间。（我们将在下一章探讨封装服务）

### 什么情况下适合使用打桩？

打桩并不是真正调用的万能替代物，当你需要在被测系统处于某一状态时，使一个函数返回一个特定值时，打桩时合适的，如例13-12那样，需要被测系统返回一个非空的事务列表。因为函数的行为在测试中被定义，所以打桩可以模拟各种各样的返回值或报错，而这些可能无法在实际运行中被触发。

为了确保测试的目标明确，每个打桩函数应该与测试断言有着直接的联系。因此，一个测试应该仅打桩测试少量的函数，因为打桩大量的函数会导致测试不清晰。一个需要多个打桩测试的函数可以表名，打桩被过多使用，或者被测系统过于复杂，需要被重构。

即使打桩是适合的，真实或者伪造的实现也仍然适用，因为他们不会暴露实现细节并且他们比起打桩更能保证代码的正确性。但打桩是一个合理的技术，当他的使用不会使得代码变得过分复杂时。

## 交互测试

正如本章前面所讨论的，交互测试是一种验证函数如何被调用的方法，而不需要实际调用该函数的实现。
模拟框架使得执行交互测试变得容易。然而，为了保持测试的有用性、可读性和对变化的适应性，重要的是只在必要时进行交互测试。

### 优先选择状态测试而不是交互测试

与交互测试不同，状态测试偏向于通过状态来对代码进行测试。
通过状态测试，你可以调用被测系统，并验证是否返回了正确的值，或者被测系统的其他状态是否被正确改变。例13-15给出了一个状态测试的例子。

例13-15 状态测试

```java
@Test public void sortNumbers() {
 NumberSorter numberSorter = new NumberSorter(quicksort, bubbleSort);
 // 调用被测系统
 List sortedList = numberSorter.sortNumbers(newList(3, 1, 2));
 // 验证返回的list被排序。
 // 并不在意调用了哪种排序算法，只需要返回结果是正确的
 assertThat(sortedList).isEqualTo(newList(1, 2, 3));
}
```

例13-16说明了一个类似的测试场景，但却使用了交互测试。请注意，这个测试不可能确定数字是否真的被排序，因为测试并不知道如何去对数字进行排序--它所能告诉的仅是被测系统视图对数据进行排序。

例13-16 交互测试

```java
@Test public void sortNumbers_quicksortIsUsed() {
 // 通过模拟 framework生成的单元测试
 NumberSorter numberSorter =
 new NumberSorter(mockQuicksort, mockBubbleSort);
 // 调用被测系统
 numberSorter.sortNumbers(newList(3, 1, 2));
 // 验证numberSorter.sortNumbers() 调用 quicksort.
 // 该测试将会失败如果mockQuicksort.sort() 没有被调用 (e.g., 如果
 // mockBubbleSort被调用) 或者他被使用了错误的参数进行调用
 verify(mockQuicksort).sort(newList(3, 1, 2));
}
```

在谷歌，我们发现，强调状态测试更具有可扩展性；它减少了测试的脆性，使之更容易随着时间的推移而改变和维护代码。交互测试的主要问题是，它不能告诉你被测系统是否正常工作；它仅能告诉你验证某些函数的调用是否符合预期。他需要你对代码的行为做出预测，例如，“如果database.save(item)被调用，我们假设这个item会被存储到数据库中”。状态测试更好因为他时间上验证了这个假设（例如，通过将item存储到数据库中，如何查询数据库来验证这个item是否存在）

交互测试的另一个缺点是，他利用了被测系统的实现细节--为了验证一个函数是否被调用，会在测试时调用这个函数。与打桩类似，这些额外的代码，使得测试变得脆弱，因为他在测试中泄露了生产代码的实现细节。谷歌的一些人开玩笑地把过度使用交互测试的测试成为变更检测器测试，因为他们面对生产代码的任何变更都会变得失效，即便被测系统的行为保持不变。

### 什么时候适合用交互测试？

下面是一些有必要使用交互测试的场景：

- 因为不能使用真实或者虚拟的实现（例如真实的实现太慢而家的实现不存在）时，你无法进行状态测试。作为代替选项，你可以进行交互测试来验证某些函数是否被调用。虽然这种实现很不理想，但他确实提供了保证被测系统按预期工作的基本信心。

- 对一个函数的调用次数或顺序不同可能导致一些超出预期的行为。这种时候交互测试是有用的，因为用状态测试很难验证这种行为。例如，如果你希望一个缓存功能减少访问数据库的次数，你可以通过验证一个数据库对象被访问次数没有超过预期。使用Mockito， 代码类似于下面这样：

```java
verify(databaseReader, atMostOnce()).selectRecords();
```

交互测试并不能完全取代状态测试。如果不能够再单元测试中进行状态测试，强烈建议考虑用更大范围的测试来完善你的测试套件。例如，你有一个单元测试同归哦交互测试来验证数据库的使用，考虑添加一个集成测试，可以对真实的数据库进行状态测试。更大范围的测试是降低风险的重要策略，我们将在下一章中讨论。

### 交互测试的最佳实践

在进行交互测试时，遵循这些做法可以减少一些前述缺点的影响。

#### 倾向于只对状态改变的函数进行交互测试

当被测系统在一个依赖关系上调用一个函数时，该调用属于以下两种情况之一：

##### 状态改变

对被测系统之外的部分有影响的功能。例如：sendEmail(), saveRecord(), logAccess()

##### 非状态改变

对被测系统之外的部分没有影响的函数，它们返回关于被测系统之外的信息，并且不修改任何东西。例如： getUser(),findResults(), readFile()
一般来说，应该只对那些改变状态的函数进行交互测试。对非状态改变的函数进行交互测试通常是多余的，因为被测系统将调用函数的返回值用来做其他工作，你可以通过断言来对该值进行判断。交互本身对正确性来说不是一个重要的细节，因为他没有其他的副作用。

对非状态变化的函数进行交互测试会使你的测试变得很脆弱，因为你需要在交互模式发生变化时更新测试。这也使得测试的可读性降低，因为额外的断言使得更难确定哪些断言对于确保代码的正确性是重要的。相比之下，状态改变的交互代表了你的代码为了改变其他地方的状态所做的事情。

例13-17演示了对状态变化和非状态变化函数的交互测试

```java
@Test public void grantUserPermission() {
 UserAuthorizer userAuthorizer =
 new UserAuthorizer(mockUserService, mockPermissionDatabase);
 when(mockPermissionService.getPermission(FAKE_USER)).thenReturn(EMPTY);
 
 // 调用被测系统
 userAuthorizer.grantPermission(USER_ACCESS);
 
 // addPermission() 是state-changing, 所以使用交互测试来验证
 // 是否被调用是更合理的
 verify(mockPermissionDatabase).addPermission(FAKE_USER, USER_ACCESS);
 
 // getPermission() 是non-state-changing,所以这行代码并不需要
 // 交互测试不一定需要：
 // getPermission()在该测试中打桩更重要
 verify(mockPermissionDatabase).getPermission(FAKE_USER);
}
```

#### 避免过度规则化

在第12章，我们讨论了为什么对行为进行测试比对方法进行测试更有效。这意味着一个测试方法应该更注重验证一个方法或类的表现，而不是在一个测试中验证多个行为。
在进行交互测试时，我们应该通过避免过度规定哪些函数和参数需要被验证来达到统一的原则。这能使测试更加的清晰和简洁。这也导致了测试对非测试范围以内的行为改变时，更具有弹性，当改变了一个函数的调用方式时，更少的测试将会失败。
例13-18说明了非规范化的交互测试。该测试的目的是验证用户名是否包含在问候语中，但如果不相关的行为改变之后，这个测试将失败。
例13-18. 过度规范化交互测试

```java
@Test public void displayGreeting_renderUserName() {
 when(mockUserService.getUserName()).thenReturn("Fake User");
 userGreeter.displayGreeting(); // 调用被测系统.
 
 // 如果 setText() 参数被修改，该测试将会失败
 verify(userPrompt).setText("Fake User", "Good morning!", "Version 2.1");
 
 // 如果 setIcon() 方法被调用，测试将会失败, 尽管该方法对测试而言很重要
 // 即使没有验证用户名
 verify(userPrompt).setIcon(IMAGE_SUNSHINE);
}
```

例13-19说明了交互测试在指定相关参数和函数时应该更加谨慎。被测试的行为被分隔成不同的测试，并且每个测试都保证验证最小数量的被测行为是正确的。

例 13-19 精心设计的交互测试

```java
@Test public void displayGreeting_renderUserName() {
 when(mockUserService.getUserName()).thenReturn("Fake User");
 userGreeter.displayGreeting(); // 调用被测方法.
 verify(userPrompter).setText(eq("Fake User"), any(), any());
}
@Test public void displayGreeting_timeIsMorning_useMorningSettings() {
 setTimeOfDay(TIME_MORNING);
 userGreeter.displayGreeting(); // 调用被测方法.
 verify(userPrompt).setText(any(), eq("Good morning!"), any());
 verify(userPrompt).setIcon(IMAGE_SUNSHINE);
}
```

## 结论

我们了解到单元测试对工程开发速度的重要性，因为他们可以帮助对代码进行全面的测试，并确保你的测试快速运行。另一方面，滥用测试会严重领影响生产力，因为他们会导致测试不清晰，效果差。这就是为什么工程师必须了解如何有效的应用测试。

是进行实际实现还是使用单元测试，应该使用哪一种单元测试一直没有一个准确的答案。工程师在决定在实际情形中使用哪种方法比较适合时，需要做一些权衡。

尽管单元测试在解决那些难以在测试中使用的依赖，但如果你想最大限度的提升对代码的自信，在某些时候仍然需要在测试中使用这些依赖。下一章将介绍大范围的测试，将不会在意这些依赖关系的使用是否适用于单元测试；例如，尽管他们很慢或是不确定的。

## TL;DRS

- 真实实现比单元测试更受欢迎
- 如果在测试中真实的实现不能被使用，那么用伪造的实现往往是一个理想的解决方案
- 过度使用打桩测试会导致测试不清晰和脆弱
- 交互测试应该尽可能避免：因为它会暴露被测系统的实现细节而导致测试变得脆弱

