# JSON web tokens

Coming Soon.

```
      jwt_auth_domain:
        enabled: false
        order: 0
        http_authenticator:
          type: jwt
          challenge: false
          config:
            signing_key: "base64 encoded key"
            jwt_header: "Authorization"
            jwt_url_parameter: null
            roles_key: null
            subject_key: null
        authentication_backend:
          type: noop
```          

## Authentication backend

Since JWT authenticates a user on HTTP level, no additional `authentication_backend` is needed, hence it can be set to `noop`.