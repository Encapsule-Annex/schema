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

            Console.message "Inserting #{appName} view templates into DOM:"
            Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates()

            Encapsule.runtime.app.SchemaWindowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager Encapsule.code.app.viewLayout




            ### CUT THE CORD

            Console.message "Initializing #{appName} model."
            Encapsule.runtime.app.SchemaViewModel = new Encapsule.code.app.SchemaViewModel()

            Console.message "Binding top-level #{appName} view model to to DOM:"

            bodyElement.append("""
                <div id="idSchemaViewModel" data-bind="template: { name: 'idKoTemplate_SchemaViewModel' }, style: { marginLeft: cssOffsetLeft(), marginTop: cssOffsetTop(), width: cssWidth(), height: cssHeight() }"></div>
                """)

            Console.message "Binding #{appName} data model to view model."
            ko.applyBindings Encapsule.runtime.app.SchemaViewModel, document.getElementById("idSchemaViewModel")

            ###
          
            Console.messageRaw  "<h3>APPLICATION RUNTIME</h3>"
            Console.message "#{appName} v#{appVersion} is running..."

            ###
            # Instantiate the SCDL data catalogue
            Encapsule.runtime.app.viewmodel = {}
            Encapsule.runtime.app.viewmodel.scdl = new Encapsule.code.app.scdl.ObservableCatalogueShimHost()
            bodyElement.append("""<div data-bind="template: { name: 'idKoTemplate_ScdlCatalogueShimHost' }" id="idSchemaAppView"></div>""")
            ko.applyBindings Encapsule.runtime.app.viewmodel.scdl, document.getElementById("idSchemaAppView")


            # Instantate the SCDL catalogue editor
            Encapsule.runtime.app.viewmodel.scdleditor = new Encapsule.code.app.scdl.editor.ObservableEditor()
            bodyElement.append("""<div data-bind="template: { name: 'idKoTemplate_ScdlEditor' }" id="idSchemaEditorView"></div>""")
            ko.applyBindings Encapsule.runtime.app.viewmodel.scdleditor, document.getElementById("idSchemaEditorView")


            # Instantiate an initialize the boot page view model.
            Encapsule.runtime.app.viewmodel.boot = new Encapsule.code.app.viewmodel.boot()
            bodyElement.append Encapsule.runtime.app.viewmodel.boot.html
            ko.applyBindings Encapsule.runtime.app.viewmodel.boot, document.getElementById("idAppBootView")
            ###

            Encapsule.runtime.boot.phase0.spinner.cancel()
            # Console.hide()

        catch exception
            Console.messageError(exception)


