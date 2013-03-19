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
# schema-view-model-layout.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


Encapsule.code.app.viewLayout = [
    {                                                                    
        name: "Frame Stack Split"                                        
        type: "vertical"                                                 
        Q1WindowDescriptor: undefined                                    
        Q2WindowDescriptor: {                                            
            id: "idFrameStack"                                           
            name: "Frame Stack Window"                                   
            modes: { full: { reserve: 300 }, min: { reserve: 64 } }      
            }                                                            
        },                                                               
    {                                                                    
        name: "Toolbar Split"                                            
        type: "horizontal"                                               
        Q1WindowDescriptor: {                                            
            id: "idToolbar"                                              
            name: "Toolbar Window"                                       
            modes: { full: { reserve: 128 }, min: { reserve: 64 } }      
            }                                                            
        Q2WindowDescriptor: undefined                                    
        },                                                               
    {                                                                    
        name: "Select 1 Split"                                           
        type: "vertical"                                                 
        Q1WindowDescriptor: {                                            
            id: "idSelect1"                                              
            name: "Select 1 Window"                                      
            modes: { full: { reserve: 300 }, min: { reserve: 64 } }      
            }                                                            
        Q2WindowDescriptor: undefined                                    
        },                                                               
    {                                                                    
        name: "Select 2 Split"                                           
        type: "vertical"                                                 
        Q1WindowDescriptor: {                                            
            id: "idSelect2"                                              
            name: "Select 1 Window"                                      
            modes: { full: { reserve: 300 }, min: { reserve: 64 } }      
            }                                                            
        Q2WindowDescriptor: undefined                                    
        },                                                               
    {                                                                    
        name: "SVG/Edit Split"                                           
        type: "horizontal"                                               
        Q1WindowDescriptor: {                                            
            id: "idSVGPlane"                                             
            name: "SVG Plane"                                            
            modes: { full: { reserve: 0 }, min: { reserve: 0 } }         
            }                                                            
        Q2WindowDescriptor: {                                            
            id: "idEdit1"                                                
            name: "Edit 1 Window"                                        
            modes: { full: { reserve: 0 }, min: { reserve: 64 } }        
            }                                                            
        }                                                                
    ]
###
>:)-~
###

                                                                                 