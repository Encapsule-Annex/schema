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
# schema/client/app/coffee/scdl/scdl-model-module.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableModule
    constructor: ->
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @inputPins = ko.observableArray []
        @outputPins = ko.observableArray []
        @modelInstances = ko.observableArray []
        @nodes = ko.observableArray []

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @addInputPin = =>
            @inputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Input")

        @removeAllInputPins = =>
            @inputPins.removeAll()

        @addOutputPin = =>
            @outputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Output")

        @removeAllOutputPins = =>
            @outputPins.removeAll()

        @removeAllPins = =>
            @removeAllInputPins()
            @removeAllOutputPins()

        @addModelInstance = =>
            @modelInstances.push new Encapsule.code.app.scdl.model.ObservableModelInstance()

        @removeAllModelInstances = =>
            @modelInstances.removeAll()

        @addNode = =>
            @nodes.push new Encapsule.code.app.scdl.model.ObservableNode()

        @removeAllNodes = =>
            @nodes.removeAll()

        @reinitializeModule = =>
            @removeAllPins()
            @removeAllModelInstances()
            @removeAllNodes()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelInstances", ( ->
    """
    <div class="classScdlModelInstances">
        <h2>Contained Model Instances:</h2>
        <button data-bind="click: addModelInstance" class="button small green">Add Model Intance</button>
        <button data-bind="click: removeAllModelInstances" class="button small red">Remove All Model Instances</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelInstance', foreach: modelInstances }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelModule", ( ->
    """
    <div class="classScdlModelModule">
        <h3>Module <span data-bind="text: $index"></span>:</h3>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelPins' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelInstances' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelNodes' }"></div>

    </div>
    """))

