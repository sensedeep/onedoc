The Dynamo class is used ease the configuration of the AWS SDK v3. The class is only used with AWS SDK V3 to wrap the DynamoDBClient instance and provide helper methods for OneTable. It does not expose any other methods.

### Dynamo Constructor

The Dynamo constructor takes a parameter of type `object` with the following properties:

| Property | Type | Description |
| -------- | :--: | ----------- |
| client | `DynamoDB` | An AWS SDK v3 [DynamoDBClient](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-dynamodb/classes/dynamodbclient.html) instance. |
| marshall | `object` | Marshall options for converting to DynamoDB attribute types. See: [util-dynamodb](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/modules/_aws_sdk_util_dynamodb.html) for details. |
| unmarshall | `object` | Unmarshall options for converting from DynamoDB attribute types. See: [util-dynamodb](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/modules/_aws_sdk_util_dynamodb.html) for details. |
