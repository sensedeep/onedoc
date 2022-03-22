
DynamoDB is a great [NoSQL](https://en.wikipedia.org/wiki/NoSQL) database that comes with a learning curve. Folks migrating from SQL often have a hard time adjusting to the NoSQL paradigm and especially to DynamoDB which offers exceptional scalability but with a fairly low-level API.

The standard DynamoDB API requires a lot of boiler-plate syntax and expressions. This is tedious to use and can unfortunately can be error prone at times. I doubt that creating complex attribute type, key, filter, condition and update expressions are anyone's idea of a good time.

Net/Net: it is not easy to write terse, clear, robust Dynamo code for one-table patterns.

Our goal with OneTable for DynamoDB was to keep all the good parts of DynamoDB and to remove the tedium and provide a more natural, "JavaScripty / TypeScripty" way to interact with DynamoDB without obscuring any of the power of DynamoDB itself.

For single-table designs, OneTable makes the job of managing single-table patterns a joy. OneTable easily manages multiple application entities, data integrity, compound keys, secondary indexes, validations and unique attributes. OneTable defines a higher level API so that you can concentrate on your application logic and let OneTable look after the mechanics of storing the data in your single table.
