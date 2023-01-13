The following attribute properties are supported:

| Property | Type | Description |
| -------- | :--: | ----------- |
| crypt | `boolean` | Set to true to encrypt the data before writing. |
| default | `string` | Default value to use when creating model items or when reading items without a value.|
| enum | `array` | List of valid string values for the attribute. |
| encode | `array` | Define how an attribute is encoded in a value template. |
| generate | `string|boolean` | Set to 'uid', 'ulid' or 'uuid' to automatically create a new ID value for the attribute when creating new items. Set to true to use a custom ID generator defined via the Table params.generate option. Default to null. |
| hidden | `boolean` | Set to true to hide the attribute in the returned Javascript results. Attributes with a "value" template defined will by hidden by default. Default to the Table params value. |
| isoDates | `boolean` | Set to true to store dates as Javascript ISO strings vs epoch numerics. If unset, the field will use the table default value for isoDates. Default to the schema params value. |
| items | `object` | Nested schema used to enforce types for items in an array if the attribute type is `Array`.
| map | `string` | Map the field value to a different attribute name when storing in the database. Can be a simple attribute name or a compound "obj.name" where multiple fields can be stored in a single attribute containing an object with all the fields. |
| nulls | `boolean` | Set to true to store null values or false to remove attributes set to null. Default false. |
| required | `boolean` | Set to true if the attribute is required. Default to the schema params value. |
| reference | `string` | Describes a reference to another entity item. Format is: model:index:attribute=src-attribute,... |
| schema | `object` | Nested schema. |
| scope | `string` | Scope within which a unique attribute will be created. This is a template value to incorporate with the unique attributes. When expanded, this value is added to the unique attribute created for unique fields. Default to null.|
| timestamp | `boolean` | Set to true to flag this field as a generated timestamp. Only used with Typescript so the generated type signature for the create() API will not require timestamp properties to be provided. |
| ttl | `boolean` | Set to true to convert a supplied date value to a DynamoDB TTL seconds value. The supplied date value can be a Date instance, a number representing a Unix epoch in milliseconds since Jan 1, 1970 or a string that can be parsed by Date.parse. OneTable will divide the Javascript date value by 1000 to get a DynamoDB TTL seconds value. |
| type | `Type or string` | Type to use for the attribute. |
| unique | `boolean` | Set to true to enforce uniqueness for this attribute. See the "scope" property to define a reduced scope for the unique attribute. Default false. |
| validate | `RegExp` | Regular expression to use to validate data before writing. |
| value | `string` | Template to derive the value of the attribute. These attributes are "hidden" by default. |


If the `default` property defines the default value for an attribute. If no value is provided for the attribute when creating a new item, the `default` value will be used.

The `encode` property defines how an attribute is encoded in a value template. It is useful to save redundantly storing attributes separately when they are encoded into other attribute via value templates. If you have an attribute that is used in value template, it is redundant to store that attribute separately. For example:

```
User: {
    pk:              { type: 'string', value: 'account#${accountId}' },
    sk:              { type: 'string', value: 'user#${id}' },
    accountId: { type: 'string', generate: 'uid' },
    id:              { type: 'string', generate: 'uid' },
}
```

In this example, the accountId and user ID are encoded in the PK and SK and are also stored redundantly in accountId and id. To save space, use encode:

```
User: {
    pk:              { type: 'string', value: 'account#${accountId}' },
    sk:              { type: 'string', value: 'user#${id}' },
    accountId: { type: 'string', generate: 'uid', encode: ['pk', '#', 1] },
    id:              { type: 'string', generate: 'uid', encode: ['sk', '#', 1] },
}
```

The encode property value is an array with three components. It specifies the attribute name encoding the property, what is the separator delimiting the portions of the value template and the index of the attribute (when split at the delimiters). i.e. the accountId is encoded in **pk** attribute and the **accountId** is found at the 1st embedded component in the pk. When data items are create or queried, you can provide and access the encoded property via named references. i.e. The encoding is transparent.

