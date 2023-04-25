
[![Build Status](https://img.shields.io/github/actions/workflow/status/sensedeep/dynamodb-onetable/build.yml?branch=main)](https://img.shields.io/github/actions/workflow/status/sensedeep/dynamodb-onetable/build.yml?branch=main)
[![npm](https://img.shields.io/npm/v/dynamodb-onetable.svg)](https://www.npmjs.com/package/dynamodb-onetable)
[![npm](https://img.shields.io/npm/l/dynamodb-onetable.svg)](https://www.npmjs.com/package/dynamodb-onetable)
[![Coverage Status](https://coveralls.io/repos/github/sensedeep/dynamodb-onetable/badge.svg?branch=main)](https://coveralls.io/github/sensedeep/dynamodb-onetable?branch=main)


OneTable is the most evolved API for DynamoDB. It provides a high-level, elegant dry syntax while still enabling full access to DynamoDB API.

OneTable works with AWS V2 and V3 SDKs for JavaScript and TypeScript. For TypeScript, OneTable will create fully typed entities from your data schemas automatically.

To see OneTable in action, take this quick tour of OneTable which demonstrates importing, configuring and basic operation of OneTable.

## Import OneTable

To start, import the OneTable library.

```javascript
import {Table} from 'dynamodb-onetable'
```

## Import the AWS SDK

If you are not using ES modules or TypeScript, use `require` to import the libraries.

If you are using the AWS SDK V2, import the AWS `DynamoDB` class and create a `DocumentClient` instance.

```javascript
import DynamoDB from 'aws-sdk/clients/dynamodb'
const client = new DynamoDB.DocumentClient(params)
```

If you are using the AWS SDK V3, import the AWS V3 `DynamoDBClient` class and the OneTable `Dynamo` helper. Then create a `DynamoDBClient` instance and Dynamo wrapper instance. Note: you will need Node v14 or later for this to work.

Note: you can use the Table.setClient API to defer setting the client or replace the client at any time.

```javascript
import Dynamo from 'dynamodb-onetable/Dynamo'
import {Model, Table} from 'dynamodb-onetable'
import {DynamoDBClient} from '@aws-sdk/client-dynamodb'
const client = new Dynamo({client: new DynamoDBClient(params)})
```

## Configure the Table Class

Initialize your OneTable `Table` instance and define your application entities via a OneTable schema.

```javascript
const table = new Table({
    client: client,
    name: 'MyTable',
    schema: MySchema,
})
```

## Data Modeling

OneTable models your application entities via a OneTable schema.

The schema defines your entities and their attributes and how they will be stored in your DynamoDB table. The schema also defines the table indexes. Here is a sample schema:

```javascript
const MySchema = {
    format: 'onetable:1.1.0',
    version: '0.0.1',
    indexes: {
        primary: { hash: 'pk', sort: 'sk' },
        gs1:     { hash: 'gs1pk', sort: 'gs1sk', follow: true },
        ls1:     { sort: 'id', type: 'local' },
    },
    models: {
        Account: {
            pk:          { type: String, value: 'account:${id}' },
            sk:          { type: String, value: 'account:' },
            id:          { type: String, generate: 'ulid', validate: /^[0123456789ABCDEFGHJKMNPQRSTVWXYZ]{26}$/i },
            name:        { type: String, required: true },
            status:      { type: String, default: 'active' },
            zip:         { type: String },
        },
        User: {
            pk:          { type: String, value: 'account:${accountName}' },
            sk:          { type: String, value: 'user:${email}', validate: EmailRegExp },
            id:          { type: String, required: true },
            accountName: { type: String, required: true },
            email:       { type: String, required: true },
            firstName:   { type: String, required: true },
            lastName:    { type: String, required: true },
            username:    { type: String, required: true },
            role:        { type: String, enum: ['user', 'admin'], required: true, default: 'user' },
            balance:     { type: Number, default: 0 },

            gs1pk:       { type: String, value: 'user-email:${email}' },
            gs1sk:       { type: String, value: 'user:' },
        }
    },
    params: {
        'isoDates': true,
        'timestamps': true,
    },
}
```

For each model, you define the entity attributes and their type and other properties.

## Get a Model

To interact with DynamoDB, get a model for the application entity.

```javascript
const model = table.getModel('Account')
```

If using TypeScript, see [TypeScript Tour](../typescript/).

## Create an Item

To create
```javascript
let account = await Account.create({
    id: '8e7bbe6a-4afc-4117-9218-67081afc935b',
    name: 'Acme Airplanes',
})
```

This will write the following to DynamoDB:
```javascript
{
    pk:         'account:8e7bbe6a-4afc-4117-9218-67081afc935b',
    sk:         'account:98034',
    id:         '8e7bbe6a-4afc-4117-9218-67081afc935b',
    name:       'Acme Airplanes',
    status:     'active',
    zip:        '98034',
    created:    1610347305510,
    updated:    1610347305510,
}
```

## Get an Item

```javascript
let account = await Account.get({
    id: '8e7bbe6a-4afc-4117-9218-67081afc935b',
})
```

which will return:

```javascript
{
    id:       '8e7bbe6a-4afc-4117-9218-67081afc935b',
    name:     'Acme Airplanes',
    status:   'active',
    zip:      '98034',
}
```

## Use a Secondary Index:

```javascript
let user = await User.get({email: 'user@example.com'}, {index: 'gs1'})
```

## Find Items

To find a set of items:

```javascript
let users = await User.find({accountId: account.id})

let adminUsers = await User.find({accountId: account.id, role: 'admin'})

let users = await User.find({accountId: account.id}, {
    where: '${balance} > {100.00}'
})

//  Get a count of matching users without returning the actual items
let users = await User.find({accountId: account.id, role: 'admin'}, {count: true})
let count = users.count
```

## Update an Item

```javascript
await User.update({id: userId, balance: 50})
await User.update({id: userId}, {add: {balance: 10.00}})
await User.update({id: userId}, {set: {status: '{active}'}})
await User.update({id: userId}, {push: {tasks: 'Learn DynamoDB'}})
```

## Transactional Updates

```javascript
let transaction = {}
await Account.update({id: account.id, status: 'active'}, {transaction})
await User.update({id: user.id, role: 'user'}, {transaction})
await table.transact('write', transaction)
```

## More

There is so much more including

* TypeScript type checking of APIs and schema data
* Validations
* Support for required and unique attributes
* Batch updates
* Automatic extra encryption for sensitive attributes
* Detailed Metrics
* Multi-page response aggregation
* Create and manage tables
* Database migrations
* Integrated logging of requests and responses
