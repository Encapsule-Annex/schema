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
# schema/client/app/coffee/scdl/scdl-system-module.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_system = Encapsule.code.app.scdl.system? and Encapsule.code.app.scdl.system or @Encapsule.code.app.scdl.system = {}


class namespaceEncapsule_code_app_scdl_system.ObservableContainedModuleInstance
    constructor: ->
        # The contained moduleInstance is a ScdlModelInstance refering to a unique instance
        # of a SCDL module model.

        @moduleInstance = ko.observable undefined

        # A SCDL module model may optionally define one or more extensibility points via contained
        # SCDL socket model(s). Our frame of reference in this object scope here is a single module.
        #
        # moduleSocketBindings is an array of ScdlSystemModuleSocketBinder objects each of which
        # map a socket instance defined by this ScdlSystemModule's associated ScdlModule model to
        # an array of ScdlSystemModule objects that are "socketed" (i.e. connected via the terms
        # of a ScdlSocketContract object.


        @moduleSocketBinders = ko.observableArray [] # an array of ScdlSystemModuleSocketBinder objects

        @addModuleSocketBinder = =>
            @moduleSocketBinders.push new Encapsule.code.app.scdl.system.ObservableModuleSocketBinder()

        @removeAllModuleSocketBinders = =>
            @moduleSocketBinders.removeAll()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSystemContainedModuleInstance", ( ->
    """
    <div class="classScdlSystemContainedModule">
        <h5>Contained Module <span data-bind="text: $index"></span>:</h5>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSystemModuleSocketBinders' }"></div>
    </div>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSystemModuleSocketBinders", ( ->
    """
    <div class="classScdlSystemModuleSocketBinders">
        <h5>Contained Module Socket Bindings:</h5>
        <button data-bind="click: addModuleSocketBinder" class="button small green">Add Module Socket Binder</button>
        <button data-bind="click: removeAllModuleSocketBinders"  class="button small red">Remove All Module Socket Binders</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSystemModuleSocketBinder', foreach: moduleSocketBinders }"></div>
    </div>
    """))







