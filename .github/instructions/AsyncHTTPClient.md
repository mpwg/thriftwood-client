<!--
Downloaded via https://llm.codes by @steipete on October 4, 2025 at 04:05 PM
Source URL: https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient
Total pages processed: 197
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient

Framework

# AsyncHTTPClient

This package provides simple HTTP Client library built on top of SwiftNIO.

## Overview

This library provides the following:

- First class support for Swift Concurrency (since version 1.9.0)

- Asynchronous and non-blocking request methods

- Simple follow-redirects (cookie headers are dropped)

- Streaming body download

- TLS support

- Automatic HTTP/2 over HTTPS (since version 1.7.0)

- Cookie parsing (but not storage)

#### Adding the dependency

Add the following entry in your Package.swift to start using HTTPClient:

.package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0")

and `AsyncHTTPClient` dependency to your target:

.target(name: "MyApp", dependencies: [.product(name: "AsyncHTTPClient", package: "async-http-client")]),

#### Request-Response API

The code snippet below illustrates how to make a simple GET request to a remote server.

import AsyncHTTPClient

/// MARK: - Using Swift Concurrency
let request = HTTPClientRequest(url: "https://apple.com/")
let response = try await httpClient.execute(request, timeout: .seconds(30))
print("HTTP head", response)
if response.status == .ok {
let body = try await response.body.collect(upTo: 1024 * 1024) // 1 MB
// handle body
} else {
// handle remote error
}

/// MARK: - Using SwiftNIO EventLoopFuture
HTTPClient.shared.get(url: "https://apple.com/").whenComplete { result in
switch result {
case .failure(let error):
// process error
case .success(let response):
if response.status == .ok {
// handle response
} else {
// handle remote error
}
}
}

You should always shut down `HTTPClient` instances you created using `shutdown()`. Please note that you must not call `shutdown()` before all requests of the HTTP client have finished, or else the in-flight requests will likely fail because their network connections are interrupted.

#### async/await examples

Examples for the async/await API can be found in the `Examples` folder in the repository.

### Usage guide

The default HTTP Method is `GET`. In case you need to have more control over the method, or you want to add headers or body, use the `HTTPClientRequest` struct:

#### Using Swift Concurrency

do {
var request = HTTPClientRequest(url: "https://apple.com/")
request.method = .POST
request.headers.add(name: "User-Agent", value: "Swift HTTPClient")
request.body = .bytes(ByteBuffer(string: "some data"))

let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
if response.status == .ok {
// handle response
} else {
// handle remote error
}
} catch {
// handle error
}

#### Using SwiftNIO EventLoopFuture

var request = try HTTPClient.Request(url: "https://apple.com/", method: .POST)
request.headers.add(name: "User-Agent", value: "Swift HTTPClient")
request.body = .string("some-body")

HTTPClient.shared.execute(request: request).whenComplete { result in
switch result {
case .failure(let error):
// process error
case .success(let response):
if response.status == .ok {
// handle response
} else {
// handle remote error
}
}
}

#### Redirects following

Enable follow-redirects behavior using the client configuration:

let httpClient = HTTPClient(eventLoopGroupProvider: .singleton,
configuration: HTTPClient.Configuration(followRedirects: true))

#### Timeouts

Timeouts (connect and read) can also be set using the client configuration:

let timeout = HTTPClient.Configuration.Timeout(connect: .seconds(1), read: .seconds(1))
let httpClient = HTTPClient(eventLoopGroupProvider: .singleton,
configuration: HTTPClient.Configuration(timeout: timeout))

or on a per-request basis:

httpClient.execute(request: request, deadline: .now() + .milliseconds(1))

#### Streaming

When dealing with larger amount of data, it’s critical to stream the response body instead of aggregating in-memory. The following example demonstrates how to count the number of bytes in a streaming response body:

##### Using Swift Concurrency

do {
let request = HTTPClientRequest(url: "https://apple.com/")
let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
print("HTTP head", response)

// if defined, the content-length headers announces the size of the body
let expectedBytes = response.headers.first(name: "content-length").flatMap(Int.init)

var receivedBytes = 0
// asynchronously iterates over all body fragments
// this loop will automatically propagate backpressure correctly
for try await buffer in response.body {
// for this example, we are just interested in the size of the fragment
receivedBytes += buffer.readableBytes

if let expectedBytes = expectedBytes {
// if the body size is known, we calculate a progress indicator
let progress = Double(receivedBytes) / Double(expectedBytes)
print("progress: \(Int(progress * 100))%")
}
}
print("did receive \(receivedBytes) bytes")
} catch {
print("request failed:", error)
}

##### Using HTTPClientResponseDelegate and SwiftNIO EventLoopFuture

import NIOCore
import NIOHTTP1

class CountingDelegate: HTTPClientResponseDelegate {
typealias Response = Int

var count = 0

// this is executed right after request head was sent, called once
}

// this is executed when request body part is sent, could be called zero or more times
}

// this is executed when request is fully sent, called once
}

func didReceiveHead(

_ head: HTTPResponseHead

// this is executed when we receive HTTP response head part of the request
// (it contains response code and headers), called once in case backpressure
// is needed, all reads will be paused until returned future is resolved
return task.eventLoop.makeSucceededFuture(())
}

func didReceiveBodyPart(

_ buffer: ByteBuffer

// this is executed when we receive parts of the response body, could be called zero or more times
count += buffer.readableBytes
// in case backpressure is needed, all reads will be paused until returned future is resolved
return task.eventLoop.makeSucceededFuture(())
}

// this is called when the request is fully read, called once
// this is where you return a result or throw any errors you require to propagate to the client
return count
}

// this is called when we receive any network-related error, called once
}
}

let request = try HTTPClient.Request(url: "https://apple.com/")
let delegate = CountingDelegate()

httpClient.execute(request: request, delegate: delegate).futureResult.whenSuccess { count in
print(count)
}

#### File downloads

Based on the `HTTPClientResponseDelegate` example above you can build more complex delegates, the built-in `FileDownloadDelegate` is one of them. It allows streaming the downloaded data asynchronously, while reporting the download progress at the same time, like in the following example:

let request = try HTTPClient.Request(
url: "https://swift.org/builds/development/ubuntu1804/latest-build.yml"
)

let delegate = try FileDownloadDelegate(path: "/tmp/latest-build.yml", reportProgress: {
if let totalBytes = $0.totalBytes {
print("Total bytes count: \(totalBytes)")
}
print("Downloaded \($0.receivedBytes) bytes so far")
})

HTTPClient.shared.execute(request: request, delegate: delegate).futureResult
.whenSuccess { progress in
if let totalBytes = progress.totalBytes {
print("Final total bytes count: \(totalBytes)")
}
print("Downloaded finished with \(progress.receivedBytes) bytes downloaded")
}

#### Unix Domain Socket Paths

Connecting to servers bound to socket paths is easy:

HTTPClient.shared.execute(
.GET,
socketPath: "/tmp/myServer.socket",
urlPath: "/path/to/resource"
).whenComplete (...)

Connecting over TLS to a unix domain socket path is possible as well:

HTTPClient.shared.execute(
.POST,
secureSocketPath: "/tmp/myServer.socket",
urlPath: "/path/to/resource",
body: .string("hello")
).whenComplete (...)

Direct URLs can easily be constructed to be executed in other scenarios:

let socketPathBasedURL = URL(
httpURLWithSocketPath: "/tmp/myServer.socket",
uri: "/path/to/resource"
)
let secureSocketPathBasedURL = URL(
httpsURLWithSocketPath: "/tmp/myServer.socket",
uri: "/path/to/resource"
)

#### Disabling HTTP/2

The exclusive use of HTTP/1 is possible by setting `httpVersion` to `http1Only` on the `HTTPClient.Configuration`:

var configuration = HTTPClient.Configuration()
configuration.httpVersion = .http1Only
let client = HTTPClient(
eventLoopGroupProvider: .singleton,
configuration: configuration
)

### Security

AsyncHTTPClient’s security process is documented on GitHub.

## Topics

### HTTPClient

`class HTTPClient`

HTTPClient class provides API for request execution.

`struct HTTPClientRequest`

A representation of an HTTP request for the Swift Concurrency HTTPClient API.

`struct HTTPClientResponse`

A representation of an HTTP response for the Swift Concurrency HTTPClient API.

### HTTP Client Delegates

`protocol HTTPClientResponseDelegate`

`HTTPClientResponseDelegate` allows an implementation to receive notifications about request processing and to control how response parts are processed.

`class ResponseAccumulator`

The default `HTTPClientResponseDelegate`.

`class FileDownloadDelegate`

Handles a streaming download to a given file path, allowing headers and progress to be reported.

`class HTTPClientCopyingDelegate`

An `HTTPClientResponseDelegate` that wraps a callback.

### Errors

`struct HTTPClientError`

Possible client errors.

### Structures

`struct HTTPClientRequestResponse`

### Extended Modules

Foundation

- AsyncHTTPClient
- Overview
- Getting Started
- Usage guide
- Security
- Topics

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequestresponse

- AsyncHTTPClient
- HTTPClientRequestResponse

Structure

# HTTPClientRequestResponse

struct HTTPClientRequestResponse

HTTPClientResponse.swift

## Topics

### Initializers

`init(request: HTTPClientRequest, responseHead: HTTPResponseHead)`

### Instance Properties

`var request: HTTPClientRequest`

`var responseHead: HTTPResponseHead`

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClientRequestResponse
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator

- AsyncHTTPClient
- ResponseAccumulator

Class

# ResponseAccumulator

The default `HTTPClientResponseDelegate`.

final class ResponseAccumulator

HTTPHandler.swift

## Overview

This `HTTPClientResponseDelegate` buffers a complete HTTP response in memory. It does not stream the response body in. The resulting `ResponseAccumulator.Response` type is `HTTPClient.Response`.

## Topics

### Structures

`struct ResponseTooBigError`

### Initializers

`convenience init(request: HTTPClient.Request)`

`init(request: HTTPClient.Request, maxBodySize: Int)`

### Instance Properties

`let maxBodySize: Int`

Maximum size in bytes of the HTTP response body that `ResponseAccumulator` will accept until it will abort the request and throw an `ResponseAccumulator.ResponseTooBigError`.

### Type Aliases

`typealias Response`

## Relationships

### Conforms To

- `HTTPClientResponseDelegate`
- `Swift.Sendable`

## See Also

### HTTP Client Delegates

`protocol HTTPClientResponseDelegate`

`HTTPClientResponseDelegate` allows an implementation to receive notifications about request processing and to control how response parts are processed.

`class FileDownloadDelegate`

Handles a streaming download to a given file path, allowing headers and progress to be reported.

`class HTTPClientCopyingDelegate`

An `HTTPClientResponseDelegate` that wraps a callback.

- ResponseAccumulator
- Overview
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/foundation

- AsyncHTTPClient
- Foundation

Extended Module

# Foundation

## Topics

### Extended Structures

`extension URL`

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate

- AsyncHTTPClient
- FileDownloadDelegate

Class

# FileDownloadDelegate

Handles a streaming download to a given file path, allowing headers and progress to be reported.

final class FileDownloadDelegate

FileDownloadDelegate.swift

## Topics

### Structures

`struct Progress`

The response type for this delegate: the total count of bytes as reported by the response “Content-Length” header (if available), the count of bytes downloaded, the response head, and a history of requests and responses.

### Initializers

Initializes a new file download delegate.

Initializes a new file download delegate and uses the shared thread pool of the `HTTPClient` for file I/O.

### Type Aliases

`typealias Response`

## Relationships

### Conforms To

- `HTTPClientResponseDelegate`
- `Swift.Sendable`

## See Also

### HTTP Client Delegates

`protocol HTTPClientResponseDelegate`

`HTTPClientResponseDelegate` allows an implementation to receive notifications about request processing and to control how response parts are processed.

`class ResponseAccumulator`

The default `HTTPClientResponseDelegate`.

`class HTTPClientCopyingDelegate`

An `HTTPClientResponseDelegate` that wraps a callback.

- FileDownloadDelegate
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate

- AsyncHTTPClient
- HTTPClientResponseDelegate

