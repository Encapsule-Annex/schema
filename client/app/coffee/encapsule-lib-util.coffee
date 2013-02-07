# arachne-util.coffee
#
# Leverages code re-use technique suggested here:
# http://coffeescriptcookbook.com/chapters/syntax/code_reuse_on_client_and_server
# if not Encapsule? and not Encapsule

#     Encapsule = exports? and exports or @Encapsule = {}
# ^--- doesn't scale to multiple coffee modules as contents of Encapsule gets whacked
# v--- my solution seems to work for client-side. likely need to use both on node.js

encapsuleNamespace = Encapsule? and Encapsule or @Encapsule = {}

getEpochTime = ->
    Math.round new Date().getTime() / 1000.0

class Encapsule.util

    # Call externally as: Encapsule.util.getEpochTime()
    @getEpochTime: getEpochTime

