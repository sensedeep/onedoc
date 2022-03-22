The `crypto` property defines the configuration used to encrypt and decrypt attributes that specify `encrypt: true` in their schema. This is useful as an additional layer of security for passwords, keys and other especially sensitive information. The crypto property should be set to a hash that contains the `cipher` to use and an encryption secret/password.

```javascript
{
    "cipher": "aes-256-gcm",
    "password": "16719023-772f-133d-1111-aaaa7722188f"
}
```
