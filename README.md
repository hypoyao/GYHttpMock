# HttpMock
Library for stubbing and updating part/all response on HTTP requests in objc.

## Features
* Support NSURLConnection, NSURLSession.
* Support replacing totally or partly for HTTP response
* Match requests with regular expressions.
* Stub requests with errors.


### Stubbing requests
#### Stubbing a simple request
It will return the default response, which is a 200 and an empty body.

```objc
stubRequest(@"GET", @"http://www.google.com");
```

#### Stubbing requests with regular expressions
```objc
stubRequest(@"GET", @"(.*?)google.com(.*?)".regex).
withBody(@"{\"name\":\"abc\"}".regex);
```


#### Stubbing a request with update response partly

```objc
stubRequest(@"POST", @"http://www.google.com").
isUpdatePartResponseBody(YES).
withBody(@"{\"name\":\"abc\"}".regex);
andReturn(200).
withBody(@"{\"key\":\"value\"}");
```

#### All together
```objc
stubRequest(@"POST", @"http://www.google.com").
withHeaders(@{@"Accept": @"application/json"}).
withBody(@"\"name\":\"foo\"".regex).
isUpdatePartResponseBody(YES).
andReturn(200).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"{\"key\":\"value\"}");
```
