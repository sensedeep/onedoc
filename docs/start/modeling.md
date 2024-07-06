
OneTable models your application entities via a OneTable schema that defines models for your entities and
specifies how data items will indexed in your database.

Schemas are defined in JSON and are passed to your OneTable Table constructor at initialization time.

Schemas can also be created and managed by tools such as the [SenseDeep DynamoDB Studio](https://www.sensedeep.com). When SenseDeep authors a schema, it will save the schema to your DynamoDB table and will generate the JSON for use by the OneTable Table constructor.

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
            pk:          { type: String, value: 'account#${name}' },
            sk:          { type: String, value: 'account#' },
            id:          { type: String, generate: 'ulid', validate: /^[0123456789ABCDEFGHJKMNPQRSTVWXYZ]{26}$/i },
            name:        { type: String, required: true },
            status:      { type: String, default: 'active' },
            zip:         { type: String },
        },
        User: {
            pk:          { type: String, value: 'account#${accountName}' },
            sk:          { type: String, value: 'user#${email}', validate: EmailRegExp },
            id:          { type: String, required: true },
            accountName: { type: String, required: true },
            email:       { type: String, required: true, encode: 'sk' },
            firstName:   { type: String, required: true },
            lastName:    { type: String, required: true },
            username:    { type: String, required: true },
            role:        { type: String, enum: ['user', 'admin'], required: true, default: 'user' },
            balance:     { type: Number, default: 0 },

            gs1pk:       { type: String, value: 'user-email#${email}' },
            gs1sk:       { type: String, value: 'user#' },
        }
    },
    params: {
        'isoDates': true,
        'separator': '#',
        'timestamps': true,
    },
}
```

The OneTable schema is passed to your table constructor via the `schema` property.

```javascript
const table = new Table({
    client: client,
    name: 'MyTable',
    schema: MySchema,
})
```

See the [API Schemas](../../schemas/overview/) for full details about creating your schema.
