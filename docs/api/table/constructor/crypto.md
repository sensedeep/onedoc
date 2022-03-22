OneTable can apply additional encryption for sensitive data fields such as email addresses, credit card information or other PII.
This is useful as an additional layer of security for passwords, keys and other especially sensitive information.

While Amazon does encrypt the data at rest internally, this additional encryption safeguards backups and should Amazon ever make a mistake with your data.

The crypto property should be set to a hash that contains the `cipher` to use and an encryption secret/password.

The Table constructor `crypto` property defines the configuration used to encrypt and decrypt attributes that specify `encrypt: true` in their schema.

```javascript
{
    "cipher": "aes-256-gcm",
    "password": "16719023-772f-133d-1111-aaaa7722188f"
}
```
