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
  keepAliveUrl = process.env.HUBOT_KEEP_ALIVE_URL
  cronSchedule = process.env.HUBOT_KEEP_ALIVE_CRON
  timezone = process.env.TZ or 'UTC'

  # Set the cronjob and make sure the schedule is valid
  try
  	new CronJob(cronSchedule, function(robot) ->
  		console.log('this should not be printed');
  	},
    null,
    true,
    timezone)
  catch e
  	robot.logger.error "cron pattern not valid"

  # Go Ping Hubot
  keepAlive = (robot) ->
    robot.get(keepAliveUrl)

  # Response from request
  keepAliveResponse = (req, res) ->
    res.set 'Content-Type', 'text/plain'
    res.send 'PONG'

  # Bind /keepalive/ping endpoint
  robot.router.get "/keepalive/ping", keepAliveResponse
