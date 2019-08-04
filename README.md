# CliNotifier

Slack notifier for CLI commands.

Use it if you want to run a CLI command and get notified on Slack when it finishes running.
The notification will contain the time it took to run, process exit code, the start and end times.

The notification's currently look something like this:

![Notification Example](/docs/notification.png)

## Usage

`CliNotifier <command>`

It require sa file `~/.config/CliNotifier/config` containing the webhook URL you get from Slack, and the user's Slack member ID that will own the job from the perspective of Slack. This is an example configuration file:

```
user: "@UXFFW32ML"
hook: "https://hooks.slack.com/services/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"
```

To get the slack member ID, you need to click the icon with the three vertical dots on the user profile:

![Getting Slack's member ID](/docs/member-id.png)


## Current Caveats

- Currently, it only supports a single configuration file in the user's home folder
- Different colours for failure states are not yet implemented
