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
# schema/client/app/coffee/scdl/scdl-model-machine.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableMachine
    constructor: ->
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @inputPins = ko.observableArray []
        @outputPins = ko.observableArray []
        @states = ko.observableArray []
        @transitions = ko.observableArray []

        @reinitializeMachine = =>
            @reinitializeMeta()
            @removeAllInputPins()
            @removeAllOutputPins()
            @removeAllTransitions()
            @removeAllStates()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllInputPins = =>
            @inputPins.removeAll()

        @removeAllOutputPins = =>
            @outputPins.removeAll()

        @removeAllPins = =>
            @removeAllInputPins()
            @removeAllOutputPins()

        @removeAllTransitions = =>
            @transitions.removeAll()

        @removeAllStates = =>
            @states.removeAll()

        @addInputPin = =>
            Console.message("ViewModel_ScdlMachine::addInputPin")
            @inputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Input")

        @addOutputPin = =>
            Console.message("ViewModel_ScdlMachine::addOutputPin")
            @outputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Output")

        @addState = =>
            Console.message("ViewModel_ScdlMachine::addState")
            @states.push new Encapsule.code.app.scdl.model.ObservableMachineState()

        @addTransition = =>
            @transitions.push new Encapsule.code.app.scdl.model.ObservableMachineTransition()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelMachine", ( ->
    """
    <div class="classScdlModelMachine">
        <h3>Machine <span data-bind="text: $index"></span>:</h3>
        <button data-bind="click: reinitializeMachine" class="button small red">Re-initialize Machine</button>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelPins' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachineStates' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachineTransitions' }"></div>
    </div><!-- classScdlMachine -->
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelMachineStates", ( ->
    """
    <div class="classScdlModelMachineStates">
        <h3>Machine States</h3>
        <button data-bind="click: addState" class="button small green">Add State</button>
        <button data-bind="click: removeAllStates" class="button small red">Remove All States</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachineState', foreach: states }"></div>
    </div>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelMachineTransitions", ( ->
    """
    <div class="classScdlModelMachineTransitions">
        <h3>Transitions:</h3>
        <button data-bind="click: addTransition" class="button small green">Add Transition</button>
        <button data-bind="click: removeAllTransitions" class="button small red">Remove All Transitions</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachineTransition', foreach: transitions}"></div>
    </div>
    """))

