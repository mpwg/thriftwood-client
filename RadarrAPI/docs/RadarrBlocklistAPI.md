# RadarrBlocklistAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3BlocklistBulkDelete**](RadarrBlocklistAPI.md#apiv3blocklistbulkdelete) | **DELETE** /api/v3/blocklist/bulk | 
[**apiV3BlocklistGet**](RadarrBlocklistAPI.md#apiv3blocklistget) | **GET** /api/v3/blocklist | 
[**apiV3BlocklistIdDelete**](RadarrBlocklistAPI.md#apiv3blocklistiddelete) | **DELETE** /api/v3/blocklist/{id} | 
[**apiV3BlocklistMovieGet**](RadarrBlocklistAPI.md#apiv3blocklistmovieget) | **GET** /api/v3/blocklist/movie | 


# **apiV3BlocklistBulkDelete**
```swift
    open class func apiV3BlocklistBulkDelete(blocklistBulkResource: BlocklistBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let blocklistBulkResource = BlocklistBulkResource(ids: [123]) // BlocklistBulkResource |  (optional)

RadarrBlocklistAPI.apiV3BlocklistBulkDelete(blocklistBulkResource: blocklistBulkResource) { (response, error) in
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
 **blocklistBulkResource** | [**BlocklistBulkResource**](BlocklistBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3BlocklistGet**
```swift
    open class func apiV3BlocklistGet(page: Int? = nil, pageSize: Int? = nil, sortKey: String? = nil, sortDirection: SortDirection? = nil, movieIds: [Int]? = nil, protocols: [DownloadProtocol]? = nil, completion: @escaping (_ data: BlocklistResourcePagingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let page = 987 // Int |  (optional) (default to 1)
let pageSize = 987 // Int |  (optional) (default to 10)
let sortKey = "sortKey_example" // String |  (optional)
let sortDirection = SortDirection() // SortDirection |  (optional)
let movieIds = [123] // [Int] |  (optional)
let protocols = [DownloadProtocol()] // [DownloadProtocol] |  (optional)

RadarrBlocklistAPI.apiV3BlocklistGet(page: page, pageSize: pageSize, sortKey: sortKey, sortDirection: sortDirection, movieIds: movieIds, protocols: protocols) { (response, error) in
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
 **movieIds** | [**[Int]**](Int.md) |  | [optional] 
 **protocols** | [**[DownloadProtocol]**](DownloadProtocol.md) |  | [optional] 

### Return type

[**BlocklistResourcePagingResource**](BlocklistResourcePagingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3BlocklistIdDelete**
```swift
    open class func apiV3BlocklistIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrBlocklistAPI.apiV3BlocklistIdDelete(id: id) { (response, error) in
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

# **apiV3BlocklistMovieGet**
```swift
    open class func apiV3BlocklistMovieGet(movieId: Int? = nil, completion: @escaping (_ data: [BlocklistResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)

RadarrBlocklistAPI.apiV3BlocklistMovieGet(movieId: movieId) { (response, error) in
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

### Return type

[**[BlocklistResource]**](BlocklistResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

