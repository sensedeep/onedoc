The `Model` class represents an entity (item) in the database and is the primary data access API for OneTable.

Model APIs take a [params](../params/) parameter that configures and controls the API execution.

API errors will throw an instance of the `OneTableError` error class. See [Error Handling](../../errors/) for more details.

## create

    async create(properties, params = {})

Create an item in the database. This API wraps the DynamoDB `putItem` method.

The `properties` parameter is a Javascript hash containing all the required attributes for the item and must contain the required keys or fields that are used to create the primary key.

OneTable will only write fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored.

The property names are those described by the schema. NOTE: these are not the same as the attribute names stored in the Database. If a schema uses `map` to define a mapped attribute name, the Javascript field name and the DynamoDB attribute name may be different.

The method returns the Javascript properties created for the item. Hidden attributes will not be returned.

Before creating the item, all the properties will be validated according to any defined schema validations and all required properties will be checked. Similarly, properties that use a schema enum definition will be checked that their value is a valid enum value. Encrypted fields will be encrypted transparently before writing.

For create, the params.exists will default to a false value to ensure an item of the same key does not already exist. If set to null, a create will be allowed to overwrite an existing item.

### Unique Fields

If the schema specifies that an attribute must be unique, OneTable will create a special item in the database to enforce the uniqueness. This item will be an instance of the Unique model with the primary key set to `_unique#Scope#Model#Attribute#Value`. The created item and the unique item will be created in a transparent transaction so that the item will be created only if all the unique fields are truly unique.  The `remove` API will similarly remove the special unique item.

A property may be be unique with a defined domain via the "scope" model schema property. The scope template will be expanded at runtime and the scope value will be incorporated into the unique attribute. This is useful to ensure an attribute is unique within a reduced domain. For example, you may want an item to be unique only within a given user's account instead of over all accounts. To achieve this, set the scope to be the user's ID.

When a unique field for an item is updated, the prior item value must be read first so that the unique item can be deleted. By default, updates() on an item with unique fields will not return a value and will issue a warning to the console. This is because DynamoDB transactions do not return the updated items. If you do an update and specify {return: 'NONE'} the warning will be squelched. If you must return the full updated item, use {return: 'get'} to fetch the updated values.

The optional params are described in [Model API Params](../params).

<a name="model-find"></a>

## find

    async find(properties, params = {})

Find items in the database. This API wraps the DynamoDB `query` method.

The `properties` parameter is a Javascript hash containing the required keys or fields that are used to determine the primary key or keys.

The sort key may be defined as a simple value or as a key condition by setting the property to an object that defines the condition. The condition operator is specified as the key, and the operand as the value. For example:

```javascript
let user = await User.find({pk, sk: {begins: 'user:john'}})
let tickets = await Ticket.find({pk, sk: {between: [1000, 2000]}})
let invoices = await Invoice.find({pk, sk: {'<=': 1000}})
let invoices = await Invoice.find({pk}, {where: '${sk} <= {1000}'})

let items = await Invoice.find({pk}, {where: '${sk} <= {1000}'}, {count: true})
let count = items.count
```

The operators include:

```javascript
< <= = >= >
begins or begins_with
between
```

Additional fields supplied in `properties` are used to construct a filter expression which is applied by DynamoDB after reading the data but before returning it to the caller. OneTable will utilize fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored in the filter expression.

More complex filter expressions may be created via a `params.where` property. For example:

```javascript
let adminUsers = await User.find({}, {
    where: '(${role} = {admin}) and (${status} = {current})'
})
```

Use `params.count` set to true to return the number of matching items instead of returning the items.

See [Where Clause](../where/) for more details.

If `find` is called without a sort key on a model that has a sort key value template, OneTable will synthesize a sort key value using the leading portion of the sort key value template. For example, if the sort key is defined as:

```javascript
Card: {
    sk: { type: String, value: 'card:${id}' }
}
```

then, OneTable will use a `begins_with card:` key condition expression. This will also work if you use `${_type}` as the leading prefix.

Without the ingredient properties needed calculate the sort key from its value template, `find` will synthesize a sort key using the leading portion utilize the model type as a sort key prefix and return all matching model items. This can be used to fetch all items that match the primary hash key and are of the specified model type.

The `find` method returns an array of items after applying any schema mappings. Hidden attributes in items will not be returned.


