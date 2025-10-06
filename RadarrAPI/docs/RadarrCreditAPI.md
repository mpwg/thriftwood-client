# RadarrCreditAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CreditGet**](RadarrCreditAPI.md#apiv3creditget) | **GET** /api/v3/credit | 
[**apiV3CreditIdGet**](RadarrCreditAPI.md#apiv3creditidget) | **GET** /api/v3/credit/{id} | 


# **apiV3CreditGet**
```swift
    open class func apiV3CreditGet(movieId: Int? = nil, movieMetadataId: Int? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)
let movieMetadataId = 987 // Int |  (optional)

RadarrCreditAPI.apiV3CreditGet(movieId: movieId, movieMetadataId: movieMetadataId) { (response, error) in
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

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CreditIdGet**
```swift
    open class func apiV3CreditIdGet(id: Int, completion: @escaping (_ data: CreditResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCreditAPI.apiV3CreditIdGet(id: id) { (response, error) in
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

[**CreditResource**](CreditResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

