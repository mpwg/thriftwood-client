# RadarrIndexerAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3IndexerActionNamePost**](RadarrIndexerAPI.md#apiv3indexeractionnamepost) | **POST** /api/v3/indexer/action/{name} | 
[**apiV3IndexerBulkDelete**](RadarrIndexerAPI.md#apiv3indexerbulkdelete) | **DELETE** /api/v3/indexer/bulk | 
[**apiV3IndexerBulkPut**](RadarrIndexerAPI.md#apiv3indexerbulkput) | **PUT** /api/v3/indexer/bulk | 
[**apiV3IndexerGet**](RadarrIndexerAPI.md#apiv3indexerget) | **GET** /api/v3/indexer | 
[**apiV3IndexerIdDelete**](RadarrIndexerAPI.md#apiv3indexeriddelete) | **DELETE** /api/v3/indexer/{id} | 
[**apiV3IndexerIdGet**](RadarrIndexerAPI.md#apiv3indexeridget) | **GET** /api/v3/indexer/{id} | 
[**apiV3IndexerIdPut**](RadarrIndexerAPI.md#apiv3indexeridput) | **PUT** /api/v3/indexer/{id} | 
[**apiV3IndexerPost**](RadarrIndexerAPI.md#apiv3indexerpost) | **POST** /api/v3/indexer | 
[**apiV3IndexerSchemaGet**](RadarrIndexerAPI.md#apiv3indexerschemaget) | **GET** /api/v3/indexer/schema | 
[**apiV3IndexerTestPost**](RadarrIndexerAPI.md#apiv3indexertestpost) | **POST** /api/v3/indexer/test | 
[**apiV3IndexerTestallPost**](RadarrIndexerAPI.md#apiv3indexertestallpost) | **POST** /api/v3/indexer/testall | 


# **apiV3IndexerActionNamePost**
```swift
    open class func apiV3IndexerActionNamePost(name: String, indexerResource: IndexerResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let name = "name_example" // String | 
let indexerResource = IndexerResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, supportsRss: false, supportsSearch: false, _protocol: DownloadProtocol(), priority: 123, downloadClientId: 123) // IndexerResource |  (optional)

RadarrIndexerAPI.apiV3IndexerActionNamePost(name: name, indexerResource: indexerResource) { (response, error) in
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
 **name** | **String** |  | 
 **indexerResource** | [**IndexerResource**](IndexerResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerBulkDelete**
```swift
    open class func apiV3IndexerBulkDelete(indexerBulkResource: IndexerBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let indexerBulkResource = IndexerBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, priority: 123) // IndexerBulkResource |  (optional)

RadarrIndexerAPI.apiV3IndexerBulkDelete(indexerBulkResource: indexerBulkResource) { (response, error) in
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
 **indexerBulkResource** | [**IndexerBulkResource**](IndexerBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerBulkPut**
```swift
    open class func apiV3IndexerBulkPut(indexerBulkResource: IndexerBulkResource? = nil, completion: @escaping (_ data: IndexerResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let indexerBulkResource = IndexerBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, priority: 123) // IndexerBulkResource |  (optional)

RadarrIndexerAPI.apiV3IndexerBulkPut(indexerBulkResource: indexerBulkResource) { (response, error) in
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
 **indexerBulkResource** | [**IndexerBulkResource**](IndexerBulkResource.md) |  | [optional] 

### Return type

[**IndexerResource**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerGet**
```swift
    open class func apiV3IndexerGet(completion: @escaping (_ data: [IndexerResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrIndexerAPI.apiV3IndexerGet() { (response, error) in
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

[**[IndexerResource]**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerIdDelete**
```swift
    open class func apiV3IndexerIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrIndexerAPI.apiV3IndexerIdDelete(id: id) { (response, error) in
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

# **apiV3IndexerIdGet**
```swift
    open class func apiV3IndexerIdGet(id: Int, completion: @escaping (_ data: IndexerResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrIndexerAPI.apiV3IndexerIdGet(id: id) { (response, error) in
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

[**IndexerResource**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerIdPut**
```swift
    open class func apiV3IndexerIdPut(id: Int, forceSave: Bool? = nil, indexerResource: IndexerResource? = nil, completion: @escaping (_ data: IndexerResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let forceSave = true // Bool |  (optional) (default to false)
let indexerResource = IndexerResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, supportsRss: false, supportsSearch: false, _protocol: DownloadProtocol(), priority: 123, downloadClientId: 123) // IndexerResource |  (optional)

RadarrIndexerAPI.apiV3IndexerIdPut(id: id, forceSave: forceSave, indexerResource: indexerResource) { (response, error) in
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
 **forceSave** | **Bool** |  | [optional] [default to false]
 **indexerResource** | [**IndexerResource**](IndexerResource.md) |  | [optional] 

### Return type

[**IndexerResource**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerPost**
```swift
    open class func apiV3IndexerPost(forceSave: Bool? = nil, indexerResource: IndexerResource? = nil, completion: @escaping (_ data: IndexerResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceSave = true // Bool |  (optional) (default to false)
let indexerResource = IndexerResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, supportsRss: false, supportsSearch: false, _protocol: DownloadProtocol(), priority: 123, downloadClientId: 123) // IndexerResource |  (optional)

RadarrIndexerAPI.apiV3IndexerPost(forceSave: forceSave, indexerResource: indexerResource) { (response, error) in
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
 **forceSave** | **Bool** |  | [optional] [default to false]
 **indexerResource** | [**IndexerResource**](IndexerResource.md) |  | [optional] 

### Return type

[**IndexerResource**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerSchemaGet**
```swift
    open class func apiV3IndexerSchemaGet(completion: @escaping (_ data: [IndexerResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrIndexerAPI.apiV3IndexerSchemaGet() { (response, error) in
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

[**[IndexerResource]**](IndexerResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerTestPost**
```swift
    open class func apiV3IndexerTestPost(forceTest: Bool? = nil, indexerResource: IndexerResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceTest = true // Bool |  (optional) (default to false)
let indexerResource = IndexerResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enableRss: false, enableAutomaticSearch: false, enableInteractiveSearch: false, supportsRss: false, supportsSearch: false, _protocol: DownloadProtocol(), priority: 123, downloadClientId: 123) // IndexerResource |  (optional)

RadarrIndexerAPI.apiV3IndexerTestPost(forceTest: forceTest, indexerResource: indexerResource) { (response, error) in
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
 **forceTest** | **Bool** |  | [optional] [default to false]
 **indexerResource** | [**IndexerResource**](IndexerResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3IndexerTestallPost**
```swift
    open class func apiV3IndexerTestallPost(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrIndexerAPI.apiV3IndexerTestallPost() { (response, error) in
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

