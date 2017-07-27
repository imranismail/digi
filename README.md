# Digi Assessment

## Section 1 - API

### HTTP Methods

According to the REST architecture, the aforementioned HTTP Methods should be used as described below:

* GET - Read/Querying a resource
* POST - Creating a resource
* PATCH (UPDATE) - Updating/Modyfing a resource
* PUT - Updating/Replacing a resource

### Authentication for Web Services (Machine to Machine)

1. Applications receive a shared secret known only to them and the service provider
2. A request is constructed (either a URL or a query string)
3. A signature is created using a combination of HMAC hash function with the shared secret and base64 encoded
4. The signature and current timestamp in ISO 8601 format is included in the request
6. Service provider validates the request and compares it's time with the given timestamp.
8. If the difference in the service provider's time and the client's provided time is within some tolerance
5. The service provider, using the shared secret, creates a signature using the same algorithm on the request it receives
7. If the service provider's signature matches the one included in the request, the request is serviced

### Request Format

Depending on the use-case, for userland facing API the JSON serialization format is preferable as it's human readable and universally implemented in almost all environment

For machine to machine web services where readability is not important, one could opt to use binary serialization format such as Protocol Buffers or Apache Thrift as it is more compact and efficient when compared to the likes of JSON or XML serialization format.

## Section 2

**Prerequisites**

```shell
brew install elixir
```

Run test with

```shell
mix test
```
