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
    internalAllRoutesCallbackCount = 0
    routerSequenceNumber = 0
    initialRoute = undefined;
    initialLocation = undefined;
    lastTriggeredRoute = undefined
    lastTriggeredLocation = undefined
    applicationRouteCallback = undefined

    allRoutes = ->
        internalAllRoutesCallbackCount++
        if not initialRoute
            initialRoute = clientRouter.getRoute()
            initialLocation = document.location
        lastTriggeredRoute = clientRouter.getRoute()
        lastTriggeredLocation = document.location
        if applicationRouteCallback? and applicationRouteCallback
            Console.message("#{appName} router: dispatching #{routerSequenceNumber} : #{document.location}")
            applicationRouteCallback(@)
            routerSequenceNumber++
        else
            Console.message("#{appName} router: caching #{routerSequenceNumber} : #{document.location}")

    clientRoutes = {}

    # This is perhaps one of the simplest possible configurations of client-side Director.js.
    # Essentially all we're doing is handling a single generic 'notfound' route and forwarding
    # it on to a registered listener callback. As used in this application, the bootstrapper
    # is initially registered as the 'applicationRouteCallback' listener in order to allow it
    # to parse out whatever it cares to from the initial load route (e.g. debug options). After
    # bootstrapping completes, the main application logic registers it own 'applicationRouteCallback'
    # listener, disconntecting the previous listener (in this case the bootstrapper).
    #
    # Note that this class trivially encapsulates this listener re-registration by caching the
    # the last set route and location in class instance state when a route is actually dispatched
    # by the contained Director.js instance. If a listener has been registered, the route is
    # dispatched immediately to the listener. If there is no active listener, the event is not
    # dispatched until the application calls the setApplicationRouteCallback method of this class.
    # In the case of re-registration, the active 
    clientOptions = {
        #before: onBefore,
        #on: allRoutes,
        #after: onAfter,
        #once: onOnce,
        notfound: allRoutes,
        async: false, # true or false (see re-director: async feature in Director.js isn't 100%)
        strict: true, # true or false (we take 'strict' to limit noise)
        recurse: false # "forward", "backward", or "false" (we take 'false' as 
        html5history: false, # true/false (enabled use of HTML5 pushstate)
        run_handler_in_init: false # true/false (we handle this case ourselves)
        }

    constructor: ->

        Console.message("#{appName} router: initialize.")

        clientRouter = Router() 
        clientRouter.configure(clientOptions)

        Console.message("#{appName} router: starting.")
        clientRouter.init()
        Console.message("#{appName} router: started.")

        if internalAllRoutesCallbackCount == 0
            Console.message("#{appName} router: redirecting to default route 'boot'")
            clientRouter.setRoute("boot")

    setApplicationRouteCallback: (applicationRouteCallback_) ->

        if not applicationRouteCallback_ or not applicationRouteCallback_
            throw "You need to specify a callback function."

        if applicationRouteCallback? or applicationRouteCallback
            Console.message("#{appName} router: re-registering application route callback.")
            routerSequenceNumber--
        else
            Console.message("#{appName} router: registering application route callback.")

        applicationRouteCallback = applicationRouteCallback_

        if internalAllRoutesCallbackCount > 0
            allRoutes()

