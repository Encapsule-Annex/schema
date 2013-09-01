###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------



------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

ONMjs = Encapsule.code.lib.omm
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observers = {}



#
# ============================================================================
class ONMjs.observers.ObjectModelNavigatorNamespaceContextElement
    constructor: (prefix_, label_, selector_, selectorStore_, options_) ->
        try
            @prefix = prefix_? and prefix_ or ""
            @label = label_? and label_ or "<no label provided>"
            @selector = selector_? and selector_ and selector_.clone() or throw "Missing selector input parameter."
            @selectorStore = selectorStore_? and selectorStore_ or throw "Missing selector store input parameter."
            options = options_? and options_ or {}
            @optionsNoLink = options.noLink? and options.noLink or false

            @onClick = =>
                @selectorStore.setSelector(@selector)

        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceContextElement failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceContextElement", ( -> """<span data-bind="if: prefix"><span class="classObjectModelNavigatorNamespaceContextPrefix" data-bind="html: prefix"></span></span><span data-bind="ifnot: optionsNoLink"><span class="classObjectModelNavigatorNamespaceContextLabel classObjectModelNavigatorMouseOverCursorPointer" data-bind="html: label, click: onClick"></span></span><span data-bind="if: optionsNoLink"><span class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: label"></span></span>"""))

#
# ============================================================================
class ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink
    constructor: (prefix_, label_, selector_, selectorStore_, options_, callback_) ->
        try
            @prefix = prefix_? and prefix_ or ""
            @label = label_? and label_ or "<no label provided>"
            @selector = selector_? and selector_ and selector_.clone() or undefined
            @selectorStore = selectorStore_? and selectorStore_ or undefined
            @options = options_? and options_ or {}
            @optionsNoLink = @options.noLink? and @options.noLink or false
            @optionsStyleClass = @options.styleClass? and @options.styleClass or undefined
            @callback = callback_

            @onClick = =>
                @callback(@prefix, @label, @selector, @selectorStore, @options)

        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink", ( -> """
<span class="classObjectModelNavigatorNamespaceCallbackLink">
<span data-bind="if: prefix"><span class="prefix" data-bind="html: prefix"></span></span>
<span data-bind="ifnot: optionsNoLink">
    <span class="link classObjectModelNavigatorMouseOverCursorPointer" data-bind="html: label, click: onClick, css: optionsStyleClass"></span>
</span>
<span data-bind="if: optionsNoLink">
    <span class="nolink" data-bind="html: label, css: optionsStyleClass"></span>
</span>
</span>
"""))

