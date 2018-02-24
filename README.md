# hubot-keep-alive

A hubot script that keeps the hubot alive. For use on sleeping web app servers.

## Installation

Add hubot-keep-alive to you package.json and then to your `external-scripts.json`:

```json
[
  "hubot-keep-alive"
]
```

## Configuring

hubot-keep-alive is configured by four environment variables:

* `HUBOT_KEEP_ALIVE_URL` - required, the complete URL to keepalive, including a trailing slash.
* `HUBOT_KEEP_ALIVE_CRON` - optional,  set of times you want to keep the hubot alive. ( default, */5, * * * * )

```
heroku config:set HUBOT_KEEP_ALIVE_URL=PASTE_WEB_URL_HERE
```

The times are based on the timezone of your Heroku application which defaults to UTC.  You can change this with:

```
heroku config:add TZ="America/New_York"
```

## Development

```
hubot$ export HUBOT_KEEP_ALIVE_URL=http://localhost:8080/
hubot$ bin/hubot
```