The `generate` property will generate an attribute value when creating new items. If set to 'uuid', then a non-crypto grade UUIDv4 format ID will be generated. If set to ULID, a crypto-grade, time-sortable random ID will be created. If set to 'uid' a shorter 10 character ID will be created.

You can also use and "generate: 'uid(NN)'" to generate shorter, less unique identifiers. A UID by default is ten letters long and supports a similar charset as the ULID (Uppercase and digits, base 32 excluding I, L, O and U.). So a 10 character UID is 32^10 which is over 1 quintillion possibilities. You can supply the length to the generate value to get an arbitrary length. For example: generate: 'uid(16)'

If the `hidden` property is set to true, the attribute will be defined in the DynamoDB database table, but will be omitted in the returned Javascript results.

If the `isoDates` property is defined and not-null, it will override the table isoDates value. Set to true to store the field date value as an ISO date string. Set to false to store the date as a Unix epoch date number.

The `map` property can be used to set an alternate or shorter attribute name when storing in the database. The map value may be a simple string that will be used as the actual attribute name.

Alternatively, the map value can be a pair of the form: 'obj.name', where the attribute value will be stored in an object attribute named "obj" with the given name `name`. Such two-level mappings may be used to map multiple properties to a single table attribute. This is helpful for the design pattern where GSIs project keys plus a single 'data' field and have multiple models map relevant attributes into the projected 'data' attribute. OneTable will automatically pack and unpack attribute values into the mapped attribute. Note: APIs that write to a mapped attribute must provide all the properties that map to that attribute on the API call. Otherwise an incomplete attribute would be written to the table.

The `reference` attribute documents a reference to another entity by using this attribute in combination with other attributes. The format is:

```bash
model:index:attribute=source-attribute,...
```

The "model" selects that target entity model of the reference using the nominated "index" where the target "attribute" is determined by the associated source-attribute. Multiple attributes can be specified. Tools can use this reference to navigate from one entity item to another.

The `schema` property permits nested field definitions. The parent property must be an Object as the type of items in arrays are defined using the `items` property.

The `ttl` property supports DynamoDB TTL expiry attributes. Set to true to store a supplied date value as a Unix epoch in seconds suitable for use as a DynamoDB TTL attribute.

The `type` properties defines the attribute data type. Valid types include: String, Number, Boolean, Date, Object, Null, Array, Buffer (or Binary) and Set. The object type is mapped to a `map`, the array type is mapped to a `list`. Dates are stored as Unix numeric epoch date stamps unless the `isoDates` parameter is true, in which case the dates are store as ISO date strings. Binary data is supplied via `buffer` types and is stored as base64 strings in DynamoDB.

The `validate` property defines a regular expression that is used to validate data before writing to the database. Highly recommended.

The `value` property defines a literal string template that is used to compute the attribute value. This is useful for computing key values from other properties, creating compound (composite) sort keys or for packing fields into a single DynamoDB attribute when using GSIs.

String templates are similar to JavaScript string templates. The template string may contain `${name}` references to other fields defined in the entity model. If any of the variable references are undefined when an API is called, the computed field value will be undefined and the attribute will be omitted from the operation. The variable `name` may be of the form: `${name:size:pad}` where the name will be padded to the specified size using the given `pad` character (which default to '0'). This is useful for zero padding numbers so that they sort numerically.

If you call `find` or any query API and do not provide all the properties needed to resolve the complete value template. i.e. some of the ${var} references are unresolved, OneTable will take the resolved leading portion and create a `begins with` key condition for that portion of the value template.

## Value and Default Functions

You may set the `value` property to a function to compute the value at runtime. This practice is not advised if you wish to use tools like SenseDeep to manage your schemas as the schema will no longer be literal as it will now contain embedded code. The `value` function invocation signature is:

```javascript
value = value(name, properties)
```

Similarly, the default property may be set to a function to compute the value at runtime. The `default` function invocation signature is:

```javascript
value = default(model, name, properties)
```
