### Documentation Types 

Engineers write various different types of documentation as part of their work: design documents, code comments, how-to documents, project pages, and more. These all count as “documentation.” But it is important to know the different types, and to not mix types. A document should have, in general, a singular purpose, and stick to it. Just as an API should do one thing and do it well, avoid trying to do several things within one document. Instead, break out those pieces more logically. There are several main types of documents that software engineers often need to write: 

• Reference documentation, including code comments 

• Design documents 

• Tutorials 

• Conceptual documentation 

• Landing pages

 It was common in the early days of Google for teams to have monolithic wiki pages with bunches of links (many broken or obsolete), some conceptual information about how the system worked, an API reference, and so on, all sprinkled together. Such documents fail because they don’t serve a single purpose (and they also get so long that no one will read them; some notorious wiki pages scrolled through several doz‐ ens of screens). Instead, make sure your document has a singular purpose, and if adding something to that page doesn’t make sense, you probably want to find, or even create, another document for that purpose.

### Reference Documentation

Reference documentation is the most common type that engineers need to write; indeed, they often need to write some form of reference documents every day. By ref‐ erence documentation, we mean anything that documents the usage of code within the codebase. Code comments are the most common form of reference documenta‐ tion that an engineer must maintain. Such comments can be divided into two basic camps: API comments versus implementation comments. Remember the audience differences between these two: API comments don’t need to discuss implementation details or design decisions and can’t assume a user is as versed in the API as the author. Implementation comments, on the other hand, can assume a lot more domain knowledge of the reader, though be careful in assuming too much: people leave projects, and sometimes it’s safer to be methodical about exactly why you wrote this code the way you did. 

Most reference documentation, even when provided as separate documentation from the code, is generated from comments within the codebase itself. (As it should; refer‐ ence documentation should be single-sourced as much as possible.) Some languages such as Java or Python have specific commenting frameworks (Javadoc, PyDoc, GoDoc) meant to make generation of this reference documentation easier. Other lan‐ guages, such as C++, have no standard “reference documentation” implementation, but because C++ separates out its API surface (in header or .h files) from the imple‐ mentation (.cc files), header files are often a natural place to document a C++ API. 

Google takes this approach: a C++ API deserves to have its reference documentation live within the header file. Other reference documentation is embedded directly in the Java, Python, and Go source code as well. Because Google’s Code Search browser (see Chapter 17) is so robust, we’ve found little benefit to providing separate gener‐ ated reference documentation. Users in Code Search not only search code easily, they can usually find the original definition of that code as the top result. Having the doc‐ umentation alongside the code’s definitions also makes the documentation easier to discover and maintain. 

We all know that code comments are essential to a well-documented API. But what precisely is a “good” comment? Earlier in this chapter, we identified two major audiences for reference documentation: seekers and stumblers. Seekers know what they want; stumblers don’t. The key win for seekers is a consistently commented codebase so that they can quickly scan an API and find what they are looking for. The key win for stumblers is clearly identifying the purpose of an API, often at the top of a fileheader. We’ll walk through some code comments in the subsections that follow. The code commenting guidelines that follow apply to C++, but similar rules are in place at Google for other languages.



File comments

Almost all code files at Google must contain a file comment. (Some header files that contain only one utility function, etc., might deviate from this standard.) File com‐ ments should begin with a header of the following form: 

// -----------------------------------------------------------------------------

// str_cat.h 

// ----------------------------------------------------------------------------- 

// 

// This header file contains functions for efficiently concatenating and appending 

// strings: StrCat() and StrAppend(). Most of the work within these routines is 

// actually handled through use of a special AlphaNum type, which was designed 

// to be used as a parameter type that efficiently manages conversion to

 // strings and avoids copies in the above operations.

… 

Generally, a file comment should begin with an outline of what’s contained in the code you are reading. It should identify the code’s main use cases and intended audi‐ ence (in the preceding case, developers who want to concatenate strings). Any API that cannot be succinctly described in the first paragraph or two is usually the sign of an API that is not well thought out. Consider breaking the API into separate compo‐ nents in those cases.



Class comments 

Most modern programming languages are object oriented. Class comments are there‐ fore important for defining the API “objects” in use in a codebase. All public classes (and structs) at Google must contain a class comment describing the class/struct, important methods of that class, and the purpose of the class. Generally, class com‐ ments should be “nouned” with documentation emphasizing their object aspect. That is, say, “The Foo class contains x, y, z, allows you to do Bar, and has the following Baz aspects,” and so on. 

