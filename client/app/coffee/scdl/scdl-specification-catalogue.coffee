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
# schema/client/app/coffee/scdl/scdl-specification-catalogue.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableSpecificationCatalogue
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_scdl.ObservableCommonMeta()

        @specifications = ko.observableArray []

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @reinitializeCatalogue = =>
            @reinitializeMeta()
            @removeAllSpecifications()

        @removeAllSpecifications = =>
            @specifications.removeAll()

        @addSpecification = =>
            @specifications.push new Encapsule.code.app.scdl.specification.ObservableSpecification()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecificationCatalogue", ( ->
    """
    <div class="classScdlSpecificationCatalogue">
        <h2>SCDL Specifications:</h2>
        <p>SCDL specifications are defined as a simple nested hierarchy of SCDL system models composed via SCDL sockets and SCDL socket contracts.</p>
        <button data-bind="click: addSpecification" class="button small green">Add Specification</button>
        <button data-bind="click: removeAllSpecifications"  class="button small red">Remove All Specifications</button>
        <span data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></span>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSpecification', foreach: specifications }"></div>
    </div>
    """))
