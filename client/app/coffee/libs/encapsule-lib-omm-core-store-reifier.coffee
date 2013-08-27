###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------

encapsule-lib-omm-core-store-reifier.coffee

------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}

ONMjs = Encapsule.code.lib.omm

#
# ****************************************************************************

class ONMjs.implementation.StoreReifier
    constructor: (objectStore_) ->
        try

            @store = objectStore_


            # 
            # ============================================================================
            @dispatchCallback = (address_, callbackName_, observerId_) =>
                try
                    if observerId_? and observerId_
                        # Use the specified observer ID to obtain the callback interface  registered with the
                        # store and then dispatch the specified callback on that interface only.
                        callbackInterface = @store.observers[observerId_]
                        if not (callbackInterface? and callbackInterface)
                            throw "Internal error: unable to resolve observer ID to obtain callback interface."
                        callbackFunction = callbackInterface[callbackName_]
                        if callbackFunction? and callbackFunction
                            callbackFunction(@store, observerId_, address_)
                    else
                        for observerId, callbackInterface of @store.observers
                            callbackFunction = callbackInterface[callbackName_]
                            if callbackFunction? and callbackFunction
                                callbackFunction(@store, observerId_, address_)

                catch exception
                    throw "ONMjs.implementation.StoreRefier.dispatchCallback failure: #{exception}"


            # 
            # ============================================================================
            @reifyStoreComponent = (address_, observerId_) =>
                try
                    if not (address_? and address_) then throw "Internal error: Missing address input parameter."

                    # Return immediately if there are no observers registered.
                    if not Encapsule.code.lib.js.dictionaryLength(@store.observers) then return

                    dispatchCallback = @dispatchCallback
                    dispatchCallback(address_, "onComponentCreated", observerId_)
                    address_.visitSubnamespacesAscending( (address__) -> dispatchCallback(address__, "onNamespaceCreated", observerId_) )

                    true # that

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.reifyStoreComponent failure: #{exception}"


            # 
            # ============================================================================
            @unreifyStoreComponent = (componentNamespaceSelector_, modelViewObject_, observerId_) =>
                try
                    componentNamespaceSelector_.internalVerifySelector()

                    # If broadcast (i.e. modelViewObject_ not specified or undefined) AND no observers then return.
                    if ( not (modelViewObserver_? and modelViewObserver_) ) and ( not Object.keys(@modelViewObservers).length )
                        return

                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onNamespaceRemoved
                    # Invoke the model view object's onNamespaceRemoved callback for each namespace in the root component.
                    # (reverse order - children first, then parent(s))
                    componentNamespaceIdsReverse = Encapsule.code.lib.js.clone(componentNamespaceSelector_.objectModelDescriptor.componentNamespaceIds)
                    componentNamespaceIdsReverse.reverse()
                    for namespaceId in componentNamespaceIdsReverse
                        namespaceSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceId, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)
                        if modelViewObject_? and modelViewObject_
                            if modelViewObject_.onNamespaceRemoved? and modelViewObject_.onNamespaceRemoved
                                modelViewObject_.onNamespaceRemoved(@, observerId_, namespaceSelector)
                        else
                            for observerId, modelViewObject of @modelViewObservers
                                if modelViewObject.onNamespaceRemoved? and modelViewObject.onNamespaceRemoved
                                    modelViewObject.onNamespaceRemoved(@, observerId, namespaceSelector)
                        @internalRemoveObserverNamespaceState(observerId, namespaceSelector)


                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onComponentRemoved
                    # Invoke the model view object's onComponentRemoved callback.
                    if modelViewObject_? and modelViewObject_
                        if modelViewObject_.onComponentRemoved? and modelViewObject_.onComponentRemoved
                            modelViewObject_.onComponentRemoved(@, observerId_, componentNamespaceSelector_)
                    else
                        for observerId, modelViewObject of @modelViewObservers
                            if modelViewObject.onComponentRemoved? and modelViewObject.onComponentRemoved
                                modelViewObject.onComponentRemoved(@, observerId, componentNamespaceSelector_)

                    @internalRemoveObserverNamespaceState(observerId, componentNamespaceSelector_)

                    true

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalUnreifyStoreComponent failure: #{exception}"

            # 
            # ============================================================================
            @reifyStoreExtensions = (componentNamespaceSelector_, modelViewObject_, observerId_, undoFlag_) =>
                try
                    componentNamespaceSelector_.internalVerifySelector()

                    # undoFlag indicates that we should reverse a prior reification (e.g. in response to
                    # a component being removed from the store.
                    undoFlag = undoFlag_? and undoFlag_ or false

                    # Dereference the component's object model descriptor and find its extension points.
                    componentObjectModelDescriptor = componentNamespaceSelector_.objectModelDescriptor

                    if not componentObjectModelDescriptor.isComponent 
                        throw "Invalid namespace selector does not correspond to a component in this object model."

                    componentExtensionPointMap = componentNamespaceSelector_.objectModelDescriptor.extensionPoints

                    for path, namespaceDescriptor of componentExtensionPointMap

                        # Use the extension point's ID obtained from namespace descriptor to create an object model namespace selector for the extension point.
                        extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(
                            namespaceDescriptor.id, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)

                        # Create a new store namespace object to gain access to the extension point array data.
                        extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector, "bypass")

                        extensionPointArray = extensionPointNamespace.objectStoreNamespace
                        if not (extensionPointArray.length?) then throw "Expected extension point array to support length property."

                        extensionJsonTag = namespaceDescriptor.children[0].jsonTag
                        extensionPath = "#{namespaceDescriptor.path}.#{extensionJsonTag}"
                        recursivelyDeclaredExtensionPoint = namespaceDescriptor.id > namespaceDescriptor.idArchetype

                        for component in extensionPointArray

                            subcomponentObject = component[extensionJsonTag]
                            subcomponentKey = @objectModel.getSemanticBindings().getUniqueKey(subcomponentObject)

                            subcomponentSelectKeyVector = undefined
                            subcomponentSecondaryKeyVector = undefined

                            if not recursivelyDeclaredExtensionPoint
                                subcomponentSelectKeyVector = Encapsule.code.lib.js.clone(componentNamespaceSelector_.selectKeyVector)
                                subcomponentSelectKeyVector.push subcomponentKey
                                subcomponentSecondaryKeyVector = []
                            else
                                subcomponentSelectKeyVector = componentNamespaceSelector_.selectKeyVector
                                subcomponentSecondaryKeyVector = Encapsule.code.lib.js.clone(componentNamespaceSelector_.secondaryKeyVector)
                                subcomponentSecondaryKeyVector.push({
                                    idExtensionPoint: namespaceDescriptor.id
                                    selectKey: subcomponentKey
                                    })

                            subcomponentNamespaceSelector = @objectModel.createNamespaceSelectorFromPath(extensionPath, subcomponentSelectKeyVector, subcomponentSecondaryKeyVector)

                            if not undoFlag
                                # Note that when we're reifying (i.e. reflecting the contents of the store out to the model view)
                                # that we proceed bottom-up (i.e. from root up towards leaves). The protocol is that namespaces are
                                # "created" parent-first and then the component is "created", and finally the component's 
                                # sub-components are evaluated until all leaf components have been processed and the entire branch
                                # or the store has been traversed.

                                # Reify the store subcomponent to the model view object.                                
                                @internalReifyStoreComponent(subcomponentNamespaceSelector, modelViewObject_, observerId_)

                                # *** RECURSION
                                @internalReifyStoreExtensions(subcomponentNamespaceSelector, modelViewObject_, observerId_, false)

                            else
                                # Note that when we're unreifying (i.e. undoing the a prior reification) that we proceed
                                # top-down (i.e. from the leaves down towards the root). Subcomponents are always evaluated 
                                # prior to their parent components. When a leaf component is discovered, it is "removed".
                                # The protocol is that the component is "removed" first, and then the namespaces are "removed"
                                # in the reverse order they were "created" during reification. Parent components are "removed"
                                # via the same protocol only after all their sub-components have been "removed" until the root
                                # component (which cannot be removed because it's not an extension) is reached.
                            
                                # *** RECURSION
                                @internalReifyStoreExtensions(subcomponentNamespaceSelector, modelViewObject_, observerId_, true)
                                
                                # Unreify the store subcomponent to the model view object.
                                @internalUnreifyStoreComponent(subcomponentNamespaceSelector, modelViewObject_, observerId_)

                            true

                            # END: for component in...

                        # END: for path, namespaceDescriptor of...

                    # extensionPointStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointNamespaceSelector_, "bypass")

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalReifyStoreExtensions failure: #{exception}"

        catch exception
            throw "Encapsule.code.lib.omm.StoreBase constructor failed: #{exception}"

