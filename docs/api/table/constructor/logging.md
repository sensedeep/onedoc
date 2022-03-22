OneTable can log complete request parameters and responses to assist you in debugging and understanding how your API requests are being translated to DynamoDB.

You can set the Table constructor `logger` property to `true` for simple logging to the console.

```javascript
const table = new Table({
    ...
    logger: true,
})
```

Alternatively, the `logger` may be set to logging callback that will be invoked as required to log data. The logger function has the signature:

```javascript
const table = new Table({
    ...
    logger: (level, message, context) => {
        if (level == 'trace' || level == 'data') return
        console.log(`${new Date().toLocaleString()}: ${level}: ${message}`)
        console.log(JSON.stringify(context, null, 4) + '\n')
    }
})
```

Where `level` is set to `info`, `error`, `warn`, `exception`, `trace` or `data`. The `trace` level is for verbose debugging messages. The `data` level logs user data retrieved find and get API calls.

The `message` is a simple String containing a descriptive message. The `context` is a hash of contextual properties regarding the request, response or error.

If you use {log: true} in the various OneTable Model API options, the more verbose `trace` and `data` levels will be changed to `info` for that call before passing to the logging callback. In this way you can emit `trace` and `data` output on a per API basis.

#### SenseLogs

OneTable also integrates with [SenseLogs](https://www.npmjs.com/package/senselogs) which is a fast dynamic logger designed for serverless.

```javascript
import SenseLogs from 'senselogs'
const senselogs = new SenseLogs()
const table = new Table({senselogs})
```

This will log request details in JSON. Use `SenseLogs({destination: 'console'})` for plain text logging to the console.
