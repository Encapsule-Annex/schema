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
# schema/client/app/coffee/scdl/scdl-model-pin.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class Encapsule.code.app.scdl.model.ObservablePin
    constructor: (direction_) ->
        # SCDL data
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @typeRef = ko.observable undefined
        @direction = ko.observable direction_

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @reinitializePin = =>
            @meta().reinitializeMeta()
            @typeRef(undefined)




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPin", ( ->
    """
    <h5><span data-bind="text: direction"></span> Pin <span data-bind="text: $index "></span>:</h5>
    <button data-bind="click: reinitializePin" class="button small red">Re-initialize Pin</button>
    <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
    <strong>Data type: </strong><span data-bind="text: typeRef"></span><br>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelInputPin", ( ->
    """
    <div class="classScdlModelMachineInputPin">
        <h5><span data-bind="text: direction"></span> Pin <span data-bind="text: $index "></span>:</h5>
        <button data-bind="click: reinitializePin" class="button small red">Re-initialize Pin</button>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <strong>Data type: </strong><span data-bind="text: typeRef"></span><br>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelOutputPin", ( ->
    """
    <div class="classScdlModelMachineOutputPin">
        <h5><span data-bind="text: direction"></span> Pin <span data-bind="text: $index "></span>:</h5>
        <button data-bind="click: reinitializePin" class="button small red">Re-initialize Pin</button>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <strong>Data type: </strong><span data-bind="text: typeRef"></span><br>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelInputPins", ( ->
    """
    <div class="classScdlModelMachineInputPins">
        <h4>SCDL Input Pin Models:</h4>
        <p>SCDL input pins model data receivers. Any number of SCDL pins may be connected to a SCDL node.</p>
        <button data-bind="click: editNewInputPin" class="button small green">Add Input Pin</button>
        <button data-bind="click: removeAllInputPins" class="button small red">Remove All Input Pins</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelInputPin', foreach: inputPins }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelOutputPins", ( ->
    """
    <div class="classScdlModelMachineOutputPins">
        <h4>SCDL Output Pin Models:</h4>
        <p>SCDL output pins model data transimitters. A single SCDL output pin may be connected to any number of SCDL input pins via a SCDL node model in order to define a data dependency relationship.</p>
        <button data-bind="click: addOutputPin"  class="button small green">Add Output Pin</button>
        <button data-bind="click: removeAllOutputPins" class="button small red">Remove All Output Pins</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelOutputPin', foreach: outputPins }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPins", ( ->
    """
    <div class="classScdlModelMachinePins">
        <h3>SCDL Pin Models:</h3>
        <p>SCDL pin models define points of connectivity between SCDL machines, modules, and sockets. Pins are constrained to carry one and only one type of information indicated by the pin's associated SCDL type model attribute.</p>
        <button data-bind="click: removeAllPins" class="button small red">Remove All Pins</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelInputPins' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelOutputPins' }"></div>
    </div>
    """))




