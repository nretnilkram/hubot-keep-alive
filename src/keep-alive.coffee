# Description
#   A hubot script that keeps it's sleepy web apps alive.
#
# Notes:
#   This will help you keep your hubot alive if it lives on a
#   server that will go to sleep when dormant.
#
# Configuration:
#   HUBOT_KEEP_ALIVE_URL or HEROKU_URL: required
#   HUBOT_KEEP_ALIVE_CRON: optional, defaults to 5 minutes
#
#   heroku config:add TZ="America/New_York"
#
# URLs:
#   GET /heroku/keepalive
#

module.exports = (robot) ->
  cronJob = require('cron').CronJob
  keepAliveUrl = process.env.HUBOT_KEEP_ALIVE_URL or 'localhost:8080/keepalive/ping'
  cronSchedule = process.env.HUBOT_KEEP_ALIVE_CRON or '*/5 * * * *'
  timezone = process.env.TZ or 'UTC'

  # Go Ping Hubot
  keepAlive = (robot) ->
    robot.http(keepAliveUrl).get() (err, response, body) ->
      console.log err, response, body

  # Response from request
  keepAliveResponse = (req, res) ->
    res.set 'Content-Type', 'text/plain'
    res.send 'PONG'

  # Bind /keepalive/ping endpoint
  robot.router.get "/keepalive/ping", keepAliveResponse

  # Set the cronjob and make sure the schedule is valid
  try
    new CronJob(cronSchedule, keepAlive(robot), null, true, timezone)
  catch e
    console.log "cron pattern not valid"
