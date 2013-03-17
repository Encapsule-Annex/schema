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



Encapsule.code.lib.kohelpers.SplitRectIntoQuads = (name_, containerRect_, centerPoint_) ->

    try
    
        Console.message("SplitRectIntoQuads on #{name_}: width=#{containerRect_.width} px / height=#{containerRect_.height} px / offset={#{containerRect_.offsetLeft} px, #{containerRect_.offsetTop} px} on center={#{centerPoint_.x}px, #{centerPoint_.y}px}")

        result = {}
        result.name = name_

        result.sources = {}
        result.sources.containerRect = containerRect_
        result.sources.centerPoint = centerPoint_

        #
        # Validate input parameters.
        #

        if not (name_? and name_ and containerRect_? and containerRect_ and centerPoint_? and centerPoint_)
            throw "Invalid input parameter(s). You must name, containerRect, and centerPoint parameters."

        if containerRect_.width < 0 then throw "Invalid input parameter: containerRect.width < 0"
        if containerRect_.width > (1920 * 3) then throw "Invalad input parameter: containerRect.width > three 1080p display widths"

        if containerRect_.height < 0 then throw "Invalid input parameter: containerRect.height < 0"
        if containerRect_.height > (1080 * 3) then throw "Invalid input parameter: containerRect.height > three 1080p display heights"

        if centerPoint_.x < 0 then throw "Invalid input parameter: centerPoint.x < 0"
        if centerPoint_.x > containerRect_.width then throw "Invalid input parameter: centerPoint.x > containerRect.width"
        if centerPoint_.y < 0 then throw "Invalid input parmeter: centerPoint.y < 0"
        if centerPoint_.y > containerRect_.height then throw "Invalid input parameter: centerPoint.y > containerRect.height"
 
        result.quad1 = {}

        result.quad1.width = centerPoint_.x
        result.quad1.height = centerPoint_.y
        result.quad1.offsetLeft = containerRect_.offsetLeft
        result.quad1.offsetTop = containerRect_.offsetTop

        result.quad2 = {}
        result.quad2.width = containerRect_.width - result.quad1.width + 1
        result.quad2.height = centerPoint_.y
        result.quad2.offsetLeft = containerRect_.offsetLeft + result.quad1.width
        result.quad2.offsetTop = containerRect_.offsetTop

        result.quad3 = {}
        result.quad3.width = result.quad1.width
        result.quad3.height = containerRect_.height - result.quad1.height + 1
        result.quad3.offsetLeft = containerRect_.offsetLeft
        result.quad3.offsetTop = containerRect_.offsetTop + result.quad1.height + 1

        result.quad4 = {}
        result.quad4.width = result.quad2.width
        result.quad4.height = result.quad3.height
        result.quad4.offsetLeft = result.quad2.offsetLeft
        result.quad4.offsetTop = result.quad3.offsetTop

        result

    catch exception
        messageError = "In SplitRectIntoQuads: #{exception}"
        Console.messageError messageError
        throw messageError

        


