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
# encapsule-lib-kohelpers-common.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.core = Encapsule.code.core? and Encapsule.code.core or @Encapsule.code.core = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.core = Encapsule.runtime.core? and Encapsule.runtime.core or @Encapsule.runtime.core = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
Encapsule.runtime.app.kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []

backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or throw "Missing expected Encapsule.runtime.backchannel object."

###
# Get back to this later
#

Encapsule.runtime.core.space = { dimensions: {} }

Encapsule.code.core.IdFromAlias = (alias_) -> "id#{alias_}"

Encapsule.code.core.GetDimensionDescriptor = (dimensionId_) ->
    try
        if not dimensionId_? then throw "Missing dimensionId parameter."
        if not dimensionId_ then throw "Missing dimensionId value."
        dimension = Encapsule.runtime.core.space.dimensions[dimensionId_]
        dimension
    catch
        throw "GetDimensionDescriptor: #{exception}"


Encapsule.code.core.CreateDimensionDescriptor = -> (alias_, name_, description_, superDimensionId_, coefficient_ ) ->

    dimensionDescriptor = {
        dimensionId: Encapsule.runtime.core.IdFromAlias(alias_)
        sphereId: undefined
        meta: {
            alias: alias_
            name: name_
            description: description_
        }
        coefficients: {}
        superDimension: Encapsule.code.core.GetDimensionDescriptor(superDimensionId_)
        subDimensions: {}
    }

    dimensionDescriptor.dimension.sphereId = "#{dimensionDescriptor.superDimension.sphereId}/#{dimensionDescriptor.dimensionId}"

# Get back to this later
###

Encapsule.code.lib.geometry = {}




Encapsule.code.lib.geometry.point = {}
Encapsule.code.lib.geometry.point.createFromCoordinates = (x_, y_) ->
    try
        if not x_? or not y_? then throw "Invalid x or y parameter(s)."
        point = { x: x_, y: y_ }
        point
    catch exception
        throw "Encapsule.code.lib.geometry.point.createFromCoordinates: #{exception}"

Encapsule.code.lib.geometry.extent = {}

Encapsule.code.lib.geometry.extent.create = ->
    extentObject = {
        width: 0
        height: 0
        area: 0
        }
    extentObject

Encapsule.code.lib.geometry.extent.createFromDimensions = (width_, height_) ->
    try
        if not width_? then throw "Missing width parameter."
        if not height_? then throw "Missing height parameter."
        width = Math.max(0, width_)
        height = Math.max(0, height_)
        containedArea = Math.abs(width * height)
        extentObject = {
            width: width
            height: height
            area: containedArea
            }
        extentObject
    catch exception
        throw "Encapsule.code.lib.geometry.extent.createFromCoordinates: #{exception}"



Encapsule.code.lib.geometry.offset = {}

Encapsule.code.lib.geometry.offset.create = ->
    offsetObject = {
        top: 0
        left: 0
        }
    offsetObject

Encapsule.code.lib.geometry.offset.createFromCoordinates = (left_, top_) ->
    try
        if not top_? or not left_? then throw "Invalid top or left parameter(s)."
        offsetObject = {
            left: left_
            top: top_
            }
        offsetObject
    catch exception
        throw "Encapsule.code.lib.geometry.offset.createFromCoordinates: #{exception}"

Encapsule.code.lib.geometry.offset.createFromExtent = (extent_) =>
    try
        if not extent_? then throw "Missing extent parameter."
        if not extent_ then throw "Missing extent value."
        offsetObject = {
            left: extent_.width / -2
            top: extent_.height / -2
            }
        offsetObject
    catch exception
        throw "Encapsule.code.lib.geometry.offset.createFromExtent: #{exception}"


Encapsule.code.lib.geometry.offset.createFromRectangle = (rectangle_) ->
    try
        if not rectangle_? then throw "Missing rectangle parameter."
        if not rectangle_ then throw "Missing rectangle value."
        offsetObject = Encapsule.code.lib.geometry.offset.createFromExtent(rectangle_.extent)
        offsetObject
    catch exception
        throw "Encapsule.code.lib.geometry.offset.createFromRectangle: #{exception}"



Encapsule.code.lib.geometry.rectangle = {}

Encapsule.code.lib.geometry.rectangle.create = ->
    try
        rectangleObject = {
            extent: Encapsule.code.lib.geometry.extent.create()
            hasArea: false
            }
        rectangleObject
    catch exception
        throw "Encapsule.code.lib.geometry.rectangle.create: #{exception}"


Encapsule.code.lib.geometry.rectangle.createFromDimensions = (width_, height_) ->
    try
        if not width_? then throw "Missing width parameter."
        if not height_? then throw "Missing height parameter."
        extentObject = Encapsule.code.lib.geometry.extent.createFromDimensions(width_, height_)
        rectangleObject = {
            extent: extentObject
            hasArea: extentObject.area != 0
            }
        rectangleObject
    catch exception
        throw "Encapsule.code.lib.geometry.rectangle.createFromDimensions: #{exception}"


Encapsule.code.lib.geometry.rectangle.createFromExtent = (extent_) ->
    try
        if not extent_? then throw "Missing extent parameter."
        if not extent_ then throw "Missing extent value."
        rectangleObject = {
            extent: Encapsule.code.lib.js.clone(extent_)
            hasArea: extent_.area != 0
            }
        rectangleObject
    catch exception
        throw "Encapsule.code.lib.geometry.rectangle.createFromExtent: #{exception}"


Encapsule.code.lib.geometry.offsetRectangle = {}

