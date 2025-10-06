# RadarrParseAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ParseGet**](RadarrParseAPI.md#apiv3parseget) | **GET** /api/v3/parse | 


# **apiV3ParseGet**
```swift
    open class func apiV3ParseGet(title: String? = nil, completion: @escaping (_ data: ParseResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let title = "title_example" // String |  (optional)

RadarrParseAPI.apiV3ParseGet(title: title) { (response, error) in
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
 **title** | **String** |  | [optional] 

### Return type

[**ParseResource**](ParseResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

