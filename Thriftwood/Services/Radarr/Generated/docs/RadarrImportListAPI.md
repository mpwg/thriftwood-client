# RadarrImportListAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ImportlistActionNamePost**](RadarrImportListAPI.md#apiv3importlistactionnamepost) | **POST** /api/v3/importlist/action/{name} | 
[**apiV3ImportlistBulkDelete**](RadarrImportListAPI.md#apiv3importlistbulkdelete) | **DELETE** /api/v3/importlist/bulk | 
[**apiV3ImportlistBulkPut**](RadarrImportListAPI.md#apiv3importlistbulkput) | **PUT** /api/v3/importlist/bulk | 
[**apiV3ImportlistGet**](RadarrImportListAPI.md#apiv3importlistget) | **GET** /api/v3/importlist | 
[**apiV3ImportlistIdDelete**](RadarrImportListAPI.md#apiv3importlistiddelete) | **DELETE** /api/v3/importlist/{id} | 
[**apiV3ImportlistIdGet**](RadarrImportListAPI.md#apiv3importlistidget) | **GET** /api/v3/importlist/{id} | 
[**apiV3ImportlistIdPut**](RadarrImportListAPI.md#apiv3importlistidput) | **PUT** /api/v3/importlist/{id} | 
[**apiV3ImportlistPost**](RadarrImportListAPI.md#apiv3importlistpost) | **POST** /api/v3/importlist | 
[**apiV3ImportlistSchemaGet**](RadarrImportListAPI.md#apiv3importlistschemaget) | **GET** /api/v3/importlist/schema | 
[**apiV3ImportlistTestPost**](RadarrImportListAPI.md#apiv3importlisttestpost) | **POST** /api/v3/importlist/test | 
[**apiV3ImportlistTestallPost**](RadarrImportListAPI.md#apiv3importlisttestallpost) | **POST** /api/v3/importlist/testall | 


# **apiV3ImportlistActionNamePost**
```swift
    open class func apiV3ImportlistActionNamePost(name: String, importListResource: ImportListResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let name = "name_example" // String | 
let importListResource = ImportListResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enabled: false, enableAuto: false, monitor: MonitorTypes(), rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, searchOnAdd: false, minimumAvailability: MovieStatusType(), listType: ImportListType(), listOrder: 123, minRefreshInterval: "minRefreshInterval_example") // ImportListResource |  (optional)

RadarrImportListAPI.apiV3ImportlistActionNamePost(name: name, importListResource: importListResource) { (response, error) in
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
 **importListResource** | [**ImportListResource**](ImportListResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistBulkDelete**
```swift
    open class func apiV3ImportlistBulkDelete(importListBulkResource: ImportListBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let importListBulkResource = ImportListBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enabled: false, enableAuto: false, rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, minimumAvailability: MovieStatusType()) // ImportListBulkResource |  (optional)

RadarrImportListAPI.apiV3ImportlistBulkDelete(importListBulkResource: importListBulkResource) { (response, error) in
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
 **importListBulkResource** | [**ImportListBulkResource**](ImportListBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistBulkPut**
```swift
    open class func apiV3ImportlistBulkPut(importListBulkResource: ImportListBulkResource? = nil, completion: @escaping (_ data: ImportListResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let importListBulkResource = ImportListBulkResource(ids: [123], tags: [123], applyTags: ApplyTags(), enabled: false, enableAuto: false, rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, minimumAvailability: MovieStatusType()) // ImportListBulkResource |  (optional)

RadarrImportListAPI.apiV3ImportlistBulkPut(importListBulkResource: importListBulkResource) { (response, error) in
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
 **importListBulkResource** | [**ImportListBulkResource**](ImportListBulkResource.md) |  | [optional] 

### Return type

[**ImportListResource**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistGet**
```swift
    open class func apiV3ImportlistGet(completion: @escaping (_ data: [ImportListResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrImportListAPI.apiV3ImportlistGet() { (response, error) in
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

[**[ImportListResource]**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistIdDelete**
```swift
    open class func apiV3ImportlistIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrImportListAPI.apiV3ImportlistIdDelete(id: id) { (response, error) in
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

# **apiV3ImportlistIdGet**
```swift
    open class func apiV3ImportlistIdGet(id: Int, completion: @escaping (_ data: ImportListResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrImportListAPI.apiV3ImportlistIdGet(id: id) { (response, error) in
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

[**ImportListResource**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistIdPut**
```swift
    open class func apiV3ImportlistIdPut(id: Int, forceSave: Bool? = nil, importListResource: ImportListResource? = nil, completion: @escaping (_ data: ImportListResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let forceSave = true // Bool |  (optional) (default to false)
let importListResource = ImportListResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enabled: false, enableAuto: false, monitor: MonitorTypes(), rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, searchOnAdd: false, minimumAvailability: MovieStatusType(), listType: ImportListType(), listOrder: 123, minRefreshInterval: "minRefreshInterval_example") // ImportListResource |  (optional)

RadarrImportListAPI.apiV3ImportlistIdPut(id: id, forceSave: forceSave, importListResource: importListResource) { (response, error) in
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
 **importListResource** | [**ImportListResource**](ImportListResource.md) |  | [optional] 

### Return type

[**ImportListResource**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistPost**
```swift
    open class func apiV3ImportlistPost(forceSave: Bool? = nil, importListResource: ImportListResource? = nil, completion: @escaping (_ data: ImportListResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceSave = true // Bool |  (optional) (default to false)
let importListResource = ImportListResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enabled: false, enableAuto: false, monitor: MonitorTypes(), rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, searchOnAdd: false, minimumAvailability: MovieStatusType(), listType: ImportListType(), listOrder: 123, minRefreshInterval: "minRefreshInterval_example") // ImportListResource |  (optional)

RadarrImportListAPI.apiV3ImportlistPost(forceSave: forceSave, importListResource: importListResource) { (response, error) in
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
 **importListResource** | [**ImportListResource**](ImportListResource.md) |  | [optional] 

### Return type

[**ImportListResource**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistSchemaGet**
```swift
    open class func apiV3ImportlistSchemaGet(completion: @escaping (_ data: [ImportListResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrImportListAPI.apiV3ImportlistSchemaGet() { (response, error) in
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

[**[ImportListResource]**](ImportListResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistTestPost**
```swift
    open class func apiV3ImportlistTestPost(forceTest: Bool? = nil, importListResource: ImportListResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceTest = true // Bool |  (optional) (default to false)
let importListResource = ImportListResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], enabled: false, enableAuto: false, monitor: MonitorTypes(), rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, searchOnAdd: false, minimumAvailability: MovieStatusType(), listType: ImportListType(), listOrder: 123, minRefreshInterval: "minRefreshInterval_example") // ImportListResource |  (optional)

RadarrImportListAPI.apiV3ImportlistTestPost(forceTest: forceTest, importListResource: importListResource) { (response, error) in
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
 **importListResource** | [**ImportListResource**](ImportListResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ImportlistTestallPost**
```swift
    open class func apiV3ImportlistTestallPost(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrImportListAPI.apiV3ImportlistTestallPost() { (response, error) in
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

