# Thrurl - Thrift meets cURL

A small utility for accessing [Thrift](http://en.wikipedia.org/wiki/Apache_Thrift) services from the command line, without having to write a service-specific client. Useful for debugging purposes, trying out services, writing integration tests, etc.

## Dependencies

You need to have [`thrift`](http://thrift.apache.org/) installed. You also need to have the IDL files (`.thrift`) related to the service you want to call. Thrurl will compile them into Ruby code and parse your parameters to match the expected types automatically.

## How to use

Thrurl is a command line client, much like cURL. Using it is simple:

```
thrurl -h "my-thrift-server" -p 5000 -m "checkinsPerLocation" -s "CheckinService" -a "{ user: { id: 1 } }"

```

Thrurl will parse the response and display it in JSON format (in case you want to use the output of the script, and because it's a nice human readable format).