Encapsule.code.lib.geometry.offsetRectangle.create = ->
    offsetRectangleObject = {
        rectangle: Encapsule.code.lib.geometry.rectangle.create()
        offset: Encapsule.code.lib.geometry.offset.create()
        }
    offsetRectangleObject

Encapsule.code.lib.geometry.offsetRectangle.createFromDimensions = (width_, height_) ->
    try
        if not width_? then throw "Missing width parameter."
        if not height_? then throw "Missing height parameter."
        rectangleObject = Encapsule.code.lib.geometry.rectangle.createFromDimensions(width_, height_)
        offsetRectangleObject = {
            rectangle: rectangleObject
            offset: Encapsule.code.lib.geometry.offset.createFromExtent(rectangleObject.extent)
        }
        offsetRectangleObject
    catch exception
        throw "Encapsule.code.lib.geometry.offsetRectangle.createFromDimensions: #{exception}"

Encapsule.code.lib.geometry.offsetRectangle.createFromRectangle = (rectangle_) ->
    try
        if not rectangle_? then throw "Missing rectangle parameter."
        if not rectangle_ then throw "Missing rectangle value."
        rectangle = Encapsule.code.lib.js.clone(rectangle_)
        offsetRectangleObject = {
            rectangle: rectangle
            offset: Encapsule.code.lib.geometry.offset.createFromExtent(rectangle.extent)
        }
        offsetRectangleObject
    catch exception
        throw "Encapsule.code.lib.geometry.offsetRectangle.createFromRectangle: #{exception}"

Encapsule.code.lib.geometry.margins = {}

Encapsule.code.lib.geometry.margins.create = ->
    marginsObject = {
        top: 0
        left: 0
        bottom: 0
        right: 0
        }
    marginsObject

Encapsule.code.lib.geometry.margins.createForPixelDimensions = (top_, left_, bottom_, right_) ->
    marginsObject = {
        top: Math.max(top_? and top_, 0)
        left: Math.max(left_? and left_, 0)
        bottom: Math.max(bottom_? and bottom_, 0)
        right: Math.max(right_? and right_, 0)
        }
    marginsObject

Encapsule.code.lib.geometry.margins.createUniform = (pixels_) ->
    try
        if not pixels_? then throw "Missing pixel count parameter."
        marginsObject = Encapsule.code.lib.geometry.margins.createForPixelDimensions(pixels_, pixels_, pixels_, pixels_)
        marginsObject
    catch exception
        throw "Encapsule.code.lib.geometry.margins.createUniform: #{exception}"



Encapsule.code.lib.geometry.frame = {}

Encapsule.code.lib.geometry.frame.create = ->
    try
        frameObject = {
            frame: Encapsule.code.lib.geometry.offsetRectangle.create()
            view: Encapsule.code.lib.geometry.offsetRectangle.create()
            margins: Encapsule.code.lib.geometry.margins.create()
            }
        frameObject
    catch exception
        throw "Encapsule.code.lib.geometry.frame.create: #{exception}"



Encapsule.code.lib.geometry.frame.createFromOffsetRectangle = (offsetRectangle_) ->
    Encapsule.code.lib.geometry.frame.createFromOffsetRectangleWithMargins(offsetRectangle_, Encapsule.code.lib.geometry.margins.create())



Encapsule.code.lib.geometry.frame.createFromOffsetRectangleWithMargins = (offsetRectangle_, margins_) ->
    try
        if not offsetRectangle_? then throw "Missing offset rectangle parameter."
        if not offsetRectangle_ then throw "Missing offset rectangle value."
        if not margins_? then throw "Missing margin set parameter."
        if not margins_ then throw "Missing margin set value."

        # Create a default frame object with the view coincident with the frame.
        frameObject = {
            frame: Encapsule.code.lib.js.clone(offsetRectangle_)
            view: Encapsule.code.lib.js.clone(offsetRectangle_)
            margins: Encapsule.code.lib.js.clone(margins_)
            }

        # Take stock of the total extents requested by the margins_ object.
        horizontalMarginExtent = margins_.left + margins_.right
        verticalMarginExtent = margins_.top + margins_.bottom

        if (horizontalMarginExtent > frameObject.frame.rectangle.extent.width) or
            (verticalMarginExtent > frameObject.frame.rectangle.extent.height)
                # Reset the view offset rectangle to zero area
                frameObject.view = Encapsule.code.lib.geometry.offsetRectangle.create()
                return frameObject

        frameObject.view.offset.left += margins_.left
        frameObject.view.offset.top += margins_.top
        frameObject.view.rectangle.extent.width -= horizontalMarginExtent
        frameObject.view.rectangle.extent.height -= verticalMarginExtent

        backchannel.log("""
            <b>Frame:</b>
            #{frameObject.frame.rectangle.extent.width} x #{frameObject.frame.rectangle.extent.height}
            w/offset (#{frameObject.frame.offset.top}, #{frameObject.frame.offset.left})
            &bull; <b>Margins:</b>
            {#{margins_.top}, #{margins_.left}, #{margins_.bottom}, #{margins_.top}}
            &bull; <b>View:</b>
            #{frameObject.view.rectangle.extent.width} x #{frameObject.view.rectangle.extent.height}
            w/offset (#{frameObject.view.offset.top}, #{frameObject.view.offset.left})
            &bull; <b>Size delta:</b>
            #{frameObject.frame.rectangle.extent.width - frameObject.view.rectangle.extent.width}
            x
            #{frameObject.frame.rectangle.extent.height - frameObject.view.rectangle.extent.height}
            """)

        frameObject

    catch exception
        throw "Encapsule.code.lib.geometry.frame.createFromOffsetRectangleWithMargins: #{exception}"





        

        



