# Chapter 3 Knowledge Sharing #
*Written by Nina Chen and Mark Barolak
Edited by Riona MacNamara*

Your organization understands your problem domain better than some random per‐
son on the internet; your organization should be able to answer most of its own ques‐
tions. To achieve that, you need both experts who know the answers to those
questions and mechanisms to distribute their knowledge, which is what we’ll explore
in this chapter. These mechanisms range from the utterly simple (Ask questions;
Write down what you know) to the much more structured, such as tutorials and
classes. Most importantly, however, your organization needs a culture of learning, and
that requires creating the psychological safety that permits people to admit to a lack
of knowledge.

## Challenges to Learning ##

Sharing expertise across an organization is not an easy task. Without a strong culture
of learning, challenges can emerge. Google has experienced a number of these chal‐
lenges, especially as the company has scaled:

*Lack of psychological safety*

An environment in which people are afraid to take risks or make mistakes in
front of others because they fear being punished for it. This often manifests as a
culture of fear or a tendency to avoid transparency.

*Information islands*

Knowledge fragmentation that occurs in different parts of an organization that
don’t communicate with one another or use shared resources. In such an environment, each group develops its own way of doing things.1 This often leads
to the following:

*Information fragmentation*

Each island has an incomplete picture of the bigger whole.

*Information duplication*

Each island has reinvented its own way of doing something.

*Information skew*

Each island has its own ways of doing the same thing, and these might or might not conflict.

*Single point of failure (SPOF)*

A bottleneck that occurs when critical information is available from only a single person. This is related to bus factor, which is discussed in more detail in Chapter 2.
SPOFs can arise out of good intentions: it can be easy to fall into a habit of “Let
me take care of that for you.” But this approach optimizes for short-term efficiency (“It’s faster for me to do it”) at the cost of poor long-term scalability (the team never learns how to do whatever it is that needs to be done). This mindset also tends to lead to all-or-nothing expertise.

*All-or-nothing expertise*

A group of people that is split between people who know “everything” and novices, with little middle ground. This problem often reinforces itself if experts
always do everything themselves and don’t take the time to develop new experts through mentoring or documentation. In this scenario, knowledge and responsibilities continue to accumulate on those who already have expertise, and new team members or novices are left to fend for themselves and ramp up more slowly.

*Parroting*

Mimicry without understanding. This is typically characterized by mindlessly copying patterns or code without understanding their purpose, often under the
assumption that said code is needed for unknown reasons.

*Haunted graveyards*

Places, often in code, that people avoid touching or changing because they are afraid that something might go wrong. Unlike the aforementioned parroting,haunted graveyards are characterized by people avoiding action because of fear and superstition.

In the rest of this chapter, we dive into strategies that Google’s engineering organizations have found to be successful in addressing these challenges.

## Philosophy ##

Software engineering can be defined as the multiperson development of multiversion programs.2 People are at the core of software engineering: code is an important output but only a small part of building a product. Crucially, code does not emerge spontaneously out of nothing, and neither does expertise. Every expert was once a novice:
an organization’s success depends on growing and investing in its people.
Personalized, one-to-one advice from an expert is always invaluable. Different team members have different areas of expertise, and so the best teammate to ask for any given question will vary. But if the expert goes on vacation or switches teams, the team can be left in the lurch. And although one person might be able to provide personalized help for one-to-many, this doesn’t scale and is limited to small numbers of “many.”
Documented knowledge, on the other hand, can better scale not just to the team but to the entire organization. Mechanisms such as a team wiki enable many authors to share their expertise with a larger group. But even though written documentation is
more scalable than one-to-one conversations, that scalability comes with some tradeoffs: it might be more generalized and less applicable to individual learners’ situations, and it comes with the added maintenance cost required to keep information
relevant and up to date over time.
Tribal knowledge exists in the gap between what individual team members know and what is documented. Human experts know these things that aren’t written down. If we document that knowledge and maintain it, it is now available not only to somebody with direct one-to-one access to the expert today, but to anybody who can find and view the documentation.
So in a magical world in which everything is always perfectly and immediately documented, we wouldn’t need to consult a person any more, right? Not quite. Written
knowledge has scaling advantages, but so does targeted human help. A human expert can synthesize their expanse of knowledge. They can assess what information is applicable to the individual’s use case, determine whether the documentation is still relevant, and know where to find it. Or, if they don’t know where to find the answers,they might know who does.

