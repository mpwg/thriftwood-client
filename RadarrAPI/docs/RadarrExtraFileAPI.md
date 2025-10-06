# RadarrExtraFileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ExtrafileGet**](RadarrExtraFileAPI.md#apiv3extrafileget) | **GET** /api/v3/extrafile | 


# **apiV3ExtrafileGet**
```swift
    open class func apiV3ExtrafileGet(movieId: Int? = nil, completion: @escaping (_ data: [ExtraFileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)

RadarrExtraFileAPI.apiV3ExtrafileGet(movieId: movieId) { (response, error) in
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

[**[ExtraFileResource]**](ExtraFileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

