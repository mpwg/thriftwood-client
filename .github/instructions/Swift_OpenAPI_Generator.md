<!--
Downloaded via https://llm.codes by @steipete on October 1, 2025 at 08:02 PM
Source URL: https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator
Total pages processed: 29
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator

# Swift OpenAPI Generator

Generate Swift client and server code from an OpenAPI document.

## Overview

OpenAPI is a specification for documenting HTTP services. An OpenAPI document is written in either YAML or JSON, and can be read by tools to help automate workflows, such as generating the necessary code to send and receive HTTP requests.

Swift OpenAPI Generator is a Swift package plugin that can generate the ceremony code required to make API calls, or implement API servers.

The code is generated at build-time, so it’s always in sync with the OpenAPI document and doesn’t need to be committed to your source repository.

## Features

- Works with OpenAPI Specification versions 3.0 and 3.1.

- Streaming request and response bodies enabling use cases such as JSON event streams, and large payloads without buffering.

- Support for JSON, multipart, URL-encoded form, base64, plain text, and raw bytes, represented as value types with type-safe properties.

- Client, server, and middleware abstractions, decoupling the generated code from the HTTP client library and web framework.

To see these features in action, see Checking out an example project.

## Usage

Swift OpenAPI Generator can be used to generate API clients and server stubs.

Below you can see some example code, or you can follow one of the Working with Swift OpenAPI Generator tutorials.

### Using a generated API client

The generated `Client` type provides a method for each HTTP operation defined in the OpenAPI document and can be used with any HTTP library that provides an implementation of `ClientTransport`.

import OpenAPIURLSession
import Foundation

let client = Client(
serverURL: URL(string: "http://localhost:8080/api")!,
transport: URLSessionTransport()
)
let response = try await client.getGreeting()
print(try response.ok.body.json.message)

### Using generated API server stubs

To implement a server, define a type that conforms to the generated `APIProtocol`, providing a method for each HTTP operation defined in the OpenAPI document.

The server can be used with any web framework that provides an implementation of `ServerTransport`, which allows you to register your API handlers with the HTTP server.

import OpenAPIRuntime
import OpenAPIVapor
import Vapor

struct Handler: APIProtocol {

let name = input.query.name ?? "Stranger"
return .ok(.init(body: .json(.init(message: "Hello, \(name)!"))))
}
}

@main struct HelloWorldVaporServer {
static func main() async throws {
let app = try await Application.make()
let transport = VaporTransport(routesBuilder: app)
let handler = Handler()
try handler.registerHandlers(on: transport, serverURL: URL(string: "/api")!)
try await app.execute()
}
}

### Package ecosystem

The Swift OpenAPI Generator project is split across multiple repositories to enable extensibility and minimize dependencies in your project.

| Repository | Description |
| --- | --- |
| apple/swift-openapi-generator | Swift package plugin and CLI |
| apple/swift-openapi-runtime | Runtime library used by the generated code |
| apple/swift-openapi-urlsession | `ClientTransport` using URLSession |
| swift-server/swift-openapi-async-http-client | `ClientTransport` using AsyncHTTPClient |
| swift-server/swift-openapi-vapor | `ServerTransport` using Vapor |
| swift-server/swift-openapi-hummingbird | `ServerTransport` using Hummingbird |
| swift-server/swift-openapi-lambda | `ServerTransport` using AWS Lambda |

### Requirements and supported features

| Generator versions | Supported OpenAPI versions | Minimum Swift version |
| --- | --- | --- |
| `1.0.0` … `main` | 3.0, 3.1 | 5.9 |

See also Supported OpenAPI features.

### Supported platforms and minimum versions

The generator is used during development and is supported on macOS and Linux.

The generated code, runtime library, and transports are supported on more platforms, listed below.

| Component | macOS | Linux | iOS | tvOS | watchOS | visionOS |
| --- | --- | --- | --- | --- | --- | --- |
| Generator plugin and CLI | ✅ 10.15+ | ✅ | ✖️ | ✖️ | ✖️ | ✖️ |
| Generated code and runtime library | ✅ 10.15+ | ✅ | ✅ 13+ | ✅ 13+ | ✅ 6+ | ✅ 1+ |

### Documentation and example projects

To get started, check out the topics below, or one of the Working with Swift OpenAPI Generator tutorials.

You can also experiment with one of the examples in Checking out an example project that use Swift OpenAPI Generator and integrate with other packages in the ecosystem.

Or if you prefer to watch a video, check out Meet Swift OpenAPI Generator from WWDC23.

### Example OpenAPI document

openapi: '3.1.0'
info:
title: GreetingService
version: 1.0.0
servers:
- url:
description: Example service deployment.
paths:
/greet:
get:
operationId: getGreeting
parameters:
- name: name
required: false
in: query
description: The name used in the returned greeting.
schema:
type: string
responses:
'200':
description: A success response with a greeting.
content:
application/json:
schema:
$ref: '#/components/schemas/Greeting'
components:
schemas:
Greeting:
type: object
description: A value with the greeting contents.
properties:
message:
type: string
description: The string representation of the greeting.
required:
- message

## Topics

### Essentials

Checking out an example project

Check out a working example to learn how packages using Swift OpenAPI Generator can be structured and integrated with the ecosystem.

Generating a client in a Swift package

This tutorial guides you through building _GreetingServiceClient_—an API client for a fictitious service that returns a personalized greeting.

Generating a client in an Xcode project

Generating server stubs in a Swift package

This tutorial guides you through building _GreetingService_—an API server for a fictitious service that returns a personalized greeting.

### OpenAPI

Exploring an OpenAPI document

This tutorial covers the basics of the OpenAPI specification and guides you through writing an OpenAPI document that describes a service API. We’ll use a fictitious service that returns a personalized greeting.

Adding OpenAPI and Swagger UI endpoints

One of the most popular ways to share your OpenAPI document with your users is to host it alongside your API server itself.

Practicing spec-driven API development

Design, iterate on, and generate both client and server code from your hand-written OpenAPI document.

Useful OpenAPI patterns

Explore OpenAPI patterns for common data representations.

Supported OpenAPI features

Learn which OpenAPI features are supported by Swift OpenAPI Generator.

### Generator plugin and CLI

Configuring the generator

Create a configuration file to control the behavior of the generator.

Manually invoking the generator CLI

Manually invoke the command-line tool to generate code as an alternative to the Swift package build plugin.

Frequently asked questions

Review some frequently asked questions below.

### API stability

API stability of the generator

Understand the impact of updating the generator package plugin on the generated Swift code.

API stability of generated code

Understand the impact of changes to the OpenAPI document on generated Swift code.

### Getting involved

Project scope and goals

Learn about what is in and out of scope of Swift OpenAPI Generator.

Contributing to Swift OpenAPI Generator

Help improve Swift OpenAPI Generator by implementing a missing feature or fixing a bug.

Collaborate on API changes to Swift OpenAPI Generator by writing a proposal.

Learn about the internals of Swift OpenAPI Generator.

- Swift OpenAPI Generator
- Overview
- Features
- Usage
- Using a generated API client
- Using generated API server stubs
- Package ecosystem
- Requirements and supported features
- Supported platforms and minimum versions
- Documentation and example projects
- Example OpenAPI document
- Topics

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/frequently-asked-questions

- Swift OpenAPI Generator
- Frequently asked questions

Article

# Frequently asked questions

Review some frequently asked questions below.

## Overview

This article includes some commonly asked questions and answers.

### How do I \_\_ in OpenAPI?

- Review the official OpenAPI specification.

- Check out the OpenAPI Guide.

- Learn how to achieve common patterns with OpenAPI and Swift OpenAPI Generator at Useful OpenAPI patterns.

### Why doesn’t the generator have feature \_\_?

Check out Project scope and goals.

### What OpenAPI features does the generator support?

Check out Supported OpenAPI features.

### Which underlying HTTP library does the generated code use?

Swift OpenAPI Generator is not tied to any particular HTTP library. Instead, the generated code utilizes a general protocol called `ClientTransport` for client code, and `ServerTransport` for server code.

The user of the generated code provides one of the concrete transport implementations, based on what’s appropriate for their use case.

Swift OpenAPI Generator lists some transport implementations in its README, but anyone is welcome to create their own custom transport implementation and share it as a package with the community.

To learn more, check out Getting started, which shows how to use some of the transport implementations.

### How do I customize the HTTP requests and responses?

If the code generated from the OpenAPI document, combined with the concrete transport implementation, doesn’t behave exactly as you need, you can provide a _middleware_ type that can inspect and modify the HTTP requests and responses that are passed between the generated code and the transport.

Just like with transports, there are two types, `ClientMiddleware` and `ServerMiddleware`.

To learn more, check out Middleware examples.

### Do I commit the generated code to my source repository?

It depends on the way you’re integrating Swift OpenAPI Generator.

The recommended way is to use the Swift package plugin, and let the build system generate the code on-demand, without the need to check it into your git repository.

However, if you require to check your generated code into git, you can use the command plugin, or manually invoke the command-line tool.

For details, check out Manually invoking the generator CLI.

### Does regenerating code from an updated OpenAPI document overwrite any of my code?

Swift OpenAPI Generator was designed for a workflow called spec-driven development (check out Practicing spec-driven API development for details). That means that it is expected that the OpenAPI document changes frequently, and no developer-written code is overwritten when the Swift code is regenerated from the OpenAPI document.

When run in `client` mode, the generator emits a type called `Client` that conforms to a generated protocol called `APIProtocol`, which defines one method per OpenAPI operation. Client code generation provides you with a concrete implementation that makes HTTP requests over a provided transport. From your code, you _use_ the `Client` type, so when it gets updated, unless the OpenAPI document removed API you’re using, you don’t need to make any changes to your code.

When run in `server` mode, the generator emits the same `APIProtocol` protocol, and you implement a type that conforms to it, providing one method per OpenAPI operation. The other server generated code takes care of registering the generated routes on the underlying server. That means that when a new operation is added to the OpenAPI document, you get a build error telling you that your custom type needs to implement the new method to conform to `APIProtocol` again, guiding you towards writing code that complies with your OpenAPI document. However, none of your hand-written code is overwritten.

To learn about the different ways of integrating Swift OpenAPI Generator, check out Manually invoking the generator CLI.

### How do I fix the build error “Decl has a package access level but no -package-name was passed”?

The build error `Decl has a package access level but no -package-name was passed` appears when the package or project is not configured with the `package` access level feature yet.

The cause of this error is that the generated code is using the `package` access modifier for its API, but the project or package are not passing the `-package-name` option to the Swift compiler yet.

For Swift packages, the fix is to ensure your `Package.swift` has a `swift-tools-version` of 5.9 or later.

For Xcode projects, make sure the target that uses the Swift OpenAPI Generator build plugin provides the build setting `SWIFT_PACKAGE_NAME` (called “Package Access Identifier”). Set it to any name, for example the name of your Xcode project.

Alternatively, change the access modifier of the generated code to either `internal` (if no code outside of that module needs to use it) or `public` (if the generated code is exported to other modules and packages.) You can do so by setting `accessModifier: internal` in the generator configuration file, or by providing `--access-modifier internal` to the `swift-openapi-generator` CLI.

For details, check out Configuring the generator.

### How do I enable the build plugin in Xcode and Xcode Cloud?

By default, you must explicitly enable build plugins before they are allowed to run.

Before a plugin is enabled, you will encounter a build error with the message `"OpenAPIGenerator" is disabled`.

In Xcode, enable the plugin by clicking the “Enable Plugin” button next to the build error and confirm the dialog by clicking “Trust & Enable”.

In Xcode Cloud, add the script `ci_scripts/ci_post_clone.sh` next to your Xcode project or workspace, containing:

#!/usr/bin/env bash

set -e

# NOTE: the misspelling of validation as "validatation" is intentional and the spelling Xcode expects.
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

Learn more about Xcode Cloud custom scripts in the documentation.

## See Also

### Generator plugin and CLI

Configuring the generator

Create a configuration file to control the behavior of the generator.

Manually invoking the generator CLI

Manually invoke the command-line tool to generate code as an alternative to the Swift package build plugin.

- Frequently asked questions
- Overview
- How do I \_\_ in OpenAPI?
- Why doesn’t the generator have feature \_\_?
- What OpenAPI features does the generator support?
- Which underlying HTTP library does the generated code use?
- How do I customize the HTTP requests and responses?
- Do I commit the generated code to my source repository?
- Does regenerating code from an updated OpenAPI document overwrite any of my code?
- How do I fix the build error “Decl has a package access level but no -package-name was passed”?
- How do I enable the build plugin in Xcode and Xcode Cloud?
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/useful-openapi-patterns

- Swift OpenAPI Generator
- Useful OpenAPI patterns

Article

# Useful OpenAPI patterns

Explore OpenAPI patterns for common data representations.

## Overview

This document lists some common OpenAPI patterns that have been tested to work well with Swift OpenAPI Generator.

### Open enums and oneOfs

While `enum` and `oneOf` are closed by default in OpenAPI, meaning that decoding fails if an unknown value is encountered, it can be a good practice to instead use open enums and oneOfs in your API, as it allows adding new cases over time without having to roll a new API-breaking version.

#### Enums

A simple enum looks like:

type: string
enum:
- foo
- bar
- baz

To create an open enum, in other words an enum that has a “default” value that doesn’t fail during decoding, but instead preserves the unknown value, wrap the enum in an `anyOf` and add a string schema as the second subschema.

anyOf:
- type: string
enum:
- foo
- bar
- baz
- type: string

When accessing this data on the generated Swift code, first check if the first value (closed enum) is non-nil – if so, one of the known enum values were provided. If the enum value is nil, the second string value will contain the raw value that was provided, which you can log or pass through your program.

#### oneOfs

A simple oneOf looks like:

oneOf:
- #/components/schemas/Foo
- #/components/schemas/Bar
- #/components/schemas/Baz

To create an open oneOf, wrap it in an `anyOf`, and provide a fragment as the second schema, or a more constrained container if you know that the payload will always follow a certain structure.

MyOpenOneOf:
anyOf:
- oneOf:
- #/components/schemas/Foo
- #/components/schemas/Bar
- #/components/schemas/Baz
- {}

The above is the most flexible, any JSON payload that doesn’t match any of the cases in oneOf will be saved into the second schema.

If you know the payload is, for example, always a JSON object, you can constrain the second schema further, like this:

MyOpenOneOf:
anyOf:
- oneOf:
- #/components/schemas/Foo
- #/components/schemas/Bar
- #/components/schemas/Baz
- type: object

### Event streams: JSON Lines, JSON Sequence, and Server-sent Events

While JSON Lines, JSON Sequence, and Server-sent Events are not explicitly part of the OpenAPI 3.0 or 3.1 specification, you can document an operation that returns events and also the event payloads themselves.

Each event stream format has one or more commonly associated content types with it:

- JSON Lines: `application/jsonl`, `application/x-ndjson`, others.

- JSON Sequence: `application/json-seq`.

- Server-sent Events: `text/event-stream`.

In the OpenAPI document, an example of an operation that returns JSON Lines could look like (analogous for the other formats):

paths:
/events:
get:
operationId: getEvents
responses:
'200':
content:
application/jsonl: {}
components:
schemas:
MyEvent:
type: object
properties:
...

- JSON Lines

- decode: `AsyncSequence<ArraySlice<UInt8>>.asDecodedJSONLines(of:decoder:)`

- JSON Sequence

- decode: `AsyncSequence<ArraySlice<UInt8>>.asDecodedJSONSequence(of:decoder:)`

- Server-sent Events

- decode (if data is JSON): `AsyncSequence<ArraySlice<UInt8>>.asDecodedServerSentEventsWithJSONData(of:decoder:)`

- decode (if data is JSON with a non-JSON terminating byte sequence): `AsyncSequence<ArraySlice<UInt8>>.asDecodedServerSentEventsWithJSONData(of:decoder:while:)`

- decode (for other data): `AsyncSequence<ArraySlice<UInt8>>.asDecodedServerSentEvents(while:)`

See the `event-streams-*` client and server examples in Checking out an example project to learn how to produce and consume these sequences.

## See Also

### OpenAPI

Exploring an OpenAPI document

This tutorial covers the basics of the OpenAPI specification and guides you through writing an OpenAPI document that describes a service API. We’ll use a fictitious service that returns a personalized greeting.

Adding OpenAPI and Swagger UI endpoints

One of the most popular ways to share your OpenAPI document with your users is to host it alongside your API server itself.

Practicing spec-driven API development

Design, iterate on, and generate both client and server code from your hand-written OpenAPI document.

Supported OpenAPI features

Learn which OpenAPI features are supported by Swift OpenAPI Generator.

- Useful OpenAPI patterns
- Overview
- Open enums and oneOfs
- Event streams: JSON Lines, JSON Sequence, and Server-sent Events
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/practicing-spec-driven-api-development

- Swift OpenAPI Generator
- Practicing spec-driven API development

Article

# Practicing spec-driven API development

Design, iterate on, and generate both client and server code from your hand-written OpenAPI document.

## Overview

An OpenAPI document represents a machine-readable _contract_ between a server and its clients.

There are two high-level workflows for creating and using the OpenAPI document:

- **Spec-driven development**:

- OpenAPI document is hand-written.

- Client and server code is generated.
- **Code-driven development**:

- Server code is hand-written.

- OpenAPI document and client code are generated.

This guide walks through these two practices and later describes how to migrate from a code-driven to a spec-driven development process to improve collaboration and consistency.

### (Recommended) Spec-driven development

Starting with an API contract and iterating on it allows developers working on both sides of the API to be involved in the API design process from the start.

Creating an OpenAPI document is no different, describing both the methods to call and the data structures of parameters and responses.

By starting with a draft of an OpenAPI document, both server and client teams can work in parallel as they write the code necessary to implement their portion of the API, gather feedback, and propose improvements for future versions.

┌────────────────────────────┐
┌────▶│ Server Implementation │
│ └────────────────────────────┘
│ ┌────────────────────────────┐
┌────────────────────┐ ├────▶│ App Client │
│ OpenAPI Document │─────┤ └────────────────────────────┘
└────────────────────┘ │ ┌────────────────────────────┐
├────▶│ Web Client │
│ └────────────────────────────┘
│ ┌────────────────────────────┐
└────▶│ ... │
└────────────────────────────┘

An OpenAPI document supports client-side developers creating a mock server and starting work on the client to provide feedback in parallel to server-side development.

Without starting with an OpenAPI document, client-side developers are frequently forced to wait to provide input about the interface. As a result, working from an API specification first allows for quicker iteration than a code-driven workflow, as there is less waiting of teams for one another.

Swift OpenAPI Generator generates both the client and server stub code, helping ensure that the implementation of both sides follows the agreed-upon OpenAPI document.

Collaborate on the API definition, as opposed to code, to less expensively iterate on the OpenAPI document.

Browse and edit OpenAPI documents using tools available in the broader OpenAPI community, with many that support syntax highlighting, autocompletion, and validation.

### (Discouraged) Code-driven development

Code-driven development, or in other words, writing server code first, and generating the OpenAPI document from it, is discouraged.

┌────────────────────────────┐
┌──▶│ App Client │
│ └────────────────────────────┘
┌────────────────────────────┐ ┌────────────────────┐ │ ┌────────────────────────────┐
│ Server Implementation │──────▶│ OpenAPI Document │───┼──▶│ Web Client │
└────────────────────────────┘ └────────────────────┘ │ └────────────────────────────┘
│ ┌────────────────────────────┐
└──▶│ ... │
└────────────────────────────┘

While initially it can appear convenient, communications with client teams can quickly become confused and ambiguous without a formal description of the API.

Additionally, as multiple teams provide feedback for an API service, there is no single point of truth for all the teams to reference, which slows down iteration.

In code-driven development, there isn’t a convenient way for clients to propose API changes in an unambiguous, machine-readable way. They would have to get access to the source code of the server, understand how it’s implemented, and make changes to it in a way that produces the desired change to the OpenAPI document.

A code-driven workflow prioritizes server-side development over client-side development, in contrast to spec-driven development, where they work as equal peers throughout the API lifecycle.

Code-driven development also doesn’t allow client teams to prototype their components until the server developers wrote at least enough code to generate the OpenAPI document, further limiting parallelization and delaying important learnings, making feedback more difficult to integrate.

For these reasons, use or migrate to a spec-driven development workflow, as it allows all API stakeholders to work and iterate as equal peers.

To learn about migrating from your existing workflow to a spec-driven workflow incrementally, check out this later section.

### Use tests and sample apps as initial clients

When developing a service without having clients yet, use integration tests and sample apps as your first “clients”.

Integration tests written against stubs generated by Swift OpenAPI Generator can simulate a separate team using the API, and can illustrate and feed back issues during the API design process.

In addition to integration tests, prototyping a sample client app helps drive end-to-end validation and puts the server-side developers in the shoes of their client-side counterparts, in the absence of real client teams.

### Publish the source of truth

In comparing the two possible workflows, as yourself the following questions:

1. What is the source of truth for the API? In other words, what is the representation that developers edit by hand?

2. What is the representation that the server provider publishes for clients, who consume it either through tooling or by directly reading it?

| Workflow | Source of truth | Published | Transcoding |
| --- | --- | --- | --- |
| Spec-driven | OpenAPI doc | OpenAPI doc | None required ✅ |
| Code-driven | Code | OpenAPI doc | Can be lossy and unpredictable ❌ |

Notice from the table above that the recommended spec-driven workflow publishes the same document that the developers of the server use to define the server’s API (source of truth).

Publishing the source of truth is preferable to relying on transcoding from code (or other representations) to an OpenAPI document.

By inferring the specification from existing code, the resulting OpenAPI spec is often lossy and incomplete. And even with annotated code, it can be difficult to predict the OpenAPI output.

Additionally, any feature unsupported by the transcoder cannot be represented in the generated OpenAPI document, further limiting the creativity and expressiveness of the API.

This way, your clients can suggest changes to your OpenAPI document without having to learn how your server is implemented, or even having access to your source code.

### Migrate from code-driven to spec-driven development

This section is a step-by-step guide that shows how to migrate an example service from code-driven to spec-driven development incrementally, one operation at a time.

Migrating incrementally helps reduce risk of large code changes and allows you to evaluate and improve the process before migrating your whole codebase.

#### Initial state

This example starts with a Vapor server that has 3 endpoints:

- `GET /foo`

- `POST /foo`

- `GET /bar`

The existing server might look something like this:

let app = try await Vapor.Application.make()
app.get("foo") { ... a, b, c ... }
app.post("foo") { ... a, b, c ... }
app.get("bar") { ... a, b, c ... }
try await app.execute()

Each request handler is responsible for three things:

- a. Parse and validate inputs from a raw `Vapor.Request`.

- b. Perform any business logic specific to that handler.

- c. Serialize outputs into a raw `Vapor.Response`.

The application-specific business logic (b) is the core of the handler, while input (a) and output (c) transformation is often repetitive code that Swift OpenAPI Generator can generate for you.

#### Configure the generator plugin

To take advantage of the generator, create a new OpenAPI document with no paths in it, looking like this:

