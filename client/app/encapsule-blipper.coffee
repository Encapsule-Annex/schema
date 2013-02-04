#
# encapsule-blipper.coffee
#
# Dumb routines for leveraging HTML5 audio tag in trivial ways
# to signal app state changes (e.g. might be useful for UI,
# or debug)
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceAudio = Encapsule.audio? and Encapsule.audio or @Encapsule.audio = {}
namespaceWidget = Encapsule.audio.widget? and Encapsule.audio.widget or @Encapsule.audio.widget = {}

createBlipper = (hostElement_, name_, source_, options_) ->
    blipperId = "id#{uuid.v4()}"
    blipperHtml = "<audio name=\"#{name_}\" src=\"#{source_}\" id=\"#{blipperId}\" class=\"classBlipper\" ></audio>"
    hostElement_.append $(blipperHtml)
    blipperElement = $("##{blipperId}")
    items = hostElement_.blippers
    items[name_] = blipperElement

createBlipperHost = (parentElement_, options_) ->
    if not parentElement_? then throw "parentElement_ must be specified as a JQuery selector object"
    blipperHostId = "id#{uuid.v4()}"
    blipperHostHtml = "<div id=\"#{blipperHostId}\" style=\"\" class=\"classBlipperHost\"></div>"
    parentElement_.append($(blipperHostHtml))
    blipperHost = $("##{blipperHostId}")
    blipperHost.createBlipper = (name_, source_, options_) ->
        if not name_? or not source_? then throw "name_ and _source parameters must be specified"
        createBlipper blipperHost, name_, source_, options_
    blipperHost.blip = (name_) ->
        items = @blippers
        blipper = items[name_]
        if blipper? then blipper.get(0).play()
    blipperHost.blippers = {}
    blipperHost

class namespaceWidget.blipper
    @createHost: createBlipperHost

