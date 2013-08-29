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


            ONMjs = Encapsule.code.lib.omm

            # ONMjs Object Namespace Schema (ONS) declaration.
            # ONMjs is currently parsing a really really old declaration.
            # Semantically there's nothing wrong with this declaration; it captures all relevant information
            # required to correctly initialize an ONMjs.Model object. However the concepts exposed by the
            # ONMjs have evolved to the point where this declaration no longer makes a ton of sense given
            # current ONMjs naming conventions.


            # Local alias of app state root.
            schemaRuntime = Encapsule.runtime.app

            # Namespace for ONMjs-related objects.
            schemaRuntime.ONMjs = {}
            schemaRuntime.ONMjs.observers = {}

            # The Schema application state model codified as an ONMjs Object Model Schema.
            schema = schemaRuntime.ONMjs.schema = Encapsule.code.app.modelview.ScdlNavigatorWindowLayout

            # Initialize the Schema application's ONMjs runtime state model.
            model = schemaRuntime.ONMjs.model = new ONMjs.Model(schema)

            # Initialize the Schema application's ONMjs runtime state store.
            store = schemaRuntime.ONMjs.store = new ONMjs.Store(model)

            # Create an instance of "canary" - an ONMjs observer. Canary "sings" to the console log.
            canary = schemaRuntime.ONMjs.observers.canary = new ONMjs.test.observers.Canary()

            #---
            # TEST CODE
            # Attach the canary to the store via ONMjs.Store.registerObserver.
            canaryStoreObserverId = store.registerObserver(canary.callbackInterface, canary)
            # Detach the canary from the store via ONMjs.Store.unregisterObserver.
            store.unregisterObserver(canaryStoreObserverId)
            # TEST CODE
            #---

            # The above attach/detach should produce corresponding callback notifications logged.
            # in the Schema debug console window.

            # Create a ONMjs.CachedAddress object associated with the store.
            selectedAddress = schemaRuntime.ONMjs.selectedAddress = new ONMjs.CachedAddress(store)

            # Attach the CachedAddress as an observer of the store.
            selectedAddressObserverId = store.registerObserver(selectedAddress.objectStoreCallbacks, selectedAddress)

            # Create an ONMjs.observers.NavigatorModelView object (responsible for rendering the treeview).
            navigator = schemaRuntime.ONMjs.observers.navigator = new ONMjs.observers.NavigatorModelView()

            # Attach the navigator as an observer of the store.
            navigator.attachToStore(store)

            # Attach the navigator as an observer of the currently selected address.
            navigator.attachToCachedAddress(selectedAddress)

            # Initialize an ONMjs.observable.SelectedJsonModelView object.
            jsonView = schemaRuntime.ONMjs.observers.json = new ONMjs.observers.SelectedJsonModelView()

            # Attach the JSON viewer as an obsever of the selected address.
            jsonView.attachToCachedAddress(selectedAddress)


            #---
            # TEST CODE
            # Manually create a new ONMjs.Address object.
            newAddress = ONMjs.address.FromPath(model, "schema.client")
            # Manually set the selected address.
            selectedAddress.setAddress(newAddress)
            # TEST CODE
            #---

            # Tell the navigator which CachedAddress to route user address selections to.
            navigator.setCachedAddressSinkStore(selectedAddress)





            # Some temporary test code for bringing up the new store addressing model.

            # Open the object store's root namespace.
            namespace = new ONMjs.Namespace(store)

            address = ONMjs.address.FromPath(model, "schema.omm")
            address2 = ONMjs.address.FromPath(model, "schema.client.catalogues.catalogue.models.machines.machine.states.state.transitions.transition")
            address3 = ONMjs.address.Parent(address2, 2)
            address = ONMjs.address.Parent(address)
            address = ONMjs.address.Parent(address, 5)



            ###

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

            ###


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