Class comments should generally begin with a comment of the following form:

// ----------------------------------------------------------------------------- 

// AlphaNum

// ----------------------------------------------------------------------------- 

// 

// The AlphaNum class acts as the main parameter type for StrCat() and 

// StrAppend(), providing efficient conversion of numeric, boolean, and 

// hexadecimal values (through the Hex type) into strings.



Function comments 

All free functions, or public methods of a class, at Google must also contain a func‐ tion comment describing what the function does. Function comments should stress the active nature of their use, beginning with an indicative verb describing what the function does and what is returned. 

Function comments should generally begin with a comment of the following form: 

// StrCat() 

// 

// Merges the given strings or numbers, using no delimiter(s),

// returning the merged result as a string. 

… 

Note that starting a function comment with a declarative verb introduces consistency across a header file. A seeker can quickly scan an API and read just the verb to get an idea of whether the function is appropriate: “Merges, Deletes, Creates,” and so on. 

Some documentation styles (and some documentation generators) require various forms of boilerplate on function comments, like “Returns:”, “Throws:”, and so forth, but at Google we haven’t found them to be necessary. It is often clearer to present such information in a single prose comment that’s not broken up into artificial sec‐ tion boundaries: 

// Creates a new record for a customer with the given name and address,

 // and returns the record ID, or throws `DuplicateEntryError` if a

// record with that name already exists. 

int AddCustomer(string name, string address); 

Notice how the postcondition, parameters, return value, and exceptional cases are naturally documented together (in this case, in a single sentence), because they are not independent of one another. Adding explicit boilerplate sections would make the comment more verbose and repetitive, but no clearer (and arguably less clear). 



Design Docs 

Most teams at Google require an approved design document before starting work on any major project. A software engineer typically writes the proposed design docu‐ ment using a specific design doc template approved by the team. Such documents are designed to be collaborative, so they are often shared in Google Docs, which has good collaboration tools. Some teams require such design documents to be discussed and debated at specific team meetings, where the finer points of the design can be dis‐ cussed or critiqued by experts. In some respects, these design discussions act as a form of code review before any code is written. 

Because the development of a design document is one of the first processes an engi‐ neer undertakes before deploying a new system, it is also a convenient place to ensure that various concerns are covered. The canonical design document templates at Goo‐ gle require engineers to consider aspects of their design such as security implications, internationalization, storage requirements and privacy concerns, and so on. In most cases, such parts of those design documents are reviewed by experts in those domains.

A good design document should cover the goals of the design, its implementation strategy, and propose key design decisions with an emphasis on their individual trade-offs. The best design documents suggest design goals and cover alternative designs, denoting their strong and weak points.

 A good design document, once approved, also acts not only as a historical record, but as a measure of whether the project successfully achieved its goals. Most teams archive their design documents in an appropriate location within their team docu‐ ments so that they can review them at a later time. It’s often useful to review a design document before a product is launched to ensure that the stated goals when the design document was written remain the stated goals at launch (and if they do not, either the document or the product can be adjusted accordingly).



Tutorials 

Every software engineer, when they join a new team, will want to get up to speed as quickly as possible. Having a tutorial that walks someone through the setup of a new project is invaluable; “Hello World” has established itself is one of the best ways to ensure that all team members start off on the right foot. This goes for documents as well as code. Most projects deserve a “Hello World” document that assumes nothing and gets the engineer to make something “real” happen. 

Often, the best time to write a tutorial, if one does not yet exist, is when you first join a team. (It’s also the best time to find bugs in any existing tutorial you are following.) Get a notepad or other way to take notes, and write down everything you need to do along the way, assuming no domain knowledge or special setup constraints; after you’re done, you’ll likely know what mistakes you made during the process—and why —and can then edit down your steps to get a more streamlined tutorial. Importantly, write everything you need to do along the way; try not to assume any particular setup, permissions, or domain knowledge. If you do need to assume some other setup, state that clearly in the beginning of the tutorial as a set of prerequisites. 

Most tutorials require you to perform a number of steps, in order. In those cases, number those steps explicitly. If the focus of the tutorial is on the user (say, for exter‐ nal developer documentation), then number each action that a user needs to under‐ take. Don’t number actions that the system may take in response to such user actions.  It is critical and important to number explicitly every step when doing this. Nothing is more annoying than an error on step 4 because you forget to tell someone to prop‐ erly authorize their username, for example.



Example: A bad tutorial 

