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
# schema/client/app/coffee/scdl/scdl-model-machine-tranisition.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableMachineTransition
    constructor: ->
        @startState = ko.observable undefined
        @vectors = ko.observableArray []

        @reinitializeTransition = =>
            @startState(undefined)
            @vectors.removeAll()

        @removeAllVectors = =>
            @vectors.removeAll()

        @addVector = =>
            @vectors.push new Encapsule.code.app.scdl.model.ObservableMachineTransitionVector()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelMachineTransition", ( ->
    """
    <div class="classScdlMachineTransition">
        <h4>State Transition <span data-bind="text: $index"></span>:</h4>
        <button data-bind="click: reinitializeTransition" class="button small red">Re-initialize Transition</button>
        Start State: <span data-bind="text: startState"></span><br>
        <div class="classEditAreaMachineTransitionVectors">
            <h4>Vectors:</h4>
            <button data-bind="click: addVector" class="button small green">Add Vector</button>
            <button data-bind="click: removeAllVectors" class="button small red">Remove All Vectors</button>

            <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachineTransitionVector', foreach: vectors }"></div>
        </div>
    </div>
    """))

