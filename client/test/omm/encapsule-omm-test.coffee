

            

            # Temporary code to test registraton/unregistration and callbacks from object store

            ###
            omNav.onComponentCreated = (observerId_, namespaceSelector_) ->
                Console.message("onComponentCreated observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onComponentUpdated = (observerId_, namespaceSelector_) ->
                Console.message("onComponentUpdated observerId='#{observerId_}' path=#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onChildComponentUpdated = (observerId_, namespaceSelector_) ->
                Console.message("onChildComponentUpdated observerId='#{observerId_}' path=#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onComponentRemoved = (observerId_, namespaceSelector_) ->
                Console.message("onComponentRemoved observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onNamespaceCreated = (observerId_, namespaceSelector_) ->
                Console.message("onNamespaceCreated observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onNamespaceUpdated = (observerId_, namespaceSelector_) ->
                Console.message("onNamespaceUpdated observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onChildNamespaceUpdated = (observerId_, namespaceSelector_) ->
                Console.message("onChildNamespaceUpdated observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onParentNamespaceUpdated = (observerId_, namespaceSelector_) ->
                Console.message("onParentNamespaceUpdated observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")

            omNav.onNamespaceRemoved = (observerId_, namespaceSelector_) ->
                Console.message("onNamespaceRemoved observerId='#{observerId_}' path='#{namespaceSelector_.objectModelDescriptor.path}' selector='#{namespaceSelector_.getHashString()}'")



            # Console.message("*** REGISTER MODEL VIEW")

            Console.message("*** CREATE A NEW SCDL MACHINE MODEL WITH AN OBSERVER REGISTERED")
            machineSelector = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues.catalogue.models.machines.machine")
            machineNamespace = objectStore.createComponent(machineSelector)

            Console.message("*** REVISE THE MACHINE NAMESPACE")
            machineSelector = machineNamespace.getResolvedSelector()
            machineNamespace.updateRevision()

            # Console.message("*** REMOVE THE SCDL MACHINE MODEL WITH AN OBSERVER REGISTERED")
            catalogueSelector = objectModel.createNamespaceSelectorFromPath("schema.client.catalogues.catalogue", machineSelector.selectKeyVector)
            # reconstitutedStore.removeComponent(machineSelector)
            # reconstitutedStore.removeComponent(catalogueSelector)

            
            # Just for grins, re-register the same model view so we get two notifation callback streams
            # when we unregister below.

            # Console.message("*** ATTACH ANOTHER MODEL VIEW OBSERVER TO THE STORE")
            # id2 = reconstitutedStore.registerModelViewObserver(omNav)

            jsonFinal = objectStore.toJSON(undefined, 4)
            Console.messageRaw("<pre>#{jsonFinal}</pre>")


            # Console.message("*** UNREGISTER MODEL VIEWS")
            # reconstitutedStore.unregisterModelViewObserver(omNavObserverId)
            # reconstitutedStore.unregisterModelViewObserver(id2)
            
            ###

