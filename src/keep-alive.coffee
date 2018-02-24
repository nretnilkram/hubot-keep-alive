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
  wakeUpTime = (process.env.HUBOT_HEROKU_WAKEUP_TIME or '6:00').split(':').map (i) -> parseInt i, 10
  sleepTime =  (process.env.HUBOT_HEROKU_SLEEP_TIME or '22:00').split(':').map (i) -> parseInt i, 10

  wakeUpOffset = (60 * wakeUpTime[0] + wakeUpTime[1]) % (60 * 24)
  awakeMinutes = (60 * (sleepTime[0] + 24) + sleepTime[1] - wakeUpOffset) % (60 * 24)

  keepaliveUrl = process.env.HUBOT_HEROKU_KEEPALIVE_URL or process.env.HEROKU_URL
  if keepaliveUrl and not keepaliveUrl.match(/\/$/)
    keepaliveUrl = "#{keepaliveUrl}/"

  # interval, in minutes
  keepaliveInterval = if process.env.HUBOT_HEROKU_KEEPALIVE_INTERVAL?
                        parseFloat process.env.HUBOT_HEROKU_KEEPALIVE_INTERVAL
                      else
                        5

  unless keepaliveUrl?
    robot.logger.error "hubot-heroku-keepalive included, but missing HUBOT_HEROKU_KEEPALIVE_URL. `heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web.url | cut -d= -f2)`"
    return

  # check for legacy heroku keepalive from robot.coffee, and remove it
  if robot.pingIntervalId
    clearInterval(robot.pingIntervalId)

  if keepaliveInterval > 0.0
    robot.herokuKeepaliveIntervalId = setInterval =>
      robot.logger.info 'keepalive ping'

      now = new Date()
      elapsedMinutes = (60 * (now.getHours() + 24) + now.getMinutes() - wakeUpOffset) % (60 * 24)

      if elapsedMinutes < awakeMinutes
        client = robot.http("#{keepaliveUrl}heroku/keepalive")
        if process.env.EXPRESS_USER && process.env.EXPRESS_PASSWORD
          client.auth(process.env.EXPRESS_USER, process.env.EXPRESS_PASSWORD)
        client.post() (err, res, body) =>
          if err?
            robot.logger.info "keepalive pong: #{err}"
            robot.emit 'error', err
          else
            robot.logger.info "keepalive pong: #{res.statusCode} #{body}"
      else
        robot.logger.info "Skipping keep alive, time to rest"

    , keepaliveInterval * 60 * 1000
  else
    robot.logger.info "hubot-heroku-keepalive is #{keepaliveInterval}, so not keeping alive"

  keepaliveCallback = (req, res) ->
    res.set 'Content-Type', 'text/plain'
    res.send 'OK'

  # keep this different from the legacy URL in httpd.coffee
  robot.router.post "/heroku/keepalive", keepaliveCallback
  robot.router.get "/heroku/keepalive", keepaliveCallback
