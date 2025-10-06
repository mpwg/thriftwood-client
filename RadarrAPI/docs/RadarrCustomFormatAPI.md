# RadarrCustomFormatAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CustomformatBulkDelete**](RadarrCustomFormatAPI.md#apiv3customformatbulkdelete) | **DELETE** /api/v3/customformat/bulk | 
[**apiV3CustomformatBulkPut**](RadarrCustomFormatAPI.md#apiv3customformatbulkput) | **PUT** /api/v3/customformat/bulk | 
[**apiV3CustomformatGet**](RadarrCustomFormatAPI.md#apiv3customformatget) | **GET** /api/v3/customformat | 
[**apiV3CustomformatIdDelete**](RadarrCustomFormatAPI.md#apiv3customformatiddelete) | **DELETE** /api/v3/customformat/{id} | 
[**apiV3CustomformatIdGet**](RadarrCustomFormatAPI.md#apiv3customformatidget) | **GET** /api/v3/customformat/{id} | 
[**apiV3CustomformatIdPut**](RadarrCustomFormatAPI.md#apiv3customformatidput) | **PUT** /api/v3/customformat/{id} | 
[**apiV3CustomformatPost**](RadarrCustomFormatAPI.md#apiv3customformatpost) | **POST** /api/v3/customformat | 
[**apiV3CustomformatSchemaGet**](RadarrCustomFormatAPI.md#apiv3customformatschemaget) | **GET** /api/v3/customformat/schema | 


# **apiV3CustomformatBulkDelete**
```swift
    open class func apiV3CustomformatBulkDelete(customFormatBulkResource: CustomFormatBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let customFormatBulkResource = CustomFormatBulkResource(ids: [123], includeCustomFormatWhenRenaming: false) // CustomFormatBulkResource |  (optional)

RadarrCustomFormatAPI.apiV3CustomformatBulkDelete(customFormatBulkResource: customFormatBulkResource) { (response, error) in
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
 **customFormatBulkResource** | [**CustomFormatBulkResource**](CustomFormatBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatBulkPut**
```swift
    open class func apiV3CustomformatBulkPut(customFormatBulkResource: CustomFormatBulkResource? = nil, completion: @escaping (_ data: CustomFormatResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let customFormatBulkResource = CustomFormatBulkResource(ids: [123], includeCustomFormatWhenRenaming: false) // CustomFormatBulkResource |  (optional)

RadarrCustomFormatAPI.apiV3CustomformatBulkPut(customFormatBulkResource: customFormatBulkResource) { (response, error) in
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
 **customFormatBulkResource** | [**CustomFormatBulkResource**](CustomFormatBulkResource.md) |  | [optional] 

### Return type

[**CustomFormatResource**](CustomFormatResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatGet**
```swift
    open class func apiV3CustomformatGet(completion: @escaping (_ data: [CustomFormatResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrCustomFormatAPI.apiV3CustomformatGet() { (response, error) in
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

[**[CustomFormatResource]**](CustomFormatResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatIdDelete**
```swift
    open class func apiV3CustomformatIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCustomFormatAPI.apiV3CustomformatIdDelete(id: id) { (response, error) in
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

# **apiV3CustomformatIdGet**
```swift
    open class func apiV3CustomformatIdGet(id: Int, completion: @escaping (_ data: CustomFormatResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCustomFormatAPI.apiV3CustomformatIdGet(id: id) { (response, error) in
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

[**CustomFormatResource**](CustomFormatResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatIdPut**
```swift
    open class func apiV3CustomformatIdPut(id: String, customFormatResource: CustomFormatResource? = nil, completion: @escaping (_ data: CustomFormatResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let customFormatResource = CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])]) // CustomFormatResource |  (optional)

RadarrCustomFormatAPI.apiV3CustomformatIdPut(id: id, customFormatResource: customFormatResource) { (response, error) in
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
 **customFormatResource** | [**CustomFormatResource**](CustomFormatResource.md) |  | [optional] 

### Return type

[**CustomFormatResource**](CustomFormatResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatPost**
```swift
    open class func apiV3CustomformatPost(customFormatResource: CustomFormatResource? = nil, completion: @escaping (_ data: CustomFormatResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let customFormatResource = CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])]) // CustomFormatResource |  (optional)

RadarrCustomFormatAPI.apiV3CustomformatPost(customFormatResource: customFormatResource) { (response, error) in
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
 **customFormatResource** | [**CustomFormatResource**](CustomFormatResource.md) |  | [optional] 

### Return type

[**CustomFormatResource**](CustomFormatResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CustomformatSchemaGet**
```swift
    open class func apiV3CustomformatSchemaGet(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrCustomFormatAPI.apiV3CustomformatSchemaGet() { (response, error) in
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

