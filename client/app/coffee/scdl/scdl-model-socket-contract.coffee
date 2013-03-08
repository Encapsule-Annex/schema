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
# schema/client/app/coffee/scdl/scdl-model-socket-contract.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableSocketContract
    constructor: ->
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @socketUuid = ko.observable undefined
        @modelUuid = ko.observable undefined
        @nodes = ko.observableArray [] # array of ScdlNode objects

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @resetSocketUuid = =>
            @socketUuid(undefined)

        @resetModelUuid = =>
            @modelUuid(undefined)

        @removeAllNodes = =>
            @nodes.removeAll()

        @addNode = =>
            @nodes.push new Encapsule.code.app.scdl.model.ObservableNode()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelSocketContract", ( ->
    """
    <div class="classScdlModelSocketContract">
        <h3>Socket Contract <span data-bind="text: $index"></span>:</h3>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <div>Contract for socket UUID: <span data-bind="text: socketUuid"></span></div>
        <div>Extensible by model UUID: <span data-bind="text: modelUuid"></span></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelNodes' }" class="classScdlSocketContractNodes"></div>

    </div>
    """))