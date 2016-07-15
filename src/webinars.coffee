# Description:
#   Get AWS Webinars schedule
#
# Commands:
#   hubot aws webinars - Get AWS Webinars schedule
cheerio = require 'cheerio'
request = require 'request'

module.exports = (robot) ->

  robot.respond /aws webinars$/i, (msg) ->
    url = 'https://aws.amazon.com/jp/about-aws/events/webinars'
    request url, (_, res) ->
      $ = cheerio.load res.body

      # For each webinars
      $('.twelve .lead-copy').each ->
        # Webinar Title
        title = $(this).find('a')
        titleText = title.text()
        titleUrl = title.attr('href')

        # Webinar Body
        body = $(this).next().find('p')
        splittedContents = splitContents body.eq(0).text()
        joinUrl = body.eq(1).find('a').attr('href')

        # Build response
        response = ''
        response += ':memo: ' + titleText + '\n'
        response += splittedContents[0] + '\n'
        response += splittedContents[1] + '\n'
        response += splittedContents[2] + '\n'
        response += joinUrl

        msg.send response

# Split Contents
#   - Time
#   - Target
#   - Summary
splitContents = (contents) ->
  splittedContents = contents.split('： ')
  timeKey = splittedContents[0]
  timeValue = splittedContents[1].split(' ')[0]
  targetKey = splittedContents[1].split(' ')[1]
  targetValue = splittedContents[2].split(' ')[0]
  summaryKey = splittedContents[2].split(' ')[1]
  summaryBody = splittedContents[3]
  return [
    timeKey + ' : ' + timeValue,
    targetKey + ' : ' + targetValue,
    summaryKey + ' : ' + summaryBody
  ]