openapi: 3.1.0
info:
title: MyService
version: 1.0.0
paths: {}

The example above is a valid OpenAPI document that describes a service with no endpoints.

Save the initial OpenAPI document to `Sources/MyServer/openapi.yaml` and then follow the tutorial of configuring the Swift OpenAPI Generator for a server project: Generating server stubs in a Swift package.

As you go through the tutorial, the important part is that you only _add_ the generated handlers _to your existing Vapor app_ instead of creating a new Vapor app.

After this step, your code looks something like this:

let app = try await Vapor.Application.make()

// Registers your existing routes.
app.get("foo") { ... a, b, c ... }
app.post("foo") { ... a, b, c ... }
app.get("bar") { ... a, b, c ... }

struct Handler: APIProtocol {} // this is where you'll implement your logic in the next step

let transport = VaporTransport(routesBuilder: app)

// Registers your generated routes from the OpenAPI document. Right now, there are 0.
try handler.registerHandlers(on: transport, serverURL: ...)

try await app.execute()

At this point, you have two sets of endpoints, your existing 3 ones, and 0 generated ones (because your OpenAPI document is still empty).

Now you can commit and push the changes, and none of your existing code should be affected.

You’ve taken the first step towards spec-driven development.

#### Move over the first operation

Migrate the first route, `GET /foo`, and leave the other two alone for now.

Add the definition of the route to the OpenAPI document, so it looks something like this:

openapi: 3.1.0
info:
title: MyService
version: 1.0.0
paths:
/foo:
get:
... (the definition of the operation, its inputs and outputs)

Comment out the first of the existing route implementations in your Vapor app:

// Registers your existing routes.
// app.get("foo") { ... a, b, c ... } // <<< just comment this out, and this route will be registered below by registerHandlers, as it is now defined by your OpenAPI document.
app.post("foo") { ... a, b, c ... }
app.get("bar") { ... a, b, c ... }

struct Handler: APIProtocol {} // <<< this is where you now get a build error

let transport = VaporTransport(routesBuilder: app)
try handler.registerHandlers(on: transport, serverURL: ...)

When you compile the example above, you’ll get a build error because `APIProtocol` contains the requirement to implement the `getFoo` operation, but it isn’t yet implemented.

Xcode will offer a Fix-it, and if you accept it, it will drop in a function stub that you can fill in:

// Registers your existing routes.
// <<< now you can just delete the first original route, as you've moved the business logic below into the Handler type
app.post("foo") { ... a, b, c ... }
app.get("bar") { ... a, b, c ... }

struct Handler: APIProtocol {

... b ... // <<< notice that here you just implement your business logic, but input deserialization and validation, and output serialization is handled by the generated code.
}
}
let transport = VaporTransport(routesBuilder: app)
try handler.registerHandlers(on: transport, serverURL: ...)

Now, build and run!

Only one operation was moved over, but you can already test that it works and even deploy the service.

#### Repeat for the remaining operations

At this point, `POST /foo` and `GET /bar` are still manually implemented, but `GET /foo` is coming from the OpenAPI document and you only had to move the business logic over.

Repeat this for the remaining two operations, until there are no manual operations with business logic.

Endpoints that provide static content, such as CSS or JavaScript files, are not usually considered part of the REST API, so they don’t need to be included in the OpenAPI document.

#### Final state

The end result should look something like this:

// Register some manual routes, for example, for serving static files.
app.middlewares.on(FileMiddleware(...))

// The business logic.
struct Handler: APIProtocol {

// ...
}

// ...
}
}

// Register the generated routes from OpenAPI.
let transport = VaporTransport(routesBuilder: app)
try handler.registerHandlers(on: transport, serverURL: ...)

By migrating your service step-by-step, you can minimize risk and get increasing value from spec-driven development as you move operations into the hand-written OpenAPI document.

## See Also

### OpenAPI

Exploring an OpenAPI document

This tutorial covers the basics of the OpenAPI specification and guides you through writing an OpenAPI document that describes a service API. We’ll use a fictitious service that returns a personalized greeting.

Adding OpenAPI and Swagger UI endpoints

One of the most popular ways to share your OpenAPI document with your users is to host it alongside your API server itself.

Useful OpenAPI patterns

Explore OpenAPI patterns for common data representations.

Supported OpenAPI features

Learn which OpenAPI features are supported by Swift OpenAPI Generator.

- Practicing spec-driven API development
- Overview
- (Recommended) Spec-driven development
- (Discouraged) Code-driven development
- Use tests and sample apps as initial clients
- Publish the source of truth
- Migrate from code-driven to spec-driven development
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/configuring-the-generator

- Swift OpenAPI Generator
- Configuring the generator

Article

# Configuring the generator

Create a configuration file to control the behavior of the generator.

## Overview

Swift OpenAPI Generator build plugin requires a configuration file that controls what files are generated.

The command-line tool also uses the same configuration file.

### Create a configuration file

The configuration file is named `openapi-generator-config.yaml` or `openapi-generator-config.yml` and must exist in the target source directory.

.
├── Package.swift
└── Sources
└── MyTarget
├── MyCode.swift
├── openapi-generator-config.yaml <-- place the file here
└── openapi.yaml

The configuration file has the following keys:

- `generate` (required): array of strings. Each string value is a mode for the generator invocation, which is one of:

- `types`: Common types and abstractions used by generated client and server code.

- `client`: Client code that can be used with any client transport (depends on code from `types`).

- `server`: Server code that can be used with any server transport (depends on code from `types`).
- `accessModifier` (optional): a string. Customizes the visibility of the API of the generated code.

- `public`: Generated API is accessible from other modules and other packages (if included in a product).

- `package`: Generated API is accessible from other modules within the same package or project.

- `internal` (default): Generated API is accessible from the containing module only.
- `additionalImports` (optional): array of strings. Each string value is a Swift module name. An import statement will be added to the generated source files for each module.

- `additionalFileComments` (optional): array of strings. Each string value is a comment that will be added to the top of each generated file (after the do-not-edit comment). Useful for adding directives like `swift-format-ignore-file` or `swiftlint:disable all`.

- `filter` (optional): Filters to apply to the OpenAPI document before generation.

- `operations`: Operations with these operation IDs will be included in the filter.

- `tags`: Operations tagged with these tags will be included in the filter.

- `paths`: Operations for these paths will be included in the filter.

- `schemas`: These (additional) schemas will be included in the filter.
- `namingStrategy` (optional): a string. The strategy of converting OpenAPI identifiers into Swift identifiers.

- `defensive` (default): Produces non-conflicting Swift identifiers for any OpenAPI identifiers. Check out SOAR-0001 for details.

- `idiomatic`: Produces more idiomatic Swift identifiers for OpenAPI identifiers. Might produce name conflicts (in that case, switch for details.
- `nameOverrides` (optional): a string to string dictionary. Allows customizing how individual OpenAPI identifiers get converted to Swift identifiers.

- `typeOverrides` (optional): Allows replacing a generated type with a custom type.

- `schemas` (optional): a string to string dictionary. The key is the name of the schema, the last component of `#/components/schemas/Foo` (here, `Foo`). The value is the custom type name, such as `CustomFoo`. Check out details in SOAR-0014.
- `featureFlags` (optional): array of strings. Each string must be a valid feature flag to enable. For a list of currently supported feature flags, check out FeatureFlags.swift.

### Example config files

To generate client code in a single target:

generate:
- types
- client
namingStrategy: idiomatic

To generate server code in a single target:

generate:
- types
- server
namingStrategy: idiomatic

If you are generating client _and_ server code, you can generate the types in a shared target using the following config:

generate:
- types
namingStrategy: idiomatic

Then, to generate client code that depends on the module from this target, use the following config (where `APITypes` is the name of the library target that contains the generated `types`):

generate:
- client
namingStrategy: idiomatic
additionalImports:
- APITypes

To use the generated code from other packages, also customize the access modifier:

generate:
- client
namingStrategy: idiomatic
additionalImports:
- APITypes
accessModifier: public

To add file comments to exclude generated files from formatting tools:

generate:
- types
- client
namingStrategy: idiomatic
additionalFileComments:
- "swift-format-ignore-file"
- "swiftlint:disable all"

### Document filtering

The generator supports filtering the OpenAPI document prior to generation, which can be useful when generating client code for a subset of a large API, or splitting an implementation of a server across multiple modules.

For example, to generate client code for only the operations with a given tag, use the following config:

filter:
tags:
- myTag

When multiple filters are specified, their union will be considered for inclusion.

In all cases, the transitive closure of dependencies from the components object will be included.

The CLI also provides a `filter` command that takes the same configuration file as the `generate` command, which can be used to inspect the filtered document:

% swift-openapi-generator filter --config path/to/openapi-generator-config.yaml path/to/openapi.yaml

To use this command as a standalone filtering tool, use the following config and redirect stdout to a new file:

generate: []
filter:
tags:
- myTag

### Type overrides

Type Overrides can be used used to replace the default generated type with a custom type.

typeOverrides:
schemas:
UUID: Foundation.UUID

Check out SOAR-0014 for details.

## See Also

### Generator plugin and CLI

Manually invoking the generator CLI

Manually invoke the command-line tool to generate code as an alternative to the Swift package build plugin.

Frequently asked questions

Review some frequently asked questions below.

- Configuring the generator
- Overview
- Create a configuration file
- Example config files
- Document filtering
- Type overrides
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/checking-out-an-example-project

- Swift OpenAPI Generator
- Checking out an example project

Article

# Checking out an example project

Check out a working example to learn how packages using Swift OpenAPI Generator can be structured and integrated with the ecosystem.

## Overview

The following examples show how to use and integrate Swift OpenAPI Generator with other packages in the ecosystem.

All the examples can be found in the Examples directory of the Swift OpenAPI Generator repository.

To run an example locally, for example hello-world-urlsession-client-example, clone the Swift OpenAPI Generator repository, and run the example, as shown below:

% git clone
% cd swift-openapi-generator/Examples
% swift run --package-path hello-world-urlsession-client-example

## Getting started

Each of the following packages shows an end-to-end working example with the given transport.

- hello-world-urlsession-client-example \- A CLI client using the URLSession API.

- hello-world-async-http-client-example \- A CLI client using the AsyncHTTPClient library.

- hello-world-vapor-server-example \- A CLI server using the Vapor web framework.

- hello-world-hummingbird-server-example \- A CLI server using the Hummingbird web framework.

- HelloWorldiOSClientAppExample \- An iOS client SwiftUI app with a mock server for unit and UI tests.

- curated-client-library-example \- A library that hides the generated API and exports a hand-written interface, allowing decoupled versioning.

## Various content types

The following packages show working with various content types, such as JSON, URL-encoded request bodies, plain text, raw bytes, multipart bodies, as well as event streams, such as JSON Lines, JSON Sequence, and Server-sent Events.

- various-content-types-client-example \- A client showing how to provide and handle the various content types.

- various-content-types-server-example \- A server showing how to handle and provide the various content types.

- event-streams-client-example \- A client showing how to provide and handle event streams.

- event-streams-server-example \- A server showing how to handle and provide event streams.

- bidirectional-event-streams-client-example \- A client showing how to handle and provide bidirectional event streams.

- bidirectional-event-streams-server-example \- A server showing how to handle and provide bidirectional event streams.

## Integrations

- swagger-ui-endpoint-example \- A server with endpoints for its raw OpenAPI document and interactive documentation using Swagger UI.

- postgres-database-example \- A server using a Postgres database for persistent state.

- command-line-client-example \- A client with a rich command-line interface using Swift Argument Parser.

## Middleware

- logging-middleware-oslog-example \- A middleware that logs requests and responses using OSLog (only available on Apple platforms, such as macOS, iOS, and more).

- logging-middleware-swift-log-example \- A middleware that logs requests and responses using SwiftLog.

- metrics-middleware-example \- A middleware that collects metrics using SwiftMetrics.

- tracing-middleware-example \- A middleware that emits traces using Swift Distributed Tracing.

- retrying-middleware-example \- A middleware that retries some failed requests.

- auth-client-middleware-example \- A middleware that injects a token header.

- auth-server-middleware-example \- A middleware that inspects a token header.

## Ahead-of-time (manual) code generation

The recommended way to use Swift OpenAPI generator is by integrating the _build plugin_, which all of the examples above use. The build plugin generates Swift code from your OpenAPI document at build time, and you don’t check in the generated code into your git repository.

However, if you cannot use the build plugin, for example because you must check in your generated code, use the _command plugin_, which you trigger manually either in Xcode or on the command line. See the following example for this workflow:

- manual-generation-package-plugin-example \- A client using the Swift package command plugin for manual code generation.

If you can’t even use the command plugin, for example because your package is not allowed to depend on Swift OpenAPI Generator, you can invoke the generator CLI manually from a Makefile. See the following example for this workflow:

- manual-generation-generator-cli-example \- A client using the `swift-openapi-generator` CLI for manual code generation.

## Talks

- FOSDEM 2025: Streaming ChatGPT Proxy with Swift OpenAPI \- A tailored API server, backed by ChatGPT, and client CLI, with end-to-end streaming.

## See Also

### Essentials

Generating a client in a Swift package

This tutorial guides you through building _GreetingServiceClient_—an API client for a fictitious service that returns a personalized greeting.

Generating a client in an Xcode project

Generating server stubs in a Swift package

This tutorial guides you through building _GreetingService_—an API server for a fictitious service that returns a personalized greeting.

- Checking out an example project
- Overview
- Getting started
- Various content types
- Integrations
- Middleware
- Ahead-of-time (manual) code generation
- Talks
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/project-scope-and-goals

- Swift OpenAPI Generator
- Project scope and goals

Article

# Project scope and goals

Learn about what is in and out of scope of Swift OpenAPI Generator.

## Overview

Swift OpenAPI Generator aims to cover the most commonly used OpenAPI features to simplify your workflow and streamline your codebase. The main goal is to reduce ceremony by generating the repetitive, verbose, and error-prone code associated with encoding API inputs, making HTTP requests, parsing HTTP responses, and decoding the outputs.

The goal of the project is to compose with the wider OpenAPI tooling ecosystem so functionality beyond reducing ceremony using code generation is, by default, considered out of scope. When in doubt, file an issue to discuss whether your idea should be a feature of Swift OpenAPI Generator, or fits better as a separate project.

#### Principle: Faithfully represent the OpenAPI document

The OpenAPI document is considered as the source of truth. The generator aims to produce code that reflects the document where possible. This includes the specification structure, and the identifiers used by the authors of the OpenAPI document.

As a result, the generated code may not always be idiomatic Swift style or conform to your own custom style guidelines. For example, the API operation identifiers may not be `lowerCamelCase` by default, when using the `defensive` naming strategy. However, an alternative naming strategy called `idiomatic` is available since version 1.6.0 that closer matches Swift conventions.

If you require the generated code to conform to specific style, we recommend you preprocess the OpenAPI document to update the identifiers to produce different code.

For larger documents, you may want to do this programmatically and, if you are doing so in Swift, you could use OpenAPIKit, which is the same library used by Swift OpenAPI Generator.

#### Principle: Generate code that evolves with the OpenAPI document

As features are added to a service, the OpenAPI document for that service will evolve. The generator aims to produce code that evolves ergonomically as the OpenAPI document evolves.

As a result, the generated code might appear unnecessarily verbose, especially for simple operations.

A concrete example of this is the use of enum types when there is only one documented scenario. This allows for a new enum case to be added to the generated Swift code when a new scenario is added to the OpenAPI document, which results in a better experience for users of the generated code.

Another example is the generation of empty structs within the input or output types. For example, the input type will contain a nested struct for the header fields, even if the API operation has no documented header fields.

#### Principle: Reduce complexity of the generator implementation

Some generators offer lots of options that affect the code generation process. In order to keep the project streamlined and maintainable, Swift OpenAPI Generator offers very few options.

One concrete example of this is that users cannot configure the names of generated types, such as `Client` and `APIProtocol`, and there is no attempt to prevent namespace collisions in the target into which it is generated.

Instead, users are advised to generate code into a dedicated target, and use Swift’s module system to separate the generated code from code that depends on it.

Another example is the lack of ability to customize how Swift names are computed from strings provided in the OpenAPI document.

You can read more about this in API stability of generated code.

## See Also

### Related Documentation

Contributing to Swift OpenAPI Generator

Help improve Swift OpenAPI Generator by implementing a missing feature or fixing a bug.

Supported OpenAPI features

Learn which OpenAPI features are supported by Swift OpenAPI Generator.

API stability of generated code

Understand the impact of changes to the OpenAPI document on generated Swift code.

### Getting involved

Collaborate on API changes to Swift OpenAPI Generator by writing a proposal.

Learn about the internals of Swift OpenAPI Generator.

- Project scope and goals
- Overview
- Guiding principles
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/manually-invoking-the-generator-cli

- Swift OpenAPI Generator
- Manually invoking the generator CLI

Article

# Manually invoking the generator CLI

Manually invoke the command-line tool to generate code as an alternative to the Swift package build plugin.

## Overview

The recommended workflow is to use the Swift package plugin, as described in our tutorials:

- Generating a client in a Swift package

- Generating a client in an Xcode project

- Generating server stubs in a Swift package

When using the package plugin, the code is generated at build time and is not committed to your source repository.

If you need to commit the generated code to your source repository (for example, for auditing reasons) you can manually invoke the generator CLI to generate the Swift code. Note that even with this workflow, the generated code still depends on the runtime library.

### Invoke the CLI manually

To generate Swift code to a specific directory, clone the generator repository and run the following command from the checkout directory:

% swift run swift-openapi-generator generate \
--mode types --mode client \
--output-directory path/to/desired/output-dir \
path/to/openapi.yaml

This will create the following files in the specified output directory:

- `Types.swift`

- `Client.swift`

To see the usage documentation for the generator CLI, use the following command:

% swift run swift-openapi-generator --help

### Use the Swift package command

As an alternative to invoking the CLI manually, you can also use the package command, which works similarly to the build plugin.

Set up the `openapi.yaml` and `openapi-generator-config.yaml` files the same way as you would for the build plugin, and then run:

% swift package plugin generate-code-from-openapi --target HelloWorldURLSessionClient

This will generate files into the `HelloWorldURLSessionClient` target’s Sources directory, in a directory called `GeneratedSources`, which you can then check into your repository.

You can also invoke the command from the Xcode UI by control-clicking on a target in the Project Navigator, and selecting the command.

## See Also

### Generator plugin and CLI

Configuring the generator

Create a configuration file to control the behavior of the generator.

Frequently asked questions

Review some frequently asked questions below.

- Manually invoking the generator CLI
- Overview
- Invoke the CLI manually
- Use the Swift package command
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/api-stability-of-generated-code

- Swift OpenAPI Generator
- API stability of generated code

Article

# API stability of generated code

Understand the impact of changes to the OpenAPI document on generated Swift code.

## Overview

Swift OpenAPI Generator generates client and server Swift code from an OpenAPI document. The generated code may change if the OpenAPI document is changed or a different version of the generator is used.

This document outlines the API stability goals for the generated code to help you avoid unintentional build errors when updating the OpenAPI document.

### Example changes

There are three API boundaries to consider:

- **HTTP**: the requests and responses sent over the network

- **OpenAPI**: the description of the API using the OpenAPI specification

- **Swift**: the client or server code generated from the OpenAPI document

Below is a table of example changes you might make to an OpenAPI document, and whether that would result in a breaking change (❌) or a non-breaking change (✅).

| Change | HTTP | OpenAPI | Swift |
| --- | --- | --- | --- |
| Add a new schema | ✅ | ✅ | ✅ |
| Add a new property to an existing schema (†) | ✅ | ✅ | ⚠️ |
| Add a new operation | ✅ | ✅ | ✅ |
| Add a new response to an existing operation (‡) | ✅ | ❌ | ❌ |
| Add a new content type to an existing response (§) | ✅ | ❌ | ❌ |
| Remove a required property | ❌ | ❌ | ❌ |
| Rename a schema | ✅ | ❌ | ❌ |

The table above is not exhaustive, but it shows a pattern:

- Removing (or renaming) anything that the adopter might have relied on is usually a breaking change.

- Adding a new schema or a new operation is an additive, non-breaking change (†).

- Adding a new response or content type is considered a breaking change (‡)(§).

### Avoid including the generated code in your public API

Due to the complicated rules above, we recommend that you don’t publish the generated code for others to rely on.

If you do expose the generated code as part of your package’s API, we recommend auditing your API for breaking changes, especially if your package uses Semantic Versioning.

Maintaining Swift library package that uses the generated code as an implementation detail is supported (and recommended), as long as no generated symbols are exported in your public API.

#### Create a curated client library package

Let’s consider an example where you’re creating a Swift library that provides a curated API for making the following API call:

% curl
{
"message": "Howdy, Maria!"
}

You can hide the generated client code as an implementation detail and provide a hand-written Swift API to your users using the following steps:

1. Create a library target that is not exposed as a product, called, for example, `GeneratedGreetingClient`, which uses the Swift OpenAPI Generator package plugin.

2. Create another library target that is exposed as a product, called, for example, `Greeter`, which depends on the `GeneratedGreetingClient` target but doesn’t use the imported types in its public API.

This way, you are in full control of the public API of the `Greeter` library, but you also benefit from calling the service using generated code.

## See Also

### Related Documentation

API stability of the generator

Understand the impact of updating the generator package plugin on the generated Swift code.

### API stability

- API stability of generated code
- Overview
- Example changes
- Avoid including the generated code in your public API
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/contributing-to-swift-openapi-generator

- Swift OpenAPI Generator
- Contributing to Swift OpenAPI Generator

Article

# Contributing to Swift OpenAPI Generator

Help improve Swift OpenAPI Generator by implementing a missing feature or fixing a bug.

## Overview

Swift OpenAPI Generator is an open source project that encourages contributions, either to the generator itself, or by building new transport and middleware packages.

### Missing transport or middleware

Anyone can create a custom transport or middleware in a new package that depends on the runtime library and provides a type conforming to one of the transport or middleware protocols.

Any adopter of Swift OpenAPI Generator can then depend on that package and use the transport or middleware when creating their client or server.

### Missing or broken feature in the generator

The code generator project is written in Swift and can be thought of as a function that takes an OpenAPI document as input and provides one or more Swift source files as output.

The generated Swift code depends on the runtime library, so some features might require coordinated changes in both the runtime and generator repositories.

Similarly, any changes to the transport and middleware protocols in the runtime library must consider the impact on existing transport and middleware implementation packages.

### Testing the generator

The generator relies on a mix of unit and integration tests.

When contributing, consider how the change can be tested and how the tests will be maintained over time.

### Runtime SPI for generated code

The generated code relies on functionality in the runtime library that is not part of its public API. This is provided in an SPI, named `Generated` and is not intended to be used directly by adopters of the generator.

To use this functionality, use an SPI import:

@_spi(Generated) import OpenAPIRuntime

### Example contribution workflow

Let’s walk through the steps to implement a missing OpenAPI feature that requires changes in multiple repositories. For example, adding support for a new query style.

01. Clone the generator and runtime repositories and set up a development environment where the generator uses the local runtime package dependency, by either:

1. Adding both packages to an Xcode workspace; or

2. Using `swift package edit` to edit the runtime dependency used in the generator package.
02. Run all of the tests in the generator package and make sure they pass, which includes reference tests for the generated code.

03. Update the OpenAPI document in the reference test to use the new OpenAPI feature.

04. Manually update the Swift code in the reference test to include the code you’d like the generator to output.

05. At this point **the reference tests should _fail_**. The differences between the generated code and the desired code are printed in the reference test output.

06. Make incremental changes to the generator and runtime library until the reference tests pass.

07. Once the reference test succeeds, add unit tests for the code you changed.

08. Open pull requests for both the generator and runtime changes and cross-reference them in the pull request descriptions. Note: it’s expected that the CI for the generator pull request will fail, because it won’t have the changes from the runtime library until the runtime pull request it is merged.

09. One of the project maintainers will review your changes and, once approved, will merge the runtime changes and release a new version of the runtime package.

10. The generator pull request will need to be updated to bump the minimum version of the runtime dependency. At this point the CI should pass and the generator pull request can be merged.

11. All done! Thank you for your contribution! 🙏

## See Also

### Getting involved

Project scope and goals

Learn about what is in and out of scope of Swift OpenAPI Generator.

Collaborate on API changes to Swift OpenAPI Generator by writing a proposal.

Learn about the internals of Swift OpenAPI Generator.

- Contributing to Swift OpenAPI Generator
- Overview
- Missing transport or middleware
- Missing or broken feature in the generator
- Testing the generator
- Runtime SPI for generated code
- Example contribution workflow
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/proposals

- Swift OpenAPI Generator
- Proposals

# Proposals

Collaborate on API changes to Swift OpenAPI Generator by writing a proposal.

## Overview

For non-trivial changes that affect the public API, the Swift OpenAPI Generator project adopts a lightweight version of the Swift Evolution process.

Writing a proposal first helps discuss multiple possible solutions early, apply useful feedback from other contributors, and avoid reimplementing the same feature multiple times.

While it’s encouraged to get feedback by opening a pull request with a proposal early in the process, it’s also important to consider the complexity of the implementation when evaluating different solutions (as per Project scope and goals). For example, this might mean including a link to a branch containing a prototype implementation of the feature in the pull request description.

### Steps

1. Make sure there’s a GitHub issue for the feature or change you would like to propose.

2. Duplicate the `SOAR-NNNN.md` document and replace `NNNN` with the next available proposal number.

3. Link the GitHub issue from your proposal, and fill in the proposal.

4. Open a pull request with your proposal and solicit feedback from other contributors.

5. Once a maintainer confirms that the proposal is ready for review, the state is updated accordingly. The review period is 7 days, and ends when one of the maintainers marks the proposal as Ready for Implementation, or Deferred.

6. Before the pull request is merged, there should be an implementation ready, either in the same pull request, or a separate one, linked from the proposal.

7. The proposal is considered Approved once the implementation, proposal PRs have been merged, and, if originally disabled by a feature flag, feature flag enabled unconditionally.

If you have any questions, tag Honza Dvorsky or Si Beaumont in your issue or pull request on GitHub.

### Possible review states

- Awaiting Review

- In Review

- Ready for Implementation

- In Preview

- Approved

- Deferred

### Possible affected components

- generator

- runtime

- client transports

- server transports

## Topics

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

## See Also

### Getting involved

Project scope and goals

Learn about what is in and out of scope of Swift OpenAPI Generator.

Contributing to Swift OpenAPI Generator

Help improve Swift OpenAPI Generator by implementing a missing feature or fixing a bug.

Learn about the internals of Swift OpenAPI Generator.

- Proposals
- Overview
- Steps
- Possible review states
- Possible affected components
- Topics
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/api-stability-of-the-generator

- Swift OpenAPI Generator
- API stability of the generator

Article

# API stability of the generator

Understand the impact of updating the generator package plugin on the generated Swift code.

## Overview

Swift OpenAPI Generator generates client and server Swift code from an OpenAPI document. The generated code may change if the OpenAPI document is changed or a different version of the generator is used.

This document outlines the API stability goals for the generator to help you avoid unintentional build errors when updating to a new version of Swift OpenAPI Generator.

Swift OpenAPI Generator follows Semantic Versioning 2.0.0 for the following, which are considered part of its API:

- The name of the Swift OpenAPI Generator package plugin.

- The format of the config file provided to Swift OpenAPI Generator (plugin or CLI tool).

- The Swift OpenAPI Generator CLI tool arguments, options, and flags.

If you upgrade any of the components above to the next non-breaking version, your project should continue to build successfully. Check out how these rules are applied, and what a breaking change means for the generated code: API stability of generated code.

### Implementation details

In contrast to the guarantees provided for the API of Swift OpenAPI Generator, the following list of behaviors are _not_ considered API, and can change without prior warning:

- The number and names of files generated by the Swift OpenAPI Generator CLI and plugins.

- The SPI provided by the OpenAPIRuntime library used by generated code (marked with `@_spi(Generated)`).

- The business logic of the generated code, any code that isn’t part of the API of the generated code.

- The diagnostics emitted by the generator, both their severity and printed description.

## See Also

### Related Documentation

API stability of generated code

Understand the impact of changes to the OpenAPI document on generated Swift code.

### API stability

- API stability of the generator
- Overview
- Implementation details
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/documentation-for-maintainers

- Swift OpenAPI Generator
- Documentation for maintainers

# Documentation for maintainers

Learn about the internals of Swift OpenAPI Generator.

## Overview

Swift OpenAPI Generator contains multiple moving pieces, from the runtime library, to the generator CLI, plugin, to extension packages using the transport and middleware APIs.

Use the resources below if you’d like to learn more about how the generator works under the hood, for example as part of contributing a new feature to it.

## Topics

Converting between data and Swift types

Learn about the type responsible for converting between binary data and Swift types.

Generating custom Codable implementations

Learn about when and how the generator emits a custom Codable implementation.

Handling nullable schemas

Learn how the generator handles schema nullability.

Supporting recursive types

Learn how the generator supports recursive types.

## See Also

### Getting involved

Project scope and goals

Learn about what is in and out of scope of Swift OpenAPI Generator.

Contributing to Swift OpenAPI Generator

Help improve Swift OpenAPI Generator by implementing a missing feature or fixing a bug.

Collaborate on API changes to Swift OpenAPI Generator by writing a proposal.

- Documentation for maintainers
- Overview
- Topics
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0007

- Swift OpenAPI Generator
- Proposals
- SOAR-0007: Shorthand APIs for operation inputs and outputs

Article

# SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

## Overview

- Proposal: SOAR-0007

- Author(s): Si Beaumont

- Status: **Implemented (0.3.0)**

- Review period: 2023-09-22 – 2023-09-29

- Swift Forums post
- Issue: apple/swift-openapi-generator#22, apple/swift-openapi-generator#104, apple/swift-openapi-generator#105, apple/swift-openapi-generator#145

- Implementation: apple/swift-openapi-runtime#56, apple/swift-openapi-generator#308

- Review: ( review)

- Affected components: generator, runtime

- Related links:

- Project scope and goals
- Versions:

- v1 (2023-09-22): Initial version

### Introduction

A key goal of Swift OpenAPI Generator is to generate code that faithfully represents the OpenAPI document\ [0\] and is capable of remaining as expressive as the OpenAPI specification, in which operations can have one of several responses (e.g. `200`, `204`), each of which can have one of several response bodies (e.g. `application/json`, `text/plain`).

Consequently, the generated code allows for exhaustive type-safe handling of all possible responses (including undocumented responses) by using nested enum values for the HTTP status and the body.

However, for simple operations that have just one documented outcome, the generated API seems overly verbose to use. We discuss a concrete example in the following section.

### Motivation

To motivate the proposal we will consider a trivial API which returns a personalized greeting. The OpenAPI document for this service is provided in an appendix, but its behaviour is illustrated with the following API call from the terminal:

% curl 'localhost:8080/api/greet?name=Maria'
{ "message" : "Hello, Maria" }

The generated API protocols define one function per OpenAPI operation. These functions take a single input parameter that holds all the operation inputs (header fields, query items, cookies, body, etc.). Consequently, when making an API call, there is an additional initializer to call. This presents unnecessary ceremony, especially when calling operations with no parameters or only default parameters.

// before (with parameters)
_ = try await client.getGreeting(Operations.getGreeting.Input(
query: Operations.getGreeting.Input.Query(name: "Maria")
))

// before (with parameters, shorthand)
_ = try await client.getGreeting(.init(query: .init(name: "Maria")))

// before (no parameters, shorthand)
_ = try await client.getGreeting(.init()))

