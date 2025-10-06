# RadarrQueueDetailsAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QueueDetailsGet**](RadarrQueueDetailsAPI.md#apiv3queuedetailsget) | **GET** /api/v3/queue/details | 


# **apiV3QueueDetailsGet**
```swift
    open class func apiV3QueueDetailsGet(movieId: Int? = nil, includeMovie: Bool? = nil, completion: @escaping (_ data: [QueueResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)
let includeMovie = true // Bool |  (optional) (default to false)

RadarrQueueDetailsAPI.apiV3QueueDetailsGet(movieId: movieId, includeMovie: includeMovie) { (response, error) in
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
 **includeMovie** | **Bool** |  | [optional] [default to false]

### Return type

[**[QueueResource]**](QueueResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

