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
# schema/client/app/coffee/scdl/scdl-specification-system-instance.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_specification = Encapsule.code.app.scdl.specification? and Encapsule.code.app.scdl.specification or @Encapsule.code.app.scdl.specification = {}


class namespaceEncapsule_code_app_scdl_specification.ObservableSystemInstance
    constructor: ->
        # The contained systemInstance is a ScdlModelInstance refering to a unique instance
        # of a SCDL system model within the scope of the SCDL specification.

        @systemInstance = ko.observable undefined

        # A SCDL system model may optionally define one or more extensibility points via contained
        # SCDL socket model(s). Our frame of reference is the scope of the the socket's parent system model.
        #
        # moduleSocketBindings is an array of ScdlSystemModuleSocketBinder objects each of which
        # map a socket instance defined by this ScdlSystemModule's associated ScdlModule model to
        # an array of ScdlSystemModule objects that are "socketed" (i.e. connected via the terms
        # of a ScdlSocketContract object.


        @socketInstanceBinders = ko.observableArray [] # an array of ObservableSocketInstanceBinder objects

        @addSocketInstanceBinder = =>
            @socketInstanceBinders.push new Encapsule.code.app.scdl.specification.ObservableSocketInstanceBinder()

        @removeAllSocketInstanceBinders = =>
            @socketInstanceBinders.removeAll()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecificationSystemInstance", ( ->
    """
    <div class="classScdlSpecificationSystemInstance">
        <h5>System Instance  <span data-bind="text: $index"></span>:</h5>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSpecificationSocketInstanceBinders' }"></div>
    </div>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecificationSocketInstanceBinders", ( ->
    """
    <div class="classScdlSpecificationSocketInstanceBinders">
        <h5>Socket Instance Binders:</h5>
        <button data-bind="click: addSocketInstanceBinder" class="button small green">Add Socket Instance Binder</button>
        <button data-bind="click: removeAllSocketInstanceBinders"  class="button small red">Remove All Socket Instance Binders</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSpecificationSocketInstanceBinder', foreach: socketInstanceBinders }"></div>
    </div>
    """))







