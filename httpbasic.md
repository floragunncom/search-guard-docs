<!---
Copryight 2016 floragunn GmbH
-->

## Installation

Search Guard already ships with HTTP Basic Authentication, no additional installation steps are required.

# HTTP Basic Authentication

In order to set up HTTP Basic authentication, you just need to enable it in the http_authenticator section of the configuration:

```
http_authenticator:
  type: basic
  challenge: true
```

In most cases, you will want to set the `challenge` flag to `true`. The flag defines the behaviour of Search Guard, if the `Authorization` field in the HTTP header is not set:

If `challenge` is set to `true`, Search Guard will send a response with status `UNAUTHORIZED` (401) back to the client, and set the `WWW-Authenticate` header to `Basic realm="Search Guard"`. If the client is accessing the Search Guard secured cluster with a browser, this will trigger the authentication dialog and the user is prompted to enter username and password. 

If `challenge` is set to `false`, and no `Authorization` header field is set, Search Guard will **not** sent a `WWW-Authenticate` response back to the client, and authentication will fail. You may want to use this setting if you have another challenge `http_authenticator` in your configured authentication domains (Note that there can only be one challenge authenticator).  One such scenario is when you plan to use Basic Authentication and Kerberos together, and set Kerberos to `challenge: true`. In that case, you can still use Basic Authentication, but only with pre-authenticated requests.
