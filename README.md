# GYHttpMock
Library for replace part/all HTTP response based on Nocilla.

## Features
* Support NSURLConnection, NSURLSession.
* Support replacing totally or partly HTTP response
* Match requests with regular expressions.
* Support json file for response

## Installation with CocoaPods

To integrate AFNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'GYHttpMock'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

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


#### Stubbing a request with updating response partly

```objc
stubRequest(@"POST", @"http://www.google.com").
isUpdatePartResponseBody(YES).
withBody(@"{\"name\":\"abc\"}".regex);
andReturn(200).
withBody(@"{\"key\":\"value\"}");
```

#### Stubbing a request with json file response

```objc
stubRequest(@"POST", @"http://www.google.com").
isUpdatePartResponseBody(YES).
withBody(@"{\"name\":\"abc\"}".regex);
andReturn(200).
withBody(@"google.json");
```

#### All together
```objc
stubRequest(@"POST", @"http://www.google.com").
withHeaders(@{@"Accept": @"application/json"}).
withBody(@"\"name\":\"foo\"".regex).
isUpdatePartResponseBody(YES).
andReturn(200).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"google.json");
```

## License

GYHttpMock is released under the MIT license. See LICENSE for details.
