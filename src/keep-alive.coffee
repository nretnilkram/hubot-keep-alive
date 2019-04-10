# Description
#   A hubot script that keeps it's sleepy web apps alive.
#
# Notes:
#   This will help you keep your hubot alive if it lives on a
#   server that will go to sleep when dormant.
#
# Configuration:
#   HUBOT_KEEP_ALIVE_URL: required
#   HUBOT_KEEP_ALIVE_CRON: optional, defaults to every 5 minutes from 6am to 10pm
#   TZ: optional, defaults to "UTC"
#
# URLs:
#   GET /heroku/keepalive
#

module.exports = (robot) ->
  cronJob = require('cron').CronJob
  keepAliveUrl = process.env.HUBOT_KEEP_ALIVE_URL or 'http://localhost:8080/keepalive/ping'
  cronSchedule = process.env.HUBOT_KEEP_ALIVE_CRON or '0 */5 6-22 * * *'
  timezone = process.env.TZ or 'UTC'

  robot.logger.info('keepAliveUrl: ', keepAliveUrl)
  robot.logger.info('cronSchedule: ', cronSchedule)
  robot.logger.info('timzone: ', timezone)

  keepAlive = (robot) ->
    robot.http(keepAliveUrl).get() (err, response, body) ->
      if err
        robot.logger.error(err)
      else
        robot.logger.info('Hubot keep alive check successful.')

  keepAliveResponse = (req, res) ->
    res.set 'Content-Type', 'text/plain'
    res.send 'PONG'

  # Bind /keepalive/ping endpoint
  robot.router.get "/keepalive/ping", keepAliveResponse

  # Create CronJob
  try
    new cronJob(cronSchedule, () ->
      keepAlive(robot)
    , null, true, timezone)
  catch e
    console.log e
