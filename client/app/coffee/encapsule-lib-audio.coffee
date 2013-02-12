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
        if blipper?
            nativeAudioObject =  blipper.get(0)
            nativeAudioObject.play()

    blipperHost.fireAtRandom = (name_, minMsSilence_, maxMsSilence_) ->
        if not name_ or not minMsSilence_ or not maxMsSilence_ 
            throw "name_, minMsSilence_, and maxMsSilence_ params must be specified."
        fireAtRandom blipperHost, name_ minMsSilence_, maxMsSilence_

    blipperHost.blippers = {}

    blipperHost




class namespaceWidget.blipper
    @createHost: createBlipperHost



fireAtRandom = (blipperHost_, name_, minMsSilence_, maxMsSilence_) ->
    blipper = blipperHost_
    name = name_
    minMs = minMsSilence_
    randSeedMs = maxMsSilence_ - minMsSilence_
    interval = minMs + (Math.random() * randSeedMs)
    setTimeout ( ->
        blipper.blip name
        fireAtRandom = fireAtRandom
        fireAtRandom blipper, name, minMs, (randSeedMs + minMs)
        ), interval

class namespaceWidget.util
    @blipAtRandom: fireAtRandom