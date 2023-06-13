
## AWS SDK V3

If you are using the AWS SDK V3, import the AWS V3 `DynamoDBClient` class. Then create a `DynamoDBClient` instance.

```javascript
import {DynamoDBClient} from '@aws-sdk/client-dynamodb'
const client = new DynamoDBClient(params)
```

## AWS SDK V2

If you are using the legacy AWS SDK V2, import the AWS V2 SDK `DynamoDB` class and create a `DocumentClient` instance.

```javascript
import DynamoDB from 'aws-sdk/clients/dynamodb'
const client = new DynamoDB.DocumentClient(params)
```

Note: you can use the Table.setClient API to defer setting the client or replace the client at any time.
