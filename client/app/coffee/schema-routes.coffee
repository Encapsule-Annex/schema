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
#
# schema-routes.coffee
#
# In-page hash routing using Director.js
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}


hello = ->
    alert "Hello!"

allroutes = ->
    alert "Hello all routes!"

class namespaceApp.routes

    @install: ->

        hello = ->
            alert "Hello"

        allroutes = ->
            Console.log "all routes"

        routes = {
            '/hello': hello
            }

        router = Router(routes)

        router.configure { on: allroutes }
        router.init()
