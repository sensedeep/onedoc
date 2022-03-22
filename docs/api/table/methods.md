The Table API provides utility methods and low-level data API to manage DynamoDB. The low-level methods are: deleteItem, getItem, putItem, updateItem. Use these methods to do raw I/O on your table. In general, you should prefer the Model APIs that are based on their schema definition and provide a higher level of operation. The model methods are: create, get, find, remove and update.

## addContext

    addContext(context = {})

Add the table `context` properties. The context properties are merged with (overwrite) the existing context.

## addModel

    addModel(name, fields)

Add a new model to a table. This invokes the `Model` constructor and then adds the model to the table. The previously defined `Table` indexes are used for the model.


## batchGet

    async batchGet(operation, params = {})

Invoke a prepared batch operation and return the results. Batches are prepared by creating a bare batch object `{}` and passing that via `params.batch` to the various OneTable APIs to build up a batched operation. Invoking `batch` will execute the accumulated API calls in a batch.

The `batch` parameter should initially be set to `{}` and then be passed to API calls via `params.batch`.

For example:

```javascript
let batch = {}
await Account.get({id: accountId}, {batch})
await User.get({id: userId}, {batch})
let results = await table.batchGet(batch)
```

Set batch params.consistent for a consistent read.

If using params.fields to return a field set, you must provide actual attribute names in the field list and not mapped property names like when using normal Model params.fields.

## batchWrite

    async batchWrite(batch, params = {})

Same as batchGet but for write operations.

## clearContext

    clearContext()

Clear the table context properties. The `Table` has a `context` of properties that are blended with `Model` properties before writing items to the database.


## create

    async create(modelName, properties, params = {})

