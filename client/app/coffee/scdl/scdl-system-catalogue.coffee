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
# schema/client/app/coffee/scdl/scdl-system-catalogue.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableSystemCatalogue
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_scdl.ObservableCommonMeta()

        @systems = ko.observableArray []

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @reinitializeCatalogue = =>
            @reinitializeMeta()
            @removeAllSystems()

        @removeAllSystems = =>
            @systems.removeAll()

        @addSystem = =>
            @systems.push new Encapsule.code.app.scdl.system.ObservableSystem()








Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSystemCatalogue", ( ->
    """
    <div class="classScdlSystemCatalogue">
        <h2>SCDL System Specifications:</h2>
        <p>SCDL system specifications are defined as a simple nested hierarchy of SCDL module models composed via SCDL sockets and SCDL socket contracts.</p>
        <p>Most systems, even insanely complex systems, are represented by a tree with a single root SCDL module that contains some SCDL sockets into
        which other SCDL modules are inserted. This seemingly simple nesting relationship wholey encapsulates an arbitrary complex extension mechanism:
        a single edge in a SCDL system graph represents an arbitrarily complex data bus connection between modules.</p>
        <p>But nobody needs concern themselves with complex data bus connections when composing a custom SCDL system specification: If a module fits into a socket, it can be inserted.
        That's the only rule for building SCDL system specifications.</p>
        <p>This means that you can build "kits" of SCDL models from which <i>anyone</i> can compose a custom SCDL system specification.</p>
        <p>SCDL system specifications can be converted into runtime code via automated program transformation (or interpreted by a fancy generic program).</p>
        <p>So LEGO for software IP. Is it starting to make sense?</p>

        <div class="classScdlCatalogueButtons">
            <button data-bind="click: addSystem" class="button small green">Add System</button>
            <button data-bind="click: removeAllSystems"  class="button small red">Remove All Systems</button>
        </div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlSystems", ( ->
    """
    <h2>Systems:</h2>
    <button data-bind="click: addSystem"  class="button small green">Add System</button>
    <button data-bind="click: removeAllSystems"  class="button small red">Remove All Systems</button>
    <div data-bind="template: { name: 'idKoTemplate_ScdlSystem_View', foreach: systems }" class="classScdlSystems"></div>
    """))
