# RadarrCustomFilterAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CustomfilterGet**](RadarrCustomFilterAPI.md#apiv3customfilterget) | **GET** /api/v3/customfilter | 
[**apiV3CustomfilterIdDelete**](RadarrCustomFilterAPI.md#apiv3customfilteriddelete) | **DELETE** /api/v3/customfilter/{id} | 
[**apiV3CustomfilterIdGet**](RadarrCustomFilterAPI.md#apiv3customfilteridget) | **GET** /api/v3/customfilter/{id} | 
[**apiV3CustomfilterIdPut**](RadarrCustomFilterAPI.md#apiv3customfilteridput) | **PUT** /api/v3/customfilter/{id} | 
[**apiV3CustomfilterPost**](RadarrCustomFilterAPI.md#apiv3customfilterpost) | **POST** /api/v3/customfilter | 


# **apiV3CustomfilterGet**
```swift
    open class func apiV3CustomfilterGet(completion: @escaping (_ data: [CustomFilterResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrCustomFilterAPI.apiV3CustomfilterGet() { (response, error) in
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

[**[CustomFilterResource]**](CustomFilterResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomfilterIdDelete**
```swift
    open class func apiV3CustomfilterIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCustomFilterAPI.apiV3CustomfilterIdDelete(id: id) { (response, error) in
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

# **apiV3CustomfilterIdGet**
```swift
    open class func apiV3CustomfilterIdGet(id: Int, completion: @escaping (_ data: CustomFilterResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCustomFilterAPI.apiV3CustomfilterIdGet(id: id) { (response, error) in
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

[**CustomFilterResource**](CustomFilterResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomfilterIdPut**
```swift
    open class func apiV3CustomfilterIdPut(id: String, customFilterResource: CustomFilterResource? = nil, completion: @escaping (_ data: CustomFilterResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let customFilterResource = CustomFilterResource(id: 123, type: "type_example", label: "label_example", filters: [123]) // CustomFilterResource |  (optional)

RadarrCustomFilterAPI.apiV3CustomfilterIdPut(id: id, customFilterResource: customFilterResource) { (response, error) in
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
 **customFilterResource** | [**CustomFilterResource**](CustomFilterResource.md) |  | [optional] 

### Return type

[**CustomFilterResource**](CustomFilterResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomfilterPost**
```swift
    open class func apiV3CustomfilterPost(customFilterResource: CustomFilterResource? = nil, completion: @escaping (_ data: CustomFilterResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let customFilterResource = CustomFilterResource(id: 123, type: "type_example", label: "label_example", filters: [123]) // CustomFilterResource |  (optional)

RadarrCustomFilterAPI.apiV3CustomfilterPost(customFilterResource: customFilterResource) { (response, error) in
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
 **customFilterResource** | [**CustomFilterResource**](CustomFilterResource.md) |  | [optional] 

### Return type

[**CustomFilterResource**](CustomFilterResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

