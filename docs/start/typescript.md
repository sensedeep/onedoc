OneTable provides TypeScript type declaration files so that OneTable APIs, requests and responses can be fully type checked.

Using the magic of TypeScript dynamic typing, OneTable automatically converts your OneTable schema into fully typed generic Model APIs. This way, OneTable creates type declarations for your table entities and attributes so that TypeScript will catch any invalid entity or entity attribute references.

For example:

```typescript
import {Entity, Model, Table} from 'dynamodb-onetable'

const MySchema = {
    ...
    models: {
        Account: {
            pk:    { type: String, value: 'account:${name}' },
            name:  { type: String },
        }
    } as const     // Required for TypeScript
}

```

When defining your OneTable schema for Typescript, you must use type objects (String, Date, Number etc) as the value for your `type` properties. When using Javascript, you can also use string values ('string', 'date', 'number'), but for Typescript, this will prevent the Typescript dynamic typing from working.

You also need to append the `as const` to the end of your models in the schema.

## Typed Application Models

Using the `Entity` generic type, you can create types for your schema models.

```typescript
type AccountType = Entity<typeof MySchema.models.Account>

```

With these types, you can declare typed variables.

```typescript
let account: AccountType = {
    name: 'Coyote',        //  OK
    unknown: 42,           //  Error
}
```

Similarly you can use a typed version of `getModel` to retrieve a typed Model to interact with OneTable.

```typescript
//  Get an Account access model
let Account = table.getModel<AccountType>('Account')

let account = await Account.create({
    name: 'Acme',               //  OK
    unknown: 42,                //  Error
})

account.name = 'Coyote'         //  OK
account.unknown = 42            //  Error
```
