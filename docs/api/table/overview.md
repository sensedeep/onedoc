The `Table` class is the top-most OneTable class and it represents a single DynamoDB table. The table class configures access to a DynamoDB table, defines the model (entity) schema, indexes, crypto and defaults. You can create a single `Table` instance or if you are working with multiple tables, you can create one instance per table.

The Table class defines the connection to your DynamoDB table and specifies your data schema including application entity models and index structure.

The Table class provides APIs for table operations, transactions and batch API operations. While most access to the database is via the `Model` methods, the Table class also provides a convenience API to wrap the `Model` methods so you can specify the required model by a string name. The is helpful for factory design patterns.
