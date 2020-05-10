# gachette

Webhook server for Gitlab, Github and Gitea to run arbitrary commands.

Until today you need one Gachette server per project.

And it doesn't recognize any webhook variables.

You can, for example, use Gachette for this kind of purposes:

* launch your own script for a specific project after any kind of webhooks from the given service. For example to launch CI or to build a static website
* change something on the server where you launched Gachette, for exemple create new files, copy some repositories, etc.

# Features

* recognize if the webhook payload comes from Github, Gitlab or Gitea
* run either a command or a script file

## Planned features

* launch one Gachette server for multiple projects
* use a INI file to configure these projects
* use payload information as variables for launched scripts/commands

# Installation

You need to create the binary like this:

```bash
shards install
make
```

As a result, the executable `bin/gachette` will appear.

# Usage

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

## Parameters

* **-h**: show an help
* **-p**: port to listen for connections. Default: 3000
* **-k**: kind of webhook among gitlab, gitea or github. Default: github
* **-n**: user namespace on the given service (by **-k** option). Default: blankoworld/gachette
* **-c**: command to run after receiving a valid payload.
* **-f**: script to run while receiving a valid payload.

Gachette needs either a command (**-c**) or a script (**-f**) to be launched!

# Development

## Webhooks documentation

  * [Github examples](https://developer.github.com/v3/activity/events/types/#pushevent)
  * [Gitlab examples](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html#push-events)
  * [Gitea examples](https://docs.gitea.io/en-us/webhooks/)
  * [Other examples](https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md)

## Tests

Pretty testing can be launched via these commands:

```bash
shards install
KEMAL_ENV=test crystal spec
```

OR:

```bash
shards install
make test
```

## Documentation

As for Crystal language, just generate the documentation like this:

```
crystal docs
```

OR:

```
make doc
```

# Contributing

1. Fork it (<https://github.com/blankoworld/gachette/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# Contributors

- [Olivier DOSSMANN](https://github.com/blankoworld) - creator and maintainer
