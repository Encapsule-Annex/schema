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
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
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
            @inputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin("Input")

        @addOutputPin = =>
            Console.message("ViewModel_ScdlMachine::addOutputPin")
            @outputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin("Output")

        @addState = =>
            Console.message("ViewModel_ScdlMachine::addState")
            @states.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachineState()

        @addTransition = =>
            @transitions.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransition()



