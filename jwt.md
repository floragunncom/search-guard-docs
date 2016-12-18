<!---
Copryight 2016 floragunn GmbH
-->

# JSON web tokens

## Token based authentication

JSON Web Tokens (JWT) are JSON-based access tokens that assert one or more claims. They are commonly used to implement Single-Sign-On solutions and fall in the category of token based authentication system:

* A user logs in to an application by providing credentials, e.g. username and password
* The application validates the credentials
* The application creates an access token and signs it
* The application returns the token to the user
* The user stores the access token
* The user sends the access token along with every request
* The server verifies the user by verifying the sent token

You can read more about token based authentication [in this blog post.](https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication)

## JSON web tokens

A JSON web token is self-contained in the sense that it carries all necessary information within itself. The tokens are basically Base64-encoded and signed JSON objects, so the can be passed around easily

A JSON web token consists of three parts:

* Header
* Payload
* Signature

### Header

The header contains information about the used signing mechanism, for example:

```
{
  "alg": "HS256",
  "typ": "JWT"
} 
```

In this case, the header states that the message was signed using HMAC-SHA256.

### Payload

The payload of a JSON web token contains the so-called [JWT Claims](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#RegisteredClaimName). A claim can be any piece of information that the application who created the token has verified.

The specification defines a set of standard claims with reserved names ("registered claims"). These include for example the issuer of the token, the expiration date of the token or the creation date of the token.

Public claims can be created freely by the issuer of the token, and can contain arbitrary information such as the user name and the roles of the user.

Example:

```
{
  "iss": "floragunn.com",
  "exp": 1300819380,
  "name": "John Doe",
  "roles": "admin, devops"
}
```
### Signature

The issuer of the token now calculates the signature of the token by using a cryptographic hash function and a secret key over the base-64 encoded header and payload. These three parts are then concatenated via a `.` sign. We now have a complete JSON web token:


```
encoded = base64UrlEncode(header)  + "." + base64UrlEncode(payload)
signature = HMACSHA256(encoded, 'secretkey');
jwt = encoded + "." + base64UrlEncode(signature)
```

For example:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dnZWRJbkFzIjoiYWRtaW4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCzcmJmMjLiuyu5CSpyHI
```

## Configuring JWT support in Search Guard

In order to use JWT, set up an security domain and choose `jwt` as HTTP authentication type. Since the tokens already contain all required information to verify the request, `challenge` must be set to `false`.

Example:

```
jwt_auth_domain:
  enabled: true
  order: 0
  http_authenticator:
    type: jwt
    challenge: false
    config:
      signing_key: "base64 encoded key"
      jwt_header: "Authorization"
      jwt_url_parameter: null
      subject_key: null
      roles_key: null
  authentication_backend:
I    type: noop
```          

Configuration parameter:

| Name  | Description  |
|---|---|
| signing_key  |  The base64-encoded secret key that the issuer of the token used to sign the message. This is a shared secret between the token issuer and Search Guard. |
|  jwt\_header |  The HTTP header in which the token is stored. This is typically the `Authentication` header with the `Bearer` schema:  `Authorization: Bearer <token>`. Default is `Authentication`.|
| jwt\_url\_parameter  | If the token is not transmitted in the HTTP header, but as an URL parameter, define the name of this parameter here.  |
| subject_key  | The key in the JSON payload that stores the users name. If not defined, the [subject](https://tools.ietf.org/html/rfc7519#section-4.1.2) registered claim is taken.|
| roles_key  | The key in the JSON payload that stores the users roles. The value of this key must be a comma-separated list of roles. |

Since JSON web tokens are self-contained and the user is authenticated on HTTP level, no additional `authentication_backend` is needed, hence it can be set to `noop`.

## Supported formats and algorithms

The following JWT types are supported: 

* Creating and parsing plaintext compact JWTs 
* Creating, parsing and verifying digitally signed compact JWTs (aka JWSs) with all standard JWS algorithms: 

```
HS256: HMAC using SHA-256 
HS384: HMAC using SHA-384 
HS512: HMAC using SHA-512 
RS256: RSASSA-PKCS-v1_5 using SHA-256 
RS384: RSASSA-PKCS-v1_5 using SHA-384 
RS512: RSASSA-PKCS-v1_5 using SHA-512 
PS256: RSASSA-PSS using SHA-256 and MGF1 with SHA-256 
PS384: RSASSA-PSS using SHA-384 and MGF1 with SHA-384 
PS512: RSASSA-PSS using SHA-512 and MGF1 with SHA-512 
ES256: ECDSA using P-256 and SHA-256 
ES384: ECDSA using P-384 and SHA-384 
ES512: ECDSA using P-521 and SHA-512 
```

## Validated registered claims

The following registered claims are validated:

* "iat" (Issued At) Claim
* "nbf" (Not Before) Claim
* "exp" (Expiration Time) Claim

## Misc

* "sub" (Subject) Claim
 * If no `subject_key` is defined, the value of the  [`sub`](https://tools.ietf.org/html/rfc7519#section-4.1.2)  claim is used as username.