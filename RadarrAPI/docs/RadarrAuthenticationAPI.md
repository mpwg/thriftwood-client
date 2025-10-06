# RadarrAuthenticationAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**loginPost**](RadarrAuthenticationAPI.md#loginpost) | **POST** /login | 
[**logoutGet**](RadarrAuthenticationAPI.md#logoutget) | **GET** /logout | 


# **loginPost**
```swift
    open class func loginPost(returnUrl: String? = nil, username: String? = nil, password: String? = nil, rememberMe: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let returnUrl = "returnUrl_example" // String |  (optional)
let username = "username_example" // String |  (optional)
let password = "password_example" // String |  (optional)
let rememberMe = "rememberMe_example" // String |  (optional)

RadarrAuthenticationAPI.loginPost(returnUrl: returnUrl, username: username, password: password, rememberMe: rememberMe) { (response, error) in
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
 **returnUrl** | **String** |  | [optional] 
 **username** | **String** |  | [optional] 
 **password** | **String** |  | [optional] 
 **rememberMe** | **String** |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutGet**
```swift
    open class func logoutGet(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrAuthenticationAPI.logoutGet() { (response, error) in
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

