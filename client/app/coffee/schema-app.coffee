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
# schema-app.coffee
#
# Post-bootstrap entry point to Encapsule Schema HTML application.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}




class namespaceEncapsule_code_app.Schema

    applicationRouteCallback = ->
        Console.message "#{appName} local URI routing hooked."

    constructor: ->
        try
            document.title = "#{appName} v#{appVersion}"
            bodyElement = $("body")


            Console.messageRaw "<h3>STARTING APPLICATION</h3>"

            Console.message "Initializing local URI routing:"
            Encapsule.runtime.boot.phase0.router.setApplicationRouteCallback(applicationRouteCallback)

            Console.message "Initializing Encapsule window manager on layout #{Encapsule.code.app.viewLayout.id}"
            Encapsule.runtime.app.SchemaWindowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager Encapsule.code.app.viewLayout

            Encapsule.runtime.boot.phase0.spinner.cancel()


        catch exception
            Console.messageError """#{appPackagePublisher} #{appName} v#{appVersion} client app init fail: Details: #{exception}"""


