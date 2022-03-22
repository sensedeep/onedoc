The `schema.models` property contains one or more models with attribute field descriptions. The models collections define the attribute names, types, mappings, validations and other properties. For example:

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

The name of the entity model is model map name (album and artist above).

The valid types are: Array, Binary, Boolean, Buffer, Date, Number, Object, Set and String.

OneTable will ensure that values are of the correct type before writing to the database. Where possible, values will be cast to their correct types. For example: 'false' will be cast to false for Boolean types and 1000 will be cast to '1000' for String types.

These JavaScript types map onto the equivalent DynamoDB types. For Binary types, you can supply data values with the types: ArrayBuffer and Buffer.

For Sets, you should set the schema type to Set and supply values as instances of the JavaScript Set type. DynamoDB supports sets with elements that are strings, numbers or binary data.

OneTable will automatically add a `_type` attribute to each model that is set to the name of the model. However, you can explicitly define your type attribute in your model schema if you wish.

The type field can be used in PK/SK value templates by using `${_type}`. You can change the name of the type field from `_type` by setting the `params.typeField` in the Table constructor.
