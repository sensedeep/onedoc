The `schema` property describes the indexes and models (entities) on your DynamoDB table. Models may be defined via the `schema` or alternatively may be constructed using the `Model` constructor and the `Table.addModel` method.

The valid properties of the `schema` object are:

| Property | Type | Description |
| -------- | :--: | ----------- |
| format | `string` | Reserved. Must be set to 'onetable:1.1.0' |
| indexes | `object` | Hash of indexes used by the table. |
| models | `object` | Hash of model entities describing the model keys, indexes and attributes. |
| params | `object` | Hash of properties controlling how data is stored in the table. |
| version | `string` | A SemVer compatible version string. |

The `format` property must be set to `onetable:1.1.0`.

The schema must contain a `version` property set to a [SemVer](https://semver.org/) compatible version string. This may be used by consumers of the schema to understand compatibility constraints for the schema and stored data.
