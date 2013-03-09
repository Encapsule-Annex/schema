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
# schema/client/app/coffee/scdl/scdl-specification.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_specification = Encapsule.code.app.scdl.specification? and Encapsule.code.app.scdl.specification or @Encapsule.code.app.scdl.specification = {}

# THE GRAIL

class namespaceEncapsule_code_app_scdl_specification.ObservableSpecification
    constructor: ->
        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()

        # An array of SCDL module system instances
        @systemInstances = ko.observableArray []

        @addSystemInstance = =>
            @systemInstances.push new Encapsule.code.app.scdl.specification.ObservableSystemInstance()

        @removeAllSystemInstances = =>
            @systemInstances.removeAll()
       


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecification", ( ->
    """
    <h3>Specification <span data-bind="text: $index"></span>:</h3>
    <button data-bind="click: addSystemInstance" class="button small green">Add System Instance</button>
    <button data-bind="click: removeAllSystemInstances"  class="button small red">Remove All System Instances</button>
    <span data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></span>
    <div data-bind="template: { name: 'idKoTemplate_ScdlSpecificationSystemInstances' }"></div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSpecificationSystemInstances", ( ->
    """
    <div class="classScdlSpecificationSystemInstances">
        <h4>System Instances:</h4>
        <div data-bind="template: { name: 'idKoTemplate_ScdlSpecificationSystemInstance', foreach: systemInstances }"></div>
    </div>
    """))