Tribal and written knowledge complement each other. Even a perfectly expert team with perfect documentation needs to communicate with one another, coordinate with other teams, and adapt their strategies over time. No single knowledge-sharing
approach is the correct solution for all types of learning, and the particulars of a good mix will likely vary based on your organization. Institutional knowledge evolves over time, and the knowledge-sharing methods that work best for your organization will
likely change as it grows. Train, focus on learning and growth, and build your own stable of experts: there is no such thing as too much engineering expertise.

## Setting the Stage: Psychological Safety

Psychological safety is critical to promoting a learning environment.
To learn, you must first acknowledge that there are things you don’t understand. We should welcome such honesty rather than punish it. (Google does this pretty well, but sometimes engineers are reluctant to admit they don’t understand something.)
An enormous part of learning is being able to try things and feeling safe to fail. In a healthy environment, people feel comfortable asking questions, being wrong, and learning new things. This is a baseline expectation for all Google teams; indeed, our research has shown that psychological safety is the most important part of an effective team.

## Mentorship


At Google, we try to set the tone as soon as a “Noogler” (new Googler) engineer joins the company. One important way of building psychological safety is to assign Nooglers a mentor—someone who is not their team member, manager, or tech leadwhose responsibilities explicitly include answering questions and helping the Noogler ramp up. Having an officially assigned mentor to ask for help makes it easier for the newcomer and means that they don’t need to worry about taking up too much of their coworkers’ time.
A mentor is a volunteer who has been at Google for more than a year and who is available to advise on anything from using Google infrastructure to navigating Google culture. Crucially, the mentor is there to be a safety net to talk to if the mentee
doesn’t know whom else to ask for advice. This mentor is not on the same team as the mentee, which can make the mentee feel more comfortable about asking for help in tricky situations.
Mentorship formalizes and facilitates learning, but learning itself is an ongoing process. There will always be opportunities for coworkers to learn from one another,whether it’s a new employee joining the organization or an experienced engineer learning a new technology. With a healthy team, teammates will be open not just to answering but also to asking questions: showing that they don’t know something and learning from one another.

## Psychological Safety in Large Groups

Asking a nearby teammate for help is easier than approaching a large group of mostly strangers. But as we’ve seen, one-to-one solutions don’t scale well. Group solutions
are more scalable, but they are also scarier. It can be intimidating for novices to form a question and ask it of a large group, knowing that their question might be archived
for many years. The need for psychological safety is amplified in large groups. Every member of the group has a role to play in creating and maintaining a safe environ‐
ment that ensures that newcomers are confident asking questions and up-andcoming experts feel empowered to help those newcomers without the fear of having their answers attacked by established experts.
The most important way to achieve this safe and welcoming environment is for group interactions to be cooperative, not adversarial. Table 3-1 lists some examples of recommended patterns (and their corresponding antipatterns) of group interactions.

These antipatterns can emerge unintentionally: someone might be trying to be helpful but is accidentally condescending and unwelcoming. We find the Recurse Center’s
social rules to be helpful here:

*No feigned surprise (“What?! I can’t believe you don’t know what the stack is!”)*

Feigned surprise is a barrier to psychological safety and makes members of the group afraid of admitting to a lack of knowledge.

*No “well-actuallys”*

Pedantic corrections that tend to be about grandstanding rather than precision.

*No back-seat driving*

Interrupting an existing discussion to offer opinions without committing to the conversation.

*No subtle “-isms” (“It’s so easy my grandmother could do it!”)*

