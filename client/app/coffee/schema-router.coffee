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
# schema-router.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

class Encapsule.code.app.SchemaRouter
    constructor: ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            @routerCore = Encapsule.runtime.boot.phase0.router

            @routeChangedCallback = (sequence_, route_, location_) =>
                # \ BEGIN: routeChangedCallback scope
                try
                    # \ BEGIN: routeChangedCallback try scope
                    Console.message("#{appName} local router: Route changed.")
                    Console.message("... sequence=#{sequence_} // route=#{route_} // location=#{location_}")

                    # / END: routeChangedCallback try scope
                catch exception
                    message = "SchemaRouter.routeChangedCallback fail: #{exception}"
                    Console.messageError(message)
                # / END: routeChangedCallback scope


            @setRoute = (route_) =>
                Console.message("#{appName} local router: Setting new local route.")



            # / END: constructor try scope
        catch exception
            message = "#{appName} local router fail: #{exception}"
            Console.messageError(message)
        # / END: constructor scope