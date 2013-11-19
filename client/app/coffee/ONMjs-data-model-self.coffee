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
Encapsule.code.lib.onm = Encapsule.code.lib.onm? and Encapsule.code.lib.onm or @Encapsule.code.lib.onm = {}

ONMjs = Encapsule.code.lib.onm
ONMjs.dataModels = ONMjs.dataModels? and ONMjs.dataModels or ONMjs.dataModels = {}

ONMjs.dataModels.implementation = ONMjs.dataModels.implementation? and ONMjs.dataModels.implementation or ONMjs.dataModels.implementation = {}

ONMjs.dataModels.implementation.selfDeclaration = {}

ONMjs.dataModels.implementation.selfDeclaration.namespaceMetaProperties =
    namespaceType: "extensionPoint"
    jsonTag: "metaProperties"
    ____label: "Meta-Properties"
    ____description: "Collection of this namespaces' meta-properties. By convention, meta-properties start with four leading underscores."
    componentArchetype:
        namespaceType: "component"
        jsonTag: "metaproperty"
        ____label: "Meta-Property"
        ____description: "Meta property declaration."
        ____getLabelVariant: "jsonTagAndValue"
        
        namespaceProperties:
            userImmutable:
                uuid:
                    ____type: "uuid"
                    ____description: "A unique identifier assigned to this meta-property."
                    fnCreate: -> uuid.v4()
            userMutable:
                jsonTag:
                    ____type: "JSON tag string"
                    ____description: "The JavaScript/JSON name to be used for this meta-property."
                    defaultValue: ""
                value:
                    ____type: "string"
                    ____description: "The default value to be assigned new instances this meta-property."
                    defaultValue: ""

ONMjs.dataModels.implementation.selfDeclaration.namespaceProperty =
    namespaceType: "component"
    jsonTag: "property"
    ____label: "Property"
    ____description: "Namespace property."
    ____getLabelVariant: "jsonTagAndValue"
    namespaceProperties:
        userImmutable:
            uuid:
                ____type: "uuid"
                ____description: "A unique identifier assigned to this immutable property."
                fnCreate: -> uuid.v4()
        userMutable:
            jsonTag:
                ____type: "JSON tag string"
                ____description: "The Javascript/JSON name to be used for this mutable property."
                defaultValue: ""
            value:
                ____type: "string"
                ____description: "The default value to be assigned new instances of this mutable property"
                defaultValue: ""
            ____type:
                ____type: "string"
                ____description: "A flag leveraged by ONMjs observers to discriminate the type of the mutable property."
                defaultValue: ""
            ____description:
                ____type: "string"
                ____description: "A human-friendly string explaining what this mutable property is used for."
                defaultValue: ""
    subNamespaces: [
        ONMjs.dataModels.implementation.selfDeclaration.namespaceMetaProperties        
    ]

ONMjs.dataModels.implementation.selfDeclaration.namespaceProperties =
    namespaceType: "child"
    jsonTag: "properties"
    ____label: "Namespace Properties"
    ____description: "Immutable and mutable properties of this namespace."
    subNamespaces: [
        {
            namespaceType: "extensionPoint"
            jsonTag: "userImmutable"
            ____label: "Immutable Properties"
            ____description: "User immutable namespace properties."
            componentArchetype: ONMjs.dataModels.implementation.selfDeclaration.namespaceProperty 
        }
        {
            namespaceType: "extensionPoint"
            jsonTag: "userMutable"
            ____label: "Mutable Properties"
            ____description: "User mutable namespace properties."
            componentArchetype: ONMjs.dataModels.implementation.selfDeclaration.namespaceProperty 

        }
    ]

ONMjs.dataModels.implementation.selfDeclaration.semanticBindings =
    namespaceType: "child"
    jsonTag: "semanticBindings"
    ____label: "Semantic Bindings"
    ____description: "Semantic bindings control ONMjs behavior at runtime by leveraging either built-in library functionality, or callback functions you add to your data model declaration object manually."
    namespaceProperties:
        userMutable:
            componentKeyGenerator:
                defaultValue: "internalLuid"
                ____type: "enum"
                ____description: "A flag that indicates to ONMjs how keys for new components are to be generated."
                ____options: [ "disabled", "internalLuid", "internalUuid", "external" ]
            namespaceVersioning:
                defaultValue: "disabled"
                ____type: "enum"
                ____description: "A flag that indicated to ONMjs if and how namespaces will be versioned."
                ____options: [ "disabled", "internalSimple", "internalAdvanced", "external" ]