Small expressions of bias (racism, ageism, homophobia) that can make individuals feel unwelcome, disrespected, or unsafe

## Growing Your Knowledge

Knowledge sharing starts with yourself. It is important to recognize that you always have something to learn. The following guidelines allow you to augment your own
personal knowledge.

## Ask Questions

If you take away only a single thing from this chapter, it is this: always be learning;always be asking questions.

We tell Nooglers that ramping up can take around six months. This extended period is necessary to ramp up on Google’s large, complex infrastructure, but it also reinforces the idea that learning is an ongoing, iterative process. One of the biggest mistakes that beginners make is not to ask for help when they’re stuck. You might be tempted
to struggle through it alone or feel fearful that your questions are “too simple.” “I just need to try harder before I ask anyone for help,” you think. Don’t fall into this trap!Your coworkers are often the best source of information: leverage this valuable resource.

There is no magical day when you suddenly always know exactly what to do in every situation—there’s always more to learn. Engineers who have been at Google for years
still have areas in which they don’t feel like they know what they are doing, and that’s OK! Don’t be afraid to say “I don’t know what that is; could you explain it?” Embrace
not knowing things as an area of opportunity rather than one to fear

It doesn’t matter whether you’re new to a team or a senior leader: you should always be in an environment in which there’s something to learn. If not, you stagnate (and
should find a new environment).

It’s especially critical for those in leadership roles to model this behavior: it’s important not to mistakenly equate “seniority” with “knowing everything.” In fact, the more you know, the more you know you don’t know. Openly asking questions4 or expressing gaps in knowledge reinforces that it’s OK for others to do the same.
 
On the receiving end, patience and kindness when answering questions fosters an environment in which people feel safe looking for help. Making it easier to overcome the initial hesitation to ask a question sets the tone early: reach out to solicit questions, and make it easy for even “trivial” questions to get an answer. Although engineers could probably figure out tribal knowledge on their own, they’re not here to work in a vacuum. Targeted help allows engineers to be productive faster, which it turn makes their entire team more productive.

## Understand Context

Learning is not just about understanding new things; it also includes developing an understanding of the decisions behind the design and implementation of existing things. Suppose that your team inherits a legacy codebase for a critical piece of infrastructure that has existed for many years. The original authors are long gone, and the code is difficult to understand. It can be tempting to rewrite from scratch rather than spend time learning the existing code. But instead of thinking “I don’t get it” and ending your thoughts there, dive deeper: what questions should you be asking?

Consider the principle of “Chesterson’s fence”: before removing or changing something, first understand why it’s there.

In the matter of reforming things, as distinct from deforming them, there is one plain and simple principle; a principle which will probably be called a paradox. There exists in such a case a certain institution or law; let us say, for the sake of simplicity, a fence or gate erected across a road. The more modern type of reformer goes gaily up to it and says, “I don’t see the use of this; let us clear it away.” To which the more intelligent type of reformer will do well to answer: “If you don’t see the use of it, I certainly won’t let you clear it away. Go away and think. Then, when you can come back and tell me that you do see the use of it, I may allow you to destroy it.”

This doesn’t mean that code can’t lack clarity or that existing design patterns can’t be wrong, but engineers have a tendency to reach for “this is bad!” far more quickly than
is often warranted, especially for unfamiliar code, languages, or paradigms. Google is not immune to this. Seek out and understand context, especially for decisions that
seem unusual. After you’ve understood the context and purpose of the code, consider whether your change still makes sense. If it does, go ahead and make it; if it doesn’t,document your reasoning for future readers.

Many Google style guides explicitly include context to help readers understand the rationale behind the style guidelines instead of just memorizing a list of arbitrary
rules. More subtly, understanding the rationale behind a given guideline allows authors to make informed decisions about when the guideline shouldn’t apply or whether the guideline needs updating. See Chapter 8.

## Scaling Your Questions: Ask the Community
Getting one-to-one help is high bandwidth but necessarily limited in scale. And as a learner, it can be difficult to remember every detail. Do your future self a favor: when
you learn something from a one-to-one discussion, write it down.

