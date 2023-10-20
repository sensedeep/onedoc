# Set Expressions

OneTable `set` expressions are a powerful way to express DynamoDB update expressions. DynamoDB ExpressionAttributeNames and Values are one of the least fun parts of DynamoDB. OneTable makes this much easier via the use of templated `set` clauses to express complex update expressions.

A `set` clause may be used with the `update` API to specify an Update expression. OneTable will parse the `set` clause and extract the names and values to use with the DynamoDB API.

For example:

```javascript
const schema = {
    version: '0.0.1',
    indexes: {
        primary: {hash: 'pk', sort: 'sk'},
    },
    models: {
        User: {
            pk: { type: String, value: '${_type}#' },
            sk: { type: String, value: '${_type}#${email}' },
            email: { type: String, required: true },
            addresses: { type: Array, default: [] }
        }
    } as const,
}

//  Create a user without an address
let users = await User.create({email: 'user@example.com'}

//  Set the first address
let user = await User.update({email: 'user@example.com'}, {
    set: {'address[0]': '1212 Cherry Tree Lane'},
})

//  Append further addresses
user = await User.update({email: user.email}, {
    set: {addresses: 'list_append(addresses, @{newAddress})'},
    substitutions: {
        newAddress: ['25 Mayfair cresent']
    }
})
```

OneTable will extract property names defined inside `${}` braces, variable substitutions in `@{}` braces and values inside `{}` braces and will automatically define your update expression and the required ExpressionAttributeNames and ExpressionAttributeValues.

If a value inside `{}` is a number, it will be typed as a number for DynamoDB. To force a value to be treated as a string, wrap it in quotes, for example: `{"42"}`.

Note: the property name is an unmapped schema property name and not a mapped attribute name.

The use of `@{}` substitutions is required when using `list_append`.

See also [Where Clauses](../where/) for using Filter Expressions with similar syntax.

See the [AWS Update Expression Reference](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.UpdateExpressions.html) for more details.