Protocol

# HTTPClientResponseDelegate

`HTTPClientResponseDelegate` allows an implementation to receive notifications about request processing and to control how response parts are processed.

@preconcurrency
protocol HTTPClientResponseDelegate : AnyObject, Sendable

HTTPHandler.swift

## Overview

You can implement this protocol if you need fine-grained control over an HTTP request/response, for example, if you want to inspect the response headers before deciding whether to accept a response body, or if you want to stream your request body. Pass an instance of your conforming class to the `execute(request:delegate:eventLoop:deadline:)` method and this package will call each delegate method appropriately as the request takes place.

### Backpressure

A `HTTPClientResponseDelegate` can be used to exert backpressure on the server response. This is achieved by way of the futures returned from `didReceiveHead(task:_:)` and `didReceiveBodyPart(task:_:)`. The following functions are part of the “backpressure system” in the delegate:

- `didReceiveHead(task:_:)`

- `didReceiveBodyPart(task:_:)`

- `didFinishRequest(task:)`

- `didReceiveError(task:_:)`

The first three methods are strictly _exclusive_, with that exclusivity managed by the futures returned by `didReceiveHead(task:_:)` and `didReceiveBodyPart(task:_:)`. What this means is that until the returned future is completed, none of these three methods will be called again. This allows delegates to rate limit the server to a capacity it can manage. `didFinishRequest(task:)` does not return a future, as we are expecting no more data from the server at this time.

`didReceiveError(task:_:)` is somewhat special: it signals the end of this regime. `didReceiveError(task:_:)` is not exclusive: it may be called at any time, even if a returned future is not yet completed. `didReceiveError(task:_:)` is terminal, meaning that once it has been called none of these four methods will be called again. This can be used as a signal to abandon all outstanding work.

## Topics

### Associated Types

`associatedtype Response : Sendable`

**Required**

### Instance Methods

Called when the complete HTTP request is finished. You must return an instance of your `Response` associated type. Will be called once, except if an error occurred.

**Required** Default implementation provided.

Called when error was thrown during request execution. Will be called zero or one time only. Request processing will be stopped after that.

Called when the request is fully sent. Will be called once.

Called when the request head is sent. Will be called once.

Called when a part of the request body is sent. Could be called zero or more times.

Called each time a response head is received (including redirects), and always called before `didReceiveHead(task:_:)`. You can use this method to keep an entire history of the request/response chain.

## Relationships

### Inherits From

- `Swift.Sendable`

### Conforming Types

- `FileDownloadDelegate`
- `HTTPClientCopyingDelegate`
- `ResponseAccumulator`

## See Also

### HTTP Client Delegates

`class ResponseAccumulator`

The default `HTTPClientResponseDelegate`.

`class FileDownloadDelegate`

Handles a streaming download to a given file path, allowing headers and progress to be reported.

`class HTTPClientCopyingDelegate`

An `HTTPClientResponseDelegate` that wraps a callback.

- HTTPClientResponseDelegate
- Overview
- Backpressure
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse

- AsyncHTTPClient
- HTTPClientResponse

Structure

# HTTPClientResponse

A representation of an HTTP response for the Swift Concurrency HTTPClient API.

struct HTTPClientResponse

HTTPClientResponse.swift

## Overview

This object is similar to `HTTPClient.Response`, but used for the Swift Concurrency API.

## Topics

### Structures

`struct Body`

A representation of the response body for an HTTP response.

### Initializers

`init(version: HTTPVersion, status: HTTPResponseStatus, headers: HTTPHeaders, body: HTTPClientResponse.Body)`

[`init(version: HTTPVersion, status: HTTPResponseStatus, headers: HTTPHeaders, body: HTTPClientResponse.Body, history: [HTTPClientRequestResponse])`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/init(version:status:headers:body:history:))

### Instance Properties

`var body: HTTPClientResponse.Body`

The body of this HTTP response.

`var headers: HTTPHeaders`

The HTTP headers of this response.

[`var history: [HTTPClientRequestResponse]`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/history)

The history of all requests and responses in redirect order.

`var status: HTTPResponseStatus`

The HTTP status for this response.

`var url: URL?`

The target URL (after redirects) of the response.

`var version: HTTPVersion`

The HTTP version on which the response was received.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### HTTPClient

`class HTTPClient`

HTTPClient class provides API for request execution.

`struct HTTPClientRequest`

A representation of an HTTP request for the Swift Concurrency HTTPClient API.

- HTTPClientResponse
- Overview
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate

- AsyncHTTPClient
- HTTPClientCopyingDelegate

Class

# HTTPClientCopyingDelegate

An `HTTPClientResponseDelegate` that wraps a callback.

final class HTTPClientCopyingDelegate

Utils.swift

## Overview

`HTTPClientCopyingDelegate` discards most parts of a HTTP response, but streams the body to the `chunkHandler` provided on `init(chunkHandler:)`. This is mostly useful for testing.

## Topics

### Type Aliases

`typealias Response`

## Relationships

### Conforms To

- `HTTPClientResponseDelegate`
- `Swift.Sendable`

## See Also

### HTTP Client Delegates

`protocol HTTPClientResponseDelegate`

`HTTPClientResponseDelegate` allows an implementation to receive notifications about request processing and to control how response parts are processed.

`class ResponseAccumulator`

The default `HTTPClientResponseDelegate`.

`class FileDownloadDelegate`

Handles a streaming download to a given file path, allowing headers and progress to be reported.

- HTTPClientCopyingDelegate
- Overview
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest

- AsyncHTTPClient
- HTTPClientRequest

Structure

# HTTPClientRequest

A representation of an HTTP request for the Swift Concurrency HTTPClient API.

struct HTTPClientRequest

HTTPClientRequest.swift

## Overview

This object is similar to `HTTPClient.Request`, but used for the Swift Concurrency API.

## Topics

### Structures

`struct Body`

An HTTP request body.

### Initializers

`init(url: String)`

### Instance Properties

`var body: HTTPClientRequest.Body?`

The request body, if any.

`var headers: HTTPHeaders`

The request headers.

`var method: HTTPMethod`

The request method.

`var tlsConfiguration: TLSConfiguration?`

Request-specific TLS configuration, defaults to no request-specific TLS configuration.

`var url: String`

The request URL, including scheme, hostname, and optionally port.

### Instance Methods

`func setBasicAuth(username: String, password: String)`

Set basic auth for a request.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### HTTPClient

`class HTTPClient`

HTTPClient class provides API for request execution.

`struct HTTPClientResponse`

A representation of an HTTP response for the Swift Concurrency HTTPClient API.

- HTTPClientRequest
- Overview
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror

- AsyncHTTPClient
- HTTPClientError

Structure

# HTTPClientError

Possible client errors.

struct HTTPClientError

HTTPClient.swift

## Topics

### Instance Properties

`var description: String`

`var shortDescription: String`

Short description of the error that can be used in case a bounded set of error descriptions is expected, e.g. to include in metric labels. For this reason the description must not contain associated values.

### Type Properties

`static let alreadyShutdown: HTTPClientError`

Client is shutdown and cannot be used for new requests.

`static let bodyLengthMismatch: HTTPClientError`

Body length is not equal to `Content-Length`.

`static let cancelled: HTTPClientError`

Request was cancelled.

`static let chunkedSpecifiedMultipleTimes: HTTPClientError`

Request contains multiple chunks definitions.

Deprecated

`static let connectTimeout: HTTPClientError`

Creating a new tcp connection timed out

`static let contentLengthMissing: HTTPClientError`

Request does not contain `Content-Length` header.

`static let deadlineExceeded: HTTPClientError`

The request deadline was exceeded. The request was cancelled because of this.

`static let emptyHost: HTTPClientError`

URL does not contain host.

`static let emptyScheme: HTTPClientError`

URL does not contain scheme.

`static let getConnectionFromPoolTimeout: HTTPClientError`

Aquiring a HTTP connection from the connection pool timed out.

`static let httpEndReceivedAfterHeadWith1xx: HTTPClientError` Deprecated

`static let httpProxyHandshakeTimeout: HTTPClientError`

The http proxy connection creation timed out.

`static let identityCodingIncorrectlyPresent: HTTPClientError`

Request contains invalid identity encoding.

`static let incompatibleHeaders: HTTPClientError`

Incompatible headers specified, for example `Transfer-Encoding` and `Content-Length`.

`static let invalidProxyResponse: HTTPClientError`

Proxy response was invalid.

`static let invalidURL: HTTPClientError`

URL provided is invalid.

`static let missingSocketPath: HTTPClientError`

URL does not contain a socketPath as a host for http(s)+unix shemes.

`static let proxyAuthenticationRequired: HTTPClientError`

Proxy Authentication Required.

`static let readTimeout: HTTPClientError`

Request timed out while waiting for response.

`static let redirectCycleDetected: HTTPClientError`

Redirect Cycle detected.

`static let redirectLimitReached: HTTPClientError`

Redirect Limit reached.

`static let remoteConnectionClosed: HTTPClientError`

Remote connection was closed unexpectedly.

`static let requestStreamCancelled: HTTPClientError`

`static var shutdownUnsupported: HTTPClientError`

The globally shared singleton `HTTPClient` cannot be shut down.

`static let socksHandshakeTimeout: HTTPClientError`

The socks handshake timed out.

`static let tlsHandshakeTimeout: HTTPClientError`

The tls handshake timed out.

`static let traceRequestWithBody: HTTPClientError`

A body was sent in a request with method TRACE.

`static let uncleanShutdown: HTTPClientError`

Unclean shutdown.

`static let writeAfterRequestSent: HTTPClientError`

Body part was written after request was fully sent.

`static let writeTimeout: HTTPClientError`

Request timed out.

### Type Methods

Header field names contain invalid characters.

Header field values contain invalid characters.

The remote server only offered an unsupported application protocol

Provided URL scheme is not supported, supported schemes are: `http` and `https`

## Relationships

### Conforms To

- `Swift.CustomStringConvertible`
- `Swift.Equatable`
- `Swift.Error`
- `Swift.Sendable`

- HTTPClientError
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/httpversion-swift.struct/http1only

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.HTTPVersion
- http1Only

Type Property

# http1Only

We will only use HTTP/1, even if the server would supports HTTP/2

static let http1Only: `HTTPClient`. `Configuration`. `HTTPVersion`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration

Structure

# HTTPClient.Configuration

`HTTPClient` configuration.

struct Configuration

HTTPClient.swift

## Topics

### Structures

`struct ConnectionPool`

Connection pool configuration.

`struct HTTPVersion`

`struct Proxy`

Proxy server configuration Specifies the remote address of an HTTP proxy.

`struct RedirectConfiguration`

Specifies redirect processing settings.

`struct Timeout`

Timeout configuration.

### Initializers

`init(certificateVerification: CertificateVerification, redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration?, timeout: HTTPClient.Configuration.Timeout, connectionPool: TimeAmount, proxy: HTTPClient.Configuration.Proxy?, ignoreUncleanSSLShutdown: Bool, decompression: HTTPClient.Decompression, backgroundActivityLogger: Logger?)`

`init(certificateVerification: CertificateVerification, redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration?, timeout: HTTPClient.Configuration.Timeout, maximumAllowedIdleTimeInConnectionPool: TimeAmount, proxy: HTTPClient.Configuration.Proxy?, ignoreUncleanSSLShutdown: Bool, decompression: HTTPClient.Decompression)`

`init(certificateVerification: CertificateVerification, redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration?, timeout: HTTPClient.Configuration.Timeout, proxy: HTTPClient.Configuration.Proxy?, ignoreUncleanSSLShutdown: Bool, decompression: HTTPClient.Decompression)`

`init(tlsConfiguration: TLSConfiguration?, redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration?, timeout: HTTPClient.Configuration.Timeout, connectionPool: HTTPClient.Configuration.ConnectionPool, proxy: HTTPClient.Configuration.Proxy?, ignoreUncleanSSLShutdown: Bool, decompression: HTTPClient.Decompression)`

`init(tlsConfiguration: TLSConfiguration?, redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration?, timeout: HTTPClient.Configuration.Timeout, proxy: HTTPClient.Configuration.Proxy?, ignoreUncleanSSLShutdown: Bool, decompression: HTTPClient.Decompression)`

