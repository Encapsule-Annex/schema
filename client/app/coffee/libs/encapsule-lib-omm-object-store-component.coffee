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
# encapsule-lib-omm-object-store-component.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

class Encapsule.code.lib.omm.ObjectStoreComponent
    constructor: (objectStore_, selectKeyVector_, componentPathId_, mode_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (mode_? and mode_) then throw "Missing mode input parameter!"
            if not componentPathId_? then throw "Missing component path ID input parameter value!"

            componentRootNamespaceSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(componentPathId_, selectKeyVector_)
            componentObjectModelDescriptor = componentRootNamespaceSelector.objectModelDescriptor

            if not componentObjectModelDescriptor.isComponent
                throw "Specified path ID does not address the root of any known component in this object model."

            componentNamespaceIds = componentRootNamespaceSelector.objectModelDescriptor.componentNamespaceIds

            if not (componentNamespaceIds.length? and componentNamespaceIds.length)
                throw "Internal error: Component namespace ID array should always be one or more elements!"

            @componentStoreNamespace = undefined

            for id in componentNamespaceIds
                componentNamespaceSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(id, selectKeyVector_)
                componentStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(objectStore_, componentNamespaceSelector, mode_)
                if not (@componentStoreNamespace? and @componentStoreNamespace)
                    @componentStoreNamespace = componentStoreNamespace


        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreComponent failure '#{exception}'."
