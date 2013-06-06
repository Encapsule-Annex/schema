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
# encapsule-lib-knockout-bindings.coffee
#
# Copied from: http://jsfiddle.net/aBUEu/1/



ko.bindingHandlers.editableText =
  init: (element, valueAccessor) ->
    $(element).on 'blur', ->
      observable = valueAccessor()
      observable $(@).text()
  
  update: (element, valueAccessor) ->
    value = ko.utils.unwrapObservable valueAccessor()
    $(element).text value