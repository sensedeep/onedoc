
If you are using the AWS SDK V2, import the AWS `DynamoDB` class and create a `DocumentClient` instance.

```javascript
import DynamoDB from 'aws-sdk/clients/dynamodb'
const client = new DynamoDB.DocumentClient(params)
```

## AWS SDK V3

If you are using the AWS SDK V3, import the AWS V3 `DynamoDBClient` class and the OneTable `Dynamo` helper. Then create a `DynamoDBClient` instance and Dynamo wrapper instance. Note: you will need Node v14 or later for this to work.

```javascript
import Dynamo from 'dynamodb-onetable/Dynamo'
import {Model, Table} from 'dynamodb-onetable'
import {DynamoDBClient} from '@aws-sdk/client-dynamodb'
const client = new Dynamo({client: new DynamoDBClient(params)})
```

Note: you can use the Table.setClient API to defer setting the client or replace the client at any time.

[Subscribe to our newsletter](#){ .md-button .md-button--primary }