1. Download the package from our server at http://example.com 
2. Copy the shell script to your home directory 
3. Execute the shell script 

4. The foobar system will communicate with the authentication system 
5. Once authenticated, foobar will bootstrap a new database named “baz”
6. Test “baz” by executing a SQL command on the command line 
7. Type: CREATE DATABASE my_foobar_db; 

In the preceding procedure, steps 4 and 5 happen on the server end. It’s unclear whether the user needs to do anything, but they don’t, so those side effects can be mentioned as part of step 3. As well, it’s unclear whether step 6 and step 7 are differ‐ ent. (They aren’t.) Combine all atomic user operations into single steps so that the user knows they need to do something at each step in the process. Also, if your tuto‐ rial has user-visible input or output, denote that on separate lines (often using the convention of a monospaced bold font).

 Example: A bad tutorial made better 

 1. Download the package from our server at http://example.com:

    $ curl -I http://example.com 

 2.  Copy the shell script to your home directory:

     $ cp foobar.sh ~ 

 3.  Execute the shell script in your home directory: 

    $ cd ~; foobar.sh The foobar system will first communicate with the authentication system. Once authenticated, foobar will bootstrap a new database named “baz” and open an input shell. 

 4.  Test “baz” by executing a SQL command on the command line: baz:

    $ CREATE DATABASE my_foobar_db; 

Note how each step requires specific user intervention. If, instead, the tutorial had a focus on some other aspect (e.g., a document about the “life of a server”), number those steps from the perspective of that focus (what the server does).

Conceptual Documentation 

Some code requires deeper explanations or insights than can be obtained simply by reading the reference documentation. In those cases, we need conceptual documenta‐ tion to provide overviews of the APIs or systems. Some examples of conceptual docu‐ mentation might be a library overview for a popular API, a document describing the life cycle of data within a server, and so on. In almost all cases, a conceptual docu‐ ment is meant to augment, not replace, a reference documentation set. Often this leads to duplication of some information, but with a purpose: to promote clarity. In those cases, it is not necessary for a conceptual document to cover all edge cases (though a reference should cover those cases religiously). In this case, sacrificing some accuracy is acceptable for clarity. The main point of a conceptual document is to impart understanding. 

“Concept” documents are the most difficult forms of documentation to write. As a result, they are often the most neglected type of document within a software engi‐ neer’s toolbox. One problem engineers face when writing conceptual documentation is that it often cannot be embedded directly within the source code because there isn’t a canonical location to place it. Some APIs have a relatively broad API surface area, in which case, a file comment might be an appropriate place for a “conceptual” explana‐ tion of the API. But often, an API works in conjunction with other APIs and/or mod‐ ules. The only logical place to document such complex behavior is through a separate conceptual document. If comments are the unit tests of documentation, conceptual documents are the integration tests. 

Even when an API is appropriately scoped, it often makes sense to provide a separate conceptual document. For example, Abseil’s StrFormat library covers a variety of concepts that accomplished users of the API should understand. In those cases, both internally and externally, we provide a format concepts document. 

A concept document needs to be useful to a broad audience: both experts and novices alike. Moreover, it needs to emphasize clarity, so it often needs to sacrifice complete‐ ness (something best reserved for a reference) and (sometimes) strict accuracy. That’s not to say a conceptual document should intentionally be inaccurate; it just means that it should focus on common usage and leave rare usages or side effects for refer‐ ence documentation.

Landing Pages 

Most engineers are members of a team, and most teams have a “team page” some‐ where on their company’s intranet. Often, these sites are a bit of a mess: a typical landing page might contain some interesting links, sometimes several documents titled “read this first!”, and some information both for the team and for its customers. Such documents start out useful but rapidly turn into disasters; because they become so cumbersome to maintain, they will eventually get so obsolete that they will be fixed by only the brave or the desperate. 

Luckily, such documents look intimidating, but are actually straightforward to fix: ensure that a landing page clearly identifies its purpose, and then include only links to other pages for more information. If something on a landing page is doing more than being a traffic cop, it is not doing its job. If you have a separate setup document, link to that from the landing page as a separate document. If you have too many links on the landing page (your page should not scroll multiple screens), consider breaking up the pages by taxonomy, under different sections. 

Most poorly configured landing pages serve two different purposes: they are the “goto” page for someone who is a user of your product or API, or they are the home page for a team. Don’t have the page serve both masters—it will become confusing. Create a separate “team page” as an internal page apart from the main landing page. What the team needs to know is often quite different than what a customer of your API needs to know.

