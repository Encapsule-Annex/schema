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
# encapsule-lib-ko-helpers.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
namespaceEncapsule_runtime_app_kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate = (selectorId_, fnHtml_) ->
    try
        if not selectorId_? or not selectorId_ or not fnHtml_? or not fnHtml_ then throw "RegisterKnockoutViewTemplate bad parameter(s)"
        koTemplate = { selectorId_ , fnHtml_ }
        Encapsule.runtime.app.kotemplates.push koTemplate
    catch exception
        throw "RegisterKnockoutViewTemplate selectorId=#{selectId_} : #{exception}"


Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate = (descriptor_, parentEl_) ->
    try
        if not parentEl_? or not parentEl_ then throw "Invalid parent element parameter."
        if not descriptor_? or not descriptor_ then throw "Invalid descriptor parameter."
        if not descriptor_.selectorId_? or not descriptor_.selectorId_ then throw "Invalid descriptor.selectorId_ parameter."
        if not descriptor_.fnHtml_? or not descriptor_.fnHtml_ then throw "Invalid descriptor.fnHtml_ parameter."
        selector = "##{descriptor_.selectorId_}"
        koTemplateJN = $(selector);
        if koTemplateJN.length == 1 then throw "Duplicate Knockout.js HTML view template registration. id=\"#{descriptor_.selectorId_}\""
        htmlViewTemplate = undefined
        try
            htmlViewTemplate = descriptor_.fnHtml_()
        catch exception
            throw "While evaluating the #{descriptor_.selectorId_} HTML callback: #{exception}"

        parentEl_.append($("""<script type="text/html" id="#{descriptor_.selectorId_}">#{htmlViewTemplate}</script>"""))
        return true
    catch exception
        throw "InstallKnockoutViewTemplate for descriptor #{descriptor_.selectorId_} : #{exception}"


# Returns $("idKnockoutHtmlView")[0]
Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates = (windowManagerId_) ->
 
    if not windowManagerId_? or not windowManagerId_ then throw "InstallKnockoutViewTemplates missing windowManagerId parameter."

    try
        # Root HTML view binding for window manager.
        windowManagerHtmlViewBinding = """
            <!-- BEGIN: \\ ENCAPSULE PROJECT WINDOW MANAGER HOST -->
            <span id="idEncapsuleWindowManagerHost">
                <!-- BEGIN: \\ WINDOW MANAGER MODEL VIEW TEMPLATES -->
                <span id="idEncapsuleWindowManagerViewTemplateCache"></span>
                <!-- END: / WINDOW MANAGER MODEL VIEW TEMPLATES -->
                <!-- BEGIN: \\ ENCAPSULE PROJECT WINDOW MANAGER HOST VIEW MODEL -->
                <span id="idEncapsuleWindowManager" data-bind="template: { name: 'idKoTemplate_EncapsuleWindowManager' }"></span>
                <!-- END: / ENCAPSULE PROJECT WINDOW MANAGER HOST VIEW MODEL -->
            </span>
            <!-- END: / ENCAPSULE PROJECT WINDOW MANAGER HOST -->
            """

        # Install the view. Binding occurs separately, later, at a higher context.
        $("body").append($(windowManagerHtmlViewBinding))

        templateCacheEl = $("#idEncapsuleWindowManagerViewTemplateCache")
        windowManagerHtmlViewRootDocumentElement = $("#idEncapsuleWindowManager")

        # Insert the HTML templates into the DOM
        for descriptor in Encapsule.runtime.app.kotemplates
            Console.message "Window manager caching view template: #{descriptor.selectorId_}"
            Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate(descriptor, templateCacheEl)

        # Return the document element node of the window manager host span. This is what we bind the window manager to.
        windowManagerHtmlViewRootDocumentElement[0]

    catch exception
         throw """InstallKnockoutViewTemplates for id=#{windowManagerId_} : #{exception}"""

