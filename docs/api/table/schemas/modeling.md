
OneTable models your application entities via a OneTable schema. The schema defines your table structure, indexes, application entities and their attributes. It specifies how items will be stored to and retrieved from your DynamoDB table.

Here is a sample schema:

```javascript
const MySchema = {
    format: 'onetable:1.1.0',
    version: '0.0.1',
    indexes: {
        primary: { hash: 'pk', sort: 'sk' },
        gs1:     { hash: 'gs1pk', sort: 'gs1sk', follow: true },
        ls1:     { sort: 'id', type: 'local' },
    },
    models: {
        Account: {
            pk:          { type: String, value: 'account:${name}' },
            sk:          { type: String, value: 'account:' },
            id:          { type: String, generate: 'ulid',
                           validate: /^[0123456789ABCDEFGHJKMNPQRSTVWXYZ]{26}$/i },
            name:        { type: String, required: true },
            status:      { type: String, default: 'active' },
            zip:         { type: String },
        },
        User: {
            pk:          { type: String, value: 'account:${accountName}' },
            sk:          { type: String, value: 'user:${email}',
                           validate: EmailRegExp },
            id:          { type: String, required: true },
            accountName: { type: String, required: true },
            email:       { type: String, required: true },
            firstName:   { type: String, required: true },
            lastName:    { type: String, required: true },
            username:    { type: String, required: true },
            role:        { type: String, enum: ['user', 'admin'], required: true,
                           default: 'user' },
            balance:     { type: Number, default: 0 },

            gs1pk:       { type: String, value: 'user-email:${email}' },
            gs1sk:       { type: String, value: 'user:' },
        }
    },
    params: {
        'isoDates': true,
        'timestamps': true,
    },
}
```

For each entity model, you define the entity attributes, their type and other attribute properties such as whether the attribute must be unique or have its value computed from other attributes.

When you invoke the Table constructor, the `schema` property must be set to your schema.

```javascript
import {Table} from 'dynamodb-onetable'

const table = new Table({
    client: DocumentClientInstance,
    name: 'MyTable',
    schema: Schema,
})
```

## Schema Properties

The valid properties of the `schema` object are:

| Property | Type | Description |
| -------- | :--: | ----------- |
| format | `string` | Reserved. Must be set to 'onetable:1.1.0' |
| indexes | `object` | Hash of indexes used by the table. |
| models | `object` | Hash of model entities describing the model keys, indexes and attributes. |
| params | `object` | Hash of properties controlling how data is stored in the table. |
| version | `string` | A SemVer compatible version string. |

The `format` property specifies the schema format version and must be set to `onetable:1.1.0`.

The `indexes` property specifies the key structure for the primary, local and secondary indexes.

The `models` property contains one or more models with attribute field descriptions. The models collections define the attribute names, types, mappings, validations and other properties.

The `params` property defines additional parameters for table data formats.

The `version` property defines a version for your DynamoDB model design. It must be a [SemVer](https://semver.org/) compatible version string. The version string is used by tools and consumers of the schema to understand compatibility constraints for the schema and stored data.


## Schema Models

The schema defines a model for each application entity. For example:

```javascript
{
    album: {
        pk:     { type: String, value: '${_type}:${name}' },
        sk:     { type: String, value: '${_type}:' },
        name:   { type: String, required: true },
        songs:  { type: Number },
    },
    artist: {
        pk:     { type: String, value: '${_type}:${name}' },
        sk:     { type: String, value: '${_type}:' },
        name:   { type: String, required: true },
        address: {
            type: Object, schema: {
                street: { type: String },
                city: { type: String },
                zip: { type: String },
            },
        },
    }
}
```

The name of the entity model is the model map name (album and artist above).

For each model, all the entity attributes are defined by specifying the attribute type, validations and other operational characteristics (uniqueness, IDs and templates).

The valid types are: Array, Binary, Boolean, Buffer, Date, Number, Object, Set and String.

OneTable will ensure that values are of the correct type before writing to the database. Where possible, values will be cast to their correct types. For example: 'false' will be cast to false for Boolean types and 1000 will be cast to '1000' for String types.

These JavaScript types map onto the equivalent DynamoDB types. For Binary types, you can supply data values with the types: ArrayBuffer and Buffer.

For Sets, you should set the schema type to Set and supply values as instances of the JavaScript Set type. DynamoDB supports sets with elements that are strings, numbers or binary data.

OneTable will automatically add a `_type` attribute to each model that is set to the name of the model. However, you can explicitly define your type attribute in your model schema if you wish.

The type field can be used in PK/SK value templates by using `${_type}`. You can change the name of the type field from `_type` by setting the `params.typeField` in the Table constructor.

## Nested Schemas

For object attributes, you can define a nested schema for the object properties, as in the example above (repeated below).

A nested schema uses the `schema` property to define a nested map of attributes.

```javascript
        address: {
            type: Object, schema: {
                street: { type: String },
                city: { type: String },
                zip: { type: String },
            },
        },
```
