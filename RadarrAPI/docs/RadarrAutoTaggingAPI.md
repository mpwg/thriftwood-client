# RadarrAutoTaggingAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3AutotaggingGet**](RadarrAutoTaggingAPI.md#apiv3autotaggingget) | **GET** /api/v3/autotagging | 
[**apiV3AutotaggingIdDelete**](RadarrAutoTaggingAPI.md#apiv3autotaggingiddelete) | **DELETE** /api/v3/autotagging/{id} | 
[**apiV3AutotaggingIdGet**](RadarrAutoTaggingAPI.md#apiv3autotaggingidget) | **GET** /api/v3/autotagging/{id} | 
[**apiV3AutotaggingIdPut**](RadarrAutoTaggingAPI.md#apiv3autotaggingidput) | **PUT** /api/v3/autotagging/{id} | 
[**apiV3AutotaggingPost**](RadarrAutoTaggingAPI.md#apiv3autotaggingpost) | **POST** /api/v3/autotagging | 
[**apiV3AutotaggingSchemaGet**](RadarrAutoTaggingAPI.md#apiv3autotaggingschemaget) | **GET** /api/v3/autotagging/schema | 


# **apiV3AutotaggingGet**
```swift
    open class func apiV3AutotaggingGet(completion: @escaping (_ data: [AutoTaggingResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrAutoTaggingAPI.apiV3AutotaggingGet() { (response, error) in
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

[**[AutoTaggingResource]**](AutoTaggingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3AutotaggingIdDelete**
```swift
    open class func apiV3AutotaggingIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrAutoTaggingAPI.apiV3AutotaggingIdDelete(id: id) { (response, error) in
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

# **apiV3AutotaggingIdGet**
```swift
    open class func apiV3AutotaggingIdGet(id: Int, completion: @escaping (_ data: AutoTaggingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrAutoTaggingAPI.apiV3AutotaggingIdGet(id: id) { (response, error) in
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

[**AutoTaggingResource**](AutoTaggingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3AutotaggingIdPut**
```swift
    open class func apiV3AutotaggingIdPut(id: String, autoTaggingResource: AutoTaggingResource? = nil, completion: @escaping (_ data: AutoTaggingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let autoTaggingResource = AutoTaggingResource(id: 123, name: "name_example", removeTagsAutomatically: false, tags: [123], specifications: [AutoTaggingSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)])]) // AutoTaggingResource |  (optional)

RadarrAutoTaggingAPI.apiV3AutotaggingIdPut(id: id, autoTaggingResource: autoTaggingResource) { (response, error) in
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
 **autoTaggingResource** | [**AutoTaggingResource**](AutoTaggingResource.md) |  | [optional] 

### Return type

[**AutoTaggingResource**](AutoTaggingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3AutotaggingPost**
```swift
    open class func apiV3AutotaggingPost(autoTaggingResource: AutoTaggingResource? = nil, completion: @escaping (_ data: AutoTaggingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let autoTaggingResource = AutoTaggingResource(id: 123, name: "name_example", removeTagsAutomatically: false, tags: [123], specifications: [AutoTaggingSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)])]) // AutoTaggingResource |  (optional)

RadarrAutoTaggingAPI.apiV3AutotaggingPost(autoTaggingResource: autoTaggingResource) { (response, error) in
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
 **autoTaggingResource** | [**AutoTaggingResource**](AutoTaggingResource.md) |  | [optional] 

### Return type

[**AutoTaggingResource**](AutoTaggingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3AutotaggingSchemaGet**
```swift
    open class func apiV3AutotaggingSchemaGet(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrAutoTaggingAPI.apiV3AutotaggingSchemaGet() { (response, error) in
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

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

