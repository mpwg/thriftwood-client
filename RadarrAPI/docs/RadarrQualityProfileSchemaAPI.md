# RadarrQualityProfileSchemaAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QualityprofileSchemaGet**](RadarrQualityProfileSchemaAPI.md#apiv3qualityprofileschemaget) | **GET** /api/v3/qualityprofile/schema | 


# **apiV3QualityprofileSchemaGet**
```swift
    open class func apiV3QualityprofileSchemaGet(completion: @escaping (_ data: QualityProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrQualityProfileSchemaAPI.apiV3QualityprofileSchemaGet() { (response, error) in
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

[**QualityProfileResource**](QualityProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

