
API errors will throw an instance of the `OneTableError` class. This instance has the following properties:

* message &mdash; Text error message.
* name &mdash; Error class name.
* code &mdash; Set to the AWS string error code indicating the class of error.
* context &mdash; Map of additional context information.
* stack &mdash; Stack backtrace information.

The `context` contains the original AWS DynamoDB error object as `context.err`. For transaction errors, the `context.err.CancellationReasons` holds the specifics of the transaction error.


## PostFormat

In cases where you cannot acheive what you need through the OneTable APIs, you can customize the final request to DynamoDB using `postFormat`. For a contrived example, imagine if you needed to add an extra ExpressionAttributeValues, you could do:

```javascript
await RouteModel.update({ routeId }, {
    set: { myField: ':myValue' },
    postFormat: (model, args) => {
        const extraValues = marshall({ ':myValue': { 'complex': 'Some kind of complex value' } })
        args.ExpressionAttributeValues = { ...extraValues, ...args.ExpressionAttributeValues }
        return args
    }
})
```
