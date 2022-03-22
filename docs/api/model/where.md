OneTable `where` clauses are a convenient way to express DynamoDB filter expressions. DynamoDB ExpressionAttributeNames and Values are one of the least fun parts of DynamoDB. OneTable makes this much easier via the use of templated `where` clauses to express complex filter expressions.

A `where` clause may be used with `find`, `scan`, `create`, `delete` or `update` APIs to specify a Filter or Conditional update expression. OneTable will parse the `where` clause and extract the names and values to use with the DynamoDB API.

For example:

```javascript
let adminUsers = await User.find({}, {
    where: '(${role} = {admin}) and (${status} = @{status})',
    substitutions: {
        status: 'current'
    }
})
```

OneTable will extract property names defined inside `${}` braces, variable substitutions in `@{}` braces and values inside `{}` braces and will automatically define your filter or conditional expressions and the required ExpressionAttributeNames and ExpressionAttributeValues.

If a value inside `{}` is a number, it will be typed as a number for DynamoDB. To force a value to be treated as a string, wrap it in quotes, for example: `{"42"}`.

Note: the property name is an unmapped schema property name and not a mapped attribute name.

Substutions also support a `splat` syntax for use with filterExpressions and the `IN` operator.

With this syntax, the list is expanded in-situ and each list item is defined as a separate ExpressionAttributeValue.

```javascript
let adminUsers = await User.find({}, {
    where: '(${role} IN @{...roles})',
    substitutions: {
        roles: ['user', 'admin']
    }
})

##### Where Clause Operators

You can use the following operators with a `where` clause:

```javascript
< <= = <> >= >
AND OR NOT BETWEEN IN
()
attribute_exists()
attribute_not_exists()
attribute_type()
begins_with()
contains()
not_contains()
size
```

Where clauses when used with `find` or `scan` on non-key attribugtes can also use the `<>` not equals operator.

See the [AWS Comparison Expression Reference](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.OperatorsAndFunctions.html) for more details.
