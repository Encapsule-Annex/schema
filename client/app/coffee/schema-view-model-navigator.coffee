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
# schema-view-model-navigator.coffee
#
# Navigation bar view model.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.appSchemaViewModelNavigatorContextLevel
    constructor: (level_, label_) ->
        @level = level_
        @label = label_

        @fontSize = 20 - level_
        @fontColorRed = 0


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorContextLevel", ( ->
    """
    """))


class Encapsule.code.app.SchemaViewModelNavigator
    constructor: (initialHeight_) ->
        Console.message "Initializing #{appName} navigator data model."
        @navigatorEl = $("#ididSchemaViewModelNavigator")

        @viewHeight = ko.observable initialHeight_

        @currentContextLevel = ko.observable undefined

        @setLevelVisibility = (levelTarget_) =>

            levelTarget = Math.min(9, Math.max(1, levelTarget_))
            @currentContextLevel(levelTarget)

            toggleLevel = (levelToggle_) =>
                levelToggle = levelToggle_
                levelCurrent = @currentContextLevel()
                selectorString = ".classSchemaViewModelNavigatorHeading#{levelTarget_}"
                headings = $(selectorString)

                headings.each ->
                    headingEl = $(this)
                    if levelToggle > levelCurrent
                        headingEl[0].hide()
                    else
                        headingEl[0].show()


            toggleLevel target for target in [1..10]









Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <div class="classSchemaViewModelNavigatorHeading1">Catalogue</div>
    <div class="classSchemaViewModelNavigatorHeading2">Specifications</div>
    <div class="classSchemaViewModelNavigatorHeading2">Models</div>
    <div class="classSchemaViewModelNavigatorHeading3">Systems</div>
    <div class="classSchemaViewModelNavigatorHeading3">Machines</div>
    <div class="classSchemaViewModelNavigatorHeading3">Sockets</div>
    <div class="classSchemaViewModelNavigatorHeading3">Contracts</div>
    <div class="classSchemaViewModelNavigatorHeading1">Context</div>
    <div class="classSchemaViewModelNavigatorHeading2">Model</div>
    <div class="classSchemaViewModelNavigatorHeading3">System</div>
    <div class="classSchemaViewModelNavigatorHeading4">I/O</div>
    <div class="classSchemaViewModelNavigatorHeading5">Input Pin</div>
    <div class="classSchemaViewModelNavigatorHeading5">Output Pin</div>
    <div class="classSchemaViewModelNavigatorHeading4">Interconnect</div>
    <div class="classSchemaViewModelNavigatorHeading5">Node</div>
    <div class="classSchemaViewModelNavigatorHeading6">Source</div>
    <div class="classSchemaViewModelNavigatorHeading6">Sinks</div>
    <div class="classSchemaViewModelNavigatorHeading7">Sink</div>
    <div class="classSchemaViewModelNavigatorHeading4">System</div>
    <div class="classSchemaViewModelNavigatorHeading4">Machine</div>
    <div class="classSchemaViewModelNavigatorHeading4">Socket</div>

    """))
