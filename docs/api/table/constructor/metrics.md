OneTable can emit detailed CloudWatch custom metrics to track DynamoDB performance and usage on a per app/function, index, entity model and operation basis.  

The metrics are emitted using the CloudWatch EMF format with dimensions for: Table, Source, Index, Model and Operation.

The following metrics are emitted for each dimension combination:

* read — Read capacity units consumed
* write — Write capacity units consumed
* latency — Aggregated request latency in milliseconds
* count — Count of items returned
* scanned — Number of items scanned
* requests — Number of API requests issued

SenseDeep and other tools can present and analyze these metrics to gain insights and graph into how your single-table designs are performing.

The properties of Table constructor `params.metrics` property are:

| Property | Type | Description |
| -------- | :--: | ----------- |
| chan | `string` | Log channel to use to emit metrics. Defaults to 'metrics'.|
| dimensions | `array` | Ordered array of dimensions to emit. Defaults to [Table, Tenant, Source, Index, Model, Operation].|
| enable | `boolean` | Set to true to enable metrics. Defaults to true.|
| env | `boolean` | Set to true to enable dynamic control via the LOG_FILTER environment variable. Defaults to true.|
| max | `number` | Number of DynamoDB API calls for which to buffer metrics before flushing. Defaults to 100.|
| namespace | `string` | CloudWatch metrics namespace for the metrics. Defaults to `SingleTable/metrics`.|
| period | `number` | Number of seconds to buffer metrics before flushing. Defaults to 30 seconds.|
| properties | `map|function` | Set to a map of additional properties to be included in EMF log record. These are not metrics. Set to a function that will be invoked as `properties(operation, params, result)` and should return a map of properties. Defaults to null.|
| queries | `boolean` | Set to true to enable per-query profile metrics. Defaults to true.|
| source | `string` | Name of application or function name that is calling DynamoDB. Default to the Lambda function name.|
| tenant | `string` | Set to an identifying string for the customer or tenant. Defaults to null.|

Metrics can be dynamically controlled by the LOG_FILTER environment variable. If this environment variable contains the string `dbmetrics` and the `env` params is set to true, then Metrics will be enabled. If the `env` parameter is unset, LOG_FILTER will be ignored.

```javascript
const table = new Table({
    metrics: {source: 'acme:launcher', env: true}
})
```

You can also generate metrics for specially profiled queries and scans via the `params.profile` tag. The profile param takes a unique string tag and metrics will be created for the dimensions [Profile, profile-tag-name]. These metrics exist outside the standard dimensions specified via the Metrics `dimensions` parameter.

```javascript
await User.find({}, {profile: 'find-all-users'})
```

Read more about how to use and configure metrics at [Understanding Your DynamoDB Performance](https://www.sensedeep.com/blog/posts/stories/single-table-dynamodb-monitoring.html).

The metrics can be viewed in CloudWatch or best via the free [SenseDeep Developer](https://www.sensedeep.com) plan which has detailed graphs for your single-table monitoring for DynamoDB.

![Single Table Monitoring](https://www.sensedeep.com/images/sensedeep/table-single.png).

#### Metrics Under the Hood

The metric are emitted using [CloudWatch EMF](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format_Specification.html) via the `metrics` method. This permits zero-latency creation of metrics without impacting the performance of your Lambdas.

Metrics will only be emitted for dimension combinations that are active. If you have many application entities and indexes, you may end up with a large number of metrics. If your site uses all these dimensions actively, your CloudWatch Metric costs may be high. You will be charged by AWS CloudWatch for the total number of metrics that are active each hour at the rate of $0.30 cents per hour.

If your CloudWatch costs are too high, you can minimize your charges by reducing the number of dimensions via the `dimensions` property. You could consider disabling the `source` or `operation` dimensions. Alternatively, you should consider [SenseLogs](https://www.npmjs.com/package/senselogs) which integrates with OneTable and can dynamically control your metrics to enable and disable metrics dynamically.

DynamoDB Metrics are buffered and aggregated to minimize the load on your system. If a Lambda function is reclaimed by AWS Lambda, there may be a few metric requests that are not emitted before the function is reclaimed. This should be a very small percentage and should not significantly impact the quality of the metrics. You can control this buffering via the `max` and `period` parameters.
