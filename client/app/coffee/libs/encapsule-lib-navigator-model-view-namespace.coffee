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
# encapsule-lib-navigator-model-view-namespace.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}

class Encapsule.code.lib.modelview.NavigatorModelViewNamespaceInitializer
    constructor: (itemHostObject_, namespaceDescriptor_) ->
        try
            if not (itemHostObject_? and itemHostObject_) then throw "Missing item host object parameter."
            if not (namespaceDescriptor_? and namespaceDescriptor_) then throw "Missing namespace declaration parameter."

            @namespaceDescriptor = namespaceDescriptor_
            @namespaceObjectReference = undefined # This is the public, serializable model view
            @itemHostObject = itemHostObject_ # This is the item host object that owns this instance

            @namespaceMemberModelView = {} # This should be used purely for managing namespace member UI state


            @initializeNamespace = (namespaceObject_) =>
                try
                    if not (namespaceObject_? and namespaceObject_) then throw "Missing namespace object parameter."

                    @namespaceObjectReference = namespaceObject_

                    if @namespaceDescriptor.userImmutable? and @namespaceDescriptor.userImmutable
                        for memberName, functions of @namespaceDescriptor.userImmutable
                            if functions.fnCreate? and functions.fnCreate
                                namespaceObject_[memberName] = functions.fnCreate()
                                memberNamespace = @namespaceMemberModelView[memberName] = {}
                                memberNamespace.editMode = ko.observable(false)
                                memberNamespace.editValue = ko.observable(undefined)

                        
                    if @namespaceDescriptor.userMutable? and @namespaceDescriptor.userMutable
                        for memberName, functions of @namespaceDescriptor.userMutable
                            if functions.fnCreate? and functions.fnCreate
                                namespaceObject_[memberName] = functions.fnCreate()
                                memberNamespace = @namespaceMemberModelView[memberName] = {}
                                memberNamespace.editMode = ko.observable(false)
                                memberNamespace.editValue = ko.observable(undefined)

                    @refreshLabel()

                catch exception
                    throw "NavigatorModelViewNamespace.initializeNamespace fail: #{exception}"

            @getLabel = =>
            
                try
                    if not (@namespaceObjectReference and @namespaceObjectReference)
                        return undefined
                    if not (@itemHostObject? and @itemHostObject)
                        return undefined
                    if not (@itemHostObject.navigatorContainer? and @itemHostObject.navigatorContainer)
                        return undefined

                    semanticBindings = @itemHostObject.navigatorContainer.layout.semanticBindings
                    if not (semanticBindings? and semanticBindings)
                        return undefined

                    getLabelBinding = semanticBindings.getLabel? and semanticBindings.getLabel
                    if not (getLabelBinding? and getLabelBinding)
                        return undefined

                    result = getLabelBinding(@namespaceObjectReference)
                    return result

                catch exception
                    throw "getLabel fail: #{exception}"
                
            @namespaceLabel = ko.observable(undefined)

            @refreshLabel = =>
                @namespaceLabel(@getLabel())

            @refreshLabel()


            @updateObservableState = =>

                try
                    if not (@itemHostObject? and @itemHostObject) then throw "Cannot resolve item host object reference."
                    if not (@itemHostObject.navigatorContainer? and @itemHostObject.navigatorContainer) then throw "Cannot resolve navigator container reference."
                    semanticBindings = @itemHostObject.navigatorContainer.layout.semanticBindings
                    if not (semanticBindings? and semanticBindings)
                        return false

                    updateBinding = semanticBindings.update? and semanticBindings.update
                    if not (updateBinding? and updateBinding)
                        return false

                    result = updateBinding(@namespaceObjectReference)
                    @refreshLabel() 

                    return result

                catch exception
                    throw "updateObservableState fail: #{exception}"
                
                

        catch exception
            throw "NavigatorModelViewNamespace fail: #{exception}"