The generated `Output` type for each API operation is an enum with cases for each documented response and a case for an undocumented response. Following this pattern, the `Output.Body` is also an enum with cases for every documented content type for the response.

While this API encourages users to handle all possible scenarios, it leads to ceremony when the user requires a specific response and receiving anything else is considered an error. This is especially apparent for API operations that have just a single response, e.g. `OK`, and a single content type, e.g. `application/json`.

// before
switch try await client.getGreeting() {
case .ok(let response):
switch response.body {
case .json(let body):
print(body.message)
}
case .undocumented(statusCode: _, _):
throw UnexpectedResponseError()
}

For users who wish to get an expected response or fail, they will have to define their own error type. They may also make use of `guard case let ... else { throw ... }` which reduces the code, but still presents additional ceremony.

### Proposed solution

To simplify providing inputs, generate an overload for each operation that lifts each of the parameters of `Input.init` as function parameters. This removes the need for users to call `Input.init`, which streamlines the API call, especially when the user does not need to provide parameters.

// after (with parameters, shorthand)
_ = try await client.getGreeting(query: .init(name: "Maria"))

// after (no parameters)
_ = try await client.getGreeting()

To simplify handling outputs, provide a throwing computed property for each enum case related to a documented outcome, which will return the associated value for the expected case, or throw a runtime error if the value is a different enum case. This allows for expressing the expected outcome as a chained operation.

// after
print(try await client.getGreeting().ok.body.json.message)
// ^ ^ ^
// | | `- (New) Throws if body did not conform to documented JSON.
// | |
// | `- (New) Throws if HTTP response is not 200 (OK).
// |
// `- (Existing) Throws if there is an error making the API call.

### Detailed design

The following listing is a relevant subset of the code that is currently generated for our example API. The comments have been changed for the audience of this proposal. The entire code is contained in an appendix.

public protocol APIProtocol: Sendable {
// A function requirement is generated for each operation. It takes an
// input type, comprising all parameters, and returns an output type, which
// is an nested enum covering all possible responses.

}

public enum Operations {
public enum getGreeting {
public struct Input: Sendable, Hashable {
// If all parameters have default values, then the initializer
// parameter also has a default value.
public init(
query: Operations.getGreeting.Input.Query = .init(),
headers: Operations.getGreeting.Input.Headers = .init()
) {
self.query = query
self.headers = headers
}
}
@frozen public enum Output: Sendable, Hashable {
public struct Ok: Sendable, Hashable {
@frozen public enum Body: Sendable, Hashable {
case json(Components.Schemas.Greeting)
}
public var body: Operations.getGreeting.Output.Ok.Body
public init(body: Operations.getGreeting.Output.Ok.Body) { self.body = body }
}
// An enum case is generated for each documented response.
case ok(Operations.getGreeting.Output.Ok)
// An additional enum case is generated for any undocumented response.
case undocumented(statusCode: Int, OpenAPIRuntime.UndocumentedPayload)
}
}
}

This proposal covers generating the following additional API surface to simplify providing inputs.

extension APIProtocol {
// The parameters to each overload will match those of the corresponding
// operation input initializer, including optionality.
public func getGreeting(
query: Operations.getGreeting.Input.Query = .init(),
headers: Operations.getGreeting.Input.Headers = .init()
) {
// Simply wraps the call to the protocol function in an input value.
getGreeting(Operations.getGreeting.Input(
query: query,
headers: headers
))
}
}

This proposal also covers generating the following additional API surface to simplify handling outputs.

// Note: Generating an extension is not prescriptive; implementations may
// generate these properties within the primary type definition.
extension Operations.getGreeting.Output {
// A throwing computed property is generated for each documented outcome.
var ok: Operations.getGreeting.Output.Ok {
get throws {
guard case let .ok(response) = self else {
// This error will be added to the OpenAPIRuntime library.
throw UnexpectedResponseError(expected: "ok", actual: self)
}
return response
}
}
// Note: a property is _not_ generated for the undocumented enum case.
}

// Note: Generating an extension is not prescriptive; implementations may
// generate these properties within the primary type definition.
extension Operations.getGreeting.Output.Ok.Body {
// A throwing computed property is generated for each document content type.
var json: Components.Schemas.Greeting {
get throws {
guard case let .json(body) = self else {
// This error will be added to the OpenAPIRuntime library.
throw UnexpectedContentError(expected: "json", actual: self)
}
return body
}
}
}

### API stability

This change is purely API additive:

- Additional SPI in the runtime library

- Additional API in the generated code

### Future directions

Nothing in this proposal.

#### Providing macros

A macro library could be used in conjunction with the existing generated code.

However, this proposal does not consider this a viable option for two reasons:

1. We currently support Swift 5.8; and

2. Adopters that rely on ahead-of-time generation will not benefit.

#### Making this an opt-in feature

There generator could conditionally generate this code, e.g. using a configuration option, or hiding the generated code behind an SPI.

This proposal does so unconditionally in the spirit of _making easy things, easy._ Based on adopter feedback, enough users want to be able to do this that it should be very discoverable on first use.

### Appendix A: OpenAPI document for example service

# openapi.yaml
# ------------
openapi: '3.0.3'
info:
title: GreetingService
version: 1.0.0
servers:
- url:
description: Example
paths:
/greet:
get:
operationId: getGreeting
parameters:
- name: name
required: false
in: query
description: A name used in the returned greeting.
schema:
type: string
responses:
'200':
description: A success response with a greeting.
content:
application/json:
schema:
$ref: '#/components/schemas/Greeting'
components:
schemas:
Greeting:
type: object
properties:
message:
type: string
required:
- message

### Appendix B: Existing generated code for example service

Generated using the following command:

% swift-openapi-generator generate --mode types openapi.yaml

// Types.swift
// -----------
// Generated by swift-openapi-generator, do not modify.
@_spi(Generated) import OpenAPIRuntime
#if os(Linux)
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.Date
#else
import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.Date
#endif
/// A type that performs HTTP operations defined by the OpenAPI document.
public protocol APIProtocol: Sendable {
/// - Remark: HTTP `GET /greet`.
/// - Remark: Generated from `#/paths//greet/get(getGreeting)`.

}
/// Server URLs defined in the OpenAPI document.
public enum Servers {
/// Example

}
/// Types generated from the components section of the OpenAPI document.
public enum Components {
/// Types generated from the `#/components/schemas` section of the OpenAPI document.
public enum Schemas {
/// - Remark: Generated from `#/components/schemas/Greeting`.
public struct Greeting: Codable, Hashable, Sendable {
/// - Remark: Generated from `#/components/schemas/Greeting/message`.
public var message: Swift.String
/// Creates a new `Greeting`.
///
/// - Parameters:
/// - message:
public init(message: Swift.String) { self.message = message }
public enum CodingKeys: String, CodingKey { case message }
}
}
/// Types generated from the `#/components/parameters` section of the OpenAPI document.
public enum Parameters {}
/// Types generated from the `#/components/requestBodies` section of the OpenAPI document.
public enum RequestBodies {}
/// Types generated from the `#/components/responses` section of the OpenAPI document.
public enum Responses {}
/// Types generated from the `#/components/headers` section of the OpenAPI document.
public enum Headers {}
}
/// API operations, with input and output types, generated from `#/paths` in the OpenAPI document.
public enum Operations {
/// - Remark: HTTP `GET /greet`.
/// - Remark: Generated from `#/paths//greet/get(getGreeting)`.
public enum getGreeting {
public static let id: String = "getGreeting"
public struct Input: Sendable, Hashable {
/// - Remark: Generated from `#/paths/greet/GET/query`.
public struct Query: Sendable, Hashable {
/// A name used in the returned greeting.
///
/// - Remark: Generated from `#/paths/greet/GET/query/name`.
public var name: Swift.String?
/// Creates a new `Query`.
///
/// - Parameters:
/// - name: A name used in the returned greeting.
public init(name: Swift.String? = nil) { self.name = name }
}
public var query: Operations.getGreeting.Input.Query
/// - Remark: Generated from `#/paths/greet/GET/header`.
public struct Headers: Sendable, Hashable {
public var accept:

/// Creates a new `Headers`.
///
/// - Parameters:
/// - accept:
public init(

.defaultValues()
) { self.accept = accept }
}
public var headers: Operations.getGreeting.Input.Headers
/// Creates a new `Input`.
///
/// - Parameters:
/// - query:
/// - headers:
public init(
query: Operations.getGreeting.Input.Query = .init(),
headers: Operations.getGreeting.Input.Headers = .init()
) {
self.query = query
self.headers = headers
}
}
@frozen public enum Output: Sendable, Hashable {
public struct Ok: Sendable, Hashable {
/// - Remark: Generated from `#/paths/greet/GET/responses/200/content`.
@frozen public enum Body: Sendable, Hashable {
/// - Remark: Generated from `#/paths/greet/GET/responses/200/content/application\/json`.
case json(Components.Schemas.Greeting)
}
/// Received HTTP response body
public var body: Operations.getGreeting.Output.Ok.Body
/// Creates a new `Ok`.
///
/// - Parameters:
/// - body: Received HTTP response body
public init(body: Operations.getGreeting.Output.Ok.Body) { self.body = body }
}
/// A success response with a greeting.
///
/// - Remark: Generated from `#/paths//greet/get(getGreeting)/responses/200`.
///
/// HTTP response code: `200 ok`.
case ok(Operations.getGreeting.Output.Ok)
/// Undocumented response.
///
/// A response with a code that is not documented in the OpenAPI document.
case undocumented(statusCode: Int, OpenAPIRuntime.UndocumentedPayload)
}
@frozen public enum AcceptableContentType: AcceptableProtocol {
case json
case other(String)
public init?(rawValue: String) {
switch rawValue.lowercased() {
case "application/json": self = .json
default: self = .other(rawValue)
}
}
public var rawValue: String {
switch self {
case let .other(string): return string
case .json: return "application/json"
}
}
public static var allCases: [Self] { [.json] }
}
}
}

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0007: Shorthand APIs for operation inputs and outputs
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- Appendix A: OpenAPI document for example service
- Appendix B: Existing generated code for example service
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0005

- Swift OpenAPI Generator
- Proposals
- SOAR-0005: Adopting the Swift HTTP Types package

Article

# SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

## Overview

- Proposal: SOAR-0005

- Author(s): Honza Dvorsky

- Status: **Implemented (0.3.0)**

- Issue: apple/swift-openapi-generator#101

- Implementation: apple/swift-openapi-generator#245, apple/swift-openapi-runtime#47, apple/swift-openapi-urlsession#15, swift-server/swift-openapi-async-http-client#16

- Review: ( review)

- Affected components: generator, runtime, client transports, server transports

- Versions:

- v1 (2023-09-08): Initial version

- v1.1: In `ServerTransport` and `ServerMiddleware`, make the response `HTTPBody` optional to preserve the intent of the OpenAPI document author for the transport.

- v1.2 (2023-09-13): Made response bodies optional.

### Introduction

Use the HTTP request and response types from the Swift HTTP Types package instead of maintaining our own currency types.

### Motivation

The purpose of the Swift OpenAPI Runtime library is to be an “API package”, in the meaning established by earlier packages in the Swift ecosystem, such as swift-log. The API package contains generally useful abstractions, which adopters can implement their logic against, and plug in any concrete implementation provided by anyone else in the ecosystem.

Similarly in Swift OpenAPI Generator, the most important abstractions in the runtime library are the transport and middleware protocols. There are concrete implementations of client and server protocols maintained as separate packages, and an adopter can use any of those concrete implementations with the adopter’s generated code. No need to regenerate any code when switching between different transport implementations.

// Instantiate a concrete transport implementation.
let transport: any ClientTransport = ... // any client transport

// Instantiate the generated client by providing it with the transport.
let client = Client(transport: transport)

// Make API calls
let response = try await client.getStats(...)
...

The definitions of the transport and middleware protocols currently use currency types provided by the runtime library, representing the HTTP request and response.

These types need to be maintained and them being specific to the runtime library makes _implementing_ a transport or middleware a little more work, as you need to write code that converts, for example, from `OpenAPIRuntime.Request` to `Foundation.URLRequest`.

A new package open sourced earlier in 2023 called Swift HTTP Types opens the door to unifying the HTTP request and response types across the Swift ecosystem. By adopting it, we can get following benefits:

1. No need to maintain `OpenAPIRuntime.Request`, `OpenAPIRuntime.Response`, and friends.

2. Get improvements to Swift HTTP Types for free.

3. Simplify implementing concrete transports and middlewares for libraries that also use Swift HTTP Types (as no manual conversion needed).

### Proposed solution

We propose to use the `HTTPRequest` and `HTTPResponse` types (and other types they refer to, such as `HTTPFields`) provided by Swift HTTP Types in the transport and middleware protocols, and delete the request, response, and related types from the runtime library.

### Detailed design

Let’s compare each of the transport and middleware protocols as they are today to what they can be with Swift HTTP Types. Note that in the code snippets below, details not relevant to the proposal, such as code comments, are omitted.

#### Client transport

The existing `ClientTransport` protocol:

