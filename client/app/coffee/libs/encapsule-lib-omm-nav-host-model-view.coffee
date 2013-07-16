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
# encapsule-lib-omnav-model-view.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}

class Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase
    constructor: (objectModelManagerStore_) ->
        # \ BEGIN: constructor
        try
            if not (objectModelManagerStore_? and objectModelManagerStore_) then throw "Missing object model manager store object input parameter!"

            # Save a reference to the associated object store.
            @objectModelManagerStore = objectModelManagerStore_

            # Build a menu level model view object for each namespace descriptor
            # cached in the object store's associated object model.

            @menuObjectById = []

            pathId = 0
            namespaceDescriptorByIdArray = objectModelManagerStore_.objectModel.objectModelDescriptorById
            pathIdCount = namespaceDescriptorByIdArray.length
            while pathId < pathIdCount
                # Dereference the next current and parent namespace descriptors.
                namespaceDescriptor = namespaceDescriptorByIdArray[pathId]
                parentNamespaceDescriptor = namespaceDescriptor.parent
                parentMenuObject = parentNamespaceDescriptor? and parentNamespaceDescriptor and @menuObjectById[parentNamespaceDescriptor.id] or undefined
                # Create a new menu window instance
                childMenuObject = @menuObjectById[pathId] = new Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow(@, namespaceDescriptor)
                if parentMenuObject? and parentMenuObject
                    # Add the newly create menu object to its parent's childMenuObjects array.
                    parentMenuObject.childMenuObjects.push childMenuObject
                pathId++

            

            


        catch exception
            throw " Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase constructor failure: #{exception}"

        # / END: constructor




class Encapsule.code.lib.modelview.ObjectModelNavigatorWindow extends Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase
    constructor: (objectModelManagerStore_) ->
        # \ BEGIN: constructor
        try
            # \ BEGIN: constructor try scope

            super(objectModelManagerStore_)
            


            @blipper = Encapsule.runtime.boot.phase0.blipper

            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorWindow", ( -> """
<span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: menuObjectById[0].childMenuObjects }"></span>
"""))


