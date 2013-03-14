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




namespaceEncapsule_code_lib_kohelpers.RegisterKnockoutViewTemplate = (selectorId_, fnHtml_) ->
    koTemplate = { selectorId_ , fnHtml_ }
    Encapsule.runtime.app.kotemplates.push koTemplate


namespaceEncapsule_code_lib_kohelpers.InstallKnockoutViewTemplate = (descriptor_) ->
    selector = "##{descriptor_.selectorId_}"
    koTemplateJN = $(selector);

    if koTemplateJN.length == 1
        throw "Duplicate Knockout.js HTML view template registration. id=\"#{descriptor_.selectorId_}\""

    koTemplatesJN = $("#idKoTemplates")

    if koTemplatesJN.length == 0
        $("body").append("""<div id="idKoTemplates" style="display: none;"></div>""")
        koTemplatesJN = $("#idKoTemplates")

    koTemplatesJN.append("<script type=\"text/html\" id=\"#{descriptor_.selectorId_}\">" + descriptor_.fnHtml_() + "</script>")
    true


namespaceEncapsule_code_lib_kohelpers.InstallKnockoutViewTemplates = ->
    for descriptor in Encapsule.runtime.app.kotemplates
        Console.message "#{appName} view template: #{descriptor.selectorId_}"
        Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate(descriptor)



