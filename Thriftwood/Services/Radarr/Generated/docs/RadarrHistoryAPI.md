# RadarrHistoryAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3HistoryFailedIdPost**](RadarrHistoryAPI.md#apiv3historyfailedidpost) | **POST** /api/v3/history/failed/{id} | 
[**apiV3HistoryGet**](RadarrHistoryAPI.md#apiv3historyget) | **GET** /api/v3/history | 
[**apiV3HistoryMovieGet**](RadarrHistoryAPI.md#apiv3historymovieget) | **GET** /api/v3/history/movie | 
[**apiV3HistorySinceGet**](RadarrHistoryAPI.md#apiv3historysinceget) | **GET** /api/v3/history/since | 


# **apiV3HistoryFailedIdPost**
```swift
    open class func apiV3HistoryFailedIdPost(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrHistoryAPI.apiV3HistoryFailedIdPost(id: id) { (response, error) in
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

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3HistoryGet**
```swift
    open class func apiV3HistoryGet(page: Int? = nil, pageSize: Int? = nil, sortKey: String? = nil, sortDirection: SortDirection? = nil, includeMovie: Bool? = nil, eventType: [Int]? = nil, downloadId: String? = nil, movieIds: [Int]? = nil, languages: [Int]? = nil, quality: [Int]? = nil, completion: @escaping (_ data: HistoryResourcePagingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let page = 987 // Int |  (optional) (default to 1)
let pageSize = 987 // Int |  (optional) (default to 10)
let sortKey = "sortKey_example" // String |  (optional)
let sortDirection = SortDirection() // SortDirection |  (optional)
let includeMovie = true // Bool |  (optional)
let eventType = [123] // [Int] |  (optional)
let downloadId = "downloadId_example" // String |  (optional)
let movieIds = [123] // [Int] |  (optional)
let languages = [123] // [Int] |  (optional)
let quality = [123] // [Int] |  (optional)

RadarrHistoryAPI.apiV3HistoryGet(page: page, pageSize: pageSize, sortKey: sortKey, sortDirection: sortDirection, includeMovie: includeMovie, eventType: eventType, downloadId: downloadId, movieIds: movieIds, languages: languages, quality: quality) { (response, error) in
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
 **includeMovie** | **Bool** |  | [optional] 
 **eventType** | [**[Int]**](Int.md) |  | [optional] 
 **downloadId** | **String** |  | [optional] 
 **movieIds** | [**[Int]**](Int.md) |  | [optional] 
 **languages** | [**[Int]**](Int.md) |  | [optional] 
 **quality** | [**[Int]**](Int.md) |  | [optional] 

### Return type

[**HistoryResourcePagingResource**](HistoryResourcePagingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3HistoryMovieGet**
```swift
    open class func apiV3HistoryMovieGet(movieId: Int? = nil, eventType: MovieHistoryEventType? = nil, includeMovie: Bool? = nil, completion: @escaping (_ data: [HistoryResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)
let eventType = MovieHistoryEventType() // MovieHistoryEventType |  (optional)
let includeMovie = true // Bool |  (optional) (default to false)

RadarrHistoryAPI.apiV3HistoryMovieGet(movieId: movieId, eventType: eventType, includeMovie: includeMovie) { (response, error) in
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
 **movieId** | **Int** |  | [optional] 
 **eventType** | [**MovieHistoryEventType**](.md) |  | [optional] 
 **includeMovie** | **Bool** |  | [optional] [default to false]

### Return type

[**[HistoryResource]**](HistoryResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3HistorySinceGet**
```swift
    open class func apiV3HistorySinceGet(date: Date? = nil, eventType: MovieHistoryEventType? = nil, includeMovie: Bool? = nil, completion: @escaping (_ data: [HistoryResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let date = Date() // Date |  (optional)
let eventType = MovieHistoryEventType() // MovieHistoryEventType |  (optional)
let includeMovie = true // Bool |  (optional) (default to false)

RadarrHistoryAPI.apiV3HistorySinceGet(date: date, eventType: eventType, includeMovie: includeMovie) { (response, error) in
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
 **date** | **Date** |  | [optional] 
 **eventType** | [**MovieHistoryEventType**](.md) |  | [optional] 
 **includeMovie** | **Bool** |  | [optional] [default to false]

### Return type

[**[HistoryResource]**](HistoryResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

