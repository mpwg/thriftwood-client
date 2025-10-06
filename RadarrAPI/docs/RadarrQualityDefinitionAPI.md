# RadarrQualityDefinitionAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QualitydefinitionGet**](RadarrQualityDefinitionAPI.md#apiv3qualitydefinitionget) | **GET** /api/v3/qualitydefinition | 
[**apiV3QualitydefinitionIdGet**](RadarrQualityDefinitionAPI.md#apiv3qualitydefinitionidget) | **GET** /api/v3/qualitydefinition/{id} | 
[**apiV3QualitydefinitionIdPut**](RadarrQualityDefinitionAPI.md#apiv3qualitydefinitionidput) | **PUT** /api/v3/qualitydefinition/{id} | 
[**apiV3QualitydefinitionLimitsGet**](RadarrQualityDefinitionAPI.md#apiv3qualitydefinitionlimitsget) | **GET** /api/v3/qualitydefinition/limits | 
[**apiV3QualitydefinitionUpdatePut**](RadarrQualityDefinitionAPI.md#apiv3qualitydefinitionupdateput) | **PUT** /api/v3/qualitydefinition/update | 


# **apiV3QualitydefinitionGet**
```swift
    open class func apiV3QualitydefinitionGet(completion: @escaping (_ data: [QualityDefinitionResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrQualityDefinitionAPI.apiV3QualitydefinitionGet() { (response, error) in
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

[**[QualityDefinitionResource]**](QualityDefinitionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualitydefinitionIdGet**
```swift
    open class func apiV3QualitydefinitionIdGet(id: Int, completion: @escaping (_ data: QualityDefinitionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrQualityDefinitionAPI.apiV3QualitydefinitionIdGet(id: id) { (response, error) in
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

[**QualityDefinitionResource**](QualityDefinitionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualitydefinitionIdPut**
```swift
    open class func apiV3QualitydefinitionIdPut(id: String, qualityDefinitionResource: QualityDefinitionResource? = nil, completion: @escaping (_ data: QualityDefinitionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let qualityDefinitionResource = QualityDefinitionResource(id: 123, quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), title: "title_example", weight: 123, minSize: 123, maxSize: 123, preferredSize: 123) // QualityDefinitionResource |  (optional)

RadarrQualityDefinitionAPI.apiV3QualitydefinitionIdPut(id: id, qualityDefinitionResource: qualityDefinitionResource) { (response, error) in
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
 **qualityDefinitionResource** | [**QualityDefinitionResource**](QualityDefinitionResource.md) |  | [optional] 

### Return type

[**QualityDefinitionResource**](QualityDefinitionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualitydefinitionLimitsGet**
```swift
    open class func apiV3QualitydefinitionLimitsGet(completion: @escaping (_ data: QualityDefinitionLimitsResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrQualityDefinitionAPI.apiV3QualitydefinitionLimitsGet() { (response, error) in
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

[**QualityDefinitionLimitsResource**](QualityDefinitionLimitsResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualitydefinitionUpdatePut**
```swift
    open class func apiV3QualitydefinitionUpdatePut(qualityDefinitionResource: [QualityDefinitionResource]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let qualityDefinitionResource = [QualityDefinitionResource(id: 123, quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), title: "title_example", weight: 123, minSize: 123, maxSize: 123, preferredSize: 123)] // [QualityDefinitionResource] |  (optional)

RadarrQualityDefinitionAPI.apiV3QualitydefinitionUpdatePut(qualityDefinitionResource: qualityDefinitionResource) { (response, error) in
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
 **qualityDefinitionResource** | [**[QualityDefinitionResource]**](QualityDefinitionResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

