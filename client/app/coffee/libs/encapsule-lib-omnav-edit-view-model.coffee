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

Encapsule.code.lib.modelview.NavigatorCreateItemHostViewModelHtmlTemplate = (layoutObject_, itemHostObject_, path_) ->

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

        ###
        Navigator path
        ###
        templateHtml = """
            <div style="font-size: 10pt; font-weight: normal; background-color: rgba(0, 200, 255, 0.2); padding: 5px;" data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                <strong>Navigator path::</strong> <span data-bind="text: path"></span>
            </div>
            """

        ###
        Navigator item title
        ###
        templateHtml += """

            <div style="font-weight: normal; background-color: rgba(0, 200, 255, 0.1); padding: 5px;">
                <div style="font-size: 22pt;" data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                   <span data-bind="text: itemPageTitle"></span>
                   <span data-bind="if: namespaceMemberInitializer"><span data-bind="if: namespaceMemberInitializer.namespaceLabel">
                       :
                       <span data-bind="text: namespaceMemberInitializer.namespaceLabel"></span>
                   </span></span>
                </div>
                <span>#{objectDescriptor.description}</span>
                </div>
                """

        ###
        START: NAVIGATOR ITEM OPERATIONS VIEW MODEL
        ###
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
                </div>
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
                </div>
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
                </div>
                """
                break


            else
                throw "Unrecognized MVVM type=#{mvvmType}"

        ###
        END: NAVIGATOR ITEM OPERATIONS VIEW MODEL
        ###

        ###
        START: NAVIGATOR ITEM NAMESPACE MEMBER VIEW MODEL
        ###


        if (namespaceDescriptor? and namespaceDescriptor)

            namespaceDescriptorImmutable = namespaceDescriptor.userImmutable? and namespaceDescriptor.userImmutable or undefined
            namespaceDescriptorMutable = namespaceDescriptor.userMutable? and namespaceDescriptor.userMutable or undefined

            templateHtmlNamespaceImmutable = """
                <thead class="classNavigatorItemNamespaceImmutableHeader"><td>immutable properties</td><td>type</td><td>value</td></thead>
                """

            templateHtmlNamespaceMutable = """
                <thead class="classNavigatorItemNamespaceMutableHeader"><td>mutable properties</td><td>type</td><td>value</td></thead>
                """

            # Enumerate namespace's immutable member properties.
            for memberName, functions of namespaceDescriptorImmutable
                templateHtmlNamespaceImmutable += """
                <tr class="classNavigatorItemNamespaceImmutableMember" data-bind="click: function(data_, event_) { $parent.onNamespaceImmutableMemberClick('#{memberName}', #{memberName}, data_, event_); }">
                    <td>#{memberName}</td>
                    <td>#{functions.type}</td>
                    <td><span data-bind="text: #{memberName}"></span></td>
                </tr>
                """

            # Enumerate namespace's mutable member properties.
            for memberName, functions of namespaceDescriptorMutable
                templateHtmlNamespaceMutable += """
                    <tr class="classNavigatorItemNamespaceMutableMember classMouseCursorPointer" data-bind="click: function(data_, event_) { $parent.onNamespaceMutableMemberClick('#{memberName}', #{memberName}, data_, event_); }">
                        <td><strong>#{memberName}</strong></td>
                        <td>#{functions.type}</td>
                        <td>
                            <span class="classNavigatorItemNamespaceMutableMemberValue" data-bind="text: #{memberName}"></span>
                        </td>
                    </tr>
                    <tr class="classNavigatorItemNamespaceMutableMemberEdit" data-bind="visible: $parent.namespaceMemberInitializer.namespaceMemberModelView['#{memberName}'].editMode">
                    <td colspan="3">
                        <div class="classNavigatorItemNamespaceMutableMemberEditArea">
                            <span style="float: right;">
                                <button class="button small green" data-bind="click: function(data_, event_) { $parent.onNamespaceMutableMemberClickUpdate('#{memberName}', data_, event_); }">Update</button>
                                <button class="button small orange" data-bind="click: function(data_, event_) { $parent.onNamespaceMutableMemberClickReset('#{memberName}', data_, event_); }">Reset</button>
                                <button class="button small black" data-bind="click: function(data_, event_) { $parent.onNamespaceMutableMemberClickCancel('#{memberName}', data_, event_); }">Cancel</button>
                            </span>
                            <span class="classNavigatorItemNamespaceMutableMemberEditAreaLabel">Edit #{functions.type} property <strong>#{itemHostObject_.jsonTag}.#{memberName}</strong></span>
                            <br clear="all">
                            <span data-bind="with: $parent.namespaceMemberInitializer.namespaceMemberModelView['#{memberName}']">
                                <div contenteditable="true" class="classNavigatorItemNamespaceMutableMemberEditAreEdit" data-bind="editableText: editValue"></div>
                            </span>
                        </div>
                    </td>
                    </tr>
                    """

            tableInnerHtml = ""
            if namespaceDescriptorImmutable? and namespaceDescriptorImmutable and templateHtmlNamespaceImmutable
                tableInnerHtml += templateHtmlNamespaceImmutable

            if namespaceDescriptorMutable? and namespaceDescriptorMutable and templateHtmlNamespaceMutable
                tableInnerHtml += templateHtmlNamespaceMutable
            
            templateHtml += """
                <h3>#{label} object namespace:</h3>
                <div class="classNavigatorItemNamespace" data-bind="with: itemObservableModelView">
                <table>#{tableInnerHtml}</table>
                </div>
                """

        ###
        END: NAVIGATOR ITEM NAMESPACE MEMBER VIEW MODEL
        ###

        ###
        REGISTER VIEW MODEL TEMPLATE AND EXIT
        ###
        Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate(templateName, -> templateHtml)
        Console.message("NavigatorModelViewFactory exit")
        return templateName

    catch exception
        throw "NavigatorModelViewFactory runtime exception: #{exception}"
