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
# schema/client/app/coffee/scdl/scdl-asset-meta.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableCommonMeta
    constructor: ->

        @uuid = ko.observable uuid.v4()
        @name = ko.observable undefined
        @description = ko.observable undefined
        @notes = ko.observable undefined
        @author = ko.observable undefined
        @organization = ko.observable undefined
        @license = ko.observable undefined
        @copyright = ko.observable undefined
        @revision = ko.observable 0
        @createTime = ko.observable Encapsule.code.lib.util.getEpochTime()
        @updateTime = ko.observable Encapsule.code.lib.util.getEpochTime()

        @reinitializeMeta = =>
            @uuid(uuid.v4())
            @name(undefined)
            @description(undefined)
            @notes(undefined)
            @author(undefined)
            @organization(undefined)
            @license(undefined)
            @revision(0)
            @createTime(Encapsule.code.lib.util.getEpochTime())
            @updateTime(Encapsule.code.lib.util.getEpochTime())



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlCommonMeta", ( ->
    """
    <div class="classEditAreaMeta">
        <h2>Meta:</h2>
        <button data-bind="click: reinitializeMeta" class="button small red">Re-initialize Meta</button>
        UUID: <span data-bind="text: uuid"></span> 
        Revision: <span data-bind="text: revision"></span>
        Create: <span data-bind="text: createTime"></span>
        Update: <span data-bind="text: updateTime"></span><br>
        Name: <span data-bind="text: name"></span>
        Description: <span data-bind="text: description"></span><br>
        Author: <span data-bind="text: author"></span>
        Organization: <span data-bind="text: organization"></span><br>
        License: <span data-bind="text: license"></span>
        Copyright: <span data-bind="text: copyright"></span>
    </div>
    """))


