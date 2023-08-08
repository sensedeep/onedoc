
The Table class is used to create an instance for each DynamoDB table you wish to access.

For each table, you define the table name, an AWS DynamoDB client connection object and a schema that defines your data model.

```javascript
import {Table} from 'dynamodb-onetable'

const table = new Table({
    client: DocumentClientInstance,
    name: 'MyTable',
    schema: Schema,
})
```

The Table constructor takes a parameter of type `object` with the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| client | `DocumentClient` | An AWS [DocumentClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html) instance. |
| crypto | `object` | Optional properties defining a crypto configuration to encrypt properties. |
| generate | `function` | Define a custom ID generator function that is used to create model IDs if required. |
| hidden | `boolean` | Return hidden fields by default. Default is false.|
| logger | `boolean|object` | Set to true to log to the console or set to a logging function(type, message, properties). Type is info|error|trace|exception. Default is false. |
| metrics | `object` | Configure metrics. Default null.|
| name | `string` | The name of your DynamoDB table. |
| partial | `boolean` | Allow partial object updates. This may be overridden on a schema per-field, or per-API basis. Default is true. |
| schema | `string` | Definition of your DynamoDB indexes and models. |
| senselogs | `object` | Set to a SenseLogs logger instance instead `logger`. Default null. |
| transform | `function` | Callback function to be invoked to format and parse the data before reading and writing. |
| validate | `function` | Function to validate properties before issuing an API.|
| value | `function` | Function to evaluate value templates. Default null. |
| warn | `boolean` | Emit warnings. Default true. |

The `client` property must be an initialized [DynamoDBClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-dynamodb/classes/dynamodbclient.html) instance. For the old AWS V2 SDK, you supply a [AWS DocumentClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html) instance.

By default, OneTable will not write `null` values to the database rather, it will remove the corresponding attribute from the item. If you set the `nulls` property to true, `null` values will be written via `create` or `update`. You can also define `nulls` on a model attribute basis via the schema.


The `metrics` property may be set to a map that configures detailed CloudWatch EMF metrics. See [Metrics](../metrics/) for more information.

The `schema` property must be set to your OneTable schema that defines your data model. See [Schemas](../schemas/) for details.

## Partial Properties

If the `partial` constructor property is true, you can specify partial objects when updating and only the supplied properties will be updated. If `partial` is false, then any objects supplied in the properties will replace the existing item object. i.e. partial permits updating individual object properties without having to provide the entire object. The default value for partial is now true.

For example, with partial set to true, you can do an update and only update an individual nested property:

```javascript
let user = await User.create({
    name: 'Road Runner',
    address: {
        street: '444 Coyote Lane',
    }
})

//  Update just the zip code
await User.update({
    id: user.id
    address: {
        zip: 98103
    }
})
```

Without `partial` set to true, the preceding update would have overwritten the address with just the zip code.

When using `partial` set to true, you must ensure the enclosing object exists before doing the update. You can ensure this by setting the schema field `default` to `{}`. For the example above, the address would have been defined as:

```javascript
const schema = {
  models: {
    User: {
        pk: {type: 'string', value: '${_type}#'},
        sk: {type: 'string', value: '${_type}#${id}'},

        name: {type: 'string'},
        id: {type: 'string', generate: 'uid'},
        address: {
            type: 'object',
            default: {},
            schema: {
                address: {type: 'string'},
                zip: {type: 'number'},
            }
        }
    }
  }
}
```

Partial can also be defined in a schema field definition and in the API params. 

Partial updates of arrays are not (yet) supported. You should specify `partial: false` in any schema array property if you are using partial updates in general.

The API params value of partial will override, the per-field definition which will override the table `partial` value.

## AWS DynamoDB Accelerator (DAX)

The Amazon DynamoDB Accelerator is a fully managed, highly available, in-memory cache for DynamoDB. OneTable supports DAX.

Currently, the AWS SDK V3 does not support DAX via by the DynamoDBClient package so you must use the AWS SDK V2.

Here is as sample initialization code for DAX:

```javascript
import {DynamoDB} from 'aws-sdk'
import AmazonDaxClient from 'amazon-dax-client'

const endpoint = "dax://DAX-CLUSTER-ENDPOINT"
const dax = new AmazonDaxClient({endpoints: [endpoint], region: 'AWS_REGION'})

const client = new DynamoDB.DocumentClient({service: dax})
```