public protocol ClientTransport {
func send(
_ request: Request,
baseURL: URL,
operationID: String

}

The proposed `ClientTransport` protocol:

public protocol ClientTransport {
func send(
_ request: HTTPRequest, // <<< changed
body: HTTPBody?, // <<< added
baseURL: URL,
operationID: String

Notable changes:

- The request and response bodies are passed separately from the request and response metadata types.

- The fully qualified type names used are:

- `HTTPTypes.HTTPRequest`

- `HTTPTypes.HTTPResponse`

- `OpenAPIRuntime.HTTPBody`

#### Client middleware

The existing `ClientMiddleware` protocol:

public protocol ClientMiddleware: Sendable {
func intercept(
_ request: Request,
baseURL: URL,
operationID: String,

The proposed `ClientMiddleware` protocol:

public protocol ClientMiddleware {
func intercept(
_ request: HTTPRequest, // <<< changed
body: HTTPBody?, // <<< added
baseURL: URL,
operationID: String,

The changes are of the same nature as those to the client transport.

#### Server transport

The existing `ServerTransport` protocol:

public protocol ServerTransport {
func register(

method: HTTPMethod,
path: [RouterPathComponent],

The proposed `ServerTransport` protocol:

method: HTTPRequest.Method, // <<< changed
path: String // <<< changed
) throws
}

- The `OpenAPIRuntime.ServerRequestMetadata` type removes its `queryParameters` property, as it’s not needed as of version 0.2.0, where the query string is decoded directly, instead of receiving the key-value pairs from the transport. We held off the breaking change until 0.3.0, as 0.2.0 did not make breaking changes to the transport and middleware protocols.

- The `path` parameter is now a string instead of an array of parsed components. The string is the templated URI, for example `/pets/{petId}`. This change was made to support #199 path components that are parameters but also have a constant component, and it is up to the server transport implementation to parse the string and pull parameter names from it.

- Just like client transport, the request and response bodies are passed separately from the request and response metadata types.

#### Server middleware

The existing `ServerMiddleware` protocol:

public protocol ServerMiddleware: Sendable {
func intercept(
_ request: Request,
metadata: ServerRequestMetadata,
operationID: String,

The proposed `ServerMiddleware` protocol:

public protocol ServerMiddleware {
func intercept(
_ request: HTTPRequest, // <<< changed
body: HTTPBody?, // <<< added
metadata: ServerRequestMetadata,
operationID: String,

The changes are of the same nature as those to client transport, client middleware, and server transport.

### API stability

The users of concrete transport and middleware implementations will not have to make any changes, only the _implementors_ of transports and middlewares will need to adapt their packages to work with the new currency types.

### Future directions

Nothing beyond the same point about the async writer pattern from SOAR-0004.

#### Not adopting the package

An alternative here is to do nothing and not adopt the new package, however since the common HTTP types work so similarly to the types we had to maintain, it was never seriously considered not to take advantage of the common types. While the package is new right now, we expect wider adoption throughout the ecosystem in the coming years, at which point having our own currency types for HTTP requests and responses might be the exception rather than the rule.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0005: Adopting the Swift HTTP Types package
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0008

- Swift OpenAPI Generator
- Proposals
- SOAR-0008: OpenAPI document filtering

Article

# SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

## Overview

- Proposal: SOAR-0008

- Author(s): Si Beaumont

- Status: **Implemented (0.3.0)**

- Issue: apple/swift-openapi-generator#285

- Implementation: apple/swift-openapi-generator#319

- Review: ( review)

- Affected components: generator

- Related links:

- Project scope and goals
- Versions:

- v1 (2023-09-28): Initial version

- v2 (2023-10-05):

- Filtering by tag only includes the tagged operations (cf. whole path)

- Add support for filtering operations by ID

### Introduction

When generating client code, Swift OpenAPI Generator generates code for the entire OpenAPI document, even if the user only makes use of a subset of its types and operations.

Generating code that is unused constitutes overhead for the adopter:

- The overhead of generating code for unused types and operations

- The overhead of compiling the generated code

- The overhead of unused code in the users codebase (AOT generation)

This is particularly noticeable when working with a small subset of a large API, which can result in O(100k) lines of unused code and long generation and compile times.

The initial scope of the Swift OpenAPI Generator was to focus only on generating Swift code from an OpenAPI document, and any preprocessing of the OpenAPI document was considered out of scope. The proposed answer to this was to preprocess the document before providing to the generator\[\[0\]\].

Even with tooling, filtering the document requires more than just filtering the YAML or JSON document for the deterministic keys for the desired operations because such operations likely contain JSON references to the reusable types in the document’s `components` dictionary, and these components can themselves contain references. Consequently, in order to filter an OpenAPI document for a single operation requires including the transitive closure of the operations referenced dependencies.

Furthermore, it’s common that Swift OpenAPI Generator adopters do not own the OpenAPI document, and simply vendor it from the service owner. In these cases, it presents a user experience hurdle to have to edit the document, and a maintenance burden to continue to do so when updating the document to a new version.

Because this problem has a general solution that is non-trivial to implement, this proposal covers adding opt-in, configurable document filtering to the generator, to improve the user experience for those using a subset of a large API.

### Motivation

% cat api.github.com.yaml | wc -l
231063

% cat api.github.com.yaml | yq '.paths.* | keys' | wc -l
898

% cat api.github.com.yaml | yq '.components.* | keys' | wc -l
1260

% time ./swift-openapi-generator.release \
generate \
--mode types \
--config openapi-generator-config.yaml \
api.github.com.yaml
Writing data to file Types.swift...

real 0m41.397s
user 0m40.912s
sys 0m0.456s

% cat Types.swift | wc -l
458852

OpenAPI has support for grouping operations by tag. For example, the OpenAPI document for the Github API has the following tags:

% cat api.github.com.yaml | yq '[.tags[].name] | join(", ")'
actions, activity, apps, billing, checks, code-scanning, codes-of-conduct,
emojis, dependabot, dependency-graph, gists, git, gitignore, issues, licenses,
markdown, merge-queue, meta, migrations, oidc, orgs, packages, projects, pulls,
rate-limit, reactions, repos, search, secret-scanning, teams, users,
codespaces, copilot, security-advisories, interactions, classroom

If a user wants to make use of just the parts of the API that relate to Github issues, then they could work with a much smaller document. For example, filtering for only operations tagged `issues` (including all components on which those operations depend) results in an OpenAPI document that is just 25k lines with 40 operations and 90 reusable components, comprising a ~90% reduction in these dimensions.

Running the generator with `--mode types` with this filtered API document takes just 1.6 seconds\[^1\] and results in < 15k LOC, which is 20x faster and a 95% reduction in generated code.

% cat issues.api.github.com.yaml | wc -l
25314

% cat issues.api.github.com.yaml | yq '.paths.* | keys' | wc -l
40

% cat issues.api.github.com.yaml | yq '.components.* | keys' | wc -l
90

% time ./swift-openapi-generator.filter.release \
generate \
--mode types \
--config openapi-generator-config.yaml \
issues.api.github.com.yaml
Writing data to file Types.swift...

real 0m1.638s
user 0m1.595s
sys 0m0.031s

% cat Types.swift | wc -l
14691

### Proposed solution

We propose a configuable, opt-in filtering feature, which would run before generation, allowing users to select the paths and schemas they are interested in.

This would be driven by a new `filter` key in the config file used by the generator.

# filter:
# paths:
# - ...
# tags:
# operations:
# schemas:

For example, to filter the document for only paths that contain operations tagged with `issues` (along with the components on which those paths depend), users could add the following to their config file.

# openapi-generator-config.yaml
generate:
- types
- client

filter:
tags:
- issues

When this config key is present, the OpenAPI document will be filtered, before generation, to contain the paths and schemas requested, along with the transitive closure of components on which they depend.

This config key is optional; when it is not present, no filtering will take place.

The following filters will be supported:

- `paths`: Includes the given paths, specified using the same keys as ‘#/paths’ in the OpenAPI document.

- `tags`: Includes the operations with any of the given tags.

- `operations`: Includes the operations with these explicit operation IDs.

- `schemas`: Includes any schemas, specifid using the same keys as ‘#/components/schemas’ in the OpenAPI document.

When multiple filters are specified, their union will be considered for inclusion.

In all cases, the transitive closure of dependencies from the components object will be included.

Appendix A contains several examples on a real OpenAPI document.

### Detailed design

The config file is currently defined by an internal Codable struct, to which a new, optional property has been added:

--- a/Sources/swift-openapi-generator/UserConfig.swift
+++ b/Sources/swift-openapi-generator/UserConfig.swift
@@ -27,6 +27,9 @@ struct _UserConfig: Codable {
/// generated Swift file.
var additionalImports: [String]?

+ /// Filter to apply to the OpenAPI document before generation.
+ var filter: DocumentFilter?
+
/// A set of features to explicitly enable.
var featureFlags: FeatureFlags?
}

/// Rules used to filter an OpenAPI document.
struct DocumentFilter: Codable, Sendable {

/// Operations with these tags will be included.
var tags: [String]?

/// Operations with these IDs will be included.
var operations: [String]?

/// These paths will be included in the filter.
var paths: [OpenAPI.Path]?

/// These schemas will be included.
///
/// These schemas are included in addition to the transitive closure of
/// schema dependencies of the included paths.
var schemas: [String]?
}

Note that these types are not being added to any Swift API; they are just used to decode the `openapi-generator-config.yaml`.

### API stability

This change is purely API additive:

- Additional, optional keys in the config file schema.

#### Providing a \`fitler\` CLI command

Filtering the OpenAPI document has general utility beyond use within the generator itself. In the future, we could consider adding a CLI for filtering.

#### Not supporting including schema components

While the primary audience for this feature is adopters generating clients, there are use cases where adopters may wish to interact with serialized data that makes use of OpenAPI types. Indeed, OpenAPI is sometimes used as a language-agnostic means of defining types outside of the context of a HTTP service.

#### Supporting including other parts of the components object

While we chose to include schemas, for the reason highlighted above, we chose _not_ to allow including other parts of the components object (e.g. `parameters`, `requestBodies`, etc.).

That’s because, unlike schemas, which have standalone utility, all other components are only useful in conjuction with an API operation.

* * *

#### Input OpenAPI document

# unfiltered OpenAPI document
openapi: 3.1.0
info:
title: ExampleService
version: 1.0.0
tags:
- name: t
paths:
/things/a:
get:
operationId: getA
tags:
- t
responses:
200:
$ref: '#/components/responses/A'
delete:
operationId: deleteA
responses:
200:
$ref: '#/components/responses/Empty'
/things/b:
get:
operationId: getB
responses:
200:
$ref: '#/components/responses/B'
components:
schemas:
A:
type: string
B:
$ref: '#/components/schemas/A'
responses:
A:
description: success
content:
application/json:
schema:
$ref: '#/components/schemas/A'
B:
description: success
content:
application/json:
schema:
$ref: '#/components/schemas/B'
Empty:
description: success

#### Including paths by key

filter:
paths:
- /things/b

# filtered OpenAPI document
openapi: 3.1.0
info:
title: ExampleService
version: 1.0.0
tags:
- name: t
paths:
/things/b:
get:
operationId: getB
responses:
200:
$ref: '#/components/responses/B'
components:
schemas:
A:
type: string
B:
$ref: '#/components/schemas/A'
responses:
B:
description: success
content:
application/json:
schema:
$ref: '#/components/schemas/B'

#### Including operations by tag

filter:
tags:
- t

openapi: 3.1.0
info:
title: ExampleService
version: 1.0.0
tags:
- name: t
paths:
/things/a:
get:
tags:
- t
operationId: getA
responses:
200:
$ref: '#/components/responses/A'
components:
schemas:
A:
type: string
responses:
A:
description: success
content:
application/json:
schema:
$ref: '#/components/schemas/A'

#### Including schemas by key

filter:
schemas:
- B

openapi: 3.1.0
info:
title: ExampleService
version: 1.0.0
tags:
- name: t
components:
schemas:
A:
type: string
B:
$ref: '#/components/schemas/A'

#### Including operations by ID

filter:
operations:
- deleteA

openapi: 3.1.0
info:
title: ExampleService
version: 1.0.0
tags:
- name: t
paths:
/things/a:
delete:
operationId: deleteA
responses:
200:
$ref: '#/components/responses/Empty'
components:
responses:
Empty:
description: success

\[^1\]: Compiled in release mode, running on Apple M1 Max.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0008: OpenAPI document filtering
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- Appendix A: Examples
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/handling-nullable-schemas

- Swift OpenAPI Generator
- Documentation for maintainers
- Handling nullable schemas

Article

# Handling nullable schemas

Learn how the generator handles schema nullability.

## Overview

Both the OpenAPI specification itself and JSON Schema, which OpenAPI uses to describe payloads, make the important distinction between optional and required values.

As Swift not only supports, but enforces this distinction as well, Swift OpenAPI Generator represents nullable schemas as optional Swift values.

This document describes the rules used to decide which generated Swift types and properties are marked as optional.

### Optionality in OpenAPI and JSON Schema

OpenAPI 3.0.3 uses JSON Schema Draft 5, while OpenAPI 3.1.0 uses JSON Schema 2020-12. There are a few differences that we call out below, but it’s important to be aware of the fact that the generator needs to handle both.

The generator uses a simple rule: if any of the places that hint at optionality mark a field as optional, the value is generated as optional. It can be thought of as an `OR` operator.

### Standalone schemas

A schema in JSON Schema Draft 5 (used by OpenAPI 3.0.3) can be marked as optional using:

- the `nullable` field, a Boolean, if enabled, the field can be omitted and defaults to nil

For example:

MyOptionalString:
type: string
nullable: true

A schema in JSON Schema 2020-12 (used by OpenAPI 3.1.0) can be marked as optional by:

- adding `null` as one of the types, if present, the field can be omitted and defaults to nil

- the `nullable` keyword was removed in this JSON Schema version

MyOptionalString:
type: [string, null]

The nullability of a schema is propagated through references. That means if a schema is a reference, the generator looks up the target schema of the reference to decide whether the value is treated as optional.

### Schemas as object properties

In addition to the schema itself being marked as nullable, we also have to consider the context in which the schema is used.

When used as an object property, we must also consider the `required` array. For example, in the following example (valid for both JSON Schema and OpenAPI versions mentioned above), we have a JSON object with a required property `name` of type string, and an optional property `age` of type integer.

MyPerson:
type: object
properties:
name:
type: string
age:
type: integer
required:
- name

Notice that the `required` array only contains `name`, but not `age`. In objects, a property being omitted from the `required` array also signals to the generator that the property should be treated as an optional.

Marking the schema itself as nullable _as well_ doesn’t make a difference, it will still be treated as a single-wrapped optional. Same if the property is included in the `required` array but marked as `nullable`, it will be an optional.

That means the following alternative definition results in the same generated Swift code as the above.

MyPerson:
type: object
properties:
name:
type: string
age:
type: [integer, null]
required:
- name
- age # even though required, the nullability of the schema "wins"

### Schemas in parameters

Another context in which a schema can appear, in addition to being standalone or an object property, is as a parameter. Examples of parameters are header fields, query items, path parameters. The following also applies to request bodies, even though they’re not technically parameters.

OpenAPI defines a separate `required` field on parameters, of a Boolean value, which defaults to false (meaning parameters are optional by default).

parameters:
- name: limit
in: query
schema:
type: integer

The example above defines an optional query item called “limit” of type integer.

Such a property would be generated as an optional `Int`.

To mark the property as required, and get a non-optional `Int` value generated in Swift, add `required: true`.

parameters:
- name: limit
in: query
required: true
schema:
type: integer

This adds a third way to mark a value as optional to the previous two. Again, if any of them marks the parameter as optional, the generated Swift value will be optional as well.

## See Also

Converting between data and Swift types

Learn about the type responsible for converting between binary data and Swift types.

Generating custom Codable implementations

Learn about when and how the generator emits a custom Codable implementation.

Supporting recursive types

Learn how the generator supports recursive types.

- Handling nullable schemas
- Overview
- Optionality in OpenAPI and JSON Schema
- Standalone schemas
- Schemas as object properties
- Schemas in parameters
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0013

- Swift OpenAPI Generator
- Proposals
- SOAR-0013: Idiomatic naming strategy

Article

# SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

## Overview

- Proposal: SOAR-0013

- Author(s): Honza Dvorsky, Si Beaumont

- Status: **Implemented (1.6.0)**

- Versions:

- v1.0 (2024-11-27): Initial version

- v1.1 (2024-11-28): Also handle “/”, “{”, and “}” for better synthesized operation names

- v1.2 (2024-12-10): Treat “/” as a word separator and improve handling of the lowercasing of acronyms at the start of an identifier.

- v1.3 (2024-12-17): Add “+” as a word separator, clarify that defensive strategy always post-processes the output of the idiomatic strategy, clarify that content type names also change with the idiomatic strategy
- Issues:

- apple/swift-openapi-generator#112

- apple/swift-openapi-generator#107

- apple/swift-openapi-generator#503

- apple/swift-openapi-generator#244

- apple/swift-openapi-generator#405
- Implementation:

- apple/swift-openapi-generator#679
- New configuration options:

- `namingStrategy`

- `nameOverrides`
- Affected components:

- generator

### Introduction

Introduce a new naming strategy as an opt-in feature, instructing the generator to produce more conventional Swift names, and offer a way to completely customize how any OpenAPI identifier gets projected to a Swift identifier.

### Motivation

The purpose of Swift OpenAPI Generator is to generate Swift code from OpenAPI documents. As part of that process, names specified in the OpenAPI document have to be converted to names in Swift code - and there are many ways to do that. We call these “naming strategies” in this proposal.

When Swift OpenAPI Generator 0.1.0 went open-source in May 2023, it had a simple naming strategy that produced relatively conventional Swift identifiers from OpenAPI names.

However, when tested on a large test corpus of around 3000 OpenAPI documents, it produced an unacceptably high number of non-compiling packages due to naming conflicts. The root cause of conflicts are the different allowed character sets for OpenAPI names and Swift identifiers. OpenAPI has a more flexible allowed character set than Swift identifiers.

In response to these findings, SOAR-0001: Improved mapping of identifiers, which shipped in 0.2.0, changed the naming strategy to avoid these conflicts, allowing hundreds of additional OpenAPI documents to be correctly handled by Swift OpenAPI Generator. This addressed all issues related to naming conflicts in the test corpus. This is the existing naming strategy today. This strategy also avoids changing the character casing, as we discovered OpenAPI documents with properties within an object schema that only differed by case.

The way the conflicts are avoided in the naming strategy from SOAR-0001 is by turning any special characters (any characters that aren’t letters, numbers, or an underscore) into words, resulting in identifiers like:

Our priority was to support as many valid OpenAPI documents as possible. However, we’ve also heard from adopters who would prefer more idiomatic generated code and don’t benefit from the defensive naming strategy.

### Proposed solution

For clarity, we’ll refer to the existing naming strategy as the “defensive” naming strategy, and to the new proposed strategy as the “idiomatic” naming strategy. The names reflect the strengths of each strategy - the defensive strategy can handle any OpenAPI document and produce compiling Swift code, the idiomatic naming strategy produces prettier names, but does not work for all documents.

Part of the new strategy is adjusting the capitalization, and producing `UpperCamelCase` names for types, and `lowerCamelCase` names for members, as is common in hand-written Swift code.

This strategy will pre-process the input string, and then still apply the defensive strategy on the output, to handle any illegal characters that are no explicitly handled by the idiomatic strategy.

The configurable naming strategy will affect not only general names from the OpenAPI document ( SOAR-0001), but also content type names ( SOAR-0002).

#### Examples

To get a sense for the proposed change, check out the table below that compares the existing defensive strategy against the proposed idiomatic strategy on a set of examples:

| OpenAPI name | Defensive | Idiomatic (capitalized) | Idiomatic (non-capitalized) |
| --- | --- | --- | --- |
| `foo` | `foo` | `Foo` | `foo` |
| `Hello world` | `Hello_space_world` | `HelloWorld` | `helloWorld` |
| `My_URL_value` | `My_URL_value` | `MyURLValue` | `myURLValue` |
| `Retry-After` | `Retry_hyphen_After` | `RetryAfter` | `retryAfter` |
| `NOT_AVAILABLE` | `NOT_AVAILABLE` | `NotAvailable` | `notAvailable` |
| `version 2.0` | `version_space_2_period_0` | `Version2_0` | `version2_0` |
| `naïve café` | `naïve_space_café` | `NaïveCafé` | `naïveCafé` |
| `__user` | `__user` | `__User` | `__user` |
| `get/pets/{petId}` _Changed in v1.2_ | `get_sol_pets_sol__lcub_petId_rcub_` | `GetPetsPetId` | `getPetsPetId` |
| `HTTPProxy` _Added in v1.2_ | `HTTPProxy` | `HTTPProxy` | `httpProxy` |
| `application/myformat+json` _Added in v1.3_ | `application_myformat_plus_json` | - | `applicationMyformatJson` |
| `order#123` | `order_num_123` | `order_num_123` | `order_num_123` |

Notice that in the last example, since the OpenAPI name contains the pound ( `#`) character, the idiomatic naming strategy lets the defensive naming strategy handle the illegal character. In all the other cases, however, the resulting names are more idiomatic Swift identifiers.

### Detailed design

This section goes into detail of the draft implementation that you can already check out and try to run on your OpenAPI document.

#### Naming logic

The idiomatic naming strategy (check out the current code here, look for the method `safeForSwiftCode_idiomatic`) is built around the decision to _only_ optimize for names that include the following:

- letters

- numbers

- periods ( `.`, ASCII: `0x2e`)

- dashes ( `-`, ASCII: `0x2d`)

- underscores ( `_`, ASCII: `0x5f`)

- spaces ( ``, ASCII: `0x20`)

- slashes ( `/`, ASCII: `0x2f`) _Added in v1.1, changed meaning in 1.2_

- curly braces ( `{` and `}`, ASCII: `0x7b` and `0x7d`) _Added in v1.1_

- pluses ( `+`, ASCII: `0x2b`) _Added in v1.3_

If the OpenAPI name includes any _other_ characters, the idiomatic naming strategy lets the defensive strategy handle those characters.

There’s a second special case for handling all uppercased names, such as `NOT_AVAILABLE` \- if this situation is detected, the idiomatic naming strategy turns it into `NotAvailable` for types and `notAvailable` for members.

The best way to understand the detailed logic is to check out the code, feel free to leave comments on the pull request.

#### Naming strategy configuration

Since Swift OpenAPI Generator is on a stable 1.x version, we cannot change the naming strategy for everyone, as it would be considered an API break. So this new naming strategy is fully opt-in using a new configuration key called `namingStrategy`, with the following allowed values:

- `defensive`: the existing naming strategy introduced in 0.2.0

- `idiomatic`: the new naming strategy proposed here

- not specified: defaults to `defensive` for backwards compatibility

Enabling this feature in the configuration file would look like this:

namingStrategy: idiomatic

#### Name overrides

While the new naming strategy produces much improved Swift names, there are still cases when the adopter knows better how they’d like a specific OpenAPI name be translated to a Swift identifier.

A good examples are the `+1` and `-1` properties in the GitHub OpenAPI document: using both strategies, the names would be `_plus_1` and `_hyphen_1`, respectively. While such names aren’t too confusing, the adopter might want to customize them to, for example: `thumbsUp` and `thumbsDown`.

nameOverrides:
'+1': 'thumbsUp'
'-1': 'thumbsDown'

### API stability

Both the new naming strategy and name overrides are purely additive, and require the adopter to explicitly opt-in.

### Future directions

With this proposal, we plan to abandon the “naming extensions” idea, as we consider the solution in this proposal to solve the name conversion problem for Swift OpenAPI Generator 1.x for all use cases.

### Alternatives considered

- “Naming extensions”, however that’d require the community to build and maintain custom naming strategies, and it was not clear that this feature would be possible in SwiftPM using only current features.

- Not changing anything, this was the status quo since 0.2.0, but adopters have made it clear that there is room to improve the naming strategy through the several filed issues linked at the top of the proposal, so we feel that some action here is justified.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0013: Idiomatic naming strategy
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0011

- Swift OpenAPI Generator
- Proposals
- SOAR-0011: Improved Error Handling

Article

# SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

## Overview

- Proposal: SOAR-0011

- Author(s): Gayathri Sairamkrishnan

- Status: **Implemented**

- Issue: apple/swift-openapi-generator#609

- Affected components:

- runtime
- Versions:

- v1.0 (2024-09-19): Initial version

- v1.1(2024-10-07):

- Replace the proposed solution to have a single error handling protocol, with the status being required and headers/body being optional.

### Introduction

The goal of this proposal to improve the current error handling mechanism in Swift OpenAPI runtime. The proposal introduces a way for users to map errors thrown by their handlers to specific HTTP responses.

### Motivation

When implementing a server with Swift OpenAPI Generator, users implement a type that conforms to a generated protocol, providing one method for each API operation defined in the OpenAPI document. At runtime, if this function throws, it’s up to the server transport to transform it into an HTTP response status code – for example, some transport use `500 Internal Error`.

Instead, server developers may want to map errors thrown by the application to a more specific HTTP response. Currently, this can be achieved by checking for each error type in each handler’s catch block, converting it to an appropriate HTTP response and returning it.

For example,

do {
let response = try callGreetingLib()
return .ok(.init(body: response))
} catch let error {
switch error {
case GreetingError.authorizationError:
return .unauthorized(.init())
case GreetingError.timeout:
return ...
}
}
}

If a user wishes to map many errors, the error handling block scales linearly and introduces a lot of ceremony.

### Proposed solution

The proposed solution is twofold.

1. Provide a protocol in `OpenAPIRuntime` to allow users to extend their error types with mappings to HTTP responses.

2. Provide an (opt-in) middleware in OpenAPIRuntime that will call the conversion function on conforming error types when constructing the HTTP response.

Vapor has a similar mechanism called AbortError.

Hummingbird also has an error handling mechanism by allowing users to define a HTTPError

The proposal aims to provide a transport agnostic error handling mechanism for OpenAPI users.

#### Proposed Error protocols

Users can choose to conform to the error handling protocol below and optionally provide the optional fields depending on the level of specificity they would like to have in the response.

public protocol HTTPResponseConvertible {
var httpStatus: HTTPResponse.Status { get }
var httpHeaderFields: HTTPTypes.HTTPFields { get }
var httpBody: OpenAPIRuntime.HTTPBody? { get }
}

extension HTTPResponseConvertible {
var httpHeaderFields: HTTPTypes.HTTPFields { [:] }
var httpBody: OpenAPIRuntime.HTTPBody? { nil }
}

#### Proposed Error Middleware

The proposed error middleware in OpenAPIRuntime will convert the application error to the appropriate error response. It returns 500 for application error(s) that do not conform to HTTPResponseConvertible protocol.

public struct ErrorHandlingMiddleware: ServerMiddleware {
func intercept(_ request: HTTPTypes.HTTPRequest,
body: OpenAPIRuntime.HTTPBody?,
metadata: OpenAPIRuntime.ServerRequestMetadata,
operationID: String,

do {
return try await next(request, body, metadata)
} catch let error as ServerError {
if let appError = error.underlyingError as? HTTPResponseConvertible else {
return (HTTPResponse(status: appError.httpStatus, headerFields: appError.httpHeaderFields),
appError.httpBody)
} else {
throw error
}
}
}
}

Please note that the proposal places the responsibility to conform to the documented API in the hands of the user. There’s no mechanism to prevent the users from inadvertently transforming a thrown error into an undocumented response.

#### Example usage

1. Create an error type that conforms to the error protocol

extension MyAppError: HTTPResponseConvertible {
var httpStatus: HTTPResponse.Status {
switch self {
case .invalidInputFormat:
.badRequest
case .authorizationError:
.forbidden
}
}
}

2. Opt in to the error middleware while registering the handler

let handler = try await RequestHandler()
try handler.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])

### API stability

This feature is purely additive:

- Additional APIs in the runtime library

### Future directions

A possible future direction is to add the error middleware by default by changing the default value for the middlewares argument in handler initialisation.

### Alternatives considered

An alternative here is to invoke the error conversion function directly from OpenAPIRuntime’s handler. The feature would still be opt-in as users have to explicitly conform to the new error protocols.

However, there is a rare case where an application might depend on a library (for eg: an auth library) which in turn depends on OpenAPIRuntime. If the authentication library conforms to the new error protocols, this would result in a breaking change for the application, whereas an error middleware provides flexibility to the user on whether they want to subscribe to the new behaviour or not.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0011: Improved Error Handling
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0009

- Swift OpenAPI Generator
- Proposals
- SOAR-0009: Type-safe streaming multipart support

Article

# SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

## Overview

- Proposal: SOAR-0009

- Author(s): Honza Dvorsky

- Status: **Implemented (1.0.0)**

- Issue: apple/swift-openapi-generator#36

- Implementation: apple/swift-openapi-runtime#69, apple/swift-openapi-generator#366

- Review: ( review)

- Affected components: generator, runtime

- Related links:

- OpenAPI 3.0.3 specification

- OpenAPI 3.1.0 specification

- Swagger.io documentation on multipart support in OpenAPI 3.x

- RFC 7578: Returning Values from Forms: multipart/form-data

- RFC 2046: Multipurpose Internet Mail Extensions (MIME) Part Two: Media Types
- Versions:

- v1.0 (2023-11-08): Initial version

- v1.1 (2023-11-16): Replace the prefix “Randomized” with “Random” in the boundary generator name.

### Introduction

Support multipart requests and responses by providing a streaming way to produce and consume type-safe parts.

### Motivation

Since its first version, Swift OpenAPI Generator has supported OpenAPI operations that represent the most common HTTP request/response pairs.

For example, posting JSON data to a server, which can look like this:

>
> {"objectCatName":"Waffles","photographerId":24}

< HTTP/1.1 204 No Content

Or uploading a raw file, such as a photo, to a server:

>
> ...

In both of these examples, the HTTP message (a request or a response) has a single content type that describes the format of the body payload.

However, there are use cases where the client wants to send multiple different payloads, each of a different content type, in a single HTTP message. That’s what the multipart content type is for, and this proposal describes how Swift OpenAPI Generator can add support for it, providing both type safety while retaining a fully streaming API.

With multipart support, uploading both a JSON object and a raw file to the server in one request could look something like:

>
> --___MY_BOUNDARY_1234__
> content-disposition: form-data; name="metadata"
> content-type: application/json
> x-sender-id: zoom123
>
> {"objectCatName":"Waffles","photographerId":24}
> --___MY_BOUNDARY_1234__
> content-disposition: form-data; name="contents"
> content-type: image/jpeg
>
> ...
> --___MY_BOUNDARY_1234__--

While we’ll discuss the structure of a multipart message in detail below, the TL;DR is:

- This is still a regular HTTP message, just with a different content type and body.

- The body uses a _boundary_ string to separate individual _parts_.

- Each part has its own header fields and body.

Extra requirements to keep in mind:

- A multipart message must have at least one part (an empty multipart body is invalid).

- But, a part can have no headers or an empty body.

- So, the least you can send is a single part with no headers and no body bytes, but it’d still have the boundary strings around it, making it a valid multipart body consisting of one part.

### Proposed solution

As an example, let’s consider a service that allows uploading cat photos together with additional JSON metadata in a single request, as seen in the previous section.

#### Describing a multipart request in OpenAPI

Let’s define a `POST` request on the `/photos` path that accepts a `multipart/form-data` body containing 2 parts, one JSON part with the name “metadata”, and another called “contents” that contains the raw JPEG bytes of the cat photo.

In OpenAPI 3.1.0, the operation could look like this (irrelevant parts were omitted, see the full OpenAPI document in Appendix A):

paths:
/photos:
post:
requestBody:
required: true
content:
multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
contents:
type: string
contentEncoding: binary
required:
- metadata
- contents
encoding:
metadata:
headers:
x-sender-id:
schema:
type: string
contents:
contentType: image/jpeg

In OpenAPI, the schema for the multipart message is defined using JSON Schema, even though the top level schema is never actually serialized as JSON - it only serves as a way to define the individual parts.

The top level schema is always an object (or an object-ish type, such as allOf or anyOf of objects), and each property describes one part. Top level properties that describe an array schema are interpreted as a way to say that there might be more than one part of the provided name (matching the property name). The `required` property of the schema is used just like in regular JSON Schema – to communicate which properties (in this case, parts) are required and which are optional.

Finally, a sibling field of the `schema` is called `encoding` and mirrors the `schema` structure. For each part, you can override the content type and add custom header fields for each part.

#### Generating a multipart request in Swift

As with other Swift OpenAPI Generator features, the goal of generating code for multipart is to maximize type safety for adopters without compromising their ability to stream HTTP bodies.

With that in mind, multiple different strategies were considered for how to best represent a multipart body in Swift – for details, see the “Future directions” and “Alternatives considered” sections of this proposal.

To that end, we propose to represent a multipart body as an _async sequence of type-safe parts_ (spelled as `OpenAPIRuntime.MultipartBody` in this proposal). This is motivated by the fact that multipart bodies can be gigabytes in size and contain hundreds of parts, so any Swift representation that forces buffering immediately prevents advanced use cases.

In addition to `MultipartBody`, we are proposing a few new public types ( `MultipartPart` and `MultipartRawPart`) in the runtime library that are used in the Swift snippets below. The full proposed runtime library API diff can be found in Appendix B, and the details of each type will be discussed in “Detailed design” section.

Getting

let response = try await client.uploadPhoto(body: multipartBody)
// ...

Similarly to `OpenAPIRuntime.HTTPBody`, the `OpenAPIRuntime.MultipartBody` async sequence has several convenience initializers, making it easy to construct both from buffered and streaming sources.

For a buffered example, just provide an array of the part values, such as:

.metadata(.init(\
payload: .init(\
headers: .init(x_dash_sender_dash_id: "zoom123"),\
body: .init(objectCatName: "Waffles", photographerId: 24)\
)\
)),\
.contents(.init(\
payload: .init(\
body: .init(try Data(contentsOf: URL(fileURLWithPath: "/tmp/waffles-summer-2023.jpg")))\
),\
filename: "cat.jpg"\
))\
]
let response = try await client.uploadPhoto(body: multipartBody)
// ...

However, you can also stream the parts and their bodies:

let (stream, continuation) = AsyncStream.makeStream(of: Operations.uploadPhoto.Input.Body.multipartFormPayload.self)
// Pass `continuation` to another task to start producing parts by calling `continuation.yield(...)` and at the end, `continuation.finish()`.
let response = try await client.uploadPhoto(body: .init(stream))
// ...

#### Consuming a multipart body sequence

When consuming a multipart body sequence, for example as a client consuming a multipart response, or a server consuming a multipart request, you are provided with the multipart body async sequence and are responsible for iterating it to completion.

Additionally, for received parts that have their own streaming bodies, you _must_ consume those bodies before requesting the next part, as the underlying async sequence never does any buffering for you, so you can’t “skip” any parts or chunks of bytes within a part without explicitly consuming it.

Consuming a multipart body, where you print the metadata fields, and write the photo to disk, could look something like this:

for try await part in multipartBody {
switch part {
case .metadata(let metadataPart):
let metadata = metadataPart.payload

print("Cat name: \(metadata.body.objectCatName)")

case .contents(let contentsPart):
// Ensure the incoming filepath doesn't try to escape to a parent directory, and so on, before using it.
let fileName = contentsPart.filename ?? "\(UUID().uuidString).jpg"
guard let outputStream = OutputStream(toFileAtPath: "/tmp/received-cat-photos/\(fileName)", shouldAppend: false) else {
// failed to open a stream
}
outputStream.open()
defer {
outputStream.close()
}
// Consume the body before moving to the next part.
for try await chunk in contentsPart.body {
chunk.withUnsafeBufferPointer { _ = outputStream.write($0.baseAddress!, maxLength: $0.count) }
}
case .undocumented(let rawPart):
print("Received an undocumented part with header fields: \(rawPart.headerFields)")
// Consume the body before moving to the next part.

}
}

### Detailed design

This section describes more details of the functionality supporting the kind of examples we saw above.

#### Different enum case types

In this section, we enumerate the different enum case types and under what circumstances they are generated.

- **Scenario A**: Zero or more documented cases and `additionalProperties` is not set - a common default.

- Also generates an `undocumented` case with an associated type `MultipartRawPart`.

OpenAPI:

multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'

Generated Swift enum members:

struct metadataPayload {
var body: Components.Schemas.PhotoMetadata
}

case undocumented(MultipartRawType)

- **Scenario B**: Zero or more documented cases and `additionalProperties: true`.

- For each documented case, same as Scenario A.

- Also generates an `other` case with an associated type `MultipartRawPart`.

- Note that while similar to `undocumented`, the `other` case uses a different name to communicate the fact that the OpenAPI author deliberately enabled `additionalProperties` and thus any parts with unknown names are expected – so the name “undocumented” would not be appropriate.

multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
additionalProperties: true

case other(MultipartRawType)

- Also generates an `other` case with an associated type `MultipartDynamicallyNamedPart`.

- Note that while similar to `MultipartPart`, `MultipartDynamicallyNamedPart` adds a read-write `name` property, because while the part name is statically known when `MultipartPart` is used, that’s not the case when `MultipartDynamicallyNamedPart` is used, thus the extra property into which the part name is written is required.

- Also, since there is no way to define custom headers in this case, the generic parameter of `MultipartDynamicallyNamedPart` is the body value itself, instead of being nested in an `otherPayload` generated struct like for statically documented parts.

multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
additionalProperties:
$ref: '#/components/schemas/OtherInfo'

- **Scenario D**: Zero or more documented cases and `additionalProperties: false`.

- No other cases are generated, and the runtime validation logic ensures that no undocumented part is allowed through.

multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
additionalProperties: false

#### Validation

Since the OpenAPI document can describe some parts as single value properties, and others as array; and some as required, while others as optional, the generator will emit code that enforces these semantics in the internals of the `MultipartBody` sequence.

The following will be enforced:

- if a property is a required single value, the sequence fails validation with an error if a part of that name is not seen before the sequence is finished, or if it appears multiple times

- if a property is an optional single value, the sequence fails validation with an error if a part of that name is seen multiple times

- if a property is a required array value, the sequence fails validation with an error if a part of that name is not seen at least once

- if a property is an optional array value, the sequence never fails validation, as any number, from 0 up, are a valid number of occurrences

- if `additionalProperties` is not specified, the default behavior is to allow undocumented parts through

- if `additionalProperties: true`, the sequence never fails validation when an undocumented part is encountered

- if `additionalProperties: false`, the sequence fails validation if an undocumented part is encountered

This validation is implemented as a private async sequence inserted into the chain with the names of parts that need the specific requirements enforced. This affords the adopter the same amount of type safety as the rest of the generated code, such as `Codable` generated types that parse from JSON.

Optionality of parts is not reflected as an optional type ( `Type?`) here, instead the _absence_ of a part in the async sequence represents it being nil.

#### Boundary customization

When sending a multipart message, the sender needs to choose a boundary string (for example, `___MY_BOUNDARY_1234__`) that is used to separate the individual parts. The boundary string must not appear in any of the parts themselves.

The runtime library comes with two implementations, `ConstantMultipartBoundaryGenerator` and `RandomMultipartBoundaryGenerator`.

`ConstantMultipartBoundaryGenerator` returns the same boundary every time and is useful for testing and in cases where stable output for stable inputs is desired, for example for caching. `RandomMultipartBoundaryGenerator` uses a constant prefix and appends a random suffix made out of `0-9` digits, returning a different output every time.

By default, the updated `Configuration` uses the random boundary generator, but the adopter can switch to the constant one, or provide a completely custom implementation.

#### The OpenAPI Encoding object

In the initial example (again listed below), we saw how to use the `encoding` object in the OpenAPI document to:

1. explicitly specify the content type `image/jpeg` for the `contents` part.

2. define a custom header field `x-sender-id` for the `metadata` part.

multipart/form-data:
schema:
type: object
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
contents:
type: string
contentEncoding: binary
required:
- metadata
- contents
encoding:
metadata:
headers:
x-sender-id:
schema:
type: string
contents:
contentType: image/jpeg

Adopters only need to explicitly specify the content type if the inferred content type doesn’t match what they need.

The inferred content type uses the following logic, copied from the OpenAPI 3.1.0 specification:

The generator follows these rules and once a serialization method is chosen, treats the payloads the same way as bodies in regular HTTP requests and responses.

Custom headers are also optional, so if the default content type is correctly inferred, and the adopter doesn’t need any custom headers, the `encoding` object can be omitted from the OpenAPI document.

#### Optional multipart request bodies

While the OpenAPI specification allows a request body to be optional, in multipart the rule is that at least one part must be sent, so a nil or empty multipart sequence is not valid. For that reason, when the generator encounters an optional multipart request body, it will emit a warning diagnostic and treat it as a required one (as we assume that the OpenAPI author just forgot to mark the body as required).

### API stability

- Runtime API:

- All of the runtime API changes are purely additive, so this feature does not require a new API-breaking release of the runtime library.
- Generated API:

- However, we will stage it into the 0.3.x release behind a feature flag, and enable it in the next API-breaking release of the generator.

### Future directions

As this proposal already is of a considerable size and complexity, we chose to defer some additional ideas to future proposals. Those will be considered based on feedback from real-world usage of this initial multipart support.

#### A buffered representation of the full body

While we believe that offering a fully streaming representation of the multipart parts, and even their individual bodies, is the correct choice at the lowest type-safe layer, some adopters might not take advantage of the streaming nature, and the streaming API might not be ergonomic for them. This might especially be the case when the individual parts are small and were sent in one data chunk from the client anyway, for example from an HTML form in a web browser.

For such adopters, it might make sense to generate an extra convenience type that has a property for each part, and is only delivered to the receiver once all the data has come in. This type would represent optional values as optional properties, and array values as array properties, closer to the generated `Codable` types.

This change should be purely additive, and would build on top of the multipart async sequence form this proposal. The generated code should simply accumulate all the parts, and then assign them to the properties on this generated type.

The feature needs to be balanced against the cost of generating another variant of the code we will already generate with this proposal, and it’s also important not to let it overshadow the streaming variant, as then even adopters who would benefit from streaming might not use it, because they might see the buffered type first and not realize multipart streaming is even supported.

#### Other multipart subtypes

This proposal focuses on the `multipart/form-data` type, but there are other multipart variants, such as `multipart/alternative` and `multipart/mixed`. It might make sense to add support for these in the future as well.

### Alternatives considered

This proposal is a product of several months of thinking about how to best represent multipart in a type-safe, yet streaming, way. Below is an incomplete list of other ideas that were considered, and the reasons we ultimately chose not to pursue them.

#### No action - keep multipart as a raw body

The first obvious alternative to adding type-safe support for multipart is to _not_ do it. It has the advantage of preserving the streaming nature, and doesn’t force buffering on users.

However, better support for multipart has been the top adopter request in recent months, so it seemed clear that the status quo is not sufficient. On the wire, multipart is not trivial to serialize and parse correctly, so asking every adopter to reimplement it seemed suboptimal.

It also doesn’t align with our goal of maximizing type-safety without compromising on streaming.

#### Only surfacing raw parts

The next step on the spectrum is to provide a sequence of parsed raw parts (in other words, the header fields and the raw body), without generating custom code for each part.

It has the advantage of taking care of the trickiest part of multipart, and that’s the serialization and parsing of parts between boundaries, and it retains streaming. However, it drops on the floor the static information the adopter authored in their OpenAPI document, and seems inconsistent with the rest of the generated code, where we do generate custom code for each schema.

However, in a scenario where we didn’t have time to implement the more advanced solution, this still would have been a decent quality-of-life improvement.

#### No runtime validation of part semantics

Even with type-safe generated parts, as proposed, we could avoid doing runtime validation of the part semantics defined in the OpenAPI document, such as that a required part did actually arrive before the multipart body sequence was completed, and that only parts described by an array schema are allowed to appear more than once.

While skipping this work would simplify implementation a little bit, it would again weaken the trust that adopters can have in the type-safe code truly verifying as much information as possible from the OpenAPI document.

The verification happens in a private async sequence that’s inserted into the middle of the serialization/parsing chain, so is mostly implemented in the runtime library, not really affecting the complexity of the generator.

#### Buffered representation at the bottom layer

We also could have generated custom code for the schema describing the parts, and only offer a non-streaming, buffered representation of the multipart body. However, that seems to go against the work we did in 0.3.0 to transition the transport and middleware layers to fully streaming mode, unlocking high-performance use cases, and would arbitrarily treat multipart as somewhat different to all the other content types.

While this is what most other code generators for OpenAPI do today, we didn’t just want to follow precedent. We wanted to show how the power of Swift’s type safety combined with modern concurrency features allows library authors not to be forced to choose between type-safety and performance – Swift gives us both. It certainly did require more work and several iterations, especially around the layering of `MultipartRawPart`, `MultipartDynamicallyNamedPart`, and `MultipartPart`, but we believe what we propose here is ready for wider feedback.

### Feedback

We’re looking for feedback from:

- potential adopters of multipart, both on client and server, both with buffering and streaming use cases

- contributors of Swift OpenAPI Generator, about how this fits into the rest of the tool

And we’re especially looking for ideas on the naming of the new types, especially:

- `MultipartRawType`

- `MultipartDynamicallyNamedPart`

- `MultipartPart`

- `MultipartBody`

That said, any and all feedback is appreciated, especially the kind that can help newcomers pick up the API and easily work with multipart.

### Acknowledgements

A special thanks to Si Beaumont for helping refine this proposal with thoughtful feedback.

### Appendix A: Example OpenAPI document with multipart bodies

openapi: '3.1.0'
info:
title: Cat photo service
version: 2.0.0
paths:
/photos:
post:
operationId: uploadPhoto
description: Uploads the provided photo with metadata to the server.
requestBody:
required: true
content:
multipart/form-data:
schema:
type: object
description: The individual parts of the photo upload.
properties:
metadata:
$ref: '#/components/schemas/PhotoMetadata'
description: Extra information about the uploaded photo.
contents:
type: string
contentEncoding: binary
description: The raw contents of the photo.
required:
- metadata
- contents
encoding:
metadata:
# No need to explicitly specify `contents: application/json` because
# it's inferred from the schema itself.
headers:
x-sender-id:
# Note that this serves as an example of a part header.
# But conventionally, you'd include this property in the metadata JSON instead.
description: The identifier of the device sending the photo.
schema:
type: string
contents:
contentType: image/jpeg
responses:
'204':
description: Successfully uploaded the file.
components:
schemas:
PhotoMetadata:
type: object
description: Extra information about a photo.
properties:
objectCatName:
type: string
description: The name of the cat that's in the photo.
photographerId:
type: integer
description: The identifier of the photographer.
required:
- objectCatName
OtherInfo:
type: object
description: Other information.

### Appendix B: Runtime library API changes

1. New API to represent a boundary generator.

/// A generator of a new boundary string used by multipart messages to separate parts.
public protocol MultipartBoundaryGenerator : Sendable {

/// Generates a boundary string for a multipart message.
/// - Returns: A boundary string.

}

extension MultipartBoundaryGenerator where Self == OpenAPIRuntime.ConstantMultipartBoundaryGenerator {

/// A generator that always returns the same boundary string.
public static var constant: OpenAPIRuntime.ConstantMultipartBoundaryGenerator { get }
}

extension MultipartBoundaryGenerator where Self == OpenAPIRuntime.RandomMultipartBoundaryGenerator {

/// A generator that produces a random boundary every time.
public static var random: OpenAPIRuntime.RandomMultipartBoundaryGenerator { get }
}

/// A generator that always returns the same constant boundary string.
public struct ConstantMultipartBoundaryGenerator : OpenAPIRuntime.MultipartBoundaryGenerator {

/// The boundary string to return.
public let boundary: String

/// Creates a new generator.
/// - Parameter boundary: The boundary string to return every time.
public init(boundary: String = "__X_SWIFT_OPENAPI_GENERATOR_BOUNDARY__")

/// A generator that returns a boundary containg a constant prefix and a randomized suffix.
public struct RandomMultipartBoundaryGenerator : OpenAPIRuntime.MultipartBoundaryGenerator {

/// The constant prefix of each boundary.
public let boundaryPrefix: String

/// The length, in bytes, of the randomized boundary suffix.
public let randomNumberSuffixLength: Int

/// Create a new generator.
/// - Parameters:
/// - boundaryPrefix: The constant prefix of each boundary.
/// - randomNumberSuffixLength: The length, in bytes, of the randomized boundary suffix.
public init(boundaryPrefix: String = "__X_SWIFT_OPENAPI_", randomNumberSuffixLength: Int = 20)

2. Customizing the boundary generator on `Configuration`.

The below property and initializer added to the Configuration struct, while the existing initializer is deprecated.

/// A set of configuration values used by the generated client and server types.
/* public struct Configuration : Sendable { */

/// The generator to use when creating mutlipart bodies.
public var multipartBoundaryGenerator: OpenAPIRuntime.MultipartBoundaryGenerator

/// Creates a new configuration with the specified values.
///
/// - Parameters:
/// - dateTranscoder: The transcoder to use when converting between date
/// and string values.
/// - multipartBoundaryGenerator: The generator to use when creating mutlipart bodies.
public init(dateTranscoder: OpenAPIRuntime.DateTranscoder = .iso8601, multipartBoundaryGenerator: OpenAPIRuntime.MultipartBoundaryGenerator = .random)

/// Creates a new configuration with the specified values.
///
/// - Parameter dateTranscoder: The transcoder to use when converting between date
/// and string values.
@available(*, deprecated, renamed: "init(dateTranscoder:multipartBoundaryGenerator:)")
public init(dateTranscoder: OpenAPIRuntime.DateTranscoder)
/* } */

3. New multipart part types.

/// A raw multipart part containing the header fields and the body stream.
public struct MultipartRawPart : Sendable, Hashable {

/// The header fields contained in this part, such as `content-disposition`.
public var headerFields: HTTPTypes.HTTPFields

/// The body stream of this part.
public var body: OpenAPIRuntime.HTTPBody

/// Creates a new part.
/// - Parameters:
/// - headerFields: The header fields contained in this part, such as `content-disposition`.
/// - body: The body stream of this part.
public init(headerFields: HTTPTypes.HTTPFields, body: OpenAPIRuntime.HTTPBody)
}

extension MultipartRawPart {

/// Creates a new raw part by injecting the provided name and filename into
/// the `content-disposition` header field.
/// - Parameters:
/// - name: The name of the part.
/// - filename: The file name of the part.
/// - headerFields: The header fields of the part.
/// - body: The body stream of the part.
public init(name: String?, filename: String? = nil, headerFields: HTTPTypes.HTTPFields, body: OpenAPIRuntime.HTTPBody)

/// The name of the part stored in the `content-disposition` header field.
public var name: String?

/// The file name of the part stored in the `content-disposition` header field.
public var filename: String?
}

/// A wrapper of a typed part with a statically known name that adds other
/// dynamic `content-disposition` parameter values, such as `filename`.

/// The underlying typed part payload, which has a statically known part name.
public var payload: Payload

/// A file name parameter provided in the `content-disposition` part header field.
public var filename: String?

/// Creates a new wrapper.
/// - Parameters:
/// - payload: The underlying typed part payload, which has a statically known part name.
/// - filename: A file name parameter provided in the `content-disposition` part header field.
public init(payload: Payload, filename: String? = nil)
}

/// A wrapper of a typed part without a statically known name that adds
/// dynamic `content-disposition` parameter values, such as `name` and `filename`.

/// A name parameter provided in the `content-disposition` part header field.
public var name: String?

/// Creates a new wrapper.
/// - Parameters:
/// - payload: The underlying typed part payload, which has a statically known part name.
/// - filename: A file name parameter provided in the `content-disposition` part header field.
/// - name: A name parameter provided in the `content-disposition` part header field.
public init(payload: Payload, filename: String? = nil, name: String? = nil)
}

4. New multipart body async sequence type.

/// The body of multipart requests and responses.
///
/// `MultipartBody` represents an async sequence of multipart parts of a specific type.
///
/// The `Part` generic type parameter is usually a generated enum representing
/// the different values documented for this multipart body.
///
/// ## Creating a body from buffered parts
///
/// Create a body from an array of values of type `Part`:
///
/// ```swift

/// .myCaseA(...),\
/// .myCaseB(...),\
/// ]
/// ```
///
/// ## Creating a body from an async sequence of parts
///
/// The body type also supports initialization from an async sequence.
///
/// ```swift
/// let producingSequence = ... // an AsyncSequence of MyPartType
/// let body = MultipartBody(
/// producingSequence,
/// iterationBehavior: .single // or .multiple
/// )
/// ```
///
/// In addition to the async sequence, also specify whether the sequence is safe
/// to be iterated multiple times, or can only be iterated once.
///
/// Sequences that can be iterated multiple times work better when an HTTP
/// request needs to be retried, or if a redirect is encountered.
///
/// In addition to providing the async sequence, you can also produce the body
/// using an `AsyncStream` or `AsyncThrowingStream`:
///
/// ```swift
/// let (stream, continuation) = AsyncStream.makeStream(of: MyPartType.self)
/// // Pass the continuation to another task that produces the parts asynchronously.
/// Task {
/// continuation.yield(.myCaseA(...))
/// // ... later
/// continuation.yield(.myCaseB(...))
/// continuation.finish()
/// }
/// let body = MultipartBody(stream)
/// ```
///
/// ## Consuming a body as an async sequence
///
/// The `MultipartBody` type conforms to `AsyncSequence` and uses a generic element type,
/// so it can be consumed in a streaming fashion, without ever buffering the whole body
/// in your process.
///
/// ```swift

/// for try await part in multipartBody {
/// switch part {
/// case .myCaseA(let myCaseAValue):
/// // Handle myCaseAValue.
/// case .myCaseB(let myCaseBValue):
/// // Handle myCaseBValue, which is a raw type with a streaming part body.
/// //
/// // Option 1: Process the part body bytes in chunks.
/// for try await bodyChunk in myCaseBValue.body {
/// // Handle bodyChunk.
/// }
/// // Option 2: Accumulate the body into a byte array.
/// // (For other convenience initializers, check out ``HTTPBody``.
/// let fullPartBody = try await UInt8
/// // ...
/// }
/// }
/// ```
///
/// Multipart parts of different names can arrive in any order, and the order is not significant.
///
/// Consuming the multipart body should be resilient to parts of different names being reordered.
///
/// However, multiple parts of the same name, if allowed by the OpenAPI document by defining it as an array,
/// should be treated as an ordered array of values, and those cannot be reordered without changing
/// the message's meaning.
///

/// have their bodies fully consumed before the multipart body sequence is asked for
/// the next part. The multipart body sequence does not buffer internally, and since
/// the parts and their bodies arrive in a single stream of bytes, you cannot move on
/// to the next part until the current one is consumed.

/// The iteration behavior, which controls how many times the input sequence can be iterated.
public let iterationBehavior: OpenAPIRuntime.IterationBehavior
}

extension MultipartBody : Equatable {

extension MultipartBody : Hashable {
public func hash(into hasher: inout Hasher)
}

extension MultipartBody {

/// Creates a new sequence with the provided async sequence of parts.
/// - Parameters:
/// - sequence: An async sequence that provides the parts.
/// - iterationBehavior: The iteration behavior of the sequence, which indicates whether it
/// can be iterated multiple times.

/// Creates a new sequence with the provided collection of parts.
/// - Parameter elements: A collection of parts.

/// Creates a new sequence with the provided async throwing stream.
/// - Parameter stream: An async throwing stream that provides the parts.

/// Creates a new sequence with the provided async stream.
/// - Parameter stream: An async stream that provides the parts.

extension MultipartBody : ExpressibleByArrayLiteral {

extension MultipartBody : AsyncSequence {
public typealias Element = Part

extension MultipartBody {
public struct Iterator : AsyncIteratorProtocol {

5. Move `HTTPBody.IterationBehavior` to the top of the module, as `OpenAPIRuntime.IterationBehavior`.

It is then used by `MultipartBody` as well as `HTTPBody`.

A deprecated compatibility typealias is added to `HTTPBody` to retain source stability, but it’ll be removed on the next API break.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0009: Type-safe streaming multipart support
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- Feedback
- Acknowledgements
- Appendix A: Example OpenAPI document with multipart bodies
- Appendix B: Runtime library API changes
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/supporting-recursive-types

- Swift OpenAPI Generator
- Documentation for maintainers
- Supporting recursive types

Article

# Supporting recursive types

Learn how the generator supports recursive types.

## Overview

In some applications, the most expressive way to represent arbitrarily nested data is using a type that holds another value of itself, either directly, or through another type. We refer to such types as _recursive types_.

By default, structs and enums do not support recursion in Swift, so the generator needs to detect recursion in the OpenAPI document and emit a different internal representation for the Swift types involved in recursion.

This article discusses the details of what boxing is, and how the generator chooses the types to box.

### Examples of recursive types

One example of a recursive type would be a file system item, representing a tree. The `FileItem` node contains more `FileItem` nodes in an array.

FileItem:
type: object
properties:
name:
type: string
isDirectory:
type: boolean
contents:
type: array
items:
$ref: '#/components/schemas/FileItem'
required:
- name

Another example would be a `Person` type, that can have a `partner` property of type `Person`.

Person:
type: object
properties:
name:
type: string
partner:
$ref: '#/components/schemas/Person'
required:
- name

### Recursive types in Swift

In Swift, the generator emits structs or enums for JSON schemas that support recursion (enums for `oneOf`, structs for `object`, `allOf`, and `anyOf`). Both structs and enums require that their size is known at compile time, however for arbitrarily nested values, such as a file system hierarchy, it cannot be known at compile time how deep the nesting goes. If such types were generated naively, they would not compile.

To allow recursion, a _reference_ Swift type must be involved in the reference cycle (as opposed to only _value_ types). We call this technique of using a reference type for storage inside a value type “boxing” and it allows for the outer type to keep its original API, including value semantics, but at the same time be used as a recursive type.

### Boxing different Swift types

- Enums can be boxed by adding the `indirect` keyword to the declaration, for example by changing:

public enum Directory {}

to:

public indirect enum Directory { ... }

When an enum type needs to be boxed, the generator simply includes the `indirect` keyword in the generated type.

- Structs require more work, including:

- Moving the stored properties into a private `final class Storage` type.

- Adding an explicit setter and getter for each property that calls into the storage.

- Adjusting the initializer to forward the initial values to the storage.

- Using a copy-on-write wrapper for the storage to avoid creating copies unless multiple references exist to the value and it’s being modified.

For example, the original struct:

public struct Person {
public var partner: Person?
public init(partner: Person? = nil) {
self.partner = partner
}
}

Would look like this when boxed:

public struct Person {
public var partner: Person? {
get { storage.value.partner }
_modify { yield &storage.value.partner }
}
public init(partner: Person? = nil) {
self.storage = .init(Storage(partner: partner))
}

var partner: Person?
public init(partner: Person? = nil) {
self.partner = partner
}
}
}

The details of the copy-on-write wrapper can be found in the runtime library, where it’s defined.

- Arrays and dictionaries are reference types under the hood (but retain value semantics) and can already be considered boxed. For that reason, the first example that showed a `FileItem` type actually would compile successfully, because the `contents` array is already boxed. That means the `FileItem` type itself does not require boxing.

- Pure reference schemas can contribute to reference cycles, but cannot be boxed, because they are represented as a `typealias` in Swift. For that reason, the algorithm never chooses a `$ref` type for boxing, and instead boxes the next eligible type in the cycle.

### Computing which types need boxing

Since a boxed type requires an internal reference type, and can be less performant than a non-recursive value type, the generator implements an algorithm that _minimizes_ the number of boxed types required to make all the reference cycles still build successfully.

The algorithm outputs a list of type names that require boxing.

It iterates over the types defined in `#/components/schemas`, in the order defined in the OpenAPI document, and for each type walks all of its references.

Once it detects a reference cycle, it adds the first type in the cycle, in other words the one to which the last reference closed the cycle.

For example, walking the following:

The algorithm would choose type “B” for boxing.

## See Also

Converting between data and Swift types

Learn about the type responsible for converting between binary data and Swift types.

Generating custom Codable implementations

Learn about when and how the generator emits a custom Codable implementation.

Handling nullable schemas

Learn how the generator handles schema nullability.

- Supporting recursive types
- Overview
- Examples of recursive types
- Recursive types in Swift
- Boxing different Swift types
- Computing which types need boxing
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0010

- Swift OpenAPI Generator
- Proposals
- SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Article

# SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

## Overview

- Proposal: SOAR-0010

- Author(s): Honza Dvorsky

- Status: **Implemented (1.2.0)**

- Issue: apple/swift-openapi-generator#416

- Implementation:

- apple/swift-openapi-runtime#91

- apple/swift-openapi-generator#494
- Affected components:

- generator (examples and docs only)

- runtime (streaming encoders and decoders)
- Related links:

- JSON Lines

- JSON Sequence

- Server-sent Events

### Introduction

Add streaming encoders and decoders for these three event stream formats to the runtime library, allowing adopters to easily produce and consume event streams, both on the client and server.

### Motivation

While the OpenAPI specification is optimized for HTTP APIs that send a single request value, and receive a single response value, there are many use cases in which developers want to stream values over time.

A simple example of streaming “values” is a file transfer, which can be thought of as a stream of byte chunks that represent the contents of the file. Another is multipart content, streaming individual parts over time. Both of these are already supported by Swift OpenAPI Generator, as of version 0.3.0 and 1.0.0-alpha.1, respectively.

Another popular use case for streaming is to send JSON-encoded events over time, usually (but not exclusively), from the server to the client.

- The Kubernetes API uses JSON Lines to stream updates to resources from its control plane.

- The OpenAI API uses Server-sent Events to stream text snippets from ChatGPT.

- I couldn’t find a popular service using JSON Sequence, but unlike JSON Lines, it’s well-defined in RFC7464, and also used around the industry.

The flow starts with the client initiating an HTTP request to the server, and the server responding with an HTTP response head, and then the server starting to stream the response body, which contains the delimited events, processed over time by the client.

This lightweight solution has the advantage of being a plain HTTP request/response pair, without requiring a custom protocol to either replace HTTP, or sit on top of it. This makes intermediaries, such as proxies, still able to pass data through without being aware of the streaming nature of the HTTP body.

### Proposed solution

Since the OpenAPI specification does not explicitly mention event streaming, it’s up to tools, such as Swift OpenAPI Generator, to provide additional conveniences.

This proposed solution consists of two parts:

1. Add streaming encoders and decoders for the three event stream formats to the runtime library, represented as an `AsyncSequence` that converts elements between byte chunks and parsed events.

2. Provide examples for how adopters can then chain those sequences on the `HTTPBody` values they either produce or consume, in their code. No extra code would be generated.

Generally, the three event stream formats are associated with the following content types:

- JSON Lines: `application/jsonl`, `application/x-ndjson`

- JSON Sequence: `application/json-seq`

- Server-sent Events: `text/event-stream`

The generated code would continue to only vend the raw sequence of byte chunks ( `HTTPBody`), and adopters could optionally chain the encoding/decoding sequence on it. For example, an OpenAPI document with a JSON Lines stream of `Greeting` values could contain the following:

paths:
/greetings:
get:
operationId: getGreetingsStream
responses:
'200':
content:
application/jsonl:
schema:
$ref: '#/components/schemas/Greeting'
components:
schemas:
Greeting:
type: object
properties:
...

The important part is the `application/jsonl` (JSON Lines) content type (not to be confused with a plain `application/json` content type), and the event schema in `#/components/schemas`.

#### Consuming event streams

As a consumer of such a body in Swift (usually on the client), you’d use one of the proposed methods, here `asDecodedJSONLines(of:decoder:)` to get a stream that parses the individual JSON lines and decodes each JSON object as a value of `Components.Schemas.Greeting`.

Then, you can read the stream, for example in a `for try await` loop.

let response = try await client.getGreetingsStream()
let httpBody = try response.ok.body.application_jsonl
let greetingStream = httpBody.asDecodedJSONLines(of: Components.Schemas.Greeting.self)
for try await greeting in greetingStream {
print("Got greeting: \(greeting.message)")
}

#### Producing event streams

As a producer of such a body, start with a root async sequence, for example an `AsyncStream`, and submit events to it.

// Pass the continuation to another task that calls
// `continuation.yield(...)` with events, and `continuation.finish()`
// at the end.

let httpBody = HTTPBody(
stream.asEncodedJSONLines(),
length: .unknown,
iterationBehavior: .single
)
// Provide `httpBody` to the response, for example.
return .ok(.init(body: .application_jsonl(httpBody)))

### Detailed design

The rest of this section contains the Swift interface of the new API for the runtime library.

/// A sequence that parses arbitrary byte chunks into lines using the JSON Lines format.

/// Creates a new sequence.
/// - Parameter upstream: The upstream sequence of arbitrary byte chunks.
public init(upstream: Upstream)
}

extension JSONLinesDeserializationSequence : AsyncSequence {

}

/// Returns another sequence that decodes each JSON Lines event as the provided type using the provided decoder.
/// - Parameters:
/// - eventType: The type to decode the JSON event into.
/// - decoder: The JSON decoder to use.
/// - Returns: A sequence that provides the decoded JSON events.

/// A sequence that serializes lines by concatenating them using the JSON Lines format.

/// Creates a new sequence.
/// - Parameter upstream: The upstream sequence of lines.
public init(upstream: Upstream)
}

extension JSONLinesSerializationSequence : AsyncSequence {

extension AsyncSequence where Self.Element : Encodable {

/// Returns another sequence that encodes the events using the provided encoder into JSON Lines.
/// - Parameter encoder: The JSON encoder to use.
/// - Returns: A sequence that provides the serialized JSON Lines.
public func asEncodedJSONLines(encoder: JSONEncoder = {
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
return encoder
}()) -> JSONLinesSerializationSequence<AsyncThrowingMapSequence<Self, ArraySlice<UInt8>>>
}

/// A sequence that parses arbitrary byte chunks into lines using the JSON Sequence format.

extension JSONSequenceDeserializationSequence : AsyncSequence {

/// Returns another sequence that decodes each JSON Sequence event as the provided type using the provided decoder.
/// - Parameters:
/// - eventType: The type to decode the JSON event into.
/// - decoder: The JSON decoder to use.
/// - Returns: A sequence that provides the decoded JSON events.

/// A sequence that serializes lines by concatenating them using the JSON Sequence format.

extension JSONSequenceSerializationSequence : AsyncSequence {

/// Returns another sequence that encodes the events using the provided encoder into a JSON Sequence.
/// - Parameter encoder: The JSON encoder to use.
/// - Returns: A sequence that provides the serialized JSON Sequence.
public func asEncodedJSONSequence(encoder: JSONEncoder = {
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
return encoder
}()) -> JSONSequenceSerializationSequence<AsyncThrowingMapSequence<Self, ArraySlice<UInt8>>>
}

/// An event sent by the server that has a JSON payload in the data field.
///
///

/// A type of the event, helps inform how to interpret the data.
public var event: String?

/// The payload of the event.
public var data: JSONDataType?

/// A unique identifier of the event, can be used to resume an interrupted stream by
/// making a new request with the `Last-Event-ID` header field set to this value.
///
///
public var id: String?

/// The amount of time, in milliseconds, the client should wait before reconnecting in case
/// of an interruption.
///
///
public var retry: Int64?

/// Creates a new event.
/// - Parameters:
/// - event: A type of the event, helps inform how to interpret the data.
/// - data: The payload of the event.
/// - id: A unique identifier of the event.
/// - retry: The amount of time, in milliseconds, to wait before retrying.
public init(event: String? = nil, data: JSONDataType? = nil, id: String? = nil, retry: Int64? = nil)
}

/// An event sent by the server.
///
///
public struct ServerSentEvent : Sendable, Hashable {

/// The payload of the event.
public var data: String?

/// Creates a new event.
/// - Parameters:
/// - id: A unique identifier of the event.
/// - event: A type of the event, helps inform how to interpret the data.
/// - data: The payload of the event.
/// - retry: The amount of time, in milliseconds, to wait before retrying.
public init(id: String? = nil, event: String? = nil, data: String? = nil, retry: Int64? = nil)
}

/// A sequence that parses arbitrary byte chunks into events using the Server-sent Events format.
///
///

extension ServerSentEventsDeserializationSequence : AsyncSequence {
public typealias Element = ServerSentEvent

/// Returns another sequence that decodes each event's data as the provided type using the provided decoder.
///
/// Use this method if the event's `data` field is not JSON, or if you don't want to parse it using `asDecodedServerSentEventsWithJSONData`.
/// - Returns: A sequence that provides the events.
public func asDecodedServerSentEvents() -> ServerSentEventsDeserializationSequence<ServerSentEventsLineDeserializationSequence<Self>>

/// Returns another sequence that decodes each event's data as the provided type using the provided decoder.
///
/// Use this method if the event's `data` field is JSON.
/// - Parameters:
/// - dataType: The type to decode the JSON data into.
/// - decoder: The JSON decoder to use.
/// - Returns: A sequence that provides the events with the decoded JSON data.
public func asDecodedServerSentEventsWithJSONData<JSONDataType>(of dataType: JSONDataType.Type = JSONDataType.self, decoder: JSONDecoder = .init()) -> AsyncThrowingMapSequence<ServerSentEventsDeserializationSequence<ServerSentEventsLineDeserializationSequence<Self>>, ServerSentEventWithJSONData<JSONDataType>> where JSONDataType : Decodable
}

/// A sequence that serializes Server-sent Events.

/// Creates a new sequence.
/// - Parameter upstream: The upstream sequence of events.
public init(upstream: Upstream)
}

extension ServerSentEventsSerializationSequence : AsyncSequence where Upstream.Element == ServerSentEvent {

extension AsyncSequence {

/// Returns another sequence that encodes Server-sent Events with generic data in the data field.
/// - Returns: A sequence that provides the serialized Server-sent Events.

/// Returns another sequence that encodes Server-sent Events that have a JSON value in the data field.
/// - Parameter encoder: The JSON encoder to use.
/// - Returns: A sequence that provides the serialized Server-sent Events.

let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
return encoder
}()) -> ServerSentEventsSerializationSequence<AsyncThrowingMapSequence<Self, ServerSentEvent>> where JSONDataType : Encodable, Self.Element == ServerSentEventWithJSONData<JSONDataType>
}

### API stability

Additive changes to the runtime library, no API changes to the generator or other components.

### Future directions

We could add additional event stream formats, if they become popular and well-defined in the industry.

### Alternatives considered

- Not doing anything - this would require adopters to write these encoders and decoders by hand, which is time-consuming, error prone, and duplicates effort across the ecosystem.

- Generating special types for these streams - this was rejected because it would force the adopter to parse the event stream, even if they instead wanted to forward it as raw data elsewhere. Since these event streams formats are not part of OpenAPI, it felt like a too strong of a limitation, which is why these conveniences are opt-in.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0002

- Swift OpenAPI Generator
- Proposals
- SOAR-0002: Improved naming of content types

Article

# SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

## Overview

- Proposal: SOAR-0002

- Author(s): Honza Dvorsky

- Status: **Implemented (0.2.0)**

- Issue: N/A, was part of multiple content type support: apple/swift-openapi-generator#6 and apple/swift-openapi-generator#7

- Implementation: apple/swift-openapi-generator#146

- Review: ( review)

- Affected components: generator

- Versions:

- v1 (2023-08-07): First draft

- v2 (2023-08-08): Second draft with the following changes:

- added 6 more short names

- updated short names for a few of the originally proposed content types

- updated the logic for generic names, gets rid of `_sol_` for the slash
- v3 (2023-08-08): Third draft with the following changes:

- `multipart/form-data` short name changed from `formData` to `multipartForm`

### Motivation

Previously, the logic for assigning a Swift name to a content type always produced one of the following three strings: `json`, `text`, or `binary`.

That worked fine at the beginning, but now with multiple content type support for request and response bodies landed behind a feature flag, we need a naming scheme that produces much fewer conflicts.

Without the change, the following OpenAPI snippet would continue to fail to build:

paths:
/foo:
get:
responses:
'200':
content:
application/json: {}
application/vendor1+json: {}
application/vendor2+json: {}

That’s because all three would use the name `json` in the generated `Output.*.Body` enum.

There are currently no workarounds apart from removing the additional content types from your OpenAPI document.

### Proposed solution

I propose to extend the naming logic to achieve two goals:

- continue to use short and ergonomic names for common content types, like today

- avoid conflicts for arbitrary, less common content types using the new logic introduced in SOAR-0001 _for each component of the content type, and concatenate them with an underscore_ ( **changed in v2**)

In practical terms, it means that if a content type exactly matches one of the predefined content types that have a short name assigned, the short name will be used.

Otherwise, each component of the content type string (for an example `application/vendor1+json` the components would be `application` and `vendor1+json`) will be passed to the `swiftSafeName` function, which was improved in SOAR-0001, and produce a deterministic name that is unlikely to conflict with any other content type.

Let’s look at a few examples:

- for a common content type, such as `application/json`, a short name `json` will be used

- for an arbitrary content type, such as `application/vendor1+json`, a deterministic name will be produced, such as `application_vendor1_plus_json` ( **changed in v2**, was `application_sol_vendor1_plus_json` in v1)

This way, adopters continue to get short names for commonly used content types, but can also use completely custom content types, without getting a build error in the generated code.

### Detailed design

switch contentType.lowercasedTypeAndSubtype {
case "application/json":
return "json"
case "application/x-www-form-urlencoded":
return "urlEncodedForm"
case "multipart/form-data":
return "multipartForm"
case "text/plain":
return "plainText"
case "*/*":
return "any"
case "application/xml":
return "xml"
case "application/octet-stream":
return "binary"
case "text/html":
return "html"
case "application/yaml":
return "yaml"
case "text/csv":
return "csv"
case "image/png":
return "png"
case "application/pdf":
return "pdf"
case "image/jpeg":
return "jpeg"
default:
let safedType = swiftSafeName(for: contentType.originallyCasedType)
let safedSubtype = swiftSafeName(for: contentType.originallyCasedSubtype)
return "\(safedType)_\(safedSubtype)"
}
}

The above shows that the content types that have a short name assigned are:

These specific values were not chosen arbitrarily, instead I wrote a script that collected and processed about 1200 OpenAPI documents from the wild, and aggregated usage statistics. These content types, in this order, were the top used content types from those documents.

### API stability

This change breaks backwards compatibility of existing generated code as it renames the enum cases in the generated `Body` enums for requests and responses.

The change is currently hidden behind the `multipleContentTypes` feature flag, and once approved, would be rolled out together with that feature in the next breaking version (likely 0.2.0).

No other API impact.

### Future directions

Nothing comes to mind right now, as we already make provisions for not-yet-supported content types (see the note about `multipart/form-data` and `*/*`), so I’m not expecting a need to change this naming logic again.

#### No short names

This idea was rejected as data from real-world OpenAPI documents showed that there is a very small number (~13) ( **changed in v2**, was ~7 in v1) of content types that are used most often, so making the readability for adopters easier comes at a relatively low cost (see the full implementation of the naming logic above). This follows the principle of making the simple things easy/pretty, and difficult things possible/usable.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0002: Improved naming of content types
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0001

- Swift OpenAPI Generator
- Proposals
- SOAR-0001: Improved mapping of identifiers

Article

# SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

## Overview

- Proposal: SOAR-0001

- Author(s): Denil Chungath

- Status: **Implemented (0.2.0)**

- Issue:

- Implementation:

- Review: ( review)

- Affected components: generator

### Introduction

The goal of this proposal is to improve the way we handle unsupported characters in property names when generating code from specs. Currently, we use a block list approach, replacing offending characters with `_` which can cause name conflicts. By encoding the offending character we create unique and valid property names. This will avoid name collisions and ensure consistent code generation.

### Motivation

The current approach for handling unsupported characters in property names is not robust and can lead to unexpected and undesirable outcomes. For example, if there are two properties, `a_b` and `a b`, with the current implementation, this will result in the same generated property `a_b` for both, which would create a conflict. It can also result in loss of information or meaning from the original specification. Therefore, we need a better solution that can handle any unsupported character in a consistent and reliable way, without compromising the quality and functionality of the code.

### Proposed solution

The proposed solution to the problem is to use a mix of replacement words and hex encoding for any unsupported character in property names. We replace characters in the printable ASCII range (20-7E) with a wordified representation inspired by the HTML entity names here. Hex encoding is a simple and standard way of representing any character as a sequence of hexadecimal digits. For example, the asterisk (\*) character is encoded as 2A, the space ( ) character is encoded as 20, and the slash (/) character is encoded as 2F. Hex encoding also has the added benefit of not introducing any additional special characters. In addition to this, we will be prefixing the hex codes with an `x` to indicate they are hex values. There are also delimiters added in the form of the underscore character to indicate a possible replacement.

Some examples,

| yaml | swift |
| --- | --- |
| a b | a\_space\_b |
| a\*b | a\_ast\_b |
| ab\_ | ab\_ |
| ab\* | ab\_ast\_ |
| /ab | \_sol\_ab |
| Hu&J\_?kin | Hu\_amp\_J\_\_quest\_kin |
| $nake… | \_dollar\_nake\_x2026\_ |
| message | message |

This would mean, that for the users of the generator, a future version of the generator might produce different names that what it currently produces right now and should be ready to make those changes before upgrading to this version.

### Detailed design

The implementation for this is quite simple as you can see in we just made changes to the substitution logic where it used to substitute with `_`. We have added an additional encoding step to the special character before substituting it. Contributors should be aware of this change and should review the places where they use this extension and evaluate if its suitable for them with this change.

### API stability

This is an API breaking change, as it will produce different symbol names than before. Other components such as the runtime and transports should not have any impacts.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0001: Improved mapping of identifiers
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0012

- Swift OpenAPI Generator
- Proposals
- SOAR-0012: Generate enums for server variables

Article

# SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

## Overview

- Proposal: SOAR-0012

- Author(s): Joshua Asbury

- Status: **Implemented (1.4.0)**

- Issue: apple/swift-openapi-generator#628

- Implementation:

- apple/swift-openapi-generator#618
- Affected components:

- generator
- Related links:

- Server variable object
- Versions:

- v1.0 (2024-09-19): Initial version

- v1.1 (2024-10-01):

- Replace the the proposed solution to a purely additive API so it is no longer a breaking change requiring a feature flag

- Moved previous proposed solution to alternatives considered section titled “Replace generation of `serverN` static functions, behind feature flag”

- Moved generation of static computed-property `default` on variable enums to future direction

### Introduction

Add generator logic to generate Swift enums for server variables that define the ‘enum’ field and use Swift String for server variables that only define the ‘default’ field.

### Motivation

The OpenAPI specification for server URL templating defines that fields can define an ‘enum’ field if substitution options should be restricted to a limited set.

The current implementation of the generator component offer the enum field values via strings that are embedded within the static function implementation and not exposed to the adopter. Relying on the runtime extension `URL.init(validatingOpenAPIServerURL:variables:)` to verify the string provided matches the allowed values.

Consider the following example

servers:
- url:
description: Example service deployment.
variables:
environment:
description: Server environment.
default: prod
enum:
- prod
- staging
- dev
version:
default: v1

The currently generated code:

/// Server URLs defined in the OpenAPI document.
internal enum Servers {
/// Server environment.
///
/// - Parameters:
/// - environment:
/// - version:
internal static func server1(
environment: Swift.String = "prod",
version: Swift.String = "v1"

try Foundation.URL(
validatingOpenAPIServerURL: "https://{environment}.example.com/api/{version}",
variables: [\
.init(\
name: "environment",\
value: environment,\
allowedValues: [\
"prod",\
"staging",\
"dev"\
]\
),\
.init(\
name: "version",\
value: version\
)\
]
)
}
}

This means the adopter needs to rely on the runtime checks as to whether their supplied string was valid. Additionally if the OpenAPI document were to ever remove an option it could only be discovered at runtime.

let serverURL = try Servers.server1(environment: "stg") // might be a valid environment, might not

### Proposed solution

Server variables that define enum values can instead be generated as Swift enums. Providing important information (including code completion) about allowed values to adopters, and providing compile-time guarantees that a valid variable has been supplied.

Using the same configuration example, from the motivation section above, the newly generated code would be:

/// Server URLs defined in the OpenAPI document.
internal enum Servers {
/// Example service deployment.
internal enum Server1 {
/// Server environment.
///
/// The "environment" variable defined in the OpenAPI document. The default value is ``prod``.
internal enum Environment: Swift.String {
case prod
case staging
case dev
}
///
/// - Parameters:
/// - environment: Server environment.
/// - version:
internal static func url(
environment: Environment = Environment.prod,
version: Swift.String = "v1"

try Foundation.URL(
validatingOpenAPIServerURL: "https://{environment}.example.com/api/{version}",
variables: [\
.init(\
name: "environment",\
value: environment.rawValue\
),\
.init(\
name: "version",\
value: version\
)\
]
)
}
}
/// Example service deployment.
///
/// - Parameters:
/// - environment: Server environment.
/// - version:
@available(*, deprecated, message: "Migrate to the new type-safe API for server URLs.")
internal static func server1(
environment: Swift.String = "prod",
version: Swift.String = "v1"

This leaves the existing implementation untouched, except for the addition of a deprecation message, and introduces a new type-safe structure that allows the compiler to validate the provided arguments.

let url = try Servers.Server1.url() // ✅ compiles

let url = try Servers.Server1.url(environment: .default) // ✅ compiles

let url = try Servers.Server1.url(environment: .staging) // ✅ compiles

let url = try Servers.Server1.url(environment: .stg) // ❌ compiler error, 'stg' not defined on the enum

Later if the OpenAPI document removes an enum value that was previously allowed, the compiler will be able to alert the adopter.

// some time later "staging" gets removed from OpenAPI document
let url = try Servers.Server1.url(environment: . staging) // ❌ compiler error, 'staging' not defined on the enum

#### Default only variables

As seen in the generated code example, variables that do not define an ‘enum’ field will still remain a string (see the ‘version’ variable).

### Detailed design

Implementation:

The implementation of `translateServers(_:)` is modified to generate the relevant namespaces (enums) for each server, deprecate the existing generated functions, and generate a new more type-safe function. A new file `translateServersVariables` has been created to contain implementations of the two generator kinds; enum and string.

The server namespace contains a newly named `url` static function which serves the same purpose as the `serverN` static functions generated as members of the `Servers` namespace; it has been named `url` to both be more expressive and because the containing namespace already provides the server context.

The server namespace also lends the purpose of containing the variable enums, should they be required, since servers may declare variables that are named the same but contain different enum values. e.g.

servers:
- url:
variables:
environment:
default: prod
enum:
- prod
- staging
- url:
variables:
environment:
default: prod
enum:
- prod
- dev

The above would generate the following (simplified for clarity) output

enum Servers {
enum Server1 {
enum Environment: String {
// ...
}

}
enum Server2 {
enum Environment: String {
// ...
}

}

Server variables that have names or enum values that are not safe to be used as a Swift identifier will be converted. E.g.

enum Servers {
enum Server1 {
enum _Protocol: String {
case https
case https
}
enum Port: String {
case _443 = "443"
case _8443 = "8443"
}

}
}

#### Deeper into the implementation

To handle the branching logic of whether a variable will be generated as a string or an enum a new protocol, `TranslatedServerVariable`, defines the common behaviours that may need to occur within each branch. This includes:

- any required declarations

- the parameters for the server’s static function

- the expression for the variable initializer in the static function’s body

- the parameter description for the static function’s documentation

There are two concrete implementations of this protocol to handle the two branching paths in logic

##### \`RawStringTranslatedServerVariable\`

This concrete implementation will not provide a declaration for generated enum.

It will define the parameter using `Swift.String` and a default value that is a String representation of the OpenAPI document defined default field.

The generated initializer expression will match the existing implementation of a variable that does not define an enum field.

Note: While the feature flag for this proposal is disabled this type is also used to generate the initializer expression to include the enum field as the allowed values parameter.

##### \`GeneratedEnumTranslatedServerVariable\`

This concrete implementation will provide an enum declaration which represents the variable’s enum field and a static computed property to access the default.

The parameter will reference a fully-qualified path to the generated enum declaration and have a default value of the fully qualified path to the static property accessor.

The initializer expression will never need to provide the allowed values parameter and only needs to provide the `rawValue` of the enum.

### API stability

This proposal creates new generated types and modifies the existing generated static functions to include a deprecation, therefore is a non-breaking change for adopters.

#### Other components

No API changes are required to other components, though once this proposal is adopted the runtime component _could_ remove the runtime validation of allowed values since the generated code guarantees the `rawValue` is in the document.

#### Variable enums could have a static computed-property convenience, called \`default\`, generated

Each server variable enum could generate a static computed-property with the name `default` which returns the case as defined by the OpenAPI document. e.g.

enum Servers {
enum Variables {
enum Server1 {
enum Environment: Swift.String {
case prod
case staging
case dev
static var `default`: Environment {
return Environment.prod
}
}
}
}

This would allow the server’s static function to use `default` as the default parameter instead of using a specific case.

#### Generate all variables as Swift enums

A previous implementation had generated all variables as a swift enum, even if the ‘enum’ field was not defined in the document. An example

servers:
- url:
variables:
version:
default: v1

Would have been generated as

/// Server URLs defined in the OpenAPI document.
internal enum Servers {
internal enum Variables {
/// The variables for Server1 defined in the OpenAPI document.
internal enum Server1 {
/// The "version" variable defined in the OpenAPI document.
///
/// The default value is "v1".
internal enum Version: Swift.String {
case v1
/// The default variable.
internal static var `default`: Version {
return Version.v1
}
}
}
}
///
/// - Parameters:
/// - version:

try Foundation.URL(
validatingOpenAPIServerURL: "https://example.com/api/{version}",
variables: [\
.init(\
name: "version",\
value: version.rawValue\
)\
]
)
}
}

This approach was reconsidered due to the wording in the OpenAPI specification of both the ‘enum’ and ‘default’ fields.

This indicates that by providing enum values the options are restricted, whereas a default value is provided when no other value is supplied.

#### Replace generation of \`serverN\` static functions, behind feature flag

This approach was considered to be added behind a feature flag as it would introduce breaking changes for adopters that didn’t use default values; it would completely rewrite the static functions to accept enum variables as Swift enums.

An example of the output, using the same configuration example from the motivation section above, this approach would generate the following code:

/// Server URLs defined in the OpenAPI document.
internal enum Servers {
/// Server URL variables defined in the OpenAPI document.
internal enum Variables {
/// The variables for Server1 defined in the OpenAPI document.
internal enum Server1 {
/// Server environment.
///
/// The "environment" variable defined in the OpenAPI document. The default value is "prod".
internal enum Environment: Swift.String {
case prod
case staging
case dev
/// The default variable.
internal static var `default`: Environment {
return Environment.prod
}
}
}
}
/// Example service deployment.
///
/// - Parameters:
/// - environment: Server environment.
/// - version:
internal static func server1(
environment: Variables.Server1.Environment = Variables.Server1.Environment.default,
version: Swift.String = "v1"

try Foundation.URL(
validatingOpenAPIServerURL: "https://example.com/api",
variables: [\
.init(\
name: "environment",\
value: environment.rawValue\
),\
.init(\
name: "version",\
value: version\
)\
]
)
}
}

The variables were scoped within a `Variables` namespace for clarity, and each server had its own namespace to avoid collisions of names between different servers.

Ultimately this approach was decided against due to lack of discoverability since it would have to be feature flagged.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0012: Generate enums for server variables
- Overview
- Introduction
- Motivation
- Proposed solution
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/generating-custom-codable-conformance-methods

- Swift OpenAPI Generator
- Documentation for maintainers
- Generating custom Codable implementations

Article

# Generating custom Codable implementations

Learn about when and how the generator emits a custom Codable implementation.

## Overview

As much as possible, the generator tries to rely on the compiler-synthesized implementation of Codable requirements:

- `init(from: Decoder) throws`

- `func encode(to: Encoder) throws`

The synthesized implementation is used as-is for:

- primitive types, such as `String`, `Int`, `Double`, and `Bool`

- string and integer-backed enums

- arrays of other Codable types

- structs generated for `object` schemas with no `additionalProperties` customization

However, a custom Codable implementation is emitted for the following types:

- structs generated for `object` schemas with `additionalProperties` customized

- structs generated for `allOf` and `anyOf` schemas

- enums with associated values generated for `oneOf` schemas

This document goes into detail about each of these types, explains why a custom Codable implementation is needed, and how it works.

### Object structs with additional properties

An `object` schema can have the `additionalProperties` key, which documents how any properties _not_ documented in the `properties` key should be handled.

1. When the `additionalProperties` key is unspecified in an object schema, no custom Codable implementation is emitted and the generator lets the Swift compiler synthesize one based on the stored properties.

- Custom decoder: no

- Custom encoder: no
2. When `additionalProperties: false`, any additional properties are forbidden.

- Custom decoder: yes, it decodes documented properties and then throws an error if any unknown properties are detected.

- Custom encoder: no, since there is no storage to put them, so the user could not have accidentally created such an value of the struct, and there is no need to perform additional validation on encoding.
3. When `additionalProperties: true`, an extra property called `additionalProperties` of type `OpenAPIRuntime.OpenAPIObjectContainer` is generated on the struct, in addition to any documented stored properties.

- Custom decoder: yes, it decodes documented properties and then collects all unknown properties into the `additionalProperties` property, which is a key-value dictionary with untyped values.

- Custom encoder: yes, it encodes all documented and additional properties.
4. When `additionalProperties: {type: ...}`, for example `{type: integer}`, all unknown properties must have an integer value. An extra property called `additionalProperties` of type (for example) `[String: Int]` is generated on the struct, in addition to any documented stored properties.

- Custom decoder: yes, similar to 3., with the difference that values are validated to be of the specified type (for example, `Int`).

- Custom encoder, yes, same as 3.

### Structs for allOf and anyOf

The `allOf` and `anyOf` schemas include one or more subschemas that all (for `allOf`) or at least one (for `anyOf`) need to be decodable from the underlying value.

These schemas are generated as a struct where each property maps to one subschema.

For `allOf`, all properties are required, and for `anyOf`, all properties are optional.

Since the subschemas are all using the same top level container for coding, the synthesized Codable implementation cannot be used and the generator always emits custom methods for coding.

An important concept referenced below is of a “key-value pair schema”. A key-value pair schema is defined as one of:

- `object`

- `allOf` where all subschemas are also key-value pair schemas

- `anyOf` or `oneOf` where at least one subschema is also a key-value pair schema

The reason we make the distinction between key-value pair schemas and other schemas is because key-value pair schemas can be safely combined (you can merge two dictionaries), but other schemas cannot be safely combined (there’s no way to combine two strings, or an integer and an array, and so on). Common Swift coders, such as JSONEncoder and JSONDecoder require that we use the right methods, as you, for example, cannot encode into a single value container more than once.

The custom Codable implementations work as follows:

- `allOf`:

- Custom decoder: yes, for key-value pair schemas uses `init(from:)` of the type directly, for others decodes from a single value container.

- Custom encoder: yes, only encodes the first non-key-value pair schema using a single value container (reason: encoding any additional one would overwrite the first value, and the different values should persist to the same exact bytes on the wire, so only encoding the first one is safe). If no non-key-value pair subschemas are present, encodes all the key-value pair subschemas using their `encoder(to:)` method directly. (Note that an `allOf` that has both non-key-value pair and key-value pair subschemas are not valid, as it’s not possible, for example, for something to be _both_ a string and a dictionary.)
- `anyOf`:

- Custom decoder: yes, for key-value pair schemas uses `init(from:)` of the type directly, for others decodes from a single value container. The decoding is graceful, in other words any failure is turned into a nil result. But, to ensure a valid `anyOf`, at the end it validates that at least one subschema decoded successfully, otherwise throws an error.

- Custom encoder: yes, only encodes the first _non-nil_ non-key-value pair schema using a single value container (similar to the `allOf` encoder above), then it encodes all the key-value pair subschemas using their `encoder(to:)` method directly. Note that only if all of the non-key-value pair schemas were nil will it actually encode the key-value pairs, again because an `anyOf` cannot be simultaneously a single value schema (for example, a string) and a key-value pair schema (for example, a dictionary).

### Enums for oneOf

A `oneOf` schema represents a payload that matches exactly one subschema (but not more).

In Swift, the generator emits an enum with associated values, which matches the JSON Schema semantics.

There are two groups of oneOf schemas, which require different handling - based on whether a _discriminator_ is present.

A discriminator is one value in the payload that encodes the name of the schema that should be used to encode and decode the payload. While normally JSON payloads are _not_ self-describing (in other words, the code needs to know which type-safe object to decode the value into upfront), including a discriminator allows for heterogeneous collections and decoding based on this dynamic value - making the payload self-describing.

Including a discriminator restricts the subschemas to be object-ish (objects and allOf/anyOf/oneOf of object-ish subschemas) schemas, as no other schemas can have properties, and a discriminator is always a property. However, it allows direct decoding, so instead of trying to decode the payload using each subschema, one by one, until one succeeds, the discriminator tells the decoder which type to use for decoding.

| Has discriminator | Allowed subschemas | Decoding |
| --- | --- | --- |
| Yes | Only object-ish | Direct |
| No | All | Try one-by-one |

The rule of thumb is roughly as follows:

- If needing to include non-object-ish schemas in a oneOf, don’t use a discriminator.

- If only including object-ish schemas, use a discriminator

- while not required, it is recommended for better performance and debugging.

- it also allows having multiple schemas that would successfully validate from the payload, but without a discriminator would fail to be a valid oneOf, where exactly one schema must validate (but not more).

#### oneOf without a discriminator

- Custom decoder: yes, tries to decode each subschema one-by-one, and stops when one validates correctly. For decoding the subschemas, it uses the same rules as allOf/anyOf, where key-value pair schemas are decoded directly using `init(from:)`, and other schemas are decoded from a single value container.

- Custom encoder: yes, a switch statement over the schema and only encodes the value matching the case of the enum, again, using the direct `encode(to:)` method for key-value pair schemas, and a single value container for all other schemas.

#### oneOf with a discriminator

- Custom decoder: yes, performs decoding in two stages. First, decodes the discriminator property value to identify the Swift type to decode the full payload into. Then switches over the discriminator value and decodes the full payload using the chosen type. Since oneOf enums with a discriminator always contain object-ish schemas, which are key-value pair schemas, uses the direct `init(from:)` decoding initializer.

- Custom encoder: yes, same as oneOf without a discriminator, but always uses `encode(to:)` because only key-value pair schemas are ever used here.

### A note on Foundation.Date

While `Foundation.Date` technically conforms to `Codable`, it’s not really codable on its own, as the method for coding is customizable by JSONEncoder/JSONDecoder (and other coders) using `dateEncodingStrategy`.

This means that you cannot use Date’s `init(from:)` and `encode(to:)` methods directly, otherwise you always get the default date encoding, which uses a `Double` \- not what you usually want (ISO 8601 is more widely used).

Having to go through the container, which goes through the coder’s customized Date coding strategy is part of the reason behind some of the complexity above and why we need to make the distinction between “key-value pair schemas” and others.

## See Also

Converting between data and Swift types

Learn about the type responsible for converting between binary data and Swift types.

Handling nullable schemas

Learn how the generator handles schema nullability.

Supporting recursive types

Learn how the generator supports recursive types.

- Generating custom Codable implementations
- Overview
- Object structs with additional properties
- Structs for allOf and anyOf
- Enums for oneOf
- A note on Foundation.Date
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0003

- Swift OpenAPI Generator
- Proposals
- SOAR-0003: Type-safe Accept headers

Article

# SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

## Overview

- Proposal: SOAR-0003

- Author(s): Honza Dvorsky, Si Beaumont

- Status: **Implemented (0.2.0)**

- Issue: apple/swift-openapi-generator#160

- Implementation: apple/swift-openapi-runtime#37, apple/swift-openapi-generator#185

- Review: ( review)

- Affected components: generator, runtime

### Introduction

Generate a type-safe representation of the possible values in the Accept header for each operation.

#### Accept header

The Accept request header allows the client to communicate to the server which content types the client can handle in the response body. This includes the ability to provide multiple values, and to give each a numeric value to that represents preference (called “quality”).

Many clients don’t provide any preference, for example by not including the Accept header, providing `accept: */*`, or listing all the known response headers in a list. The last option is what our generated clients do by default already today.

However, sometimes the client needs to narrow down the list of acceptable content types, or it prefers one over the other, while it can still technically handle both.

For example, let’s consider an operation that returns an image either in the `png` or `jpeg` format. A client with a low amount of CPU and memory might choose `jpeg`, even though it could also handle `png`. In such a scenario, it would send an Accept header that could look like: `accept: image/jpeg, image/png; q=0.1`. This tells the server that while the client can handle both formats, it really prefers `jpeg`. Note that the “q” parameter represents a priority value between `0.0` and `1.0` inclusive, and the default value is `1.0`.

However, the client could also completely lack a `png` decoder, in which case it would only request the `jpeg` format with: `accept: image/jpeg`. Note that `image/png` is completely omitted from the Accept header in this case.

To summarize, the client needs to _provide_ Accept header information, and the server _inspects_ that information and uses it as a hint. Note that the server is still in charge of making the final decision over which of the acceptable content types it chooses, or it can return a 4xx status code if it cannot satisfy the client’s request.

#### Existing behavior

Today, the generated client includes in the Accept header all the content types that appear in any response for the invoked operation in the OpenAPI document, essentially allowing the server to pick any content type. For an operation that uses JSON and plain text, the header would be: `accept: application/json, text/plain`. However, there is no way for the client to narrow down the choices or customize the quality value, meaning the only workaround is to build a `ClientMiddleware` that modifies the raw HTTP request before it’s executed by the transport.

On the server side, adopters have had to resort to workarounds, such as extracting the Accept header in a custom `ServerMiddleware` and saving the parsed value into a task local value.

#### Why now?

While the Accept header can be sent even with requests that only have one documented response content type, it is most useful when the response contains multiple possible content types.

That’s why we are proposing this feature now, since multiple content types recently got implemented in Swift OpenAPI Generator - hidden behind the feature flag `multipleContentTypes` in versions `0.1.7+`.

### Proposed solution

We propose to start generating a new enum in each operation’s namespace that contains all the unique concrete content types that appear in any of the operation’s responses. This enum would also have a case called `other` with an associated `String` value, which would be an escape hatch, similar to the `undocumented` case generated today for undocumented response codes.

This enum would be used by a new property that would be generated on every operation’s `Input.Headers` struct, allowing clients a type-safe way to set, and servers to get, this information, represented as an array of enum values each wrapped in a type that also includes the quality value.

### Example

For example, let’s consider the following operation:

/stats:
get:
operationId: getStats
responses:
'200':
description: A successful response with stats.
content:
application/json:
schema:
...
text/plain: {}

The generated code in `Types.swift` would gain an enum definition and a property on the headers struct.

// Types.swift
// ...
enum Operations {
enum getStats {
struct Input {
struct Headers {
+ var accept: [AcceptHeaderContentType<\
+ Operations.getStats.AcceptableContentType\

}
}
enum Output {
// ...
}
+ enum AcceptableContentType: AcceptableProtocol {
+ case json
+ case plainText
+ case other(String)
+ }
}
}

As a client adopter, you would be able to set the new defaulted property `accept` on `Input.Headers`. The following invocation of the `getStats` operation tells the server that the JSON content type is preferred over plain text, but both are acceptable.

let response = try await client.getStats(.init(
headers: .init(accept: [\
.init(contentType: .json),\
.init(contentType: .plainText, quality: 0.5)\
])
))

You could also leave it to its default value, which sends the full list of content types documented in the responses for this operation - which is the existing behavior.

As a server implementer, you would inspect the provided Accept information for example by sorting it by quality (highest first), and always returning the most preferred content type. And if no Accept header is provided, this implementation defaults to JSON.

struct MyHandler: APIProtocol {

let contentType = input
.headers
.accept
.sortedByQuality()
.first?
.contentType ?? .json
switch contentType {
case .json:
// ... return JSON
case .plainText:
// ... return plain text
case .other(let value):
// ... inspect the value or return an error
}
}
}

### Detailed design

This feature requires a new API in the runtime library, in addition to the new generated code.

#### New runtime library APIs

/// The protocol that all generated `AcceptableContentType` enums conform to.
public protocol AcceptableProtocol : CaseIterable, Hashable, RawRepresentable, Sendable where Self.RawValue == String {}

/// A wrapper of an individual content type in the accept header.

/// The value representing the content type.
public var contentType: ContentType

/// The quality value of this content type.
///
/// Used to describe the order of priority in a comma-separated
/// list of values.
///
/// Content types with a higher priority should be preferred by the server
/// when deciding which content type to use in the response.
///
/// Also called the "q-factor" or "q-value".
public var quality: QualityValue

/// Creates a new content type from the provided parameters.
/// - Parameters:
/// - value: The value representing the content type.
/// - quality: The quality of the content type, between 0.0 and 1.0.
/// - Precondition: Priority must be in the range 0.0 and 1.0 inclusive.
public init(contentType: ContentType, quality: QualityValue = 1.0)

/// Returns the default set of acceptable content types for this type, in
/// the order specified in the OpenAPI document.
public static var defaultValues: [`Self`] { get }
}

/// A quality value used to describe the order of priority in a comma-separated
/// list of values, such as in the Accept header.
public struct QualityValue : Sendable, Equatable, Hashable {

/// Creates a new quality value of the default value 1.0.
public init()

/// Returns a Boolean value indicating whether the quality value is
/// at its default value 1.0.
public var isDefault: Bool { get }

/// Creates a new quality value from the provided floating-point number.
///
/// - Precondition: The value must be between 0.0 and 1.0, inclusive.
public init(doubleValue: Double)

/// The value represented as a floating-point number between 0.0 and 1.0, inclusive.
public var doubleValue: Double { get }
}

extension QualityValue : RawRepresentable { ... }
extension QualityValue : ExpressibleByIntegerLiteral { ... }
extension QualityValue : ExpressibleByFloatLiteral { ... }
extension AcceptHeaderContentType : RawRepresentable { ... }

extension Array {
/// Returns the array sorted by the quality value, highest quality first.

/// Returns the default values for the acceptable type.

}

The generated operation-specific enum called `AcceptableContentType` conforms to the `AcceptableProtocol` protocol.

A full example of a generated `AcceptableContentType` for `getStats` looks like this:

@frozen public enum AcceptableContentType: AcceptableProtocol {
case json
case plainText
case other(String)
public init?(rawValue: String) {
switch rawValue.lowercased() {
case "application/json": self = .json
case "text/plain": self = .plainText
default: self = .other(rawValue)
}
}
public var rawValue: String {
switch self {
case let .other(string): return string
case .json: return "application/json"
case .plainText: return "text/plain"
}
}
public static var allCases: [Self] { [.json, .plainText] }
}

### API stability

This feature is purely additive, and introduces a new property to `Input.Headers` generated structs for all operations with at least 1 documented response content type.

The default behavior is still the same – all documented response content types are sent in the Accept header.

#### Support for wildcards

One deliberate omission from this design is the support for wildcards, such as `*/*` or `application/*`. If such a value needs to be sent or received, the adopter is expected to use the `other(String)` case.

While we discussed this topic at length, we did not arrive at a solution that would provide enough added value for the extra complexity, so it is left up to future proposals to solve, or for real-world usage to show that nothing more is necessary.

#### A stringly array

The `accept` property could have simply been `var accept: [String]`, where the generated code would only concatenate or split the header value with a comma, but then leave it to the adopter to construct or parse the type, subtype, and optional quality parameter.

That seemed to go counter to this project’s goals of making access to the information in the OpenAPI document as type-safe as possible, helping catch bugs at compile time.

#### Maintaing the status quo

We also could have not implemented anything, leaving adopters who need to customize the Accept header to inject or extract that information with a middleware, both on the client and server side.

That option was rejected as without explicit support for setting and getting the Accept header information, the support for multiple content types seemed incomplete.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

- SOAR-0003: Type-safe Accept headers
- Overview
- Introduction
- Motivation
- Proposed solution
- Example
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/converting-between-data-and-swift-types

- Swift OpenAPI Generator
- Documentation for maintainers
- Converting between data and Swift types

Article

# Converting between data and Swift types

Learn about the type responsible for converting between binary data and Swift types.

## Overview

The `Converter` type is a structure defined in the runtime library and is used by both the client and server generated code to perform conversions between binary data and Swift types.

Most of the functionality of `Converter` is implemented as helper methods in extensions:

- `Converter+Client.swift`

- `Converter+Server.swift`

- `Converter+Common.swift`

Some helper methods can be reused between client and server code, such as headers, but most can’t. It’s important that we only generalize (move helper methods into common extensions) if the client and server variants would have been exact copies. However, if there are differences, prefer to keep them separate and optimize each variant (for client or server) separately.

The converter, it contains helper methods for all the supported combinations of an schema location, a “coding strategy” and a Swift type.

### Codable and coders

The project uses multiple encoder and decoder implementations that all utilize the `Codable` conformance of generated and built-in types.

At the time of writing, the list of coders used is as follows.

| Format | Encoder | Decoder | Supported in |
| --- | --- | --- | --- |
| JSON | `Foundation.JSONEncoder` | `Foundation.JSONDecoder` | Bodies, headers |
| URI (†) | `OpenAPIRuntime.URIEncoder` | `OpenAPIRuntime.URIDecoder` | Path, query, headers |
| Plain text | `OpenAPIRuntime.StringEncoder` | `OpenAPIRuntime.StringDecoder` | Bodies |

While the generator attempts to catch invalid inputs at generation time, there are still combinations of `Codable` types and locations that aren’t compatible, and will only get caught at runtime by the specific coder implementation. For example, one could ask the `StringEncoder` to encode an array, but the encoder will throw an error, as containers are not supported in that encoder.

### Dimensions of helper methods

Below is a list of the “dimensions” across which the helper methods differ:

- **Client/server** represents whether the code is needed by the client, server, or both (“common”).

- **Set/get** represents whether the generated code sets or gets the value.

- **Schema location** refers to one of the several places where schemas can be used in OpenAPI documents. Values:

- request path parameters

- request query items

- request header fields

- request body

- response header fields

- response body
- **Coding strategy** represents the chosen coder to convert between the Swift type and data. Supported options:

- `JSON`

- example content type: `application/json` and any with the `+json` suffix

- `{"color": "red", "power": 24}`
- `URI`

- example: query, path, header parameters

- `color=red&power=24`
- `urlEncodedForm`

- example: request body with the `application/x-www-form-urlencoded` content type

- `greeting=Hello+world`
- `multipart`

- example: request body with the `multipart/form-data` content type

- part 1: `{"color": "red", "power": 24}`, part 2: `greeting=Hello+world`
- `binary`

- example: `application/octet-stream`

- serves as the fallback for content types that don’t have more specific handling

- doesn’t transform the binary data, just passes it through
- **Optional/required** represents whether the method works with optional values. Values:

- _required_ represents a special overload only for required values

- _optional_ represents a special overload only for optional values

- _both_ represents a special overload that works for optional values without negatively impacting passed-in required values (for example, setters)

### Helper method variants

Together, the dimensions are enough to deterministically decide which helper method on the converter should be used.

In the list below, each row represents one helper method.

The helper method naming convention can be described as:

method name: {set,get}{required/optional/omit if both}{location}As{strategy}
method parameters: value or type of value

| Client/server | Set/get | Schema location | Coding strategy | Optional/required | Method name |
| --- | --- | --- | --- | --- | --- |
| common | set | header field | URI | both | setHeaderFieldAsURI |
| common | set | header field | JSON | both | setHeaderFieldAsJSON |
| common | get | header field | URI | optional | getOptionalHeaderFieldAsURI |
| common | get | header field | URI | required | getRequiredHeaderFieldAsURI |
| common | get | header field | JSON | optional | getOptionalHeaderFieldAsJSON |
| common | get | header field | JSON | required | getRequiredHeaderFieldAsJSON |
| client | set | request path | URI | required | renderedPath |
| client | set | request query | URI | both | setQueryItemAsURI |
| client | set | request body | JSON | optional | setOptionalRequestBodyAsJSON |
| client | set | request body | JSON | required | setRequiredRequestBodyAsJSON |
| client | set | request body | binary | optional | setOptionalRequestBodyAsBinary |
| client | set | request body | binary | required | setRequiredRequestBodyAsBinary |
| client | set | request body | urlEncodedForm | optional | setOptionalRequestBodyAsURLEncodedForm |
| client | set | request body | urlEncodedForm | required | setRequiredRequestBodyAsURLEncodedForm |
| client | set | request body | multipart | required | setRequiredRequestBodyAsMultipart |
| client | get | response body | JSON | required | getResponseBodyAsJSON |
| client | get | response body | binary | required | getResponseBodyAsBinary |
| client | get | response body | multipart | required | getResponseBodyAsMultipart |
| server | get | request path | URI | required | getPathParameterAsURI |
| server | get | request query | URI | optional | getOptionalQueryItemAsURI |
| server | get | request query | URI | required | getRequiredQueryItemAsURI |
| server | get | request body | JSON | optional | getOptionalRequestBodyAsJSON |
| server | get | request body | JSON | required | getRequiredRequestBodyAsJSON |
| server | get | request body | binary | optional | getOptionalRequestBodyAsBinary |
| server | get | request body | binary | required | getRequiredRequestBodyAsBinary |
| server | get | request body | urlEncodedForm | optional | getOptionalRequestBodyAsURLEncodedForm |
| server | get | request body | urlEncodedForm | required | getRequiredRequestBodyAsURLEncodedForm |
| server | get | request body | multipart | required | getRequiredRequestBodyAsMultipart |
| server | set | response body | JSON | required | setResponseBodyAsJSON |
| server | set | response body | binary | required | setResponseBodyAsBinary |
| server | set | response body | multipart | required | setResponseBodyAsMultipart |

## See Also

Generating custom Codable implementations

Learn about when and how the generator emits a custom Codable implementation.

Handling nullable schemas

Learn how the generator handles schema nullability.

Supporting recursive types

Learn how the generator supports recursive types.

- Converting between data and Swift types
- Overview
- Codable and coders
- Dimensions of helper methods
- Helper method variants
- See Also

|
|

---

# https://swiftpackageindex.com/apple/swift-openapi-generator/1.10.3/documentation/swift-openapi-generator/soar-0014

- Swift OpenAPI Generator
- Proposals
- SOAR-0014: Support Type Overrides

Article

# SOAR-0014: Support Type Overrides

Allow using user-defined types instead of generated ones

## Overview

- Proposal: SOAR-0014

- Author(s): simonbility

- Status: **Implemented (1.9.0)**

- Issue: apple/swift-openapi-generator#375

- Implementation:

- apple/swift-openapi-generator#764
- Affected components:

- generator

### Introduction

The goal of this proposal is to allow users to specify custom types for generated. This will enable users to use their own types instead of the default generated ones, allowing for greater flexibility.

### Motivation

This proposal would enable more flexibility in the generated code. Some usecases include:

- Using custom types that are already defined in the user’s codebase or even coming from a third party library, instead of generating new ones.

- workaround missing support for `format` for strings

- Implement custom validation/encoding/decoding logic that cannot be expressed using the OpenAPI spec

This is intended as a “escape hatch” for use-cases that (currently) cannot be expressed. Using this comes with the risk of user-provided types not being compliant with the original OpenAPI spec.

### Proposed solution

The proposed solution is to allow specifying typeOverrides using a new configuration option named `typeOverrides`. This is only supported for schemas defined in the `components.schemas` section of a OpenAPI document.

### Example

A current limitiation is string formats are not directly supported by the generator. (for example, `uuid` is not supported)

With this proposal this can be worked around with with the following approach (This proposal does not preclude extending support for formats in the future):

Given schemas defined in the OpenAPI document like this:

components:
schemas:
UUID:
type: string
format: uuid

Adding typeOverrides like this in the configuration

+ typeOverrides:
+ schemas:
+ UUID: Foundation.UUID

Will affect the generated code in the following way:

/// Types generated from the `#/components/schemas` section of the OpenAPI document.
package enum Schemas {
/// - Remark: Generated from `#/components/schemas/UUID`.
- package typealias Uuid = Swift.String
+ package typealias Uuid = Foundation.UUID
}

### Detailed design

In the configuration file a new `typeOverrides` option is supported. It contains mapping from the original name (as defined in the OpenAPI document) to a override type name to use instead of the generated name.

The mapping is evaluated relative to `#/components/schemas`

So defining overrides like this:

typeOverrides:
schemas:
OriginalName: NewName

will replace the generated type for `#/components/schemas/OriginalName` with `NewName`.

Its in the users responsibility to ensure that the type is valid and available. It must conform to `Codable`, `Hashable` and `Sendable`

### API stability

While this proposal does affect the generated code, it requires the user to explicitly opt-in to using the `typeOverrides` configuration option.

This is interpreted as a “strong enough” signal of the user to opt into this behaviour, to justify NOT introducing a feature-flag or considering this a breaking change.

### Future directions

The implementation could potentially be extended to support inline defined properties as well. This could be done by supporting “Paths” instead of names in the mapping.

For example with the following schema.

components:
schemas:
User:
properties:
id:
type: string
format: uuid

This configuration could be used to override the type of `id`:

typeOverrides:
schemas:
'User/id': Foundation.UUID

### Alternatives considered

An alternative to the mapping defined in the configuration file is to use a vendor extension (for instance `x-swift-open-api-override-type`) in the OpenAPI document itself.

...
components:
schemas:
UUID:
type: string
x-swift-open-api-override-type: Foundation.UUID

The current proposal using the configuration file was preferred because it does not rely on modifying the OpenAPI document itself, which is not always possible/straightforward when its provided by a third-party.

## See Also

SOAR-NNNN: Feature name

Feature abstract – a one sentence summary.

SOAR-0001: Improved mapping of identifiers

Improved mapping of OpenAPI identifiers to Swift identifiers.

SOAR-0002: Improved naming of content types

Improved naming of content types to Swift identifiers.

SOAR-0003: Type-safe Accept headers

Generate a dedicated Accept header enum for each operation.

SOAR-0004: Streaming request and response bodies

Represent HTTP request and response bodies as a stream of bytes.

SOAR-0005: Adopting the Swift HTTP Types package

Adopt the new ecosystem-wide Swift HTTP Types package for HTTP currency types in the transport and middleware protocols.

SOAR-0007: Shorthand APIs for operation inputs and outputs

Generating additional API to simplify providing operation inputs and handling operation outputs.

SOAR-0008: OpenAPI document filtering

Filtering the OpenAPI document for just the required parts prior to generating.

SOAR-0009: Type-safe streaming multipart support

Provide a type-safe streaming API to produce and consume multipart bodies.

SOAR-0010: Support for JSON Lines, JSON Sequence, and Server-sent Events

Introduce streaming encoders and decoders for JSON Lines, JSON Sequence, and Server-sent Events for as a convenience API.

SOAR-0011: Improved Error Handling

Improve error handling by adding the ability for mapping application errors to HTTP responses.

SOAR-0012: Generate enums for server variables

Introduce generator logic to generate Swift enums for server variables that define the ‘enum’ field.

SOAR-0013: Idiomatic naming strategy

Introduce an alternative naming strategy for more idiomatic Swift identifiers, including a way to provide custom name overrides.

- SOAR-0014: Support Type Overrides
- Overview
- Introduction
- Motivation
- Proposed solution
- Example
- Detailed design
- API stability
- Future directions
- Alternatives considered
- See Also

|
|

---

