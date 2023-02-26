The `schema.params` is a hash map of properties that control how data is stored. It may contain the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| createdField | `string` | Name of the "created" timestamp attribute. Defaults to "created". |
| hidden | `boolean` | Hide templated (value) attributes in Javascript properties. Default true. |
| isoDates | `boolean` | Set to true to store dates as Javascript ISO strings vs epoch numerics. Default false. |
| nulls | `boolean` | Store nulls in database attributes vs remove attributes set to null. Default false. |
| timestamps | `boolean | string` | Make "created" and "updated" timestamps in items. Set to true to create both. Set to 'create' for only "created" timestamp and set to "update" for only an "updated" timestamp. See below for more details. Also see: "updatedField" and "createdField" properties. Default false. |
| typeField | `string` | Name of the "type" attribute. Default "_type". |
| updatedField | `string` | Name of the "updated" timestamp attribute. Default "updated". |

For example:

```javascript
const MySchema = {
    params: {
        isoDates: true,
        timestamps: true,
    }
}
```

## Timestamps

Created and updated timestamps can be automatically added to items. If the schema timestamps param is set to true, a `created` and `updated` date timestamp will be added to items during **create** or **update** API calls. 

If using TypeScript, you should define the created and updated fields in your data model so that the returned items match your TypeScript definitions. If using JavaScript, it is optional if you wish to define them in your model.

The name of the `created` and `updated` fields can be modified via the schema param `createdField` and `updatedField`.

If you need to manually modify a created or updated timestamp, you can disable automatic timestamps by setting the API `timestamps` param to false. For example:

```javascript
props.updated = new Date('2023-02-26T23:23:14.752Z')
await User.update(props, {timestamps: false})
```
