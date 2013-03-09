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
# schema/client/app/coffee/scdl/scdl-system-module-socket-binder.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_system = Encapsule.code.app.scdl.system? and Encapsule.code.app.scdl.system or @Encapsule.code.app.scdl.system = {}


class namespaceEncapsule_code_app_scdl_system.ObservableModuleSocketBinder
    constructor: ->
        # moduleSocketInstanceId is the instance ID of a specific SCDL socket contained within a SCDL module model.
        @moduleSocketInstanceId = ko.observable undefined
        @socketedSystemModuleInstances = ko.observableArray []



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSystemModuleSocketBinder", ( ->
    """
    <h5>Module Socket Binder <span data-bind="text: $index"></span>:</h5>
    """))

