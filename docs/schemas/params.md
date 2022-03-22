The `schema.params` is a hash map of properties that control how data is stored. It may contain the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| createdField | `string` | Name of the "created" timestamp attribute. Defaults to "created". |
| hidden | `boolean` | Hide templated (value) attributes in Javascript properties. Default true. |
| isoDates | `boolean` | Set to true to store dates as Javascript ISO strings vs epoch numerics. Default false. |
| nulls | `boolean` | Store nulls in database attributes vs remove attributes set to null. Default false. |
| timestamps | `boolean` | Make "created" and "updated" timestamps in items. Default false. |
| typeField | `string` | Name of the "type" attribute. Default "_type". |
| updatedField | `string` | Name of the "updated" timestamp attribute. Default "updated". |
