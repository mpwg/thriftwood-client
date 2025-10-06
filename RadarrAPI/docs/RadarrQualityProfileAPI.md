# RadarrQualityProfileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QualityprofileGet**](RadarrQualityProfileAPI.md#apiv3qualityprofileget) | **GET** /api/v3/qualityprofile | 
[**apiV3QualityprofileIdDelete**](RadarrQualityProfileAPI.md#apiv3qualityprofileiddelete) | **DELETE** /api/v3/qualityprofile/{id} | 
[**apiV3QualityprofileIdGet**](RadarrQualityProfileAPI.md#apiv3qualityprofileidget) | **GET** /api/v3/qualityprofile/{id} | 
[**apiV3QualityprofileIdPut**](RadarrQualityProfileAPI.md#apiv3qualityprofileidput) | **PUT** /api/v3/qualityprofile/{id} | 
[**apiV3QualityprofilePost**](RadarrQualityProfileAPI.md#apiv3qualityprofilepost) | **POST** /api/v3/qualityprofile | 


# **apiV3QualityprofileGet**
```swift
    open class func apiV3QualityprofileGet(completion: @escaping (_ data: [QualityProfileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrQualityProfileAPI.apiV3QualityprofileGet() { (response, error) in
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

[**[QualityProfileResource]**](QualityProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualityprofileIdDelete**
```swift
    open class func apiV3QualityprofileIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrQualityProfileAPI.apiV3QualityprofileIdDelete(id: id) { (response, error) in
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

# **apiV3QualityprofileIdGet**
```swift
    open class func apiV3QualityprofileIdGet(id: Int, completion: @escaping (_ data: QualityProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrQualityProfileAPI.apiV3QualityprofileIdGet(id: id) { (response, error) in
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

[**QualityProfileResource**](QualityProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualityprofileIdPut**
```swift
    open class func apiV3QualityprofileIdPut(id: String, qualityProfileResource: QualityProfileResource? = nil, completion: @escaping (_ data: QualityProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let qualityProfileResource = QualityProfileResource(id: 123, name: "name_example", upgradeAllowed: false, cutoff: 123, items: [QualityProfileQualityItemResource(id: 123, name: "name_example", quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), items: [nil], allowed: false)], minFormatScore: 123, cutoffFormatScore: 123, minUpgradeFormatScore: 123, formatItems: [ProfileFormatItemResource(id: 123, format: 123, name: "name_example", score: 123)], language: Language(id: 123, name: "name_example")) // QualityProfileResource |  (optional)

RadarrQualityProfileAPI.apiV3QualityprofileIdPut(id: id, qualityProfileResource: qualityProfileResource) { (response, error) in
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
 **qualityProfileResource** | [**QualityProfileResource**](QualityProfileResource.md) |  | [optional] 

### Return type

[**QualityProfileResource**](QualityProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QualityprofilePost**
```swift
    open class func apiV3QualityprofilePost(qualityProfileResource: QualityProfileResource? = nil, completion: @escaping (_ data: QualityProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let qualityProfileResource = QualityProfileResource(id: 123, name: "name_example", upgradeAllowed: false, cutoff: 123, items: [QualityProfileQualityItemResource(id: 123, name: "name_example", quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), items: [nil], allowed: false)], minFormatScore: 123, cutoffFormatScore: 123, minUpgradeFormatScore: 123, formatItems: [ProfileFormatItemResource(id: 123, format: 123, name: "name_example", score: 123)], language: Language(id: 123, name: "name_example")) // QualityProfileResource |  (optional)

RadarrQualityProfileAPI.apiV3QualityprofilePost(qualityProfileResource: qualityProfileResource) { (response, error) in
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
 **qualityProfileResource** | [**QualityProfileResource**](QualityProfileResource.md) |  | [optional] 

### Return type

[**QualityProfileResource**](QualityProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

