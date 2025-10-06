# RadarrQueueAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QueueBulkDelete**](RadarrQueueAPI.md#apiv3queuebulkdelete) | **DELETE** /api/v3/queue/bulk | 
[**apiV3QueueGet**](RadarrQueueAPI.md#apiv3queueget) | **GET** /api/v3/queue | 
[**apiV3QueueIdDelete**](RadarrQueueAPI.md#apiv3queueiddelete) | **DELETE** /api/v3/queue/{id} | 


# **apiV3QueueBulkDelete**
```swift
    open class func apiV3QueueBulkDelete(removeFromClient: Bool? = nil, blocklist: Bool? = nil, skipRedownload: Bool? = nil, changeCategory: Bool? = nil, queueBulkResource: QueueBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let removeFromClient = true // Bool |  (optional) (default to true)
let blocklist = true // Bool |  (optional) (default to false)
let skipRedownload = true // Bool |  (optional) (default to false)
let changeCategory = true // Bool |  (optional) (default to false)
let queueBulkResource = QueueBulkResource(ids: [123]) // QueueBulkResource |  (optional)

RadarrQueueAPI.apiV3QueueBulkDelete(removeFromClient: removeFromClient, blocklist: blocklist, skipRedownload: skipRedownload, changeCategory: changeCategory, queueBulkResource: queueBulkResource) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **removeFromClient** | **Bool** |  | [optional] [default to true]
 **blocklist** | **Bool** |  | [optional] [default to false]
 **skipRedownload** | **Bool** |  | [optional] [default to false]
 **changeCategory** | **Bool** |  | [optional] [default to false]
 **queueBulkResource** | [**QueueBulkResource**](QueueBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QueueGet**
```swift
    open class func apiV3QueueGet(page: Int? = nil, pageSize: Int? = nil, sortKey: String? = nil, sortDirection: SortDirection? = nil, includeUnknownMovieItems: Bool? = nil, includeMovie: Bool? = nil, movieIds: [Int]? = nil, _protocol: DownloadProtocol? = nil, languages: [Int]? = nil, quality: [Int]? = nil, status: [QueueStatus]? = nil, completion: @escaping (_ data: QueueResourcePagingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let page = 987 // Int |  (optional) (default to 1)
let pageSize = 987 // Int |  (optional) (default to 10)
let sortKey = "sortKey_example" // String |  (optional)
let sortDirection = SortDirection() // SortDirection |  (optional)
let includeUnknownMovieItems = true // Bool |  (optional) (default to false)
let includeMovie = true // Bool |  (optional) (default to false)
let movieIds = [123] // [Int] |  (optional)
let _protocol = DownloadProtocol() // DownloadProtocol |  (optional)
let languages = [123] // [Int] |  (optional)
let quality = [123] // [Int] |  (optional)
let status = [QueueStatus()] // [QueueStatus] |  (optional)

RadarrQueueAPI.apiV3QueueGet(page: page, pageSize: pageSize, sortKey: sortKey, sortDirection: sortDirection, includeUnknownMovieItems: includeUnknownMovieItems, includeMovie: includeMovie, movieIds: movieIds, _protocol: _protocol, languages: languages, quality: quality, status: status) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Int** |  | [optional] [default to 1]
 **pageSize** | **Int** |  | [optional] [default to 10]
 **sortKey** | **String** |  | [optional] 
 **sortDirection** | [**SortDirection**](.md) |  | [optional] 
 **includeUnknownMovieItems** | **Bool** |  | [optional] [default to false]
 **includeMovie** | **Bool** |  | [optional] [default to false]
 **movieIds** | [**[Int]**](Int.md) |  | [optional] 
 **_protocol** | [**DownloadProtocol**](.md) |  | [optional] 
 **languages** | [**[Int]**](Int.md) |  | [optional] 
 **quality** | [**[Int]**](Int.md) |  | [optional] 
 **status** | [**[QueueStatus]**](QueueStatus.md) |  | [optional] 

### Return type

[**QueueResourcePagingResource**](QueueResourcePagingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QueueIdDelete**
```swift
    open class func apiV3QueueIdDelete(id: Int, removeFromClient: Bool? = nil, blocklist: Bool? = nil, skipRedownload: Bool? = nil, changeCategory: Bool? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let removeFromClient = true // Bool |  (optional) (default to true)
let blocklist = true // Bool |  (optional) (default to false)
let skipRedownload = true // Bool |  (optional) (default to false)
let changeCategory = true // Bool |  (optional) (default to false)

RadarrQueueAPI.apiV3QueueIdDelete(id: id, removeFromClient: removeFromClient, blocklist: blocklist, skipRedownload: skipRedownload, changeCategory: changeCategory) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **Int** |  | 
 **removeFromClient** | **Bool** |  | [optional] [default to true]
 **blocklist** | **Bool** |  | [optional] [default to false]
 **skipRedownload** | **Bool** |  | [optional] [default to false]
 **changeCategory** | **Bool** |  | [optional] [default to false]

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