Chances are that future newcomers will have the same questions you had. Do them a favor, too, and share what you write down.

Although sharing the answers you receive can be useful, it’s also beneficial to seek help not from individuals but from the greater community. In this section, we examine different forms of community-based learning. Each of these approaches—group chats, mailing lists, and question-and-answer systems—have different trade-offs and
complement one another. But each of them enables the knowledge seeker to get help from a broader community of peers and experts and also ensures that answers are broadly available to current and future members of that community.

## Group Chats

When you have a question, it can sometimes be difficult to get help from the right person. Maybe you’re not sure who knows the answer, or the person you want to ask is busy. In these situations, group chats are great, because you can ask your question to many people at once and have a quick back-and-forth conversation with whoever is available. As a bonus, other members of the group chat can learn from the question and answer, and many forms of group chat can be automatically archived and searched later.

Group chats tend to be devoted either to topics or to teams. Topic-driven group chats are typically open so that anyone can drop in to ask a question. They tend to attract
experts and can grow quite large, so questions are usually answered quickly. Teamoriented chats, on the other hand, tend to be smaller and restrict membership. As a result, they might not have the same reach as a topic-driven chat, but their smaller size can feel safer to a newcomer.
Although group chats are great for quick questions, they don’t provide much structure, which can make it difficult to extract meaningful information from a conversation in which you’re not actively involved. As soon as you need to share information outside of the group, or make it available to refer back to later, you should write a document or email a mailing list.

## Mailing Lists

Most topics at Google have a topic-users@ or topic-discuss@ Google Groups mailing list that anyone at the company can join or email. Asking a question on a public mailing list is a lot like asking a group chat: the question reaches a lot of people who could potentially answer it and anyone following the list can learn from the answer. Unlike group chats, though, public mailing lists are easy to share with a wider audience: they are packaged into searchable archives, and email threads provide more structure than group chats. At Google, mailing lists are also indexed and can be discovered by Moma, Google’s intranet search engine.

When you find an answer to a question you asked on a mailing list, it can be tempting to get on with your work. Don’t do it! You never know when someone will need the same information in the future, so it’s a best practice to post the answer back to the list.

Mailing lists are not without their trade-offs. They’re well suited for complicated questions that require a lot of context, but they’re clumsy for the quick back-andforth exchanges at which group chats excel. A thread about a particular problem is generally most useful while it is active. Email archives are immutable, and it can be hard to determine whether an answer discovered in an old discussion thread is still relevant to a present-day situation.

Additionally, the signal-to-noise ratio can be lower than other mediums like formal documentation because the problem that someone is having with their specific workflow might not be applicable to you.
## Email at Google
Google culture is infamously email-centric and email-heavy. Google engineers receive hundreds of emails (if not more) each day, with varying degrees of actionability. Nooglers can spend days just setting up email filters to deal with the volume of notifications coming from groups that they’ve been autosubscribed to; some people just give up and don’t try to keep up with the flow. Some groups CC large mailing lists onto every discussion by default, without trying to target information to those who are likely to be specifically interested in it; as a result, the signal-to-noise ratio can be a real problem.


Google tends toward email-based workflows by default. This isn’t necessarily because email is a better medium than other communications options—it often isn’t—rather, it’s because that’s what our culture is accustomed to. Keep this in mind as your organization considers what forms of communication to encourage or invest in.

## YAQS: Question-and-Answer Platform

YAQS (“Yet Another Question System”) is a Google-internal version of a Stack Overflow–like website, making it easy for Googlers to link to existing or work-in-progress
code as well as discuss confidential information.


Like Stack Overflow, YAQS shares many of the same advantages of mailing lists and adds refinements: answers marked as helpful are promoted in the user interface, and users can edit questions and answers so that they remain accurate and useful as code and facts change. As a result, some mailing lists have been superseded by YAQS,whereas others have evolved into more general discussion lists that are less focused on problem solving.