Create a new item in the database of the given model `modelName` as defined in the table schema.
Wraps the `Model.create` API. See [Model.create](#model-create) for details.


## createTable

    async createTable(params)

Create a DynamoDB table based upon the needs of the specified OneTable schema. The table configuration can be augmented by supplying additional createTable configuration via the `params.provisioned`. See [DynamoDB CreateTable](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB.html#createTable-property) for details.


## deleteItem


    async deleteItem(properties, params = {})

Delete an item in the database. This wraps the DynamoDB `deleteItem` method.

The `properties` parameter is a Javascript hash containing the required keys or fields that are used to create the primary key.

Additional fields supplied in `properties` may be used to construct a filter expression. In this case, a `find` query is first executed to identify the item to remove. Superfluous property fields will be ignored.

The optional params are fully described in [Model API Params](#model-api-params). Some relevant params include:

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression. The properties must include the key attributes if you wish to use `params.prev` for reverse pagination.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.many` is set to true, the API may be used to delete more than one item. Otherwise, for safety, it is assume the API will only remove one item.

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](#where-clauses) for more details.


## deleteTable


    async deleteTable(confirmation)

Delete a DynamoDB table. Because this is a destructive operation, a confirmation string of 'DeleteTableForever' must be provided.


## exists

    async exists()

Test if the table name exists in the database.


## fetch

    async fetch(models, properties, params = {})

Fetch an item collection of items that share the same primary key. Models should be a list of model type names to return. The properties should provide the primary key shared by those model types. The return result is a map with items organized by their model type.

For example:

```javascript
let items = await table.fetch(['User', 'Product'], {pk: 'account:AcmeCorp'})
let users = items.User
let products = items.Product
users.forEach(user => /* operate on user */)
products.forEach(product => /* operate on product */)
```

## find

    async find(modelName, properties, params = {})

Find an item in the database of the given model `modelName` as defined in the table schema. Wraps the `Model.find` API. See [Model.find](#model-find) for details.


## get

    async get(modelName, properties, params = {})

Get an item in the database of the given model `modelName` as defined in the table schema. Wraps the `Model.get` API. See [Model.get](#model-get) for details.


## getContext

    getContext()

Return the current context properties.


## getCurrentSchema

    getCurrentSchema(): OneSchema

Return the schema currently used by the table.


## getLog

    getLog()

Return the current logger object.


## getKeys

    async getKeys()

Return the current primary table and global secondary index keys. Returns a map indexed by index name or 'primary'. The partition key property is named 'hash' and the sort key 'sort'.


## getItem

    async getItem(properties, params = {})

Get an item from the database. This API wraps the DynamoDB `getItem` method.

The `properties` parameter is a Javascript hash containing the required keys or fields that are used to create the primary key.

Additional fields supplied in `properties` may be used to construct a filter expression. In this case, a `find` query is first executed to identify the item to retrieve. Superfluous property fields will be ignored.

The `get` method returns Javascript properties for the item after applying any schema mappings. Hidden attributes will not be returned.

The optional params are fully described in [Model API Params](#model-api-params). Some relevant params include:

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to true, the results will be parsed and mapped into a set of Javascript properties. By default, the unmodified DynamoDB results are returned.

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](#where-clauses) for more details.


## getModel

    getModel(name)

Return a model for the given model name.


## groupByType

    groupByType(items)

Return the items grouped by the configured table typeField property. Returns a map indexed by type name.

## listModels

    listModels()

Return a list of models defined on the `Table`.


## listTables

    async listTables()

Return a list of tables in the database.


## putItem

    async putItem(properties, params = {})

Create an item in the database. This API wraps the DynamoDB `putItem` method.

The `properties` parameter is a Javascript hash containing all the required attributes for the item and must contain the required keys or fields that are used to create the primary key.

OneTable will only write fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored.

The property names are those described by the schema. NOTE: these are not the same as the attribute names stored in the Database. If a schema uses `map` to define a mapped attribute name, the Javascript field name and the DynamoDB attribute name may be different.

The method returns the unmodified DynamoDB `put` response. If `params.parse` is set to true, it will return the Javascript properties created for the item with hidden attributes will not be returned.

Before creating the item, all the properties will be validated according to any defined schema validations and all required properties will be checked. Similarly, properties that use a schema enum definition will be checked that their value is a valid enum value. Encrypted fields will be encrypted transparently before writing.

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to true, the results will be parsed and mapped into a set of Javascript properties. Otherwise, the unmodified DynamoDB response will be returned.


## queryItems

    async queryItems(properties, params)

This API invokes the DynamoDB `query` API and return the results.

The properties should include the relevant key properties.

The sort key may be defined as a key condition by setting the property to an object that defines the condition. The condition operator is specified as the key, and the operand as the value.

These operators may only be used with the sort key property. If the sort key uses a value template, you cannot use the operator on the sort key value directly and not on the properties that are referenced in the value template.

For example:

```javascript
let user = await table.queryItems({pk, sk: {begins: 'user:john'}})
let tickets = await table.queryItems({pk, sk: {between: [1000, 2000]}})
let invoices = await table.queryItems({pk, sk: {'<=': 1000}})
```

The operators include:

```javascript
< <= = <> >= >
begins or begins_with
between
```

<!---
For TypeScript, the OneTable creates strict typings on properties and so special steps are required for {beings}, {between} etc. For TypeScript, OneTable supports tunneling such values via the params. Alternatively, use the `Where Clause` formulation described below. For example:

```typescript
let user = await table.queryItems({pk}, {tunnel: {begins: {sk: 'user:john'}}})
let tickets = await table.queryItems({pk}, {tunnel: {between: {sk: [1000, 2000]}}})
let invoices = await table.queryItems({pk}, {tunnel: {'<=': {sk: 1000}}})
```
-->

**Filter Expressions**

Non-key fields are used to construct a filter expression which is applied by DynamoDB after reading the data but before returning it to the caller. OneTable will utilize fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored in the filter expression.

More complex filter expressions may be created via a `params.where` property. For example:

```javascript
let invoices = await table.queryItems({pk}, {where: '${sk} <= {1000}'})
```

See [Where Clause](#where-clauses) for more details.

If `queryItems` is called without a sort key, `queryItems` will utilize the model type as a sort key prefix and return all matching model items. This can be used to fetch all items that match the primary hash key and are of the specified model type.

The `queryItems` method returns an array of items after applying any schema mappings. Hidden attributes in items will not be returned.


Some useful params for queryItems include:

The `params.index` may be set to the desired index name.

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](#where-clauses) for more details.

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to true, the results will be parsed and mapped into a set of Javascript properties. Otherwise, the unmodified DynamoDB response will be returned.


## readSchema

    async readSchema(): OneSchema

Read the `Current` schema from the table if it has been stored there via `saveSchema`.


## readSchemas

    async readSchemas(): OneSchema[]

Read all stored schemas from the table.


## remove

    async remove(modelName, properties, params = {})

Delete an item in the database of the given model `modelName` as defined in the table schema. Wraps the `Model.remove` API. See [Model.remove](#model-remove) for details.


## removeModel

    removeModel(name)

Remove a model from the current schema in use by the table. This does not impact the persisted schemas.


## removeSchema

    removeSchema(schema)

Remove a schema from the persisted `Table` schema items. The schema should include a `name` property that describes the schema.


## saveSchema

    async saveSchema(schema?: OneSchema): OneSchema

Save the current schema to the table using the _Schema:_Schema hash/sort key pair.

If the schema parameter is null or not provided, the currently configured schema will be saved.
If a schema is provided and the schema.params is unset, the saved schema will include the current Table parms.

## scanItems

    async scanItems(params)

Invokes the DynamoDB `scan` API and return the results.

Some relevant params include:

The `params.where` clause may be used to define a filter expression. This will define a FilterExpression and the ExpressionAttributeNames and ExpressionAttributeValues. See [Where Clause](#where-clauses) for more details.

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to true, the results will be parsed and mapped into a set of Javascript properties. Otherwise, the unmodified DynamoDB response will be returned.

The scan method supports parallel scan where you invoke scan simultaneously from multiple workers. Using the async/await pattern, you can start the workers and then use a Promise.all to wait for their completion.
To perform parallel scans, you should set the `params.segments` to the number of parallel segements and the `params.segment` to the numeric segment to be scaned for that worker.

```javacript
const segments = 4
let promises = []
for (let segment = 0; segment < segments; segment++) {
    promises.push(table.scanItems({}, {segment, segments}))
}
let results = await Promise.all(promises)
```

## setClient

    setClient(client)

Assign an AWS SDK V2 DocumentClient or AWS SDK V3 Dynamo helper client to be used for communiction with DynamoDB. Note the V3 DocumentClient instance is a native AWS SDK DocumentClient instance. For AWS SDK V3, the client is an instance of the OneTable Dynamo helper.

## setContext

    setContext(context = {}, merge = false)

Set the table `context` properties. If `merge` is true, the properties are blended with the existing context.

## setSchema

    async setSchema(schema?: OneSchema)

Set the current schema for the table instance. This will reset the current schema. If the schema parameter contains a schema.params, these will be applied and overwrite the current Table params.

If the schema property is null, the current schema will be removed.


## transact

    async transact(operation, transaction, params = {})

Invoke a prepared transaction and return the results. Transactions are prepared by creating a bare transaction object `{}` and passing that via `params.transaction` to the various OneTable APIs to build up a transactional operation. Finally invoking `transact` will execute the accumulated API calls within a DynamoDB transaction.

The `operation` parameter should be set to `write` or `get`.

The `transaction` parameter should initially be set to `{}` and then be passed to API calls via `params.transaction`.

A `get` operation will return an array containing the items retrieved.

The `Table.groupBy` can be used to organize the returned items by model. E.g.

```javascript
let transaction = {}
await table.get('Account', {id: accountId}, {transaction})
await table.get('User', {id: userId}, {transaction})
let items = await table.transact('get', transaction, {parse: true, hidden: true})
items = table.groupByType(items)
let accounts = items.Account
let users = items.User
```

## update

    async update(modelName, properties, params = {})

Update an item in the database of the given model `modelName` as defined in the table schema. Wraps the `Model.update` API. See [Model.update](#model-update) for details.


## updateItem

    async updateItem(properties, params)

Update an item in the database. This method wraps the DynamoDB `updateItem` API.

The `properties` parameter is a Javascript hash containing properties to update including the required keys or fields that are used to create the primary key.

OneTable will only update fields in `properties` that correspond to the schema attributes for the model. Superfluous property fields will be ignored.

The property names are those described by the schema. NOTE: these are not the same as the attribute names stored in the Database. If a schema uses `map` to define a mapped attribute name, the Javascript field name and the DynamoDB attribute name may be different.

The method returns the unmodified DynamoDB response. If `params.parse` is true, the call returns the Javascript properties for the item with hidden attributes removed.

The optional params are described in [Model API Params](#model-api-params).   

The `params.fields` may be set to a list of properties to return. This defines the ProjectionExpression.

If `params.execute` is set to false, the command will not be executed and the prepared DynamoDB API parameters will be returned.

If `params.parse` is set to true, the results will be parsed and mapped into a set of Javascript properties. Otherwise, the unmodified DynamoDB response will be returned.


## updateTable

    async updateTable(params)

Update a table and create or remove a Global Secondary Index.  

Set `params.create` to an index to create. Set `create` to a map with properties for the `hash` and `sort` attributes. E.g.

```javascript
await table.updateTable({create: {
    hash: 'gs1pk',
    hash: 'gs2pk',
    name: 'gs1',
}})
```
Set `params.remove` to remove an index. Set `remove` to a map with a `name` property of the table to remove. E.g.

```javascript
await table.updateTable({remove: {
    name: 'gs1'
}})
```

## UUID

    uuid()

Internal routine to generate a simple, fast non-cryptographic UUID string. This routine is provided for use in the browser where Node crypto is not availble. The uuid function will generate IDs that have the same format as a UUID v4 string. However they are not crypto-grade in terms of uniqueness nor are they fully compliant in the composition of the UUID sub-components. In general, use `ulid` in preference to `uuid`.

This routine


#### ULID

    ulid()

Generate a [ULID](https://github.com/ulid/spec). Useful when you need a time-based sortable, cryptographic, unique sequential number. This is preferable to using `uuid`.
