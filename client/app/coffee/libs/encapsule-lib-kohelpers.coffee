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
            throw "While evaluating the #{descriptor_.selectorId_} HTML callback."

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
            <!-- ENCAPSULE PROJECT WINDOW MANAGER -->
            <span id="idEncapsuleWindowManagerHost">
                <!-- WINDOW MANAGER MODEL VIEW TEMPLATES -->
                <span id="idEncapsuleWindowManagerViewTemplateCache"></span>
                <!-- WINDOW MANAGER MODEL VIEW -->
                <span id="idEncapsuleWindowManager" data-bind="template: { name: 'idKoTemplate_EncapsuleWindowManager' }"></span>
            </span>"""

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




Encapsule.code.lib.kohelpers.SplitRectIntoQuads = (name_, containerRect_, centerPoint_, paneMargin_) ->

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

        result.quad1.width = Math.max(0, centerPoint_.x - paneMargin_ - 1 )
        result.quad1.height = Math.max(0, centerPoint_.y - paneMargin_ - 1 )
        result.quad1.offsetLeft = containerRect_.offsetLeft
        result.quad1.offsetTop = containerRect_.offsetTop

        result.quad2 = {}
        result.quad2.width = Math.max( 0, containerRect_.width - result.quad1.width - paneMargin_ )
        result.quad2.height = Math.max( 0, centerPoint_.y - paneMargin_ - 1 )
        result.quad2.offsetLeft = containerRect_.offsetLeft + result.quad1.width + (2 * paneMargin_)
        result.quad2.offsetTop = containerRect_.offsetTop

        result.quad3 = {}
        result.quad3.width = result.quad1.width
        result.quad3.height = Math.max( 0, containerRect_.height - result.quad1.height - (2 * paneMargin_) )
        result.quad3.offsetLeft = containerRect_.offsetLeft
        result.quad3.offsetTop = containerRect_.offsetTop + result.quad1.height + (2 * paneMargin_)

        result.quad4 = {}
        result.quad4.width = result.quad2.width
        result.quad4.height = result.quad3.height
        result.quad4.offsetLeft = result.quad2.offsetLeft
        result.quad4.offsetTop = result.quad3.offsetTop

        # QA

        # Row 0 / Q1 Q2
        if result.quad1.height != result.quad2.height
            throw "Q1 and Q2 heights do not match!"
        # Row 1 / Q3 Q4
        if result.quad3.height != result.quad4.height
            throw "Q3 and Q4 heights do not match!"
        # Column 0 / Q1 Q3
        if result.quad1.width != result.quad3.width
            throw "Q1 and Q4 widths do not match!"
        # Column 1 / Q2 Q4
        if result.quad2.width != result.quad4.width
            throw "Q2 and Q4 widths do not match!"

        containerWidth = containerRect_.width
        containerWidth -= 2 * paneMargin_
        containerWidth -= result.quad1.width + result.quad2.width
        if containerWidth not 0
           Console.message "Total width distribution looks wrong?"

        containerHeight = containerRect_.height

        if containerRect_.height != ( result.quad1.height + result.quad3.height (2 * paneMargin_))
            Console.message "Total height distribution looks wrong?"


        result

    catch exception
        messageError = "In SplitRectIntoQuads: #{exception}"
        Console.messageError messageError
        throw messageError

        