### Instance Properties

`var connectionPool: HTTPClient.Configuration.ConnectionPool`

`var decompression: HTTPClient.Decompression`

Enables automatic body decompression. Supported algorithms are gzip and deflate.

[`var dnsOverride: [String : String]`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/dnsoverride)

Sometimes it can be useful to connect to one host e.g. `x.example.com` but request and validate the certificate chain as if we would connect to `y.example.com`. `dnsOverride` allows to do just that by mapping host names which we will request and validate the certificate chain, to a different host name which will be used to actually connect to.

`var enableMultipath: Bool`

Whether `HTTPClient` will use Multipath TCP or not By default, don’t use it

A method with access to the HTTP/1 connection channel that is called when creating the connection.

A method with access to the HTTP/2 connection channel that is called when creating the connection.

A method with access to the HTTP/2 stream channel that is called when creating the stream.

`var httpVersion: HTTPClient.Configuration.HTTPVersion`

What HTTP versions to use.

`var ignoreUncleanSSLShutdown: Bool`

Ignore TLS unclean shutdown error, defaults to `false`.

Deprecated

`var maximumUsesPerConnection: Int?`

The maximum number of times each connection can be used before it is replaced with a new one. Use `nil` (the default) if no limit should be applied to each connection.

`var networkFrameworkWaitForConnectivity: Bool`

Whether `HTTPClient` will let Network.framework sit in the `.waiting` state awaiting new network changes, or fail immediately. Defaults to `true`, which is the recommended setting. Only set this to `false` when attempting to trigger a particular error path.

`var proxy: HTTPClient.Configuration.Proxy?`

Upstream proxy, defaults to no proxy.

`var redirectConfiguration: HTTPClient.Configuration.RedirectConfiguration`

Enables following 3xx redirects automatically.

`var timeout: HTTPClient.Configuration.Timeout`

Default client timeout, defaults to no `read` timeout and 10 seconds `connect` timeout.

TLS configuration, defaults to `TLSConfiguration.makeClientConfiguration()`.

### Type Properties

`static var singletonConfiguration: HTTPClient.Configuration`

The `HTTPClient.Configuration` for `shared` which tries to mimic the platform’s default or prevalent browser as closely as possible.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Configuration
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient

- AsyncHTTPClient
- HTTPClient

Class

# HTTPClient

HTTPClient class provides API for request execution.

final class HTTPClient

HTTPClient.swift

## Overview

Example:

HTTPClient.shared.get(url: "https://swift.org", deadline: .now() + .seconds(1)).whenComplete { result in
switch result {
case .failure(let error):
// process error
case .success(let response):
if let response.status == .ok {
// handle response
} else {
// handle remote error
}
}
}

## Topics

### Classes

`class Task`

Response execution context.

### Structures

`struct Authorization`

HTTP authentication.

`struct Body`

A request body.

`struct Configuration`

`HTTPClient` configuration.

`struct Cookie`

A representation of an HTTP cookie.

`struct EventLoopPreference`

Specifies how the library will treat the event loop passed by the user.

`struct NWPOSIXError`

A wrapper for `POSIX` errors thrown by `Network.framework`.

`struct NWTLSError`

A wrapper for TLS errors thrown by `Network.framework`.

`struct Request`

Represents an HTTP request.

`struct RequestResponse`

`struct Response`

Represents an HTTP response.

### Initializers

`convenience init(eventLoopGroup: any EventLoopGroup, configuration: HTTPClient.Configuration)`

Create an `HTTPClient` with specified `EventLoopGroup` and configuration.

`convenience init(eventLoopGroup: any EventLoopGroup, configuration: HTTPClient.Configuration, backgroundActivityLogger: Logger)`

`convenience init(eventLoopGroupProvider: HTTPClient.EventLoopGroupProvider, configuration: HTTPClient.Configuration)`

Create an `HTTPClient` with specified `EventLoopGroup` provider and configuration.

`convenience init(eventLoopGroupProvider: HTTPClient.EventLoopGroupProvider, configuration: HTTPClient.Configuration, backgroundActivityLogger: Logger)`

### Instance Properties

`let eventLoopGroup: any EventLoopGroup`

The `EventLoopGroup` in use by this `HTTPClient`.

### Instance Methods

Execute `DELETE` request using specified URL.

Execute arbitrary HTTP requests.

Execute arbitrary HTTPS+UNIX request to a unix domain socket path over TLS, using the specified URL as the request to send to the server.

Execute arbitrary HTTP+UNIX request to a unix domain socket path, using the specified URL as the request to send to the server.

Execute arbitrary HTTP request using specified URL.

Execute arbitrary HTTP request and handle response processing using provided delegate.

Execute `GET` request using specified URL.

Execute `PATCH` request using specified URL.

Execute `POST` request using specified URL.

Execute `PUT` request using specified URL.

`func shutdown() async throws`

Shuts down the client and `EventLoopGroup` if it was created by the client.

Shuts down the `HTTPClient` and releases its resources.

Shuts down the client and event loop gracefully.

`func syncShutdown() throws`

### Type Properties

`static var defaultEventLoopGroup: any EventLoopGroup`

Returns the default `EventLoopGroup` singleton, automatically selecting the best for the platform.

`static var shared: HTTPClient`

A globally shared, singleton `HTTPClient`.

### Type Methods

Start & automatically shut down a new `HTTPClient`.

### Enumerations

`enum Decompression`

Specifies decompression settings.

`enum EventLoopGroupProvider`

Specifies how `EventLoopGroup` will be created and establishes lifecycle ownership.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### HTTPClient

`struct HTTPClientRequest`

A representation of an HTTP request for the Swift Concurrency HTTPClient API.

`struct HTTPClientResponse`

A representation of an HTTP response for the Swift Concurrency HTTPClient API.

- HTTPClient
- Overview
- Topics
- Relationships
- See Also

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/shutdown()-9gcpw

-9gcpw#app-main)

- AsyncHTTPClient
- HTTPClient
- shutdown()

Instance Method

# shutdown()

Shuts down the `HTTPClient` and releases its resources.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/httpversion-swift.property

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- httpVersion

Instance Property

# httpVersion

What HTTP versions to use.

var httpVersion: `HTTPClient`. `Configuration`. `HTTPVersion`

HTTPClient.swift

## Discussion

Set to `automatic` by default which will use HTTP/2 if run over https and the server supports it, otherwise HTTP/1

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/maxbodysize

- AsyncHTTPClient
- ResponseAccumulator
- maxBodySize

Instance Property

# maxBodySize

Maximum size in bytes of the HTTP response body that `ResponseAccumulator` will accept until it will abort the request and throw an `ResponseAccumulator.ResponseTooBigError`.

let maxBodySize: Int

HTTPHandler.swift

## Discussion

