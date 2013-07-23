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
# encapsule-lib-navigator-window.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome
      constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->



class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow extends Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome

    constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->

        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope
            super(objectStore_, objectModelNavigatorWindow_, namespaceSelector_)

            # Cache references to this instance's construction parameters.
            @objectStore = objectStore_
            @objectModelNavigatorWindow = objectModelNavigatorWindow_
            @namespaceSelector = namespaceSelector_
            @children = ko.observableArray []

            @blipper = Encapsule.runtime.boot.phase0.blipper



            # / END: constructor try scope
        catch exception
            throw "Encapsule.code.lib.modelview.NavigatorWindowMenuLevel failure: : #{exception}"
        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorMenuWindow", ( ->
    """
        <div class="classObjectModelNavigatorWindow">
            <span data-bind="text: namespaceSelector.objectModelDescriptor.label"></span>
            <span data-bind="if: children().length">
            <div data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: children }"></div>
            </span>
        </div>
    </span>
    """))

