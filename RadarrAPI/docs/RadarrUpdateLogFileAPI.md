# RadarrUpdateLogFileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3LogFileUpdateFilenameGet**](RadarrUpdateLogFileAPI.md#apiv3logfileupdatefilenameget) | **GET** /api/v3/log/file/update/{filename} | 
[**apiV3LogFileUpdateGet**](RadarrUpdateLogFileAPI.md#apiv3logfileupdateget) | **GET** /api/v3/log/file/update | 


# **apiV3LogFileUpdateFilenameGet**
```swift
    open class func apiV3LogFileUpdateFilenameGet(filename: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let filename = "filename_example" // String | 

RadarrUpdateLogFileAPI.apiV3LogFileUpdateFilenameGet(filename: filename) { (response, error) in
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
 **filename** | **String** |  | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3LogFileUpdateGet**
```swift
    open class func apiV3LogFileUpdateGet(completion: @escaping (_ data: [LogFileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrUpdateLogFileAPI.apiV3LogFileUpdateGet() { (response, error) in
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

[**[LogFileResource]**](LogFileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

