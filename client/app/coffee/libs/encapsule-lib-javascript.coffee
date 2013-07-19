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
# encapsule-lib-javascript.coffee
#
# Low-level library routines inspired by (and often copied) from http://coffeescriptcookbook.com
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.js = Encapsule.code.lib.js? and Encapsule.code.lib.js or @Encapsule.code.lib.js = {}


# Copied from http://coffeescriptcookbook.com/chapters/classes_and_objects/cloning

Encapsule.code.lib.js.clone = (object_) ->
    # \ BEGIN: clone function
    try
        # \ BEGIN: try
        if not object_? or typeof object_ isnt 'object'
            return object_

        if object_ instanceof Date
            return new Date(object_.getTime()) 

        if object_ instanceof RegExp
            flags = ''
            flags += 'g' if object_.global?
            flags += 'i' if object_.ignoreCase?
            flags += 'm' if object_.multiline?
            flags += 'y' if object_.sticky?
            return new RegExp(object_.source, flags) 

        newInstance = new object_.constructor()

        for key of object_
            newInstance[key] = Encapsule.code.lib.js.clone object_[key]

        return newInstance
        # / END: try

    catch exception
        Console.message("Encapsule.code.lib.js.clone: #{exception}")
    # / END: clone function


Encapsule.code.lib.js.dictionaryLength = (dictionary_) -> Object.keys(dictionary_).length

