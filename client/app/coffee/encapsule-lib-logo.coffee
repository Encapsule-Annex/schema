#
# encapsule-logo.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceView = Encapsule.view? and Encapsule.view or @Encapsule.view = {}
namespaceWidget = Encapsule.view.widget? and Encapsule.view.widget or @Encapsule.view.widget = {}

# parentElement_ is a JQuery element, presumably a DIV
#
# options_ = { outerStrokeWidth: undefined | num, outerStrokeColor: undefined | "#RRGGBB",
# innerStrokeWidth: undefined | num, innerStrokeColor: undefined | "#RRGGBB",
# outerFillColor: undefined | "#RRGGBB", innerFillColor: undefined | "#RRGGBB"

optionsDefault = { outerFillColor: "#0066CC", innerFillColor: "#0099FF", rectStrokeWidth: 1, rectStrokeColor: "#00FF00" }

optionsOutlineOnly = { outerStrokeWidth: 1, outerStrokeColor: "#006699", innerStrokeWidth: 1, innerStrokeColor: "#006699" }

drawLogo = (parentElement_, options_) ->

    # aspect = w / h = 16 / 9 = 1.77778
    # w / 1.77778 = h

    # constants
    assumedAspectRatio = 16 / 9
    goldenRatio = 1.6180339887498948482

    # ratio of drawing area height to outer circle diameter
    outerRadiusBias = 0.5

    # ratio of the outer to inner circle diameter
    innerRadiusBias = 0.87

    # inner circle center displacement ratio
    # e.g.
    # 0.0 -> inner is centered in outer circle
    # 1.0 -> inner and outer circles edges are coincident
    innerCircleTranslationBias = 0.9

    # angle to displace inner circle
    logoAngle = 45 * (Math.PI/180)

    # we can reliably get the width of the parent element via JQuery
    parentWidth = parentElement_.width()

    # height of the drawing area deduced from parent's width and assumedApsectRatio
    parentHeight = parentWidth / assumedAspectRatio

    # calculate the center of the drawing area (and the center of the outer circle)
    outerCenterX = parentWidth / 2
    outerCenterY = parentHeight / 2 

    # calculate the outer and inner radius
    outerRadius = outerCenterY * outerRadiusBias
    innerRadius = outerRadius * innerRadiusBias

    # calculate the difference between the outer and inner radius
    radiusDiff = outerRadius - innerRadius

    # calculate inner circle's translation distance
    innerTranslateDistance = radiusDiff * innerCircleTranslationBias

    # calculate the center coordinates of the inner circle
    innerCenterX = outerCenterX + (innerTranslateDistance * Math.cos(logoAngle))
    innerCenterY = outerCenterY + (innerTranslateDistance  * Math.sin(logoAngle))

    outerFill = options_? and options_.outerFillColor? and "fill: #{options_.outerFillColor};" or "fill: #0066CC;"
    outerStroke = options_? and options_.outerStrokeWidth? and options_.outerStrokeColor? and
        "stroke-width: #{options_.outerStrokeWidth}; stroke: #{options_.outerStrokeColor};" or "stroke: none;"

    innerFill = options_? and options_.innerFillColor? and "fill: #{options_.innerFillColor};" or "fill: white;"
    innerStroke = options_? and options_.innerStrokeWidth? and options_.innerStrokeColor? and
        "stroke-width: #{options_.innerStrokeWidth}; stroke: #{options_.innerStrokeColor};" or "stroke: none;"

    rectHtml = options_? and options_.rectStrokeWidth? and options_.rectStrokeColor? and
        "<rect x=\"10\" y=\"10\" width=\"#{parentWidth - 20}\" height=\"#{parentHeight - 20}\" style=\"
        stroke-width: #{options_.rectStrokeWidth}; stroke: #{options_.rectStrokeColor}; fill: none;\" />
        <text x=\"15\" y=\"20\" style=\"fill: #{options_.outerFillColor}; font-family: Courier; font-size: 8pt;\">
        #{appName} v#{appVersion} (#{appReleaseName}) built #{appBuildTime} by #{appBuilder}
        </text>
        <text x=\"#{parentWidth - 520}\" y=\"20\" style=\"fill: #{options_.innerFillColor}; font-family: Courier; font-size: 8pt;\">
        client width=#{parentWidth} height=#{parentHeight} with display aspect=#{assumedAspectRatio}
        </text>
        " or ""
    
    logoHtml = "<div class=\"classEncapsuleCrescentLogo\">
    <svg width=\"#{parentWidth}\" height=\"#{parentHeight}\">
    <circle cx=\"#{outerCenterX}\" cy=\"#{outerCenterY}\" r=\"#{outerRadius}\" style=\"#{outerFill} #{outerStroke}\" />
    <circle cx=\"#{innerCenterX}\" cy=\"#{innerCenterY}\" r=\"#{innerRadius}\" style=\"#{innerFill} #{innerStroke}\" />
    #{rectHtml}
    </svg>
    </div>"

    logoElementToBeInserted = $(logoHtml)
    logoElement = parentElement_.append logoElementToBeInserted
    logoElement.css { margin: "0px", padding: "0px" }

    @



class namespaceWidget.logo

    @optionsDefault: optionsDefault
    @optionsOutlineOnly: optionsOutlineOnly
    @draw: drawLogo

