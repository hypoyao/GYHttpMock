# GYHttpMock
Library for replacing part/all HTTP response based on [Nocilla](https://github.com/luisobo/Nocilla).

## Features
* Support NSURLConnection, NSURLSession.
* Support replacing totally or partly HTTP response
* Match requests with regular expressions.
* Support json file for response

## Installation with CocoaPods

To integrate GYHttpMock into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'GYHttpMock'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
mocking a request before the real request anywhere.

#### Mock a simple request
It will return the default response, which is a 200 and an empty body.

```objc
mockRequest(@"GET", @"http://www.google.com");
```

#### Mock requests with regular expressions
```objc
mockRequest(@"GET", @"(.*?)google.com(.*?)".regex).
withBody(@"{\"name\":\"abc\"}".regex);
```


#### Mock a request with updating response partly

```objc
mockRequest(@"POST", @"http://www.google.com").
isUpdatePartResponseBody(YES).
withBody(@"{\"name\":\"abc\"}".regex);
andReturn(200).
withBody(@"{\"key\":\"value\"}");
```

#### Mock a request with json file response

```objc
mockRequest(@"POST", @"http://www.google.com").
isUpdatePartResponseBody(YES).
withBody(@"{\"name\":\"abc\"}".regex);
andReturn(200).
withBody(@"google.json");
```
##### Examle for update part response 
    orginal response:
    {"data":{"id":"abc","location":"GZ"}}

    updatedBody: google.json
    {"data":{"time":"today"}}

    final resoponse:
    {"data":{"id":"abc","location":"GZ","time":"today"}}

#### All together
```objc
mockRequest(@"POST", @"http://www.google.com").
withHeaders(@{@"Accept": @"application/json"}).
withBody(@"\"name\":\"foo\"".regex).
isUpdatePartResponseBody(YES).
andReturn(200).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"google.json");
```

## License

GYHttpMock is released under the MIT license. See LICENSE for details.
