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
# encapsule-lib-omm-object-selector.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}



#
# An OM selector represents a unique object namespace within the space defined
# by the object model parameter.
# objectModel_ = reference to an instance of ObjectModel class
# objectModelPath_ = OM path
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelSelector
    constructor: (objectModel_, pathId_, objectModelSelectVector_) ->
        try
            if not (objectModel_? and objectModel_) then throw "Missing object model input parameter."
            if not (pathId_?) then throw "Missing object model path parameter."

            if (pathId_ < 0) or (pathId_ >= objectModel_.objectModelDescriptorById.length)
                throw "Out of range path ID specified in request."

            @objectModel = objectModel_
            @objectModelSelectVector = objectModelSelectVector_
            @pathId = pathId_


            # Get the OM descriptor associated with the specified OM path.

            @objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]
            if not (@objectModelDescriptor? and @objectModelDescriptor)
                throw "Unable to resolve object model descriptor for path #{objectModelPath_}"

            @selectKeysRequired = @objectModelDescriptor.pathResolveExtensionPoints.length
            @selectKeysProvided = objectModelSelectVector_? and objectModelSelectVector_ and objectModelSelectVector_.length or 0

            if @selectKeysRequired != @selectKeysProvided
                throw "Unable to resolve object model selector. Expected #{@selectKeysRequired} select keys. #{@selectKeysProvided} keys were provided."

        catch exception
            throw "Encapsule.code.lib.omm.ObjectSelector construction fail: #{exception}"

