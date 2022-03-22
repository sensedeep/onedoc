
Here are a few examples using the Table API. For most data accesses, the Model API is used.

## Setup

```javascript
import {Table} from 'dynamodb-onetable'

const table = new Table({
    client: DocumentClientInstance,
    name: 'MyTable',
    schema: Schema,
})
```

## Fetch an Item Collection

```javascript
let items = await table.fetch(['User', 'Product'], {pk: 'account:AcmeCorp'})
let users = items.User
let products = items.Product
```

## Query Items and then Group by Type

```javascript
let items = await table.queryItems({pk: 'account:AcmeCorp'}, {parse: true, hidden: true})
items = table.groupByType(items)
let users = items.User
let products = items.Product
```

## Get Item

```javascript
//  Fetch an account by the ID which is used to create the primary key value
let account = await table.get('Account', {id})
```

## Transactional Update
```javascript
let transaction = {}
await table.update('Account', {id: account.id, status: 'active'}, {transaction})
await table.update('User', {id: user.id, role: 'user'}, {transaction})
await table.transact('write', transaction)
```

## Scan
```javascript
//  Get the number of accounts without reading the items
let accounts = await table.scan('Account')
let count = accounts.count
```
