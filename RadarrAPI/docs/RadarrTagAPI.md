# RadarrTagAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3TagGet**](RadarrTagAPI.md#apiv3tagget) | **GET** /api/v3/tag | 
[**apiV3TagIdDelete**](RadarrTagAPI.md#apiv3tagiddelete) | **DELETE** /api/v3/tag/{id} | 
[**apiV3TagIdGet**](RadarrTagAPI.md#apiv3tagidget) | **GET** /api/v3/tag/{id} | 
[**apiV3TagIdPut**](RadarrTagAPI.md#apiv3tagidput) | **PUT** /api/v3/tag/{id} | 
[**apiV3TagPost**](RadarrTagAPI.md#apiv3tagpost) | **POST** /api/v3/tag | 


# **apiV3TagGet**
```swift
    open class func apiV3TagGet(completion: @escaping (_ data: [TagResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrTagAPI.apiV3TagGet() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**[TagResource]**](TagResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3TagIdDelete**
```swift
    open class func apiV3TagIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrTagAPI.apiV3TagIdDelete(id: id) { (response, error) in
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

# **apiV3TagIdGet**
```swift
    open class func apiV3TagIdGet(id: Int, completion: @escaping (_ data: TagResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrTagAPI.apiV3TagIdGet(id: id) { (response, error) in
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

[**TagResource**](TagResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3TagIdPut**
```swift
    open class func apiV3TagIdPut(id: String, tagResource: TagResource? = nil, completion: @escaping (_ data: TagResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let tagResource = TagResource(id: 123, label: "label_example") // TagResource |  (optional)

RadarrTagAPI.apiV3TagIdPut(id: id, tagResource: tagResource) { (response, error) in
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
 **id** | **String** |  | 
 **tagResource** | [**TagResource**](TagResource.md) |  | [optional] 

### Return type

[**TagResource**](TagResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3TagPost**
```swift
    open class func apiV3TagPost(tagResource: TagResource? = nil, completion: @escaping (_ data: TagResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let tagResource = TagResource(id: 123, label: "label_example") // TagResource |  (optional)

RadarrTagAPI.apiV3TagPost(tagResource: tagResource) { (response, error) in
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
 **tagResource** | [**TagResource**](TagResource.md) |  | [optional] 

### Return type

[**TagResource**](TagResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

