The optional Table `transform` function will be invoked on read and write requests to transform data before reading or writing to the table. The transform function can be used for custom storage formats or to assist with data migrations. The transform function can modify the item as it sees fit and return the modified item. The invocation signature is:

```javascript
item = transform(model, operation, item, properties, params, raw)
```

Where `operation` is set to 'read' or 'write'. The `params` and `properties` are the original params and properties provided to the API call. When writing, the `item` will contain the already transformed properties by the internal transformers. You can overwrite the value in `item` using your own custom transformation logic using property values from `properties`.

When reading, the `item` will contain the already transformed read data and the `raw` parameter will contain the raw data as read from the table before conversion into Javascript properties in `item` via the internal transformers.

You can also use a `params.transform` with many Model APIs. See [Model API Params](#model-api-params) for details.
