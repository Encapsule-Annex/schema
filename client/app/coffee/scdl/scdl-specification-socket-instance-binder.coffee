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
# schema/client/app/coffee/scdl/scdl-specification-socket-instance-binder.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_specification = Encapsule.code.app.scdl.specification? and Encapsule.code.app.scdl.specification or @Encapsule.code.app.scdl.specification = {}


class namespaceEncapsule_code_app_scdl_specification.ObservableSocketInstanceBinder
    constructor: ->
        # systemSocketInstanceId is the instance ID of a specific SCDL socket instance contained within an instance of a SCDL system that is part of a SCDL specification.
        @systemSocketInstanceId = ko.observable undefined
        @socketedSystemInstances = ko.observableArray []



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecificationSocketInstanceBinder", ( ->
    """
    <h5>Socket Instance Binder <span data-bind="text: $index"></span>:</h5>
    """))

