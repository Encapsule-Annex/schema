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
# schema/client/app/coffee/scdl/scdl-model-pin-instance.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservablePinInstance
    constructor: (direction_) ->
        @direction = ko.observable direction_
        @modelInstanceUuid = ko.observable undefined
        @pinUuid = ko.observable undefined



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPinInstance", ( ->
    """
    <div class="classScdlPinInstance">
        <h4><span data-bind="text: direction"></span> Pin Instance <span data-bind="text: $index"></span>:</h4>
        <div>SCDL model instance UUID: <span data-bind="text: modelInstanceUuid"></span></div>
        <div>SCDL pin identifer on model: <span data-bind="text: pinUuid"></span></div>
    </div>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelInputPinInstances", ( ->
    """
    <div class="classScdlInputPinInstances">
        <h3>Input Pin Instances:</h3>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelPinInstance', foreach: inputPinInstances }"></div>
    </div>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelOutputPinInstances", ( ->
    """
    <div class="classScdlOutputPinInstances">
        <h3>Output Pin Instances:</h3>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelPinInstance', foreach: outputPinInstances }"></div>
    </div>
    """))



