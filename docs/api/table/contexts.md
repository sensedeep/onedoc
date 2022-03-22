Each `Table` has a `context` of properties that are blended with `Model` properties before executing APIs. The context is used to provide keys and attributes that apply to more than just one API invocation. A typical use case is for a central authorization module to add an `accountId` or `userId` to the context which is then used in keys for items belonging to that account or user. This is useful for multi-tenant applications.

When creating items, context properties are written to the database. When updating, context properties are not, only explicit attributes provided in the API `properties` parameter are written.

Context properties take precedence over supplied `properties`. This is to prevent accidental updating of context keys. To force an update of context attributes, provide the context properties either by updating the context via `Table.addContext`, replacing the context via `Table.setContext` or supplying an explicit context via `params.context` to the individual API.

Use the `Table.setContext` method to initialize the context and `Table.clear` to reset.

For example:

```javascript
table.setContext({
    userId: 'user-42'
})
```
