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

            Console.messageRaw("<h3>INITIALIZING #{appName} MODEL VIEW</h3>")

            # ==============================================================================
            # OMM experiments.

            objectModel = 
                Encapsule.runtime.app.SchemaObjectModel =
                new Encapsule.code.lib.omm.ObjectModel(Encapsule.code.app.modelview.ScdlNavigatorWindowLayout)

            objectStore = 
                Encapsule.runtime.app.SchemaObjectStore =
                new Encapsule.code.lib.omm.ObjectStore(objectModel)

            jsonStoreDefault = objectStore.toJSON()

            selectorCatalogues = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues")
            namespaceCatalogues = objectStore.openNamespace(selectorCatalogues)

            selectorCatalogueUnresolved = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues.catalogue")
            namespaceCatalogue = objectStore.createComponent(selectorCatalogueUnresolved)
            selectorCatalogueResolved = namespaceCatalogue.getResolvedSelector()

            namespaceCatalogueTest = objectStore.openNamespace(selectorCatalogueResolved)

            saveStore = objectStore.toJSON()

            reconstitutedStore = new Encapsule.code.lib.omm.ObjectStore(objectModel, saveStore)

            scdlMachineSelectorUnresolved = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues.catalogue.models.machines.machine")
            scdlMachineNamespace = reconstitutedStore.createComponent(scdlMachineSelectorUnresolved)
            scdlMachineSelectorResolved = scdlMachineNamespace.getResolvedSelector()

            reconstitutedStore.removeComponent(scdlMachineSelectorResolved)


            jsonFinal = reconstitutedStore.toJSON(undefined, 4)
            Console.messageRaw("<pre>#{jsonFinal}</pre>")


            ###

            jsonString = objectStore.toJSON()

            # Raw old style
            selectKeyVector = []
            schemaClientId = objectModel.getPathIdFromPath("schema.client")
            schemaClientCataloguesId = objectModel.getPathIdFromPath("schema.client.catalogues")
            schemaClientSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(objectModel, schemaClientId, selectKeyVector)
            schemaClientCataloguesSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(objectModel, schemaClientCataloguesId, selectKeyVector)
            schemaClientNamespace = objectStore.createNamespace(schemaClientSelector)
            schemaClientCataloguesNamespace = objectStore.createNamespace(schemaClientCataloguesSelector)

            # Abbreviated new style

            cataloguesSelector = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues", undefined)

            catalogues = objectStore.createNamespaceFromPath("schema.client.catalogues", undefined)

            jsonString = objectStore.toJSON()


            objectStore2 = new Encapsule.code.lib.omm.ObjectStore(objectModel, jsonString)

            ###



            # ==============================================================================

            Encapsule.runtime.app.SchemaScdlNavigatorWindow = new Encapsule.code.lib.modelview.NavigatorWindow(Encapsule.code.app.modelview.ScdlNavigatorWindowLayout)
            Encapsule.runtime.app.SchemaTitlebarWindow = new Encapsule.code.app.modelview.SchemaTitleBarWindow()
            Encapsule.runtime.app.SchemaBootInfoWindow = new Encapsule.code.app.modelview.SchemaBootInfoWindow()

            Encapsule.runtime.app.SchemaD3Main = new Encapsule.code.app.SchemaViewModelSvgPlane()

            Encapsule.runtime.app.SchemaWindowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager(Encapsule.code.app.winmgr.layout.root.Layout)


            Console.message "Initializing local URI routing:"
            Encapsule.runtime.app.SchemaRouter = new Encapsule.code.app.SchemaRouter()
            Encapsule.runtime.boot.phase0.router.setApplicationRouteCallback(Encapsule.runtime.app.SchemaRouter.routeChangedCallback)
            Console.message( Encapsule.runtime.app.SchemaRouter.getRoute() )
            Encapsule.runtime.app.SchemaRouter.setRoute(Encapsule.code.app.modelview.ScdlNavigatorWindowLayout.initialSelectionPath)


            #Encapsule.runtime.app.SchemaWindowManager.displayPlane("idSchemaPlaneScdlCatalogueNavigator")
            Encapsule.runtime.app.SchemaWindowManager.displayPlane("idSchemaPlaneD3")

            Encapsule.runtime.app.SchemaD3Main.initializeD3()


            Encapsule.runtime.boot.phase0.spinner.cancel()
            Console.message("#{appName} main application document.onLoad event handler exit error.")
            Encapsule.runtime.boot.phase0.blipper.blip "system-normal"

        catch exception
            Console.messageError """#{appPackagePublisher} #{appName} v#{appVersion} APP INIT FAIL:: #{exception}"""


