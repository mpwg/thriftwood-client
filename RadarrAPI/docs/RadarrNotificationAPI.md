# RadarrNotificationAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3NotificationActionNamePost**](RadarrNotificationAPI.md#apiv3notificationactionnamepost) | **POST** /api/v3/notification/action/{name} | 
[**apiV3NotificationGet**](RadarrNotificationAPI.md#apiv3notificationget) | **GET** /api/v3/notification | 
[**apiV3NotificationIdDelete**](RadarrNotificationAPI.md#apiv3notificationiddelete) | **DELETE** /api/v3/notification/{id} | 
[**apiV3NotificationIdGet**](RadarrNotificationAPI.md#apiv3notificationidget) | **GET** /api/v3/notification/{id} | 
[**apiV3NotificationIdPut**](RadarrNotificationAPI.md#apiv3notificationidput) | **PUT** /api/v3/notification/{id} | 
[**apiV3NotificationPost**](RadarrNotificationAPI.md#apiv3notificationpost) | **POST** /api/v3/notification | 
[**apiV3NotificationSchemaGet**](RadarrNotificationAPI.md#apiv3notificationschemaget) | **GET** /api/v3/notification/schema | 
[**apiV3NotificationTestPost**](RadarrNotificationAPI.md#apiv3notificationtestpost) | **POST** /api/v3/notification/test | 
[**apiV3NotificationTestallPost**](RadarrNotificationAPI.md#apiv3notificationtestallpost) | **POST** /api/v3/notification/testall | 


# **apiV3NotificationActionNamePost**
```swift
    open class func apiV3NotificationActionNamePost(name: String, notificationResource: NotificationResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let name = "name_example" // String | 
let notificationResource = NotificationResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], link: "link_example", onGrab: false, onDownload: false, onUpgrade: false, onRename: false, onMovieAdded: false, onMovieDelete: false, onMovieFileDelete: false, onMovieFileDeleteForUpgrade: false, onHealthIssue: false, includeHealthWarnings: false, onHealthRestored: false, onApplicationUpdate: false, onManualInteractionRequired: false, supportsOnGrab: false, supportsOnDownload: false, supportsOnUpgrade: false, supportsOnRename: false, supportsOnMovieAdded: false, supportsOnMovieDelete: false, supportsOnMovieFileDelete: false, supportsOnMovieFileDeleteForUpgrade: false, supportsOnHealthIssue: false, supportsOnHealthRestored: false, supportsOnApplicationUpdate: false, supportsOnManualInteractionRequired: false, testCommand: "testCommand_example") // NotificationResource |  (optional)

RadarrNotificationAPI.apiV3NotificationActionNamePost(name: name, notificationResource: notificationResource) { (response, error) in
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
 **notificationResource** | [**NotificationResource**](NotificationResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationGet**
```swift
    open class func apiV3NotificationGet(completion: @escaping (_ data: [NotificationResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrNotificationAPI.apiV3NotificationGet() { (response, error) in
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

[**[NotificationResource]**](NotificationResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationIdDelete**
```swift
    open class func apiV3NotificationIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrNotificationAPI.apiV3NotificationIdDelete(id: id) { (response, error) in
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

# **apiV3NotificationIdGet**
```swift
    open class func apiV3NotificationIdGet(id: Int, completion: @escaping (_ data: NotificationResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrNotificationAPI.apiV3NotificationIdGet(id: id) { (response, error) in
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

[**NotificationResource**](NotificationResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationIdPut**
```swift
    open class func apiV3NotificationIdPut(id: Int, forceSave: Bool? = nil, notificationResource: NotificationResource? = nil, completion: @escaping (_ data: NotificationResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let forceSave = true // Bool |  (optional) (default to false)
let notificationResource = NotificationResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], link: "link_example", onGrab: false, onDownload: false, onUpgrade: false, onRename: false, onMovieAdded: false, onMovieDelete: false, onMovieFileDelete: false, onMovieFileDeleteForUpgrade: false, onHealthIssue: false, includeHealthWarnings: false, onHealthRestored: false, onApplicationUpdate: false, onManualInteractionRequired: false, supportsOnGrab: false, supportsOnDownload: false, supportsOnUpgrade: false, supportsOnRename: false, supportsOnMovieAdded: false, supportsOnMovieDelete: false, supportsOnMovieFileDelete: false, supportsOnMovieFileDeleteForUpgrade: false, supportsOnHealthIssue: false, supportsOnHealthRestored: false, supportsOnApplicationUpdate: false, supportsOnManualInteractionRequired: false, testCommand: "testCommand_example") // NotificationResource |  (optional)

RadarrNotificationAPI.apiV3NotificationIdPut(id: id, forceSave: forceSave, notificationResource: notificationResource) { (response, error) in
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
 **notificationResource** | [**NotificationResource**](NotificationResource.md) |  | [optional] 

### Return type

[**NotificationResource**](NotificationResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationPost**
```swift
    open class func apiV3NotificationPost(forceSave: Bool? = nil, notificationResource: NotificationResource? = nil, completion: @escaping (_ data: NotificationResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceSave = true // Bool |  (optional) (default to false)
let notificationResource = NotificationResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], link: "link_example", onGrab: false, onDownload: false, onUpgrade: false, onRename: false, onMovieAdded: false, onMovieDelete: false, onMovieFileDelete: false, onMovieFileDeleteForUpgrade: false, onHealthIssue: false, includeHealthWarnings: false, onHealthRestored: false, onApplicationUpdate: false, onManualInteractionRequired: false, supportsOnGrab: false, supportsOnDownload: false, supportsOnUpgrade: false, supportsOnRename: false, supportsOnMovieAdded: false, supportsOnMovieDelete: false, supportsOnMovieFileDelete: false, supportsOnMovieFileDeleteForUpgrade: false, supportsOnHealthIssue: false, supportsOnHealthRestored: false, supportsOnApplicationUpdate: false, supportsOnManualInteractionRequired: false, testCommand: "testCommand_example") // NotificationResource |  (optional)

RadarrNotificationAPI.apiV3NotificationPost(forceSave: forceSave, notificationResource: notificationResource) { (response, error) in
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
 **notificationResource** | [**NotificationResource**](NotificationResource.md) |  | [optional] 

### Return type

[**NotificationResource**](NotificationResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationSchemaGet**
```swift
    open class func apiV3NotificationSchemaGet(completion: @escaping (_ data: [NotificationResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrNotificationAPI.apiV3NotificationSchemaGet() { (response, error) in
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

[**[NotificationResource]**](NotificationResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationTestPost**
```swift
    open class func apiV3NotificationTestPost(forceTest: Bool? = nil, notificationResource: NotificationResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let forceTest = true // Bool |  (optional) (default to false)
let notificationResource = NotificationResource(id: 123, name: "name_example", fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], implementationName: "implementationName_example", implementation: "implementation_example", configContract: "configContract_example", infoLink: "infoLink_example", message: ProviderMessage(message: "message_example", type: ProviderMessageType()), tags: [123], presets: [nil], link: "link_example", onGrab: false, onDownload: false, onUpgrade: false, onRename: false, onMovieAdded: false, onMovieDelete: false, onMovieFileDelete: false, onMovieFileDeleteForUpgrade: false, onHealthIssue: false, includeHealthWarnings: false, onHealthRestored: false, onApplicationUpdate: false, onManualInteractionRequired: false, supportsOnGrab: false, supportsOnDownload: false, supportsOnUpgrade: false, supportsOnRename: false, supportsOnMovieAdded: false, supportsOnMovieDelete: false, supportsOnMovieFileDelete: false, supportsOnMovieFileDeleteForUpgrade: false, supportsOnHealthIssue: false, supportsOnHealthRestored: false, supportsOnApplicationUpdate: false, supportsOnManualInteractionRequired: false, testCommand: "testCommand_example") // NotificationResource |  (optional)

RadarrNotificationAPI.apiV3NotificationTestPost(forceTest: forceTest, notificationResource: notificationResource) { (response, error) in
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
 **notificationResource** | [**NotificationResource**](NotificationResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3NotificationTestallPost**
```swift
    open class func apiV3NotificationTestallPost(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrNotificationAPI.apiV3NotificationTestallPost() { (response, error) in
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

