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

optionsDefault = { outerFillColor: "#004466", innerFillColor: "#003355" }

optionsOutlineOnly = { outerStrokeWidth: 1, outerStrokeColor: "#006699", innerStrokeWidth: 1, innerStrokeColor: "#006699" }

drawLogo = (parentElement_, options_) ->

    # aspect = w / h = 16 / 9 = 1.77778
    # w / 1.77778 = h

    parentWidth = parentElement_.width()
    parentCenterX = parentWidth / 2
    parentHeight = parentWidth / 1.7778 
    parentCenterY = parentHeight / 2 


    logoOuterRadius = (parentHeight * 0.9) / 2
    logoInnerRadius = logoOuterRadius * 0.83
    logoCenterX = parentCenterX
    logoCenterY = parentCenterY
    logoCenterInnerX = logoCenterX + ((logoOuterRadius - logoInnerRadius) * Math.sin(45))
    logoCenterInnerY = logoCenterY + ((logoOuterRadius - logoInnerRadius) * Math.cos(45))

    outerFill = options_? and options_.outerFillColor? and "fill: #{options_.outerFillColor};" or "fill: none;"
    outerStroke = options_? and options_.outerStrokeWidth? and options_.outerStrokeColor? and
        "stroke-width: #{options_.outerStrokeWidth}; stroke: #{options_.outerStrokeColor};" or "stroke: none;"

    innerFill = options_? and options_.innerFillColor? and "fill: #{options_.innerFillColor};" or "fill: none;"
    innerStroke = options_? and options_.innerStrokeWidth? and options_.innerStrokeColor? and
        "stroke-width: #{options_.innerStrokeWidth}; stroke: #{options_.innerStrokeColor};" or "stroke: none;"
    
    logoHtml = "<div class=\"classEncapsuleCrescentLogo\">
    <svg width=\"#{parentWidth}\" height=\"#{parentHeight}\">
    <circle cx=\"#{logoCenterX}\" cy=\"#{logoCenterY}\" r=\"#{logoOuterRadius}\" style=\"#{outerFill} #{outerStroke}\" />
    <circle cx=\"#{logoCenterInnerX}\" cy=\"#{logoCenterInnerY}\" r=\"#{logoInnerRadius}\" style=\"#{innerFill} #{innerStroke}\" />
    <rect x=\"10\" y=\"10\" width=\"#{parentWidth - 20}\" height=\"#{parentHeight - 20}\" style=\"stroke-width: 1; stroke: #007799; fill: none;\" />
    </svg>
    </div>"

    logoElementToBeInserted = $(logoHtml)
    logoElement = parentElement_.append logoElementToBeInserted
    logoElement.css { margin: "0px", padding: "0px" }

    @



class namespaceWidget.EncapsuleLogo

    @optionsDefault: optionsDefault
    @optionsOutlineOnly: optionsOutlineOnly
    @drawLogo: drawLogo

