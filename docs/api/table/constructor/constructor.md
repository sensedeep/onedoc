
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
| partial | `boolean` | Allow partial object updates. Default is true (>2.6) |
| schema | `string` | Definition of your DynamoDB indexes and models. |
| senselogs | `object` | Set to a SenseLogs logger instance instead `logger`. Default null. |
| transform | `function` | Callback function to be invoked to format and parse the data before reading and writing. |
| validate | `function` | Function to validate properties before issuing an API.|
| value | `function` | Function to evaluate value templates. Default null. |
| warn | `boolean` | Emit warnings. Default true. |

The `client` property must be an initialized [AWS DocumentClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html). The DocumentClient API is currently supported by the AWS v2 API. The recently released AWS v3 API does not yet support the DocumentClient API (stay tuned - See [Issue](https://github.com/sensedeep/dynamodb-onetable/issues/2)).

By default, OneTable will not write `null` values to the database rather, it will remove the corresponding attribute from the item. If you set the `nulls` property to true, `null` values will be written via `create` or `update`. You can also define `nulls` on a model attribute basis via the schema.

The `metrics` property may be set to a map that configures detailed CloudWatch EMF metrics. See [Metrics](../metrics/) for more information.

The `schema` property must be set to your OneTable schema that defines your data model. See [Schemas](../schemas/) for details.

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
