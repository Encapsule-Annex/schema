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
# encapsule-lib-omm-core-component.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

class Encapsule.code.lib.omm.ObjectStoreComponent
    constructor: (objectStore_, componentSelector_, mode_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (mode_? and mode_) then throw "Missing mode input parameter!"
            if not (componentSelector_? and componentSelector_) then throw "Missing component root namespace selector input parameter!"

            componentDescriptor = componentSelector_.objectModelDescriptor
            if not componentDescriptor.isComponent
                throw "Specified path ID does not address the root of any known component in this object model."

            componentNamespaceIds = componentDescriptor.componentNamespaceIds

            if not (componentNamespaceIds.length? and componentNamespaceIds.length)
                throw "Internal error: Component namespace ID array should always be one or more elements!"

            @componentStoreNamespace = undefined

            for id in componentNamespaceIds

                componentNamespaceSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(id, componentSelector_.selectKeyVector, componentSelector_.secondaryKeyVector)
                componentStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(objectStore_, componentNamespaceSelector, mode_)

                if not (@componentStoreNamespace? and @componentStoreNamespace)
                    @componentStoreNamespace = componentStoreNamespace

            objectStore_.internalReifyStoreComponent(componentSelector_)

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreComponent failure '#{exception}'."
