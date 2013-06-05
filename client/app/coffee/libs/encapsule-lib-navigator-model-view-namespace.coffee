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
            @namespaceObjectReference = undefined
            @itemHostObject = itemHostObject_

            @initializeNamespace = (namespaceObject_) =>
                try
                    if not (namespaceObject_? and namespaceObject_) then throw "Missing namespace object parameter."

                    @namespaceObjectReference = namespaceObject_

                    if @namespaceDescriptor.userImmutable? and @namespaceDescriptor.userImmutable
                        for memberName, functions of @namespaceDescriptor.userImmutable
                            if functions.fnCreate? and functions.fnCreate
                                namespaceObject_[memberName] = functions.fnCreate()
                        
                    if @namespaceDescriptor.userMutable? and @namespaceDescriptor.userMutable
                        for memberName, functions of @namespaceDescriptor.userMutable
                            if functions.fnCreate? and functions.fnCreate
                                namespaceObject_[memberName] = functions.fnCreate()

                catch exception
                    throw "NavigatorModelViewNamespace.initializeNamespace fail: #{exception}"

            @updateObservableState = =>

                if (@namespaceObjectReference? and @namespaceObjectReference)
                    revision = @namespaceObjectReference["revision"]
                    updateTime = @namespaceObjectReference["updateTime"]
                    revision++
                    if revision? and revision
                        @namespaceObjectReference["revision"] = revision
                    if updateTime? and updateTime
                        @namespaceObjectReference["updateTime"] =  Encapsule.code.lib.util.getEpochTime()

                return true

                

        catch exception
            throw "NavigatorModelViewNamespace fail: #{exception}"

