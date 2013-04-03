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
# encapsule-lib-kohelpers-window-manager-view-model.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
Encapsule.code.lib.kohelpers.implementation = Encapsule.code.lib.kohelpers.implementation? and Encapsule.code.lib.kohelpers.implementation or @Encapsule.code.lib.kohelpers.implementation = {}


Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
Encapsule.runtime.app.kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []



# Called from the constructor of ObservableWindowManager to synthesize the entire static view model template
# string from the specified layout JS object.

Encapsule.code.lib.kohelpers.implementation.SynthesizeWindowManagerViewModelFromLayoutDeclaration = (layout_) =>

    result = {}
    result.htmlHead = """
        <!-- BEGIN: \\ WINDOW MANAGER GLASS BACKGROUND LAYER -->
        <div id="idWindowManagerGlass" onclick="Console.show()" data-bind="style: { width: cssGlassWidth(), height: cssGlassHeight(), marginLeft: cssGlassMarginLeft(), marginTop: cssGlassMarginTop(), background: cssGlassBackground(), opacity: cssGlassOpacity(), backgroundColor: cssGlassBackgroundColor() }"></div>
        <!-- END: / WINDOW MANAGER GLASS BACKGROUND LAYER -->
        <!-- BEGIN: \\ WINDOW MANAGER BACKGROUND LAYER -->
        <div id="#{layout_.id}" class="classObservableWindowManager" onclick="Console.show()" data-bind="style: { width: cssWindowManagerWidth(), height: cssWindowManagerHeight(), marginLeft: cssWindowManagerMarginLeft(), marginTop: cssWindowManagerMarginTop(), backgroundColor: cssWindowManagerBackgroundColor(), opacity: cssWindowManagerOpacity() }"></div>
        <!-- END: / WINDOW MANAGER BACKGROUND LAYER -->
        <!-- BEGIN: \\ WINDOW MANAGER CONTROL PANEL WINDOW -->
        <!-- END: / WINDOW MANAGER CONTROL PANEL WINDOW -->
        """

    result.htmlTail = """
        """


    # Enumerate the plane objects defined in the layout.
    windowNumber = 0
    planeNumber = 0
    for plane in layout_.planes

        result.htmlHead += """<!-- BEGIN: \\ LAYOUT PLANE id=#{plane.id} --><div id="#{plane.id}" data-bind="if: planes[#{planeNumber}].enabled">"""

        # Enumerate the splitter objects defined in the plane.
        for splitter in plane.splitterStack

            # A splitter may contain one or two observable window declarations.
            # All we care about here is enumerating the windows so that we can
            # generate the appropriate view model template for each of them.

            for splitHalf in [ "Q1WindowDescriptor", "Q2WindowDescriptor" ]
                windowDescriptor = splitter[splitHalf]
                if windowDescriptor?
                    result.htmlHead += """
                        <!-- BEGIN: \\ OBSERVABLE WINDOW HOST planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                        <span data-bind="with: observableWindows()[#{windowNumber}]">
                            <! -- BEGIN: OBSERVABLE WINDOW HOST CONTAINER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                            <span data-bind="if: windowInDOM">
                                <! -- BEGIN: \\ OBSERVABLE WINDOW HOST LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                                <div class="classObservableWindowHost" data-bind="attr: { id: idHost }, style: { width: cssHostWidth(), height: cssHostHeight(), marginLeft: cssHostMarginLeft(), marginTop: cssHostMarginTop(), opacity: cssHostOpacity(), backgroundColor: cssHostBackgroundColor() }"></div>
                                <!-- END: / OBSERVABLE WINDOW HOST LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                                <! -- BEGIN: \\ OBSERVABLE WINDOW CHROME LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                                <div class="classObservableWindowChrome" data-bind="attr: { id: idChrome }, style: { width: cssChromeWidth(), height: cssChromeHeight(), marginLeft: cssChromeMarginLeft(),  marginTop: cssChromeMarginTop(), opacity: cssChromeOpacity(), backgroundColor: cssChromeBackgroundColor() }"></div>
                                <!-- END: / OBSERVABLE WINDOW CHROME LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                                <!-- BEGIN: \\ OBSERVABLE WINDOW LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id}  -->
                                <div class="classObservableWindow" data-bind="attr: { id: id }, style: { width: cssWindowWidth(), height: cssWindowHeight(), marginLeft: cssWindowMarginLeft(), marginTop: cssWindowMarginTop(), opacity: cssWindowOpacity(), backgroundColor: cssWindowBackgroundColor(), border: cssWindowBorder(), padding: cssWindowPadding(), overflow: cssWindowOverflow() }, event: { mouseover: onMouseOver, mouseout: onMouseOut }">
                          """

                    if windowDescriptor.MVVM? and windowDescriptor.MVVM.viewModelTemplateId? and (windowDescriptor.MVVM.modelView? or windowDescriptor.MVVM.fnModelView?)
                        result.htmlHead += """
                                    <!-- BEGIN: \\ HOSTED OBSERVABLE WINDOW planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                                    <span data-bind="with: hostedModelView">
                                        <span data-bind="template: { name: '#{windowDescriptor.MVVM.viewModelTemplateId}' }"></span>
                                    </span>
                                    <!-- END: / HOSTED OBSERVABLE WINDOW planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                            """
                        # END: / if

                    ### Disable but keep for reference
                    result.htmlHead += """
                                    <b>Toggle [ <span data-bind="event: { click: toggleWindowMode }, text: windowMode" style="color: blue; font-weight: bold; text-decoration: underline;"></span> ]</b>
                                    ObservableWindow: id=<span data-bind="text: id"></span> &bull; <span data-bind="text: name"></span><br>
                         """
                    ###

                    result.htmlHead += """
                                </div><!-- END: / OBSERVABLE WINDOW LAYER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                            </span><!-- END: / OBSERVABLE WINDOW HOST CONTAINER planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                        </span><! -- END: / OBSERVABLE WINDOW HOST planeId=#{plane.id} windowId=#{windowDescriptor.id} -->
                        """
                    windowNumber++
                    # END : / if windowDescriptor_?
                # END: / for splitHalf
            # END: / for splitter
        result.htmlHead += """</div><!-- END: / LAYOUT PLANE id=#{plane.id} -->"""
        planeNumber++
        # END: / for plane

    return result.htmlHead + result.htmlTail
    # / END: function scope


