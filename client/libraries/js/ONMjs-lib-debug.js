//     uuid.js
//
//     Copyright (c) 2010-2012 Robert Kieffer
//     MIT License - http://opensource.org/licenses/mit-license.php

(function() {
  var _global = this;

  // Unique ID creation requires a high quality random # generator.  We feature
  // detect to determine the best RNG source, normalizing to a function that
  // returns 128-bits of randomness, since that's what's usually required
  var _rng;

  // Node.js crypto-based RNG - http://nodejs.org/docs/v0.6.2/api/crypto.html
  //
  // Moderately fast, high quality
  if (typeof(require) == 'function') {
    try {
      var _rb = require('crypto').randomBytes;
      _rng = _rb && function() {return _rb(16);};
    } catch(e) {}
  }

  if (!_rng && _global.crypto && crypto.getRandomValues) {
    // WHATWG crypto-based RNG - http://wiki.whatwg.org/wiki/Crypto
    //
    // Moderately fast, high quality
    var _rnds8 = new Uint8Array(16);
    _rng = function whatwgRNG() {
      crypto.getRandomValues(_rnds8);
      return _rnds8;
    };
  }

  if (!_rng) {
    // Math.random()-based (RNG)
    //
    // If all else fails, use Math.random().  It's fast, but is of unspecified
    // quality.
    var  _rnds = new Array(16);
    _rng = function() {
      for (var i = 0, r; i < 16; i++) {
        if ((i & 0x03) === 0) r = Math.random() * 0x100000000;
        _rnds[i] = r >>> ((i & 0x03) << 3) & 0xff;
      }

      return _rnds;
    };
  }

  // Buffer class to use
  var BufferClass = typeof(Buffer) == 'function' ? Buffer : Array;

  // Maps for number <-> hex string conversion
  var _byteToHex = [];
  var _hexToByte = {};
  for (var i = 0; i < 256; i++) {
    _byteToHex[i] = (i + 0x100).toString(16).substr(1);
    _hexToByte[_byteToHex[i]] = i;
  }

  // **`parse()` - Parse a UUID into it's component bytes**
  function parse(s, buf, offset) {
    var i = (buf && offset) || 0, ii = 0;

    buf = buf || [];
    s.toLowerCase().replace(/[0-9a-f]{2}/g, function(oct) {
      if (ii < 16) { // Don't overflow!
        buf[i + ii++] = _hexToByte[oct];
      }
    });

    // Zero out remaining bytes if string was short
    while (ii < 16) {
      buf[i + ii++] = 0;
    }

    return buf;
  }

  // **`unparse()` - Convert UUID byte array (ala parse()) into a string**
  function unparse(buf, offset) {
    var i = offset || 0, bth = _byteToHex;
    return  bth[buf[i++]] + bth[buf[i++]] +
            bth[buf[i++]] + bth[buf[i++]] + '-' +
            bth[buf[i++]] + bth[buf[i++]] + '-' +
            bth[buf[i++]] + bth[buf[i++]] + '-' +
            bth[buf[i++]] + bth[buf[i++]] + '-' +
            bth[buf[i++]] + bth[buf[i++]] +
            bth[buf[i++]] + bth[buf[i++]] +
            bth[buf[i++]] + bth[buf[i++]];
  }

  // **`v1()` - Generate time-based UUID**
  //
  // Inspired by https://github.com/LiosK/UUID.js
  // and http://docs.python.org/library/uuid.html

  // random #'s we need to init node and clockseq
  var _seedBytes = _rng();

  // Per 4.5, create and 48-bit node id, (47 random bits + multicast bit = 1)
  var _nodeId = [
    _seedBytes[0] | 0x01,
    _seedBytes[1], _seedBytes[2], _seedBytes[3], _seedBytes[4], _seedBytes[5]
  ];

  // Per 4.2.2, randomize (14 bit) clockseq
  var _clockseq = (_seedBytes[6] << 8 | _seedBytes[7]) & 0x3fff;

  // Previous uuid creation time
  var _lastMSecs = 0, _lastNSecs = 0;

  // See https://github.com/broofa/node-uuid for API details
  function v1(options, buf, offset) {
    var i = buf && offset || 0;
    var b = buf || [];

    options = options || {};

    var clockseq = options.clockseq != null ? options.clockseq : _clockseq;

    // UUID timestamps are 100 nano-second units since the Gregorian epoch,
    // (1582-10-15 00:00).  JSNumbers aren't precise enough for this, so
    // time is handled internally as 'msecs' (integer milliseconds) and 'nsecs'
    // (100-nanoseconds offset from msecs) since unix epoch, 1970-01-01 00:00.
    var msecs = options.msecs != null ? options.msecs : new Date().getTime();

    // Per 4.2.1.2, use count of uuid's generated during the current clock
    // cycle to simulate higher resolution clock
    var nsecs = options.nsecs != null ? options.nsecs : _lastNSecs + 1;

    // Time since last uuid creation (in msecs)
    var dt = (msecs - _lastMSecs) + (nsecs - _lastNSecs)/10000;

    // Per 4.2.1.2, Bump clockseq on clock regression
    if (dt < 0 && options.clockseq == null) {
      clockseq = clockseq + 1 & 0x3fff;
    }

    // Reset nsecs if clock regresses (new clockseq) or we've moved onto a new
    // time interval
    if ((dt < 0 || msecs > _lastMSecs) && options.nsecs == null) {
      nsecs = 0;
    }

    // Per 4.2.1.2 Throw error if too many uuids are requested
    if (nsecs >= 10000) {
      throw new Error('uuid.v1(): Can\'t create more than 10M uuids/sec');
    }

    _lastMSecs = msecs;
    _lastNSecs = nsecs;
    _clockseq = clockseq;

    // Per 4.1.4 - Convert from unix epoch to Gregorian epoch
    msecs += 12219292800000;

    // `time_low`
    var tl = ((msecs & 0xfffffff) * 10000 + nsecs) % 0x100000000;
    b[i++] = tl >>> 24 & 0xff;
    b[i++] = tl >>> 16 & 0xff;
    b[i++] = tl >>> 8 & 0xff;
    b[i++] = tl & 0xff;

    // `time_mid`
    var tmh = (msecs / 0x100000000 * 10000) & 0xfffffff;
    b[i++] = tmh >>> 8 & 0xff;
    b[i++] = tmh & 0xff;

    // `time_high_and_version`
    b[i++] = tmh >>> 24 & 0xf | 0x10; // include version
    b[i++] = tmh >>> 16 & 0xff;

    // `clock_seq_hi_and_reserved` (Per 4.2.2 - include variant)
    b[i++] = clockseq >>> 8 | 0x80;

    // `clock_seq_low`
    b[i++] = clockseq & 0xff;

    // `node`
    var node = options.node || _nodeId;
    for (var n = 0; n < 6; n++) {
      b[i + n] = node[n];
    }

    return buf ? buf : unparse(b);
  }

  // **`v4()` - Generate random UUID**

  // See https://github.com/broofa/node-uuid for API details
  function v4(options, buf, offset) {
    // Deprecated - 'format' argument, as supported in v1.2
    var i = buf && offset || 0;

    if (typeof(options) == 'string') {
      buf = options == 'binary' ? new BufferClass(16) : null;
      options = null;
    }
    options = options || {};

    var rnds = options.random || (options.rng || _rng)();

    // Per 4.4, set bits for version and `clock_seq_hi_and_reserved`
    rnds[6] = (rnds[6] & 0x0f) | 0x40;
    rnds[8] = (rnds[8] & 0x3f) | 0x80;

    // Copy bytes to buffer, if provided
    if (buf) {
      for (var ii = 0; ii < 16; ii++) {
        buf[i + ii] = rnds[ii];
      }
    }

    return buf || unparse(rnds);
  }

  // Export public API
  var uuid = v4;
  uuid.v1 = v1;
  uuid.v4 = v4;
  uuid.parse = parse;
  uuid.unparse = unparse;
  uuid.BufferClass = BufferClass;

  if (_global.define && define.amd) {
    // Publish as AMD module
    define(function() {return uuid;});
  } else if (typeof(module) != 'undefined' && module.exports) {
    // Publish as node.js module
    module.exports = uuid;
  } else {
    // Publish as global (in browsers)
    var _previousRoot = _global.uuid;

    // **`noConflict()` - (browser only) to reset global 'uuid' var**
    uuid.noConflict = function() {
      _global.uuid = _previousRoot;
      return uuid;
    };

    _global.uuid = uuid;
  }
}).call(this);// Generated by CoffeeScript 1.4.0

/*
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
Low-level library routines inspired by (and often copied) from http://coffeescriptcookbook.com
------------------------------------------------------------------------------
*/