Default is 2^32.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didreceivebodypart(task:_:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didReceiveBodyPart(task:\_:)

Instance Method

# didReceiveBodyPart(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveBodyPart(task:_:)`.

func didReceiveBodyPart(

_ part: ByteBuffer

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/init(request:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- init(request:)

Initializer

# init(request:)

convenience init(request: `HTTPClient`. `Request`)

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/init(path:pool:reporthead:reportprogress:)-ydc4

-ydc4#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- init(path:pool:reportHead:reportProgress:)

Initializer

# init(path:pool:reportHead:reportProgress:)

Initializes a new file download delegate.

@preconcurrency
init(
path: String,
pool: NIOThreadPool? = nil,

) throws

FileDownloadDelegate.swift

## Parameters

`path`

Path to a file you’d like to write the download to.

`pool`

A thread pool to use for asynchronous file I/O. If nil, a shared thread pool will be used. Defaults to nil.

`reportHead`

A closure called when the response head is available.

`reportProgress`

A closure called when a body chunk has been downloaded, with the total byte count and download byte count passed to it as arguments. The callbacks will be invoked in the same threading context that the delegate itself is invoked, as controlled by `EventLoopPreference`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/didvisiturl(task:_:_:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- didVisitURL(task:\_:\_:)

Instance Method

# didVisitURL(task:\_:\_:)

Inherited from `HTTPClientResponseDelegate.didVisitURL(task:_:_:)`.

func didVisitURL(

_ request: `HTTPClient`. `Request`,
_ head: HTTPResponseHead
)

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didsendrequest(task:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didSendRequest(task:)

Instance Method

# didSendRequest(task:)

Called when the request is fully sent. Will be called once.

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didSendRequest(task:)`.

- didSendRequest(task:)
- Parameters
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/http2connectiondebuginitializer

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- http2ConnectionDebugInitializer

Instance Property

# http2ConnectionDebugInitializer

A method with access to the HTTP/2 connection channel that is called when creating the connection.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/httpversion-swift.struct/equatable-implementations

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.HTTPVersion
- Equatable Implementations

API Collection

# Equatable Implementations

## Topics

### Operators

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/chunkedspecifiedmultipletimes

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:delegate:eventloop:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:delegate:eventLoop:deadline:)

Instance Method

# execute(request:delegate:eventLoop:deadline:)

Execute arbitrary HTTP request and handle response processing using provided delegate.

request: `HTTPClient`. `Request`,
delegate: Delegate,
eventLoop eventLoopPreference: `HTTPClient`. `EventLoopPreference`,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`delegate`

Delegate to process response parts.

`eventLoopPreference`

NIO Event Loop preference.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didvisiturl(task:_:_:)

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/decompression

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- decompression

Instance Property

# decompression

Enables automatic body decompression. Supported algorithms are gzip and deflate.

var decompression: `HTTPClient`. `Decompression`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/response

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Response

Type Alias

# FileDownloadDelegate.Response

Inherited from `HTTPClientResponseDelegate.Response`.

typealias Response = `FileDownloadDelegate`. `Progress`

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequestresponse/responsehead

- AsyncHTTPClient
- HTTPClientRequestResponse
- responseHead

Instance Property

# responseHead

var responseHead: HTTPResponseHead

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didreceivehead(task:_:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didReceiveHead(task:\_:)

Instance Method

# didReceiveHead(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveHead(task:_:)`.

func didReceiveHead(

_ head: HTTPResponseHead

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/init(request:maxbodysize:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- init(request:maxBodySize:)

Initializer

# init(request:maxBodySize:)

init(
request: `HTTPClient`. `Request`,
maxBodySize: Int
)

HTTPHandler.swift

## Parameters

`request`

The corresponding request of the response this delegate will be accumulating.

`maxBodySize`

Maximum size in bytes of the HTTP response body that `ResponseAccumulator` will accept until it will abort the request and throw an `ResponseAccumulator.ResponseTooBigError`. Default is 2^32.

## Discussion

- init(request:maxBodySize:)
- Parameters
- Discussion

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequestresponse/init(request:responsehead:)

#app-main)

- AsyncHTTPClient
- HTTPClientRequestResponse
- init(request:responseHead:)

Initializer

# init(request:responseHead:)

init(
request: `HTTPClientRequest`,
responseHead: HTTPResponseHead
)

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/responsetoobigerror

- AsyncHTTPClient
- ResponseAccumulator
- ResponseAccumulator.ResponseTooBigError

Structure

# ResponseAccumulator.ResponseTooBigError

struct ResponseTooBigError

HTTPHandler.swift

## Topics

### Initializers

`init(maxBodySize: Int)`

### Instance Properties

`var description: String`

`var maxBodySize: Int`

## Relationships

### Conforms To

- `Swift.CustomStringConvertible`
- `Swift.Error`
- `Swift.Sendable`

- ResponseAccumulator.ResponseTooBigError
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didreceiveerror(task:_:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didReceiveError(task:\_:)

Instance Method

# didReceiveError(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveError(task:_:)`.

func didReceiveError(

_ error: any Error
)

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didsendrequesthead(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didSendRequestHead(task:\_:)

Instance Method

# didSendRequestHead(task:\_:)

Called when the request head is sent. Will be called once.

func didSendRequestHead(

_ head: HTTPRequestHead
)

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`head`

Request head.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didSendRequest(task:)`.

- didSendRequestHead(task:\_:)
- Parameters
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/init(path:pool:reporthead:reportprogress:)-7rma1

-7rma1#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- init(path:pool:reportHead:reportProgress:)

Initializer

# init(path:pool:reportHead:reportProgress:)

Initializes a new file download delegate.

@preconcurrency
convenience init(
path: String,
pool: NIOThreadPool,

) throws

FileDownloadDelegate.swift

## Parameters

`path`

Path to a file you’d like to write the download to.

`pool`

A thread pool to use for asynchronous file I/O.

`reportHead`

A closure called when the response head is available.

`reportProgress`

A closure called when a body chunk has been downloaded, with the total byte count and download byte count passed to it as arguments. The callbacks will be invoked in the same threading context that the delegate itself is invoked, as controlled by `EventLoopPreference`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/httpclientresponsedelegate-implementations

- AsyncHTTPClient
- ResponseAccumulator
- HTTPClientResponseDelegate Implementations

API Collection

# HTTPClientResponseDelegate Implementations

## Topics

### Instance Methods

Default implementation of `didSendRequest(task:)`.

Default implementation of `didSendRequestPart(task:_:)`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/response

- AsyncHTTPClient
- ResponseAccumulator
- ResponseAccumulator.Response

Type Alias

# ResponseAccumulator.Response

Inherited from `HTTPClientResponseDelegate.Response`.

typealias Response = `HTTPClient`. `Response`

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didreceivebodypart(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didReceiveBodyPart(task:\_:)

Instance Method

# didReceiveBodyPart(task:\_:)

func didReceiveBodyPart(

_ buffer: ByteBuffer

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`buffer`

Received body `Part`.

## Return Value

`EventLoopFuture` that will be used for backpressure.

## Discussion

This function will not be called until the future returned by `didReceiveHead(task:_:)` has completed.

This function will not be called for subsequent body parts until the previous future returned by a call to this function completes.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didReceiveBodyPart(task:_:)`.

- didReceiveBodyPart(task:\_:)
- Parameters
- Return Value
- Discussion
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequestresponse/request

- AsyncHTTPClient
- HTTPClientRequestResponse
- request

Instance Property

# request

var request: `HTTPClientRequest`

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didfinishrequest(task:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didFinishRequest(task:)

Instance Method

# didFinishRequest(task:)

Inherited from `HTTPClientResponseDelegate.didFinishRequest(task:)`.

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/init(path:reporthead:reportprogress:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- init(path:reportHead:reportProgress:)

Initializer

# init(path:reportHead:reportProgress:)

Initializes a new file download delegate and uses the shared thread pool of the `HTTPClient` for file I/O.

@preconcurrency
convenience init(
path: String,

) throws

FileDownloadDelegate.swift

## Parameters

`path`

Path to a file you’d like to write the download to.

`reportHead`

A closure called when the response head is available.

`reportProgress`

A closure called when a body chunk has been downloaded, with the total byte count and download byte count passed to it as arguments. The callbacks will be invoked in the same threading context that the delegate itself is invoked, as controlled by `EventLoopPreference`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/body-swift.property

- AsyncHTTPClient
- HTTPClientResponse
- body

Instance Property

# body

The body of this HTTP response.

var body: `HTTPClientResponse`. `Body`

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Progress

Structure

# FileDownloadDelegate.Progress

The response type for this delegate: the total count of bytes as reported by the response “Content-Length” header (if available), the count of bytes downloaded, the response head, and a history of requests and responses.

struct Progress

FileDownloadDelegate.swift

## Topics

### Instance Properties

`var head: HTTPResponseHead`

[`var history: [HTTPClient.RequestResponse]`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress/history)

The history of all requests and responses in redirect order.

`var receivedBytes: Int`

`var totalBytes: Int?`

`var url: URL?`

The target URL (after redirects) of the response.

## Relationships

### Conforms To

- `Swift.Sendable`

- FileDownloadDelegate.Progress
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/init(version:status:headers:body:history:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponse
- init(version:status:headers:body:history:)

Initializer

# init(version:status:headers:body:history:)

init(
version: HTTPVersion = .http1_1,
status: HTTPResponseStatus = .ok,
headers: HTTPHeaders = [:],
body: `HTTPClientResponse`. `Body` = Body(),
history: [`HTTPClientRequestResponse`] = []
)

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/didreceivebodypart(task:_:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- didReceiveBodyPart(task:\_:)

Instance Method

# didReceiveBodyPart(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveBodyPart(task:_:)`.

func didReceiveBodyPart(

_ buffer: ByteBuffer

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didvisiturl(task:_:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didVisitURL(task:\_:\_:)

Instance Method

# didVisitURL(task:\_:\_:)

Called each time a response head is received (including redirects), and always called before `didReceiveHead(task:_:)`. You can use this method to keep an entire history of the request/response chain.

func didVisitURL(

_ request: `HTTPClient`. `Request`,
_ head: HTTPResponseHead
)

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`request`

The request that was sent.

`head`

Received response head.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didVisitURL(task:_:_:)`.

- didVisitURL(task:\_:\_:)
- Parameters
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/headers

- AsyncHTTPClient
- HTTPClientResponse
- headers

Instance Property

# headers

The HTTP headers of this response.

var headers: HTTPHeaders

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/didfinishrequest(task:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- didFinishRequest(task:)

Instance Method

# didFinishRequest(task:)

Inherited from `HTTPClientResponseDelegate.didFinishRequest(task:)`.

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/version

- AsyncHTTPClient
- HTTPClientResponse
- version

Instance Property

# version

The HTTP version on which the response was received.

var version: HTTPVersion

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/body-swift.struct

- AsyncHTTPClient
- HTTPClientResponse
- HTTPClientResponse.Body

Structure

# HTTPClientResponse.Body

A representation of the response body for an HTTP response.

struct Body

HTTPClientResponse.swift

## Overview

The body is streamed as an `AsyncSequence` of `ByteBuffer`, where each `ByteBuffer` contains an arbitrarily large chunk of data. The boundaries between `ByteBuffer` objects in the sequence are entirely synthetic and have no semantic meaning.

## Topics

### Structures

`struct AsyncIterator`

### Initializers

`init()`

### Instance Methods

Accumulates `Body` of `ByteBuffer` s into a single `ByteBuffer`.

### Type Aliases

`typealias Element`

## Relationships

### Conforms To

- `Swift.Sendable`
- `_Concurrency.AsyncSequence`

- HTTPClientResponse.Body
- Overview
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/authorization

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Authorization

Structure

# HTTPClient.Authorization

HTTP authentication.

struct Authorization

HTTPHandler.swift

## Topics

### Instance Properties

`var headerValue: String`

The header string for this auth field.

### Type Methods

HTTP basic auth.

HTTP bearer auth

## Relationships

### Conforms To

- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- HTTPClient.Authorization
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/didreceivehead(task:_:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- didReceiveHead(task:\_:)

Instance Method

# didReceiveHead(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveHead(task:_:)`.

func didReceiveHead(

_ head: HTTPResponseHead

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didsendrequestpart(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didSendRequestPart(task:\_:)

Instance Method

# didSendRequestPart(task:\_:)

Called when a part of the request body is sent. Could be called zero or more times.

func didSendRequestPart(

_ part: IOData
)

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`part`

Request body part.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didSendRequestPart(task:_:)`.

- didSendRequestPart(task:\_:)
- Parameters
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didreceivehead(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didReceiveHead(task:\_:)

Instance Method

# didReceiveHead(task:\_:)

func didReceiveHead(

_ head: HTTPResponseHead

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`head`

Received reposonse head.

## Return Value

`EventLoopFuture` that will be used for backpressure.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didReceiveHead(task:_:)`.

- didReceiveHead(task:\_:)
- Parameters
- Return Value
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/proxy-swift.struct

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.Proxy

Structure

# HTTPClient.Configuration.Proxy

Proxy server configuration Specifies the remote address of an HTTP proxy.

struct Proxy

HTTPClient+Proxy.swift

## Overview

Adding an `Proxy` to your client’s `HTTPClient.Configuration` will cause requests to be passed through the specified proxy using the HTTP `CONNECT` method.

If a `TLSConfiguration` is used in conjunction with `HTTPClient.Configuration.Proxy`, TLS will be established _after_ successful proxy, between your client and the destination server.

## Topics

### Instance Properties

`var authorization: HTTPClient.Authorization?`

Specifies Proxy server authorization.

`var host: String`

Specifies Proxy server host.

`var port: Int`

Specifies Proxy server port.

### Type Methods

Create a HTTP proxy.

Create a SOCKSv5 proxy.

## Relationships

### Conforms To

- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- HTTPClient.Configuration.Proxy
- Overview
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/body

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Body

Structure

# HTTPClient.Body

A request body.

struct Body

HTTPHandler.swift

## Topics

### Structures

`struct StreamWriter`

A streaming uploader.

### Instance Properties

`var contentLength: Int64?`

Body size. If nil, `Transfer-Encoding` will automatically be set to `chunked`. Otherwise a `Content-Length` header is set with the given `contentLength`.

`var length: Int?`

Body size. If nil, `Transfer-Encoding` will automatically be set to `chunked`. Otherwise a `Content-Length` header is set with the given `length`.

Deprecated

Body chunk provider.

### Type Methods

Create and stream body using `ByteBuffer`.

Create and stream body using a collection of bytes.

Create and stream body using `Data`.

Create and stream body using `HTTPClient.Body.StreamWriter`.

Create and stream body using `String`.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Body
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/connecttimeout

- AsyncHTTPClient
- HTTPClientError
- connectTimeout

Type Property

# connectTimeout

Creating a new tcp connection timed out

static let connectTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/didreceiveerror(task:_:)

#app-main)

- AsyncHTTPClient
- FileDownloadDelegate
- didReceiveError(task:\_:)

Instance Method

# didReceiveError(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveError(task:_:)`.

func didReceiveError(

_ error: any Error
)

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/getconnectionfrompooltimeout

- AsyncHTTPClient
- HTTPClientError
- getConnectionFromPoolTimeout

Type Property

# getConnectionFromPoolTimeout

Aquiring a HTTP connection from the connection pool timed out.

static let getConnectionFromPoolTimeout: `HTTPClientError`

HTTPClient.swift

## Discussion

This can have multiple reasons:

- A connection could not be created within the timout period.

- Tasks are not processed fast enough on the existing connections, to process all waiters in time

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/cancelled

- AsyncHTTPClient
- HTTPClientError
- cancelled

Type Property

# cancelled

Request was cancelled.

static let cancelled: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/url

- AsyncHTTPClient
- HTTPClientResponse
- url

Instance Property

# url

The target URL (after redirects) of the response.

var url: URL? { get }

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didfinishrequest(task:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didFinishRequest(task:)

Instance Method

# didFinishRequest(task:)

Called when the complete HTTP request is finished. You must return an instance of your `Response` associated type. Will be called once, except if an error occurred.

HTTPHandler.swift

**Required**

## Parameters

`task`

Current request context.

## Return Value

Result of processing.

## Discussion

This function will not be called until all futures returned by `didReceiveHead(task:_:)` and `didReceiveBodyPart(task:_:)` have completed. Once called, no further calls will be made to `didReceiveHead(task:_:)`, `didReceiveBodyPart(task:_:)`, or `didReceiveError(task:_:)`.

- didFinishRequest(task:)
- Parameters
- Return Value
- Discussion

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/contentlengthmissing

- AsyncHTTPClient
- HTTPClientError
- contentLengthMissing

Type Property

# contentLengthMissing

Request does not contain `Content-Length` header.

static let contentLengthMissing: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/alreadyshutdown

- AsyncHTTPClient
- HTTPClientError
- alreadyShutdown

Type Property

# alreadyShutdown

Client is shutdown and cannot be used for new requests.

static let alreadyShutdown: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/history

- AsyncHTTPClient
- HTTPClientResponse
- history

Instance Property

# history

The history of all requests and responses in redirect order.

var history: [`HTTPClientRequestResponse`]

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(certificateverification:redirectconfiguration:timeout:proxy:ignoreuncleansslshutdown:decompression:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(certificateVerification:redirectConfiguration:timeout:proxy:ignoreUncleanSSLShutdown:decompression:)

Initializer

# init(certificateVerification:redirectConfiguration:timeout:proxy:ignoreUncleanSSLShutdown:decompression:)

init(
certificateVerification: CertificateVerification,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled
)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/foundation/url

- AsyncHTTPClient
- Foundation
- URL

Extended Structure

# URL

AsyncHTTPClientFoundation

extension URL

## Topics

### Initializers

`init?(httpURLWithSocketPath: String, uri: String)`

Initializes a newly created HTTP URL connecting to a unix domain socket path. The socket path is encoded as the URL’s host, replacing percent encoding invalid path characters, and will use the “http+unix” scheme.

`init?(httpsURLWithSocketPath: String, uri: String)`

Initializes a newly created HTTPS URL connecting to a unix domain socket path over TLS. The socket path is encoded as the URL’s host, replacing percent encoding invalid path characters, and will use the “https+unix” scheme.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/emptyscheme

- AsyncHTTPClient
- HTTPClientError
- emptyScheme

Type Property

# emptyScheme

URL does not contain scheme.

static let emptyScheme: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/httpendreceivedafterheadwith1xx

- AsyncHTTPClient
- HTTPClientError
- httpEndReceivedAfterHeadWith1xx Deprecated

Type Property

# httpEndReceivedAfterHeadWith1xx

static let httpEndReceivedAfterHeadWith1xx: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(tlsconfiguration:redirectconfiguration:timeout:connectionpool:proxy:ignoreuncleansslshutdown:decompression:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(tlsConfiguration:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:)

Initializer

# init(tlsConfiguration:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:)

init(
tlsConfiguration: TLSConfiguration? = nil,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
connectionPool: `HTTPClient`. `Configuration`. `ConnectionPool` = ConnectionPool(),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled
)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/request

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Request

Structure

# HTTPClient.Request

Represents an HTTP request.

struct Request

HTTPHandler.swift

## Topics

### Initializers

`init(url: URL, method: HTTPMethod, headers: HTTPHeaders, body: HTTPClient.Body?) throws`

Create an HTTP `Request`.

`init(url: String, method: HTTPMethod, headers: HTTPHeaders, body: HTTPClient.Body?) throws`

Create HTTP request.

`init(url: URL, method: HTTPMethod, headers: HTTPHeaders, body: HTTPClient.Body?, tlsConfiguration: TLSConfiguration?) throws`

`init(url: String, method: HTTPMethod, headers: HTTPHeaders, body: HTTPClient.Body?, tlsConfiguration: TLSConfiguration?) throws`

### Instance Properties

`var body: HTTPClient.Body?`

Request body, defaults to no body.

`var headers: HTTPHeaders`

Request custom HTTP Headers, defaults to no headers.

`var host: String`

Remote host, resolved from `URL`.

`let method: HTTPMethod`

Request HTTP method, defaults to `GET`.

`var port: Int`

Resolved port.

`var scheme: String`

Remote HTTP scheme, resolved from `URL`.

`var tlsConfiguration: TLSConfiguration?`

Request-specific TLS configuration, defaults to no request-specific TLS configuration.

`let url: URL`

Remote URL.

`var useTLS: Bool`

Whether request will be executed using secure socket.

### Instance Methods

`func setBasicAuth(username: String, password: String)`

Set basic auth for a request.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Request
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/shortdescription

- AsyncHTTPClient
- HTTPClientError
- shortDescription

Instance Property

# shortDescription

Short description of the error that can be used in case a bounded set of error descriptions is expected, e.g. to include in metric labels. For this reason the description must not contain associated values.

var shortDescription: String { get }

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/deadlineexceeded

- AsyncHTTPClient
- HTTPClientError
- deadlineExceeded

Type Property

# deadlineExceeded

The request deadline was exceeded. The request was cancelled because of this.

static let deadlineExceeded: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/httpversion-swift.struct/automatic

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.HTTPVersion
- automatic

Type Property

# automatic

HTTP/2 is used if we connect to a server with HTTPS and the server supports HTTP/2, otherwise we use HTTP/1

static let automatic: `HTTPClient`. `Configuration`. `HTTPVersion`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/httpclientresponsedelegate-implementations

- AsyncHTTPClient
- FileDownloadDelegate
- HTTPClientResponseDelegate Implementations

API Collection

# HTTPClientResponseDelegate Implementations

## Topics

### Instance Methods

Default implementation of `didSendRequest(task:)`.

Default implementation of `didSendRequestPart(task:_:)`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/httpversion-swift.struct

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.HTTPVersion

Structure

# HTTPClient.Configuration.HTTPVersion

struct HTTPVersion

HTTPClient.swift

## Topics

### Type Properties

`static let automatic: HTTPClient.Configuration.HTTPVersion`

HTTP/2 is used if we connect to a server with HTTPS and the server supports HTTP/2, otherwise we use HTTP/1

`static let http1Only: HTTPClient.Configuration.HTTPVersion`

We will only use HTTP/1, even if the server would supports HTTP/2

## Relationships

### Conforms To

- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- HTTPClient.Configuration.HTTPVersion
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/connectionpool-swift.struct

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.ConnectionPool

Structure

# HTTPClient.Configuration.ConnectionPool

Connection pool configuration.

struct ConnectionPool

HTTPClient.swift

## Topics

### Initializers

`init()`

`init(idleTimeout: TimeAmount)`

`init(idleTimeout: TimeAmount, concurrentHTTP1ConnectionsPerHostSoftLimit: Int)`

### Instance Properties

`var concurrentHTTP1ConnectionsPerHostSoftLimit: Int`

The maximum number of connections that are kept alive in the connection pool per host. If requests with an explicit eventLoopRequirement are sent, this number might be exceeded due to overflow connections.

`var idleTimeout: TimeAmount`

Specifies amount of time connections are kept idle in the pool. After this time has passed without a new request the connections are closed.

`var preWarmedHTTP1ConnectionCount: Int`

The number of pre-warmed HTTP/1 connections to maintain.

`var retryConnectionEstablishment: Bool`

If true, `HTTPClient` will try to create new connections on connection failure with an exponential backoff. Requests will only fail after the `connect` timeout exceeded. If false, all requests that have no assigned connection will fail immediately after a connection could not be established. Defaults to `true`.

## Relationships

### Conforms To

- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- HTTPClient.Configuration.ConnectionPool
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/description

- AsyncHTTPClient
- HTTPClientError
- description

Instance Property

# description

Inherited from `CustomStringConvertible.description`.

var description: String { get }

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(tlsconfiguration:redirectconfiguration:timeout:connectionpool:proxy:ignoreuncleansslshutdown:decompression:http1_1connectiondebuginitializer:http2connectiondebuginitializer:http2streamchanneldebuginitializer:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(tlsConfiguration:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:http1\_1ConnectionDebugInitializer:http2ConnectionDebugInitializer:http2StreamChannelDebugInitializer:)

Initializer

# init(tlsConfiguration:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:http1\_1ConnectionDebugInitializer:http2ConnectionDebugInitializer:http2StreamChannelDebugInitializer:)

init(
tlsConfiguration: TLSConfiguration? = nil,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
connectionPool: `HTTPClient`. `Configuration`. `ConnectionPool` = ConnectionPool(),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled,

)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/task

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Task

Class

# HTTPClient.Task

Response execution context.

HTTPHandler.swift

## Overview

## Topics

### Instance Properties

`let eventLoop: any EventLoop`

The `EventLoop` the delegate will be executed on.

`EventLoopFuture` for the response returned by this request.

`let logger: Logger`

The `Logger` used by the `Task` for logging.

### Instance Methods

`func cancel()`

Initiate cancellation of a HTTP request.

`func fail(reason: any Error)`

Initiate cancellation of a HTTP request with an `error`.

Provides the result of this request.

Waits for execution of this request to complete.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Task
- Overview
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/missingsocketpath

- AsyncHTTPClient
- HTTPClientError
- missingSocketPath

Type Property

# missingSocketPath

URL does not contain a socketPath as a host for http(s)+unix shemes.

static let missingSocketPath: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/httpproxyhandshaketimeout

- AsyncHTTPClient
- HTTPClientError
- httpProxyHandshakeTimeout

Type Property

# httpProxyHandshakeTimeout

The http proxy connection creation timed out.

static let httpProxyHandshakeTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/invalidproxyresponse

- AsyncHTTPClient
- HTTPClientError
- invalidProxyResponse

Type Property

# invalidProxyResponse

Proxy response was invalid.

static let invalidProxyResponse: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/timeout-swift.struct

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.Timeout

Structure

# HTTPClient.Configuration.Timeout

Timeout configuration.

struct Timeout

HTTPClient.swift

## Topics

### Initializers

`init(connect: TimeAmount?, read: TimeAmount?)`

Create timeout.

`init(connect: TimeAmount?, read: TimeAmount?, write: TimeAmount)`

### Instance Properties

`var connect: TimeAmount?`

Specifies connect timeout. If no connect timeout is given, a default 10 seconds timeout will be applied.

`var read: TimeAmount?`

Specifies read timeout.

`var write: TimeAmount?`

Specifies the maximum amount of time without bytes being written by the client before closing the connection.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Configuration.Timeout
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponse/init(version:status:headers:body:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponse
- init(version:status:headers:body:)

Initializer

# init(version:status:headers:body:)

init(
version: HTTPVersion = .http1_1,
status: HTTPResponseStatus = .ok,
headers: HTTPHeaders = [:],
body: `HTTPClientResponse`. `Body` = Body()
)

HTTPClientResponse.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(certificateverification:redirectconfiguration:timeout:maximumallowedidletimeinconnectionpool:proxy:ignoreuncleansslshutdown:decompression:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(certificateVerification:redirectConfiguration:timeout:maximumAllowedIdleTimeInConnectionPool:proxy:ignoreUncleanSSLShutdown:decompression:)

Initializer

# init(certificateVerification:redirectConfiguration:timeout:maximumAllowedIdleTimeInConnectionPool:proxy:ignoreUncleanSSLShutdown:decompression:)

init(
certificateVerification: CertificateVerification,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
maximumAllowedIdleTimeInConnectionPool: TimeAmount = .seconds(60),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled
)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/response

- AsyncHTTPClient
- HTTPClientResponseDelegate
- Response

Associated Type

# Response

associatedtype Response : Sendable

HTTPHandler.swift

**Required**

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/bodylengthmismatch

- AsyncHTTPClient
- HTTPClientError
- bodyLengthMismatch

Type Property

# bodyLengthMismatch

Body length is not equal to `Content-Length`.

static let bodyLengthMismatch: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/http1_1connectiondebuginitializer

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- http1\_1ConnectionDebugInitializer

Instance Property

# http1\_1ConnectionDebugInitializer

A method with access to the HTTP/1 connection channel that is called when creating the connection.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/emptyhost

- AsyncHTTPClient
- HTTPClientError
- emptyHost

Type Property

# emptyHost

URL does not contain host.

static let emptyHost: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/dnsoverride

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- dnsOverride

Instance Property

# dnsOverride

Sometimes it can be useful to connect to one host e.g. `x.example.com` but request and validate the certificate chain as if we would connect to `y.example.com`. `dnsOverride` allows to do just that by mapping host names which we will request and validate the certificate chain, to a different host name which will be used to actually connect to.

var dnsOverride: [String : String]

HTTPClient.swift

## Discussion

**Example:** if `dnsOverride` is set to `["example.com": "localhost"]` and we execute a request with a `url` of `https://example.com/`, the `HTTPClient` will actually open a connection to `localhost` instead of `example.com`. `HTTPClient` will still request certificates from the server for `example.com` and validate them as if we would connect to `example.com`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/unsupportedscheme(_:)

#app-main)

- AsyncHTTPClient
- HTTPClientError
- unsupportedScheme(\_:)

Type Method

# unsupportedScheme(\_:)

Provided URL scheme is not supported, supported schemes are: `http` and `https`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(certificateverification:redirectconfiguration:timeout:connectionpool:proxy:ignoreuncleansslshutdown:decompression:backgroundactivitylogger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(certificateVerification:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:backgroundActivityLogger:)

Initializer

# init(certificateVerification:redirectConfiguration:timeout:connectionPool:proxy:ignoreUncleanSSLShutdown:decompression:backgroundActivityLogger:)

init(
certificateVerification: CertificateVerification,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
connectionPool: TimeAmount = .seconds(60),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled,
backgroundActivityLogger: Logger?
)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(_:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(\_:deadline:logger:)

Instance Method

# execute(\_:deadline:logger:)

Execute arbitrary HTTP requests.

func execute(
_ request: `HTTPClientRequest`,
deadline: NIODeadline,
logger: Logger? = nil

HTTPClient+execute.swift

## Parameters

`request`

HTTP request to execute.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

## Return Value

The response to the request. Note that the `body` of the response may not yet have been fully received.

## Discussion

- execute(\_:deadline:logger:)
- Parameters
- Return Value
- Discussion

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/connectionpool-swift.property

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- connectionPool

Instance Property

# connectionPool

Connection pool configuration.

var connectionPool: `HTTPClient`. `Configuration`. `ConnectionPool`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/ignoreuncleansslshutdown

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- ignoreUncleanSSLShutdown Deprecated

Instance Property

# ignoreUncleanSSLShutdown

Ignore TLS unclean shutdown error, defaults to `false`.

var ignoreUncleanSSLShutdown: Bool { get set }

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/redirectconfiguration-swift.struct

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.RedirectConfiguration

Structure

# HTTPClient.Configuration.RedirectConfiguration

Specifies redirect processing settings.

struct RedirectConfiguration

HTTPClient.swift

## Topics

### Type Properties

`static let disallow: HTTPClient.Configuration.RedirectConfiguration`

Redirects are not followed.

### Type Methods

Redirects are followed with a specified limit.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Configuration.RedirectConfiguration
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/init(tlsconfiguration:redirectconfiguration:timeout:proxy:ignoreuncleansslshutdown:decompression:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- init(tlsConfiguration:redirectConfiguration:timeout:proxy:ignoreUncleanSSLShutdown:decompression:)

Initializer

# init(tlsConfiguration:redirectConfiguration:timeout:proxy:ignoreUncleanSSLShutdown:decompression:)

init(
tlsConfiguration: TLSConfiguration? = nil,
redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`? = nil,
timeout: `HTTPClient`. `Configuration`. `Timeout` = Timeout(),
proxy: `HTTPClient`. `Configuration`. `Proxy`? = nil,
ignoreUncleanSSLShutdown: Bool = false,
decompression: `HTTPClient`. `Decompression` = .disabled
)

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/tlsconfiguration

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- tlsConfiguration

Instance Property

# tlsConfiguration

TLS configuration, defaults to `TLSConfiguration.makeClientConfiguration()`.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/http2streamchanneldebuginitializer

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- http2StreamChannelDebugInitializer

Instance Property

# http2StreamChannelDebugInitializer

A method with access to the HTTP/2 stream channel that is called when creating the stream.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/identitycodingincorrectlypresent

- AsyncHTTPClient
- HTTPClientError
- identityCodingIncorrectlyPresent

Type Property

# identityCodingIncorrectlyPresent

Request contains invalid identity encoding.

static let identityCodingIncorrectlyPresent: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/networkframeworkwaitforconnectivity

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- networkFrameworkWaitForConnectivity

Instance Property

# networkFrameworkWaitForConnectivity

Whether `HTTPClient` will let Network.framework sit in the `.waiting` state awaiting new network changes, or fail immediately. Defaults to `true`, which is the recommended setting. Only set this to `false` when attempting to trigger a particular error path.

var networkFrameworkWaitForConnectivity: Bool

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/maximumusesperconnection

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- maximumUsesPerConnection

Instance Property

# maximumUsesPerConnection

The maximum number of times each connection can be used before it is replaced with a new one. Use `nil` (the default) if no limit should be applied to each connection.

var maximumUsesPerConnection: Int? { get set }

HTTPClient.swift

## Discussion

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/incompatibleheaders

- AsyncHTTPClient
- HTTPClientError
- incompatibleHeaders Deprecated

Type Property

# incompatibleHeaders

Incompatible headers specified, for example `Transfer-Encoding` and `Content-Length`.

static let incompatibleHeaders: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didreceiveerror(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didReceiveError(task:\_:)

Instance Method

# didReceiveError(task:\_:)

Called when error was thrown during request execution. Will be called zero or one time only. Request processing will be stopped after that.

func didReceiveError(

_ error: any Error
)

HTTPHandler.swift

**Required** Default implementation provided.

## Parameters

`task`

Current request context.

`error`

Error that occured during response processing.

## Discussion

This function may be called at any time: it does not respect the backpressure exerted by `didReceiveHead(task:_:)` and `didReceiveBodyPart(task:_:)`. All outstanding work may be cancelled when this is received. Once called, no further calls will be made to `didReceiveHead(task:_:)`, `didReceiveBodyPart(task:_:)`, or `didFinishRequest(task:)`.

## Default Implementations

### HTTPClientResponseDelegate Implementations

Default implementation of `didReceiveError(task:_:)`.

- didReceiveError(task:\_:)
- Parameters
- Discussion
- Default Implementations

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/enablemultipath

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- enableMultipath

Instance Property

# enableMultipath

Whether `HTTPClient` will use Multipath TCP or not By default, don’t use it

var enableMultipath: Bool

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/response

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Response

Structure

# HTTPClient.Response

Represents an HTTP response.

struct Response

HTTPHandler.swift

## Topics

### Initializers

`init(host: String, status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?)`

Create HTTP `Response`.

Deprecated

`init(host: String, status: HTTPResponseStatus, version: HTTPVersion, headers: HTTPHeaders, body: ByteBuffer?)`

[`init(host: String, status: HTTPResponseStatus, version: HTTPVersion, headers: HTTPHeaders, body: ByteBuffer?, history: [HTTPClient.RequestResponse])`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/response/init(host:status:version:headers:body:history:))

### Instance Properties

`var body: ByteBuffer?`

Response body.

[`var cookies: [HTTPClient.Cookie]`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/response/cookies)

List of HTTP cookies returned by the server.

`var headers: HTTPHeaders`

Reponse HTTP headers.

[`var history: [HTTPClient.RequestResponse]`](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/response/history)

The history of all requests and responses in redirect order.

`var host: String`

Remote host of the request.

`var status: HTTPResponseStatus`

Response HTTP status.

`var url: URL?`

The target URL (after redirects) of the response.

`var version: HTTPVersion`

Response HTTP version.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Response
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/shared

- AsyncHTTPClient
- HTTPClient
- shared

Type Property

# shared

A globally shared, singleton `HTTPClient`.

static var shared: `HTTPClient` { get }

Singleton.swift

## Discussion

The returned client uses the following settings:

- configuration is `singletonConfiguration` (matching the platform’s default/prevalent browser as well as possible)

- `EventLoopGroup` is `defaultEventLoopGroup` (matching the platform default)

- logging is disabled

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:deadline:logger:)

Instance Method

# execute(request:deadline:logger:)

Execute arbitrary HTTP request using specified URL.

func execute(
request: `HTTPClient`. `Request`,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/invalidurl

- AsyncHTTPClient
- HTTPClientError
- invalidURL

Type Property

# invalidURL

URL provided is invalid.

static let invalidURL: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/writeafterrequestsent

- AsyncHTTPClient
- HTTPClientError
- writeAfterRequestSent

Type Property

# writeAfterRequestSent

Body part was written after request was fully sent.

static let writeAfterRequestSent: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/shutdown()-96ayw

-96ayw#app-main)

- AsyncHTTPClient
- HTTPClient
- shutdown()

Instance Method

# shutdown()

Shuts down the client and `EventLoopGroup` if it was created by the client.

func shutdown() async throws

HTTPClient+shutdown.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/eventlooppreference

- AsyncHTTPClient
- HTTPClient
- HTTPClient.EventLoopPreference

Structure

# HTTPClient.EventLoopPreference

Specifies how the library will treat the event loop passed by the user.

struct EventLoopPreference

HTTPClient.swift

## Topics

### Type Properties

`static let indifferent: HTTPClient.EventLoopPreference`

Event Loop will be selected by the library.

### Type Methods

The delegate will be run on the specified EventLoop (and the Channel if possible).

The delegate and the `Channel` will be run on the specified EventLoop.

## Relationships

### Conforms To

- `Swift.Copyable`
- `Swift.CustomStringConvertible`
- `Swift.Sendable`

- HTTPClient.EventLoopPreference
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/nwtlserror

- AsyncHTTPClient
- HTTPClient
- HTTPClient.NWTLSError

Structure

# HTTPClient.NWTLSError

A wrapper for TLS errors thrown by `Network.framework`.

struct NWTLSError

NWErrorHandler.swift

## Topics

### Initializers

`init(OSStatus, reason: String)`

initialise a NWTLSError

### Instance Properties

`var description: String`

`let status: OSStatus`

## Relationships

### Conforms To

- `Swift.CustomStringConvertible`
- `Swift.Error`
- `Swift.Sendable`

- HTTPClient.NWTLSError
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/uncleanshutdown

- AsyncHTTPClient
- HTTPClientError
- uncleanShutdown

Type Property

# uncleanShutdown

Unclean shutdown.

static let uncleanShutdown: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/responsetoobigerror/maxbodysize

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/httpclientresponsedelegate-implementations

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- HTTPClientResponseDelegate Implementations

API Collection

# HTTPClientResponseDelegate Implementations

## Topics

### Instance Methods

Default implementation of `didReceiveError(task:_:)`.

Default implementation of `didReceiveHead(task:_:)`.

Default implementation of `didSendRequest(task:)`.

Default implementation of `didSendRequestPart(task:_:)`.

Default implementation of `didVisitURL(task:_:_:)`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/url

- AsyncHTTPClient
- HTTPClientRequest
- url

Instance Property

# url

The request URL, including scheme, hostname, and optionally port.

var url: String

HTTPClientRequest.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/decompression

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Decompression

Enumeration

# HTTPClient.Decompression

Specifies decompression settings.

enum Decompression

HTTPClient.swift

## Topics

### Enumeration Cases

`case disabled`

Decompression is disabled.

`case enabled(limit: NIOHTTPDecompression.DecompressionLimit)`

Decompression is enabled.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Decompression
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/put(url:body:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- put(url:body:deadline:)

Instance Method

# put(url:body:deadline:)

Execute `PUT` request using specified URL.

func put(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(_:url:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(\_:url:body:deadline:logger:)

Instance Method

# execute(\_:url:body:deadline:logger:)

Execute arbitrary HTTP request using specified URL.

func execute(
_ method: HTTPMethod = .GET,
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger? = nil

HTTPClient.swift

## Parameters

`method`

Request method.

`url`

Request url.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/setbasicauth(username:password:)

#app-main)

- AsyncHTTPClient
- HTTPClientRequest
- setBasicAuth(username:password:)

Instance Method

# setBasicAuth(username:password:)

Set basic auth for a request.

mutating func setBasicAuth(
username: String,
password: String
)

HTTPClientRequest+auth.swift

## Parameters

`username`

The username to authenticate with

`password`

Authentication password associated with the username

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/init(eventloopgroup:configuration:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- init(eventLoopGroup:configuration:)

Initializer

# init(eventLoopGroup:configuration:)

Create an `HTTPClient` with specified `EventLoopGroup` and configuration.

convenience init(
eventLoopGroup: any EventLoopGroup = HTTPClient.defaultEventLoopGroup,
configuration: `HTTPClient`. `Configuration` = Configuration()
)

HTTPClient.swift

## Parameters

`eventLoopGroup`

Specify how `EventLoopGroup` will be created.

`configuration`

Client configuration.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/patch(url:body:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- patch(url:body:deadline:)

Instance Method

# patch(url:body:deadline:)

Execute `PATCH` request using specified URL.

func patch(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/timeout-swift.struct/read

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.Timeout
- read

Instance Property

# read

Specifies read timeout.

var read: TimeAmount?

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/get(url:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- get(url:deadline:)

Instance Method

# get(url:deadline:)

Execute `GET` request using specified URL.

func get(
url: String,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`url`

Remote URL.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/writetimeout

- AsyncHTTPClient
- HTTPClientError
- writeTimeout

Type Property

# writeTimeout

Request timed out.

static let writeTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/readtimeout

- AsyncHTTPClient
- HTTPClientError
- readTimeout

Type Property

# readTimeout

Request timed out while waiting for response.

static let readTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/sockshandshaketimeout

- AsyncHTTPClient
- HTTPClientError
- socksHandshakeTimeout

Type Property

# socksHandshakeTimeout

The socks handshake timed out.

static let socksHandshakeTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/redirectlimitreached

- AsyncHTTPClient
- HTTPClientError
- redirectLimitReached

Type Property

# redirectLimitReached

Redirect Limit reached.

static let redirectLimitReached: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/didfinishrequest(task:)

#app-main)

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- didFinishRequest(task:)

Instance Method

# didFinishRequest(task:)

Inherited from `HTTPClientResponseDelegate.didFinishRequest(task:)`.

Utils.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/withhttpclient(eventloopgroup:configuration:backgroundactivitylogger:isolation:_:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- withHTTPClient(eventLoopGroup:configuration:backgroundActivityLogger:isolation:\_:)

Type Method

# withHTTPClient(eventLoopGroup:configuration:backgroundActivityLogger:isolation:\_:)

Start & automatically shut down a new `HTTPClient`.

eventLoopGroup: any EventLoopGroup = HTTPClient.defaultEventLoopGroup,
configuration: `HTTPClient`. `Configuration` = Configuration(),
backgroundActivityLogger: Logger? = nil,
isolation: isolated (any Actor)? = #isolation,

HTTPClient+StructuredConcurrency.swift

## Discussion

This method allows to start & automatically dispose of a `HTTPClient` following the principle of Structured Concurrency. The `HTTPClient` is guaranteed to be shut down upon return, whether `body` throws or not.

This may be particularly useful if you cannot use the shared singleton ( `shared`).

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/body-swift.property

- AsyncHTTPClient
- HTTPClientRequest
- body

Instance Property

# body

The request body, if any.

var body: `HTTPClientRequest`. `Body`?

HTTPClientRequest.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/tlshandshaketimeout

- AsyncHTTPClient
- HTTPClientError
- tlsHandshakeTimeout

Type Property

# tlsHandshakeTimeout

The tls handshake timed out.

static let tlsHandshakeTimeout: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/shutdownunsupported

- AsyncHTTPClient
- HTTPClientError
- shutdownUnsupported

Type Property

# shutdownUnsupported

The globally shared singleton `HTTPClient` cannot be shut down.

static var shutdownUnsupported: `HTTPClientError` { get }

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/body-swift.struct

- AsyncHTTPClient
- HTTPClientRequest
- HTTPClientRequest.Body

Structure

# HTTPClientRequest.Body

An HTTP request body.

struct Body

HTTPClientRequest.swift

## Overview

This object encapsulates the difference between streamed HTTP request bodies and those bodies that are already entirely in memory.

## Topics

### Structures

`struct Length`

The length of a HTTP request body.

### Type Methods

Create an `HTTPClientRequest.Body` from a `RandomAccessCollection` of bytes.

Create an `HTTPClientRequest.Body` from a `ByteBuffer`.

Create an `HTTPClientRequest.Body` from a `Collection` of bytes.

Create an `HTTPClientRequest.Body` from a `Sequence` of bytes.

Create an `HTTPClientRequest.Body` from an `AsyncSequence` of `ByteBuffer` s.

Create an `HTTPClientRequest.Body` from an `AsyncSequence` of bytes.

## Relationships

### Conforms To

- `Swift.Copyable`
- `Swift.Sendable`
- `_Concurrency.AsyncSequence`

- HTTPClientRequest.Body
- Overview
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didsendrequest(task:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didSendRequest(task:)

Instance Method

# didSendRequest(task:)

Default implementation of `didSendRequest(task:)`.

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/method

- AsyncHTTPClient
- HTTPClientRequest
- method

Instance Property

# method

The request method.

var method: HTTPMethod

HTTPClientRequest.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:eventloop:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:eventLoop:deadline:)

Instance Method

# execute(request:eventLoop:deadline:)

Execute arbitrary HTTP request using specified URL.

func execute(
request: `HTTPClient`. `Request`,
eventLoop: `HTTPClient`. `EventLoopPreference`,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`eventLoop`

NIO Event Loop preference.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/didreceivebodypart(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- didReceiveBodyPart(task:\_:)

Instance Method

# didReceiveBodyPart(task:\_:)

Inherited from `HTTPClientResponseDelegate.didReceiveBodyPart(task:_:)`.

func didReceiveBodyPart(

_ buffer: ByteBuffer

Utils.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/post(url:body:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- post(url:body:deadline:)

Instance Method

# post(url:body:deadline:)

Execute `POST` request using specified URL.

func post(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(_:timeout:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(\_:timeout:logger:)

Instance Method

# execute(\_:timeout:logger:)

Execute arbitrary HTTP requests.

func execute(
_ request: `HTTPClientRequest`,
timeout: TimeAmount,
logger: Logger? = nil

HTTPClient+execute.swift

## Parameters

`request`

HTTP request to execute.

`timeout`

Time the the request has to complete.

`logger`

The logger to use for this request.

## Return Value

The response to the request. Note that the `body` of the response may not yet have been fully received.

## Discussion

- execute(\_:timeout:logger:)
- Parameters
- Return Value
- Discussion

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress/head

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Progress
- head

Instance Property

# head

var head: HTTPResponseHead { get set }

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didsendrequestpart(task:_:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didSendRequestPart(task:\_:)

Instance Method

# didSendRequestPart(task:\_:)

Default implementation of `didSendRequestPart(task:_:)`.

func didSendRequestPart(

_ part: IOData
)

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/init(url:)

#app-main)

- AsyncHTTPClient
- HTTPClientRequest
- init(url:)

Initializer

# init(url:)

init(url: String)

HTTPClientRequest.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/invalidheaderfieldnames(_:)

#app-main)

- AsyncHTTPClient
- HTTPClientError
- invalidHeaderFieldNames(\_:)

Type Method

# invalidHeaderFieldNames(\_:)

Header field names contain invalid characters.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/responsetoobigerror/description

- AsyncHTTPClient
- ResponseAccumulator
- ResponseAccumulator.ResponseTooBigError
- description

Instance Property

# description

Inherited from `CustomStringConvertible.description`.

var description: String { get }

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/didsendrequesthead(task:_:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- didSendRequestHead(task:\_:)

Instance Method

# didSendRequestHead(task:\_:)

Default implementation of `didSendRequest(task:)`.

func didSendRequestHead(

_ head: HTTPRequestHead
)

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/invalidheaderfieldvalues(_:)

#app-main)

- AsyncHTTPClient
- HTTPClientError
- invalidHeaderFieldValues(\_:)

Type Method

# invalidHeaderFieldValues(\_:)

Header field values contain invalid characters.

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/init(eventloopgroupprovider:configuration:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- init(eventLoopGroupProvider:configuration:)

Initializer

# init(eventLoopGroupProvider:configuration:)

Create an `HTTPClient` with specified `EventLoopGroup` provider and configuration.

convenience init(
eventLoopGroupProvider: `HTTPClient`. `EventLoopGroupProvider`,
configuration: `HTTPClient`. `Configuration` = Configuration()
)

HTTPClient.swift

## Parameters

`eventLoopGroupProvider`

Specify how `EventLoopGroup` will be created.

`configuration`

Client configuration.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/error-implementations

- AsyncHTTPClient
- HTTPClientError
- Error Implementations

API Collection

# Error Implementations

## Topics

### Instance Properties

`var localizedDescription: String`

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/redirectconfiguration-swift.property

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- redirectConfiguration

Instance Property

# redirectConfiguration

Enables following 3xx redirects automatically.

var redirectConfiguration: `HTTPClient`. `Configuration`. `RedirectConfiguration`

HTTPClient.swift

## Discussion

Following redirects are supported:

- `301: Moved Permanently`

- `302: Found`

- `303: See Other`

- `304: Not Modified`

- `305: Use Proxy`

- `307: Temporary Redirect`

- `308: Permanent Redirect`

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didsendrequest(task:)-3vqgm

-3vqgm#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didSendRequest(task:)

Instance Method

# didSendRequest(task:)

Default implementation of `didSendRequest(task:)`.

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress/receivedbytes

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Progress
- receivedBytes

Instance Property

# receivedBytes

var receivedBytes: Int

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/delete(url:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- delete(url:deadline:)

Instance Method

# delete(url:deadline:)

Execute `DELETE` request using specified URL.

func delete(
url: String,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`url`

Remote URL.

`deadline`

The time when the request must have been completed by.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/response

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- HTTPClientCopyingDelegate.Response

Type Alias

# HTTPClientCopyingDelegate.Response

Inherited from `HTTPClientResponseDelegate.Response`.

typealias Response = Void

Utils.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress/totalbytes

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Progress
- totalBytes

Instance Property

# totalBytes

var totalBytes: Int?

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientrequest/tlsconfiguration

- AsyncHTTPClient
- HTTPClientRequest
- tlsConfiguration

Instance Property

# tlsConfiguration

Request-specific TLS configuration, defaults to no request-specific TLS configuration.

var tlsConfiguration: TLSConfiguration?

HTTPClientRequest.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/tracerequestwithbody

- AsyncHTTPClient
- HTTPClientError
- traceRequestWithBody

Type Property

# traceRequestWithBody

A body was sent in a request with method TRACE.

static let traceRequestWithBody: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/redirectcycledetected

- AsyncHTTPClient
- HTTPClientError
- redirectCycleDetected

Type Property

# redirectCycleDetected

Redirect Cycle detected.

static let redirectCycleDetected: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/shutdown(queue:_:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- shutdown(queue:\_:)

Instance Method

# shutdown(queue:\_:)

Shuts down the client and event loop gracefully.

@preconcurrency
func shutdown(
queue: DispatchQueue = .global(),

)

HTTPClient.swift

## Discussion

This function is clearly an outlier in that it uses a completion callback instead of an EventLoopFuture. The reason for that is that NIO’s EventLoopFutures will call back on an event loop. The virtue of this function is to shut the event loop down. To work around that we call back on a DispatchQueue instead.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/serverofferedunsupportedapplicationprotocol(_:)

#app-main)

- AsyncHTTPClient
- HTTPClientError
- serverOfferedUnsupportedApplicationProtocol(\_:)

Type Method

# serverOfferedUnsupportedApplicationProtocol(\_:)

The remote server only offered an unsupported application protocol

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/syncshutdown()

#app-main)

- AsyncHTTPClient
- HTTPClient
- syncShutdown()

Instance Method

# syncShutdown()

Shuts down the client and `EventLoopGroup` if it was created by the client.

func syncShutdown() throws

HTTPClient.swift

## Discussion

This method blocks the thread indefinitely, prefer using `shutdown()`.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/equatable-implementations

- AsyncHTTPClient
- HTTPClientError
- Equatable Implementations

API Collection

# Equatable Implementations

## Topics

### Operators

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(_:socketpath:urlpath:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(\_:socketPath:urlPath:body:deadline:logger:)

Instance Method

# execute(\_:socketPath:urlPath:body:deadline:logger:)

Execute arbitrary HTTP+UNIX request to a unix domain socket path, using the specified URL as the request to send to the server.

func execute(
_ method: HTTPMethod = .GET,
socketPath: String,
urlPath: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger? = nil

HTTPClient.swift

## Parameters

`method`

Request method.

`socketPath`

The path to the unix domain socket to connect to.

`urlPath`

The URL path and query that will be sent to the server.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didsendrequesthead(task:_:)-q36n

-q36n#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didSendRequestHead(task:\_:)

Instance Method

# didSendRequestHead(task:\_:)

Default implementation of `didSendRequest(task:)`.

func didSendRequestHead(

_ head: HTTPRequestHead
)

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/put(url:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- put(url:body:deadline:logger:)

Instance Method

# put(url:body:deadline:logger:)

Execute `PUT` request using specified URL.

func put(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:delegate:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:delegate:deadline:logger:)

Instance Method

# execute(request:delegate:deadline:logger:)

Execute arbitrary HTTP request and handle response processing using provided delegate.

request: `HTTPClient`. `Request`,
delegate: Delegate,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`delegate`

Delegate to process response parts.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/eventloopgroupprovider

- AsyncHTTPClient
- HTTPClient
- HTTPClient.EventLoopGroupProvider

Enumeration

# HTTPClient.EventLoopGroupProvider

Specifies how `EventLoopGroup` will be created and establishes lifecycle ownership.

enum EventLoopGroupProvider

HTTPClient.swift

## Topics

### Enumeration Cases

`case createNew`

The original intention of this was that `HTTPClient` would create and own its own `EventLoopGroup` to facilitate use in programs that are not already using SwiftNIO. Since however, SwiftNIO does provide a global, shared singleton `EventLoopGroup` s that we can use. `HTTPClient` is no longer able to create & own its own `EventLoopGroup` which solves a whole host of issues around shutdown.

Deprecated

`case shared(any EventLoopGroup)`

`EventLoopGroup` will be provided by the user. Owner of this group is responsible for its lifecycle.

### Type Properties

`static var singleton: HTTPClient.EventLoopGroupProvider`

Shares `defaultEventLoopGroup` which is a singleton `EventLoopGroup` suitable for the platform.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.EventLoopGroupProvider
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(_:securesocketpath:urlpath:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(\_:secureSocketPath:urlPath:body:deadline:logger:)

Instance Method

# execute(\_:secureSocketPath:urlPath:body:deadline:logger:)

Execute arbitrary HTTPS+UNIX request to a unix domain socket path over TLS, using the specified URL as the request to send to the server.

func execute(
_ method: HTTPMethod = .GET,
secureSocketPath: String,
urlPath: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger? = nil

HTTPClient.swift

## Parameters

`method`

Request method.

`secureSocketPath`

The path to the unix domain socket to connect to.

`urlPath`

The URL path and query that will be sent to the server.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:deadline:)

Instance Method

# execute(request:deadline:)

Execute arbitrary HTTP request using specified URL.

func execute(
request: `HTTPClient`. `Request`,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/requestresponse

- AsyncHTTPClient
- HTTPClient
- HTTPClient.RequestResponse

Structure

# HTTPClient.RequestResponse

struct RequestResponse

HTTPHandler.swift

## Topics

### Initializers

`init(request: HTTPClient.Request, responseHead: HTTPResponseHead)`

### Instance Properties

`var request: HTTPClient.Request`

`var responseHead: HTTPResponseHead`

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.RequestResponse
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/proxy-swift.property

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- proxy

Instance Property

# proxy

Upstream proxy, defaults to no proxy.

var proxy: `HTTPClient`. `Configuration`. `Proxy`?

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/remoteconnectionclosed

- AsyncHTTPClient
- HTTPClientError
- remoteConnectionClosed

Type Property

# remoteConnectionClosed

Remote connection was closed unexpectedly.

static let remoteConnectionClosed: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:delegate:deadline:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:delegate:deadline:)

Instance Method

# execute(request:delegate:deadline:)

Execute arbitrary HTTP request and handle response processing using provided delegate.

request: `HTTPClient`. `Request`,
delegate: Delegate,
deadline: NIODeadline? = nil

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`delegate`

Delegate to process response parts.

`deadline`

Point in time by which the request must complete.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/cookie

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Cookie

Structure

# HTTPClient.Cookie

A representation of an HTTP cookie.

struct Cookie

HTTPClient+HTTPCookie.swift

## Topics

### Initializers

`init?(header: String, defaultDomain: String)`

Create a Cookie by parsing a `Set-Cookie` header.

`init(name: String, value: String, path: String, domain: String?, expires: Date?, maxAge: Int?, httpOnly: Bool, secure: Bool)`

Create HTTP cookie.

### Instance Properties

`var domain: String?`

The domain of the cookie.

`var expires: Date?`

The cookie’s expiration date.

`var httpOnly: Bool`

Whether the cookie should only be sent to HTTP servers.

`var maxAge: Int?`

The cookie’s age in seconds.

`var name: String`

The name of the cookie.

`var path: String`

The cookie’s path.

`var secure: Bool`

Whether the cookie should only be sent over secure channels.

`var value: String`

The cookie’s string value.

## Relationships

### Conforms To

- `Swift.Sendable`

- HTTPClient.Cookie
- Topics
- Relationships

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/init(eventloopgroupprovider:configuration:backgroundactivitylogger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- init(eventLoopGroupProvider:configuration:backgroundActivityLogger:)

Initializer

# init(eventLoopGroupProvider:configuration:backgroundActivityLogger:)

Create an `HTTPClient` with specified `EventLoopGroup` provider and configuration.

convenience init(
eventLoopGroupProvider: `HTTPClient`. `EventLoopGroupProvider`,
configuration: `HTTPClient`. `Configuration` = Configuration(),
backgroundActivityLogger: Logger
)

HTTPClient.swift

## Parameters

`eventLoopGroupProvider`

Specify how `EventLoopGroup` will be created.

`configuration`

Client configuration.

`backgroundActivityLogger`

The logger to use for background activity logs.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/get(url:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- get(url:deadline:logger:)

Instance Method

# get(url:deadline:logger:)

Execute `GET` request using specified URL.

func get(
url: String,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`url`

Remote URL.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/requeststreamcancelled

- AsyncHTTPClient
- HTTPClientError
- requestStreamCancelled

Type Property

# requestStreamCancelled

static let requestStreamCancelled: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientresponsedelegate/didreceivebodypart(task:_:)-1fvyq

-1fvyq#app-main)

- AsyncHTTPClient
- HTTPClientResponseDelegate
- didReceiveBodyPart(task:\_:)

Instance Method

# didReceiveBodyPart(task:\_:)

Default implementation of `didReceiveBodyPart(task:_:)`.

func didReceiveBodyPart(

_: ByteBuffer

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/responseaccumulator/responsetoobigerror/init(maxbodysize:)

#app-main)

- AsyncHTTPClient
- ResponseAccumulator
- ResponseAccumulator.ResponseTooBigError
- init(maxBodySize:)

Initializer

# init(maxBodySize:)

init(maxBodySize: Int)

HTTPHandler.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/eventloopgroup

- AsyncHTTPClient
- HTTPClient
- eventLoopGroup

Instance Property

# eventLoopGroup

The `EventLoopGroup` in use by this `HTTPClient`.

let eventLoopGroup: any EventLoopGroup

HTTPClient.swift

## Discussion

All HTTP transactions will occur on loops owned by this group.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/defaulteventloopgroup

- AsyncHTTPClient
- HTTPClient
- defaultEventLoopGroup

Type Property

# defaultEventLoopGroup

Returns the default `EventLoopGroup` singleton, automatically selecting the best for the platform.

static var defaultEventLoopGroup: any EventLoopGroup { get }

HTTPClient.swift

## Discussion

This will select the concrete `EventLoopGroup` depending which platform this is running on.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/init(eventloopgroup:configuration:backgroundactivitylogger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- init(eventLoopGroup:configuration:backgroundActivityLogger:)

Initializer

# init(eventLoopGroup:configuration:backgroundActivityLogger:)

Create an `HTTPClient` with specified `EventLoopGroup` and configuration.

convenience init(
eventLoopGroup: any EventLoopGroup = HTTPClient.defaultEventLoopGroup,
configuration: `HTTPClient`. `Configuration` = Configuration(),
backgroundActivityLogger: Logger
)

HTTPClient.swift

## Parameters

`eventLoopGroup`

The `EventLoopGroup` that the `HTTPClient` will use.

`configuration`

Client configuration.

`backgroundActivityLogger`

The `Logger` that will be used to log background any activity that’s not associated with a request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/filedownloaddelegate/progress/history

- AsyncHTTPClient
- FileDownloadDelegate
- FileDownloadDelegate.Progress
- history

Instance Property

# history

The history of all requests and responses in redirect order.

var history: [`HTTPClient`. `RequestResponse`]

FileDownloadDelegate.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/delete(url:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- delete(url:deadline:logger:)

Instance Method

# delete(url:deadline:logger:)

Execute `DELETE` request using specified URL.

func delete(
url: String,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`url`

Remote URL.

`deadline`

The time when the request must have been completed by.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/init(chunkhandler:)

#app-main)

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- init(chunkHandler:)

Initializer

# init(chunkHandler:)

@preconcurrency

Utils.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/timeout-swift.struct/connect

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- HTTPClient.Configuration.Timeout
- connect

Instance Property

# connect

Specifies connect timeout. If no connect timeout is given, a default 10 seconds timeout will be applied.

var connect: TimeAmount?

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/post(url:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- post(url:body:deadline:logger:)

Instance Method

# post(url:body:deadline:logger:)

Execute `POST` request using specified URL.

func post(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/patch(url:body:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- patch(url:body:deadline:logger:)

Instance Method

# patch(url:body:deadline:logger:)

Execute `PATCH` request using specified URL.

func patch(
url: String,
body: `HTTPClient`. `Body`? = nil,
deadline: NIODeadline? = nil,
logger: Logger

HTTPClient.swift

## Parameters

`url`

Remote URL.

`body`

Request body.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/singletonconfiguration

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- singletonConfiguration

Type Property

# singletonConfiguration

The `HTTPClient.Configuration` for `shared` which tries to mimic the platform’s default or prevalent browser as closely as possible.

static var singletonConfiguration: `HTTPClient`. `Configuration` { get }

Configuration+BrowserLike.swift

## Discussion

Don’t rely on specific values of this configuration as they’re subject to change. You can rely on them being somewhat sensible though.

Platform’s default/prevalent browsers that we’re trying to match (these might change over time):

- macOS: Safari

- iOS: Safari

- Android: Google Chrome

- Linux (non-Android): Google Chrome

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:delegate:eventloop:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:delegate:eventLoop:deadline:logger:)

Instance Method

# execute(request:delegate:eventLoop:deadline:logger:)

Execute arbitrary HTTP request and handle response processing using provided delegate.

request: `HTTPClient`. `Request`,
delegate: Delegate,
eventLoop eventLoopPreference: `HTTPClient`. `EventLoopPreference`,
deadline: NIODeadline? = nil,
logger: Logger?

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`delegate`

Delegate to process response parts.

`eventLoopPreference`

NIO Event Loop preference.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/execute(request:eventloop:deadline:logger:)

#app-main)

- AsyncHTTPClient
- HTTPClient
- execute(request:eventLoop:deadline:logger:)

Instance Method

# execute(request:eventLoop:deadline:logger:)

Execute arbitrary HTTP request and handle response processing using provided delegate.

func execute(
request: `HTTPClient`. `Request`,
eventLoop eventLoopPreference: `HTTPClient`. `EventLoopPreference`,
deadline: NIODeadline? = nil,
logger: Logger?

HTTPClient.swift

## Parameters

`request`

HTTP request to execute.

`eventLoopPreference`

NIO Event Loop preference.

`deadline`

Point in time by which the request must complete.

`logger`

The logger to use for this request.

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclient/configuration/timeout-swift.property

- AsyncHTTPClient
- HTTPClient
- HTTPClient.Configuration
- timeout

Instance Property

# timeout

Default client timeout, defaults to no `read` timeout and 10 seconds `connect` timeout.

var timeout: `HTTPClient`. `Configuration`. `Timeout`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclienterror/proxyauthenticationrequired

- AsyncHTTPClient
- HTTPClientError
- proxyAuthenticationRequired

Type Property

# proxyAuthenticationRequired

Proxy Authentication Required.

static let proxyAuthenticationRequired: `HTTPClientError`

HTTPClient.swift

|
|

---

# https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient/httpclientcopyingdelegate/didreceiveerror(task:_:)

#app-main)

- AsyncHTTPClient
- HTTPClientCopyingDelegate
- didReceiveError(task:\_:)

Instance Method

# didReceiveError(task:\_:)

Default implementation of `didReceiveError(task:_:)`.

func didReceiveError(

_: any Error
)

HTTPHandler.swift

## Discussion

By default, this does nothing.

|
|

---

