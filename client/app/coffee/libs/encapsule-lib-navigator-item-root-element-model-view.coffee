###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-navigator-item-root-element-model-view.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}

Encapsule.code.lib.modelview.NavigatorCreateItemHostViewModelHtmlTemplate = (layoutObject_, path_) ->

    try

        Console.message("NavigatorModelViewFactory enter")

        jsonTag = layoutObject_.jsonTag
        label = layoutObject_.label

        objectDescriptor = layoutObject_.objectDescriptor? and layoutObject_.objectDescriptor

        # We require that every menu level object declare an objectDescriptor.
        #
        if not (objectDescriptor? and objectDescriptor)
            throw "Missing object descriptor."

        # A menu level object may optionally declare a namespaceDescriptor.
        #
        namespaceDescriptor = objectDescriptor? and objectDescriptor and objectDescriptor.namespaceDescriptor? and objectDescriptor.namespaceDescriptor
        if not (namespaceDescriptor? and namespaceDescriptor)
            Console.message("... informational: #{path_} defines no namespaceDescriptor.")

        mvvmType = objectDescriptor.mvvmType

        templateName = "idKoTemplate_NavigatorItemElement_#{path_}"

        templateHtml = """
            <div style="font-size: 10pt; font-weight: normal; background-color: rgba(0, 200, 255, 0.2); padding: 5px;" data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                <strong>Navigator path::</strong> <span data-bind="text: menuLevelObject.path"></span>
            </div>

            <div style="font-weight: normal; background-color: rgba(0, 200, 255, 0.1); padding: 5px;">
                <div style="font-size: 22pt;" data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                   <span data-bind="text: itemPageTitle"></span>
                </div>
                <span>#{objectDescriptor.description}</span>
            </div>                

            """




        switch mvvmType
            when "root"
                break
            when "child"
                break
            when "extension"
                templateHtml += """
                <div style="padding: 5px; background-color: rgba(0,200,256,0.2);" >
                <span style="float: right;">
                    <strong><span data-bind="text: itemPageTitle"></span> &gt;</strong>
                    <button class="button small orange" data-bind="click: onButtonClickResetExtension">Reset</button>
                </span>
                <strong><span data-bind="text: itemExtensionSelectLabel"></span> &gt;</strong>
                <button class="button small green" data-bind="click: function(data_, event_) { onButtonClickInsertExtension(data_, event_, false) }">Add</button>
                <button class="button small green" data-bind="click: function(data_, event_) { onButtonClickInsertExtension(data_, event_, true) }">Add/Select</button>
                <button class="button small black" data-bind="click: onButtonClickCloseExtension">Close</button>
                <br clear="all">
                """
                break
            when "select"

                templateHtml += """
                <div style="padding: 5px; background-color: rgba(0,200,256,0.2);" >

                <!-- <button class="button small blue" data-bind="click: onButtonClickCloneExtension">Clone</button> -->

                <span style="float: right;">
                    <strong><span data-bind="text: itemPageTitle"></span> &gt;</strong>
                    <button class="button small orange" data-bind="click: onButtonClickResetExtension">Reset</button>
                    <button class="button small red" data-bind="click: onButtonClickRemoveExtension">Remove</button>
                </span>

                <strong><span data-bind="text: itemPageTitle"></span> &gt;</strong>
                <button class="button small black" data-bind="click: onButtonClickCloseExtension">Close</button>
                <br clear="all">
                """
                break
            when "archetype"
                templateHtml += """
                <div style="padding: 5px; background-color: rgba(0,200,256,0.2);" >

                <!-- <button class="button small blue" data-bind="click: onButtonClickCloneExtension">Clone</button> -->

                <span style="float: right;">
                    <strong><span data-bind="text: itemPageTitle"></span> &gt;</strong>
                    <button class="button small orange" data-bind="click: onButtonClickResetExtension">Reset</button>
                    <button class="button small red" data-bind="click: onButtonClickRemoveExtension">Remove</button>
                </span>

                <strong><span data-bind="text: itemPageTitle"></span> &gt;</strong>
                <button class="button small black" data-bind="click: onButtonClickCloseExtension">Close</button>
                <br clear="all">
                """
                break


            else
                throw "Unrecognized MVVM type=#{mvvmType}"


        if (namespaceDescriptor? and namespaceDescriptor)
            Console.message("... namespaceDescriptor defined for path #{path_}")


        # LAST STEP (ALWAYS)
        templateHtml += """</div>"""

        

        Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate(templateName, -> templateHtml)

        Console.message("NavigatorModelViewFactory exit")

        return templateName

    catch exception
        throw "NavigatorModelViewFactory runtime exception: #{exception}"
