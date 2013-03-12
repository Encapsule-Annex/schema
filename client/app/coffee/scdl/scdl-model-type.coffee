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
# schema/client/app/coffee/scdl/scdl-model-type.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableType
    constructor: ->

        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @descriptor = ko.observable undefined

        @resetType = =>
             @meta().reinitializeMeta()
             @descriptor(undefined)



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelTypes", ( ->
    """
    <div class="classScdlModelTypes">
        <h3>SCDL Type Models:</h3>
        <p>A SCDL type model is a label applied to input and output pins to denote the type of information that passed between pins via SCDL node models.</p>
        <button data-bind="click: addType" class="button small green">Add Type</button>
        <button data-bind="click: removeAllTypes" class="button small red">Remove All Types</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelType', foreach: types }"></div>
    </div>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelType", ( ->
    """
    <div class="classScdlModelType">
       <h3>Type <span data-bind="text: $index"></span>: {<span data-bind="with: meta"><span data-bind="text: uuid"></span></span>}</h3>
       <button data-bind="click: resetType" class="button small red">Reset Type</button>
       <span data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></span>
       Descriptor: <span data-bind="text: descriptor"></span><br>
    </div>
    """))

