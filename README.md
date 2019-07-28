# CliNotifier

Slack notifier for CLI commands.

Use it if you want to run a CLI command and get notified on Slack when it finishes running.
The notification will contain the time it took to run, process exit code, the start and end times.

## Usage

`CliNotifier <command>`

It will require a file `~/.config/CliNotifier/config` containing the webhook URL you get from Slack.

## Current Caveats

- Currently, it only supports a single configuration file in the user's home folder
- Currently, the only existing configuration is the webhook URL. Other configurations, such as the user to @ when notifying should be added soon. Those changes will likely break compatibility with the current plain text config file.
- Currently, it doesn't @user when sending a notification
- At the moment there's no distribution of the Slack plugin yet, to use it for now you'll have to compile it and install it on Slack yourself (I'll get to that soon 😜)
- Currently, it uses an out of date version of the Slack API which doesn't supported neatly formmated messages, this is due to a dependency on linklater. Hopefuly this will change soon
