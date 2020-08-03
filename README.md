# gachette

Webhook server for Gitlab, Github and Gitea to run arbitrary commands.

Until today Gachette doesn't recognize any webhook variables (i.e transforming each element from the webhook into environment variables).

You can, for example, use Gachette for this kind of purposes:

* launch your own script for a specific project after any kind of webhooks from the given service. For example to launch CI or to build a static website
* change something on the server where you launched Gachette, for exemple create new files, copy some repositories, etc.

# Features

* recognize if the webhook payload comes from Github, Gitlab or Gitea
* run either a command or a script file
* launch one Gachette server for multiple projects
* use a INI file to configure these projects

## Planned features

* use payload information as variables for launched scripts/commands

# Installation

You need to create the binary like this:

```bash
shards install
make
```

As a result, the executable `bin/gachette` will appear.

# Configuration

Gachette needs a [INI formed configuration file](https://en.wikipedia.org/wiki/INI_file). You can get an example in the **gachette.ini.example** file.

Here is an example:

```ini
[The_name_I_want_for_the_project_in_gachette]
service = github
namespace = blankoworld/gachette
key = myPrivateSecretKey
command = ls .
```

With the last configuration we know that:

  * you accept webhooks from Github, from the namespace called **blankoworld/gachette** on Github
  * the webhook content uses a private key, which content is: `myPrivateSecretKey`
  * when Gachette receives a well formed webhook, it launch the command `ls .`

Gachette use **each section as a project**.

Each project contains all project options.

**key** is not mandatory.

Gachette uses **either `command` or `scriptfile`** as action to execute while receiving a webhook.

`scriptfile` should contains the path of an executable script file.

# Usage

Launch the `bin/gachette` binary:

```bash
KEMAL_ENV=production gachette -p 3030
```

Which means:

  * you run in **production** mode
  * port: **3030**

That's all!

## Parameters

* **-h**: show an help.
* **-p**: port to listen for connections. Default: 3000.
* **-c**: *.ini file used as configuration for allowed projects.

Gachette use **gachette.ini** configuration file as default one.

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
