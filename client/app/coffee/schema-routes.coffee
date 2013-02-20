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
# This class is based on learnings from my Director.js test page, re-director.
# See https://github.com/ChrisRus/re-director for background information.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}

class namespaceApp.InPageHashRouter

    #
    # class instance state

    clientRouter = undefined
    routerSequenceNumber = 0
    initialRoute = undefined;
    initialLocation = undefined;
    lastTriggeredRoute = undefined
    lastTriggeredLocation = undefined
    applicationRouteCallback = undefined

    routeNotFound = ->
        routerSequenceNumber++
        if not initialRoute
            initialRoute = clientRouter.getRoute()
            initialLocation = document.location
        lastTriggeredRoute = clientRouter.getRoute()
        lastTriggeredLocation = document.location
        if applicationRouteCallback? and applicationRouteCallback
            applicationRouteCallback(this)

    clientRoutes = {
        # look Mom - no routes!
        }

    clientOptions = {
        #before: onBefore,
        #on: allRoutes,
        #after: onAfter,
        #once: onOnce,
        notfound: routeNotFound,
        async: false, # true or false (see re-director: async feature in Director.js isn't 100%)
        strict: true, # true or false (we take 'strict' to limit noise)
        recurse: false # "forward", "backward", or "false" (we take 'false' as 
        html5history: false, # true/false (enabled use of HTML5 pushstate)
        run_handler_in_init: false # true/false (we handle this case ourselves)
        }

    constructor: ->

        clientRouter = Router(clientRoutes)

        clientRouter.configure(clientOptions)
        clientRouter.init()

        if routerSequenceNumber == 0
            clientRouter.setRoute('/#/')




