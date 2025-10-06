# RadarrHostConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigHostGet**](RadarrHostConfigAPI.md#apiv3confighostget) | **GET** /api/v3/config/host | 
[**apiV3ConfigHostIdGet**](RadarrHostConfigAPI.md#apiv3confighostidget) | **GET** /api/v3/config/host/{id} | 
[**apiV3ConfigHostIdPut**](RadarrHostConfigAPI.md#apiv3confighostidput) | **PUT** /api/v3/config/host/{id} | 


# **apiV3ConfigHostGet**
```swift
    open class func apiV3ConfigHostGet(completion: @escaping (_ data: HostConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrHostConfigAPI.apiV3ConfigHostGet() { (response, error) in
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

[**HostConfigResource**](HostConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigHostIdGet**
```swift
    open class func apiV3ConfigHostIdGet(id: Int, completion: @escaping (_ data: HostConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrHostConfigAPI.apiV3ConfigHostIdGet(id: id) { (response, error) in
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

[**HostConfigResource**](HostConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigHostIdPut**
```swift
    open class func apiV3ConfigHostIdPut(id: String, hostConfigResource: HostConfigResource? = nil, completion: @escaping (_ data: HostConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let hostConfigResource = HostConfigResource(id: 123, bindAddress: "bindAddress_example", port: 123, sslPort: 123, enableSsl: false, launchBrowser: false, authenticationMethod: AuthenticationType(), authenticationRequired: AuthenticationRequiredType(), analyticsEnabled: false, username: "username_example", password: "password_example", passwordConfirmation: "passwordConfirmation_example", logLevel: "logLevel_example", logSizeLimit: 123, consoleLogLevel: "consoleLogLevel_example", branch: "branch_example", apiKey: "apiKey_example", sslCertPath: "sslCertPath_example", sslCertPassword: "sslCertPassword_example", urlBase: "urlBase_example", instanceName: "instanceName_example", applicationUrl: "applicationUrl_example", updateAutomatically: false, updateMechanism: UpdateMechanism(), updateScriptPath: "updateScriptPath_example", proxyEnabled: false, proxyType: ProxyType(), proxyHostname: "proxyHostname_example", proxyPort: 123, proxyUsername: "proxyUsername_example", proxyPassword: "proxyPassword_example", proxyBypassFilter: "proxyBypassFilter_example", proxyBypassLocalAddresses: false, certificateValidation: CertificateValidationType(), backupFolder: "backupFolder_example", backupInterval: 123, backupRetention: 123, trustCgnatIpAddresses: false) // HostConfigResource |  (optional)

RadarrHostConfigAPI.apiV3ConfigHostIdPut(id: id, hostConfigResource: hostConfigResource) { (response, error) in
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
 **hostConfigResource** | [**HostConfigResource**](HostConfigResource.md) |  | [optional] 

### Return type

[**HostConfigResource**](HostConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