### Pagination

The `find` method will automatically invoke DynamoDB query to fetch additional items and aggregate the result up to the limit specified by `params.limit`. If the limit is exceeded, the last key fetched is set in the **result.next** property of the returned array of items. You can provide this as `params.next` to a subsequent API call to continue the query with the next page of results.


```typescript
let next
do {
    let items = await User.find({accountId}, {limit: 10, next})
    //  process items
    next = items.next
} while (next)
```

To scan backwards, set Params.reverse to true.

The keys for the first item are returned in `params.prev` which can be used to retrieve the previous page.

```typescript
let firstPage = await User.find({accountId}, {limit})
let secondPage = await User.find({accountId}, {limit, next: firstPage.next})
let previousPage = await User.find({accountId}, {limit, prev: secondPage.prev})
```

Note: the limit is the number of items read by DynamoDB before filtering and thus may not be equal to the number of items returned if you are using filtering expressions.

The optional params are fully described in [Model API Params](../params). Some relevant params include:

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned. However, if set on an update that has a unique field, the commands will not be returned. This is because and update with a unique field requires a transaction and multiple commands. In this case, setting execute: true will cause the command to not be executed as expected, but the the proposed commands will not be returned. To see the commands, set the parmas.log to true to log the commands to the console.

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If the `params.follow` is set to true, each item will be re-fetched using the returned results. This is useful for KEYS_ONLY secondary indexes where OneTable will use the retrieved keys to fetch all the attributes of the entire item using the primary index. This incurs an additional request for each item, but for large data sets, it enables the transparent use of a KEYS_ONLY secondary index which may greatly reduce the size (and cost) of the secondary index.

The `params.limit` specifies the maximum number of items for DynamoDB to read. The `params.next` defines the start point for the returned items. It is typically set to the last key returned from previous invocation via the `result.next` property. Note: the limit is the number of items DynamoDB reads before filtering.

The `params.maxPages` specifies the maximum number of DynamoDB query requests that OneTable will perform for a single API request.
When doing a find or query with a filter expression, DynamoDB may scan up to 1MB and may return no items. Find will re-issue the API following the next key to retrieve the set of results. A maxPages limit will define the maximum number of times Find will query DynamoDB for another chunk of results.

If `params.parse` is set to false, the unmodified DynamoDB response will be returned. Otherwise the results will be parsed and mapped into a set of Javascript properties.

If `params.next` or `params.prev` is set to a map that contains the primary hash and sort key values for an existing item, the query will commence at that item. The `params.next` will be the exclusive start of the query, whereas `params.prev` will define the end of the query. These two properties are mutually exclusive, both of them can't be set at the same time.

The `params.where` clause may be used to augment the filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](../where/) for more details.


<a name="model-get"></a>

## get

    async get(properties, params = {})

Get an item from the database. This API wraps the DynamoDB `getItem` method.

The `properties` parameter is a Javascript hash containing the required keys or fields that are used to create the primary key.

Additional fields supplied in `properties` may be used to construct a filter expression. In this case, a `find` query is first executed to identify the item to retrieve. Superfluous property fields will be ignored.

The `get` method returns Javascript properties for the item after applying any schema mappings. Hidden attributes will not be returned.

The optional params are fully described in [Model API Params](../params). Some relevant params include:

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If the `params.follow` is set to true, the item will be re-fetched using the retrieved keys for the item. This is useful for KEYS_ONLY secondary indexes where OneTable will use the retrieved keys to fetch all the attributes of the item using the primary index. This incurs an additional request, but for very large data sets, it enables the transparent use of a KEYS_ONLY secondary index which reduces the size of the database.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to false, the unmodified DynamoDB response will be returned. Otherwise the results will be parsed and mapped into a set of Javascript properties.

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](../where/) for more details.

<a name="model-init"></a>

## init

    async init(properties, params = {})

Return a constructed model item without writing to the database. This will return an object with all the model properties set to null including default properties, UUID properties and value template properties. Be careful using these objects with create() as you should define values for all attributes.

<a name="model-remove"></a>

## remove

    async remove(properties, params = {})

Remove an item from the database. This wraps the DynamoDB `deleteItem` method.

The `properties` parameter is a Javascript hash containing the required keys or fields that are used to create the primary key.

