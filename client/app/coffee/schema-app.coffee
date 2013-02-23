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
namespaceEncapsule_runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}




class namespaceEncapsule_code_app.Schema

    applicationRouteCallback = ->
        Console.message("#{appName}'s main applicationRouteCallback has been called.")

    constructor: ->
        try
            document.title = "#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName}"
            bodyElement = $("body")

            Console.messageRaw("<h3>STARTING APPLICATION</h3>")

            # Take over the applicationRouteCallback registration from the bootstrapper
            Encapsule.runtime.boot.phase0.router.setApplicationRouteCallback(applicationRouteCallback)

            # Instantiate and initialize the SCDL view model.

            Encapsule.runtime.app.viewmodel = {}
            Encapsule.runtime.app.viewmodel.scdl = new Encapsule.code.app.viewmodel.scdl()
            bodyElement.append Encapsule.runtime.app.viewmodel.scdl.html
            ko.applyBindings Encapsule.runtime.app.viewmodel.scdl, document.getElementById("idSchemaAppView")

            # Instantiate an initialize the boot page view model.

            Encapsule.runtime.app.viewmodel.boot = new Encapsule.code.app.viewmodel.boot()
            bodyElement.append Encapsule.runtime.app.viewmodel.boot.html
            ko.applyBindings Encapsule.runtime.app.viewmodel.boot, document.getElementById("idAppBootView")

            Encapsule.runtime.boot.phase0.spinner.cancel()

        catch exception
            Console.messageError(exception)


