```javascript
import {Table} from 'dynamodb-onetable'

const table = new Table({})

let Account = table.getModel('Account')
let User = table.getModel('User')

//  Get an item where the name is sufficient to construct the primary key
let account = await Account.get({name: 'Acme Airplanes'})
let user = await User.get({email: 'user@example.com'}, {index: 'gs1'})

//  find (query) items
let users = await User.find({accountName: 'Acme Airplanes'})

//  Update an item
await User.update({email: 'user@example.com', balance: 0})
```
