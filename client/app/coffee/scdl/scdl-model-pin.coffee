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


class namespaceEncapsule_code_app_scdl_model.ObservablePin
    constructor: (direction_) ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @typeRef = ko.observable undefined
        @direction = ko.observable direction_

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @reinitializePin = =>
            Console.message("ViewModel_ScdlPin::resetPin")
            @meta().reinitializeMeta()
            @typeRef(undefined)



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPin", ( ->
    """
    <div class="classScdlMachinePin">
        <h5><span data-bind="text: direction"></span> Pin <span data-bind="text: $index "></span>:</h5>
        <button data-bind="click: reinitializePin" class="button small red">Re-initialize Pin</button>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
        Data type: <span data-bind="text: typeRef"></span><br>
    </div>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelInputPins", ( ->
    """
    <div class="classEditAreaMachineInputPins">
        <h4>Input Pins:</h4>
        <button data-bind="click: addInputPin" class="button small green">Add Input Pin</button>
        <button data-bind="click: removeAllInputPins" class="button small red">Remove All Input Pins</button>
        <div class="classScdlMachineInputPins">
            <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: inputPins }"></div>
        </div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelOutputPins", ( ->
    """
    <div class="classEditAreaMachineOutputPins">
        <h4>Output Pins:</h4>
        <button data-bind="click: addOutputPin"  class="button small green">Add Output Pin</button>
        <button data-bind="click: removeAllOutputPins" class="button small red">Remove All Output Pins</button>
        <div class="classScdlMachineOutputPins">
            <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: outputPins }"></div>
        </div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPins", ( ->
    """
    <div class="classEditAreaMachinePins">
        <h3>Pins:</h3>
        <button data-bind="click: removeAllPins" class="button small red">Remove All Pins</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineInputPins_View' }" class="classEditAreaMachineInputPins"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineOutputPins_View' }" class="classEditAreaMachineOutputPins"></div>
    </div>
    """))

