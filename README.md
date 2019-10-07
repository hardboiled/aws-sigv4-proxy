# AWS SigV4 Proxy

This is a modified version of the [AWS SigV4 Proxy](https://github.com/awslabs/aws-sigv4-proxy). The changes of this fork are as follows:
1. added a self-signed certificate
1. modified server to listen over HTTPS, and
1. updated host to be passed up-front as a command line argument, so host headers aren't required.

The primary motivation of these changes were to allow for access of Kibana on AWS-hosted ElasticSearch as a service within a VPC.

> :memo: *Note that when using this proxy, `/_plugin/kibana` route for ElasticSearch will `403` instead of `302`'ing as normal. A workaround for this is to access the redirected route directly `/_plugin/kibana/app/kibana`, which works fine.* It's not clear why this behavior occurs.

## Getting Started

Build and run the Proxy

```go
The proxy uses the default AWS SDK for Go credential search path:

* Environment variables.
* Shared credentials file.
* IAM role for Amazon EC2 or ECS task role

More information can be found in the [developer guide](https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/configuring-sdk.html)

docker build -t aws-sigv4-proxy .

# Env vars
docker run --rm -ti \
  -e 'AWS_ACCESS_KEY_ID=<YOUR ACCESS KEY ID>' \
  -e 'AWS_SECRET_ACCESS_KEY=<YOUR SECRET ACCESS KEY>' \
  -p 8080:8080 \
  aws-sigv4-proxy -v <remote_host_to_proxy_to>

# Shared Credentials
docker run --rm -ti \
  -v ~/.aws:/root/.aws \
  -p 8080:8080 \
  -e 'AWS_PROFILE=<SOME PROFILE>' \
  aws-sigv4-proxy -v <remote_host_to_proxy_to>
```

## Examples

You can use the same examples as in the [AWS SigV4 Proxy](https://github.com/awslabs/aws-sigv4-proxy#examples), except pass the value of the host header to the `docker run` command as shown in the previous section, instead of passing it as a header to `curl`.

## License

This library is licensed under the Apache 2.0 License.
