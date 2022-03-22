
The `Model` class represents an application entity that is modeled according to your OneTable schema. With one-table design patterns, multiple entities items are stored in a single DynamoDB table and are distinguished by unique primary keys and a `type` attribute that designates the model type. The schema specifies the entity attributes and keys and the Model instance is the mechanism by which you interact with specific entities in your table.

Models are defined via the Table `schema` definition and model instances are created using the Table.getModel(name) method.

```javascript
let User = table.getModel('User')
```

Where `table` is a configured instance of `Table`. Name is the name of the model.

In TypeScript, use the following pattern to return a fully typed model:

```typescript
type UserType = Entity<typeof Schema.models.User>
let User = table.getModel<UserType>('User')
```

Thereafter, the references to User instances will be fully type checked. Note: you must add "as const" to the end of your models after the closing brace.

## Model Constructor

The model constructor is an internal method and you should not normally construct model instances directly.

The Model constructor `options` are:

| Property | Type | Description |
| -------- | :--: | ----------- |
| fields | `object` | Field attribute definitions. Same format as in the Table `schema` |
| indexes | `object` | Index definition. Same format as in the Table `schema` |
| timestamps | `boolean` | Make "created" and "updated" timestamps in items |
