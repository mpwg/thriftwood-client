# RadarrDownloadClientAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3DownloadclientActionNamePost**](RadarrDownloadClientAPI.md#apiv3downloadclientactionnamepost) | **POST** /api/v3/downloadclient/action/{name} | 
[**apiV3DownloadclientBulkDelete**](RadarrDownloadClientAPI.md#apiv3downloadclientbulkdelete) | **DELETE** /api/v3/downloadclient/bulk | 
[**apiV3DownloadclientBulkPut**](RadarrDownloadClientAPI.md#apiv3downloadclientbulkput) | **PUT** /api/v3/downloadclient/bulk | 
[**apiV3DownloadclientGet**](RadarrDownloadClientAPI.md#apiv3downloadclientget) | **GET** /api/v3/downloadclient | 
[**apiV3DownloadclientIdDelete**](RadarrDownloadClientAPI.md#apiv3downloadclientiddelete) | **DELETE** /api/v3/downloadclient/{id} | 
[**apiV3DownloadclientIdGet**](RadarrDownloadClientAPI.md#apiv3downloadclientidget) | **GET** /api/v3/downloadclient/{id} | 
[**apiV3DownloadclientIdPut**](RadarrDownloadClientAPI.md#apiv3downloadclientidput) | **PUT** /api/v3/downloadclient/{id} | 
[**apiV3DownloadclientPost**](RadarrDownloadClientAPI.md#apiv3downloadclientpost) | **POST** /api/v3/downloadclient | 
[**apiV3DownloadclientSchemaGet**](RadarrDownloadClientAPI.md#apiv3downloadclientschemaget) | **GET** /api/v3/downloadclient/schema | 
[**apiV3DownloadclientTestPost**](RadarrDownloadClientAPI.md#apiv3downloadclienttestpost) | **POST** /api/v3/downloadclient/test | 
[**apiV3DownloadclientTestallPost**](RadarrDownloadClientAPI.md#apiv3downloadclienttestallpost) | **POST** /api/v3/downloadclient/testall | 


# **apiV3DownloadclientActionNamePost**
```swift
    open class func apiV3DownloadclientActionNamePost(name: String, downloadClientResource: DownloadClientResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let name = "name_example" // String | 
let downloadClientResource = DownloadClientResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enable: false, _protocol: DownloadProtocol(), priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientActionNamePost(name: name, downloadClientResource: downloadClientResource) { (response, error) in
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
 **downloadClientResource** | [**DownloadClientResource**](DownloadClientResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientBulkDelete**
```swift
    open class func apiV3DownloadclientBulkDelete(downloadClientBulkResource: DownloadClientBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let downloadClientBulkResource = DownloadClientBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enable: false, priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientBulkResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientBulkDelete(downloadClientBulkResource: downloadClientBulkResource) { (response, error) in
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
 **downloadClientBulkResource** | [**DownloadClientBulkResource**](DownloadClientBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientBulkPut**
```swift
    open class func apiV3DownloadclientBulkPut(downloadClientBulkResource: DownloadClientBulkResource? = nil, completion: @escaping (_ data: DownloadClientResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let downloadClientBulkResource = DownloadClientBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enable: false, priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientBulkResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientBulkPut(downloadClientBulkResource: downloadClientBulkResource) { (response, error) in
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
 **downloadClientBulkResource** | [**DownloadClientBulkResource**](DownloadClientBulkResource.md) |  | [optional] 

### Return type

[**DownloadClientResource**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientGet**
```swift
    open class func apiV3DownloadclientGet(completion: @escaping (_ data: [DownloadClientResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrDownloadClientAPI.apiV3DownloadclientGet() { (response, error) in
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

[**[DownloadClientResource]**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientIdDelete**
```swift
    open class func apiV3DownloadclientIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrDownloadClientAPI.apiV3DownloadclientIdDelete(id: id) { (response, error) in
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

# **apiV3DownloadclientIdGet**
```swift
    open class func apiV3DownloadclientIdGet(id: Int, completion: @escaping (_ data: DownloadClientResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrDownloadClientAPI.apiV3DownloadclientIdGet(id: id) { (response, error) in
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

[**DownloadClientResource**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientIdPut**
```swift
    open class func apiV3DownloadclientIdPut(id: Int, forceSave: Bool? = nil, downloadClientResource: DownloadClientResource? = nil, completion: @escaping (_ data: DownloadClientResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let forceSave = true // Bool |  (optional) (default to false)
let downloadClientResource = DownloadClientResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enable: false, _protocol: DownloadProtocol(), priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientIdPut(id: id, forceSave: forceSave, downloadClientResource: downloadClientResource) { (response, error) in
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
 **downloadClientResource** | [**DownloadClientResource**](DownloadClientResource.md) |  | [optional] 

### Return type

[**DownloadClientResource**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientPost**
```swift
    open class func apiV3DownloadclientPost(forceSave: Bool? = nil, downloadClientResource: DownloadClientResource? = nil, completion: @escaping (_ data: DownloadClientResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceSave = true // Bool |  (optional) (default to false)
let downloadClientResource = DownloadClientResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enable: false, _protocol: DownloadProtocol(), priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientPost(forceSave: forceSave, downloadClientResource: downloadClientResource) { (response, error) in
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
 **downloadClientResource** | [**DownloadClientResource**](DownloadClientResource.md) |  | [optional] 

### Return type

[**DownloadClientResource**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientSchemaGet**
```swift
    open class func apiV3DownloadclientSchemaGet(completion: @escaping (_ data: [DownloadClientResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrDownloadClientAPI.apiV3DownloadclientSchemaGet() { (response, error) in
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

[**[DownloadClientResource]**](DownloadClientResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientTestPost**
```swift
    open class func apiV3DownloadclientTestPost(forceTest: Bool? = nil, downloadClientResource: DownloadClientResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceTest = true // Bool |  (optional) (default to false)
let downloadClientResource = DownloadClientResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enable: false, _protocol: DownloadProtocol(), priority: 123, removeCompletedDownloads: false, removeFailedDownloads: false) // DownloadClientResource |  (optional)

RadarrDownloadClientAPI.apiV3DownloadclientTestPost(forceTest: forceTest, downloadClientResource: downloadClientResource) { (response, error) in
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
 **downloadClientResource** | [**DownloadClientResource**](DownloadClientResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DownloadclientTestallPost**
```swift
    open class func apiV3DownloadclientTestallPost(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrDownloadClientAPI.apiV3DownloadclientTestallPost() { (response, error) in
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