Additional fields supplied in `properties` may be used to construct a filter expression. In this case, a `find` query is first executed to identify the item to remove. Superfluous property fields will be ignored.

The optional params are fully described in [Model API Params](../params). Some relevant params include:

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.many` is set to true, the API may be used to delete more than one item. Otherwise, for safety, it is assume the API will only remove one item.

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](../where/) for more details.

This API does not return a result. To test if the item was actually removed, set `params.exists` to true and the API will throw an exception if the item does not exist.


<a name="model-scan"></a>

## scan

    async scan(properties, params = {})

Scan items in the database and return items of the given model type. This wraps the DynamoDB `scan` method and uses a filter expression to extract the designated model type. Use `scanItems` to return all model types. NOTE: this will still scan the entire database.

An alternative to using scan to retrieve all items of a give model type is to create a GSI and index the model `type` field and then use `query` to retrieve the items. This index can be a sparse index if only a subset of models are indexed.

The `properties` parameter is a Javascript hash containing fields used to construct a filter expression which is applied by DynamoDB after reading the data but before returning it to the caller. OneTable will utilize fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored in the filter expression.

The `scan` method returns an array of items after applying any schema mappings. Hidden attributes in items will not be returned.

The optional params are fully described in [Model API Params](../params). Some relevant params include:

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

The `params.where` clause may be used to augment the filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](../where/) for more details.

The scan method supports parallel scan where you invoke scan simultaneously from multiple workers. Using the async/await pattern, you can start the workers and then use a Promise.all to wait for their completion.
To perform parallel scans, you should set the `params.segments` to the number of parallel segements and the `params.segment` to the numeric segment to be scaned for that worker.

```javacript
const segments = 4
let promises = []
for (let segment = 0; segment < segments; segment++) {
    promises.push(table.scan({}, {segment, segments}))
}
let results = await Promise.all(promises)
```

<a name="model-template"></a>

## template

    async template(fieldName, properties)

Return the evaluated field value template based on the given properties. This is a utility routine to manually evaluate value templates.

<a name="model-update"></a>

## update

    async update(properties, params = {})

Update an item in the database. This method wraps the DynamoDB `updateItem` API.

The `properties` parameter is a Javascript hash containing properties to update including the required keys or fields that are used to create the primary key.

OneTable will only update fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored.

The property names are those described by the schema. NOTE: these are not the same as the attribute names stored in the Database. If a schema uses `map` to define a mapped attribute name, the Javascript field name and the DynamoDB attribute name may be different.

The method returns the all the Javascript properties for the item. Hidden attributes will not be returned.

If the method fails to update, it will throw an exception. If `params.throw` is set to false, an exception will not be thrown and the method will return `undefined`.

The optional params are described in [Model API Params](../params).    

The `params.add` parameter may be set to a value to add to the property.
The `params.delete` parameter may be set to a hash, where the hash keys are the property sets to modify and the values are the items in the sets to remove.
The `params.remove` parameter may be set to a list of properties to remove.
The `params.set` parameter may be set to a hash, where the hash keys are the properties to modify and the values are expresions.

The `params.return` parameter may be set to 'NONE' to return no result or 'get' to perform a transparent get() call to retrieve the updated item. Normally, update() will return the updated item automatically, however, it the item has unique attributes, a transaction is used which does not return the updated item. In this case, use {return: 'get'} to retrieve and return the updated item.

The propertys provided to params.add, delete, remove and set are property names (not mapped attribute names).

If a property is specified in the API `properties` first argument and the property is also set in params.set, params.delete, params.remove or params.add, then the params.* property value takes precedence.

For example:

```javascript
await User.update({id: userId}, {delete: {tokens: ['captain']}})
await User.update({id: userId}, {remove: ['special', 'suspended']})
await User.update({id: userId}, {set: {balance: '${balance} + {100}'}})
await User.update({id: userId}, {
    set: {contacts: 'list_append(if_not_exists(contacts, @{empty_list}), @{newContacts})'},
    substitutions: {newContacts: ['+15555555555'], empty_list: []}
})
```

In update, the params.exists will default to a true value to ensure the item exists. If set to null, an update will be permitted to create an item if it does not already exist. This implements an "upsert" operation.

In this case, you must provide values for all properties that are required for a create.
