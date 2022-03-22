
The Table constructor takes a parameter of type `object` with the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| client | `DocumentClient` | An AWS [DocumentClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html) instance. |
| crypto | `object` | Optional properties defining a crypto configuration to encrypt properties. |
| generate | `function` | Define a custom ID generator function that is used to create model IDs if required. |
| logger | `boolean|object` | Set to true to log to the console or set to a logging function(type, message, properties). Type is info|error|trace|exception. Default is false. |
| metrics | `object` | Configure metrics. Default null.|
| name | `string` | The name of your DynamoDB table. |
| schema | `string` | Definition of your DynamoDB indexes and models. |
| senselogs | `object` | Set to a SenseLogs logger instance instead `logger`. Default null. |
| transform | `function` | Callback function to be invoked to format and parse the data before reading and writing. |
| validate | `function` | Function to validate properties before issuing an API.|
| value | `function` | Function to evaluate value templates. Default null. |

The `client` property must be an initialized [AWS DocumentClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html). The DocumentClient API is currently supported by the AWS v2 API. The recently released AWS v3 API does not yet support the DocumentClient API (stay tuned - See [Issue](https://github.com/sensedeep/dynamodb-onetable/issues/2)).

By default, OneTable will not write `null` values to the database rather, it will remove the corresponding attribute from the item. If you set the `nulls` property to true, `null` values will be written via `create` or `update`. You can also define `nulls` on a model attribute basis via the schema.

The `metrics` property may be set to a map that configures detailed CloudWatch EMF metrics.

See [Metrics](../metrics/) for more details.
