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
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}




class Encapsule.code.app.Schema

    applicationRouteCallback = ->
        Console.message "#{appName} local URI routing hooked."

    constructor: ->
        try
            Console.messageRaw("<h3>#{appName} v#{appVersion} APPLICATION STARTING</h3>")
            Console.message "Initializing local URI routing:"
            Encapsule.runtime.boot.phase0.router.setApplicationRouteCallback(applicationRouteCallback)

            Console.messageRaw("<h3>INITIALIZING #{appName} MODEL VIEW</h3>")

            Encapsule.runtime.app.SchemaScdlCatalogue = new Encapsule.code.app.scdl.ObservableCatalogueShimHost()
            Encapsule.runtime.app.SchemaScdlNavigatorWindow = new Encapsule.code.app.modelview.SchemaScdlNavigatorWindow()

            Encapsule.runtime.app.SchemaTitlebarWindow = new Encapsule.code.app.modelview.SchemaTitleBarWindow()

            Encapsule.runtime.app.SchemaBootInfoWindow = new Encapsule.code.app.modelview.SchemaBootInfoWindow()

            Encapsule.runtime.app.SchemaWindowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager Encapsule.code.app.viewLayout

            Encapsule.runtime.boot.phase0.spinner.cancel()

            Console.message("#{appName} main application document.onLoad event handler exit error.")

        catch exception
            Console.messageError """#{appPackagePublisher} #{appName} v#{appVersion} APP INIT FAIL:: #{exception}"""


