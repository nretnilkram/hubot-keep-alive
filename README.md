# hubot-keep-alive

A hubot script that keeps the hubot alive. For use on sleeping web app servers.

## Installation

Add hubot-keep-alive to you package.json and then to your `external-scripts.json`:

```json
[
  "hubot-keep-alive"
]
```

## Configuration

hubot-keep-alive is configured by three environment variables:

* `HUBOT_KEEP_ALIVE_URL` - required, the fully qualified URL to keepalive, including a trailing slash.
* `HUBOT_KEEP_ALIVE_CRON` - optional,  set of times you want to keep the hubot alive. ( default, \*/5, \* \* \* \* )
* `TZ` - optional, default is "UTC"

```
heroku config:set HUBOT_KEEP_ALIVE_URL=<url>
```

## Development

```
hubot$ export HUBOT_KEEP_ALIVE_URL=http://localhost:8080/
hubot$ bin/hubot
```