ONMjs.dataModels.selfDeclaration = {
    namespaceType: "root"
    jsonTag: "littleDragon"
    ____label: "ONMjs Data Model Editor"
    ____description: "ONMjs data model declaration editor."

    subNamespaces: [   
        {
            namespaceType: "extensionPoint"
            jsonTag: "dragonEggs"
            ____label: "ONMjs Data Models"
            ____description: "ONMjs data model declaration collection."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "dragonEgg"
                ____label: "ONMjs Data Model"
                ____description: "ONMjs data model declaration."
                ____getLabelVariant: "jsonTagAndNamespaceType"

                namespaceProperties: 
                    userImmutable:
                        revision:
                            ____type: "integer"
                            ____description: "Revision number of this namespace."
                            defaultValue: 0
                        uuid:
                            ____type: "uuid"
                            ____description: "The unique identifier and key of this namespace object."
                            defaultValaue: undefined
                        uuidRevision:
                            ____type: "uuid"
                            ____description: "A unique identifier assigned this namespace object every time it is revised."
                            fnCreate: (data_) -> uuid.v4()
                        namespaceType:
                            defaultValue: "root"
                            ____type: "enum"
                            ____description: "A flag indicating to ONMjs the type of namespace you're declaring."
                    userMutable:
                        jsonTag:
                            ____type: "JSON tag string"
                            ____description: "The Javascript/JSON name to be used for this namespace."
                            defaultValue: ""
                        ____label:
                            ____type: "String"
                            ____description: "A human-friendly label used by ONMjs observers."
                            defaultValue: ""
                        ____description:
                            ____description: "A human-friendly description of this mutable property."
                            ____type: "String"
                            defaultValue: ""
                subNamespaces: [
                    ONMjs.dataModels.implementation.selfDeclaration.namespaceProperties 
                    ONMjs.dataModels.implementation.selfDeclaration.namespaceMetaProperties 
                    ONMjs.dataModels.implementation.selfDeclaration.semanticBindings
                    {
                        namespaceType: "extensionPoint"
                        jsonTag: "namespaces"
                        ____label: "Namespaces"
                        ____description: "A collection of subnamespace declarations."
                        componentArchetype: {
                            namespaceType: "component"
                            jsonTag: "namespace"
                            ____label: "Namespace"
                            ____description: "ONMjs component namespace declaration."
                            ____getLabelVariant: "jsonTagAndNamespaceType"
                            namespaceProperties: 
                                userImmutable:
                                    revision:
                                        ____type: "integer"
                                        ____description: "Revision number of this namespace."
                                        defaultValue: 0
                                    uuid:
                                        ____type: "uuid"
                                        ____description: "The unique identifier and key of this namespace object."
                                        fnCreate: -> uuid.v4()
                                    uuidRevision:
                                        ____type: "uuid"
                                        ____description: "A unique identifier assigned this namespace object every time it is revised."
                                        fnCreate: -> uuid.v4()
                                userMutable:
                                    namespaceType:
                                        defaultValue: "invalid"
                                        ____type: "enum"
                                        ____options: [ "child", "extensionPoint", "component" ]
                                        ____description: "A flag indicating to ONMjs the type of namespace you're declaring."
                                    jsonTag:
                                        ____type: "JSON tag string"
                                        ____description: "The Javascript/JSON name to be used for this namespace."
                                        ____description: "A flag indicating to ONMjs the type of namespace you're declaring."
                                        defaultValue: ""
                                    ____label:
                                        ____type: "String"
                                        ____description: "A human-friendly label used by ONMjs observers."
                                        defaultValue: ""
                                    ____description:
                                        ____type: "String"
                                        ____description: "A human-friendly description of this mutable property."
                                        defaultValue: ""
                            subNamespaces: [
                                ONMjs.dataModels.implementation.selfDeclaration.namespaceProperties 
                                ONMjs.dataModels.implementation.selfDeclaration.namespaceMetaProperties 
                                {
                                    namespaceType: "extensionPoint"
                                    jsonTag: "namespaces"
                                    ____label: "Namespaces"
                                    ____description: "Subnamespace collection."
                                    componentArchetypePath: "littleDragon.dragonEggs.dragonEgg.namespaces.namespace"
                                }
                            ]
                        } # subnamespaceDeclaration
                    }
                ]
            }
        }
    ]

    semanticBindings:
        setUniqueKey: (data_) -> data_.uuid = uuid.v4()

        getUniqueKey: (data_) -> data_.uuid

        update: (data_) ->
            if data_.revision? then data_.revision++
            if data_.uuidRevision? then data_.uuidRevision = uuid.v4()

        getLabel: (data_, address_) ->
            try
                model = address_.getModel();
                defaultLabel = model.____label? and model.____label or "<no default label specified>"

                if not (model.____getLabelVariant? and model.____getLabelVariant)
                    return defaultLabel

                switch model.____getLabelVariant
                    when "jsonTagAndNamespaceType"
                        if data_.jsonTag? and data_.jsonTag
                            return "#{data_.jsonTag} (#{data_.namespaceType})"
                        break

                    when "jsonTagAndValue"
                        if data_.jsonTag? and data_.jsonTag
                            return "'#{data_.jsonTag}': '#{data_.value}'"
                        break

                    else
                       throw "Unrecognized getLabelVariant string specified."
                
                return model.____label

            catch exception
                throw "Failed in getLabel: #{exception}"

}