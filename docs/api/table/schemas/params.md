The `schema.params` is a hash map of properties that control how data is stored. It may contain the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| createdField | `string` | Name of the "created" timestamp attribute. Defaults to "created". |
| hidden | `boolean` | Hide templated (value) attributes in Javascript properties. Default true. |
| isoDates | `boolean` | Set to true to store dates as Javascript ISO strings vs epoch numerics. Default false. |
| nulls | `boolean` | Store nulls in database attributes vs remove attributes set to null. Default false. |
| timestamps | `boolean | string` | Make "created" and "updated" timestamps in items. Set to true to create both. Set to 'create' for only "created" timestamp and set to "update" for only an "updated" timestamp. See also: "updatedField" and "createdField" properties. Default false. |
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
