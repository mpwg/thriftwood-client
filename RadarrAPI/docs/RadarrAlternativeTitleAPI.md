# RadarrAlternativeTitleAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3AlttitleGet**](RadarrAlternativeTitleAPI.md#apiv3alttitleget) | **GET** /api/v3/alttitle | 
[**apiV3AlttitleIdGet**](RadarrAlternativeTitleAPI.md#apiv3alttitleidget) | **GET** /api/v3/alttitle/{id} | 


# **apiV3AlttitleGet**
```swift
    open class func apiV3AlttitleGet(movieId: Int? = nil, movieMetadataId: Int? = nil, completion: @escaping (_ data: [AlternativeTitleResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)
let movieMetadataId = 987 // Int |  (optional)

RadarrAlternativeTitleAPI.apiV3AlttitleGet(movieId: movieId, movieMetadataId: movieMetadataId) { (response, error) in
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
 **movieMetadataId** | **Int** |  | [optional] 

### Return type

[**[AlternativeTitleResource]**](AlternativeTitleResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3AlttitleIdGet**
```swift
    open class func apiV3AlttitleIdGet(id: Int, completion: @escaping (_ data: AlternativeTitleResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrAlternativeTitleAPI.apiV3AlttitleIdGet(id: id) { (response, error) in
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

[**AlternativeTitleResource**](AlternativeTitleResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

