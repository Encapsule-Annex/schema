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

    onNamespaceCreated: (objectStore_, observerId_, namespaceSelector_) =>
        try
            Console.message("ObjectModelNavigatorWindowBase.onNamespaceCreated observerId=#{observerId_}")
            namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)
            namespaceState.selector = namespaceSelector_
            namespaceState.children = []
            parentDescriptor = namespaceSelector_.objectModelDescriptor.parent? and namespaceSelector_.objectModelDescriptor.parent or undefined
            if parentDescriptor? and parentDescriptor
                parentSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(parentDescriptor.id, namespaceSelector_.selectKeyVector)
                parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)
                parentNamespaceState.children[namespaceSelector_.pathId] = namespaceState

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase.onNamespaceCreated failure: #{exception}"
        

    onNamespaceRemoved: (objectStore_, observerId_, namespaceSelector_) =>
        try
            Console.message("ObjectModelNavigatorWindowBase.onNamespaceRemoved observerId=#{observerId_}")
            namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)
            parentDescriptor = namespaceSelector_.objectModelDescriptor.parent? and namespaceSelector_.objectModelDescriptor.parent or undefined
            if parentDescriptor? and parentDescriptor
                parentSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(parentDescriptor.id, namespaceSelector_.selectKeyVector)
                parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)
                parentNamespaceState.children.splice(namespaceSelector_.pathId, 1)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase.onNamespaceRemoved failure: #{exception}"


    onNamespaceUpdated: (objectStore_, observerId_, namespaceSelector) =>

            


    constructor: ->
        # \ BEGIN: constructor
        try



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
SUP!

"""))


