The optional Table `validate` function will be invoked on requests to enable property validation before writing to the table.
The invocation signature is:

```javascript
details = validate(model, properties, params)
```

The validation function must return a map of validation messages for properties that fail validation checks. The map is indexed by the property field name.
