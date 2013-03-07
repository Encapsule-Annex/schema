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
# schema/client/app/coffee/scdl/scdl-model-socket.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableSocket
    constructor: ->
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @inputPins = ko.observableArray []
        @outputPins = ko.observableArray []
        @populationRequired = ko.observable false
        @populationLimit = ko.observable 1
        @populationPartition = ko.observable undefined

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @resetSocket = =>
            @populationRequired(false)
            @populationLimit(1)
            @populationPartition(undefined)

        @removeAllInputPins = =>
            @inputPins.removeAll()

        @removeAllOutputPins = =>
            @outputPins.removeAll()

        @removeAllPins = =>
            @removeAllInputPins()
            @removeAllOutputPins()

        @addInputPin = =>
            @inputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Input")

        @addOutputPin = =>
            @outputPins.push new Encapsule.code.app.scdl.model.ObservablePin("Output")




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelSocket", ( ->
    """
    <div class="classScdlModelSocket">
        <h3>Socket <span data-bind="text: $index"></span>:</h3>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelPins' }"></div>
        <div>Population required: <span data-bind="text: populationRequired"></span></div>
        <div>Population limit: <span data-bind="text: populationLimit"></span></div>
        <div>Population partition: <span data-bind="text: populationPartition"></span></div>
    </div>
    """))

