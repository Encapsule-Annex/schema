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




class Encapsule.code.lib.modelview.ObjectModelNavigatorWindow
    #
    # ============================================================================
    onNamespaceCreated: (objectStore_, observerId_, namespaceSelector_) =>
        try
            Console.message("ObjectModelNavigatorWindowBase.onNamespaceCreated observerId=#{observerId_}")
            namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)
            namespaceState.menuModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow(objectStore_, @, namespaceSelector_)
            if namespaceSelector_.pathId == 0
                @rootMenuModelView = namespaceState.menuModelView
            parentDescriptor = namespaceSelector_.objectModelDescriptor.parent? and namespaceSelector_.objectModelDescriptor.parent or undefined
            if parentDescriptor? and parentDescriptor
                parentSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(parentDescriptor.id, namespaceSelector_.selectKeyVector)
                parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)
                parentNamespaceState.menuModelView.children.push namespaceState.menuModelView
                namespaceState.indexInParentChildArray = parentNamespaceState.menuModelView.children().length - 1

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase.onNamespaceCreated failure: #{exception}"
        

    #
    # ============================================================================
    onNamespaceRemoved: (objectStore_, observerId_, namespaceSelector_) =>
        try
            Console.message("ObjectModelNavigatorWindowBase.onNamespaceRemoved observerId=#{observerId_}")
            namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)
            if namespaceSelector_.pathId == 0
                @rootMenuModelView = undefined
            parentDescriptor = namespaceSelector_.objectModelDescriptor.parent? and namespaceSelector_.objectModelDescriptor.parent or undefined
            if parentDescriptor? and parentDescriptor
                parentSelector = objectStore_.objectModel.createNamespaceSelectorFromPathId(parentDescriptor.id, namespaceSelector_.selectKeyVector)
                parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)
                parentNamespaceState.menuModelView.children.splice(namespaceState.indexInParentChildArray, 1)
                return true

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindow.onNamespaceRemoved failure: #{exception}"

    constructor: ->
        # \ BEGIN: constructor
        try
            @blipper = Encapsule.runtime.boot.phase0.blipper
            @rootMenuModelView = undefined

        catch exception
            throw " Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase constructor failure: #{exception}"

        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorWindow", ( -> """
<span data-bind="if: rootMenuModelView">
    <div data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: rootMenuModelView.children }"></div>
</span>
"""))


