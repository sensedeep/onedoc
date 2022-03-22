The `schema.indexes` property can contain one or more indexes and must contain the `primary` key. Additional indexes will be treated as Global Secondary Indexes (GSIs) unless they are defined with a `type: "local"` property in which case they will be designated as Local Secondary Indexes (LSIs). An LSI index should not specify a hash attribute. If one is specified, it must equal that of the primary index.

```javascript
const MySchema = {
    indexes: {
        primary: {
            hash: 'pk',         //  Schema property name of the hash key
            sort: 'sk',         //  Schema property name of the sort key
        },
        //  Zero or more global secondary or local secondary indexes
        gs1: {
            hash: 'gs1pk',
            sort: 'gs1sk',
            project: 'all',
            follow: true,
        },
        ls1: {
            type: 'local'
            sort: 'id',
        }
    ...
}
```

Note: the hash and sort names are schema property names which may differ from table attribute names if you are using mapping.

The `project` property can be set to 'all' to project all attributes to the secondary index, set to 'keys' to project only keys and may be set to an array of attributes (not properties) to specify an explicit list of attributes to project. The `project` property is used by the Table.createTable and updateTable APIs only.

The `follow` property is used to support GSI indexes that project KEYS_ONLY or only a subset of an items properties. When `follow` is true, any fetch of an item via the GSI will be transparently followed by a fetch of the full item using the primary index and the GSI projected keys. This incurs an additional request for each item, but for large data sets, it is useful to minimize the size of a GSI and yet retain access to full items.
