# RadarrLogAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3LogGet**](RadarrLogAPI.md#apiv3logget) | **GET** /api/v3/log | 


# **apiV3LogGet**
```swift
    open class func apiV3LogGet(page: Int? = nil, pageSize: Int? = nil, sortKey: String? = nil, sortDirection: SortDirection? = nil, level: String? = nil, completion: @escaping (_ data: LogResourcePagingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let page = 987 // Int |  (optional) (default to 1)
let pageSize = 987 // Int |  (optional) (default to 10)
let sortKey = "sortKey_example" // String |  (optional)
let sortDirection = SortDirection() // SortDirection |  (optional)
let level = "level_example" // String |  (optional)

RadarrLogAPI.apiV3LogGet(page: page, pageSize: pageSize, sortKey: sortKey, sortDirection: sortDirection, level: level) { (response, error) in
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
 **level** | **String** |  | [optional] 

### Return type

[**LogResourcePagingResource**](LogResourcePagingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

