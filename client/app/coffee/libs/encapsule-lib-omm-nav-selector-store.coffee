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




# customized for the Encapsule.code.lib.modelview.detail.SelectorObjectModelDescriptor
# object model (declaration above). 

class Encapsule.code.lib.modelview.SelectorStore extends Encapsule.code.lib.omm.ObjectStore
    constructor: (objectStore_, initialObjectStoreSelector_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter. Unable to determine external selector type."
            # Cache the associated objectStore parameter for later use.
            @associatedObjectStore = objectStore_
            # Create an ObjectModel instance from the selector object model declaration.
            selectorObjectModel = new Encapsule.code.lib.omm.ObjectModel(
                {
                    jsonTag: "selector"
                    label: "#{appName} Selector"
                    description: "#{appName} selector root."
                })
            # Initialize the base ObjectStore class for this SelectorStore
            super(selectorObjectModel)

            @getSelector = =>
                try
                    selector = @rootNamespace.objectStoreNamespace.pathElements[@rootNamespace.objectStoreNamespace.pathElements.length - 1]
                    return selector
                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.getSelector failure: #{exception}"

            @setSelector = (externalSelector_) =>
                try
                    # Verify that externalSelector_ addresses an actual store namespace.
                    externalStoreNamespace = @associatedObjectStore.openNamespace(externalSelector_)
                    # Save the new external selector.
                    pathElementsArray = @rootNamespace.objectStoreNamespace.pathElements? and @rootNamespace.objectStoreNamespace.pathElements or @rootNamespace.objectStoreNamespace.pathElements = []
                    pathElementsArray.splice(0, pathElementsArray.length)
                    parentPathIdVector = externalSelector_.objectModelDescriptor.parentPathIdVector
                    for parentPathId in parentPathIdVector
                        parentSelector = @associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentPathId, externalSelector_.selectKeyVector)
                        pathElementsArray.push parentSelector
                    pathElementsArray.push externalSelector_
                    
                    @rootNamespace.updateRevision()

                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.setSelector failure: #{exception}"
            
            externalSelector = initialObjectStoreSelector_
            if not (externalSelector? and externalSelector)
                externalSelector = @associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(0)
            
            rootSelector = selectorObjectModel.createNamespaceSelectorFromPath("selector")
            @rootNamespace = @openNamespace(rootSelector)
            
            @setSelector(externalSelector)


        catch exception
            throw "Encapsule.code.lib.omm.SelectorStore failure: #{exception}"