(function() {
  var ONMjs, namespaceEncapsule,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.js = (Encapsule.code.lib.js != null) && Encapsule.code.lib.js || (this.Encapsule.code.lib.js = {});

  Encapsule.code.lib.util = (Encapsule.code.lib.util != null) && Encapsule.code.lib.util || (this.Encapsule.code.lib.util = {});

  Encapsule.code.lib.js.clone = function(object_) {
    var flags, key, newInstance;
    try {
      if (!(object_ != null) || typeof object_ !== 'object') {
        return object_;
      }
      if (object_ instanceof Date) {
        return new Date(object_.getTime());
      }
      if (object_ instanceof RegExp) {
        flags = '';
        if (object_.global != null) {
          flags += 'g';
        }
        if (object_.ignoreCase != null) {
          flags += 'i';
        }
        if (object_.multiline != null) {
          flags += 'm';
        }
        if (object_.sticky != null) {
          flags += 'y';
        }
        return new RegExp(object_.source, flags);
      }
      newInstance = new object_.constructor();
      for (key in object_) {
        newInstance[key] = Encapsule.code.lib.js.clone(object_[key]);
      }
      return newInstance;
    } catch (exception) {
      throw "Encapsule.code.lib.js.clone: " + exception;
    }
  };

  Encapsule.code.lib.js.dictionaryLength = function(dictionary_) {
    try {
      return Object.keys(dictionary_).length;
    } catch (exception) {
      throw "Encapsule.code.lib.js.dictionaryLength: " + exception;
    }
  };

  Encapsule.code.lib.util.uuidNull = "00000000-0000-0000-0000-000000000000";

  Encapsule.code.lib.util.getEpochTime = function() {
    return Math.round(new Date().getTime() / 1000.0);
  };

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.base = (Encapsule.code.lib.base != null) && Encapsule.code.lib.base || (this.Encapsule.code.lib.base = {});

  Encapsule.code.lib.base.BackChannel = (function() {

    function BackChannel(logHandler_, errorHandler_) {
      var _this = this;
      try {
        this.logHandler = logHandler_;
        this.errorHandler = errorHandler_;
        this.log = function(html_) {
          try {
            if ((_this.logHandler != null) && _this.logHandler) {
              try {
                _this.logHandler(html_);
              } catch (exception) {
                throw "Error executing log handler function callback: " + exception;
              }
              return true;
            }
            return false;
          } catch (exception) {
            throw "Encapsule.code.lib.base.BackChannel.log failure: " + exception;
          }
        };
        this.error = function(error_) {
          try {
            if ((_this.errorHandler != null) && _this.errorHandler) {
              try {
                _this.errorHandler(error_);
              } catch (exception) {
                throw "Error executing error handler function callback: " + exception;
              }
              return true;
            }
            throw error_;
          } catch (exception) {
            throw "Encapsule.code.lib.base.BackChannel.error failure: " + exception;
          }
        };
      } catch (exception) {
        throw "Encapsule.code.lib.base.BackChannel failure: " + exception;
      }
    }

    return BackChannel;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation = (ONMjs.implementation != null) && ONMjs.implementation || (ONMjs.implementation = {});

  ONMjs.implementation.ModelDetails = (function() {

    function ModelDetails(model_, objectModelDeclaration_) {
      var buildOMDescriptorFromLayout,
        _this = this;
      try {
        this.model = ((model_ != null) && model_) || (function() {
          throw "Internal error missing model input parameter.";
        })();
        buildOMDescriptorFromLayout = function(ONMD_, path_, parentDescriptor_, componentDescriptor_, parentPathIdVector_, parentPathExtensionPointIdVector_) {
          var archetypeDescriptor, componentDescriptor, description, id, label, namespaceProperties, namespaceType, objectModelDescriptorReference, parentPathExtensionPoints, path, pathReference, processArchetypeDeclaration, subNamespace, tag, thisDescriptor, updatedParentPathExtensionPointIdVector, _i, _len, _ref;
          try {
            if (!((ONMD_ != null) && ONMD_)) {
              throw "Missing object model layout object input parameter! If you specified the namespace declaration via object reference, check the validity of the reference.";
            }
            if (!((ONMD_.jsonTag != null) && ONMD_.jsonTag)) {
              throw "Missing required namespace declaration property 'jsonTag'.";
            }
            tag = (ONMD_.jsonTag != null) && ONMD_.jsonTag || (function() {
              throw "Namespace declaration missing required `jsonTag` property.";
            })();
            path = (path_ != null) && path_ && ("" + path_ + "." + tag) || tag;
            label = (ONMD_.____label != null) && ONMD_.____label || ONMD_.jsonTag;
            description = (ONMD_.____description != null) && ONMD_.____description || "no description provided";
            id = _this.countDescriptors++;
            namespaceType = ((ONMD_.namespaceType != null) && ONMD_.namespaceType) || (!id && (ONMD_.namespaceType = "root")) || (function() {
              throw "Internal error unable to determine namespace type.";
            })();
            parentPathExtensionPoints = void 0;
            if ((parentPathExtensionPointIdVector_ != null) && parentPathExtensionPointIdVector_) {
              parentPathExtensionPoints = Encapsule.code.lib.js.clone(parentPathExtensionPointIdVector_);
            } else {
              parentPathExtensionPoints = [];
            }
            namespaceProperties = (ONMD_.namespaceProperties != null) && ONMD_.namespaceProperties || {};
            thisDescriptor = _this.objectModelDescriptorById[id] = {
              "archetypePathId": -1,
              "children": [],
              "componentNamespaceIds": [],
              "description": description,
              "extensionPointReferenceIds": [],
              "id": id,
              "idComponent": id,
              "isComponent": false,
              "jsonTag": tag,
              "label": label,
              "namespaceType": namespaceType,
              "namespaceModelDeclaration": ONMD_,
              "namespaceModelPropertiesDeclaration": namespaceProperties,
              "parent": parentDescriptor_,
              "parentPathExtensionPoints": parentPathExtensionPoints,
              "parentPathIdVector": [],
              "path": path
            };
            _this.objectModelPathMap[path] = thisDescriptor;
            if ((parentDescriptor_ != null) && parentDescriptor_) {
              parentDescriptor_.children.push(thisDescriptor);
              thisDescriptor.parentPathIdVector = Encapsule.code.lib.js.clone(parentDescriptor_.parentPathIdVector);
              thisDescriptor.parentPathIdVector.push(parentDescriptor_.id);
            }
            if (_this.rankMax < thisDescriptor.parentPathIdVector.length) {
              _this.rankMax = thisDescriptor.parentPathIdVector.length;
            }
            componentDescriptor = void 0;
            switch (namespaceType) {
              case "extensionPoint":
                if (!((componentDescriptor_ != null) && componentDescriptor_)) {
                  throw "Internal error: componentDescriptor_ should be defined.";
                }
                thisDescriptor.idComponent = componentDescriptor_.id;
                componentDescriptor = componentDescriptor_;
                componentDescriptor.extensionPoints[path] = thisDescriptor;
                processArchetypeDeclaration = void 0;
                archetypeDescriptor = void 0;
                if ((ONMD_.componentArchetype != null) && ONMD_.componentArchetype) {
                  processArchetypeDeclaration = true;
                  archetypeDescriptor = ONMD_.componentArchetype;
                } else if ((ONMD_.componentArchetypePath != null) && ONMD_.componentArchetypePath) {
                  processArchetypeDeclaration = false;
                  pathReference = ONMD_.componentArchetypePath;
                  objectModelDescriptorReference = _this.objectModelPathMap[pathReference];
                  if (!((objectModelDescriptorReference != null) && objectModelDescriptorReference)) {
                    throw "Extension point namespace '" + path + "' component archetype '" + pathReference + "' was not found and is invalid.";
                  }
                  if (objectModelDescriptorReference.namespaceType !== "component") {
                    throw "Extension point namespace '" + path + "' declares component archetype '" + pathReference + "' which is not a 'component' namespace type.";
                  }
                  objectModelDescriptorReference.extensionPointReferenceIds.push(thisDescriptor.id);
                  thisDescriptor.archetypePathId = objectModelDescriptorReference.id;
                  _this.countExtensionReferences++;
                } else {
                  throw "Cannot process extension point declaration because its corresponding extension archetype is missing from the object model declaration.";
                }
                updatedParentPathExtensionPointIdVector = Encapsule.code.lib.js.clone(parentPathExtensionPoints);
                updatedParentPathExtensionPointIdVector.push(id);
                _this.countExtensionPoints++;
                if (processArchetypeDeclaration) {
                  buildOMDescriptorFromLayout(archetypeDescriptor, path, thisDescriptor, componentDescriptor, thisDescriptor.parentPathIdVector, updatedParentPathExtensionPointIdVector);
                }
                break;
              case "component":
                thisDescriptor.isComponent = true;
                thisDescriptor.extensionPoints = {};
                parentDescriptor_.archetypePathId = id;
                componentDescriptor = thisDescriptor;
                _this.countExtensions++;
                _this.countComponents++;
                break;
              case "root":
                if ((componentDescriptor_ != null) || componentDescriptor) {
                  throw "Internal error: componentDescriptor_ should be undefined.";
                }
                thisDescriptor.isComponent = true;
                thisDescriptor.extensionPoints = {};
                componentDescriptor = thisDescriptor;
                _this.countComponents++;
                break;
              case "child":
                if (!((componentDescriptor_ != null) && componentDescriptor_)) {
                  throw "Internal error: componentDescriptor_ should be defined.";
                }
                thisDescriptor.idComponent = componentDescriptor_.id;
                componentDescriptor = componentDescriptor_;
                _this.countChildren++;
                break;
              default:
                throw "Unrecognized namespace type '" + namespaceType + "' in object model namespace declaration.";
            }
            _this.objectModelDescriptorById[thisDescriptor.idComponent].componentNamespaceIds.push(thisDescriptor.id);
            if (!((ONMD_.subNamespaces != null) && ONMD_.subNamespaces)) {
              return true;
            }
            _ref = ONMD_.subNamespaces;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              subNamespace = _ref[_i];
              buildOMDescriptorFromLayout(subNamespace, path, thisDescriptor, componentDescriptor, thisDescriptor.parentPathIdVector, parentPathExtensionPoints);
            }
            return true;
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.buildOMDescriptorFromLayout fail: " + exception;
          }
        };
        this.getNamespaceDescriptorFromPathId = function(pathId_) {
          var objectModelDescriptor;
          try {
            if (!(pathId_ != null)) {
              throw "Missing path ID parameter!";
            }
            if ((pathId_ < 0) || (pathId_ >= _this.objectModelDescriptorById.length)) {
              throw "Out of range path ID '" + pathId_ + " cannot be resolved.";
            }
            objectModelDescriptor = _this.objectModelDescriptorById[pathId_];
            if (!((objectModelDescriptor != null) && objectModelDescriptor)) {
              throw "Internal error getting namespace descriptor for path ID=" + pathId_ + "!";
            }
            return objectModelDescriptor;
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.getNamespaceDescriptorFromPathId failure: " + exception;
          }
        };
        this.getNamespaceDescriptorFromPath = function(path_) {
          try {
            return _this.getNamespaceDescriptorFromPathId(_this.getPathIdFromPath(path_));
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.getNamespaceDescriptorFromPath failure: " + exception;
          }
        };
        this.getPathIdFromPath = function(path_) {
          var objectModelDescriptor, objectModelPathId;
          try {
            if (!((path_ != null) && path_)) {
              throw "Missing object model path parameter!";
            }
            objectModelDescriptor = _this.objectModelPathMap[path_];
            if (!((objectModelDescriptor != null) && objectModelDescriptor)) {
              throw "Path '" + path_ + "' is not in the '" + _this.model.jsonTag + "' model's address space.";
            }
            objectModelPathId = objectModelDescriptor.id;
            if (!(objectModelPathId != null)) {
              throw "Internal error: Invalid object model descriptor doesn't support id property for path '" + objectModelPath_ + ".";
            }
            return objectModelPathId;
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.getPathIdFromPath fail: " + exception;
          }
        };
        this.getPathFromPathId = function(pathId_) {
          var objectModelDescriptor, path;
          try {
            objectModelDescriptor = _this.getNamespaceDescriptorFromPathId(pathId_);
            if (!((objectModelDescriptor != null) && objectModelDescriptor)) {
              throw "Internal error: Can't find object descriptor for valid path ID '" + pathId_ + ".";
            }
            path = objectModelDescriptor.path;
            if (!((path != null) && path)) {
              throw "Internal error: Invalid object model descriptor doesn't support path property for path '" + objectModelPath_ + ".";
            }
            return path;
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.getPathFromPathId fail: " + exception;
          }
        };
        this.createAddressFromPathId = function(pathId_) {
          var descriptor, newAddress, parentPathId, pathIds, targetDescriptor, token, _i, _len;
          try {
            if (!(pathId_ != null)) {
              throw "Missing path input parameter.";
            }
            targetDescriptor = this.getNamespaceDescriptorFromPathId(pathId_);
            newAddress = new ONMjs.Address(this.model);
            token = void 0;
            pathIds = Encapsule.code.lib.js.clone(targetDescriptor.parentPathIdVector);
            pathIds.push(targetDescriptor.id);
            for (_i = 0, _len = pathIds.length; _i < _len; _i++) {
              parentPathId = pathIds[_i];
              descriptor = this.getNamespaceDescriptorFromPathId(parentPathId);
              if (descriptor.namespaceType === "component") {
                newAddress.implementation.pushToken(token);
              }
              token = new ONMjs.implementation.AddressToken(this.model, descriptor.idExtensionPoint, void 0, descriptor.id);
            }
            newAddress.implementation.pushToken(token);
            return newAddress;
          } catch (exception) {
            throw "ONMjs.implementation.ModelDetails.getAddressFromPathId failure: " + exception;
          }
        };
        if (!((objectModelDeclaration_ != null) && objectModelDeclaration_)) {
          throw "Missing object model delcaration input parameter!";
        }
        if (!((objectModelDeclaration_.jsonTag != null) && objectModelDeclaration_.jsonTag)) {
          throw "Missing required root namespace property 'jsonTag'.";
        }
        this.model.jsonTag = objectModelDeclaration_.jsonTag;
        this.model.label = (objectModelDeclaration_.____label != null) && objectModelDeclaration_.____label || objectModelDeclaration_.jsonTag;
        this.model.description = (objectModelDeclaration_.____description != null) && objectModelDeclaration_.____description || "<no description provided>";
        this.objectModelDeclaration = Encapsule.code.lib.js.clone(objectModelDeclaration_);
        Object.freeze(this.objectModelDeclaration);
        if (!((this.objectModelDeclaration != null) && this.objectModelDeclaration)) {
          throw "Failed to deep copy (clone) source object model declaration.";
        }
        this.objectModelPathMap = {};
        this.objectModelDescriptorById = [];
        this.countDescriptors = 0;
        this.countComponents = 0;
        this.countExtensionPoints = 0;
        this.countExtensions = 0;
        this.countExtensionReferences = 0;
        this.countChildren = 0;
        this.rankMax = 0;
        buildOMDescriptorFromLayout(objectModelDeclaration_);
        if (this.countExtensionPoints !== this.countExtensions + this.countExtensionReferences) {
          throw "Layout declaration error: extension point and extension descriptor counts do not match. countExtensionPoints=" + this.countExtensionPoints + " countExtensions=" + this.countExtensions;
        }
        if (this.countComponents !== this.countExtensionPoints + 1 - this.countExtensionReferences) {
          throw "Layout declaration error: component count should be " + ("extension count + 1 - extension references. componentCount=" + this.countComponents + " ") + (" countExtensions=" + this.countExtensions + " extensionReferences=" + this.countExtensionReferences);
        }
        Object.freeze(this.objectModelPathMap);
        Object.freeze(this.objectModelDescriptorById);
        this.semanticBindings = (this.objectModelDeclaration.semanticBindings != null) && this.objectModelDeclaration.semanticBindings || {};
        this.componentKeyGenerator = (this.semanticBindings.componentKeyGenerator != null) && this.semanticBindings.componentKeyGenerator || "external";
        this.namespaceVersioning = (this.semanticBindings.namespaceVersioning != null) && this.semanticBindings.namespaceVersioning || "disabled";
        switch (this.componentKeyGenerator) {
          case "disabled":
            if ((this.semanticBindings.getUniqueKey != null) && this.semanticBindings.getUniqueKey) {
              delete this.semanticBindings.getUniqueKey;
            }
            if ((this.semanticBindings.setUniqueKey != null) && this.semanticBindings.setUniqueKey) {
              delete this.semanticBindings.setUniqueKey;
            }
            break;
          case "internalLuid":
            this.semanticBindings.getUniqueKey = function(data_) {
              return data_.key;
            };
            this.semanticBindings.setUniqueKey = function(data_) {
              data_.key = (ONMjs.implementation.LUID != null) && ONMjs.implementation.LUID || (ONMjs.implementation.LUID = 1);
              ONMjs.implementation.LUID++;
              return data_.key;
            };
            break;
          case "internalUuid":
            this.semanticBindings.getUniqueKey = function(data_) {
              return data_.key;
            };
            this.semanticBindings.setUniqueKey = function(data_) {
              return data_.key = uuid.v4();
            };
            break;
          case "external":
            break;
          default:
            throw "Unrecognized componentKeyGenerator='" + this.componentKeyGenerator + "'";
        }
        switch (this.namespaceVersioning) {
          case "disabled":
            if ((this.semanticBindings.update != null) && this.semanticBindings.update) {
              delete this.semanticBindings.update;
            }
            break;
          case "internalSimple":
            this.semanticBindings.update = function(data_) {
              if (data_.revision != null) {
                return data_.revision++;
              }
            };
            break;
          case "internalAdvanced":
            this.semanticBindings.update = function(data_) {
              if (data_.revision != null) {
                data_.revision++;
              }
              if (data_.uuidRevision != null) {
                data_.uuidRevision = uuid.v4();
              }
              if (data_.revisionTime != null) {
                return data_.revisionTime = Encapsule.code.lib.util.getEpochTime();
              }
            };
            break;
          default:
            throw "Unrecognized namespaceVersionion=`" + this.namespaceUpdateRevision + "'";
        }
      } catch (exception) {
        throw "ONMjs.implementation.ModelDetails failure: " + exception;
      }
    }

    return ModelDetails;

  })();

  ONMjs.Model = (function() {

    function Model(objectModelDeclaration_) {
      var _this = this;
      try {
        this.implementation = new ONMjs.implementation.ModelDetails(this, objectModelDeclaration_);
        this.createRootAddress = function() {
          try {
            return new ONMjs.Address(_this, [new ONMjs.implementation.AddressToken(_this, void 0, void 0, 0)]);
          } catch (exception) {
            throw "ONMjs.Model.getRootAddress failure: " + exception;
          }
        };
        this.createPathAddress = function(path_) {
          var newAddress, pathId;
          try {
            pathId = _this.implementation.getPathIdFromPath(path_);
            newAddress = _this.implementation.createAddressFromPathId(pathId);
            return newAddress;
          } catch (exception) {
            throw "ONMjs.Model.getAddressFromPath failure: " + exception;
          }
        };
        this.getSemanticBindings = function() {
          try {
            return _this.implementation.semanticBindings;
          } catch (exception) {
            throw "ONMjs.Model.getSemanticBindings failure: " + exception;
          }
        };
        this.isEqual = function(model_) {
          try {
            return _this.jsonTag === model_.jsonTag;
          } catch (exception) {
            throw "ONMjs.Model.isEqual failure: " + exception;
          }
        };
      } catch (exception) {
        throw "ONMjs.Model construction fail: " + exception;
      }
    }

    return Model;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation = (ONMjs.implementation != null) && ONMjs.implementation || (ONMjs.implementation = {});

  ONMjs.implementation.AddressDetails = (function() {

    function AddressDetails(address_, model_, tokenVector_) {
      var token, _i, _len, _ref,
        _this = this;
      try {
        this.address = ((address_ != null) && address_) || (function() {
          throw "Internal error missing address input parameter.";
        })();
        this.model = ((model_ != null) && model_) || (function() {
          throw "Internal error missing model input paramter.";
        })();
        this.getModelPath = function() {
          var lastToken;
          try {
            if (!_this.tokenVector.length) {
              throw "Invalid address contains no address tokens.";
            }
            lastToken = _this.getLastToken();
            return lastToken.namespaceDescriptor.path;
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.getModelPathFromAddress failure: " + exception;
          }
        };
        this.getModelDescriptorFromSubpath = function(subpath_) {
          var path;
          try {
            path = "" + (_this.getModelPath()) + "." + subpath_;
            return _this.model.implementation.getNamespaceDescriptorFromPath(path);
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.getModelDescriptorFromSubpath failure: " + exception;
          }
        };
        this.createSubpathIdAddress = function(pathId_) {
          var addressedComponentDescriptor, addressedComponentToken, newAddress, newToken, newTokenVector, targetNamespaceDescriptor;
          try {
            if (!((pathId_ != null) && pathId_ > -1)) {
              throw "Missing namespace path ID input parameter.";
            }
            addressedComponentToken = _this.getLastToken();
            addressedComponentDescriptor = addressedComponentToken.componentDescriptor;
            targetNamespaceDescriptor = _this.model.implementation.getNamespaceDescriptorFromPathId(pathId_);
            if (targetNamespaceDescriptor.idComponent !== addressedComponentDescriptor.id) {
              throw "Invalid path ID specified does not resolve to a namespace in the same component as the source address.";
            }
            newToken = new ONMjs.implementation.AddressToken(_this.model, addressedComponentToken.idExtensionPoint, addressedComponentToken.key, pathId_);
            newTokenVector = _this.tokenVector.length > 0 && _this.tokenVector.slice(0, _this.tokenVector.length - 1) || [];
            newTokenVector.push(newToken);
            newAddress = new ONMjs.Address(_this.model, newTokenVector);
            return newAddress;
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.createSubpathIdAddress failure: " + exception;
          }
        };
        this.pushToken = function(token_) {
          var parentToken;
          try {
            if (_this.tokenVector.length) {
              parentToken = _this.tokenVector[_this.tokenVector.length - 1];
              _this.validateTokenPair(parentToken, token_);
            }
            _this.tokenVector.push(token_.clone());
            if (token_.componentDescriptor.id === 0) {
              _this.complete = true;
            }
            if (token_.keyRequired) {
              _this.keysRequired = true;
            }
            if (!token_.isQualified()) {
              _this.keysSpecified = false;
            }
            _this.humanReadableString = void 0;
            _this.hashString = void 0;
            return _this.address;
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.pushToken failure: " + exception;
          }
        };
        this.validateTokenPair = function(parentToken_, childToken_) {
          try {
            if (!((parentToken_ != null) && parentToken_ && (childToken_ != null) && childToken_)) {
              throw "Internal error: input parameters are not correct.";
            }
            if (!childToken_.keyRequired) {
              throw "Child token is invalid because it specifies a namespace in the root component.";
            }
            if (parentToken_.namespaceDescriptor.id !== childToken_.extensionPointDescriptor.id) {
              throw "Child token is invalid because the parent token does not select the required extension point namespace.";
            }
            if (!parentToken_.isQualified() && childToken_.isQualified()) {
              throw "Child token is invalid because the parent token is unqualified and the child is qualified.";
            }
            return true;
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.validateTokenPair the specified parent and child tokens are incompatible and cannot be used to form an address: " + exception;
          }
        };
        this.getLastToken = function() {
          try {
            if (!_this.tokenVector.length) {
              throw "Illegal call to getLastToken on uninitialized address class instance.";
            }
            return _this.tokenVector[_this.tokenVector.length - 1];
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.getLastToken failure: " + exception;
          }
        };
        this.getDescriptor = function() {
          try {
            return _this.getLastToken().namespaceDescriptor;
          } catch (exception) {
            throw "ONMjs.implementation.AddressDetails.getDescriptor failure: " + exception;
          }
        };
        this.tokenVector = [];
        this.parentExtensionPointId = -1;
        this.complete = false;
        this.keysRequired = false;
        this.keysSpecified = true;
        _ref = (tokenVector_ != null) && tokenVector_ || [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          token = _ref[_i];
          this.pushToken(token);
        }
        this.parentAddressesAscending = void 0;
        this.parentAddressesDescending = void 0;
        this.subnamespaceAddressesAscending = void 0;
        this.subnamespaceAddressesDescending = void 0;
        this.subcomponentAddressesAscending = void 0;
        this.subcomponentsAddressesDescending = void 0;
        this.humanReadableString = void 0;
        this.hashString = void 0;
      } catch (exception) {
        throw "ONMjs.implementation.AddressDetails failure: " + exception;
      }
    }

    return AddressDetails;

  })();

  ONMjs.Address = (function() {

    function Address(model_, tokenVector_) {
      this.visitExtensionPointAddresses = __bind(this.visitExtensionPointAddresses, this);

      this.visitChildAddresses = __bind(this.visitChildAddresses, this);

      this.visitSubaddressesDescending = __bind(this.visitSubaddressesDescending, this);

      this.visitSubaddressesAscending = __bind(this.visitSubaddressesAscending, this);

      this.visitParentAddressesDescending = __bind(this.visitParentAddressesDescending, this);

      this.visitParentAddressesAscending = __bind(this.visitParentAddressesAscending, this);

      this.getPropertiesModel = __bind(this.getPropertiesModel, this);

      this.getModel = __bind(this.getModel, this);

      this.createSubcomponentAddress = __bind(this.createSubcomponentAddress, this);

      this.createComponentAddress = __bind(this.createComponentAddress, this);

      this.createSubpathAddress = __bind(this.createSubpathAddress, this);

      this.createParentAddress = __bind(this.createParentAddress, this);

      this.clone = __bind(this.clone, this);

      this.isEqual = __bind(this.isEqual, this);

      this.isRoot = __bind(this.isRoot, this);

      this.getHashString = __bind(this.getHashString, this);

      this.getHumanReadableString = __bind(this.getHumanReadableString, this);

      var _this = this;
      try {
        this.model = (model_ != null) && model_ || (function() {
          throw "Missing required object model input parameter.";
        })();
        this.implementation = new ONMjs.implementation.AddressDetails(this, model_, tokenVector_);
        this.isComplete = function() {
          return _this.implementation.complete;
        };
        this.isQualified = function() {
          return !_this.implementation.keysRequired || _this.implementation.keysSpecified;
        };
        this.isResolvable = function() {
          return _this.isComplete() && _this.isQualified();
        };
        this.isCreatable = function() {
          return _this.isComplete() && _this.implementation.keysRequired && !_this.implementation.keysSpecified;
        };
      } catch (exception) {
        throw "ONMjs.Address error: " + exception;
      }
    }

    Address.prototype.getHumanReadableString = function() {
      var humanReadableString, index, token, _i, _len, _ref;
      try {
        if ((this.implementation.humanReadableString != null) && this.implementation.humanReadableString) {
          return this.implementation.humanReadableString;
        }
        index = 0;
        humanReadableString = "";
        _ref = this.implementation.tokenVector;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          token = _ref[_i];
          if (!index) {
            humanReadableString += token.model.jsonTag;
          }
          if ((token.key != null) && token.key) {
            humanReadableString += "." + token.key;
          } else {
            if (token.idExtensionPoint > 0) {
              humanReadableString += ".-";
            }
          }
          if (token.idNamespace) {
            humanReadableString += "." + token.namespaceDescriptor.jsonTag;
          }
          index++;
        }
        this.implementation.humanReadableString = humanReadableString;
        return humanReadableString;
      } catch (exception) {
        throw "ONMjs.Address.getHumanReadableString failure: " + exception;
      }
    };

    Address.prototype.getHashString = function() {
      var hashSource, index, token, _i, _len, _ref;
      try {
        if ((this.implementation.hashString != null) && this.implementation.hashString) {
          return this.implementation.hashString;
        }
        index = 0;
        hashSource = "";
        _ref = this.implementation.tokenVector;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          token = _ref[_i];
          if (!index) {
            hashSource += "" + token.model.jsonTag;
          }
          if ((token.key != null) && token.key) {
            hashSource += "." + token.key;
          } else {
            if (token.idExtensionPoint > 0) {
              hashSource += ".-";
            }
          }
          if (token.idNamespace) {
            hashSource += "." + token.idNamespace;
          }
          index++;
        }
        this.implementation.hashString = encodeURIComponent(hashSource).replace(/[!'()]/g, escape).replace(/\*/g, "%2A");
        return this.implementation.hashString;
      } catch (exception) {
        throw "ONMjs.Address.getHashString failure: " + exception;
      }
    };

    Address.prototype.isRoot = function() {
      try {
        return this.implementation.getLastToken().idNamespace === 0;
      } catch (exception) {
        throw "CNMjs.Address.isRoot failure: " + exception;
      }
    };

    Address.prototype.isEqual = function(address_) {
      var index, result, tokenA, tokenB;
      try {
        if (!((address_ != null) && address_)) {
          throw "Missing address input parameter.";
        }
        if (this.implementation.tokenVector.length !== address_.implementation.tokenVector.length) {
          return false;
        }
        result = true;
        index = 0;
        while (index < this.implementation.tokenVector.length) {
          tokenA = this.implementation.tokenVector[index];
          tokenB = address_.implementation.tokenVector[index];
          if (!tokenA.isEqual(tokenB)) {
            result = false;
            break;
          }
          index++;
        }
        return result;
      } catch (exception) {
        throw "ONMjs.Address.isEqual failure: " + exception;
      }
    };

    Address.prototype.clone = function() {
      try {
        return new ONMjs.Address(this.model, this.implementation.tokenVector);
      } catch (exception) {
        throw "ONMjs.Address.clone failure: " + exception;
      }
    };

    Address.prototype.createParentAddress = function(generations_) {
      var descriptor, generations, newAddress, newTokenVector, token, tokenSourceIndex;
      try {
        if (!this.implementation.tokenVector.length) {
          throw "Invalid address contains no address tokens.";
        }
        generations = (generations_ != null) && generations_ || 1;
        tokenSourceIndex = this.implementation.tokenVector.length - 1;
        token = this.implementation.tokenVector[tokenSourceIndex--];
        if (token.namespaceDescriptor.id === 0) {
          return void 0;
        }
        while (generations) {
          descriptor = token.namespaceDescriptor;
          if (descriptor.id === 0) {
            break;
          }
          if (descriptor.namespaceType !== "component") {
            token = new ONMjs.implementation.AddressToken(token.model, token.idExtensionPoint, token.key, descriptor.parent.id);
          } else {
            token = (tokenSourceIndex !== -1) && this.implementation.tokenVector[tokenSourceIndex--] || (function() {
              throw "Internal error: exhausted token stack.";
            })();
          }
          generations--;
        }
        newTokenVector = ((tokenSourceIndex < 0) && []) || this.implementation.tokenVector.slice(0, tokenSourceIndex + 1);
        newAddress = new ONMjs.Address(token.model, newTokenVector);
        newAddress.implementation.pushToken(token);
        return newAddress;
      } catch (exception) {
        throw "ONMjs.Address.createParentAddress failure: " + exception;
      }
    };

    Address.prototype.createSubpathAddress = function(subpath_) {
      var baseDescriptor, baseDescriptorHeight, baseTokenVector, descriptor, newAddress, pathId, subpathDescriptor, subpathDescriptorHeight, subpathParentIdVector, token, _i, _len;
      try {
        if (!((subpath_ != null) && subpath_)) {
          throw "Missing subpath input parameter.";
        }
        subpathDescriptor = this.implementation.getModelDescriptorFromSubpath(subpath_);
        baseDescriptor = this.implementation.getDescriptor();
        if ((baseDescriptor.namespaceType === "extensionPoint") && (subpathDescriptor.namespaceType !== "component")) {
          throw "Invalid subpath string must begin with the name of the component contained by the base address' extension point.";
        }
        baseDescriptorHeight = baseDescriptor.parentPathIdVector.length;
        subpathDescriptorHeight = subpathDescriptor.parentPathIdVector.length;
        if ((subpathDescriptorHeight - baseDescriptorHeight) < 1) {
          throw "Internal error due to failed consistency check.";
        }
        subpathParentIdVector = subpathDescriptor.parentPathIdVector.slice(baseDescriptorHeight + 1, subpathDescriptorHeight);
        subpathParentIdVector.push(subpathDescriptor.id);
        baseTokenVector = this.implementation.tokenVector.slice(0, this.implementation.tokenVector.length - 1) || [];
        newAddress = new ONMjs.Address(this.model, baseTokenVector);
        token = this.implementation.getLastToken().clone();
        for (_i = 0, _len = subpathParentIdVector.length; _i < _len; _i++) {
          pathId = subpathParentIdVector[_i];
          descriptor = this.model.implementation.getNamespaceDescriptorFromPathId(pathId);
          switch (descriptor.namespaceType) {
            case "component":
              newAddress.implementation.pushToken(token);
              token = new ONMjs.implementation.AddressToken(token.model, token.namespaceDescriptor.id, void 0, pathId);
              break;
            default:
              token = new ONMjs.implementation.AddressToken(token.model, token.idExtensionPoint, token.key, pathId);
          }
        }
        newAddress.implementation.pushToken(token);
        return newAddress;
      } catch (exception) {
        throw "ONMjs.Address.createSubpathAddress failure: " + exception;
      }
    };

    Address.prototype.createComponentAddress = function() {
      var descriptor, newAddress;
      try {
        descriptor = this.implementation.getDescriptor();
        if (descriptor.isComponent) {
          return this.clone();
        }
        newAddress = this.implementation.createSubpathIdAddress(descriptor.idComponent);
        return newAddress;
      } catch (exception) {
        throw "ONMjs.Address.createComponentAddress failure: " + exception;
      }
    };

    Address.prototype.createSubcomponentAddress = function() {
      var descriptor, newToken;
      try {
        descriptor = this.implementation.getDescriptor();
        if (descriptor.namespaceType !== "extensionPoint") {
          throw "Unable to determine subcomponent to create because this address does not specifiy an extension point namespace.";
        }
        newToken = new ONMjs.implementation.AddressToken(this.model, descriptor.id, void 0, descriptor.archetypePathId);
        return this.clone().implementation.pushToken(newToken);
      } catch (exception) {
        throw "ONMjs.Address.createSubcomponentAddress failure: " + exception;
      }
    };

    Address.prototype.getModel = function() {
      try {
        return this.implementation.getDescriptor().namespaceModelDeclaration;
      } catch (exception) {
        throw "ONMjs.Address.getModel failure: " + exception;
      }
    };

    Address.prototype.getPropertiesModel = function() {
      try {
        return this.implementation.getDescriptor().namespaceModelPropertiesDeclaration;
      } catch (exception) {
        throw "ONMjs.Address.getPropertiesModel failure: " + exception;
      }
    };

    Address.prototype.visitParentAddressesAscending = function(callback_) {
      var address, _i, _len, _ref,
        _this = this;
      try {
        if (!((callback_ != null) && callback_)) {
          return false;
        }
        if (!((this.parentAddressesAscending != null) && this.parentAddressesAscending)) {
          this.parentAddressesAscending = [];
          this.visitParentAddressesDescending(function(address__) {
            _this.parentAddressesAscending.push(address__);
            return true;
          });
          this.parentAddressesAscending.reverse();
        }
        if (!this.parentAddressesAscending.length) {
          return false;
        }
        _ref = this.parentAddressesAscending;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          address = _ref[_i];
          try {
            callback_(address);
          } catch (exception) {
            throw "Failure occurred inside your registered callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitParentAddressesAscending failure: " + exception;
      }
    };

    Address.prototype.visitParentAddressesDescending = function(callback_) {
      var address, parent, _i, _len, _ref;
      try {
        if (!((callback_ != null) && callback_)) {
          return false;
        }
        if (!((this.parentAddressesDesending != null) && this.parentAddressesDesceding)) {
          this.parentAddressesDescending = [];
          parent = this.createParentAddress();
          while (parent) {
            this.parentAddressesDescending.push(parent);
            parent = parent.createParentAddress();
          }
        }
        if (!this.parentAddressesDescending.length) {
          return false;
        }
        _ref = this.parentAddressesDescending;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          address = _ref[_i];
          try {
            callback_(address);
          } catch (exception) {
            throw "Failure occurred inside your registered callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitParentAddressesDescending failure: " + exception;
      }
    };

    Address.prototype.visitSubaddressesAscending = function(callback_) {
      var address, namespaceDescriptor, subnamespaceAddress, subnamespacePathId, _i, _j, _len, _len1, _ref, _ref1;
      try {
        if (!((callback_ != null) && callback_)) {
          return false;
        }
        if (!((this.subnamespaceAddressesAscending != null) && this.subnamespaceAddressesAscending)) {
          this.subnamespaceAddressesAscending = [];
          namespaceDescriptor = this.implementation.getDescriptor();
          _ref = namespaceDescriptor.componentNamespaceIds;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            subnamespacePathId = _ref[_i];
            subnamespaceAddress = this.implementation.createSubpathIdAddress(subnamespacePathId);
            this.subnamespaceAddressesAscending.push(subnamespaceAddress);
          }
        }
        _ref1 = this.subnamespaceAddressesAscending;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          address = _ref1[_j];
          try {
            callback_(address);
          } catch (exception) {
            throw "Failure occurred inside your registered callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitSubaddressesAscending failure: " + exception;
      }
    };

    Address.prototype.visitSubaddressesDescending = function(callback_) {
      var address, _i, _len, _ref,
        _this = this;
      try {
        if (!(callback_ && callback_)) {
          return false;
        }
        if (!((this.subnamespaceAddressesDescending != null) && this.subnamespaceAddressesDescending)) {
          this.subnamespaceAddressesDescending = [];
          this.visitSubaddressesAscending(function(address__) {
            return _this.subnamespaceAddressesDescending.push(address__);
          });
          this.subnamespaceAddressesDescending.reverse();
        }
        _ref = this.subnamespaceAddressesDescending;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          address = _ref[_i];
          try {
            callback_(address);
          } catch (exception) {
            throw "Failure occurred inside your registered callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitSubaddressesAscending failure: " + exception;
      }
    };

    Address.prototype.visitChildAddresses = function(callback_) {
      var childAddress, childDescriptor, namespaceDescriptor, _i, _len, _ref;
      try {
        if (!((callback_ != null) && callback_)) {
          return false;
        }
        namespaceDescriptor = this.implementation.getDescriptor();
        _ref = namespaceDescriptor.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          childDescriptor = _ref[_i];
          childAddress = this.implementation.createSubpathIdAddress(childDescriptor.id);
          try {
            callback_(childAddress);
          } catch (exception) {
            throw "Failure occurred inside your registered callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitChildAddresses failure: " + exception;
      }
    };

    Address.prototype.visitExtensionPointAddresses = function(callback_) {
      var address, extensionPointAddress, extensionPointDescriptor, namespaceDescriptor, path, _i, _len, _ref, _ref1;
      try {
        if (!((callback_ != null) && callback_)) {
          return false;
        }
        if (!((this.extensionPointAddresses != null) && this.extensionPointAddresses)) {
          this.extensionPointAddresses = [];
          namespaceDescriptor = this.implementation.getDescriptor();
          _ref = namespaceDescriptor.extensionPoints;
          for (path in _ref) {
            extensionPointDescriptor = _ref[path];
            extensionPointAddress = this.implementation.createSubpathIdAddress(extensionPointDescriptor.id);
            this.extensionPointAddresses.push(extensionPointAddress);
          }
        }
        _ref1 = this.extensionPointAddresses;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          address = _ref1[_i];
          callback_(address);
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Address.visitExtensionPointAddresses failure: " + exception;
      }
    };

    return Address;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation = (ONMjs.implementation != null) && ONMjs.implementation || (ONMjs.implementation = {});

  ONMjs.implementation.binding = (ONMjs.implementation.binding != null) && ONMjs.implementation.binding || (ONMjs.implementation.binding = {});

  ONMjs.implementation.binding.InitializeNamespaceProperties = function(data_, descriptor_) {
    var functions, memberName, _ref, _ref1;
    try {
      if (!((data_ != null) && data_)) {
        throw "Missing data reference input parameter.";
      }
      if (!((descriptor_ != null) && descriptor_)) {
        throw "Missing descriptor input parameter.";
      }
      if ((descriptor_.userImmutable != null) && descriptor_.userImmutable) {
        _ref = descriptor_.userImmutable;
        for (memberName in _ref) {
          functions = _ref[memberName];
          if ((functions.fnCreate != null) && functions.fnCreate) {
            data_[memberName] = functions.fnCreate();
          } else {
            data_[memberName] = functions.defaultValue;
          }
        }
      }
      if ((descriptor_.userMutable != null) && descriptor_.userMutable) {
        _ref1 = descriptor_.userMutable;
        for (memberName in _ref1) {
          functions = _ref1[memberName];
          if ((functions.fnCreate != null) && functions.fnCreate) {
            data_[memberName] = functions.fnCreate();
          } else {
            data_[memberName] = functions.defaultValue;
          }
        }
      }
      return true;
    } catch (exception) {
      throw "ONMjs.implementation.binding.InitializeNamespaceProperties failure " + exception + ".";
    }
  };

  ONMjs.implementation.binding.VerifyNamespaceProperties = function(data_, descriptor_) {
    var functions, memberName, memberReference, _ref, _ref1;
    try {
      if (!((data_ != null) && data_)) {
        throw "Missing data reference input parameter.";
      }
      if (!((descriptor_ != null) && descriptor_)) {
        throw "Missing descriptor input parameter.";
      }
      if ((descriptor_.userImmutable != null) && descriptor_.userImmutable) {
        _ref = descriptor_.userImmutable;
        for (memberName in _ref) {
          functions = _ref[memberName];
          memberReference = data_[memberName];
          if (!(memberReference != null)) {
            throw "Expected immutable member '" + memberName + "' not found.";
          }
        }
      }
      if ((descriptor_.userMutable != null) && descriptor_.userMutable) {
        _ref1 = descriptor_.userMutable;
        for (memberName in _ref1) {
          functions = _ref1[memberName];
          memberReference = data_[memberName];
          if (!(memberReference != null)) {
            throw "Expected mutable member '" + memberName + "' not found.";
          }
        }
      }
      return true;
    } catch (exception) {
      throw "ONMjs.implementation.binding.VerifyNamespaceMembers failure " + exception + ".";
    }
  };

  ONMjs.implementation.binding.InitializeComponentNamespaces = function(store_, data_, descriptor_, extensionPointId_, key_) {
    var childDescriptor, resolveResults, _i, _len, _ref;
    try {
      if (!((data_ != null) && data_)) {
        throw "Missing data reference input parameter.";
      }
      if (!((descriptor_ != null) && descriptor_)) {
        throw "Missing descriptor input parameter.";
      }
      if (!((extensionPointId_ != null) && extensionPointId_)) {
        throw "Missing extension point ID input parameter.";
      }
      _ref = descriptor_.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        childDescriptor = _ref[_i];
        if (childDescriptor.namespaceType !== "component") {
          resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor({}, store_, data_, childDescriptor, key_, "new");
          ONMjs.implementation.binding.InitializeComponentNamespaces(store_, resolveResults.dataReference, childDescriptor, extensionPointId_, key_);
        }
      }
      return true;
    } catch (exception) {
      throw "ONMjs.implementation.binding.InitializeComponentNamespaces failure: " + exception + ".";
    }
  };

  ONMjs.implementation.binding.VerifyComponentNamespaces = function(store_, data_, descriptor_, extensionPointId_) {
    try {
      if (!((data_ != null) && data_)) {
        throw "Missing data reference input parameter.";
      }
      if (!((descriptor_ != null) && descriptor_)) {
        throw "Missing descriptor input parameter.";
      }
      return true;
    } catch (exception) {
      throw "ONMjs.implementation.binding.VerifyComponentNamespaces failure: " + exception + ".";
    }
  };

  ONMjs.implementation.binding.ResolveNamespaceDescriptor = function(resolveActions_, store_, data_, descriptor_, key_, mode_) {
    var jsonTag, newData, resolveResults;
    try {
      if (!((resolveActions_ != null) && resolveActions_)) {
        throw "Internal error: missing resolve actions structure input parameter.";
      }
      if (!((data_ != null) && data_)) {
        throw "Internal error: missing parent data reference input parameter.";
      }
      if (!((descriptor_ != null) && descriptor_)) {
        throw "Internal error: missing object model descriptor input parameter.";
      }
      if (!((mode_ != null) && mode_)) {
        throw "Internal error: missing mode input parameter.";
      }
      jsonTag = ((descriptor_.namespaceType !== "component") && descriptor_.jsonTag) || key_ || void 0;
      resolveResults = {
        jsonTag: jsonTag,
        dataReference: (jsonTag != null) && jsonTag && data_[jsonTag] || void 0,
        dataParentReference: data_,
        key: key_,
        mode: mode_,
        descriptor: descriptor_,
        store: store_,
        created: false
      };
      switch (mode_) {
        case "bypass":
          if (!((resolveResults.dataReference != null) && resolveResults.dataReference)) {
            throw "Internal error: Unable to resolve " + descriptor_.namespaceType + " namespace descriptor in bypass mode.";
          }
          break;
        case "new":
          if ((resolveResults.dataReference != null) && resolveResults.dataReference) {
            break;
          }
          newData = {};
          ONMjs.implementation.binding.InitializeNamespaceProperties(newData, descriptor_.namespaceModelPropertiesDeclaration);
          if (descriptor_.namespaceType === "component") {
            if (!((resolveActions_.setUniqueKey != null) && resolveActions_.setUniqueKey)) {
              throw "You must define semanticBindings.setUniqueKey function in your data model declaration.";
            }
            resolveActions_.setUniqueKey(newData);
            if (!((resolveActions_.getUniqueKey != null) && resolveActions_.getUniqueKey)) {
              throw "You must define semanticBindings.getUniqueKey function in your data model declaration.";
            }
            resolveResults.key = resolveResults.jsonTag = resolveActions_.getUniqueKey(newData);
            if (!((resolveResults.key != null) && resolveResults.key)) {
              throw "Your data model's semanticBindings.getUniqueKey function returned an invalid key. Key cannot be zero or zero-length.";
            }
          }
          resolveResults.dataReference = resolveResults.dataParentReference[resolveResults.jsonTag] = newData;
          resolveResults.created = true;
          break;
        case "strict":
          if (!((resolveResult.dataReference != null) && resolveResult.dataReference)) {
            throw "Internal error: Unable to resolve  " + descriptor_.namespaceType + " namespace descriptor in strict mode.";
          }
          ONMjs.implementation.binding.VerifyNamespaceProperties(result.dataReference, descriptor_.namespaceModelPropertiesDeclaration);
          break;
        default:
          throw "Unrecognized mode parameter value.";
      }
      return resolveResults;
    } catch (exception) {
      throw "ONMjs.implementation.binding.ResolveNamespaceDescriptor failure: " + exception;
    }
  };

  ONMjs.implementation.AddressTokenBinder = (function() {

    function AddressTokenBinder(store_, parentDataReference_, token_, mode_) {
      var descriptor, extensionPointId, generations, getUniqueKeyFunction, model, parentPathIds, pathId, resolveActions, resolveResults, semanticBindings, setUniqueKeyFunction, targetComponentDescriptor, targetNamespaceDescriptor, _i, _len;
      try {
        this.store = (store_ != null) && store_ || (function() {
          throw "Missing object store input parameter.";
        })();
        model = store_.model;
        this.parentDataReference = (parentDataReference_ != null) && parentDataReference_ || (function() {
          throw "Missing parent data reference input parameter.";
        })();
        if (!((token_ != null) && token_)) {
          throw "Missing object model address token object input parameter.";
        }
        if (!((mode_ != null) && mode_)) {
          throw "Missing mode input parameter.";
        }
        this.dataReference = void 0;
        this.resolvedToken = token_.clone();
        targetNamespaceDescriptor = token_.namespaceDescriptor;
        targetComponentDescriptor = token_.componentDescriptor;
        semanticBindings = model.getSemanticBindings();
        setUniqueKeyFunction = (semanticBindings != null) && semanticBindings && (semanticBindings.setUniqueKey != null) && semanticBindings.setUniqueKey || void 0;
        getUniqueKeyFunction = (semanticBindings != null) && semanticBindings && (semanticBindings.getUniqueKey != null) && semanticBindings.getUniqueKey || void 0;
        resolveActions = {
          setUniqueKey: setUniqueKeyFunction,
          getUniqueKey: getUniqueKeyFunction
        };
        resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, this.parentDataReference, token_.componentDescriptor, token_.key, mode_);
        this.dataReference = resolveResults.dataReference;
        if (resolveResults.created) {
          this.resolvedToken.key = resolveResults.key;
        }
        extensionPointId = (token_.extensionPointDescriptor != null) && token_.extensionPointDescriptor && token_.extensionPointDescriptor.id || -1;
        if (mode_ === "new" && resolveResults.created) {
          ONMjs.implementation.binding.InitializeComponentNamespaces(store_, this.dataReference, targetComponentDescriptor, extensionPointId, this.resolvedToken.key);
        }
        if (mode_ === "strict") {
          ONMjs.implementation.binding.VerifyComponentNamespaces(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId);
        }
        if (targetNamespaceDescriptor.isComponent) {
          return;
        }
        generations = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1;
        parentPathIds = generations && targetNamespaceDescriptor.parentPathIdVector.slice(-generations) || [];
        for (_i = 0, _len = parentPathIds.length; _i < _len; _i++) {
          pathId = parentPathIds[_i];
          descriptor = model.implementation.getNamespaceDescriptorFromPathId(pathId);
          resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, resolveResults.dataReference, descriptor, resolveResults.key, mode_);
        }
        resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, resolveResults.dataReference, targetNamespaceDescriptor, resolveResults.key, mode_);
        this.dataReference = resolveResults.dataReference;
        return;
      } catch (exception) {
        throw "ONMjs.implementation.AddressTokenBinder failure: " + exception;
      }
    }

    return AddressTokenBinder;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation = (ONMjs.implementation != null) && ONMjs.implementation || (ONMjs.implementation = {});

  ONMjs.implementation.AddressToken = (function() {

    function AddressToken(model_, idExtensionPoint_, key_, idNamespace_) {
      this.isRoot = __bind(this.isRoot, this);

      this.isQualified = __bind(this.isQualified, this);

      this.isEqual = __bind(this.isEqual, this);

      this.clone = __bind(this.clone, this);
      try {
        this.model = (model_ != null) && model_ || (function() {
          throw "Missing object model input parameter.";
        })();
        if (!(idNamespace_ != null)) {
          throw "Missing target namespace ID input parameter.";
        }
        this.idNamespace = idNamespace_;
        this.namespaceDescriptor = model_.implementation.getNamespaceDescriptorFromPathId(idNamespace_);
        this.idComponent = this.namespaceDescriptor.idComponent;
        this.componentDescriptor = model_.implementation.getNamespaceDescriptorFromPathId(this.idComponent);
        this.key = (this.componentDescriptor.id > 0) && (key_ != null) && key_ || void 0;
        this.keyRequired = false;
        this.idExtensionPoint = (idExtensionPoint_ != null) && idExtensionPoint_ || -1;
        this.extensionPointDescriptor = void 0;
        if (this.componentDescriptor.id === 0) {
          return;
        }
        this.keyRequired = true;
        if (this.idExtensionPoint === -1 && !this.componentDescriptor.extensionPointReferenceIds.length) {
          this.idExtensionPoint = this.componentDescriptor.parent.id;
        }
        if (!this.idExtensionPoint) {
          throw "You must specify the ID of the parent extension point when creating a token addressing a '" + this.componentDescriptor.path + "' component namespace.";
        }
        this.extensionPointDescriptor = this.model.implementation.getNamespaceDescriptorFromPathId(this.idExtensionPoint);
        if (!((this.extensionPointDescriptor != null) && this.extensionPointDescriptor)) {
          throw "Internal error: unable to resolve extension point object model descriptor in request.";
        }
        if (this.extensionPointDescriptor.namespaceType !== "extensionPoint") {
          throw "Invalid selector key object specifies an invalid parent extension point ID. Not an extension point.";
        }
        if (this.extensionPointDescriptor.archetypePathId !== this.componentDescriptor.id) {
          throw "Invalid selector key object specifies unsupported extension point / component ID pair.";
        }
        return;
      } catch (exception) {
        throw "ONMjs.implementation.AddressToken failure: " + exception;
      }
    }

    AddressToken.prototype.clone = function() {
      return new ONMjs.implementation.AddressToken(this.model, (this.extensionPointDescriptor != null) && this.extensionPointDescriptor && this.extensionPointDescriptor.id || -1, this.key, this.namespaceDescriptor.id);
    };

    AddressToken.prototype.isEqual = function(token_) {
      var result;
      try {
        if (!((token_ != null) && token_)) {
          throw "Missing token input parameter.";
        }
        result = (this.idNamespace === token_.idNamespace) && (this.key === token_.key) && (this.idExtensionPoint === token_.idExtensionPoint);
        return result;
      } catch (exception) {
        throw "ONMjs.AddressToken.isEqual failure: " + exception;
      }
    };

    AddressToken.prototype.isQualified = function() {
      return !this.keyRequired || ((this.key != null) && this.key) || false;
    };

    AddressToken.prototype.isRoot = function() {
      return !this.componentId;
    };

    return AddressToken;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation = (ONMjs.implementation != null) && ONMjs.implementation || (ONMjs.implementation = {});

  ONMjs.implementation.NamespaceDetails = (function() {

    function NamespaceDetails(namespace_, store_, address_, mode_) {
      var _this = this;
      try {
        this.dataReference = (store_.implementation.dataReference != null) && store_.implementation.dataReference || (function() {
          throw "Cannot resolve object store's root data reference.";
        })();
        this.resolvedTokenArray = [];
        this.getResolvedToken = function() {
          return _this.resolvedTokenArray.length && _this.resolvedTokenArray[_this.resolvedTokenArray.length - 1] || void 0;
        };
        this.resolvedAddress = void 0;
      } catch (exception) {
        throw "ONMjs.implementation.NamespaceDetails failure: " + exception;
      }
    }

    return NamespaceDetails;

  })();

  ONMjs.Namespace = (function() {

    function Namespace(store_, address_, mode_) {
      this.visitExtensionPointSubcomponents = __bind(this.visitExtensionPointSubcomponents, this);

      this.update = __bind(this.update, this);

      this.toJSON = __bind(this.toJSON, this);

      this.data = __bind(this.data, this);

      this.getResolvedLabel = __bind(this.getResolvedLabel, this);

      this.getResolvedAddress = __bind(this.getResolvedAddress, this);

      var address, addressToken, componentAddress, extensionPointAddress, extensionPointNamespace, mode, objectModel, objectModelNameKeys, objectModelNameStore, resolvedAddress, tokenBinder, _i, _len, _ref;
      try {
        if (!((store_ != null) && store_)) {
          throw "Missing object store input parameter.";
        }
        this.store = store_;
        this.implementation = new ONMjs.implementation.NamespaceDetails(this, store_, address_, mode_);
        address = void 0;
        if (!((address_ != null) && address_ && address_.implementation.tokenVector.length)) {
          objectModel = store_.model;
          address = new ONMjs.Address(objectModel, [new ONMjs.implementation.AddressToken(objectModel, void 0, void 0, 0)]);
        } else {
          address = address_;
        }
        objectModelNameStore = store_.model.jsonTag;
        objectModelNameKeys = address.model.jsonTag;
        if (objectModelNameStore !== objectModelNameKeys) {
          throw "You cannot access a '" + objectModelNameStore + "' store namespace with a '" + objectModelNameKeys + "' object model address!";
        }
        if (!address.isComplete()) {
          throw "Specified address is invalid because the first address token does not specify the object store's root component.";
        }
        mode = (mode_ != null) && mode_ || "bypass";
        if ((mode !== "new") && !address.isResolvable()) {
          throw "'" + mode + "' mode error: Unresolvable address '" + (address.getHumanReadableString()) + "' invalid for this operation.";
        }
        _ref = address.implementation.tokenVector;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          addressToken = _ref[_i];
          tokenBinder = new ONMjs.implementation.AddressTokenBinder(store_, this.implementation.dataReference, addressToken, mode);
          this.implementation.resolvedTokenArray.push(tokenBinder.resolvedToken);
          this.implementation.dataReference = tokenBinder.dataReference;
          if (mode === "new") {
            if (addressToken.idComponent) {
              if (!((addressToken.key != null) && addressToken.key)) {
                resolvedAddress = new ONMjs.Address(this.store.model, this.implementation.resolvedTokenArray);
                componentAddress = resolvedAddress.createComponentAddress();
                this.store.implementation.reifier.reifyStoreComponent(componentAddress);
                extensionPointAddress = componentAddress.createParentAddress();
                extensionPointNamespace = this.store.openNamespace(extensionPointAddress);
                extensionPointNamespace.update();
              }
            }
          }
          true;
        }
      } catch (exception) {
        throw "ONMjs.Namespace failure: " + exception;
      }
    }

    Namespace.prototype.getResolvedAddress = function() {
      try {
        if ((this.implementation.resolvedAddress != null) && this.implementation.resolvedAddress) {
          return this.implementation.resolvedAddress;
        }
        this.implementation.resolvedAddress = new ONMjs.Address(this.store.model, this.implementation.resolvedTokenArray);
        return this.implementation.resolvedAddress;
      } catch (exception) {
        throw "ONMjs.Namespace.address failure: " + exception;
      }
    };

    Namespace.prototype.getResolvedLabel = function() {
      var getLabelBinding, resolvedDescriptor, resolvedLabel, semanticBindings;
      try {
        resolvedDescriptor = this.implementation.getResolvedToken().namespaceDescriptor;
        semanticBindings = this.store.model.getSemanticBindings();
        getLabelBinding = (semanticBindings != null) && semanticBindings && (semanticBindings.getLabel != null) && semanticBindings.getLabel || void 0;
        resolvedLabel = void 0;
        if ((getLabelBinding != null) && getLabelBinding) {
          resolvedLabel = getLabelBinding(this.data(), this.getResolvedAddress());
        } else {
          resolvedLabel = resolvedDescriptor.label;
        }
        return resolvedLabel;
      } catch (exception) {
        throw "ONMjs.Namespace.getResolvedLabel failure: " + exception;
      }
    };

    Namespace.prototype.data = function() {
      return this.implementation.dataReference;
    };

    Namespace.prototype.toJSON = function(replacer_, space_) {
      var namespaceDescriptor, resultJSON, resultObject, space;
      try {
        namespaceDescriptor = this.implementation.getResolvedToken().namespaceDescriptor;
        resultObject = {};
        resultObject[namespaceDescriptor.jsonTag] = this.data();
        space = (space_ != null) && space_ || 0;
        resultJSON = JSON.stringify(resultObject, replacer_, space);
        if (!((resultJSON != null) && resultJSON)) {
          throw "Cannot serialize Javascript object to JSON!";
        }
        return resultJSON;
      } catch (exception) {
        throw "ONMjs.Namespace.toJSON failure: " + exception;
      }
    };

    Namespace.prototype.update = function() {
      var address, containingComponentNotified, count, descriptor, semanticBindings, updateAction, _results,
        _this = this;
      try {
        address = this.getResolvedAddress();
        semanticBindings = this.store.model.getSemanticBindings();
        updateAction = (semanticBindings != null) && semanticBindings && (semanticBindings.update != null) && semanticBindings.update || void 0;
        if ((updateAction != null) && updateAction) {
          updateAction(this.data());
          address.visitParentAddressesDescending(function(address__) {
            var dataReference;
            dataReference = _this.store.openNamespace(address__).data();
            return updateAction(dataReference);
          });
        }
        count = 0;
        containingComponentNotified = false;
        _results = [];
        while ((address != null) && address) {
          descriptor = address.implementation.getDescriptor();
          if (count === 0) {
            this.store.implementation.reifier.dispatchCallback(address, "onNamespaceUpdated", void 0);
          } else {
            this.store.implementation.reifier.dispatchCallback(address, "onSubnamespaceUpdated", void 0);
          }
          if (descriptor.namespaceType === "component" || descriptor.namespaceType === "root") {
            if (!containingComponentNotified) {
              this.store.implementation.reifier.dispatchCallback(address, "onComponentUpdated", void 0);
              containingComponentNotified = true;
            } else {
              this.store.implementation.reifier.dispatchCallback(address, "onSubcomponentUpdated", void 0);
            }
          }
          address = address.createParentAddress();
          _results.push(count++);
        }
        return _results;
      } catch (exception) {
        throw "ONMjs.Namespace.update failure: " + exception;
      }
    };

    Namespace.prototype.visitExtensionPointSubcomponents = function(callback_) {
      var address, key, object, resolvedToken, token, _ref;
      try {
        resolvedToken = this.implementation.getResolvedToken();
        if (!((resolvedToken != null) && resolvedToken)) {
          throw "Internal error: unable to resolve token.";
        }
        if (resolvedToken.namespaceDescriptor.namespaceType !== "extensionPoint") {
          throw "You may only visit the subcomponents of an extension point namespace.";
        }
        _ref = this.data();
        for (key in _ref) {
          object = _ref[key];
          address = this.getResolvedAddress().clone();
          token = new ONMjs.implementation.AddressToken(this.store.model, resolvedToken.idNamespace, key, resolvedToken.namespaceDescriptor.archetypePathId);
          address.implementation.pushToken(token);
          try {
            callback_(address);
          } catch (exception) {
            throw "Failure occurred inside your callback function implementation: " + exception;
          }
        }
        return true;
      } catch (exception) {
        throw "ONMjs.Namepsace.visitExtensionPointSubcomponents failure: " + exception;
      }
    };

    return Namespace;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  Encapsule.code.lib.onm.implementation = (Encapsule.code.lib.onm.implementation != null) && Encapsule.code.lib.onm.implementation || (this.Encapsule.code.lib.onm.implementation = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation.StoreReifier = (function() {

    function StoreReifier(objectStore_) {
      var _this = this;
      try {
        this.store = objectStore_;
        this.dispatchCallback = function(address_, callbackName_, observerId_) {
          var callbackFunction, callbackInterface, exceptionMessage, observerId, _ref, _results;
          try {
            if ((observerId_ != null) && observerId_) {
              callbackInterface = _this.store.implementation.observers[observerId_];
              if (!((callbackInterface != null) && callbackInterface)) {
                throw "Internal error: unable to resolve observer ID to obtain callback interface.";
              }
              callbackFunction = callbackInterface[callbackName_];
              if ((callbackFunction != null) && callbackFunction) {
                try {
                  return callbackFunction(_this.store, observerId_, address_);
                } catch (exception) {
                  throw "An error occurred in the '" + callbackName_ + "' method of your observer interface: " + exception;
                }
              }
            } else {
              _ref = _this.store.implementation.observers;
              _results = [];
              for (observerId in _ref) {
                callbackInterface = _ref[observerId];
                callbackFunction = callbackInterface[callbackName_];
                if ((callbackFunction != null) && callbackFunction) {
                  try {
                    _results.push(callbackFunction(_this.store, observerId, address_));
                  } catch (exception) {
                    throw "An error occurred in the '" + callbackName_ + "' method of your observer interface: " + exception;
                  }
                } else {
                  _results.push(void 0);
                }
              }
              return _results;
            }
          } catch (exception) {
            exceptionMessage = "ONMjs.implementation.StoreRefier.dispatchCallback failure while processing " + ("address='" + (address_.getHumanReadableString()) + "', callback='" + callbackName_ + "', observer='" + ((observerId_ != null) && observerId_ || "[broadcast all]") + "': " + exception);
            throw exceptionMessage;
          }
        };
        this.reifyStoreComponent = function(address_, observerId_) {
          var dispatchCallback;
          try {
            if (!((address_ != null) && address_)) {
              throw "Internal error: Missing address input parameter.";
            }
            if (!Encapsule.code.lib.js.dictionaryLength(_this.store.implementation.observers)) {
              return;
            }
            dispatchCallback = _this.dispatchCallback;
            dispatchCallback(address_, "onComponentCreated", observerId_);
            address_.visitSubaddressesAscending(function(addressSubnamespace_) {
              return dispatchCallback(addressSubnamespace_, "onNamespaceCreated", observerId_);
            });
            return true;
          } catch (exception) {
            throw "ONMjs.implementation.StoreReifier failure: " + exception;
          }
        };
        this.unreifyStoreComponent = function(address_, observerId_) {
          var dispatchCallback;
          try {
            if (!((address_ != null) && address_)) {
              throw "Internal error: Missing address input parameter.";
            }
            if (!Encapsule.code.lib.js.dictionaryLength(_this.store.implementation.observers)) {
              return;
            }
            dispatchCallback = _this.dispatchCallback;
            address_.visitSubaddressesDescending(function(addressSubnamespace_) {
              return dispatchCallback(addressSubnamespace_, "onNamespaceRemoved", observerId_);
            });
            dispatchCallback(address_, "onComponentRemoved", observerId_);
            return true;
          } catch (exception) {
            throw "ONMjs.implementation.StoreReifier failure: " + exception;
          }
        };
        this.reifyStoreExtensions = function(address_, observerId_, undoFlag_) {
          var dispatchCallback;
          try {
            if (!((address_ != null) && address_)) {
              throw "Internal error: Missing address input parameter.";
            }
            if (!Encapsule.code.lib.js.dictionaryLength(_this.store.implementation.observers)) {
              return;
            }
            dispatchCallback = _this.dispatchCallback;
            return address_.visitExtensionPointAddresses(function(addressExtensionPoint_) {
              var extensionPointNamespace;
              extensionPointNamespace = new ONMjs.Namespace(_this.store, addressExtensionPoint_);
              extensionPointNamespace.visitExtensionPointSubcomponents(function(addressSubcomponent_) {
                if (!undoFlag_) {
                  _this.reifyStoreComponent(addressSubcomponent_, observerId_);
                  _this.reifyStoreExtensions(addressSubcomponent_, observerId_, false);
                } else {
                  _this.reifyStoreExtensions(addressSubcomponent_, observerId_, true);
                  _this.unreifyStoreComponent(addressSubcomponent_, observerId_);
                }
                return true;
              });
              return true;
            });
          } catch (exception) {
            throw "ONMjs.implementation.StoreReifier failure: " + exception;
          }
        };
      } catch (exception) {
        throw "ONMjs.implementation.StoreReifier constructor failed: " + exception;
      }
    }

    return StoreReifier;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  Encapsule.code.lib.onm.implementation = (Encapsule.code.lib.onm.implementation != null) && Encapsule.code.lib.onm.implementation || (this.Encapsule.code.lib.onm.implementation = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.implementation.StoreDetails = (function() {

    function StoreDetails(store_, model_, initialStateJSON_) {
      try {
        this.store = store_;
        this.model = model_;
        this.reifier = new ONMjs.implementation.StoreReifier(this.store);
        this.dataReference = {};
        this.objectStoreSource = void 0;
        this.observers = {};
        this.observersState = {};
      } catch (exception) {
        throw "ONMjs.implementation.StoreDetails failure: " + exception;
      }
    }

    return StoreDetails;

  })();

  ONMjs.Store = (function() {

    function Store(model_, initialStateJSON_) {
      var token, tokenBinder,
        _this = this;
      try {
        this.implementation = new ONMjs.implementation.StoreDetails(this, model_, initialStateJSON_);
        if (!((model_ != null) && model_)) {
          throw "Missing object model parameter!";
        }
        this.model = model_;
        this.jsonTag = model_.jsonTag;
        this.label = model_.label;
        this.description = model_.description;
        if ((initialStateJSON_ != null) && initialStateJSON_) {
          this.implementation.dataReference = JSON.parse(initialStateJSON_);
          if (!((this.implementation.dataReference != null) && this.implementation.dataReference)) {
            throw "Cannot deserialize specified JSON string!";
          }
          this.implementation.objectStoreSource = "json";
        } else {
          this.implementation.dataReference = {};
          this.implementation.objectStoreSource = "new";
          token = new ONMjs.implementation.AddressToken(model_, void 0, void 0, 0);
          tokenBinder = new ONMjs.implementation.AddressTokenBinder(this, this.implementation.dataReference, token, "new");
        }
        this.validateAddressModel = function(address_) {
          try {
            if (!((address_ != null) && address_)) {
              throw "Missing address input parameter.";
            }
            return _this.model.isEqual(address_.model);
          } catch (exception) {
            throw "ONMjs.Store.verifyAddress failure: " + exception;
          }
        };
        this.createComponent = function(address_) {
          var componentNamespace, descriptor;
          try {
            if (!((address_ != null) && address_)) {
              throw "Missing object model namespace selector input parameter.";
            }
            if (!_this.validateAddressModel(address_)) {
              throw "The specified address cannot be used to reference this store because it's not bound to the same model as this store.";
            }
            if (address_.isQualified()) {
              throw "The specified address is qualified and may only be used to specify existing objects in the store.";
            }
            descriptor = address_.implementation.getDescriptor();
            if (!descriptor.isComponent) {
              throw "The specified address does not specify the root of a component.";
            }
            if (descriptor.namespaceType === "root") {
              throw "The specified address refers to the root namespace of the store which is created automatically.";
            }
            componentNamespace = new ONMjs.Namespace(_this, address_, "new");
            return componentNamespace;
          } catch (exception) {
            throw "ONMjs.Store.createComponent failure: " + exception;
          }
        };
        this.removeComponent = function(address_) {
          var componentDictionary, componentKey, componentNamespace, descriptor, extensionPointAddress, extensionPointNamespace;
          try {
            if (!((address_ != null) && address_)) {
              throw "Missing address input parameter!";
            }
            if (!_this.validateAddressModel(address_)) {
              throw "The specified address cannot be used to reference this store because it's not bound to the same model as this store.";
            }
            if (!address_.isQualified()) {
              throw "You cannot use an unqualified address to remove a component.";
            }
            descriptor = address_.implementation.getDescriptor();
            if (!descriptor.isComponent) {
              throw "The specified address does not specify the root of a component.";
            }
            if (descriptor.namespace === "root") {
              throw "The specified address refers to the root namespace of the store which cannot be removed.";
            }
            _this.implementation.reifier.reifyStoreExtensions(address_, void 0, true);
            _this.implementation.reifier.unreifyStoreComponent(address_);
            componentNamespace = _this.openNamespace(address_);
            extensionPointAddress = address_.createParentAddress();
            extensionPointNamespace = _this.openNamespace(extensionPointAddress);
            componentDictionary = extensionPointNamespace.data();
            componentKey = address_.implementation.getLastToken().key;
            delete componentDictionary[componentKey];
            extensionPointNamespace.update();
            return componentNamespace;
          } catch (exception) {
            throw "ONMjs.Store.removeComponent failure: " + exception;
          }
        };
        this.openNamespace = function(address_) {
          var namespace;
          try {
            if (!(address_ && address_)) {
              throw "Missing address input parameter.";
            }
            if (!_this.validateAddressModel(address_)) {
              throw "The specified address cannot be used to reference this store because it's not bound to the same model as this store.";
            }
            namespace = new ONMjs.Namespace(_this, address_, "bypass");
            return namespace;
          } catch (exception) {
            throw "ONMjs.Store.openNamespace failure: " + exception;
          }
        };
        this.toJSON = function(replacer_, space_) {
          var resultJSON, rootNamespace;
          try {
            rootNamespace = _this.openNamespace(_this.model.createRootAddress());
            resultJSON = rootNamespace.toJSON(replacer_, space_);
            return resultJSON;
          } catch (exception) {
            throw "ONMjs.Store.toJSON fail on object store " + _this.jsonTag + " : " + exception;
          }
        };
        this.registerObserver = function(observerCallbackInterface_, observingEntityReference_) {
          var observerIdCode, rootAddress;
          try {
            if (!((observerCallbackInterface_ != null) && observerCallbackInterface_)) {
              throw "Missing callback interface namespace input parameter..";
            }
            observerCallbackInterface_.observingEntity = observingEntityReference_;
            observerIdCode = uuid.v4();
            _this.implementation.observers[observerIdCode] = observerCallbackInterface_;
            rootAddress = _this.model.createRootAddress();
            _this.implementation.reifier.dispatchCallback(void 0, "onObserverAttachBegin", observerIdCode);
            _this.implementation.reifier.reifyStoreComponent(rootAddress, observerIdCode);
            _this.implementation.reifier.reifyStoreExtensions(rootAddress, observerIdCode);
            _this.implementation.reifier.dispatchCallback(void 0, "onObserverAttachEnd", observerIdCode);
            return observerIdCode;
          } catch (exception) {
            throw "ONMjs.Store.registerObserver failure: " + exception;
          }
        };
        this.unregisterObserver = function(observerIdCode_) {
          var registeredObserver, rootAddress;
          try {
            if (!((observerIdCode_ != null) && observerIdCode_)) {
              throw "Missing observer ID code input parameter!";
            }
            registeredObserver = _this.implementation.observers[observerIdCode_];
            if (!((registeredObserver != null) && registeredObserver)) {
              throw "Unknown observer ID code provided. No registration to remove.";
            }
            _this.implementation.reifier.dispatchCallback(void 0, "onObserverDetachBegin", observerIdCode_);
            rootAddress = _this.model.createRootAddress();
            _this.implementation.reifier.reifyStoreExtensions(rootAddress, observerIdCode_, true);
            _this.implementation.reifier.unreifyStoreComponent(rootAddress, observerIdCode_);
            _this.implementation.reifier.dispatchCallback(void 0, "onObserverDetachEnd", observerIdCode_);
            _this.removeObserverState(observerIdCode_);
            return delete _this.implementation.observers[observerIdCode_];
          } catch (exception) {
            throw "ONMjs.Store.unregisterObserver failure: " + exception;
          }
        };
        this.openObserverState = function(observerId_) {
          var observerState;
          try {
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID parameter!";
            }
            observerState = (_this.implementation.observersState[observerId_] != null) && _this.implementation.observersState[observerId_] || (_this.implementation.observersState[observerId_] = []);
            return observerState;
          } catch (exception) {
            throw "ONMjs.Store.openObserverStateObject failure: " + exception;
          }
        };
        this.removeObserverState = function(observerId_) {
          if (!((observerId_ != null) && observerId_)) {
            throw "Missing observer ID parameter!";
          }
          if ((typeof observerState !== "undefined" && observerState !== null) && observerState) {
            if ((_this.implementation.observerState[observerId_] != null) && _this.implementation.observerState[observerId_]) {
              delete _this.implementation.observerState[observerId_];
            }
          }
          return _this;
        };
        this.openObserverComponentState = function(observerId_, address_) {
          var componentAddress, componentNamespaceId;
          try {
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID parameter.";
            }
            if (!((address_ != null) && address_)) {
              throw "Missing address input parameter.";
            }
            token = address_.implementation.getLastToken();
            componentNamespaceId = token.componentDescriptor.id;
            componentAddress = address_.createComponentAddress();
            return _this.openObserverNamespaceState(observerId_, componentAddress);
          } catch (exception) {
            throw "ONMjs.Store.openObserverComponentState failure: " + exception;
          }
        };
        this.openObserverNamespaceState = function(observerId_, address_) {
          var namespacePathId, namespacePathState, namespaceState, namespaceURN, observerState;
          try {
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID parameter.";
            }
            if (!((address_ != null) && address_)) {
              throw "Missing address input parameter.";
            }
            observerState = _this.openObserverState(observerId_);
            token = address_.implementation.getLastToken();
            namespacePathId = token.namespaceDescriptor.id;
            namespacePathState = (observerState[namespacePathId] != null) && observerState[namespacePathId] || (observerState[namespacePathId] = {});
            namespaceURN = address_.getHashString();
            namespaceState = (namespacePathState[namespaceURN] != null) && namespacePathState[namespaceURN] || (namespacePathState[namespaceURN] = {});
            return namespaceState;
          } catch (exception) {
            throw "ONMjs.Store.openObserverNamespaceState failure: " + exception;
          }
        };
        this.removeObserverNamespaceState = function(observerId_, address_) {
          var namespaceHash, observerState, pathRecord;
          observerState = _this.modelViewObserversState[observerId_];
          if (!((observerState != null) && observerState)) {
            return _this;
          }
          pathRecord = observerState[namespaceSelector_.pathId];
          if (!((pathRecord != null) && pathRecord)) {
            return _this;
          }
          namespaceHash = namespaceSelector_.getHashString();
          delete pathRecord[namespaceHash];
          if (Encapsule.code.lib.js.dictionaryLength(pathRecord) === 0) {
            delete observerState[namespaceSelector_.pathId];
          }
          return _this;
        };
      } catch (exception) {
        throw "ONMjs.Store failure: " + exception;
      }
    }

    return Store;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.AddressStore = (function(_super) {

    __extends(AddressStore, _super);

    function AddressStore(referenceStore_, address_) {
      this.setAddress = __bind(this.setAddress, this);

      this.getAddress = __bind(this.getAddress, this);

      var selectorAddress, selectorModel,
        _this = this;
      try {
        if (!((referenceStore_ != null) && referenceStore_)) {
          throw "Missing object store input parameter. Unable to determine external selector type.";
        }
        this.referenceStore = referenceStore_;
        selectorModel = new ONMjs.Model({
          jsonTag: "addressStore",
          label: "" + referenceStore_.model.jsonTag + " Address Cache",
          description: "" + referenceStore_.model.label + " observable address cache."
        });
        AddressStore.__super__.constructor.call(this, selectorModel);
        selectorAddress = selectorModel.createRootAddress();
        this.selectorNamespace = new ONMjs.Namespace(this, selectorAddress);
        this.selectorNamespaceData = this.selectorNamespace.data();
        this.selectorNamespaceData.selectedNamespace = void 0;
        this.setAddress(address_);
        this.objectStoreCallbacks = {
          onNamespaceUpdated: function(objectStore_, observerId_, address_) {
            var cachedAddress;
            try {
              cachedAddress = _this.getAddress();
              if ((cachedAddress != null) && cachedAddress && cachedAddress.isEqual(address_)) {
                return _this.setAddress(address_);
              }
            } catch (exception) {
              throw "ONMjs.AddressStore.objectStoreCallbacks.onNamespaceUpdated failure: " + exception;
            }
          },
          onNamespaceRemoved: function(objectStore_, observerId_, address_) {
            var cachedAddress, parentAddress;
            try {
              cachedAddress = _this.getAddress();
              if ((cachedAddress != null) && cachedAddress && cachedAddress.isEqual(address_)) {
                parentAddress = cachedAddress.createParentAddress();
                _this.setAddress(parentAddress);
              }
            } catch (exception) {
              throw "ONMjs.AddressStore.objectStoreCallbacks.onNamespaceRemoved failure: " + exception;
            }
          }
        };
      } catch (exception) {
        throw "ONMjs.AddressStore failure: " + exception;
      }
    }

    AddressStore.prototype.getAddress = function() {
      var namespace;
      try {
        namespace = this.selectorNamespaceData.selectedNamespace;
        if (!((namespace != null) && namespace)) {
          return void 0;
        }
        return namespace.getResolvedAddress();
      } catch (exception) {
        throw "ONMjs.AddressStore.getSelector failure: " + exception;
      }
    };

    AddressStore.prototype.setAddress = function(address_) {
      try {
        if (!(address_ && address_)) {
          this.selectorNamespaceData.selectedNamespace = void 0;
        } else {
          this.selectorNamespaceData.selectedNamespace = new ONMjs.Namespace(this.referenceStore, address_);
        }
        return this.selectorNamespace.update();
      } catch (exception) {
        throw "ONMjs.AddressStore.setAddress failure: " + exception;
      }
    };

    return AddressStore;

  })(ONMjs.Store);

  Encapsule.code.lib.onm.about = {};

  Encapsule.code.lib.onm.about.version = "0.1.00";

  Encapsule.code.lib.onm.about.build = "Mon Nov 11 20:26:10 UTC 2013";

  Encapsule.code.lib.onm.about.epoch = "1384201570";

  Encapsule.code.lib.onm.about.uuid = "9059239b-f537-4b4f-88f5-722e50cb5b89";

}).call(this);
// Generated by CoffeeScript 1.4.0

/*

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.
*/


(function() {
  var ONMjs, namespaceEncapsule;

  ko.bindingHandlers.editableText = {
    init: function(element, valueAccessor) {
      return $(element).on('blur', function() {
        var observable;
        observable = valueAccessor();
        return observable($(this).text());
      });
    },
    update: function(element, valueAccessor) {
      var value;
      value = ko.utils.unwrapObservable(valueAccessor());
      return $(element).text(value);
    }
  };

  /*
  
    http://schema.encapsule.org/schema.html
  
    A single-page HTML5 application for creating, visualizing, and editing
    JSON-encoded Soft Circuit Description Language (SCDL) models.
  
    Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell
  
    Distributed under the terms of the Boost Software License Version 1.0
    See included license.txt or http://www.boost.org/LICENSE_1_0.txt
  
    Sources on GitHub: https://github.com/Encapsule-Project/schema
  
    Visit http://www.encapsule.org for more information and happy hacking.
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.kohelpers = (Encapsule.code.lib.kohelpers != null) && Encapsule.code.lib.kohelpers || (this.Encapsule.code.lib.kohelpers = {});

  Encapsule.runtime = (Encapsule.runtime != null) && Encapsule.runtime || (this.Encapsule.runtime = {});

  Encapsule.runtime.app = (Encapsule.runtime.app != null) && Encapsule.runtime.app || (this.Encapsule.runtime.app = {});

  Encapsule.runtime.app.kotemplates = (Encapsule.runtime.app.kotemplates != null) && Encapsule.runtime.app.kotemplates || (this.Encapsule.runtime.app.kotemplates = []);

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate = function(selectorId_, fnHtml_) {
    var koTemplate;
    try {
      if (!(selectorId_ != null) || !selectorId_ || !(fnHtml_ != null) || !fnHtml_) {
        throw "RegisterKnockoutViewTemplate bad parameter(s)";
      }
      koTemplate = {
        selectorId_: selectorId_,
        fnHtml_: fnHtml_
      };
      Encapsule.runtime.app.kotemplates.push(koTemplate);
      return true;
    } catch (exception) {
      throw "RegisterKnockoutViewTemplate selectorId=" + selectorId_ + " : " + exception;
    }
  };

  Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate = function(descriptor_, templateCacheEl_) {
    var htmlViewTemplate, koTemplateJN, selector;
    try {
      if (!(templateCacheEl_ != null) || !templateCacheEl_) {
        throw "Invalid templateCache element parameter.";
      }
      if (!(descriptor_ != null) || !descriptor_) {
        throw "Invalid descriptor parameter.";
      }
      if (!(descriptor_.selectorId_ != null) || !descriptor_.selectorId_) {
        throw "Invalid descriptor.selectorId_ parameter.";
      }
      if (!(descriptor_.fnHtml_ != null) || !descriptor_.fnHtml_) {
        throw "Invalid descriptor.fnHtml_ parameter.";
      }
      selector = "#" + descriptor_.selectorId_;
      koTemplateJN = $(selector);
      if (koTemplateJN.length === 1) {
        throw "Duplicate Knockout.js HTML view template registration. id=\"" + descriptor_.selectorId_ + "\"";
      }
      htmlViewTemplate = void 0;
      try {
        htmlViewTemplate = descriptor_.fnHtml_();
      } catch (exception) {
        throw "While evaluating the " + descriptor_.selectorId_ + " HTML callback: " + exception;
      }
      templateCacheEl_.append($("<script type=\"text/html\" id=\"" + descriptor_.selectorId_ + "\">" + htmlViewTemplate + "</script>"));
      return true;
    } catch (exception) {
      throw "Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate for descriptor " + descriptor_.selectorId_ + " : " + exception;
    }
  };

  Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates = function(templateCacheSelector_) {
    var descriptor, templateCacheEl, _i, _len, _ref;
    try {
      if (!((templateCacheSelector_ != null) && templateCacheSelector_)) {
        throw "You must specify the selector string of the Knockout.js view model template cache's DOM element.";
      }
      templateCacheEl = $(templateCacheSelector_);
      _ref = Encapsule.runtime.app.kotemplates;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        descriptor = _ref[_i];
        Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplate(descriptor, templateCacheEl);
      }
      Encapsule.runtime.app.kotemplates = [];
      return true;
    } catch (exception) {
      throw "InstallKnockoutViewTemplates failure: " + exception;
    }
  };

  /*
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
  
  GenericTest implements handlers for all signals defined by ONMjs. Once registered
  with an ONMjs.Store, GenericTest serializes telemetry information back via
  BackChannel.log.
  
  ------------------------------------------------------------------------------
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.GenericTest = (function() {

    function GenericTest(backchannel_) {
      var _this = this;
      this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
        throw "Missing backchannel input parameter.";
      })();
      this.callbackInterface = {
        onObserverAttachBegin: function(store_, observerId_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onObserverAttachBegin");
        },
        onObserverAttachEnd: function(store_, observerId_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onObserverAttachEnd");
        },
        onObserverDetachBegin: function(store_, observerId_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onObserverDetachBegin");
        },
        onObserverDetachEnd: function(store_, observerId_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onObserverDetachEnd");
        },
        onComponentCreated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onComponentCreated(" + (address_.getHumanReadableString()) + ")");
        },
        onComponentUpdated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onComponentUpdated(" + (address_.getHumanReadableString()) + ")");
        },
        onComponentRemoved: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onComponentRemoved(" + (address_.getHumanReadableString()) + ")");
        },
        onNamespaceCreated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onNamespaceCreated(" + (address_.getHumanReadableString()) + ")");
        },
        onNamespaceUpdated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onNamespaceUpdated(" + (address_.getHumanReadableString()) + ")");
        },
        onNamespaceRemoved: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onNamespaceRemoved(" + (address_.getHumanReadableString()) + ")");
        },
        onSubNamespaceUpdated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onSubNamespaceUpdated(" + (address_.getHumanReadableString()) + ")");
        },
        onSubComponentUpdated: function(store_, observerId_, address_) {
          return _this.backchannel.log("ONMjs_" + store_.jsonTag + "Observer::" + observerId_ + "::onSubComponentUpdated(" + (address_.getHumanReadableString()) + ")");
        }
      };
    }

    return GenericTest;

  })();

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.BackchannelView = (function() {

    function BackchannelView(backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel parameter.";
        })();
        this.logHandlerOriginal = void 0;
        this.errorHandlerOriginal = void 0;
        this.viewEl = void 0;
        this.backchannel.clearLog = function() {
          return true;
        };
        this.setViewSelector = function(selectorString_) {
          try {
            if (!((selectorString_ != null) && selectorString_)) {
              _this.viewEl = void 0;
              _this.backchannel.logHandler = _this.logHandlerOriginal;
              _this.backchannel.errorHandler = _this.errorHandlerOriginal;
              return;
            }
            _this.viewEl = $(selectorString_);
            if (!((_this.viewEl != null) && _this.viewEl)) {
              throw "Cannot resolve selector string '" + selectorString + "'";
            }
            _this.logHandlerOriginal = backchannel_.logHandler;
            _this.errorHandlerOriginal = backchannel_.errorHandler;
            _this.backchannel.logHandler = function(message_) {
              var message;
              message = $("<div style=\"background-color: rgba(255,255,255,0.1); margin-bottom: 1px; white-space: nowrap;\" >" + message_ + "</div>");
              return _this.viewEl.append(message);
            };
            _this.backchannel.errorHandler = function(message_) {
              var message;
              message = $("<div style=\"background-color: rgba(255,255,0,0.5); margin-bottom: 1px; white-space: nowrap;\" ><h1>error</h1></div>");
              _this.viewEl.append(message);
              message = $("<div style=\"background-color: rgba(255,255,0,0.3); margin-bottom: 1px; \" >" + message_ + "</div>");
              return _this.viewEl.append(message);
            };
            return _this.backchannel.clearLog = function() {
              return _this.viewEl.html("");
            };
          } catch (exception) {
            throw "ONMjs.observers.BackchannelView failure: " + exception;
          }
        };
        this;

      } catch (exception) {
        throw "ONMjs.observers.BackchannelModelView failure: " + exception;
      }
    }

    return BackchannelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_BackchannelViewModel", (function() {
    return "<div class=\"classONMjsSelectedJson\">\n    <span class=\"titleString\">Data Model Host</span>\n</div>\n<div id=\"idBackchannelLogMessages\" style: position: relative; top: 0px;\" ></div>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.NavigatorModelView = (function() {

    function NavigatorModelView(backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.objectStore = void 0;
        this.rootMenuModelView = ko.observable(void 0);
        this.store = void 0;
        this.storeObserverId = void 0;
        this.selectedCachedAddressSink = void 0;
        this.attachToStore = function(store_) {
          try {
            if (!((store_ != null) && store_)) {
              throw "Missing store input parameter.";
            }
            if ((_this.storeObserverId != null) && _this.storeObserverId) {
              throw "This navigator instance is already observing an ONMjs.Store instance.";
            }
            _this.store = store_;
            _this.storeObserverId = store_.registerObserver(_this.objectStoreObserverInterface, _this);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.attachToStore failure: " + exception;
          }
        };
        this.detachFromStore = function() {
          try {
            if (!(_this.storeObserverId != null) && _this.storeObserverId) {
              throw "This navigator instance is not attached to an ONMjs.Store instance.";
            }
            _this.store.unregisterObserver(_this.storeObserverId);
            _this.storeObserverId = void 0;
            _this.store = void 0;
            return true;
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.detachFromStore failure: " + exception;
          }
        };
        this.attachToCachedAddress = function(cachedAddress_) {
          var observerId;
          try {
            if (!((cachedAddress_ != null) && cachedAddress_)) {
              throw "Missing cached address input parameter.";
            }
            observerId = cachedAddress_.registerObserver(_this.cachedAddressObserverInterface, _this);
            return observerId;
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.attachToCachedAddress failure: " + excpetion;
          }
        };
        this.detachFromCachedAddress = function(cachedAddress_, observerId_) {
          try {
            if (!((cachedAddress_ != null) && cachedAddress_)) {
              throw "Missing cached address input parameter.";
            }
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID input parameter.";
            }
            cachedAddress_.unregisterObserver(observerId_);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.detachFromCachedAddress failure: " + exception;
          }
        };
        this.setCachedAddressSink = function(cachedAddress_) {
          try {
            return _this.selectedCachedAddressSink = cachedAddress_;
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.setCachedAddressSink failure: " + exception;
          }
        };
        this.routeUserSelectAddressRequest = function(address_) {
          var message;
          try {
            if ((_this.selectedCachedAddressSink != null) && _this.selectedCachedAddressSink) {
              _this.selectedCachedAddressSink.setAddress(address_);
              return;
            }
            message = ("ONMjs.obsevers.NavigatorModelView.routeUserSelectAddressRequest for address  '" + (address_.getHashString()) + "'failed. ") + "setCachedAddressSink method must be called to set the routing destination.";
            return alert(message);
          } catch (exception) {
            throw "ONMjs.observers.NavigatorModelView.routeUserSelectAddressRequest failure: " + exception;
          }
        };
        this.objectStoreObserverInterface = {
          onObserverAttachBegin: function(store_, observerId_) {
            try {
              _this.backchannel.log("ONMjs.observer.NavigatorModelview is now observing ONMjs.Store.");
              if ((_this.storeObserverId != null) && _this.storeObserverId) {
                throw "This navigator instance is already observing an ONMjs.Store.";
              }
              _this.storeObserverId = observerId_;
              return true;
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.objectStoreObserverCallbacks.onObserverAttach failure: " + exception;
            }
          },
          onObserverDetachEnd: function(store_, observerId_) {
            try {
              _this.backchannel.log("ONMjs.observers.NavigatorModelView is no longer observing ONMjs.Store.");
              if (!((_this.storeObserverId != null) && _this.storeObserverId)) {
                throw "Internal error: received detach callback but it doesn't apprear we're attached?";
              }
              if (_this.storeObserverId !== observerId_) {
                throw "Internal error: received detach callback for un unrecognized observer ID?";
              }
              _this.storeObserverId = void 0;
              return true;
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.objectStoreObserverCallbacks.onObserverDetach failure: " + exception;
            }
          },
          onNamespaceCreated: function(store_, observerId_, address_) {
            var namespaceState, parentAddress, parentNamespaceState;
            try {
              if (_this.storeObserverId !== observerId_) {
                throw "Unrecognized observer ID.";
              }
              namespaceState = store_.openObserverNamespaceState(observerId_, address_);
              namespaceState.description = "Hey this is the ONMjs.observers.NavigatorModelView class saving some submenu state.";
              namespaceState.itemModelView = new ONMjs.observers.implementation.NavigatorItemModelView(store_, _this, address_, _this.backchannel);
              if (address_.isRoot()) {
                _this.rootMenuModelView(namespaceState.itemModelView);
              }
              parentAddress = address_.createParentAddress();
              if ((parentAddress != null) && (parentAddress != null)) {
                parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress);
                parentNamespaceState.itemModelView.children.push(namespaceState.itemModelView);
                return namespaceState.indexInParentChildArray = parentNamespaceState.itemModelView.children().length - 1;
              }
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView failure: " + exception;
            }
          },
          onNamespaceUpdated: function(store_, observerId_, address_) {
            var namespace, namespaceModel, namespaceState;
            try {
              if (_this.storeObserverId !== observerId_) {
                throw "Unrecognized observer ID.";
              }
              namespaceModel = address_.getModel();
              if (namespaceModel.namespaceType !== "component") {
                return;
              }
              namespace = store_.openNamespace(address_);
              namespaceState = store_.openObserverNamespaceState(observerId_, address_);
              return namespaceState.itemModelView.label(namespace.getResolvedLabel());
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.onNamespaceUpdated failure: " + excpetion;
            }
          },
          onNamespaceRemoved: function(store_, observerId_, address_) {
            var item, itemAddress, itemState, namespaceState, parentAddress, parentChildItemArray, parentNamespaceState, spliceIndex;
            try {
              if (_this.storeObserverId !== observerId_) {
                throw "Unrecognized observer ID.";
              }
              namespaceState = store_.openObserverNamespaceState(observerId_, address_);
              if (address_.isRoot()) {
                _this.rootMenuModelView(void 0);
              }
              parentAddress = address_.createParentAddress();
              if ((parentAddress != null) && parentAddress) {
                parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress);
                parentChildItemArray = parentNamespaceState.itemModelView.children();
                spliceIndex = namespaceState.indexInParentChildArray;
                parentChildItemArray.splice(spliceIndex, 1);
                while (spliceIndex < parentChildItemArray.length) {
                  item = parentChildItemArray[spliceIndex];
                  itemAddress = item.address;
                  itemState = store_.openObserverNamespaceState(observerId_, itemAddress);
                  itemState.indexInParentChildArray = spliceIndex++;
                }
                parentNamespaceState.itemModelView.children(parentChildItemArray);
                return true;
              }
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.onNamespaceRemoved failure: " + exception;
            }
          }
        };
        this.selectedNamespacesBySelectorHash = {};
        this.cachedAddressObserverInterface = {
          onComponentCreated: function(store_, observerId_, address_) {
            try {
              return _this.cachedAddressObserverInterface.onComponentUpdated(store_, observerId_, address_);
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.cachedAddressObserverInterface.onComponentCreated failure: " + exception;
            }
          },
          onComponentUpdated: function(store_, observerId_, address_) {
            var cachedAddress, namespaceState, observerState;
            try {
              observerState = store_.openObserverState(observerId_);
              if ((observerState.itemModelView != null) && observerState.itemModelView) {
                observerState.itemModelView.removeSelection(observerId_);
              }
              cachedAddress = store_.getAddress();
              if ((cachedAddress != null) && cachedAddress) {
                namespaceState = _this.store.openObserverNamespaceState(_this.storeObserverId, cachedAddress);
                if (!((namespaceState.itemModelView != null) && namespaceState.itemModelView)) {
                  throw "Internal error: namespace state cache for this namespace is not initialized.";
                }
                namespaceState.itemModelView.addSelection(observerId_);
                return observerState.itemModelView = namespaceState.itemModelView;
              }
            } catch (exception) {
              throw "ONMjs.observers.NavigatorModelView.cachedAddressObserverInterface.onComponentUpdated failure: " + exception;
            }
          }
        };
      } catch (exception) {
        throw " ONMjs.observers.NavigatorModelView consructor failure: " + exception;
      }
    }

    return NavigatorModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_NavigatorViewModel", (function() {
    return "<span data-bind=\"if: rootMenuModelView()\">\n    <div class=\"classONMjsNavigator\">\n        <span data-bind=\"template: { name: 'idKoTemplate_NavigatorItemViewModel', foreach: rootMenuModelView().children }\"></span>\n    </div>\n</span>\n<span data-bind=\"ifnot: rootMenuModelView()\">\nOffline.\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observer = {});

  ONMjs.observers.implementation = (ONMjs.observers.implementation != null) && ONMjs.observers.implementation || (ONMjs.observers.implementation = {});

  ONMjs.observers.implementation.NavigatorItemModelView = (function() {

    function NavigatorItemModelView(store_, navigatorModelView_, address_, backchannel_) {
      var namespace,
        _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        if (!((store_ != null) && store_)) {
          throw "Missing object store input parameter.";
        }
        if (!((navigatorModelView_ != null) && navigatorModelView_)) {
          throw "Missing parent object model navigator window input parameter.";
        }
        if (!((address_ != null) && address_)) {
          throw "Missing address input parameter.";
        }
        this.store = store_;
        this.navigatorModelView = navigatorModelView_;
        this.address = address_;
        this.children = ko.observableArray([]);
        this.isSelected = ko.observable(false);
        this.selectionsByObserverId = {};
        namespace = store_.openNamespace(address_);
        this.label = ko.observable(namespace.getResolvedLabel());
        this.onClick = function() {
          try {
            return _this.navigatorModelView.routeUserSelectAddressRequest(_this.address);
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.implementation.NavigatorItemModelView.onClick failure: " + exception);
          }
        };
        this.addSelection = function(observerId_) {
          try {
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID input parameter.";
            }
            _this.selectionsByObserverId[observerId_] = true;
            return _this.isSelected(true);
          } catch (exception) {
            throw "ONMjs.observers.implementation.NavigatorItemModelView.addSelection failure: " + exception;
          }
        };
        this.removeSelection = function(observerId_) {
          try {
            if (!((observerId_ != null) && observerId_)) {
              throw "Missing observer ID input parameter.";
            }
            delete _this.selectionsByObserverId[observerId_];
            return _this.isSelected(Encapsule.code.lib.js.dictionaryLength(_this.selectionsByObserverId) && true || false);
          } catch (exception) {
            throw "ONMjs.observers.implementation.NavigatorItemModelView.removeSelection failure: " + exception;
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.implementation.NavigatorItemModelView failure: : " + exception;
      }
    }

    return NavigatorItemModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_NavigatorItemViewModel", (function() {
    return "<span data-bind=\"if: isSelected()\">\n    <div class=\"classONMjsNavigatorItem classONMjsNavigatorItemSelected\">\n        <div class=\"classONMjsNavigatorItemSelectedLabel\" data-bind=\"text: label\" ></div>\n\n        <span data-bind=\"if: children().length\">\n            <div class=\"classONMjsNavigatorItemSelectedChildren\">\n                <div data-bind=\"template: { name: 'idKoTemplate_NavigatorItemViewModel', foreach: children }\"></div>\n            </div>\n        </span>\n\n    </div>\n</span>\n\n<span data-bind=\"ifnot: isSelected()\">\n    <div class=\"classONMjsNavigatorItem classONMjsNavigatorItemUnselected classONMjsMouseOverPointer\" data-bind=\"click: onClick, clickBubble: false\" >\n        <div class=\"classONMjsNavigatorItemUnselectedLabel\" data-bind=\"text: label\"></div>\n\n        <span data-bind=\"if: children().length\">\n            <div class=\"classONMjsNavigatorItemUnselectedChildren\">\n                <div data-bind=\"template: { name: 'idKoTemplate_NavigatorItemViewModel', foreach: children }\"></div>\n            </div>\n        </span>\n\n    </div>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers.SelectedJsonModelView = (function() {

    function SelectedJsonModelView(backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.title = ko.observable("<not connected>");
        this.selectorHash = ko.observable("<not connected>");
        this.jsonString = ko.observable("<not connected>");
        this.observerAttached = ko.observable(false);
        this.cachedAddressStore = void 0;
        this.cachedAddressObserverId = void 0;
        this.saveJSONAsLinkHtml = ko.computed(function() {
          var html;
          return html = "<a href=\"data:text/json;base64," + (window.btoa(_this.jsonString())) + "\" target=\"_blank\" title=\"Open raw JSON in new tab...\"> \n<img src=\"./img/json_file-48x48.png\" style=\"width: 24px; heigh: 24px; border: 0px solid black; vertical-align: middle;\" ></a>";
        });
        this.attachToCachedAddress = function(cachedAddress_) {
          try {
            if (!((cachedAddress_ != null) && cachedAddress_)) {
              throw "Missing cached address store input parameter.";
            }
            if ((_this.cachedAddressStore != null) && _this.cachedAddressStore) {
              throw "Already attached to an ONMjs.CachedAddress object.";
            }
            _this.cachedAddressStore = cachedAddress_;
            _this.cachedAddressObserverId = cachedAddress_.registerObserver(_this.cachedAddressCallbackInterface, _this);
            _this.observerAttached(true);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedJsonModelView.attachToCachedAddress failure: " + exception + ".";
          }
        };
        this.detachFromCachedAddress = function() {
          try {
            if (!((_this.cachedAddressStore != null) && _this.cachedAddressStore)) {
              throw "Not attached to address store object.";
            }
            _this.cachedAddressStore.unregisterObserver(_this.cachedAddressObserverId);
            _this.cachedAddressStore = void 0;
            _this.cachedAddressObserverId = void 0;
            _this.observerAttached(false);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedJsonModelView.detachFromCachedAddress failure: " + exception + ".";
          }
        };
        this.cachedAddressCallbackInterface = {
          onComponentCreated: function(store_, observerId_, address_) {
            try {
              return _this.cachedAddressCallbackInterface.onComponentUpdated(store_, observerId_, address_);
            } catch (exception) {
              throw "ONMjs.observers.SelectedJsonModelView.cachedAddressCallbackInterface.onComponentCreated failure: " + exception;
            }
          },
          onComponentUpdated: function(store_, observerId_, address_) {
            var selectedNamespace, storeAddress;
            try {
              storeAddress = store_.getAddress();
              if (!((storeAddress != null) && storeAddress)) {
                _this.title("<no selected address>");
                _this.selectorHash("Address: <no selected address>");
                _this.jsonString("<undefined>");
                return true;
              }
              selectedNamespace = store_.referenceStore.openNamespace(storeAddress);
              _this.title(selectedNamespace.getResolvedLabel());
              _this.selectorHash(selectedNamespace.getResolvedAddress().getHashString());
              _this.jsonString(selectedNamespace.toJSON(void 0, 2));
              return true;
            } catch (exception) {
              throw "ONMjs.observers.SelectedJsonModelView.cachedAddressCallbackInterface.onComponentUpdated failure: " + exception;
            }
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.SelectedJsonModelView construction failure: " + exception;
      }
    }

    return SelectedJsonModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorJsonModelView", (function() {
    return "<span data-bind=\"if: observerAttached()\">\n<div class=\"classONMjsSelectedJson\">\n    <span data-bind=\"html: saveJSONAsLinkHtml\"></span>\n    <span class=\"titleString\" data-bind=\"html: title\"></span>\n</div>\naddress hash:<br>\n<span class=\"classONMjsSelectedJsonAddressHash\" data-bind=\"html: selectorHash\"></span>\n<div class=\"classObjectModelNavigatorJsonBody\">\n    <pre class=\"classONMjsSelectedJsonBody\" data-bind=\"html: jsonString\"></pre>\n</div>\n</span>\n<span data-bind=\"ifnot: observerAttached()\">\nOffline.\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.implementation = (ONMjs.observers.implementation != null) && ONMjs.observers.implementation || (ONMjs.observers.implementation = {});

  ONMjs.observers.implementation.SelectedPathElementModelView = (function() {

    function SelectedPathElementModelView(addressCache_, count_, selectedCount_, objectStoreAddress_, backchannel_) {
      var objectStoreNamespace, resolvedLabel, styleClasses,
        _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.cachedAddressStore = addressCache_;
        this.objectStoreAddress = objectStoreAddress_;
        this.isSelected = count_ === selectedCount_;
        objectStoreNamespace = addressCache_.referenceStore.openNamespace(objectStoreAddress_);
        resolvedLabel = objectStoreNamespace.getResolvedLabel();
        this.prefix = "";
        switch (count_) {
          case 0:
            break;
          case 1:
            this.prefix += " :: ";
            break;
          default:
            this.prefix += " / ";
            break;
        }
        if (this.prefix.length) {
          this.prefix = "<span class=\"prefix\">" + this.prefix + "</span>";
        }
        this.label = "";
        if (this.isSelected) {
          this.label += "<span class=\"selected\">" + resolvedLabel + "</span>";
        } else {
          styleClasses = "parent classONMjsMouseOverPointer";
          if (objectStoreAddress_.getModel().namespaceType === "component") {
            styleClasses += " component";
          }
          this.label += "<span class=\"" + styleClasses + "\">" + resolvedLabel + "</span>";
        }
        this.onClick = function() {
          try {
            if (!_this.isSelected) {
              return _this.cachedAddressStore.setAddress(_this.objectStoreAddress);
            }
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.implementation.SelectedPathElementModelView.onClick failure: " + exception);
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.SelectedPathElementModelView failure: " + exception;
      }
    }

    return SelectedPathElementModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedPathElementViewModel", (function() {
    return "<span class=\"classONMjsSelectedPathElement\"><span data-bind=\"html: prefix\"></span><span data-bind=\"html: label, click: onClick\"></span></span>";
  }));

  ONMjs.observers.SelectedPathModelView = (function() {

    function SelectedPathModelView(backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.pathElements = ko.observableArray([]);
        this.cachedAddressStore = void 0;
        this.cachedAddressStoreObserverId = void 0;
        this.addressHumanString = ko.observable("not connected");
        this.addressHashString = ko.observable("not connected");
        this.attachToCachedAddress = function(cachedAddress_) {
          try {
            if (!((cachedAddress_ != null) && cachedAddress_)) {
              throw "Missing cached address input parameter.";
            }
            if ((_this.cachedAddressStore != null) && _this.cachedAddressStore) {
              throw "Already attached to an ONMjs.CachedAddress object.";
            }
            _this.cachedAddressStore = cachedAddress_;
            _this.cachedAddressStoreObserverId = cachedAddress_.registerObserver(_this.cachedAddressObserverInterface, _this);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedPathModelView.attachToCachedAddress failure: " + exception;
          }
        };
        this.detachFromCachedAddress = function() {
          try {
            if (!((_this.cachedAddressStoreObserverId != null) && _this.cachedAddressStoreObserverId)) {
              throw "Not attached to an ONMjs.CachedAddress object.";
            }
            _this.cachedAddressStore.unregisterObserver(_this.cachedAddressStoreObserverId);
            _this.cachedAddressStoreObserverId = void 0;
            _this.cachedAddressStore = void 0;
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedPathModelView.detachFromCachedAddress failure: " + exception;
          }
        };
        this.cachedAddressObserverInterface = {
          onObserverAttachEnd: function(store_, observerId_) {
            return _this.backchannel.log("ONMjs.observers.SelectedPathModelView has attached to and is observing in ONMjs.CachedAddress instance.");
          },
          onObserverDetachEnd: function(store_, observerId_) {
            _this.pathElements.removeAll();
            _this.addressHashString("not connected");
            _this.addressHumanString("not connected");
            _this.cachedAddressStore = void 0;
            _this.cachedAddressStoreObserverId = void 0;
            return _this.backchannel.log("ONMjs.observers.SelectedPathModelView has detached from and is no longer observing an ONMjs.CachedAddress instance.");
          },
          onComponentCreated: function(store_, observerId_, address_) {
            try {
              return _this.cachedAddressObserverInterface.onComponentUpdated(store_, observerId_, address_);
            } catch (exception) {
              return "ONMjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentCreated failure: " + exception;
            }
          },
          onComponentUpdated: function(store_, observerId_, address_) {
            var address, addresses, count, pathElementObject, selectedAddress, selectedCount, _i, _len;
            try {
              selectedAddress = store_.getAddress();
              if (!((selectedAddress != null) && selectedAddress)) {
                return true;
              }
              _this.addressHumanString(selectedAddress.getHumanReadableString());
              _this.addressHashString(selectedAddress.getHashString());
              addresses = [];
              selectedAddress.visitParentAddressesAscending(function(address__) {
                return addresses.push(address__);
              });
              addresses.push(selectedAddress);
              count = 0;
              selectedCount = addresses.length - 1;
              _this.pathElements.removeAll();
              for (_i = 0, _len = addresses.length; _i < _len; _i++) {
                address = addresses[_i];
                pathElementObject = new ONMjs.observers.implementation.SelectedPathElementModelView(store_, count++, selectedCount, address, _this.backchannel);
                _this.pathElements.push(pathElementObject);
              }
              return true;
            } catch (exception) {
              throw "OMNjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentUpdated failure: " + exception;
            }
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.SelectedPathModelView construction failure: " + exception;
      }
    }

    return SelectedPathModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedPathViewModel", (function() {
    return "<span data-bind=\"if: pathElements().length\">\n<div class=\"classONMjsSelectedPath\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedPathElementViewModel', foreach: pathElements }\"></span></div>\n<div style=\"margin-top: 8px; font-family: Courier;\"><span data-bind=\"text: addressHumanString\"></span></div>\n<div style=\"font-family: Courier;\"><span data-bind=\"text: addressHashString\"></span></div>\n</span>\n<span data-bind=\"ifnot: pathElements().length\">\nOffline.\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceModelView = (function() {

    function SelectedNamespaceModelView(backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.objectStoreName = ko.observable("<not connected>");
        this.title = ko.observable("<not connected>");
        this.observerAttached = ko.observable(false);
        this.modelviewActions = ko.observable(void 0);
        this.modelviewTitle = ko.observable(void 0);
        this.modelviewImmutable = ko.observable(void 0);
        this.modelviewMutable = ko.observable(void 0);
        this.modelviewComponent = ko.observable(void 0);
        this.modelviewChildren = ko.observable(void 0);
        this.modelviewCollection = ko.observable(void 0);
        this.cachedAddressStore = void 0;
        this.cachedAddressStoreObserverId = void 0;
        this.attachToCachedAddress = function(cachedAddress_) {
          try {
            if (!((cachedAddress_ != null) && cachedAddress_)) {
              throw "Missing cached address input parameter.";
            }
            if ((_this.cachedAddressStore != null) && _this.cachedAddressStore) {
              throw "This namespace observer is already attached to a selected address store.";
            }
            _this.cachedAddressStore = cachedAddress_;
            _this.cachedAddressStoreObserverId = cachedAddress_.registerObserver(_this.cachedAddressObserverInterface, _this);
            _this.observerAttached(true);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedNamespaceModelView.attachToCachedAddress failure: " + exception;
          }
        };
        this.detachFromCachedAddress = function() {
          try {
            if (!(_this.cachedAddressStoreObserverId && _this.cachedAddressStoreObserverId)) {
              throw "This namespace observer is not currently attached to a cached address store.";
            }
            _this.cachedAddressStore.unregisterObserver(_this.cachedAddressStoreObserverId);
            _this.cachedAddressStore = void 0;
            _this.cachedAddressStoreObserverId = void 0;
            _this.observerAttached(false);
            return true;
          } catch (exception) {
            throw "ONMjs.observers.SelectedNamespaceModelView.detachFromCachedAddress failure: " + exception;
          }
        };
        this.cachedAddressObserverInterface = {
          onComponentCreated: function(cachedAddressStore_, observerId_, address_) {
            return _this.cachedAddressObserverInterface.onComponentUpdated(cachedAddressStore_, observerId_, address_);
          },
          onComponentUpdated: function(cachedAddressStore_, observerId_, address_) {
            var childParams, immutableModelView, mutableModelView, namespaceType, newModelViewChildren, objectStore, selectedAddress, selectedNamespace, selectedNamespaceModel;
            objectStore = cachedAddressStore_.referenceStore;
            selectedAddress = cachedAddressStore_.getAddress();
            if (!(selectedAddress && selectedAddress)) {
              return true;
            }
            selectedNamespace = objectStore.openNamespace(selectedAddress);
            selectedNamespaceModel = selectedAddress.getModel();
            _this.objectStoreName = objectStore.jsonTag;
            childParams = {
              backchannel: _this.backchannel,
              cachedAddressStore: cachedAddressStore_,
              objectStore: objectStore,
              selectedAddress: selectedAddress,
              selectedNamespace: selectedNamespace,
              selectedNamespaceModel: selectedNamespaceModel
            };
            _this.modelviewTitle(new ONMjs.observers.SelectedNamespaceTitleModelView(childParams, _this.backchannel));
            _this.modelviewActions(new ONMjs.observers.SelectedNamespaceActionsModelView(childParams, _this.backchannel));
            namespaceType = selectedNamespaceModel.namespaceType;
            switch (namespaceType) {
              case "root":
                immutableModelView = new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams);
                _this.modelviewImmutable(immutableModelView.propertyModelViews.length && immutableModelView || void 0);
                mutableModelView = new ONMjs.observers.SelectedNamespaceMutablePropertiesModelView(childParams);
                _this.modelviewMutable(mutableModelView.propertyModelViews.length && mutableModelView || void 0);
                newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams);
                _this.modelviewChildren(newModelViewChildren.childModelViews.length && newModelViewChildren || void 0);
                _this.modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams));
                _this.modelviewCollection(void 0);
                break;
              case "child":
                immutableModelView = new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams);
                _this.modelviewImmutable(immutableModelView.propertyModelViews.length && immutableModelView || void 0);
                mutableModelView = new ONMjs.observers.SelectedNamespaceMutablePropertiesModelView(childParams);
                _this.modelviewMutable(mutableModelView.propertyModelViews.length && mutableModelView || void 0);
                newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams);
                _this.modelviewChildren(newModelViewChildren.childModelViews.length && newModelViewChildren || void 0);
                _this.modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams));
                _this.modelviewCollection(void 0);
                break;
              case "extensionPoint":
                _this.modelviewImmutable(void 0);
                _this.modelviewMutable(void 0);
                _this.modelviewChildren(void 0);
                _this.modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams));
                _this.modelviewCollection(new ONMjs.observers.SelectedNamespaceCollectionModelView(childParams));
                break;
              case "component":
                immutableModelView = new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams);
                _this.modelviewImmutable(immutableModelView.propertyModelViews.length && immutableModelView || void 0);
                mutableModelView = new ONMjs.observers.SelectedNamespaceMutablePropertiesModelView(childParams);
                _this.modelviewMutable(mutableModelView.propertyModelViews.length && mutableModelView || void 0);
                newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams);
                _this.modelviewChildren(newModelViewChildren.childModelViews.length && newModelViewChildren || void 0);
                _this.modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams));
                _this.modelviewCollection(void 0);
                break;
              default:
                throw "Unrecognized namespace type in request.";
            }
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceModelView construction failure: " + exception;
      }
    }

    return SelectedNamespaceModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceViewModel", (function() {
    return "<span data-bind=\"if: observerAttached()\">\n<span data-bind=\"if: modelviewTitle\"><span data-bind=\"with: modelviewTitle\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceTitleViewModel' }\"></span></span></span>\n<span data-bind=\"if: modelviewActions\"><span data-bind=\"with: modelviewActions\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceActionsViewModel' }\"></span></span></span>\n<span data-bind=\"if: modelviewImmutable\"><span data-bind=\"with: modelviewImmutable\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceImmutablePropertiesViewModel' }\"></span></span></span>\n<span data-bind=\"if: modelviewMutable\"><span data-bind=\"with: modelviewMutable\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceMutablePropertiesViewModel'}\"></span></span></span>\n<span data-bind=\"if: modelviewCollection\"><span data-bind=\"with: modelviewCollection\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceCollectionViewModel'}\"></span></span></span>\n<span data-bind=\"if: modelviewChildren\"><span data-bind=\"with: modelviewChildren\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceChildrenViewModel'}\"></span></span></span>\n<span data-bind=\"if: modelviewComponent\"><span data-bind=\"with: modelviewComponent\"><span data-bind=\"template: { name: 'idKoTemplate_SelectedNamespaceComponentViewModel'}\"></span></span></span>\n</span>\n<span data-bind=\"ifnot: observerAttached()\">\nOffline.\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceActionsModelView = (function() {

    function SelectedNamespaceActionsModelView(params_) {
      var archetypeLabel, componentAddress, componentModel, label, subcomponentCount,
        _this = this;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.onClickAddSubcomponent = function(prefix_, label_, address_, selectorStore_, options_) {
          var componentNamespace;
          try {
            _this.backchannel.log("ObjectModelNavigatorNamespaceActions.onClickAddSubcomponent starting...");
            componentNamespace = selectorStore_.referenceStore.createComponent(address_);
            return selectorStore_.setAddress(componentNamespace.getResolvedAddress());
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.SelectedNamespaceActionsModelView.onClickAddSubcomponent failure: " + exception);
          }
        };
        this.onClickRemoveComponent = function(prefix_, label_, address_, selectorStore_, options_) {
          try {
            return _this.showConfirmRemove(true);
          } catch (exception) {
            throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveComponent failure: " + exception;
          }
        };
        this.onDoRemoveComponent = function(prefix_, label_, address_, selectorStore_, options_) {
          try {
            return selectorStore_.referenceStore.removeComponent(address_);
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveComponent failure: " + exception);
          }
        };
        this.onClickRemoveAllSubcomponents = function(prefix_, label_, address_, selectorStore_, options_) {
          try {
            return _this.showConfirmRemoveAll(true);
          } catch (exception) {
            throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveAllSubcomponents failure: " + exception;
          }
        };
        this.onDoRemoveAllSubcomponents = function(prefix_, label_, address_, selectorStore_, options_) {
          var address, namespace, store, subcomponentAddresses, _i, _len, _results;
          try {
            store = selectorStore_.referenceStore;
            namespace = store.openNamespace(address_);
            subcomponentAddresses = [];
            namespace.visitExtensionPointSubcomponents(function(address__) {
              return subcomponentAddresses.push(address__);
            });
            _results = [];
            for (_i = 0, _len = subcomponentAddresses.length; _i < _len; _i++) {
              address = subcomponentAddresses[_i];
              _results.push(store.removeComponent(address));
            }
            return _results;
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveAllSubcomponents failure: " + exception);
          }
        };
        this.onClickCancelActionRequest = function(prefix_, label_, address_, selectorStore_, options_) {
          try {
            _this.showConfirmRemoveAll(false);
            return _this.showConfirmRemove(false);
          } catch (exception) {
            throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickCancelActionRequest failure: " + exception;
          }
        };
        this.actionsForNamespace = false;
        this.callbackLinkAddSubcomponent = void 0;
        this.callbackLinkRequestRemoveAllSubcomponents = void 0;
        this.callbackLinkRemoveAllSubcomponents = void 0;
        this.callbackLinkRequestRemoveComponent = void 0;
        this.callbackLinkRemoveComponent = void 0;
        this.callbackLinkCancelActionRequest = new ONMjs.observers.helpers.CallbackLinkModelView("", "Cancel Request", void 0, void 0, {
          styleClass: "classONMjsActionButtonCancel"
        }, this.onClickCancelActionRequest, this.backchannel);
        this.showConfirmRemove = ko.observable(false);
        this.showConfirmRemoveAll = ko.observable(false);
        switch (params_.selectedNamespaceModel.namespaceType) {
          case "root":
            break;
          case "child":
            break;
          case "extensionPoint":
            componentAddress = params_.selectedAddress.createSubcomponentAddress();
            componentModel = componentAddress.getModel();
            archetypeLabel = (componentModel.____label != null) && componentModel.____label || "<no label provided>";
            this.callbackLinkAddSubcomponent = new ONMjs.observers.helpers.CallbackLinkModelView("", "Add " + archetypeLabel, componentAddress, params_.cachedAddressStore, {
              styleClass: "classONMjsActionButtonAdd"
            }, this.onClickAddSubcomponent, this.backchannel);
            subcomponentCount = Encapsule.code.lib.js.dictionaryLength(params_.selectedNamespace.data());
            label = (params_.selectedNamespaceModel.____label != null) && params_.selectedNamespaceModel.____label || "<no label defined>";
            this.callbackLinkRequestRemoveAllSubcomponents = new ONMjs.observers.helpers.CallbackLinkModelView("", "Remove All " + label, void 0, void 0, {
              noLink: subcomponentCount === 0,
              styleClass: subcomponentCount !== 0 && "classONMjsActionButtonRemoveAll" || void 0
            }, this.onClickRemoveAllSubcomponents, this.backchannel);
            this.callbackLinkRemoveAllSubcomponents = new ONMjs.observers.helpers.CallbackLinkModelView("", "Proceed with Remove All", params_.selectedAddress, params_.cachedAddressStore, {
              noLink: subcomponentCount === 0,
              styleClass: subcomponentCount !== 0 && "classONMjsActionButtonConfirm" || void 0
            }, this.onDoRemoveAllSubcomponents, this.backchannel);
            this.actionsForNamespace = true;
            break;
          case "component":
            label = (params_.selectedNamespaceModel.____label != null) && params_.selectedNamespaceModel.____label || "<no label provided>";
            this.callbackLinkRequestRemoveComponent = new ONMjs.observers.helpers.CallbackLinkModelView("", "Remove " + label, void 0, void 0, {
              styleClass: "classONMjsActionButtonRemove"
            }, this.onClickRemoveComponent, this.backchannel);
            this.callbackLinkRemoveComponent = new ONMjs.observers.helpers.CallbackLinkModelView("", "Proceed with Remove", params_.selectedAddress, params_.cachedAddressStore, {
              styleClass: "classONMjsActionButtonConfirm"
            }, this.onDoRemoveComponent, this.backchannel);
            this.actionsForNamespace = true;
            break;
        }
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceActions construction failure: " + exception;
      }
    }

    return SelectedNamespaceActionsModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceActionsViewModel", (function() {
    return "<span data-bind=\"if: actionsForNamespace\">\n<div class=\"classONMjsSelectedNamespaceSectionTitle\">\n    Actions:\n</div>\n<div class=\"classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceActions\">\n    <span data-bind=\"if: actionsForNamespace\">\n        <div>\n            <span data-bind=\"if: callbackLinkAddSubcomponent\">\n                <span data-bind=\"with: callbackLinkAddSubcomponent\">\n                    <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                </span>\n            </span>\n            <span data-bind=\"if: callbackLinkRequestRemoveAllSubcomponents\">\n                <span data-bind=\"with: callbackLinkRequestRemoveAllSubcomponents\">\n                    <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                </span>\n            </span>\n            <span data-bind=\"if: callbackLinkRequestRemoveComponent\">\n                <span data-bind=\"with: callbackLinkRequestRemoveComponent\">\n                    <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                </span>\n            </span>\n\n            <span data-bind=\"if: showConfirmRemove\">\n                <div class=\"classONMjsActionConfirmation\">\n                    Please confirm <strong><span data-bind=\"text: callbackLinkRequestRemoveComponent.label\"></span></span></strong> request.<br><br>\n                    <span data-bind=\"with: callbackLinkCancelActionRequest\">\n                        <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                    </span>\n                    <span data-bind=\"with: callbackLinkRemoveComponent\">\n                        <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                    </span>\n                </div>\n            </span>\n\n            <span data-bind=\"if: showConfirmRemoveAll\">\n                <div class=\"classONMjsActionConfirmation\">\n                    Please confirm <strong><span data-bind=\"text: callbackLinkRequestRemoveAllSubcomponents.label\"></span></span></strong> request.<br><br>\n                    <span data-bind=\"with: callbackLinkCancelActionRequest\">\n                        <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                    </span>\n                    <span data-bind=\"with: callbackLinkRemoveAllSubcomponents\">\n                        <span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span>\n                    </span>\n                </div>\n            </span>\n\n        </div>\n    </span>\n    <span data-bind=\"ifnot: actionsForNamespace\"><i>No actions defined for this namespace.</i></span>\n</div>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceChildrenModelView = (function() {

    function SelectedNamespaceChildrenModelView(params_) {
      var index,
        _this = this;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.childModelViews = [];
        index = 0;
        params_.selectedAddress.visitChildAddresses(function(address_) {
          var childNamespace, label, prefix;
          if (address_.getModel().namespaceType !== "extensionPoint") {
            childNamespace = params_.cachedAddressStore.referenceStore.openNamespace(address_);
            prefix = "" + (index++ + 1) + ": ";
            label = "" + (childNamespace.getResolvedLabel()) + "<br>";
            return _this.childModelViews.push(new ONMjs.observers.helpers.AddressSelectionLinkModelView(prefix, label, address_, params_.cachedAddressStore, void 0, _this.backchannel));
          }
        });
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceChildrenModelView failure: " + exception;
      }
    }

    return SelectedNamespaceChildrenModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceChildrenViewModel", (function() {
    return "<span data-bind=\"if: childModelViews.length\">\n    <div class=\"classONMjsSelectedNamespaceSectionTitle\">Child Namespaces (<span data-bind=\"text: childModelViews.length\"></span>):</div>\n    <div class=\"classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceChildren\">\n        <span data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel', foreach: childModelViews }\"></span>\n    </div>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceCollectionModelView = (function() {

    function SelectedNamespaceCollectionModelView(params_) {
      var index, label, semanticBindings,
        _this = this;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.subcomponentModelViews = [];
        label = params_.selectedNamespaceModel.____label;
        this.namespaceLabel = (label != null) && label || "<no label provided>";
        semanticBindings = params_.cachedAddressStore.referenceStore.model.getSemanticBindings();
        index = 0;
        params_.selectedNamespace.visitExtensionPointSubcomponents(function(address__) {
          var prefix, subcomponentNamespace;
          subcomponentNamespace = params_.cachedAddressStore.referenceStore.openNamespace(address__);
          prefix = "" + (index++ + 1) + ": ";
          label = "" + (subcomponentNamespace.getResolvedLabel()) + "<br>";
          return _this.subcomponentModelViews.push(new ONMjs.observers.helpers.AddressSelectionLinkModelView(prefix, label, address__, params_.cachedAddressStore, void 0, _this.backchannel));
        });
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceCollectionModelView failure: " + exception;
      }
    }

    return SelectedNamespaceCollectionModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceCollectionViewModel", (function() {
    return "<span data-bind=\"if: subcomponentModelViews.length\">\n<div class=\"classONMjsSelectedNamespaceSectionTitle\">\n<span class=\"class=\"classONMjsAddressSelectionLinkLabelNoLink\" data-bind=\"html: namespaceLabel\"></span>\nSubcomponents (<span data-bind=\"text: subcomponentModelViews.length\"></span>):\n</div>\n<div class=\"classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceCollection\">\n<span data-bind=\"ifnot: subcomponentModelViews.length\">\n<i><span class=\"classONMjsAddressSelectionLinkLabelNoLink\" data-bind=\"html: namespaceLabel\"></span> extension point is empty.</i>\n</span>\n<span data-bind=\"if: subcomponentModelViews.length\">\n<span class=\"link\" data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel', foreach: subcomponentModelViews }\"></span>\n</span>\n</div>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceComponentModelView = (function() {

    function SelectedNamespaceComponentModelView(params_) {
      var componentAddress, componentNamespace, index,
        _this = this;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        componentAddress = params_.selectedAddress.createComponentAddress();
        componentNamespace = params_.cachedAddressStore.referenceStore.openNamespace(componentAddress);
        this.extensionPointModelViewArray = [];
        index = 0;
        componentAddress.visitExtensionPointAddresses(function(address_) {
          var extensionPointNamespace, label, noLinkFlag, prefix, subcomponentCount;
          noLinkFlag = address_.isEqual(params_.selectedAddress);
          extensionPointNamespace = params_.cachedAddressStore.referenceStore.openNamespace(address_);
          prefix = void 0;
          if (index++) {
            prefix = " &bull; ";
          }
          label = "" + (extensionPointNamespace.getResolvedLabel());
          subcomponentCount = Encapsule.code.lib.js.dictionaryLength(extensionPointNamespace.data());
          label += " (" + subcomponentCount + ")";
          return _this.extensionPointModelViewArray.push(new ONMjs.observers.helpers.AddressSelectionLinkModelView(prefix, label, address_, params_.cachedAddressStore, {
            noLink: noLinkFlag
          }, _this.backchannel));
        });
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceComponentModelView failure: " + exception;
      }
    }

    return SelectedNamespaceComponentModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceComponentViewModel", (function() {
    return "\n<span data-bind=\"if: extensionPointModelViewArray.length\">\n    <div class=\"classONMjsSelectedNamespaceSectionTitle\">\n        Component Extension Points (<span data-bind=\"text: extensionPointModelViewArray.length\"></span>):\n    </div>\n    <span data-bind=\"ifnot: extensionPointModelViewArray.length\"><i>Extension point contains no subcomponents.</i></span>\n    <span data-bind=\"if: extensionPointModelViewArray.length\">\n    <div class=\"classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceComponent\">\n        <span data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel', foreach: extensionPointModelViewArray }\"></span>\n    </div>\n    </span>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.helpers = (ONMjs.observers.helpers != null) && ONMjs.observers.helpers || (ONMjs.observers.helpers = {});

  ONMjs.observers.helpers.AddressSelectionLinkModelView = (function() {

    function AddressSelectionLinkModelView(prefix_, label_, address_, selectorStore_, options_, backchannel_) {
      var options,
        _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.prefix = (prefix_ != null) && prefix_ || "";
        this.label = (label_ != null) && label_ || "<no label provided>";
        this.address = (address_ != null) && address_ && address_.clone() || (function() {
          throw "Missing address input parameter.";
        })();
        this.selectorStore = (selectorStore_ != null) && selectorStore_ || (function() {
          throw "Missing selector store input parameter.";
        })();
        options = (options_ != null) && options_ || {};
        this.optionsNoLink = (options.noLink != null) && options.noLink || false;
        this.onClick = function() {
          try {
            return _this.selectorStore.setAddress(_this.address);
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.helpers.AddressSelectionLinkModelView.onClick failure: " + exception);
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.helpers.AddressSelectionLinkModelView failure: " + exception;
      }
    }

    return AddressSelectionLinkModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_AddressSelectionLinkViewModel", (function() {
    return "<span data-bind=\"if: prefix\"><span class=\"classONMjsAddressSelectionLinkPrefix\" data-bind=\"html: prefix\"></span></span><span data-bind=\"ifnot: optionsNoLink\"><span class=\"classONMjsAddressSelectionLinkLabel classONMjsMouseOverPointer\" data-bind=\"html: label, click: onClick\"></span></span><span data-bind=\"if: optionsNoLink\"><span class=\"classONMjsAddressSelectionLinkLabelNoLink\" data-bind=\"html: label\"></span></span>";
  }));

  ONMjs.observers.helpers.CallbackLinkModelView = (function() {

    function CallbackLinkModelView(prefix_, label_, address_, selectorStore_, options_, callback_, backchannel_) {
      var _this = this;
      try {
        this.backchannel = (backchannel_ != null) && backchannel_ || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.prefix = (prefix_ != null) && prefix_ || "";
        this.label = (label_ != null) && label_ || "<no label provided>";
        this.address = (address_ != null) && address_.clone() || void 0;
        this.selectorStore = (selectorStore_ != null) && selectorStore_ || void 0;
        this.options = (options_ != null) && options_ || {};
        this.optionsNoLink = (this.options.noLink != null) && this.options.noLink || false;
        this.optionsStyleClass = (this.options.styleClass != null) && this.options.styleClass || void 0;
        this.callback = callback_;
        this.onClick = function() {
          try {
            if (!((_this.callback != null) && _this.callback)) {
              throw "Internal error: Did you construct this callback link with a valid callback function?";
            }
            return _this.callback(_this.prefix, _this.label, _this.address, _this.selectorStore, _this.options);
          } catch (exception) {
            return _this.backchannel.error("ONMjs.observers.helpers.CallbackLinkModelView.onClick failure: " + exception);
          }
        };
      } catch (exception) {
        throw "ONMjs.observers.helpers.CallbackLinkModelView failure: " + exception;
      }
    }

    return CallbackLinkModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_CallbackLinkViewModel", (function() {
    return "<span class=\"classONMjsCallbackLink\">\n    <span data-bind=\"if: prefix\"><span class=\"prefix\" data-bind=\"html: prefix\"></span></span>\n    <span data-bind=\"ifnot: optionsNoLink\">\n        <span class=\"link classONMjsMouseOverPointer\" data-bind=\"html: label, click: onClick, css: optionsStyleClass\"></span>\n    </span>\n    <span data-bind=\"if: optionsNoLink\">\n        <span class=\"nolink\" data-bind=\"html: label, css: optionsStyleClass\"></span>\n    </span>\n</span>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView = (function() {

    function SelectedNamespaceImmutablePropertiesModelView(params_) {
      var dataReference, members, name, namespaceDeclarationImmutable, namespaceModelProperties, propertyDescriptor;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.propertyModelViews = [];
        namespaceModelProperties = params_.selectedAddress.getPropertiesModel();
        if (!((namespaceModelProperties != null) && namespaceModelProperties)) {
          throw "Cannot resolve namespace properties declaration for selection.";
        }
        namespaceDeclarationImmutable = (namespaceModelProperties.userImmutable != null) && namespaceModelProperties.userImmutable || void 0;
        if (!((namespaceDeclarationImmutable != null) && namespaceDeclarationImmutable)) {
          return;
        }
        dataReference = params_.selectedNamespace.data();
        for (name in namespaceDeclarationImmutable) {
          members = namespaceDeclarationImmutable[name];
          propertyDescriptor = {
            immutable: true,
            declaration: {
              property: name,
              members: members
            },
            store: {
              value: dataReference[name]
            }
          };
          this.propertyModelViews.push(propertyDescriptor);
        }
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView failure: " + exception;
      }
    }

    return SelectedNamespaceImmutablePropertiesModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceImmutablePropertiesViewModel", (function() {
    return "<div class=\"classONMjsSelectedNamespaceSectionTitle\">\n    Immutable Properties (<span data-bind=\"text: propertyModelViews.length\"></span>):\n</div>\n<div class=\"classONMjsSelectedNamespaceSectionCommon\">\n    <span data-bind=\"if: propertyModelViews.length\">\n        <div class=\"classONMjsSelectedNamespacePropertiesCommon classONMjsSelectedNamespacePropertiesImmutable\">\n            <span data-bind=\"foreach: propertyModelViews\">\n                <div class=\"name\"><span class=\"immutable\" data-bind=\"text: declaration.property\"></span></div>\n                <div class=\"type\" data-bind=\"text: declaration.members.____type\"></div>\n                <div style=\"clear: both;\" />\n                <span data-bind=\"if: declaration.members.____description\">\n                    <div class=\"description\" data-bind=\"text: declaration.members.____description\"></div>\n                </span>\n                <div class=\"value\"><span class=\"immutable\" data-bind=\"text: store.value\"></span></div>\n                <div style=\"clear: both;\" />\n            </span>\n        </div>\n    </span>\n    <span data-bind=\"ifnot: propertyModelViews.length\">\n        <i>This namespace has no immutable properties.</i>\n    </span>\n</div>";
  }));

  ONMjs.observers.SelectedNamespaceMutablePropertiesModelView = (function() {

    function SelectedNamespaceMutablePropertiesModelView(params_) {
      var label, members, name, namespaceDeclarationMutable, namespaceModelProperties, propertyModelView, type,
        _this = this;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.propertyModelViews = [];
        this.namespace = params_.selectedNamespace;
        namespaceModelProperties = params_.selectedAddress.getPropertiesModel();
        if (!((namespaceModelProperties != null) && namespaceModelProperties)) {
          throw "Cannot resolve namespace properties declaration for selection.";
        }
        namespaceDeclarationMutable = (namespaceModelProperties.userMutable != null) && namespaceModelProperties.userMutable || void 0;
        if (!((namespaceDeclarationMutable != null) && namespaceDeclarationMutable)) {
          return;
        }
        this.dataReference = params_.selectedNamespace.data();
        this.onClickUpdateProperties = function(prefix_, label_, addres_, selectorStore_, options_) {
          var propertiesUpdated, propertyModelView, valueEdit, _i, _len, _ref;
          try {
            propertiesUpdated = false;
            _ref = _this.propertyModelViews;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              propertyModelView = _ref[_i];
              valueEdit = propertyModelView.store.valueEdit();
              if (propertyModelView.store.value !== valueEdit) {
                _this.dataReference[propertyModelView.declaration.property] = valueEdit;
                propertiesUpdated = true;
              }
            }
            if (propertiesUpdated) {
              return _this.namespace.update();
            }
          } catch (exception) {
            throw "ONMjs.observer.SelectedNamespaceMutablePropertiesModelView.onClickUpdateProperties failure: " + exception;
          }
        };
        label = (params_.selectedNamespaceModel.____label != null) && params_.selectedNamespaceModel.____label || "<no label defined>";
        this.updateLinkModelView = new ONMjs.observers.helpers.CallbackLinkModelView("", "Apply " + label + " Edit", void 0, void 0, {
          styleClass: "classONMjsActionButtonConfirm"
        }, this.onClickUpdateProperties, this.backchannel);
        this.onClickDiscardPropertyEdits = function(prefix_, label_, address_, selectorStore_, options_) {
          var propertyModelView, _i, _len, _ref, _results;
          try {
            _ref = _this.propertyModelViews;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              propertyModelView = _ref[_i];
              _results.push(propertyModelView.store.valueEdit(propertyModelView.store.value));
            }
            return _results;
          } catch (exception) {
            throw "ONMjs.observer.SelectedNamespaceMutablePropertiesModelView.onClickDiscardPropertyEdits failure: " + exception;
          }
        };
        this.discardLinkModelView = new ONMjs.observers.helpers.CallbackLinkModelView("", "Discard " + label + " Edits", void 0, void 0, {
          styleClass: "classONMjsActionButtonCancel"
        }, this.onClickDiscardPropertyEdits, this.backchannel);
        for (name in namespaceDeclarationMutable) {
          members = namespaceDeclarationMutable[name];
          propertyModelView = {
            immutable: false,
            declaration: {
              property: name,
              members: members
            },
            store: {
              value: this.dataReference[name],
              valueEdit: ko.observable(this.dataReference[name])
            },
            viewModelTemplate: void 0
          };
          type = (members.____type != null) && members.____type || "string";
          switch (type) {
            case "enum":
              if (!((members.____options != null) && members.____options && (members.____options.length != null) && members.____options.length)) {
                throw "Mutable property of type 'enum' must specify an options list via ____options array of string(s).";
              }
              propertyModelView.viewModelTemplate = "idKoTemplate_MutableSelectProperty";
              break;
            default:
              propertyModelView.viewModelTemplate = "idKoTemplate_MutableStringProperty";
              break;
          }
          this.propertyModelViews.push(propertyModelView);
        }
        this.propertiesUpdated = ko.computed(function() {
          var propertiesUpdated, valueEdit, _i, _len, _ref;
          propertiesUpdated = false;
          _ref = _this.propertyModelViews;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            propertyModelView = _ref[_i];
            valueEdit = propertyModelView.store.valueEdit();
            if (propertyModelView.store.value !== valueEdit) {
              propertiesUpdated = true;
            }
          }
          return propertiesUpdated;
        });
      } catch (exception) {
        throw "ONMjs.observers.SelectedNamespaceMutablePropertiesModelView failure: " + exception;
      }
    }

    return SelectedNamespaceMutablePropertiesModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_MutableStringProperty", (function() {
    return "<div type=\"text\" class=\"value\" contentEditable=\"true\" data-bind=\"editableText: store.valueEdit\"></div>";
  }));

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_MutableSelectProperty", (function() {
    return "<div class=\"select\"><select data-bind=\"value: store.valueEdit, options: declaration.members.____options\"></select></div>";
  }));

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceMutablePropertiesViewModel", (function() {
    return "<div class=\"classONMjsSelectedNamespaceSectionTitle\">\n    Mutable Properties (<span data-bind=\"text: propertyModelViews.length\"></span>):\n</div>\n<div class=\"classONMjsSelectedNamespaceSectionCommon\">\n    <span data-bind=\"if: propertyModelViews.length\">\n        <div class=\"classONMjsSelectedNamespacePropertiesCommon classONMjsSelectedNamespacePropertiesMutable\">\n            <span data-bind=\"foreach: propertyModelViews\">\n                <div class=\"name\" data-bind=\"text: declaration.property\"></div>\n                <div class=\"type\" data-bind=\"text: declaration.members.____type\"></div>\n                <div style=\"clear: both;\" />\n                <span data-bind=\"if: declaration.members.____description\">\n                    <div class=\"description\" data-bind=\"text: declaration.members.____description\"></div>\n                </span>\n                <!-- <div type=\"text\" class=\"value\" contentEditable=\"true\" data-bind=\"editableText: store.valueEdit\"></div> -->\n                <span data-bind=\"template: { name: viewModelTemplate }\"></span>\n            </span>\n            <span data-bind=\"if: propertiesUpdated\">\n                <div class=\"buttons\">\n                    <span data-bind=\"with: discardLinkModelView\"><span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span></span>\n                    <span data-bind=\"with: updateLinkModelView\"><span data-bind=\"template: { name: 'idKoTemplate_CallbackLinkViewModel' }\"></span></span>\n                </div>\n            </span>\n        </div>\n    </span>\n    <span data-bind=\"ifnot: propertyModelViews.length\">\n        <i>This namespace has no mutable properties.</i>\n    </span>\n</div>";
  }));

  /*
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
  */


  namespaceEncapsule = (typeof Encapsule !== "undefined" && Encapsule !== null) && Encapsule || (this.Encapsule = {});

  Encapsule.code = (Encapsule.code != null) && Encapsule.code || (this.Encapsule.code = {});

  Encapsule.code.lib = (Encapsule.code.lib != null) && Encapsule.code.lib || (this.Encapsule.code.lib = {});

  Encapsule.code.lib.onm = (Encapsule.code.lib.onm != null) && Encapsule.code.lib.onm || (this.Encapsule.code.lib.onm = {});

  ONMjs = Encapsule.code.lib.onm;

  ONMjs.observers = (ONMjs.observers != null) && ONMjs.observers || (ONMjs.observers = {});

  ONMjs.observers.SelectedNamespaceTitleModelView = (function() {

    function SelectedNamespaceTitleModelView(params_) {
      var componentAddress, componentDescriptor, componentLabelResolved, componentNamespace, componentPathId, componentSelector, displayComponent, displayExtensionPoint, extensionPointAddress, extensionPointLabel, extensionPointModel, label, namespaceType;
      try {
        this.backchannel = (params_.backchannel != null) && params_.backchannel || (function() {
          throw "Missing backchannel input parameter.";
        })();
        this.namespaceLabelResolved = params_.selectedNamespace.getResolvedLabel();
        this.namespaceDescription = (params_.selectedNamespaceModel.____description != null) && params_.selectedNamespaceModel.____description || "<no description provided>";
        displayComponent = false;
        componentPathId = void 0;
        componentSelector = void 0;
        componentLabelResolved = void 0;
        this.componentSuffixString = void 0;
        displayExtensionPoint = false;
        extensionPointLabel = void 0;
        this.contextLinkModelViewComponent = void 0;
        this.contextLinkModelViewExtensionPoint = void 0;
        componentAddress = void 0;
        componentDescriptor = void 0;
        extensionPointAddress = void 0;
        namespaceType = params_.selectedAddress.getModel().namespaceType;
        if (!(namespaceType === "root")) {
          displayComponent = true;
          if (params_.selectedNamespaceModel.namespaceType !== "component") {
            componentAddress = params_.selectedAddress.createComponentAddress();
          } else {
            extensionPointAddress = params_.selectedAddress.createParentAddress();
            componentAddress = extensionPointAddress.createComponentAddress();
          }
          componentNamespace = params_.objectStore.openNamespace(componentAddress);
          componentLabelResolved = componentNamespace.getResolvedLabel();
          this.componentSuffixString = (componentAddress.getModel().namespaceType !== "root" && ":") || "::";
          this.componentClickableLink = new ONMjs.observers.helpers.AddressSelectionLinkModelView("", componentLabelResolved, componentAddress, params_.cachedAddressStore, void 0, this.backchannel);
        }
        if (namespaceType === "component") {
          displayExtensionPoint = true;
          if (!((extensionPointAddress != null) && extensionPointAddress)) {
            extensionPointAddress = params_.selectedAddress.createParentAddress();
          }
          extensionPointModel = extensionPointAddress.getModel();
          label = (extensionPointModel.____label != null) && extensionPointModel.____label || "<no label defined>";
          this.extensionPointClickableLink = new ONMjs.observers.helpers.AddressSelectionLinkModelView("", label, extensionPointAddress, params_.cachedAddressStore, void 0, this.backchannel);
        }
        this.templateName = void 0;
        if (!displayComponent) {
          this.templateName = "idKoTemplate_SelectedNamespaceTitleRootViewModel";
        } else if (!displayExtensionPoint) {
          this.templateName = "idKoTemplate_SelectedNamespaceTitleExtensionPointViewModel";
        } else {
          this.templateName = "idKoTemplate_SelectedNamespaceTitleComponentViewModel";
        }
      } catch (exception) {
        throw "ONMjs.observers.ObjectModelNavigatorNamespaceTitle failure: " + exception;
      }
    }

    return SelectedNamespaceTitleModelView;

  })();

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleRootViewModel", (function() {
    return "<span class=\"selected\" data-bind=\"html: namespaceLabelResolved\"></span>";
  }));

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleExtensionPointViewModel", (function() {
    return "<span data-bind=\"with: componentClickableLink\"><span data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }\"></span></span>\n<span class=\"separator\" data-bind=\"html: componentSuffixString\"></span>\n<span class=\"selected\" data-bind=\"html: namespaceLabelResolved\"></span>";
  }));

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleComponentViewModel", (function() {
    return "<span data-bind=\"with: componentClickableLink\"><span data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }\"></span></span>\n<span class=\"separator\" data-bind=\"html: componentSuffixString\"></span>\n<span data-bind=\"with: extensionPointClickableLink\"><span data-bind=\"template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }\"></span></span>\n<span class=\"separator\"> / </span>\n<span class=\"selected\" data-bind=\"html: namespaceLabelResolved\"></span>";
  }));

  Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleViewModel", (function() {
    return "<div class=\"classONMjsSelectedNamespaceTitle\">\n    <span class=\"classONMjsSelectedNamespaceTitleLinks\" data-bind=\"template: { name: function () { return templateName; } }\" ></span>\n    <div class=\"description\" data-bind=\"html: namespaceDescription\"></div>\n</div>";
  }));

}).call(this);
