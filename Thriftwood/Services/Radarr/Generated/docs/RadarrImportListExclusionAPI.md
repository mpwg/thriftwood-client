# RadarrImportListExclusionAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ExclusionsBulkDelete**](RadarrImportListExclusionAPI.md#apiv3exclusionsbulkdelete) | **DELETE** /api/v3/exclusions/bulk | 
[**apiV3ExclusionsBulkPost**](RadarrImportListExclusionAPI.md#apiv3exclusionsbulkpost) | **POST** /api/v3/exclusions/bulk | 
[**apiV3ExclusionsGet**](RadarrImportListExclusionAPI.md#apiv3exclusionsget) | **GET** /api/v3/exclusions | 
[**apiV3ExclusionsIdDelete**](RadarrImportListExclusionAPI.md#apiv3exclusionsiddelete) | **DELETE** /api/v3/exclusions/{id} | 
[**apiV3ExclusionsIdGet**](RadarrImportListExclusionAPI.md#apiv3exclusionsidget) | **GET** /api/v3/exclusions/{id} | 
[**apiV3ExclusionsIdPut**](RadarrImportListExclusionAPI.md#apiv3exclusionsidput) | **PUT** /api/v3/exclusions/{id} | 
[**apiV3ExclusionsPagedGet**](RadarrImportListExclusionAPI.md#apiv3exclusionspagedget) | **GET** /api/v3/exclusions/paged | 
[**apiV3ExclusionsPost**](RadarrImportListExclusionAPI.md#apiv3exclusionspost) | **POST** /api/v3/exclusions | 


# **apiV3ExclusionsBulkDelete**
```swift
    open class func apiV3ExclusionsBulkDelete(importListExclusionBulkResource: ImportListExclusionBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let importListExclusionBulkResource = ImportListExclusionBulkResource(ids: [123]) // ImportListExclusionBulkResource |  (optional)

RadarrImportListExclusionAPI.apiV3ExclusionsBulkDelete(importListExclusionBulkResource: importListExclusionBulkResource) { (response, error) in
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
 **importListExclusionBulkResource** | [**ImportListExclusionBulkResource**](ImportListExclusionBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsBulkPost**
```swift
    open class func apiV3ExclusionsBulkPost(importListExclusionResource: [ImportListExclusionResource]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let importListExclusionResource = [ImportListExclusionResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], tmdbId: 123, movieTitle: "movieTitle_example", movieYear: 123)] // [ImportListExclusionResource] |  (optional)

RadarrImportListExclusionAPI.apiV3ExclusionsBulkPost(importListExclusionResource: importListExclusionResource) { (response, error) in
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
 **importListExclusionResource** | [**[ImportListExclusionResource]**](ImportListExclusionResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsGet**
```swift
    open class func apiV3ExclusionsGet(completion: @escaping (_ data: [ImportListExclusionResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrImportListExclusionAPI.apiV3ExclusionsGet() { (response, error) in
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

[**[ImportListExclusionResource]**](ImportListExclusionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsIdDelete**
```swift
    open class func apiV3ExclusionsIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrImportListExclusionAPI.apiV3ExclusionsIdDelete(id: id) { (response, error) in
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

# **apiV3ExclusionsIdGet**
```swift
    open class func apiV3ExclusionsIdGet(id: Int, completion: @escaping (_ data: ImportListExclusionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrImportListExclusionAPI.apiV3ExclusionsIdGet(id: id) { (response, error) in
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

[**ImportListExclusionResource**](ImportListExclusionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsIdPut**
```swift
    open class func apiV3ExclusionsIdPut(id: String, importListExclusionResource: ImportListExclusionResource? = nil, completion: @escaping (_ data: ImportListExclusionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let importListExclusionResource = ImportListExclusionResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], tmdbId: 123, movieTitle: "movieTitle_example", movieYear: 123) // ImportListExclusionResource |  (optional)

RadarrImportListExclusionAPI.apiV3ExclusionsIdPut(id: id, importListExclusionResource: importListExclusionResource) { (response, error) in
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
 **importListExclusionResource** | [**ImportListExclusionResource**](ImportListExclusionResource.md) |  | [optional] 

### Return type

[**ImportListExclusionResource**](ImportListExclusionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsPagedGet**
```swift
    open class func apiV3ExclusionsPagedGet(page: Int? = nil, pageSize: Int? = nil, sortKey: String? = nil, sortDirection: SortDirection? = nil, completion: @escaping (_ data: ImportListExclusionResourcePagingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let page = 987 // Int |  (optional) (default to 1)
let pageSize = 987 // Int |  (optional) (default to 10)
let sortKey = "sortKey_example" // String |  (optional)
let sortDirection = SortDirection() // SortDirection |  (optional)

RadarrImportListExclusionAPI.apiV3ExclusionsPagedGet(page: page, pageSize: pageSize, sortKey: sortKey, sortDirection: sortDirection) { (response, error) in
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
 **page** | **Int** |  | [optional] [default to 1]
 **pageSize** | **Int** |  | [optional] [default to 10]
 **sortKey** | **String** |  | [optional] 
 **sortDirection** | [**SortDirection**](.md) |  | [optional] 

### Return type

[**ImportListExclusionResourcePagingResource**](ImportListExclusionResourcePagingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ExclusionsPost**
```swift
    open class func apiV3ExclusionsPost(importListExclusionResource: ImportListExclusionResource? = nil, completion: @escaping (_ data: ImportListExclusionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let importListExclusionResource = ImportListExclusionResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], tmdbId: 123, movieTitle: "movieTitle_example", movieYear: 123) // ImportListExclusionResource |  (optional)

RadarrImportListExclusionAPI.apiV3ExclusionsPost(importListExclusionResource: importListExclusionResource) { (response, error) in
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
 **importListExclusionResource** | [**ImportListExclusionResource**](ImportListExclusionResource.md) |  | [optional] 

### Return type

[**ImportListExclusionResource**](ImportListExclusionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

