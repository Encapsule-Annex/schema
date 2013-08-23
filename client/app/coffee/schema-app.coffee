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

    constructor: ->
        try
            Console.messageRaw("<h3>#{appName} v#{appVersion} APPLICATION STARTING</h3>")

            Encapsule.runtime.app.SchemaSession = new Encapsule.code.app.SchemaSession()

            Console.messageRaw("<h3>INITIALIZING #{appName} OBJECT MODEL MANAGER</h3>")

            ommLib = Encapsule.code.lib.omm


            ommRuntime = Encapsule.runtime.app.omm = {}
            ommRuntime.declaration = Encapsule.code.app.modelview.ScdlNavigatorWindowLayout

            ommRuntime.model = new ommLib.Model(ommRuntime.declaration)

            ommRuntime.store = new ommLib.Store(ommRuntime.model)

            ommRuntime.observers = {}
            ommObservers = ommRuntime.observers

            ommObservers = new Encapsule.code.lib.omm.observers.NavigatorModelView()




            objectModelNavigatorWindow = Encapsule.runtime.app.ObjectModelNavigatorWindow = new Encapsule.code.lib.modelview.ObjectModelNavigatorWindow(objectStore)
            objectModelNavigatorSelectorWindow = Encapsule.runtime.app.ObjectModelNavigatorSelectorWindow = new Encapsule.code.lib.modelview.ObjectModelNavigatorSelectorWindow()
            objectModelNavigatorWindow.selectorStore.registerModelViewObserver(objectModelNavigatorSelectorWindow.selectorStoreCallbacks)

            objectModelNavigatorNamespaceWindow = Encapsule.runtime.app.ObjectModelNavigatorNamespaceWindow = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow()
            objectModelNavigatorWindow.selectorStore.registerModelViewObserver(objectModelNavigatorNamespaceWindow.selectorStoreCallbacks)

            objectModelNavigatorJsonWindow = Encapsule.runtime.app.ObjectModelNavigatorJsonModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorJsonModelView()
            objectModelNavigatorWindow.selectorStore.registerModelViewObserver(objectModelNavigatorJsonWindow.selectorStoreCallbacks)
            # ==============================================================================

            # Some experimental stuff

            token01 = new Encapsule.code.lib.omm.AddressToken(objectModel, undefined, undefined, 2) # root selector
            token02 = new Encapsule.code.lib.omm.AddressToken(objectModel, 2, undefined, 3) # Should be okay.
            token03 = new Encapsule.code.lib.omm.AddressToken(objectModel, undefined, undefined, 3) # Should be okay.

            address01 = new Encapsule.code.lib.omm.Address(objectModel)
            address01.pushToken token01
            address01.pushToken token02

            address02 = new Encapsule.code.lib.omm.Address objectModel, [ token01, token03 ]

            namespace2Test01 = new Encapsule.code.lib.omm.ObjectStoreNamespace2(objectStore, address02, "new")



            # ==============================================================================

            Encapsule.runtime.app.SchemaBootInfoWindow = new Encapsule.code.app.modelview.SchemaBootInfoWindow()

            # Encapsule.runtime.app.SchemaTitlebarWindow = new Encapsule.code.app.modelview.SchemaTitleBarWindow()
            # Encapsule.runtime.app.SchemaD3Main = new Encapsule.code.app.SchemaViewModelSvgPlane()

            # Initialize the Encapsule Window Manager library.
            Encapsule.runtime.app.SchemaWindowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager(Encapsule.code.app.winmgr.layout.root.Layout)

            Encapsule.runtime.app.SchemaWindowManager.displayPlane("idSchemaPlaneOmmNavigator")
            #Encapsule.runtime.app.SchemaWindowManager.displayPlane("idSchemaPlaneScdlCatalogueNavigator")
            #Encapsule.runtime.app.SchemaWindowManager.displayPlane("idSchemaPlaneD3")
            #Encapsule.runtime.app.SchemaWindowManager.displayPlane("idRootLayoutDebugPlane")

            Console.message "Initializing local URI routing:"
            Encapsule.runtime.app.SchemaRouter = new Encapsule.code.app.SchemaRouter()
            Encapsule.runtime.boot.phase0.router.setApplicationRouteCallback(Encapsule.runtime.app.SchemaRouter.routeChangedCallback)
            Console.message( Encapsule.runtime.app.SchemaRouter.getRoute() )
            Encapsule.runtime.app.SchemaRouter.setRoute(Encapsule.code.app.modelview.ScdlNavigatorWindowLayout.initialSelectionPath)

            # Encapsule.runtime.app.SchemaD3Main.initializeD3()

            Encapsule.runtime.boot.phase0.spinner.cancel()
            Console.message("#{appName} main application document.onLoad event handler exit error.")
            Encapsule.runtime.boot.phase0.blipper.blip "system-normal"


        catch exception
            Console.messageError """#{appPackagePublisher} #{appName} v#{appVersion} APP INIT FAIL:: #{exception}"""


