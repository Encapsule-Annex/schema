###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
# arachne-util.coffee
#
# Leverages code re-use technique suggested here:
# http://coffeescriptcookbook.com/chapters/syntax/code_reuse_on_client_and_server
# if not Encapsule? and not Encapsule

#     Encapsule = exports? and exports or @Encapsule = {}
# ^--- doesn't scale to multiple coffee modules as contents of Encapsule gets whacked
# v--- my solution seems to work for client-side. likely need to use both on node.js

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encpasule.code or @Encapusle.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}


getEpochTime = ->
    Math.round new Date().getTime() / 1000.0

class namespaceEncapsule_code_lib.util

    # Call externally as: Encapsule.util.getEpochTime()
    @getEpochTime: getEpochTime

