###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-omm-nav-selector-store.coffee
#
# Encapsulates the creation of an Encapsule.code.lib.omm.ObjectStore
# instance using the "selector" object model.

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}

Encapsule.code.lib.modelview.detail.SelectorObjectModelDescriptor = {

    jsonTag: "selector"
    label: "#{appName} Selector"
    description: "#{appName} selector root."

    externalIntegration:
        fnNotifyPathChange: (navigatorContainer_, path_) ->
            # We currently instantiate the SchemaRouter after the navigator. The first selection change
            # will not be forwarded. That's okay.
            if Encapsule.runtime.app.SchemaRouter? and Encapsule.runtime.app.SchemaRouter
                Encapsule.runtime.app.SchemaRouter.setRoute(path_)
            return true

    semanticBindings:
        update: (namespaceObjectReference_) ->
            revision = namespaceObjectReference_["revision"]
            updateTime = namespaceObjectReference_["updateTime"]
            revision++
            if revision? and revision
                namespaceObjectReference_["revision"] = revision
            if updateTime? and updateTime
                namespaceObjectReference_["updateTime"] =  Encapsule.code.lib.util.getEpochTime()
            return true

        getLabel: (namespaceObjectReference_) ->
            label = namespaceObjectReference_["name"]? and namespaceObjectReference_["name"] or
            namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or undefined
            return label

        getUniqueKey: (namespaceObjectReference_) ->
            key = namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or undefined
            return key

    menuHierarchy: [
        {
            jsonTag: "pathElements"
            label: "Path Elements"
            objectDescriptor: {
                mvvmType: "extension"
                description: "Array of path element object(s)."
                archetype: {
                    jsonTag: "pathElement"
                    label: "Path Element"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "Selector path element object."
                        namespaceDescriptor: {
                            userImmutable: {
                                uuid: {
                                    type: "uuid"
                                    fnCreate: -> uuid.v4()
                                    fnReinitialize: undefined
                                }
                                selector: {
                                    type: "object"
                                    fnCreate: -> undefined
                                    fnReinitialized: undefined
                                    }
                            }
                            userMutable: {}
                        }
                    }
                }
            }
        }
    ]
}





# customized for the Encapsule.code.lib.modelview.detail.SelectorObjectModelDescriptor
# object model (declaration above). 

class Encapsule.code.lib.modelview.SelectorStore extends Encapsule.code.lib.omm.ObjectStore
    constructor: (objectStore_, initialObjectStoreSelector_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter. Unable to determine external selector type."
            # Cache the associated objectStore parameter for later use.
            @associatedObjectStore = objectStore_
            # Create an ObjectModel instance from the selector object model declaration.
            selectorObjectModel = new Encapsule.code.lib.omm.ObjectModel(Encapsule.code.lib.modelview.detail.SelectorObjectModelDescriptor)
            # Initialize the base ObjectStore class for this SelectorStore
            super(selectorObjectModel)

            @getSelector = =>
                try
                    selector = @rootNamespace.objectStoreNamespace.externalSelector? and @rootNamespace.objectStoreNamespace.externalSelector or undefined
                    return selector
                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.getSelector failure: #{exception}"

            @setSelector = (externalSelector_) =>
                try
                    externalStoreNamespace = @associatedObjectStore.openNamespace(externalSelector_)
                    @rootNamespace.objectStoreNamespace.selector = externalSelector_
                    @rootNamespace.updateRevision()

                    index = @pathElementsNamespace.objectStoreNamespace.length - 1
                    while index >= 0
                         pathElementStoreNamespaceData = @pathElementsNamespace.objectStoreNamespace[index--].pathElement
                         @removeComponent(pathElementStoreNamespaceData.selector)

                    parentPathIdVector = externalSelector_.objectModelDescriptor.parentPathIdVector
                    for parentPathId in parentPathIdVector
                        pathElementSelector = @objectModel.createNamespaceSelectorFromPath("selector.pathElements.pathElement")
                        pathElementNamespace = @createComponent(pathElementSelector)
                        pathElementNamespace.objectStoreNamespace.selector = pathElementNamespace.getResolvedSelector()
                        pathElementNamespace.objectStoreNamespace.externalSelector =
                            @associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentPathId, externalStoreNamespace.getResolvedSelector())

                    pathElementSelector = @objectModel.createNamespaceSelectorFromPath("selector.pathElements.pathElement")
                    pathElementNamespace = @createComponent(pathElementSelector)
                    pathElementNamespace.objectStoreNamespace.selector = pathElementNamespace.getResolvedSelector()
                    pathElementNamespace.objectStoreNamespace.externalSelector = externalStoreNamespace.getResolvedSelector()
                    
                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.setSelector failure: #{exception}"
            
            externalSelector = initialObjectStoreSelector_
            if not (externalSelector? and externalSelector)
                externalSelector = @associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(0)
            
            rootSelector = selectorObjectModel.createNamespaceSelectorFromPath("selector")
            @rootNamespace = @openNamespace(rootSelector)
            pathElementsSelector = selectorObjectModel.createNamespaceSelectorFromPath("selector.pathElements")
            @pathElementsNamespace = @openNamespace(pathElementsSelector)

            @setSelector(externalSelector)

        catch exception
            throw "Encapsule.code.lib.omm.SelectorStore failure: #{exception}"


