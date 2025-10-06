# RadarrUiConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigUiGet**](RadarrUiConfigAPI.md#apiv3configuiget) | **GET** /api/v3/config/ui | 
[**apiV3ConfigUiIdGet**](RadarrUiConfigAPI.md#apiv3configuiidget) | **GET** /api/v3/config/ui/{id} | 
[**apiV3ConfigUiIdPut**](RadarrUiConfigAPI.md#apiv3configuiidput) | **PUT** /api/v3/config/ui/{id} | 


# **apiV3ConfigUiGet**
```swift
    open class func apiV3ConfigUiGet(completion: @escaping (_ data: UiConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrUiConfigAPI.apiV3ConfigUiGet() { (response, error) in
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

[**UiConfigResource**](UiConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigUiIdGet**
```swift
    open class func apiV3ConfigUiIdGet(id: Int, completion: @escaping (_ data: UiConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrUiConfigAPI.apiV3ConfigUiIdGet(id: id) { (response, error) in
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

[**UiConfigResource**](UiConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigUiIdPut**
```swift
    open class func apiV3ConfigUiIdPut(id: String, uiConfigResource: UiConfigResource? = nil, completion: @escaping (_ data: UiConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let uiConfigResource = UiConfigResource(id: 123, firstDayOfWeek: 123, calendarWeekColumnHeader: "calendarWeekColumnHeader_example", movieRuntimeFormat: MovieRuntimeFormatType(), shortDateFormat: "shortDateFormat_example", longDateFormat: "longDateFormat_example", timeFormat: "timeFormat_example", showRelativeDates: false, enableColorImpairedMode: false, movieInfoLanguage: 123, uiLanguage: 123, theme: "theme_example") // UiConfigResource |  (optional)

RadarrUiConfigAPI.apiV3ConfigUiIdPut(id: id, uiConfigResource: uiConfigResource) { (response, error) in
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
 **uiConfigResource** | [**UiConfigResource**](UiConfigResource.md) |  | [optional] 

### Return type

[**UiConfigResource**](UiConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

