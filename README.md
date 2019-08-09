# gachette

Webhook server for Gitlab, Github and Gitea to run arbitrary commands.

## Installation

You need to create the binary like this:

```bash
shards install
make
```

As a result, the executable `bin/gachette` will appear.

## Usage

Launch the `bin/gachette` binary:

```bash
KEMAL_ENV=production gachette -p 3030 -k github -n blankoworld/gachette -c "ls /"
```

Which means:

  * you run in **production** mode
  * port: **3030**
  * you accept webhooks formed as **github** one
  * user namespace is **blankoworld/gachette**
  * each time you receive the well-formed request you launch a command: **ls /**

That's all!

## Development

### Webhooks documentation

  * [Github examples](https://developer.github.com/v3/activity/events/types/#pushevent)
  * [Gitlab examples](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html#push-events)
  * [Gitea examples](https://docs.gitea.io/en-us/webhooks/)
  * [Other examples](https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md)

### Tests

Pretty testing can be launched via these commands:

```bash
shards install
KEMAL_ENV=test crystal spec
```

## Contributing

1. Fork it (<https://github.com/blankoworld/gachette/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Olivier DOSSMANN](https://github.com/blankoworld) - creator and maintainer
