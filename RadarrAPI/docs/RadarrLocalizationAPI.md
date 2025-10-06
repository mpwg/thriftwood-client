# RadarrLocalizationAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3LocalizationGet**](RadarrLocalizationAPI.md#apiv3localizationget) | **GET** /api/v3/localization | 
[**apiV3LocalizationLanguageGet**](RadarrLocalizationAPI.md#apiv3localizationlanguageget) | **GET** /api/v3/localization/language | 


# **apiV3LocalizationGet**
```swift
    open class func apiV3LocalizationGet(completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrLocalizationAPI.apiV3LocalizationGet() { (response, error) in
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

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3LocalizationLanguageGet**
```swift
    open class func apiV3LocalizationLanguageGet(completion: @escaping (_ data: LocalizationLanguageResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrLocalizationAPI.apiV3LocalizationLanguageGet() { (response, error) in
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

[**LocalizationLanguageResource**](LocalizationLanguageResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

