Most `Model` APIs and some `Table` APIs accept a `params` hash argument that controls the API operation.

## Params

These are the parameter values for the `params` argument.

| Property | Type | Description |
| -------- | :--: | ----------- |
| add | `object` | Used to atomically add a value to an attribute. Set to an object containing the attribute name and value to add. Example: add: {balance: 1}|
| batch | `object` | Accumulated batched API calls. Invoke with `Table.batch*`|
| capacity | `string` | Set to `INDEXES`, `TOTAL`  or `NONE` to control the capacity metric. Returned in items.capacity|
| client | `object` | Set to a DynamoDB DocumentClient instance to overide the table default client. Defaults to null|
| consistent | `boolean` | Set to true to stipulate that consistent reads are required.|
| context | `object` | Optional context hash of properties to blend with API properties when creating or updating items. This overrides the Table.context. Setting to `{}` is a useful one-off way to ignore the context for this API. |
| count | `boolean` | Return a count of matching items instead of the result set for a find/query. The count is returned as a `count` property in the returned items array. Default false. |
| delete | `object` | Used to delete items from a `set` attribute. Set to an object containing the attribute name and item to delete. Example: delete: {colors: 'blue'}|
| execute | `boolean` | Set to true to execute the API. If false, return the formatted command and do not execute. Note: if set on an update of a unique field which requires a transaction and multiple commands, the commands will not be returned. To see the commands, set the parmas.log to true. Execute defaults to true.|
| exists | `boolean` | Set to true for `create`, `delete` or `update` APIs to verify if an item of the same key exists or not. Defaults to false for `create`, null for `delete` and true for `update` Set to null to disable checking either way.|
| fields | `array` | List of properties to return. This sets the ProjectionExpression. Default null. |
| follow | `boolean` | Refetch the item using the returned keys to retrieve the full item. Useful for indexes that are KEYS_ONLY. Default null. |
| hidden | `boolean` | Return hidden attributes in Javascript properties. Default Table params.hidden. |
| index | `string` | Name of index to utilize. Defaults to 'primary'|
| limit | `number` | Set to the maximum number of items to return from a find / scan.|
| log | `boolean` | Set to true to force the API call to be logged at the 'data' level. Requires that a 'logger' be defined via the Table constructor. Defaults to false.|
| many | `boolean` | Set to true to enable deleting multiple items. Default to false.|
| next | `object` | Starting key for the result set. This is used to set the ExclusiveStartKey when doing a find/scan. Typically set to the result.next value returned on a previous find/scan. |
| prev | `object` | Starting key for the result set when requesting a previous page. This is used to set the ExclusiveStartKey when doing a find/scan in reverse order. Typically set to the result.prev value returned on a previous find/scan.|
| parse | `boolean` | Parse DynamoDB response into native Javascript properties. Defaults to true.|
| partial | `boolean` | Allow partial object updates for this API call. This overrides any field schema, or Table constructor "partial" definitions. Default is null. |
| postFormat | `function` | Hook to invoke on the formatted API command just before execution. Passed the `model` and `cmd`, expects updated `cmd` to be returned. Cmd is an object with properties for the relevant DynamoDB API.|
| remove | `array` | Set to a list of of attributes to remove from the item.|
| reprocess | `boolean` | Set to true to enable batchWrite to retry unprocessed items. Defaults to true|
| return | string | Controls the returned values for create() and update() via the ReturnValues DynamoDB API parameter. Set to true, false or 'ALL_NEW', 'ALL_OLD', 'NONE', 'UPDATED_OLD' or 'UPDATED_NEW'. The value true, is an alias for ALL_NEW. The value false is an alias for 'NONE'. The create() API defaults to 'ALL_NEW'. The update() API defaults to 'ALL_NEW' unless the item has unique properties the return parameter must be specified. For update() calls on items that have unique attributes defined in the schema, you can set to 'get' to perform a transparent get() to retrieve the updated item. This is necessary as updating unique items uses transactions which do not return the updated value. |
| reverse | `boolean` | Set to true to reverse the order of items returned.|
| select | `string` | Determine the returned attributes. Set to ALL_ATTRIBUTES | ALL_PROJECTED_ATTRIBUTES | SPECIFIC_ATTRIBUTES | COUNT. Note: recommended to use params.count instead of COUNT. Default to ALL_ATTRIBUTES. |
| set | `object` | Used to atomically set attribute vaules to an expression value. Set to an object containing the attribute names and values to assign. The values are expressions similar to Where Clauses with embedded ${attributeReferences} and {values}. See [Where Clause](#where-clauses) for more details. |
| stats | `object` | Set to an object to receive performance statistics for find/scan. Defaults to null.|
| substitutions | `object` | Variables that can be referenced in a where clause. Values will be added to ExpressionAttributeValues when used.|
| throw | `boolean` | Set to false to not throw exceptions when an API request fails. Defaults to true.|
| transaction | `object` | Accumulated transactional API calls. Invoke with `Table.transaction` |
| type | `string` | Add a `type` condition to the `create`, `delete` or `update` API call. Set `type` to the DynamoDB required type.|
| where | `string` | Define a filter or update conditional expression template. Use `${attribute}` for attribute names, `@{var}` for variable substitutions and `{value}` for values. OneTable will extract attributes and values into the relevant ExpressionAttributeNames and ExpressionAttributeValues.|

## Stats

If `stats` is defined, find/query/scan operations will return the following statistics in the stats object:

* count -- Number of items returned
* scanned -- Number of items scanned
* capacity -- DynamoDB consumed capacity units

## Transformations

The `transform` property may be used to format data prior to writing into the database and parse it when reading back. This can be useful to convert to alternate data representations in your table. The transform signature is:

```javascript
value = transform(model, operation, name, value, properties)
```

The `operation` parameter is set to `read` or `write`. The `name` argument is set to the field attribute name.
