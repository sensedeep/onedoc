Value templates are defined in the schema for model fields. These are typically literal strings with property variable references. In some use cases, more complex logic for a value template requires a function to calculate the property value at runtime. The Table constructor params.value function provides a centralized place to evaluate value templates. It will be invoked for fields that define their value template to be `true`.

The value template function is called with the signature:

```javascript
str = value(model, fieldName, properties, params)
```

The value template should return a string to be used for the given fieldName. The `properties` and `params` are corresponding arguments given to the API.
