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
stubRequest(@"GET", @"(.*?)google.com(.*?)".regex);
```



#### Stubbing a request with a regular expressions body

```objc
stubRequest(@"POST", @"http://www.google.com").
withBody(@"{\"name\":\"abc\"}");
```

#### Returning a specific status code
```objc
stubRequest(@"GET", @"http://www.google.com").andReturn(404);
```

#### Returning a specific status code, headers and body
```objc
stubRequest(@"GET", @"http://www.google.com").
andReturn(200).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"{\"ok\":true}");
```

#### All together
```objc
stubRequest(@"POST", @"http://www.google.com").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"}).
withBody(@"{\"name\":\"foo\"}").
andReturn(200).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"{\"ok\":true}");
```
