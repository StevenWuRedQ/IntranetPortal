var check_lib = true;
var Errors = {getHTTPObject:function() {
  var http = null;
  if (typeof ActiveXObject != "undefined") {
    try {
      http = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        http = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
        http = false;
      }
    }
  } else {
    if (window.XMLHttpRequest) {
      try {
        http = new XMLHttpRequest;
      } catch (e) {
        http = null;
      }
    }
  }
  return http;
}, load:function(srcUrl, callback, method) {
  var http = this.getHTTPObject();
  if (!http || !srcUrl) {
    return;
  }
  var url = srcUrl;
  url += url.indexOf("?") + 1 ? "&" : "?";
  url += "uid=" + (new Date).getTime();
  var parameters = null;
  if (method == "POST") {
    var parts = url.split("?");
    url = parts[0];
    parameters = parts[1];
  }
  http.open(method, url, true);
  if (method == "POST") {
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", parameters.length);
    http.setRequestHeader("Connection", "close");
  }
  http.onreadystatechange = function() {
    if (http.readyState == 4) {
      if (http.status == 200) {
        var result = "";
        if (http.responseText) {
          result = http.responseText;
        }
        if (callback) {
          callback(result);
        }
      }
    }
  };
  http.send(parameters);
}, handler:function(msg, url, line) {
  var error = '<b style="color:#ff0066">JavaScript Error</b>\n<br/>\n' + "Message: " + msg + "\n<br>\n" + "Url: " + url + "\n<br>\n" + "Line: " + line + "\n<br>\n";
  var error_alert = "JavaScript Error\n" + "Message: " + msg + "\n\n" + "Url: " + url + "\n\n" + "Line: " + line + "\n\n";
  if (navigator && navigator.userAgent) {
    error = error + "userAgent: " + navigator.userAgent;
  }
  var dialog = document.createElement("div");
  dialog.className = "errordialog";
  dialog.innerHTML = error;
  if (document && (document.body && document.body.appendChild)) {
    document.body.appendChild(dialog);
  } else {
    alert(error_alert);
  }
  Errors.post_error({msg:msg, url:url, line:line, userAgent:navigator.userAgent});
  return true;
}, post_error:function(params) {
  var url = "handlers/clientError.axd?";
  for (var i in params) {
    if (params.hasOwnProperty(i)) {
      url += i + "=" + encodeURI(params[i]) + "&";
    }
  }
  this.load(url, null, "POST");
}};
(function() {
  this.MooTools = {version:"1.4.5", build:"ab8ea8824dc3b24b6666867a2c4ed58ebb762cf0"};
  var typeOf = this.typeOf = function(item) {
    if (item == null) {
      return "null";
    }
    if (item.$family != null) {
      return item.$family();
    }
    if (item.nodeName) {
      if (item.nodeType == 1) {
        return "element";
      }
      if (item.nodeType == 3) {
        return/\S/.test(item.nodeValue) ? "textnode" : "whitespace";
      }
    } else {
      if (typeof item.length == "number") {
        if (item.callee) {
          return "arguments";
        }
        if ("item" in item) {
          return "collection";
        }
      }
    }
    return typeof item;
  };
  var instanceOf = this.instanceOf = function(item, object) {
    if (item == null) {
      return false;
    }
    var constructor = item.$constructor || item.constructor;
    while (constructor) {
      if (constructor === object) {
        return true;
      }
      constructor = constructor.parent;
    }
    if (!item.hasOwnProperty) {
      return false;
    }
    return item instanceof object;
  };
  var Function = this.Function;
  var enumerables = true;
  for (var i in{toString:1}) {
    enumerables = null;
  }
  if (enumerables) {
    enumerables = ["hasOwnProperty", "valueOf", "isPrototypeOf", "propertyIsEnumerable", "toLocaleString", "toString", "constructor"];
  }
  Function.prototype.overloadSetter = function(usePlural) {
    var self = this;
    return function(a, b) {
      if (a == null) {
        return this;
      }
      if (usePlural || typeof a != "string") {
        for (var k in a) {
          self.call(this, k, a[k]);
        }
        if (enumerables) {
          for (var i = enumerables.length;i--;) {
            k = enumerables[i];
            if (a.hasOwnProperty(k)) {
              self.call(this, k, a[k]);
            }
          }
        }
      } else {
        self.call(this, a, b);
      }
      return this;
    };
  };
  Function.prototype.overloadGetter = function(usePlural) {
    var self = this;
    return function(a) {
      var args, result;
      if (typeof a != "string") {
        args = a;
      } else {
        if (arguments.length > 1) {
          args = arguments;
        } else {
          if (usePlural) {
            args = [a];
          }
        }
      }
      if (args) {
        result = {};
        for (var i = 0;i < args.length;i++) {
          result[args[i]] = self.call(this, args[i]);
        }
      } else {
        result = self.call(this, a);
      }
      return result;
    };
  };
  Function.prototype.extend = function(key, value) {
    this[key] = value;
  }.overloadSetter();
  Function.prototype.implement = function(key, value) {
    this.prototype[key] = value;
  }.overloadSetter();
  var slice = Array.prototype.slice;
  Function.from = function(item) {
    return typeOf(item) == "function" ? item : function() {
      return item;
    };
  };
  Array.from = function(item) {
    if (item == null) {
      return[];
    }
    return mooType.isEnumerable(item) && typeof item != "string" ? typeOf(item) == "array" ? item : slice.call(item) : [item];
  };
  Number.from = function(item) {
    var number = parseFloat(item);
    return isFinite(number) ? number : null;
  };
  String.from = function(item) {
    return item + "";
  };
  Function.implement({mHide:function() {
    this.$hidden = true;
    return this;
  }, protect:function() {
    this.$protected = true;
    return this;
  }});
  var mooType = this.mooType = this.mooType = function(name, object) {
    if (name) {
      var lower = name.toLowerCase();
      var typeCheck = function(item) {
        return typeOf(item) == lower;
      };
      mooType["is" + name] = typeCheck;
      if (object != null) {
        object.prototype.$family = function() {
          return lower;
        }.mHide();
      }
    }
    if (object == null) {
      return null;
    }
    object.extend(this);
    object.$constructor = mooType;
    object.prototype.$constructor = object;
    return object;
  };
  var toString = Object.prototype.toString;
  mooType.isEnumerable = function(item) {
    return item != null && (typeof item.length == "number" && toString.call(item) != "[object Function]");
  };
  var hooks = {};
  var hooksOf = function(object) {
    var type = typeOf(object.prototype);
    return hooks[type] || (hooks[type] = []);
  };
  var implement = function(name, method) {
    if (method && method.$hidden) {
      return;
    }
    var hooks = hooksOf(this);
    for (var i = 0;i < hooks.length;i++) {
      var hook = hooks[i];
      if (typeOf(hook) == "type") {
        implement.call(hook, name, method);
      } else {
        hook.call(this, name, method);
      }
    }
    var previous = this.prototype[name];
    if (previous == null || !previous.$protected) {
      this.prototype[name] = method;
    }
    if (this[name] == null && typeOf(method) == "function") {
      extend.call(this, name, function(item) {
        return method.apply(item, slice.call(arguments, 1));
      });
    }
  };
  var extend = function(name, method) {
    if (method && method.$hidden) {
      return;
    }
    var previous = this[name];
    if (previous == null || !previous.$protected) {
      this[name] = method;
    }
  };
  mooType.implement({implement:implement.overloadSetter(), extend:extend.overloadSetter(), alias:function(name, existing) {
    implement.call(this, name, this.prototype[existing]);
  }.overloadSetter(), mirror:function(hook) {
    hooksOf(this).push(hook);
    return this;
  }});
  new mooType("mooType", mooType);
  var force = function(name, object, methods) {
    var isType = object != Object, prototype = object.prototype;
    if (isType) {
      object = new mooType(name, object);
    }
    for (var i = 0, l = methods.length;i < l;i++) {
      var key = methods[i], generic = object[key], proto = prototype[key];
      if (generic) {
        generic.protect();
      }
      if (isType && proto) {
        object.implement(key, proto.protect());
      }
    }
    if (isType) {
      var methodsEnumerable = prototype.propertyIsEnumerable(methods[0]);
      object.forEachMethod = function(fn) {
        if (!methodsEnumerable) {
          for (var i = 0, l = methods.length;i < l;i++) {
            fn.call(prototype, prototype[methods[i]], methods[i]);
          }
        }
        for (var key in prototype) {
          fn.call(prototype, prototype[key], key);
        }
      };
    }
    return force;
  };
  force("String", String, ["charAt", "charCodeAt", "concat", "indexOf", "lastIndexOf", "match", "quote", "replace", "search", "slice", "split", "substr", "substring", "trim", "toLowerCase", "toUpperCase"])("Array", Array, ["pop", "push", "reverse", "shift", "sort", "splice", "unshift", "concat", "join", "slice", "indexOf", "lastIndexOf", "filter", "forEach", "every", "map", "some", "reduce", "reduceRight"])("Number", Number, ["toExponential", "toFixed", "toLocaleString", "toPrecision"])("Function", 
  Function, ["apply", "call", "bind"])("RegExp", RegExp, ["exec", "test"])("Object", Object, ["create", "defineProperty", "defineProperties", "keys", "getPrototypeOf", "getOwnPropertyDescriptor", "getOwnPropertyNames", "preventExtensions", "isExtensible", "seal", "isSealed", "freeze", "isFrozen"])("Date", Date, ["now"]);
  Object.extend = extend.overloadSetter();
  Date.extend("now", function() {
    return+new Date;
  });
  new mooType("Boolean", Boolean);
  Number.prototype.$family = function() {
    return isFinite(this) ? "number" : "null";
  }.mHide();
  Number.extend("random", function(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  });
  var hasOwnProperty = Object.prototype.hasOwnProperty;
  Object.extend("forEach", function(object, fn, bind) {
    for (var key in object) {
      if (hasOwnProperty.call(object, key)) {
        fn.call(bind, object[key], key, object);
      }
    }
  });
  Object.each = Object.forEach;
  Array.implement({forEach:function(fn, bind) {
    for (var i = 0, l = this.length;i < l;i++) {
      if (i in this) {
        fn.call(bind, this[i], i, this);
      }
    }
  }, each:function(fn, bind) {
    Array.forEach(this, fn, bind);
    return this;
  }});
  var cloneOf = function(item) {
    switch(typeOf(item)) {
      case "array":
        return item.clone();
      case "object":
        return Object.clone(item);
      default:
        return item;
    }
  };
  Array.implement("clone", function() {
    var i = this.length, clone = new Array(i);
    while (i--) {
      clone[i] = cloneOf(this[i]);
    }
    return clone;
  });
  var mergeOne = function(source, key, current) {
    switch(typeOf(current)) {
      case "object":
        if (typeOf(source[key]) == "object") {
          Object.merge(source[key], current);
        } else {
          source[key] = Object.clone(current);
        }
        break;
      case "array":
        source[key] = current.clone();
        break;
      default:
        source[key] = current;
    }
    return source;
  };
  Object.extend({merge:function(source, k, v) {
    if (typeOf(k) == "string") {
      return mergeOne(source, k, v);
    }
    for (var i = 1, l = arguments.length;i < l;i++) {
      var object = arguments[i];
      for (var key in object) {
        mergeOne(source, key, object[key]);
      }
    }
    return source;
  }, clone:function(object) {
    var clone = {};
    for (var key in object) {
      clone[key] = cloneOf(object[key]);
    }
    return clone;
  }, append:function(original) {
    for (var i = 1, l = arguments.length;i < l;i++) {
      var extended = arguments[i] || {};
      for (var key in extended) {
        original[key] = extended[key];
      }
    }
    return original;
  }});
  ["Object", "WhiteSpace", "TextNode", "Collection", "Arguments"].each(function(name) {
    new mooType(name);
  });
  var UID = Date.now();
  String.extend("uniqueID", function() {
    return(UID++).toString(36);
  });
})();
Array.implement({every:function(fn, bind) {
  for (var i = 0, l = this.length >>> 0;i < l;i++) {
    if (i in this && !fn.call(bind, this[i], i, this)) {
      return false;
    }
  }
  return true;
}, filter:function(fn, bind) {
  var results = [];
  for (var value, i = 0, l = this.length >>> 0;i < l;i++) {
    if (i in this) {
      value = this[i];
      if (fn.call(bind, value, i, this)) {
        results.push(value);
      }
    }
  }
  return results;
}, indexOf:function(item, from) {
  var length = this.length >>> 0;
  for (var i = from < 0 ? Math.max(0, length + from) : from || 0;i < length;i++) {
    if (this[i] === item) {
      return i;
    }
  }
  return-1;
}, map:function(fn, bind) {
  var length = this.length >>> 0, results = Array(length);
  for (var i = 0;i < length;i++) {
    if (i in this) {
      results[i] = fn.call(bind, this[i], i, this);
    }
  }
  return results;
}, some:function(fn, bind) {
  for (var i = 0, l = this.length >>> 0;i < l;i++) {
    if (i in this && fn.call(bind, this[i], i, this)) {
      return true;
    }
  }
  return false;
}, clean:function() {
  return this.filter(function(item) {
    return item != null;
  });
}, invoke:function(methodName) {
  var args = Array.slice(arguments, 1);
  return this.map(function(item) {
    return item[methodName].apply(item, args);
  });
}, associate:function(keys) {
  var obj = {}, length = Math.min(this.length, keys.length);
  for (var i = 0;i < length;i++) {
    obj[keys[i]] = this[i];
  }
  return obj;
}, link:function(object) {
  var result = {};
  for (var i = 0, l = this.length;i < l;i++) {
    for (var key in object) {
      if (object[key](this[i])) {
        result[key] = this[i];
        delete object[key];
        break;
      }
    }
  }
  return result;
}, contains:function(item, from) {
  return this.indexOf(item, from) != -1;
}, append:function(array) {
  this.push.apply(this, array);
  return this;
}, getLast:function() {
  return this.length ? this[this.length - 1] : null;
}, getRandom:function() {
  return this.length ? this[Number.random(0, this.length - 1)] : null;
}, include:function(item) {
  if (!this.contains(item)) {
    this.push(item);
  }
  return this;
}, combine:function(array) {
  for (var i = 0, l = array.length;i < l;i++) {
    this.include(array[i]);
  }
  return this;
}, erase:function(item) {
  for (var i = this.length;i--;) {
    if (this[i] === item) {
      this.splice(i, 1);
    }
  }
  return this;
}, empty:function() {
  this.length = 0;
  return this;
}, flatten:function() {
  var array = [];
  for (var i = 0, l = this.length;i < l;i++) {
    var type = typeOf(this[i]);
    if (type == "null") {
      continue;
    }
    array = array.concat(type == "array" || (type == "collection" || (type == "arguments" || instanceOf(this[i], Array))) ? Array.flatten(this[i]) : this[i]);
  }
  return array;
}, pick:function() {
  for (var i = 0, l = this.length;i < l;i++) {
    if (this[i] != null) {
      return this[i];
    }
  }
  return null;
}, hexToRgb:function(array) {
  if (this.length != 3) {
    return null;
  }
  var rgb = this.map(function(value) {
    if (value.length == 1) {
      value += value;
    }
    return value.toInt(16);
  });
  return array ? rgb : "rgb(" + rgb + ")";
}, rgbToHex:function(array) {
  if (this.length < 3) {
    return null;
  }
  if (this.length == 4 && (this[3] == 0 && !array)) {
    return "transparent";
  }
  var hex = [];
  for (var i = 0;i < 3;i++) {
    var bit = (this[i] - 0).toString(16);
    hex.push(bit.length == 1 ? "0" + bit : bit);
  }
  return array ? hex : "#" + hex.join("");
}});
String.implement({test:function(regex, params) {
  return(typeOf(regex) == "regexp" ? regex : new RegExp("" + regex, params)).test(this);
}, contains:function(string, separator) {
  return separator ? (separator + this + separator).indexOf(separator + string + separator) > -1 : String(this).indexOf(string) > -1;
}, trim:function() {
  return String(this).replace(/^\s+|\s+$/g, "");
}, clean:function() {
  return String(this).replace(/\s+/g, " ").trim();
}, camelCase:function() {
  return String(this).replace(/-\D/g, function(match) {
    return match.charAt(1).toUpperCase();
  });
}, hyphenate:function() {
  return String(this).replace(/[A-Z]/g, function(match) {
    return "-" + match.charAt(0).toLowerCase();
  });
}, capitalize:function() {
  return String(this).replace(/\b[a-z]/g, function(match) {
    return match.toUpperCase();
  });
}, escapeRegExp:function() {
  return String(this).replace(/([-.*+?^${}()|[\]\/\\])/g, "\\$1");
}, toInt:function(base) {
  return parseInt(this, base || 10);
}, toFloat:function() {
  return parseFloat(this);
}, hexToRgb:function(array) {
  var hex = String(this).match(/^#?(\w{1,2})(\w{1,2})(\w{1,2})$/);
  return hex ? hex.slice(1).hexToRgb(array) : null;
}, rgbToHex:function(array) {
  var rgb = String(this).match(/\d{1,3}/g);
  return rgb ? rgb.rgbToHex(array) : null;
}, substitute:function(object, regexp) {
  return String(this).replace(regexp || /\\?\{([^{}]+)\}/g, function(match, name) {
    if (match.charAt(0) == "\\") {
      return match.slice(1);
    }
    return object[name] != null ? object[name] : "";
  });
}});
Function.extend({attempt:function() {
  for (var i = 0, l = arguments.length;i < l;i++) {
    try {
      return arguments[i]();
    } catch (e) {
    }
  }
  return null;
}});
Function.implement({attempt:function(args, bind) {
  try {
    return this.apply(bind, Array.from(args));
  } catch (e) {
  }
  return null;
}, bind:function(that) {
  var self = this, args = arguments.length > 1 ? Array.slice(arguments, 1) : null, F = function() {
  };
  var bound = function() {
    var context = that, length = arguments.length;
    if (this instanceof bound) {
      F.prototype = self.prototype;
      context = new F;
    }
    var result = !args && !length ? self.call(context) : self.apply(context, args && length ? args.concat(Array.slice(arguments)) : args || arguments);
    return context == that ? result : context;
  };
  return bound;
}, pass:function(args, bind) {
  var self = this;
  if (args != null) {
    args = Array.from(args);
  }
  return function() {
    return self.apply(bind, args || arguments);
  };
}, delay:function(delay, bind, args) {
  return setTimeout(this.pass(args == null ? [] : args, bind), delay);
}, periodical:function(periodical, bind, args) {
  return setInterval(this.pass(args == null ? [] : args, bind), periodical);
}});
Number.implement({limit:function(min, max) {
  return Math.min(max, Math.max(min, this));
}, round:function(precision) {
  precision = Math.pow(10, precision || 0).toFixed(precision < 0 ? -precision : 0);
  return Math.round(this * precision) / precision;
}, times:function(fn, bind) {
  for (var i = 0;i < this;i++) {
    fn.call(bind, i, this);
  }
}, toFloat:function() {
  return parseFloat(this);
}, toInt:function(base) {
  return parseInt(this, base || 10);
}});
Number.alias("each", "times");
(function(math) {
  var methods = {};
  math.each(function(name) {
    if (!Number[name]) {
      methods[name] = function() {
        return Math[name].apply(null, [this].concat(Array.from(arguments)));
      };
    }
  });
  Number.implement(methods);
})(["abs", "acos", "asin", "atan", "atan2", "ceil", "cos", "exp", "floor", "log", "max", "min", "pow", "sin", "sqrt", "tan"]);
(function() {
  var Class = this.Class = new mooType("Class", function(params) {
    if (instanceOf(params, Function)) {
      params = {initialize:params};
    }
    var newClass = function() {
      reset(this);
      if (newClass.$prototyping) {
        return this;
      }
      this.$caller = null;
      var value = this.initialize ? this.initialize.apply(this, arguments) : this;
      this.$caller = this.caller = null;
      return value;
    }.extend(this).implement(params);
    newClass.$constructor = Class;
    newClass.prototype.$constructor = newClass;
    newClass.prototype.parent = parent;
    return newClass;
  });
  var parent = function() {
    if (!this.$caller) {
      throw new Error('The method "parent" cannot be called.');
    }
    var name = this.$caller.$name, parent = this.$caller.$owner.parent, previous = parent ? parent.prototype[name] : null;
    if (!previous) {
      throw new Error('The method "' + name + '" has no parent.');
    }
    return previous.apply(this, arguments);
  };
  var reset = function(object) {
    for (var key in object) {
      var value = object[key];
      switch(typeOf(value)) {
        case "object":
          var F = function() {
          };
          F.prototype = value;
          object[key] = reset(new F);
          break;
        case "array":
          object[key] = value.clone();
          break;
      }
    }
    return object;
  };
  var wrap = function(self, key, method) {
    if (method.$origin) {
      method = method.$origin;
    }
    var wrapper = function() {
      if (method.$protected && this.$caller == null) {
        throw new Error('The method "' + key + '" cannot be called.');
      }
      var caller = this.caller, current = this.$caller;
      this.caller = current;
      this.$caller = wrapper;
      var result = method.apply(this, arguments);
      this.$caller = current;
      this.caller = caller;
      return result;
    }.extend({$owner:self, $origin:method, $name:key});
    return wrapper;
  };
  var implement = function(key, value, retain) {
    if (Class.Mutators.hasOwnProperty(key)) {
      value = Class.Mutators[key].call(this, value);
      if (value == null) {
        return this;
      }
    }
    if (typeOf(value) == "function") {
      if (value.$hidden) {
        return this;
      }
      this.prototype[key] = retain ? value : wrap(this, key, value);
    } else {
      Object.merge(this.prototype, key, value);
    }
    return this;
  };
  var getInstance = function(klass) {
    klass.$prototyping = true;
    var proto = new klass;
    delete klass.$prototyping;
    return proto;
  };
  Class.implement("implement", implement.overloadSetter());
  Class.Mutators = {Extends:function(parent) {
    this.parent = parent;
    this.prototype = getInstance(parent);
  }, Implements:function(items) {
    Array.from(items).each(function(item) {
      var instance = new item;
      for (var key in instance) {
        implement.call(this, key, instance[key], true);
      }
    }, this);
  }};
})();
(function($) {
  $.support.touch = "ontouchend" in document;
  if (!$.support.touch) {
    return;
  }
  var mouseProto = $.ui.mouse.prototype;
  var _mouseInit = mouseProto._mouseInit;
  var touchHandled;
  function simulateMouseEvent(event, simulatedType) {
    if (event.originalEvent.touches.length > 1) {
      return;
    }
    event.preventDefault();
    var t = event.originalEvent.changedTouches[0];
    var simulatedEvent = document.createEvent("MouseEvents");
    simulatedEvent.initMouseEvent(simulatedType, true, true, window, 1, t.screenX, t.screenY, t.clientX, t.clientY, false, false, false, false, 0, null);
    event.target.dispatchEvent(simulatedEvent);
  }
  mouseProto._touchStart = function(event) {
    var me = this;
    if (touchHandled || !me._mouseCapture(event.originalEvent.changedTouches[0])) {
      return;
    }
    touchHandled = true;
    me._touchMoved = false;
    simulateMouseEvent(event, "mouseover");
    simulateMouseEvent(event, "mousemove");
    simulateMouseEvent(event, "mousedown");
  };
  mouseProto._touchMove = function(event) {
    if (!touchHandled) {
      return;
    }
    this._touchMoved = true;
    simulateMouseEvent(event, "mousemove");
  };
  mouseProto._touchEnd = function(event) {
    if (!touchHandled) {
      return;
    }
    simulateMouseEvent(event, "mouseup");
    simulateMouseEvent(event, "mouseout");
    if (!this._touchMoved) {
      simulateMouseEvent(event, "click");
    }
    touchHandled = false;
  };
  mouseProto._mouseInit = function() {
    var me = this;
    me.element.bind("touchstart", $.proxy(me, "_touchStart")).bind("touchmove", $.proxy(me, "_touchMove")).bind("touchend", $.proxy(me, "_touchEnd"));
    _mouseInit.call(me);
  };
})(jQuery);
var _global_timer_ = null;
(function($) {
  $.fn.longClickContextMenu = function() {
    $(this).longclick(function(e) {
      var t = e.currentTarget;
      var o = $(e.currentTarget).offset();
      if (e.pageX - o.left > t.clientWidth) {
        return;
      }
      var element = $(e.target);
      element.contextMenu({x:e.clientX, y:e.clientY});
    });
  };
  var $_fn_click = $.fn.click;
  $.fn.click = function click(duration, handler) {
    if (!handler) {
      return $_fn_click.apply(this, arguments);
    }
    return $(this).bind(type, handler);
  };
  $.fn.longclick = function longclick() {
    var args = [].splice.call(arguments, 0), handler = args.pop(), duration = args.pop(), $this = $(this);
    return handler ? $this.click(duration, handler) : $this.trigger(type);
  };
  $.longclick = {duration:1E3};
  $.event.special.longclick = {setup:function(data, namespaces) {
    if (!/iphone|ipad|ipod/i.test(navigator.userAgent)) {
      $(this).bind(_mousedown_, schedule).bind([_mousemove_, _mouseup_, _mouseout_, _contextmenu_].join(" "), annul).bind(_click_, click);
    } else {
      touch_enabled(this).bind(_touchstart_, schedule).bind([_touchend_, _touchmove_, _touchcancel_].join(" "), annul).bind(_click_, click).css({WebkitUserSelect:"none"});
    }
  }, teardown:function(namespaces) {
    $(this).unbind(namespace);
  }};
  function touch_enabled(element) {
    $.each("touchstart touchmove touchend touchcancel".split(/ /), function bind(ix, it) {
      element.addEventListener(it, function trigger_jquery_event(event) {
        $(element).trigger(it);
      }, false);
    });
    return $(element);
  }
  function schedule(event) {
    if (_global_timer_) {
      return;
    }
    var element = this;
    var args = arguments;
    $(this).data(_fired_, false);
    _global_timer_ = setTimeout(scheduled, $.longclick.duration);
    function scheduled() {
      $(element).data(_fired_, true);
      event.type = type;
      jQuery.event.dispatch.apply(element, args);
    }
  }
  function annul(event) {
    if (_global_timer_) {
      clearTimeout(_global_timer_);
      _global_timer_ = null;
    }
  }
  function click(event) {
    if ($(this).data(_fired_)) {
      return event.stopImmediatePropagation() || false;
    }
  }
  var type = "longclick";
  var namespace = "." + type;
  var _mousedown_ = "mousedown" + namespace;
  var _click_ = "click" + namespace;
  var _mousemove_ = "mousemove" + namespace;
  var _mouseup_ = "mouseup" + namespace;
  var _mouseout_ = "mouseout" + namespace;
  var _contextmenu_ = "contextmenu" + namespace;
  var _touchstart_ = "touchstart" + namespace;
  var _touchend_ = "touchend" + namespace;
  var _touchmove_ = "touchmove" + namespace;
  var _touchcancel_ = "touchcancel" + namespace;
  var _duration_ = "duration" + namespace;
  var _timer_ = "timer" + namespace;
  var _fired_ = "fired" + namespace;
})(jQuery);
(function($) {
  $.fn.paginate = function(options) {
    var opts = $.extend({}, $.fn.paginate.defaults, options);
    return this.each(function() {
      $this = $(this);
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
      var selectedpage = o.start;
      $.fn.draw(o, $this, selectedpage);
    });
  };
  var outsidewidth_tmp = 0;
  var insidewidth = 0;
  var bName = navigator.appName;
  var bVer = navigator.appVersion;
  if (bVer.indexOf("MSIE 7.0") > 0) {
    var ver = "ie7"
  }
  $.fn.paginate.defaults = {count:5, start:12, display:5, border:true, border_color:"#fff", text_color:"#8cc59d", background_color:"black", border_hover_color:"#fff", text_hover_color:"#fff", background_hover_color:"#fff", rotate:true, images:true, mouse:"slide", onChange:function() {
    return false;
  }};
  $.fn.draw = function(o, obj, selectedpage) {
    if (o.display > o.count) {
      o.display = o.count;
    }
    $this.empty();
    if (o.images) {
      var spreviousclass = "jPag-sprevious-img";
      var previousclass = "jPag-previous-img";
      var snextclass = "jPag-snext-img";
      var nextclass = "jPag-next-img";
    } else {
      var spreviousclass = "jPag-sprevious";
      var previousclass = "jPag-previous";
      var snextclass = "jPag-snext";
      var nextclass = "jPag-next";
    }
    if (o.rotate) {
      var _rotleft = $("<div>&lt;</div>").button({icons:{primary:"ui-icon-carat-1-w"}, text:false})
    }
    $this.html('<div id="wrapper1">' + '<div id="wrapper2">' + '<div id="maincol">' + '<div id="leftcol"></div>' + '<div id="rightcol"></div>' + '<div id="centercol"></div>' + "</div>" + "</div>" + "</div>");
    var _divwrapleft = $("#leftcol").addClass("jPag-control-back");
    _divwrapleft.append(_rotleft);
    var _ulwrapdiv = $('<table cellpadding="0" cellspacing="0">').css("overflow", "hidden");
    var _ul = $("<tr>").addClass("jPag-pages");
    var c = (o.display - 1) / 2;
    var first = selectedpage - c;
    var selobj;
    for (var i = 0;i < o.count;i++) {
      var val = i + 1;
      if (val == selectedpage) {
        var _obj = $('<td class="li">').html('<span class="jPag-current">' + val + "</span>");
        selobj = _obj;
        _ul.append(_obj);
      } else {
        var _obj = $('<td class="li">').html("<a>" + val + "</a>");
        _ul.append(_obj);
      }
    }
    _ulwrapdiv.append(_ul);
    if (o.rotate) {
      var _rotright = $("<div>&gt;</div>").button({icons:{primary:"ui-icon-carat-1-e"}, text:false})
    }
    var _divwrapright = $("#rightcol").addClass("jPag-control-front");
    _divwrapright.append(_rotright);
    $("#centercol").append(_ulwrapdiv);
    var _outer = $("#centercol");
    var test_interval = null;
    function hideArrow() {
      $("#leftcol").hide();
      $("#rightcol").hide();
    }
    function showArrow() {
      $("#leftcol").show();
      $("#rightcol").show();
    }
    function testWidth() {
      if (_outer.width() == 0) {
        return;
      }
      clearInterval(test_interval);
      if (_ulwrapdiv.width() <= _outer.width()) {
        hideArrow();
      } else {
        showArrow();
      }
    }
    if (_outer.width() == 0) {
      test_interval = setInterval(testWidth, 500);
    } else {
      testWidth();
    }
    $this.addClass("jPaginate");
    if (!o.border) {
      if (o.background_color == "none") {
        var a_css = {"color":o.text_color}
      } else {
        var a_css = {"color":o.text_color, "background-color":o.background_color}
      }
      if (o.background_hover_color == "none") {
        var hover_css = {"color":o.text_hover_color}
      } else {
        var hover_css = {"color":o.text_hover_color, "background-color":o.background_hover_color}
      }
    } else {
      if (o.background_color == "none") {
        var a_css = {"color":o.text_color, "border":"1px solid " + o.border_color}
      } else {
        var a_css = {"color":o.text_color, "background-color":o.background_color, "border":"1px solid " + o.border_color}
      }
      if (o.background_hover_color == "none") {
        var hover_css = {"color":o.text_hover_color, "border":"1px solid " + o.border_hover_color}
      } else {
        var hover_css = {"color":o.text_hover_color, "background-color":o.background_hover_color, "border":"1px solid " + o.border_hover_color}
      }
    }
    $.fn.applystyle(o, $this, a_css, hover_css, _ul, _ulwrapdiv, _divwrapright);
    var outsidewidth = outsidewidth_tmp - 1;
    if (ver == "ie7") {
    } else {
    }
    if (o.mouse == "press") {
      _rotright.mousedown(function() {
        thumbs_mouse_interval = setInterval(function() {
          var left = _ulwrapdiv.parent().scrollLeft() + 5;
          _ulwrapdiv.parent().scrollLeft(left);
        }, 20);
      }).mouseup(function() {
        clearInterval(thumbs_mouse_interval);
      });
      _rotleft.mousedown(function() {
        thumbs_mouse_interval = setInterval(function() {
          var left = _ulwrapdiv.parent().scrollLeft() - 5;
          _ulwrapdiv.parent().scrollLeft(left);
        }, 20);
      }).mouseup(function() {
        clearInterval(thumbs_mouse_interval);
      });
    }
    _ulwrapdiv.find(".li").click(function(e) {
      selobj.html("<a>" + selobj.find(".jPag-current").html() + "</a>");
      var currval = $(this).find("a").html();
      $(this).html('<span class="jPag-current">' + currval + "</span>");
      selobj = $(this);
      $.fn.applystyle(o, $(this).parent().parent().parent(), a_css, hover_css, _ul, _ulwrapdiv, _divwrapright);
      var left = this.offsetLeft / 2;
      var left2 = _ulwrapdiv.scrollLeft() + left;
      var tmp = left - outsidewidth / 2;
      if (ver == "ie7") {
        _ulwrapdiv.animate({scrollLeft:left + tmp + 52 + "px"});
      } else {
        _ulwrapdiv.animate({scrollLeft:left + tmp + "px"});
      }
      o.onChange(currval);
    });
    var last = _ulwrapdiv.find(".li").eq(o.start - 1);
    last.attr("id", "tmp");
    var left = document.getElementById("tmp").offsetLeft / 2;
    last.removeAttr("id");
    var tmp = left - outsidewidth / 2;
    if (ver == "ie7") {
      _ulwrapdiv.animate({scrollLeft:left + tmp + 52 + "px"});
    } else {
      _ulwrapdiv.animate({scrollLeft:left + tmp + "px"});
    }
  };
  $.fn.applystyle = function(o, obj, a_css, hover_css, _ul, _ulwrapdiv, _divwrapright) {
    obj.find("a").css(a_css);
    obj.find("span.jPag-current").css(hover_css);
    obj.find("a").hover(function() {
      $(this).css(hover_css);
    }, function() {
      $(this).css(a_css);
    });
    insidewidth = 0;
    obj.find(".li").each(function(i, n) {
      if (i == o.display - 1) {
        outsidewidth_tmp = this.offsetLeft + this.offsetWidth;
      }
      insidewidth += this.offsetWidth;
    });
    insidewidth += 3;
  };
})(jQuery);
(function($) {
  $.extend({debounce:function(fn, timeout, ctx, invokeAsap) {
    var timer;
    return function() {
      var args = arguments;
      ctx = ctx || this;
      invokeAsap && (!timer && fn.apply(ctx, args));
      clearTimeout(timer);
      timer = setTimeout(function() {
        !invokeAsap && fn.apply(ctx, args);
        timer = null;
      }, timeout);
    };
  }, throttle:function(fn, timeout, ctx) {
    var timer, args, needInvoke;
    return function() {
      args = arguments;
      needInvoke = true;
      ctx = ctx || this;
      if (!timer) {
        (function() {
          if (needInvoke) {
            fn.apply(ctx, args);
            needInvoke = false;
            timer = setTimeout(arguments.callee, timeout);
          } else {
            timer = null;
          }
        })();
      }
    };
  }});
})(jQuery);
(function($) {
  var strings = {strConversion:{__repr:function(i) {
    switch(this.__getType(i)) {
      case "array":
      ;
      case "date":
      ;
      case "number":
        return i.toString();
      case "object":
        var o = [];
        for (x = 0;x < i.length;i++) {
          o.push(i + ": " + this.__repr(i[x]));
        }
        return o.join(", ");
      case "string":
        return i;
      default:
        return i;
    }
  }, __getType:function(i) {
    if (!i || !i.constructor) {
      return typeof i;
    }
    var match = i.constructor.toString().match(/Array|Number|String|Object|Date/);
    return match && match[0].toLowerCase() || typeof i;
  }, __pad:function(str, l, s, t) {
    var p = s || " ";
    var o = str;
    if (l - str.length > 0) {
      o = (new Array(Math.ceil(l / p.length))).join(p).substr(0, t = !t ? l : t == 1 ? 0 : Math.ceil(l / 2)) + str + p.substr(0, l - t);
    }
    return o;
  }, __getInput:function(arg, args) {
    var key = arg.getKey();
    switch(this.__getType(args)) {
      case "object":
        var keys = key.split(".");
        var obj = args;
        for (var subkey = 0;subkey < keys.length;subkey++) {
          obj = obj[keys[subkey]];
        }
        if (typeof obj != "undefined") {
          if (strings.strConversion.__getType(obj) == "array") {
            return arg.getFormat().match(/\.\*/) && obj[1] || obj;
          }
          return obj;
        } else {
        }
        break;
      case "array":
        key = parseInt(key, 10);
        if (arg.getFormat().match(/\.\*/) && typeof args[key + 1] != "undefined") {
          return args[key + 1];
        } else {
          if (typeof args[key] != "undefined") {
            return args[key];
          } else {
            return key;
          }
        }
        break;
    }
    return "{" + key + "}";
  }, __formatToken:function(token, args) {
    var arg = new Argument(token, args);
    return strings.strConversion[arg.getFormat().slice(-1)](this.__getInput(arg, args), arg);
  }, d:function(input, arg) {
    var o = parseInt(input, 10);
    var p = arg.getPaddingLength();
    if (p) {
      return this.__pad(o.toString(), p, arg.getPaddingString(), 0);
    } else {
      return o;
    }
  }, i:function(input, args) {
    return this.d(input, args);
  }, o:function(input, arg) {
    var o = input.toString(8);
    if (arg.isAlternate()) {
      o = this.__pad(o, o.length + 1, "0", 0);
    }
    return this.__pad(o, arg.getPaddingLength(), arg.getPaddingString(), 0);
  }, u:function(input, args) {
    return Math.abs(this.d(input, args));
  }, x:function(input, arg) {
    var o = parseInt(input, 10).toString(16);
    o = this.__pad(o, arg.getPaddingLength(), arg.getPaddingString(), 0);
    return arg.isAlternate() ? "0x" + o : o;
  }, X:function(input, arg) {
    return this.x(input, arg).toUpperCase();
  }, e:function(input, arg) {
    return parseFloat(input, 10).toExponential(arg.getPrecision());
  }, E:function(input, arg) {
    return this.e(input, arg).toUpperCase();
  }, f:function(input, arg) {
    return this.__pad(parseFloat(input, 10).toFixed(arg.getPrecision()), arg.getPaddingLength(), arg.getPaddingString(), 0);
  }, F:function(input, args) {
    return this.f(input, args);
  }, g:function(input, arg) {
    var o = parseFloat(input, 10);
    return o.toString().length > 6 ? Math.round(o.toExponential(arg.getPrecision())) : o;
  }, G:function(input, args) {
    return this.g(input, args);
  }, c:function(input, args) {
    var match = input.match(/\w|\d/);
    return match && match[0] || "";
  }, r:function(input, args) {
    return this.__repr(input);
  }, s:function(input, args) {
    return input.toString && input.toString() || "" + input;
  }}, format:function(str, args) {
    var end = 0;
    var start = 0;
    var match = false;
    var buffer = [];
    var token = "";
    var tmp = (str || "").split("");
    for (start = 0;start < tmp.length;start++) {
      if (tmp[start] == "{" && tmp[start + 1] != "{") {
        end = str.indexOf("}", start);
        token = tmp.slice(start + 1, end).join("");
        buffer.push(strings.strConversion.__formatToken(token, typeof arguments[1] != "object" ? arguments2Array(arguments, 2) : args || []));
      } else {
        if (start > end || buffer.length < 1) {
          buffer.push(tmp[start]);
        }
      }
    }
    return buffer.length > 1 ? buffer.join("") : buffer[0];
  }, calc:function(str, args) {
    return eval(format(str, args));
  }, repeat:function(s, n) {
    return(new Array(n + 1)).join(s);
  }, UTF8encode:function(s) {
    return unescape(encodeURIComponent(s));
  }, UTF8decode:function(s) {
    return decodeURIComponent(escape(s));
  }, tpl:function() {
    var out = "", render = true;
    if (arguments.length == 2 && $.isArray(arguments[1])) {
      this[arguments[0]] = arguments[1].join("");
      return jQuery;
    }
    if (arguments.length == 2 && $.isString(arguments[1])) {
      this[arguments[0]] = arguments[1];
      return jQuery;
    }
    if (arguments.length == 1) {
      return $(this[arguments[0]]);
    }
    if (arguments.length == 2 && arguments[1] == false) {
      return this[arguments[0]];
    }
    if (arguments.length == 2 && $.isObject(arguments[1])) {
      return $($.format(this[arguments[0]], arguments[1]));
    }
    if (arguments.length == 3 && $.isObject(arguments[1])) {
      return arguments[2] == true ? $.format(this[arguments[0]], arguments[1]) : $($.format(this[arguments[0]], arguments[1]));
    }
  }};
  var Argument = function(arg, args) {
    this.__arg = arg;
    this.__args = args;
    this.__max_precision = parseFloat("1." + (new Array(32)).join("1"), 10).toString().length - 3;
    this.__def_precision = 6;
    this.getString = function() {
      return this.__arg;
    };
    this.getKey = function() {
      return this.__arg.split(":")[0];
    };
    this.getFormat = function() {
      var match = this.getString().split(":");
      return match && match[1] ? match[1] : "s";
    };
    this.getPrecision = function() {
      var match = this.getFormat().match(/\.(\d+|\*)/g);
      if (!match) {
        return this.__def_precision;
      } else {
        match = match[0].slice(1);
        if (match != "*") {
          return parseInt(match, 10);
        } else {
          if (strings.strConversion.__getType(this.__args) == "array") {
            return this.__args[1] && this.__args[0] || this.__def_precision;
          } else {
            if (strings.strConversion.__getType(this.__args) == "object") {
              return this.__args[this.getKey()] && this.__args[this.getKey()][0] || this.__def_precision;
            } else {
              return this.__def_precision;
            }
          }
        }
      }
    };
    this.getPaddingLength = function() {
      var match = false;
      if (this.isAlternate()) {
        match = this.getString().match(/0?#0?(\d+)/);
        if (match && match[1]) {
          return parseInt(match[1], 10);
        }
      }
      match = this.getString().match(/(0|\.)(\d+|\*)/g);
      return match && parseInt(match[0].slice(1), 10) || 0;
    };
    this.getPaddingString = function() {
      var o = "";
      if (this.isAlternate()) {
        o = " ";
      }
      if (this.getFormat().match(/#0|0#|^0|\.\d+/)) {
        o = "0";
      }
      return o;
    };
    this.getFlags = function() {
      var match = this.getString().matc(/^(0|\#|\-|\+|\s)+/);
      return match && match[0].split("") || [];
    };
    this.isAlternate = function() {
      return!!this.getFormat().match(/^0?#/);
    };
  };
  var arguments2Array = function(args, shift) {
    var o = [];
    for (l = args.length, x = (shift || 0) - 1;x < l;x++) {
      o.push(args[x]);
    }
    return o;
  };
  $.extend(strings);
})(jQuery);
(function($) {
  $.toJSON = function(o) {
    if (typeof JSON == "object" && JSON.stringify) {
      return JSON.stringify(o);
    }
    var type = typeof o;
    if (o === null) {
      return "null";
    }
    if (type == "undefined") {
      return undefined;
    }
    if (type == "number" || type == "boolean") {
      return o + "";
    }
    if (type == "string") {
      return $.quoteString(o);
    }
    if (type == "object") {
      if (typeof o.toJSON == "function") {
        return $.toJSON(o.toJSON());
      }
      if (o.constructor === Date) {
        var month = o.getUTCMonth() + 1;
        if (month < 10) {
          month = "0" + month;
        }
        var day = o.getUTCDate();
        if (day < 10) {
          day = "0" + day;
        }
        var year = o.getUTCFullYear();
        var hours = o.getUTCHours();
        if (hours < 10) {
          hours = "0" + hours;
        }
        var minutes = o.getUTCMinutes();
        if (minutes < 10) {
          minutes = "0" + minutes;
        }
        var seconds = o.getUTCSeconds();
        if (seconds < 10) {
          seconds = "0" + seconds;
        }
        var milli = o.getUTCMilliseconds();
        if (milli < 100) {
          milli = "0" + milli;
        }
        if (milli < 10) {
          milli = "0" + milli;
        }
        return'"' + year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "." + milli + 'Z"';
      }
      if (o.constructor === Array) {
        var ret = [];
        for (var i = 0;i < o.length;i++) {
          ret.push($.toJSON(o[i]) || "null");
        }
        return "[" + ret.join(",") + "]";
      }
      var pairs = [];
      for (var k in o) {
        var name;
        var type = typeof k;
        if (type == "number") {
          name = '"' + k + '"';
        } else {
          if (type == "string") {
            name = $.quoteString(k);
          } else {
            continue;
          }
        }
        if (typeof o[k] == "function") {
          continue;
        }
        var val = $.toJSON(o[k]);
        pairs.push(name + ":" + val);
      }
      return "{" + pairs.join(", ") + "}";
    }
  };
  $.evalJSON = function(src) {
    if (typeof JSON == "object" && JSON.parse) {
      return JSON.parse(src);
    }
    return eval("(" + src + ")");
  };
  $.secureEvalJSON = function(src) {
    if (typeof JSON == "object" && JSON.parse) {
      return JSON.parse(src);
    }
    var filtered = src;
    filtered = filtered.replace(/\\["\\\/bfnrtu]/g, "@");
    filtered = filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]");
    filtered = filtered.replace(/(?:^|:|,)(?:\s*\[)+/g, "");
    if (/^[\],:{}\s]*$/.test(filtered)) {
      return eval("(" + src + ")");
    } else {
      throw new SyntaxError("Error parsing JSON, source is not valid.");
    }
  };
  $.quoteString = function(string) {
    if (string.match(_escapeable)) {
      return'"' + string.replace(_escapeable, function(a) {
        var c = _meta[a];
        if (typeof c === "string") {
          return c;
        }
        c = a.charCodeAt();
        return "\\u00" + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
      }) + '"';
    }
    return'"' + string + '"';
  };
  var _escapeable = /["\\\x00-\x1f\x7f-\x9f]/g;
  var _meta = {"\b":"\\b", "\t":"\\t", "\n":"\\n", "\f":"\\f", "\r":"\\r", '"':'\\"', "\\":"\\\\"};
})(jQuery);
(function($) {
  $.fn.addOption = function() {
    var add = function(el, v, t, sO) {
      var option = document.createElement("option");
      option.value = v, option.text = t;
      var o = el.options;
      var oL = o.length;
      if (!el.cache) {
        el.cache = {};
        for (var i = 0;i < oL;i++) {
          el.cache[o[i].value] = i;
        }
      }
      if (typeof el.cache[v] == "undefined") {
        el.cache[v] = oL;
      }
      el.options[el.cache[v]] = option;
      if (sO) {
        option.selected = true;
      }
    };
    var a = arguments;
    if (a.length == 0) {
      return this;
    }
    var sO = true;
    var m = false;
    var items, v, t;
    if (typeof a[0] == "object") {
      m = true;
      items = a[0];
    }
    if (a.length >= 2) {
      if (typeof a[1] == "boolean") {
        sO = a[1];
      } else {
        if (typeof a[2] == "boolean") {
          sO = a[2];
        }
      }
      if (!m) {
        v = a[0];
        t = a[1];
      }
    }
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return;
      }
      if (m) {
        for (var item in items) {
          add(this, item, items[item], sO);
        }
      } else {
        add(this, v, t, sO);
      }
    });
    return this;
  };
  $.fn.ajaxAddOption = function(url, params, select, fn, args) {
    if (typeof url != "string") {
      return this;
    }
    if (typeof params != "object") {
      params = {};
    }
    if (typeof select != "boolean") {
      select = true;
    }
    this.each(function() {
      var el = this;
      $.getJSON(url, params, function(r) {
        $(el).addOption(r, select);
        if (typeof fn == "function") {
          if (typeof args == "object") {
            fn.apply(el, args);
          } else {
            fn.call(el);
          }
        }
      });
    });
    return this;
  };
  $.fn.removeOption = function() {
    var a = arguments;
    if (a.length == 0) {
      return this;
    }
    var ta = typeof a[0];
    var v, index;
    if (ta == "string" || (ta == "object" || ta == "function")) {
      v = a[0];
      if (v.constructor == Array) {
        var l = v.length;
        for (var i = 0;i < l;i++) {
          this.removeOption(v[i], a[1]);
        }
        return this;
      }
    } else {
      if (ta == "number") {
        index = a[0];
      } else {
        return this;
      }
    }
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return;
      }
      if (this.cache) {
        this.cache = null;
      }
      var remove = false;
      var o = this.options;
      if (!!v) {
        var oL = o.length;
        for (var i = oL - 1;i >= 0;i--) {
          if (v.constructor == RegExp) {
            if (o[i].value.match(v)) {
              remove = true;
            }
          } else {
            if (o[i].value == v) {
              remove = true;
            }
          }
          if (remove && a[1] === true) {
            remove = o[i].selected;
          }
          if (remove) {
            o[i] = null;
          }
          remove = false;
        }
      } else {
        if (a[1] === true) {
          remove = o[index].selected;
        } else {
          remove = true;
        }
        if (remove) {
          this.remove(index);
        }
      }
    });
    return this;
  };
  $.fn.sortOptions = function(ascending) {
    var sel = $(this).selectedValues();
    var a = typeof ascending == "undefined" ? true : !!ascending;
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return;
      }
      var o = this.options;
      var oL = o.length;
      var sA = [];
      for (var i = 0;i < oL;i++) {
        sA[i] = {v:o[i].value, t:o[i].text};
      }
      sA.sort(function(o1, o2) {
        o1t = o1.t.toLowerCase(), o2t = o2.t.toLowerCase();
        if (o1t == o2t) {
          return 0;
        }
        if (a) {
          return o1t < o2t ? -1 : 1;
        } else {
          return o1t > o2t ? -1 : 1;
        }
      });
      for (var i = 0;i < oL;i++) {
        o[i].text = sA[i].t;
        o[i].value = sA[i].v;
      }
    }).selectOptions(sel, true);
    return this;
  };
  $.fn.selectOptions = function(value, clear) {
    var v = value;
    var vT = typeof value;
    if (vT == "object" && v.constructor == Array) {
      var $this = this;
      $.each(v, function() {
        $this.selectOptions(this, clear);
      });
    }
    var c = clear || false;
    if (vT != "string" && (vT != "function" && vT != "object")) {
      return this;
    }
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return this;
      }
      var o = this.options;
      var oL = o.length;
      for (var i = 0;i < oL;i++) {
        if (v.constructor == RegExp) {
          if (o[i].value.match(v)) {
            o[i].selected = true;
          } else {
            if (c) {
              o[i].selected = false;
            }
          }
        } else {
          if (o[i].value == v) {
            o[i].selected = true;
          } else {
            if (c) {
              o[i].selected = false;
            }
          }
        }
      }
    });
    return this;
  };
  $.fn.copyOptions = function(to, which) {
    var w = which || "selected";
    if ($(to).size() == 0) {
      return this;
    }
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return this;
      }
      var o = this.options;
      var oL = o.length;
      for (var i = 0;i < oL;i++) {
        if (w == "all" || w == "selected" && o[i].selected) {
          $(to).addOption(o[i].value, o[i].text);
        }
      }
    });
    return this;
  };
  $.fn.containsOption = function(value, fn) {
    var found = false;
    var v = value;
    var vT = typeof v;
    var fT = typeof fn;
    if (vT != "string" && (vT != "function" && vT != "object")) {
      return fT == "function" ? this : found;
    }
    this.each(function() {
      if (this.nodeName.toLowerCase() != "select") {
        return this;
      }
      if (found && fT != "function") {
        return false;
      }
      var o = this.options;
      var oL = o.length;
      for (var i = 0;i < oL;i++) {
        if (v.constructor == RegExp) {
          if (o[i].value.match(v)) {
            found = true;
            if (fT == "function") {
              fn.call(o[i], i);
            }
          }
        } else {
          if (o[i].value == v) {
            found = true;
            if (fT == "function") {
              fn.call(o[i], i);
            }
          }
        }
      }
    });
    return fT == "function" ? this : found;
  };
  $.fn.selectedValues = function() {
    var v = [];
    this.selectedOptions().each(function() {
      v[v.length] = this.value;
    });
    return v;
  };
  $.fn.selectedTexts = function() {
    var t = [];
    this.selectedOptions().each(function() {
      t[t.length] = this.text;
    });
    return t;
  };
  $.fn.selectedOptions = function() {
    return this.find("option:selected");
  };
})(jQuery);
(function($) {
  $.extend($.fn, {swapClass:function(c1, c2) {
    var c1Elements = this.filter("." + c1);
    this.filter("." + c2).removeClass(c2).addClass(c1);
    c1Elements.removeClass(c1).addClass(c2);
    return this;
  }, replaceClass:function(c1, c2) {
    return this.filter("." + c1).removeClass(c1).addClass(c2).end();
  }, hoverClass:function(className) {
    className = className || "hover";
    return this.hover(function() {
      $(this).addClass(className);
    }, function() {
      $(this).removeClass(className);
    });
  }, heightToggle:function(animated, callback) {
    animated ? this.animate({height:"toggle"}, animated, callback) : this.each(function() {
      jQuery(this)[jQuery(this).is(":hidden") ? "show" : "hide"]();
      if (callback) {
        callback.apply(this, arguments);
      }
    });
  }, heightHide:function(animated, callback) {
    if (animated) {
      this.animate({height:"hide"}, animated, callback);
    } else {
      this.hide();
      if (callback) {
        this.each(callback);
      }
    }
  }, prepareBranches:function(settings) {
    if (!settings.prerendered) {
      this.filter(":last-child:not(ul)").addClass(CLASSES.last);
      this.filter((settings.collapsed ? "" : "." + CLASSES.closed) + ":not(." + CLASSES.open + ")").find(">ul").hide();
    }
    return this.filter(":has(>ul)");
  }, applyClasses:function(settings, toggler) {
    if (!settings.prerendered) {
      this.filter(":has(>ul:hidden)").addClass(CLASSES.expandable).replaceClass(CLASSES.last, CLASSES.lastExpandable);
      this.not(":has(>ul:hidden)").addClass(CLASSES.collapsable).replaceClass(CLASSES.last, CLASSES.lastCollapsable);
      this.prepend('<div class="' + CLASSES.hitarea + '"/>').find("div." + CLASSES.hitarea).each(function() {
        var classes = "";
        $.each($(this).parent().attr("class").split(" "), function() {
          classes += this + "-hitarea ";
        });
        $(this).addClass(classes);
      });
    }
    this.find("div." + CLASSES.hitarea).click(toggler);
  }, treeview:function(settings) {
    settings = $.extend({cookieId:"treeview"}, settings);
    if (settings.add) {
      return this.trigger("add", [settings.add]);
    }
    if (settings.toggle) {
      var callback = settings.toggle;
      settings.toggle = function() {
        return callback.apply($(this).parent()[0], arguments);
      };
    }
    function treeController(tree, control) {
      function handler(filter) {
        return function() {
          toggler.apply($("div." + CLASSES.hitarea, tree).filter(function() {
            return filter ? $(this).parent("." + filter).length : true;
          }));
          return false;
        };
      }
      $("a:eq(0)", control).click(handler(CLASSES.collapsable));
      $("a:eq(1)", control).click(handler(CLASSES.expandable));
      $("a:eq(2)", control).click(handler());
    }
    function toggler() {
      $(this).parent().find(">.hitarea").swapClass(CLASSES.collapsableHitarea, CLASSES.expandableHitarea).swapClass(CLASSES.lastCollapsableHitarea, CLASSES.lastExpandableHitarea).end().swapClass(CLASSES.collapsable, CLASSES.expandable).swapClass(CLASSES.lastCollapsable, CLASSES.lastExpandable).find(">ul").heightToggle(settings.animated, settings.toggle);
      if (settings.unique) {
        $(this).parent().siblings().find(">.hitarea").replaceClass(CLASSES.collapsableHitarea, CLASSES.expandableHitarea).replaceClass(CLASSES.lastCollapsableHitarea, CLASSES.lastExpandableHitarea).end().replaceClass(CLASSES.collapsable, CLASSES.expandable).replaceClass(CLASSES.lastCollapsable, CLASSES.lastExpandable).find(">ul").heightHide(settings.animated, settings.toggle);
      }
    }
    function serialize() {
      function binary(arg) {
        return arg ? 1 : 0;
      }
      var data = [];
      branches.each(function(i, e) {
        data[i] = $(e).is(":has(>ul:visible)") ? 1 : 0;
      });
      $.cookie(settings.cookieId, data.join(""));
    }
    function deserialize() {
      var stored = $.cookie(settings.cookieId);
      if (stored) {
        var data = stored.split("");
        branches.each(function(i, e) {
          $(e).find(">ul")[parseInt(data[i]) ? "show" : "hide"]();
        });
      }
    }
    this.addClass("treeview");
    var branches = this.find("li").prepareBranches(settings);
    switch(settings.persist) {
      case "cookie":
        var toggleCallback = settings.toggle;
        settings.toggle = function() {
          serialize();
          if (toggleCallback) {
            toggleCallback.apply(this, arguments);
          }
        };
        deserialize();
        break;
      case "location":
        var current = this.find("a").filter(function() {
          return this.href.toLowerCase() == location.href.toLowerCase();
        });
        if (current.length) {
          current.addClass("selected").parents("ul, li").add(current.next()).show();
        }
        break;
    }
    branches.applyClasses(settings, toggler);
    if (settings.control) {
      treeController(this, settings.control);
      $(settings.control).show();
    }
    return this.bind("add", function(event, branches) {
      $(branches).prev().removeClass(CLASSES.last).removeClass(CLASSES.lastCollapsable).removeClass(CLASSES.lastExpandable).find(">.hitarea").removeClass(CLASSES.lastCollapsableHitarea).removeClass(CLASSES.lastExpandableHitarea);
      $(branches).find("li").andSelf().prepareBranches(settings).applyClasses(settings, toggler);
    });
  }});
  var CLASSES = $.fn.treeview.classes = {open:"open", closed:"closed", expandable:"expandable", expandableHitarea:"expandable-hitarea", lastExpandableHitarea:"lastExpandable-hitarea", collapsable:"collapsable", collapsableHitarea:"collapsable-hitarea", lastCollapsableHitarea:"lastCollapsable-hitarea", lastCollapsable:"lastCollapsable", lastExpandable:"lastExpandable", last:"last", hitarea:"hitarea"};
  $.fn.Treeview = $.fn.treeview;
})(jQuery);
(function($, undefined) {
  $.support.htmlMenuitem = "HTMLMenuItemElement" in window;
  $.support.htmlCommand = "HTMLCommandElement" in window;
  $.support.eventSelectstart = "onselectstart" in document.documentElement;
  var $currentTrigger = null, initialized = false, $win = $(window), counter = 0, namespaces = {}, menus = {}, types = {}, defaults = {selector:null, appendTo:null, trigger:"right", autoHide:false, delay:200, determinePosition:function($menu) {
    if ($.ui && $.ui.position) {
      $menu.css("display", "block").position({my:"center top", at:"center bottom", of:this, offset:"0 5", collision:"fit"}).css("display", "none");
    } else {
      var offset = this.offset();
      offset.top += this.outerHeight();
      offset.left += this.outerWidth() / 2 - $menu.outerWidth() / 2;
      $menu.css(offset);
    }
  }, position:function(opt, x, y) {
    var $this = this, offset;
    if (!x && !y) {
      opt.determinePosition.call(this, opt.$menu);
      return;
    } else {
      if (x === "maintain" && y === "maintain") {
        offset = opt.$menu.position();
      } else {
        var triggerIsFixed = opt.$trigger.parents().andSelf().filter(function() {
          return $(this).css("position") == "fixed";
        }).length;
        if (triggerIsFixed) {
          y -= $win.scrollTop();
          x -= $win.scrollLeft();
        }
        offset = {top:y, left:x};
      }
    }
    var bottom = $win.scrollTop() + $win.height(), right = $win.scrollLeft() + $win.width(), height = opt.$menu.height(), width = opt.$menu.width();
    if (offset.top + height > bottom) {
      offset.top -= height;
    }
    if (offset.left + width > right) {
      offset.left -= width;
    }
    opt.$menu.css(offset);
  }, positionSubmenu:function($menu) {
    if ($.ui && $.ui.position) {
      $menu.css("display", "block").position({my:"left top", at:"right top", of:this, collision:"fit"}).css("display", "");
    } else {
      var offset = {top:0, left:this.outerWidth()};
      $menu.css(offset);
    }
  }, zIndex:6001, animation:{duration:0, show:"slideDown", hide:"slideUp"}, events:{show:$.noop, hide:$.noop}, callback:null, items:{}}, hoveract = {timer:null, pageX:null, pageY:null}, zindex = function($t) {
    var zin = 0, $tt = $t, z = 0;
    for (var i = 0;i < 999;i++) {
      z = parseInt($tt.css("z-index"), 10);
      if (isNaN(z)) {
        z = 0;
      }
      zin = Math.max(zin, z);
      $tt = $tt.parent();
      if (!$tt || (!$tt.length || "html body".indexOf($tt.prop("nodeName").toLowerCase()) > -1)) {
        break;
      }
    }
    return zin;
  }, handle = {abortevent:function(e) {
    e.preventDefault();
    e.stopImmediatePropagation();
  }, contextmenu:function(e) {
    var $this = $(this);
    e.preventDefault();
    e.stopImmediatePropagation();
    if (e.data.trigger != "right" && e.originalEvent) {
      return;
    }
    if (!$this.hasClass("context-menu-disabled")) {
      $currentTrigger = $this;
      if (e.data.build) {
        var built = e.data.build($currentTrigger, e);
        if (built === false) {
          return;
        }
        e.data = $.extend(true, {}, defaults, e.data, built || {});
        if (!e.data.items || $.isEmptyObject(e.data.items)) {
          if (window.console) {
            (console.error || console.log)("No items specified to show in contextMenu");
          }
          throw new Error("No Items sepcified");
        }
        e.data.$trigger = $currentTrigger;
        op.create(e.data);
      }
      op.show.call($this, e.data, e.pageX, e.pageY);
    }
  }, click:function(e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    $(this).trigger($.Event("contextmenu", {data:e.data, pageX:e.pageX, pageY:e.pageY}));
  }, mousedown:function(e) {
    var $this = $(this);
    if ($currentTrigger && ($currentTrigger.length && !$currentTrigger.is($this))) {
      $currentTrigger.data("contextMenu").$menu.trigger("contextmenu:hide");
    }
    if (e.button == 2) {
      $currentTrigger = $this.data("contextMenuActive", true);
    }
  }, mouseup:function(e) {
    var $this = $(this);
    if ($this.data("contextMenuActive") && ($currentTrigger && ($currentTrigger.length && ($currentTrigger.is($this) && !$this.hasClass("context-menu-disabled"))))) {
      e.preventDefault();
      e.stopImmediatePropagation();
      $currentTrigger = $this;
      $this.trigger($.Event("contextmenu", {data:e.data, pageX:e.pageX, pageY:e.pageY}));
    }
    $this.removeData("contextMenuActive");
  }, mouseenter:function(e) {
    var $this = $(this), $related = $(e.relatedTarget), $document = $(document);
    if ($related.is(".context-menu-list") || $related.closest(".context-menu-list").length) {
      return;
    }
    if ($currentTrigger && $currentTrigger.length) {
      return;
    }
    hoveract.pageX = e.pageX;
    hoveract.pageY = e.pageY;
    hoveract.data = e.data;
    $document.on("mousemove.contextMenuShow", handle.mousemove);
    hoveract.timer = setTimeout(function() {
      hoveract.timer = null;
      $document.off("mousemove.contextMenuShow");
      $currentTrigger = $this;
      $this.trigger($.Event("contextmenu", {data:hoveract.data, pageX:hoveract.pageX, pageY:hoveract.pageY}));
    }, e.data.delay);
  }, mousemove:function(e) {
    hoveract.pageX = e.pageX;
    hoveract.pageY = e.pageY;
  }, mouseleave:function(e) {
    var $related = $(e.relatedTarget);
    if ($related.is(".context-menu-list") || $related.closest(".context-menu-list").length) {
      return;
    }
    try {
      clearTimeout(hoveract.timer);
    } catch (e) {
    }
    hoveract.timer = null;
  }, layerClick:function(e) {
    var $this = $(this), root = $this.data("contextMenuRoot"), mouseup = false, button = e.button, x = e.pageX, y = e.pageY, target, offset, selectors;
    e.preventDefault();
    e.stopImmediatePropagation();
    $this.on("mouseup", function() {
      mouseup = true;
    });
    setTimeout(function() {
      var $window, hideshow;
      if (root.trigger == "left" && button == 0 || root.trigger == "right" && button == 2) {
        if (document.elementFromPoint) {
          root.$layer.hide();
          target = document.elementFromPoint(x - $win.scrollLeft(), y - $win.scrollTop());
          root.$layer.show();
          selectors = [];
          for (var s in namespaces) {
            selectors.push(s);
          }
          target = $(target).closest(selectors.join(", "));
          if (target.length) {
            if (target.is(root.$trigger[0])) {
              root.position.call(root.$trigger, root, x, y);
              return;
            }
          }
        } else {
          offset = root.$trigger.offset();
          $window = $(window);
          offset.top += $window.scrollTop();
          if (offset.top <= e.pageY) {
            offset.left += $window.scrollLeft();
            if (offset.left <= e.pageX) {
              offset.bottom = offset.top + root.$trigger.outerHeight();
              if (offset.bottom >= e.pageY) {
                offset.right = offset.left + root.$trigger.outerWidth();
                if (offset.right >= e.pageX) {
                  root.position.call(root.$trigger, root, x, y);
                  return;
                }
              }
            }
          }
        }
      }
      hideshow = function(e) {
        if (e) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
        root.$menu.trigger("contextmenu:hide");
        if (target && target.length) {
          setTimeout(function() {
            target.contextMenu({x:x, y:y});
          }, 50);
        }
      };
      if (mouseup) {
        hideshow();
      } else {
        $this.on("mouseup", hideshow);
      }
    }, 50);
  }, keyStop:function(e, opt) {
    if (!opt.isInput) {
      e.preventDefault();
    }
    e.stopPropagation();
  }, key:function(e) {
    var opt = $currentTrigger.data("contextMenu") || {}, $children = opt.$menu.children(), $round;
    switch(e.keyCode) {
      case 9:
      ;
      case 38:
        handle.keyStop(e, opt);
        if (opt.isInput) {
          if (e.keyCode == 9 && e.shiftKey) {
            e.preventDefault();
            opt.$selected && opt.$selected.find("input, textarea, select").blur();
            opt.$menu.trigger("prevcommand");
            return;
          } else {
            if (e.keyCode == 38 && opt.$selected.find("input, textarea, select").prop("type") == "checkbox") {
              e.preventDefault();
              return;
            }
          }
        } else {
          if (e.keyCode != 9 || e.shiftKey) {
            opt.$menu.trigger("prevcommand");
            return;
          }
        }
      ;
      case 40:
        handle.keyStop(e, opt);
        if (opt.isInput) {
          if (e.keyCode == 9) {
            e.preventDefault();
            opt.$selected && opt.$selected.find("input, textarea, select").blur();
            opt.$menu.trigger("nextcommand");
            return;
          } else {
            if (e.keyCode == 40 && opt.$selected.find("input, textarea, select").prop("type") == "checkbox") {
              e.preventDefault();
              return;
            }
          }
        } else {
          opt.$menu.trigger("nextcommand");
          return;
        }
        break;
      case 37:
        handle.keyStop(e, opt);
        if (opt.isInput || (!opt.$selected || !opt.$selected.length)) {
          break;
        }
        if (!opt.$selected.parent().hasClass("context-menu-root")) {
          var $parent = opt.$selected.parent().parent();
          opt.$selected.trigger("contextmenu:blur");
          opt.$selected = $parent;
          return;
        }
        break;
      case 39:
        handle.keyStop(e, opt);
        if (opt.isInput || (!opt.$selected || !opt.$selected.length)) {
          break;
        }
        var itemdata = opt.$selected.data("contextMenu") || {};
        if (itemdata.$menu && opt.$selected.hasClass("context-menu-submenu")) {
          opt.$selected = null;
          itemdata.$selected = null;
          itemdata.$menu.trigger("nextcommand");
          return;
        }
        break;
      case 35:
      ;
      case 36:
        if (opt.$selected && opt.$selected.find("input, textarea, select").length) {
          return;
        } else {
          (opt.$selected && opt.$selected.parent() || opt.$menu).children(":not(.disabled, .not-selectable)")[e.keyCode == 36 ? "first" : "last"]().trigger("contextmenu:focus");
          e.preventDefault();
          return;
        }
        break;
      case 13:
        handle.keyStop(e, opt);
        if (opt.isInput) {
          if (opt.$selected && !opt.$selected.is("textarea, select")) {
            e.preventDefault();
            return;
          }
          break;
        }
        opt.$selected && opt.$selected.trigger("mouseup");
        return;
      case 32:
      ;
      case 33:
      ;
      case 34:
        handle.keyStop(e, opt);
        return;
      case 27:
        handle.keyStop(e, opt);
        opt.$menu.trigger("contextmenu:hide");
        return;
      default:
        var k = String.fromCharCode(e.keyCode).toUpperCase();
        if (opt.accesskeys[k]) {
          opt.accesskeys[k].$node.trigger(opt.accesskeys[k].$menu ? "contextmenu:focus" : "mouseup");
          return;
        }
        break;
    }
    e.stopPropagation();
    opt.$selected && opt.$selected.trigger(e);
  }, prevItem:function(e) {
    e.stopPropagation();
    var opt = $(this).data("contextMenu") || {};
    if (opt.$selected) {
      var $s = opt.$selected;
      opt = opt.$selected.parent().data("contextMenu") || {};
      opt.$selected = $s;
    }
    var $children = opt.$menu.children(), $prev = !opt.$selected || !opt.$selected.prev().length ? $children.last() : opt.$selected.prev(), $round = $prev;
    while ($prev.hasClass("disabled") || $prev.hasClass("not-selectable")) {
      if ($prev.prev().length) {
        $prev = $prev.prev();
      } else {
        $prev = $children.last();
      }
      if ($prev.is($round)) {
        return;
      }
    }
    if (opt.$selected) {
      handle.itemMouseleave.call(opt.$selected.get(0), e);
    }
    handle.itemMouseenter.call($prev.get(0), e);
    var $input = $prev.find("input, textarea, select");
    if ($input.length) {
      $input.focus();
    }
  }, nextItem:function(e) {
    e.stopPropagation();
    var opt = $(this).data("contextMenu") || {};
    if (opt.$selected) {
      var $s = opt.$selected;
      opt = opt.$selected.parent().data("contextMenu") || {};
      opt.$selected = $s;
    }
    var $children = opt.$menu.children(), $next = !opt.$selected || !opt.$selected.next().length ? $children.first() : opt.$selected.next(), $round = $next;
    while ($next.hasClass("disabled") || $next.hasClass("not-selectable")) {
      if ($next.next().length) {
        $next = $next.next();
      } else {
        $next = $children.first();
      }
      if ($next.is($round)) {
        return;
      }
    }
    if (opt.$selected) {
      handle.itemMouseleave.call(opt.$selected.get(0), e);
    }
    handle.itemMouseenter.call($next.get(0), e);
    var $input = $next.find("input, textarea, select");
    if ($input.length) {
      $input.focus();
    }
  }, focusInput:function(e) {
    var $this = $(this).closest(".context-menu-item"), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    root.$selected = opt.$selected = $this;
    root.isInput = opt.isInput = true;
  }, blurInput:function(e) {
    var $this = $(this).closest(".context-menu-item"), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    root.isInput = opt.isInput = false;
  }, menuMouseenter:function(e) {
    var root = $(this).data().contextMenuRoot;
    root.hovering = true;
  }, menuMouseleave:function(e) {
    var root = $(this).data().contextMenuRoot;
    if (root.$layer && root.$layer.is(e.relatedTarget)) {
      root.hovering = false;
    }
  }, itemMouseenter:function(e) {
    var $this = $(this), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    root.hovering = true;
    if (e && (root.$layer && root.$layer.is(e.relatedTarget))) {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
    (opt.$menu ? opt : root).$menu.children(".hover").trigger("contextmenu:blur");
    if ($this.hasClass("disabled") || $this.hasClass("not-selectable")) {
      opt.$selected = null;
      return;
    }
    $this.trigger("contextmenu:focus");
  }, itemMouseleave:function(e) {
    var $this = $(this), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    if (root !== opt && (root.$layer && root.$layer.is(e.relatedTarget))) {
      root.$selected && root.$selected.trigger("contextmenu:blur");
      e.preventDefault();
      e.stopImmediatePropagation();
      root.$selected = opt.$selected = opt.$node;
      return;
    }
    $this.trigger("contextmenu:blur");
  }, itemClick:function(e) {
    var $this = $(this), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot, key = data.contextMenuKey, callback;
    if (!opt.items[key] || ($this.hasClass("disabled") || $this.hasClass("context-menu-submenu"))) {
      return;
    }
    e.preventDefault();
    e.stopImmediatePropagation();
    if ($.isFunction(root.callbacks[key])) {
      callback = root.callbacks[key];
    } else {
      if ($.isFunction(root.callback)) {
        callback = root.callback;
      } else {
        return;
      }
    }
    if (callback.call(root.$trigger, key, root) !== false) {
      root.$menu.trigger("contextmenu:hide");
    } else {
      if (root.$menu.parent().length) {
        op.update.call(root.$trigger, root);
      }
    }
  }, inputClick:function(e) {
    e.stopImmediatePropagation();
  }, hideMenu:function(e, data) {
    var root = $(this).data("contextMenuRoot");
    op.hide.call(root.$trigger, root, data && data.force);
  }, focusItem:function(e) {
    e.stopPropagation();
    var $this = $(this), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    $this.addClass("hover").siblings(".hover").trigger("contextmenu:blur");
    opt.$selected = root.$selected = $this;
    if (opt.$node) {
      root.positionSubmenu.call(opt.$node, opt.$menu);
    }
  }, blurItem:function(e) {
    e.stopPropagation();
    var $this = $(this), data = $this.data(), opt = data.contextMenu, root = data.contextMenuRoot;
    $this.removeClass("hover");
    opt.$selected = null;
  }}, op = {show:function(opt, x, y) {
    if (typeof globalMenu != "undefined" && globalMenu) {
      return;
    }
    globalMenu = true;
    var $this = $(this), offset, css = {};
    $("#context-menu-layer").trigger("mousedown");
    opt.$trigger = $this;
    if (opt.events.show.call($this, opt) === false) {
      $currentTrigger = null;
      return;
    }
    op.update.call($this, opt);
    opt.position.call($this, opt, x, y);
    if (opt.zIndex) {
      css.zIndex = zindex($this) + opt.zIndex;
    }
    op.layer.call(opt.$menu, opt, css.zIndex);
    opt.$menu.find("ul").css("zIndex", css.zIndex + 1);
    opt.$menu.css(css)[opt.animation.show](opt.animation.duration);
    $this.data("contextMenu", opt);
    $(document).off("keydown.contextMenu").on("keydown.contextMenu", handle.key);
    if (opt.autoHide) {
      var pos = $this.position();
      pos.right = pos.left + $this.outerWidth();
      pos.bottom = pos.top + this.outerHeight();
      $(document).on("mousemove.contextMenuAutoHide", function(e) {
        if (opt.$layer && (!opt.hovering && (!(e.pageX >= pos.left && e.pageX <= pos.right) || !(e.pageY >= pos.top && e.pageY <= pos.bottom)))) {
          opt.$menu.trigger("contextmenu:hide");
        }
      });
    }
  }, hide:function(opt, force) {
    var $this = $(this);
    if (!opt) {
      opt = $this.data("contextMenu") || {};
    }
    if (!force && (opt.events && opt.events.hide.call($this, opt) === false)) {
      return;
    }
    if (opt.$layer) {
      setTimeout(function($layer) {
        return function() {
          $layer.remove();
        };
      }(opt.$layer), 10);
      try {
        delete opt.$layer;
      } catch (e) {
        opt.$layer = null;
      }
    }
    $currentTrigger = null;
    opt.$menu.find(".hover").trigger("contextmenu:blur");
    opt.$selected = null;
    $(document).off(".contextMenuAutoHide").off("keydown.contextMenu");
    opt.$menu && opt.$menu[opt.animation.hide](opt.animation.duration, function() {
      if (opt.build) {
        opt.$menu.remove();
        $.each(opt, function(key, value) {
          switch(key) {
            case "ns":
            ;
            case "selector":
            ;
            case "build":
            ;
            case "trigger":
              return true;
            default:
              opt[key] = undefined;
              try {
                delete opt[key];
              } catch (e) {
              }
              return true;
          }
        });
      }
    });
    globalMenu = false;
  }, create:function(opt, root) {
    if (root === undefined) {
      root = opt;
    }
    opt.$menu = $('<ul class="context-menu-list ' + (opt.className || "") + '"></ul>').data({"contextMenu":opt, "contextMenuRoot":root});
    $.each(["callbacks", "commands", "inputs"], function(i, k) {
      opt[k] = {};
      if (!root[k]) {
        root[k] = {};
      }
    });
    root.accesskeys || (root.accesskeys = {});
    $.each(opt.items, function(key, item) {
      var $t = $('<li class="context-menu-item ' + (item.className || "") + '"></li>'), $label = null, $input = null;
      item.$node = $t.data({"contextMenu":opt, "contextMenuRoot":root, "contextMenuKey":key});
      if (item.accesskey) {
        var aks = splitAccesskey(item.accesskey);
        for (var i = 0, ak;ak = aks[i];i++) {
          if (!root.accesskeys[ak]) {
            root.accesskeys[ak] = item;
            item._name = item.name.replace(new RegExp("(" + ak + ")", "i"), '<span class="context-menu-accesskey">$1</span>');
            break;
          }
        }
      }
      if (typeof item == "string") {
        $t.addClass("context-menu-separator not-selectable");
      } else {
        if (item.type && types[item.type]) {
          types[item.type].call($t, item, opt, root);
          $.each([opt, root], function(i, k) {
            k.commands[key] = item;
            if ($.isFunction(item.callback)) {
              k.callbacks[key] = item.callback;
            }
          });
        } else {
          if (item.type == "html") {
            $t.addClass("context-menu-html not-selectable");
          } else {
            if (item.type) {
              $label = $("<label></label>").appendTo($t);
              $("<span></span>").html(item._name || item.name).appendTo($label);
              $t.addClass("context-menu-input");
              opt.hasTypes = true;
              $.each([opt, root], function(i, k) {
                k.commands[key] = item;
                k.inputs[key] = item;
              });
            } else {
              if (item.items) {
                item.type = "sub";
              }
            }
          }
          switch(item.type) {
            case "text":
              $input = $('<input type="text" value="1" name="context-menu-input-' + key + '" value="">').val(item.value || "").appendTo($label);
              break;
            case "textarea":
              $input = $('<textarea name="context-menu-input-' + key + '"></textarea>').val(item.value || "").appendTo($label);
              if (item.height) {
                $input.height(item.height);
              }
              break;
            case "checkbox":
              $input = $('<input type="checkbox" value="1" name="context-menu-input-' + key + '" value="">').val(item.value || "").prop("checked", !!item.selected).prependTo($label);
              break;
            case "radio":
              $input = $('<input type="radio" value="1" name="context-menu-input-' + item.radio + '" value="">').val(item.value || "").prop("checked", !!item.selected).prependTo($label);
              break;
            case "select":
              $input = $('<select name="context-menu-input-' + key + '">').appendTo($label);
              if (item.options) {
                $.each(item.options, function(value, text) {
                  $("<option></option>").val(value).text(text).appendTo($input);
                });
                $input.val(item.selected);
              }
              break;
            case "sub":
              $("<span></span>").html(item._name || item.name).appendTo($t);
              item.appendTo = item.$node;
              op.create(item, root);
              $t.data("contextMenu", item).addClass("context-menu-submenu");
              item.callback = null;
              break;
            case "html":
              $(item.html).appendTo($t);
              break;
            default:
              $.each([opt, root], function(i, k) {
                k.commands[key] = item;
                if ($.isFunction(item.callback)) {
                  k.callbacks[key] = item.callback;
                }
              });
              $("<span></span>").html(item._name || (item.name || "")).appendTo($t);
              break;
          }
          if (item.type && (item.type != "sub" && item.type != "html")) {
            $input.on("focus", handle.focusInput).on("blur", handle.blurInput);
            if (item.events) {
              $input.on(item.events, opt);
            }
          }
          if (item.icon) {
            $t.addClass("icon icon-" + item.icon);
          }
        }
      }
      item.$input = $input;
      item.$label = $label;
      $t.appendTo(opt.$menu);
      if (!opt.hasTypes && $.support.eventSelectstart) {
        $t.on("selectstart.disableTextSelect", handle.abortevent);
      }
    });
    if (!opt.$node) {
      opt.$menu.css("display", "none").addClass("context-menu-root");
    }
    opt.$menu.appendTo(opt.appendTo || document.body);
  }, update:function(opt, root) {
    var $this = this;
    if (root === undefined) {
      root = opt;
      opt.$menu.find("ul").andSelf().css({position:"static", display:"block"}).each(function() {
        var $this = $(this);
        $this.width($this.css("position", "absolute").width()).css("position", "static");
      }).css({position:"", display:""});
    }
    opt.$menu.children().each(function() {
      var $item = $(this), key = $item.data("contextMenuKey"), item = opt.items[key], disabled = $.isFunction(item.disabled) && item.disabled.call($this, key, root) || item.disabled === true;
      $item[disabled ? "addClass" : "removeClass"]("disabled");
      if (item.type) {
        $item.find("input, select, textarea").prop("disabled", disabled);
        switch(item.type) {
          case "text":
          ;
          case "textarea":
            item.$input.val(item.value || "");
            break;
          case "checkbox":
          ;
          case "radio":
            item.$input.val(item.value || "").prop("checked", !!item.selected);
            break;
          case "select":
            item.$input.val(item.selected || "");
            break;
        }
      }
      if (item.$menu) {
        op.update.call($this, item, root);
      }
    });
  }, layer:function(opt, zIndex) {
    $l = $("#context-menu-layer");
    if ($l) {
      $l.remove();
    }
    var $layer = opt.$layer = $('<div id="context-menu-layer" style="position:fixed; z-index:' + zIndex + '; top:0; left:0; opacity: 0; filter: alpha(opacity=0); background-color: #000;"></div>').css({height:$win.height(), width:$win.width(), display:"block"}).data("contextMenuRoot", opt).insertBefore(this).on("contextmenu", handle.abortevent).on("mousedown", handle.layerClick);
    if (!$.support.fixedPosition) {
      $layer.css({"position":"absolute", "height":$(document).height()});
    }
    return $layer;
  }};
  function splitAccesskey(val) {
    var t = val.split(/\s+/), keys = [];
    for (var i = 0, k;k = t[i];i++) {
      k = k[0].toUpperCase();
      keys.push(k);
    }
    return keys;
  }
  $.fn.contextMenu = function(operation) {
    if (operation === undefined) {
      this.first().trigger("contextmenu");
    } else {
      if (operation.x && operation.y) {
        this.first().trigger($.Event("contextmenu", {pageX:operation.x, pageY:operation.y}));
      } else {
        if (operation === "hide") {
          var $menu = this.data("contextMenu").$menu;
          $menu && $menu.trigger("contextmenu:hide");
        } else {
          if (operation === "element") {
            if (this.data("contextMenu") != null) {
              return this.data("contextMenu").$menu;
            }
            return[];
          } else {
            if (operation) {
              this.removeClass("context-menu-disabled");
            } else {
              if (!operation) {
                this.addClass("context-menu-disabled");
              }
            }
          }
        }
      }
    }
    return this;
  };
  $.contextMenu = function(operation, options) {
    if (typeof operation != "string") {
      options = operation;
      operation = "create";
    }
    if (typeof options == "string") {
      options = {selector:options};
    } else {
      if (options === undefined) {
        options = {};
      }
    }
    var o = $.extend(true, {}, defaults, options || {}), $document = $(document);
    switch(operation) {
      case "create":
        if (!o.selector) {
          throw new Error("No selector specified");
        }
        if (o.selector.match(/.context-menu-(list|item|input)($|\s)/)) {
          throw new Error('Cannot bind to selector "' + o.selector + '" as it contains a reserved className');
        }
        if (!o.build && (!o.items || $.isEmptyObject(o.items))) {
          throw new Error("No Items sepcified");
        }
        counter++;
        o.ns = ".contextMenu" + counter;
        namespaces[o.selector] = o.ns;
        menus[o.ns] = o;
        if (!o.trigger) {
          o.trigger = "right";
        }
        if (!initialized) {
          $document.on({"contextmenu:hide.contextMenu":handle.hideMenu, "prevcommand.contextMenu":handle.prevItem, "nextcommand.contextMenu":handle.nextItem, "contextmenu.contextMenu":handle.abortevent, "mouseenter.contextMenu":handle.menuMouseenter, "mouseleave.contextMenu":handle.menuMouseleave}, ".context-menu-list").on("mouseup.contextMenu", ".context-menu-input", handle.inputClick).on({"mouseup.contextMenu":handle.itemClick, "contextmenu:focus.contextMenu":handle.focusItem, "contextmenu:blur.contextMenu":handle.blurItem, 
          "contextmenu.contextMenu":handle.abortevent, "mouseenter.contextMenu":handle.itemMouseenter, "mouseleave.contextMenu":handle.itemMouseleave}, ".context-menu-item");
          initialized = true;
        }
        $document.on("contextmenu" + o.ns, o.selector, o, handle.contextmenu);
        switch(o.trigger) {
          case "hover":
            $document.on("mouseenter" + o.ns, o.selector, o, handle.mouseenter).on("mouseleave" + o.ns, o.selector, o, handle.mouseleave);
            break;
          case "left":
            $document.on("click" + o.ns, o.selector, o, handle.click);
            break;
        }
        if (!o.build) {
          op.create(o);
        }
        break;
      case "destroy":
        if (!o.selector) {
          $document.off(".contextMenu .contextMenuAutoHide");
          $.each(namespaces, function(key, value) {
            $document.off(value);
          });
          namespaces = {};
          menus = {};
          counter = 0;
          initialized = false;
          $("#context-menu-layer, .context-menu-list").remove();
        } else {
          if (namespaces[o.selector]) {
            var $visibleMenu = $(".context-menu-list").filter(":visible");
            if ($visibleMenu.length && $visibleMenu.data().contextMenuRoot.$trigger.is(o.selector)) {
              $visibleMenu.trigger("contextmenu:hide", {force:true});
            }
            try {
              if (menus[namespaces[o.selector]].$menu) {
                menus[namespaces[o.selector]].$menu.remove();
              }
              delete menus[namespaces[o.selector]];
            } catch (e) {
              menus[namespaces[o.selector]] = null;
            }
            $document.off(namespaces[o.selector]);
          }
        }
        break;
      case "html5":
        if (!$.support.htmlCommand && !$.support.htmlMenuitem || typeof options == "boolean" && options) {
          $('menu[type="context"]').each(function() {
            if (this.id) {
              $.contextMenu({selector:"[contextmenu=" + this.id + "]", items:$.contextMenu.fromMenu(this)});
            }
          }).css("display", "none");
        }
        break;
      default:
        throw new Error('Unknown operation "' + operation + '"');;
    }
    return this;
  };
  $.contextMenu.setInputValues = function(opt, data) {
    if (data === undefined) {
      data = {};
    }
    $.each(opt.inputs, function(key, item) {
      switch(item.type) {
        case "text":
        ;
        case "textarea":
          item.value = data[key] || "";
          break;
        case "checkbox":
          item.selected = data[key] ? true : false;
          break;
        case "radio":
          item.selected = (data[item.radio] || "") == item.value ? true : false;
          break;
        case "select":
          item.selected = data[key] || "";
          break;
      }
    });
  };
  $.contextMenu.getInputValues = function(opt, data) {
    if (data === undefined) {
      data = {};
    }
    $.each(opt.inputs, function(key, item) {
      switch(item.type) {
        case "text":
        ;
        case "textarea":
        ;
        case "select":
          data[key] = item.$input.val();
          break;
        case "checkbox":
          data[key] = item.$input.prop("checked");
          break;
        case "radio":
          if (item.$input.prop("checked")) {
            data[item.radio] = item.value;
          }
          break;
      }
    });
    return data;
  };
  function inputLabel(node) {
    return node.id && $('label[for="' + node.id + '"]').val() || node.name;
  }
  function menuChildren(items, $children, counter) {
    if (!counter) {
      counter = 0;
    }
    $children.each(function() {
      var $node = $(this), node = this, nodeName = this.nodeName.toLowerCase(), label, item;
      if (nodeName == "label" && $node.find("input, textarea, select").length) {
        label = $node.text();
        $node = $node.children().first();
        node = $node.get(0);
        nodeName = node.nodeName.toLowerCase();
      }
      switch(nodeName) {
        case "menu":
          item = {name:$node.attr("label"), items:{}};
          counter = menuChildren(item.items, $node.children(), counter);
          break;
        case "a":
        ;
        case "button":
          item = {name:$node.text(), disabled:!!$node.attr("disabled"), callback:function() {
            return function() {
              $node.click();
            };
          }()};
          break;
        case "menuitem":
        ;
        case "command":
          switch($node.attr("type")) {
            case undefined:
            ;
            case "command":
            ;
            case "menuitem":
              item = {name:$node.attr("label"), disabled:!!$node.attr("disabled"), callback:function() {
                return function() {
                  $node.click();
                };
              }()};
              break;
            case "checkbox":
              item = {type:"checkbox", disabled:!!$node.attr("disabled"), name:$node.attr("label"), selected:!!$node.attr("checked")};
              break;
            case "radio":
              item = {type:"radio", disabled:!!$node.attr("disabled"), name:$node.attr("label"), radio:$node.attr("radiogroup"), value:$node.attr("id"), selected:!!$node.attr("checked")};
              break;
            default:
              item = undefined;
          }
          break;
        case "hr":
          item = "-------";
          break;
        case "input":
          switch($node.attr("type")) {
            case "text":
              item = {type:"text", name:label || inputLabel(node), disabled:!!$node.attr("disabled"), value:$node.val()};
              break;
            case "checkbox":
              item = {type:"checkbox", name:label || inputLabel(node), disabled:!!$node.attr("disabled"), selected:!!$node.attr("checked")};
              break;
            case "radio":
              item = {type:"radio", name:label || inputLabel(node), disabled:!!$node.attr("disabled"), radio:!!$node.attr("name"), value:$node.val(), selected:!!$node.attr("checked")};
              break;
            default:
              item = undefined;
              break;
          }
          break;
        case "select":
          item = {type:"select", name:label || inputLabel(node), disabled:!!$node.attr("disabled"), selected:$node.val(), options:{}};
          $node.children().each(function() {
            item.options[this.value] = $(this).text();
          });
          break;
        case "textarea":
          item = {type:"textarea", name:label || inputLabel(node), disabled:!!$node.attr("disabled"), value:$node.val()};
          break;
        case "label":
          break;
        default:
          item = {type:"html", html:$node.clone(true)};
          break;
      }
      if (item) {
        counter++;
        items["key" + counter] = item;
      }
    });
    return counter;
  }
  $.contextMenu.fromMenu = function(element) {
    var $this = $(element), items = {};
    menuChildren(items, $this.children());
    return items;
  };
  $.contextMenu.defaults = defaults;
  $.contextMenu.types = types;
})(jQuery);
var EditableSelectWrapper = function(id) {
  this.id = id;
  this.element = null;
  this.values = new Array;
  this.list_height = 0;
  this.list_item_height = 20;
  this.UpdateValues = function(values) {
    delete this.values;
    this.values = new Array;
    var li = new Array;
    for (var i = 0;i < values.length;i++) {
      var value = values[i];
      li.push('<li value="' + i + '" class="' + value.cssClass + '">' + value.text + "</li>");
      this.values.push(value.value);
    }
    this.element.html("<ul>" + li.join("\n") + "</ul>");
    var me = this;
    this.element.bindEx("mouseup", function(e) {
      var li = e.target;
      if (li.tagName.toUpperCase() != "LI") {
        return;
      }
      var $li = $(e.target);
      e.stopPropagation();
      this.currentContext.pickListItem($li.text(), me.currentContext.getListValue(li.value));
    }, this).bindEx("mousedown", function(e) {
      e.stopPropagation();
    }, this);
    this.adjustHeight();
    this.checkScroll(10);
  };
  this.adjustHeight = function() {
    this.element.css("visibility", "hidden");
    this.element.show();
    var elements = this.element.find("li");
    if (elements.length > 0) {
      this.list_item_height = elements[0].offsetHeight;
    }
    this.element.css("visibility", "visible");
    this.element.hide();
  };
  this.checkScroll = function(items_then_scroll) {
    if (this.element.find("li").length > items_then_scroll) {
      this.list_height = this.list_item_height * items_then_scroll;
      this.element.css("height", this.list_height + "px");
      this.element.css("overflow", "auto");
    } else {
      this.element.css("height", "auto");
      this.element.css("overflow", "visible");
    }
  };
  this.getListValue = function(index) {
    return this.values[index];
  };
  this.clearHighlightMatches = function() {
    this.element.find("li").removeClass("match");
  };
  this.highlightSelected = function(text) {
    var current_value = toLower(text);
    this.clearHighlightMatches();
    var matches = this.getMatchItems(current_value);
    $(matches).addClass("match");
    if (matches.length > 0) {
      this.selectListItem($(matches[0]));
    } else {
      this.selectFirstListItem();
    }
  };
  this.getMatchItemNext = function(text) {
    var current_value = toLower(text);
    var matches = this.getMatchItems(current_value);
    var current = this.getSelectedListItem();
    if (current.length > 0 && matches.length > 1) {
      var index = matches.indexOf(current[0]);
      if (index < matches.length - 1) {
        return $(matches[index + 1]);
      } else {
        return $(matches[0]);
      }
    }
    return null;
  };
  this.getMatchItemPrev = function(text) {
    var current_value = toLower(text);
    var matches = this.getMatchItems(current_value);
    var current = this.getSelectedListItem();
    if (current.length > 0 && matches.length > 1) {
      var index = matches.indexOf(current[0]);
      if (index > 0) {
        return $(matches[index - 1]);
      } else {
        return $(matches[matches.length - 1]);
      }
    }
    return null;
  };
  this.getMatchItems = function(text) {
    var result = [];
    if (isEmpty(text)) {
      return result;
    }
    var pattern = text.replace(/([$-/:-?{-~!"^_`\[\]\\])/g, "\\$1");
    var elements = this.element.find("li");
    for (var i = 0;i < elements.length;i++) {
      var li = elements[i];
      var li_text = toLower(!isEmpty(li.textContent) ? li.textContent : li.innerText);
      var li_value = toLower(this.getListValue(li.value));
      if (QB.Web.Grid.QuickFilterInExpressionMatchFromBeginning) {
        pattern = "(^" + text + ")|([.]" + text + ")";
      }
      if (text == li_text || text == li_value) {
        result.push(li);
      } else {
        if (li_text.test(pattern) || li_value.test(pattern)) {
          result.push(li);
        }
      }
    }
    return result;
  };
  this.clearSelectedListItem = function() {
    this.element.find("li.selected").removeClass("selected");
  };
  this.selectNewListItem = function(text, direction, userEdit) {
    var li = this.getSelectedListItem();
    if (!li.length) {
      li = this.selectFirstListItem();
    }
    var sib = null;
    if (direction == "down") {
      if (userEdit) {
        sib = this.getMatchItemNext(text);
      }
      if (sib == null) {
        sib = li.next();
      }
    } else {
      if (direction == "up") {
        if (userEdit) {
          sib = this.getMatchItemPrev(text);
        }
        if (sib == null) {
          sib = li.prev();
        }
      }
    }
    if (sib != null) {
      this.selectListItem(sib);
      this.unselectListItem(li);
    }
  };
  this.selectListItem = function(li) {
    this.clearSelectedListItem();
    li.addClass("selected");
    this.scrollToListItem(li);
  };
  this.selectFirstListItem = function() {
    var first = this.element.find("li:first");
    this.selectListItem(first);
    return first;
  };
  this.unselectListItem = function(list_item) {
    list_item.removeClass("selected");
  };
  this.getSelectedListItem = function() {
    return this.element.find("li.selected");
  };
  this.scrollToListItem = function(list_item) {
    if (this.list_height && (list_item != null && list_item.length > 0)) {
      this.element.scrollTop(list_item[0].offsetTop - this.list_height / 2);
    }
  };
  this.init = function() {
    this.element = $('<div class="editable-select-options"></div>').appendTo($(document.body));
  };
  this.init();
};
var EditableSelectStatic = {wrappers:{}, instances:[], handlers:{}, inited:false, context:null, init:function() {
  this.initEvents();
  this.inited = true;
}, initEvents:function() {
}, GetWrapper:function(wrapperId) {
  if (isEmpty(wrapperId) || isEmpty(this.wrappers[wrapperId])) {
    this.wrappers[wrapperId] = new EditableSelectWrapper(wrapperId);
  }
  return this.wrappers[wrapperId];
}, UpdateWrapper:function(id, values) {
  this.GetWrapper(id).UpdateValues(values);
}};
(function($) {
  $.fn.editableSelect = function(options) {
    if (!EditableSelectStatic.inited) {
      EditableSelectStatic.init();
    }
    var me = this;
    var defaults = {bg_iframe:false, onSelect:true, items_then_scroll:10, case_sensitive:false};
    var settings = $.extend(defaults, options);
    var instance = false;
    $(this).each(function(i, domElement) {
      var element = $(domElement);
      if (element.data("editable-selecter") == undefined) {
        EditableSelectStatic.instances.push(new EditableSelect(domElement, settings));
        element.data("editable-selecter", EditableSelectStatic.instances.length - 1);
      }
    });
    return $(this);
  };
  $.fn.editableSelectInstances = function() {
    var ret = [];
    $(this).each(function() {
      if ($(this).data("editable-selecter") !== undefined) {
        ret[ret.length] = EditableSelectStatic.instances[$(this).data("editable-selecter")];
      }
    });
    return ret;
  };
  var EditableSelect = function(select, settings) {
    this.init(select, settings);
  };
  EditableSelect.prototype = {isActive:false, settings:false, textControl:false, select:false, wrapper:false, wrapperId:null, list_is_visible:false, hide_on_blur_timeout:false, bg_iframe:false, padding_right:13, current_value:"", options_value:[], userEdit:false, autoShow:false, init:function(select, settings) {
    this.settings = settings;
    this.wrapperId = this.settings.wrapperId;
    this.wrapper = EditableSelectStatic.GetWrapper(this.wrapperId);
    this.handler = this.settings.onSelect;
    if (!isEmpty(this.wrapperId)) {
      EditableSelectStatic.handlers[this.wrapperId] = this.settings.onSelect;
    }
    this.options = [];
    if (!isEmpty(this.settings.options)) {
      this.options = this.settings.options;
    }
    this.select = $(select);
    this.textControl = $('<input type="text">');
    this.textControl.attr("aria-label", this.select.attr("aria-label"));
    this.textControl.val(this.settings.value);
    this.textControl.attr("name", this.select.attr("name"));
    this.textControl.data("editable-selecter", this.select.data("editable-selecter"));
    this.select.attr("disabled", "disabled");
    var id = this.select.attr("id");
    if (!id) {
      id = "editable-select" + EditableSelectStatic.instances.length;
    }
    this.id = id;
    this.textControl.attr("id", id);
    this.textControl.attr("autocomplete", "off");
    this.textControl.addClass("editable-select");
    this.select.attr("id", id + "_hidden_select");
    this.initInputEvents(this.textControl, this);
    this.duplicateOptions();
    this.positionElements();
    this.setWidths();
    if (this.settings.bg_iframe) {
      var bg_iframe = $('<iframe frameborder="0" class="editable-select-iframe" src="about:blank;"></iframe>');
      $(document.body).append(bg_iframe);
      bg_iframe.width(this.select.width() + 2);
      bg_iframe.height(this.wrapper.element.height());
      bg_iframe.css({top:this.wrapper.element.css("top"), left:this.wrapper.element.css("left")});
      this.bg_iframe = bg_iframe;
    }
  }, duplicateOptions:function() {
    var me = this;
    var wrapperCleared = false;
    var values = new Array;
    this.select.find("option").each(function(index, option) {
      var $option = $(option);
      var text = $option.text();
      var val = $option.attr("value");
      var selected = false;
      if ($option.attr("selected") || option.selected) {
        me.textControl.val(text);
        me.current_value = text;
        me.current_options_value = val;
        selected = true;
      }
      var cssClass = $option.attr("class");
      values.push({selected:selected, text:text, value:val, cssClass:cssClass});
    });
    if (values.length > 0) {
      this.wrapper.UpdateValues(values);
      this.wrapper.element.addClass("disable-selection");
      this.wrapper.checkScroll(this.settings.items_then_scroll);
    }
  }, getControl:function() {
    return this.textControl;
  }, onSelect:function() {
    var context = this.wrapper.currentContext;
    if (typeof context.handler == "function") {
      context.handler.call(context, context.textControl);
    }
  }, editStart:function() {
    if (this.isActive) {
      return;
    }
    this.isActive = true;
    this.current_value = this.textControl.val();
    this.userEdit = false;
    this.adjustWrapper(this);
    if (this.autoShow) {
      this.showList();
    }
  }, editEnd:function() {
    if (!this.isActive) {
      return;
    }
    this.wrapper.clearSelectedListItem();
    this.hideList();
    this.onSelect();
    this.isActive = false;
  }, onTextboxChanged:function(reset_options_value) {
    if (this.textControl.val() != this.current_value) {
      this.userEdit = true;
      this.current_value = this.textControl.val();
      this.wrapper.highlightSelected(this.textControl.val());
    }
  }, initInputEvents:function(textControl, me2) {
    var me = this;
    var timer = false;
    textControl.focus(function(e) {
      me.editStart();
    }).blur(function(e) {
      if (!me.list_is_visible) {
        me.editEnd();
      }
    }).click(function(e) {
      e.stopPropagation();
      me.editStart();
      if (e.pageX - $(this).offset().left > $(this).width() - 16) {
        if (me.list_is_visible) {
          me.hideList();
        } else {
          me.showList();
        }
      }
    }).keydown(function(e) {
      me.isActive = true;
      switch(e.keyCode) {
        case 40:
          if (!me.listIsVisible()) {
            me.showList();
          } else {
            e.preventDefault();
            me.wrapper.selectNewListItem(me.textControl.val(), "down", me.userEdit);
          }
          break;
        case 38:
          if (!me.listIsVisible()) {
            me.showList();
          } else {
            e.preventDefault();
            me.wrapper.selectNewListItem(me.textControl.val(), "up", me.userEdit);
          }
          break;
        case 9:
          var $li = me.wrapper.getSelectedListItem();
          if ($li.length) {
            me.pickListItem($li.text(), me.getListValue($li[0].value));
          }
          break;
        case 27:
          e.preventDefault();
          me.editEnd();
          return false;
          break;
        case 13:
          e.preventDefault();
          if (!me.list_is_visible) {
            me.editEnd();
          } else {
            var $li = me.wrapper.getSelectedListItem();
            if ($li.length) {
              me.pickListItem($li.text(), me.getListValue($li[0].value));
            }
          }
          return false;
          break;
      }
    }).keyup($.debounce(me.onTextboxChanged, 100, me)).keypress(function(e) {
      if (e.keyCode == 13) {
        e.preventDefault();
        return false;
      }
    });
  }, pickListItem:function(text, val) {
    this.current_value = text;
    this.current_options_value = val;
    this.textControl.val(val);
    this.editEnd();
  }, listIsVisible:function() {
    return this.list_is_visible;
  }, adjustWrapper:function(context) {
    this.adjustWrapperPosition();
    this.adjustWrapperSize();
    EditableSelectStatic.context = context;
    this.wrapper.currentContext = context;
  }, adjustWrapperPosition:function() {
    var offset = this.textControl.offset();
    offset.top += this.textControl[0].offsetHeight;
    this.wrapper.element.css({top:offset.top + "px", left:offset.left + "px"});
  }, adjustWrapperSize:function() {
    var width = this.textControl[0].clientWidth;
    this.wrapper.element.width(width);
    this.textControl.width(width);
  }, showList:function() {
    this.hideOtherLists();
    this.overlay = new $.ui.editableSelectOverlay.overlay(this);
    this.wrapper.element.show();
    this.adjustWrapper(this);
    this.list_is_visible = true;
    if (this.settings.bg_iframe) {
      this.bg_iframe.show();
    }
    this.wrapper.checkScroll(10);
    this.wrapper.highlightSelected(this.textControl.val());
  }, getListValue:function(index) {
    return this.wrapper.values[index];
  }, hideList:function() {
    if (this.overlay != null) {
      this.overlay.destroy();
    }
    this.wrapper.element.hide();
    this.list_is_visible = false;
    if (this.settings.bg_iframe) {
      this.bg_iframe.hide();
    }
  }, hideOtherLists:function() {
    for (var i = 0;i < EditableSelectStatic.instances.length;i++) {
      if (i != this.select.data("editable-selecter")) {
        EditableSelectStatic.instances[i].hideList();
      }
    }
  }, positionElements:function() {
    this.select.after(this.textControl);
    this.select.hide();
    $(document.body).append(this.wrapper.element);
  }, setWidths:function() {
    var width = this.select.width() + 2 * 0;
    if (this.bg_iframe) {
      this.bg_iframe.width(width + 4);
    }
  }};
  $.ui.editableSelectOverlay = {overlay:function(dialog) {
    this.$el = $.ui.editableSelectOverlay.overlay.create(dialog);
  }};
  $.extend($.ui.editableSelectOverlay.overlay, {self:this, instances:[], oldInstances:[], maxZ:4E3, events:$.map("focus,mousedown,keydown,keypress".split(","), function(event) {
    return event + ".dialog-overlay";
  }).join(" "), create:function(dialog) {
    if (this.instances.length === 0) {
      $(window).bind("resize.dialog-overlay", $.ui.editableSelectOverlay.overlay.resize);
    }
    var $el = $('<div class="editable-select-options-overlay"></div>').appendTo(dialog.textControl.parent()).css({width:this.width(), height:this.height()});
    $el.bind("mousedown.dialog-overlay", function(event) {
      dialog.editEnd();
      var element = document.elementFromPoint(event.clientX, event.clientY);
      if (element != null) {
        try {
          var eventName = "click";
          if (element.dispatchEvent) {
            var e = document.createEvent("MouseEvent");
            e.initMouseEvent(eventName, true, true, window, 0, event.screenX, event.screenY, event.clientX, event.clientY, false, false, false, false, 0, null);
            element.dispatchEvent(e);
          } else {
            if (element.fireEvent) {
              element.fireEvent("on" + eventName);
            }
          }
        } catch (err) {
        }
      }
    });
    if ($.fn.bgiframe) {
      $el.bgiframe();
    }
    this.instances.push($el);
    return $el;
  }, destroy:function($el) {
    if ($el != null) {
      $el.remove();
    }
    if (this.instances.length === 0) {
      $([document, window]).unbind(".dialog-overlay");
    }
  }, height:function() {
    var scrollHeight, offsetHeight;
    return $(document).height() + "px";
  }, width:function() {
    var scrollWidth, offsetWidth;
    return $(document).width() + "px";
  }, resize:function() {
    var $overlays = $([]);
    $.each($.ui.editableSelectOverlay.overlay.instances, function() {
      $overlays = $overlays.add(this);
    });
    $overlays.css({width:0, height:0}).css({width:$.ui.editableSelectOverlay.overlay.width(), height:$.ui.editableSelectOverlay.overlay.height()});
  }});
  $.extend($.ui.editableSelectOverlay.overlay.prototype, {destroy:function() {
    $.ui.editableSelectOverlay.overlay.destroy(this.$el);
  }});
})(jQuery);
(function($) {
  var R = $.refresh = $.fn.refresh = function(a, b, c) {
    return R.setup(opts.apply(this, arguments));
  };
  function opts(a, b, c) {
    var r = $.extend({}, R);
    if (typeof a == "string") {
      r.url = a;
      if (b && !$.isFunction(b)) {
        r.time = b;
      } else {
        c = b;
      }
      if (c) {
        r.success = c;
      }
    } else {
      $.extend(r, a);
    }
    if (!r.method) {
      r.method = $.rest ? "Read" : "ajax";
    }
    if (!r.target) {
      r.target = this ? this : $;
    }
    if (!r.type && !$.rest) {
      r.type = "GET";
    }
    return r;
  }
  $.extend(R, {version:"0.5", url:null, time:178, success:null, method:null, setup:function(r) {
    if (r.cancel) {
      r.cancel();
    }
    r.id = setInterval(function() {
      r.refresh(r);
    }, r.time * 1E3);
    r.cancel = function() {
      clearInterval(r.id);
      return r;
    };
    return r;
  }, refresh:function(r) {
    if (r.lastReturn) {
      delete r.lastReturn;
    }
    r.lastReturn = r.target[r.method](r);
  }});
})(jQuery);
jQuery.tableDnD = {currentTable:null, dragObject:null, mouseOffset:null, oldY:0, build:function(options) {
  this.each(function() {
    this.tableDnDConfig = jQuery.extend({onDragStyle:null, onDropStyle:null, onDragClass:"tDnD_whileDrag", onDrop:null, onDragStart:null, scrollAmount:5, serializeRegexp:/[^\-]*$/, serializeParamName:null, dragHandle:null}, options || {});
    jQuery.tableDnD.makeDraggable(this);
  });
  jQuery(document).bind("mousemove", jQuery.tableDnD.mousemove).bind("mouseup", jQuery.tableDnD.mouseup);
  return this;
}, makeDraggable:function(table) {
  var config = table.tableDnDConfig;
  if (table.tableDnDConfig.dragHandle) {
    $(document).on("mousedown", "#qb-ui-grid td." + table.tableDnDConfig.dragHandle, function(ev) {
      jQuery.tableDnD.dragObject = this.parentNode;
      jQuery.tableDnD.currentTable = table;
      jQuery.tableDnD.mouseOffset = jQuery.tableDnD.getMouseOffset(this, ev);
      if (config.onDragStart) {
        config.onDragStart(table, this);
      }
      return false;
    });
  } else {
    var rows = jQuery("tr", table);
    $(document).on("mousedown", "#qb-ui-grid table td." + table.tableDnDConfig.dragHandle, function(ev) {
      if (ev.target.tagName == "TD") {
        jQuery.tableDnD.dragObject = this;
        jQuery.tableDnD.currentTable = table;
        jQuery.tableDnD.mouseOffset = jQuery.tableDnD.getMouseOffset(this, ev);
        if (config.onDragStart) {
          config.onDragStart(table, this);
        }
        return false;
      }
    });
  }
}, updateTables:function() {
  this.each(function() {
    if (this.tableDnDConfig) {
      jQuery.tableDnD.makeDraggable(this);
    }
  });
}, mouseCoords:function(ev) {
  if (ev.pageX || ev.pageY) {
    return{x:ev.pageX, y:ev.pageY};
  }
  return{x:ev.clientX + document.body.scrollLeft - document.body.clientLeft, y:ev.clientY + document.body.scrollTop - document.body.clientTop};
}, getMouseOffset:function(target, ev) {
  ev = ev || window.event;
  var docPos = this.getPosition(target);
  var mousePos = this.mouseCoords(ev);
  return{x:mousePos.x - docPos.x, y:mousePos.y - docPos.y};
}, getPosition:function(e) {
  var left = 0;
  var top = 0;
  if (e.offsetHeight == 0) {
    e = e.firstChild;
  }
  while (e.offsetParent) {
    left += e.offsetLeft;
    top += e.offsetTop;
    e = e.offsetParent;
  }
  left += e.offsetLeft;
  top += e.offsetTop;
  return{x:left, y:top};
}, mousemove:function(ev) {
  if (jQuery.tableDnD.dragObject == null) {
    return;
  }
  var dragObj = jQuery(jQuery.tableDnD.dragObject);
  var config = jQuery.tableDnD.currentTable.tableDnDConfig;
  var mousePos = jQuery.tableDnD.mouseCoords(ev);
  var y = mousePos.y - jQuery.tableDnD.mouseOffset.y;
  var yOffset = window.pageYOffset;
  if (document.all) {
    if (typeof document.compatMode != "undefined" && document.compatMode != "BackCompat") {
      yOffset = document.documentElement.scrollTop;
    } else {
      if (typeof document.body != "undefined") {
        yOffset = document.body.scrollTop;
      }
    }
  }
  if (mousePos.y - yOffset < config.scrollAmount) {
    window.scrollBy(0, -config.scrollAmount);
  } else {
    var windowHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
    if (windowHeight - (mousePos.y - yOffset) < config.scrollAmount) {
      window.scrollBy(0, config.scrollAmount);
    }
  }
  if (y != jQuery.tableDnD.oldY) {
    var movingDown = y > jQuery.tableDnD.oldY;
    jQuery.tableDnD.oldY = y;
    if (config.onDragClass) {
      dragObj.addClass(config.onDragClass);
    } else {
      dragObj.css(config.onDragStyle);
    }
    var currentRow = jQuery.tableDnD.findDropTargetRow(dragObj, y);
    if (currentRow && currentRow.className != "ui-qb-grid-row-header") {
      if (movingDown && jQuery.tableDnD.dragObject != currentRow) {
        jQuery.tableDnD.dragObject.parentNode.insertBefore(jQuery.tableDnD.dragObject, currentRow.nextSibling);
      } else {
        if (!movingDown && jQuery.tableDnD.dragObject != currentRow) {
          jQuery.tableDnD.dragObject.parentNode.insertBefore(jQuery.tableDnD.dragObject, currentRow);
        }
      }
    }
  }
  return false;
}, findDropTargetRow:function(draggedRow, y) {
  var rows = jQuery.tableDnD.currentTable.rows;
  for (var i = 0;i < rows.length;i++) {
    var row = rows[i];
    var rowY = this.getPosition(row).y;
    var rowHeight = parseInt(row.offsetHeight) / 2;
    if (row.offsetHeight == 0) {
      rowY = this.getPosition(row.firstChild).y;
      rowHeight = parseInt(row.firstChild.offsetHeight) / 2;
    }
    if (y > rowY - rowHeight && y < rowY + rowHeight) {
      if (row == draggedRow) {
        return null;
      }
      var config = jQuery.tableDnD.currentTable.tableDnDConfig;
      if (config.onAllowDrop) {
        if (config.onAllowDrop(draggedRow, row)) {
          return row;
        } else {
          return null;
        }
      } else {
        var nodrop = jQuery(row).hasClass("nodrop");
        if (!nodrop) {
          return row;
        } else {
          return null;
        }
      }
      return row;
    }
  }
  return null;
}, mouseup:function(e) {
  if (jQuery.tableDnD.currentTable && jQuery.tableDnD.dragObject) {
    var droppedRow = jQuery.tableDnD.dragObject;
    var config = jQuery.tableDnD.currentTable.tableDnDConfig;
    if (config.onDragClass) {
      jQuery(droppedRow).removeClass(config.onDragClass);
    } else {
      jQuery(droppedRow).css(config.onDropStyle);
    }
    jQuery.tableDnD.dragObject = null;
    if (config.onDrop) {
      config.onDrop(jQuery.tableDnD.currentTable, droppedRow);
    }
    jQuery.tableDnD.currentTable = null;
  }
}, serialize:function() {
  if (jQuery.tableDnD.currentTable) {
    return jQuery.tableDnD.serializeTable(jQuery.tableDnD.currentTable);
  } else {
    return "Error: No Table id set, you need to set an id on your table and every row";
  }
}, serializeTable:function(table) {
  var result = "";
  var tableId = table.id;
  var rows = table.rows;
  for (var i = 0;i < rows.length;i++) {
    if (result.length > 0) {
      result += "&";
    }
    var rowId = rows[i].id;
    if (rowId && (rowId && (table.tableDnDConfig && table.tableDnDConfig.serializeRegexp))) {
      rowId = rowId.match(table.tableDnDConfig.serializeRegexp)[0];
    }
    result += tableId + "[]=" + rowId;
  }
  return result;
}, serializeTables:function() {
  var result = "";
  this.each(function() {
    result += jQuery.tableDnD.serializeTable(this);
  });
  return result;
}};
jQuery.fn.extend({tableDnD:jQuery.tableDnD.build, tableDnDUpdate:jQuery.tableDnD.updateTables, tableDnDSerialize:jQuery.tableDnD.serializeTables});
(function($) {
  $.widget("ui.selectmenu", {options:{appendTo:"body", typeAhead:1E3, style:"dropdown", positionOptions:null, width:null, menuWidth:null, handleWidth:26, maxHeight:null, icons:null, format:null, escapeHtml:false, bgImage:function() {
  }}, _create:function() {
    var self = this, o = this.options;
    var selectmenuId = this.element.uniqueId().attr("id");
    this.ids = [selectmenuId, selectmenuId + "-button", selectmenuId + "-menu"];
    this._safemouseup = true;
    this.isOpen = false;
    this.newelement = $("<a />", {"class":"ui-selectmenu ui-widget ui-state-default ui-corner-all", "id":this.ids[1], "role":"button", "href":"#nogo", "tabindex":this.element.attr("disabled") ? 1 : 0, "aria-haspopup":true, "aria-owns":this.ids[2]});
    this.newelementWrap = $("<span />").append(this.newelement).insertAfter(this.element);
    var tabindex = this.element.attr("tabindex");
    if (tabindex) {
      this.newelement.attr("tabindex", tabindex);
    }
    this.newelement.data("selectelement", this.element);
    this.selectmenuIcon = $('<span class="ui-selectmenu-icon ui-icon"></span>').prependTo(this.newelement);
    this.newelement.prepend('<span class="ui-selectmenu-status" />');
    this.element.bind({"click.selectmenu":function(event) {
      self.newelement.focus();
      event.preventDefault();
    }});
    this.newelement.bind("mousedown.selectmenu", function(event) {
      self._toggle(event, true);
      if (o.style == "popup") {
        self._safemouseup = false;
        setTimeout(function() {
          self._safemouseup = true;
        }, 300);
      }
      event.preventDefault();
    }).bind("click.selectmenu", function(event) {
      event.preventDefault();
    }).bind("keydown.selectmenu", function(event) {
      var ret = false;
      switch(event.keyCode) {
        case $.ui.keyCode.ENTER:
          ret = true;
          break;
        case $.ui.keyCode.SPACE:
          self._toggle(event);
          break;
        case $.ui.keyCode.UP:
          if (event.altKey) {
            self.open(event);
          } else {
            self._moveSelection(-1);
          }
          break;
        case $.ui.keyCode.DOWN:
          if (event.altKey) {
            self.open(event);
          } else {
            self._moveSelection(1);
          }
          break;
        case $.ui.keyCode.LEFT:
          self._moveSelection(-1);
          break;
        case $.ui.keyCode.RIGHT:
          self._moveSelection(1);
          break;
        case $.ui.keyCode.TAB:
          ret = true;
          break;
        case $.ui.keyCode.PAGE_UP:
        ;
        case $.ui.keyCode.HOME:
          self.index(0);
          break;
        case $.ui.keyCode.PAGE_DOWN:
        ;
        case $.ui.keyCode.END:
          self.index(self._optionLis.length);
          break;
        default:
          ret = true;
      }
      return ret;
    }).bind("keypress.selectmenu", function(event) {
      if (event.which > 0) {
        self._typeAhead(event.which, "mouseup");
      }
      return true;
    }).bind("mouseover.selectmenu", function() {
      if (!o.disabled) {
        $(this).addClass("ui-state-hover");
      }
    }).bind("mouseout.selectmenu", function() {
      if (!o.disabled) {
        $(this).removeClass("ui-state-hover");
      }
    }).bind("focus.selectmenu", function() {
      if (!o.disabled) {
        $(this).addClass("ui-state-focus");
      }
    }).bind("blur.selectmenu", function() {
      if (!o.disabled) {
        $(this).removeClass("ui-state-focus");
      }
    });
    $(document).bind("mousedown.selectmenu-" + this.ids[0], function(event) {
      if (self.isOpen && !$(event.target).closest("#" + self.ids[1]).length) {
        self.close(event);
      }
    });
    this.element.bind("click.selectmenu", function() {
      self._refreshValue();
    }).bind("focus.selectmenu", function() {
      if (self.newelement) {
        self.newelement[0].focus();
      }
    });
    if (!o.width) {
      o.width = this.element.outerWidth();
    }
    this.newelement.width(o.width);
    this.element.hide();
    this.list = $("<ul />", {"class":"ui-widget ui-widget-content", "aria-hidden":true, "role":"listbox", "aria-labelledby":this.ids[1], "id":this.ids[2]});
    this.listWrap = $("<div />", {"class":"ui-selectmenu-menu"}).append(this.list).appendTo(o.appendTo);
    this.list.bind("keydown.selectmenu", function(event) {
      var ret = false;
      switch(event.keyCode) {
        case $.ui.keyCode.UP:
          if (event.altKey) {
            self.close(event, true);
          } else {
            self._moveFocus(-1);
          }
          break;
        case $.ui.keyCode.DOWN:
          if (event.altKey) {
            self.close(event, true);
          } else {
            self._moveFocus(1);
          }
          break;
        case $.ui.keyCode.LEFT:
          self._moveFocus(-1);
          break;
        case $.ui.keyCode.RIGHT:
          self._moveFocus(1);
          break;
        case $.ui.keyCode.HOME:
          self._moveFocus(":first");
          break;
        case $.ui.keyCode.PAGE_UP:
          self._scrollPage("up");
          break;
        case $.ui.keyCode.PAGE_DOWN:
          self._scrollPage("down");
          break;
        case $.ui.keyCode.END:
          self._moveFocus(":last");
          break;
        case $.ui.keyCode.ENTER:
        ;
        case $.ui.keyCode.SPACE:
          self.close(event, true);
          $(event.target).parents("li:eq(0)").trigger("mouseup");
          break;
        case $.ui.keyCode.TAB:
          ret = true;
          self.close(event, true);
          $(event.target).parents("li:eq(0)").trigger("mouseup");
          break;
        case $.ui.keyCode.ESCAPE:
          self.close(event, true);
          break;
        default:
          ret = true;
      }
      return ret;
    }).bind("keypress.selectmenu", function(event) {
      if (event.which > 0) {
        self._typeAhead(event.which, "focus");
      }
      return true;
    }).bind("mousedown.selectmenu mouseup.selectmenu", function() {
      return false;
    });
    $(window).bind("resize.selectmenu-" + this.ids[0], $.proxy(self.close, this));
  }, _init:function() {
    var self = this, o = this.options;
    var selectOptionData = [];
    this.element.find("option").each(function() {
      var opt = $(this);
      selectOptionData.push({value:opt.attr("value"), text:self._formatText(opt.text(), opt), selected:opt.attr("selected"), disabled:opt.attr("disabled"), classes:opt.attr("class"), typeahead:opt.attr("typeahead"), parentOptGroup:opt.parent("optgroup"), bgImage:o.bgImage.call(opt)});
    });
    var activeClass = self.options.style == "popup" ? " ui-state-active" : "";
    this.list.html("");
    if (selectOptionData.length) {
      for (var i = 0;i < selectOptionData.length;i++) {
        var thisLiAttr = {role:"presentation"};
        if (selectOptionData[i].disabled) {
          thisLiAttr["class"] = "ui-state-disabled";
        }
        var thisAAttr = {html:selectOptionData[i].text || "&nbsp;", href:"#nogo", tabindex:-1, role:"option", "aria-selected":false};
        if (selectOptionData[i].disabled) {
          thisAAttr["aria-disabled"] = true;
        }
        if (selectOptionData[i].typeahead) {
          thisAAttr["typeahead"] = selectOptionData[i].typeahead;
        }
        var thisA = $("<a/>", thisAAttr).bind("focus.selectmenu", function() {
          $(this).parent().mouseover();
        }).bind("blur.selectmenu", function() {
          $(this).parent().mouseout();
        });
        var thisLi = $("<li/>", thisLiAttr).append(thisA).data("index", i).addClass(selectOptionData[i].classes).data("optionClasses", selectOptionData[i].classes || "").bind("mouseup.selectmenu", function(event) {
          if (self._safemouseup && (!self._disabled(event.currentTarget) && !self._disabled($(event.currentTarget).parents("ul > li.ui-selectmenu-group ")))) {
            self.index($(this).data("index"));
            self.select(event);
            self.close(event, true);
          }
          return false;
        }).bind("click.selectmenu", function() {
          return false;
        }).bind("mouseover.selectmenu", function(e) {
          if (!$(this).hasClass("ui-state-disabled") && !$(this).parent("ul").parent("li").hasClass("ui-state-disabled")) {
            e.optionValue = self.element[0].options[$(this).data("index")].value;
            self._trigger("hover", e, self._uiHash());
            self._selectedOptionLi().addClass(activeClass);
            self._focusedOptionLi().removeClass("ui-selectmenu-item-focus ui-state-hover");
            $(this).removeClass("ui-state-active").addClass("ui-selectmenu-item-focus ui-state-hover");
          }
        }).bind("mouseout.selectmenu", function(e) {
          if ($(this).is(self._selectedOptionLi())) {
            $(this).addClass(activeClass);
          }
          e.optionValue = self.element[0].options[$(this).data("index")].value;
          self._trigger("blur", e, self._uiHash());
          $(this).removeClass("ui-selectmenu-item-focus ui-state-hover");
        });
        if (selectOptionData[i].parentOptGroup.length) {
          var optGroupName = "ui-selectmenu-group-" + this.element.find("optgroup").index(selectOptionData[i].parentOptGroup);
          if (this.list.find("li." + optGroupName).length) {
            this.list.find("li." + optGroupName + ":last ul").append(thisLi);
          } else {
            $('<li role="presentation" class="ui-selectmenu-group ' + optGroupName + (selectOptionData[i].parentOptGroup.attr("disabled") ? " " + 'ui-state-disabled" aria-disabled="true"' : '"') + '><span class="ui-selectmenu-group-label">' + selectOptionData[i].parentOptGroup.attr("label") + "</span><ul></ul></li>").appendTo(this.list).find("ul").append(thisLi);
          }
        } else {
          thisLi.appendTo(this.list);
        }
        if (o.icons) {
          for (var j in o.icons) {
            if (thisLi.is(o.icons[j].find)) {
              thisLi.data("optionClasses", selectOptionData[i].classes + " ui-selectmenu-hasIcon").addClass("ui-selectmenu-hasIcon");
              var iconClass = o.icons[j].icon || "";
              thisLi.find("a:eq(0)").prepend('<span class="ui-selectmenu-item-icon ui-icon ' + iconClass + '"></span>');
              if (selectOptionData[i].bgImage) {
                thisLi.find("span").css("background-image", selectOptionData[i].bgImage);
              }
            }
          }
        }
      }
    } else {
      $('<li role="presentation"><a href="#nogo" tabindex="-1" role="option"></a></li>').appendTo(this.list);
    }
    var isDropDown = o.style == "dropdown";
    this.newelement.toggleClass("ui-selectmenu-dropdown", isDropDown).toggleClass("ui-selectmenu-popup", !isDropDown);
    this.list.toggleClass("ui-selectmenu-menu-dropdown ui-corner-bottom", isDropDown).toggleClass("ui-selectmenu-menu-popup ui-corner-all", !isDropDown).find("li:first").toggleClass("ui-corner-top", !isDropDown).end().find("li:last").addClass("ui-corner-bottom");
    this.selectmenuIcon.toggleClass("ui-icon-triangle-1-s", isDropDown).toggleClass("ui-icon-triangle-2-n-s", !isDropDown);
    if (o.style == "dropdown") {
      this.list.width(o.menuWidth ? o.menuWidth : o.width);
    } else {
      this.list.width(o.menuWidth ? o.menuWidth : o.width - o.handleWidth);
    }
    if (!navigator.userAgent.match(/Android 2/)) {
      var listH = this.listWrap.height();
      var winH = $(window).height();
      var maxH = o.maxHeight ? Math.min(o.maxHeight, winH) : winH / 3;
      if (listH > maxH) {
        this.list.height(maxH);
      }
    }
    this._optionLis = this.list.find("li:not(.ui-selectmenu-group)");
    if (this.element.attr("disabled")) {
      this.disable();
    } else {
      this.enable();
    }
    this._refreshValue();
    this._selectedOptionLi().addClass("ui-selectmenu-item-focus");
    clearTimeout(this.refreshTimeout);
    this.refreshTimeout = window.setTimeout(function() {
      self._refreshPosition();
    }, 200);
  }, destroy:function() {
    this.element.removeData(this.widgetName).removeClass("ui-selectmenu-disabled" + " " + "ui-state-disabled").removeAttr("aria-disabled").unbind(".selectmenu");
    $(window).unbind(".selectmenu-" + this.ids[0]);
    $(document).unbind(".selectmenu-" + this.ids[0]);
    this.newelementWrap.remove();
    this.listWrap.remove();
    this.element.unbind(".selectmenu").show();
    $.Widget.prototype.destroy.apply(this, arguments);
  }, _typeAhead:function(code, eventType) {
    var self = this, c = String.fromCharCode(code).toLowerCase(), matchee = null, nextIndex = null;
    if (self._typeAhead_timer) {
      window.clearTimeout(self._typeAhead_timer);
      self._typeAhead_timer = undefined;
    }
    self._typeAhead_chars = (self._typeAhead_chars === undefined ? "" : self._typeAhead_chars).concat(c);
    if (self._typeAhead_chars.length < 2 || self._typeAhead_chars.substr(-2, 1) === c && self._typeAhead_cycling) {
      self._typeAhead_cycling = true;
      matchee = c;
    } else {
      self._typeAhead_cycling = false;
      matchee = self._typeAhead_chars;
    }
    var selectedIndex = (eventType !== "focus" ? this._selectedOptionLi().data("index") : this._focusedOptionLi().data("index")) || 0;
    for (var i = 0;i < this._optionLis.length;i++) {
      var thisText = this._optionLis.eq(i).text().substr(0, matchee.length).toLowerCase();
      if (thisText === matchee) {
        if (self._typeAhead_cycling) {
          if (nextIndex === null) {
            nextIndex = i;
          }
          if (i > selectedIndex) {
            nextIndex = i;
            break;
          }
        } else {
          nextIndex = i;
        }
      }
    }
    if (nextIndex !== null) {
      this._optionLis.eq(nextIndex).find("a").trigger(eventType);
    }
    self._typeAhead_timer = window.setTimeout(function() {
      self._typeAhead_timer = undefined;
      self._typeAhead_chars = undefined;
      self._typeAhead_cycling = undefined;
    }, self.options.typeAhead);
  }, _uiHash:function() {
    var index = this.index();
    return{index:index, option:$("option", this.element).get(index), value:this.element[0].value};
  }, open:function(event) {
    if (this.newelement.attr("aria-disabled") != "true") {
      var self = this, o = this.options, selected = this._selectedOptionLi(), link = selected.find("a");
      self._closeOthers(event);
      self.newelement.addClass("ui-state-active");
      self.list.attr("aria-hidden", false);
      self.listWrap.addClass("ui-selectmenu-open");
      if (o.style == "dropdown") {
        self.newelement.removeClass("ui-corner-all").addClass("ui-corner-top");
      } else {
        this.list.css("left", -5E3).scrollTop(this.list.scrollTop() + selected.position().top - this.list.outerHeight() / 2 + selected.outerHeight() / 2).css("left", "auto");
      }
      self._refreshPosition();
      if (link.length) {
        link[0].focus();
      }
      self.isOpen = true;
      self._trigger("open", event, self._uiHash());
    }
  }, close:function(event, retainFocus) {
    if (this.newelement.is(".ui-state-active")) {
      this.newelement.removeClass("ui-state-active");
      this.listWrap.removeClass("ui-selectmenu-open");
      this.list.attr("aria-hidden", true);
      if (this.options.style == "dropdown") {
        this.newelement.removeClass("ui-corner-top").addClass("ui-corner-all");
      }
      if (retainFocus) {
        this.newelement.focus();
      }
      this.isOpen = false;
      this._trigger("close", event, this._uiHash());
    }
  }, change:function(event) {
    this.element.trigger("change");
    this._trigger("change", event, this._uiHash());
  }, select:function(event) {
    if (this._disabled(event.currentTarget)) {
      return false;
    }
    this._trigger("select", event, this._uiHash());
  }, widget:function() {
    return this.listWrap.add(this.newelementWrap);
  }, _closeOthers:function(event) {
    $(".ui-selectmenu.ui-state-active").not(this.newelement).each(function() {
      $(this).data("selectelement").selectmenu("close", event);
    });
    $(".ui-selectmenu.ui-state-hover").trigger("mouseout");
  }, _toggle:function(event, retainFocus) {
    if (this.isOpen) {
      this.close(event, retainFocus);
    } else {
      this.open(event);
    }
  }, _formatText:function(text, opt) {
    if (this.options.format) {
      text = this.options.format(text, opt);
    } else {
      if (this.options.escapeHtml) {
        text = $("<div />").text(text).html();
      }
    }
    return text;
  }, _selectedIndex:function() {
    return this.element[0].selectedIndex;
  }, _selectedOptionLi:function() {
    return this._optionLis.eq(this._selectedIndex());
  }, _focusedOptionLi:function() {
    return this.list.find(".ui-selectmenu-item-focus");
  }, _moveSelection:function(amt, recIndex) {
    if (!this.options.disabled) {
      var currIndex = parseInt(this._selectedOptionLi().data("index") || 0, 10);
      var newIndex = currIndex + amt;
      if (newIndex < 0) {
        newIndex = 0;
      }
      if (newIndex > this._optionLis.size() - 1) {
        newIndex = this._optionLis.size() - 1;
      }
      if (newIndex === recIndex) {
        return false;
      }
      if (this._optionLis.eq(newIndex).hasClass("ui-state-disabled")) {
        amt > 0 ? ++amt : --amt;
        this._moveSelection(amt, newIndex);
      } else {
        this._optionLis.eq(newIndex).trigger("mouseover").trigger("mouseup");
      }
    }
  }, _moveFocus:function(amt, recIndex) {
    if (!isNaN(amt)) {
      var currIndex = parseInt(this._focusedOptionLi().data("index") || 0, 10);
      var newIndex = currIndex + amt;
    } else {
      var newIndex = parseInt(this._optionLis.filter(amt).data("index"), 10)
    }
    if (newIndex < 0) {
      newIndex = 0;
    }
    if (newIndex > this._optionLis.size() - 1) {
      newIndex = this._optionLis.size() - 1;
    }
    if (newIndex === recIndex) {
      return false;
    }
    var activeID = "ui-selectmenu-item-" + Math.round(Math.random() * 1E3);
    this._focusedOptionLi().find("a:eq(0)").attr("id", "");
    if (this._optionLis.eq(newIndex).hasClass("ui-state-disabled")) {
      amt > 0 ? ++amt : --amt;
      this._moveFocus(amt, newIndex);
    } else {
      this._optionLis.eq(newIndex).find("a:eq(0)").attr("id", activeID).focus();
    }
    this.list.attr("aria-activedescendant", activeID);
  }, _scrollPage:function(direction) {
    var numPerPage = Math.floor(this.list.outerHeight() / this._optionLis.first().outerHeight());
    numPerPage = direction == "up" ? -numPerPage : numPerPage;
    this._moveFocus(numPerPage);
  }, _setOption:function(key, value) {
    this.options[key] = value;
    if (key == "disabled") {
      if (value) {
        this.close();
      }
      this.element.add(this.newelement).add(this.list)[value ? "addClass" : "removeClass"]("ui-selectmenu-disabled " + "ui-state-disabled").attr("aria-disabled", value).attr("tabindex", value ? 1 : 0);
    }
  }, disable:function(index, type) {
    if (typeof index == "undefined") {
      this._setOption("disabled", true);
    } else {
      this._toggleEnabled(type || "option", index, false);
    }
  }, enable:function(index, type) {
    if (typeof index == "undefined") {
      this._setOption("disabled", false);
    } else {
      this._toggleEnabled(type || "option", index, true);
    }
  }, _disabled:function(elem) {
    return $(elem).hasClass("ui-state-disabled");
  }, _toggleEnabled:function(type, index, flag) {
    var element = this.element.find(type).eq(index), elements = type === "optgroup" ? this.list.find("li.ui-selectmenu-group-" + index) : this._optionLis.eq(index);
    if (elements) {
      elements.toggleClass("ui-state-disabled", !flag).attr("aria-disabled", !flag);
      if (flag) {
        element.removeAttr("disabled");
      } else {
        element.attr("disabled", "disabled");
      }
    }
  }, index:function(newIndex) {
    if (arguments.length) {
      if (!this._disabled($(this._optionLis[newIndex])) && newIndex != this._selectedIndex()) {
        this.element[0].selectedIndex = newIndex;
        this._refreshValue();
        this.change();
      } else {
        return false;
      }
    } else {
      return this._selectedIndex();
    }
  }, value:function(newValue) {
    if (arguments.length && newValue != this.element[0].value) {
      this.element[0].value = newValue;
      this._refreshValue();
      this.change();
    } else {
      return this.element[0].value;
    }
  }, _refreshValue:function() {
    var activeClass = this.options.style == "popup" ? " ui-state-active" : "";
    var activeID = "ui-selectmenu-item-" + Math.round(Math.random() * 1E3);
    this.list.find(".ui-selectmenu-item-selected").removeClass("ui-selectmenu-item-selected" + activeClass).find("a").attr("aria-selected", "false").attr("id", "");
    this._selectedOptionLi().addClass("ui-selectmenu-item-selected" + activeClass).find("a").attr("aria-selected", "true").attr("id", activeID);
    var currentOptionClasses = this.newelement.data("optionClasses") ? this.newelement.data("optionClasses") : "";
    var newOptionClasses = this._selectedOptionLi().data("optionClasses") ? this._selectedOptionLi().data("optionClasses") : "";
    this.newelement.removeClass(currentOptionClasses).data("optionClasses", newOptionClasses).addClass(newOptionClasses).find(".ui-selectmenu-status").html(this._selectedOptionLi().find("a:eq(0)").html());
    this.list.attr("aria-activedescendant", activeID);
  }, _refreshPosition:function() {
    var o = this.options, positionDefault = {of:this.newelement, my:"left top", at:"left bottom", collision:"flip"};
    if (o.style == "popup") {
      var selected = this._selectedOptionLi();
      positionDefault.my = "left top" + (this.list.offset().top - selected.offset().top - (this.newelement.outerHeight() + selected.outerHeight()) / 2);
      positionDefault.collision = "fit";
    }
    this.listWrap.removeAttr("style").zIndex(this.element.zIndex() + 2).position($.extend(positionDefault, o.positionOptions));
  }});
})(jQuery);
(function(glob) {
  var version = "0.4.2", has = "hasOwnProperty", separator = /[\.\/]/, wildcard = "*", fun = function() {
  }, numsort = function(a, b) {
    return a - b;
  }, current_event, stop, events = {n:{}}, eve = function(name, scope) {
    name = String(name);
    var e = events, oldstop = stop, args = Array.prototype.slice.call(arguments, 2), listeners = eve.listeners(name), z = 0, f = false, l, indexed = [], queue = {}, out = [], ce = current_event, errors = [];
    current_event = name;
    stop = 0;
    for (var i = 0, ii = listeners.length;i < ii;i++) {
      if ("zIndex" in listeners[i]) {
        indexed.push(listeners[i].zIndex);
        if (listeners[i].zIndex < 0) {
          queue[listeners[i].zIndex] = listeners[i];
        }
      }
    }
    indexed.sort(numsort);
    while (indexed[z] < 0) {
      l = queue[indexed[z++]];
      out.push(l.apply(scope, args));
      if (stop) {
        stop = oldstop;
        return out;
      }
    }
    for (i = 0;i < ii;i++) {
      l = listeners[i];
      if ("zIndex" in l) {
        if (l.zIndex == indexed[z]) {
          out.push(l.apply(scope, args));
          if (stop) {
            break;
          }
          do {
            z++;
            l = queue[indexed[z]];
            l && out.push(l.apply(scope, args));
            if (stop) {
              break;
            }
          } while (l);
        } else {
          queue[l.zIndex] = l;
        }
      } else {
        out.push(l.apply(scope, args));
        if (stop) {
          break;
        }
      }
    }
    stop = oldstop;
    current_event = ce;
    return out.length ? out : null;
  };
  eve._events = events;
  eve.listeners = function(name) {
    var names = name.split(separator), e = events, item, items, k, i, ii, j, jj, nes, es = [e], out = [];
    for (i = 0, ii = names.length;i < ii;i++) {
      nes = [];
      for (j = 0, jj = es.length;j < jj;j++) {
        e = es[j].n;
        items = [e[names[i]], e[wildcard]];
        k = 2;
        while (k--) {
          item = items[k];
          if (item) {
            nes.push(item);
            out = out.concat(item.f || []);
          }
        }
      }
      es = nes;
    }
    return out;
  };
  eve.on = function(name, f) {
    name = String(name);
    if (typeof f != "function") {
      return function() {
      };
    }
    var names = name.split(separator), e = events;
    for (var i = 0, ii = names.length;i < ii;i++) {
      e = e.n;
      e = e.hasOwnProperty(names[i]) && e[names[i]] || (e[names[i]] = {n:{}});
    }
    e.f = e.f || [];
    for (i = 0, ii = e.f.length;i < ii;i++) {
      if (e.f[i] == f) {
        return fun;
      }
    }
    e.f.push(f);
    return function(zIndex) {
      if (+zIndex == +zIndex) {
        f.zIndex = +zIndex;
      }
    };
  };
  eve.f = function(event) {
    var attrs = [].slice.call(arguments, 1);
    return function() {
      eve.apply(null, [event, null].concat(attrs).concat([].slice.call(arguments, 0)));
    };
  };
  eve.stop = function() {
    stop = 1;
  };
  eve.nt = function(subname) {
    if (subname) {
      return(new RegExp("(?:\\.|\\/|^)" + subname + "(?:\\.|\\/|$)")).test(current_event);
    }
    return current_event;
  };
  eve.nts = function() {
    return current_event.split(separator);
  };
  eve.off = eve.unbind = function(name, f) {
    if (!name) {
      eve._events = events = {n:{}};
      return;
    }
    var names = name.split(separator), e, key, splice, i, ii, j, jj, cur = [events];
    for (i = 0, ii = names.length;i < ii;i++) {
      for (j = 0;j < cur.length;j += splice.length - 2) {
        splice = [j, 1];
        e = cur[j].n;
        if (names[i] != wildcard) {
          if (e[names[i]]) {
            splice.push(e[names[i]]);
          }
        } else {
          for (key in e) {
            if (e[has](key)) {
              splice.push(e[key]);
            }
          }
        }
        cur.splice.apply(cur, splice);
      }
    }
    for (i = 0, ii = cur.length;i < ii;i++) {
      e = cur[i];
      while (e.n) {
        if (f) {
          if (e.f) {
            for (j = 0, jj = e.f.length;j < jj;j++) {
              if (e.f[j] == f) {
                e.f.splice(j, 1);
                break;
              }
            }
            !e.f.length && delete e.f;
          }
          for (key in e.n) {
            if (e.n[has](key) && e.n[key].f) {
              var funcs = e.n[key].f;
              for (j = 0, jj = funcs.length;j < jj;j++) {
                if (funcs[j] == f) {
                  funcs.splice(j, 1);
                  break;
                }
              }
              !funcs.length && delete e.n[key].f;
            }
          }
        } else {
          delete e.f;
          for (key in e.n) {
            if (e.n[has](key) && e.n[key].f) {
              delete e.n[key].f;
            }
          }
        }
        e = e.n;
      }
    }
  };
  eve.once = function(name, f) {
    var f2 = function() {
      eve.unbind(name, f2);
      return f.apply(this, arguments);
    };
    return eve.on(name, f2);
  };
  eve.version = version;
  eve.toString = function() {
    return "You are running Eve " + version;
  };
  typeof module != "undefined" && module.exports ? module.exports = eve : typeof define != "undefined" ? define("eve", [], function() {
    return eve;
  }) : glob.eve = eve;
})(window || this);
(function(glob, factory) {
  if (typeof define === "function" && define.amd) {
    define(["eve"], function(eve) {
      return factory(glob, eve);
    });
  } else {
    factory(glob, glob.eve);
  }
})(this, function(window, eve) {
  function R(first) {
    if (R.is(first, "function")) {
      return loaded ? first() : eve.on("raphael.DOMload", first);
    } else {
      if (R.is(first, array)) {
        return R._engine.create[apply](R, first.splice(0, 3 + R.is(first[0], nu))).add(first);
      } else {
        var args = Array.prototype.slice.call(arguments, 0);
        if (R.is(args[args.length - 1], "function")) {
          var f = args.pop();
          return loaded ? f.call(R._engine.create[apply](R, args)) : eve.on("raphael.DOMload", function() {
            f.call(R._engine.create[apply](R, args));
          });
        } else {
          return R._engine.create[apply](R, arguments);
        }
      }
    }
  }
  R.version = "2.1.2";
  R.eve = eve;
  var loaded, separator = /[, ]+/, elements = {circle:1, rect:1, path:1, ellipse:1, text:1, image:1}, formatrg = /\{(\d+)\}/g, proto = "prototype", has = "hasOwnProperty", g = {doc:document, win:window}, oldRaphael = {was:Object.prototype[has].call(g.win, "Raphael"), is:g.win.Raphael}, Paper = function() {
    this.ca = this.customAttributes = {};
  }, paperproto, appendChild = "appendChild", apply = "apply", concat = "concat", supportsTouch = "ontouchstart" in g.win || g.win.DocumentTouch && g.doc instanceof DocumentTouch, E = "", S = " ", Str = String, split = "split", events = "click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel"[split](S), touchMap = {mousedown:"touchstart", mousemove:"touchmove", mouseup:"touchend"}, lowerCase = Str.prototype.toLowerCase, math = Math, mmax = math.max, 
  mmin = math.min, abs = math.abs, pow = math.pow, PI = math.PI, nu = "number", string = "string", array = "array", toString = "toString", fillString = "fill", objectToString = Object.prototype.toString, paper = {}, push = "push", ISURL = R._ISURL = /^url\(['"]?([^\)]+?)['"]?\)$/i, colourRegExp = /^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\))\s*$/i, 
  isnan = {"NaN":1, "Infinity":1, "-Infinity":1}, bezierrg = /^(?:cubic-)?bezier\(([^,]+),([^,]+),([^,]+),([^\)]+)\)/, round = math.round, setAttribute = "setAttribute", toFloat = parseFloat, toInt = parseInt, upperCase = Str.prototype.toUpperCase, availableAttrs = R._availableAttrs = {"arrow-end":"none", "arrow-start":"none", blur:0, "clip-rect":"0 0 1e9 1e9", cursor:"default", cx:0, cy:0, fill:"#fff", "fill-opacity":1, font:'10px "Arial"', "font-family":'"Arial"', "font-size":"10", "font-style":"normal", 
  "font-weight":400, gradient:0, height:0, href:"http://raphaeljs.com/", "letter-spacing":0, opacity:1, path:"M0,0", r:0, rx:0, ry:0, src:"", stroke:"#000", "stroke-dasharray":"", "stroke-linecap":"butt", "stroke-linejoin":"butt", "stroke-miterlimit":0, "stroke-opacity":1, "stroke-width":1, target:"_blank", "text-anchor":"middle", title:"Raphael", transform:"", width:0, x:0, y:0}, availableAnimAttrs = R._availableAnimAttrs = {blur:nu, "clip-rect":"csv", cx:nu, cy:nu, fill:"colour", "fill-opacity":nu, 
  "font-size":nu, height:nu, opacity:nu, path:"path", r:nu, rx:nu, ry:nu, stroke:"colour", "stroke-opacity":nu, "stroke-width":nu, transform:"transform", width:nu, x:nu, y:nu}, whitespace = /[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]/g, commaSpaces = /[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/, 
  hsrg = {hs:1, rg:1}, p2s = /,?([achlmqrstvxz]),?/gi, pathCommand = /([achlmrqstvz])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/ig, 
  tCommand = /([rstm])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/ig, pathValues = /(-?\d*\.?\d*(?:e[\-+]?\d+)?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/ig, 
  radial_gradient = R._radial_gradient = /^r(?:\(([^,]+?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*([^\)]+?)\))?/, eldata = {}, sortByKey = function(a, b) {
    return a.key - b.key;
  }, sortByNumber = function(a, b) {
    return toFloat(a) - toFloat(b);
  }, fun = function() {
  }, pipe = function(x) {
    return x;
  }, rectPath = R._rectPath = function(x, y, w, h, r) {
    if (r) {
      return[["M", x + r, y], ["l", w - r * 2, 0], ["a", r, r, 0, 0, 1, r, r], ["l", 0, h - r * 2], ["a", r, r, 0, 0, 1, -r, r], ["l", r * 2 - w, 0], ["a", r, r, 0, 0, 1, -r, -r], ["l", 0, r * 2 - h], ["a", r, r, 0, 0, 1, r, -r], ["z"]];
    }
    return[["M", x, y], ["l", w, 0], ["l", 0, h], ["l", -w, 0], ["z"]];
  }, ellipsePath = function(x, y, rx, ry) {
    if (ry == null) {
      ry = rx;
    }
    return[["M", x, y], ["m", 0, -ry], ["a", rx, ry, 0, 1, 1, 0, 2 * ry], ["a", rx, ry, 0, 1, 1, 0, -2 * ry], ["z"]];
  }, getPath = R._getPath = {path:function(el) {
    return el.attr("path");
  }, circle:function(el) {
    var a = el.attrs;
    return ellipsePath(a.cx, a.cy, a.r);
  }, ellipse:function(el) {
    var a = el.attrs;
    return ellipsePath(a.cx, a.cy, a.rx, a.ry);
  }, rect:function(el) {
    var a = el.attrs;
    return rectPath(a.x, a.y, a.width, a.height, a.r);
  }, image:function(el) {
    var a = el.attrs;
    return rectPath(a.x, a.y, a.width, a.height);
  }, text:function(el) {
    var bbox = el._getBBox();
    return rectPath(bbox.x, bbox.y, bbox.width, bbox.height);
  }, set:function(el) {
    var bbox = el._getBBox();
    return rectPath(bbox.x, bbox.y, bbox.width, bbox.height);
  }}, mapPath = R.mapPath = function(path, matrix) {
    if (!matrix) {
      return path;
    }
    var x, y, i, j, ii, jj, pathi;
    path = path2curve(path);
    for (i = 0, ii = path.length;i < ii;i++) {
      pathi = path[i];
      for (j = 1, jj = pathi.length;j < jj;j += 2) {
        x = matrix.x(pathi[j], pathi[j + 1]);
        y = matrix.y(pathi[j], pathi[j + 1]);
        pathi[j] = x;
        pathi[j + 1] = y;
      }
    }
    return path;
  };
  R._g = g;
  R.type = g.win.SVGAngle || g.doc.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1") ? "SVG" : "VML";
  if (R.type == "VML") {
    var d = g.doc.createElement("div"), b;
    d.innerHTML = '<v:shape adj="1"/>';
    b = d.firstChild;
    b.style.behavior = "url(#default#VML)";
    if (!(b && typeof b.adj == "object")) {
      return R.type = E;
    }
    d = null;
  }
  R.svg = !(R.vml = R.type == "VML");
  R._Paper = Paper;
  R.fn = paperproto = Paper.prototype = R.prototype;
  R._id = 0;
  R._oid = 0;
  R.is = function(o, type) {
    type = lowerCase.call(type);
    if (type == "finite") {
      return!isnan[has](+o);
    }
    if (type == "array") {
      return o instanceof Array;
    }
    return type == "null" && o === null || (type == typeof o && o !== null || (type == "object" && o === Object(o) || (type == "array" && (Array.isArray && Array.isArray(o)) || objectToString.call(o).slice(8, -1).toLowerCase() == type)));
  };
  function clone(obj) {
    if (typeof obj == "function" || Object(obj) !== obj) {
      return obj;
    }
    var res = new obj.constructor;
    for (var key in obj) {
      if (obj[has](key)) {
        res[key] = clone(obj[key]);
      }
    }
    return res;
  }
  R.angle = function(x1, y1, x2, y2, x3, y3) {
    if (x3 == null) {
      var x = x1 - x2, y = y1 - y2;
      if (!x && !y) {
        return 0;
      }
      return(180 + math.atan2(-y, -x) * 180 / PI + 360) % 360;
    } else {
      return R.angle(x1, y1, x3, y3) - R.angle(x2, y2, x3, y3);
    }
  };
  R.rad = function(deg) {
    return deg % 360 * PI / 180;
  };
  R.deg = function(rad) {
    return rad * 180 / PI % 360;
  };
  R.snapTo = function(values, value, tolerance) {
    tolerance = R.is(tolerance, "finite") ? tolerance : 10;
    if (R.is(values, array)) {
      var i = values.length;
      while (i--) {
        if (abs(values[i] - value) <= tolerance) {
          return values[i];
        }
      }
    } else {
      values = +values;
      var rem = value % values;
      if (rem < tolerance) {
        return value - rem;
      }
      if (rem > values - tolerance) {
        return value - rem + values;
      }
    }
    return value;
  };
  var createUUID = R.createUUID = function(uuidRegEx, uuidReplacer) {
    return function() {
      return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(uuidRegEx, uuidReplacer).toUpperCase();
    };
  }(/[xy]/g, function(c) {
    var r = math.random() * 16 | 0, v = c == "x" ? r : r & 3 | 8;
    return v.toString(16);
  });
  R.setWindow = function(newwin) {
    eve("raphael.setWindow", R, g.win, newwin);
    g.win = newwin;
    g.doc = g.win.document;
    if (R._engine.initWin) {
      R._engine.initWin(g.win);
    }
  };
  var toHex = function(color) {
    if (R.vml) {
      var trim = /^\s+|\s+$/g;
      var bod;
      try {
        var docum = new ActiveXObject("htmlfile");
        docum.write("<body>");
        docum.close();
        bod = docum.body;
      } catch (e) {
        bod = createPopup().document.body;
      }
      var range = bod.createTextRange();
      toHex = cacher(function(color) {
        try {
          bod.style.color = Str(color).replace(trim, E);
          var value = range.queryCommandValue("ForeColor");
          value = (value & 255) << 16 | value & 65280 | (value & 16711680) >>> 16;
          return "#" + ("000000" + value.toString(16)).slice(-6);
        } catch (e) {
          return "none";
        }
      });
    } else {
      var i = g.doc.createElement("i");
      i.title = "Rapha\u00ebl Colour Picker";
      i.style.display = "none";
      g.doc.body.appendChild(i);
      toHex = cacher(function(color) {
        i.style.color = color;
        return g.doc.defaultView.getComputedStyle(i, E).getPropertyValue("color");
      });
    }
    return toHex(color);
  }, hsbtoString = function() {
    return "hsb(" + [this.h, this.s, this.b] + ")";
  }, hsltoString = function() {
    return "hsl(" + [this.h, this.s, this.l] + ")";
  }, rgbtoString = function() {
    return this.hex;
  }, prepareRGB = function(r, g, b) {
    if (g == null && (R.is(r, "object") && ("r" in r && ("g" in r && "b" in r)))) {
      b = r.b;
      g = r.g;
      r = r.r;
    }
    if (g == null && R.is(r, string)) {
      var clr = R.getRGB(r);
      r = clr.r;
      g = clr.g;
      b = clr.b;
    }
    if (r > 1 || (g > 1 || b > 1)) {
      r /= 255;
      g /= 255;
      b /= 255;
    }
    return[r, g, b];
  }, packageRGB = function(r, g, b, o) {
    r *= 255;
    g *= 255;
    b *= 255;
    var rgb = {r:r, g:g, b:b, hex:R.rgb(r, g, b), toString:rgbtoString};
    R.is(o, "finite") && (rgb.opacity = o);
    return rgb;
  };
  R.color = function(clr) {
    var rgb;
    if (R.is(clr, "object") && ("h" in clr && ("s" in clr && "b" in clr))) {
      rgb = R.hsb2rgb(clr);
      clr.r = rgb.r;
      clr.g = rgb.g;
      clr.b = rgb.b;
      clr.hex = rgb.hex;
    } else {
      if (R.is(clr, "object") && ("h" in clr && ("s" in clr && "l" in clr))) {
        rgb = R.hsl2rgb(clr);
        clr.r = rgb.r;
        clr.g = rgb.g;
        clr.b = rgb.b;
        clr.hex = rgb.hex;
      } else {
        if (R.is(clr, "string")) {
          clr = R.getRGB(clr);
        }
        if (R.is(clr, "object") && ("r" in clr && ("g" in clr && "b" in clr))) {
          rgb = R.rgb2hsl(clr);
          clr.h = rgb.h;
          clr.s = rgb.s;
          clr.l = rgb.l;
          rgb = R.rgb2hsb(clr);
          clr.v = rgb.b;
        } else {
          clr = {hex:"none"};
          clr.r = clr.g = clr.b = clr.h = clr.s = clr.v = clr.l = -1;
        }
      }
    }
    clr.toString = rgbtoString;
    return clr;
  };
  R.hsb2rgb = function(h, s, v, o) {
    if (this.is(h, "object") && ("h" in h && ("s" in h && "b" in h))) {
      v = h.b;
      s = h.s;
      h = h.h;
      o = h.o;
    }
    h *= 360;
    var R, G, B, X, C;
    h = h % 360 / 60;
    C = v * s;
    X = C * (1 - abs(h % 2 - 1));
    R = G = B = v - C;
    h = ~~h;
    R += [C, X, 0, 0, X, C][h];
    G += [X, C, C, X, 0, 0][h];
    B += [0, 0, X, C, C, X][h];
    return packageRGB(R, G, B, o);
  };
  R.hsl2rgb = function(h, s, l, o) {
    if (this.is(h, "object") && ("h" in h && ("s" in h && "l" in h))) {
      l = h.l;
      s = h.s;
      h = h.h;
    }
    if (h > 1 || (s > 1 || l > 1)) {
      h /= 360;
      s /= 100;
      l /= 100;
    }
    h *= 360;
    var R, G, B, X, C;
    h = h % 360 / 60;
    C = 2 * s * (l < 0.5 ? l : 1 - l);
    X = C * (1 - abs(h % 2 - 1));
    R = G = B = l - C / 2;
    h = ~~h;
    R += [C, X, 0, 0, X, C][h];
    G += [X, C, C, X, 0, 0][h];
    B += [0, 0, X, C, C, X][h];
    return packageRGB(R, G, B, o);
  };
  R.rgb2hsb = function(r, g, b) {
    b = prepareRGB(r, g, b);
    r = b[0];
    g = b[1];
    b = b[2];
    var H, S, V, C;
    V = mmax(r, g, b);
    C = V - mmin(r, g, b);
    H = C == 0 ? null : V == r ? (g - b) / C : V == g ? (b - r) / C + 2 : (r - g) / C + 4;
    H = (H + 360) % 6 * 60 / 360;
    S = C == 0 ? 0 : C / V;
    return{h:H, s:S, b:V, toString:hsbtoString};
  };
  R.rgb2hsl = function(r, g, b) {
    b = prepareRGB(r, g, b);
    r = b[0];
    g = b[1];
    b = b[2];
    var H, S, L, M, m, C;
    M = mmax(r, g, b);
    m = mmin(r, g, b);
    C = M - m;
    H = C == 0 ? null : M == r ? (g - b) / C : M == g ? (b - r) / C + 2 : (r - g) / C + 4;
    H = (H + 360) % 6 * 60 / 360;
    L = (M + m) / 2;
    S = C == 0 ? 0 : L < 0.5 ? C / (2 * L) : C / (2 - 2 * L);
    return{h:H, s:S, l:L, toString:hsltoString};
  };
  R._path2string = function() {
    return this.join(",").replace(p2s, "$1");
  };
  function repush(array, item) {
    for (var i = 0, ii = array.length;i < ii;i++) {
      if (array[i] === item) {
        return array.push(array.splice(i, 1)[0]);
      }
    }
  }
  function cacher(f, scope, postprocessor) {
    function newf() {
      var arg = Array.prototype.slice.call(arguments, 0), args = arg.join("\u2400"), cache = newf.cache = newf.cache || {}, count = newf.count = newf.count || [];
      if (cache[has](args)) {
        repush(count, args);
        return postprocessor ? postprocessor(cache[args]) : cache[args];
      }
      count.length >= 1E3 && delete cache[count.shift()];
      count.push(args);
      cache[args] = f[apply](scope, arg);
      return postprocessor ? postprocessor(cache[args]) : cache[args];
    }
    return newf;
  }
  var preload = R._preload = function(src, f) {
    var img = g.doc.createElement("img");
    img.style.cssText = "position:absolute;left:-9999em;top:-9999em";
    img.onload = function() {
      f.call(this);
      this.onload = null;
      g.doc.body.removeChild(this);
    };
    img.onerror = function() {
      g.doc.body.removeChild(this);
    };
    g.doc.body.appendChild(img);
    img.src = src;
  };
  function clrToString() {
    return this.hex;
  }
  R.getRGB = cacher(function(colour) {
    if (!colour || !!((colour = Str(colour)).indexOf("-") + 1)) {
      return{r:-1, g:-1, b:-1, hex:"none", error:1, toString:clrToString};
    }
    if (colour == "none") {
      return{r:-1, g:-1, b:-1, hex:"none", toString:clrToString};
    }
    !(hsrg[has](colour.toLowerCase().substring(0, 2)) || colour.charAt() == "#") && (colour = toHex(colour));
    var res, red, green, blue, opacity, t, values, rgb = colour.match(colourRegExp);
    if (rgb) {
      if (rgb[2]) {
        blue = toInt(rgb[2].substring(5), 16);
        green = toInt(rgb[2].substring(3, 5), 16);
        red = toInt(rgb[2].substring(1, 3), 16);
      }
      if (rgb[3]) {
        blue = toInt((t = rgb[3].charAt(3)) + t, 16);
        green = toInt((t = rgb[3].charAt(2)) + t, 16);
        red = toInt((t = rgb[3].charAt(1)) + t, 16);
      }
      if (rgb[4]) {
        values = rgb[4][split](commaSpaces);
        red = toFloat(values[0]);
        values[0].slice(-1) == "%" && (red *= 2.55);
        green = toFloat(values[1]);
        values[1].slice(-1) == "%" && (green *= 2.55);
        blue = toFloat(values[2]);
        values[2].slice(-1) == "%" && (blue *= 2.55);
        rgb[1].toLowerCase().slice(0, 4) == "rgba" && (opacity = toFloat(values[3]));
        values[3] && (values[3].slice(-1) == "%" && (opacity /= 100));
      }
      if (rgb[5]) {
        values = rgb[5][split](commaSpaces);
        red = toFloat(values[0]);
        values[0].slice(-1) == "%" && (red *= 2.55);
        green = toFloat(values[1]);
        values[1].slice(-1) == "%" && (green *= 2.55);
        blue = toFloat(values[2]);
        values[2].slice(-1) == "%" && (blue *= 2.55);
        (values[0].slice(-3) == "deg" || values[0].slice(-1) == "\u00b0") && (red /= 360);
        rgb[1].toLowerCase().slice(0, 4) == "hsba" && (opacity = toFloat(values[3]));
        values[3] && (values[3].slice(-1) == "%" && (opacity /= 100));
        return R.hsb2rgb(red, green, blue, opacity);
      }
      if (rgb[6]) {
        values = rgb[6][split](commaSpaces);
        red = toFloat(values[0]);
        values[0].slice(-1) == "%" && (red *= 2.55);
        green = toFloat(values[1]);
        values[1].slice(-1) == "%" && (green *= 2.55);
        blue = toFloat(values[2]);
        values[2].slice(-1) == "%" && (blue *= 2.55);
        (values[0].slice(-3) == "deg" || values[0].slice(-1) == "\u00b0") && (red /= 360);
        rgb[1].toLowerCase().slice(0, 4) == "hsla" && (opacity = toFloat(values[3]));
        values[3] && (values[3].slice(-1) == "%" && (opacity /= 100));
        return R.hsl2rgb(red, green, blue, opacity);
      }
      rgb = {r:red, g:green, b:blue, toString:clrToString};
      rgb.hex = "#" + (16777216 | blue | green << 8 | red << 16).toString(16).slice(1);
      R.is(opacity, "finite") && (rgb.opacity = opacity);
      return rgb;
    }
    return{r:-1, g:-1, b:-1, hex:"none", error:1, toString:clrToString};
  }, R);
  R.hsb = cacher(function(h, s, b) {
    return R.hsb2rgb(h, s, b).hex;
  });
  R.hsl = cacher(function(h, s, l) {
    return R.hsl2rgb(h, s, l).hex;
  });
  R.rgb = cacher(function(r, g, b) {
    return "#" + (16777216 | b | g << 8 | r << 16).toString(16).slice(1);
  });
  R.getColor = function(value) {
    var start = this.getColor.start = this.getColor.start || {h:0, s:1, b:value || 0.75}, rgb = this.hsb2rgb(start.h, start.s, start.b);
    start.h += 0.075;
    if (start.h > 1) {
      start.h = 0;
      start.s -= 0.2;
      start.s <= 0 && (this.getColor.start = {h:0, s:1, b:start.b});
    }
    return rgb.hex;
  };
  R.getColor.reset = function() {
    delete this.start;
  };
  function catmullRom2bezier(crp, z) {
    var d = [];
    for (var i = 0, iLen = crp.length;iLen - 2 * !z > i;i += 2) {
      var p = [{x:+crp[i - 2], y:+crp[i - 1]}, {x:+crp[i], y:+crp[i + 1]}, {x:+crp[i + 2], y:+crp[i + 3]}, {x:+crp[i + 4], y:+crp[i + 5]}];
      if (z) {
        if (!i) {
          p[0] = {x:+crp[iLen - 2], y:+crp[iLen - 1]};
        } else {
          if (iLen - 4 == i) {
            p[3] = {x:+crp[0], y:+crp[1]};
          } else {
            if (iLen - 2 == i) {
              p[2] = {x:+crp[0], y:+crp[1]};
              p[3] = {x:+crp[2], y:+crp[3]};
            }
          }
        }
      } else {
        if (iLen - 4 == i) {
          p[3] = p[2];
        } else {
          if (!i) {
            p[0] = {x:+crp[i], y:+crp[i + 1]};
          }
        }
      }
      d.push(["C", (-p[0].x + 6 * p[1].x + p[2].x) / 6, (-p[0].y + 6 * p[1].y + p[2].y) / 6, (p[1].x + 6 * p[2].x - p[3].x) / 6, (p[1].y + 6 * p[2].y - p[3].y) / 6, p[2].x, p[2].y]);
    }
    return d;
  }
  R.parsePathString = function(pathString) {
    if (!pathString) {
      return null;
    }
    var pth = paths(pathString);
    if (pth.arr) {
      return pathClone(pth.arr);
    }
    var paramCounts = {a:7, c:6, h:1, l:2, m:2, r:4, q:4, s:4, t:2, v:1, z:0}, data = [];
    if (R.is(pathString, array) && R.is(pathString[0], array)) {
      data = pathClone(pathString);
    }
    if (!data.length) {
      Str(pathString).replace(pathCommand, function(a, b, c) {
        var params = [], name = b.toLowerCase();
        c.replace(pathValues, function(a, b) {
          b && params.push(+b);
        });
        if (name == "m" && params.length > 2) {
          data.push([b][concat](params.splice(0, 2)));
          name = "l";
          b = b == "m" ? "l" : "L";
        }
        if (name == "r") {
          data.push([b][concat](params));
        } else {
          while (params.length >= paramCounts[name]) {
            data.push([b][concat](params.splice(0, paramCounts[name])));
            if (!paramCounts[name]) {
              break;
            }
          }
        }
      });
    }
    data.toString = R._path2string;
    pth.arr = pathClone(data);
    return data;
  };
  R.parseTransformString = cacher(function(TString) {
    if (!TString) {
      return null;
    }
    var paramCounts = {r:3, s:4, t:2, m:6}, data = [];
    if (R.is(TString, array) && R.is(TString[0], array)) {
      data = pathClone(TString);
    }
    if (!data.length) {
      Str(TString).replace(tCommand, function(a, b, c) {
        var params = [], name = lowerCase.call(b);
        c.replace(pathValues, function(a, b) {
          b && params.push(+b);
        });
        data.push([b][concat](params));
      });
    }
    data.toString = R._path2string;
    return data;
  });
  var paths = function(ps) {
    var p = paths.ps = paths.ps || {};
    if (p[ps]) {
      p[ps].sleep = 100;
    } else {
      p[ps] = {sleep:100};
    }
    setTimeout(function() {
      for (var key in p) {
        if (p[has](key) && key != ps) {
          p[key].sleep--;
          !p[key].sleep && delete p[key];
        }
      }
    });
    return p[ps];
  };
  R.findDotsAtSegment = function(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t) {
    var t1 = 1 - t, t13 = pow(t1, 3), t12 = pow(t1, 2), t2 = t * t, t3 = t2 * t, x = t13 * p1x + t12 * 3 * t * c1x + t1 * 3 * t * t * c2x + t3 * p2x, y = t13 * p1y + t12 * 3 * t * c1y + t1 * 3 * t * t * c2y + t3 * p2y, mx = p1x + 2 * t * (c1x - p1x) + t2 * (c2x - 2 * c1x + p1x), my = p1y + 2 * t * (c1y - p1y) + t2 * (c2y - 2 * c1y + p1y), nx = c1x + 2 * t * (c2x - c1x) + t2 * (p2x - 2 * c2x + c1x), ny = c1y + 2 * t * (c2y - c1y) + t2 * (p2y - 2 * c2y + c1y), ax = t1 * p1x + t * c1x, ay = t1 * p1y + 
    t * c1y, cx = t1 * c2x + t * p2x, cy = t1 * c2y + t * p2y, alpha = 90 - math.atan2(mx - nx, my - ny) * 180 / PI;
    (mx > nx || my < ny) && (alpha += 180);
    return{x:x, y:y, m:{x:mx, y:my}, n:{x:nx, y:ny}, start:{x:ax, y:ay}, end:{x:cx, y:cy}, alpha:alpha};
  };
  R.bezierBBox = function(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y) {
    if (!R.is(p1x, "array")) {
      p1x = [p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y];
    }
    var bbox = curveDim.apply(null, p1x);
    return{x:bbox.min.x, y:bbox.min.y, x2:bbox.max.x, y2:bbox.max.y, width:bbox.max.x - bbox.min.x, height:bbox.max.y - bbox.min.y};
  };
  R.isPointInsideBBox = function(bbox, x, y) {
    return x >= bbox.x && (x <= bbox.x2 && (y >= bbox.y && y <= bbox.y2));
  };
  R.isBBoxIntersect = function(bbox1, bbox2) {
    var i = R.isPointInsideBBox;
    return i(bbox2, bbox1.x, bbox1.y) || (i(bbox2, bbox1.x2, bbox1.y) || (i(bbox2, bbox1.x, bbox1.y2) || (i(bbox2, bbox1.x2, bbox1.y2) || (i(bbox1, bbox2.x, bbox2.y) || (i(bbox1, bbox2.x2, bbox2.y) || (i(bbox1, bbox2.x, bbox2.y2) || (i(bbox1, bbox2.x2, bbox2.y2) || (bbox1.x < bbox2.x2 && bbox1.x > bbox2.x || bbox2.x < bbox1.x2 && bbox2.x > bbox1.x) && (bbox1.y < bbox2.y2 && bbox1.y > bbox2.y || bbox2.y < bbox1.y2 && bbox2.y > bbox1.y))))))));
  };
  function base3(t, p1, p2, p3, p4) {
    var t1 = -3 * p1 + 9 * p2 - 9 * p3 + 3 * p4, t2 = t * t1 + 6 * p1 - 12 * p2 + 6 * p3;
    return t * t2 - 3 * p1 + 3 * p2;
  }
  function bezlen(x1, y1, x2, y2, x3, y3, x4, y4, z) {
    if (z == null) {
      z = 1;
    }
    z = z > 1 ? 1 : z < 0 ? 0 : z;
    var z2 = z / 2, n = 12, Tvalues = [-0.1252, 0.1252, -0.3678, 0.3678, -0.5873, 0.5873, -0.7699, 0.7699, -0.9041, 0.9041, -0.9816, 0.9816], Cvalues = [0.2491, 0.2491, 0.2335, 0.2335, 0.2032, 0.2032, 0.1601, 0.1601, 0.1069, 0.1069, 0.0472, 0.0472], sum = 0;
    for (var i = 0;i < n;i++) {
      var ct = z2 * Tvalues[i] + z2, xbase = base3(ct, x1, x2, x3, x4), ybase = base3(ct, y1, y2, y3, y4), comb = xbase * xbase + ybase * ybase;
      sum += Cvalues[i] * math.sqrt(comb);
    }
    return z2 * sum;
  }
  function getTatLen(x1, y1, x2, y2, x3, y3, x4, y4, ll) {
    if (ll < 0 || bezlen(x1, y1, x2, y2, x3, y3, x4, y4) < ll) {
      return;
    }
    var t = 1, step = t / 2, t2 = t - step, l, e = 0.01;
    l = bezlen(x1, y1, x2, y2, x3, y3, x4, y4, t2);
    while (abs(l - ll) > e) {
      step /= 2;
      t2 += (l < ll ? 1 : -1) * step;
      l = bezlen(x1, y1, x2, y2, x3, y3, x4, y4, t2);
    }
    return t2;
  }
  function intersect(x1, y1, x2, y2, x3, y3, x4, y4) {
    if (mmax(x1, x2) < mmin(x3, x4) || (mmin(x1, x2) > mmax(x3, x4) || (mmax(y1, y2) < mmin(y3, y4) || mmin(y1, y2) > mmax(y3, y4)))) {
      return;
    }
    var nx = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4), ny = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4), denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (!denominator) {
      return;
    }
    var px = nx / denominator, py = ny / denominator, px2 = +px.toFixed(2), py2 = +py.toFixed(2);
    if (px2 < +mmin(x1, x2).toFixed(2) || (px2 > +mmax(x1, x2).toFixed(2) || (px2 < +mmin(x3, x4).toFixed(2) || (px2 > +mmax(x3, x4).toFixed(2) || (py2 < +mmin(y1, y2).toFixed(2) || (py2 > +mmax(y1, y2).toFixed(2) || (py2 < +mmin(y3, y4).toFixed(2) || py2 > +mmax(y3, y4).toFixed(2)))))))) {
      return;
    }
    return{x:px, y:py};
  }
  function inter(bez1, bez2) {
    return interHelper(bez1, bez2);
  }
  function interCount(bez1, bez2) {
    return interHelper(bez1, bez2, 1);
  }
  function interHelper(bez1, bez2, justCount) {
    var bbox1 = R.bezierBBox(bez1), bbox2 = R.bezierBBox(bez2);
    if (!R.isBBoxIntersect(bbox1, bbox2)) {
      return justCount ? 0 : [];
    }
    var l1 = bezlen.apply(0, bez1), l2 = bezlen.apply(0, bez2), n1 = mmax(~~(l1 / 5), 1), n2 = mmax(~~(l2 / 5), 1), dots1 = [], dots2 = [], xy = {}, res = justCount ? 0 : [];
    for (var i = 0;i < n1 + 1;i++) {
      var p = R.findDotsAtSegment.apply(R, bez1.concat(i / n1));
      dots1.push({x:p.x, y:p.y, t:i / n1});
    }
    for (i = 0;i < n2 + 1;i++) {
      p = R.findDotsAtSegment.apply(R, bez2.concat(i / n2));
      dots2.push({x:p.x, y:p.y, t:i / n2});
    }
    for (i = 0;i < n1;i++) {
      for (var j = 0;j < n2;j++) {
        var di = dots1[i], di1 = dots1[i + 1], dj = dots2[j], dj1 = dots2[j + 1], ci = abs(di1.x - di.x) < 0.001 ? "y" : "x", cj = abs(dj1.x - dj.x) < 0.001 ? "y" : "x", is = intersect(di.x, di.y, di1.x, di1.y, dj.x, dj.y, dj1.x, dj1.y);
        if (is) {
          if (xy[is.x.toFixed(4)] == is.y.toFixed(4)) {
            continue;
          }
          xy[is.x.toFixed(4)] = is.y.toFixed(4);
          var t1 = di.t + abs((is[ci] - di[ci]) / (di1[ci] - di[ci])) * (di1.t - di.t), t2 = dj.t + abs((is[cj] - dj[cj]) / (dj1[cj] - dj[cj])) * (dj1.t - dj.t);
          if (t1 >= 0 && (t1 <= 1.001 && (t2 >= 0 && t2 <= 1.001))) {
            if (justCount) {
              res++;
            } else {
              res.push({x:is.x, y:is.y, t1:mmin(t1, 1), t2:mmin(t2, 1)});
            }
          }
        }
      }
    }
    return res;
  }
  R.pathIntersection = function(path1, path2) {
    return interPathHelper(path1, path2);
  };
  R.pathIntersectionNumber = function(path1, path2) {
    return interPathHelper(path1, path2, 1);
  };
  function interPathHelper(path1, path2, justCount) {
    path1 = R._path2curve(path1);
    path2 = R._path2curve(path2);
    var x1, y1, x2, y2, x1m, y1m, x2m, y2m, bez1, bez2, res = justCount ? 0 : [];
    for (var i = 0, ii = path1.length;i < ii;i++) {
      var pi = path1[i];
      if (pi[0] == "M") {
        x1 = x1m = pi[1];
        y1 = y1m = pi[2];
      } else {
        if (pi[0] == "C") {
          bez1 = [x1, y1].concat(pi.slice(1));
          x1 = bez1[6];
          y1 = bez1[7];
        } else {
          bez1 = [x1, y1, x1, y1, x1m, y1m, x1m, y1m];
          x1 = x1m;
          y1 = y1m;
        }
        for (var j = 0, jj = path2.length;j < jj;j++) {
          var pj = path2[j];
          if (pj[0] == "M") {
            x2 = x2m = pj[1];
            y2 = y2m = pj[2];
          } else {
            if (pj[0] == "C") {
              bez2 = [x2, y2].concat(pj.slice(1));
              x2 = bez2[6];
              y2 = bez2[7];
            } else {
              bez2 = [x2, y2, x2, y2, x2m, y2m, x2m, y2m];
              x2 = x2m;
              y2 = y2m;
            }
            var intr = interHelper(bez1, bez2, justCount);
            if (justCount) {
              res += intr;
            } else {
              for (var k = 0, kk = intr.length;k < kk;k++) {
                intr[k].segment1 = i;
                intr[k].segment2 = j;
                intr[k].bez1 = bez1;
                intr[k].bez2 = bez2;
              }
              res = res.concat(intr);
            }
          }
        }
      }
    }
    return res;
  }
  R.isPointInsidePath = function(path, x, y) {
    var bbox = R.pathBBox(path);
    return R.isPointInsideBBox(bbox, x, y) && interPathHelper(path, [["M", x, y], ["H", bbox.x2 + 10]], 1) % 2 == 1;
  };
  R._removedFactory = function(methodname) {
    return function() {
      eve("raphael.log", null, "Rapha\u00ebl: you are calling to method \u201c" + methodname + "\u201d of removed object", methodname);
    };
  };
  var pathDimensions = R.pathBBox = function(path) {
    var pth = paths(path);
    if (pth.bbox) {
      return clone(pth.bbox);
    }
    if (!path) {
      return{x:0, y:0, width:0, height:0, x2:0, y2:0};
    }
    path = path2curve(path);
    var x = 0, y = 0, X = [], Y = [], p;
    for (var i = 0, ii = path.length;i < ii;i++) {
      p = path[i];
      if (p[0] == "M") {
        x = p[1];
        y = p[2];
        X.push(x);
        Y.push(y);
      } else {
        var dim = curveDim(x, y, p[1], p[2], p[3], p[4], p[5], p[6]);
        X = X[concat](dim.min.x, dim.max.x);
        Y = Y[concat](dim.min.y, dim.max.y);
        x = p[5];
        y = p[6];
      }
    }
    var xmin = mmin[apply](0, X), ymin = mmin[apply](0, Y), xmax = mmax[apply](0, X), ymax = mmax[apply](0, Y), width = xmax - xmin, height = ymax - ymin, bb = {x:xmin, y:ymin, x2:xmax, y2:ymax, width:width, height:height, cx:xmin + width / 2, cy:ymin + height / 2};
    pth.bbox = clone(bb);
    return bb;
  }, pathClone = function(pathArray) {
    var res = clone(pathArray);
    res.toString = R._path2string;
    return res;
  }, pathToRelative = R._pathToRelative = function(pathArray) {
    var pth = paths(pathArray);
    if (pth.rel) {
      return pathClone(pth.rel);
    }
    if (!R.is(pathArray, array) || !R.is(pathArray && pathArray[0], array)) {
      pathArray = R.parsePathString(pathArray);
    }
    var res = [], x = 0, y = 0, mx = 0, my = 0, start = 0;
    if (pathArray[0][0] == "M") {
      x = pathArray[0][1];
      y = pathArray[0][2];
      mx = x;
      my = y;
      start++;
      res.push(["M", x, y]);
    }
    for (var i = start, ii = pathArray.length;i < ii;i++) {
      var r = res[i] = [], pa = pathArray[i];
      if (pa[0] != lowerCase.call(pa[0])) {
        r[0] = lowerCase.call(pa[0]);
        switch(r[0]) {
          case "a":
            r[1] = pa[1];
            r[2] = pa[2];
            r[3] = pa[3];
            r[4] = pa[4];
            r[5] = pa[5];
            r[6] = +(pa[6] - x).toFixed(3);
            r[7] = +(pa[7] - y).toFixed(3);
            break;
          case "v":
            r[1] = +(pa[1] - y).toFixed(3);
            break;
          case "m":
            mx = pa[1];
            my = pa[2];
          default:
            for (var j = 1, jj = pa.length;j < jj;j++) {
              r[j] = +(pa[j] - (j % 2 ? x : y)).toFixed(3);
            }
          ;
        }
      } else {
        r = res[i] = [];
        if (pa[0] == "m") {
          mx = pa[1] + x;
          my = pa[2] + y;
        }
        for (var k = 0, kk = pa.length;k < kk;k++) {
          res[i][k] = pa[k];
        }
      }
      var len = res[i].length;
      switch(res[i][0]) {
        case "z":
          x = mx;
          y = my;
          break;
        case "h":
          x += +res[i][len - 1];
          break;
        case "v":
          y += +res[i][len - 1];
          break;
        default:
          x += +res[i][len - 2];
          y += +res[i][len - 1];
      }
    }
    res.toString = R._path2string;
    pth.rel = pathClone(res);
    return res;
  }, pathToAbsolute = R._pathToAbsolute = function(pathArray) {
    var pth = paths(pathArray);
    if (pth.abs) {
      return pathClone(pth.abs);
    }
    if (!R.is(pathArray, array) || !R.is(pathArray && pathArray[0], array)) {
      pathArray = R.parsePathString(pathArray);
    }
    if (!pathArray || !pathArray.length) {
      return[["M", 0, 0]];
    }
    var res = [], x = 0, y = 0, mx = 0, my = 0, start = 0;
    if (pathArray[0][0] == "M") {
      x = +pathArray[0][1];
      y = +pathArray[0][2];
      mx = x;
      my = y;
      start++;
      res[0] = ["M", x, y];
    }
    var crz = pathArray.length == 3 && (pathArray[0][0] == "M" && (pathArray[1][0].toUpperCase() == "R" && pathArray[2][0].toUpperCase() == "Z"));
    for (var r, pa, i = start, ii = pathArray.length;i < ii;i++) {
      res.push(r = []);
      pa = pathArray[i];
      if (pa[0] != upperCase.call(pa[0])) {
        r[0] = upperCase.call(pa[0]);
        switch(r[0]) {
          case "A":
            r[1] = pa[1];
            r[2] = pa[2];
            r[3] = pa[3];
            r[4] = pa[4];
            r[5] = pa[5];
            r[6] = +(pa[6] + x);
            r[7] = +(pa[7] + y);
            break;
          case "V":
            r[1] = +pa[1] + y;
            break;
          case "H":
            r[1] = +pa[1] + x;
            break;
          case "R":
            var dots = [x, y][concat](pa.slice(1));
            for (var j = 2, jj = dots.length;j < jj;j++) {
              dots[j] = +dots[j] + x;
              dots[++j] = +dots[j] + y;
            }
            res.pop();
            res = res[concat](catmullRom2bezier(dots, crz));
            break;
          case "M":
            mx = +pa[1] + x;
            my = +pa[2] + y;
          default:
            for (j = 1, jj = pa.length;j < jj;j++) {
              r[j] = +pa[j] + (j % 2 ? x : y);
            }
          ;
        }
      } else {
        if (pa[0] == "R") {
          dots = [x, y][concat](pa.slice(1));
          res.pop();
          res = res[concat](catmullRom2bezier(dots, crz));
          r = ["R"][concat](pa.slice(-2));
        } else {
          for (var k = 0, kk = pa.length;k < kk;k++) {
            r[k] = pa[k];
          }
        }
      }
      switch(r[0]) {
        case "Z":
          x = mx;
          y = my;
          break;
        case "H":
          x = r[1];
          break;
        case "V":
          y = r[1];
          break;
        case "M":
          mx = r[r.length - 2];
          my = r[r.length - 1];
        default:
          x = r[r.length - 2];
          y = r[r.length - 1];
      }
    }
    res.toString = R._path2string;
    pth.abs = pathClone(res);
    return res;
  }, l2c = function(x1, y1, x2, y2) {
    return[x1, y1, x2, y2, x2, y2];
  }, q2c = function(x1, y1, ax, ay, x2, y2) {
    var _13 = 1 / 3, _23 = 2 / 3;
    return[_13 * x1 + _23 * ax, _13 * y1 + _23 * ay, _13 * x2 + _23 * ax, _13 * y2 + _23 * ay, x2, y2];
  }, a2c = function(x1, y1, rx, ry, angle, large_arc_flag, sweep_flag, x2, y2, recursive) {
    var _120 = PI * 120 / 180, rad = PI / 180 * (+angle || 0), res = [], xy, rotate = cacher(function(x, y, rad) {
      var X = x * math.cos(rad) - y * math.sin(rad), Y = x * math.sin(rad) + y * math.cos(rad);
      return{x:X, y:Y};
    });
    if (!recursive) {
      xy = rotate(x1, y1, -rad);
      x1 = xy.x;
      y1 = xy.y;
      xy = rotate(x2, y2, -rad);
      x2 = xy.x;
      y2 = xy.y;
      var cos = math.cos(PI / 180 * angle), sin = math.sin(PI / 180 * angle), x = (x1 - x2) / 2, y = (y1 - y2) / 2;
      var h = x * x / (rx * rx) + y * y / (ry * ry);
      if (h > 1) {
        h = math.sqrt(h);
        rx = h * rx;
        ry = h * ry;
      }
      var rx2 = rx * rx, ry2 = ry * ry, k = (large_arc_flag == sweep_flag ? -1 : 1) * math.sqrt(abs((rx2 * ry2 - rx2 * y * y - ry2 * x * x) / (rx2 * y * y + ry2 * x * x))), cx = k * rx * y / ry + (x1 + x2) / 2, cy = k * -ry * x / rx + (y1 + y2) / 2, f1 = math.asin(((y1 - cy) / ry).toFixed(9)), f2 = math.asin(((y2 - cy) / ry).toFixed(9));
      f1 = x1 < cx ? PI - f1 : f1;
      f2 = x2 < cx ? PI - f2 : f2;
      f1 < 0 && (f1 = PI * 2 + f1);
      f2 < 0 && (f2 = PI * 2 + f2);
      if (sweep_flag && f1 > f2) {
        f1 = f1 - PI * 2;
      }
      if (!sweep_flag && f2 > f1) {
        f2 = f2 - PI * 2;
      }
    } else {
      f1 = recursive[0];
      f2 = recursive[1];
      cx = recursive[2];
      cy = recursive[3];
    }
    var df = f2 - f1;
    if (abs(df) > _120) {
      var f2old = f2, x2old = x2, y2old = y2;
      f2 = f1 + _120 * (sweep_flag && f2 > f1 ? 1 : -1);
      x2 = cx + rx * math.cos(f2);
      y2 = cy + ry * math.sin(f2);
      res = a2c(x2, y2, rx, ry, angle, 0, sweep_flag, x2old, y2old, [f2, f2old, cx, cy]);
    }
    df = f2 - f1;
    var c1 = math.cos(f1), s1 = math.sin(f1), c2 = math.cos(f2), s2 = math.sin(f2), t = math.tan(df / 4), hx = 4 / 3 * rx * t, hy = 4 / 3 * ry * t, m1 = [x1, y1], m2 = [x1 + hx * s1, y1 - hy * c1], m3 = [x2 + hx * s2, y2 - hy * c2], m4 = [x2, y2];
    m2[0] = 2 * m1[0] - m2[0];
    m2[1] = 2 * m1[1] - m2[1];
    if (recursive) {
      return[m2, m3, m4][concat](res);
    } else {
      res = [m2, m3, m4][concat](res).join()[split](",");
      var newres = [];
      for (var i = 0, ii = res.length;i < ii;i++) {
        newres[i] = i % 2 ? rotate(res[i - 1], res[i], rad).y : rotate(res[i], res[i + 1], rad).x;
      }
      return newres;
    }
  }, findDotAtSegment = function(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t) {
    var t1 = 1 - t;
    return{x:pow(t1, 3) * p1x + pow(t1, 2) * 3 * t * c1x + t1 * 3 * t * t * c2x + pow(t, 3) * p2x, y:pow(t1, 3) * p1y + pow(t1, 2) * 3 * t * c1y + t1 * 3 * t * t * c2y + pow(t, 3) * p2y};
  }, curveDim = cacher(function(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y) {
    var a = c2x - 2 * c1x + p1x - (p2x - 2 * c2x + c1x), b = 2 * (c1x - p1x) - 2 * (c2x - c1x), c = p1x - c1x, t1 = (-b + math.sqrt(b * b - 4 * a * c)) / 2 / a, t2 = (-b - math.sqrt(b * b - 4 * a * c)) / 2 / a, y = [p1y, p2y], x = [p1x, p2x], dot;
    abs(t1) > "1e12" && (t1 = 0.5);
    abs(t2) > "1e12" && (t2 = 0.5);
    if (t1 > 0 && t1 < 1) {
      dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t1);
      x.push(dot.x);
      y.push(dot.y);
    }
    if (t2 > 0 && t2 < 1) {
      dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t2);
      x.push(dot.x);
      y.push(dot.y);
    }
    a = c2y - 2 * c1y + p1y - (p2y - 2 * c2y + c1y);
    b = 2 * (c1y - p1y) - 2 * (c2y - c1y);
    c = p1y - c1y;
    t1 = (-b + math.sqrt(b * b - 4 * a * c)) / 2 / a;
    t2 = (-b - math.sqrt(b * b - 4 * a * c)) / 2 / a;
    abs(t1) > "1e12" && (t1 = 0.5);
    abs(t2) > "1e12" && (t2 = 0.5);
    if (t1 > 0 && t1 < 1) {
      dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t1);
      x.push(dot.x);
      y.push(dot.y);
    }
    if (t2 > 0 && t2 < 1) {
      dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t2);
      x.push(dot.x);
      y.push(dot.y);
    }
    return{min:{x:mmin[apply](0, x), y:mmin[apply](0, y)}, max:{x:mmax[apply](0, x), y:mmax[apply](0, y)}};
  }), path2curve = R._path2curve = cacher(function(path, path2) {
    var pth = !path2 && paths(path);
    if (!path2 && pth.curve) {
      return pathClone(pth.curve);
    }
    var p = pathToAbsolute(path), p2 = path2 && pathToAbsolute(path2), attrs = {x:0, y:0, bx:0, by:0, X:0, Y:0, qx:null, qy:null}, attrs2 = {x:0, y:0, bx:0, by:0, X:0, Y:0, qx:null, qy:null}, processPath = function(path, d, pcom) {
      var nx, ny, tq = {T:1, Q:1};
      if (!path) {
        return["C", d.x, d.y, d.x, d.y, d.x, d.y];
      }
      !(path[0] in tq) && (d.qx = d.qy = null);
      switch(path[0]) {
        case "M":
          d.X = path[1];
          d.Y = path[2];
          break;
        case "A":
          path = ["C"][concat](a2c[apply](0, [d.x, d.y][concat](path.slice(1))));
          break;
        case "S":
          if (pcom == "C" || pcom == "S") {
            nx = d.x * 2 - d.bx;
            ny = d.y * 2 - d.by;
          } else {
            nx = d.x;
            ny = d.y;
          }
          path = ["C", nx, ny][concat](path.slice(1));
          break;
        case "T":
          if (pcom == "Q" || pcom == "T") {
            d.qx = d.x * 2 - d.qx;
            d.qy = d.y * 2 - d.qy;
          } else {
            d.qx = d.x;
            d.qy = d.y;
          }
          path = ["C"][concat](q2c(d.x, d.y, d.qx, d.qy, path[1], path[2]));
          break;
        case "Q":
          d.qx = path[1];
          d.qy = path[2];
          path = ["C"][concat](q2c(d.x, d.y, path[1], path[2], path[3], path[4]));
          break;
        case "L":
          path = ["C"][concat](l2c(d.x, d.y, path[1], path[2]));
          break;
        case "H":
          path = ["C"][concat](l2c(d.x, d.y, path[1], d.y));
          break;
        case "V":
          path = ["C"][concat](l2c(d.x, d.y, d.x, path[1]));
          break;
        case "Z":
          path = ["C"][concat](l2c(d.x, d.y, d.X, d.Y));
          break;
      }
      return path;
    }, fixArc = function(pp, i) {
      if (pp[i].length > 7) {
        pp[i].shift();
        var pi = pp[i];
        while (pi.length) {
          pp.splice(i++, 0, ["C"][concat](pi.splice(0, 6)));
        }
        pp.splice(i, 1);
        ii = mmax(p.length, p2 && p2.length || 0);
      }
    }, fixM = function(path1, path2, a1, a2, i) {
      if (path1 && (path2 && (path1[i][0] == "M" && path2[i][0] != "M"))) {
        path2.splice(i, 0, ["M", a2.x, a2.y]);
        a1.bx = 0;
        a1.by = 0;
        a1.x = path1[i][1];
        a1.y = path1[i][2];
        ii = mmax(p.length, p2 && p2.length || 0);
      }
    };
    for (var i = 0, ii = mmax(p.length, p2 && p2.length || 0);i < ii;i++) {
      p[i] = processPath(p[i], attrs);
      fixArc(p, i);
      p2 && (p2[i] = processPath(p2[i], attrs2));
      p2 && fixArc(p2, i);
      fixM(p, p2, attrs, attrs2, i);
      fixM(p2, p, attrs2, attrs, i);
      var seg = p[i], seg2 = p2 && p2[i], seglen = seg.length, seg2len = p2 && seg2.length;
      attrs.x = seg[seglen - 2];
      attrs.y = seg[seglen - 1];
      attrs.bx = toFloat(seg[seglen - 4]) || attrs.x;
      attrs.by = toFloat(seg[seglen - 3]) || attrs.y;
      attrs2.bx = p2 && (toFloat(seg2[seg2len - 4]) || attrs2.x);
      attrs2.by = p2 && (toFloat(seg2[seg2len - 3]) || attrs2.y);
      attrs2.x = p2 && seg2[seg2len - 2];
      attrs2.y = p2 && seg2[seg2len - 1];
    }
    if (!p2) {
      pth.curve = pathClone(p);
    }
    return p2 ? [p, p2] : p;
  }, null, pathClone), parseDots = R._parseDots = cacher(function(gradient) {
    var dots = [];
    for (var i = 0, ii = gradient.length;i < ii;i++) {
      var dot = {}, par = gradient[i].match(/^([^:]*):?([\d\.]*)/);
      dot.color = R.getRGB(par[1]);
      if (dot.color.error) {
        return null;
      }
      dot.color = dot.color.hex;
      par[2] && (dot.offset = par[2] + "%");
      dots.push(dot);
    }
    for (i = 1, ii = dots.length - 1;i < ii;i++) {
      if (!dots[i].offset) {
        var start = toFloat(dots[i - 1].offset || 0), end = 0;
        for (var j = i + 1;j < ii;j++) {
          if (dots[j].offset) {
            end = dots[j].offset;
            break;
          }
        }
        if (!end) {
          end = 100;
          j = ii;
        }
        end = toFloat(end);
        var d = (end - start) / (j - i + 1);
        for (;i < j;i++) {
          start += d;
          dots[i].offset = start + "%";
        }
      }
    }
    return dots;
  }), tear = R._tear = function(el, paper) {
    el == paper.top && (paper.top = el.prev);
    el == paper.bottom && (paper.bottom = el.next);
    el.next && (el.next.prev = el.prev);
    el.prev && (el.prev.next = el.next);
  }, tofront = R._tofront = function(el, paper) {
    if (paper.top === el) {
      return;
    }
    tear(el, paper);
    el.next = null;
    el.prev = paper.top;
    paper.top.next = el;
    paper.top = el;
  }, toback = R._toback = function(el, paper) {
    if (paper.bottom === el) {
      return;
    }
    tear(el, paper);
    el.next = paper.bottom;
    el.prev = null;
    paper.bottom.prev = el;
    paper.bottom = el;
  }, insertafter = R._insertafter = function(el, el2, paper) {
    tear(el, paper);
    el2 == paper.top && (paper.top = el);
    el2.next && (el2.next.prev = el);
    el.next = el2.next;
    el.prev = el2;
    el2.next = el;
  }, insertbefore = R._insertbefore = function(el, el2, paper) {
    tear(el, paper);
    el2 == paper.bottom && (paper.bottom = el);
    el2.prev && (el2.prev.next = el);
    el.prev = el2.prev;
    el2.prev = el;
    el.next = el2;
  }, toMatrix = R.toMatrix = function(path, transform) {
    var bb = pathDimensions(path), el = {_:{transform:E}, getBBox:function() {
      return bb;
    }};
    extractTransform(el, transform);
    return el.matrix;
  }, transformPath = R.transformPath = function(path, transform) {
    return mapPath(path, toMatrix(path, transform));
  }, extractTransform = R._extractTransform = function(el, tstr) {
    if (tstr == null) {
      return el._.transform;
    }
    tstr = Str(tstr).replace(/\.{3}|\u2026/g, el._.transform || E);
    var tdata = R.parseTransformString(tstr), deg = 0, dx = 0, dy = 0, sx = 1, sy = 1, _ = el._, m = new Matrix;
    _.transform = tdata || [];
    if (tdata) {
      for (var i = 0, ii = tdata.length;i < ii;i++) {
        var t = tdata[i], tlen = t.length, command = Str(t[0]).toLowerCase(), absolute = t[0] != command, inver = absolute ? m.invert() : 0, x1, y1, x2, y2, bb;
        if (command == "t" && tlen == 3) {
          if (absolute) {
            x1 = inver.x(0, 0);
            y1 = inver.y(0, 0);
            x2 = inver.x(t[1], t[2]);
            y2 = inver.y(t[1], t[2]);
            m.translate(x2 - x1, y2 - y1);
          } else {
            m.translate(t[1], t[2]);
          }
        } else {
          if (command == "r") {
            if (tlen == 2) {
              bb = bb || el.getBBox(1);
              m.rotate(t[1], bb.x + bb.width / 2, bb.y + bb.height / 2);
              deg += t[1];
            } else {
              if (tlen == 4) {
                if (absolute) {
                  x2 = inver.x(t[2], t[3]);
                  y2 = inver.y(t[2], t[3]);
                  m.rotate(t[1], x2, y2);
                } else {
                  m.rotate(t[1], t[2], t[3]);
                }
                deg += t[1];
              }
            }
          } else {
            if (command == "s") {
              if (tlen == 2 || tlen == 3) {
                bb = bb || el.getBBox(1);
                m.scale(t[1], t[tlen - 1], bb.x + bb.width / 2, bb.y + bb.height / 2);
                sx *= t[1];
                sy *= t[tlen - 1];
              } else {
                if (tlen == 5) {
                  if (absolute) {
                    x2 = inver.x(t[3], t[4]);
                    y2 = inver.y(t[3], t[4]);
                    m.scale(t[1], t[2], x2, y2);
                  } else {
                    m.scale(t[1], t[2], t[3], t[4]);
                  }
                  sx *= t[1];
                  sy *= t[2];
                }
              }
            } else {
              if (command == "m" && tlen == 7) {
                m.add(t[1], t[2], t[3], t[4], t[5], t[6]);
              }
            }
          }
        }
        _.dirtyT = 1;
        el.matrix = m;
      }
    }
    el.matrix = m;
    _.sx = sx;
    _.sy = sy;
    _.deg = deg;
    _.dx = dx = m.e;
    _.dy = dy = m.f;
    if (sx == 1 && (sy == 1 && (!deg && _.bbox))) {
      _.bbox.x += +dx;
      _.bbox.y += +dy;
    } else {
      _.dirtyT = 1;
    }
  }, getEmpty = function(item) {
    var l = item[0];
    switch(l.toLowerCase()) {
      case "t":
        return[l, 0, 0];
      case "m":
        return[l, 1, 0, 0, 1, 0, 0];
      case "r":
        if (item.length == 4) {
          return[l, 0, item[2], item[3]];
        } else {
          return[l, 0];
        }
      ;
      case "s":
        if (item.length == 5) {
          return[l, 1, 1, item[3], item[4]];
        } else {
          if (item.length == 3) {
            return[l, 1, 1];
          } else {
            return[l, 1];
          }
        }
      ;
    }
  }, equaliseTransform = R._equaliseTransform = function(t1, t2) {
    t2 = Str(t2).replace(/\.{3}|\u2026/g, t1);
    t1 = R.parseTransformString(t1) || [];
    t2 = R.parseTransformString(t2) || [];
    var maxlength = mmax(t1.length, t2.length), from = [], to = [], i = 0, j, jj, tt1, tt2;
    for (;i < maxlength;i++) {
      tt1 = t1[i] || getEmpty(t2[i]);
      tt2 = t2[i] || getEmpty(tt1);
      if (tt1[0] != tt2[0] || (tt1[0].toLowerCase() == "r" && (tt1[2] != tt2[2] || tt1[3] != tt2[3]) || tt1[0].toLowerCase() == "s" && (tt1[3] != tt2[3] || tt1[4] != tt2[4]))) {
        return;
      }
      from[i] = [];
      to[i] = [];
      for (j = 0, jj = mmax(tt1.length, tt2.length);j < jj;j++) {
        j in tt1 && (from[i][j] = tt1[j]);
        j in tt2 && (to[i][j] = tt2[j]);
      }
    }
    return{from:from, to:to};
  };
  R._getContainer = function(x, y, w, h) {
    var container;
    container = h == null && !R.is(x, "object") ? g.doc.getElementById(x) : x;
    if (container == null) {
      return;
    }
    if (container.tagName) {
      if (y == null) {
        return{container:container, width:container.style.pixelWidth || container.offsetWidth, height:container.style.pixelHeight || container.offsetHeight};
      } else {
        return{container:container, width:y, height:w};
      }
    }
    return{container:1, x:x, y:y, width:w, height:h};
  };
  R.pathToRelative = pathToRelative;
  R._engine = {};
  R.path2curve = path2curve;
  R.matrix = function(a, b, c, d, e, f) {
    return new Matrix(a, b, c, d, e, f);
  };
  function Matrix(a, b, c, d, e, f) {
    if (a != null) {
      this.a = +a;
      this.b = +b;
      this.c = +c;
      this.d = +d;
      this.e = +e;
      this.f = +f;
    } else {
      this.a = 1;
      this.b = 0;
      this.c = 0;
      this.d = 1;
      this.e = 0;
      this.f = 0;
    }
  }
  (function(matrixproto) {
    matrixproto.add = function(a, b, c, d, e, f) {
      var out = [[], [], []], m = [[this.a, this.c, this.e], [this.b, this.d, this.f], [0, 0, 1]], matrix = [[a, c, e], [b, d, f], [0, 0, 1]], x, y, z, res;
      if (a && a instanceof Matrix) {
        matrix = [[a.a, a.c, a.e], [a.b, a.d, a.f], [0, 0, 1]];
      }
      for (x = 0;x < 3;x++) {
        for (y = 0;y < 3;y++) {
          res = 0;
          for (z = 0;z < 3;z++) {
            res += m[x][z] * matrix[z][y];
          }
          out[x][y] = res;
        }
      }
      this.a = out[0][0];
      this.b = out[1][0];
      this.c = out[0][1];
      this.d = out[1][1];
      this.e = out[0][2];
      this.f = out[1][2];
    };
    matrixproto.invert = function() {
      var me = this, x = me.a * me.d - me.b * me.c;
      return new Matrix(me.d / x, -me.b / x, -me.c / x, me.a / x, (me.c * me.f - me.d * me.e) / x, (me.b * me.e - me.a * me.f) / x);
    };
    matrixproto.clone = function() {
      return new Matrix(this.a, this.b, this.c, this.d, this.e, this.f);
    };
    matrixproto.translate = function(x, y) {
      this.add(1, 0, 0, 1, x, y);
    };
    matrixproto.scale = function(x, y, cx, cy) {
      y == null && (y = x);
      (cx || cy) && this.add(1, 0, 0, 1, cx, cy);
      this.add(x, 0, 0, y, 0, 0);
      (cx || cy) && this.add(1, 0, 0, 1, -cx, -cy);
    };
    matrixproto.rotate = function(a, x, y) {
      a = R.rad(a);
      x = x || 0;
      y = y || 0;
      var cos = +math.cos(a).toFixed(9), sin = +math.sin(a).toFixed(9);
      this.add(cos, sin, -sin, cos, x, y);
      this.add(1, 0, 0, 1, -x, -y);
    };
    matrixproto.x = function(x, y) {
      return x * this.a + y * this.c + this.e;
    };
    matrixproto.y = function(x, y) {
      return x * this.b + y * this.d + this.f;
    };
    matrixproto.get = function(i) {
      return+this[Str.fromCharCode(97 + i)].toFixed(4);
    };
    matrixproto.toString = function() {
      return R.svg ? "matrix(" + [this.get(0), this.get(1), this.get(2), this.get(3), this.get(4), this.get(5)].join() + ")" : [this.get(0), this.get(2), this.get(1), this.get(3), 0, 0].join();
    };
    matrixproto.toFilter = function() {
      return "progid:DXImageTransform.Microsoft.Matrix(M11=" + this.get(0) + ", M12=" + this.get(2) + ", M21=" + this.get(1) + ", M22=" + this.get(3) + ", Dx=" + this.get(4) + ", Dy=" + this.get(5) + ", sizingmethod='auto expand')";
    };
    matrixproto.offset = function() {
      return[this.e.toFixed(4), this.f.toFixed(4)];
    };
    function norm(a) {
      return a[0] * a[0] + a[1] * a[1];
    }
    function normalize(a) {
      var mag = math.sqrt(norm(a));
      a[0] && (a[0] /= mag);
      a[1] && (a[1] /= mag);
    }
    matrixproto.split = function() {
      var out = {};
      out.dx = this.e;
      out.dy = this.f;
      var row = [[this.a, this.c], [this.b, this.d]];
      out.scalex = math.sqrt(norm(row[0]));
      normalize(row[0]);
      out.shear = row[0][0] * row[1][0] + row[0][1] * row[1][1];
      row[1] = [row[1][0] - row[0][0] * out.shear, row[1][1] - row[0][1] * out.shear];
      out.scaley = math.sqrt(norm(row[1]));
      normalize(row[1]);
      out.shear /= out.scaley;
      var sin = -row[0][1], cos = row[1][1];
      if (cos < 0) {
        out.rotate = R.deg(math.acos(cos));
        if (sin < 0) {
          out.rotate = 360 - out.rotate;
        }
      } else {
        out.rotate = R.deg(math.asin(sin));
      }
      out.isSimple = !+out.shear.toFixed(9) && (out.scalex.toFixed(9) == out.scaley.toFixed(9) || !out.rotate);
      out.isSuperSimple = !+out.shear.toFixed(9) && (out.scalex.toFixed(9) == out.scaley.toFixed(9) && !out.rotate);
      out.noRotation = !+out.shear.toFixed(9) && !out.rotate;
      return out;
    };
    matrixproto.toTransformString = function(shorter) {
      var s = shorter || this[split]();
      if (s.isSimple) {
        s.scalex = +s.scalex.toFixed(4);
        s.scaley = +s.scaley.toFixed(4);
        s.rotate = +s.rotate.toFixed(4);
        return(s.dx || s.dy ? "t" + [s.dx, s.dy] : E) + (s.scalex != 1 || s.scaley != 1 ? "s" + [s.scalex, s.scaley, 0, 0] : E) + (s.rotate ? "r" + [s.rotate, 0, 0] : E);
      } else {
        return "m" + [this.get(0), this.get(1), this.get(2), this.get(3), this.get(4), this.get(5)];
      }
    };
  })(Matrix.prototype);
  var version = navigator.userAgent.match(/Version\/(.*?)\s/) || navigator.userAgent.match(/Chrome\/(\d+)/);
  if (navigator.vendor == "Apple Computer, Inc." && (version && version[1] < 4 || navigator.platform.slice(0, 2) == "iP") || navigator.vendor == "Google Inc." && (version && version[1] < 8)) {
    paperproto.safari = function() {
      var rect = this.rect(-99, -99, this.width + 99, this.height + 99).attr({stroke:"none"});
      setTimeout(function() {
        rect.remove();
      });
    };
  } else {
    paperproto.safari = fun;
  }
  var preventDefault = function() {
    this.returnValue = false;
  }, preventTouch = function() {
    return this.originalEvent.preventDefault();
  }, stopPropagation = function() {
    this.cancelBubble = true;
  }, stopTouch = function() {
    return this.originalEvent.stopPropagation();
  }, getEventPosition = function(e) {
    var scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop, scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft;
    return{x:e.clientX + scrollX, y:e.clientY + scrollY};
  }, addEvent = function() {
    if (g.doc.addEventListener) {
      return function(obj, type, fn, element) {
        var f = function(e) {
          var pos = getEventPosition(e);
          return fn.call(element, e, pos.x, pos.y);
        };
        obj.addEventListener(type, f, false);
        if (supportsTouch && touchMap[type]) {
          var _f = function(e) {
            var pos = getEventPosition(e), olde = e;
            for (var i = 0, ii = e.targetTouches && e.targetTouches.length;i < ii;i++) {
              if (e.targetTouches[i].target == obj) {
                e = e.targetTouches[i];
                e.originalEvent = olde;
                e.preventDefault = preventTouch;
                e.stopPropagation = stopTouch;
                break;
              }
            }
            return fn.call(element, e, pos.x, pos.y);
          };
          obj.addEventListener(touchMap[type], _f, false);
        }
        return function() {
          obj.removeEventListener(type, f, false);
          if (supportsTouch && touchMap[type]) {
            obj.removeEventListener(touchMap[type], f, false);
          }
          return true;
        };
      };
    } else {
      if (g.doc.attachEvent) {
        return function(obj, type, fn, element) {
          var f = function(e) {
            e = e || g.win.event;
            var scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop, scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft, x = e.clientX + scrollX, y = e.clientY + scrollY;
            e.preventDefault = e.preventDefault || preventDefault;
            e.stopPropagation = e.stopPropagation || stopPropagation;
            return fn.call(element, e, x, y);
          };
          obj.attachEvent("on" + type, f);
          var detacher = function() {
            obj.detachEvent("on" + type, f);
            return true;
          };
          return detacher;
        };
      }
    }
  }(), drag = [], dragMove = function(e) {
    var x = e.clientX, y = e.clientY, scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop, scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft, dragi, j = drag.length;
    while (j--) {
      dragi = drag[j];
      if (supportsTouch && e.touches) {
        var i = e.touches.length, touch;
        while (i--) {
          touch = e.touches[i];
          if (touch.identifier == dragi.el._drag.id) {
            x = touch.clientX;
            y = touch.clientY;
            (e.originalEvent ? e.originalEvent : e).preventDefault();
            break;
          }
        }
      } else {
        e.preventDefault();
      }
      var node = dragi.el.node, o, next = node.nextSibling, parent = node.parentNode, display = node.style.display;
      g.win.opera && parent.removeChild(node);
      node.style.display = "none";
      o = dragi.el.paper.getElementByPoint(x, y);
      node.style.display = display;
      g.win.opera && (next ? parent.insertBefore(node, next) : parent.appendChild(node));
      o && eve("raphael.drag.over." + dragi.el.id, dragi.el, o);
      x += scrollX;
      y += scrollY;
      eve("raphael.drag.move." + dragi.el.id, dragi.move_scope || dragi.el, x - dragi.el._drag.x, y - dragi.el._drag.y, x, y, e);
    }
  }, dragUp = function(e) {
    R.unmousemove(dragMove).unmouseup(dragUp);
    var i = drag.length, dragi;
    while (i--) {
      dragi = drag[i];
      dragi.el._drag = {};
      eve("raphael.drag.end." + dragi.el.id, dragi.end_scope || (dragi.start_scope || (dragi.move_scope || dragi.el)), e);
    }
    drag = [];
  }, elproto = R.el = {};
  for (var i = events.length;i--;) {
    (function(eventName) {
      R[eventName] = elproto[eventName] = function(fn, scope) {
        if (R.is(fn, "function")) {
          this.events = this.events || [];
          this.events.push({name:eventName, f:fn, unbind:addEvent(this.shape || (this.node || g.doc), eventName, fn, scope || this)});
        }
        return this;
      };
      R["un" + eventName] = elproto["un" + eventName] = function(fn) {
        var events = this.events || [], l = events.length;
        while (l--) {
          if (events[l].name == eventName && (R.is(fn, "undefined") || events[l].f == fn)) {
            events[l].unbind();
            events.splice(l, 1);
            !events.length && delete this.events;
          }
        }
        return this;
      };
    })(events[i]);
  }
  elproto.data = function(key, value) {
    var data = eldata[this.id] = eldata[this.id] || {};
    if (arguments.length == 0) {
      return data;
    }
    if (arguments.length == 1) {
      if (R.is(key, "object")) {
        for (var i in key) {
          if (key[has](i)) {
            this.data(i, key[i]);
          }
        }
        return this;
      }
      eve("raphael.data.get." + this.id, this, data[key], key);
      return data[key];
    }
    data[key] = value;
    eve("raphael.data.set." + this.id, this, value, key);
    return this;
  };
  elproto.removeData = function(key) {
    if (key == null) {
      eldata[this.id] = {};
    } else {
      eldata[this.id] && delete eldata[this.id][key];
    }
    return this;
  };
  elproto.getData = function() {
    return clone(eldata[this.id] || {});
  };
  elproto.hover = function(f_in, f_out, scope_in, scope_out) {
    return this.mouseover(f_in, scope_in).mouseout(f_out, scope_out || scope_in);
  };
  elproto.unhover = function(f_in, f_out) {
    return this.unmouseover(f_in).unmouseout(f_out);
  };
  var draggable = [];
  elproto.drag = function(onmove, onstart, onend, move_scope, start_scope, end_scope) {
    function start(e) {
      (e.originalEvent || e).preventDefault();
      var x = e.clientX, y = e.clientY, scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop, scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft;
      this._drag.id = e.identifier;
      if (supportsTouch && e.touches) {
        var i = e.touches.length, touch;
        while (i--) {
          touch = e.touches[i];
          this._drag.id = touch.identifier;
          if (touch.identifier == this._drag.id) {
            x = touch.clientX;
            y = touch.clientY;
            break;
          }
        }
      }
      this._drag.x = x + scrollX;
      this._drag.y = y + scrollY;
      !drag.length && R.mousemove(dragMove).mouseup(dragUp);
      drag.push({el:this, move_scope:move_scope, start_scope:start_scope, end_scope:end_scope});
      onstart && eve.on("raphael.drag.start." + this.id, onstart);
      onmove && eve.on("raphael.drag.move." + this.id, onmove);
      onend && eve.on("raphael.drag.end." + this.id, onend);
      eve("raphael.drag.start." + this.id, start_scope || (move_scope || this), e.clientX + scrollX, e.clientY + scrollY, e);
    }
    this._drag = {};
    draggable.push({el:this, start:start});
    this.mousedown(start);
    return this;
  };
  elproto.onDragOver = function(f) {
    f ? eve.on("raphael.drag.over." + this.id, f) : eve.unbind("raphael.drag.over." + this.id);
  };
  elproto.undrag = function() {
    var i = draggable.length;
    while (i--) {
      if (draggable[i].el == this) {
        this.unmousedown(draggable[i].start);
        draggable.splice(i, 1);
        eve.unbind("raphael.drag.*." + this.id);
      }
    }
    !draggable.length && R.unmousemove(dragMove).unmouseup(dragUp);
    drag = [];
  };
  paperproto.circle = function(x, y, r) {
    var out = R._engine.circle(this, x || 0, y || 0, r || 0);
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.rect = function(x, y, w, h, r) {
    var out = R._engine.rect(this, x || 0, y || 0, w || 0, h || 0, r || 0);
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.ellipse = function(x, y, rx, ry) {
    var out = R._engine.ellipse(this, x || 0, y || 0, rx || 0, ry || 0);
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.path = function(pathString) {
    pathString && (!R.is(pathString, string) && (!R.is(pathString[0], array) && (pathString += E)));
    var out = R._engine.path(R.format[apply](R, arguments), this);
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.image = function(src, x, y, w, h) {
    var out = R._engine.image(this, src || "about:blank", x || 0, y || 0, w || 0, h || 0);
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.text = function(x, y, text) {
    var out = R._engine.text(this, x || 0, y || 0, Str(text));
    this.__set__ && this.__set__.push(out);
    return out;
  };
  paperproto.set = function(itemsArray) {
    !R.is(itemsArray, "array") && (itemsArray = Array.prototype.splice.call(arguments, 0, arguments.length));
    var out = new Set(itemsArray);
    this.__set__ && this.__set__.push(out);
    out["paper"] = this;
    out["type"] = "set";
    return out;
  };
  paperproto.setStart = function(set) {
    this.__set__ = set || this.set();
  };
  paperproto.setFinish = function(set) {
    var out = this.__set__;
    delete this.__set__;
    return out;
  };
  paperproto.setSize = function(width, height) {
    return R._engine.setSize.call(this, width, height);
  };
  paperproto.setViewBox = function(x, y, w, h, fit) {
    return R._engine.setViewBox.call(this, x, y, w, h, fit);
  };
  paperproto.top = paperproto.bottom = null;
  paperproto.raphael = R;
  var getOffset = function(elem) {
    var box = elem.getBoundingClientRect(), doc = elem.ownerDocument, body = doc.body, docElem = doc.documentElement, clientTop = docElem.clientTop || (body.clientTop || 0), clientLeft = docElem.clientLeft || (body.clientLeft || 0), top = box.top + (g.win.pageYOffset || (docElem.scrollTop || body.scrollTop)) - clientTop, left = box.left + (g.win.pageXOffset || (docElem.scrollLeft || body.scrollLeft)) - clientLeft;
    return{y:top, x:left};
  };
  paperproto.getElementByPoint = function(x, y) {
    var paper = this, svg = paper.canvas, target = g.doc.elementFromPoint(x, y);
    if (g.win.opera && target.tagName == "svg") {
      var so = getOffset(svg), sr = svg.createSVGRect();
      sr.x = x - so.x;
      sr.y = y - so.y;
      sr.width = sr.height = 1;
      var hits = svg.getIntersectionList(sr, null);
      if (hits.length) {
        target = hits[hits.length - 1];
      }
    }
    if (!target) {
      return null;
    }
    while (target.parentNode && (target != svg.parentNode && !target.raphael)) {
      target = target.parentNode;
    }
    target == paper.canvas.parentNode && (target = svg);
    target = target && target.raphael ? paper.getById(target.raphaelid) : null;
    return target;
  };
  paperproto.getElementsByBBox = function(bbox) {
    var set = this.set();
    this.forEach(function(el) {
      if (R.isBBoxIntersect(el.getBBox(), bbox)) {
        set.push(el);
      }
    });
    return set;
  };
  paperproto.getById = function(id) {
    var bot = this.bottom;
    while (bot) {
      if (bot.id == id) {
        return bot;
      }
      bot = bot.next;
    }
    return null;
  };
  paperproto.forEach = function(callback, thisArg) {
    var bot = this.bottom;
    while (bot) {
      if (callback.call(thisArg, bot) === false) {
        return this;
      }
      bot = bot.next;
    }
    return this;
  };
  paperproto.getElementsByPoint = function(x, y) {
    var set = this.set();
    this.forEach(function(el) {
      if (el.isPointInside(x, y)) {
        set.push(el);
      }
    });
    return set;
  };
  function x_y() {
    return this.x + S + this.y;
  }
  function x_y_w_h() {
    return this.x + S + this.y + S + this.width + " \u00d7 " + this.height;
  }
  elproto.isPointInside = function(x, y) {
    var rp = this.realPath = getPath[this.type](this);
    if (this.attr("transform") && this.attr("transform").length) {
      rp = R.transformPath(rp, this.attr("transform"));
    }
    return R.isPointInsidePath(rp, x, y);
  };
  elproto.getBBox = function(isWithoutTransform) {
    if (this.removed) {
      return{};
    }
    var _ = this._;
    if (isWithoutTransform) {
      if (_.dirty || !_.bboxwt) {
        this.realPath = getPath[this.type](this);
        _.bboxwt = pathDimensions(this.realPath);
        _.bboxwt.toString = x_y_w_h;
        _.dirty = 0;
      }
      return _.bboxwt;
    }
    if (_.dirty || (_.dirtyT || !_.bbox)) {
      if (_.dirty || !this.realPath) {
        _.bboxwt = 0;
        this.realPath = getPath[this.type](this);
      }
      _.bbox = pathDimensions(mapPath(this.realPath, this.matrix));
      _.bbox.toString = x_y_w_h;
      _.dirty = _.dirtyT = 0;
    }
    return _.bbox;
  };
  elproto.clone = function() {
    if (this.removed) {
      return null;
    }
    var out = this.paper[this.type]().attr(this.attr());
    this.__set__ && this.__set__.push(out);
    return out;
  };
  elproto.glow = function(glow) {
    if (this.type == "text") {
      return null;
    }
    glow = glow || {};
    var s = {width:(glow.width || 10) + (+this.attr("stroke-width") || 1), fill:glow.fill || false, opacity:glow.opacity || 0.5, offsetx:glow.offsetx || 0, offsety:glow.offsety || 0, color:glow.color || "#000"}, c = s.width / 2, r = this.paper, out = r.set(), path = this.realPath || getPath[this.type](this);
    path = this.matrix ? mapPath(path, this.matrix) : path;
    for (var i = 1;i < c + 1;i++) {
      out.push(r.path(path).attr({stroke:s.color, fill:s.fill ? s.color : "none", "stroke-linejoin":"round", "stroke-linecap":"round", "stroke-width":+(s.width / c * i).toFixed(3), opacity:+(s.opacity / c).toFixed(3)}));
    }
    return out.insertBefore(this).translate(s.offsetx, s.offsety);
  };
  var curveslengths = {}, getPointAtSegmentLength = function(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, length) {
    if (length == null) {
      return bezlen(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y);
    } else {
      return R.findDotsAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, getTatLen(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, length));
    }
  }, getLengthFactory = function(istotal, subpath) {
    return function(path, length, onlystart) {
      path = path2curve(path);
      var x, y, p, l, sp = "", subpaths = {}, point, len = 0;
      for (var i = 0, ii = path.length;i < ii;i++) {
        p = path[i];
        if (p[0] == "M") {
          x = +p[1];
          y = +p[2];
        } else {
          l = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6]);
          if (len + l > length) {
            if (subpath && !subpaths.start) {
              point = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6], length - len);
              sp += ["C" + point.start.x, point.start.y, point.m.x, point.m.y, point.x, point.y];
              if (onlystart) {
                return sp;
              }
              subpaths.start = sp;
              sp = ["M" + point.x, point.y + "C" + point.n.x, point.n.y, point.end.x, point.end.y, p[5], p[6]].join();
              len += l;
              x = +p[5];
              y = +p[6];
              continue;
            }
            if (!istotal && !subpath) {
              point = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6], length - len);
              return{x:point.x, y:point.y, alpha:point.alpha};
            }
          }
          len += l;
          x = +p[5];
          y = +p[6];
        }
        sp += p.shift() + p;
      }
      subpaths.end = sp;
      point = istotal ? len : subpath ? subpaths : R.findDotsAtSegment(x, y, p[0], p[1], p[2], p[3], p[4], p[5], 1);
      point.alpha && (point = {x:point.x, y:point.y, alpha:point.alpha});
      return point;
    };
  };
  var getTotalLength = getLengthFactory(1), getPointAtLength = getLengthFactory(), getSubpathsAtLength = getLengthFactory(0, 1);
  R.getTotalLength = getTotalLength;
  R.getPointAtLength = getPointAtLength;
  R.getSubpath = function(path, from, to) {
    if (this.getTotalLength(path) - to < 1E-6) {
      return getSubpathsAtLength(path, from).end;
    }
    var a = getSubpathsAtLength(path, to, 1);
    return from ? getSubpathsAtLength(a, from).end : a;
  };
  elproto.getTotalLength = function() {
    var path = this.getPath();
    if (!path) {
      return;
    }
    if (this.node.getTotalLength) {
      return this.node.getTotalLength();
    }
    return getTotalLength(path);
  };
  elproto.getPointAtLength = function(length) {
    var path = this.getPath();
    if (!path) {
      return;
    }
    return getPointAtLength(path, length);
  };
  elproto.getPath = function() {
    var path, getPath = R._getPath[this.type];
    if (this.type == "text" || this.type == "set") {
      return;
    }
    if (getPath) {
      path = getPath(this);
    }
    return path;
  };
  elproto.getSubpath = function(from, to) {
    var path = this.getPath();
    if (!path) {
      return;
    }
    return R.getSubpath(path, from, to);
  };
  var ef = R.easing_formulas = {linear:function(n) {
    return n;
  }, "<":function(n) {
    return pow(n, 1.7);
  }, ">":function(n) {
    return pow(n, 0.48);
  }, "<>":function(n) {
    var q = 0.48 - n / 1.04, Q = math.sqrt(0.1734 + q * q), x = Q - q, X = pow(abs(x), 1 / 3) * (x < 0 ? -1 : 1), y = -Q - q, Y = pow(abs(y), 1 / 3) * (y < 0 ? -1 : 1), t = X + Y + 0.5;
    return(1 - t) * 3 * t * t + t * t * t;
  }, backIn:function(n) {
    var s = 1.70158;
    return n * n * ((s + 1) * n - s);
  }, backOut:function(n) {
    n = n - 1;
    var s = 1.70158;
    return n * n * ((s + 1) * n + s) + 1;
  }, elastic:function(n) {
    if (n == !!n) {
      return n;
    }
    return pow(2, -10 * n) * math.sin((n - 0.075) * (2 * PI) / 0.3) + 1;
  }, bounce:function(n) {
    var s = 7.5625, p = 2.75, l;
    if (n < 1 / p) {
      l = s * n * n;
    } else {
      if (n < 2 / p) {
        n -= 1.5 / p;
        l = s * n * n + 0.75;
      } else {
        if (n < 2.5 / p) {
          n -= 2.25 / p;
          l = s * n * n + 0.9375;
        } else {
          n -= 2.625 / p;
          l = s * n * n + 0.984375;
        }
      }
    }
    return l;
  }};
  ef.easeIn = ef["ease-in"] = ef["<"];
  ef.easeOut = ef["ease-out"] = ef[">"];
  ef.easeInOut = ef["ease-in-out"] = ef["<>"];
  ef["back-in"] = ef.backIn;
  ef["back-out"] = ef.backOut;
  var animationElements = [], requestAnimFrame = window.requestAnimationFrame || (window.webkitRequestAnimationFrame || (window.mozRequestAnimationFrame || (window.oRequestAnimationFrame || (window.msRequestAnimationFrame || function(callback) {
    setTimeout(callback, 16);
  })))), animation = function() {
    var Now = +new Date, l = 0;
    for (;l < animationElements.length;l++) {
      var e = animationElements[l];
      if (e.el.removed || e.paused) {
        continue;
      }
      var time = Now - e.start, ms = e.ms, easing = e.easing, from = e.from, diff = e.diff, to = e.to, t = e.t, that = e.el, set = {}, now, init = {}, key;
      if (e.initstatus) {
        time = (e.initstatus * e.anim.top - e.prev) / (e.percent - e.prev) * ms;
        e.status = e.initstatus;
        delete e.initstatus;
        e.stop && animationElements.splice(l--, 1);
      } else {
        e.status = (e.prev + (e.percent - e.prev) * (time / ms)) / e.anim.top;
      }
      if (time < 0) {
        continue;
      }
      if (time < ms) {
        var pos = easing(time / ms);
        for (var attr in from) {
          if (from[has](attr)) {
            switch(availableAnimAttrs[attr]) {
              case nu:
                now = +from[attr] + pos * ms * diff[attr];
                break;
              case "colour":
                now = "rgb(" + [upto255(round(from[attr].r + pos * ms * diff[attr].r)), upto255(round(from[attr].g + pos * ms * diff[attr].g)), upto255(round(from[attr].b + pos * ms * diff[attr].b))].join(",") + ")";
                break;
              case "path":
                now = [];
                for (var i = 0, ii = from[attr].length;i < ii;i++) {
                  now[i] = [from[attr][i][0]];
                  for (var j = 1, jj = from[attr][i].length;j < jj;j++) {
                    now[i][j] = +from[attr][i][j] + pos * ms * diff[attr][i][j];
                  }
                  now[i] = now[i].join(S);
                }
                now = now.join(S);
                break;
              case "transform":
                if (diff[attr].real) {
                  now = [];
                  for (i = 0, ii = from[attr].length;i < ii;i++) {
                    now[i] = [from[attr][i][0]];
                    for (j = 1, jj = from[attr][i].length;j < jj;j++) {
                      now[i][j] = from[attr][i][j] + pos * ms * diff[attr][i][j];
                    }
                  }
                } else {
                  var get = function(i) {
                    return+from[attr][i] + pos * ms * diff[attr][i];
                  };
                  now = [["m", get(0), get(1), get(2), get(3), get(4), get(5)]];
                }
                break;
              case "csv":
                if (attr == "clip-rect") {
                  now = [];
                  i = 4;
                  while (i--) {
                    now[i] = +from[attr][i] + pos * ms * diff[attr][i];
                  }
                }
                break;
              default:
                var from2 = [][concat](from[attr]);
                now = [];
                i = that.paper.customAttributes[attr].length;
                while (i--) {
                  now[i] = +from2[i] + pos * ms * diff[attr][i];
                }
                break;
            }
            set[attr] = now;
          }
        }
        that.attr(set);
        (function(id, that, anim) {
          setTimeout(function() {
            eve("raphael.anim.frame." + id, that, anim);
          });
        })(that.id, that, e.anim);
      } else {
        (function(f, el, a) {
          setTimeout(function() {
            eve("raphael.anim.frame." + el.id, el, a);
            eve("raphael.anim.finish." + el.id, el, a);
            R.is(f, "function") && f.call(el);
          });
        })(e.callback, that, e.anim);
        that.attr(to);
        animationElements.splice(l--, 1);
        if (e.repeat > 1 && !e.next) {
          for (key in to) {
            if (to[has](key)) {
              init[key] = e.totalOrigin[key];
            }
          }
          e.el.attr(init);
          runAnimation(e.anim, e.el, e.anim.percents[0], null, e.totalOrigin, e.repeat - 1);
        }
        if (e.next && !e.stop) {
          runAnimation(e.anim, e.el, e.next, null, e.totalOrigin, e.repeat);
        }
      }
    }
    R.svg && (that && (that.paper && that.paper.safari()));
    animationElements.length && requestAnimFrame(animation);
  }, upto255 = function(color) {
    return color > 255 ? 255 : color < 0 ? 0 : color;
  };
  elproto.animateWith = function(el, anim, params, ms, easing, callback) {
    var element = this;
    if (element.removed) {
      callback && callback.call(element);
      return element;
    }
    var a = params instanceof Animation ? params : R.animation(params, ms, easing, callback), x, y;
    runAnimation(a, element, a.percents[0], null, element.attr());
    for (var i = 0, ii = animationElements.length;i < ii;i++) {
      if (animationElements[i].anim == anim && animationElements[i].el == el) {
        animationElements[ii - 1].start = animationElements[i].start;
        break;
      }
    }
    return element;
  };
  function CubicBezierAtTime(t, p1x, p1y, p2x, p2y, duration) {
    var cx = 3 * p1x, bx = 3 * (p2x - p1x) - cx, ax = 1 - cx - bx, cy = 3 * p1y, by = 3 * (p2y - p1y) - cy, ay = 1 - cy - by;
    function sampleCurveX(t) {
      return((ax * t + bx) * t + cx) * t;
    }
    function solve(x, epsilon) {
      var t = solveCurveX(x, epsilon);
      return((ay * t + by) * t + cy) * t;
    }
    function solveCurveX(x, epsilon) {
      var t0, t1, t2, x2, d2, i;
      for (t2 = x, i = 0;i < 8;i++) {
        x2 = sampleCurveX(t2) - x;
        if (abs(x2) < epsilon) {
          return t2;
        }
        d2 = (3 * ax * t2 + 2 * bx) * t2 + cx;
        if (abs(d2) < 1E-6) {
          break;
        }
        t2 = t2 - x2 / d2;
      }
      t0 = 0;
      t1 = 1;
      t2 = x;
      if (t2 < t0) {
        return t0;
      }
      if (t2 > t1) {
        return t1;
      }
      while (t0 < t1) {
        x2 = sampleCurveX(t2);
        if (abs(x2 - x) < epsilon) {
          return t2;
        }
        if (x > x2) {
          t0 = t2;
        } else {
          t1 = t2;
        }
        t2 = (t1 - t0) / 2 + t0;
      }
      return t2;
    }
    return solve(t, 1 / (200 * duration));
  }
  elproto.onAnimation = function(f) {
    f ? eve.on("raphael.anim.frame." + this.id, f) : eve.unbind("raphael.anim.frame." + this.id);
    return this;
  };
  function Animation(anim, ms) {
    var percents = [], newAnim = {};
    this.ms = ms;
    this.times = 1;
    if (anim) {
      for (var attr in anim) {
        if (anim[has](attr)) {
          newAnim[toFloat(attr)] = anim[attr];
          percents.push(toFloat(attr));
        }
      }
      percents.sort(sortByNumber);
    }
    this.anim = newAnim;
    this.top = percents[percents.length - 1];
    this.percents = percents;
  }
  Animation.prototype.delay = function(delay) {
    var a = new Animation(this.anim, this.ms);
    a.times = this.times;
    a.del = +delay || 0;
    return a;
  };
  Animation.prototype.repeat = function(times) {
    var a = new Animation(this.anim, this.ms);
    a.del = this.del;
    a.times = math.floor(mmax(times, 0)) || 1;
    return a;
  };
  function runAnimation(anim, element, percent, status, totalOrigin, times) {
    percent = toFloat(percent);
    var params, isInAnim, isInAnimSet, percents = [], next, prev, timestamp, ms = anim.ms, from = {}, to = {}, diff = {};
    if (status) {
      for (i = 0, ii = animationElements.length;i < ii;i++) {
        var e = animationElements[i];
        if (e.el.id == element.id && e.anim == anim) {
          if (e.percent != percent) {
            animationElements.splice(i, 1);
            isInAnimSet = 1;
          } else {
            isInAnim = e;
          }
          element.attr(e.totalOrigin);
          break;
        }
      }
    } else {
      status = +to;
    }
    for (var i = 0, ii = anim.percents.length;i < ii;i++) {
      if (anim.percents[i] == percent || anim.percents[i] > status * anim.top) {
        percent = anim.percents[i];
        prev = anim.percents[i - 1] || 0;
        ms = ms / anim.top * (percent - prev);
        next = anim.percents[i + 1];
        params = anim.anim[percent];
        break;
      } else {
        if (status) {
          element.attr(anim.anim[anim.percents[i]]);
        }
      }
    }
    if (!params) {
      return;
    }
    if (!isInAnim) {
      for (var attr in params) {
        if (params[has](attr)) {
          if (availableAnimAttrs[has](attr) || element.paper.customAttributes[has](attr)) {
            from[attr] = element.attr(attr);
            from[attr] == null && (from[attr] = availableAttrs[attr]);
            to[attr] = params[attr];
            switch(availableAnimAttrs[attr]) {
              case nu:
                diff[attr] = (to[attr] - from[attr]) / ms;
                break;
              case "colour":
                from[attr] = R.getRGB(from[attr]);
                var toColour = R.getRGB(to[attr]);
                diff[attr] = {r:(toColour.r - from[attr].r) / ms, g:(toColour.g - from[attr].g) / ms, b:(toColour.b - from[attr].b) / ms};
                break;
              case "path":
                var pathes = path2curve(from[attr], to[attr]), toPath = pathes[1];
                from[attr] = pathes[0];
                diff[attr] = [];
                for (i = 0, ii = from[attr].length;i < ii;i++) {
                  diff[attr][i] = [0];
                  for (var j = 1, jj = from[attr][i].length;j < jj;j++) {
                    diff[attr][i][j] = (toPath[i][j] - from[attr][i][j]) / ms;
                  }
                }
                break;
              case "transform":
                var _ = element._, eq = equaliseTransform(_[attr], to[attr]);
                if (eq) {
                  from[attr] = eq.from;
                  to[attr] = eq.to;
                  diff[attr] = [];
                  diff[attr].real = true;
                  for (i = 0, ii = from[attr].length;i < ii;i++) {
                    diff[attr][i] = [from[attr][i][0]];
                    for (j = 1, jj = from[attr][i].length;j < jj;j++) {
                      diff[attr][i][j] = (to[attr][i][j] - from[attr][i][j]) / ms;
                    }
                  }
                } else {
                  var m = element.matrix || new Matrix, to2 = {_:{transform:_.transform}, getBBox:function() {
                    return element.getBBox(1);
                  }};
                  from[attr] = [m.a, m.b, m.c, m.d, m.e, m.f];
                  extractTransform(to2, to[attr]);
                  to[attr] = to2._.transform;
                  diff[attr] = [(to2.matrix.a - m.a) / ms, (to2.matrix.b - m.b) / ms, (to2.matrix.c - m.c) / ms, (to2.matrix.d - m.d) / ms, (to2.matrix.e - m.e) / ms, (to2.matrix.f - m.f) / ms];
                }
                break;
              case "csv":
                var values = Str(params[attr])[split](separator), from2 = Str(from[attr])[split](separator);
                if (attr == "clip-rect") {
                  from[attr] = from2;
                  diff[attr] = [];
                  i = from2.length;
                  while (i--) {
                    diff[attr][i] = (values[i] - from[attr][i]) / ms;
                  }
                }
                to[attr] = values;
                break;
              default:
                values = [][concat](params[attr]);
                from2 = [][concat](from[attr]);
                diff[attr] = [];
                i = element.paper.customAttributes[attr].length;
                while (i--) {
                  diff[attr][i] = ((values[i] || 0) - (from2[i] || 0)) / ms;
                }
                break;
            }
          }
        }
      }
      var easing = params.easing, easyeasy = R.easing_formulas[easing];
      if (!easyeasy) {
        easyeasy = Str(easing).match(bezierrg);
        if (easyeasy && easyeasy.length == 5) {
          var curve = easyeasy;
          easyeasy = function(t) {
            return CubicBezierAtTime(t, +curve[1], +curve[2], +curve[3], +curve[4], ms);
          };
        } else {
          easyeasy = pipe;
        }
      }
      timestamp = params.start || (anim.start || +new Date);
      e = {anim:anim, percent:percent, timestamp:timestamp, start:timestamp + (anim.del || 0), status:0, initstatus:status || 0, stop:false, ms:ms, easing:easyeasy, from:from, diff:diff, to:to, el:element, callback:params.callback, prev:prev, next:next, repeat:times || anim.times, origin:element.attr(), totalOrigin:totalOrigin};
      animationElements.push(e);
      if (status && (!isInAnim && !isInAnimSet)) {
        e.stop = true;
        e.start = new Date - ms * status;
        if (animationElements.length == 1) {
          return animation();
        }
      }
      if (isInAnimSet) {
        e.start = new Date - e.ms * status;
      }
      animationElements.length == 1 && requestAnimFrame(animation);
    } else {
      isInAnim.initstatus = status;
      isInAnim.start = new Date - isInAnim.ms * status;
    }
    eve("raphael.anim.start." + element.id, element, anim);
  }
  R.animation = function(params, ms, easing, callback) {
    if (params instanceof Animation) {
      return params;
    }
    if (R.is(easing, "function") || !easing) {
      callback = callback || (easing || null);
      easing = null;
    }
    params = Object(params);
    ms = +ms || 0;
    var p = {}, json, attr;
    for (attr in params) {
      if (params[has](attr) && (toFloat(attr) != attr && toFloat(attr) + "%" != attr)) {
        json = true;
        p[attr] = params[attr];
      }
    }
    if (!json) {
      return new Animation(params, ms);
    } else {
      easing && (p.easing = easing);
      callback && (p.callback = callback);
      return new Animation({100:p}, ms);
    }
  };
  elproto.animate = function(params, ms, easing, callback) {
    var element = this;
    if (element.removed) {
      callback && callback.call(element);
      return element;
    }
    var anim = params instanceof Animation ? params : R.animation(params, ms, easing, callback);
    runAnimation(anim, element, anim.percents[0], null, element.attr());
    return element;
  };
  elproto.setTime = function(anim, value) {
    if (anim && value != null) {
      this.status(anim, mmin(value, anim.ms) / anim.ms);
    }
    return this;
  };
  elproto.status = function(anim, value) {
    var out = [], i = 0, len, e;
    if (value != null) {
      runAnimation(anim, this, -1, mmin(value, 1));
      return this;
    } else {
      len = animationElements.length;
      for (;i < len;i++) {
        e = animationElements[i];
        if (e.el.id == this.id && (!anim || e.anim == anim)) {
          if (anim) {
            return e.status;
          }
          out.push({anim:e.anim, status:e.status});
        }
      }
      if (anim) {
        return 0;
      }
      return out;
    }
  };
  elproto.pause = function(anim) {
    for (var i = 0;i < animationElements.length;i++) {
      if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
        if (eve("raphael.anim.pause." + this.id, this, animationElements[i].anim) !== false) {
          animationElements[i].paused = true;
        }
      }
    }
    return this;
  };
  elproto.resume = function(anim) {
    for (var i = 0;i < animationElements.length;i++) {
      if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
        var e = animationElements[i];
        if (eve("raphael.anim.resume." + this.id, this, e.anim) !== false) {
          delete e.paused;
          this.status(e.anim, e.status);
        }
      }
    }
    return this;
  };
  elproto.stop = function(anim) {
    for (var i = 0;i < animationElements.length;i++) {
      if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
        if (eve("raphael.anim.stop." + this.id, this, animationElements[i].anim) !== false) {
          animationElements.splice(i--, 1);
        }
      }
    }
    return this;
  };
  function stopAnimation(paper) {
    for (var i = 0;i < animationElements.length;i++) {
      if (animationElements[i].el.paper == paper) {
        animationElements.splice(i--, 1);
      }
    }
  }
  eve.on("raphael.remove", stopAnimation);
  eve.on("raphael.clear", stopAnimation);
  elproto.toString = function() {
    return "Rapha\u00ebl\u2019s object";
  };
  var Set = function(items) {
    this.items = [];
    this.length = 0;
    this.type = "set";
    if (items) {
      for (var i = 0, ii = items.length;i < ii;i++) {
        if (items[i] && (items[i].constructor == elproto.constructor || items[i].constructor == Set)) {
          this[this.items.length] = this.items[this.items.length] = items[i];
          this.length++;
        }
      }
    }
  }, setproto = Set.prototype;
  setproto.push = function() {
    var item, len;
    for (var i = 0, ii = arguments.length;i < ii;i++) {
      item = arguments[i];
      if (item && (item.constructor == elproto.constructor || item.constructor == Set)) {
        len = this.items.length;
        this[len] = this.items[len] = item;
        this.length++;
      }
    }
    return this;
  };
  setproto.pop = function() {
    this.length && delete this[this.length--];
    return this.items.pop();
  };
  setproto.forEach = function(callback, thisArg) {
    for (var i = 0, ii = this.items.length;i < ii;i++) {
      if (callback.call(thisArg, this.items[i], i) === false) {
        return this;
      }
    }
    return this;
  };
  for (var method in elproto) {
    if (elproto[has](method)) {
      setproto[method] = function(methodname) {
        return function() {
          var arg = arguments;
          return this.forEach(function(el) {
            el[methodname][apply](el, arg);
          });
        };
      }(method);
    }
  }
  setproto.attr = function(name, value) {
    if (name && (R.is(name, array) && R.is(name[0], "object"))) {
      for (var j = 0, jj = name.length;j < jj;j++) {
        this.items[j].attr(name[j]);
      }
    } else {
      for (var i = 0, ii = this.items.length;i < ii;i++) {
        this.items[i].attr(name, value);
      }
    }
    return this;
  };
  setproto.clear = function() {
    while (this.length) {
      this.pop();
    }
  };
  setproto.splice = function(index, count, insertion) {
    index = index < 0 ? mmax(this.length + index, 0) : index;
    count = mmax(0, mmin(this.length - index, count));
    var tail = [], todel = [], args = [], i;
    for (i = 2;i < arguments.length;i++) {
      args.push(arguments[i]);
    }
    for (i = 0;i < count;i++) {
      todel.push(this[index + i]);
    }
    for (;i < this.length - index;i++) {
      tail.push(this[index + i]);
    }
    var arglen = args.length;
    for (i = 0;i < arglen + tail.length;i++) {
      this.items[index + i] = this[index + i] = i < arglen ? args[i] : tail[i - arglen];
    }
    i = this.items.length = this.length -= count - arglen;
    while (this[i]) {
      delete this[i++];
    }
    return new Set(todel);
  };
  setproto.exclude = function(el) {
    for (var i = 0, ii = this.length;i < ii;i++) {
      if (this[i] == el) {
        this.splice(i, 1);
        return true;
      }
    }
  };
  setproto.animate = function(params, ms, easing, callback) {
    (R.is(easing, "function") || !easing) && (callback = easing || null);
    var len = this.items.length, i = len, item, set = this, collector;
    if (!len) {
      return this;
    }
    callback && (collector = function() {
      !--len && callback.call(set);
    });
    easing = R.is(easing, string) ? easing : collector;
    var anim = R.animation(params, ms, easing, collector);
    item = this.items[--i].animate(anim);
    while (i--) {
      this.items[i] && (!this.items[i].removed && this.items[i].animateWith(item, anim, anim));
      this.items[i] && !this.items[i].removed || len--;
    }
    return this;
  };
  setproto.insertAfter = function(el) {
    var i = this.items.length;
    while (i--) {
      this.items[i].insertAfter(el);
    }
    return this;
  };
  setproto.getBBox = function() {
    var x = [], y = [], x2 = [], y2 = [];
    for (var i = this.items.length;i--;) {
      if (!this.items[i].removed) {
        var box = this.items[i].getBBox();
        x.push(box.x);
        y.push(box.y);
        x2.push(box.x + box.width);
        y2.push(box.y + box.height);
      }
    }
    x = mmin[apply](0, x);
    y = mmin[apply](0, y);
    x2 = mmax[apply](0, x2);
    y2 = mmax[apply](0, y2);
    return{x:x, y:y, x2:x2, y2:y2, width:x2 - x, height:y2 - y};
  };
  setproto.clone = function(s) {
    s = this.paper.set();
    for (var i = 0, ii = this.items.length;i < ii;i++) {
      s.push(this.items[i].clone());
    }
    return s;
  };
  setproto.toString = function() {
    return "Rapha\u00ebl\u2018s set";
  };
  setproto.glow = function(glowConfig) {
    var ret = this.paper.set();
    this.forEach(function(shape, index) {
      var g = shape.glow(glowConfig);
      if (g != null) {
        g.forEach(function(shape2, index2) {
          ret.push(shape2);
        });
      }
    });
    return ret;
  };
  setproto.isPointInside = function(x, y) {
    var isPointInside = false;
    this.forEach(function(el) {
      if (el.isPointInside(x, y)) {
        isPointInside = true;
        return false;
      }
    });
    return isPointInside;
  };
  R.registerFont = function(font) {
    if (!font.face) {
      return font;
    }
    this.fonts = this.fonts || {};
    var fontcopy = {w:font.w, face:{}, glyphs:{}}, family = font.face["font-family"];
    for (var prop in font.face) {
      if (font.face[has](prop)) {
        fontcopy.face[prop] = font.face[prop];
      }
    }
    if (this.fonts[family]) {
      this.fonts[family].push(fontcopy);
    } else {
      this.fonts[family] = [fontcopy];
    }
    if (!font.svg) {
      fontcopy.face["units-per-em"] = toInt(font.face["units-per-em"], 10);
      for (var glyph in font.glyphs) {
        if (font.glyphs[has](glyph)) {
          var path = font.glyphs[glyph];
          fontcopy.glyphs[glyph] = {w:path.w, k:{}, d:path.d && "M" + path.d.replace(/[mlcxtrv]/g, function(command) {
            return{l:"L", c:"C", x:"z", t:"m", r:"l", v:"c"}[command] || "M";
          }) + "z"};
          if (path.k) {
            for (var k in path.k) {
              if (path[has](k)) {
                fontcopy.glyphs[glyph].k[k] = path.k[k];
              }
            }
          }
        }
      }
    }
    return font;
  };
  paperproto.getFont = function(family, weight, style, stretch) {
    stretch = stretch || "normal";
    style = style || "normal";
    weight = +weight || ({normal:400, bold:700, lighter:300, bolder:800}[weight] || 400);
    if (!R.fonts) {
      return;
    }
    var font = R.fonts[family];
    if (!font) {
      var name = new RegExp("(^|\\s)" + family.replace(/[^\w\d\s+!~.:_-]/g, E) + "(\\s|$)", "i");
      for (var fontName in R.fonts) {
        if (R.fonts[has](fontName)) {
          if (name.test(fontName)) {
            font = R.fonts[fontName];
            break;
          }
        }
      }
    }
    var thefont;
    if (font) {
      for (var i = 0, ii = font.length;i < ii;i++) {
        thefont = font[i];
        if (thefont.face["font-weight"] == weight && ((thefont.face["font-style"] == style || !thefont.face["font-style"]) && thefont.face["font-stretch"] == stretch)) {
          break;
        }
      }
    }
    return thefont;
  };
  paperproto.print = function(x, y, string, font, size, origin, letter_spacing, line_spacing) {
    origin = origin || "middle";
    letter_spacing = mmax(mmin(letter_spacing || 0, 1), -1);
    line_spacing = mmax(mmin(line_spacing || 1, 3), 1);
    var letters = Str(string)[split](E), shift = 0, notfirst = 0, path = E, scale;
    R.is(font, "string") && (font = this.getFont(font));
    if (font) {
      scale = (size || 16) / font.face["units-per-em"];
      var bb = font.face.bbox[split](separator), top = +bb[0], lineHeight = bb[3] - bb[1], shifty = 0, height = +bb[1] + (origin == "baseline" ? lineHeight + +font.face.descent : lineHeight / 2);
      for (var i = 0, ii = letters.length;i < ii;i++) {
        if (letters[i] == "\n") {
          shift = 0;
          curr = 0;
          notfirst = 0;
          shifty += lineHeight * line_spacing;
        } else {
          var prev = notfirst && font.glyphs[letters[i - 1]] || {}, curr = font.glyphs[letters[i]];
          shift += notfirst ? (prev.w || font.w) + (prev.k && prev.k[letters[i]] || 0) + font.w * letter_spacing : 0;
          notfirst = 1;
        }
        if (curr && curr.d) {
          path += R.transformPath(curr.d, ["t", shift * scale, shifty * scale, "s", scale, scale, top, height, "t", (x - top) / scale, (y - height) / scale]);
        }
      }
    }
    return this.path(path).attr({fill:"#000", stroke:"none"});
  };
  paperproto.add = function(json) {
    if (R.is(json, "array")) {
      var res = this.set(), i = 0, ii = json.length, j;
      for (;i < ii;i++) {
        j = json[i] || {};
        elements[has](j.type) && res.push(this[j.type]().attr(j));
      }
    }
    return res;
  };
  R.format = function(token, params) {
    var args = R.is(params, array) ? [0][concat](params) : arguments;
    token && (R.is(token, string) && (args.length - 1 && (token = token.replace(formatrg, function(str, i) {
      return args[++i] == null ? E : args[i];
    }))));
    return token || E;
  };
  R.fullfill = function() {
    var tokenRegex = /\{([^\}]+)\}/g, objNotationRegex = /(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g, replacer = function(all, key, obj) {
      var res = obj;
      key.replace(objNotationRegex, function(all, name, quote, quotedName, isFunc) {
        name = name || quotedName;
        if (res) {
          if (name in res) {
            res = res[name];
          }
          typeof res == "function" && (isFunc && (res = res()));
        }
      });
      res = (res == null || res == obj ? all : res) + "";
      return res;
    };
    return function(str, obj) {
      return String(str).replace(tokenRegex, function(all, key) {
        return replacer(all, key, obj);
      });
    };
  }();
  R.ninja = function() {
    oldRaphael.was ? g.win.Raphael = oldRaphael.is : delete Raphael;
    return R;
  };
  R.st = setproto;
  (function(doc, loaded, f) {
    if (doc.readyState == null && doc.addEventListener) {
      doc.addEventListener(loaded, f = function() {
        doc.removeEventListener(loaded, f, false);
        doc.readyState = "complete";
      }, false);
      doc.readyState = "loading";
    }
    function isLoaded() {
      /in/.test(doc.readyState) ? setTimeout(isLoaded, 9) : R.eve("raphael.DOMload");
    }
    isLoaded();
  })(document, "DOMContentLoaded");
  eve.on("raphael.DOMload", function() {
    loaded = true;
  });
  (function() {
    if (!R.svg) {
      return;
    }
    var has = "hasOwnProperty", Str = String, toFloat = parseFloat, toInt = parseInt, math = Math, mmax = math.max, abs = math.abs, pow = math.pow, separator = /[, ]+/, eve = R.eve, E = "", S = " ";
    var xlink = "http://www.w3.org/1999/xlink", markers = {block:"M5,0 0,2.5 5,5z", classic:"M5,0 0,2.5 5,5 3.5,3 3.5,2z", diamond:"M2.5,0 5,2.5 2.5,5 0,2.5z", open:"M6,1 1,3.5 6,6", oval:"M2.5,0A2.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,0z"}, markerCounter = {};
    R.toString = function() {
      return "Your browser supports SVG.\nYou are running Rapha\u00ebl " + this.version;
    };
    var $ = function(el, attr) {
      if (attr) {
        if (typeof el == "string") {
          el = $(el);
        }
        for (var key in attr) {
          if (attr[has](key)) {
            if (key.substring(0, 6) == "xlink:") {
              el.setAttributeNS(xlink, key.substring(6), Str(attr[key]));
            } else {
              el.setAttribute(key, Str(attr[key]));
            }
          }
        }
      } else {
        el = R._g.doc.createElementNS("http://www.w3.org/2000/svg", el);
        el.style && (el.style.webkitTapHighlightColor = "rgba(0,0,0,0)");
      }
      return el;
    }, addGradientFill = function(element, gradient) {
      var type = "linear", id = element.id + gradient, fx = 0.5, fy = 0.5, o = element.node, SVG = element.paper, s = o.style, el = R._g.doc.getElementById(id);
      if (!el) {
        gradient = Str(gradient).replace(R._radial_gradient, function(all, _fx, _fy) {
          type = "radial";
          if (_fx && _fy) {
            fx = toFloat(_fx);
            fy = toFloat(_fy);
            var dir = (fy > 0.5) * 2 - 1;
            pow(fx - 0.5, 2) + pow(fy - 0.5, 2) > 0.25 && ((fy = math.sqrt(0.25 - pow(fx - 0.5, 2)) * dir + 0.5) && (fy != 0.5 && (fy = fy.toFixed(5) - 1E-5 * dir)));
          }
          return E;
        });
        gradient = gradient.split(/\s*\-\s*/);
        if (type == "linear") {
          var angle = gradient.shift();
          angle = -toFloat(angle);
          if (isNaN(angle)) {
            return null;
          }
          var vector = [0, 0, math.cos(R.rad(angle)), math.sin(R.rad(angle))], max = 1 / (mmax(abs(vector[2]), abs(vector[3])) || 1);
          vector[2] *= max;
          vector[3] *= max;
          if (vector[2] < 0) {
            vector[0] = -vector[2];
            vector[2] = 0;
          }
          if (vector[3] < 0) {
            vector[1] = -vector[3];
            vector[3] = 0;
          }
        }
        var dots = R._parseDots(gradient);
        if (!dots) {
          return null;
        }
        id = id.replace(/[\(\)\s,\xb0#]/g, "_");
        if (element.gradient && id != element.gradient.id) {
          SVG.defs.removeChild(element.gradient);
          delete element.gradient;
        }
        if (!element.gradient) {
          el = $(type + "Gradient", {id:id});
          element.gradient = el;
          $(el, type == "radial" ? {fx:fx, fy:fy} : {x1:vector[0], y1:vector[1], x2:vector[2], y2:vector[3], gradientTransform:element.matrix.invert()});
          SVG.defs.appendChild(el);
          for (var i = 0, ii = dots.length;i < ii;i++) {
            el.appendChild($("stop", {offset:dots[i].offset ? dots[i].offset : i ? "100%" : "0%", "stop-color":dots[i].color || "#fff"}));
          }
        }
      }
      $(o, {fill:"url(#" + id + ")", opacity:1, "fill-opacity":1});
      s.fill = E;
      s.opacity = 1;
      s.fillOpacity = 1;
      return 1;
    }, updatePosition = function(o) {
      var bbox = o.getBBox(1);
      $(o.pattern, {patternTransform:o.matrix.invert() + " translate(" + bbox.x + "," + bbox.y + ")"});
    }, addArrow = function(o, value, isEnd) {
      if (o.type == "path") {
        var values = Str(value).toLowerCase().split("-"), p = o.paper, se = isEnd ? "end" : "start", node = o.node, attrs = o.attrs, stroke = attrs["stroke-width"], i = values.length, type = "classic", from, to, dx, refX, attr, w = 3, h = 3, t = 5;
        while (i--) {
          switch(values[i]) {
            case "block":
            ;
            case "classic":
            ;
            case "oval":
            ;
            case "diamond":
            ;
            case "open":
            ;
            case "none":
              type = values[i];
              break;
            case "wide":
              h = 5;
              break;
            case "narrow":
              h = 2;
              break;
            case "long":
              w = 5;
              break;
            case "short":
              w = 2;
              break;
          }
        }
        if (type == "open") {
          w += 2;
          h += 2;
          t += 2;
          dx = 1;
          refX = isEnd ? 4 : 1;
          attr = {fill:"none", stroke:attrs.stroke};
        } else {
          refX = dx = w / 2;
          attr = {fill:attrs.stroke, stroke:"none"};
        }
        if (o._.arrows) {
          if (isEnd) {
            o._.arrows.endPath && markerCounter[o._.arrows.endPath]--;
            o._.arrows.endMarker && markerCounter[o._.arrows.endMarker]--;
          } else {
            o._.arrows.startPath && markerCounter[o._.arrows.startPath]--;
            o._.arrows.startMarker && markerCounter[o._.arrows.startMarker]--;
          }
        } else {
          o._.arrows = {};
        }
        if (type != "none") {
          var pathId = "raphael-marker-" + type, markerId = "raphael-marker-" + se + type + w + h;
          if (!R._g.doc.getElementById(pathId)) {
            p.defs.appendChild($($("path"), {"stroke-linecap":"round", d:markers[type], id:pathId}));
            markerCounter[pathId] = 1;
          } else {
            markerCounter[pathId]++;
          }
          var marker = R._g.doc.getElementById(markerId), use;
          if (!marker) {
            marker = $($("marker"), {id:markerId, markerHeight:h, markerWidth:w, orient:"auto", refX:refX, refY:h / 2});
            use = $($("use"), {"xlink:href":"#" + pathId, transform:(isEnd ? "rotate(180 " + w / 2 + " " + h / 2 + ") " : E) + "scale(" + w / t + "," + h / t + ")", "stroke-width":(1 / ((w / t + h / t) / 2)).toFixed(4)});
            marker.appendChild(use);
            p.defs.appendChild(marker);
            markerCounter[markerId] = 1;
          } else {
            markerCounter[markerId]++;
            use = marker.getElementsByTagName("use")[0];
          }
          $(use, attr);
          var delta = dx * (type != "diamond" && type != "oval");
          if (isEnd) {
            from = o._.arrows.startdx * stroke || 0;
            to = R.getTotalLength(attrs.path) - delta * stroke;
          } else {
            from = delta * stroke;
            to = R.getTotalLength(attrs.path) - (o._.arrows.enddx * stroke || 0);
          }
          attr = {};
          attr["marker-" + se] = "url(#" + markerId + ")";
          if (to || from) {
            attr.d = R.getSubpath(attrs.path, from, to);
          }
          $(node, attr);
          o._.arrows[se + "Path"] = pathId;
          o._.arrows[se + "Marker"] = markerId;
          o._.arrows[se + "dx"] = delta;
          o._.arrows[se + "Type"] = type;
          o._.arrows[se + "String"] = value;
        } else {
          if (isEnd) {
            from = o._.arrows.startdx * stroke || 0;
            to = R.getTotalLength(attrs.path) - from;
          } else {
            from = 0;
            to = R.getTotalLength(attrs.path) - (o._.arrows.enddx * stroke || 0);
          }
          o._.arrows[se + "Path"] && $(node, {d:R.getSubpath(attrs.path, from, to)});
          delete o._.arrows[se + "Path"];
          delete o._.arrows[se + "Marker"];
          delete o._.arrows[se + "dx"];
          delete o._.arrows[se + "Type"];
          delete o._.arrows[se + "String"];
        }
        for (attr in markerCounter) {
          if (markerCounter[has](attr) && !markerCounter[attr]) {
            var item = R._g.doc.getElementById(attr);
            item && item.parentNode.removeChild(item);
          }
        }
      }
    }, dasharray = {"":[0], "none":[0], "-":[3, 1], ".":[1, 1], "-.":[3, 1, 1, 1], "-..":[3, 1, 1, 1, 1, 1], ". ":[1, 3], "- ":[4, 3], "--":[8, 3], "- .":[4, 3, 1, 3], "--.":[8, 3, 1, 3], "--..":[8, 3, 1, 3, 1, 3]}, addDashes = function(o, value, params) {
      value = dasharray[Str(value).toLowerCase()];
      if (value) {
        var width = o.attrs["stroke-width"] || "1", butt = {round:width, square:width, butt:0}[o.attrs["stroke-linecap"] || params["stroke-linecap"]] || 0, dashes = [], i = value.length;
        while (i--) {
          dashes[i] = value[i] * width + (i % 2 ? 1 : -1) * butt;
        }
        $(o.node, {"stroke-dasharray":dashes.join(",")});
      }
    }, setFillAndStroke = function(o, params) {
      var node = o.node, attrs = o.attrs, vis = node.style.visibility;
      node.style.visibility = "hidden";
      for (var att in params) {
        if (params[has](att)) {
          if (!R._availableAttrs[has](att)) {
            continue;
          }
          var value = params[att];
          attrs[att] = value;
          switch(att) {
            case "blur":
              o.blur(value);
              break;
            case "title":
              var title = node.getElementsByTagName("title");
              if (title.length && (title = title[0])) {
                title.firstChild.nodeValue = value;
              } else {
                title = $("title");
                var val = R._g.doc.createTextNode(value);
                title.appendChild(val);
                node.appendChild(title);
              }
              break;
            case "href":
            ;
            case "target":
              var pn = node.parentNode;
              if (pn.tagName.toLowerCase() != "a") {
                var hl = $("a");
                pn.insertBefore(hl, node);
                hl.appendChild(node);
                pn = hl;
              }
              if (att == "target") {
                pn.setAttributeNS(xlink, "show", value == "blank" ? "new" : value);
              } else {
                pn.setAttributeNS(xlink, att, value);
              }
              break;
            case "cursor":
              node.style.cursor = value;
              break;
            case "transform":
              o.transform(value);
              break;
            case "arrow-start":
              addArrow(o, value);
              break;
            case "arrow-end":
              addArrow(o, value, 1);
              break;
            case "clip-rect":
              var rect = Str(value).split(separator);
              if (rect.length == 4) {
                o.clip && o.clip.parentNode.parentNode.removeChild(o.clip.parentNode);
                var el = $("clipPath"), rc = $("rect");
                el.id = R.createUUID();
                $(rc, {x:rect[0], y:rect[1], width:rect[2], height:rect[3]});
                el.appendChild(rc);
                o.paper.defs.appendChild(el);
                $(node, {"clip-path":"url(#" + el.id + ")"});
                o.clip = rc;
              }
              if (!value) {
                var path = node.getAttribute("clip-path");
                if (path) {
                  var clip = R._g.doc.getElementById(path.replace(/(^url\(#|\)$)/g, E));
                  clip && clip.parentNode.removeChild(clip);
                  $(node, {"clip-path":E});
                  delete o.clip;
                }
              }
              break;
            case "path":
              if (o.type == "path") {
                $(node, {d:value ? attrs.path = R._pathToAbsolute(value) : "M0,0"});
                o._.dirty = 1;
                if (o._.arrows) {
                  "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
                  "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
                }
              }
              break;
            case "width":
              node.setAttribute(att, value);
              o._.dirty = 1;
              if (attrs.fx) {
                att = "x";
                value = attrs.x;
              } else {
                break;
              }
            ;
            case "x":
              if (attrs.fx) {
                value = -attrs.x - (attrs.width || 0);
              }
            ;
            case "rx":
              if (att == "rx" && o.type == "rect") {
                break;
              }
            ;
            case "cx":
              node.setAttribute(att, value);
              o.pattern && updatePosition(o);
              o._.dirty = 1;
              break;
            case "height":
              node.setAttribute(att, value);
              o._.dirty = 1;
              if (attrs.fy) {
                att = "y";
                value = attrs.y;
              } else {
                break;
              }
            ;
            case "y":
              if (attrs.fy) {
                value = -attrs.y - (attrs.height || 0);
              }
            ;
            case "ry":
              if (att == "ry" && o.type == "rect") {
                break;
              }
            ;
            case "cy":
              node.setAttribute(att, value);
              o.pattern && updatePosition(o);
              o._.dirty = 1;
              break;
            case "r":
              if (o.type == "rect") {
                $(node, {rx:value, ry:value});
              } else {
                node.setAttribute(att, value);
              }
              o._.dirty = 1;
              break;
            case "src":
              if (o.type == "image") {
                node.setAttributeNS(xlink, "href", value);
              }
              break;
            case "stroke-width":
              if (o._.sx != 1 || o._.sy != 1) {
                value /= mmax(abs(o._.sx), abs(o._.sy)) || 1;
              }
              if (o.paper._vbSize) {
                value *= o.paper._vbSize;
              }
              node.setAttribute(att, value);
              if (attrs["stroke-dasharray"]) {
                addDashes(o, attrs["stroke-dasharray"], params);
              }
              if (o._.arrows) {
                "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
                "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
              }
              break;
            case "stroke-dasharray":
              addDashes(o, value, params);
              break;
            case "fill":
              var isURL = Str(value).match(R._ISURL);
              if (isURL) {
                el = $("pattern");
                var ig = $("image");
                el.id = R.createUUID();
                $(el, {x:0, y:0, patternUnits:"userSpaceOnUse", height:1, width:1});
                $(ig, {x:0, y:0, "xlink:href":isURL[1]});
                el.appendChild(ig);
                (function(el) {
                  R._preload(isURL[1], function() {
                    var w = this.offsetWidth, h = this.offsetHeight;
                    $(el, {width:w, height:h});
                    $(ig, {width:w, height:h});
                    o.paper.safari();
                  });
                })(el);
                o.paper.defs.appendChild(el);
                $(node, {fill:"url(#" + el.id + ")"});
                o.pattern = el;
                o.pattern && updatePosition(o);
                break;
              }
              var clr = R.getRGB(value);
              if (!clr.error) {
                delete params.gradient;
                delete attrs.gradient;
                !R.is(attrs.opacity, "undefined") && (R.is(params.opacity, "undefined") && $(node, {opacity:attrs.opacity}));
                !R.is(attrs["fill-opacity"], "undefined") && (R.is(params["fill-opacity"], "undefined") && $(node, {"fill-opacity":attrs["fill-opacity"]}));
              } else {
                if ((o.type == "circle" || (o.type == "ellipse" || Str(value).charAt() != "r")) && addGradientFill(o, value)) {
                  if ("opacity" in attrs || "fill-opacity" in attrs) {
                    var gradient = R._g.doc.getElementById(node.getAttribute("fill").replace(/^url\(#|\)$/g, E));
                    if (gradient) {
                      var stops = gradient.getElementsByTagName("stop");
                      $(stops[stops.length - 1], {"stop-opacity":("opacity" in attrs ? attrs.opacity : 1) * ("fill-opacity" in attrs ? attrs["fill-opacity"] : 1)});
                    }
                  }
                  attrs.gradient = value;
                  attrs.fill = "none";
                  break;
                }
              }
              clr[has]("opacity") && $(node, {"fill-opacity":clr.opacity > 1 ? clr.opacity / 100 : clr.opacity});
            case "stroke":
              clr = R.getRGB(value);
              node.setAttribute(att, clr.hex);
              att == "stroke" && (clr[has]("opacity") && $(node, {"stroke-opacity":clr.opacity > 1 ? clr.opacity / 100 : clr.opacity}));
              if (att == "stroke" && o._.arrows) {
                "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
                "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
              }
              break;
            case "gradient":
              (o.type == "circle" || (o.type == "ellipse" || Str(value).charAt() != "r")) && addGradientFill(o, value);
              break;
            case "opacity":
              if (attrs.gradient && !attrs[has]("stroke-opacity")) {
                $(node, {"stroke-opacity":value > 1 ? value / 100 : value});
              }
            ;
            case "fill-opacity":
              if (attrs.gradient) {
                gradient = R._g.doc.getElementById(node.getAttribute("fill").replace(/^url\(#|\)$/g, E));
                if (gradient) {
                  stops = gradient.getElementsByTagName("stop");
                  $(stops[stops.length - 1], {"stop-opacity":value});
                }
                break;
              }
            ;
            default:
              att == "font-size" && (value = toInt(value, 10) + "px");
              var cssrule = att.replace(/(\-.)/g, function(w) {
                return w.substring(1).toUpperCase();
              });
              node.style[cssrule] = value;
              o._.dirty = 1;
              node.setAttribute(att, value);
              break;
          }
        }
      }
      tuneText(o, params);
      node.style.visibility = vis;
    }, leading = 1.2, tuneText = function(el, params) {
      if (el.type != "text" || !(params[has]("text") || (params[has]("font") || (params[has]("font-size") || (params[has]("x") || params[has]("y")))))) {
        return;
      }
      var a = el.attrs, node = el.node, fontSize = node.firstChild ? toInt(R._g.doc.defaultView.getComputedStyle(node.firstChild, E).getPropertyValue("font-size"), 10) : 10;
      if (params[has]("text")) {
        a.text = params.text;
        while (node.firstChild) {
          node.removeChild(node.firstChild);
        }
        var texts = Str(params.text).split("\n"), tspans = [], tspan;
        for (var i = 0, ii = texts.length;i < ii;i++) {
          tspan = $("tspan");
          i && $(tspan, {dy:fontSize * leading, x:a.x});
          tspan.appendChild(R._g.doc.createTextNode(texts[i]));
          node.appendChild(tspan);
          tspans[i] = tspan;
        }
      } else {
        tspans = node.getElementsByTagName("tspan");
        for (i = 0, ii = tspans.length;i < ii;i++) {
          if (i) {
            $(tspans[i], {dy:fontSize * leading, x:a.x});
          } else {
            $(tspans[0], {dy:0});
          }
        }
      }
      $(node, {x:a.x, y:a.y});
      el._.dirty = 1;
      var bb = el._getBBox(), dif = a.y - (bb.y + bb.height / 2);
      dif && (R.is(dif, "finite") && $(tspans[0], {dy:dif}));
    }, Element = function(node, svg) {
      var X = 0, Y = 0;
      this[0] = this.node = node;
      node.raphael = true;
      this.id = R._oid++;
      node.raphaelid = this.id;
      this.matrix = R.matrix();
      this.realPath = null;
      this.paper = svg;
      this.attrs = this.attrs || {};
      this._ = {transform:[], sx:1, sy:1, deg:0, dx:0, dy:0, dirty:1};
      !svg.bottom && (svg.bottom = this);
      this.prev = svg.top;
      svg.top && (svg.top.next = this);
      svg.top = this;
      this.next = null;
    }, elproto = R.el;
    Element.prototype = elproto;
    elproto.constructor = Element;
    R._engine.path = function(pathString, SVG) {
      var el = $("path");
      SVG.canvas && SVG.canvas.appendChild(el);
      var p = new Element(el, SVG);
      p.type = "path";
      setFillAndStroke(p, {fill:"none", stroke:"#000", path:pathString});
      return p;
    };
    elproto.rotate = function(deg, cx, cy) {
      if (this.removed) {
        return this;
      }
      deg = Str(deg).split(separator);
      if (deg.length - 1) {
        cx = toFloat(deg[1]);
        cy = toFloat(deg[2]);
      }
      deg = toFloat(deg[0]);
      cy == null && (cx = cy);
      if (cx == null || cy == null) {
        var bbox = this.getBBox(1);
        cx = bbox.x + bbox.width / 2;
        cy = bbox.y + bbox.height / 2;
      }
      this.transform(this._.transform.concat([["r", deg, cx, cy]]));
      return this;
    };
    elproto.scale = function(sx, sy, cx, cy) {
      if (this.removed) {
        return this;
      }
      sx = Str(sx).split(separator);
      if (sx.length - 1) {
        sy = toFloat(sx[1]);
        cx = toFloat(sx[2]);
        cy = toFloat(sx[3]);
      }
      sx = toFloat(sx[0]);
      sy == null && (sy = sx);
      cy == null && (cx = cy);
      if (cx == null || cy == null) {
        var bbox = this.getBBox(1)
      }
      cx = cx == null ? bbox.x + bbox.width / 2 : cx;
      cy = cy == null ? bbox.y + bbox.height / 2 : cy;
      this.transform(this._.transform.concat([["s", sx, sy, cx, cy]]));
      return this;
    };
    elproto.translate = function(dx, dy) {
      if (this.removed) {
        return this;
      }
      dx = Str(dx).split(separator);
      if (dx.length - 1) {
        dy = toFloat(dx[1]);
      }
      dx = toFloat(dx[0]) || 0;
      dy = +dy || 0;
      this.transform(this._.transform.concat([["t", dx, dy]]));
      return this;
    };
    elproto.transform = function(tstr) {
      var _ = this._;
      if (tstr == null) {
        return _.transform;
      }
      R._extractTransform(this, tstr);
      this.clip && $(this.clip, {transform:this.matrix.invert()});
      this.pattern && updatePosition(this);
      this.node && $(this.node, {transform:this.matrix});
      if (_.sx != 1 || _.sy != 1) {
        var sw = this.attrs[has]("stroke-width") ? this.attrs["stroke-width"] : 1;
        this.attr({"stroke-width":sw});
      }
      return this;
    };
    elproto.hide = function() {
      !this.removed && this.paper.safari(this.node.style.display = "none");
      return this;
    };
    elproto.show = function() {
      !this.removed && this.paper.safari(this.node.style.display = "");
      return this;
    };
    elproto.remove = function() {
      if (this.removed || !this.node.parentNode) {
        return;
      }
      var paper = this.paper;
      paper.__set__ && paper.__set__.exclude(this);
      eve.unbind("raphael.*.*." + this.id);
      if (this.gradient) {
        paper.defs.removeChild(this.gradient);
      }
      R._tear(this, paper);
      if (this.node.parentNode.tagName.toLowerCase() == "a") {
        this.node.parentNode.parentNode.removeChild(this.node.parentNode);
      } else {
        this.node.parentNode.removeChild(this.node);
      }
      for (var i in this) {
        this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
      }
      this.removed = true;
    };
    elproto._getBBox = function() {
      if (this.node.style.display == "none") {
        this.show();
        var hide = true;
      }
      var bbox = {};
      try {
        bbox = this.node.getBBox();
      } catch (e) {
      } finally {
        bbox = bbox || {};
      }
      hide && this.hide();
      return bbox;
    };
    elproto.attr = function(name, value) {
      if (this.removed) {
        return this;
      }
      if (name == null) {
        var res = {};
        for (var a in this.attrs) {
          if (this.attrs[has](a)) {
            res[a] = this.attrs[a];
          }
        }
        res.gradient && (res.fill == "none" && ((res.fill = res.gradient) && delete res.gradient));
        res.transform = this._.transform;
        return res;
      }
      if (value == null && R.is(name, "string")) {
        if (name == "fill" && (this.attrs.fill == "none" && this.attrs.gradient)) {
          return this.attrs.gradient;
        }
        if (name == "transform") {
          return this._.transform;
        }
        var names = name.split(separator), out = {};
        for (var i = 0, ii = names.length;i < ii;i++) {
          name = names[i];
          if (name in this.attrs) {
            out[name] = this.attrs[name];
          } else {
            if (R.is(this.paper.customAttributes[name], "function")) {
              out[name] = this.paper.customAttributes[name].def;
            } else {
              out[name] = R._availableAttrs[name];
            }
          }
        }
        return ii - 1 ? out : out[names[0]];
      }
      if (value == null && R.is(name, "array")) {
        out = {};
        for (i = 0, ii = name.length;i < ii;i++) {
          out[name[i]] = this.attr(name[i]);
        }
        return out;
      }
      if (value != null) {
        var params = {};
        params[name] = value;
      } else {
        if (name != null && R.is(name, "object")) {
          params = name;
        }
      }
      for (var key in params) {
        eve("raphael.attr." + key + "." + this.id, this, params[key]);
      }
      for (key in this.paper.customAttributes) {
        if (this.paper.customAttributes[has](key) && (params[has](key) && R.is(this.paper.customAttributes[key], "function"))) {
          var par = this.paper.customAttributes[key].apply(this, [].concat(params[key]));
          this.attrs[key] = params[key];
          for (var subkey in par) {
            if (par[has](subkey)) {
              params[subkey] = par[subkey];
            }
          }
        }
      }
      setFillAndStroke(this, params);
      return this;
    };
    elproto.toFront = function() {
      if (this.removed) {
        return this;
      }
      if (this.node.parentNode.tagName.toLowerCase() == "a") {
        this.node.parentNode.parentNode.appendChild(this.node.parentNode);
      } else {
        this.node.parentNode.appendChild(this.node);
      }
      var svg = this.paper;
      svg.top != this && R._tofront(this, svg);
      return this;
    };
    elproto.toBack = function() {
      if (this.removed) {
        return this;
      }
      var parent = this.node.parentNode;
      if (parent.tagName.toLowerCase() == "a") {
        parent.parentNode.insertBefore(this.node.parentNode, this.node.parentNode.parentNode.firstChild);
      } else {
        if (parent.firstChild != this.node) {
          parent.insertBefore(this.node, this.node.parentNode.firstChild);
        }
      }
      R._toback(this, this.paper);
      var svg = this.paper;
      return this;
    };
    elproto.insertAfter = function(element) {
      if (this.removed) {
        return this;
      }
      var node = element.node || element[element.length - 1].node;
      if (node.nextSibling) {
        node.parentNode.insertBefore(this.node, node.nextSibling);
      } else {
        node.parentNode.appendChild(this.node);
      }
      R._insertafter(this, element, this.paper);
      return this;
    };
    elproto.insertBefore = function(element) {
      if (this.removed) {
        return this;
      }
      var node = element.node || element[0].node;
      node.parentNode.insertBefore(this.node, node);
      R._insertbefore(this, element, this.paper);
      return this;
    };
    elproto.blur = function(size) {
      var t = this;
      if (+size !== 0) {
        var fltr = $("filter"), blur = $("feGaussianBlur");
        t.attrs.blur = size;
        fltr.id = R.createUUID();
        $(blur, {stdDeviation:+size || 1.5});
        fltr.appendChild(blur);
        t.paper.defs.appendChild(fltr);
        t._blur = fltr;
        $(t.node, {filter:"url(#" + fltr.id + ")"});
      } else {
        if (t._blur) {
          t._blur.parentNode.removeChild(t._blur);
          delete t._blur;
          delete t.attrs.blur;
        }
        t.node.removeAttribute("filter");
      }
      return t;
    };
    R._engine.circle = function(svg, x, y, r) {
      var el = $("circle");
      svg.canvas && svg.canvas.appendChild(el);
      var res = new Element(el, svg);
      res.attrs = {cx:x, cy:y, r:r, fill:"none", stroke:"#000"};
      res.type = "circle";
      $(el, res.attrs);
      return res;
    };
    R._engine.rect = function(svg, x, y, w, h, r) {
      var el = $("rect");
      svg.canvas && svg.canvas.appendChild(el);
      var res = new Element(el, svg);
      res.attrs = {x:x, y:y, width:w, height:h, r:r || 0, rx:r || 0, ry:r || 0, fill:"none", stroke:"#000"};
      res.type = "rect";
      $(el, res.attrs);
      return res;
    };
    R._engine.ellipse = function(svg, x, y, rx, ry) {
      var el = $("ellipse");
      svg.canvas && svg.canvas.appendChild(el);
      var res = new Element(el, svg);
      res.attrs = {cx:x, cy:y, rx:rx, ry:ry, fill:"none", stroke:"#000"};
      res.type = "ellipse";
      $(el, res.attrs);
      return res;
    };
    R._engine.image = function(svg, src, x, y, w, h) {
      var el = $("image");
      $(el, {x:x, y:y, width:w, height:h, preserveAspectRatio:"none"});
      el.setAttributeNS(xlink, "href", src);
      svg.canvas && svg.canvas.appendChild(el);
      var res = new Element(el, svg);
      res.attrs = {x:x, y:y, width:w, height:h, src:src};
      res.type = "image";
      return res;
    };
    R._engine.text = function(svg, x, y, text) {
      var el = $("text");
      svg.canvas && svg.canvas.appendChild(el);
      var res = new Element(el, svg);
      res.attrs = {x:x, y:y, "text-anchor":"middle", text:text, font:R._availableAttrs.font, stroke:"none", fill:"#000"};
      res.type = "text";
      setFillAndStroke(res, res.attrs);
      return res;
    };
    R._engine.setSize = function(width, height) {
      this.width = width || this.width;
      this.height = height || this.height;
      this.canvas.setAttribute("width", this.width);
      this.canvas.setAttribute("height", this.height);
      if (this._viewBox) {
        this.setViewBox.apply(this, this._viewBox);
      }
      return this;
    };
    R._engine.create = function() {
      var con = R._getContainer.apply(0, arguments), container = con && con.container, x = con.x, y = con.y, width = con.width, height = con.height;
      if (!container) {
        throw new Error("SVG container not found.");
      }
      var cnvs = $("svg"), css = "overflow:hidden;", isFloating;
      x = x || 0;
      y = y || 0;
      width = width || 512;
      height = height || 342;
      $(cnvs, {height:height, version:1.1, width:width, xmlns:"http://www.w3.org/2000/svg"});
      if (container == 1) {
        cnvs.style.cssText = css + "position:absolute;left:" + x + "px;top:" + y + "px";
        R._g.doc.body.appendChild(cnvs);
        isFloating = 1;
      } else {
        cnvs.style.cssText = css + "position:relative";
        if (container.firstChild) {
          container.insertBefore(cnvs, container.firstChild);
        } else {
          container.appendChild(cnvs);
        }
      }
      container = new R._Paper;
      container.width = width;
      container.height = height;
      container.canvas = cnvs;
      container.clear();
      container._left = container._top = 0;
      isFloating && (container.renderfix = function() {
      });
      container.renderfix();
      return container;
    };
    R._engine.setViewBox = function(x, y, w, h, fit) {
      eve("raphael.setViewBox", this, this._viewBox, [x, y, w, h, fit]);
      var size = mmax(w / this.width, h / this.height), top = this.top, aspectRatio = fit ? "meet" : "xMinYMin", vb, sw;
      if (x == null) {
        if (this._vbSize) {
          size = 1;
        }
        delete this._vbSize;
        vb = "0 0 " + this.width + S + this.height;
      } else {
        this._vbSize = size;
        vb = x + S + y + S + w + S + h;
      }
      $(this.canvas, {viewBox:vb, preserveAspectRatio:aspectRatio});
      while (size && top) {
        sw = "stroke-width" in top.attrs ? top.attrs["stroke-width"] : 1;
        top.attr({"stroke-width":sw});
        top._.dirty = 1;
        top._.dirtyT = 1;
        top = top.prev;
      }
      this._viewBox = [x, y, w, h, !!fit];
      return this;
    };
    R.prototype.renderfix = function() {
      var cnvs = this.canvas, s = cnvs.style, pos;
      try {
        pos = cnvs.getScreenCTM() || cnvs.createSVGMatrix();
      } catch (e) {
        pos = cnvs.createSVGMatrix();
      }
      var left = -pos.e % 1, top = -pos.f % 1;
      if (left || top) {
        if (left) {
          this._left = (this._left + left) % 1;
          s.left = this._left + "px";
        }
        if (top) {
          this._top = (this._top + top) % 1;
          s.top = this._top + "px";
        }
      }
    };
    R.prototype.clear = function() {
      R.eve("raphael.clear", this);
      var c = this.canvas;
      while (c.firstChild) {
        c.removeChild(c.firstChild);
      }
      this.bottom = this.top = null;
      (this.desc = $("desc")).appendChild(R._g.doc.createTextNode("Created with Rapha\u00ebl " + R.version));
      c.appendChild(this.desc);
      c.appendChild(this.defs = $("defs"));
    };
    R.prototype.remove = function() {
      eve("raphael.remove", this);
      this.canvas.parentNode && this.canvas.parentNode.removeChild(this.canvas);
      for (var i in this) {
        this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
      }
    };
    var setproto = R.st;
    for (var method in elproto) {
      if (elproto[has](method) && !setproto[has](method)) {
        setproto[method] = function(methodname) {
          return function() {
            var arg = arguments;
            return this.forEach(function(el) {
              el[methodname].apply(el, arg);
            });
          };
        }(method);
      }
    }
  })();
  (function() {
    if (!R.vml) {
      return;
    }
    var has = "hasOwnProperty", Str = String, toFloat = parseFloat, math = Math, round = math.round, mmax = math.max, mmin = math.min, abs = math.abs, fillString = "fill", separator = /[, ]+/, eve = R.eve, ms = " progid:DXImageTransform.Microsoft", S = " ", E = "", map = {M:"m", L:"l", C:"c", Z:"x", m:"t", l:"r", c:"v", z:"x"}, bites = /([clmz]),?([^clmz]*)/gi, blurregexp = / progid:\S+Blur\([^\)]+\)/g, val = /-?[^,\s-]+/g, cssDot = "position:absolute;left:0;top:0;width:1px;height:1px", zoom = 21600, 
    pathTypes = {path:1, rect:1, image:1}, ovalTypes = {circle:1, ellipse:1}, path2vml = function(path) {
      var total = /[ahqstv]/ig, command = R._pathToAbsolute;
      Str(path).match(total) && (command = R._path2curve);
      total = /[clmz]/g;
      if (command == R._pathToAbsolute && !Str(path).match(total)) {
        var res = Str(path).replace(bites, function(all, command, args) {
          var vals = [], isMove = command.toLowerCase() == "m", res = map[command];
          args.replace(val, function(value) {
            if (isMove && vals.length == 2) {
              res += vals + map[command == "m" ? "l" : "L"];
              vals = [];
            }
            vals.push(round(value * zoom));
          });
          return res + vals;
        });
        return res;
      }
      var pa = command(path), p, r;
      res = [];
      for (var i = 0, ii = pa.length;i < ii;i++) {
        p = pa[i];
        r = pa[i][0].toLowerCase();
        r == "z" && (r = "x");
        for (var j = 1, jj = p.length;j < jj;j++) {
          r += round(p[j] * zoom) + (j != jj - 1 ? "," : E);
        }
        res.push(r);
      }
      return res.join(S);
    }, compensation = function(deg, dx, dy) {
      var m = R.matrix();
      m.rotate(-deg, 0.5, 0.5);
      return{dx:m.x(dx, dy), dy:m.y(dx, dy)};
    }, setCoords = function(p, sx, sy, dx, dy, deg) {
      var _ = p._, m = p.matrix, fillpos = _.fillpos, o = p.node, s = o.style, y = 1, flip = "", dxdy, kx = zoom / sx, ky = zoom / sy;
      s.visibility = "hidden";
      if (!sx || !sy) {
        return;
      }
      o.coordsize = abs(kx) + S + abs(ky);
      s.rotation = deg * (sx * sy < 0 ? -1 : 1);
      if (deg) {
        var c = compensation(deg, dx, dy);
        dx = c.dx;
        dy = c.dy;
      }
      sx < 0 && (flip += "x");
      sy < 0 && ((flip += " y") && (y = -1));
      s.flip = flip;
      o.coordorigin = dx * -kx + S + dy * -ky;
      if (fillpos || _.fillsize) {
        var fill = o.getElementsByTagName(fillString);
        fill = fill && fill[0];
        o.removeChild(fill);
        if (fillpos) {
          c = compensation(deg, m.x(fillpos[0], fillpos[1]), m.y(fillpos[0], fillpos[1]));
          fill.position = c.dx * y + S + c.dy * y;
        }
        if (_.fillsize) {
          fill.size = _.fillsize[0] * abs(sx) + S + _.fillsize[1] * abs(sy);
        }
        o.appendChild(fill);
      }
      s.visibility = "visible";
    };
    R.toString = function() {
      return "Your browser doesn\u2019t support SVG. Falling down to VML.\nYou are running Rapha\u00ebl " + this.version;
    };
    var addArrow = function(o, value, isEnd) {
      var values = Str(value).toLowerCase().split("-"), se = isEnd ? "end" : "start", i = values.length, type = "classic", w = "medium", h = "medium";
      while (i--) {
        switch(values[i]) {
          case "block":
          ;
          case "classic":
          ;
          case "oval":
          ;
          case "diamond":
          ;
          case "open":
          ;
          case "none":
            type = values[i];
            break;
          case "wide":
          ;
          case "narrow":
            h = values[i];
            break;
          case "long":
          ;
          case "short":
            w = values[i];
            break;
        }
      }
      var stroke = o.node.getElementsByTagName("stroke")[0];
      stroke[se + "arrow"] = type;
      stroke[se + "arrowlength"] = w;
      stroke[se + "arrowwidth"] = h;
    }, setFillAndStroke = function(o, params) {
      o.attrs = o.attrs || {};
      var node = o.node, a = o.attrs, s = node.style, xy, newpath = pathTypes[o.type] && (params.x != a.x || (params.y != a.y || (params.width != a.width || (params.height != a.height || (params.cx != a.cx || (params.cy != a.cy || (params.rx != a.rx || (params.ry != a.ry || params.r != a.r)))))))), isOval = ovalTypes[o.type] && (a.cx != params.cx || (a.cy != params.cy || (a.r != params.r || (a.rx != params.rx || a.ry != params.ry)))), res = o;
      for (var par in params) {
        if (params[has](par)) {
          a[par] = params[par];
        }
      }
      if (newpath) {
        a.path = R._getPath[o.type](o);
        o._.dirty = 1;
      }
      params.href && (node.href = params.href);
      params.title && (node.title = params.title);
      params.target && (node.target = params.target);
      params.cursor && (s.cursor = params.cursor);
      "blur" in params && o.blur(params.blur);
      if (params.path && o.type == "path" || newpath) {
        node.path = path2vml(~Str(a.path).toLowerCase().indexOf("r") ? R._pathToAbsolute(a.path) : a.path);
        if (o.type == "image") {
          o._.fillpos = [a.x, a.y];
          o._.fillsize = [a.width, a.height];
          setCoords(o, 1, 1, 0, 0, 0);
        }
      }
      "transform" in params && o.transform(params.transform);
      if (isOval) {
        var cx = +a.cx, cy = +a.cy, rx = +a.rx || (+a.r || 0), ry = +a.ry || (+a.r || 0);
        node.path = R.format("ar{0},{1},{2},{3},{4},{1},{4},{1}x", round((cx - rx) * zoom), round((cy - ry) * zoom), round((cx + rx) * zoom), round((cy + ry) * zoom), round(cx * zoom));
        o._.dirty = 1;
      }
      if ("clip-rect" in params) {
        var rect = Str(params["clip-rect"]).split(separator);
        if (rect.length == 4) {
          rect[2] = +rect[2] + +rect[0];
          rect[3] = +rect[3] + +rect[1];
          var div = node.clipRect || R._g.doc.createElement("div"), dstyle = div.style;
          dstyle.clip = R.format("rect({1}px {2}px {3}px {0}px)", rect);
          if (!node.clipRect) {
            dstyle.position = "absolute";
            dstyle.top = 0;
            dstyle.left = 0;
            dstyle.width = o.paper.width + "px";
            dstyle.height = o.paper.height + "px";
            node.parentNode.insertBefore(div, node);
            div.appendChild(node);
            node.clipRect = div;
          }
        }
        if (!params["clip-rect"]) {
          node.clipRect && (node.clipRect.style.clip = "auto");
        }
      }
      if (o.textpath) {
        var textpathStyle = o.textpath.style;
        params.font && (textpathStyle.font = params.font);
        params["font-family"] && (textpathStyle.fontFamily = '"' + params["font-family"].split(",")[0].replace(/^['"]+|['"]+$/g, E) + '"');
        params["font-size"] && (textpathStyle.fontSize = params["font-size"]);
        params["font-weight"] && (textpathStyle.fontWeight = params["font-weight"]);
        params["font-style"] && (textpathStyle.fontStyle = params["font-style"]);
      }
      if ("arrow-start" in params) {
        addArrow(res, params["arrow-start"]);
      }
      if ("arrow-end" in params) {
        addArrow(res, params["arrow-end"], 1);
      }
      if (params.opacity != null || (params["stroke-width"] != null || (params.fill != null || (params.src != null || (params.stroke != null || (params["stroke-width"] != null || (params["stroke-opacity"] != null || (params["fill-opacity"] != null || (params["stroke-dasharray"] != null || (params["stroke-miterlimit"] != null || (params["stroke-linejoin"] != null || params["stroke-linecap"] != null))))))))))) {
        var fill = node.getElementsByTagName(fillString), newfill = false;
        fill = fill && fill[0];
        !fill && (newfill = fill = createNode(fillString));
        if (o.type == "image" && params.src) {
          fill.src = params.src;
        }
        params.fill && (fill.on = true);
        if (fill.on == null || (params.fill == "none" || params.fill === null)) {
          fill.on = false;
        }
        if (fill.on && params.fill) {
          var isURL = Str(params.fill).match(R._ISURL);
          if (isURL) {
            fill.parentNode == node && node.removeChild(fill);
            fill.rotate = true;
            fill.src = isURL[1];
            fill.type = "tile";
            var bbox = o.getBBox(1);
            fill.position = bbox.x + S + bbox.y;
            o._.fillpos = [bbox.x, bbox.y];
            R._preload(isURL[1], function() {
              o._.fillsize = [this.offsetWidth, this.offsetHeight];
            });
          } else {
            fill.color = R.getRGB(params.fill).hex;
            fill.src = E;
            fill.type = "solid";
            if (R.getRGB(params.fill).error && ((res.type in {circle:1, ellipse:1} || Str(params.fill).charAt() != "r") && addGradientFill(res, params.fill, fill))) {
              a.fill = "none";
              a.gradient = params.fill;
              fill.rotate = false;
            }
          }
        }
        if ("fill-opacity" in params || "opacity" in params) {
          var opacity = ((+a["fill-opacity"] + 1 || 2) - 1) * ((+a.opacity + 1 || 2) - 1) * ((+R.getRGB(params.fill).o + 1 || 2) - 1);
          opacity = mmin(mmax(opacity, 0), 1);
          fill.opacity = opacity;
          if (fill.src) {
            fill.color = "none";
          }
        }
        node.appendChild(fill);
        var stroke = node.getElementsByTagName("stroke") && node.getElementsByTagName("stroke")[0], newstroke = false;
        !stroke && (newstroke = stroke = createNode("stroke"));
        if (params.stroke && params.stroke != "none" || (params["stroke-width"] || (params["stroke-opacity"] != null || (params["stroke-dasharray"] || (params["stroke-miterlimit"] || (params["stroke-linejoin"] || params["stroke-linecap"])))))) {
          stroke.on = true;
        }
        (params.stroke == "none" || (params.stroke === null || (stroke.on == null || (params.stroke == 0 || params["stroke-width"] == 0)))) && (stroke.on = false);
        var strokeColor = R.getRGB(params.stroke);
        stroke.on && (params.stroke && (stroke.color = strokeColor.hex));
        opacity = ((+a["stroke-opacity"] + 1 || 2) - 1) * ((+a.opacity + 1 || 2) - 1) * ((+strokeColor.o + 1 || 2) - 1);
        var width = (toFloat(params["stroke-width"]) || 1) * 0.75;
        opacity = mmin(mmax(opacity, 0), 1);
        params["stroke-width"] == null && (width = a["stroke-width"]);
        params["stroke-width"] && (stroke.weight = width);
        width && (width < 1 && ((opacity *= width) && (stroke.weight = 1)));
        stroke.opacity = opacity;
        params["stroke-linejoin"] && (stroke.joinstyle = params["stroke-linejoin"] || "miter");
        stroke.miterlimit = params["stroke-miterlimit"] || 8;
        params["stroke-linecap"] && (stroke.endcap = params["stroke-linecap"] == "butt" ? "flat" : params["stroke-linecap"] == "square" ? "square" : "round");
        if ("stroke-dasharray" in params) {
          var dasharray = {"-":"shortdash", ".":"shortdot", "-.":"shortdashdot", "-..":"shortdashdotdot", ". ":"dot", "- ":"dash", "--":"longdash", "- .":"dashdot", "--.":"longdashdot", "--..":"longdashdotdot"};
          stroke.dashstyle = dasharray[has](params["stroke-dasharray"]) ? dasharray[params["stroke-dasharray"]] : E;
        }
        newstroke && node.appendChild(stroke);
      }
      if (res.type == "text") {
        res.paper.canvas.style.display = E;
        var span = res.paper.span, m = 100, fontSize = a.font && a.font.match(/\d+(?:\.\d*)?(?=px)/);
        s = span.style;
        a.font && (s.font = a.font);
        a["font-family"] && (s.fontFamily = a["font-family"]);
        a["font-weight"] && (s.fontWeight = a["font-weight"]);
        a["font-style"] && (s.fontStyle = a["font-style"]);
        fontSize = toFloat(a["font-size"] || fontSize && fontSize[0]) || 10;
        s.fontSize = fontSize * m + "px";
        res.textpath.string && (span.innerHTML = Str(res.textpath.string).replace(/</g, "&#60;").replace(/&/g, "&#38;").replace(/\n/g, "<br>"));
        var brect = span.getBoundingClientRect();
        res.W = a.w = (brect.right - brect.left) / m;
        res.H = a.h = (brect.bottom - brect.top) / m;
        res.X = a.x;
        res.Y = a.y + res.H / 2;
        ("x" in params || "y" in params) && (res.path.v = R.format("m{0},{1}l{2},{1}", round(a.x * zoom), round(a.y * zoom), round(a.x * zoom) + 1));
        var dirtyattrs = ["x", "y", "text", "font", "font-family", "font-weight", "font-style", "font-size"];
        for (var d = 0, dd = dirtyattrs.length;d < dd;d++) {
          if (dirtyattrs[d] in params) {
            res._.dirty = 1;
            break;
          }
        }
        switch(a["text-anchor"]) {
          case "start":
            res.textpath.style["v-text-align"] = "left";
            res.bbx = res.W / 2;
            break;
          case "end":
            res.textpath.style["v-text-align"] = "right";
            res.bbx = -res.W / 2;
            break;
          default:
            res.textpath.style["v-text-align"] = "center";
            res.bbx = 0;
            break;
        }
        res.textpath.style["v-text-kern"] = true;
      }
    }, addGradientFill = function(o, gradient, fill) {
      o.attrs = o.attrs || {};
      var attrs = o.attrs, pow = Math.pow, opacity, oindex, type = "linear", fxfy = ".5 .5";
      o.attrs.gradient = gradient;
      gradient = Str(gradient).replace(R._radial_gradient, function(all, fx, fy) {
        type = "radial";
        if (fx && fy) {
          fx = toFloat(fx);
          fy = toFloat(fy);
          pow(fx - 0.5, 2) + pow(fy - 0.5, 2) > 0.25 && (fy = math.sqrt(0.25 - pow(fx - 0.5, 2)) * ((fy > 0.5) * 2 - 1) + 0.5);
          fxfy = fx + S + fy;
        }
        return E;
      });
      gradient = gradient.split(/\s*\-\s*/);
      if (type == "linear") {
        var angle = gradient.shift();
        angle = -toFloat(angle);
        if (isNaN(angle)) {
          return null;
        }
      }
      var dots = R._parseDots(gradient);
      if (!dots) {
        return null;
      }
      o = o.shape || o.node;
      if (dots.length) {
        o.removeChild(fill);
        fill.on = true;
        fill.method = "none";
        fill.color = dots[0].color;
        fill.color2 = dots[dots.length - 1].color;
        var clrs = [];
        for (var i = 0, ii = dots.length;i < ii;i++) {
          dots[i].offset && clrs.push(dots[i].offset + S + dots[i].color);
        }
        fill.colors = clrs.length ? clrs.join() : "0% " + fill.color;
        if (type == "radial") {
          fill.type = "gradientTitle";
          fill.focus = "100%";
          fill.focussize = "0 0";
          fill.focusposition = fxfy;
          fill.angle = 0;
        } else {
          fill.type = "gradient";
          fill.angle = (270 - angle) % 360;
        }
        o.appendChild(fill);
      }
      return 1;
    }, Element = function(node, vml) {
      this[0] = this.node = node;
      node.raphael = true;
      this.id = R._oid++;
      node.raphaelid = this.id;
      this.X = 0;
      this.Y = 0;
      this.attrs = {};
      this.paper = vml;
      this.matrix = R.matrix();
      this._ = {transform:[], sx:1, sy:1, dx:0, dy:0, deg:0, dirty:1, dirtyT:1};
      !vml.bottom && (vml.bottom = this);
      this.prev = vml.top;
      vml.top && (vml.top.next = this);
      vml.top = this;
      this.next = null;
    };
    var elproto = R.el;
    Element.prototype = elproto;
    elproto.constructor = Element;
    elproto.transform = function(tstr) {
      if (tstr == null) {
        return this._.transform;
      }
      var vbs = this.paper._viewBoxShift, vbt = vbs ? "s" + [vbs.scale, vbs.scale] + "-1-1t" + [vbs.dx, vbs.dy] : E, oldt;
      if (vbs) {
        oldt = tstr = Str(tstr).replace(/\.{3}|\u2026/g, this._.transform || E);
      }
      R._extractTransform(this, vbt + tstr);
      var matrix = this.matrix.clone(), skew = this.skew, o = this.node, split, isGrad = ~Str(this.attrs.fill).indexOf("-"), isPatt = !Str(this.attrs.fill).indexOf("url(");
      matrix.translate(1, 1);
      if (isPatt || (isGrad || this.type == "image")) {
        skew.matrix = "1 0 0 1";
        skew.offset = "0 0";
        split = matrix.split();
        if (isGrad && split.noRotation || !split.isSimple) {
          o.style.filter = matrix.toFilter();
          var bb = this.getBBox(), bbt = this.getBBox(1), dx = bb.x - bbt.x, dy = bb.y - bbt.y;
          o.coordorigin = dx * -zoom + S + dy * -zoom;
          setCoords(this, 1, 1, dx, dy, 0);
        } else {
          o.style.filter = E;
          setCoords(this, split.scalex, split.scaley, split.dx, split.dy, split.rotate);
        }
      } else {
        o.style.filter = E;
        skew.matrix = Str(matrix);
        skew.offset = matrix.offset();
      }
      oldt && (this._.transform = oldt);
      return this;
    };
    elproto.rotate = function(deg, cx, cy) {
      if (this.removed) {
        return this;
      }
      if (deg == null) {
        return;
      }
      deg = Str(deg).split(separator);
      if (deg.length - 1) {
        cx = toFloat(deg[1]);
        cy = toFloat(deg[2]);
      }
      deg = toFloat(deg[0]);
      cy == null && (cx = cy);
      if (cx == null || cy == null) {
        var bbox = this.getBBox(1);
        cx = bbox.x + bbox.width / 2;
        cy = bbox.y + bbox.height / 2;
      }
      this._.dirtyT = 1;
      this.transform(this._.transform.concat([["r", deg, cx, cy]]));
      return this;
    };
    elproto.translate = function(dx, dy) {
      if (this.removed) {
        return this;
      }
      dx = Str(dx).split(separator);
      if (dx.length - 1) {
        dy = toFloat(dx[1]);
      }
      dx = toFloat(dx[0]) || 0;
      dy = +dy || 0;
      if (this._.bbox) {
        this._.bbox.x += dx;
        this._.bbox.y += dy;
      }
      this.transform(this._.transform.concat([["t", dx, dy]]));
      return this;
    };
    elproto.scale = function(sx, sy, cx, cy) {
      if (this.removed) {
        return this;
      }
      sx = Str(sx).split(separator);
      if (sx.length - 1) {
        sy = toFloat(sx[1]);
        cx = toFloat(sx[2]);
        cy = toFloat(sx[3]);
        isNaN(cx) && (cx = null);
        isNaN(cy) && (cy = null);
      }
      sx = toFloat(sx[0]);
      sy == null && (sy = sx);
      cy == null && (cx = cy);
      if (cx == null || cy == null) {
        var bbox = this.getBBox(1)
      }
      cx = cx == null ? bbox.x + bbox.width / 2 : cx;
      cy = cy == null ? bbox.y + bbox.height / 2 : cy;
      this.transform(this._.transform.concat([["s", sx, sy, cx, cy]]));
      this._.dirtyT = 1;
      return this;
    };
    elproto.hide = function() {
      !this.removed && (this.node.style.display = "none");
      return this;
    };
    elproto.show = function() {
      !this.removed && (this.node.style.display = E);
      return this;
    };
    elproto._getBBox = function() {
      if (this.removed) {
        return{};
      }
      return{x:this.X + (this.bbx || 0) - this.W / 2, y:this.Y - this.H, width:this.W, height:this.H};
    };
    elproto.remove = function() {
      if (this.removed || !this.node.parentNode) {
        return;
      }
      this.paper.__set__ && this.paper.__set__.exclude(this);
      R.eve.unbind("raphael.*.*." + this.id);
      R._tear(this, this.paper);
      this.node.parentNode.removeChild(this.node);
      this.shape && this.shape.parentNode.removeChild(this.shape);
      for (var i in this) {
        this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
      }
      this.removed = true;
    };
    elproto.attr = function(name, value) {
      if (this.removed) {
        return this;
      }
      if (name == null) {
        var res = {};
        for (var a in this.attrs) {
          if (this.attrs[has](a)) {
            res[a] = this.attrs[a];
          }
        }
        res.gradient && (res.fill == "none" && ((res.fill = res.gradient) && delete res.gradient));
        res.transform = this._.transform;
        return res;
      }
      if (value == null && R.is(name, "string")) {
        if (name == fillString && (this.attrs.fill == "none" && this.attrs.gradient)) {
          return this.attrs.gradient;
        }
        var names = name.split(separator), out = {};
        for (var i = 0, ii = names.length;i < ii;i++) {
          name = names[i];
          if (name in this.attrs) {
            out[name] = this.attrs[name];
          } else {
            if (R.is(this.paper.customAttributes[name], "function")) {
              out[name] = this.paper.customAttributes[name].def;
            } else {
              out[name] = R._availableAttrs[name];
            }
          }
        }
        return ii - 1 ? out : out[names[0]];
      }
      if (this.attrs && (value == null && R.is(name, "array"))) {
        out = {};
        for (i = 0, ii = name.length;i < ii;i++) {
          out[name[i]] = this.attr(name[i]);
        }
        return out;
      }
      var params;
      if (value != null) {
        params = {};
        params[name] = value;
      }
      value == null && (R.is(name, "object") && (params = name));
      for (var key in params) {
        eve("raphael.attr." + key + "." + this.id, this, params[key]);
      }
      if (params) {
        for (key in this.paper.customAttributes) {
          if (this.paper.customAttributes[has](key) && (params[has](key) && R.is(this.paper.customAttributes[key], "function"))) {
            var par = this.paper.customAttributes[key].apply(this, [].concat(params[key]));
            this.attrs[key] = params[key];
            for (var subkey in par) {
              if (par[has](subkey)) {
                params[subkey] = par[subkey];
              }
            }
          }
        }
        if (params.text && this.type == "text") {
          this.textpath.string = params.text;
        }
        setFillAndStroke(this, params);
      }
      return this;
    };
    elproto.toFront = function() {
      !this.removed && this.node.parentNode.appendChild(this.node);
      this.paper && (this.paper.top != this && R._tofront(this, this.paper));
      return this;
    };
    elproto.toBack = function() {
      if (this.removed) {
        return this;
      }
      if (this.node.parentNode.firstChild != this.node) {
        this.node.parentNode.insertBefore(this.node, this.node.parentNode.firstChild);
        R._toback(this, this.paper);
      }
      return this;
    };
    elproto.insertAfter = function(element) {
      if (this.removed) {
        return this;
      }
      if (element.constructor == R.st.constructor) {
        element = element[element.length - 1];
      }
      if (element.node.nextSibling) {
        element.node.parentNode.insertBefore(this.node, element.node.nextSibling);
      } else {
        element.node.parentNode.appendChild(this.node);
      }
      R._insertafter(this, element, this.paper);
      return this;
    };
    elproto.insertBefore = function(element) {
      if (this.removed) {
        return this;
      }
      if (element.constructor == R.st.constructor) {
        element = element[0];
      }
      element.node.parentNode.insertBefore(this.node, element.node);
      R._insertbefore(this, element, this.paper);
      return this;
    };
    elproto.blur = function(size) {
      var s = this.node.runtimeStyle, f = s.filter;
      f = f.replace(blurregexp, E);
      if (+size !== 0) {
        this.attrs.blur = size;
        s.filter = f + S + ms + ".Blur(pixelradius=" + (+size || 1.5) + ")";
        s.margin = R.format("-{0}px 0 0 -{0}px", round(+size || 1.5));
      } else {
        s.filter = f;
        s.margin = 0;
        delete this.attrs.blur;
      }
      return this;
    };
    R._engine.path = function(pathString, vml) {
      var el = createNode("shape");
      el.style.cssText = cssDot;
      el.coordsize = zoom + S + zoom;
      el.coordorigin = vml.coordorigin;
      var p = new Element(el, vml), attr = {fill:"none", stroke:"#000"};
      pathString && (attr.path = pathString);
      p.type = "path";
      p.path = [];
      p.Path = E;
      setFillAndStroke(p, attr);
      vml.canvas.appendChild(el);
      var skew = createNode("skew");
      skew.on = true;
      el.appendChild(skew);
      p.skew = skew;
      p.transform(E);
      return p;
    };
    R._engine.rect = function(vml, x, y, w, h, r) {
      var path = R._rectPath(x, y, w, h, r), res = vml.path(path), a = res.attrs;
      res.X = a.x = x;
      res.Y = a.y = y;
      res.W = a.width = w;
      res.H = a.height = h;
      a.r = r;
      a.path = path;
      res.type = "rect";
      return res;
    };
    R._engine.ellipse = function(vml, x, y, rx, ry) {
      var res = vml.path(), a = res.attrs;
      res.X = x - rx;
      res.Y = y - ry;
      res.W = rx * 2;
      res.H = ry * 2;
      res.type = "ellipse";
      setFillAndStroke(res, {cx:x, cy:y, rx:rx, ry:ry});
      return res;
    };
    R._engine.circle = function(vml, x, y, r) {
      var res = vml.path(), a = res.attrs;
      res.X = x - r;
      res.Y = y - r;
      res.W = res.H = r * 2;
      res.type = "circle";
      setFillAndStroke(res, {cx:x, cy:y, r:r});
      return res;
    };
    R._engine.image = function(vml, src, x, y, w, h) {
      var path = R._rectPath(x, y, w, h), res = vml.path(path).attr({stroke:"none"}), a = res.attrs, node = res.node, fill = node.getElementsByTagName(fillString)[0];
      a.src = src;
      res.X = a.x = x;
      res.Y = a.y = y;
      res.W = a.width = w;
      res.H = a.height = h;
      a.path = path;
      res.type = "image";
      fill.parentNode == node && node.removeChild(fill);
      fill.rotate = true;
      fill.src = src;
      fill.type = "tile";
      res._.fillpos = [x, y];
      res._.fillsize = [w, h];
      node.appendChild(fill);
      setCoords(res, 1, 1, 0, 0, 0);
      return res;
    };
    R._engine.text = function(vml, x, y, text) {
      var el = createNode("shape"), path = createNode("path"), o = createNode("textpath");
      x = x || 0;
      y = y || 0;
      text = text || "";
      path.v = R.format("m{0},{1}l{2},{1}", round(x * zoom), round(y * zoom), round(x * zoom) + 1);
      path.textpathok = true;
      o.string = Str(text);
      o.on = true;
      el.style.cssText = cssDot;
      el.coordsize = zoom + S + zoom;
      el.coordorigin = "0 0";
      var p = new Element(el, vml), attr = {fill:"#000", stroke:"none", font:R._availableAttrs.font, text:text};
      p.shape = el;
      p.path = path;
      p.textpath = o;
      p.type = "text";
      p.attrs.text = Str(text);
      p.attrs.x = x;
      p.attrs.y = y;
      p.attrs.w = 1;
      p.attrs.h = 1;
      setFillAndStroke(p, attr);
      el.appendChild(o);
      el.appendChild(path);
      vml.canvas.appendChild(el);
      var skew = createNode("skew");
      skew.on = true;
      el.appendChild(skew);
      p.skew = skew;
      p.transform(E);
      return p;
    };
    R._engine.setSize = function(width, height) {
      var cs = this.canvas.style;
      this.width = width;
      this.height = height;
      width == +width && (width += "px");
      height == +height && (height += "px");
      cs.width = width;
      cs.height = height;
      cs.clip = "rect(0 " + width + " " + height + " 0)";
      if (this._viewBox) {
        R._engine.setViewBox.apply(this, this._viewBox);
      }
      return this;
    };
    R._engine.setViewBox = function(x, y, w, h, fit) {
      R.eve("raphael.setViewBox", this, this._viewBox, [x, y, w, h, fit]);
      var width = this.width, height = this.height, size = 1 / mmax(w / width, h / height), H, W;
      if (fit) {
        H = height / h;
        W = width / w;
        if (w * H < width) {
          x -= (width - w * H) / 2 / H;
        }
        if (h * W < height) {
          y -= (height - h * W) / 2 / W;
        }
      }
      this._viewBox = [x, y, w, h, !!fit];
      this._viewBoxShift = {dx:-x, dy:-y, scale:size};
      this.forEach(function(el) {
        el.transform("...");
      });
      return this;
    };
    var createNode;
    R._engine.initWin = function(win) {
      var doc = win.document;
      doc.createStyleSheet().addRule(".rvml", "behavior:url(#default#VML)");
      try {
        !doc.namespaces.rvml && doc.namespaces.add("rvml", "urn:schemas-microsoft-com:vml");
        createNode = function(tagName) {
          return doc.createElement("<rvml:" + tagName + ' class="rvml">');
        };
      } catch (e) {
        createNode = function(tagName) {
          return doc.createElement("<" + tagName + ' xmlns="urn:schemas-microsoft.com:vml" class="rvml">');
        };
      }
    };
    R._engine.initWin(R._g.win);
    R._engine.create = function() {
      var con = R._getContainer.apply(0, arguments), container = con.container, height = con.height, s, width = con.width, x = con.x, y = con.y;
      if (!container) {
        throw new Error("VML container not found.");
      }
      var res = new R._Paper, c = res.canvas = R._g.doc.createElement("div"), cs = c.style;
      x = x || 0;
      y = y || 0;
      width = width || 512;
      height = height || 342;
      res.width = width;
      res.height = height;
      width == +width && (width += "px");
      height == +height && (height += "px");
      res.coordsize = zoom * 1E3 + S + zoom * 1E3;
      res.coordorigin = "0 0";
      res.span = R._g.doc.createElement("span");
      res.span.style.cssText = "position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;";
      c.appendChild(res.span);
      cs.cssText = R.format("top:0;left:0;width:{0};height:{1};display:inline-block;position:relative;clip:rect(0 {0} {1} 0);overflow:hidden", width, height);
      if (container == 1) {
        R._g.doc.body.appendChild(c);
        cs.left = x + "px";
        cs.top = y + "px";
        cs.position = "absolute";
      } else {
        if (container.firstChild) {
          container.insertBefore(c, container.firstChild);
        } else {
          container.appendChild(c);
        }
      }
      res.renderfix = function() {
      };
      return res;
    };
    R.prototype.clear = function() {
      R.eve("raphael.clear", this);
      this.canvas.innerHTML = E;
      this.span = R._g.doc.createElement("span");
      this.span.style.cssText = "position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;";
      this.canvas.appendChild(this.span);
      this.bottom = this.top = null;
    };
    R.prototype.remove = function() {
      R.eve("raphael.remove", this);
      this.canvas.parentNode.removeChild(this.canvas);
      for (var i in this) {
        this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
      }
      return true;
    };
    var setproto = R.st;
    for (var method in elproto) {
      if (elproto[has](method) && !setproto[has](method)) {
        setproto[method] = function(methodname) {
          return function() {
            var arg = arguments;
            return this.forEach(function(el) {
              el[methodname].apply(el, arg);
            });
          };
        }(method);
      }
    }
  })();
  oldRaphael.was ? g.win.Raphael = R : Raphael = R;
  return R;
});
var QBWebCanvasLink = function(param) {
  this.color = null;
  this.thin = null;
  this.bg = null;
  this.line = null;
  this.startType = null;
  this.start = null;
  this.endType = null;
  this.end = null;
  this.object = null;
  this.graphics = null;
  this._init = function(param) {
  };
  this._init(param);
};
function getBBox(obj) {
  var box = {x:0, y:0, width:0, height:0};
  if (!obj.length) {
    return box;
  }
  var o = obj[0];
  function getBoxToParent(element, parentId) {
    box = {x:0, y:0, width:element.clientWidth, height:element.clientHeight};
    while (element) {
      if (element.id == parentId) {
        break;
      }
      box.x += element.offsetLeft - element.scrollLeft + element.clientLeft;
      box.y += element.offsetTop - element.scrollTop + element.clientTop;
      element = element.offsetParent;
    }
    return box;
  }
  if (o.tagName == "TR") {
    box = getBoxToParent(o, "qb-ui-canvas");
  } else {
    if (o.tagName == "TABLE") {
      box = getBoxToParent(o, "qb-ui-canvas");
    } else {
      if (o.tagName == "DIV") {
        box = getBoxToParent(o, "qb-ui-canvas");
      }
    }
  }
  return box;
}
function round1000(x) {
  return Math.round(x * 1E3) / 1E3;
}
function getLineCoord(bb1, bb2) {
  var minLeg = 20;
  var p1 = [{x:bb1.x, y:bb1.y + bb1.height / 2}, {x:bb1.x + bb1.width, y:bb1.y + bb1.height / 2}];
  var p2 = [{x:bb2.x, y:bb2.y + bb2.height / 2}, {x:bb2.x + bb2.width, y:bb2.y + bb2.height / 2}];
  var d = [], dis = [];
  for (var i1 = 0;i1 < p1.length;i1++) {
    for (var i2 = 0;i2 < p2.length;i2++) {
      var dx = Math.abs(p1[i1].x - p2[i2].x);
      var dy = Math.abs(p1[i1].y - p2[i2].y);
      var len = dx * dx + dy * dy;
      dis.push(len);
      d.push({i1:i1, i2:i2});
    }
  }
  var res = {i1:0, i2:0};
  var idx = -1;
  var min = -1;
  for (var i = 0;i < dis.length;i++) {
    if (min == -1 || dis[i] < min) {
      min = dis[i];
      idx = i;
    }
  }
  if (idx > 0) {
    res = d[idx];
  }
  var x1 = p1[res.i1].x, y1 = p1[res.i1].y, x4 = p2[res.i2].x, y4 = p2[res.i2].y, y2 = y1, y3 = y4;
  var dx = Math.max(Math.abs(x1 - x4) / 2, minLeg);
  var x2 = [x1 - dx, x1 + dx][res.i1];
  var x3 = [x4 - dx, x4 + dx][res.i2];
  return{x1:round1000(x1), y1:round1000(y1), x2:round1000(x2), y2:round1000(y2), x3:round1000(x3), y3:round1000(y3), x4:round1000(x4), y4:round1000(y4)};
}
function fixOutsideBounds(box, parentBox) {
  var R = Raphael == null ? defaults : Raphael;
  var first = box;
  if (R.is(box, "function")) {
    return parentBox ? first() : eve.on("raphael.DOMload", first);
  } else {
    if (R.is(first, true)) {
      return R._engine.create[box](R, first.splice(0, 3 + R.is(first[0], null))).add(first);
    } else {
      var args = Array.prototype.slice.call(arguments, 0);
      if (R.is(args[args.length - 1], "function")) {
        var f = args.pop();
        return first ? f.call(R._engine.create[box](R, args)) : eve.on("raphael.DOMload", function() {
          f.call(R._engine.create[box](R, args));
        });
      } else {
        return R._engine.create[box](R, arguments);
      }
    }
  }
}
Raphael.fn.UpdateConnection = function(link) {
  if (!link.Left || !link.Right) {
    return false;
  }
  if (!link.Left.field || !link.Right.field) {
    return false;
  }
  if (!link.Left.field.element || !link.Right.field.element) {
    return false;
  }
  var graph = link.graphics;
  var shortLeg = 8;
  var color = graph.color;
  var fromType = link.Left.Type;
  var toType = link.Right.Type;
  function calculateBox(link) {
    var linkBox = getBBox(link.field.element);
    if (link.table) {
      var tableBox = getBBox(link.table.element);
      linkBox.x = tableBox.x - 1;
      linkBox.width = tableBox.width + 2;
      if (linkBox.y < tableBox.y) {
        linkBox.y = tableBox.y;
      } else {
        if (linkBox.y > tableBox.y + tableBox.height - linkBox.height) {
          linkBox.y = tableBox.y + tableBox.height - linkBox.height;
        }
      }
    }
    return linkBox;
  }
  var leftBox = calculateBox(link.Left);
  var rightBox = calculateBox(link.Right);
  var lineCoord = getLineCoord(leftBox, rightBox);
  var startD = lineCoord.x1 < lineCoord.x2 ? 1 : -1;
  var endD = lineCoord.x4 < lineCoord.x3 ? 1 : -1;
  var path = ["M", lineCoord.x1, lineCoord.y1, "L", lineCoord.x1 + shortLeg * startD, lineCoord.y1, "C", lineCoord.x2, lineCoord.y2, lineCoord.x3, lineCoord.y3, lineCoord.x4 + shortLeg * endD, lineCoord.y4, "L", lineCoord.x4, lineCoord.y4].join(",");
  graph.start = configEnds(graph.start, toType, color, lineCoord.x1, lineCoord.y1, startD);
  graph.end = configEnds(graph.end, fromType, color, lineCoord.x4, lineCoord.y4, endD);
  if (graph.path = path && (graph.line && graph.bg)) {
    graph.bg.attr({path:path});
    graph.line.attr({path:path});
    $(graph.bg.node).addClass("link-context");
  }
  return true;
};
Raphael.fn.CreateConnection = function(obj, attr) {
  var link = new QBWebCanvasLink;
  link.color = attr.split("|")[0] || "#000000";
  link.thin = attr.split("|")[1] || 3;
  link.thinBg = 15;
  link.line = this.path("M,0,0").attr({stroke:link.color, fill:"none", "stroke-width":link.thin, "stroke-linecap":"round", "stroke-linejoin":"round"});
  link.bg = this.path("M,0,0").attr({stroke:link.color, fill:"none", "stroke-width":link.thinBg, "stroke-opacity":0.01});
  link.startType = obj.Right.Type;
  link.start = configEnds(null, link.startType, link.color);
  link.endType = obj.Left.Type;
  link.end = configEnds(null, link.endType, link.color);
  link.object = obj;
  return link;
};
function configEnds(obj, type, color, x, y, d) {
  if (!x) {
    x = 0;
  }
  if (!y) {
    y = 0;
  }
  if (!d) {
    d = 1;
  }
  var typeMismatch = false;
  if (obj != null && obj.node) {
    switch(type) {
      case MetaData.JoinType.Inner:
        typeMismatch = obj.node.nodeName != "circle";
        break;
      case MetaData.JoinType.Outer:
        typeMismatch = obj.node.nodeName != "path";
        break;
    }
  }
  if (typeMismatch) {
    if (obj && obj.remove) {
      obj.remove();
    }
    obj = null;
  }
  if (obj == null) {
    switch(type) {
      case MetaData.JoinType.Inner:
        obj = QB.Web.Canvas.r.circle(0, 0, 5);
        obj.attr({fill:color, "stroke-width":0});
        break;
      case MetaData.JoinType.Outer:
        obj = QB.Web.Canvas.r.path("M,0,0");
        obj.attr({fill:color, "stroke-width":0});
        break;
    }
  }
  switch(type) {
    case MetaData.JoinType.Inner:
      obj.attr({cx:x, cy:y});
      break;
    case MetaData.JoinType.Outer:
      var dx = 8;
      var dy = 5;
      var path = ["M", x, y, "L", x, y + 1, x + dx * d, y + dy, x + dx * d, y - dy, x, y - 1, "Z"].join(",");
      obj.attr({path:path});
      break;
  }
  return obj;
}
;
/*
 * Packer
 * Javascript Compressor
 * http://dean.edwards.name/
 * http://www.smallsharptools.com/Projects/Packer/
*/

// ..\..\src\Common\Client\js\release\usr_v2_5_16.js
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1;};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p;}('K ZC=1n;K FW={Ic:1a(){K 6H=1c;if(2K r6!="2O"){7n{6H=1S r6("OB.JD")}7p(e){7n{6H=1S r6("z9.JD")}7p(E){6H=1j}}}1i{if(3Q.Il){7n{6H=1S Il}7p(e){6H=1c}}}1b 6H},vW:1a(Cd,1Z,44){K 6H=J.Ic();if(!6H||!Cd){1b}K 5e=Cd;5e+=5e.4Y("?")+1?"&":"?";5e+="Oq="+(1S 5m).KK();K rC=1c;if(44=="rD"){K BW=5e.3q("?");5e=BW[0];rC=BW[1]}6H.6Q(44,5e,1n);if(44=="rD"){6H.Ce("Eu-1w","nQ/x-nz-Oj-OA");6H.Ce("Eu-1e",rC.1e);6H.Ce("NZ","5s")}6H.Om=1a(){if(6H.mY==4){if(6H.6G==ff){K 1J="";if(6H.GO){1J=6H.GO}if(1Z){1Z(1J)}}}};6H.NU(rC)},7A:1a(c9,5e,bj){K 96=\'<b 3b="3t:#O8">yj 9n</b>\\n<br/>\\n\'+"jx: "+c9+"\\n<br>\\n"+"FK: "+5e+"\\n<br>\\n"+"Fq: "+bj+"\\n<br>\\n";K G0="yj 9n\\n"+"jx: "+c9+"\\n\\n"+"FK: "+5e+"\\n\\n"+"Fq: "+bj+"\\n\\n";if(aW&&aW.ew){96=96+"ew: "+aW.ew}K 3j=2N.c8("2E");3j.bO="QR";3j.nC=96;if(2N&&(2N.3U&&2N.3U.3G)){2N.3U.3G(3j)}1i{dL(G0)}FW.EW({c9:c9,5e:5e,bj:bj,ew:aW.ew});1b 1n},EW:1a(1v){K 5e="o9/R7.R6?";1o(K i in 1v){if(1v.7P(i)){5e+=i+"="+Rb(1v[i])+"&"}}J.vW(5e,1c,"rD")}};(1a(){J.Ra={5M:"1.4.5",9A:"R9"};K 7I=J.7I=1a(1g){if(1g==1c){1b"1c"}if(1g.$84!=1c){1b 1g.$84()}if(1g.8S){if(1g.F4==1){1b"1f"}if(1g.F4==3){1b/\\S/.9V(1g.DJ)?"R2":"GU"}}1i{if(2K 1g.1e=="cl"){if(1g.Je){1b"2q"}if("1g"in 1g){1b"Ed"}}}1b 2K 1g};K pO=J.pO=1a(1g,1D){if(1g==1c){1b 1j}K 4U=1g.$4U||1g.4U;45(4U){if(4U===1D){1b 1n}4U=4U.1L}if(!1g.7P){1b 1j}1b 1g dY 1D};K 9c=J.9c;K gu=1n;1o(K i in{3s:1}){gu=1c}if(gu){gu=["7P","KU","KT","rk","C6","3s","4U"]}9c.2T.eY=1a(qu){K 2n=J;1b 1a(a,b){if(a==1c){1b J}if(qu||2K a!="4e"){1o(K k in a){2n.2w(J,k,a[k])}if(gu){1o(K i=gu.1e;i--;){k=gu[i];if(a.7P(k)){2n.2w(J,k,a[k])}}}}1i{2n.2w(J,a,b)}1b J}};9c.2T.R1=1a(qu){K 2n=J;1b 1a(a){K 2e,1J;if(2K a!="4e"){2e=a}1i{if(2q.1e>1){2e=2q}1i{if(qu){2e=[a]}}}if(2e){1J={};1o(K i=0;i<2e.1e;i++){1J[2e[i]]=2n.2w(J,2e[i])}}1i{1J=2n.2w(J,a)}1b 1J}};9c.2T.4l=1a(1q,1m){J[1q]=1m}.eY();9c.2T.7c=1a(1q,1m){J.2T[1q]=1m}.eY();K 3H=43.2T.3H;9c.2s=1a(1g){1b 7I(1g)=="1a"?1g:1a(){1b 1g}};43.2s=1a(1g){if(1g==1c){1b[]}1b 9o.H8(1g)&&2K 1g!="4e"?7I(1g)=="3I"?1g:3H.2w(1g):[1g]};63.2s=1a(1g){K cl=d5(1g);1b GK(cl)?cl:1c};5l.2s=1a(1g){1b 1g+""};9c.7c({Bf:1a(){J.$7d=1n;1b J},BF:1a(){J.$q8=1n;1b J}});K 9o=J.9o=J.9o=1a(1z,1D){if(1z){K Ay=1z.3N();K Gd=1a(1g){1b 7I(1g)==Ay};9o["is"+1z]=Gd;if(1D!=1c){1D.2T.$84=1a(){1b Ay}.Bf()}}if(1D==1c){1b 1c}1D.4l(J);1D.$4U=9o;1D.2T.$4U=1D;1b 1D};K 3s=4J.2T.3s;9o.H8=1a(1g){1b 1g!=1c&&(2K 1g.1e=="cl"&&3s.2w(1g)!="[1D 9c]")};K j2={};K Bv=1a(1D){K 1w=7I(1D.2T);1b j2[1w]||(j2[1w]=[])};K 7c=1a(1z,44){if(44&&44.$7d){1b}K j2=Bv(J);1o(K i=0;i<j2.1e;i++){K k5=j2[i];if(7I(k5)=="1w"){7c.2w(k5,1z,44)}1i{k5.2w(J,1z,44)}}K cc=J.2T[1z];if(cc==1c||!cc.$q8){J.2T[1z]=44}if(J[1z]==1c&&7I(44)=="1a"){4l.2w(J,1z,1a(1g){1b 44.3c(1g,3H.2w(2q,1))})}};K 4l=1a(1z,44){if(44&&44.$7d){1b}K cc=J[1z];if(cc==1c||!cc.$q8){J[1z]=44}};9o.7c({7c:7c.eY(),4l:4l.eY(),b0:1a(1z,8s){7c.2w(J,1z,J.2T[8s])}.eY(),R5:1a(k5){Bv(J).1C(k5);1b J}});1S 9o("9o",9o);K fa=1a(1z,1D,a4){K pH=1D!=4J,2T=1D.2T;if(pH){1D=1S 9o(1z,1D)}1o(K i=0,l=a4.1e;i<l;i++){K 1q=a4[i],Bq=1D[1q],hR=2T[1q];if(Bq){Bq.BF()}if(pH&&hR){1D.7c(1q,hR.BF())}}if(pH){K Go=2T.rk(a4[0]);1D.Qu=1a(fn){if(!Go){1o(K i=0,l=a4.1e;i<l;i++){fn.2w(2T,2T[a4[i]],a4[i])}}1o(K 1q in 2T){fn.2w(2T,2T[1q],1q)}}}1b fa};fa("5l",5l,["bs","K6","3x","4Y","GQ","3e","Cy","3g","Qt","3H","3q","71","fY","od","3N","8w"])("43",43,["cQ","1C","Qy","bf","eZ","5f","Qx","3x","4H","3H","4Y","GQ","4p","8F","A5","eQ","Ck","Qw","Qo"])("63",63,["Bt","4q","C6","Qn"])("9c",9c,["3c","2w","2C"])("cY",cY,["Qs","9V"])("4J",4J,["7U","Qr","Qq","81","Qz","QJ","QI","QH","QM","QL","QK","QD","QC"])("5m",5m,["7b"]);4J.4l=4l.eY();5m.4l("7b",1a(){1b+1S 5m});1S 9o("i8",i8);63.2T.$84=1a(){1b GK(J)?"cl":"1c"}.Bf();63.4l("iw",1a(5Q,4y){1b 3D.gF(3D.iw()*(4y-5Q+1)+5Q)});K 7P=4J.2T.7P;4J.4l("8F",1a(1D,fn,2C){1o(K 1q in 1D){if(7P.2w(1D,1q)){fn.2w(2C,1D[1q],1q,1D)}}});4J.2h=4J.8F;43.7c({8F:1a(fn,2C){1o(K i=0,l=J.1e;i<l;i++){if(i in J){fn.2w(2C,J[i],i,J)}}},2h:1a(fn,2C){43.8F(J,fn,2C);1b J}});K B4=1a(1g){3r(7I(1g)){1l"3I":1b 1g.5R();1l"1D":1b 4J.5R(1g);5o:1b 1g}};43.7c("5R",1a(){K i=J.1e,5R=1S 43(i);45(i--){5R[i]=B4(J[i])}1b 5R});K Bl=1a(af,1q,5C){3r(7I(5C)){1l"1D":if(7I(af[1q])=="1D"){4J.BK(af[1q],5C)}1i{af[1q]=4J.5R(5C)}1p;1l"3I":af[1q]=5C.5R();1p;5o:af[1q]=5C}1b af};4J.4l({BK:1a(af,k,v){if(7I(k)=="4e"){1b Bl(af,k,v)}1o(K i=1,l=2q.1e;i<l;i++){K 1D=2q[i];1o(K 1q in 1D){Bl(af,1q,1D[1q])}}1b af},5R:1a(1D){K 5R={};1o(K 1q in 1D){5R[1q]=B4(1D[1q])}1b 5R},3a:1a(kp){1o(K i=1,l=2q.1e;i<l;i++){K Ba=2q[i]||{};1o(K 1q in Ba){kp[1q]=Ba[1q]}}1b kp}});["4J","Rc","RK","RJ","RN"].2h(1a(1z){1S 9o(1z)});K Ch=5m.7b();5l.4l("RL",1a(){1b(Ch++).3s(36)})})();43.7c({A5:1a(fn,2C){1o(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&!fn.2w(2C,J[i],i,J)){1b 1j}}1b 1n},4p:1a(fn,2C){K e9=[];1o(K 1m,i=0,l=J.1e>>>0;i<l;i++){if(i in J){1m=J[i];if(fn.2w(2C,1m,i,J)){e9.1C(1m)}}}1b e9},4Y:1a(1g,2s){K 1e=J.1e>>>0;1o(K i=2s<0?3D.4y(0,1e+2s):2s||0;i<1e;i++){if(J[i]===1g){1b i}}1b-1},eQ:1a(fn,2C){K 1e=J.1e>>>0,e9=43(1e);1o(K i=0;i<1e;i++){if(i in J){e9[i]=fn.2w(2C,J[i],i,J)}}1b e9},Ck:1a(fn,2C){1o(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&fn.2w(2C,J[i],i,J)){1b 1n}}1b 1j},E5:1a(){1b J.4p(1a(1g){1b 1g!=1c})},RE:1a(Cn){K 2e=43.3H(2q,1);1b J.eQ(1a(1g){1b 1g[Cn].3c(1g,2e)})},RC:1a(81){K 1u={},1e=3D.5Q(J.1e,81.1e);1o(K i=0;i<1e;i++){1u[81[i]]=J[i]}1b 1u},1W:1a(1D){K 1J={};1o(K i=0,l=J.1e;i<l;i++){1o(K 1q in 1D){if(1D[1q](J[i])){1J[1q]=J[i];42 1D[1q];1p}}}1b 1J},hd:1a(1g,2s){1b J.4Y(1g,2s)!=-1},3a:1a(3I){J.1C.3c(J,3I);1b J},RH:1a(){1b J.1e?J[J.1e-1]:1c},RG:1a(){1b J.1e?J[63.iw(0,J.1e-1)]:1c},E9:1a(1g){if(!J.hd(1g)){J.1C(1g)}1b J},RF:1a(3I){1o(K i=0,l=3I.1e;i<l;i++){J.E9(3I[i])}1b J},RO:1a(1g){1o(K i=J.1e;i--;){if(J[i]===1g){J.5f(i,1)}}1b J},cI:1a(){J.1e=0;1b J},Eg:1a(){K 3I=[];1o(K i=0,l=J.1e;i<l;i++){K 1w=7I(J[i]);if(1w=="1c"){ah}3I=3I.3x(1w=="3I"||(1w=="Ed"||(1w=="2q"||pO(J[i],43)))?43.Eg(J[i]):J[i])}1b 3I},RX:1a(){1o(K i=0,l=J.1e;i<l;i++){if(J[i]!=1c){1b J[i]}}1b 1c},Ap:1a(3I){if(J.1e!=3){1b 1c}K 3E=J.eQ(1a(1m){if(1m.1e==1){1m+=1m}1b 1m.9z(16)});1b 3I?3E:"3E("+3E+")"},AR:1a(3I){if(J.1e<3){1b 1c}if(J.1e==4&&(J[3]==0&&!3I)){1b"RW"}K 67=[];1o(K i=0;i<3;i++){K qP=(J[i]-0).3s(16);67.1C(qP.1e==1?"0"+qP:qP)}1b 3I?67:"#"+67.4H("")}});5l.7c({9V:1a(ri,1v){1b(7I(ri)=="AW"?ri:1S cY(""+ri,1v)).9V(J)},hd:1a(4e,5n){1b 5n?(5n+J+5n).4Y(5n+4e+5n)>-1:5l(J).4Y(4e)>-1},od:1a(){1b 5l(J).3g(/^\\s+|\\s+$/g,"")},E5:1a(){1b 5l(J).3g(/\\s+/g," ").od()},S0:1a(){1b 5l(J).3g(/-\\D/g,1a(3e){1b 3e.bs(1).8w()})},RZ:1a(){1b 5l(J).3g(/[A-Z]/g,1a(3e){1b"-"+3e.bs(0).3N()})},RP:1a(){1b 5l(J).3g(/\\b[a-z]/g,1a(3e){1b 3e.8w()})},RU:1a(){1b 5l(J).3g(/([-.*+?^${}()|[\\]\\/\\\\])/g,"\\\\$1")},9z:1a(gx){1b 6p(J,gx||10)},3z:1a(){1b d5(J)},Ap:1a(3I){K 67=5l(J).3e(/^#?(\\w{1,2})(\\w{1,2})(\\w{1,2})$/);1b 67?67.3H(1).Ap(3I):1c},AR:1a(3I){K 3E=5l(J).3e(/\\d{1,3}/g);1b 3E?3E.AR(3I):1c},RS:1a(1D,AW){1b 5l(J).3g(AW||/\\\\?\\{([^{}]+)\\}/g,1a(3e,1z){if(3e.bs(0)=="\\\\"){1b 3e.3H(1)}1b 1D[1z]!=1c?1D[1z]:""})}});9c.4l({DI:1a(){1o(K i=0,l=2q.1e;i<l;i++){7n{1b 2q[i]()}7p(e){}}1b 1c}});9c.7c({DI:1a(2e,2C){7n{1b J.3c(2C,43.2s(2e))}7p(e){}1b 1c},2C:1a(65){K 2n=J,2e=2q.1e>1?43.3H(2q,1):1c,F=1a(){};K AX=1a(){K 3l=65,1e=2q.1e;if(J dY AX){F.2T=2n.2T;3l=1S F}K 1J=!2e&&!1e?2n.2w(3l):2n.3c(3l,2e&&1e?2e.3x(43.3H(2q)):2e||2q);1b 3l==65?1J:3l};1b AX},AI:1a(2e,2C){K 2n=J;if(2e!=1c){2e=43.2s(2e)}1b 1a(){1b 2n.3c(2C,2e||2q)}},fo:1a(fo,2C,2e){1b 6x(J.AI(2e==1c?[]:2e,2C),fo)},AN:1a(AN,2C,2e){1b lO(J.AI(2e==1c?[]:2e,2C),AN)}});63.7c({Rj:1a(5Q,4y){1b 3D.5Q(4y,3D.4y(5Q,J))},4G:1a(fi){fi=3D.5L(10,fi||0).4q(fi<0?-fi:0);1b 3D.4G(J*fi)/fi},bX:1a(fn,2C){1o(K i=0;i<J;i++){fn.2w(2C,i,J)}},3z:1a(){1b d5(J)},9z:1a(gx){1b 6p(J,gx||10)}});63.b0("2h","bX");(1a(3w){K a4={};3w.2h(1a(1z){if(!63[1z]){a4[1z]=1a(){1b 3D[1z].3c(1c,[J].3x(43.2s(2q)))}}});63.7c(a4)})(["4a","Fv","qV","Rn","ya","j5","8B","Rm","gF","j3","4y","5Q","5L","8o","9M","Cg"]);(1a(){K 68=J.68=1S 9o("68",1a(1v){if(pO(1v,9c)){1v={bB:1v}}K gP=1a(){lU(J);if(gP.$BQ){1b J}J.$8U=1c;K 1m=J.bB?J.bB.3c(J,2q):J;J.$8U=J.8U=1c;1b 1m}.4l(J).7c(1v);gP.$4U=68;gP.2T.$4U=gP;gP.2T.1L=1L;1b gP});K 1L=1a(){if(!J.$8U){9w 1S 9n(\'qZ 44 "1L" Ey be AH.\')}K 1z=J.$8U.$1z,1L=J.$8U.$CG.1L,cc=1L?1L.2T[1z]:1c;if(!cc){9w 1S 9n(\'qZ 44 "\'+1z+\'" 3o no 1L.\')}1b cc.3c(J,2q)};K lU=1a(1D){1o(K 1q in 1D){K 1m=1D[1q];3r(7I(1m)){1l"1D":K F=1a(){};F.2T=1m;1D[1q]=lU(1S F);1p;1l"3I":1D[1q]=1m.5R();1p}}1b 1D};K Co=1a(2n,1q,44){if(44.$f0){44=44.$f0}K 5T=1a(){if(44.$q8&&J.$8U==1c){9w 1S 9n(\'qZ 44 "\'+1q+\'" Ey be AH.\')}K 8U=J.8U,5C=J.$8U;J.8U=5C;J.$8U=5T;K 1J=44.3c(J,2q);J.$8U=5C;J.8U=8U;1b 1J}.4l({$CG:2n,$f0:44,$1z:1q});1b 5T};K 7c=1a(1q,1m,CD){if(68.Cc.7P(1q)){1m=68.Cc[1q].2w(J,1m);if(1m==1c){1b J}}if(7I(1m)=="1a"){if(1m.$7d){1b J}J.2T[1q]=CD?1m:Co(J,1q,1m)}1i{4J.BK(J.2T,1q,1m)}1b J};K LZ=1a(qN){qN.$BQ=1n;K hR=1S qN;42 qN.$BQ;1b hR};68.7c("7c",7c.eY());68.Cc={bh:1a(1L){J.1L=1L;J.2T=LZ(1L)},Rz:1a(1F){43.2s(1F).2h(1a(1g){K rl=1S 1g;1o(K 1q in rl){7c.2w(J,1q,rl[1q],1n)}},J)}}})();(1a($){$.bV.9l="Rs"in 2N;if(!$.bV.9l){1b}K kg=$.ui.tE.2T;K pt=kg.pt;K kh;1a fR(1H,LR){if(1H.d1.hq.1e>1){1b}1H.4h();K t=1H.d1.LU[0];K BP=2N.CR("Rr");BP.De(LR,1n,1n,3Q,1,t.D9,t.Cj,t.aj,t.ap,1j,1j,1j,1j,0,1c);1H.3k.zu(BP)}kg.Mi=1a(1H){K me=J;if(kh||!me.Rq(1H.d1.LU[0])){1b}kh=1n;me.BR=1j;fR(1H,"hL");fR(1H,"9T");fR(1H,"7f")};kg.Mj=1a(1H){if(!kh){1b}J.BR=1n;fR(1H,"9T")};kg.Mf=1a(1H){if(!kh){1b}fR(1H,"5u");fR(1H,"ea");if(!J.BR){fR(1H,"3J")}kh=1j};kg.pt=1a(){K me=J;me.1f.2C("oc",$.9v(me,"Mi")).2C("oe",$.9v(me,"Mj")).2C("o4",$.9v(me,"Mf"));pt.2w(me)}})(2v);K gj=1c;(1a($){$.fn.nk=1a(){$(J).fp(1a(e){K t=e.8b;K o=$(e.8b).2y();if(e.6R-o.2a>t.kP){1b}K 1f=$(e.3k);1f.2L({x:e.aj,y:e.ap})})};K $Ml=$.fn.3J;$.fn.3J=1a 3J(6S,7A){if(!7A){1b $Ml.3c(J,2q)}1b $(J).2C(1w,7A)};$.fn.fp=1a fp(){K 2e=[].5f.2w(2q,0),7A=2e.cQ(),6S=2e.cQ(),$J=$(J);1b 7A?$J.3J(6S,7A):$J.2c(1w)};$.fp={6S:8W};$.1H.Pe.fp={yO:1a(1h,9g){if(!/Pd|Pc|P8/i.9V(aW.ew)){$(J).2C(LF,AY).2C([LD,LL,LM,LK].4H(" "),Ao).2C(Aq,3J)}1i{Lj(J).2C(LH,AY).2C([Lt,Lr,Lp].4H(" "),Ao).2C(Aq,3J).31({Pb:"3p"})}},P9:1a(9g){$(J).7Y(9a)}};1a Lj(1f){$.2h("oc oe o4 xf".3q(/ /),1a 2C(ix,it){1f.bL(it,1a Pq(1H){$(1f).2c(it)},1j)});1b $(1f)}1a AY(1H){if(gj){1b}K 1f=J;K 2e=2q;$(J).1h(oP,1j);gj=6x(L6,$.fp.6S);1a L6(){$(1f).1h(oP,1n);1H.1w=1w;2v.1H.Pt.3c(1f,2e)}}1a Ao(1H){if(gj){k1(gj);gj=1c}}1a 3J(1H){if($(J).1h(oP)){1b 1H.cN()||1j}}K 1w="fp";K 9a="."+1w;K LF="7f"+9a;K Aq="3J"+9a;K LD="9T"+9a;K LL="5u"+9a;K LM="ea"+9a;K LK="5g"+9a;K LH="oc"+9a;K Lt="o4"+9a;K Lr="oe"+9a;K Lp="xf"+9a;K Pl="6S"+9a;K Pk="8N"+9a;K oP="Gh"+9a})(2v);(1a($){$.fn.tQ=1a(1x){K lA=$.4l({},$.fn.tQ.cO,1x);1b J.2h(1a(){$J=$(J);K o=$.Po?$.4l({},lA,$J.1h()):lA;K lB=o.2I;$.fn.jl(o,$J,lB)})};K BD=0;K pT=0;K Pn=aW.Pm;K NB=aW.OP;if(NB.4Y("OO 7.0")>0){K qk="qn"}$.fn.tQ.cO={6E:5,2I:12,5p:5,g2:1n,Bb:"#ja",je:"#OS",jd:"OR",Bk:"#ja",jh:"#ja",j8:"#ja",5q:1n,C0:1n,tE:"OI",nA:1a(){1b 1j}};$.fn.jl=1a(o,1u,lB){if(o.5p>o.6E){o.5p=o.6E}$J.cI();if(o.C0){K Np="95-Nv-cE";K Nw="95-cc-cE";K NS="95-NK-cE";K NO="95-3m-cE"}1i{K Np="95-Nv";K Nw="95-cc";K NS="95-NK";K NO="95-3m"}if(o.5q){K Bg=$("<2E>&lt;</2E>").3C({bJ:{uj:"ui-3K-MW-1-w"},1Y:1j})}$J.3X(\'<2E id="OG">\'+\'<2E id="OM">\'+\'<2E id="OL">\'+\'<2E id="qD"></2E>\'+\'<2E id="qH"></2E>\'+\'<2E id="Bm"></2E>\'+"</2E>"+"</2E>"+"</2E>");K MQ=$("#qD").2t("95-2Z-zJ");MQ.3a(Bg);K 8d=$(\'<1M t8="0" t4="0">\').31("ga","7d");K hk=$("<tr>").2t("95-OT");K c=(o.5p-1)/2;K 4x=lB-c;K m6;1o(K i=0;i<o.6E;i++){K 2g=i+1;if(2g==lB){K lx=$(\'<td 2B="li">\').3X(\'<2F 2B="95-5C">\'+2g+"</2F>");m6=lx;hk.3a(lx)}1i{K lx=$(\'<td 2B="li">\').3X("<a>"+2g+"</a>");hk.3a(lx)}}8d.3a(hk);if(o.5q){K Be=$("<2E>&gt;</2E>").3C({bJ:{uj:"ui-3K-MW-1-e"},1Y:1j})}K mc=$("#qH").2t("95-2Z-P1");mc.3a(Be);$("#Bm").3a(8d);K q7=$("#Bm");K B9=1c;1a MV(){$("#qD").3L();$("#qH").3L()}1a MF(){$("#qD").59();$("#qH").59()}1a B2(){if(q7.1r()==0){1b}qB(B9);if(8d.1r()<=q7.1r()){MV()}1i{MF()}}if(q7.1r()==0){B9=lO(B2,kO)}1i{B2()}$J.2t("P3");if(!o.g2){if(o.jd=="3p"){K e1={"3t":o.je}}1i{K e1={"3t":o.je,"ia-3t":o.jd}}if(o.j8=="3p"){K e5={"3t":o.jh}}1i{K e5={"3t":o.jh,"ia-3t":o.j8}}}1i{if(o.jd=="3p"){K e1={"3t":o.je,"g2":"k3 mN "+o.Bb}}1i{K e1={"3t":o.je,"ia-3t":o.jd,"g2":"k3 mN "+o.Bb}}if(o.j8=="3p"){K e5={"3t":o.jh,"g2":"k3 mN "+o.Bk}}1i{K e5={"3t":o.jh,"ia-3t":o.j8,"g2":"k3 mN "+o.Bk}}}$.fn.B6(o,$J,e1,e5,hk,8d,mc);K Bj=BD-1;if(qk=="qn"){}1i{}if(o.tE=="DX"){Be.7f(1a(){q9=lO(1a(){K 2a=8d.1L().4S()+5;8d.1L().4S(2a)},20)}).5u(1a(){qB(q9)});Bg.7f(1a(){q9=lO(1a(){K 2a=8d.1L().4S()-5;8d.1L().4S(2a)},20)}).5u(1a(){qB(q9)})}8d.2D(".li").3J(1a(e){m6.3X("<a>"+m6.2D(".95-5C").3X()+"</a>");K Bd=$(J).2D("a").3X();$(J).3X(\'<2F 2B="95-5C">\'+Bd+"</2F>");m6=$(J);$.fn.B6(o,$(J).1L().1L().1L(),e1,e5,hk,8d,mc);K 2a=J.8p/2;K OW=8d.4S()+2a;K 8i=2a-Bj/2;if(qk=="qn"){8d.4K({4S:2a+8i+52+"px"})}1i{8d.4K({4S:2a+8i+"px"})}o.nA(Bd)});K 73=8d.2D(".li").eq(o.2I-1);73.1k("id","8i");K 2a=2N.eg("8i").8p/2;73.iu("id");K 8i=2a-Bj/2;if(qk=="qn"){8d.4K({4S:2a+8i+52+"px"})}1i{8d.4K({4S:2a+8i+"px"})}};$.fn.B6=1a(o,1u,e1,e5,hk,8d,mc){1u.2D("a").31(e1);1u.2D("2F.95-5C").31(e5);1u.2D("a").6y(1a(){$(J).31(e5)},1a(){$(J).31(e1)});pT=0;1u.2D(".li").2h(1a(i,n){if(i==o.5p-1){BD=J.8p+J.f6}pT+=J.f6});pT+=3}})(2v);(1a($){$.4l({gQ:1a(fn,pE,92,Bz){K 8N;1b 1a(){K 2e=2q;92=92||J;Bz&&(!8N&&fn.3c(92,2e));k1(8N);8N=6x(1a(){!Bz&&fn.3c(92,2e);8N=1c},pE)}},C9:1a(fn,pE,92){K 8N,2e,ph;1b 1a(){2e=2q;ph=1n;92=92||J;if(!8N){(1a(){if(ph){fn.3c(92,2e);ph=1j;8N=6x(2q.Je,pE)}1i{8N=1c}})()}}}})})(2v);(1a($){K h3={jy:{Ax:1a(i){3r(J.jQ(i)){1l"3I":;1l"OV":;1l"cl":1b i.3s();1l"1D":K o=[];1o(x=0;x<i.1e;i++){o.1C(i+": "+J.Ax(i[x]))}1b o.4H(", ");1l"4e":1b i;5o:1b i}},jQ:1a(i){if(!i||!i.4U){1b 2K i}K 3e=i.4U.3s().3e(/43|63|5l|4J|5m/);1b 3e&&3e[0].3N()||2K i},jw:1a(76,l,s,t){K p=s||" ";K o=76;if(l-76.1e>0){o=(1S 43(3D.j5(l/ p.1e))).4H(p).71(0, t = !t ? l : t == 1 ? 0 : 3D.j5(l /2))+76+p.71(0,l-t)}1b o},Jo:1a(4i,2e){K 1q=4i.pD();3r(J.jQ(2e)){1l"1D":K 81=1q.3q(".");K 1u=2e;1o(K bG=0;bG<81.1e;bG++){1u=1u[81[bG]]}if(2K 1u!="2O"){if(h3.jy.jQ(1u)=="3I"){1b 4i.h5().3e(/\\.\\*/)&&1u[1]||1u}1b 1u}1i{}1p;1l"3I":1q=6p(1q,10);if(4i.h5().3e(/\\.\\*/)&&2K 2e[1q+1]!="2O"){1b 2e[1q+1]}1i{if(2K 2e[1q]!="2O"){1b 2e[1q]}1i{1b 1q}}1p}1b"{"+1q+"}"},HY:1a(c4,2e){K 4i=1S KY(c4,2e);1b h3.jy[4i.h5().3H(-1)](J.Jo(4i,2e),4i)},d:1a(29,4i){K o=6p(29,10);K p=4i.ld();if(p){1b J.jw(o.3s(),p,4i.ls(),0)}1i{1b o}},i:1a(29,2e){1b J.d(29,2e)},o:1a(29,4i){K o=29.3s(8);if(4i.lv()){o=J.jw(o,o.1e+1,"0",0)}1b J.jw(o,4i.ld(),4i.ls(),0)},u:1a(29,2e){1b 3D.4a(J.d(29,2e))},x:1a(29,4i){K o=6p(29,10).3s(16);o=J.jw(o,4i.ld(),4i.ls(),0);1b 4i.lv()?"OX"+o:o},X:1a(29,4i){1b J.x(29,4i).8w()},e:1a(29,4i){1b d5(29,10).Bt(4i.pN())},E:1a(29,4i){1b J.e(29,4i).8w()},f:1a(29,4i){1b J.jw(d5(29,10).4q(4i.pN()),4i.ld(),4i.ls(),0)},F:1a(29,2e){1b J.f(29,2e)},g:1a(29,4i){K o=d5(29,10);1b o.3s().1e>6?3D.4G(o.Bt(4i.pN())):o},G:1a(29,2e){1b J.g(29,2e)},c:1a(29,2e){K 3e=29.3e(/\\w|\\d/);1b 3e&&3e[0]||""},r:1a(29,2e){1b J.Ax(29)},s:1a(29,2e){1b 29.3s&&29.3s()||""+29}},6v:1a(76,2e){K 4z=0;K 2I=0;K 3e=1j;K hK=[];K c4="";K 8i=(76||"").3q("");1o(2I=0;2I<8i.1e;2I++){if(8i[2I]=="{"&&8i[2I+1]!="{"){4z=76.4Y("}",2I);c4=8i.3H(2I+1,4z).4H("");hK.1C(h3.jy.HY(c4,2K 2q[1]!="1D"?JK(2q,2):2e||[]))}1i{if(2I>4z||hK.1e<1){hK.1C(8i[2I])}}}1b hK.1e>1?hK.4H(""):hK[0]},Q4:1a(76,2e){1b sC(6v(76,2e))},jN:1a(s,n){1b(1S 43(n+1)).4H(s)},Q3:1a(s){1b Q8(Q7(s))},Q6:1a(s){1b PZ(PY(s))},Qi:1a(){K 2k="",Qh=1n;if(2q.1e==2&&$.xV(2q[1])){J[2q[0]]=2q[1].4H("");1b 2v}if(2q.1e==2&&$.Qj(2q[1])){J[2q[0]]=2q[1];1b 2v}if(2q.1e==1){1b $(J[2q[0]])}if(2q.1e==2&&2q[1]==1j){1b J[2q[0]]}if(2q.1e==2&&$.KR(2q[1])){1b $($.6v(J[2q[0]],2q[1]))}if(2q.1e==3&&$.KR(2q[1])){1b 2q[2]==1n?$.6v(J[2q[0]],2q[1]):$($.6v(J[2q[0]],2q[1]))}}};K KY=1a(4i,2e){J.C1=4i;J.hH=2e;J.Qc=d5("1."+(1S 43(32)).4H("1"),10).3s().1e-3;J.le=6;J.lw=1a(){1b J.C1};J.pD=1a(){1b J.C1.3q(":")[0]};J.h5=1a(){K 3e=J.lw().3q(":");1b 3e&&3e[1]?3e[1]:"s"};J.pN=1a(){K 3e=J.h5().3e(/\\.(\\d+|\\*)/g);if(!3e){1b J.le}1i{3e=3e[0].3H(1);if(3e!="*"){1b 6p(3e,10)}1i{if(h3.jy.jQ(J.hH)=="3I"){1b J.hH[1]&&J.hH[0]||J.le}1i{if(h3.jy.jQ(J.hH)=="1D"){1b J.hH[J.pD()]&&J.hH[J.pD()][0]||J.le}1i{1b J.le}}}}};J.ld=1a(){K 3e=1j;if(J.lv()){3e=J.lw().3e(/0?#0?(\\d+)/);if(3e&&3e[1]){1b 6p(3e[1],10)}}3e=J.lw().3e(/(0|\\.)(\\d+|\\*)/g);1b 3e&&6p(3e[0].3H(1),10)||0};J.ls=1a(){K o="";if(J.lv()){o=" "}if(J.h5().3e(/#0|0#|^0|\\.\\d+/)){o="0"}1b o};J.Qa=1a(){K 3e=J.lw().Qe(/^(0|\\#|\\-|\\+|\\s)+/);1b 3e&&3e[0].3q("")||[]};J.lv=1a(){1b!!J.h5().3e(/^0?#/)}};K JK=1a(2e,bf){K o=[];1o(l=2e.1e,x=(bf||0)-1;x<l;x++){o.1C(2e[x])}1b o};$.4l(h3)})(2v);(1a($){$.gA=1a(o){if(2K dv=="1D"&&dv.Jr){1b dv.Jr(o)}K 1w=2K o;if(o===1c){1b"1c"}if(1w=="2O"){1b 2O}if(1w=="cl"||1w=="lS"){1b o+""}if(1w=="4e"){1b $.vn(o)}if(1w=="1D"){if(2K o.gA=="1a"){1b $.gA(o.gA())}if(o.4U===5m){K ln=o.PF()+1;if(ln<10){ln="0"+ln}K lo=o.PT();if(lo<10){lo="0"+lo}K JW=o.PR();K kU=o.PV();if(kU<10){kU="0"+kU}K kT=o.PL();if(kT<10){kT="0"+kT}K kX=o.PQ();if(kX<10){kX="0"+kX}K eR=o.RT();if(eR<100){eR="0"+eR}if(eR<10){eR="0"+eR}1b\'"\'+JW+"-"+ln+"-"+lo+"T"+kU+":"+kT+":"+kX+"."+eR+\'Z"\'}if(o.4U===43){K 7S=[];1o(K i=0;i<o.1e;i++){7S.1C($.gA(o[i])||"1c")}1b"["+7S.4H(",")+"]"}K v0=[];1o(K k in o){K 1z;K 1w=2K k;if(1w=="cl"){1z=\'"\'+k+\'"\'}1i{if(1w=="4e"){1z=$.vn(k)}1i{ah}}if(2K o[k]=="1a"){ah}K 2g=$.gA(o[k]);v0.1C(1z+":"+2g)}1b"{"+v0.4H(", ")+"}"}};$.PO=1a(4b){if(2K dv=="1D"&&dv.pL){1b dv.pL(4b)}1b sC("("+4b+")")};$.PP=1a(4b){if(2K dv=="1D"&&dv.pL){1b dv.pL(4b)}K eU=4b;eU=eU.3g(/\\\\["\\\\\\/PK]/g,"@");eU=eU.3g(/"[^"\\\\\\n\\r]*"|1n|1j|1c|-?\\d+(?:\\.\\d*)?(?:[eE][+\\-]?\\d+)?/g,"]");eU=eU.3g(/(?:^|:|,)(?:\\s*\\[)+/g,"");if(/^[\\],:{}\\s]*$/.9V(eU)){1b sC("("+4b+")")}1i{9w 1S PN("9n PU dv, af is 5X PW.")}};$.vn=1a(4e){if(4e.3e(vi)){1b\'"\'+4e.3g(vi,1a(a){K c=Jy[a];if(2K c==="4e"){1b c}c=a.K6();1b"\\\\PS"+3D.gF(c/16).3s(16)+(c%16).3s(16)})+\'"\'}1b\'"\'+4e+\'"\'};K vi=/["\\\\\\PJ-\\Pz\\PA-\\PB]/g;K Jy={"\\b":"\\\\b","\\t":"\\\\t","\\n":"\\\\n","\\f":"\\\\f","\\r":"\\\\r",\'"\':\'\\\\"\',"\\\\":"\\\\\\\\"}})(2v);(1a($){$.fn.uu=1a(){K 54=1a(el,v,t,sO){K 2Q=2N.c8("2Q");2Q.1m=v,2Q.1Y=t;K o=el.1x;K oL=o.1e;if(!el.7K){el.7K={};1o(K i=0;i<oL;i++){el.7K[o[i].1m]=i}}if(2K el.7K[v]=="2O"){el.7K[v]=oL}el.1x[el.7K[v]]=2Q;if(sO){2Q.1Q=1n}};K a=2q;if(a.1e==0){1b J}K sO=1n;K m=1j;K 1F,v,t;if(2K a[0]=="1D"){m=1n;1F=a[0]}if(a.1e>=2){if(2K a[1]=="lS"){sO=a[1]}1i{if(2K a[2]=="lS"){sO=a[2]}}if(!m){v=a[0];t=a[1]}}J.2h(1a(){if(J.8S.3N()!="2o"){1b}if(m){1o(K 1g in 1F){54(J,1g,1F[1g],sO)}}1i{54(J,v,t,sO)}});1b J};$.fn.Pw=1a(5e,1v,2o,fn,2e){if(2K 5e!="4e"){1b J}if(2K 1v!="1D"){1v={}}if(2K 2o!="lS"){2o=1n}J.2h(1a(){K el=J;$.Px(5e,1v,1a(r){$(el).uu(r,2o);if(2K fn=="1a"){if(2K 2e=="1D"){fn.3c(el,2e)}1i{fn.2w(el)}}})});1b J};$.fn.JB=1a(){K a=2q;if(a.1e==0){1b J}K ta=2K a[0];K v,1P;if(ta=="4e"||(ta=="1D"||ta=="1a")){v=a[0];if(v.4U==43){K l=v.1e;1o(K i=0;i<l;i++){J.JB(v[i],a[1])}1b J}}1i{if(ta=="cl"){1P=a[0]}1i{1b J}}J.2h(1a(){if(J.8S.3N()!="2o"){1b}if(J.7K){J.7K=1c}K 3u=1j;K o=J.1x;if(!!v){K oL=o.1e;1o(K i=oL-1;i>=0;i--){if(v.4U==cY){if(o[i].1m.3e(v)){3u=1n}}1i{if(o[i].1m==v){3u=1n}}if(3u&&a[1]===1n){3u=o[i].1Q}if(3u){o[i]=1c}3u=1j}}1i{if(a[1]===1n){3u=o[1P].1Q}1i{3u=1n}if(3u){J.3u(1P)}}});1b J};$.fn.Py=1a(um){K Jq=$(J).Ju();K a=2K um=="2O"?1n:!!um;J.2h(1a(){if(J.8S.3N()!="2o"){1b}K o=J.1x;K oL=o.1e;K sA=[];1o(K i=0;i<oL;i++){sA[i]={v:o[i].1m,t:o[i].1Y}}sA.eZ(1a(o1,o2){pM=o1.t.3N(),oI=o2.t.3N();if(pM==oI){1b 0}if(a){1b pM<oI?-1:1}1i{1b pM>oI?-1:1}});1o(K i=0;i<oL;i++){o[i].1Y=sA[i].t;o[i].1m=sA[i].v}}).qr(Jq,1n);1b J};$.fn.qr=1a(1m,a0){K v=1m;K vT=2K 1m;if(vT=="1D"&&v.4U==43){K $J=J;$.2h(v,1a(){$J.qr(J,a0)})}K c=a0||1j;if(vT!="4e"&&(vT!="1a"&&vT!="1D")){1b J}J.2h(1a(){if(J.8S.3N()!="2o"){1b J}K o=J.1x;K oL=o.1e;1o(K i=0;i<oL;i++){if(v.4U==cY){if(o[i].1m.3e(v)){o[i].1Q=1n}1i{if(c){o[i].1Q=1j}}}1i{if(o[i].1m==v){o[i].1Q=1n}1i{if(c){o[i].1Q=1j}}}}});1b J};$.fn.PG=1a(to,iK){K w=iK||"1Q";if($(to).56()==0){1b J}J.2h(1a(){if(J.8S.3N()!="2o"){1b J}K o=J.1x;K oL=o.1e;1o(K i=0;i<oL;i++){if(w=="6o"||w=="1Q"&&o[i].1Q){$(to).uu(o[i].1m,o[i].1Y)}}});1b J};$.fn.PH=1a(1m,fn){K 8y=1j;K v=1m;K vT=2K v;K fT=2K fn;if(vT!="4e"&&(vT!="1a"&&vT!="1D")){1b fT=="1a"?J:8y}J.2h(1a(){if(J.8S.3N()!="2o"){1b J}if(8y&&fT!="1a"){1b 1j}K o=J.1x;K oL=o.1e;1o(K i=0;i<oL;i++){if(v.4U==cY){if(o[i].1m.3e(v)){8y=1n;if(fT=="1a"){fn.2w(o[i],i)}}}1i{if(o[i].1m==v){8y=1n;if(fT=="1a"){fn.2w(o[i],i)}}}}});1b fT=="1a"?J:8y};$.fn.Ju=1a(){K v=[];J.ur().2h(1a(){v[v.1e]=J.1m});1b v};$.fn.PC=1a(){K t=[];J.ur().2h(1a(){t[t.1e]=J.1Y});1b t};$.fn.ur=1a(){1b J.2D("2Q:1Q")}})(2v);(1a($){$.4l($.fn,{kW:1a(c1,c2){K JI=J.4p("."+c1);J.4p("."+c2).4f(c2).2t(c1);JI.4f(c1).2t(c2);1b J},gT:1a(c1,c2){1b J.4p("."+c1).4f(c1).2t(c2).4z()},t7:1a(bO){bO=bO||"6y";1b J.6y(1a(){$(J).2t(bO)},1a(){$(J).4f(bO)})},JE:1a(fg,1Z){fg?J.4K({1y:"cH"},fg,1Z):J.2h(1a(){2v(J)[2v(J).is(":7d")?"59":"3L"]();if(1Z){1Z.3c(J,2q)}})},JH:1a(fg,1Z){if(fg){J.4K({1y:"3L"},fg,1Z)}1i{J.3L();if(1Z){J.2h(1Z)}}},wb:1a(3W){if(!3W.JM){J.4p(":73-PD:5X(ul)").2t(4P.73);J.4p((3W.gm?"":"."+4P.wH)+":5X(."+4P.6Q+")").2D(">ul").3L()}1b J.4p(":3o(>ul)")},wg:1a(3W,kl){if(!3W.JM){J.4p(":3o(>ul:7d)").2t(4P.al).gT(4P.73,4P.hm);J.5X(":3o(>ul:7d)").2t(4P.bm).gT(4P.73,4P.h6);J.i9(\'<2E 2B="\'+4P.4n+\'"/>\').2D("2E."+4P.4n).2h(1a(){K fV="";$.2h($(J).1L().1k("2B").3q(" "),1a(){fV+=J+"-4n "});$(J).2t(fV)})}J.2D("2E."+4P.4n).3J(kl)},hT:1a(3W){3W=$.4l({uL:"hT"},3W);if(3W.54){1b J.2c("54",[3W.54])}if(3W.cH){K 1Z=3W.cH;3W.cH=1a(){1b 1Z.3c($(J).1L()[0],2q)}}1a KD(3Z,2Z){1a 7A(4p){1b 1a(){kl.3c($("2E."+4P.4n,3Z).4p(1a(){1b 4p?$(J).1L("."+4p).1e:1n}));1b 1j}}$("a:eq(0)",2Z).3J(7A(4P.bm));$("a:eq(1)",2Z).3J(7A(4P.al));$("a:eq(2)",2Z).3J(7A())}1a kl(){$(J).1L().2D(">.4n").kW(4P.wE,4P.wz).kW(4P.p0,4P.oZ).4z().kW(4P.bm,4P.al).kW(4P.h6,4P.hm).2D(">ul").JE(3W.fg,3W.cH);if(3W.PE){$(J).1L().Ix().2D(">.4n").gT(4P.wE,4P.wz).gT(4P.p0,4P.oZ).4z().gT(4P.bm,4P.al).gT(4P.h6,4P.hm).2D(">ul").JH(3W.fg,3W.cH)}}1a A1(){1a Qd(4i){1b 4i?1:0}K 1h=[];gS.2h(1a(i,e){1h[i]=$(e).is(":3o(>ul:6K)")?1:0});$.uA(3W.uL,1h.4H(""))}1a KJ(){K uP=$.uA(3W.uL);if(uP){K 1h=uP.3q("");gS.2h(1a(i,e){$(e).2D(">ul")[6p(1h[i])?"59":"3L"]()})}}J.2t("hT");K gS=J.2D("li").wb(3W);3r(3W.Qf){1l"uA":K uG=3W.cH;3W.cH=1a(){A1();if(uG){uG.3c(J,2q)}};KJ();1p;1l"rw":K 5C=J.2D("a").4p(1a(){1b J.5c.3N()==rw.5c.3N()});if(5C.1e){5C.2t("1Q").cD("ul, li").54(5C.3m()).59()}1p}gS.wg(3W,kl);if(3W.2Z){KD(J,3W.2Z);$(3W.2Z).59()}1b J.2C("54",1a(1H,gS){$(gS).3P().4f(4P.73).4f(4P.h6).4f(4P.hm).2D(">.4n").4f(4P.p0).4f(4P.oZ);$(gS).2D("li").vr().wb(3W).wg(3W,kl)})}});K 4P=$.fn.hT.fV={6Q:"6Q",wH:"wH",al:"al",wz:"al-4n",oZ:"hm-4n",bm:"bm",wE:"bm-4n",p0:"h6-4n",h6:"h6",hm:"hm",73:"73",4n:"4n"};$.fn.Qk=$.fn.hT})(2v);(1a($,2O){$.bV.NP="Ql"in 3Q;$.bV.NQ="Qg"in 3Q;$.bV.I2="Q9"in 2N.9S;K $7R=1c,ly=1j,$5j=$(3Q),bP=0,9g={},hf={},k4={},cO={3S:1c,4r:1c,2c:"7M",Is:1j,fo:ff,Kf:1a($1T){if($.ui&&$.ui.2J){$1T.31("5p","7a").2J({my:"v2 1O",at:"v2 4I",of:J,2y:"0 5",lK:"9W"}).31("5p","3p")}1i{K 2y=J.2y();2y.1O+=J.aS();2y.2a+=J.eB()/ 2 - $1T.eB() /2;$1T.31(2y)}},2J:1a(1B,x,y){K $J=J,2y;if(!x&&!y){1B.Kf.2w(J,1B.$1T);1b}1i{if(x==="Ke"&&y==="Ke"){2y=1B.$1T.2J()}1i{K Kj=1B.$2c.cD().vr().4p(1a(){1b $(J).31("2J")=="wA"}).1e;if(Kj){y-=$5j.58();x-=$5j.4S()}2y={1O:y,2a:x}}}K 4I=$5j.58()+$5j.1y(),7M=$5j.4S()+$5j.1r(),1y=1B.$1T.1y(),1r=1B.$1T.1r();if(2y.1O+1y>4I){2y.1O-=1y}if(2y.2a+1r>7M){2y.2a-=1r}1B.$1T.31(2y)},Iw:1a($1T){if($.ui&&$.ui.2J){$1T.31("5p","7a").2J({my:"2a 1O",at:"7M 1O",of:J,lK:"9W"}).31("5p","")}1i{K 2y={1O:0,2a:J.eB()};$1T.31(2y)}},4o:Q0,6O:{6S:0,59:"Q1",3L:"Q2"},4t:{59:$.vR,3L:$.vR},1Z:1c,1F:{}},ae={8N:1c,6R:1c,7i:1c},Iz=1a($t){K oT=0,$tt=$t,z=0;1o(K i=0;i<PX;i++){z=6p($tt.31("z-1P"),10);if(aa(z)){z=0}oT=3D.4y(oT,z);$tt=$tt.1L();if(!$tt||(!$tt.1e||"3X 3U".4Y($tt.6T("8S").3N())>-1)){1p}}1b oT},4M={l3:1a(e){e.4h();e.cN()},5g:1a(e){K $J=$(J);e.4h();e.cN();if(e.1h.2c!="7M"&&e.d1){1b}if(!$J.4E("3l-1T-2x")){$7R=$J;if(e.1h.9A){K vt=e.1h.9A($7R,e);if(vt===1j){1b}e.1h=$.4l(1n,{},cO,e.1h,vt||{});if(!e.1h.1F||$.Jp(e.1h.1F)){if(3Q.cp){(cp.96||cp.j3)("No 1F J5 to 59 in 2L")}9w 1S 9n("No 2P Jn")}e.1h.$2c=$7R;op.7U(e.1h)}op.59.2w($J,e.1h,e.6R,e.7i)}},3J:1a(e){e.4h();e.cN();$(J).2c($.qT("5g",{1h:e.1h,6R:e.6R,7i:e.7i}))},7f:1a(e){K $J=$(J);if($7R&&($7R.1e&&!$7R.is($J))){$7R.1h("2L").$1T.2c("5g:3L")}if(e.3C==2){$7R=$J.1h("vA",1n)}},5u:1a(e){K $J=$(J);if($J.1h("vA")&&($7R&&($7R.1e&&($7R.is($J)&&!$J.4E("3l-1T-2x"))))){e.4h();e.cN();$7R=$J;$J.2c($.qT("5g",{1h:e.1h,6R:e.6R,7i:e.7i}))}$J.tm("vA")},lY:1a(e){K $J=$(J),$jX=$(e.l6),$2N=$(2N);if($jX.is(".3l-1T-4L")||$jX.fB(".3l-1T-4L").1e){1b}if($7R&&$7R.1e){1b}ae.6R=e.6R;ae.7i=e.7i;ae.1h=e.1h;$2N.on("9T.Ks",4M.9T);ae.8N=6x(1a(){ae.8N=1c;$2N.dT("9T.Ks");$7R=$J;$J.2c($.qT("5g",{1h:ae.1h,6R:ae.6R,7i:ae.7i}))},e.1h.fo)},9T:1a(e){ae.6R=e.6R;ae.7i=e.7i},m0:1a(e){K $jX=$(e.l6);if($jX.is(".3l-1T-4L")||$jX.fB(".3l-1T-4L").1e){1b}7n{k1(ae.8N)}7p(e){}ae.8N=1c},J3:1a(e){K $J=$(J),2p=$J.1h("93"),5u=1j,3C=e.3C,x=e.6R,y=e.7i,3k,2y,oU;e.4h();e.cN();$J.on("5u",1a(){5u=1n});6x(1a(){K $3Q,oX;if(2p.2c=="2a"&&3C==0||2p.2c=="7M"&&3C==2){if(2N.p9){2p.$6q.3L();3k=2N.p9(x-$5j.4S(),y-$5j.58());2p.$6q.59();oU=[];1o(K s in 9g){oU.1C(s)}3k=$(3k).fB(oU.4H(", "));if(3k.1e){if(3k.is(2p.$2c[0])){2p.2J.2w(2p.$2c,2p,x,y);1b}}}1i{2y=2p.$2c.2y();$3Q=$(3Q);2y.1O+=$3Q.58();if(2y.1O<=e.7i){2y.2a+=$3Q.4S();if(2y.2a<=e.6R){2y.4I=2y.1O+2p.$2c.aS();if(2y.4I>=e.7i){2y.7M=2y.2a+2p.$2c.eB();if(2y.7M>=e.6R){2p.2J.2w(2p.$2c,2p,x,y);1b}}}}}}oX=1a(e){if(e){e.4h();e.cN()}2p.$1T.2c("5g:3L");if(3k&&3k.1e){6x(1a(){3k.2L({x:x,y:y})},50)}};if(5u){oX()}1i{$J.on("5u",oX)}},50)},f8:1a(e,1B){if(!1B.d7){e.4h()}e.7X()},1q:1a(e){K 1B=$7R.1h("2L")||{},$6w=1B.$1T.6w(),$4G;3r(e.3F){1l 9:;1l 38:4M.f8(e,1B);if(1B.d7){if(e.3F==9&&e.nc){e.4h();1B.$1Q&&1B.$1Q.2D("29, 7W, 2o").4O();1B.$1T.2c("wG");1b}1i{if(e.3F==38&&1B.$1Q.2D("29, 7W, 2o").6T("1w")=="7O"){e.4h();1b}}}1i{if(e.3F!=9||e.nc){1B.$1T.2c("wG");1b}};1l 40:4M.f8(e,1B);if(1B.d7){if(e.3F==9){e.4h();1B.$1Q&&1B.$1Q.2D("29, 7W, 2o").4O();1B.$1T.2c("qY");1b}1i{if(e.3F==40&&1B.$1Q.2D("29, 7W, 2o").6T("1w")=="7O"){e.4h();1b}}}1i{1B.$1T.2c("qY");1b}1p;1l 37:4M.f8(e,1B);if(1B.d7||(!1B.$1Q||!1B.$1Q.1e)){1p}if(!1B.$1Q.1L().4E("3l-1T-2p")){K $1L=1B.$1Q.1L().1L();1B.$1Q.2c("5g:4O");1B.$1Q=$1L;1b}1p;1l 39:4M.f8(e,1B);if(1B.d7||(!1B.$1Q||!1B.$1Q.1e)){1p}K oV=1B.$1Q.1h("2L")||{};if(oV.$1T&&1B.$1Q.4E("3l-1T-vM")){1B.$1Q=1c;oV.$1Q=1c;oV.$1T.2c("qY");1b}1p;1l 35:;1l 36:if(1B.$1Q&&1B.$1Q.2D("29, 7W, 2o").1e){1b}1i{(1B.$1Q&&1B.$1Q.1L()||1B.$1T).6w(":5X(.2x, .5X-jT)")[e.3F==36?"4x":"73"]().2c("5g:2S");e.4h();1b}1p;1l 13:4M.f8(e,1B);if(1B.d7){if(1B.$1Q&&!1B.$1Q.is("7W, 2o")){e.4h();1b}1p}1B.$1Q&&1B.$1Q.2c("5u");1b;1l 32:;1l 33:;1l 34:4M.f8(e,1B);1b;1l 27:4M.f8(e,1B);1B.$1T.2c("5g:3L");1b;5o:K k=5l.xk(e.3F).8w();if(1B.ho[k]){1B.ho[k].$1s.2c(1B.ho[k].$1T?"5g:2S":"5u");1b}1p}e.7X();1B.$1Q&&1B.$1Q.2c(e)},hb:1a(e){e.7X();K 1B=$(J).1h("2L")||{};if(1B.$1Q){K $s=1B.$1Q;1B=1B.$1Q.1L().1h("2L")||{};1B.$1Q=$s}K $6w=1B.$1T.6w(),$3P=!1B.$1Q||!1B.$1Q.3P().1e?$6w.73():1B.$1Q.3P(),$4G=$3P;45($3P.4E("2x")||$3P.4E("5X-jT")){if($3P.3P().1e){$3P=$3P.3P()}1i{$3P=$6w.73()}if($3P.is($4G)){1b}}if(1B.$1Q){4M.ru.2w(1B.$1Q.4u(0),e)}4M.rv.2w($3P.4u(0),e);K $29=$3P.2D("29, 7W, 2o");if($29.1e){$29.2S()}},hp:1a(e){e.7X();K 1B=$(J).1h("2L")||{};if(1B.$1Q){K $s=1B.$1Q;1B=1B.$1Q.1L().1h("2L")||{};1B.$1Q=$s}K $6w=1B.$1T.6w(),$3m=!1B.$1Q||!1B.$1Q.3m().1e?$6w.4x():1B.$1Q.3m(),$4G=$3m;45($3m.4E("2x")||$3m.4E("5X-jT")){if($3m.3m().1e){$3m=$3m.3m()}1i{$3m=$6w.4x()}if($3m.is($4G)){1b}}if(1B.$1Q){4M.ru.2w(1B.$1Q.4u(0),e)}4M.rv.2w($3m.4u(0),e);K $29=$3m.2D("29, 7W, 2o");if($29.1e){$29.2S()}},HR:1a(e){K $J=$(J).fB(".3l-1T-1g"),1h=$J.1h(),1B=1h.2L,2p=1h.93;2p.$1Q=1B.$1Q=$J;2p.d7=1B.d7=1n},I8:1a(e){K $J=$(J).fB(".3l-1T-1g"),1h=$J.1h(),1B=1h.2L,2p=1h.93;2p.d7=1B.d7=1j},ID:1a(e){K 2p=$(J).1h().93;2p.oF=1n},IH:1a(e){K 2p=$(J).1h().93;if(2p.$6q&&2p.$6q.is(e.l6)){2p.oF=1j}},rv:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2L,2p=1h.93;2p.oF=1n;if(e&&(2p.$6q&&2p.$6q.is(e.l6))){e.4h();e.cN()}(1B.$1T?1B:2p).$1T.6w(".6y").2c("5g:4O");if($J.4E("2x")||$J.4E("5X-jT")){1B.$1Q=1c;1b}$J.2c("5g:2S")},ru:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2L,2p=1h.93;if(2p!==1B&&(2p.$6q&&2p.$6q.is(e.l6))){2p.$1Q&&2p.$1Q.2c("5g:4O");e.4h();e.cN();2p.$1Q=1B.$1Q=1B.$1s;1b}$J.2c("5g:4O")},IP:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2L,2p=1h.93,1q=1h.vv,1Z;if(!1B.1F[1q]||($J.4E("2x")||$J.4E("3l-1T-vM"))){1b}e.4h();e.cN();if($.ej(2p.kZ[1q])){1Z=2p.kZ[1q]}1i{if($.ej(2p.1Z)){1Z=2p.1Z}1i{1b}}if(1Z.2w(2p.$2c,1q,2p)!==1j){2p.$1T.2c("5g:3L")}1i{if(2p.$1T.1L().1e){op.7Q.2w(2p.$2c,2p)}}},IZ:1a(e){e.cN()},IJ:1a(e,1h){K 2p=$(J).1h("93");op.3L.2w(2p.$2c,2p,1h&&1h.fa)},N9:1a(e){e.7X();K $J=$(J),1h=$J.1h(),1B=1h.2L,2p=1h.93;$J.2t("6y").Ix(".6y").2c("5g:4O");1B.$1Q=2p.$1Q=$J;if(1B.$1s){2p.Iw.2w(1B.$1s,1B.$1T)}},N0:1a(e){e.7X();K $J=$(J),1h=$J.1h(),1B=1h.2L,2p=1h.93;$J.4f("6y");1B.$1Q=1c}},op={59:1a(1B,x,y){if(2K pZ!="2O"&&pZ){1b}pZ=1n;K $J=$(J),2y,31={};$("#3l-1T-6q").2c("7f");1B.$2c=$J;if(1B.4t.59.2w($J,1B)===1j){$7R=1c;1b}op.7Q.2w($J,1B);1B.2J.2w($J,1B,x,y);if(1B.4o){31.4o=Iz($J)+1B.4o}op.6q.2w(1B.$1T,1B,31.4o);1B.$1T.2D("ul").31("4o",31.4o+1);1B.$1T.31(31)[1B.6O.59](1B.6O.6S);$J.1h("2L",1B);$(2N).dT("7V.2L").on("7V.2L",4M.1q);if(1B.Is){K 3V=$J.2J();3V.7M=3V.2a+$J.eB();3V.4I=3V.1O+J.aS();$(2N).on("9T.ws",1a(e){if(1B.$6q&&(!1B.oF&&(!(e.6R>=3V.2a&&e.6R<=3V.7M)||!(e.7i>=3V.1O&&e.7i<=3V.4I)))){1B.$1T.2c("5g:3L")}})}},3L:1a(1B,fa){K $J=$(J);if(!1B){1B=$J.1h("2L")||{}}if(!fa&&(1B.4t&&1B.4t.3L.2w($J,1B)===1j)){1b}if(1B.$6q){6x(1a($6q){1b 1a(){$6q.3u()}}(1B.$6q),10);7n{42 1B.$6q}7p(e){1B.$6q=1c}}$7R=1c;1B.$1T.2D(".6y").2c("5g:4O");1B.$1Q=1c;$(2N).dT(".ws").dT("7V.2L");1B.$1T&&1B.$1T[1B.6O.3L](1B.6O.6S,1a(){if(1B.9A){1B.$1T.3u();$.2h(1B,1a(1q,1m){3r(1q){1l"ns":;1l"3S":;1l"9A":;1l"2c":1b 1n;5o:1B[1q]=2O;7n{42 1B[1q]}7p(e){}1b 1n}})}});pZ=1j},7U:1a(1B,2p){if(2p===2O){2p=1B}1B.$1T=$(\'<ul 2B="3l-1T-4L \'+(1B.bO||"")+\'"></ul>\').1h({"2L":1B,"93":2p});$.2h(["kZ","r9","rr"],1a(i,k){1B[k]={};if(!2p[k]){2p[k]={}}});2p.ho||(2p.ho={});$.2h(1B.1F,1a(1q,1g){K $t=$(\'<li 2B="3l-1T-1g \'+(1g.bO||"")+\'"></li>\'),$3y=1c,$29=1c;1g.$1s=$t.1h({"2L":1B,"93":2p,"vv":1q});if(1g.w1){K HW=J6(1g.w1);1o(K i=0,ak;ak=HW[i];i++){if(!2p.ho[ak]){2p.ho[ak]=1g;1g.qO=1g.1z.3g(1S cY("("+ak+")","i"),\'<2F 2B="3l-1T-w1">$1</2F>\');1p}}}if(2K 1g=="4e"){$t.2t("3l-1T-5n 5X-jT")}1i{if(1g.1w&&k4[1g.1w]){k4[1g.1w].2w($t,1g,1B,2p);$.2h([1B,2p],1a(i,k){k.r9[1q]=1g;if($.ej(1g.1Z)){k.kZ[1q]=1g.1Z}})}1i{if(1g.1w=="3X"){$t.2t("3l-1T-3X 5X-jT")}1i{if(1g.1w){$3y=$("<3y></3y>").4r($t);$("<2F></2F>").3X(1g.qO||1g.1z).4r($3y);$t.2t("3l-1T-29");1B.I7=1n;$.2h([1B,2p],1a(i,k){k.r9[1q]=1g;k.rr[1q]=1g})}1i{if(1g.1F){1g.1w="k9"}}}3r(1g.1w){1l"1Y":$29=$(\'<29 1w="1Y" 1m="1" 1z="3l-1T-29-\'+1q+\'" 1m="">\').2g(1g.1m||"").4r($3y);1p;1l"7W":$29=$(\'<7W 1z="3l-1T-29-\'+1q+\'"></7W>\').2g(1g.1m||"").4r($3y);if(1g.1y){$29.1y(1g.1y)}1p;1l"7O":$29=$(\'<29 1w="7O" 1m="1" 1z="3l-1T-29-\'+1q+\'" 1m="">\').2g(1g.1m||"").6T("3B",!!1g.1Q).A6($3y);1p;1l"8x":$29=$(\'<29 1w="8x" 1m="1" 1z="3l-1T-29-\'+1g.8x+\'" 1m="">\').2g(1g.1m||"").6T("3B",!!1g.1Q).A6($3y);1p;1l"2o":$29=$(\'<2o 1z="3l-1T-29-\'+1q+\'">\').4r($3y);if(1g.1x){$.2h(1g.1x,1a(1m,1Y){$("<2Q></2Q>").2g(1m).1Y(1Y).4r($29)});$29.2g(1g.1Q)}1p;1l"k9":$("<2F></2F>").3X(1g.qO||1g.1z).4r($t);1g.4r=1g.$1s;op.7U(1g,2p);$t.1h("2L",1g).2t("3l-1T-vM");1g.1Z=1c;1p;1l"3X":$(1g.3X).4r($t);1p;5o:$.2h([1B,2p],1a(i,k){k.r9[1q]=1g;if($.ej(1g.1Z)){k.kZ[1q]=1g.1Z}});$("<2F></2F>").3X(1g.qO||(1g.1z||"")).4r($t);1p}if(1g.1w&&(1g.1w!="k9"&&1g.1w!="3X")){$29.on("2S",4M.HR).on("4O",4M.I8);if(1g.4t){$29.on(1g.4t,1B)}}if(1g.3K){$t.2t("3K 3K-"+1g.3K)}}}1g.$29=$29;1g.$3y=$3y;$t.4r(1B.$1T);if(!1B.I7&&$.bV.I2){$t.on("Q5.Pv",4M.l3)}});if(!1B.$1s){1B.$1T.31("5p","3p").2t("3l-1T-2p")}1B.$1T.4r(1B.4r||2N.3U)},7Q:1a(1B,2p){K $J=J;if(2p===2O){2p=1B;1B.$1T.2D("ul").vr().31({2J:"wx",5p:"7a"}).2h(1a(){K $J=$(J);$J.1r($J.31("2J","8t").1r()).31("2J","wx")}).31({2J:"",5p:""})}1B.$1T.6w().2h(1a(){K $1g=$(J),1q=$1g.1h("vv"),1g=1B.1F[1q],2x=$.ej(1g.2x)&&1g.2x.2w($J,1q,2p)||1g.2x===1n;$1g[2x?"2t":"4f"]("2x");if(1g.1w){$1g.2D("29, 2o, 7W").6T("2x",2x);3r(1g.1w){1l"1Y":;1l"7W":1g.$29.2g(1g.1m||"");1p;1l"7O":;1l"8x":1g.$29.2g(1g.1m||"").6T("3B",!!1g.1Q);1p;1l"2o":1g.$29.2g(1g.1Q||"");1p}}if(1g.$1T){op.7Q.2w($J,1g,2p)}})},6q:1a(1B,4o){$l=$("#3l-1T-6q");if($l){$l.3u()}K $6q=1B.$6q=$(\'<2E id="3l-1T-6q" 3b="2J:wA; z-1P:\'+4o+\'; 1O:0; 2a:0; 2G: 0; 4p: d9(2G=0); ia-3t: #cm;"></2E>\').31({1y:$5j.1y(),1r:$5j.1r(),5p:"7a"}).1h("93",1B).6Y(J).on("5g",4M.l3).on("7f",4M.J3);if(!$.bV.OY){$6q.31({"2J":"8t","1y":$(2N).1y()})}1b $6q}};1a J6(2g){K t=2g.3q(/\\s+/),81=[];1o(K i=0,k;k=t[i];i++){k=k[0].8w();81.1C(k)}1b 81}$.fn.2L=1a(7T){if(7T===2O){J.4x().2c("5g")}1i{if(7T.x&&7T.y){J.4x().2c($.qT("5g",{6R:7T.x,7i:7T.y}))}1i{if(7T==="3L"){K $1T=J.1h("2L").$1T;$1T&&$1T.2c("5g:3L")}1i{if(7T==="1f"){if(J.1h("2L")!=1c){1b J.1h("2L").$1T}1b[]}1i{if(7T){J.4f("3l-1T-2x")}1i{if(!7T){J.2t("3l-1T-2x")}}}}}}1b J};$.2L=1a(7T,1x){if(2K 7T!="4e"){1x=7T;7T="7U"}if(2K 1x=="4e"){1x={3S:1x}}1i{if(1x===2O){1x={}}}K o=$.4l(1n,{},cO,1x||{}),$2N=$(2N);3r(7T){1l"7U":if(!o.3S){9w 1S 9n("No 3S J5")}if(o.3S.3e(/.3l-1T-(4L|1g|29)($|\\s)/)){9w 1S 9n(\'OZ 2C to 3S "\'+o.3S+\'" as it hd a OU bO\')}if(!o.9A&&(!o.1F||$.Jp(o.1F))){9w 1S 9n("No 2P Jn")}bP++;o.ns=".2L"+bP;9g[o.3S]=o.ns;hf[o.ns]=o;if(!o.2c){o.2c="7M"}if(!ly){$2N.on({"5g:3L.2L":4M.IJ,"wG.2L":4M.hb,"qY.2L":4M.hp,"5g.2L":4M.l3,"lY.2L":4M.ID,"m0.2L":4M.IH},".3l-1T-4L").on("5u.2L",".3l-1T-29",4M.IZ).on({"5u.2L":4M.IP,"5g:2S.2L":4M.N9,"5g:4O.2L":4M.N0,"5g.2L":4M.l3,"lY.2L":4M.rv,"m0.2L":4M.ru},".3l-1T-1g");ly=1n}$2N.on("5g"+o.ns,o.3S,o,4M.5g);3r(o.2c){1l"6y":$2N.on("lY"+o.ns,o.3S,o,4M.lY).on("m0"+o.ns,o.3S,o,4M.m0);1p;1l"2a":$2N.on("3J"+o.ns,o.3S,o,4M.3J);1p}if(!o.9A){op.7U(o)}1p;1l"6d":if(!o.3S){$2N.dT(".2L .ws");$.2h(9g,1a(1q,1m){$2N.dT(1m)});9g={};hf={};bP=0;ly=1j;$("#3l-1T-6q, .3l-1T-4L").3u()}1i{if(9g[o.3S]){K $rE=$(".3l-1T-4L").4p(":6K");if($rE.1e&&$rE.1h().93.$2c.is(o.3S)){$rE.2c("5g:3L",{fa:1n})}7n{if(hf[9g[o.3S]].$1T){hf[9g[o.3S]].$1T.3u()}42 hf[9g[o.3S]]}7p(e){hf[9g[o.3S]]=1c}$2N.dT(9g[o.3S])}}1p;1l"OJ":if(!$.bV.NQ&&!$.bV.NP||2K 1x=="lS"&&1x){$(\'1T[1w="3l"]\').2h(1a(){if(J.id){$.2L({3S:"[5g="+J.id+"]",1F:$.2L.Lz(J)})}}).31("5p","3p")}1p;5o:9w 1S 9n(\'f3 7T "\'+7T+\'"\')}1b J};$.2L.OH=1a(1B,1h){if(1h===2O){1h={}}$.2h(1B.rr,1a(1q,1g){3r(1g.1w){1l"1Y":;1l"7W":1g.1m=1h[1q]||"";1p;1l"7O":1g.1Q=1h[1q]?1n:1j;1p;1l"8x":1g.1Q=(1h[1g.8x]||"")==1g.1m?1n:1j;1p;1l"2o":1g.1Q=1h[1q]||"";1p}})};$.2L.OQ=1a(1B,1h){if(1h===2O){1h={}}$.2h(1B.rr,1a(1q,1g){3r(1g.1w){1l"1Y":;1l"7W":;1l"2o":1h[1q]=1g.$29.2g();1p;1l"7O":1h[1q]=1g.$29.6T("3B");1p;1l"8x":if(1g.$29.6T("3B")){1h[1g.8x]=1g.1m}1p}});1b 1h};1a i7(1s){1b 1s.id&&$(\'3y[1o="\'+1s.id+\'"]\').2g()||1s.1z}1a uX(1F,$6w,bP){if(!bP){bP=0}$6w.2h(1a(){K $1s=$(J),1s=J,8S=J.8S.3N(),3y,1g;if(8S=="3y"&&$1s.2D("29, 7W, 2o").1e){3y=$1s.1Y();$1s=$1s.6w().4x();1s=$1s.4u(0);8S=1s.8S.3N()}3r(8S){1l"1T":1g={1z:$1s.1k("3y"),1F:{}};bP=uX(1g.1F,$1s.6w(),bP);1p;1l"a":;1l"3C":1g={1z:$1s.1Y(),2x:!!$1s.1k("2x"),1Z:1a(){1b 1a(){$1s.3J()}}()};1p;1l"ND":;1l"83":3r($1s.1k("1w")){1l 2O:;1l"83":;1l"ND":1g={1z:$1s.1k("3y"),2x:!!$1s.1k("2x"),1Z:1a(){1b 1a(){$1s.3J()}}()};1p;1l"7O":1g={1w:"7O",2x:!!$1s.1k("2x"),1z:$1s.1k("3y"),1Q:!!$1s.1k("3B")};1p;1l"8x":1g={1w:"8x",2x:!!$1s.1k("2x"),1z:$1s.1k("3y"),8x:$1s.1k("Pj"),1m:$1s.1k("id"),1Q:!!$1s.1k("3B")};1p;5o:1g=2O}1p;1l"hr":1g="-------";1p;1l"29":3r($1s.1k("1w")){1l"1Y":1g={1w:"1Y",1z:3y||i7(1s),2x:!!$1s.1k("2x"),1m:$1s.2g()};1p;1l"7O":1g={1w:"7O",1z:3y||i7(1s),2x:!!$1s.1k("2x"),1Q:!!$1s.1k("3B")};1p;1l"8x":1g={1w:"8x",1z:3y||i7(1s),2x:!!$1s.1k("2x"),8x:!!$1s.1k("1z"),1m:$1s.2g(),1Q:!!$1s.1k("3B")};1p;5o:1g=2O;1p}1p;1l"2o":1g={1w:"2o",1z:3y||i7(1s),2x:!!$1s.1k("2x"),1Q:$1s.2g(),1x:{}};$1s.6w().2h(1a(){1g.1x[J.1m]=$(J).1Y()});1p;1l"7W":1g={1w:"7W",1z:3y||i7(1s),2x:!!$1s.1k("2x"),1m:$1s.2g()};1p;1l"3y":1p;5o:1g={1w:"3X",3X:$1s.5R(1n)};1p}if(1g){bP++;1F["1q"+bP]=1g}});1b bP}$.2L.Lz=1a(1f){K $J=$(1f),1F={};uX(1F,$J.6w());1b 1F};$.2L.cO=cO;$.2L.k4=k4})(2v);K L3=1a(id){J.id=id;J.1f=1c;J.2H=1S 43;J.lV=0;J.uW=20;J.uM=1a(2H){42 J.2H;J.2H=1S 43;K li=1S 43;1o(K i=0;i<2H.1e;i++){K 1m=2H[i];li.1C(\'<li 1m="\'+i+\'" 2B="\'+1m.dg+\'">\'+1m.1Y+"</li>");J.2H.1C(1m.1m)}J.1f.3X("<ul>"+li.4H("\\n")+"</ul>");K me=J;J.1f.4N("5u",1a(e){K li=e.3k;if(li.6c.8w()!="LI"){1b}K $li=$(e.3k);e.7X();J.q0.q3($li.1Y(),me.q0.iC(li.1m))},J).4N("7f",1a(e){e.7X()},J);J.Lu();J.qo(10)};J.Lu=1a(){J.1f.31("gq","7d");J.1f.59();K 9u=J.1f.2D("li");if(9u.1e>0){J.uW=9u[0].ba}J.1f.31("gq","6K");J.1f.3L()};J.qo=1a(ma){if(J.1f.2D("li").1e>ma){J.lV=J.uW*ma;J.1f.31("1y",J.lV+"px");J.1f.31("ga","6l")}1i{J.1f.31("1y","6l");J.1f.31("ga","6K")}};J.iC=1a(1P){1b J.2H[1P]};J.Ls=1a(){J.1f.2D("li").4f("3e")};J.z7=1a(1Y){K bt=iv(1Y);J.Ls();K 8I=J.re(bt);$(8I).2t("3e");if(8I.1e>0){J.rf($(8I[0]))}1i{J.v8()}};J.LG=1a(1Y){K bt=iv(1Y);K 8I=J.re(bt);K 5C=J.iX();if(5C.1e>0&&8I.1e>1){K 1P=8I.4Y(5C[0]);if(1P<8I.1e-1){1b $(8I[1P+1])}1i{1b $(8I[0])}}1b 1c};J.LC=1a(1Y){K bt=iv(1Y);K 8I=J.re(bt);K 5C=J.iX();if(5C.1e>0&&8I.1e>1){K 1P=8I.4Y(5C[0]);if(1P>0){1b $(8I[1P-1])}1i{1b $(8I[8I.1e-1])}}1b 1c};J.re=1a(1Y){K 1J=[];if(1K(1Y)){1b 1J}K bW=1Y.3g(/([$-/:-?{-~!"^1U`\\[\\]\\\\])/g, "\\\\$1");K 9u=J.1f.2D("li");1o(K i=0;i<9u.1e;i++){K li=9u[i];K uU=iv(!1K(li.LJ)?li.LJ:li.Ps);K v7=iv(J.iC(li.1m));if(QB.1d.2W.t6){bW="(^"+1Y+")|([.]"+1Y+")"}if(1Y==uU||1Y==v7){1J.1C(li)}1i{if(uU.9V(bW)||v7.9V(bW)){1J.1C(li)}}}1b 1J};J.uJ=1a(){J.1f.2D("li.1Q").4f("1Q")};J.uH=1a(1Y,cB,fN){K li=J.iX();if(!li.1e){li=J.v8()}K e4=1c;if(cB=="dE"){if(fN){e4=J.LG(1Y)}if(e4==1c){e4=li.3m()}}1i{if(cB=="up"){if(fN){e4=J.LC(1Y)}if(e4==1c){e4=li.3P()}}}if(e4!=1c){J.rf(e4);J.L8(li)}};J.rf=1a(li){J.uJ();li.2t("1Q");J.La(li)};J.v8=1a(){K 4x=J.1f.2D("li:4x");J.rf(4x);1b 4x};J.L8=1a(ih){ih.4f("1Q")};J.iX=1a(){1b J.1f.2D("li.1Q")};J.La=1a(ih){if(J.lV&&(ih!=1c&&ih.1e>0)){J.1f.58(ih[0].9h-J.lV/2)}};J.80=1a(){J.1f=$(\'<2E 2B="bC-2o-1x"></2E>\').4r($(2N.3U))};J.80()};K 9x={rn:{},bF:[],o9:{},uY:1j,3l:1c,80:1a(){J.L1();J.uY=1n},L1:1a(){},uz:1a(9C){if(1K(9C)||1K(J.rn[9C])){J.rn[9C]=1S L3(9C)}1b J.rn[9C]},zR:1a(id,2H){J.uz(id).uM(2H)}};(1a($){$.fn.zk=1a(1x){if(!9x.uY){9x.80()}K me=J;K cO={8D:1j,fM:1n,ma:10,Pr:1j};K 3W=$.4l(cO,1x);K rl=1j;$(J).2h(1a(i,vq){K 1f=$(vq);if(1f.1h("bC-h0")==2O){9x.bF.1C(1S vg(vq,3W));1f.1h("bC-h0",9x.bF.1e-1)}});1b $(J)};$.fn.zj=1a(){K 7S=[];$(J).2h(1a(){if($(J).1h("bC-h0")!==2O){7S[7S.1e]=9x.bF[$(J).1h("bC-h0")]}});1b 7S};K vg=1a(2o,3W){J.80(2o,3W)};vg.2T={i3:1j,3W:1j,5D:1j,2o:1j,5T:1j,9C:1c,gW:1j,Pa:1j,8D:1j,P6:13,bt:"",P7:[],fN:1j,Mk:1j,80:1a(2o,3W){J.3W=3W;J.9C=J.3W.9C;J.5T=9x.uz(J.9C);J.7A=J.3W.fM;if(!1K(J.9C)){9x.o9[J.9C]=J.3W.fM}J.1x=[];if(!1K(J.3W.1x)){J.1x=J.3W.1x}J.2o=$(2o);J.5D=$(\'<29 1w="1Y">\');J.5D.1k("5w-3y",J.2o.1k("5w-3y"));J.5D.2g(J.3W.1m);J.5D.1k("1z",J.2o.1k("1z"));J.5D.1h("bC-h0",J.2o.1h("bC-h0"));J.2o.1k("2x","2x");K id=J.2o.1k("id");if(!id){id="bC-2o"+9x.bF.1e}J.id=id;J.5D.1k("id",id);J.5D.1k("Pf","dT");J.5D.2t("bC-2o");J.2o.1k("id",id+"Pg");J.Mx(J.5D,J);J.Lh();J.M3();J.M7();if(J.3W.8D){K 8D=$(\'<cX Ph="0" 2B="bC-2o-cX" 4b="EJ:yH;"></cX>\');$(2N.3U).3a(8D);8D.1r(J.2o.1r()+2);8D.1y(J.5T.1f.1y());8D.31({1O:J.5T.1f.31("1O"),2a:J.5T.1f.31("2a")});J.8D=8D}},Lh:1a(){K me=J;K Qm=1j;K 2H=1S 43;J.2o.2D("2Q").2h(1a(1P,2Q){K $2Q=$(2Q);K 1Y=$2Q.1Y();K 2g=$2Q.1k("1m");K 1Q=1j;if($2Q.1k("1Q")||2Q.1Q){me.5D.2g(1Y);me.bt=1Y;me.LX=2g;1Q=1n}K dg=$2Q.1k("2B");2H.1C({1Q:1Q,1Y:1Y,1m:2g,dg:dg})});if(2H.1e>0){J.5T.uM(2H);J.5T.1f.2t("te-H0");J.5T.qo(J.3W.ma)}},zo:1a(){1b J.5D},fM:1a(){K 3l=J.5T.q0;if(2K 3l.7A=="1a"){3l.7A.2w(3l,3l.5D)}},uB:1a(){if(J.i3){1b}J.i3=1n;J.bt=J.5D.2g();J.fN=1j;J.zg(J);if(J.Mk){J.m8()}},iS:1a(){if(!J.i3){1b}J.5T.uJ();J.qC();J.fM();J.i3=1j},Mu:1a(Rt){if(J.5D.2g()!=J.bt){J.fN=1n;J.bt=J.5D.2g();J.5T.z7(J.5D.2g())}},Mx:1a(5D,Ru){K me=J;K 8N=1j;5D.2S(1a(e){me.uB()}).4O(1a(e){if(!me.gW){me.iS()}}).3J(1a(e){e.7X();me.uB();if(e.6R-$(J).2y().2a>$(J).1r()-16){if(me.gW){me.qC()}1i{me.m8()}}}).7V(1a(e){me.i3=1n;3r(e.3F){1l 40:if(!me.zd()){me.m8()}1i{e.4h();me.5T.uH(me.5D.2g(),"dE",me.fN)}1p;1l 38:if(!me.zd()){me.m8()}1i{e.4h();me.5T.uH(me.5D.2g(),"up",me.fN)}1p;1l 9:K $li=me.5T.iX();if($li.1e){me.q3($li.1Y(),me.iC($li[0].1m))}1p;1l 27:e.4h();me.iS();1b 1j;1p;1l 13:e.4h();if(!me.gW){me.iS()}1i{K $li=me.5T.iX();if($li.1e){me.q3($li.1Y(),me.iC($li[0].1m))}}1b 1j;1p}}).w8($.gQ(me.Mu,100,me)).gN(1a(e){if(e.3F==13){e.4h();1b 1j}})},q3:1a(1Y,2g){J.bt=1Y;J.LX=2g;J.5D.2g(2g);J.iS()},zd:1a(){1b J.gW},zg:1a(3l){J.LS();J.LO();9x.3l=3l;J.5T.q0=3l},LS:1a(){K 2y=J.5D.2y();2y.1O+=J.5D[0].ba;J.5T.1f.31({1O:2y.1O+"px",2a:2y.2a+"px"})},LO:1a(){K 1r=J.5D[0].kP;J.5T.1f.1r(1r);J.5D.1r(1r)},m8:1a(){J.M9();J.7C=1S $.ui.ds.7C(J);J.5T.1f.59();J.zg(J);J.gW=1n;if(J.3W.8D){J.8D.59()}J.5T.qo(10);J.5T.z7(J.5D.2g())},iC:1a(1P){1b J.5T.2H[1P]},qC:1a(){if(J.7C!=1c){J.7C.6d()}J.5T.1f.3L();J.gW=1j;if(J.3W.8D){J.8D.3L()}},M9:1a(){1o(K i=0;i<9x.bF.1e;i++){if(i!=J.2o.1h("bC-h0")){9x.bF[i].qC()}}},M3:1a(){J.2o.uh(J.5D);J.2o.3L();$(2N.3U).3a(J.5T.1f)},M7:1a(){K 1r=J.2o.1r()+2*0;if(J.8D){J.8D.1r(1r+4)}}};$.ui.ds={7C:1a(3j){J.$el=$.ui.ds.7C.7U(3j)}};$.4l($.ui.ds.7C,{2n:J,bF:[],RB:[],mv:BB,4t:$.eQ("2S,7f,7V,gN".3q(","),1a(1H){1b 1H+".3j-7C"}).4H(" "),7U:1a(3j){if(J.bF.1e===0){$(3Q).2C("79.3j-7C",$.ui.ds.7C.79)}K $el=$(\'<2E 2B="bC-2o-1x-7C"></2E>\').4r(3j.5D.1L()).31({1r:J.1r(),1y:J.1y()});$el.2C("7f.3j-7C",1a(1H){3j.iS();K 1f=2N.p9(1H.aj,1H.ap);if(1f!=1c){7n{K c0="3J";if(1f.zu){K e=2N.CR("Ry");e.De(c0,1n,1n,3Q,0,1H.D9,1H.Cj,1H.aj,1H.ap,1j,1j,1j,1j,0,1c);1f.zu(e)}1i{if(1f.Cz){1f.Cz("on"+c0)}}}7p(Rg){}}});if($.fn.eu){$el.eu()}J.bF.1C($el);1b $el},6d:1a($el){if($el!=1c){$el.3u()}if(J.bF.1e===0){$([2N,3Q]).7Y(".3j-7C")}},1y:1a(){K sz,ba;1b $(2N).1y()+"px"},1r:1a(){K AV,f6;1b $(2N).1r()+"px"},79:1a(){K $qv=$([]);$.2h($.ui.ds.7C.bF,1a(){$qv=$qv.54(J)});$qv.31({1r:0,1y:0}).31({1r:$.ui.ds.7C.1r(),1y:$.ui.ds.7C.1y()})}});$.4l($.ui.ds.7C.2T,{6d:1a(){$.ui.ds.7C.6d(J.$el)}})})(2v);(1a($){K R=$.jR=$.fn.jR=1a(a,b,c){1b R.yO(lA.3c(J,2q))};1a lA(a,b,c){K r=$.4l({},R);if(2K a=="4e"){r.5e=a;if(b&&!$.ej(b)){r.et=b}1i{c=b}if(c){r.Aw=c}}1i{$.4l(r,a)}if(!r.44){r.44=$.Du?"Rh":"Br"}if(!r.3k){r.3k=J?J:$}if(!r.1w&&!$.Du){r.1w="Re"}1b r}$.4l(R,{5M:"0.5",5e:1c,et:Rf,Aw:1c,44:1c,yO:1a(r){if(r.iA){r.iA()}r.id=lO(1a(){r.jR(r)},r.et*8W);r.iA=1a(){qB(r.id);1b r};1b r},jR:1a(r){if(r.yM){42 r.yM}r.yM=r.3k[r.44](r)}})})(2v);2v.4d={b9:1c,9R:1c,qs:1c,qI:0,9A:1a(1x){J.2h(1a(){J.b8=2v.4l({El:1c,Ef:1c,kw:"Rk",tf:1c,lQ:1c,lH:5,A4:/[^\\-]*$/,Rl:1c,na:1c},1x||{});2v.4d.yP(J)});2v(2N).2C("9T",2v.4d.9T).2C("5u",2v.4d.5u);1b J},yP:1a(1M){K 6B=1M.b8;if(1M.b8.na){$(2N).on("7f","#qb-ui-3R td."+1M.b8.na,1a(ev){2v.4d.9R=J.3n;2v.4d.b9=1M;2v.4d.qs=2v.4d.yI(J,ev);if(6B.lQ){6B.lQ(1M,J)}1b 1j})}1i{K 2V=2v("tr",1M);$(2N).on("7f","#qb-ui-3R 1M td."+1M.b8.na,1a(ev){if(ev.3k.6c=="TD"){2v.4d.9R=J;2v.4d.b9=1M;2v.4d.qs=2v.4d.yI(J,ev);if(6B.lQ){6B.lQ(1M,J)}1b 1j}})}},Ci:1a(){J.2h(1a(){if(J.b8){2v.4d.yP(J)}})},z5:1a(ev){if(ev.6R||ev.7i){1b{x:ev.6R,y:ev.7i}}1b{x:ev.aj+2N.3U.4S-2N.3U.hV,y:ev.ap+2N.3U.58-2N.3U.hZ}},yI:1a(3k,ev){ev=ev||3Q.1H;K yG=J.q2(3k);K hv=J.z5(ev);1b{x:hv.x-yG.x,y:hv.y-yG.y}},q2:1a(e){K 2a=0;K 1O=0;if(e.ba==0){e=e.7E}45(e.dX){2a+=e.8p;1O+=e.9h;e=e.dX}2a+=e.8p;1O+=e.9h;1b{x:2a,y:1O}},9T:1a(ev){if(2v.4d.9R==1c){1b}K qE=2v(2v.4d.9R);K 6B=2v.4d.b9.b8;K hv=2v.4d.z5(ev);K y=hv.y-2v.4d.qs.y;K lI=3Q.Fh;if(2N.6o){if(2K 2N.Dm!="2O"&&2N.Dm!="RQ"){lI=2N.9S.58}1i{if(2K 2N.3U!="2O"){lI=2N.3U.58}}}if(hv.y-lI<6B.lH){3Q.wm(0,-6B.lH)}1i{K DD=3Q.DE?3Q.DE:2N.9S.oC?2N.9S.oC:2N.3U.oC;if(DD-(hv.y-lI)<6B.lH){3Q.wm(0,6B.lH)}}if(y!=2v.4d.qI){K yV=y>2v.4d.qI;2v.4d.qI=y;if(6B.kw){qE.2t(6B.kw)}1i{qE.31(6B.El)}K hA=2v.4d.E6(qE,y);if(hA&&hA.bO!="ui-qb-3R-1I-8a"){if(yV&&2v.4d.9R!=hA){2v.4d.9R.3n.6Y(2v.4d.9R,hA.iI)}1i{if(!yV&&2v.4d.9R!=hA){2v.4d.9R.3n.6Y(2v.4d.9R,hA)}}}}1b 1j},E6:1a(yW,y){K 2V=2v.4d.b9.2V;1o(K i=0;i<2V.1e;i++){K 1I=2V[i];K qc=J.q2(1I).y;K qd=6p(1I.ba)/2;if(1I.ba==0){qc=J.q2(1I.7E).y;qd=6p(1I.7E.ba)/2}if(y>qc-qd&&y<qc+qd){if(1I==yW){1b 1c}K 6B=2v.4d.b9.b8;if(6B.E2){if(6B.E2(yW,1I)){1b 1I}1i{1b 1c}}1i{K A2=2v(1I).4E("A2");if(!A2){1b 1I}1i{1b 1c}}1b 1I}}1b 1c},5u:1a(e){if(2v.4d.b9&&2v.4d.9R){K ro=2v.4d.9R;K 6B=2v.4d.b9.b8;if(6B.kw){2v(ro).4f(6B.kw)}1i{2v(ro).31(6B.Ef)}2v.4d.9R=1c;if(6B.tf){6B.tf(2v.4d.b9,ro)}2v.4d.b9=1c}},A1:1a(){if(2v.4d.b9){1b 2v.4d.A3(2v.4d.b9)}1i{1b"9n: No cb id 5v, CW CA to 5v an id on FM 1M o8 A5 1I"}},A3:1a(1M){K 1J="";K CI=1M.id;K 2V=1M.2V;1o(K i=0;i<2V.1e;i++){if(1J.1e>0){1J+="&"}K iU=2V[i].id;if(iU&&(iU&&(1M.b8&&1M.b8.A4))){iU=iU.3e(1M.b8.A4)[0]}1J+=CI+"[]="+iU}1b 1J},D8:1a(){K 1J="";J.2h(1a(){1J+=2v.4d.A3(J)});1b 1J}};2v.fn.4l({4d:2v.4d.9A,RD:2v.4d.Ci,RM:2v.4d.D8});(1a($){$.8M("ui.3i",{1x:{4r:"3U",Hj:8W,3b:"hB",EQ:1c,1r:1c,kr:1c,HD:26,9i:1c,bJ:1c,6v:1c,Fc:1j,kv:1a(){}},tg:1a(){K 2n=J,o=J.1x;K rh=J.1f.RI().1k("id");J.cV=[rh,rh+"-3C",rh+"-1T"];J.oO=1n;J.ib=1j;J.6e=$("<a />",{"2B":"ui-3i ui-8M ui-4Z-5o ui-9Z-6o","id":J.cV[1],"h9":"3C","5c":"#zO","69":J.1f.1k("2x")?1:0,"5w-QE":1n,"5w-QF":J.cV[2]});J.xw=$("<2F />").3a(J.6e).e7(J.1f);K 69=J.1f.1k("69");if(69){J.6e.1k("69",69)}J.6e.1h("Hh",J.1f);J.HJ=$(\'<2F 2B="ui-3i-3K ui-3K"></2F>\').A6(J.6e);J.6e.i9(\'<2F 2B="ui-3i-6G" />\');J.1f.2C({"3J.3i":1a(1H){2n.6e.2S();1H.4h()}});J.6e.2C("7f.3i",1a(1H){2n.xm(1H,1n);if(o.3b=="jS"){2n.oO=1j;6x(1a(){2n.oO=1n},t9)}1H.4h()}).2C("3J.3i",1a(1H){1H.4h()}).2C("7V.3i",1a(1H){K 7S=1j;3r(1H.3F){1l $.ui.3F.GD:7S=1n;1p;1l $.ui.3F.GV:2n.xm(1H);1p;1l $.ui.3F.UP:if(1H.rz){2n.6Q(1H)}1i{2n.jv(-1)}1p;1l $.ui.3F.CL:if(1H.rz){2n.6Q(1H)}1i{2n.jv(1)}1p;1l $.ui.3F.CK:2n.jv(-1);1p;1l $.ui.3F.CS:2n.jv(1);1p;1l $.ui.3F.GY:7S=1n;1p;1l $.ui.3F.Di:;1l $.ui.3F.CU:2n.1P(0);1p;1l $.ui.3F.EC:;1l $.ui.3F.GF:2n.1P(2n.86.1e);1p;5o:7S=1n}1b 7S}).2C("gN.3i",1a(1H){if(1H.iK>0){2n.zM(1H.iK,"5u")}1b 1n}).2C("hL.3i",1a(){if(!o.2x){$(J).2t("ui-4Z-6y")}}).2C("ea.3i",1a(){if(!o.2x){$(J).4f("ui-4Z-6y")}}).2C("2S.3i",1a(){if(!o.2x){$(J).2t("ui-4Z-2S")}}).2C("4O.3i",1a(){if(!o.2x){$(J).4f("ui-4Z-2S")}});$(2N).2C("7f.3i-"+J.cV[0],1a(1H){if(2n.ib&&!$(1H.3k).fB("#"+2n.cV[1]).1e){2n.5s(1H)}});J.1f.2C("3J.3i",1a(){2n.nZ()}).2C("2S.3i",1a(){if(2n.6e){2n.6e[0].2S()}});if(!o.1r){o.1r=J.1f.eB()}J.6e.1r(o.1r);J.1f.3L();J.4L=$("<ul />",{"2B":"ui-8M ui-8M-a8","5w-7d":1n,"h9":"QG","5w-QA":J.cV[1],"id":J.cV[2]});J.hu=$("<2E />",{"2B":"ui-3i-1T"}).3a(J.4L).4r(o.4r);J.4L.2C("7V.3i",1a(1H){K 7S=1j;3r(1H.3F){1l $.ui.3F.UP:if(1H.rz){2n.5s(1H,1n)}1i{2n.eI(-1)}1p;1l $.ui.3F.CL:if(1H.rz){2n.5s(1H,1n)}1i{2n.eI(1)}1p;1l $.ui.3F.CK:2n.eI(-1);1p;1l $.ui.3F.CS:2n.eI(1);1p;1l $.ui.3F.CU:2n.eI(":4x");1p;1l $.ui.3F.Di:2n.xI("up");1p;1l $.ui.3F.EC:2n.xI("dE");1p;1l $.ui.3F.GF:2n.eI(":73");1p;1l $.ui.3F.GD:;1l $.ui.3F.GV:2n.5s(1H,1n);$(1H.3k).cD("li:eq(0)").2c("5u");1p;1l $.ui.3F.GY:7S=1n;2n.5s(1H,1n);$(1H.3k).cD("li:eq(0)").2c("5u");1p;1l $.ui.3F.Qp:2n.5s(1H,1n);1p;5o:7S=1n}1b 7S}).2C("gN.3i",1a(1H){if(1H.iK>0){2n.zM(1H.iK,"2S")}1b 1n}).2C("7f.3i 5u.3i",1a(){1b 1j});$(3Q).2C("79.3i-"+J.cV[0],$.9v(2n.5s,J))},vE:1a(){K 2n=J,o=J.1x;K 8g=[];J.1f.2D("2Q").2h(1a(){K 1B=$(J);8g.1C({1m:1B.1k("1m"),1Y:2n.Fa(1B.1Y(),1B),1Q:1B.1k("1Q"),2x:1B.1k("2x"),fV:1B.1k("2B"),kG:1B.1k("kG"),kq:1B.1L("xK"),kv:o.kv.2w(1B)})});K jW=2n.1x.3b=="jS"?" ui-4Z-b4":"";J.4L.3X("");if(8g.1e){1o(K i=0;i<8g.1e;i++){K Aa={h9:"zP"};if(8g[i].2x){Aa["2B"]="ui-4Z-2x"}K p7={3X:8g[i].1Y||"&2r;",5c:"#zO",69:-1,h9:"2Q","5w-1Q":1j};if(8g[i].2x){p7["5w-2x"]=1n}if(8g[i].kG){p7["kG"]=8g[i].kG}K Gf=$("<a/>",p7).2C("2S.3i",1a(){$(J).1L().hL()}).2C("4O.3i",1a(){$(J).1L().ea()});K g1=$("<li/>",Aa).3a(Gf).1h("1P",i).2t(8g[i].fV).1h("hj",8g[i].fV||"").2C("5u.3i",1a(1H){if(2n.oO&&(!2n.o0(1H.8b)&&!2n.o0($(1H.8b).cD("ul > li.ui-3i-bI ")))){2n.1P($(J).1h("1P"));2n.2o(1H);2n.5s(1H,1n)}1b 1j}).2C("3J.3i",1a(){1b 1j}).2C("hL.3i",1a(e){if(!$(J).4E("ui-4Z-2x")&&!$(J).1L("ul").1L("li").4E("ui-4Z-2x")){e.GB=2n.1f[0].1x[$(J).1h("1P")].1m;2n.7w("6y",e,2n.eV());2n.b7().2t(jW);2n.nf().4f("ui-3i-1g-2S ui-4Z-6y");$(J).4f("ui-4Z-b4").2t("ui-3i-1g-2S ui-4Z-6y")}}).2C("ea.3i",1a(e){if($(J).is(2n.b7())){$(J).2t(jW)}e.GB=2n.1f[0].1x[$(J).1h("1P")].1m;2n.7w("4O",e,2n.eV());$(J).4f("ui-3i-1g-2S ui-4Z-6y")});if(8g[i].kq.1e){K oH="ui-3i-bI-"+J.1f.2D("xK").1P(8g[i].kq);if(J.4L.2D("li."+oH).1e){J.4L.2D("li."+oH+":73 ul").3a(g1)}1i{$(\'<li h9="zP" 2B="ui-3i-bI \'+oH+(8g[i].kq.1k("2x")?" "+\'ui-4Z-2x" 5w-2x="1n"\':\'"\')+\'><2F 2B="ui-3i-bI-3y">\'+8g[i].kq.1k("3y")+"</2F><ul></ul></li>").4r(J.4L).2D("ul").3a(g1)}}1i{g1.4r(J.4L)}if(o.bJ){1o(K j in o.bJ){if(g1.is(o.bJ[j].2D)){g1.1h("hj",8g[i].fV+" ui-3i-Hw").2t("ui-3i-Hw");K tc=o.bJ[j].3K||"";g1.2D("a:eq(0)").i9(\'<2F 2B="ui-3i-1g-3K ui-3K \'+tc+\'"></2F>\');if(8g[i].kv){g1.2D("2F").31("ia-8O",8g[i].kv)}}}}}}1i{$(\'<li h9="zP"><a 5c="#zO" 69="-1" h9="2Q"></a></li>\').4r(J.4L)}K fS=o.3b=="hB";J.6e.8C("ui-3i-hB",fS).8C("ui-3i-jS",!fS);J.4L.8C("ui-3i-1T-hB ui-9Z-4I",fS).8C("ui-3i-1T-jS ui-9Z-6o",!fS).2D("li:4x").8C("ui-9Z-1O",!fS).4z().2D("li:73").2t("ui-9Z-4I");J.HJ.8C("ui-3K-i4-1-s",fS).8C("ui-3K-i4-2-n-s",!fS);if(o.3b=="hB"){J.4L.1r(o.kr?o.kr:o.1r)}1i{J.4L.1r(o.kr?o.kr:o.1r-o.HD)}if(!aW.ew.3e(/R4 2/)){K HF=J.hu.1y();K zK=$(3Q).1y();K zN=o.9i?3D.5Q(o.9i,zK):zK/3;if(HF>zN){J.4L.1y(zN)}}J.86=J.4L.2D("li:5X(.ui-3i-bI)");if(J.1f.1k("2x")){J.te()}1i{J.Fn()}J.nZ();J.b7().2t("ui-3i-1g-2S");k1(J.H7);J.H7=3Q.6x(1a(){2n.xE()},ff)},6d:1a(){J.1f.tm(J.R0).4f("ui-3i-2x"+" "+"ui-4Z-2x").iu("5w-2x").7Y(".3i");$(3Q).7Y(".3i-"+J.cV[0]);$(2N).7Y(".3i-"+J.cV[0]);J.xw.3u();J.hu.3u();J.1f.7Y(".3i").59();$.A9.2T.6d.3c(J,2q)},zM:1a(Ha,yF){K 2n=J,c=5l.xk(Ha).3N(),kI=1c,dC=1c;if(2n.kK){3Q.k1(2n.kK);2n.kK=2O}2n.gX=(2n.gX===2O?"":2n.gX).3x(c);if(2n.gX.1e<2||2n.gX.71(-2,1)===c&&2n.kC){2n.kC=1n;kI=c}1i{2n.kC=1j;kI=2n.gX}K bi=(yF!=="2S"?J.b7().1h("1P"):J.nf().1h("1P"))||0;1o(K i=0;i<J.86.1e;i++){K H3=J.86.eq(i).1Y().71(0,kI.1e).3N();if(H3===kI){if(2n.kC){if(dC===1c){dC=i}if(i>bi){dC=i;1p}}1i{dC=i}}}if(dC!==1c){J.86.eq(dC).2D("a").2c(yF)}2n.kK=3Q.6x(1a(){2n.kK=2O;2n.gX=2O;2n.kC=2O},2n.1x.Hj)},eV:1a(){K 1P=J.1P();1b{1P:1P,2Q:$("2Q",J.1f).4u(1P),1m:J.1f[0].1m}},6Q:1a(1H){if(J.6e.1k("5w-2x")!="1n"){K 2n=J,o=J.1x,1Q=J.b7(),1W=1Q.2D("a");2n.Hi(1H);2n.6e.2t("ui-4Z-b4");2n.4L.1k("5w-7d",1j);2n.hu.2t("ui-3i-6Q");if(o.3b=="hB"){2n.6e.4f("ui-9Z-6o").2t("ui-9Z-1O")}1i{J.4L.31("2a",-rF).58(J.4L.58()+1Q.2J().1O-J.4L.aS()/ 2 + 1Q.aS() /2).31("2a","6l")}2n.xE();if(1W.1e){1W[0].2S()}2n.ib=1n;2n.7w("6Q",1H,2n.eV())}},5s:1a(1H,oW){if(J.6e.is(".ui-4Z-b4")){J.6e.4f("ui-4Z-b4");J.hu.4f("ui-3i-6Q");J.4L.1k("5w-7d",1n);if(J.1x.3b=="hB"){J.6e.4f("ui-9Z-1O").2t("ui-9Z-6o")}if(oW){J.6e.2S()}J.ib=1j;J.7w("5s",1H,J.eV())}},dr:1a(1H){J.1f.2c("dr");J.7w("dr",1H,J.eV())},2o:1a(1H){if(J.o0(1H.8b)){1b 1j}J.7w("2o",1H,J.eV())},8M:1a(){1b J.hu.54(J.xw)},Hi:1a(1H){$(".ui-3i.ui-4Z-b4").5X(J.6e).2h(1a(){$(J).1h("Hh").3i("5s",1H)});$(".ui-3i.ui-4Z-6y").2c("ea")},xm:1a(1H,oW){if(J.ib){J.5s(1H,oW)}1i{J.6Q(1H)}},Fa:1a(1Y,1B){if(J.1x.6v){1Y=J.1x.6v(1Y,1B)}1i{if(J.1x.Fc){1Y=$("<2E />").1Y(1Y).3X()}}1b 1Y},po:1a(){1b J.1f[0].bi},b7:1a(){1b J.86.eq(J.po())},nf:1a(){1b J.4L.2D(".ui-3i-1g-2S")},jv:1a(9O,pq){if(!J.1x.2x){K pY=6p(J.b7().1h("1P")||0,10);K 53=pY+9O;if(53<0){53=0}if(53>J.86.56()-1){53=J.86.56()-1}if(53===pq){1b 1j}if(J.86.eq(53).4E("ui-4Z-2x")){9O>0?++9O:--9O;J.jv(9O,53)}1i{J.86.eq(53).2c("hL").2c("5u")}}},eI:1a(9O,pq){if(!aa(9O)){K pY=6p(J.nf().1h("1P")||0,10);K 53=pY+9O}1i{K 53=6p(J.86.4p(9O).1h("1P"),10)}if(53<0){53=0}if(53>J.86.56()-1){53=J.86.56()-1}if(53===pq){1b 1j}K jV="ui-3i-1g-"+3D.4G(3D.iw()*8W);J.nf().2D("a:eq(0)").1k("id","");if(J.86.eq(53).4E("ui-4Z-2x")){9O>0?++9O:--9O;J.eI(9O,53)}1i{J.86.eq(53).2D("a:eq(0)").1k("id",jV).2S()}J.4L.1k("5w-EE",jV)},xI:1a(cB){K nX=3D.gF(J.4L.aS()/J.86.4x().aS());nX=cB=="up"?-nX:nX;J.eI(nX)},mz:1a(1q,1m){J.1x[1q]=1m;if(1q=="2x"){if(1m){J.5s()}J.1f.54(J.6e).54(J.4L)[1m?"2t":"4f"]("ui-3i-2x "+"ui-4Z-2x").1k("5w-2x",1m).1k("69",1m?1:0)}},te:1a(1P,1w){if(2K 1P=="2O"){J.mz("2x",1n)}1i{J.xL(1w||"2Q",1P,1j)}},Fn:1a(1P,1w){if(2K 1P=="2O"){J.mz("2x",1j)}1i{J.xL(1w||"2Q",1P,1n)}},o0:1a(6i){1b $(6i).4E("ui-4Z-2x")},xL:1a(1w,1P,pu){K 1f=J.1f.2D(1w).eq(1P),9u=1w==="xK"?J.4L.2D("li.ui-3i-bI-"+1P):J.86.eq(1P);if(9u){9u.8C("ui-4Z-2x",!pu).1k("5w-2x",!pu);if(pu){1f.iu("2x")}1i{1f.1k("2x","2x")}}},1P:1a(53){if(2q.1e){if(!J.o0($(J.86[53]))&&53!=J.po()){J.1f[0].bi=53;J.nZ();J.dr()}1i{1b 1j}}1i{1b J.po()}},1m:1a(4g){if(2q.1e&&4g!=J.1f[0].1m){J.1f[0].1m=4g;J.nZ();J.dr()}1i{1b J.1f[0].1m}},nZ:1a(){K jW=J.1x.3b=="jS"?" ui-4Z-b4":"";K jV="ui-3i-1g-"+3D.4G(3D.iw()*8W);J.4L.2D(".ui-3i-1g-1Q").4f("ui-3i-1g-1Q"+jW).2D("a").1k("5w-1Q","1j").1k("id","");J.b7().2t("ui-3i-1g-1Q"+jW).2D("a").1k("5w-1Q","1n").1k("id",jV);K EM=J.6e.1h("hj")?J.6e.1h("hj"):"";K xF=J.b7().1h("hj")?J.b7().1h("hj"):"";J.6e.4f(EM).1h("hj",xF).2t(xF).2D(".ui-3i-6G").3X(J.b7().2D("a:eq(0)").3X());J.4L.1k("5w-EE",jV)},xE:1a(){K o=J.1x,pS={of:J.6e,my:"2a 1O",at:"2a 4I",lK:"hP"};if(o.3b=="jS"){K 1Q=J.b7();pS.my="2a 1O"+(J.4L.2y().1O-1Q.2y().1O-(J.6e.aS()+1Q.aS())/2);pS.lK="9W"}J.hu.iu("3b").4o(J.1f.4o()+2).2J($.4l(pS,o.EQ))}})})(2v);(1a(io){K 5M="0.4.2",3o="7P",5n=/[\\.\\/]/,wW="*",qW=1a(){},EU=1a(a,b){1b a-b},hg,5B,4t={n:{}},2R=1a(1z,eF){1z=5l(1z);K e=4t,wU=5B,2e=43.2T.3H.2w(2q,2),dH=2R.dH(1z),z=0,f=1j,l,ha=[],ir={},2k=[],ce=hg,R8=[];hg=1z;5B=0;1o(K i=0,ii=dH.1e;i<ii;i++){if("4o"in dH[i]){ha.1C(dH[i].4o);if(dH[i].4o<0){ir[dH[i].4o]=dH[i]}}}ha.eZ(EU);45(ha[z]<0){l=ir[ha[z++]];2k.1C(l.3c(eF,2e));if(5B){5B=wU;1b 2k}}1o(i=0;i<ii;i++){l=dH[i];if("4o"in l){if(l.4o==ha[z]){2k.1C(l.3c(eF,2e));if(5B){1p}do{z++;l=ir[ha[z]];l&&2k.1C(l.3c(eF,2e));if(5B){1p}}45(l)}1i{ir[l.4o]=l}}1i{2k.1C(l.3c(eF,2e));if(5B){1p}}}5B=wU;hg=ce;1b 2k.1e?2k:1c};2R.dc=4t;2R.dH=1a(1z){K 7h=1z.3q(5n),e=4t,1g,1F,k,i,ii,j,jj,pR,es=[e],2k=[];1o(i=0,ii=7h.1e;i<ii;i++){pR=[];1o(j=0,jj=es.1e;j<jj;j++){e=es[j].n;1F=[e[7h[i]],e[wW]];k=2;45(k--){1g=1F[k];if(1g){pR.1C(1g);2k=2k.3x(1g.f||[])}}}es=pR}1b 2k};2R.on=1a(1z,f){1z=5l(1z);if(2K f!="1a"){1b 1a(){}}K 7h=1z.3q(5n),e=4t;1o(K i=0,ii=7h.1e;i<ii;i++){e=e.n;e=e.7P(7h[i])&&e[7h[i]]||(e[7h[i]]={n:{}})}e.f=e.f||[];1o(i=0,ii=e.f.1e;i<ii;i++){if(e.f[i]==f){1b qW}}e.f.1C(f);1b 1a(4o){if(+4o==+4o){f.4o=+4o}}};2R.f=1a(1H){K 2b=[].3H.2w(2q,1);1b 1a(){2R.3c(1c,[1H,1c].3x(2b).3x([].3H.2w(2q,0)))}};2R.5B=1a(){5B=1};2R.nt=1a(wX){if(wX){1b(1S cY("(?:\\\\.|\\\\/|^)"+wX+"(?:\\\\.|\\\\/|$)")).9V(hg)}1b hg};2R.QQ=1a(){1b hg.3q(5n)};2R.dT=2R.7Y=1a(1z,f){if(!1z){2R.dc=4t={n:{}};1b}K 7h=1z.3q(5n),e,1q,5f,i,ii,j,jj,he=[4t];1o(i=0,ii=7h.1e;i<ii;i++){1o(j=0;j<he.1e;j+=5f.1e-2){5f=[j,1];e=he[j].n;if(7h[i]!=wW){if(e[7h[i]]){5f.1C(e[7h[i]])}}1i{1o(1q in e){if(e[3o](1q)){5f.1C(e[1q])}}}he.5f.3c(he,5f)}}1o(i=0,ii=he.1e;i<ii;i++){e=he[i];45(e.n){if(f){if(e.f){1o(j=0,jj=e.f.1e;j<jj;j++){if(e.f[j]==f){e.f.5f(j,1);1p}}!e.f.1e&&42 e.f}1o(1q in e.n){if(e.n[3o](1q)&&e.n[1q].f){K o3=e.n[1q].f;1o(j=0,jj=o3.1e;j<jj;j++){if(o3[j]==f){o3.5f(j,1);1p}}!o3.1e&&42 e.n[1q].f}}}1i{42 e.f;1o(1q in e.n){if(e.n[3o](1q)&&e.n[1q].f){42 e.n[1q].f}}}e=e.n}}};2R.QS=1a(1z,f){K f2=1a(){2R.7Y(1z,f2);1b f.3c(J,2q)};1b 2R.on(1z,f2)};2R.5M=5M;2R.3s=1a(){1b"Dr qg ze QN "+5M};2K tM!="2O"&&tM.FA?tM.FA=2R:2K jn!="2O"?jn("2R",[],1a(){1b 2R}):io.2R=2R})(3Q||J);(1a(io,x8){if(2K jn==="1a"&&jn.QO){jn(["2R"],1a(2R){1b x8(io,2R)})}1i{x8(io,io.2R)}})(J,1a(3Q,2R){1a R(4x){if(R.is(4x,"1a")){1b ai?4x():2R.on("46.iy",4x)}1i{if(R.is(4x,3I)){1b R.4C.7U[3c](R,4x.5f(0,3+R.is(4x[0],nu))).54(4x)}1i{K 2e=43.2T.3H.2w(2q,0);if(R.is(2e[2e.1e-1],"1a")){K f=2e.cQ();1b ai?f.2w(R.4C.7U[3c](R,2e)):2R.on("46.iy",1a(){f.2w(R.4C.7U[3c](R,2e))})}1i{1b R.4C.7U[3c](R,2q)}}}}R.5M="2.1.2";R.2R=2R;K ai,5n=/[, ]+/,9u={9m:1,4k:1,1G:1,aM:1,1Y:1,8O:1},CH=/\\{(\\d+)\\}/g,hR="2T",3o="7P",g={2Y:2N,5j:3Q},oN={vF:4J.2T[3o].2w(g.5j,"bk"),is:g.5j.bk},xW=1a(){J.ca=J.8E={}},62,3G="3G",3c="3c",3x="3x",mu="QX"in g.5j||g.5j.FI&&g.2Y dY FI,E="",S=" ",3Y=5l,3q="3q",4t="3J vG 7f 9T ea hL 5u oc oe o4 xf"[3q](S),mt={7f:"oc",9T:"oe",5u:"o4"},mm=3Y.2T.3N,3w=3D,4Q=3w.4y,5W=3w.5Q,4a=3w.4a,5L=3w.5L,PI=3w.PI,nu="cl",4e="4e",3I="3I",3s="3s",gG="28",Lc=4J.2T.3s,2u={},1C="1C",QU=R.us=/^5e\\([\'"]?([^\\)]+?)[\'"]?\\)$/i,JA=/^\\s*((#[a-f\\d]{6})|(#[a-f\\d]{3})|yX?\\(\\s*([\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?(?:\\s*,\\s*[\\d\\.]+%?)?)\\s*\\)|Jz?\\(\\s*([\\d\\.]+(?:4j|\\z4|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\)|JN?\\(\\s*([\\d\\.]+(?:4j|\\z4|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\))\\s*$/i,Ll={"QV":1,"FE":1,"-FE":1},Gm=/^(?:O5-)?O3\\(([^,]+),([^,]+),([^,]+),([^\\)]+)\\)/,4G=3w.4G,b1="b1",3z=d5,9z=6p,yE=3Y.2T.8w,Gz=R.jY={"ag-4z":"3p","ag-2I":"3p",4O:0,"6h-4k":"0 0 Fw Fw",iN:"5o",cx:0,cy:0,28:"#ja","28-2G":1,2M:\'Oz "Gb"\',"2M-84":\'"Gb"\',"2M-56":"10","2M-3b":"pJ","2M-9K":ol,3O:0,1y:0,5c:"6H://Ot.wJ/","Og-Oi":0,2G:1,1G:"M0,0",r:0,rx:0,ry:0,4b:"",1X:"#cm","1X-98":"","1X-cA":"iq","1X-g3":"iq","1X-mV":0,"1X-2G":1,"1X-1r":1,3k:"Ox","1Y-v4":"zs",61:"bk",3A:"",1r:0,x:0,y:0},pl=R.O1={4O:nu,"6h-4k":"zC",cx:nu,cy:nu,28:"9s","28-2G":nu,"2M-56":nu,1y:nu,2G:nu,1G:"1G",r:nu,rx:nu,ry:nu,1X:"9s","1X-2G":nu,"1X-1r":nu,3A:"3A",1r:nu,x:nu,y:nu},GU=/[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]/g,q5=/[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*,[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*/,Jx={hs:1,rg:1},K3=/,?([O4]),?/gi,Ko=/([Od])[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*,?[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*)+)/ig,Ky=/([NX])[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*,?[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*)+)/ig,yd=/(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*,?[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*/ig,NW=R.v6=/^r(?:\\(([^,]+?)[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*,[\\au\\aN\\aR\\aQ\\aK\\aL\\aJ\\aH\\aI\\aY\\aP\\aO\\aG\\aw\\az\\av\\aq\\aA\\aE\\aF\\aD\\aB\\aC\\b2\\b3]*([^\\)]+?)\\))?/,hh={},Oy=1a(a,b){1b a.1q-b.1q},Gq=1a(a,b){1b 3z(a)-3z(b)},qW=1a(){},GS=1a(x){1b x},o7=R.wf=1a(x,y,w,h,r){if(r){1b[["M",x+r,y],["l",w-r*2,0],["a",r,r,0,0,1,r,r],["l",0,h-r*2],["a",r,r,0,0,1,-r,r],["l",r*2-w,0],["a",r,r,0,0,1,-r,-r],["l",0,r*2-h],["a",r,r,0,0,1,r,-r],["z"]]}1b[["M",x,y],["l",w,0],["l",0,h],["l",-w,0],["z"]]},yB=1a(x,y,rx,ry){if(ry==1c){ry=rx}1b[["M",x,y],["m",0,-ry],["a",rx,ry,0,1,1,0,2*ry],["a",rx,ry,0,1,1,0,-2*ry],["z"]]},bz=R.uD={1G:1a(el){1b el.1k("1G")},9m:1a(el){K a=el.2b;1b yB(a.cx,a.cy,a.r)},aM:1a(el){K a=el.2b;1b yB(a.cx,a.cy,a.rx,a.ry)},4k:1a(el){K a=el.2b;1b o7(a.x,a.y,a.1r,a.1y,a.r)},8O:1a(el){K a=el.2b;1b o7(a.x,a.y,a.1r,a.1y)},1Y:1a(el){K 2X=el.nT();1b o7(2X.x,2X.y,2X.1r,2X.1y)},5v:1a(el){K 2X=el.nT();1b o7(2X.x,2X.y,2X.1r,2X.1y)}},nK=R.nK=1a(1G,4v){if(!4v){1b 1G}K x,y,i,j,ii,jj,ee;1G=hM(1G);1o(i=0,ii=1G.1e;i<ii;i++){ee=1G[i];1o(j=1,jj=ee.1e;j<jj;j+=2){x=4v.x(ee[j],ee[j+1]);y=4v.y(ee[j],ee[j+1]);ee[j]=x;ee[j+1]=y}}1b 1G};R.7x=g;R.1w=g.5j.NV||g.2Y.O6.O2("6H://nz.w3.r5/TR/OD/OC#On","1.1")?"c5":"gn";if(R.1w=="gn"){K d=g.2Y.c8("2E"),b;d.nC=\'<v:cz Ld="1"/>\';b=d.7E;b.3b.N1="5e(#5o#gn)";if(!(b&&2K b.Ld=="1D")){1b R.1w=E}d=1c}R.41=!(R.5H=R.1w=="gn");R.wN=xW;R.fn=62=xW.2T=R.2T;R.Oo=0;R.vk=0;R.is=1a(o,1w){1w=mm.2w(1w);if(1w=="nM"){1b!Ll[3o](+o)}if(1w=="3I"){1b o dY 43}1b 1w=="1c"&&o===1c||(1w==2K o&&o!==1c||(1w=="1D"&&o===4J(o)||(1w=="3I"&&(43.xV&&43.xV(o))||Lc.2w(o).3H(8,-1).3N()==1w)))};1a 5R(1u){if(2K 1u=="1a"||4J(1u)!==1u){1b 1u}K 1A=1S 1u.4U;1o(K 1q in 1u){if(1u[3o](1q)){1A[1q]=5R(1u[1q])}}1b 1A}R.7l=1a(x1,y1,x2,y2,x3,y3){if(x3==1c){K x=x1-x2,y=y1-y2;if(!x&&!y){1b 0}1b(c6+3w.ya(-y,-x)*c6/PI+8r)%8r}1i{1b R.7l(x1,y1,x3,y3)-R.7l(x2,y2,x3,y3)}};R.8R=1a(4j){1b 4j%8r*PI/c6};R.4j=1a(8R){1b 8R*c6/PI%8r};R.Ol=1a(2H,1m,dl){dl=R.is(dl,"nM")?dl:10;if(R.is(2H,3I)){K i=2H.1e;45(i--){if(4a(2H[i]-1m)<=dl){1b 2H[i]}}}1i{2H=+2H;K o5=1m%2H;if(o5<dl){1b 1m-o5}if(o5>2H-dl){1b 1m-o5+2H}}1b 1m};K nm=R.nm=1a(Nz,NF){1b 1a(){1b"Ow-Ob-Oc-O9-Oe".3g(Nz,NF).8w()}}(/[xy]/g,1a(c){K r=3w.iw()*16|0,v=c=="x"?r:r&3|8;1b v.3s(16)});R.Nr=1a(xY){2R("46.Nr",R,g.5j,xY);g.5j=xY;g.2Y=g.5j.2N;if(R.4C.pe){R.4C.pe(g.5j)}};K nU=1a(3t){if(R.5H){K od=/^\\s+|\\s+$/g;K og;7n{K qU=1S r6("OF");qU.NY("<3U>");qU.5s();og=qU.3U}7p(e){og=OE().2N.3U}K JO=og.Os();nU=b6(1a(3t){7n{og.3b.3t=3Y(3t).3g(od,E);K 1m=JO.Ov("Ou");1m=(1m&e0)<<16|1m&O0|(1m&O7)>>>16;1b"#"+("HV"+1m.3s(16)).3H(-6)}7p(e){1b"3p"}})}1i{K i=g.2Y.c8("i");i.61="gk\\gd S1 XL";i.3b.5p="3p";g.2Y.3U.3G(i);nU=b6(1a(3t){i.3b.3t=3t;1b g.2Y.iH.qL(i,E).DB("3t")})}1b nU(3t)},K7=1a(){1b"KL("+[J.h,J.s,J.b]+")"},Ka=1a(){1b"KM("+[J.h,J.s,J.l]+")"},uq=1a(){1b J.67},y7=1a(r,g,b){if(g==1c&&(R.is(r,"1D")&&("r"in r&&("g"in r&&"b"in r)))){b=r.b;g=r.g;r=r.r}if(g==1c&&R.is(r,4e)){K 3v=R.bM(r);r=3v.r;g=3v.g;b=3v.b}if(r>1||(g>1||b>1)){r/=e0;g/=e0;b/=e0}1b[r,g,b]},y6=1a(r,g,b,o){r*=e0;g*=e0;b*=e0;K 3E={r:r,g:g,b:b,67:R.3E(r,g,b),3s:uq};R.is(o,"nM")&&(3E.2G=o);1b 3E};R.3t=1a(3v){K 3E;if(R.is(3v,"1D")&&("h"in 3v&&("s"in 3v&&"b"in 3v))){3E=R.ok(3v);3v.r=3E.r;3v.g=3E.g;3v.b=3E.b;3v.67=3E.67}1i{if(R.is(3v,"1D")&&("h"in 3v&&("s"in 3v&&"l"in 3v))){3E=R.qM(3v);3v.r=3E.r;3v.g=3E.g;3v.b=3E.b;3v.67=3E.67}1i{if(R.is(3v,"4e")){3v=R.bM(3v)}if(R.is(3v,"1D")&&("r"in 3v&&("g"in 3v&&"b"in 3v))){3E=R.Kc(3v);3v.h=3E.h;3v.s=3E.s;3v.l=3E.l;3E=R.K9(3v);3v.v=3E.b}1i{3v={67:"3p"};3v.r=3v.g=3v.b=3v.h=3v.s=3v.v=3v.l=-1}}}3v.3s=uq;1b 3v};R.ok=1a(h,s,v,o){if(J.is(h,"1D")&&("h"in h&&("s"in h&&"b"in h))){v=h.b;s=h.s;h=h.h;o=h.o}h*=8r;K R,G,B,X,C;h=h%8r/60;C=v*s;X=C*(1-4a(h%2-1));R=G=B=v-C;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b y6(R,G,B,o)};R.qM=1a(h,s,l,o){if(J.is(h,"1D")&&("h"in h&&("s"in h&&"l"in h))){l=h.l;s=h.s;h=h.h}if(h>1||(s>1||l>1)){h/=8r;s/=100;l/=100}h*=8r;K R,G,B,X,C;h=h%8r/60;C=2*s*(l<0.5?l:1-l);X=C*(1-4a(h%2-1));R=G=B=l-C/2;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b y6(R,G,B,o)};R.K9=1a(r,g,b){b=y7(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,V,C;V=4Q(r,g,b);C=V-5W(r,g,b);H=C==0?1c:V==r?(g-b)/ C : V == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8r)%6*60/8r;S=C==0?0:C/V;1b{h:H,s:S,b:V,3s:K7}};R.Kc=1a(r,g,b){b=y7(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,L,M,m,C;M=4Q(r,g,b);m=5W(r,g,b);C=M-m;H=C==0?1c:M==r?(g-b)/ C : M == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8r)%6*60/8r;L=(M+m)/2;S=C==0?0:L<0.5?C/ (2 * L) : C /(2-2*L);1b{h:H,s:S,l:L,3s:Ka}};R.iW=1a(){1b J.4H(",").3g(K3,"$1")};1a K5(3I,1g){1o(K i=0,ii=3I.1e;i<ii;i++){if(3I[i]===1g){1b 3I.1C(3I.5f(i,1)[0])}}}1a b6(f,eF,nR){1a hQ(){K 4i=43.2T.3H.2w(2q,0),2e=4i.4H("\\XM"),7K=hQ.7K=hQ.7K||{},6E=hQ.6E=hQ.6E||[];if(7K[3o](2e)){K5(6E,2e);1b nR?nR(7K[2e]):7K[2e]}6E.1e>=8W&&42 7K[6E.bf()];6E.1C(2e);7K[2e]=f[3c](eF,4i);1b nR?nR(7K[2e]):7K[2e]}1b hQ}K XN=R.ut=1a(4b,f){K cE=g.2Y.c8("cE");cE.3b.fk="2J:8t;2a:-j9;1O:-j9";cE.gb=1a(){f.2w(J);J.gb=1c;g.2Y.3U.7o(J)};cE.XK=1a(){g.2Y.3U.7o(J)};g.2Y.3U.3G(cE);cE.4b=4b};1a nW(){1b J.67}R.bM=b6(1a(9s){if(!9s||!!((9s=3Y(9s)).4Y("-")+1)){1b{r:-1,g:-1,b:-1,67:"3p",96:1,3s:nW}}if(9s=="3p"){1b{r:-1,g:-1,b:-1,67:"3p",3s:nW}}!(Jx[3o](9s.3N().fY(0,2))||9s.bs()=="#")&&(9s=nU(9s));K 1A,8Y,9X,a5,2G,t,2H,3E=9s.3e(JA);if(3E){if(3E[2]){a5=9z(3E[2].fY(5),16);9X=9z(3E[2].fY(3,5),16);8Y=9z(3E[2].fY(1,3),16)}if(3E[3]){a5=9z((t=3E[3].bs(3))+t,16);9X=9z((t=3E[3].bs(2))+t,16);8Y=9z((t=3E[3].bs(1))+t,16)}if(3E[4]){2H=3E[4][3q](q5);8Y=3z(2H[0]);2H[0].3H(-1)=="%"&&(8Y*=2.55);9X=3z(2H[1]);2H[1].3H(-1)=="%"&&(9X*=2.55);a5=3z(2H[2]);2H[2].3H(-1)=="%"&&(a5*=2.55);3E[1].3N().3H(0,4)=="yX"&&(2G=3z(2H[3]));2H[3]&&(2H[3].3H(-1)=="%"&&(2G/=100))}if(3E[5]){2H=3E[5][3q](q5);8Y=3z(2H[0]);2H[0].3H(-1)=="%"&&(8Y*=2.55);9X=3z(2H[1]);2H[1].3H(-1)=="%"&&(9X*=2.55);a5=3z(2H[2]);2H[2].3H(-1)=="%"&&(a5*=2.55);(2H[0].3H(-3)=="4j"||2H[0].3H(-1)=="\\Jt")&&(8Y/=8r);3E[1].3N().3H(0,4)=="Jz"&&(2G=3z(2H[3]));2H[3]&&(2H[3].3H(-1)=="%"&&(2G/=100));1b R.ok(8Y,9X,a5,2G)}if(3E[6]){2H=3E[6][3q](q5);8Y=3z(2H[0]);2H[0].3H(-1)=="%"&&(8Y*=2.55);9X=3z(2H[1]);2H[1].3H(-1)=="%"&&(9X*=2.55);a5=3z(2H[2]);2H[2].3H(-1)=="%"&&(a5*=2.55);(2H[0].3H(-3)=="4j"||2H[0].3H(-1)=="\\Jt")&&(8Y/=8r);3E[1].3N().3H(0,4)=="JN"&&(2G=3z(2H[3]));2H[3]&&(2H[3].3H(-1)=="%"&&(2G/=100));1b R.qM(8Y,9X,a5,2G)}3E={r:8Y,g:9X,b:a5,3s:nW};3E.67="#"+(KQ|a5|9X<<8|8Y<<16).3s(16).3H(1);R.is(2G,"nM")&&(3E.2G=2G);1b 3E}1b{r:-1,g:-1,b:-1,67:"3p",96:1,3s:nW}},R);R.KL=b6(1a(h,s,b){1b R.ok(h,s,b).67});R.KM=b6(1a(h,s,l){1b R.qM(h,s,l).67});R.3E=b6(1a(r,g,b){1b"#"+(KQ|b|g<<8|r<<16).3s(16).3H(1)});R.ot=1a(1m){K 2I=J.ot.2I=J.ot.2I||{h:0,s:1,b:1m||0.75},3E=J.ok(2I.h,2I.s,2I.b);2I.h+=0.H6;if(2I.h>1){2I.h=0;2I.s-=0.2;2I.s<=0&&(J.ot.2I={h:0,s:1,b:2I.b})}1b 3E.67};R.ot.lU=1a(){42 J.2I};1a yz(7r,z){K d=[];1o(K i=0,hG=7r.1e;hG-2*!z>i;i+=2){K p=[{x:+7r[i-2],y:+7r[i-1]},{x:+7r[i],y:+7r[i+1]},{x:+7r[i+2],y:+7r[i+3]},{x:+7r[i+4],y:+7r[i+5]}];if(z){if(!i){p[0]={x:+7r[hG-2],y:+7r[hG-1]}}1i{if(hG-4==i){p[3]={x:+7r[0],y:+7r[1]}}1i{if(hG-2==i){p[2]={x:+7r[0],y:+7r[1]};p[3]={x:+7r[2],y:+7r[3]}}}}}1i{if(hG-4==i){p[3]=p[2]}1i{if(!i){p[0]={x:+7r[i],y:+7r[i+1]}}}}d.1C(["C",(-p[0].x+6*p[1].x+p[2].x)/ 6, (-p[0].y + 6 * p[1].y + p[2].y) /6,(p[1].x+6*p[2].x-p[3].x)/ 6, (p[1].y + 6 * p[2].y - p[3].y) /6,p[2].x,p[2].y])}1b d}R.yC=1a(8l){if(!8l){1b 1c}K 7G=fZ(8l);if(7G.lz){1b b5(7G.lz)}K ou={a:7,c:6,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,z:0},1h=[];if(R.is(8l,3I)&&R.is(8l[0],3I)){1h=b5(8l)}if(!1h.1e){3Y(8l).3g(Ko,1a(a,b,c){K 1v=[],1z=b.3N();c.3g(yd,1a(a,b){b&&1v.1C(+b)});if(1z=="m"&&1v.1e>2){1h.1C([b][3x](1v.5f(0,2)));1z="l";b=b=="m"?"l":"L"}if(1z=="r"){1h.1C([b][3x](1v))}1i{45(1v.1e>=ou[1z]){1h.1C([b][3x](1v.5f(0,ou[1z])));if(!ou[1z]){1p}}}})}1h.3s=R.iW;7G.lz=b5(1h);1b 1h};R.rs=b6(1a(hY){if(!hY){1b 1c}K ou={r:3,s:4,t:2,m:6},1h=[];if(R.is(hY,3I)&&R.is(hY[0],3I)){1h=b5(hY)}if(!1h.1e){3Y(hY).3g(Ky,1a(a,b,c){K 1v=[],1z=mm.2w(b);c.3g(yd,1a(a,b){b&&1v.1C(+b)});1h.1C([b][3x](1v))})}1h.3s=R.iW;1b 1h});K fZ=1a(ps){K p=fZ.ps=fZ.ps||{};if(p[ps]){p[ps].qz=100}1i{p[ps]={qz:100}}6x(1a(){1o(K 1q in p){if(p[3o](1q)&&1q!=ps){p[1q].qz--;!p[1q].qz&&42 p[1q]}}});1b p[ps]};R.nL=1a(5y,5Z,64,6f,77,74,7q,7m,t){K t1=1-t,ye=5L(t1,3),y9=5L(t1,2),t2=t*t,t3=t2*t,x=ye*5y+y9*3*t*64+t1*3*t*t*77+t3*7q,y=ye*5Z+y9*3*t*6f+t1*3*t*t*74+t3*7m,mx=5y+2*t*(64-5y)+t2*(77-2*64+5y),my=5Z+2*t*(6f-5Z)+t2*(74-2*6f+5Z),nx=64+2*t*(77-64)+t2*(7q-2*77+64),ny=6f+2*t*(74-6f)+t2*(7m-2*74+6f),ax=t1*5y+t*64,ay=t1*5Z+t*6f,cx=t1*77+t*7q,cy=t1*74+t*7m,d9=90-3w.ya(mx-nx,my-ny)*c6/PI;(mx>nx||my<ny)&&(d9+=c6);1b{x:x,y:y,m:{x:mx,y:my},n:{x:nx,y:ny},2I:{x:ax,y:ay},4z:{x:cx,y:cy},d9:d9}};R.xM=1a(5y,5Z,64,6f,77,74,7q,7m){if(!R.is(5y,"3I")){5y=[5y,5Z,64,6f,77,74,7q,7m]}K 2X=yg.3c(1c,5y);1b{x:2X.5Q.x,y:2X.5Q.y,x2:2X.4y.x,y2:2X.4y.y,1r:2X.4y.x-2X.5Q.x,1y:2X.4y.y-2X.5Q.y}};R.yw=1a(2X,x,y){1b x>=2X.x&&(x<=2X.x2&&(y>=2X.y&&y<=2X.y2))};R.xG=1a(6X,6V){K i=R.yw;1b i(6V,6X.x,6X.y)||(i(6V,6X.x2,6X.y)||(i(6V,6X.x,6X.y2)||(i(6V,6X.x2,6X.y2)||(i(6X,6V.x,6V.y)||(i(6X,6V.x2,6V.y)||(i(6X,6V.x,6V.y2)||(i(6X,6V.x2,6V.y2)||(6X.x<6V.x2&&6X.x>6V.x||6V.x<6X.x2&&6V.x>6X.x)&&(6X.y<6V.y2&&6X.y>6V.y||6V.y<6X.y2&&6V.y>6X.y))))))))};1a yb(t,p1,p2,p3,p4){K t1=-3*p1+9*p2-9*p3+3*p4,t2=t*t1+6*p1-12*p2+6*p3;1b t*t2-3*p1+3*p2}1a gM(x1,y1,x2,y2,x3,y3,x4,y4,z){if(z==1c){z=1}z=z>1?1:z<0?0:z;K z2=z/2,n=12,MP=[-0.I0,0.I0,-0.J4,0.J4,-0.J7,0.J7,-0.Jm,0.Jm,-0.Jl,0.Jl,-0.Jf,0.Jf],NN=[0.Nc,0.Nc,0.MM,0.MM,0.MH,0.MH,0.ME,0.ME,0.MN,0.MN,0.MU,0.MU],xR=0;1o(K i=0;i<n;i++){K ct=z2*MP[i]+z2,xP=yb(ct,x1,x2,x3,x4),xQ=yb(ct,y1,y2,y3,y4),Nn=xP*xP+xQ*xQ;xR+=NN[i]*3w.9M(Nn)}1b z2*xR}1a Fd(x1,y1,x2,y2,x3,y3,x4,y4,ll){if(ll<0||gM(x1,y1,x2,y2,x3,y3,x4,y4)<ll){1b}K t=1,lD=t/2,t2=t-lD,l,e=0.Iu;l=gM(x1,y1,x2,y2,x3,y3,x4,y4,t2);45(4a(l-ll)>e){lD/=2;t2+=(l<ll?1:-1)*lD;l=gM(x1,y1,x2,y2,x3,y3,x4,y4,t2)}1b t2}1a wF(x1,y1,x2,y2,x3,y3,x4,y4){if(4Q(x1,x2)<5W(x3,x4)||(5W(x1,x2)>4Q(x3,x4)||(4Q(y1,y2)<5W(y3,y4)||5W(y1,y2)>4Q(y3,y4)))){1b}K nx=(x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4),ny=(x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4),ra=(x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);if(!ra){1b}K px=nx/ ra, py = ny /ra,nN=+px.4q(2),mJ=+py.4q(2);if(nN<+5W(x1,x2).4q(2)||(nN>+4Q(x1,x2).4q(2)||(nN<+5W(x3,x4).4q(2)||(nN>+4Q(x3,x4).4q(2)||(mJ<+5W(y1,y2).4q(2)||(mJ>+4Q(y1,y2).4q(2)||(mJ<+5W(y3,y4).4q(2)||mJ>+4Q(y3,y4).4q(2)))))))){1b}1b{x:px,y:py}}1a Xx(8G,8z){1b qF(8G,8z)}1a Xy(8G,8z){1b qF(8G,8z,1)}1a qF(8G,8z,eW){K 6X=R.xM(8G),6V=R.xM(8z);if(!R.xG(6X,6V)){1b eW?0:[]}K l1=gM.3c(0,8G),l2=gM.3c(0,8z),n1=4Q(~~(l1/ 5), 1), n2 = 4Q(~~(l2 /5),1),qp=[],qt=[],xy={},1A=eW?0:[];1o(K i=0;i<n1+1;i++){K p=R.nL.3c(R,8G.3x(i/n1));qp.1C({x:p.x,y:p.y,t:i/n1})}1o(i=0;i<n2+1;i++){p=R.nL.3c(R,8z.3x(i/n2));qt.1C({x:p.x,y:p.y,t:i/n2})}1o(i=0;i<n1;i++){1o(K j=0;j<n2;j++){K di=qp[i],iL=qp[i+1],dj=qt[j],iE=qt[j+1],ci=4a(iL.x-di.x)<0.qJ?"y":"x",cj=4a(iE.x-dj.x)<0.qJ?"y":"x",is=wF(di.x,di.y,iL.x,iL.y,dj.x,dj.y,iE.x,iE.y);if(is){if(xy[is.x.4q(4)]==is.y.4q(4)){ah}xy[is.x.4q(4)]=is.y.4q(4);K t1=di.t+4a((is[ci]-di[ci])/ (iL[ci] - di[ci])) * (iL.t - di.t), t2 = dj.t + 4a((is[cj] - dj[cj]) /(iE[cj]-dj[cj]))*(iE.t-dj.t);if(t1>=0&&(t1<=1.qJ&&(t2>=0&&t2<=1.qJ))){if(eW){1A++}1i{1A.1C({x:is.x,y:is.y,t1:5W(t1,1),t2:5W(t2,1)})}}}}}1b 1A}R.XE=1a(9N,8h){1b qG(9N,8h)};R.XF=1a(9N,8h){1b qG(9N,8h,1)};1a qG(9N,8h,eW){9N=R.rA(9N);8h=R.rA(8h);K x1,y1,x2,y2,mH,mT,mU,mW,8G,8z,1A=eW?0:[];1o(K i=0,ii=9N.1e;i<ii;i++){K pi=9N[i];if(pi[0]=="M"){x1=mH=pi[1];y1=mT=pi[2]}1i{if(pi[0]=="C"){8G=[x1,y1].3x(pi.3H(1));x1=8G[6];y1=8G[7]}1i{8G=[x1,y1,x1,y1,mH,mT,mH,mT];x1=mH;y1=mT}1o(K j=0,jj=8h.1e;j<jj;j++){K pj=8h[j];if(pj[0]=="M"){x2=mU=pj[1];y2=mW=pj[2]}1i{if(pj[0]=="C"){8z=[x2,y2].3x(pj.3H(1));x2=8z[6];y2=8z[7]}1i{8z=[x2,y2,x2,y2,mU,mW,mU,mW];x2=mU;y2=mW}K fJ=qF(8G,8z,eW);if(eW){1A+=fJ}1i{1o(K k=0,kk=fJ.1e;k<kk;k++){fJ[k].XD=i;fJ[k].XA=j;fJ[k].8G=8G;fJ[k].8z=8z}1A=1A.3x(fJ)}}}}}1b 1A}R.F5=1a(1G,x,y){K 2X=R.Cu(1G);1b R.yw(2X,x,y)&&qG(1G,[["M",x,y],["H",2X.x2+10]],1)%2==1};R.kH=1a(eC){1b 1a(){2R("46.j3",1c,"gk\\gd: CW qg XB to 44 \\XC"+eC+"\\XW of 5d 1D",eC)}};K oB=R.Cu=1a(1G){K 7G=fZ(1G);if(7G.2X){1b 5R(7G.2X)}if(!1G){1b{x:0,y:0,1r:0,1y:0,x2:0,y2:0}}1G=hM(1G);K x=0,y=0,X=[],Y=[],p;1o(K i=0,ii=1G.1e;i<ii;i++){p=1G[i];if(p[0]=="M"){x=p[1];y=p[2];X.1C(x);Y.1C(y)}1i{K mO=yg(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);X=X[3x](mO.5Q.x,mO.4y.x);Y=Y[3x](mO.5Q.y,mO.4y.y);x=p[5];y=p[6]}}K qa=5W[3c](0,X),q1=5W[3c](0,Y),yx=4Q[3c](0,X),yy=4Q[3c](0,Y),1r=yx-qa,1y=yy-q1,bb={x:qa,y:q1,x2:yx,y2:yy,1r:1r,1y:1y,cx:qa+1r/ 2, cy:q1 + 1y /2};7G.2X=5R(bb);1b bb},b5=1a(5i){K 1A=5R(5i);1A.3s=R.iW;1b 1A},xj=R.Yh=1a(5i){K 7G=fZ(5i);if(7G.yv){1b b5(7G.yv)}if(!R.is(5i,3I)||!R.is(5i&&5i[0],3I)){5i=R.yC(5i)}K 1A=[],x=0,y=0,mx=0,my=0,2I=0;if(5i[0][0]=="M"){x=5i[0][1];y=5i[0][2];mx=x;my=y;2I++;1A.1C(["M",x,y])}1o(K i=2I,ii=5i.1e;i<ii;i++){K r=1A[i]=[],pa=5i[i];if(pa[0]!=mm.2w(pa[0])){r[0]=mm.2w(pa[0]);3r(r[0]){1l"a":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]-x).4q(3);r[7]=+(pa[7]-y).4q(3);1p;1l"v":r[1]=+(pa[1]-y).4q(3);1p;1l"m":mx=pa[1];my=pa[2];5o:1o(K j=1,jj=pa.1e;j<jj;j++){r[j]=+(pa[j]-(j%2?x:y)).4q(3)}}}1i{r=1A[i]=[];if(pa[0]=="m"){mx=pa[1]+x;my=pa[2]+y}1o(K k=0,kk=pa.1e;k<kk;k++){1A[i][k]=pa[k]}}K 6b=1A[i].1e;3r(1A[i][0]){1l"z":x=mx;y=my;1p;1l"h":x+=+1A[i][6b-1];1p;1l"v":y+=+1A[i][6b-1];1p;5o:x+=+1A[i][6b-2];y+=+1A[i][6b-1]}}1A.3s=R.iW;7G.yv=b5(1A);1b 1A},yo=R.mQ=1a(5i){K 7G=fZ(5i);if(7G.4a){1b b5(7G.4a)}if(!R.is(5i,3I)||!R.is(5i&&5i[0],3I)){5i=R.yC(5i)}if(!5i||!5i.1e){1b[["M",0,0]]}K 1A=[],x=0,y=0,mx=0,my=0,2I=0;if(5i[0][0]=="M"){x=+5i[0][1];y=+5i[0][2];mx=x;my=y;2I++;1A[0]=["M",x,y]}K yA=5i.1e==3&&(5i[0][0]=="M"&&(5i[1][0].8w()=="R"&&5i[2][0].8w()=="Z"));1o(K r,pa,i=2I,ii=5i.1e;i<ii;i++){1A.1C(r=[]);pa=5i[i];if(pa[0]!=yE.2w(pa[0])){r[0]=yE.2w(pa[0]);3r(r[0]){1l"A":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]+x);r[7]=+(pa[7]+y);1p;1l"V":r[1]=+pa[1]+y;1p;1l"H":r[1]=+pa[1]+x;1p;1l"R":K 57=[x,y][3x](pa.3H(1));1o(K j=2,jj=57.1e;j<jj;j++){57[j]=+57[j]+x;57[++j]=+57[j]+y}1A.cQ();1A=1A[3x](yz(57,yA));1p;1l"M":mx=+pa[1]+x;my=+pa[2]+y;5o:1o(j=1,jj=pa.1e;j<jj;j++){r[j]=+pa[j]+(j%2?x:y)}}}1i{if(pa[0]=="R"){57=[x,y][3x](pa.3H(1));1A.cQ();1A=1A[3x](yz(57,yA));r=["R"][3x](pa.3H(-2))}1i{1o(K k=0,kk=pa.1e;k<kk;k++){r[k]=pa[k]}}}3r(r[0]){1l"Z":x=mx;y=my;1p;1l"H":x=r[1];1p;1l"V":y=r[1];1p;1l"M":mx=r[r.1e-2];my=r[r.1e-1];5o:x=r[r.1e-2];y=r[r.1e-1]}}1A.3s=R.iW;7G.4a=b5(1A);1b 1A},mk=1a(x1,y1,x2,y2){1b[x1,y1,x2,y2,x2,y2]},yl=1a(x1,y1,ax,ay,x2,y2){K mn=1/ 3, mo = 2 /3;1b[mn*x1+mo*ax,mn*y1+mo*ay,mn*x2+mo*ax,mn*y2+mo*ay,x2,y2]},yp=1a(x1,y1,rx,ry,7l,Ez,k8,x2,y2,hi){K yi=PI*Yj/ c6, 8R = PI /c6*(+7l||0),1A=[],xy,5q=b6(1a(x,y,8R){K X=x*3w.8B(8R)-y*3w.8o(8R),Y=x*3w.8o(8R)+y*3w.8B(8R);1b{x:X,y:Y}});if(!hi){xy=5q(x1,y1,-8R);x1=xy.x;y1=xy.y;xy=5q(x2,y2,-8R);x2=xy.x;y2=xy.y;K 8B=3w.8B(PI/ c6 * 7l), 8o = 3w.8o(PI /c6*7l),x=(x1-x2)/ 2, y = (y1 - y2) /2;K h=x*x/ (rx * rx) + y * y /(ry*ry);if(h>1){h=3w.9M(h);rx=h*rx;ry=h*ry}K qf=rx*rx,qh=ry*ry,k=(Ez==k8?-1:1)*3w.9M(4a((qf*qh-qf*y*y-qh*x*x)/ (qf * y * y + qh * x * x))), cx = k * rx * y /ry+(x1+x2)/ 2, cy = k * -ry * x /rx+(y1+y2)/ 2, f1 = 3w.qV(((y1 - cy) /ry).4q(9)),f2=3w.qV(((y2-cy)/ry).4q(9));f1=x1<cx?PI-f1:f1;f2=x2<cx?PI-f2:f2;f1<0&&(f1=PI*2+f1);f2<0&&(f2=PI*2+f2);if(k8&&f1>f2){f1=f1-PI*2}if(!k8&&f2>f1){f2=f2-PI*2}}1i{f1=hi[0];f2=hi[1];cx=hi[2];cy=hi[3]}K df=f2-f1;if(4a(df)>yi){K CB=f2,Ea=x2,CF=y2;f2=f1+yi*(k8&&f2>f1?1:-1);x2=cx+rx*3w.8B(f2);y2=cy+ry*3w.8o(f2);1A=yp(x2,y2,rx,ry,7l,0,k8,Ea,CF,[f2,CB,cx,cy])}df=f2-f1;K c1=3w.8B(f1),s1=3w.8o(f1),c2=3w.8B(f2),s2=3w.8o(f2),t=3w.Cg(df/ 4), hx = 4 /3*rx*t,hy=4/3*ry*t,m1=[x1,y1],m2=[x1+hx*s1,y1-hy*c1],m3=[x2+hx*s2,y2-hy*c2],m4=[x2,y2];m2[0]=2*m1[0]-m2[0];m2[1]=2*m1[1]-m2[1];if(hi){1b[m2,m3,m4][3x](1A)}1i{1A=[m2,m3,m4][3x](1A).4H()[3q](",");K yf=[];1o(K i=0,ii=1A.1e;i<ii;i++){yf[i]=i%2?5q(1A[i-1],1A[i],8R).y:5q(1A[i],1A[i+1],8R).x}1b yf}},mh=1a(5y,5Z,64,6f,77,74,7q,7m,t){K t1=1-t;1b{x:5L(t1,3)*5y+5L(t1,2)*3*t*64+t1*3*t*t*77+5L(t,3)*7q,y:5L(t1,3)*5Z+5L(t1,2)*3*t*6f+t1*3*t*t*74+5L(t,3)*7m}},yg=b6(1a(5y,5Z,64,6f,77,74,7q,7m){K a=77-2*64+5y-(7q-2*77+64),b=2*(64-5y)-2*(77-64),c=5y-64,t1=(-b+3w.9M(b*b-4*a*c))/ 2 /a,t2=(-b-3w.9M(b*b-4*a*c))/ 2 /a,y=[5Z,7m],x=[5y,7q],6M;4a(t1)>"rm"&&(t1=0.5);4a(t2)>"rm"&&(t2=0.5);if(t1>0&&t1<1){6M=mh(5y,5Z,64,6f,77,74,7q,7m,t1);x.1C(6M.x);y.1C(6M.y)}if(t2>0&&t2<1){6M=mh(5y,5Z,64,6f,77,74,7q,7m,t2);x.1C(6M.x);y.1C(6M.y)}a=74-2*6f+5Z-(7m-2*74+6f);b=2*(6f-5Z)-2*(74-6f);c=5Z-6f;t1=(-b+3w.9M(b*b-4*a*c))/ 2 /a;t2=(-b-3w.9M(b*b-4*a*c))/ 2 /a;4a(t1)>"rm"&&(t1=0.5);4a(t2)>"rm"&&(t2=0.5);if(t1>0&&t1<1){6M=mh(5y,5Z,64,6f,77,74,7q,7m,t1);x.1C(6M.x);y.1C(6M.y)}if(t2>0&&t2<1){6M=mh(5y,5Z,64,6f,77,74,7q,7m,t2);x.1C(6M.x);y.1C(6M.y)}1b{5Q:{x:5W[3c](0,x),y:5W[3c](0,y)},4y:{x:4Q[3c](0,x),y:4Q[3c](0,y)}}}),hM=R.rA=b6(1a(1G,8h){K 7G=!8h&&fZ(1G);if(!8h&&7G.fe){1b b5(7G.fe)}K p=yo(1G),p2=8h&&yo(8h),2b={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},dB={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},ym=1a(1G,d,mi){K nx,ny,tq={T:1,Q:1};if(!1G){1b["C",d.x,d.y,d.x,d.y,d.x,d.y]}!(1G[0]in tq)&&(d.qx=d.qy=1c);3r(1G[0]){1l"M":d.X=1G[1];d.Y=1G[2];1p;1l"A":1G=["C"][3x](yp[3c](0,[d.x,d.y][3x](1G.3H(1))));1p;1l"S":if(mi=="C"||mi=="S"){nx=d.x*2-d.bx;ny=d.y*2-d.by}1i{nx=d.x;ny=d.y}1G=["C",nx,ny][3x](1G.3H(1));1p;1l"T":if(mi=="Q"||mi=="T"){d.qx=d.x*2-d.qx;d.qy=d.y*2-d.qy}1i{d.qx=d.x;d.qy=d.y}1G=["C"][3x](yl(d.x,d.y,d.qx,d.qy,1G[1],1G[2]));1p;1l"Q":d.qx=1G[1];d.qy=1G[2];1G=["C"][3x](yl(d.x,d.y,1G[1],1G[2],1G[3],1G[4]));1p;1l"L":1G=["C"][3x](mk(d.x,d.y,1G[1],1G[2]));1p;1l"H":1G=["C"][3x](mk(d.x,d.y,1G[1],d.y));1p;1l"V":1G=["C"][3x](mk(d.x,d.y,d.x,1G[1]));1p;1l"Z":1G=["C"][3x](mk(d.x,d.y,d.X,d.Y));1p}1b 1G},yn=1a(pp,i){if(pp[i].1e>7){pp[i].bf();K pi=pp[i];45(pi.1e){pp.5f(i++,0,["C"][3x](pi.5f(0,6)))}pp.5f(i,1);ii=4Q(p.1e,p2&&p2.1e||0)}},xc=1a(9N,8h,a1,a2,i){if(9N&&(8h&&(9N[i][0]=="M"&&8h[i][0]!="M"))){8h.5f(i,0,["M",a2.x,a2.y]);a1.bx=0;a1.by=0;a1.x=9N[i][1];a1.y=9N[i][2];ii=4Q(p.1e,p2&&p2.1e||0)}};1o(K i=0,ii=4Q(p.1e,p2&&p2.1e||0);i<ii;i++){p[i]=ym(p[i],2b);yn(p,i);p2&&(p2[i]=ym(p2[i],dB));p2&&yn(p2,i);xc(p,p2,2b,dB,i);xc(p2,p,dB,2b,i);K im=p[i],ik=p2&&p2[i],mj=im.1e,mw=p2&&ik.1e;2b.x=im[mj-2];2b.y=im[mj-1];2b.bx=3z(im[mj-4])||2b.x;2b.by=3z(im[mj-3])||2b.y;dB.bx=p2&&(3z(ik[mw-4])||dB.x);dB.by=p2&&(3z(ik[mw-3])||dB.y);dB.x=p2&&ik[mw-2];dB.y=p2&&ik[mw-1]}if(!p2){7G.fe=b5(p)}1b p2?[p,p2]:p},1c,b5),Y0=R.uZ=b6(1a(3O){K 57=[];1o(K i=0,ii=3O.1e;i<ii;i++){K 6M={},8H=3O[i].3e(/^([^:]*):?([\\d\\.]*)/);6M.3t=R.bM(8H[1]);if(6M.3t.96){1b 1c}6M.3t=6M.3t.67;8H[2]&&(6M.2y=8H[2]+"%");57.1C(6M)}1o(i=1,ii=57.1e-1;i<ii;i++){if(!57[i].2y){K 2I=3z(57[i-1].2y||0),4z=0;1o(K j=i+1;j<ii;j++){if(57[j].2y){4z=57[j].2y;1p}}if(!4z){4z=100;j=ii}4z=3z(4z);K d=(4z-2I)/(j-i+1);1o(;i<j;i++){2I+=d;57[i].2y=2I+"%"}}}1b 57}),mA=R.uQ=1a(el,2u){el==2u.1O&&(2u.1O=el.3P);el==2u.4I&&(2u.4I=el.3m);el.3m&&(el.3m.3P=el.3P);el.3P&&(el.3P.3m=el.3m)},Y5=R.wq=1a(el,2u){if(2u.1O===el){1b}mA(el,2u);el.3m=1c;el.3P=2u.1O;2u.1O.3m=el;2u.1O=el},Ya=R.wo=1a(el,2u){if(2u.4I===el){1b}mA(el,2u);el.3m=2u.4I;el.3P=1c;2u.4I.3P=el;2u.4I=el},Yb=R.wn=1a(el,9L,2u){mA(el,2u);9L==2u.1O&&(2u.1O=el);9L.3m&&(9L.3m.3P=el);el.3m=9L.3m;el.3P=9L;9L.3m=el},Yc=R.wt=1a(el,9L,2u){mA(el,2u);9L==2u.4I&&(2u.4I=el);9L.3P&&(9L.3P.3m=el);el.3P=9L.3P;9L.3P=el;el.3m=9L},xa=R.xa=1a(1G,3A){K bb=oB(1G),el={1U:{3A:E},6F:1a(){1b bb}};zG(el,3A);1b el.4v},pC=R.pC=1a(1G,3A){1b nK(1G,xa(1G,3A))},zG=R.vd=1a(el,ab){if(ab==1c){1b el.1U.3A}ab=3Y(ab).3g(/\\.{3}|\\vc/g,el.1U.3A||E);K mB=R.rs(ab),4j=0,dx=0,dy=0,sx=1,sy=1,1U=el.1U,m=1S eb;1U.3A=mB||[];if(mB){1o(K i=0,ii=mB.1e;i<ii;i++){K t=mB[i],cW=t.1e,83=3Y(t[0]).3N(),8t=t[0]!=83,eH=8t?m.nq():0,x1,y1,x2,y2,bb;if(83=="t"&&cW==3){if(8t){x1=eH.x(0,0);y1=eH.y(0,0);x2=eH.x(t[1],t[2]);y2=eH.y(t[1],t[2]);m.fc(x2-x1,y2-y1)}1i{m.fc(t[1],t[2])}}1i{if(83=="r"){if(cW==2){bb=bb||el.6F(1);m.5q(t[1],bb.x+bb.1r/ 2, bb.y + bb.1y /2);4j+=t[1]}1i{if(cW==4){if(8t){x2=eH.x(t[2],t[3]);y2=eH.y(t[2],t[3]);m.5q(t[1],x2,y2)}1i{m.5q(t[1],t[2],t[3])}4j+=t[1]}}}1i{if(83=="s"){if(cW==2||cW==3){bb=bb||el.6F(1);m.82(t[1],t[cW-1],bb.x+bb.1r/ 2, bb.y + bb.1y /2);sx*=t[1];sy*=t[cW-1]}1i{if(cW==5){if(8t){x2=eH.x(t[3],t[4]);y2=eH.y(t[3],t[4]);m.82(t[1],t[2],x2,y2)}1i{m.82(t[1],t[2],t[3],t[4])}sx*=t[1];sy*=t[2]}}}1i{if(83=="m"&&cW==7){m.54(t[1],t[2],t[3],t[4],t[5],t[6])}}}}1U.f9=1;el.4v=m}}el.4v=m;1U.sx=sx;1U.sy=sy;1U.4j=4j;1U.dx=dx=m.e;1U.dy=dy=m.f;if(sx==1&&(sy==1&&(!4j&&1U.2X))){1U.2X.x+=+dx;1U.2X.y+=+dy}1i{1U.f9=1}},xi=1a(1g){K l=1g[0];3r(l.3N()){1l"t":1b[l,0,0];1l"m":1b[l,1,0,0,1,0,0];1l"r":if(1g.1e==4){1b[l,0,1g[2],1g[3]]}1i{1b[l,0]};1l"s":if(1g.1e==5){1b[l,1,1,1g[3],1g[4]]}1i{if(1g.1e==3){1b[l,1,1]}1i{1b[l,1]}}}},Gj=R.Y7=1a(t1,t2){t2=3Y(t2).3g(/\\.{3}|\\vc/g,t1);t1=R.rs(t1)||[];t2=R.rs(t2)||[];K FH=4Q(t1.1e,t2.1e),2s=[],to=[],i=0,j,jj,aZ,cZ;1o(;i<FH;i++){aZ=t1[i]||xi(t2[i]);cZ=t2[i]||xi(aZ);if(aZ[0]!=cZ[0]||(aZ[0].3N()=="r"&&(aZ[2]!=cZ[2]||aZ[3]!=cZ[3])||aZ[0].3N()=="s"&&(aZ[3]!=cZ[3]||aZ[4]!=cZ[4]))){1b}2s[i]=[];to[i]=[];1o(j=0,jj=4Q(aZ.1e,cZ.1e);j<jj;j++){j in aZ&&(2s[i][j]=aZ[j]);j in cZ&&(to[i][j]=cZ[j])}}1b{2s:2s,to:to}};R.wP=1a(x,y,w,h){K 49;49=h==1c&&!R.is(x,"1D")?g.2Y.eg(x):x;if(49==1c){1b}if(49.6c){if(y==1c){1b{49:49,1r:49.3b.Xr||49.f6,1y:49.3b.WL||49.ba}}1i{1b{49:49,1r:y,1y:w}}}1b{49:1,x:x,y:y,1r:w,1y:h}};R.xj=xj;R.4C={};R.hM=hM;R.4v=1a(a,b,c,d,e,f){1b 1S eb(a,b,c,d,e,f)};1a eb(a,b,c,d,e,f){if(a!=1c){J.a=+a;J.b=+b;J.c=+c;J.d=+d;J.e=+e;J.f=+f}1i{J.a=1;J.b=0;J.c=0;J.d=1;J.e=0;J.f=0}}(1a(94){94.54=1a(a,b,c,d,e,f){K 2k=[[],[],[]],m=[[J.a,J.c,J.e],[J.b,J.d,J.f],[0,0,1]],4v=[[a,c,e],[b,d,f],[0,0,1]],x,y,z,1A;if(a&&a dY eb){4v=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1]]}1o(x=0;x<3;x++){1o(y=0;y<3;y++){1A=0;1o(z=0;z<3;z++){1A+=m[x][z]*4v[z][y]}2k[x][y]=1A}}J.a=2k[0][0];J.b=2k[1][0];J.c=2k[0][1];J.d=2k[1][1];J.e=2k[0][2];J.f=2k[1][2]};94.nq=1a(){K me=J,x=me.a*me.d-me.b*me.c;1b 1S eb(me.d/ x, -me.b /x,-me.c/ x, me.a /x,(me.c*me.f-me.d*me.e)/ x, (me.b * me.e - me.a * me.f) /x)};94.5R=1a(){1b 1S eb(J.a,J.b,J.c,J.d,J.e,J.f)};94.fc=1a(x,y){J.54(1,0,0,1,x,y)};94.82=1a(x,y,cx,cy){y==1c&&(y=x);(cx||cy)&&J.54(1,0,0,1,cx,cy);J.54(x,0,0,y,0,0);(cx||cy)&&J.54(1,0,0,1,-cx,-cy)};94.5q=1a(a,x,y){a=R.8R(a);x=x||0;y=y||0;K 8B=+3w.8B(a).4q(9),8o=+3w.8o(a).4q(9);J.54(8B,8o,-8o,8B,x,y);J.54(1,0,0,1,-x,-y)};94.x=1a(x,y){1b x*J.a+y*J.c+J.e};94.y=1a(x,y){1b x*J.b+y*J.d+J.f};94.4u=1a(i){1b+J[3Y.xk(97+i)].4q(4)};94.3s=1a(){1b R.41?"4v("+[J.4u(0),J.4u(1),J.4u(2),J.4u(3),J.4u(4),J.4u(5)].4H()+")":[J.4u(0),J.4u(2),J.4u(1),J.4u(3),0,0].4H()};94.Nx=1a(){1b"za:CZ.z9.eb(WN="+J.4u(0)+", WK="+J.4u(2)+", WH="+J.4u(1)+", WI="+J.4u(3)+", Dx="+J.4u(4)+", Dy="+J.4u(5)+", WT=\'6l WU\')"};94.2y=1a(){1b[J.e.4q(4),J.f.4q(4)]};1a rb(a){1b a[0]*a[0]+a[1]*a[1]}1a xh(a){K xg=3w.9M(rb(a));a[0]&&(a[0]/=xg);a[1]&&(a[1]/=xg)}94.3q=1a(){K 2k={};2k.dx=J.e;2k.dy=J.f;K 1I=[[J.a,J.c],[J.b,J.d]];2k.fU=3w.9M(rb(1I[0]));xh(1I[0]);2k.h7=1I[0][0]*1I[1][0]+1I[0][1]*1I[1][1];1I[1]=[1I[1][0]-1I[0][0]*2k.h7,1I[1][1]-1I[0][1]*2k.h7];2k.ep=3w.9M(rb(1I[1]));xh(1I[1]);2k.h7/=2k.ep;K 8o=-1I[0][1],8B=1I[1][1];if(8B<0){2k.5q=R.4j(3w.Fv(8B));if(8o<0){2k.5q=8r-2k.5q}}1i{2k.5q=R.4j(3w.qV(8o))}2k.va=!+2k.h7.4q(9)&&(2k.fU.4q(9)==2k.ep.4q(9)||!2k.5q);2k.WV=!+2k.h7.4q(9)&&(2k.fU.4q(9)==2k.ep.4q(9)&&!2k.5q);2k.NG=!+2k.h7.4q(9)&&!2k.5q;1b 2k};94.WS=1a(FB){K s=FB||J[3q]();if(s.va){s.fU=+s.fU.4q(4);s.ep=+s.ep.4q(4);s.5q=+s.5q.4q(4);1b(s.dx||s.dy?"t"+[s.dx,s.dy]:E)+(s.fU!=1||s.ep!=1?"s"+[s.fU,s.ep,0,0]:E)+(s.5q?"r"+[s.5q,0,0]:E)}1i{1b"m"+[J.4u(0),J.4u(1),J.4u(2),J.4u(3),J.4u(4),J.4u(5)]}}})(eb.2T);K 5M=aW.ew.3e(/WP\\/(.*?)\\s/)||aW.ew.3e(/WQ\\/(\\d+)/);if(aW.G1=="WR Ww, G3."&&(5M&&5M[1]<4||aW.Wx.3H(0,2)=="iP")||aW.G1=="Wv G3."&&(5M&&5M[1]<8)){62.ka=1a(){K 4k=J.4k(-99,-99,J.1r+99,J.1y+99).1k({1X:"3p"});6x(1a(){4k.3u()})}}1i{62.ka=qW}K 4h=1a(){J.Ws=1j},G9=1a(){1b J.d1.4h()},7X=1a(){J.Wt=1n},FS=1a(){1b J.d1.7X()},wS=1a(e){K eN=g.2Y.9S.58||g.2Y.3U.58,eK=g.2Y.9S.4S||g.2Y.3U.4S;1b{x:e.aj+eK,y:e.ap+eN}},FR=1a(){if(g.2Y.bL){1b 1a(1u,1w,fn,1f){K f=1a(e){K 3V=wS(e);1b fn.2w(1f,e,3V.x,3V.y)};1u.bL(1w,f,1j);if(mu&&mt[1w]){K FT=1a(e){K 3V=wS(e),G8=e;1o(K i=0,ii=e.qX&&e.qX.1e;i<ii;i++){if(e.qX[i].3k==1u){e=e.qX[i];e.d1=G8;e.4h=G9;e.7X=FS;1p}}1b fn.2w(1f,e,3V.x,3V.y)};1u.bL(mt[1w],FT,1j)}1b 1a(){1u.lP(1w,f,1j);if(mu&&mt[1w]){1u.lP(mt[1w],f,1j)}1b 1n}}}1i{if(g.2Y.ge){1b 1a(1u,1w,fn,1f){K f=1a(e){e=e||g.5j.1H;K eN=g.2Y.9S.58||g.2Y.3U.58,eK=g.2Y.9S.4S||g.2Y.3U.4S,x=e.aj+eK,y=e.ap+eN;e.4h=e.4h||4h;e.7X=e.7X||7X;1b fn.2w(1f,e,x,y)};1u.ge("on"+1w,f);K FP=1a(){1u.wr("on"+1w,f);1b 1n};1b FP}}}}(),5k=[],oR=1a(e){K x=e.aj,y=e.ap,eN=g.2Y.9S.58||g.2Y.3U.58,eK=g.2Y.9S.4S||g.2Y.3U.4S,7H,j=5k.1e;45(j--){7H=5k[j];if(mu&&e.hq){K i=e.hq.1e,9l;45(i--){9l=e.hq[i];if(9l.r0==7H.el.cS.id){x=9l.aj;y=9l.ap;(e.d1?e.d1:e).4h();1p}}}1i{e.4h()}K 1s=7H.el.1s,o,3m=1s.iI,1L=1s.3n,5p=1s.3b.5p;g.5j.xJ&&1L.7o(1s);1s.3b.5p="3p";o=7H.el.2u.Fi(x,y);1s.3b.5p=5p;g.5j.xJ&&(3m?1L.6Y(1s,3m):1L.3G(1s));o&&2R("46.5k.iM."+7H.el.id,7H.el,o);x+=eK;y+=eN;2R("46.5k.dD."+7H.el.id,7H.kn||7H.el,x-7H.el.cS.x,y-7H.el.cS.y,x,y,e)}},oY=1a(e){R.EF(oR).EN(oY);K i=5k.1e,7H;45(i--){7H=5k[i];7H.el.cS={};2R("46.5k.4z."+7H.el.id,7H.r3||(7H.nn||(7H.kn||7H.el)),e)}5k=[]},3d=R.el={};1o(K i=4t.1e;i--;){(1a(c0){R[c0]=3d[c0]=1a(fn,eF){if(R.is(fn,"1a")){J.4t=J.4t||[];J.4t.1C({1z:c0,f:fn,7Y:FR(J.cz||(J.1s||g.2Y),c0,fn,eF||J)})}1b J};R["un"+c0]=3d["un"+c0]=1a(fn){K 4t=J.4t||[],l=4t.1e;45(l--){if(4t[l].1z==c0&&(R.is(fn,"2O")||4t[l].f==fn)){4t[l].7Y();4t.5f(l,1);!4t.1e&&42 J.4t}}1b J}})(4t[i])}3d.1h=1a(1q,1m){K 1h=hh[J.id]=hh[J.id]||{};if(2q.1e==0){1b 1h}if(2q.1e==1){if(R.is(1q,"1D")){1o(K i in 1q){if(1q[3o](i)){J.1h(i,1q[i])}}1b J}2R("46.1h.4u."+J.id,J,1h[1q],1q);1b 1h[1q]}1h[1q]=1m;2R("46.1h.5v."+J.id,J,1m,1q);1b J};3d.tm=1a(1q){if(1q==1c){hh[J.id]={}}1i{hh[J.id]&&42 hh[J.id][1q]}1b J};3d.WE=1a(){1b 5R(hh[J.id]||{})};3d.6y=1a(r7,r8,x6,FX){1b J.hL(r7,x6).ea(r8,FX||x6)};3d.WF=1a(r7,r8){1b J.WG(r7).WD(r8)};K 6P=[];3d.5k=1a(wZ,wY,x0,kn,nn,r3){1a 2I(e){(e.d1||e).4h();K x=e.aj,y=e.ap,eN=g.2Y.9S.58||g.2Y.3U.58,eK=g.2Y.9S.4S||g.2Y.3U.4S;J.cS.id=e.r0;if(mu&&e.hq){K i=e.hq.1e,9l;45(i--){9l=e.hq[i];J.cS.id=9l.r0;if(9l.r0==J.cS.id){x=9l.aj;y=9l.ap;1p}}}J.cS.x=x+eK;J.cS.y=y+eN;!5k.1e&&R.9T(oR).5u(oY);5k.1C({el:J,kn:kn,nn:nn,r3:r3});wY&&2R.on("46.5k.2I."+J.id,wY);wZ&&2R.on("46.5k.dD."+J.id,wZ);x0&&2R.on("46.5k.4z."+J.id,x0);2R("46.5k.2I."+J.id,nn||(kn||J),e.aj+eK,e.ap+eN,e)}J.cS={};6P.1C({el:J,2I:2I});J.7f(2I);1b J};3d.Xi=1a(f){f?2R.on("46.5k.iM."+J.id,f):2R.7Y("46.5k.iM."+J.id)};3d.Xf=1a(){K i=6P.1e;45(i--){if(6P[i].el==J){J.Xc(6P[i].2I);6P.5f(i,1);2R.7Y("46.5k.*."+J.id)}}!6P.1e&&R.EF(oR).EN(oY);5k=[]};62.9m=1a(x,y,r){K 2k=R.4C.9m(J,x||0,y||0,r||0);J.6W&&J.6W.1C(2k);1b 2k};62.4k=1a(x,y,w,h,r){K 2k=R.4C.4k(J,x||0,y||0,w||0,h||0,r||0);J.6W&&J.6W.1C(2k);1b 2k};62.aM=1a(x,y,rx,ry){K 2k=R.4C.aM(J,x||0,y||0,rx||0,ry||0);J.6W&&J.6W.1C(2k);1b 2k};62.1G=1a(8l){8l&&(!R.is(8l,4e)&&(!R.is(8l[0],3I)&&(8l+=E)));K 2k=R.4C.1G(R.6v[3c](R,2q),J);J.6W&&J.6W.1C(2k);1b 2k};62.8O=1a(4b,x,y,w,h){K 2k=R.4C.8O(J,4b||"EJ:yH",x||0,y||0,w||0,h||0);J.6W&&J.6W.1C(2k);1b 2k};62.1Y=1a(x,y,1Y){K 2k=R.4C.1Y(J,x||0,y||0,3Y(1Y));J.6W&&J.6W.1C(2k);1b 2k};62.5v=1a(oS){!R.is(oS,"3I")&&(oS=43.2T.5f.2w(2q,0,2q.1e));K 2k=1S jC(oS);J.6W&&J.6W.1C(2k);2k["2u"]=J;2k["1w"]="5v";1b 2k};62.Xj=1a(5v){J.6W=5v||J.5v()};62.Xo=1a(5v){K 2k=J.6W;42 J.6W;1b 2k};62.km=1a(1r,1y){1b R.4C.km.2w(J,1r,1y)};62.fP=1a(x,y,w,h,9W){1b R.4C.fP.2w(J,x,y,w,h,9W)};62.1O=62.4I=1c;62.46=R;K Fj=1a(6i){K 51=6i.vz(),2Y=6i.vJ,3U=2Y.3U,dP=2Y.9S,hZ=dP.hZ||(3U.hZ||0),hV=dP.hV||(3U.hV||0),1O=51.1O+(g.5j.Fh||(dP.58||3U.58))-hZ,2a=51.2a+(g.5j.Xp||(dP.4S||3U.4S))-hV;1b{y:1O,x:2a}};62.Fi=1a(x,y){K 2u=J,41=2u.1V,3k=g.2Y.p9(x,y);if(g.5j.xJ&&3k.6c=="41"){K so=Fj(41),sr=41.Xq();sr.x=x-so.x;sr.y=y-so.y;sr.1r=sr.1y=1;K oD=41.Xk(sr,1c);if(oD.1e){3k=oD[oD.1e-1]}}if(!3k){1b 1c}45(3k.3n&&(3k!=41.3n&&!3k.46)){3k=3k.3n}3k==2u.1V.3n&&(3k=41);3k=3k&&3k.46?2u.Fp(3k.vp):1c;1b 3k};62.Xm=1a(2X){K 5v=J.5v();J.8F(1a(el){if(R.xG(el.6F(),2X)){5v.1C(el)}});1b 5v};62.Fp=1a(id){K bY=J.4I;45(bY){if(bY.id==id){1b bY}bY=bY.3m}1b 1c};62.8F=1a(1Z,oy){K bY=J.4I;45(bY){if(1Z.2w(oy,bY)===1j){1b J}bY=bY.3m}1b J};62.X2=1a(x,y){K 5v=J.5v();J.8F(1a(el){if(el.g4(x,y)){5v.1C(el)}});1b 5v};1a X3(){1b J.x+S+J.y}1a xo(){1b J.x+S+J.y+S+J.1r+" \\X0 "+J.1y}3d.g4=1a(x,y){K rp=J.fF=bz[J.1w](J);if(J.1k("3A")&&J.1k("3A").1e){rp=R.pC(rp,J.1k("3A"))}1b R.F5(rp,x,y)};3d.6F=1a(F7){if(J.5d){1b{}}K 1U=J.1U;if(F7){if(1U.7J||!1U.nJ){J.fF=bz[J.1w](J);1U.nJ=oB(J.fF);1U.nJ.3s=xo;1U.7J=0}1b 1U.nJ}if(1U.7J||(1U.f9||!1U.2X)){if(1U.7J||!J.fF){1U.nJ=0;J.fF=bz[J.1w](J)}1U.2X=oB(nK(J.fF,J.4v));1U.2X.3s=xo;1U.7J=1U.f9=0}1b 1U.2X};3d.5R=1a(){if(J.5d){1b 1c}K 2k=J.2u[J.1w]().1k(J.1k());J.6W&&J.6W.1C(2k);1b 2k};3d.bp=1a(bp){if(J.1w=="1Y"){1b 1c}bp=bp||{};K s={1r:(bp.1r||10)+(+J.1k("1X-1r")||1),28:bp.28||1j,2G:bp.2G||0.5,xp:bp.xp||0,xq:bp.xq||0,3t:bp.3t||"#cm"},c=s.1r/2,r=J.2u,2k=r.5v(),1G=J.fF||bz[J.1w](J);1G=J.4v?nK(1G,J.4v):1G;1o(K i=1;i<c+1;i++){2k.1C(r.1G(1G).1k({1X:s.3t,28:s.28?s.3t:"3p","1X-g3":"4G","1X-cA":"4G","1X-1r":+(s.1r/ c * i).4q(3), 2G:+(s.2G /c).4q(3)}))}1b 2k.6Y(J).fc(s.xp,s.xq)};K X4={},oG=1a(5y,5Z,64,6f,77,74,7q,7m,1e){if(1e==1c){1b gM(5y,5Z,64,6f,77,74,7q,7m)}1i{1b R.nL(5y,5Z,64,6f,77,74,7q,7m,Fd(5y,5Z,64,6f,77,74,7q,7m,1e))}},pI=1a(xn,pd){1b 1a(1G,1e,Hg){1G=hM(1G);K x,y,p,l,sp="",om={},6r,6b=0;1o(K i=0,ii=1G.1e;i<ii;i++){p=1G[i];if(p[0]=="M"){x=+p[1];y=+p[2]}1i{l=oG(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);if(6b+l>1e){if(pd&&!om.2I){6r=oG(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-6b);sp+=["C"+6r.2I.x,6r.2I.y,6r.m.x,6r.m.y,6r.x,6r.y];if(Hg){1b sp}om.2I=sp;sp=["M"+6r.x,6r.y+"C"+6r.n.x,6r.n.y,6r.4z.x,6r.4z.y,p[5],p[6]].4H();6b+=l;x=+p[5];y=+p[6];ah}if(!xn&&!pd){6r=oG(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-6b);1b{x:6r.x,y:6r.y,d9:6r.d9}}}6b+=l;x=+p[5];y=+p[6]}sp+=p.bf()+p}om.4z=sp;6r=xn?6b:pd?om:R.nL(x,y,p[0],p[1],p[2],p[3],p[4],p[5],1);6r.d9&&(6r={x:6r.x,y:6r.y,d9:6r.d9});1b 6r}};K bu=pI(1),nG=pI(),pX=pI(0,1);R.bu=bu;R.nG=nG;R.nF=1a(1G,2s,to){if(J.bu(1G)-to<1E-6){1b pX(1G,2s).4z}K a=pX(1G,to,1);1b 2s?pX(a,2s).4z:a};3d.bu=1a(){K 1G=J.bz();if(!1G){1b}if(J.1s.bu){1b J.1s.bu()}1b bu(1G)};3d.nG=1a(1e){K 1G=J.bz();if(!1G){1b}1b nG(1G,1e)};3d.bz=1a(){K 1G,bz=R.uD[J.1w];if(J.1w=="1Y"||J.1w=="5v"){1b}if(bz){1G=bz(J)}1b 1G};3d.nF=1a(2s,to){K 1G=J.bz();if(!1G){1b}1b R.nF(1G,2s,to)};K ef=R.Gk={mD:1a(n){1b n},"<":1a(n){1b 5L(n,1.7)},">":1a(n){1b 5L(n,0.48)},"<>":1a(n){K q=0.48-n/ 1.ZP, Q = 3w.9M(0.ZS + q * q), x = Q - q, X = 5L(4a(x), 1 /3)*(x<0?-1:1),y=-Q-q,Y=5L(4a(y),1/3)*(y<0?-1:1),t=X+Y+0.5;1b(1-t)*3*t*t+t*t*t},H9:1a(n){K s=1.H4;1b n*n*((s+1)*n-s)},HG:1a(n){n=n-1;K s=1.H4;1b n*n*((s+1)*n+s)+1},ZL:1a(n){if(n==!!n){1b n}1b 5L(2,-10*n)*3w.8o((n-0.H6)*(2*PI)/0.3)+1},ZN:1a(n){K s=7.ZY,p=2.75,l;if(n<1/p){l=s*n*n}1i{if(n<2/p){n-=1.5/p;l=s*n*n+0.75}1i{if(n<2.5/p){n-=2.25/p;l=s*n*n+0.ZX}1i{n-=2.101/p;l=s*n*n+0.ZZ}}}1b l}};ef.ZU=ef["zI-in"]=ef["<"];ef.ZT=ef["zI-2k"]=ef[">"];ef.ZW=ef["zI-in-2k"]=ef["<>"];ef["zJ-in"]=ef.H9;ef["zJ-2k"]=ef.HG;K 4X=[],Ag=3Q.ZK||(3Q.Zz||(3Q.Zy||(3Q.ZB||(3Q.ZA||1a(1Z){6x(1Z,16)})))),6O=1a(){K HM=+1S 5m,l=0;1o(;l<4X.1e;l++){K e=4X[l];if(e.el.5d||e.Ah){ah}K et=HM-e.2I,ms=e.ms,5E=e.5E,2s=e.2s,5F=e.5F,to=e.to,t=e.t,65=e.el,5v={},7b,80={},1q;if(e.jF){et=(e.jF*e.2A.1O-e.3P)/(e.ad-e.3P)*ms;e.6G=e.jF;42 e.jF;e.5B&&4X.5f(l--,1)}1i{e.6G=(e.3P+(e.ad-e.3P)*(et/ ms)) /e.2A.1O}if(et<0){ah}if(et<ms){K 3V=5E(et/ms);1o(K 1k in 2s){if(2s[3o](1k)){3r(pl[1k]){1l nu:7b=+2s[1k]+3V*ms*5F[1k];1p;1l"9s":7b="3E("+[pQ(4G(2s[1k].r+3V*ms*5F[1k].r)),pQ(4G(2s[1k].g+3V*ms*5F[1k].g)),pQ(4G(2s[1k].b+3V*ms*5F[1k].b))].4H(",")+")";1p;1l"1G":7b=[];1o(K i=0,ii=2s[1k].1e;i<ii;i++){7b[i]=[2s[1k][i][0]];1o(K j=1,jj=2s[1k][i].1e;j<jj;j++){7b[i][j]=+2s[1k][i][j]+3V*ms*5F[1k][i][j]}7b[i]=7b[i].4H(S)}7b=7b.4H(S);1p;1l"3A":if(5F[1k].Ge){7b=[];1o(i=0,ii=2s[1k].1e;i<ii;i++){7b[i]=[2s[1k][i][0]];1o(j=1,jj=2s[1k][i].1e;j<jj;j++){7b[i][j]=2s[1k][i][j]+3V*ms*5F[1k][i][j]}}}1i{K 4u=1a(i){1b+2s[1k][i]+3V*ms*5F[1k][i]};7b=[["m",4u(0),4u(1),4u(2),4u(3),4u(4),4u(5)]]}1p;1l"zC":if(1k=="6h-4k"){7b=[];i=4;45(i--){7b[i]=+2s[1k][i]+3V*ms*5F[1k][i]}}1p;5o:K hJ=[][3x](2s[1k]);7b=[];i=65.2u.8E[1k].1e;45(i--){7b[i]=+hJ[i]+3V*ms*5F[1k][i]}1p}5v[1k]=7b}}65.1k(5v);(1a(id,65,2A){6x(1a(){2R("46.2A.pr."+id,65,2A)})})(65.id,65,e.2A)}1i{(1a(f,el,a){6x(1a(){2R("46.2A.pr."+el.id,el,a);2R("46.2A.Zv."+el.id,el,a);R.is(f,"1a")&&f.2w(el)})})(e.1Z,65,e.2A);65.1k(to);4X.5f(l--,1);if(e.jN>1&&!e.3m){1o(1q in to){if(to[3o](1q)){80[1q]=e.hC[1q]}}e.el.1k(80);jD(e.2A,e.el,e.2A.89[0],1c,e.hC,e.jN-1)}if(e.3m&&!e.5B){jD(e.2A,e.el,e.3m,1c,e.hC,e.jN)}}}R.41&&(65&&(65.2u&&65.2u.ka()));4X.1e&&Ag(6O)},pQ=1a(3t){1b 3t>e0?e0:3t<0?0:3t};3d.GL=1a(el,2A,1v,ms,5E,1Z){K 1f=J;if(1f.5d){1Z&&1Z.2w(1f);1b 1f}K a=1v dY cT?1v:R.6O(1v,ms,5E,1Z),x,y;jD(a,1f,a.89[0],1c,1f.1k());1o(K i=0,ii=4X.1e;i<ii;i++){if(4X[i].2A==2A&&4X[i].el==el){4X[ii-1].2I=4X[i].2I;1p}}1b 1f};1a GC(t,5y,5Z,7q,7m,6S){K cx=3*5y,bx=3*(7q-5y)-cx,ax=1-cx-bx,cy=3*5Z,by=3*(7m-5Z)-cy,ay=1-cy-by;1a zy(t){1b((ax*t+bx)*t+cx)*t}1a Gt(x,mZ){K t=Hz(x,mZ);1b((ay*t+by)*t+cy)*t}1a Hz(x,mZ){K t0,t1,t2,x2,d2,i;1o(t2=x,i=0;i<8;i++){x2=zy(t2)-x;if(4a(x2)<mZ){1b t2}d2=(3*ax*t2+2*bx)*t2+cx;if(4a(d2)<1E-6){1p}t2=t2-x2/d2}t0=0;t1=1;t2=x;if(t2<t0){1b t0}if(t2>t1){1b t1}45(t0<t1){x2=zy(t2);if(4a(x2-x)<mZ){1b t2}if(x>x2){t0=t2}1i{t1=t2}t2=(t1-t0)/2+t0}1b t2}1b Gt(t,1/(ff*6S))}3d.ZF=1a(f){f?2R.on("46.2A.pr."+J.id,f):2R.7Y("46.2A.pr."+J.id);1b J};1a cT(2A,ms){K 89=[],zv={};J.ms=ms;J.bX=1;if(2A){1o(K 1k in 2A){if(2A[3o](1k)){zv[3z(1k)]=2A[1k];89.1C(3z(1k))}}89.eZ(Gq)}J.2A=zv;J.1O=89[89.1e-1];J.89=89}cT.2T.fo=1a(fo){K a=1S cT(J.2A,J.ms);a.bX=J.bX;a.pg=+fo||0;1b a};cT.2T.jN=1a(bX){K a=1S cT(J.2A,J.ms);a.pg=J.pg;a.bX=3w.gF(4Q(bX,0))||1;1b a};1a jD(2A,1f,ad,6G,hC,bX){ad=3z(ad);K 1v,hz,pK,89=[],3m,3P,n0,ms=2A.ms,2s={},to={},5F={};if(6G){1o(i=0,ii=4X.1e;i<ii;i++){K e=4X[i];if(e.el.id==1f.id&&e.2A==2A){if(e.ad!=ad){4X.5f(i,1);pK=1}1i{hz=e}1f.1k(e.hC);1p}}}1i{6G=+to}1o(K i=0,ii=2A.89.1e;i<ii;i++){if(2A.89[i]==ad||2A.89[i]>6G*2A.1O){ad=2A.89[i];3P=2A.89[i-1]||0;ms=ms/2A.1O*(ad-3P);3m=2A.89[i+1];1v=2A.2A[ad];1p}1i{if(6G){1f.1k(2A.2A[2A.89[i]])}}}if(!1v){1b}if(!hz){1o(K 1k in 1v){if(1v[3o](1k)){if(pl[3o](1k)||1f.2u.8E[3o](1k)){2s[1k]=1f.1k(1k);2s[1k]==1c&&(2s[1k]=Gz[1k]);to[1k]=1v[1k];3r(pl[1k]){1l nu:5F[1k]=(to[1k]-2s[1k])/ms;1p;1l"9s":2s[1k]=R.bM(2s[1k]);K pf=R.bM(to[1k]);5F[1k]={r:(pf.r-2s[1k].r)/ ms, g:(pf.g - 2s[1k].g) /ms,b:(pf.b-2s[1k].b)/ms};1p;1l"1G":K zF=hM(2s[1k],to[1k]),Gi=zF[1];2s[1k]=zF[0];5F[1k]=[];1o(i=0,ii=2s[1k].1e;i<ii;i++){5F[1k][i]=[0];1o(K j=1,jj=2s[1k][i].1e;j<jj;j++){5F[1k][i][j]=(Gi[i][j]-2s[1k][i][j])/ms}}1p;1l"3A":K 1U=1f.1U,eq=Gj(1U[1k],to[1k]);if(eq){2s[1k]=eq.2s;to[1k]=eq.to;5F[1k]=[];5F[1k].Ge=1n;1o(i=0,ii=2s[1k].1e;i<ii;i++){5F[1k][i]=[2s[1k][i][0]];1o(j=1,jj=2s[1k][i].1e;j<jj;j++){5F[1k][i][j]=(to[1k][i][j]-2s[1k][i][j])/ms}}}1i{K m=1f.4v||1S eb,e6={1U:{3A:1U.3A},6F:1a(){1b 1f.6F(1)}};2s[1k]=[m.a,m.b,m.c,m.d,m.e,m.f];zG(e6,to[1k]);to[1k]=e6.1U.3A;5F[1k]=[(e6.4v.a-m.a)/ ms, (e6.4v.b - m.b) /ms,(e6.4v.c-m.c)/ ms, (e6.4v.d - m.d) /ms,(e6.4v.e-m.e)/ ms, (e6.4v.f - m.f) /ms]}1p;1l"zC":K 2H=3Y(1v[1k])[3q](5n),hJ=3Y(2s[1k])[3q](5n);if(1k=="6h-4k"){2s[1k]=hJ;5F[1k]=[];i=hJ.1e;45(i--){5F[1k][i]=(2H[i]-2s[1k][i])/ms}}to[1k]=2H;1p;5o:2H=[][3x](1v[1k]);hJ=[][3x](2s[1k]);5F[1k]=[];i=1f.2u.8E[1k].1e;45(i--){5F[1k][i]=((2H[i]||0)-(hJ[i]||0))/ms}1p}}}}K 5E=1v.5E,dW=R.Gk[5E];if(!dW){dW=3Y(5E).3e(Gm);if(dW&&dW.1e==5){K fe=dW;dW=1a(t){1b GC(t,+fe[1],+fe[2],+fe[3],+fe[4],ms)}}1i{dW=GS}}n0=1v.2I||(2A.2I||+1S 5m);e={2A:2A,ad:ad,n0:n0,2I:n0+(2A.pg||0),6G:0,jF:6G||0,5B:1j,ms:ms,5E:dW,2s:2s,5F:5F,to:to,el:1f,1Z:1v.1Z,3P:3P,3m:3m,jN:bX||2A.bX,f0:1f.1k(),hC:hC};4X.1C(e);if(6G&&(!hz&&!pK)){e.5B=1n;e.2I=1S 5m-ms*6G;if(4X.1e==1){1b 6O()}}if(pK){e.2I=1S 5m-e.ms*6G}4X.1e==1&&Ag(6O)}1i{hz.jF=6G;hz.2I=1S 5m-hz.ms*6G}2R("46.2A.2I."+1f.id,1f,2A)}R.6O=1a(1v,ms,5E,1Z){if(1v dY cT){1b 1v}if(R.is(5E,"1a")||!5E){1Z=1Z||(5E||1c);5E=1c}1v=4J(1v);ms=+ms||0;K p={},e2,1k;1o(1k in 1v){if(1v[3o](1k)&&(3z(1k)!=1k&&3z(1k)+"%"!=1k)){e2=1n;p[1k]=1v[1k]}}if(!e2){1b 1S cT(1v,ms)}1i{5E&&(p.5E=5E);1Z&&(p.1Z=1Z);1b 1S cT({100:p},ms)}};3d.4K=1a(1v,ms,5E,1Z){K 1f=J;if(1f.5d){1Z&&1Z.2w(1f);1b 1f}K 2A=1v dY cT?1v:R.6O(1v,ms,5E,1Z);jD(2A,1f,2A.89[0],1c,1f.1k());1b 1f};3d.10c=1a(2A,1m){if(2A&&1m!=1c){J.6G(2A,5W(1m,2A.ms)/2A.ms)}1b J};3d.6G=1a(2A,1m){K 2k=[],i=0,6b,e;if(1m!=1c){jD(2A,J,-1,5W(1m,1));1b J}1i{6b=4X.1e;1o(;i<6b;i++){e=4X[i];if(e.el.id==J.id&&(!2A||e.2A==2A)){if(2A){1b e.6G}2k.1C({2A:e.2A,6G:e.6G})}}if(2A){1b 0}1b 2k}};3d.GW=1a(2A){1o(K i=0;i<4X.1e;i++){if(4X[i].el.id==J.id&&(!2A||4X[i].2A==2A)){if(2R("46.2A.GW."+J.id,J,4X[i].2A)!==1j){4X[i].Ah=1n}}}1b J};3d.GX=1a(2A){1o(K i=0;i<4X.1e;i++){if(4X[i].el.id==J.id&&(!2A||4X[i].2A==2A)){K e=4X[i];if(2R("46.2A.GX."+J.id,J,e.2A)!==1j){42 e.Ah;J.6G(e.2A,e.6G)}}}1b J};3d.5B=1a(2A){1o(K i=0;i<4X.1e;i++){if(4X[i].el.id==J.id&&(!2A||4X[i].2A==2A)){if(2R("46.2A.5B."+J.id,J,4X[i].2A)!==1j){4X.5f(i--,1)}}}1b J};1a Ai(2u){1o(K i=0;i<4X.1e;i++){if(4X[i].el.2u==2u){4X.5f(i--,1)}}}2R.on("46.3u",Ai);2R.on("46.a0",Ai);3d.3s=1a(){1b"gk\\gd\\10b 1D"};K jC=1a(1F){J.1F=[];J.1e=0;J.1w="5v";if(1F){1o(K i=0,ii=1F.1e;i<ii;i++){if(1F[i]&&(1F[i].4U==3d.4U||1F[i].4U==jC)){J[J.1F.1e]=J.1F[J.1F.1e]=1F[i];J.1e++}}}},6L=jC.2T;6L.1C=1a(){K 1g,6b;1o(K i=0,ii=2q.1e;i<ii;i++){1g=2q[i];if(1g&&(1g.4U==3d.4U||1g.4U==jC)){6b=J.1F.1e;J[6b]=J.1F[6b]=1g;J.1e++}}1b J};6L.cQ=1a(){J.1e&&42 J[J.1e--];1b J.1F.cQ()};6L.8F=1a(1Z,oy){1o(K i=0,ii=J.1F.1e;i<ii;i++){if(1Z.2w(oy,J.1F[i],i)===1j){1b J}}1b J};1o(K 44 in 3d){if(3d[3o](44)){6L[44]=1a(eC){1b 1a(){K 4i=2q;1b J.8F(1a(el){el[eC][3c](el,4i)})}}(44)}}6L.1k=1a(1z,1m){if(1z&&(R.is(1z,3I)&&R.is(1z[0],"1D"))){1o(K j=0,jj=1z.1e;j<jj;j++){J.1F[j].1k(1z[j])}}1i{1o(K i=0,ii=J.1F.1e;i<ii;i++){J.1F[i].1k(1z,1m)}}1b J};6L.a0=1a(){45(J.1e){J.cQ()}};6L.5f=1a(1P,6E,104){1P=1P<0?4Q(J.1e+1P,0):1P;6E=4Q(0,5W(J.1e-1P,6E));K p6=[],Af=[],2e=[],i;1o(i=2;i<2q.1e;i++){2e.1C(2q[i])}1o(i=0;i<6E;i++){Af.1C(J[1P+i])}1o(;i<J.1e-1P;i++){p6.1C(J[1P+i])}K ng=2e.1e;1o(i=0;i<ng+p6.1e;i++){J.1F[1P+i]=J[1P+i]=i<ng?2e[i]:p6[i-ng]}i=J.1F.1e=J.1e-=6E-ng;45(J[i]){42 J[i++]}1b 1S jC(Af)};6L.uK=1a(el){1o(K i=0,ii=J.1e;i<ii;i++){if(J[i]==el){J.5f(i,1);1b 1n}}};6L.4K=1a(1v,ms,5E,1Z){(R.is(5E,"1a")||!5E)&&(1Z=5E||1c);K 6b=J.1F.1e,i=6b,1g,5v=J,p8;if(!6b){1b J}1Z&&(p8=1a(){!--6b&&1Z.2w(5v)});5E=R.is(5E,4e)?5E:p8;K 2A=R.6O(1v,ms,5E,p8);1g=J.1F[--i].4K(2A);45(i--){J.1F[i]&&(!J.1F[i].5d&&J.1F[i].GL(1g,2A,2A));J.1F[i]&&!J.1F[i].5d||6b--}1b J};6L.e7=1a(el){K i=J.1F.1e;45(i--){J.1F[i].e7(el)}1b J};6L.6F=1a(){K x=[],y=[],x2=[],y2=[];1o(K i=J.1F.1e;i--;){if(!J.1F[i].5d){K 51=J.1F[i].6F();x.1C(51.x);y.1C(51.y);x2.1C(51.x+51.1r);y2.1C(51.y+51.1y)}}x=5W[3c](0,x);y=5W[3c](0,y);x2=4Q[3c](0,x2);y2=4Q[3c](0,y2);1b{x:x,y:y,x2:x2,y2:y2,1r:x2-x,1y:y2-y}};6L.5R=1a(s){s=J.2u.5v();1o(K i=0,ii=J.1F.1e;i<ii;i++){s.1C(J.1F[i].5R())}1b s};6L.3s=1a(){1b"gk\\gd\\106 5v"};6L.bp=1a(CV){K 7S=J.2u.5v();J.8F(1a(cz,1P){K g=cz.bp(CV);if(g!=1c){g.8F(1a(D0,10e){7S.1C(D0)})}});1b 7S};6L.g4=1a(x,y){K g4=1j;J.8F(1a(el){if(el.g4(x,y)){g4=1n;1b 1j}});1b g4};R.10f=1a(2M){if(!2M.8Q){1b 2M}J.dm=J.dm||{};K g6={w:2M.w,8Q:{},fb:{}},84=2M.8Q["2M-84"];1o(K 6T in 2M.8Q){if(2M.8Q[3o](6T)){g6.8Q[6T]=2M.8Q[6T]}}if(J.dm[84]){J.dm[84].1C(g6)}1i{J.dm[84]=[g6]}if(!2M.41){g6.8Q["zY-zZ-em"]=9z(2M.8Q["zY-zZ-em"],10);1o(K nb in 2M.fb){if(2M.fb[3o](nb)){K 1G=2M.fb[nb];g6.fb[nb]={w:1G.w,k:{},d:1G.d&&"M"+1G.d.3g(/[10i]/g,1a(83){1b{l:"L",c:"C",x:"z",t:"m",r:"l",v:"c"}[83]||"M"})+"z"};if(1G.k){1o(K k in 1G.k){if(1G[3o](k)){g6.fb[nb].k[k]=1G.k[k]}}}}}}1b 2M};62.Da=1a(84,9K,3b,nl){nl=nl||"pJ";3b=3b||"pJ";9K=+9K||({pJ:ol,YP:YO,YJ:t9,YI:ss}[9K]||ol);if(!R.dm){1b}K 2M=R.dm[84];if(!2M){K 1z=1S cY("(^|\\\\s)"+84.3g(/[^\\w\\d\\s+!~.:1U-]/g,E)+"(\\\\s|$)","i");1o(K pV in R.dm){if(R.dm[3o](pV)){if(1z.9V(pV)){2M=R.dm[pV];1p}}}}K g5;if(2M){1o(K i=0,ii=2M.1e;i<ii;i++){g5=2M[i];if(g5.8Q["2M-9K"]==9K&&((g5.8Q["2M-3b"]==3b||!g5.8Q["2M-3b"])&&g5.8Q["2M-nl"]==nl)){1p}}}1b g5};62.YL=1a(x,y,4e,2M,56,f0,pw,pv){f0=f0||"zs";pw=4Q(5W(pw||0,1),-1);pv=4Q(5W(pv||1,3),1);K jL=3Y(4e)[3q](E),bf=0,n3=0,1G=E,82;R.is(2M,"4e")&&(2M=J.Da(2M));if(2M){82=(56||16)/2M.8Q["zY-zZ-em"];K bb=2M.8Q.2X[3q](5n),1O=+bb[0],pA=bb[3]-bb[1],zW=0,1y=+bb[1]+(f0=="YV"?pA+ +2M.8Q.YU:pA/2);1o(K i=0,ii=jL.1e;i<ii;i++){if(jL[i]=="\\n"){bf=0;n4=0;n3=0;zW+=pA*pv}1i{K 3P=n3&&2M.fb[jL[i-1]]||{},n4=2M.fb[jL[i]];bf+=n3?(3P.w||2M.w)+(3P.k&&3P.k[jL[i]]||0)+2M.w*pw:0;n3=1}if(n4&&n4.d){1G+=R.pC(n4.d,["t",bf*82,zW*82,"s",82,82,1O,1y,"t",(x-1O)/ 82, (y - 1y) /82])}}}1b J.1G(1G).1k({28:"#cm",1X:"3p"})};62.54=1a(e2){if(R.is(e2,"3I")){K 1A=J.5v(),i=0,ii=e2.1e,j;1o(;i<ii;i++){j=e2[i]||{};9u[3o](j.1w)&&1A.1C(J[j.1w]().1k(j))}}1b 1A};R.6v=1a(c4,1v){K 2e=R.is(1v,3I)?[0][3x](1v):2q;c4&&(R.is(c4,4e)&&(2e.1e-1&&(c4=c4.3g(CH,1a(76,i){1b 2e[++i]==1c?E:2e[i]}))));1b c4||E};R.Yx=1a(){K Dj=/\\{([^\\}]+)\\}/g,Ct=/(?:(?:^|\\.)(.+?)(?=\\[|\\.|$|\\()|\\[(\'|")(.+?)\\2\\])(\\(\\))?/g,Eb=1a(6o,1q,1u){K 1A=1u;1q.3g(Ct,1a(6o,1z,Cy,Cw,Cx){1z=1z||Cw;if(1A){if(1z in 1A){1A=1A[1z]}2K 1A=="1a"&&(Cx&&(1A=1A()))}});1A=(1A==1c||1A==1u?6o:1A)+"";1b 1A};1b 1a(76,1u){1b 5l(76).3g(Dj,1a(6o,1q){1b Eb(6o,1q,1u)})}}();R.Yw=1a(){oN.vF?g.5j.bk=oN.is:42 bk;1b R};R.st=6L;(1a(2Y,ai,f){if(2Y.mY==1c&&2Y.bL){2Y.bL(ai,f=1a(){2Y.lP(ai,f,1j);2Y.mY="HQ"},1j);2Y.mY="tJ"}1a A0(){/in/.9V(2Y.mY)?6x(A0,9):R.2R("46.iy")}A0()})(2N,"Ys");2R.on("46.iy",1a(){ai=1n});(1a(){if(!R.41){1b}K 3o="7P",3Y=5l,3z=d5,9z=6p,3w=3D,4Q=3w.4y,4a=3w.4a,5L=3w.5L,5n=/[, ]+/,2R=R.2R,E="",S=" ";K cR="6H://nz.w3.r5/Yv/cR",Dv={7a:"M5,0 0,2.5 5,5z",mp:"M5,0 0,2.5 5,5 3.5,3 3.5,2z",qi:"M2.5,0 5,2.5 2.5,5 0,2.5z",6Q:"M6,1 1,3.5 6,6",qe:"M2.5,YA.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,YD"},bq={};R.3s=1a(){1b"LN qK YC c5.\\LV qg ze gk\\gd "+J.5M};K $=1a(el,1k){if(1k){if(2K el=="4e"){el=$(el)}1o(K 1q in 1k){if(1k[3o](1q)){if(1q.fY(0,6)=="cR:"){el.nv(cR,1q.fY(6),3Y(1k[1q]))}1i{el.b1(1q,3Y(1k[1q]))}}}}1i{el=R.7x.2Y.Zj("6H://nz.w3.r5/Cp/41",el);el.3b&&(el.3b.Zi="yX(0,0,0,0)")}1b el},mG=1a(1f,3O){K 1w="mD",id=1f.id+3O,fx=0.5,fy=0.5,o=1f.1s,c5=1f.2u,s=o.3b,el=R.7x.2Y.eg(id);if(!el){3O=3Y(3O).3g(R.v6,1a(6o,yY,yT){1w="qA";if(yY&&yT){fx=3z(yY);fy=3z(yT);K yU=(fy>0.5)*2-1;5L(fx-0.5,2)+5L(fy-0.5,2)>0.25&&((fy=3w.9M(0.25-5L(fx-0.5,2))*yU+0.5)&&(fy!=0.5&&(fy=fy.4q(5)-1E-5*yU)))}1b E});3O=3O.3q(/\\s*\\-\\s*/);if(1w=="mD"){K 7l=3O.bf();7l=-3z(7l);if(aa(7l)){1b 1c}K 8k=[0,0,3w.8B(R.8R(7l)),3w.8o(R.8R(7l))],4y=1/(4Q(4a(8k[2]),4a(8k[3]))||1);8k[2]*=4y;8k[3]*=4y;if(8k[2]<0){8k[0]=-8k[2];8k[2]=0}if(8k[3]<0){8k[1]=-8k[3];8k[3]=0}}K 57=R.uZ(3O);if(!57){1b 1c}id=id.3g(/[\\(\\)\\s,\\z4#]/g,"1U");if(1f.3O&&id!=1f.3O.id){c5.d3.7o(1f.3O);42 1f.3O}if(!1f.3O){el=$(1w+"Ze",{id:id});1f.3O=el;$(el,1w=="qA"?{fx:fx,fy:fy}:{x1:8k[0],y1:8k[1],x2:8k[2],y2:8k[3],Zg:1f.4v.nq()});c5.d3.3G(el);1o(K i=0,ii=57.1e;i<ii;i++){el.3G($("5B",{2y:57[i].2y?57[i].2y:i?"100%":"0%","5B-3t":57[i].3t||"#ja"}))}}}$(o,{28:"5e(#"+id+")",2G:1,"28-2G":1});s.28=E;s.2G=1;s.Zr=1;1b 1},np=1a(o){K 2X=o.6F(1);$(o.bW,{Zq:o.4v.nq()+" fc("+2X.x+","+2X.y+")"})},bE=1a(o,1m,dR){if(o.1w=="1G"){K 2H=3Y(1m).3N().3q("-"),p=o.2u,se=dR?"4z":"2I",1s=o.1s,2b=o.2b,1X=2b["1X-1r"],i=2H.1e,1w="mp",2s,to,dx,n8,1k,w=3,h=3,t=5;45(i--){3r(2H[i]){1l"7a":;1l"mp":;1l"qe":;1l"qi":;1l"6Q":;1l"3p":1w=2H[i];1p;1l"Ms":h=5;1p;1l"Mw":h=2;1p;1l"MA":w=5;1p;1l"MB":w=2;1p}}if(1w=="6Q"){w+=2;h+=2;t+=2;dx=1;n8=dR?4:1;1k={28:"3p",1X:2b.1X}}1i{n8=dx=w/2;1k={28:2b.1X,1X:"3p"}}if(o.1U.4A){if(dR){o.1U.4A.Eq&&bq[o.1U.4A.Eq]--;o.1U.4A.Er&&bq[o.1U.4A.Er]--}1i{o.1U.4A.Ep&&bq[o.1U.4A.Ep]--;o.1U.4A.Dw&&bq[o.1U.4A.Dw]--}}1i{o.1U.4A={}}if(1w!="3p"){K gJ="46-dk-"+1w,gE="46-dk-"+se+1w+w+h;if(!R.7x.2Y.eg(gJ)){p.d3.3G($($("1G"),{"1X-cA":"4G",d:Dv[1w],id:gJ}));bq[gJ]=1}1i{bq[gJ]++}K dk=R.7x.2Y.eg(gE),gI;if(!dk){dk=$($("dk"),{id:gE,Zt:h,Zs:w,Zn:"6l",n8:n8,Zm:h/2});gI=$($("gI"),{"cR:5c":"#"+gJ,3A:(dR?"5q(c6 "+w/ 2 + " " + h /2+") ":E)+"82("+w/ t + "," + h /t+")","1X-1r":(1/ ((w /t+h/ t) /2)).4q(4)});dk.3G(gI);p.d3.3G(dk);bq[gE]=1}1i{bq[gE]++;gI=dk.ch("gI")[0]}$(gI,1k);K pP=dx*(1w!="qi"&&1w!="qe");if(dR){2s=o.1U.4A.DQ*1X||0;to=R.bu(2b.1G)-pP*1X}1i{2s=pP*1X;to=R.bu(2b.1G)-(o.1U.4A.DU*1X||0)}1k={};1k["dk-"+se]="5e(#"+gE+")";if(to||2s){1k.d=R.nF(2b.1G,2s,to)}$(1s,1k);o.1U.4A[se+"l4"]=gJ;o.1U.4A[se+"DW"]=gE;o.1U.4A[se+"dx"]=pP;o.1U.4A[se+"4B"]=1w;o.1U.4A[se+"5l"]=1m}1i{if(dR){2s=o.1U.4A.DQ*1X||0;to=R.bu(2b.1G)-2s}1i{2s=0;to=R.bu(2b.1G)-(o.1U.4A.DU*1X||0)}o.1U.4A[se+"l4"]&&$(1s,{d:R.nF(2b.1G,2s,to)});42 o.1U.4A[se+"l4"];42 o.1U.4A[se+"DW"];42 o.1U.4A[se+"dx"];42 o.1U.4A[se+"4B"];42 o.1U.4A[se+"5l"]}1o(1k in bq){if(bq[3o](1k)&&!bq[1k]){K 1g=R.7x.2Y.eg(1k);1g&&1g.3n.7o(1g)}}}},98={"":[0],"3p":[0],"-":[3,1],".":[1,1],"-.":[3,1,1,1],"-..":[3,1,1,1,1,1],". ":[1,3],"- ":[4,3],"--":[8,3],"- .":[4,3,1,3],"--.":[8,3,1,3],"--..":[8,3,1,3,1,3]},yR=1a(o,1m,1v){1m=98[3Y(1m).3N()];if(1m){K 1r=o.2b["1X-1r"]||"1",iq={4G:1r,uo:1r,iq:0}[o.2b["1X-cA"]||1v["1X-cA"]]||0,yL=[],i=1m.1e;45(i--){yL[i]=1m[i]*1r+(i%2?1:-1)*iq}$(o.1s,{"1X-98":yL.4H(",")})}},dG=1a(o,1v){K 1s=o.1s,2b=o.2b,Do=1s.3b.gq;1s.3b.gq="7d";1o(K 6C in 1v){if(1v[3o](6C)){if(!R.jY[3o](6C)){ah}K 1m=1v[6C];2b[6C]=1m;3r(6C){1l"4O":o.4O(1m);1p;1l"61":K 61=1s.ch("61");if(61.1e&&(61=61[0])){61.7E.DJ=1m}1i{61=$("61");K 2g=R.7x.2Y.zq(1m);61.3G(2g);1s.3G(61)}1p;1l"5c":;1l"3k":K pn=1s.3n;if(pn.6c.3N()!="a"){K hl=$("a");pn.6Y(hl,1s);hl.3G(1s);pn=hl}if(6C=="3k"){pn.nv(cR,"59",1m=="yH"?"1S":1m)}1i{pn.nv(cR,6C,1m)}1p;1l"iN":1s.3b.iN=1m;1p;1l"3A":o.3A(1m);1p;1l"ag-2I":bE(o,1m);1p;1l"ag-4z":bE(o,1m,1);1p;1l"6h-4k":K 4k=3Y(1m).3q(5n);if(4k.1e==4){o.6h&&o.6h.3n.3n.7o(o.6h.3n);K el=$("Z3"),rc=$("4k");el.id=R.nm();$(rc,{x:4k[0],y:4k[1],1r:4k[2],1y:4k[3]});el.3G(rc);o.2u.d3.3G(el);$(1s,{"6h-1G":"5e(#"+el.id+")"});o.6h=rc}if(!1m){K 1G=1s.yN("6h-1G");if(1G){K 6h=R.7x.2Y.eg(1G.3g(/(^5e\\(#|\\)$)/g,E));6h&&6h.3n.7o(6h);$(1s,{"6h-1G":E});42 o.6h}}1p;1l"1G":if(o.1w=="1G"){$(1s,{d:1m?2b.1G=R.mQ(1m):"M0,0"});o.1U.7J=1;if(o.1U.4A){"jm"in o.1U.4A&&bE(o,o.1U.4A.jm);"kd"in o.1U.4A&&bE(o,o.1U.4A.kd,1)}}1p;1l"1r":1s.b1(6C,1m);o.1U.7J=1;if(2b.fx){6C="x";1m=2b.x}1i{1p};1l"x":if(2b.fx){1m=-2b.x-(2b.1r||0)};1l"rx":if(6C=="rx"&&o.1w=="4k"){1p};1l"cx":1s.b1(6C,1m);o.bW&&np(o);o.1U.7J=1;1p;1l"1y":1s.b1(6C,1m);o.1U.7J=1;if(2b.fy){6C="y";1m=2b.y}1i{1p};1l"y":if(2b.fy){1m=-2b.y-(2b.1y||0)};1l"ry":if(6C=="ry"&&o.1w=="4k"){1p};1l"cy":1s.b1(6C,1m);o.bW&&np(o);o.1U.7J=1;1p;1l"r":if(o.1w=="4k"){$(1s,{rx:1m,ry:1m})}1i{1s.b1(6C,1m)}o.1U.7J=1;1p;1l"4b":if(o.1w=="8O"){1s.nv(cR,"5c",1m)}1p;1l"1X-1r":if(o.1U.sx!=1||o.1U.sy!=1){1m/=4Q(4a(o.1U.sx),4a(o.1U.sy))||1}if(o.2u.mX){1m*=o.2u.mX}1s.b1(6C,1m);if(2b["1X-98"]){yR(o,2b["1X-98"],1v)}if(o.1U.4A){"jm"in o.1U.4A&&bE(o,o.1U.4A.jm);"kd"in o.1U.4A&&bE(o,o.1U.4A.kd,1)}1p;1l"1X-98":yR(o,1m,1v);1p;1l"28":K f4=3Y(1m).3e(R.us);if(f4){el=$("bW");K ig=$("8O");el.id=R.nm();$(el,{x:0,y:0,YZ:"YY",1y:1,1r:1});$(ig,{x:0,y:0,"cR:5c":f4[1]});el.3G(ig);(1a(el){R.ut(f4[1],1a(){K w=J.f6,h=J.ba;$(el,{1r:w,1y:h});$(ig,{1r:w,1y:h});o.2u.ka()})})(el);o.2u.d3.3G(el);$(1s,{28:"5e(#"+el.id+")"});o.bW=el;o.bW&&np(o);1p}K 3v=R.bM(1m);if(!3v.96){42 1v.3O;42 2b.3O;!R.is(2b.2G,"2O")&&(R.is(1v.2G,"2O")&&$(1s,{2G:2b.2G}));!R.is(2b["28-2G"],"2O")&&(R.is(1v["28-2G"],"2O")&&$(1s,{"28-2G":2b["28-2G"]}))}1i{if((o.1w=="9m"||(o.1w=="aM"||3Y(1m).bs()!="r"))&&mG(o,1m)){if("2G"in 2b||"28-2G"in 2b){K 3O=R.7x.2Y.eg(1s.yN("28").3g(/^5e\\(#|\\)$/g,E));if(3O){K ke=3O.ch("5B");$(ke[ke.1e-1],{"5B-2G":("2G"in 2b?2b.2G:1)*("28-2G"in 2b?2b["28-2G"]:1)})}}2b.3O=1m;2b.28="3p";1p}}3v[3o]("2G")&&$(1s,{"28-2G":3v.2G>1?3v.2G/100:3v.2G});1l"1X":3v=R.bM(1m);1s.b1(6C,3v.67);6C=="1X"&&(3v[3o]("2G")&&$(1s,{"1X-2G":3v.2G>1?3v.2G/100:3v.2G}));if(6C=="1X"&&o.1U.4A){"jm"in o.1U.4A&&bE(o,o.1U.4A.jm);"kd"in o.1U.4A&&bE(o,o.1U.4A.kd,1)}1p;1l"3O":(o.1w=="9m"||(o.1w=="aM"||3Y(1m).bs()!="r"))&&mG(o,1m);1p;1l"2G":if(2b.3O&&!2b[3o]("1X-2G")){$(1s,{"1X-2G":1m>1?1m/100:1m})};1l"28-2G":if(2b.3O){3O=R.7x.2Y.eg(1s.yN("28").3g(/^5e\\(#|\\)$/g,E));if(3O){ke=3O.ch("5B");$(ke[ke.1e-1],{"5B-2G":1m})}1p};5o:6C=="2M-56"&&(1m=9z(1m,10)+"px");K Ds=6C.3g(/(\\-.)/g,1a(w){1b w.fY(1).8w()});1s.3b[Ds]=1m;o.1U.7J=1;1s.b1(6C,1m);1p}}}Dl(o,1v);1s.3b.gq=Do},zn=1.2,Dl=1a(el,1v){if(el.1w!="1Y"||!(1v[3o]("1Y")||(1v[3o]("2M")||(1v[3o]("2M-56")||(1v[3o]("x")||1v[3o]("y")))))){1b}K a=el.2b,1s=el.1s,dI=1s.7E?9z(R.7x.2Y.iH.qL(1s.7E,E).DB("2M-56"),10):10;if(1v[3o]("1Y")){a.1Y=1v.1Y;45(1s.7E){1s.7o(1s.7E)}K zm=3Y(1v.1Y).3q("\\n"),gc=[],fz;1o(K i=0,ii=zm.1e;i<ii;i++){fz=$("fz");i&&$(fz,{dy:dI*zn,x:a.x});fz.3G(R.7x.2Y.zq(zm[i]));1s.3G(fz);gc[i]=fz}}1i{gc=1s.ch("fz");1o(i=0,ii=gc.1e;i<ii;i++){if(i){$(gc[i],{dy:dI*zn,x:a.x})}1i{$(gc[0],{dy:0})}}}$(1s,{x:a.x,y:a.y});el.1U.7J=1;K bb=el.nT(),oA=a.y-(bb.y+bb.1y/2);oA&&(R.is(oA,"nM")&&$(gc[0],{dy:oA}))},9J=1a(1s,41){K X=0,Y=0;J[0]=J.1s=1s;1s.46=1n;J.id=R.vk++;1s.vp=J.id;J.4v=R.4v();J.fF=1c;J.2u=41;J.2b=J.2b||{};J.1U={3A:[],sx:1,sy:1,4j:0,dx:0,dy:0,7J:1};!41.4I&&(41.4I=J);J.3P=41.1O;41.1O&&(41.1O.3m=J);41.1O=J;J.3m=1c},3d=R.el;9J.2T=3d;3d.4U=9J;R.4C.1G=1a(8l,c5){K el=$("1G");c5.1V&&c5.1V.3G(el);K p=1S 9J(el,c5);p.1w="1G";dG(p,{28:"3p",1X:"#cm",1G:8l});1b p};3d.5q=1a(4j,cx,cy){if(J.5d){1b J}4j=3Y(4j).3q(5n);if(4j.1e-1){cx=3z(4j[1]);cy=3z(4j[2])}4j=3z(4j[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2X=J.6F(1);cx=2X.x+2X.1r/2;cy=2X.y+2X.1y/2}J.3A(J.1U.3A.3x([["r",4j,cx,cy]]));1b J};3d.82=1a(sx,sy,cx,cy){if(J.5d){1b J}sx=3Y(sx).3q(5n);if(sx.1e-1){sy=3z(sx[1]);cx=3z(sx[2]);cy=3z(sx[3])}sx=3z(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2X=J.6F(1)}cx=cx==1c?2X.x+2X.1r/2:cx;cy=cy==1c?2X.y+2X.1y/2:cy;J.3A(J.1U.3A.3x([["s",sx,sy,cx,cy]]));1b J};3d.fc=1a(dx,dy){if(J.5d){1b J}dx=3Y(dx).3q(5n);if(dx.1e-1){dy=3z(dx[1])}dx=3z(dx[0])||0;dy=+dy||0;J.3A(J.1U.3A.3x([["t",dx,dy]]));1b J};3d.3A=1a(ab){K 1U=J.1U;if(ab==1c){1b 1U.3A}R.vd(J,ab);J.6h&&$(J.6h,{3A:J.4v.nq()});J.bW&&np(J);J.1s&&$(J.1s,{3A:J.4v});if(1U.sx!=1||1U.sy!=1){K sw=J.2b[3o]("1X-1r")?J.2b["1X-1r"]:1;J.1k({"1X-1r":sw})}1b J};3d.3L=1a(){!J.5d&&J.2u.ka(J.1s.3b.5p="3p");1b J};3d.59=1a(){!J.5d&&J.2u.ka(J.1s.3b.5p="");1b J};3d.3u=1a(){if(J.5d||!J.1s.3n){1b}K 2u=J.2u;2u.6W&&2u.6W.uK(J);2R.7Y("46.*.*."+J.id);if(J.3O){2u.d3.7o(J.3O)}R.uQ(J,2u);if(J.1s.3n.6c.3N()=="a"){J.1s.3n.3n.7o(J.1s.3n)}1i{J.1s.3n.7o(J.1s)}1o(K i in J){J[i]=2K J[i]=="1a"?R.kH(i):1c}J.5d=1n};3d.nT=1a(){if(J.1s.3b.5p=="3p"){J.59();K 3L=1n}K 2X={};7n{2X=J.1s.6F()}7p(e){}Z7{2X=2X||{}}3L&&J.3L();1b 2X};3d.1k=1a(1z,1m){if(J.5d){1b J}if(1z==1c){K 1A={};1o(K a in J.2b){if(J.2b[3o](a)){1A[a]=J.2b[a]}}1A.3O&&(1A.28=="3p"&&((1A.28=1A.3O)&&42 1A.3O));1A.3A=J.1U.3A;1b 1A}if(1m==1c&&R.is(1z,"4e")){if(1z=="28"&&(J.2b.28=="3p"&&J.2b.3O)){1b J.2b.3O}if(1z=="3A"){1b J.1U.3A}K 7h=1z.3q(5n),2k={};1o(K i=0,ii=7h.1e;i<ii;i++){1z=7h[i];if(1z in J.2b){2k[1z]=J.2b[1z]}1i{if(R.is(J.2u.8E[1z],"1a")){2k[1z]=J.2u.8E[1z].NJ}1i{2k[1z]=R.jY[1z]}}}1b ii-1?2k:2k[7h[0]]}if(1m==1c&&R.is(1z,"3I")){2k={};1o(i=0,ii=1z.1e;i<ii;i++){2k[1z[i]]=J.1k(1z[i])}1b 2k}if(1m!=1c){K 1v={};1v[1z]=1m}1i{if(1z!=1c&&R.is(1z,"1D")){1v=1z}}1o(K 1q in 1v){2R("46.1k."+1q+"."+J.id,J,1v[1q])}1o(1q in J.2u.8E){if(J.2u.8E[3o](1q)&&(1v[3o](1q)&&R.is(J.2u.8E[1q],"1a"))){K 8H=J.2u.8E[1q].3c(J,[].3x(1v[1q]));J.2b[1q]=1v[1q];1o(K bG in 8H){if(8H[3o](bG)){1v[bG]=8H[bG]}}}}dG(J,1v);1b J};3d.MT=1a(){if(J.5d){1b J}if(J.1s.3n.6c.3N()=="a"){J.1s.3n.3n.3G(J.1s.3n)}1i{J.1s.3n.3G(J.1s)}K 41=J.2u;41.1O!=J&&R.wq(J,41);1b J};3d.MY=1a(){if(J.5d){1b J}K 1L=J.1s.3n;if(1L.6c.3N()=="a"){1L.3n.6Y(J.1s.3n,J.1s.3n.3n.7E)}1i{if(1L.7E!=J.1s){1L.6Y(J.1s,J.1s.3n.7E)}}R.wo(J,J.2u);K 41=J.2u;1b J};3d.e7=1a(1f){if(J.5d){1b J}K 1s=1f.1s||1f[1f.1e-1].1s;if(1s.iI){1s.3n.6Y(J.1s,1s.iI)}1i{1s.3n.3G(J.1s)}R.wn(J,1f,J.2u);1b J};3d.6Y=1a(1f){if(J.5d){1b J}K 1s=1f.1s||1f[0].1s;1s.3n.6Y(J.1s,1s);R.wt(J,1f,J.2u);1b J};3d.4O=1a(56){K t=J;if(+56!==0){K jZ=$("4p"),4O=$("Z6");t.2b.4O=56;jZ.id=R.nm();$(4O,{Wr:+56||1.5});jZ.3G(4O);t.2u.d3.3G(jZ);t.nB=jZ;$(t.1s,{4p:"5e(#"+jZ.id+")"})}1i{if(t.nB){t.nB.3n.7o(t.nB);42 t.nB;42 t.2b.4O}t.1s.Tu("4p")}1b t};R.4C.9m=1a(41,x,y,r){K el=$("9m");41.1V&&41.1V.3G(el);K 1A=1S 9J(el,41);1A.2b={cx:x,cy:y,r:r,28:"3p",1X:"#cm"};1A.1w="9m";$(el,1A.2b);1b 1A};R.4C.4k=1a(41,x,y,w,h,r){K el=$("4k");41.1V&&41.1V.3G(el);K 1A=1S 9J(el,41);1A.2b={x:x,y:y,1r:w,1y:h,r:r||0,rx:r||0,ry:r||0,28:"3p",1X:"#cm"};1A.1w="4k";$(el,1A.2b);1b 1A};R.4C.aM=1a(41,x,y,rx,ry){K el=$("aM");41.1V&&41.1V.3G(el);K 1A=1S 9J(el,41);1A.2b={cx:x,cy:y,rx:rx,ry:ry,28:"3p",1X:"#cm"};1A.1w="aM";$(el,1A.2b);1b 1A};R.4C.8O=1a(41,4b,x,y,w,h){K el=$("8O");$(el,{x:x,y:y,1r:w,1y:h,CP:"3p"});el.nv(cR,"5c",4b);41.1V&&41.1V.3G(el);K 1A=1S 9J(el,41);1A.2b={x:x,y:y,1r:w,1y:h,4b:4b};1A.1w="8O";1b 1A};R.4C.1Y=1a(41,x,y,1Y){K el=$("1Y");41.1V&&41.1V.3G(el);K 1A=1S 9J(el,41);1A.2b={x:x,y:y,"1Y-v4":"zs",1Y:1Y,2M:R.jY.2M,1X:"3p",28:"#cm"};1A.1w="1Y";dG(1A,1A.2b);1b 1A};R.4C.km=1a(1r,1y){J.1r=1r||J.1r;J.1y=1y||J.1y;J.1V.b1("1r",J.1r);J.1V.b1("1y",J.1y);if(J.eX){J.fP.3c(J,J.eX)}1b J};R.4C.7U=1a(){K aX=R.wP.3c(0,2q),49=aX&&aX.49,x=aX.x,y=aX.y,1r=aX.1r,1y=aX.1y;if(!49){9w 1S 9n("c5 49 5X 8y.")}K aU=$("41"),31="ga:7d;",zp;x=x||0;y=y||0;1r=1r||J0;1y=1y||IV;$(aU,{1y:1y,5M:1.1,1r:1r,Na:"6H://nz.w3.r5/Cp/41"});if(49==1){aU.3b.fk=31+"2J:8t;2a:"+x+"px;1O:"+y+"px";R.7x.2Y.3U.3G(aU);zp=1}1i{aU.3b.fk=31+"2J:mM";if(49.7E){49.6Y(aU,49.7E)}1i{49.3G(aU)}}49=1S R.wN;49.1r=1r;49.1y=1y;49.1V=aU;49.a0();49.qS=49.qQ=0;zp&&(49.pG=1a(){});49.pG();1b 49};R.4C.fP=1a(x,y,w,h,9W){2R("46.fP",J,J.eX,[x,y,w,h,9W]);K 56=4Q(w/ J.1r, h /J.1y),1O=J.1O,CO=9W?"Tw":"Tv",vb,sw;if(x==1c){if(J.mX){56=1}42 J.mX;vb="0 0 "+J.1r+S+J.1y}1i{J.mX=56;vb=x+S+y+S+w+S+h}$(J.1V,{Tq:vb,CP:CO});45(56&&1O){sw="1X-1r"in 1O.2b?1O.2b["1X-1r"]:1;1O.1k({"1X-1r":sw});1O.1U.7J=1;1O.1U.f9=1;1O=1O.3P}J.eX=[x,y,w,h,!!9W];1b J};R.2T.pG=1a(){K aU=J.1V,s=aU.3b,3V;7n{3V=aU.Ts()||aU.CN()}7p(e){3V=aU.CN()}K 2a=-3V.e%1,1O=-3V.f%1;if(2a||1O){if(2a){J.qS=(J.qS+2a)%1;s.2a=J.qS+"px"}if(1O){J.qQ=(J.qQ+1O)%1;s.1O=J.qQ+"px"}}};R.2T.a0=1a(){R.2R("46.a0",J);K c=J.1V;45(c.7E){c.7o(c.7E)}J.4I=J.1O=1c;(J.zr=$("zr")).3G(R.7x.2Y.zq("TB fX gk\\gd "+R.5M));c.3G(J.zr);c.3G(J.d3=$("d3"))};R.2T.3u=1a(){2R("46.3u",J);J.1V.3n&&J.1V.3n.7o(J.1V);1o(K i in J){J[i]=2K J[i]=="1a"?R.kH(i):1c}};K 6L=R.st;1o(K 44 in 3d){if(3d[3o](44)&&!6L[3o](44)){6L[44]=1a(eC){1b 1a(){K 4i=2q;1b J.8F(1a(el){el[eC].3c(el,4i)})}}(44)}}})();(1a(){if(!R.5H){1b}K 3o="7P",3Y=5l,3z=d5,3w=3D,4G=3w.4G,4Q=3w.4y,5W=3w.5Q,4a=3w.4a,gG="28",5n=/[, ]+/,2R=R.2R,ms=" za:CZ.z9",S=" ",E="",eQ={M:"m",L:"l",C:"c",Z:"x",m:"t",l:"r",c:"v",z:"x"},Mc=/([z6]),?([^z6]*)/gi,MG=/ za:\\S+MC\\([^\\)]+\\)/g,2g=/-?[^,\\s-]+/g,wi="2J:8t;2a:0;1O:0;1r:k3;1y:k3",6I=Ty,My={1G:1,4k:1,8O:1},Mq={9m:1,aM:1},Mh=1a(1G){K rB=/[Tx]/ig,83=R.mQ;3Y(1G).3e(rB)&&(83=R.rA);rB=/[z6]/g;if(83==R.mQ&&!3Y(1G).3e(rB)){K 1A=3Y(1G).3g(Mc,1a(6o,83,2e){K i6=[],Md=83.3N()=="m",1A=eQ[83];2e.3g(2g,1a(1m){if(Md&&i6.1e==2){1A+=i6+eQ[83=="m"?"l":"L"];i6=[]}i6.1C(4G(1m*6I))});1b 1A+i6});1b 1A}K pa=83(1G),p,r;1A=[];1o(K i=0,ii=pa.1e;i<ii;i++){p=pa[i];r=pa[i][0].3N();r=="z"&&(r="x");1o(K j=1,jj=p.1e;j<jj;j++){r+=4G(p[j]*6I)+(j!=jj-1?",":E)}1A.1C(r)}1b 1A.4H(S)},zh=1a(4j,dx,dy){K m=R.4v();m.5q(-4j,0.5,0.5);1b{dx:m.x(dx,dy),dy:m.y(dx,dy)}},nS=1a(p,sx,sy,dx,dy,4j){K 1U=p.1U,m=p.4v,cd=1U.cd,o=p.1s,s=o.3b,y=1,hP="",Te,kx=6I/ sx, ky = 6I /sy;s.gq="7d";if(!sx||!sy){1b}o.pz=4a(kx)+S+4a(ky);s.T9=4j*(sx*sy<0?-1:1);if(4j){K c=zh(4j,dx,dy);dx=c.dx;dy=c.dy}sx<0&&(hP+="x");sy<0&&((hP+=" y")&&(y=-1));s.hP=hP;o.jc=dx*-kx+S+dy*-ky;if(cd||1U.gg){K 28=o.ch(gG);28=28&&28[0];o.7o(28);if(cd){c=zh(4j,m.x(cd[0],cd[1]),m.y(cd[0],cd[1]));28.2J=c.dx*y+S+c.dy*y}if(1U.gg){28.56=1U.gg[0]*4a(sx)+S+1U.gg[1]*4a(sy)}o.3G(28)}s.gq="6K"};R.3s=1a(){1b"LN qK Ta\\Tl bV c5. Tm dE to gn.\\LV qg ze gk\\gd "+J.5M};K bE=1a(o,1m,dR){K 2H=3Y(1m).3N().3q("-"),se=dR?"4z":"2I",i=2H.1e,1w="mp",w="Mv",h="Mv";45(i--){3r(2H[i]){1l"7a":;1l"mp":;1l"qe":;1l"qi":;1l"6Q":;1l"3p":1w=2H[i];1p;1l"Ms":;1l"Mw":h=2H[i];1p;1l"MA":;1l"MB":w=2H[i];1p}}K 1X=o.1s.ch("1X")[0];1X[se+"ag"]=1w;1X[se+"U6"]=w;1X[se+"U5"]=h},dG=1a(o,1v){o.2b=o.2b||{};K 1s=o.1s,a=o.2b,s=1s.3b,xy,uI=My[o.1w]&&(1v.x!=a.x||(1v.y!=a.y||(1v.1r!=a.1r||(1v.1y!=a.1y||(1v.cx!=a.cx||(1v.cy!=a.cy||(1v.rx!=a.rx||(1v.ry!=a.ry||1v.r!=a.r)))))))),Mg=Mq[o.1w]&&(a.cx!=1v.cx||(a.cy!=1v.cy||(a.r!=1v.r||(a.rx!=1v.rx||a.ry!=1v.ry)))),1A=o;1o(K 8H in 1v){if(1v[3o](8H)){a[8H]=1v[8H]}}if(uI){a.1G=R.uD[o.1w](o);o.1U.7J=1}1v.5c&&(1s.5c=1v.5c);1v.61&&(1s.61=1v.61);1v.3k&&(1s.3k=1v.3k);1v.iN&&(s.iN=1v.iN);"4O"in 1v&&o.4O(1v.4O);if(1v.1G&&o.1w=="1G"||uI){1s.1G=Mh(~3Y(a.1G).3N().4Y("r")?R.mQ(a.1G):a.1G);if(o.1w=="8O"){o.1U.cd=[a.x,a.y];o.1U.gg=[a.1r,a.1y];nS(o,1,1,0,0,0)}}"3A"in 1v&&o.3A(1v.3A);if(Mg){K cx=+a.cx,cy=+a.cy,rx=+a.rx||(+a.r||0),ry=+a.ry||(+a.r||0);1s.1G=R.6v("ar{0},{1},{2},{3},{4},{1},{4},{1}x",4G((cx-rx)*6I),4G((cy-ry)*6I),4G((cx+rx)*6I),4G((cy+ry)*6I),4G(cx*6I));o.1U.7J=1}if("6h-4k"in 1v){K 4k=3Y(1v["6h-4k"]).3q(5n);if(4k.1e==4){4k[2]=+4k[2]+ +4k[0];4k[3]=+4k[3]+ +4k[1];K 2E=1s.mR||R.7x.2Y.c8("2E"),gH=2E.3b;gH.6h=R.6v("4k({1}px {2}px {3}px {0}px)",4k);if(!1s.mR){gH.2J="8t";gH.1O=0;gH.2a=0;gH.1r=o.2u.1r+"px";gH.1y=o.2u.1y+"px";1s.3n.6Y(2E,1s);2E.3G(1s);1s.mR=2E}}if(!1v["6h-4k"]){1s.mR&&(1s.mR.3b.6h="6l")}}if(o.cw){K j7=o.cw.3b;1v.2M&&(j7.2M=1v.2M);1v["2M-84"]&&(j7.Lb=\'"\'+1v["2M-84"].3q(",")[0].3g(/^[\'"]+|[\'"]+$/g,E)+\'"\');1v["2M-56"]&&(j7.dI=1v["2M-56"]);1v["2M-9K"]&&(j7.L9=1v["2M-9K"]);1v["2M-3b"]&&(j7.L7=1v["2M-3b"])}if("ag-2I"in 1v){bE(1A,1v["ag-2I"])}if("ag-4z"in 1v){bE(1A,1v["ag-4z"],1)}if(1v.2G!=1c||(1v["1X-1r"]!=1c||(1v.28!=1c||(1v.4b!=1c||(1v.1X!=1c||(1v["1X-1r"]!=1c||(1v["1X-2G"]!=1c||(1v["28-2G"]!=1c||(1v["1X-98"]!=1c||(1v["1X-mV"]!=1c||(1v["1X-g3"]!=1c||1v["1X-cA"]!=1c))))))))))){K 28=1s.ch(gG),Mn=1j;28=28&&28[0];!28&&(Mn=28=cq(gG));if(o.1w=="8O"&&1v.4b){28.4b=1v.4b}1v.28&&(28.on=1n);if(28.on==1c||(1v.28=="3p"||1v.28===1c)){28.on=1j}if(28.on&&1v.28){K f4=3Y(1v.28).3e(R.us);if(f4){28.3n==1s&&1s.7o(28);28.5q=1n;28.4b=f4[1];28.1w="MI";K 2X=o.6F(1);28.2J=2X.x+S+2X.y;o.1U.cd=[2X.x,2X.y];R.ut(f4[1],1a(){o.1U.gg=[J.f6,J.ba]})}1i{28.3t=R.bM(1v.28).67;28.4b=E;28.1w="mN";if(R.bM(1v.28).96&&((1A.1w in{9m:1,aM:1}||3Y(1v.28).bs()!="r")&&mG(1A,1v.28,28))){a.28="3p";a.3O=1v.28;28.5q=1j}}}if("28-2G"in 1v||"2G"in 1v){K 2G=((+a["28-2G"]+1||2)-1)*((+a.2G+1||2)-1)*((+R.bM(1v.28).o+1||2)-1);2G=5W(4Q(2G,0),1);28.2G=2G;if(28.4b){28.3t="3p"}}1s.3G(28);K 1X=1s.ch("1X")&&1s.ch("1X")[0],v5=1j;!1X&&(v5=1X=cq("1X"));if(1v.1X&&1v.1X!="3p"||(1v["1X-1r"]||(1v["1X-2G"]!=1c||(1v["1X-98"]||(1v["1X-mV"]||(1v["1X-g3"]||1v["1X-cA"])))))){1X.on=1n}(1v.1X=="3p"||(1v.1X===1c||(1X.on==1c||(1v.1X==0||1v["1X-1r"]==0))))&&(1X.on=1j);K uw=R.bM(1v.1X);1X.on&&(1v.1X&&(1X.3t=uw.67));2G=((+a["1X-2G"]+1||2)-1)*((+a.2G+1||2)-1)*((+uw.o+1||2)-1);K 1r=(3z(1v["1X-1r"])||1)*0.75;2G=5W(4Q(2G,0),1);1v["1X-1r"]==1c&&(1r=a["1X-1r"]);1v["1X-1r"]&&(1X.9K=1r);1r&&(1r<1&&((2G*=1r)&&(1X.9K=1)));1X.2G=2G;1v["1X-g3"]&&(1X.U7=1v["1X-g3"]||"Ua");1X.mV=1v["1X-mV"]||8;1v["1X-cA"]&&(1X.U9=1v["1X-cA"]=="iq"?"TM":1v["1X-cA"]=="uo"?"uo":"4G");if("1X-98"in 1v){K 98={"-":"TL",".":"TO","-.":"TN","-..":"TI",". ":"6M","- ":"TH","--":"TK","- .":"TJ","--.":"TV","--..":"TU"};1X.TX=98[3o](1v["1X-98"])?98[1v["1X-98"]]:E}v5&&1s.3G(1X)}if(1A.1w=="1Y"){1A.2u.1V.3b.5p=E;K 2F=1A.2u.2F,m=100,dI=a.2M&&a.2M.3e(/\\d+(?:\\.\\d*)?(?=px)/);s=2F.3b;a.2M&&(s.2M=a.2M);a["2M-84"]&&(s.Lb=a["2M-84"]);a["2M-9K"]&&(s.L9=a["2M-9K"]);a["2M-3b"]&&(s.L7=a["2M-3b"]);dI=3z(a["2M-56"]||dI&&dI[0])||10;s.dI=dI*m+"px";1A.cw.4e&&(2F.nC=3Y(1A.cw.4e).3g(/</g,"&#60;").3g(/&/g,"&#38;").3g(/\\n/g,"<br>"));K mS=2F.vz();1A.W=a.w=(mS.7M-mS.2a)/m;1A.H=a.h=(mS.4I-mS.1O)/m;1A.X=a.x;1A.Y=a.y+1A.H/2;("x"in 1v||"y"in 1v)&&(1A.1G.v=R.6v("m{0},{1}l{2},{1}",4G(a.x*6I),4G(a.y*6I),4G(a.x*6I)+1));K v3=["x","y","1Y","2M","2M-84","2M-9K","2M-3b","2M-56"];1o(K d=0,dd=v3.1e;d<dd;d++){if(v3[d]in 1v){1A.1U.7J=1;1p}}3r(a["1Y-v4"]){1l"2I":1A.cw.3b["v-1Y-v1"]="2a";1A.rq=1A.W/2;1p;1l"4z":1A.cw.3b["v-1Y-v1"]="7M";1A.rq=-1A.W/2;1p;5o:1A.cw.3b["v-1Y-v1"]="v2";1A.rq=0;1p}1A.cw.3b["v-1Y-So"]=1n}},mG=1a(o,3O,28){o.2b=o.2b||{};K 2b=o.2b,5L=3D.5L,2G,Sq,1w="mD",vl=".5 .5";o.2b.3O=3O;3O=3Y(3O).3g(R.v6,1a(6o,fx,fy){1w="qA";if(fx&&fy){fx=3z(fx);fy=3z(fy);5L(fx-0.5,2)+5L(fy-0.5,2)>0.25&&(fy=3w.9M(0.25-5L(fx-0.5,2))*((fy>0.5)*2-1)+0.5);vl=fx+S+fy}1b E});3O=3O.3q(/\\s*\\-\\s*/);if(1w=="mD"){K 7l=3O.bf();7l=-3z(7l);if(aa(7l)){1b 1c}}K 57=R.uZ(3O);if(!57){1b 1c}o=o.cz||o.1s;if(57.1e){o.7o(28);28.on=1n;28.44="3p";28.3t=57[0].3t;28.Sm=57[57.1e-1].3t;K qq=[];1o(K i=0,ii=57.1e;i<ii;i++){57[i].2y&&qq.1C(57[i].2y+S+57[i].3t)}28.Sl=qq.1e?qq.4H():"0% "+28.3t;if(1w=="qA"){28.1w="Sy";28.2S="100%";28.Sx="0 0";28.Ss=vl;28.7l=0}1i{28.1w="3O";28.7l=(Sr-7l)%8r}o.3G(28)}1b 1},9J=1a(1s,5H){J[0]=J.1s=1s;1s.46=1n;J.id=R.vk++;1s.vp=J.id;J.X=0;J.Y=0;J.2b={};J.2u=5H;J.4v=R.4v();J.1U={3A:[],sx:1,sy:1,dx:0,dy:0,4j:0,7J:1,f9:1};!5H.4I&&(5H.4I=J);J.3P=5H.1O;5H.1O&&(5H.1O.3m=J);5H.1O=J;J.3m=1c};K 3d=R.el;9J.2T=3d;3d.4U=9J;3d.3A=1a(ab){if(ab==1c){1b J.1U.3A}K g7=J.2u.N3,Ny=g7?"s"+[g7.82,g7.82]+"-1-1t"+[g7.dx,g7.dy]:E,q6;if(g7){q6=ab=3Y(ab).3g(/\\.{3}|\\vc/g,J.1U.3A||E)}R.vd(J,Ny+ab);K 4v=J.4v.5R(),8f=J.8f,o=J.1s,3q,v9=~3Y(J.2b.28).4Y("-"),NC=!3Y(J.2b.28).4Y("5e(");4v.fc(1,1);if(NC||(v9||J.1w=="8O")){8f.4v="1 0 0 1";8f.2y="0 0";3q=4v.3q();if(v9&&3q.NG||!3q.va){o.3b.4p=4v.Nx();K bb=J.6F(),vh=J.6F(1),dx=bb.x-vh.x,dy=bb.y-vh.y;o.jc=dx*-6I+S+dy*-6I;nS(J,1,1,dx,dy,0)}1i{o.3b.4p=E;nS(J,3q.fU,3q.ep,3q.dx,3q.dy,3q.5q)}}1i{o.3b.4p=E;8f.4v=3Y(4v);8f.2y=4v.2y()}q6&&(J.1U.3A=q6);1b J};3d.5q=1a(4j,cx,cy){if(J.5d){1b J}if(4j==1c){1b}4j=3Y(4j).3q(5n);if(4j.1e-1){cx=3z(4j[1]);cy=3z(4j[2])}4j=3z(4j[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2X=J.6F(1);cx=2X.x+2X.1r/2;cy=2X.y+2X.1y/2}J.1U.f9=1;J.3A(J.1U.3A.3x([["r",4j,cx,cy]]));1b J};3d.fc=1a(dx,dy){if(J.5d){1b J}dx=3Y(dx).3q(5n);if(dx.1e-1){dy=3z(dx[1])}dx=3z(dx[0])||0;dy=+dy||0;if(J.1U.2X){J.1U.2X.x+=dx;J.1U.2X.y+=dy}J.3A(J.1U.3A.3x([["t",dx,dy]]));1b J};3d.82=1a(sx,sy,cx,cy){if(J.5d){1b J}sx=3Y(sx).3q(5n);if(sx.1e-1){sy=3z(sx[1]);cx=3z(sx[2]);cy=3z(sx[3]);aa(cx)&&(cx=1c);aa(cy)&&(cy=1c)}sx=3z(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2X=J.6F(1)}cx=cx==1c?2X.x+2X.1r/2:cx;cy=cy==1c?2X.y+2X.1y/2:cy;J.3A(J.1U.3A.3x([["s",sx,sy,cx,cy]]));J.1U.f9=1;1b J};3d.3L=1a(){!J.5d&&(J.1s.3b.5p="3p");1b J};3d.59=1a(){!J.5d&&(J.1s.3b.5p=E);1b J};3d.nT=1a(){if(J.5d){1b{}}1b{x:J.X+(J.rq||0)-J.W/2,y:J.Y-J.H,1r:J.W,1y:J.H}};3d.3u=1a(){if(J.5d||!J.1s.3n){1b}J.2u.6W&&J.2u.6W.uK(J);R.2R.7Y("46.*.*."+J.id);R.uQ(J,J.2u);J.1s.3n.7o(J.1s);J.cz&&J.cz.3n.7o(J.cz);1o(K i in J){J[i]=2K J[i]=="1a"?R.kH(i):1c}J.5d=1n};3d.1k=1a(1z,1m){if(J.5d){1b J}if(1z==1c){K 1A={};1o(K a in J.2b){if(J.2b[3o](a)){1A[a]=J.2b[a]}}1A.3O&&(1A.28=="3p"&&((1A.28=1A.3O)&&42 1A.3O));1A.3A=J.1U.3A;1b 1A}if(1m==1c&&R.is(1z,"4e")){if(1z==gG&&(J.2b.28=="3p"&&J.2b.3O)){1b J.2b.3O}K 7h=1z.3q(5n),2k={};1o(K i=0,ii=7h.1e;i<ii;i++){1z=7h[i];if(1z in J.2b){2k[1z]=J.2b[1z]}1i{if(R.is(J.2u.8E[1z],"1a")){2k[1z]=J.2u.8E[1z].NJ}1i{2k[1z]=R.jY[1z]}}}1b ii-1?2k:2k[7h[0]]}if(J.2b&&(1m==1c&&R.is(1z,"3I"))){2k={};1o(i=0,ii=1z.1e;i<ii;i++){2k[1z[i]]=J.1k(1z[i])}1b 2k}K 1v;if(1m!=1c){1v={};1v[1z]=1m}1m==1c&&(R.is(1z,"1D")&&(1v=1z));1o(K 1q in 1v){2R("46.1k."+1q+"."+J.id,J,1v[1q])}if(1v){1o(1q in J.2u.8E){if(J.2u.8E[3o](1q)&&(1v[3o](1q)&&R.is(J.2u.8E[1q],"1a"))){K 8H=J.2u.8E[1q].3c(J,[].3x(1v[1q]));J.2b[1q]=1v[1q];1o(K bG in 8H){if(8H[3o](bG)){1v[bG]=8H[bG]}}}}if(1v.1Y&&J.1w=="1Y"){J.cw.4e=1v.1Y}dG(J,1v)}1b J};3d.MT=1a(){!J.5d&&J.1s.3n.3G(J.1s);J.2u&&(J.2u.1O!=J&&R.wq(J,J.2u));1b J};3d.MY=1a(){if(J.5d){1b J}if(J.1s.3n.7E!=J.1s){J.1s.3n.6Y(J.1s,J.1s.3n.7E);R.wo(J,J.2u)}1b J};3d.e7=1a(1f){if(J.5d){1b J}if(1f.4U==R.st.4U){1f=1f[1f.1e-1]}if(1f.1s.iI){1f.1s.3n.6Y(J.1s,1f.1s.iI)}1i{1f.1s.3n.3G(J.1s)}R.wn(J,1f,J.2u);1b J};3d.6Y=1a(1f){if(J.5d){1b J}if(1f.4U==R.st.4U){1f=1f[0]}1f.1s.3n.6Y(J.1s,1f.1s);R.wt(J,1f,J.2u);1b J};3d.4O=1a(56){K s=J.1s.Sf,f=s.4p;f=f.3g(MG,E);if(+56!==0){J.2b.4O=56;s.4p=f+S+ms+".MC(Sh="+(+56||1.5)+")";s.jO=R.6v("-{0}px 0 0 -{0}px",4G(+56||1.5))}1i{s.4p=f;s.jO=0;42 J.2b.4O}1b J};R.4C.1G=1a(8l,5H){K el=cq("cz");el.3b.fk=wi;el.pz=6I+S+6I;el.jc=5H.jc;K p=1S 9J(el,5H),1k={28:"3p",1X:"#cm"};8l&&(1k.1G=8l);p.1w="1G";p.1G=[];p.l4=E;dG(p,1k);5H.1V.3G(el);K 8f=cq("8f");8f.on=1n;el.3G(8f);p.8f=8f;p.3A(E);1b p};R.4C.4k=1a(5H,x,y,w,h,r){K 1G=R.wf(x,y,w,h,r),1A=5H.1G(1G),a=1A.2b;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1r=w;1A.H=a.1y=h;a.r=r;a.1G=1G;1A.1w="4k";1b 1A};R.4C.aM=1a(5H,x,y,rx,ry){K 1A=5H.1G(),a=1A.2b;1A.X=x-rx;1A.Y=y-ry;1A.W=rx*2;1A.H=ry*2;1A.1w="aM";dG(1A,{cx:x,cy:y,rx:rx,ry:ry});1b 1A};R.4C.9m=1a(5H,x,y,r){K 1A=5H.1G(),a=1A.2b;1A.X=x-r;1A.Y=y-r;1A.W=1A.H=r*2;1A.1w="9m";dG(1A,{cx:x,cy:y,r:r});1b 1A};R.4C.8O=1a(5H,4b,x,y,w,h){K 1G=R.wf(x,y,w,h),1A=5H.1G(1G).1k({1X:"3p"}),a=1A.2b,1s=1A.1s,28=1s.ch(gG)[0];a.4b=4b;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1r=w;1A.H=a.1y=h;a.1G=1G;1A.1w="8O";28.3n==1s&&1s.7o(28);28.5q=1n;28.4b=4b;28.1w="MI";1A.1U.cd=[x,y];1A.1U.gg=[w,h];1s.3G(28);nS(1A,1,1,0,0,0);1b 1A};R.4C.1Y=1a(5H,x,y,1Y){K el=cq("cz"),1G=cq("1G"),o=cq("cw");x=x||0;y=y||0;1Y=1Y||"";1G.v=R.6v("m{0},{1}l{2},{1}",4G(x*6I),4G(y*6I),4G(x*6I)+1);1G.Sc=1n;o.4e=3Y(1Y);o.on=1n;el.3b.fk=wi;el.pz=6I+S+6I;el.jc="0 0";K p=1S 9J(el,5H),1k={28:"#cm",1X:"3p",2M:R.jY.2M,1Y:1Y};p.cz=el;p.1G=1G;p.cw=o;p.1w="1Y";p.2b.1Y=3Y(1Y);p.2b.x=x;p.2b.y=y;p.2b.w=1;p.2b.h=1;dG(p,1k);el.3G(o);el.3G(1G);5H.1V.3G(el);K 8f=cq("8f");8f.on=1n;el.3G(8f);p.8f=8f;p.3A(E);1b p};R.4C.km=1a(1r,1y){K cs=J.1V.3b;J.1r=1r;J.1y=1y;1r==+1r&&(1r+="px");1y==+1y&&(1y+="px");cs.1r=1r;cs.1y=1y;cs.6h="4k(0 "+1r+" "+1y+" 0)";if(J.eX){R.4C.fP.3c(J,J.eX)}1b J};R.4C.fP=1a(x,y,w,h,9W){R.2R("46.fP",J,J.eX,[x,y,w,h,9W]);K 1r=J.1r,1y=J.1y,56=1/ 4Q(w /1r,h/1y),H,W;if(9W){H=1y/h;W=1r/w;if(w*H<1r){x-=(1r-w*H)/ 2 /H}if(h*W<1y){y-=(1y-h*W)/ 2 /W}}J.eX=[x,y,w,h,!!9W];J.N3={dx:-x,dy:-y,82:56};J.8F(1a(el){el.3A("...")});1b J};K cq;R.4C.pe=1a(5j){K 2Y=5j.2N;2Y.SW().SV(".jt","N1:5e(#5o#gn)");7n{!2Y.9g.jt&&2Y.9g.54("jt","N8:N6-IS-wJ:5H");cq=1a(6c){1b 2Y.c8("<jt:"+6c+\' 2B="jt">\')}}7p(e){cq=1a(6c){1b 2Y.c8("<"+6c+\' Na="N8:N6-IS.wJ:5H" 2B="jt">\')}}};R.4C.pe(R.7x.5j);R.4C.7U=1a(){K aX=R.wP.3c(0,2q),49=aX.49,1y=aX.1y,s,1r=aX.1r,x=aX.x,y=aX.y;if(!49){9w 1S 9n("gn 49 5X 8y.")}K 1A=1S R.wN,c=1A.1V=R.7x.2Y.c8("2E"),cs=c.3b;x=x||0;y=y||0;1r=1r||J0;1y=1y||IV;1A.1r=1r;1A.1y=1y;1r==+1r&&(1r+="px");1y==+1y&&(1y+="px");1A.pz=6I*8W+S+6I*8W;1A.jc="0 0";1A.2F=R.7x.2Y.c8("2F");1A.2F.3b.fk="2J:8t;2a:-j9;1O:-j9;IN:0;jO:0;bj-1y:1;";c.3G(1A.2F);cs.fk=R.6v("1O:0;2a:0;1r:{0};1y:{1};5p:IO-7a;2J:mM;6h:4k(0 {0} {1} 0);ga:7d",1r,1y);if(49==1){R.7x.2Y.3U.3G(c);cs.2a=x+"px";cs.1O=y+"px";cs.2J="8t"}1i{if(49.7E){49.6Y(c,49.7E)}1i{49.3G(c)}}1A.pG=1a(){};1b 1A};R.2T.a0=1a(){R.2R("46.a0",J);J.1V.nC=E;J.2F=R.7x.2Y.c8("2F");J.2F.3b.fk="2J:8t;2a:-j9;1O:-j9;IN:0;jO:0;bj-1y:1;5p:IO;";J.1V.3G(J.2F);J.4I=J.1O=1c};R.2T.3u=1a(){R.2R("46.3u",J);J.1V.3n.7o(J.1V);1o(K i in J){J[i]=2K J[i]=="1a"?R.kH(i):1c}1b 1n};K 6L=R.st;1o(K 44 in 3d){if(3d[3o](44)&&!6L[3o](44)){6L[44]=1a(eC){1b 1a(){K 4i=2q;1b J.8F(1a(el){el[eC].3c(el,4i)})}}(44)}}})();oN.vF?g.5j.bk=R:bk=R;1b R});K HU=1a(vD){J.3t=1c;J.w0=1c;J.bg=1c;J.bj=1c;J.w7=1c;J.2I=1c;J.w5=1c;J.4z=1c;J.1D=1c;J.6k=1c;J.vE=1a(vD){};J.vE(vD)};1a 6F(1u){K 51={x:0,y:0,1r:0,1y:0};if(!1u.1e){1b 51}K o=1u[0];1a oQ(1f,Jg){51={x:0,y:0,1r:1f.kP,1y:1f.oC};45(1f){if(1f.id==Jg){1p}51.x+=1f.8p-1f.4S+1f.hV;51.y+=1f.9h-1f.58+1f.hZ;1f=1f.dX}1b 51}if(o.6c=="TR"){51=oQ(o,"qb-ui-1V")}1i{if(o.6c=="HA"){51=oQ(o,"qb-ui-1V")}1i{if(o.6c=="T5"){51=oQ(o,"qb-ui-1V")}}}1b 51}1a eG(x){1b 3D.4G(x*8W)/8W}1a Ia(fw,fv){K J2=20;K p1=[{x:fw.x,y:fw.y+fw.1y/ 2}, {x:fw.x + fw.1r, y:fw.y + fw.1y /2}];K p2=[{x:fv.x,y:fv.y+fv.1y/ 2}, {x:fv.x + fv.1r, y:fv.y + fv.1y /2}];K d=[],ku=[];1o(K i1=0;i1<p1.1e;i1++){1o(K i2=0;i2<p2.1e;i2++){K dx=3D.4a(p1[i1].x-p2[i2].x);K dy=3D.4a(p1[i1].y-p2[i2].y);K 6b=dx*dx+dy*dy;ku.1C(6b);d.1C({i1:i1,i2:i2})}}K 1A={i1:0,i2:0};K r1=-1;K 5Q=-1;1o(K i=0;i<ku.1e;i++){if(5Q==-1||ku[i]<5Q){5Q=ku[i];r1=i}}if(r1>0){1A=d[r1]}K x1=p1[1A.i1].x,y1=p1[1A.i1].y,x4=p2[1A.i2].x,y4=p2[1A.i2].y,y2=y1,y3=y4;K dx=3D.4y(3D.4a(x1-x4)/2,J2);K x2=[x1-dx,x1+dx][1A.i1];K x3=[x4-dx,x4+dx][1A.i2];1b{x1:eG(x1),y1:eG(y1),x2:eG(x2),y2:eG(y2),x3:eG(x3),y3:eG(y3),x4:eG(x4),y4:eG(y4)}}1a SA(51,J9){K R=bk==1c?cO:bk;K 4x=51;if(R.is(51,"1a")){1b J9?4x():2R.on("46.iy",4x)}1i{if(R.is(4x,1n)){1b R.4C.7U[51](R,4x.5f(0,3+R.is(4x[0],1c))).54(4x)}1i{K 2e=43.2T.3H.2w(2q,0);if(R.is(2e[2e.1e-1],"1a")){K f=2e.cQ();1b 4x?f.2w(R.4C.7U[51](R,2e)):2R.on("46.iy",1a(){f.2w(R.4C.7U[51](R,2e))})}1i{1b R.4C.7U[51](R,2q)}}}}bk.fn.GJ=1a(1W){if(!1W.4W||!1W.4V){1b 1j}if(!1W.4W.2j||!1W.4V.2j){1b 1j}if(!1W.4W.2j.1f||!1W.4V.2j.1f){1b 1j}K 7z=1W.6k;K vw=8;K 3t=7z.3t;K HX=1W.4W.4B;K HP=1W.4V.4B;1a vy(1W){K d6=6F(1W.2j.1f);if(1W.1M){K eO=6F(1W.1M.1f);d6.x=eO.x-1;d6.1r=eO.1r+2;if(d6.y<eO.y){d6.y=eO.y}1i{if(d6.y>eO.y+eO.1y-d6.1y){d6.y=eO.y+eO.1y-d6.1y}}}1b d6}K Ib=vy(1W.4W);K I6=vy(1W.4V);K 7g=Ia(Ib,I6);K w2=7g.x1<7g.x2?1:-1;K vZ=7g.x4<7g.x3?1:-1;K 1G=["M",7g.x1,7g.y1,"L",7g.x1+vw*w2,7g.y1,"C",7g.x2,7g.y2,7g.x3,7g.y3,7g.x4+vw*vZ,7g.y4,"L",7g.x4,7g.y4].4H(",");7z.2I=ks(7z.2I,HP,3t,7g.x1,7g.y1,w2);7z.4z=ks(7z.4z,HX,3t,7g.x4,7g.y4,vZ);if(7z.1G=1G&&(7z.bj&&7z.bg)){7z.bg.1k({1G:1G});7z.bj.1k({1G:1G});$(7z.bg.1s).2t("1W-3l")}1b 1n};bk.fn.GG=1a(1u,1k){K 1W=1S HU;1W.3t=1k.3q("|")[0]||"#HV";1W.w0=1k.3q("|")[1]||3;1W.It=15;1W.bj=J.1G("M,0,0").1k({1X:1W.3t,28:"3p","1X-1r":1W.w0,"1X-cA":"4G","1X-g3":"4G"});1W.bg=J.1G("M,0,0").1k({1X:1W.3t,28:"3p","1X-1r":1W.It,"1X-2G":0.Iu});1W.w7=1u.4V.4B;1W.2I=ks(1c,1W.w7,1W.3t);1W.w5=1u.4W.4B;1W.4z=ks(1c,1W.w5,1W.3t);1W.1D=1u;1b 1W};1a ks(1u,1w,3t,x,y,d){if(!x){x=0}if(!y){y=0}if(!d){d=1}K q4=1j;if(1u!=1c&&1u.1s){3r(1w){1l 1R.7t.cM:q4=1u.1s.8S!="9m";1p;1l 1R.7t.dn:q4=1u.1s.8S!="1G";1p}}if(q4){if(1u&&1u.3u){1u.3u()}1u=1c}if(1u==1c){3r(1w){1l 1R.7t.cM:1u=QB.1d.2f.r.9m(0,0,5);1u.1k({28:3t,"1X-1r":0});1p;1l 1R.7t.dn:1u=QB.1d.2f.r.1G("M,0,0");1u.1k({28:3t,"1X-1r":0});1p}}3r(1w){1l 1R.7t.cM:1u.1k({cx:x,cy:y});1p;1l 1R.7t.dn:K dx=8;K dy=5;K 1G=["M",x,y,"L",x,y+1,x+dx*d,y+dy,x+dx*d,y-dy,x,y-1,"Z"].4H(",");1u.1k({1G:1G});1p}1b 1u};K IF=1n;1a VL(1D,1H,7A){if(2K 1D.bL!="2O"){1D.bL(1H,7A,1j)}1i{if(2K 1D.ge!="2O"){1D.ge("on"+1H,7A)}1i{9w"In qK"}}}1a VO(1D,1H,7A){if(2K 1D.lP!="2O"){1D.lP(1H,7A,1j)}1i{if(2K 1D.wr!="2O"){1D.wr("on"+1H,7A)}1i{9w"In qK"}}}1a Vs(fn){K 2p=3Q.bL||3Q.ge?3Q:2N.bL?2N:2N.1L||1c;if(2p){if(2p.bL){2p.bL("vW",fn,1j)}1i{if(2p.ge){2p.ge("gb",fn)}}}1i{if(2K 3Q.gb=="1a"){K 8s=3Q.gb;3Q.gb=1a(){8s();fn()}}1i{3Q.gb=fn}}}K qw=[];K w4=1j;1a Vm(fn){if(!w4){qw.1C(fn)}1i{fn()}}1a LQ(){w4=1n;1o(K i=0;i<qw.1e;i++){qw[i]()}};K Ku=0;if(!43.4Y){43.2T.4Y=1a(1u){1o(K i=0;i<J.1e;i++){if(J[i]==1u){1b i}}1b-1}}3M={tk:1a(){1b++Ku},3s:1a(1u){if(1u==2O||1u==1c){1b""}1b 1u.3s()}};3M.jk=1a(4b,9D){K p,v;1o(p in 4b){if(2K 4b[p]==="1a"){9D[p]=4b[p]}1i{v=4b[p];9D[p]=v}}1b 9D};3M.Fg=1a(4b,9D){K p,v;1o(p in 4b){if(9D[p]===2O){ah}if(2K 4b[p]==="1a"){9D[p]=4b[p]}1i{v=4b[p];9D[p]=v}}1b 9D};3M.vB=1a($1f,3y){if($1f.1e&&!1K(3y)){$1f.1k("5w-3y",3y.3g(/&2r;/g," ").3g(/&xv;/g,"&"))}};3M.Kz=1a(4b,9D){K p,v;1o(p in 4b){if(2K 4b[p]==="1a"){9D[p]=4b[p]}1i{if(4b.7P(p)){v=4b[p];if(v&&"1D"===2K v){9D[p]=3M.Kr(v)}1i{9D[p]=v}}}}1b 9D};3M.Kr=1a(o){if(!o||"1D"!==2K o){1b o}K c=o dY 43?[]:{};1b 3M.Kz(o,c)};3M.Vz=1a(el,1L){K 1J={2a:el.4S,1r:el.AV,1O:el.58,1y:el.sz};1J.7M=1J.1r-1J.2a;1J.4I=1J.1y-1J.1O;if(1L){1J=3M.vs(1J,1L)}1b 1J};3M.fm=1a(el,1L){K r=el.vz();K 1J={2a:r.2a,7M:r.7M,1O:r.1O,4I:r.4I};if(!r.1r){1J.1r=r.7M-r.2a}1i{1J.1r=r.1r}if(!r.1y){1J.1y=r.4I-r.1O}1i{1J.1y=r.1y}if(1L){1J=3M.vs(1J,1L)}1b 1J};3M.vs=1a(r,p){1b{2a:r.2a-p.2a,1O:r.1O-p.1O,7M:r.7M-p.2a,4I:r.4I-p.1O,1y:r.1y,1r:r.1r}};3M.VB=1a(3S){K 4y=0;$(3S).2h(1a(){4y=3D.4y(4y,$(J).1y())}).1y(4y)};3M.Vv=1a(3S){K 4y=0;$(3S).2h(1a(){4y=3D.4y(4y,$(J).1r())}).1r(4y)};3M.Vu=1a(1u){if(1u){if(2K 1u=="4e"){if(1u!=""){1b 1u}}}1b""};3M.9B=1a(lz,1u){if(1u){if(2K 1u=="4e"){if(1u!=""){lz.1C(1u)}}}};2v.fn.cK=1a(1m){K fs=J.1k("1w");fs=1K(fs)?"":fs.3N();if(1m===2O){if(fs=="7O"){1b J[0].3B}1i{if(fs=="8x"){if(J[0].3B){1b J.1k("1m")}1i{1b 1c}}}1b J.2g()}if(fs=="7O"){if(1m==1n&&!J.1k("3B")){J.1k("3B","3B")}if(1m!=1n&&J.1k("3B")){J.iu("3B")}if(1m==1n&&!J.6T("3B")){J.6T("3B",1n)}if(1m!=1n&&J.6T("3B")){J.6T("3B",1j)}1b}1i{if(fs=="8x"){K Ki=J.1k("1m");if(Ki==1m){J.1k("3B","1n");J[0].3B=1n}1i{J.iu("3B")}1b}1i{K 6c="";if(!1K(J[0])&&!1K(J[0].6c)){6c=J[0].6c}if(6c.3N()=="2o"){J.qr(1K(1m)?"0":1m.3s());1b}}}if(1m==1c){1m=""}J.2g(1m)};2v.fn.Wf=1a(lF){if(!J[0]){1b{1O:0,2a:0}}if(J[0]===J[0].vJ.3U){1b 2v.2y.Wi(J[0])}2v.2y.ly||2v.2y.bB();if(2K lF=="4e"){if(lF!=""){K 1L=J.cD(lF);if(1L.1e){42 1L}}}1i{K 1L=lF}K 6i=J[0],dX=6i.dX,KC=6i,2Y=6i.vJ,fQ,dP=2Y.9S,3U=2Y.3U,iH=2Y.iH,lC=iH.qL(6i,1c),1O=6i.9h,2a=6i.8p;45((6i=6i.3n)&&(6i!==3U&&6i!==dP)){fQ=iH.qL(6i,1c);1O-=6i.58,2a-=6i.4S;if(6i===dX){1O+=6i.9h,2a+=6i.8p;if(2v.2y.Wc&&!(2v.2y.Wb&&/^t(DP|d|h)$/i.9V(6i.6c))){1O+=6p(fQ.uV,10)||0,2a+=6p(fQ.uT,10)||0}KC=dX,dX=6i.dX}if(2v.2y.Wd&&fQ.ga!=="6K"){1O+=6p(fQ.uV,10)||0,2a+=6p(fQ.uT,10)||0}lC=fQ;if($.Wn(6i,1L)>=0){1p}}if(lC.2J==="mM"||lC.2J==="wx"){1O+=3U.9h,2a+=3U.8p}if(lC.2J==="wA"){1O+=3D.4y(dP.58,3U.58),2a+=3D.4y(dP.4S,3U.4S)}1b{1O:1O,2a:2a}};1a Wj(65,wK){if(2q.1e>2){K wI=[];1o(K n=2;n<2q.1e;++n){wI.1C(2q[n])}1b 1a(){1b wK.3c(65,wI)}}1i{1b 1a(){1b wK.2w(65)}}}K 1K=1a(1u){if(1u===2O){1b 1n}if(1u==1c){1b 1n}if(1u===""){1b 1n}1b 1j};K iv=1a(76){if(!1K(76)){1b 76.3N()}1b 76};K Wm=1a(76){if(!1K(76)){1b 76.8w()}1b 76};K 2r=1a(1u){if(1u===2O){1b""}if(1u==1c){1b""}if(1u==""){1b""}1b 1u.3g(/ /g,"&2r;")};1a KW(dQ,dN,dM){1b 1a(a,b){if(!1K(dQ)&&a[dQ]<b[dQ]){1b-1}if(!1K(dQ)&&a[dQ]>b[dQ]){1b 1}if(!1K(dN)&&a[dN]<b[dN]){1b-1}if(!1K(dN)&&a[dN]>b[dN]){1b 1}if(!1K(dM)&&a[dM]<b[dM]){1b-1}if(!1K(dM)&&a[dM]>b[dM]){1b 1}1b 0}}43.2T.rV=1a(dQ,dN,dM){1b J.eZ(KW(dQ,dN,dM))};K fW=1a(a,b){if(1K(a)&&1K(b)){1b 1n}if(1K(a)||1K(b)){1b 1j}1b a.3N()==b.3N()};3M.ti=1a(a,b){if(1K(a)&&1K(b)){1b 1n}1b a==b};1a 4l(m7,4m){K F=1a(){};F.2T=4m.2T;m7.2T=1S F;m7.2T.4U=m7;m7.VZ=4m.2T}1a VY(KE,a4){1o(K 44 in a4){KE.2T[44]=a4[44]}}5m.2T.6v=1a(6v){K ql="";K 3g=5m.iV;1o(K i=0;i<6v.1e;i++){K qj=6v.bs(i);if(3g[qj]){ql+=3g[qj].2w(J)}1i{ql+=qj}}1b ql};5m.iV={JU:["W0","VV","VU","VX","JJ","VW","W7","W6","W9","W8","W3","W2"],JS:["W5","W4","Vl","UB","JJ","UA","UD","UC","Uz","Uy","UJ","UI"],K1:["UK","UF","UG","Uv","Uj","Um","Ul"],K2:["Uf","Ui","Uh","Us","Ur","Uu","Ut"],d:1a(){1b(J.ed()<10?"0":"")+J.ed()},D:1a(){1b 5m.iV.K1[J.qm()]},j:1a(){1b J.ed()},l:1a(){1b 5m.iV.K2[J.qm()]},N:1a(){1b J.qm()+1},S:1a(){1b J.ed()%10==1&&J.ed()!=11?"st":J.ed()%10==2&&J.ed()!=12?"nd":J.ed()%10==3&&J.ed()!=13?"rd":"th"},w:1a(){1b J.qm()},z:1a(){1b"eT mf gK"},W:1a(){1b"eT mf gK"},F:1a(){1b 5m.iV.JS[J.hU()]},m:1a(){1b(J.hU()<9?"0":"")+(J.hU()+1)},M:1a(){1b 5m.iV.JU[J.hU()]},n:1a(){1b J.hU()+1},t:1a(){1b"eT mf gK"},L:1a(){1b J.md()%4==0&&J.md()%100!=0||J.md()%ol==0?"1":"0"},o:1a(){1b"eT gK"},Y:1a(){1b J.md()},y:1a(){1b(""+J.md()).71(2)},a:1a(){1b J.fO()<12?"am":"pm"},A:1a(){1b J.fO()<12?"AM":"PM"},B:1a(){1b"eT mf gK"},g:1a(){1b J.fO()%12||12},G:1a(){1b J.fO()},h:1a(){1b((J.fO()%12||12)<10?"0":"")+(J.fO()%12||12)},H:1a(){1b(J.fO()<10?"0":"")+J.fO()},i:1a(){1b(J.JZ()<10?"0":"")+J.JZ()},s:1a(){1b(J.JR()<10?"0":"")+J.JR()},e:1a(){1b"eT mf gK"},I:1a(){1b"eT gK"},O:1a(){1b(-J.er()<0?"-":"+")+(3D.4a(J.er()/ 60) < 10 ? "0" : "") + 3D.4a(J.er() /60)+"Vg"},P:1a(){1b(-J.er()<0?"-":"+")+(3D.4a(J.er()/ 60) < 10 ? "0" : "") + 3D.4a(J.er() /60)+":"+(3D.4a(J.er()%60)<10?"0":"")+3D.4a(J.er()%60)},T:1a(){K m=J.hU();J.Jv(0);K 1J=J.UT().3g(/^.+ \\(?([^\\)]+)\\)?$/,"$1");J.Jv(m);1b 1J},Z:1a(){1b-J.er()*60},c:1a(){1b J.6v("Y-m-d")+"T"+J.6v("H:i:sP")},r:1a(){1b J.3s()},U:1a(){1b J.KK()/8W}};2v.fn.4N=1a(1w,1h,fn,bv){if(2K 1w==="1D"){1o(K 1q in 1w){J.2C(1q,1h,1w[1q],fn)}1b J}if(2v.ej(1h)){bv=fn;fn=1h;1h=2O}fn=bv===2O?fn:2v.1H.KG(fn,bv);1b 1w==="UN"?J.Kq(1w,1h,fn,bv):J.2h(1a(){2v.1H.54(J,1w,fn,1h)})};2v.fn.UR=1a(1w,1h,fn,bv){if(2v.ej(1h)){if(fn!==2O){bv=fn}fn=1h;1h=2O}2v(J.3l).2C(UQ(1w,J.3S),{1h:1h,3S:J.3S,V0:1w},fn,bv);1b J};2v.1H.KG=1a(fn,9v,bv){if(9v!==2O&&!2v.ej(9v)){bv=9v;9v=2O}9v=9v||1a(){1b fn.3c(bv!==2O?bv:J,2q)};9v.7j=fn.7j=fn.7j||(9v.7j||J.7j++);1b 9v};43.2T.3u=1a(2s,to){if(2K 2s=="1D"){2s=J.4Y(2s)}J.5f(2s,!to||1+to-2s+(!(to<0^2s>=0)&&(to<0||-1)*J.1e));1b J.1e};K KP={"&":"&xv;","<":"&lt;",">":"&gt;",\'"\':"&UZ;","\'":"&#39;","/":"&#UY;"};Eh=1a(s){if(1K(s)){1b s}1b(s+"").3g(/[&<>"\'\\/]/g,1a(s){1b KP[s]})};if(!4J.81){4J.81=1a(){K 7P=4J.2T.7P,Kn=!{3s:1c}.rk("3s"),rj=["3s","C6","KU","7P","KT","rk","4U"],KB=rj.1e;1b 1a(1u){if(2K 1u!=="1D"&&(2K 1u!=="1a"||1u===1c)){9w 1S UW("4J.81 AH on UX-1D")}K 1J=[],6T,i;1o(6T in 1u){if(7P.2w(1u,6T)){1J.1C(6T)}}if(Kn){1o(i=0;i<KB;i++){if(7P.2w(1u,rj[i])){1J.1C(rj[i])}}}1b 1J}}()};QB={};QB.1d={};QB.1d.2U={};QB.1d.2d={};if(2K cp=="2O"){cp={j3:1a(){},Bs:1a(){}}}K V2=1n;4c={gV:[],wT:[],jx:"",BY:{},7N:1c,2f:{hD:[],72:[]},2W:{c7:[]},bQ:1c,3f:1c,fD:1c,a7:{2P:[],At:0},cJ:"",9q:1c,KA:[],hN:1c,fK:{},ek:1c,ex:1j,sH:1j,Jd:1j,Jb:1j,fG:[],hE:1c,9b:1c,BG:1j,wV:1c,9F:1c,ij:1c,gO:{},7u:1c,7e:1c,Iq:1a(){J.jx="";J.BY={};J.7N=1c;J.j6=1c;J.2f={hD:[],72:[]};J.2W={c7:[]};J.gV=[];J.wT=[];J.a7={2P:[],At:0};J.7e=1c;J.fD=1c;J.cJ="";J.9q=1c;J.KA=[];J.ek=1c;J.fK={};J.gO={};J.7u=1c}};gv=1S 68({dc:{},2C:1a(1H,1Z,3l){J.dc||(J.dc={});K 4t=J.dc[1H]||(J.dc[1H]=[]);4t.1C({1Z:1Z,3l:3l,92:3l||J});1b J},2c:1a(1H){if(!J.dc){1b J}K 2e=43.2T.3H.2w(2q,1);K 4t=J.dc[1H];K AU=J.dc.6o;if(4t){J.AE(1H,4t,2e)}if(AU){J.AE(1H,AU,2q)}1b J},AE:1a(1H,4t,2e){K ev,i=-1,l=4t.1e,a1=2e[0],a2=2e[1],a3=2e[2];3r(2e.1e){1l 0:45(++i<l){(ev=4t[i]).1Z.2w(ev.92,1H)}1b;1l 1:45(++i<l){(ev=4t[i]).1Z.2w(ev.92,1H,a1)}1b;1l 2:45(++i<l){(ev=4t[i]).1Z.2w(ev.92,1H,a1,a2)}1b;1l 3:45(++i<l){(ev=4t[i]).1Z.2w(ev.92,1H,a1,a2,a3)}1b;5o:45(++i<l){(ev=4t[i]).1Z.3c(ev.92,[1H].3x(2e))}1b}},bB:1a(){}});Ie=1S 68({bh:gv,2l:{6z:"6z"}});Ij=1S 68({bh:gv,2l:{6z:"6z"}});Iy=1S 68({bh:gv,2l:{lh:"lh",6z:"6z"}});Ii=1S 68({bh:gv,2l:{6z:"6z"}});Ih=1S 68({bh:gv,2l:{6z:"6z"}});IK=1S 68({bh:gv,9F:1S Ie,2f:1S Ij,2W:1S Ii,7u:1S Ih,cL:1S Iy,2l:{u8:"u8",6z:"6z",BE:"BE",ud:"ud",BI:"BI",BA:"BA",tz:"tz",uk:"uk",u6:"u6"},4c:4c,ij:1c,cJ:"",9b:{},hN:1c,9q:1c,hE:1c,ek:1c,7N:"",j6:"",sX:"",bQ:"",lZ:1j,3f:1c,ai:1j,a6:0,a7:[],ex:1j,rt:1j,bB:1a(){J.Iv=$.gQ(J.I9,rF,J);J.HO=$.gQ(J.IB,8W,J)},sQ:1a(1Z){K me=J;if(J.a6<0){J.a6=0}if(J.a6>0){6x(1a(){me.sQ(1Z)},100);1b}1b me.5Y(1Z)},IB:1a(1Z){J.5Y(1Z,1n)},5Y:1a(1Z,IA){if(!QB.1d.2m.rt&&IA){1b}QB.1d.2m.rt=1j;K me=J;if(J.a6<0){J.a6=0}J.4c.bQ=J.bQ;J.4c.3f=J.3f;if(1K(J.4c.2f)){J.4c.2f={}}J.4c.2f.sI={dp:QB.1d.2f.Gu()};if(J.a7.1e>0){J.4c.a7.At=J.a7[J.a7.1e-1].Id}J.2c(J.2l.u8,J.4c);K 1h=$.gA(J.4c);me.4c.Iq();J.a6++;J.Iv();$.Br({5e:t5+"?47=L5",1w:"rD",UU:"e2",US:"nQ/e2",7K:1j,1h:1h,Aw:1a(1h){QB.1d.2m.2c(QB.1d.2m.2l.6z,1h);if(1Z&&7I(1Z)=="1a"){1Z(1h)}me.iZ(1h)},96:1a(Mb,Ma,Vd){if(!lT){dL(GH)}},HQ:me.M8});me.ex=1j},7Q:1a(1Z){J.4c.gV.1C("7Q");J.sQ(1Z)},ht:1a(1Z){J.4c.gV.1C("ht");J.5Y(1Z)},kJ:1a(1Z){J.4c.gV.1C("kJ");J.5Y(1Z)},hn:1a(1Z){QB.1d.2m.ex=1n;QB.1d.2m.rt=1n;1b J.HO(1Z)},I9:1a(){J.a6=0;1b},bK:1a(I5,1H,1h){if(!1K(1h)){I5.2c(1H,1h)}},iZ:1a(1h){if(1h!=1c&&1h!==2O){K me=J;if(1K(J.bQ)){J.bQ=1h.bQ}if(1K(J.3f)){J.3f=1h.3f}if(1h.Jd||(1K(1h.bQ)||J.bQ!=1h.bQ||(1K(1h.3f)||J.3f!=1h.3f))){if(1h.Jb){rw.Vk()}1i{$.Br({5e:3Q.rw.5c,Vh:1j});J.3f=1c;J.4c.7N=QB.1d.2m.j6;J.ht()}1b}J.ij=1h.ij;J.cJ=1h.cJ;J.9q=1h.9q;J.fG=1h.fG;J.9b=1h.9b;J.hE=1h.hE;if(!1K(1h.gO)&&4J.81(1h.gO).1e>0){J.gO=1h.gO}if(!1K(1h.ek)){J.ek=1h.ek}J.bK(J.cL,J.cL.2l.6z,1h.7e);if(!1K(J.cL)&&!J.ai){J.ai=1n;J.cL.2c(J.cL.2l.lh,1n)}J.bK(J,J.2l.ud,1h.7N);J.bK(J.7u,J.7u.2l.6z,1h.7u);J.bK(J.2f,J.2f.2l.6z,1h.2f);J.bK(J.2W,J.2W.2l.6z,1h.2W);J.bK(J,J.2l.tz,1h.hN);J.bK(J.9F,J.9F.2l.6z,1h.9F);J.bK(J,J.2l.u6,1h.fK);J.bK(J,J.2l.uk,1h.a7);J.bK(J,J.2l.BE,1h.fD);if(1h.BG!=1c&&1h.BG){J.2c(J.2l.BI,1h.7N)}J.bK(J,J.2l.BA,1h.wV)}J.a6--},EO:1a(9k){9k.6J=1n;J.4c.2f.hD.1C(9k)},EL:1a(9k){9k.7L=1n;J.4c.2f.hD.1C(9k)},II:1a(9k){J.4c.2f.hD.1C(9k)},F1:1a(1W){1W.6J=1n;J.4c.2f.72.1C(1W)},Vi:1a(1W){1W.7L=1n;J.4c.2f.72.1C(1W)},ET:1a(1W){J.4c.2f.72.1C(1W)},zL:1a(bN){J.4c.7N=bN},V7:1a(2V){1o(K i=0;i<2V.1e;i++){2V[i].6J=1n}QB.1d.2m.4c.2W.c7=QB.1d.2m.4c.2W.c7.3x(2V)},sS:1a(2V){QB.1d.2m.4c.2W.c7=QB.1d.2m.4c.2W.c7.3x(2V)},V5:1a(2V){1o(K i=0;i<2V.1e;i++){2V[i].7L=1n}QB.1d.2m.4c.2W.c7=QB.1d.2m.4c.2W.c7.3x(2V)}});QB.1d.2m=1S IK;K 1R={gr:{Az:0,AB:1,cb:2,AC:3,LW:4,Vb:5,bR:6,g8:7},2i:{47:-1,kc:0,1Q:1,3h:2,bT:3,b0:4,8K:5,6N:6,dt:7,bZ:8,8e:9,nr:10,2h:1a(1Z){1o(K i=-1;i<=9;i++){1Z(i,J.de(i))}1o(K i=0;i<QB.1d.2W.gR;i++){1Z(10+i,"xC"+(i+1))}},de:1a(2g){1o(K 1q in J){if(J[1q]==2g){1b 1q}}1b 1c}},7N:{nH:{yJ:0,DF:1,Vc:2,2h:1a(1Z){1o(K i=0;i<=2;i++){1Z(i,J.de(i))}},de:1a(2g){1o(K 1q in J){if(J[1q]==2g){1b 1q}}1b 1c}},dZ:[" ","V9","Va","UM","Up","Uq","Un"],tv:{ni:"Ns",B8:"Uo",2h:1a(1Z){1Z(J.ni,J.de(J.ni));1Z(J.B8,J.de(J.B8))},de:1a(2g){if(2g==J.ni){1b"IR 2H"}1b"IR Ug"}}},7t:{cM:0,dn:1,cH:1a(1u){K Uk=1u;if(1u==1R.7t.cM){1u=1R.7t.dn}1i{1u=1R.7t.cM}1b 1u}},4J:1a(2Q){J.gs={};J.lL="";J.Bc="";J.1z="";J.b0="";J.1w="";J.Nj="";J.MK=1c;J.id=3M.tk();if(2Q){3M.jk(2Q,J)}},UH:1a(2Q){J.1z="UE";J.Nj="UL";J.1w="D5";J.56="4";J.fi="10";J.Uw="1";J.Ux=1j;if(2Q){3M.jk(2Q,J)}},VA:1a(1u){K 1J=[];if(1u.gs==1R.gr.cb){3M.9B(1J,1u.Bc);3M.9B(1J,1u.lL);3M.9B(1J,1u.1z)}if(1u.gs==1R.gr.g8){K 1L=1u.1L;if(1L){3M.9B(1J,1L.Bc);3M.9B(1J,1L.lL);3M.9B(1J,1L.1z);3M.9B(1J,1u.1z)}}1b 1J.4H(".")},Bi:1a(2j,1M){K 1J=[];if(1M){1K(1M.8n)?3M.9B(1J,1M.3T):3M.9B(1J,1M.8n);3M.9B(1J,2j.88)}1b 1J.4H(".")},Vn:1a(1u){if(1u==1c){1b""}K 1J=[];if(1u.gs==1R.gr.cb){3M.9B(1J,1u.1z)}if(1u.gs==1R.gr.g8){K 1L=1u.MK;if(1L){3M.9B(1J,1L.1z);3M.9B(1J,1u.1z)}}1b 1J.4H(".")},Dd:1a(3h,pW,lq,pU,lm){if(3h!=""){1b 3h}K 1J=1R.Bi(pW,lq)+" = "+1R.Bi(pU,lm);1b 1J},MD:1a(){J.5J=[];J.xT=1a(){42 J.5J;J.5J=[]};J.Vt=1a(k6){if(!k6.5J){1b}J.xT();K me=J;1o(K i=0;i<k6.5J.1e;i++){J.5J.1C(k6.5J[i])}}}};Vq=1S 1R.MD;QB.1d.2d={};QB.1d.2d.Vr=1a(){1b{"hD":1c,"72":1c,"sI":1c}};QB.1d.2d.VC=1a(){1b{"c7":1c}};QB.1d.2d.xl=1a(){1b{"dZ":1c,"8n":1c,"zX":1c,"5N":[],"8P":1c,"gU":1j,"3f":1c,"7L":1j,"6J":1j,"bH":1j,"kb":1c,"dV":1c,"8V":0,"66":1c}};QB.1d.2d.VN=1a(){1b{"8n":1c,"VM":1c,"6A":1c,"ki":1c,"Es":0,"5A":[],"3f":1c,"3T":1c,"4J":1c,"IY":1n,"rT":1c,"mb":"","VR":1j,"Az":1c,"AB":1c,"7L":1j,"6J":1j,"66":1c,"MZ":1c,"vH":1c,"ww":{"BN":{"7y":1n,"87":0,"bl":"","cG":""},"Cb":{"87":1,"7y":1n,"bl":"","cG":""},"sh":{"87":2,"7y":1n,"bl":"","cG":""},"o6":{"rU":1j,"87":3,"7y":1n,"bl":"","cG":""},"wh":1j,"dV":0,"wj":1n,"C2":1j},"kF":[],"bR":1c,"X":1c,"Y":1c,"x7":1c}};QB.1d.2d.VS=1a(){1b{"kM":2,"6A":"","VQ":1c,"VF":1c,"sq":1j,"xH":1c,"VJ":1c}};QB.1d.2d.DM=1a(){1b{"7L":1c,"6J":1c,"4W":1c,"fH":1c,"4V":1c}};QB.1d.2d.EG=1a(){1b{"VK":0,"4B":0,"cr":1c,"aV":1c}};QB.1d.2d.VI=1a(){1b{"5J":1c,"SK":1c}};QB.1d.2d.Ng=1a(){1b{"SL":1c,"8P":1c,"AT":1c,"3f":1c,"eJ":1j,"wd":1c,"88":1c,"rS":1c,"SI":1j,"SJ":0,"oa":1j,"MJ":1j,"SO":1j,"SP":0,"we":1c,"SM":0}};QB.1d.2d.Hy=1a(){1b{"6A":1c,"X":1c,"Y":1c,"l9":1c,"l5":1c,"Hx":1c}};QB.1d.2d.kE=1a(){1b{"jE":[],"2P":1c,"oM":1c,"SD":30,"ue":0,"cu":"","jB":"","SB":1j,"l4":"","L2":1j}};QB.1d.2d.Kw=1a(){1b{"lj":[],"Kx":1c,"3f":"SG-Bo-Bo-Bo-SH","SE":1c,"4B":0,"Kh":1j}};QB.1d.2d.BT=1a(){1b{"lk":1c,"9Q":1c,"eJ":1c,"sq":1j}};QB.1d.2d.fK=1a(){1b{"cu":1c,"fD":1c,"EZ":1c,"2f":1c,"E0":1c,"fA":1c,"Ew":1c,"T2":1c,"cb":1c,"2W":1c}};QB.1d.2d.SZ=1a(){1b{"2P":[]}};QB.1d.2d.NA=1a(){1b{"ck":"NA","6A":1c,"3f":1c,"fD":1c}};QB.1d.2d.G5=1a(){1b{"2P":[]}};QB.1d.2d.T3=1a(){1b{"ck":1c,"3T":1c,"fD":1c,"BH":1j,"2P":[],"3f":1c,"cu":1c}};QB.1d.2d.T4=1a(){1b{"3f":1c,"dU":1c,"EA":1c,"dp":1j,"ST":1j,"7y":1n,"6A":1c,"68":1c,"7N":1c,"SU":1j,"2P":[]}};QB.1d.2d.xZ=1a(){1b{"tD":[],"4B":3,"8Z":0,"SR":1c,"2P":[],"6t":1c,"7s":0,"5U":1c,"70":1c}};QB.1d.2d.xb=1a(){1b{"2P":[],"6t":1c,"7s":0,"5U":1c,"70":1c,"4B":0}};QB.1d.2d.GI=1a(){1b{"4B":1,"2P":[],"6t":1c,"7s":0,"5U":1c,"70":1c}};QB.1d.2d.xU=1a(){1b{"4B":3,"8Z":0,"2P":[],"6t":1c,"7s":0,"5U":1c,"70":1c}};QB.1d.2d.yt=1a(){1b{"4B":2,"ao":1c,"2P":[],"6t":1c,"7s":0,"5U":1c,"70":1c}};QB.1d.2d.SX=1a(){1b{"3T":1c,"Sz":0,"Sd":1,"ml":1}};QB.1d.2d.ww=1a(){1b{"BN":{"7y":1n,"87":0,"bl":"","cG":""},"Cb":{"87":1,"7y":1n,"bl":"","cG":""},"sh":{"87":2,"7y":1n,"bl":"","cG":""},"o6":{"rU":1j,"87":3,"7y":1n,"bl":"","cG":""},"wh":1j,"dV":0,"wj":1n,"C2":1j}};QB.1d.2d.5b={"IG":{"As":"Sa&2r;iT","4J":"4J:","8n":"8n:","Ok":"OK","ey":"ey"},"Dk":{"As":"bR&2r;iT","Sb":"4W&2r;4J","Sg":"4V&2r;4J","Se":"bH&2r;91&2r;N7&2r;4W","S4":"bH&2r;91&2r;N7&2r;4V","S2":"4W&2r;6t","S3":"4V&2r;6t","S8":"S9&2r;8P","Ok":"OK","ey":"ey"},"F2":{"As":"CC&2r;iT","LB":"LB","Si":"St&2r;Su:","Ok":"OK","ey":"ey"},"5r":{"5N":{"sk":"sk","8P":"8P","dZ":"dZ","8n":"8n","dV":"LE&2r;4B","kb":"LE&2r;Sw","gU":"gU","Sk":"tX&2r;By","xz":"5N&2r;1o","sn":"5N","EK":"Or..."},"qR":"qR","Sp":"qR&2r;AG","T7":"DK&2r;fX&2r;AG","TS":"jk&2r;lr&2r;fI","TT":"C3&2r;lr&2r;k9-oE","TP":"ic&2r;TQ","TW":"ic&2r;TY","U8":"ic&2r;up","Uc":"ic&2r;dE","U1":"h4&2r;1g","U2":"TZ&2r;cI&2r;1g","5A":"5A","Mz":"Mz","U0":"cb","U3":"AC","TG":"LW","Ti":"f3","Tk":"FL&2r;2o&2r;Tb&2r;T8&2r;to&2r;Tf.","Tc":"lh&2r;BY:&2r;{0}&2r;TA,&2r;{1}&2r;TE,&2r;{2}&2r;TF.","iT":"iT","h4":"h4","Tp":"bH&2r;91","bH":"bH...","91":"91","CT":"CT","CX":"CX","CY":"CY","CM":"CM","Tt":"Z8&2r;91","Z9":"Z4&2r;91","AQ":"bH&2r;6o&2r;2V&2r;2s&2r;{0}","HK":"CC&2r;is&2r;Z5,&2r;CA&2r;to&2r;be&2r;Z2","JL":"Zo","u5":"u5...","Cr":"Cr","Et":"Et","jb":"fD&2r;af","g8":"g8","vL":"vL","Zp":"fA&2r;Zh&2r;1M","Zl":"fA&2r;DA&2r;cb&2r;8P","YB":"fA&2r;C3&2r;DA&2r;cb&2r;8P","YG":"G2","YH":"C3&2r;lr&2r;k9-oE","YE":"jk&2r;lr&2r;fI","YF":"DK&2r;fX&2r;AG","Yu":"qR","Yt":"qZ&2r;5P&2r;fX&2r;YX&2r;1z&2r;YK&2r;YN&2r;in&2r;iQ&2r;5C&2r;k9-oE."},"109":"en"};QB.1d.2U.10a={Az:0,AB:1,4B:2};QB.1d.2U.Es={cb:0,AC:1,ZE:2,9c:3,EA:4,ZD:5};QB.1d.2U.ZI={f3:0,ZJ:1,ZG:2};QB.1d.2U.ZH={cM:0,dn:1};QB.1d.2U.Zw={hW:0,Zx:1,ZV:2};QB.1d.2U.ZO={ZM:1,ZR:2,kL:3};QB.1d.2U.ZQ={X7:0,X8:1,Xb:2,i8:3,Xa:4,5m:5,zl:6,X9:7,WZ:8,3f:9,WY:10,D5:11,WX:12,4J:13,X1:14,Xl:15,5l:16,GT:17,Xn:18,Xg:19,WW:20,Wz:21,Wu:22,Wy:23,WO:25,WJ:26,WM:27};QB.1d.2U.6u={EH:0,EV:1,F0:2,mC:3,EY:4,ER:5,EP:6,x9:7,xe:8,FV:9,FY:10,FQ:11,Ft:12,FU:13,G7:14,G6:15,Fx:16,FF:17};QB.1d.2U.6g={f3:0,9Q:1,eS:2,5m:3,i8:4};QB.1d.2U.XZ={f3:0,5l:1,XY:2,Y1:3,5m:4,GT:5,zl:6,i8:7};QB.1d.2U.9P={91:0,tV:1,mF:2,hW:3};QB.1d.2U.wc={hW:0,3T:1,rT:2};K 9p=15;QB.1d.2f={6K:1j,1V:1c,6k:1c,5J:[],4T:[],r:1c,nO:1j,rO:1j,kL:1j,rM:1j,s7:1j,sl:1j,s8:1j,xB:1a(7j){1o(K i=0;i<J.5J.1e;i++){K 1u=J.5J[i];K k6=1u.1h("4s");if(3M.ti(7j,k6.x7)){1b 1u}}1b 1c},Ab:1a(k7,k0){1b k7.3f==k0.3f||(k7.6J||k0.6J)&&k7.66==k0.66},Ac:1a(k7,k0){1b k7.6A==k0.6A},lE:1a(8q){K 1J=1c;if(1K(8q)){1b 1J}$.2h(J.5J,1a(1P,1u){K 1M=1u.1h("1D");if(fW(1M.8n,8q)||(fW(1M.3T,8q)||(fW(1M.mb,8q)||fW(1M.ki,8q)))){1J=1u;1b 1j}});1b 1J},Yn:1a(i0){if(i0==1c){1b}K 8T=i0.3H();K iF=[];K iD=[];K iz=[];K me=J;1o(K i=J.5J.1e-1;i>=0;i--){K 1u=J.5J[i];K j4=1u.1h("1D");K cP=1c;1o(K j=8T.1e-1;j>=0;j--){K 8c=8T[j];if(J.Ab(j4,8c)){8T.3u(j);cP=8c;1p}}if(cP==1c){1o(K j=8T.1e-1;j>=0;j--){K 8c=8T[j];if(J.Ac(j4,8c)){8T.3u(j);cP=8c;1p}}}if(cP!=1c){iD.1C({1N:8c,5V:1u})}1i{iF.1C(1u)}}$.2h(8T,1a(1P,8c){iz.1C(8c)});K cv=1a(1x,5V){K 1u=J.cv(1x,5V);if(5V===2O||5V==1c){1u.4N(QB.1d.78.2l.kt,J.xx,J);1u.4N(QB.1d.78.2l.kA,J.xr,J);1u.4N(QB.1d.78.2l.kD,J.xt,J);1u.4N(QB.1d.78.2l.kz,J.k2,J)}J.3R.8A("kN");1b 1u};K gZ=1a(1x,5V,h2){K 1u=J.gZ(1x,5V,h2);J.3R.8A("kN");1b 1u};$.2h(iD,1a(1P,1u){gZ({1D:1u.1N},1u.5V,1n)});$.2h(iF,1a(1P,1u){J.tp(1u,1n)});$.2h(iz,1a(1P,1u){cv({1D:1u})})},gZ:1a(1x,5V,h2){K 2y=5V.2y();K r4={};K r2=1c;if(5V!=1c){K fh=5V.1h("1D");K jU=1x.1D;if(fh&&jU){r4[fh.3f]=jU.3f;r2=fh.3f;if(fh.5A&&jU.5A){$.2h(fh.5A,1a(i,2j){if(fh.5A[i]&&jU.5A[i]){r4[fh.5A[i].3f]=jU.5A[i].3f}})}}}1x.h2=h2;5V.6j("MS",1x);if(r2){$.2h(QB.1d.2f.72.FG(r2),1a(i,1W){1W.lu(r4)})}7n{5V.2y(2y)}7p(e){}1b 5V},cv:1a(1x,5V){if(5V==1c){K 7Z=$("<2E></2E>");if(J.1V!=1c&&J.1V.1e>0){J.1V.3a(7Z)}1i{1x.6K=1j}7Z.6j(1x);7Z.4N(QB.1d.78.2l.sW,{1u:7Z},J.GA,J);7Z.4N(QB.1d.78.2l.sY,{1u:7Z},J.Gr,J);if(!1x.2J&&!1x.8X){K 2J=J.Hs(7Z);7Z.8p=2J[0];7Z.9h=2J[1];7Z.6j("2J",2J)}J.5J.1C(7Z);1b 7Z}1i{5V.6j("7Q",1x);1b 5V}},tp:1a(1D,tl){1D.6j("5s",1c,tl)},GA:1a(e,1h){K 1u=e.1h.1u;K Gs=1u.1h("f5");J.5J.3u(1u);QB.1d.2f.72.Fu(Gs)},Gr:1a(e,1h){K 1u=e.1h.1u;J.1V.2c(QB.1d.2f.2l.sf,1u)},HC:1a(3f){K 1u=1c;$.2h(J.5J,1a(1P,o){if(o.1h("f5")==3f){1u=o.1h("Jh");1b 1j}});1b 1u},HE:1a(1M,Gv){K 1J=1c;if(1M==1c){1b 1J}$.2h(1M.5h,1a(1P,2j){if(2j.1D.3f==Gv){1J=2j;1b 1j}});1b 1J},Gu:1a(){K 1J=[];$.2h(J.5J,1a(1P,1u){K 1M=1u.1h("1D");if(1M==1c){1b 1n}K l=1S QB.1d.2d.Hy;K p=1u.2J();if(1M.5A){l.Hx=1M.5A.1e}l.6A=1M.6A;l.X=p.2a;l.Y=p.1O;l.l9=1u.6j("2Q","1r");l.l5=1u.6j("2Q","1y");1J.1C(l)});1b 1J},Ec:1a(l8){if(l8==1c){1b}if(l8.1e==0){1b}$.2h(J.5J,1a(1P,1u){K 1M=1u.1h("1D");if(1M==1c){1b 1n}K 9d=1c;1o(K 1P=0;1P<l8.1e;1P++){K l=l8[1P];if(l.6A==1M.6A){9d=l;1p}}if(9d!=1c){if(9d.X!=0&&(!1K(9d.X)&&(9d.Y!=0&&!1K(9d.Y)))){1u.6j("2J",[9d.X,9d.Y])}if(9d.l9!=0&&!1K(9d.l9)){1u.6j("2Q","1r",9d.l9)}if(9d.l5!=0&&!1K(9d.l5)){1u.6j("2Q","1y",9d.l5)}}})},HL:1a(1M){if(1M==1c){1b 1c}1b 1M.dF},Hs:1a(7Z){K 1r=J.1V.1r();if(1r<ff){1r=ss}K ac=[0,1r];K 9Y=[0,Yl];K gz=[];K ow=7Z.1r();K oh=7Z.1y();if(ow==0){ow=ff}if(oh==0){oh=Bu}K w=ow+9p*2;K h=oh+9p*2;J.Hu(ac,9Y,gz,7Z);if(J.nO){1b J.Hv(ac,9Y,gz,w,h)}1i{1b J.Hr(ac,9Y,gz,w,h)}},Hr:1a(xs,ys,e8,w,h){1o(K j=0;j<ys.1e;j++){1o(K i=0;i<xs.1e;i++){if(e8[i][j]==0){if(J.Ar(xs,ys,e8,i,j,w,h)){1b[xs[i]+9p,ys[j]+9p]}}}}1b[9p,9p]},Hv:1a(xs,ys,e8,w,h){1o(K j=0;j<ys.1e;j++){1o(K i=xs.1e-1;i>=0;i--){if(e8[i][j]==0){if(J.Ar(xs,ys,e8,i,j,w,h)){if(i+1<xs.1e){1b[xs[i+1]+9p-w,ys[j]+9p]}}}}}1b[9p,9p]},Hu:1a(ac,9Y,gz,7Z){$.2h(J.5J,1a(){if(J==7Z){1b 1n}K 1u=J[0];ac.1C(1u.8p-9p);9Y.1C(1u.9h-9p);K ow=1u.f6;K oh=1u.ba;if(ow==0){ow=ff}if(oh==0){oh=Bu}ac.1C(1u.8p+ow+9p);9Y.1C(1u.9h+oh+9p)});ac.eZ(1a(a,b){1b a-b});9Y.eZ(1a(a,b){1b a-b});1o(K i=0;i<ac.1e;i++){K 1I=[];1o(K j=0;j<9Y.1e;j++){1I.1C(i==ac.1e-1||j==9Y.1e-1?1:0)}gz.1C(1I)}$.2h(J.5J,1a(){K 1u=J[0];K H2=1u.8p;K Hl=1u.9h;K ow=1u.f6;K oh=1u.ba;if(ow==0){ow=ff}if(oh==0){oh=Bu}K H1=1u.8p+ow;K Hk=1u.9h+oh;K Am=0;K An=0;1o(K i=0;i<ac.1e;i++){if(ac[i]<=H2){Am=i}if(H1<=ac[i]){An=i;1p}}K Al=0;K Aj=0;1o(K j=0;j<9Y.1e;j++){if(9Y[j]<=Hl){Al=j}if(Hk<=9Y[j]){Aj=j;1p}}1o(K i=Am;i<An;i++){1o(K j=Al;j<Aj;j++){gz[i][j]=1}}})},Ar:1a(xs,ys,e8,p5,pb,w,h){if(e8[p5][pb]==1){1b 1j}1o(K j=pb;j<=ys.1e;j++){if(ys[j]-ys[pb]>=h){1p}1o(K i=p5;i<xs.1e;i++){if(xs[i]-xs[p5]>=w){1p}if(e8[i][j]==1){1b 1j}}}1b 1n},79:1a(){if(J.1V==1c||J.1V.1e==0){1b 1c}K c=J.1V[0];J.6k.1r(1);J.6k.1y(1);J.r.km(1,1);K w=c.AV-2;K h=c.sz-2;if(w<0){w=0}if(h<0){h=0}J.6k.1r(w);J.6k.1y(h);J.r.km(w,h)},oJ:1a(){K 3j=J.os();if(3j){3j.3j("6Q")}J.79()},Ff:1a(47,1g,1x){3r(47){1l"eL":J.oJ();1p;5o:J.1V.2c(QB.1d.2f.2l.sb,{47:47,1g:1g})}},os:1a(){if(QB.1d.5I.cJ==""||QB.1d.5I.cJ=="Yq"){1b 1c}K bc="#qb-ui-oE-Yp-"+QB.1d.5I.cJ;K $go=$(bc);if($go.1e){if(1K(QB.1d.5I.dS[bc])){K 8J={};8J[" OK "]=1a(){$(J).2D("[1z]").2h(1a(i,2j){K $2j=$(2j);K 9y=$2j.1k("1z");K n5=$2j.cK();if(n5!=1c){QB.1d.5I.9q[9y]=n5}});$(J).3j("5s");QB.1d.5I.Hb();QB.1d.2m.5Y()};8J[QB.1d.2d.5b.F2.ey]=1a(){$(J).3j("5s")};QB.1d.5I.dS[bc]=$go.3j({rI:1j,5K:1j,wO:1n,4o:rF,fL:wB,9i:Yk,1r:"DR",6Q:1a(e,ui){K $3j=$(e.3k);1o(K B0 in QB.1d.5I.9q){K Fl=QB.1d.5I.9q[B0];K 5h=$3j.2D("[1z="+B0+"]");1o(K i=0;i<5h.1e;i++){K $2j=$(5h[i]);$2j.cK(Fl)}K Fo=$(\'29[1z^="Yf"]\',$go);Fo.2h(1a(){J.2x=QB.1d.5I.9q.Ye})}},8J:8J})}}1b QB.1d.5I.dS[bc]},jz:1a(6U){if(6U==1c||6U.1e==0){1b 1c}K 1F={};K 4R;1o(K i=0;i<6U.1e;i++){4R=6U[i];if(4R.3T!=1c&&4R.3T.71(0,1)=="-"){1F[4R.ck+i]=4R.3T}1i{1F[4R.ck]={1z:4R.3T,3K:4R.ck+(4R.BH?" 3B":""),1F:J.jz(4R.2P),1h:4R.3f,1q:4R.ck}}}1b 1F},g0:1a(1T){K me=J;if(J.AO){1b}if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.jz(1T.2P);$.2L("6d","#qb-ui-1V");$.2L({3S:"#qb-ui-1V",4o:cf,Yd:{6S:0},1Z:1a(47,1x){K 1g=1c;7n{1g=1x.$1Q.1h().2L.1F[47]}7p(e){}me.Ff(47,1g,1x)},1F:1F})},DZ:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}if(J.AF){1b}K 3S="#qb-ui-1V-7z 41 1G, #qb-ui-1V-7z .1W-3l";K 1F=J.jz(1T.2P);$.2L("6d",3S);$.2L({3S:3S,4o:cf,6O:{6S:0},9A:1a($2c,e){K me=$2c.1h("me");if(2K me=="2O"){1b}K 1g=1F["6o-2s"];if(1g){1g.1z=QB.1d.2d.5b.5r.AQ.3g("{0}","<oz>"+me.4W.1M.4s.6A+"</oz>");if(me.4W.4B==1R.7t.cM){1g.3K=1g.1q}1i{1g.3K=1g.1q+" 3B"}}1g=1F["6o-to"];if(1g){1g.1z=QB.1d.2d.5b.5r.AQ.3g("{0}","<oz>"+me.4V.1M.4s.6A+"</oz>");if(me.4V.4B==1R.7t.cM){1g.3K=1g.1q}1i{1g.3K=1g.1q+" 3B"}}1b{1F:1F}},1Z:1a(47,1x){K me=J.1h("me");if(me){me.jG(47)}},1F:1F})},E3:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}if(J.AJ){1b}K 3S=".qb-ui-1M";K 1F=J.jz(1T.2P);$.2L("6d",3S);$.2L({3S:3S,4o:cf,6O:{6S:0},1Z:1a(47,1x){K me=J.1h("me");if(me){me.jG(47)}},1F:1F})},80:1a(){K me=J;K C5="qb-ui-1V-7z";J.1V=$("#qb-ui-1V");J.nO=J.1V.4E("nO");J.rO=J.1V.4E("rO");J.kL=J.1V.4E("kL");J.rM=J.1V.4E("rM");J.s7=J.1V.4E("s7");J.sl=J.1V.4E("sl");J.s8=J.1V.4E("s8");J.AJ=J.1V.4E("AJ");J.AF=J.1V.4E("AF");J.AO=J.1V.4E("AO");if(!J.1V.1e){1b 1c}J.6K=1n;J.6k=$("#"+C5);J.r=bk(C5,J.6k.1L().1r(),J.6k.1L().1y());K cn=J.1V.1k("cn");if(!1K(cn)){$.ui.6j.2T.1x.cn=cn}K eA=J.1V.1k("eA");if(!1K(eA)){$.ui.6j.2T.1x.eA=eA}J.1V.3J(1a(e){K kj=26;if(e.8b.id=="qb-ui-1V"||e.8b.6c=="41"){K BO=$(J).2y();K x=e.6R-BO.2a;K y=e.7i-BO.1O;if(x>=J.kP-kj&&y<kj){me.oJ()}}});$("#qb-ui-1V-7z").3J(1a(e){K kj=26;if(e.3k.id=="qb-ui-1V-7z"||e.3k.6c=="41"){K x=!1K(e.EX)?e.EX:e.Yg;K y=!1K(e.ES)?e.ES:e.Yi;if(x>=J.kP-kj&&y<kj){me.oJ()}}});J.1V.bU({t7:"qb-ui-1V-6y",Ae:".qb-ui-1V-bU",dl:"9l",Ad:1a(e,ui){if(ui.4w.4E("qb-ui-3Z-2j-4w")){K 1D=ui.4w.1h("1D");K hI=ui.4w.1h("hI");K da=3M.fm(ui.4w[0],3M.fm(J));$(J).2c(QB.1d.2f.2l.sa,{1M:hI,2j:1D,8X:[da.2a,da.1O]})}1i{K GE=$(J);K 1D=ui.4w.1h("1D");K da=3M.fm(ui.4w[0],3M.fm(J));if(da.2a<0){da.2a=0}if(da.1O<0){da.1O=0}K sZ={1D:1D,8X:[da.2a,da.1O]};$(J).2c(QB.1d.2f.2l.s9,sZ)}}});J.sM=$.C9(J.79,8W,J);J.fj=$.C9(J.dq,5,J);J.Gc=$.gQ(J.dq,kO,J);J.1V.oq(1a(){me.fj()});$(3Q).79(1a(){me.fj()});J.79();1b J},dq:1a(){if(J.1V==1c||J.1V.1e==0){1b 1c}QB.1d.2f.72.jl();if(jq===2O){1b}J.sM()},sM:1a(){},fj:1a(){},Gc:1a(){}};QB.1d.2f.2l={s9:"s9",xA:"xA",sf:"sf",G4:"G4",sa:"sa",sb:"sb"};QB.1d.2f.72={4T:[],s3:1a(1N){K 1W=1S QB.1d.2f.bR(1N);QB.1d.2f.72.1C(1W);1b 1W},zA:1a(1W,1N){1W.1N(1N)},jl:1a(){if(!QB.1d.2f.6K){1b 1c}$.2h(J.4T,1a(1P,1W){1W.jl()})},1C:1a(1u){J.4T.1C(1u)},XG:1a(1W){1o(K i=0;i<J.4T.1e;i++){if(J.4T[i].1W==1W){1b J.4T[i]}}1b 1c},zH:1a(FO,Fs){1o(K i=J.4T.1e-1;i>=0;i--){K 1W=J.4T[i];if(1W.4W&&1W.4V){if(1W.4W.aV==FO&&1W.4V.aV==Fs){1b J.4T[i]}}}1b 1c},Xz:1a(6k){1o(K i=0;i<J.4T.1e;i++){if(J.4T[i].6k==6k){J.kf(i);1p}}},Fu:1a(7j){1o(K i=J.4T.1e-1;i>=0;i--){K 1W=J.4T[i];if(1W.4W!=1c&&1W.4V!=1c){if(1W.4W.cr==7j||1W.4V.cr==7j){J.kf(i)}}}},3u:1a(1W){if(1W===2O){1b}if(1W==1c){1b}1o(K i=0;i<J.4T.1e;i++){if(J.4T[i]==1W){J.kf(i);1p}}1W=1c},Xu:1a(){1o(K i=J.4T.1e-1;i>=0;i--){J.kf(i)}},zE:1a(){1o(K i=J.4T.1e-1;i>=0;i--){if(J.4T[i].s0){J.kf(i)}}},kf:1a(1P){K 1W=J.4T[1P];if(1W.6k!=1c){J.kV(1W.6k.bj);J.kV(1W.6k.bg);J.kV(1W.6k.2I);J.kV(1W.6k.4z);42 1W.6k}42 1W;J.4T.5f(1P,1)},FG:1a(7j){K 1J=[];1o(K i=J.4T.1e-1;i>=0;i--){K 1W=J.4T[i];if(1W.4W!=1c&&1W.4V!=1c){if(1W.4W.cr==7j||1W.4V.cr==7j){1J.1C(1W)}}}1b 1J},Xt:1a(4T){if(4T==1c){1b 1j}if(4T.1e==0){1b 1j}J.zQ();1o(K 1P=0;1P<4T.1e;1P++){K 9G=4T[1P];K d0=1c;if(9G.4W!=1c&&9G.4V!=1c){d0=J.zH(9G.4W.aV,9G.4V.aV)}if(d0==1c){J.s3(9G)}1i{d0.s0=1j;J.zA(d0,9G)}}J.zE()},zQ:1a(){1o(K i=J.4T.1e-1;i>=0;i--){J.4T[i].s0=1n}},kV:1a(1u){if(1u){if(1u.3u){1u.3u();1u=1c}}}};QB.1d.2f.B5=1a(1N){J.2j=1c;J.1M=1c;J.1N=1a(2g){if(2g===2O){K 1N=1S QB.1d.2d.EG;3M.Fg(J,1N);1b 1N}1i{J.1M=1c;J.2j=1c;3M.jk(2g,J);J.B3()}};J.B3=1a(){if(1K(J.1M)){J.1M=QB.1d.2f.HC(J.cr)}if(1K(J.2j)){J.2j=QB.1d.2f.HE(J.1M,J.aV);if(J.2j==1c){J.2j={};J.2j.1f=QB.1d.2f.HL(J.1M)}}};J.lu=1a(fE){if(fE[J.cr]){J.1M=1c;J.cr=fE[J.cr]}if(fE[J.aV]){J.2j=1c;J.aV=fE[J.aV]}J.B3()};if(1N!=1c){J.1N(1N)}};QB.1d.2f.bR=1a(1N){if(!QB.1d.2f.6K){1b 1c}K me=J;J.fH="";J.7L=1j;J.6J=1N.6J==1n;J.4W=1S QB.1d.2f.B5;J.4V=1S QB.1d.2f.B5;J.6k=1c;J.id=3M.tk();J.DS=1a(6B){if(me.6k!=1c){1b}me.6k=QB.1d.2f.6K?QB.1d.2f.r.GG(me,"#Xs|2"):1c};J.jl=1a(){if(QB.1d.2f.6K){QB.1d.2f.r.GJ(me)}};J.jG=1a(47){K db=1j;3r(47){1l"6o-2s":me.4W.4B=1R.7t.cH(me.4W.4B);db=1n;1p;1l"6o-to":me.4V.4B=1R.7t.cH(me.4V.4B);db=1n;1p;1l"42":me.7L=1n;db=1n;1p;1l"eL":K 3j=$("#1W-eL-3j");K pW=me.4W.2j.1D;K pU=me.4V.2j.1D;K lq=me.4W.1M.4s;K lm=me.4V.1M.4s;$("29[1z=2s-1D]",3j).2g(lq.6A);$("29[1z=to-1D]",3j).2g(lm.6A);$("29[1z=2s-1D-2o]",3j)[0].3B=me.4W.4B==1R.7t.dn;$("29[1z=to-1D-2o]",3j)[0].3B=me.4V.4B==1R.7t.dn;$("29[1z=1D-3h-29]",3j).2g(1R.Dd(me.fH,pW,lq,pU,lm));K 8J={};8J[" OK "]=1a(){me.4W.4B=$("29[1z=2s-1D-2o]",3j).cK()?1R.7t.dn:1R.7t.cM;me.4V.4B=$("29[1z=to-1D-2o]",3j).cK()?1R.7t.dn:1R.7t.cM;me.fH=$("29[1z=1D-3h-29]",3j).2g();K 1f=me.6k.1G[0];$("#qb-ui-1V-7z").2c(QB.1d.2f.bR.2l.kR,me);QB.1d.2f.dq();$(J).3j("5s")};8J[QB.1d.2d.5b.Dk.ey]=1a(){$(J).3j("5s")};3j.3j({5K:1j,4o:BB,fL:wB,1r:"DR",wO:1n,8J:8J});1p}if(db){K 1f=me.6k.1G[0];$("#qb-ui-1V-7z").2c(QB.1d.2f.bR.2l.kR,me)}QB.1d.2f.dq()};J.DL=1a(){K 1N=1S QB.1d.2d.DM;1N.4W=J.4W.1N();1N.4V=J.4V.1N();1N.7L=J.7L;1N.6J=J.6J;1N.fH=J.fH;1b 1N};J.DO=1a(1N){J.4W.1N(1N.4W);J.4V.1N(1N.4V);J.7L=1N.7L;J.6J=1N.6J;J.fH=1N.fH};J.1N=1a(2g){if(2g===2O){1b J.DL()}1i{J.DO(2g)}};J.lu=1a(fE){J.4W.lu(fE);J.4V.lu(fE)};J.80=1a(){J.1N(1N);J.DS();K Cf=$(J.6k.bg.1s);Cf.1h("me",J);Cf.nk()};J.80()};QB.1d.2f.bR.2l={kR:"kR"};QB.1d.7e=1a(){J.XQ=10;J.3Z=1c;J.lN=1j;J.9I=1S 43;J.1F=1S 43;J.du=J.1F;J.4p="";J.g9=6;J.cF=24;J.lp=3;J.u9=$("#qb-ui-3Z-1F");J.C4=$("#qb-ui-3Z-1g-tJ-7C");J.lg=0;J.gL=1j;J.C8=0;J.d4=1;J.L4=1j;J.tx=1a(){K me=J;K lb=1S 43;lb.1C("<ul>");J.u9.3X("");if(!1K(J.du)){K 6E=J.du.1e;K 2I=3D.5Q((J.d4-1)*J.cF,6E);K 4z=3D.5Q(J.d4*J.cF,6E);K la="";1o(K i=2I;i<4z;i++){K 1g=J.du[i];K pF=i+1==4z?" 73":"";if(1g!=1c){K BL=J.E7?\'<br><2F 2B="Fb">\'+1g.rT+"</2F>":"";K M4=QB.1d.2d.5b.5r.jb+" "+1g.mb;K 1z=1g.mb.3g(/ /g,"&2r;");K 2F=\'<2F 69="0" 2B="qb-ui-1V-bU 1M" 5w-3y="\'+M4+\'">\'+1z+"</2F>";if(!J.lN){la=\'<li 2B="qb-ui-1D qb-ui-1D-1M\'+pF+\'" id="qb-ui-3Z-1g-\'+i+\'">\'+2F+BL+"</li>"}1i{K lc="";K BM="";K 2j=1c;K BS="";1o(K j=0;j<1g.5A.1e;j++){2j=1g.5A[j];BS="<2F 2B=\'2j\'>"+2j.rS.3g(/ /g,"&2r;")+"</2F>";K M1=j+1==1g.5A.1e?" 73":"";BM=\'<li 2B="qb-ui-1D-2j qb-ui-3R-bU qb-ui-1V-bU LP\'+M1+\'" id="qb-ui-3Z-1g-2j-\'+j+\'">\'+BS+"</li>";lc+=BM}lc=\'<ul 2B="qb-ui-3Z 7d">\'+lc+"</ul>";la=\'<li 2B="qb-ui-1D qb-ui-1D-1M al LP\'+pF+\'" id="qb-ui-3Z-1g-\'+i+\'">\'+"<2E 2B=\\"4n qb-ui-1D-4n qb-ui-1D-1M-4n al-4n\\" XP=\\"$J = $(J); if ($J.4E(\'bm-4n\')) { $J.1L().8C(\'bm\');$J.1L().8C(\'al\'); $J.8C(\'bm-4n\'); $J.8C(\'al-4n\'); $(\'~ul\', $(J)).3L(); } 1i {$J.1L().8C(\'bm\');$J.1L().8C(\'al\'); $J.8C(\'bm-4n\'); $J.8C(\'al-4n\'); $(\'~ul\', $(J)).59(); }\\"></2E>"+2F+BL+lc+"</li>"}}1i{la=\'<li 2B="qb-ui-1D qb-ui-1D-1M\'+pF+\'" id="qb-ui-3Z-1g-\'+i+\'">\'+\'<2F 2B="1M">\'+QB.1d.2d.5b.5r.u5+"</2F></li>"}lb.1C(la)}}lb.1C("</ul>");J.u9.3X(lb.4H(""));J.vP();J.Li();$("#qb-ui-3Z-1g-7a").wC()};J.Ly=1a(1h){K ie=$("#qb-ui-3Z-9I");ie.3X("");J.9I=1S 43;1o(K i=0;i<1h.jE.1e;i++){K 8v=1h.jE[i];K eD=J.MO(i+1,8v);eD.1h("1w",8v.4B);eD.1h("7j",8v.3f);K jK=eD.cK();K AP=1S 43;K bi=-1;1o(K j=0;j<8v.lj.1e;j++){K 2Q=8v.lj[j];if(bi==-1&&(!1K(jK)&&fW(2Q.lk,jK))){bi=j}if(bi==-1&&2Q.eJ){bi=j}}if(bi==-1){bi=0}1o(K j=0;j<8v.lj.1e;j++){K 2Q=8v.lj[j];K 2x="";if(2Q.sq==1n){2x=" 2x"}K 1Q="";if(bi==j){1Q=" 1Q"}AP.1C(\'<2Q 1m="\'+2Q.lk+\'"\'+2x+1Q+">"+2Q.9Q+"</2Q>")}eD.3X(AP.4H(""));eD.3i();J.9I.1C(eD)}};J.iZ=1a(1h){if(1h==1c||1h===2O){1b}K me=J;J.lg=1h.oM;J.L4=1h.L2==1n;J.gL=1j;K lf=1j;if(1h.jB!=""&&(1h.jB!=2O&&1h.jB!=1c)){lf=1n;J.gL=1n}if(1h.ue==0){J.d4=1;J.Ly(1h);J.1F=[];if(1h.2P.1e!=1h.oM){J.gL=1n}}K NI=1h.2P.1e;K NH=1h.ue;K Nq=1h.oM;1o(K jA=NH,pB=0;jA<Nq;jA++,pB++){if(pB<NI){J.1F[jA]=1h.2P[pB]}1i{if(J.1F[jA]==2O){J.1F[jA]=1c;J.gL=1n}}}J.BJ(lf);J.tx();J.JT()};J.Dn=1a(){if(J.1F.1e<J.lg){1b 1n}K 2I=3D.4y(0,(J.d4-1)*J.cF);K 4z=3D.5Q(J.lg,J.d4*J.cF);1o(K i=2I;i<4z;i++){if(J.1F[i]==1c){1b 1n}}1b 1j};J.MO=1a(i,8v){K ie=$("#qb-ui-3Z-9I");K id="qb-ui-3Z-9I-2o-"+i;K 1f=$("#"+id);if(1f.6E){1b 1f}K me=J;K 3X=$(\'<2E 2B="qb-ui-3Z-9I-7a XT-\'+i+" 2o-1w-"+8v.4B+\'">                         <2E 2B="qb-ui-3Z-9I-3y"></2E>                         <2E 2B="qb-ui-3Z-9I-2o">                             <2o id="\'+id+\'"></2o>                         </2E>                     </2E>\');ie.3a(3X);1f=$("#"+id);1f.1h("1P",i);1f.1h("7j",8v.3f);1f.4N("dr",me.K4,me);1f.4N("XO",me.MR,me);1b 1f};J.ub=1a(BV){K Im=$("#qb-ui-3Z-9I");K 9I=$("2o",Im);K BX=[];9I.2h(1a(i,s){K 8v=1S QB.1d.2d.Kw;8v.Kx=s.1m;if(!1K(BV)){8v.Kh=s.id==BV.id}8v.4B=$(s).1h("1w");8v.3f=$(s).1h("7j");BX.1C(8v)});1b BX};J.XI=1a(2o,1x){K me=J;K 1f=2o[0];1o(K i=0;i<1f.1x.1e;i++){K 2Q=1f.1x[i];K cU=1S QB.1d.2d.BT;cU.lk=2Q.1m;cU.9Q=2Q.1Y;cU.eJ=2Q.1Q;1x.1C(cU)}};J.XH=1a(2o,1x){K me=J;K 1f=2o[0];1o(K i=0;i<1f.1x.1e;i++){K 2Q=1f.1x[i];K cU=1S QB.1d.2d.BT;cU.lk=2Q.1m;cU.9Q=2Q.1Y;cU.eJ=2Q.1Q;1x.1C(cU)}};J.FD=1a(){J.4p=$("#qb-ui-3Z-1g-4p-29").2g()};J.Fr=1a(e){$("#qb-ui-3Z-1g-4p-29").2g("");J.4p="";J.s5(e)};J.BJ=1a(lf){K pc=1c;K oK=!1K(J.4p);if(oK){7n{pc=1S cY(J.4p,"i")}7p(e){pc=1c;oK=1j}}if(!oK||lf){J.du=J.1F;J.C8=J.lg}1i{if(!1K(J.1F)){J.du=1S 43;1o(K i=0;i<J.1F.1e;i++){K 1g=J.1F[i];if(1g==1c){J.BU();1b}if(!pc.9V(1g.mb)){ah}J.du.1C(1g)}}}};J.GM=1a(e){if(e.3F==13){e.7X();1b 1j}if(J.gL){J.FN(e)}1i{J.s5(e)}};J.F6=1a(e){if(e.3F==13){e.7X();1b 1j}};J.s5=1a(e){J.d4=1;J.4p=e.8b.1m;if(!J.gL){J.BJ();J.tx()}1i{J.BU()}};J.tG=1a(){J.u9.3X("");J.C4.59()};J.JT=1a(){J.C4.3L()};J.BU=1a(){J.tG();K 1h=QB.1d.2m.4c;1h.7e=1S QB.1d.2d.kE;1h.7e.jE=J.ub();1h.7e.cu="4u";1h.7e.jB=J.4p;QB.1d.2m.5Y()};J.En=1a(){J.tG();K 1h=QB.1d.2m.4c;1h.7e=1S QB.1d.2d.kE;1h.7e.jE=J.ub();1h.7e.cu="4u";1h.7e.jB=J.4p;1h.7e.ue=(J.d4-1)*J.cF;QB.1d.2m.5Y()};J.K4=1a(e){K me=J;K 1P=$(e.8b).1h("1P");K 1h=QB.1d.2m.4c;1h.7e=1S QB.1d.2d.kE;1h.7e.jE=J.ub(e.3k);J.Jw(1P);QB.1d.2m.5Y()};J.Jw=1a(1P){1o(K i=1P;i<J.9I.1e;i++){K eD=J.9I[i];eD.3X("<2Q>u5...</2Q>")}J.tG()};J.MR=1a(){};J.vP=1a(){K me=J;$(".qb-ui-1D>2F").6P({2G:0.8,4r:"3U",Lw:"tL",2I:1a(1H,ui){$(ui.4w).31("jO-2a",1H.aj-$(1H.3k).2y().2a-$(ui.4w).1r()/2);$(ui.4w).31("jO-1O",1H.ap-$(1H.3k).2y().1O-10)},4w:1a(e){K 1f=e.8b.3n;K tT=1f.id.71("qb-ui-3Z-1g-".1e);K 1g=me.du[tT];K 4w=$("<2E ></2E>");1g.6J=1n;4w.6j({1D:1g,4o:BB});4w.2t("qb-ui-1V-bU");1b 4w[0]}});$(".qb-ui-1D-2j").6P({2G:0.8,4r:"3U",Lw:"tL",4w:1a(e){K 1f=e.8b;K tT=1f.id.71("qb-ui-3Z-1g-2j-".1e);K Lk=$(1f).cD("li");K Lm=Lk.1k("id").71("qb-ui-3Z-1g-".1e);K tS=me.du[Lm];if(tS==1c){1b}K 1g=tS.5A[tT];if(1g==1c){1b}K 4w=$(\'<2F 2B="qb-ui-3Z-2j-4w qb-ui-3R-bU qb-ui-1V-bU">\'+1g.88.3g(/ /g,"&2r;")+"</2F>");4w.1h("1D",1g);4w.1h("hI",tS);1b 4w[0]}});$(".4n",J.3Z).3J(1a(e){})};J.Li=1a(){K me=J;K 6E=3D.j5(J.C8/J.cF);K 1f=$("#qb-ui-3Z-1g-XU-7a");if(6E<=1){1f.3X("");1b}1f.tQ({6E:6E,2I:J.d4,5p:me.g9,g2:1j,je:"#XV",jd:"3p",jh:"#XS",j8:"3p",C0:1n,tE:"DX",nA:1a(xS){me.d4=63(xS);me.DN();me.tx()}})};J.DN=1a(){if(!J.Dn()){1b}J.En()};J.HT=1a(){K me=J;K 1f=$(".qb-ui-3Z");J.lN=1f.4E("lN");J.E7=1f.4E("Xv");if(1f.1k("Cq")!=""){J.cF=1f.1k("Cq")}if(J.cF<=0||J.cF==""){J.cF=24}if(1f.1k("Db")!=""){J.lp=1f.1k("Db")}if(J.lp<=0||J.lp==""){J.lp=3}K B1=1f.1k("g9");if(B1!=""){7n{K g9=63(B1);if(g9>0){J.g9=g9}}7p(e){}}$("#qb-ui-3Z-1g-4p-29").4N("w8",me.GM,me);$("#qb-ui-3Z-1g-4p-29").4N("7V",me.F6,me);$("#qb-ui-3Z-1g-4p-a0").4N("3J",me.Fr,me);1a cv(1f){K FC=1f.id.71("qb-ui-3Z-1g-".1e);K 1g=me.du[FC];me.3Z.2c(QB.1d.7e.2l.s6,1g)}$(2N).on("vG","#qb-ui-3Z-1F .qb-ui-1D 2F",1a(e){if($(e.8b).4E("2j")){1b 1j}cv(e.8b.3n)});$(2N).on("7V","#qb-ui-3Z-1F .qb-ui-1D 2F",1a(e){if(e.3F==13){cv(e.8b.3n)}});J.FD();J.3Z=1f;1b 1f};J.FN=$.gQ(J.s5,kO,J);1b J.3Z};QB.1d.7e.2l={FZ:"FZ",s6:"s6"};QB.1d.wl=1a(2j,5S,s4,1x){K me=J;J.gs=1R.gr.g8;J.1D=2j;J.1M=s4;J.1L=5S;J.3B=2j.eJ;J.1f=$(\'<tr 69="-1" />\').2t("qb-ui-1M-2j 8L").1h("J",J).1h("1D",2j).1h("1M",s4).1h("f5",2j.3f).1h("1L",5S).1h("tu",5S.3f);3M.vB(J.1f,QB.1d.2d.5b.5r.g8+" "+2j.88);if(2j.88=="*"){J.1f.2t("qb-ui-1M-2j-gh")}J.rY=$(\'<29 1w="7O" 1m="1" 69="-1" \'+(2j.eJ?" 3B":"")+"/>").3J(1a(){me.3B=J.3B;s4.sG([me])});J.1f.7V(1a(e){3r(e.3F){1l 13:;1l 32:me.rY.2c("3J");e.4h()}});J.Ak=$(\'<2F 2B="qb-ui-1M-2j-3K"></2F>\');if(2j.oa){J.Ak.2t("qb-ui-1M-2j-3K-pk")}K kQ=1x.BN;K kS=1x.Cb;K Bw=1x.C2;K rH=1x.sh;K rJ=1x.o6;J.Ho=$(\'<2F 2B="qb-ui-1M-2j-2o">\'+kQ.bl+"</2F>").2t(QB.1d.2f.s8?"7d":"").3a(J.rY);J.9y=$(\'<2F 2B="qb-ui-1M-2j-1z">\'+kS.bl+2r(2j.rS)+kS.cG+"</2F>").2t(QB.1d.2f.s7?"7d":"");J.H5=$(\'<2F 2B="qb-ui-1M-2j-1w">\'+(2j.88!="*"&&2j.AT!="1c"?rH.bl+2j.AT+1x.sh.cG:"")+"</2F>").2t(QB.1d.2f.sl?"7d":"");J.Hp=$(\'<2F 2B="qb-ui-1M-2j-Fb">\'+kQ.bl+(rJ.rU?2j.wd:2r(2j.we))+1x.o6.cG+"</2F>").2t(QB.1d.2f.rM?"7d":"");K 5O=[];5O.1C({2Z:J.Ak,87:-1,7y:1n});5O.1C({2Z:J.Ho,87:kQ.87,7y:kQ.7y});5O.1C({2Z:J.9y,87:kS.87,7y:kS.7y});5O.1C({2Z:J.H5,87:rH.87,7y:rH.7y});5O.1C({2Z:J.Hp,87:rJ.87,7y:rJ.7y});5O.rV("87");K 7v;if(Bw){7v=me.1f}1i{7v=$("<td Yr />");7v.4r(me.1f)}1o(K i=0;i<5O.1e;i++){K 7D=5O[i];if(Bw){7v.3a($("<td td"+(i+1)+\'" />\').3a(7D.2Z))}1i{7v.3a(7D.2Z)}}J.fd=1a(1m){J.3B=1m;J.rY[0].3B=J.3B};J.6F=1a(){K 51={x:0,y:0,1r:0,1y:0};K o=J.1f;K Bp=fm(QB.1d.2f.1V[0]);K fl=fm(o,Bp);K 1L=o;do{if(1L.6c.8w()=="HA"){1L=1L.3n;if(1L){1L=1L.3n}1p}1L=1L.3n}45(1L!=1c);K fq=fl;if(1L!=1c){fq=fm(1L,Bp)}if(fl.1O<fq.1O){51.y=fq.1O}1i{if(fl.1O>fq.4I-fl.1y/2){51.y=fq.4I-fl.1y/2}1i{51.y=fl.1O}}51.1y=fl.1y;51.1r=fq.1r;51.x=fq.2a;1b 51}};QB.1d.wl.2l={HB:"HB"};K Av=20;QB.1d.9F=1a(){J.2Z=$("#qb-ui-1V-dO");J.1T=1c;K gD=J;K gf=J.2Z;K iG=0;K lG=0;K iR=0;J.Ee=1a(9E){if(J.2Z.1k("Gy")&&J.2Z.1k("Gy").3N()=="1j"){1b}K $49=$("#qb-ui-1V-dO-9t");if(!$49){1b}K $9u=[];1o(K i=0;i<9E.2P.1e;i++){K 1g=9E.2P[i];K 1Y=1g.9Q;if(1K(1Y)){1Y="&2r;"}K $1f=$(\'<2E 2B="2Z" id="qb-ui-1V-dO-9t\'+(i+1)+\'">\'+1Y+"</2E>").2t(1g.hw);$1f.3C();if(1g.dp){$1f.2t("ui-4Z-b4");$1f.1k("69",-1)}1i{$1f.1k("69",0);$1f.7V(1a(e){if(e.3F==32||e.3F==13){$(e.3k).2c("3J")}})}$1f.1h("1g",1g);$1f.3J(1a(e){K $1f=$(e.8b);if($1f.1h("Gh.fp")){1b}K 1g=$1f.1h("1g");if(1g&&1g.cu){QB.1d.5I.rX(1g.cu)}1i{$("#"+$1f[0].id).2L()}if(1g&&1g.dp){$1f.2t("ui-4Z-b4");e.4h();1b 1j}});$1f.6y(1a(e){K $1f=$(e.8b);K 1g=$1f.1h("1g");if(1g&&1g.dp){$1f.2t("ui-4Z-b4");e.4h();1b 1j}});$1f.4O(1a(e){K $1f=$(e.8b);K 1g=$1f.1h("1g");if(1g&&1g.dp){$1f.2t("ui-4Z-b4");e.4h();1b 1j}});$1f.nk();J.Jk($1f,1g.fK);$9u.1C($1f)}$49.cI();$gf=$(\'<2E id="qb-ui-1V-dO-9t-gf">\');$gf.4r($49).3a($9u)};1a u4(8m,4K){if(8m<0){8m=0}1i{if(8m>iR){8m=iR}}Gg(8m)}1a Gg(8m){if(8m===2O){8m=Y2.2J().2a}Au=8m;K Y3=Au===0,Y4=Au==iR,j0=8m/iR,Dq=-j0*(iG-lG);gf.31("2a",Dq)}1a tN(){1b-gf.2J().2a}1a Yy(kY,l0,bA){1b 1a(){DG(kY,l0,J,bA);J.4O();1b 1j}}1a DG(kY,l0,ag,bA){ag=$(ag).2t("Ne");K 2R,lX,Bn=1n,Bh=1a(){if(kY!==0){gD.wu(kY*30)}if(l0!==0){gD.wv(l0*30)}lX=6x(Bh,Bn?t9:50);Bn=1j};Bh();2R=bA?"ea.gD":"5u.gD";bA=bA||$("3X");bA.2C(2R,1a(){ag.4f("Ne");lX&&k1(lX);lX=1c;bA.7Y(2R)})}J.Bx=1a(6U){if(6U==1c||6U.1e==0){1b 1c}K 1F={};K 4R;1o(K i=0;i<6U.1e;i++){4R=6U[i];K 1q=4R.ck;if(4R.3T!=1c&&4R.3T.71(0,1)=="-"){1F[1q]=4R.3T}1i{1F[1q]={1z:4R.3T,3K:1q+(4R.BH?" 3B":""),1F:J.Bx(4R.2P),1h:4R}}}1b 1F};J.Jk=1a($1f,1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.Bx(1T.2P);K 3S="#"+$1f[0].id;$.2L("6d",3S);$.2L({3S:3S,4o:cf,6O:{6S:0},1F:1F,1Z:1a(47,1x){K 4R=1x.1F[47].1h;me.ty(47,4R)}});$.2L.k4.Vj=1a(1g,1B,2p){J.on("7V",1a(e){})}};J.ty=1a(1q,1g){K 47=1c;if(1g!=1c&&2K 1g.cu!="2O"){47=1g.cu}J.2Z.2c(QB.1d.9F.2l.sv,47)};J.AA=1a(s){if(s==1c){1b s}if(s.1e<=Av){1b s}1b s.71(0,Av)+"&UO;"};J.If=1a(1L){K 1F=[];$.2h(1L.2P,1a(1P,1g){if(!1g.7y){1b}if(1g.dp){1b}1F.1C(1g)});1b 1F};J.Ig=1a(1L){K e3=1c;$.2h(1L.2P,1a(1P,1g){if(1g.dp){e3=1g}});1b e3};J.AS=1a($3C){$3C.1k("69",0);$3C.7V(1a(e){if(e.3F==32||e.3F==13){$(e.3k).2c("3J")}})};J.AK=1a(1g,2x){K me=J;K 3K="ui-3K-qb-"+1g.68;K $3C=$(\'<2E 2B="fI">\'+J.AA(1g.6A)+"</2E>").1h("vO",1g.3f).1h("dU",1g.dU).3C({2x:2x,bJ:{uj:3K}}).3J(1a(e){me.AL(e)});if(2x){$3C.2t("ui-4Z-b4").2t("ui-4Z-6y")}1i{J.AS($3C)}1b $3C};J.Kl=1a(1F){K me=J;K $ul=$("<ul/>");$.2h(1F,1a(1P,gC){K 3K="ui-3K-qb-"+gC.68;K $3C=$(\'<li><a 5c="#"><2F 2B="ui-3K \'+3K+\'"></2F>\'+me.AA(gC.6A)+"</a></li>").1h("vO",gC.3f).1h("dU",gC.dU);$ul.3a($3C)});$ul.1T({2o:1a(e,ui){$ul.3L();me.AL(e)}});1b $ul};J.Ca=1a(1g,1L){K me=J;K 9t=[];if(1g==1c){1b 9t}K 1F=J.If(1g);K e3=J.Ig(1g);K Io=e3===1c;K $3C=J.AK(1g,Io);9t.1C($3C);if(1F.1e>0){if(e3!=1c){K $AZ=$("<2E>&2r;</2E>").3C({1Y:1j,bJ:{uj:"ui-3K-i4-1-s"}}).3J(1a(e){if(me.1T!=1c){me.1T.3L()}me.1T=$(J).3m().59().2J({my:"2a 1O",at:"2a 4I",of:$(J).V1(".ui-3C")[0]});$(2N).Kq("3J",1a(){me.1T.3L()});1b 1j});J.AS($AZ);9t.1C($AZ);K $ul=J.Kl(1F);9t.1C($ul)}1i{$3C.3C("2Q","bJ.vQ","ui-3K-i4-1-e");$.2h(1F,1a(1P,gC){9t.1C(me.AK(gC))})}}1i{if(e3!=1c){$3C.3C("2Q","bJ.vQ","ui-3K-i4-1-e")}}if(e3!=1c){9t=9t.3x(J.Ca(e3,1g))}1b 9t};J.AL=1a(e){K $1f=$(e.8b);K 9e=$1f.1h("dU");if(!1K(9e)){J.2Z.2c(QB.1d.9F.2l.rG,9e)}1b 1j};J.E8=1a(cC){K me=J;K $2Z=$("#qb-ui-1V-dO-V3-49");if(cC!=1c&&cC.2P!=1c){$2Z.cI();K $1F=me.Ca(cC);$2Z.3a($1F);K KX=$("<2E id=\'qb-ui-1V-fI-lJ-3C\'>+</2E>").3C();$2Z.3a(KX);$2Z.UV({1F:"3C, 29[1w=3C], 29[1w=V4], 29[1w=lU], 29[1w=7O], 29[1w=8x], :1h(ui-3C)"});$2Z.2D("ul").1k("69",-1);$2Z.2D("a").1k("69",0)}1b $2Z};$.4l(J,{Vf:1a(s){s=$.4l({},3W,s);Ve(s)},JP:1a(bA,JV,4K){JP(bA,JV,4K)},V8:1a(8m,iY,4K){uf(8m,4K);tU(iY,4K)},uf:1a(8m,4K){uf(8m,4K)},tU:1a(iY,4K){tU(iY,4K)},V6:1a(Kb,4K){uf(Kb*(iG-lG),4K)},W1:1a(KN,4K){tU(KN*(tI-vI),4K)},wm:1a(m5,m9,4K){gD.wu(m5,4K);gD.wv(m9,4K)},wu:1a(m5,4K){K 8m=tN()+3D[m5<0?"gF":"j5"](m5);K j0=8m/(iG-lG);u4(j0*iR,4K)},wv:1a(m9,4K){K iY=vK()+3D[m9<0?"gF":"j5"](m9),j0=iY/(tI-vI);ua(j0*Kv,4K)},u4:1a(x,4K){u4(x,4K)},ua:1a(y,4K){ua(y,4K)},4K:1a(bA,6T,1m,L0){K 1v={};1v[6T]=1m;bA.4K(1v,{"6S":3W.Wa,"5E":3W.Wl,"ir":1j,"lD":L0})},Wk:1a(){1b tN()},Wp:1a(){1b vK()},Wq:1a(){1b iG},Wo:1a(){1b tI},We:1a(){1b tN()/(iG-lG)},Wh:1a(){1b vK()/(tI-vI)},Wg:1a(){1b VT},Vw:1a(){1b Vx},Vy:1a(){1b gf},Vo:1a(4K){ua(Kv,4K)},Vp:$.vR,6d:1a(){6d()}});1b J};QB.1d.lW=1a(){J.3Z=1c;J.lN=1j;J.vS=1a(lM){if(lM==1c||lM.1e<=0){1b 1c}K vV=0;K $1f=$("<ul />");1o(K i=0;i<lM.1e;i++){K 1s=lM[i];if(!1s.7y){ah}vV++;K $li=$("<li />");$li.1h("vO",1s.3f);$li.1h("dU",1s.dU);$li.3X(\'<2F 2B="\'+1s.68+(1s.dp?" b4":"")+\'">\'+1s.6A+"</2F>");$li.3a(J.vS(1s.2P));$1f.3a($li)}if(vV>0){1b $1f}1b 1c};J.wk=1a(cC){K me=J;K 2Z=$("#qb-ui-3Z-vN");if(cC!=1c&&cC.2P!=1c){2Z.3X("");2Z.3a(me.vS([cC]));K 1f=$("#qb-ui-3Z-vN>ul");J.3Z=1f.hT({});1f.2D("*").wC();$("#qb-ui-3Z-vN 2F").3J(1a(){K $1f=1c;K 9e=1c;if(J.ie!=1c){$1f=$(J.ie);9e=$1f.1h("dU")}if(!1K(9e)){me.3Z.2c(QB.1d.lW.2l.rZ,9e)}1b 1j})}1b 2Z};J.vP=1a(){K me=J;$(".4n",J.3Z).3J(1a(e){})};$("#qb-ui-1V-dO-lJ-3C").3C({bJ:{vQ:"ui-3K-i4-1-s"}});1b J.3Z};QB.1d.lW.2l={rZ:"rZ"};QB.1d.9F.2l={rG:"rG",sv:"sv"};K gy=1c;QB.1d.78={4s:1c,1x:{VP:"<2M 2B=\'qb-ui-1M-bd-1Y-lL-1z\'>{lL}</2M>.<2M 2B=\'qb-ui-1M-bd-1Y-1M-1z\'>{1z}</2M>",rI:1n,eu:1j,Ja:"",6P:1n,3L:1c,1y:"6l",1r:"6l",6m:5,c3:60,9i:1j,fL:1j,6K:1n,2J:{my:"2a 1O",at:"2a+15 1O+15",of:"#qb-ui-1V",lK:"3p",VG:1a(3V){K w9=$(J).31(3V).2y().1O;if(w9<0){$(J).31("1O",3V.1O-w9)}}},5K:1n,59:1c,VD:1n,61:"",4o:8W,eA:VE,cn:"6l"},VH:{vo:"2I.6P",5k:"5k.6P",vm:"5B.6P",9i:"9i.5K",6m:"6m.5K",fL:"fL.5K",c3:"c3.5K",Mm:"2I.5K",79:"5k.5K",Mo:"5B.5K"},7v:1c,bw:1c,IC:"qb-ui-1M "+"ui-8M "+"ui-8M-a8 "+"ui-9Z-6o ",bn:1j,jG:1a(47){K me=J;if(me.4s!=1c&&me.4s.6J){1b 1j}3r(47){1l"fd":me.uy(1n);1p;1l"SN":me.uy(1j);1p;1l"42":me.5s();1p;1l"eL":K 3j=me.os(me);if(3j!=1c){3j.3j("6Q")}1p}},I3:1a(){K me=J;K 5t=".bd-3C.3C-1W";$.2L("6d",5t);K 1F={};K cB=1c;1o(K i=0;i<me.4s.kF.1e;i++){K ez=me.4s.kF[i];if(cB==1c){cB=ez.kM}if(cB!=ez.kM){1F["5n-"+i]="---------";cB=ez.kM}1F[ez.6A]={1z:ez.6A,3K:"SC-1D-cB-"+ez.kM,1h:ez,bO:ez.sq?"sg":""}}$.2L({3S:5t,4o:cf,6O:{6S:0},1Z:1a(47,1x){K I4=1x.$1Q.1h().2L.1F[47];me.1f.2c(QB.1d.78.2l.kD,I4.1h)},1F:1F});1b 5t},Jj:1a(3C){K me=J;K 5t=".bd-3C.3C-1W";if(me.4s==1c){1b}3C.7f(1a(){me.I3();$(5t).2L();K $1T=$(5t).2L("1f");if($1T){$1T.2J({my:"2a 1O",at:"2a 4I",of:J})}})},8L:".8L:6K",J8:".8L:6K:4x",Jc:".8L:6K:73",tg:1a(7Q){K me=J;J.4s=me.1x.1D;J.ex=1j;if(!J.5h){J.5h=[]}K 5S=J.4s;if(J.4s!=1c&&!1K(J.4s.66)){J.66=J.4s.66}1i{J.66=BZ()}5S.66=J.66;$(me.1f).1h("4s",5S);$(me.1f).1h("me",J);me.1f.2t(J.IC+me.1x.Ja).31({2J:"8t",4o:me.1x.4o});me.1f.1k("69",0);if(!7Q){me.1f.2S(1a(e){me.bn=1j})}1a eM(2S){K 1J=1c;if(2S.4E("qb-ui-1M")){1J=2S}1i{1J=2S.3m()}45(1n){if(1J.1e==0){1p}if(1J.is(me.8L)){1b 1J}K 8y=1J.2D(me.J8);if(8y.1e){1b 8y}1J=1J.3m()}K 1L=2S.1L();if(1L.4E("qb-ui-1M")){1b $()}1b eM(1L)}1a dK(2S){K 1J=1c;if(2S.4E("qb-ui-1M")){1J=2S}1i{1J=2S.3P()}45(1n){if(1J.1e==0){1p}if(1J.is(me.8L)){1b 1J}K 8y=1J.2D(me.Jc);if(8y.1e){1b 8y}1J=1J.3P()}K 1L=2S.1L();if(1L.4E("qb-ui-1M")){1b $()}1b dK(1L)}if(!7Q){me.1f.7V(1a(e){3r(e.3F){1l 13:if(me.bn){1b}me.bn=1n;eM(me.1f).2S();e.4h();1p;1l 9:if(!me.bn){1b}K 2S=me.1f.2D(":2S");if(!2S.1e){2S=me.1f}K 1f=1c;if(e.nc){1f=dK(2S)}1i{1f=eM(2S)}if(1f.1e){1f.2S();e.4h();1b 1j}1i{me.bn=1j}}})}J.6a=me.1f;if(me.1x.8X){me.1x.2J.at="2a+"+me.1x.8X[0]+" 1O+"+me.1x.8X[1];me.2J.2y=me.1x.2J.2y;me.mg(me.2J);me.1x.8X=1c}if(J.jo==1c){J.jo=$(\'<2F 2B="qb-ui-1M-bd-1Y"></2F>\')}K 61=J.Nh();3M.vB(me.1f,QB.1d.2d.5b.5r.jb+" "+61);J.jo.3X(61);if(J.dF==1c){J.sj=[];if(!1K(J.4s)&&!1K(J.4s.vH)){J.jo.2t("SF");J.sj=J.ov("fI","ui-3K-fI-sm").1k("5w-3y","").1k("5w-3y","SQ to fI");J.sj.3J(1a(1H){me.1f.2c(QB.1d.78.2l.kz,me.4s.vH);1b 1j})}J.kB=J.ov("1W","ui-3K-1W-sm").1k("5w-3y","").1k("5w-3y","T1 T0");J.wD=J.ov("eL","ui-3K-eL-sm").1k("5w-3y",QB.1d.2d.5b.5r.iT);J.wa=J.ov("5s","ui-3K-5s-sm").1k("5w-3y","").1k("5w-3y","vL");J.dF=$(\'<2E 2B="qb-ui-1M-bd ui-8M-8a ui-9Z-6o ui-4w-T6 6v-1M"></2E>\').3a(J.sj).3a(J.jo).3a(J.kB).3a(J.wD).3a(J.wa).2C("vG",1a(){me.J1()});J.dF.4r(me.1f).2t("qb-ui-1M-2j-61");J.dF.1h("gm",1j);J.wa.3J(1a(1H){me.5s(1H);1b 1j});J.wD.3J(1a(1H){if(me.4s!=1c&&me.4s.6J){1b 1j}K 3j=me.os(me);if(3j!=1c){3j.3j("6Q")}1b 1j});J.Jj(J.kB)}if(J.4s!=1c&&J.4s.6J){J.dF.2D(".3C-eL").3L();J.dF.2D(".3C-1W").3L()}1i{J.dF.2D(".3C-eL").59();J.dF.2D(".3C-1W").59()}if(!QB.1d.5I.sH&&(5S!=1c&&(5S.kF!=1c&&5S.kF.1e>0))){J.kB.59()}1i{J.kB.3L()}K gp=1n;if(7Q){if(5S&&5S.5A){if(J.5h.1e==5S.5A.1e+1){7n{if(J.5h.1e>1&&5S.5A.1e>1){K ko=J.5h[1].1D;K ox=5S.5A[1];if(ko.3f==ox.3f){gp=1j}1i{gp=1n}}}7p(e){gp=1n}gp=1j}1i{gp=1n}}}if(gp){if(me.bw!=1c){me.bw.3u()}me.bw=$(\'<2E 2B="qb-ui-1M-2j-49 ui-3j-a8 ui-8M-a8"></2E>\').oq(1a(){QB.1d.2f.fj()}).1k("69",-1);me.7v=me.bw;me.nP=$(\'<1M t4="1" t8="0"></1M>\').4r(me.bw);if(5S&&5S.5A){J.Nd(5S,me.nP)}me.bw.4r(me.1f);me.bw.nk()}if(J.4s.6J){me.bw.2t("rK")}1i{me.bw.4f("rK")}me.gl=me.1f.1y()-me.7v.1y();me.1x.6m=3D.4y(me.1x.6m,me.gl);me.2Q.9i=1j;$(".qb-ui-1M-2j:Ji",me.nP).2t("Ji");me.1x.6P&&($.fn.6P&&J.zc());me.1x.5K&&($.fn.5K&&J.zf());J.oo=1j;me.1x.eu&&($.fn.eu&&me.7v.eu());me.1x.eu&&($.fn.eu&&me.1f.eu());me.IQ();me.2Q.9i=1j;me.1x.rI&&J.6Q();J.gs=1R.gr.cb;me.1f.1h("Jh",me);me.1f.1h("1D",5S);me.1f.1h("f5",5S.3f);me.1f.2D("*").wC();me.1f.7f(1a(1H){me.vf(1j,1H)});J.J1=1a(){if(me.1f.1h("gm")){me.1f.1h("gm",1j);me.gm=1j;me.2Q("1y",J.IL)}1i{me.1f.1h("gm",1n);me.gm=1n;J.IL=J.2Q("1y");me.2Q("1y",16)}QB.1d.2f.dq();1b 1j};K 5h=$(".qb-ui-1M-2j",me.1f).4p(":5X(.qb-ui-1M-2j-gh)");if(!QB.1d.2f.rO&&!QB.1d.2f.kL){5h.6P({4w:1a(1H){K 3k=1H.3k;K tr=1c;if(3k.6c.8w()=="TR"){tr=$(3k).5R()}1i{K 1L=3k;do{if(1L.6c.8w()=="TR"){1p}1L=1L.3n}45(1L!=1c);if(1L){tr=$(1L).5R()}}K 4w=$(\'<1M 2B="qb-ui-1M ui-8M ui-8M-a8 qb-ui-6P-4w-2j" t8="0" t4="0"></1M>\').3a(tr);gy=4w;1b 4w},4r:"#qb-ui-1V",2G:0.8,2I:1a(1H,ui){me.1f.1h("wy",1n);K 4w=$(ui.4w);K kp=$(J);ui.4w.1r($(J).1r());QB.1d.2f.72.3u(jq);jq=1S QB.1d.2f.bR({4W:{2j:{1f:kp},1M:me},4V:{2j:{1f:4w}}});QB.1d.2f.72.1C(jq);J.ex=1j},5B:1a(1H,ui){QB.1d.2f.72.3u(jq);QB.1d.2f.dq();me.1f.1h("wy",1j);gy=1c},5k:1a(1H,ui){QB.1d.2f.fj()}}).bU({Ae:".qb-ui-1M-2j",t7:"qb-ui-1M-2j-sg",dl:"wF",Ad:1a(1H,ui){if(me.4s.6J){1b 1j}K ko=$(ui.6P);K ox=$(J);K 1W=QB.1d.2f.72.s3({6J:1n,4W:{cr:ko.1h("tu"),aV:ko.1h("f5")},4V:{cr:ox.1h("tu"),aV:ox.1h("f5")}});QB.1d.2f.dq();K 1N=1W.1N();me.1f.2c(QB.1d.78.2l.kA,1N);me.1f.1h("wy",1j);me.ex=1j},iM:1a(1H,ui){if(me.4s.6J){$(ui.4w).2t("rK")}1i{$(ui.4w).4f("rK")}}})}},os:1a(3l){K bc="#1M-eL-3j";if(1K(QB.1d.5I.dS[bc])){K $go=$(bc);if($go.1e){K 8J={};8J[" OK "]=1a(){K 4s=$(J).1h("4s");4s.8n=$("29[1z=1D-b0]",$(J)).cK();4s.4J=$("29[1z=1D-1z]",$(J)).cK();$(J).3j("5s");QB.1d.2m.II(4s);QB.1d.2m.5Y()};8J[QB.1d.2d.5b.IG.ey]=1a(){$(J).3j("5s")};QB.1d.5I.dS[bc]=$go.3j({5K:1j,4o:rF,fL:wB,rI:1j,1r:ol,wO:1n,6Q:1a(e,ui){K 4s=$(J).1h("4s");$("29[1z=1D-1z]",$(J)).2g(4s.4J);$("29[1z=1D-1z]").1k("SS",4s.IY);$("29[1z=1D-b0]",$(J)).2g(4s.8n)},8J:8J})}}if(!1K(QB.1d.5I.dS[bc])){QB.1d.5I.dS[bc].1h("4s",3l.4s)}1b QB.1d.5I.dS[bc]},IQ:1a(){if(J.1f.1y()>J.1x.eA){J.2Q("1y",J.1x.eA)}if(J.1f.1r()>J.1x.cn){J.2Q("1r",J.1x.cn)}K Nm=40;K a8=J.nP;K wQ=J.1f;K 61=J.dF;K N5=J.jo;K wL=a8.aS();K Nk=wQ.aS();K Ni=61.aS();K nY=a8.1r();K N2=wQ.eB();K wM=61.eB();K SY=N5.1r();if(wL==0&&nY==0){1b}K N4=nY>N2-wM;if(N4){nY+=16}K 1r=3D.4y(wM,nY);if(!1K(J.1x.cn)&&J.1x.cn!="6l"){1r=J.1x.cn}K Nl=wL+Ni;K 1y=3D.5Q(Nk,J.1x.eA);if(1r>Nm){J.2Q("1r",63(1r));J.nP.1r("100%")}if(1y>0){J.2Q("1y",1y);J.2Q("9i",Nl)}},Nh:1a(){if(!1K(J.4s.6A)){1b J.4s.6A.3g(/ /g,"&2r;")}1i{1b""}},Nd:1a(5S,bw){K me=J;K 1x=5S.ww;if(1K(1x)){1x={}}K 5h=[];if(!1x.wh){K gh=1S QB.1d.2d.Ng;gh.88="*";gh.rS="*";gh.eJ=5S.MZ;5h.1C(gh)}K oa=1x.wj?"MJ":"";3r(1x.dV){1l QB.1d.2U.wc.3T:5S.5A.rV(oa,"88");1p;1l QB.1d.2U.wc.rT:5S.5A.rV(oa,1x.o6.rU?"wd":"we");1p}me.5h=[];5h=5h.3x(5S.5A);$.2h(5h,1a(1q,2j){K f=1S QB.1d.wl(2j,5S,me,1x);me.5h.1C(f);bw.3a(f.1f)})},ov:1a(dg,tc){1b $(\'<a 5c="#"></a>\').2t("ui-9Z-6o bd-3C 3C-"+dg+" 8L").6y(1a(){$(J).2t("ui-4Z-6y")},1a(){$(J).4f("ui-4Z-6y")}).7f(1a(ev){ev.7X()}).3a($("<2F/>").2t("ui-3K "+tc)).1k("69",-1)},S5:1a(){if(!J.wp){J.wp=$("#qb-ui-3R")}1b J.wp},6F:1a(){1b{x:J.2y().2a,y:J.2y().1O,1r:J.1r(),1y:J.1y()}},7Q:1a(1h){if(!1K(gy)){gy.2c("5u")}K me=J;K 1u=1h.1D;me.1f.1h("f5",1u.3f);$(".qb-ui-1M-2j",me.1f).2h(1a(){K 2j=$(J);2j.1h("tu",1u.3f);K 7j=1c;$.2h(1u.5A,1a(1q,uC){if(fW(uC.88,2j.1h("1D").88)){7j=uC.3f;1b 1j}});2j.1h("f5",7j)});J.1f.2c(QB.1d.78.2l.zt)},MS:1a(1x){if(!1K(gy)){gy.2c("5u")}J.1x=$.4l(J.1x,1x);K NL=J.1f.1r();K NM=J.7v.1y();K NR=J.5h.1e;K uO=0;if(1x!=1c&&(1x.1D!=1c&&1x.1D.5A!=1c)){uO=1x.1D.5A.1e+1}K uN=uO!=NR;if(uN){J.1x.1y="6l";J.1x.1r="6l"}K oq=J.7v.58();J.tg(1n);if(!uN){J.1f.1r(NL);J.7v.1y(NM)}J.7v.58(oq)},6d:1a(){K me=J;J.1f.2c(QB.1d.78.2l.sW);me.1f.3X("").3L().7Y(".6j").tm("6j").4r("3U").6w().3u()},5s:1a(1H,tl){K me=J;if(!tl){me.1f.2c(QB.1d.78.2l.sY)}if(1j===me.7w("Mt",1H)){1b}me.1f.7Y("gN.qb-ui-1M");me.1f.3L()&&me.7w("5s",1H);me.oo=1j;me.6d()},ib:1a(){1b J.oo},vf:1a(fa,1H){K me=J;if(J.1x.4o>$.ui.6j.mv){$.ui.6j.mv=J.1x.4o}K Nt={58:me.1f.1k("58"),4S:me.1f.1k("4S")};me.1f.31("z-1P",++$.ui.6j.mv).1k(Nt);J.7w("2S",1H)},sG:1a(5h){J.1f.2c(QB.1d.78.2l.kt,{5h:5h})},uy:1a(3B){K me=J;K 5h=J.5h;K e9=[];$.2h(5h,1a(){K 2j=J;if(2j.1D.88!="*"&&J.3B!=3B){J.fd(3B);e9.1C(J)}});me.sG(e9)},iJ:1a(9y,3B,tj){K me=J;K 5h=J.5h;K uR=[];$.2h(5h,1a(1P,2j){if(2j.1D.88==9y){$(".qb-ui-1M-2j-2o 29",2j.1f).2h(1a(){if(J.3B!=3B){J.3B=3B;2j.3B=3B;uR.1C(2j)}})}});if(tj){me.sG(uR)}},6Q:1a(){if(J.oo){1b}K 1x=J.1x;J.zb();J.mg(1x.2J);J.vf(1n);J.7w("6Q");J.oo=1n},S6:1a(){K 65=J,1x=J.1x;1a bD(ui){1b{2J:ui.2J,2y:ui.2y}}J.6a.6P({iA:".ui-3j-a8, .ui-3j-bd-5s",4M:".qb-ui-1M-bd",85:"2N",2I:1a(1H,ui){$(J).2t("ui-3j-sJ");65.sN();65.7w("vo",1H,bD(ui))},5k:1a(1H,ui){65.7w("5k",1H,bD(ui))},5B:1a(1H,ui){1x.2J=[ui.2J.2a-65.2N.4S(),ui.2J.1O-65.2N.58()];$(J).4f("ui-3j-sJ");65.zi();65.7w("vm",1H,bD(ui))}})},zc:1a(){K me=J;K 2Y=$(2N),vj;1a bD(ui){1b{2J:ui.2J,2y:ui.2y}}me.6a.6P({S7:1j,Ej:1j,iA:".ui-3j-a8, .ui-3j-bd-5s",4M:".qb-ui-1M-bd",85:"1L",oq:1n,2I:1a(1H,ui){K c=$(J);vj=me.1x.1y==="6l"?"6l":c.1y();c.1y(c.1y()).2t("ui-3j-sJ");if($.ui.gB.5C!=1c&&($.ui.gB.5C.85!=1c&&$.ui.gB.5C.85.1e>3)){$.ui.gB.5C.85[2]=sL;$.ui.gB.5C.85[3]=sL}me.sN();me.7w("vo",1H,bD(ui))},5k:1a(1H,ui){QB.1d.2f.fj();me.7w("5k",1H,bD(ui))},5B:1a(1H,ui){QB.1d.2f.79();QB.1d.2f.dq();me.1x.2J.at="2a+"+(ui.2J.2a-2Y.4S())+" 1O+"+(ui.2J.1O-2Y.58());$(J).4f("ui-3j-sJ").1y(vj);me.1f.2c(QB.1d.78.2l.sU,me);QB.1d.2m.hn();me.zi();me.7w("vm",1H,bD(ui))}})},Sv:1a(){K ce,co,iM,o=J.1x;if(o.85==="1L"){o.85=J.4w[0].3n}if(o.85==="2N"||o.85==="3Q"){J.85=[0-J.2y.mM.2a-J.2y.1L.2a,0-J.2y.mM.1O-J.2y.1L.1O,$(o.85==="2N"?2N:3Q).1r()-J.Lq.1r-J.sE.2a,($(o.85==="2N"?2N:3Q).1y()||2N.3U.3n.sz)-J.Lq.1y-J.sE.1O]}if(!/^(2N|3Q|1L)$/.9V(o.85)){ce=$(o.85)[0];co=$(o.85).2y();iM=$(ce).31("ga")!=="7d";J.85=[co.2a+(6p($(ce).31("uT"),10)||0)+(6p($(ce).31("Sj"),10)||0)-J.sE.2a,co.1O+(6p($(ce).31("uV"),10)||0)+(6p($(ce).31("Sn"),10)||0)-J.sE.1O,sL,sL]}},zf:1a(fu){fu=fu===2O?J.1x.5K:fu;K me=J,1x=me.1x,2J=me.6a.31("2J"),Lg=2K fu==="4e"?fu:"n,e,s,w,se,sw,ne,nw";1a bD(ui){1b{Le:ui.Le,Lf:ui.Lf,2J:ui.2J,56:ui.56}}me.6a.5K({iA:".ui-3j-a8",85:"2N",Ud:me.7v,9i:63(1x.9i),c3:1x.c3,6m:me.mq(),fu:Lg,2I:1a(1H,ui){$(J).2t("ui-3j-Mp");me.sN();me.7w("Mm",1H,bD(ui))},79:1a(1H,ui){me.7w("79",1H,bD(ui));QB.1d.2f.sM();QB.1d.2f.fj()},5B:1a(1H,ui){$(J).4f("ui-3j-Mp");1x.1y=$(J).1y();1x.1r=$(J).1r();me.7w("Mo",1H,bD(ui));me.1f.2c(QB.1d.78.2l.sU,me);QB.1d.2m.hn()}}).31("2J",2J).2D(".ui-5K-se").2t("ui-3K ui-3K-Ue-Ub-se")},mq:1a(){K 1x=J.1x;K 1y=J.gl;if(1x.1y==="6l"){if(!aa(1x.6m)){1y=3D.4y(1y,1x.6m)}}1i{K h=0;if(!aa(1x.6m)){h=1x.6m}if(!aa(1x.1y)){1y=3D.5Q(h,1x.1y)}1y=3D.4y(1y,h)}1b 1y},2J:1a(3V){J.mg(3V)},mg:1a(3V){if(!J.1x.6K){1b}if(!$("#qb-ui-1V").is(":6K")){1b}K eh=[],2y=[0,0];if(3V){if(2K 3V==="4e"||2K 3V==="1D"&&"0"in 3V){eh=3V.3q?3V.3q(" "):[3V[0],3V[1]];if(eh.1e===1){eh[1]=eh[0]}$.2h(["2a","1O"],1a(i,Mr){if(+eh[i]===eh[i]){2y[i]=eh[i];eh[i]=Mr}});3V={my:"2a 1O",of:"#qb-ui-1V",at:"2a+"+2y[0]+" 1O+"+2y[1]}}3V=$.4l({},J.1x.2J,3V)}1i{3V=J.1x.2J}J.1x.2J=3V;if(J.1x.6K&&(J.1x.2J.of==1c||$(J.1x.2J.of).1e>0)){J.6a.59();3V.of="#qb-ui-1V";J.6a.2J(3V)}},mz:1a(1q,1m){K me=J,6a=me.6a,fr=6a.is(":1h(ui-5K)"),79=1j;3r(1q){1l"Mt":1q="U4";1p;1l"8J":me.Tj(1m);79=1n;1p;1l"Tg":me.Th.1Y(""+1m);1p;1l"LT":6a.4f(me.1x.LT).2t(Tn+1m);1p;1l"2x":if(1m){6a.2t("ui-3j-2x")}1i{6a.4f("ui-3j-2x")}1p;1l"6P":if(1m){me.zc()}1i{6a.6P("6d")}1p;1l"1y":79=1n;1p;1l"9i":if(fr){6a.5K("2Q","9i",1m)}79=1n;1p;1l"fL":if(fr){6a.5K("2Q","fL",1m)}79=1n;1p;1l"6m":if(fr){6a.5K("2Q","6m",1m)}79=1n;1p;1l"c3":if(fr){6a.5K("2Q","c3",1m)}79=1n;1p;1l"2J":me.mg(1m);1p;1l"5K":if(fr&&!1m){6a.5K("6d")}if(fr&&2K 1m==="4e"){6a.5K("2Q","fu",1m)}if(!fr&&1m!==1j){me.zf(1m)}1p;1l"61":$(".ui-3j-61",me.Td).3X(""+(1m||"&#To;"));1p;1l"1r":79=1n;1p}$.A9.2T.mz.3c(me,2q);if(79){me.zb()}},Tz:1a(){K 1x=J.1x;J.7v.31({1r:"6l",6m:0,1y:0});if(1x.c3>1x.1r){1x.1r=1x.c3}K mr=J.6a.31({1y:"6l",1r:"6l"}).1y();K 6m=J.mq();J.7v.31(1x.1y==="6l"?{6m:6m,1y:$.bV.6m?"6l":6m}:{6m:0,1y:"6l"}).59();if(J.6a.is(":1h(ui-5K)")){J.6a.5K("2Q","6m",J.mq())}},zb:1a(){K o=J.1x;J.7v.59().31({1r:"6l",6m:0,9i:"3p",1y:0,c3:o.c3});K mr=J.6a.31({1y:"6l",1r:o.1r}).1y();K gl=0;if(aa(o.6m)){gl=mr}1i{gl=3D.4y(o.6m,mr)}if(o.1y==="6l"){J.7v.31({6m:gl,1y:"6l"})}1i{J.7v.1y(3D.4y(0,o.1y-mr))}if(J.6a.is(":1h(ui-5K)")){J.6a.5K("2Q","6m",J.mq())}},sN:1a(){J.sT=J.2N.2D("cX").eQ(1a(){K cX=$(J);1b $("<2E>").31({2J:"8t",1r:cX.eB(),1y:cX.aS()}).4r(cX.1L()).2y(cX.2y())[0]})},zi:1a(){if(J.sT){J.sT.3u();42 J.sT}},TC:1a(1H){if($(1H.3k).fB(".ui-3j").1e){1b 1n}1b!!$(1H.3k).fB(".ui-tF").1e}};(1a($){$.8M("ui.6j",QB.1d.78);$.4l($.ui.6j,{5M:"1.8.2",ED:"2J",Tr:0,mv:0,6F:1a(){K 1V=$("#qb-ui-1V");1b{x:J.2y().2a-1V.2y().2a,y:J.2y().1O-1V.2y().1O,1r:J.1r(),1y:J.1y()}}})})(2v);QB.1d.78.2l={kt:"kt",Df:"Df",sY:"sY",sW:"sW",sU:"sU",zt:"zt",kA:"kA",Cs:"Cs",kD:"kD",kz:"kz"};QB.1d.Cv={};QB.1d.Cv.2l={nA:"nA"};QB.1d.jJ=1a(1q,1L){J.2Z=1c;J.d8=1c;J.aT=1c;J.6n=1c;J.9f=1q;J.eo=1L;J.bS=1c;J.1m=1a(4g){if(4g===2O){1b J.bS}J.bS=4g};J.bo=1a(){K bo=J.bS;if(!1K(J.bS)){3r(J.9f){1l 1R.2i.bT:bo=J.bS;1p;1l 1R.2i.8K:bo=1R.7N.nH.de(J.bS);if(bo=="yJ"){bo=""}1p;1l 1R.2i.6N:K 1m=J.eo.7k(1R.2i.8K);if(1K(1m)||1m==0){bo=""}1p;1l 1R.2i.bZ:bo=1R.7N.tv.de(J.bS);1p}}if(1K(bo)){bo=" "}1b bo};J.3u=1a(){};J.7Q=1a(){if(J.d8!=1c){J.d8[0].nC=Eh(J.bo())}if(J.6n!=1c){J.6n.cK(J.bS)}};J.DV=1a(){if(J.d8!=1c){J.d8.3L()}if(J.aT!=1c){J.aT.59()}if(J.6n!=1c){J.6n.2S()}};J.z0=1a(){if(J.d8==1c){1b}QB.1d.2W.ts=1n;J.d8.59();if(J.aT!=1c){J.aT.3L()}QB.1d.2W.ts=1j};J.EB=1a(){K 6D=1c;K me=J;3r(J.9f){1l 1R.2i.kc:6D=$("<2E></2E>");6D.gw=1n;6D.2C("3J",1a(e){$(me).2c(QB.1d.jJ.2l.tn,{1q:me.9f,4g:1n,5x:1j})});me.2Z.2C("7V",1a(e){if(e.3F==13||e.3F==32){me.6n.2c("3J")}});1p;1l 1R.2i.47:6D=$("<2E></2E>");6D.gw=1n;1p;1l 1R.2i.1Q:6D=$(\'<29 1w="7O" 1m="1n" />\');6D.1k("69",-1);6D.gw=1n;1p;1l 1R.2i.dt:6D=$(\'<29 1w="7O" 1m="1n" />\');6D.1k("69",-1);6D.gw=1n;1p;1l 1R.2i.3h:6D=$("<2o />");1p;1l 1R.2i.bT:K 2o=["<2o>"];if(!1K(QB.1d.5I.9b)&&!1K(QB.1d.5I.9b.E4)){K 1Q="";$.2h(QB.1d.5I.9b.E4,1a(1P,2g){1Q=2g==me.bS?\' 1Q="1Q" \':"";2o.1C(\'<2Q 1m="\'+2g+\'"\'+1Q+">"+(2g==1c?"":2g)+"</2Q>")})}2o.1C("</2o>");6D=$(2o.4H(""));6D.2C("dr",1a(){me.dh()});1p;1l 1R.2i.8K:K 2o=["<2o>"];1R.7N.nH.2h(1a(1P,2g){2o.1C(\'<2Q 1m="\'+1P+\'">\'+(2g==1c?"":2g)+"</2Q>")});2o.1C("</2o>");6D=$(2o.4H(""));6D.2C("dr",1a(){me.dh()});1p;1l 1R.2i.6N:6D=$("<2o />");1p;1l 1R.2i.bZ:K 2o=["<2o>"];1R.7N.tv.2h(1a(1P,2g){2o.1C(\'<2Q 1m="\'+1P+\'">\'+(2g==1c?"":2g)+"</2Q>")});2o.1C("</2o>");6D=$(2o.4H(""));6D.2C("dr",1a(){me.dh()});1p;5o:6D=$(\'<29 1w="1Y" 1m="" />\');6D.4N("7V",me.Ex,me);1p}6D.YS(1a(e){me.2Z.4f("ui-yZ-2S")});1b 6D};J.Ex=1a(e){if(e.3F==13){e.7X();J.dh();1b 1j}};J.z3=1a(){K me=J;if(J.aT==1c){J.aT=$(\'<2E 2B="ui-qb-3R-1I-7D-Ek-7a"></2E>\');J.aT.4r(J.2Z)}J.6n=J.EB(J.9f);J.6n.4r(J.aT);J.6n.1k("5w-3y",QB.1d.2W.8j[J.9f]);if(!J.6n.gw){J.aT.3L()}if(J.9f==1R.2i.3h){K sD=J.6n.zk({9C:"3R-3h",1m:me.bS,fM:1a(){me.dh()}});K 8i=sD.zj()[0];J.6n=8i.zo();J.6n.nI=1n}if(J.9f==1R.2i.6N){K sD=J.6n.zk({9C:"3R-6N",fM:1a(){me.dh()}});K 8i=sD.zj()[0];J.6n=8i.zo();J.6n.nI=1n}J.6n.2t("ui-qb-3R-1I-7D-Ek-2Z");if(!J.6n.nI){if(J.6n.gw){J.6n.dr(1a(){me.dh()});J.6n.nI=1n}1i{J.6n.4O(1a(){me.dh()});J.6n.nI=1n}}};J.zz=1a(){J.aT.6w().3u();J.aT.3u();J.aT=1c;J.z3()};J.Em=1a(){K me=J;3r(J.9f){1l 1R.2i.kc:;1l 1R.2i.47:;1l 1R.2i.1Q:;1l 1R.2i.dt:1b 1c}K $yK=$("<2E></2E>").2t("ui-qb-3R-1I-7D-Eo-7a").2t("ui-qb-3R-1I-7D-Eo-2Z");$yK.3J(1a(e){if(gj){1b}if(Lx&&me.9f==1R.2i.b0){QB.1d.5I.u0("Zc DH is iQ Zd of iQ Lv 5M. Dr DY 4u Za of Zb o8 DY be DP to jn Z0 DH in iQ Z1 5M.");1b 1j}me.rQ()});1b $yK};J.rQ=1a(){QB.1d.2W.bn=1n;if(QB.1d.2W.n9!=1c){QB.1d.2W.n9.dh()}if(J.9f==1R.2i.3h||!J.eo.1K()&&!J.eo.Cl()){J.DV();QB.1d.2W.n9=J}J.2Z.2t("ui-yZ-2S")};J.dh=1a(){K z1=1n;K 5x=J.1m();K 4g=J.6n.cK();if(!3M.ti(5x,4g)&&!(5x==1c&&(4g==" "||4g==0))){K yS=J.eo.7k(1R.2i.8K);3r(J.9f){1l 1R.2i.6N:if(1K(4g)||4g==0){if(!1K(yS)){J.eo.8u(1R.2i.8K,1R.7N.nH.yJ)}}1i{5x=1K(5x)?JX:63(5x);4g=63(4g);if(aa(4g)){4g=0}if(aa(5x)){5x=JX}4g+=4g<5x?-0.5:+0.5;if(1K(yS)){J.eo.8u(1R.2i.8K,1R.7N.nH.DF);J.eo.jp(1R.2i.8K)}z1=1j}1p}J.1m(4g);if(z1){J.eo.jp()}J.z0();$(J).2c(QB.1d.jJ.2l.tn,{1q:J.9f,4g:4g,5x:5x})}1i{J.z0()}QB.1d.2W.n9=1c;if(!J.6n.gw){J.2Z.4f("ui-yZ-2S")}};J.Dt=1a(1q){K gx="ui-qb-3R-1I-";if(1q>=1R.2i.nr){1b gx+"xC"}1b gx+1R.2i.de(1q)};J.eM=1a(2S){if(!2S.1e){1b $()}K 1J=2S.3m();if(1J.is(":8L")){1b 1J}1J=1J.2D(":8L:4x");if(1J.1e){1b 1J}K 1L=2S.1L();1b J.eM(1L)};J.dK=1a(2S){if(!2S.1e){1b $()}K 1J=2S.3P();if(1J.is(":8L")){1b 1J}1J=1J.2D(":8L:73");if(1J.1e){1b 1J}K 1L=2S.1L();1b J.dK(1L)};J.80=1a(1q,1L){K me=J;J.2Z=$(\'<td 2B="ui-8M-a8 ui-qb-3R-1I-7D \'+J.Dt(J.9f)+\'" />\');J.2Z.1k("69",0);K sB=J.9f;if(sB>1R.2i.8e){sB=1R.2i.8e}J.2Z.1k("5w-3y",QB.1d.2W.8j[sB]);J.d8=J.Em();if(J.d8!=1c){J.d8.4r(J.2Z)}J.z3();J.2Z.Zf(1a(e){if(QB.1d.2W!=1c&&QB.1d.2W.2x){1b}if(QB.1d.2W.ts){1b}if(me.2Z[0]!=e.3k){1b}me.rQ()});J.2Z.7V(1a(e){3r(e.3F){1l 9:if(e.nc){me.dK(me.2Z).2S();e.4h()}}})};J.80(1q,1L)};QB.1d.jJ.2l={tn:"Zk",Yz:"YT"};QB.1d.nh=1a(1N){J.YQ=1;J.5O={};J.YR=3M.tk();J.3f=1c;J.2Z=1c;J.nj=1j;J.66=BZ();J.YW=1j;J.1K=1a(){1b 1K(J.5O[1R.2i.3h].1m())};J.Cl=1a(){K 2g=J.5O[1R.2i.3h].1m();if(1K(2g)){1b 1j}1b 2g.4Y(".*")>=0};J.fd=1a(2g){K jK=J.5O[1R.2i.1Q].1m();if(2g===2O){1b jK}1i{if(jK!=2g){J.5O[1R.2i.1Q].1m(2g);J.zV(1c,{1q:1R.2i.1Q,4g:2g});1b 1n}}1b 1j};J.7k=1a(1q){1b J.5O[1q].1m()};J.F3=1a(){1b!1K(J.7k(1R.2i.bT))||!1K(J.7k(1R.2i.8e))};J.8u=1a(1q,1m,tj){if(1m===2O){1m=1c}K 4g=1m;K 5x=J.5O[1q].1m();if(3M.ti(4g,5x)){1b 1j}3r(1q){1l 1R.2i.8K:J.8u(1R.2i.6N,1c,tj);1p;1l 1R.2i.6N:if(1K(4g)||4g==0){4g=""}1p;5o:}J.5O[1q].1m(4g);1b 1n};J.zV=1a(e,1h){K 1q=1h.1q;K 4g=1h.4g;K 5x=1h.5x;$(J).2c(QB.1d.nh.2l.A7,{1q:1q,4g:4g,5x:5x,1I:J});J.jM()};J.jM=1a(){K me=J;K tb=me.1K();1o(K 1q in me.5O){if(1q==1R.2i.3h){ah}K 7D=me.5O[1q];7D.2Z.1k("69",tb?-1:0)}};J.Dh=1a(){K me=J;K 3X=$(\'<tr 2B="ui-qb-3R-1I" />\');1R.2i.2h(1a(1q){K 7D=1S QB.1d.jJ(1q,me);$(7D).4N(QB.1d.jJ.2l.tn,me.zV,me);7D.2Z.4r(3X);me.5O[1q]=7D});J.jM();3X.1h("1D",J);3X.1h("me",J);1b 3X};J.3u=1a(){J.nj=1n;J.2Z.6w().3u();J.2Z.3u();J.2Z.3X("")};J.jp=1a(jP){K me=J;1o(K 1q in me.5O){K 7D=me.5O[1q];if(jP===2O||jP==1q){7D.7Q()}}J.jM()};J.Hm=1a(jP){K me=J;1o(K 1q in me.5O){K 7D=me.5O[1q];if(jP===2O||jP==1q){7D.zz()}}J.jM()};J.Dc=1a(){J.8u(1R.2i.1Q,!J.1K());J.8u(1R.2i.dt,1j);J.8u(1R.2i.bZ,1R.7N.tv.ni)};J.h8=1a(zw,zU,rW){if(3M.3s(J.7k(1R.2i.3h)).3N()==3M.3s(zw).3N()){if(zU===2O||zU==3M.3s(J.7k(1R.2i.bT)).3N()){if(rW===2O||rW==3M.3s(J.7k(1R.2i.b0)).3N()){1b 1n}}}1b 1j};J.1N=1a(1m){if(1m===2O){1b J.D3()}1i{1b J.tw(1m)}};J.7Q=1a(1N){K 5G=J.tw(1N);if(5G){J.jp()}1b 5G};J.tw=1a(1N){K 5G=1j;if(1K(1N)){1b 5G}5G=J.8u(1R.2i.3h,1N.8P)||5G;5G=J.8u(1R.2i.bT,1N.dZ)||5G;5G=J.8u(1R.2i.b0,1N.8n)||5G;5G=J.8u(1R.2i.dt,1N.gU)||5G;5G=J.8u(1R.2i.bZ,1N.zX)||5G;5G=J.8u(1R.2i.8K,1N.dV)||5G;5G=J.8u(1R.2i.6N,1N.kb)||5G;1o(K i=0;i<QB.1d.2W.gR+1;i++){5G=J.8u(1R.2i.8e+i,1N.5N[i])||5G}if(J.3f!=1N.3f){J.3f=1N.3f;5G=1n}if(!1K(1N.66)&&J.66!=1N.66){J.66=1N.66;5G=1n}if(!1K(1N.3f)&&J.66!=1c){if(!1K(1N.3f)){J.66=1c}5G=1n}if(J.nj!=1N.7L){J.nj=1N.7L;5G=1n}if(J.8V!=1N.8V){J.8V=1N.8V;5G=1n}5G=J.8u(1R.2i.1Q,1N.bH&&!J.1K())||5G;J.jM();1b 5G};J.D3=1a(){K 1N=1S QB.1d.2d.xl;1N.bH=J.7k(1R.2i.1Q);1N.8P=J.7k(1R.2i.3h);1N.dZ=J.7k(1R.2i.bT);1N.8n=J.7k(1R.2i.b0);1N.gU=J.7k(1R.2i.dt);1N.zX=J.7k(1R.2i.bZ);1N.dV=J.7k(1R.2i.8K);1N.kb=J.7k(1R.2i.6N);1N.5N[0]=J.7k(1R.2i.8e);1o(K i=0;i<QB.1d.2W.gR;i++){1N.5N[1+i]=J.7k(1R.2i.nr+i)}1N.3f=J.3f;1N.7L=J.nj;1N.66=J.66;1N.8V=J.2Z==1c?0:J.2Z.1P();1b 1N};J.80=1a(D1){J.2Z=J.Dh();J.2Z.nk();J.Dc();J.tw(D1);J.jp()};J.80(1N)};QB.1d.nh.2l={A7:"YM"};QB.1d.2W={2V:[],gR:2,t6:1j,10g:1c,nE:1c,bn:1j,10d:[],2x:1j,ts:1j,eM:1a(2S){if(!2S.1e){1b $()}K 1J=2S.3m();if(1J.is(":8L")){1b 1J}1J=1J.2D(":8L:4x");if(1J.1e){1b 1J}K 1L=2S.1L();1b J.eM(1L)},dK:1a(2S){if(!2S.1e){1b $()}K 1J=2S.3P();if(1J.is(":8L")){1b 1J}1J=1J.2D(":8L:73");if(1J.1e){1b 1J}K 1L=2S.1L();1b J.dK(1L)},tg:1a(){K me=J;K x=J.1f.1k("gR");if(x!=1c&&(x!=""&&!aa(x))){QB.1d.2W.gR=63(x)}if(J.1f.1k("t6")=="103"){QB.1d.2W.t6=1n}J.1f.2t("ui-8M").2t("ui-qb-3R");J.1f.bU({t7:"qb-ui-3R-6y",Ae:".qb-ui-3R-bU",dl:"9l",Ad:1a(e,ui){if(ui.4w.4E("qb-ui-3Z-2j-4w")){K 1D=ui.4w.1h("1D");K hI=ui.4w.1h("hI");$(J).2c(QB.1d.2W.2l.tA,{1M:hI,2j:1D})}1i{K GE=$(J);K 1D=ui.4w.1h("1D");K sZ={1D:1D};$(J).2c(QB.1d.2W.2l.tK,sZ)}}});J.1M=$(\'<1M t4="0" t8="0" g2="0" />\').2t("ui-8M-a8").2t("te-H0").4r(J.1f);J.Hd().4r(J.1M);J.ji();J.h1();J.GZ();me.1f.2S(1a(e){QB.1d.2W.bn=1j});me.1f.1k("69",0);me.1f.7V(1a(e){3r(e.3F){1l 13:if(QB.1d.2W.bn){1b}QB.1d.2W.bn=1n;me.1f.2D("[69]:6K:4x").2S();e.4h();1p;1l 9:if(!QB.1d.2W.bn){if(!e.nc){me.eM(me.1f).2S()}1i{me.dK(me.1f).2S()}e.4h()}}})},GZ:1a(){K me=J;me.1M.4d({tf:1a(1M,1I){K 1u=$(1I).1h("1D");if(!1u.1K()){me.1f.2c(QB.1d.2W.2l.f7,{1I:1u})}},na:"ui-qb-3R-1I-47"})},6d:1a(){J.1f.4f("ui-qb-3R").7Y(".8A");J.1M.3u();$.A9.2T.6d.3c(J,2q)},ji:1a(1I){K A8=1j;$.2h(J.2V,1a(1q,1I){if(1I.1K()){A8=1n;1b 1j}});if(!A8){J.jI(1c)}},g0:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 3S=".ui-qb-3R-1I";K 1F=QB.1d.2f.jz(1T.2P);$.2L("6d",3S);$.2L({3S:3S,4o:cf,6O:{6S:0},1Z:1a(47,1x){K 1I=J.1h("me");me.jG(47,1I)},1F:1F})},jG:1a(47,1I){K me=J;K el=1I.2Z;3r(47){1l"dD-up":if(el.3m().1e){el.6Y(el.3P());if(!1I.1K()){me.1f.2c(QB.1d.2W.2l.f7,{1I:1I})}}1p;1l"dD-dE":K 3m=el.3m();if(3m.1e&&3m.3m().1e){el.e7(3m);if(!1I.1K()){me.1f.2c(QB.1d.2W.2l.f7,{1I:1I})}}1p;1l"1I-42":if(me.2V.1e>1){me.hO(1I)}1i{if(1I.1K()){1b}1i{me.hO(1I);me.ji()}}me.ji(1I);me.h1();me.1f.2c(QB.1d.2W.2l.f7,{1I:1I,1q:1R.2i.kc,4g:1n,5x:1j});1p;1l"1I-105":me.jI(1c,el);1p}},jI:1a(5a,jH,53,jg){K db=1j;K 1I=J.Gw(5a);if(1I==1c){db=1n;1I=1S QB.1d.nh(5a);$(1I).4N(QB.1d.nh.2l.A7,{1I:1I},J.HI,J);if(1I!=1c&&(!1I.1K()&&1K(jH))){jH=J.Gx()}if(53===0||!1K(53)){53=63(53)+1;K jf=$("tr",J.1M).eq(53);if(jf.1e){jf.yk(1I.2Z)}1i{1I.2Z.4r(J.1M)}}1i{if(jH!=1c&&jH.1e){1I.2Z.6Y(jH)}1i{1I.2Z.4r(J.1M)}}if(!jg){J.1f.2c(QB.1d.2W.2l.vY,{1I:1I})}J.2V.1C(1I)}1i{if(53===0||!1K(53)){53=63(53)+1;K GP=1I.2Z[0].108;if(53!=GP){K jf=$("tr",J.1M).eq(53);if(jf.1e){jf.yk(1I.2Z)}}}db=1I.7Q(5a);if(!jg&&db){J.1f.2c(QB.1d.2W.2l.f7,{1I:1I})}}if(1I!=1c&&1I.2Z!=1c){K nD=$(".ui-qb-3R-1I-bZ",1I.2Z);if(nD.1e>0){nD.31("5p",J.nE?"":"3p")}}if(!jg&&db){J.h1()}1b 1I},LY:1a(){1b J.2V},107:1a(){K zD=1c;$.2h(J.2V,1a(1q,1I){K tb=1I.1K();if(tb){zD=1I;1b 1j}});1b zD},hO:1a(zB,jg){K 5a;1o(K i=J.2V.1e-1;i>=0;i--){K 1I=J.2V[i];if(1I.3f==zB.3f){if(!1K(1I.3f)||1K(1I.3f)&&1I.2Z==zB.2Z){J.2V.3u(1I);1I.7L=1n;1I.3u();5a=1I.1N()}}}J.h1();if(5a){5a.7L=1n;if(!jg){J.1f.2c(QB.1d.2W.2l.vu,{5a:5a})}}},10h:1a(1N){K 2V=J.zx(1N);1o(K 1I in 2V){1I.3u();J.2V.3u(1I);42 1I}J.h1()},102:1a(7j){K 1J=1c;$.2h(J.2V,1a(1q,1I){if(1I.3f==7j){1J=1I;1b 1j}});1b 1J},Gx:1a(){1b J.1M.2D("tr:73:5X(.ui-qb-3R-1I-8a)")},Gw:1a(5a){K 2V=J.zx(5a);if(2V.1e>0){1b 2V[0]}1b 1c},zx:1a(5a){K 1J=[];if(5a==1c){1b 1J}K zw=3M.3s(5a.8P).3N();K rW=3M.3s(5a.8n).3N();1o(K i=0;i<J.2V.1e;i++){K 1I=J.2V[i];if(!1K(1I.3f)&&(!1K(5a.3f)&&1I.3f==5a.3f)){1J.1C(1I)}1i{if(!1K(1I.66)&&(!1K(5a.66)&&1I.66==5a.66)){1J.1C(1I)}1i{if(1I.h8(5a.8P,5a.dZ,5a.8n)){1J.1C(1I)}}}}1b 1J},kN:1a(){$.2h(J.2V,1a(1q,1I){1I.5O[1R.2i.3h].zz();if(QB.1d.2W.n9==1I.5O[1R.2i.3h]){1I.5O[1R.2i.3h].rQ()}})},EI:1a(3h){K 2V=J.su(3h);if(2V.1e>0){1b 2V[0]}1b 1c},su:1a(3h){K 1J=[];$.2h(J.2V,1a(1q,1I){if(1I.h8(3h,"")){1J.1C(1I)}});1b 1J},Ev:1a(1N){K 2S=$(":2S");$("#qb-ui-3R").2S();QB.1d.2W.2x=1n;K me=J;if(1K(1N)){1b}K zT=[];$.2h(1N.c7,1a(1P,Hq){zT.1C(me.jI(Hq,1c,1P,1n))});1o(K i=J.2V.1e-1;i>=0;i--){if(i>J.2V.1e-1){ah}K n7=J.2V[i];if(n7!=1c){if(zT.4Y(n7)==-1&&!n7.1K()){J.hO(n7,1n)}}}QB.1d.2W.2x=1j},CQ:1a(){K 2H=[];if(QB.1d.2f.5J!=1c&&QB.1d.2f.5J.1e!=1c){1o(K i=0;i<QB.1d.2f.5J.1e;i++){K 1u=QB.1d.2f.5J[i];K 1M=1u.1h("1D");K 8q=!1K(1M.ki)?1M.ki:1M.3T;K zS=8q+".*";2H.1C({1Q:1j,1Y:zS,1m:zS,dg:"1M"});$(1M.5A).2h(1a(){K 2j=J;K n5=8q+"."+2j.88;K Ht=2j.88;2H.1C({1Q:1j,1Y:Ht,1m:n5,dg:"2j"})})}}9x.zR("3R-3h",2H)},Zu:1a(1I,3B){1I.fd(3B)},HI:1a(e,1h){K 1I=e.1h.1I;K 1q=1c;K 4g=1c;K 5x=1c;if(1h){1q=1h.1q;4g=1h.4g;5x=1h.5x}if(1q==1R.2i.kc&&4g){if(J.2V.1e>1){J.hO(1I,1n)}1i{if(1I.1K()){1b}1i{J.hO(1I,1n);J.ji()}}}J.ji(1I);J.h1(1I);J.1f.2c(QB.1d.2W.2l.f7,{1I:1I,1q:1q,4g:4g,5x:5x})},h1:1a(1I){J.He(1I);J.HN(1I)},HN:1a(){K n6=[];1o(K i=0;i<J.2V.1e;i++){K 1I=J.2V[i];K 1m=1I.7k(1R.2i.8K);if(1m!=1c&&1m>0){n6.1C({1I:1I,6N:1I.7k(1R.2i.6N)})}}n6.eZ(J.Hf);K 2H=[];1o(K i=0;i<n6.1e;i++){2H.1C({1Q:1j,1Y:5l(i+1),1m:5l(i+1),dg:"6N"});K 1I=n6[i].1I;1I.8u(1R.2i.6N,i+1,1n);1I.jp(1R.2i.6N)}2H.1C({1Q:1j,1Y:5l(i+1),1m:5l(i+1),dg:"6N"});9x.zR("3R-6N",2H)},KH:1a(){1o(K i=0;i<J.2V.1e;i++){K 1I=J.2V[i];1I.Hm(1R.2i.bT)}},Hf:1a(a,b){K ju=b.6N;K jr=a.6N;if(1K(jr)||jr<0){1b 1}if(1K(ju)||ju<0){1b-1}jr=63(jr);ju=63(ju);1b jr-ju},He:1a(1I){K rP=1j;1o(K i=0;i<J.2V.1e;i++){if(J.2V[i].7k(1R.2i.dt)){rP=1n;1p}}if(J.nE==rP){1b 1j}J.nE=rP;K nD=$(".ui-qb-3R-1I-bZ",J.1M);nD.31("5p",J.nE?"":"3p");1b 1n},Hd:1a(){K 8a=$("<X6 />");K tr=$("<tr />").2t("ui-qb-3R-1I-8a").4r(8a);K 4x=1n;K rN="";QB.1d.2W.8j={};QB.1d.2W.8j[1R.2i.47]="";QB.1d.2W.8j[1R.2i.kc]=QB.1d.2d.5b.5r.h4;QB.1d.2W.8j[1R.2i.1Q]=QB.1d.2d.5b.5r.5N.sk;QB.1d.2W.8j[1R.2i.3h]=QB.1d.2d.5b.5r.5N.8P;QB.1d.2W.8j[1R.2i.bT]=QB.1d.2d.5b.5r.5N.dZ;QB.1d.2W.8j[1R.2i.b0]=QB.1d.2d.5b.5r.5N.8n;QB.1d.2W.8j[1R.2i.8K]=QB.1d.2d.5b.5r.5N.dV;QB.1d.2W.8j[1R.2i.6N]=QB.1d.2d.5b.5r.5N.kb;QB.1d.2W.8j[1R.2i.dt]=QB.1d.2d.5b.5r.5N.gU;QB.1d.2W.8j[1R.2i.bZ]=QB.1d.2d.5b.5r.5N.xz;QB.1d.2W.8j[1R.2i.8e]=QB.1d.2d.5b.5r.5N.sn;QB.1d.2W.8j[1R.2i.nr]=QB.1d.2d.5b.5r.5N.sn;$.2h(QB.1d.2W.8j,1a(i,7D){QB.1d.2W.8j[i]=7D.3g("&2r;"," ").3g("&xv;","&")});$.2h(J.F9(),1a(){if(4x){rN=\'X5="3"\';4x=1j}1i{rN=""}$(\'<th 2B="ui-4Z-5o ui-qb-3R-1I-\'+J.1z+\'" \'+rN+">"+J.8a+"</th>").4r(tr)});1b 8a},F9:1a(){K 2V={};2V[1R.2i.1Q]={cg:1,1z:"1Q",8a:QB.1d.2d.5b.5r.5N.sk,1w:"7O"};2V[1R.2i.3h]={cg:2,1z:"3h",8a:QB.1d.2d.5b.5r.5N.8P,1w:"3h"};2V[1R.2i.bT]={cg:3,1z:"bT",8a:QB.1d.2d.5b.5r.5N.dZ,1w:"2o"};2V[1R.2i.b0]={cg:4,1z:"b0",8a:QB.1d.2d.5b.5r.5N.8n,1w:"1Y"};2V[1R.2i.8K]={cg:5,1z:"8K",8a:QB.1d.2d.5b.5r.5N.dV,1w:"2o"};2V[1R.2i.6N]={cg:6,1z:"6N",8a:QB.1d.2d.5b.5r.5N.kb,1w:"2o"};2V[1R.2i.dt]={cg:7,1z:"dt",8a:QB.1d.2d.5b.5r.5N.gU,1w:"7O"};2V[1R.2i.bZ]={cg:8,1z:"bZ",8a:QB.1d.2d.5b.5r.5N.xz,1w:"2o"};2V[1R.2i.8e]={cg:9,1z:"8e",8a:QB.1d.2d.5b.5r.5N.sn,1w:"1Y"};1o(K i=0;i<QB.1d.2W.gR;i++){2V[1R.2i.nr+i]={cg:10+i,1z:"xC",8a:QB.1d.2d.5b.5r.5N.EK,1w:"1Y"}}1b 2V}};QB.1d.2W.2l={vY:"Xe",vu:"Xd",f7:"vX",tK:"tK",tA:"tA"};(1a($){$.8M("ui.8A",QB.1d.2W);$.4l($.ui.8A,{ED:"Xh EI su jI g0",5M:"1.7.1"})})(2v);QB.1d.2d.eP={f3:0,6t:1,yu:2,tX:3,Ln:4};QB.1d.2d.6s={};QB.1d.2d.6s[QB.1d.2U.6u.EH]={3T:"WC fX",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.EV]={3T:"hd",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.F0]={3T:"WB fX",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.mC]={3T:"is h8 to",7F:1,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.EY]={3T:"x5 5X 2I fX",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.ER]={3T:"x5 5X WA",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.EP]={3T:"x5 5X 4z fX",7F:1,6Z:[QB.1d.2U.6g.9Q]};QB.1d.2d.6s[QB.1d.2U.6u.x9]={3T:"is in 4L",7F:1,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.FV]={3T:"is 5X h8 to",7F:1,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.xe]={3T:"is 5X in 4L",7F:1,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.FY]={3T:"is 1c",7F:0,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.FQ]={3T:"is 5X 1c",7F:0,6Z:[]};QB.1d.2d.6s[QB.1d.2U.6u.FU]={3T:"is Ga sc",7F:1,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.6s[QB.1d.2U.6u.G7]={3T:"is Ga sc or h8 to",7F:1,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.6s[QB.1d.2U.6u.G6]={3T:"is Fz sc",7F:1,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.6s[QB.1d.2U.6u.Fx]={3T:"is Fz sc or h8 to",7F:1,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.6s[QB.1d.2U.6u.Ft]={3T:"is Gl",7F:2,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.6s[QB.1d.2U.6u.FF]={3T:"is 5X Gl",7F:2,6Z:[QB.1d.2U.6g.eS,QB.1d.2U.6g.5m]};QB.1d.2d.gY={};QB.1d.2d.gY[QB.1d.2U.9P.91]={3T:"91",hw:"6o"};QB.1d.2d.gY[QB.1d.2U.9P.tV]={3T:"eT 91",hw:"Y8"};QB.1d.2d.gY[QB.1d.2U.9P.mF]={3T:"mF",hw:"Y6"};QB.1d.2d.gY[QB.1d.2U.9P.hW]={3T:"hW",hw:"3p"};QB.1d.u3=1a(){J.$1w=1c};QB.1d.mE=1S 68({$1w:"dA.mL.1d.dJ.mK.xb, dA.mI.1d.dJ",4m:1c,2P:[],4B:QB.1d.2d.eP.f3,6t:1c,7s:QB.1d.2U.6u.mC,5U:1c,70:1c,dw:1j,ft:1j,1f:1c,9r:1a(){K 9r=J;45(9r.4m!=1c){9r=9r.4m}1b 9r},u1:1a(1N){1N.$1w=J.$1w;1N.4B=J.4B;1N.6t=J.6t;1N.7s=J.7s;1N.5U=J.5U;1N.70=J.70},ug:1a(1N){1N.2P=[];$.2h(J.2P,1a(1P,1g){1N.2P.1C(1g.hF())})},hF:1a(){K 1N=$.4l(1S QB.1d.u3,1S QB.1d.2d.xb);J.u1(1N);J.ug(1N);1b 1N},FJ:1a(1N){K 1J=1c;if(1N==1c){1b 1J}3r(1N.4B){1l QB.1d.2d.eP.6t:1J=1S QB.1d.yq(J);1J.oj(1N);1p;1l QB.1d.2d.eP.yu:1J=1S QB.1d.yD(J);1J.oj(1N);1p;1l QB.1d.2d.eP.tX:1J=1S QB.1d.u2(J);1J.oj(1N);1p}1b 1J},oj:1a(1N){K me=J;J.4B=1N.4B;J.6t=1N.6t;J.7s=1N.7s;J.ao=1N.ao;J.8Z=1N.8Z;J.5U=1N.5U;J.70=1N.70;$.2h(1N.2P,1a(1P,1g){me.2P.1C(me.FJ(1g))})},xN:1a(5P){J.6t=5P;if(J.6t!=1c){if(QB.1d.2d.6s[J.7s].6Z.1e!=0&&!QB.1d.2d.6s[J.7s].6Z.hd(J.7s)){J.7s=QB.1d.2U.6u.mC}}1i{J.7s=QB.1d.2U.6u.mC}},8V:1a(){if(J.4m==1c){1b-1}1b J.4m.2P.4Y(J)},Y9:1a(){if(J.4m==1c){1b 1c}K i=J.4m.2P.4Y(J);if(i>=J.4m.2P.1e-1){1b 1c}1b J.4m.2P[i+1]},nV:1a(){if(J.4m==1c){1b 1c}K i=J.4m.2P.4Y(J);if(i<=0){1b 1c}1b J.4m.2P[i-1]},Fy:1a(){if(J.4m==1c){1b 0}1b J.4m.2P.1e},yr:1a(){1b QB.1d.2d.6s[J.7s]},tP:1a(){K 1J="";if(!J.9r().oi){1b 1J}if(J.nV()==1c){1b 1J}if(J.4m==1c){1b 1J}3r(63(J.4m.8Z)){1l QB.1d.2U.9P.91:;1l QB.1d.2U.9P.tV:1J=$("<2F> o8 </2F>");1p;1l QB.1d.2U.9P.mF:;1l QB.1d.2U.9P.hW:1J=$("<2F> or </2F>");1p}1b 1J},KZ:1a(){K 1F={};$.2h(J.9r().tD,1a(1P,5P){1F[5P.3T]={1z:5P.3T,3K:"2j",1h:5P}});1b 1F},Kg:1a(1g){K 1F={};$.2h(QB.1d.2d.6s,1a(1P,1f){if(1g.6t!=1c){if(1f.6Z.1e!=0){if(1g.6t!=1c&&1f.6Z.hd(1g.6t.ml)){1F[1P]={1z:1f.3T,3K:"",1h:1f}}}1i{1F[1P]={1z:1f.3T,3K:"",1h:1f}}}});1b 1F},Kk:1a(1g){K 1F={};$.2h(QB.1d.2d.gY,1a(1P,1f){1F[1P]={1z:1f.3T,3K:"",1h:1f}});1b 1F},tW:1a(){K 1F={};1F["dD-up"]={1z:"ic up",3K:"dD-up",2x:J.8V()<=0};1F["dD-dE"]={1z:"ic dE",3K:"dD-dE",2x:J.8V()>=J.Fy()-1};1F["5n"]="---------";1b 1F},7B:1a(){J.mP()},hS:1a(){1b 1n},mP:1a(){if(J.6t==1c){J.dw=1n;J.ft=1n;1b}if(J.7s==QB.1d.2U.6u.x9||J.7s==QB.1d.2U.6u.xe){1b!1K(J.5U)}3r(J.6t.ml){1l QB.1d.2U.6g.i8:;1l QB.1d.2U.6g.5m:;1l QB.1d.2U.6g.9Q:;1l QB.1d.2U.6g.f3:J.dw=!1K(J.5U);J.ft=!1K(J.70);1p;1l QB.1d.2U.6g.eS:J.dw=!1K(J.5U)&&$.Fk(J.5U);J.ft=!1K(J.70)&&$.Fk(J.70);1p}},fC:1a(){J.7B()},ip:1a(){1b{}},F8:1a(){K 1P=J.8V();K 1g=J.4m.2P[1P];if(1P<=0||(J.4m==1c||J.1f==1c)){1b 1j}K xd=1P-1;K hb=J.4m.2P[xd];if(hb==1c||hb.1f==1c){1b 1j}J.1f.6Y(hb.1f);J.4m.2P[1P]=hb;J.4m.2P[xd]=1g;1b 1n},Hc:1a(){K 1P=J.8V();K 1g=J.4m.2P[1P];if(J.4m==1c||(J.1f==1c||1P>=J.4m.2P.1e-1)){1b 1j}K dC=1P+1;K hp=J.4m.2P[dC];if(hp==1c||hp.1f==1c){1b 1j}hp.1f.6Y(J.1f);J.4m.2P[1P]=hp;J.4m.2P[dC]=1g;1b 1n},HH:1a(){K 1P=J.8V();J.4m.2P.3u(1P);J.1f.3u();1b 1n},Gn:1a(){$.2h(J.2P,1a(1P,1g){1g.1f.3u()});J.2P=[];1b 1n},i5:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.i9(1g.7B())}1i{1g.nV().1f.uh(1g.7B())}},xO:1a(){K 1g=1S QB.1d.yq(J.4m);J.4m.2P.1C(1g);J.4m.i5(1g);1b 1g},Gp:1a(){K 1g=1S QB.1d.yD(J.4m);J.4m.2P.1C(1g);J.4m.i5(1g);1b 1g},GR:1a(){K 1g=1S QB.1d.u2(J.4m);J.4m.2P.1C(1g);J.4m.i5(1g);1b 1g},ty:1a(1q){3r(1q){1l"dD-up":1b J.F8();1p;1l"dD-dE":1b J.Hc();1p;1l"42":1b J.HH();1p;1l"a0":1b J.Gn();1p;1l"54-8e-1o-5P":1b J.xO();1p;1l"54-tO-8e":1b J.Gp();1p;1l"54-bI-of-tR":1b J.GR();1p}1b 1j},yc:1a(1q,5P){J.xN(5P);J.fC();1b 1n},Kp:1a(1q){J.7s=1q;J.fC();1b 1n},Km:1a(1q){J.8Z=1q;J.fC();1b 1n},bB:1a(1L){if(1L!==2O){J.4m=1L}}});QB.1d.yq=1S 68({bh:QB.1d.mE,4B:QB.1d.2d.eP.6t,$1w:"dA.mL.1d.dJ.mK.GI, dA.mI.1d.dJ",ip:1a(){K 1F=J.tW();1F["42"]={1z:"h4",3K:"xX"};1b 1F},hS:1a(){if(J.6t==1c){1b 1j}K yh=J.yr();if(yh!=1c){3r(yh.7F){1l 2:1b J.dw&&J.ft;1p;1l 1:1b J.dw;1p;1l 0:1b 1n;1p}}1b 1n},j1:1a($1f,dz,5P){K me=J;if(1K(dz)){dz=1}K 2g="";if(dz==2){if(!1K(J.70)){2g=J.70}}1i{if(!1K(J.5U)){2g=J.5U}}K $29=$(\'<29 1m="\'+2g+\'">\').gN(1a(1H){if(1H.3F==10||1H.3F==13){1H.4h();J.4O()}});if(!1K(5P)&&5P.ml==QB.1d.2U.6g.5m){$29.tF({fM:1a(2g,Ym){$29.2g(2g);if(dz==2){me.70=2g}1i{me.5U=2g}me.mP(2g,dz)},Yo:1a(){2g=$29.2g();if(dz==2){me.70=2g}1i{me.5U=2g}me.fC()}});$29.e7($1f).2S()}1i{$29.e7($1f);$29.2S();6x(1a(){$29.4O(1a(){K 2g=$29.2g();if(dz==2){me.70=2g}1i{me.5U=2g}me.mP(2g,dz);me.fC()})},8W)}},7B:1a(){K me=J;J.1L(2q);if(J.1f==1c){J.1f=$(\'<2E 2B="qb-ui-4D-4F-7a 1g">\')}J.1f.cI();J.1f.1h("1g",J);J.1f.3a($(\'<2E 2B="qb-ui-4D-4F-3C 6M">\'));J.1f.3a(" ");J.1f.3a(J.tP());K 5P=J.6t;if(1K(5P)){J.1f.3a($(\'<a 2B="qb-ui-4D-4F-1W-2j-2o 9j" 5c="#">[2o 5P]</a>\'))}1i{J.1f.3a($(\'<a 2B="qb-ui-4D-4F-1W-2j-2o" 5c="#">\'+5P.3T+"</a>"))}J.1f.3a(" ");K E1=QB.1d.2d.6s[J.7s].3T;J.1f.3a($(\'<a 2B="qb-ui-4D-4F-1W-7T" 5c="#">\'+E1+"</a>"));J.1f.3a(" ");K Ei=J.yr();K $9U;K $ei;3r(63(Ei.7F)){1l 1:if(1K(J.5U)){$9U=$(\'<a 2B="qb-ui-4D-4F-1W-1m 9j" 5c="#">[tB 1m]</a>\')}1i{$9U=$(\'<a 2B="qb-ui-4D-4F-1W-1m" 5c="#">\'+J.5U+"</a>")}$9U.3J(1a(e){K $1f=$(J);me.j1($1f,1,5P);$1f.3L()});J.1f.3a($9U);if(!1K(J.5U)&&!J.dw){$9U.2t("9j");J.1f.3a(\' <2F 2B="tL-1m">DC 1m</2F>\')}1p;1l 2:if(1K(J.5U)){$9U=$(\'<a 2B="qb-ui-4D-4F-1W-1m 9j" 5c="#">[tB 1m]</a>\')}1i{$9U=$(\'<a 2B="qb-ui-4D-4F-1W-1m" 5c="#">\'+J.5U+"</a>")}if(!J.dw){$9U.2t("9j")}$9U.3J(1a(e){K $1f=$(J);me.j1($1f,1,5P);$1f.3L()});J.1f.3a($9U);J.1f.3a($("<2F> o8 </2F>"));if(1K(J.70)){$ei=$(\'<a 2B="qb-ui-4D-4F-1W-1m 9j" 5c="#">[tB 1m]</a>\')}1i{$ei=$(\'<a 2B="qb-ui-4D-4F-1W-1m" 5c="#">\'+J.70+"</a>")}if(!J.ft){$ei.2t("9j")}$ei.3J(1a(e){K $1f=$(J);me.j1($1f,2,5P);$1f.3L()});J.1f.3a($ei);if(!1K(J.5U)&&!J.dw||!1K(J.70)&&!J.ft){if(!1K(J.5U)&&!J.dw){$9U.2t("9j")}if(!1K(J.70)&&!J.ft){$ei.2t("9j")}J.1f.3a(\' <2F 2B="tL-1m">DC 1m</2F>\')}1p}if(!1K(5P)&&5P.ml==QB.1d.2U.6g.5m){if(!1K($9U)){$9U.tF()}if(!1K($ei)){$ei.tF()}}1b J.1f},bB:1a(1L){J.1L(1L)}});QB.1d.yD=1S 68({bh:QB.1d.mE,4B:QB.1d.2d.eP.yu,$1w:"dA.mL.1d.dJ.mK.yt, dA.mI.1d.dJ",ao:"",tZ:1j,ip:1a(){K 1F=J.tW();1F["42"]={1z:"h4",3K:"xX"};1b 1F},hF:1a(){K 1N=$.4l(1S QB.1d.u3,1S QB.1d.2d.yt);J.u1(1N);1N.ao=J.ao;J.ug(1N);1b 1N},hS:1a(){1b J.tZ},mP:1a(2g,dz){J.tZ=!1K(J.ao)},j1:1a($1f){K me=J;K 2g="";if(!1K(J.ao)){2g=J.ao}K $29=$(\'<29 1m="\'+2g+\'">\').gN(1a(1H){if(1H.3F==10||1H.3F==13){1H.4h();J.4O()}}).4O(1a(){me.ao=$29.2g();me.5U=me.ao;me.fC()}).e7($1f).2S()},7B:1a(){K me=J;J.1L(2q);if(J.1f==1c){J.1f=$(\'<2E 2B="qb-ui-4D-4F-7a 1g">\').1h("1g",J)}J.1f.cI();J.1f.3a($(\'<2E 2B="qb-ui-4D-4F-3C 6M">\'));K $hX;J.1f.3a(J.tP());if(1K(J.ao)){$hX=$(\'<a 2B="qb-ui-4D-4F-1W-1m 9j" 5c="#">[tB 8e]</a>\')}1i{$hX=$(\'<a 2B="qb-ui-4D-4F-1W-1m" 5c="#">\'+J.ao+"</a>")}if(!J.tZ){$hX.2t("9j")}$hX.3J(1a(e){K $1f=$(J);$1f.3L();me.j1($1f)});J.1f.3a($hX);1b J.1f},bB:1a(1L){J.1L(1L)}});QB.1d.u2=1S 68({bh:QB.1d.mE,4B:QB.1d.2d.eP.tX,$1w:"dA.mL.1d.dJ.mK.xU, dA.mI.1d.dJ",8Z:QB.1d.2U.9P.91,hF:1a(){K 1N=$.4l(1S QB.1d.u3,1S QB.1d.2d.xU);J.u1(1N);1N.8Z=J.8Z;J.ug(1N);1b 1N},hS:1a(){K 1J=1n;if(J.2P.1e==0&&J.4m!=1c){1b 1j}$.2h(J.2P,1a(1P,1g){if(!1g.hS()){1J=1j;1b 1j}});1b 1J},ip:1a(){K 1F=J.tW();1F["a0"]={1z:"xT",3K:"xS",2x:J.2P.1e<=0};1F["42"]={1z:"h4",3K:"xX"};1b 1F},i5:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.6w(".qb-ui-4D-4F-4n").i9(1g.7B())}1i{1g.nV().1f.uh(1g.7B())}},y5:1a(){1b QB.1d.2d.gY[J.8Z]},7B:1a(){J.1L(2q);if(J.1f==1c){J.1f=$(\'<2E 2B="qb-ui-4D-4F-7a bI">\')}J.1f.1h("1g",J);J.1f.cI();J.1f.3a($(\'<2E 2B="qb-ui-4D-4F-3C 9Z">\'));K il=J.y5();K $3y=$(\'<2E id="qb-ui-4D-4F-3y">\');$3y.3a(J.tP());K $a=$(\'<a 2B="qb-ui-4D-4F-1W-y8" 5c="#">\'+il.3T+"</a>");$3y.3a($a);$3y.3a($("<2F> "+J.9r().iO+"</2F>"));J.1f.3a($3y);K $4n=$(\'<2E 2B="qb-ui-4D-4F-4n \'+il.hw+\'">\');$.2h(J.2P,1a(1P,1g){$4n.3a(1g.7B())});K u7=1S QB.1d.uc(J);$4n.3a(u7.7B());J.1f.3a($4n);1b J.1f},bB:1a(1L){J.1L(1L);if(1L!=1c){3r(63(1L.8Z)){1l QB.1d.2U.9P.91:;1l QB.1d.2U.9P.tV:J.8Z=QB.1d.2U.9P.mF;1p;5o:J.8Z=QB.1d.2U.9P.91}}}});QB.1d.uc=1S 68({bh:QB.1d.mE,4B:QB.1d.2d.eP.Ln,ip:1a(){K 1F={"54-8e-1o-5P":{1z:"fA 8e 1o 5P",3K:"54-8e-1o-5P"},"54-tO-8e":{1z:"fA tO 8e",3K:"54-tO-8e"},"5n":"---------","54-bI-of-tR":{1z:"fA bI of tR",3K:"54-bI-of-tR"}};1b 1F},7B:1a(){if(J.1f==1c){J.1f=$(\'<2E 2B="qb-ui-4D-4F-7a 54">\').1h("1g",J)}J.1f.cI();J.1f.3a($(\'<2E 2B="qb-ui-4D-4F-3C lJ">\'));J.1f.3a($(\'<a 2B="qb-ui-4D-4F-1W-2j-2o" 5c="#">[...]</a>\'));1b J.1f},yc:1a(1q,5P){K 1g=J.xO();1g.xN(5P);1g.fC();1b 1n},bB:1a(1L){J.1L(1L)}});QB.1d.7u=1S 68({bh:QB.1d.u2,$1w:"dA.mL.1d.dJ.mK.xZ, dA.mI.1d.dJ",4m:1c,ob:"Ns",iO:"of iQ Xw XR",oi:1n,2P:[],iZ:1a(1h){J.tD=1h.tD;J.2P=[];J.oj(1h);J.y0()},Ik:1a(){K me=J;K 5t=".qb-ui-4D-4F-3C";$.2L("6d",5t);$.2L({3S:5t,4o:cf,6O:{6S:0},2c:"2a",1F:{},9A:1a($2c,e){K 1g=$2c.cD(".qb-ui-4D-4F-7a:4x").1h("1g");if(1g==1c){1b 1j}K 1F=1g.ip();if(1F==1c||4J.81(1F).1e==0){1b 1j}1b{1Z:1a(1q){1g.ty(1q,1F[1q].1h)},1F:1F}}})},NE:1a(){K me=J;K 5t=".qb-ui-4D-4F-1W-7T";$.2L("6d",5t);$.2L({3S:5t,4o:cf,6O:{6S:0},2c:"2a",1F:{},9A:1a($2c,e){K 1g=$2c.cD(".qb-ui-4D-4F-7a:4x").1h("1g");if(1g==1c){1b 1j}K 6U=1g.Kg(1g);if(6U==1c||4J.81(6U).1e==0){1b 1j}1b{1Z:1a(1q){1g.Kp(1q)},1F:6U}}})},Lo:1a(){K me=J;K 5t=".qb-ui-4D-4F-1W-y8";$.2L("6d",5t);$.2L({3S:5t,4o:cf,6O:{6S:0},2c:"2a",1F:{},9A:1a($2c,e){K 1g=$2c.cD(".qb-ui-4D-4F-7a:4x").1h("1g");if(1g==1c){1b 1j}K 6U=1g.Kk(1g);if(6U==1c||4J.81(6U).1e==0){1b 1j}1b{1Z:1a(1q){1g.Km(1q)},1F:6U}}})},I1:1a(){K me=J;K 5t=".qb-ui-4D-4F-1W-2j-2o";$.2L("6d",5t);K 1T=$.2L({3S:5t,4o:cf,6O:{6S:0},2c:"2a",1F:{},bO:"XJ",9A:1a($2c,e){K 1g=$2c.cD(".qb-ui-4D-4F-7a:4x").1h("1g");if(1g==1c){1b 1j}K 1F=1g.KZ();if(1F==1c||4J.81(1F).1e==0){1b 1j}1b{1Z:1a(1q){1g.yc(1q,1F[1q].1h)},1F:1F}}})},y0:1a(){K me=J;J.2p.cI();J.2p.3a(J.7B());1b;K $4n=$(\'<2E 2B="qb-ui-4D-4F-4n 6o">\');$.2h(J.2P,1a(1P,1g){$4n.3a(1g.7B())});K JF=1S QB.1d.uc(J);$4n.3a(JF.7B());J.2p.3a($4n);J.1f=$4n},i5:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.6w(".qb-ui-4D-4F-4n").i9(1g.7B())}1i{1g.nV().1f.uh(1g.7B())}},7B:1a(){if(J.1f==1c){J.1f=$(\'<2E 2B="qb-ui-4D-4F-7a bI 2p">\').1h("1g",J)}J.1f.cI();K il=J.y5();K $3y=$(\'<2E id="qb-ui-4D-4F-3y">\');$3y.3a("<2F>"+J.9r().ob+" </2F>");K $a=$(\'<a 2B="qb-ui-4D-4F-1W-y8" 5c="#">\'+il.3T+"</a>");$3y.3a($a);$3y.3a($("<2F> "+J.9r().iO+"</2F>"));J.1f.3a($3y);K $4n=$(\'<2E 2B="qb-ui-4D-4F-4n \'+il.hw+\'">\');$.2h(J.2P,1a(1P,1g){$4n.3a(1g.7B())});K u7=1S QB.1d.uc(J);$4n.3a(u7.7B());J.1f.3a($4n);1b J.1f},hF:1a(){K 1N=1S QB.1d.2d.xZ;1N.8Z=J.8Z;1N.2P=[];$.2h(J.2P,1a(1P,1g){1N.2P.1C(1g.hF())});1b 1N},5Y:1a(1Z){QB.1d.2m.4c.7u=J.hF();QB.1d.2m.5Y(1Z)},7Q:1a(1Z){QB.1d.2m.4c.7u=1c;QB.1d.2m.5Y(1Z)},bB:1a(1L){J.2p=$("#qb-ui-4D-4F");if(J.2p.1e){if(!1K(J.2p.1k("iO"))){J.iO=J.2p.1k("iO")}if(!1K(J.2p.1k("ob"))){J.ob=J.2p.1k("ob")}if(!1K(J.2p.1k("oi"))){J.oi=J.2p.1k("oi").3N()=="1n"}}J.1L(1c);J.y0();J.Ik();J.I1();J.NE();J.Lo()}});QB.1d.7u.2l={Dp:"Dp",DT:"DT"};K 5M=4;K ML=1n;K t5="o9/";K C7="1.11.0";K IX="1.99.99";K B7="1.11.0";K IT="1.99.99";K IE="yj tM GN.js is 5X ai.";K BC="2v Cm is 5X 8y.";K IU="tH Cm is 5X 8y.";K IW="CJ 2v 5M v.$1 D7! 2v v.$2 or D6 2s 1.XX D2 is D4.";K Nf="CJ tH 5M v.$1 D7! tH v.$2 or D6 2s 1.XX D2 is D4.";K MX=\'Op Oh tJ cg. 2v o8 tH Of be ai yk tJ iQ "GN.js"\';K GH=\'Oa o9 QT is QY. FL fd FM "QW.6B" QP.\';K lT=1j;K 5I=1a(){J.3Z=1c;J.vx=1c;J.1V=1c;J.3R=1c;J.4T=[];J.dS={};J.5J=[];J.7N=1c;J.sX=1c;J.lZ=1j;J.3f=1c;J.hc=1c;J.cJ="";J.9b={};J.hN=1c;J.9q=1c;J.7u=1c;J.wV=1c;J.nO=1j;J.a6=0;J.tY=1n;J.sV=1a(9e){K sd=QB.1d.2m.gO[9e];if(!1K(sd)){J.uv(1c,sd.2f);J.ux(1c,sd.2W)}QB.1d.2m.ek=9e};J.rX=1a(47){K me=J;if(47.ck=="G5-G2-QZ"){J.sV(47.3f)}if(QB.1d.2m.ex){6x(1a(){me.rX(47)},50);1b}QB.1d.2m.4c.wT.1C(47);QB.1d.2m.5Y()};J.Ip=1a(e,1W){K 1N=1W.1N();if(1W.7L){QB.1d.2f.72.3u(1W)}QB.1d.2m.ET(1N);QB.1d.2m.5Y()};J.vU=1a(e,1h){K 47=1h.47;K 1g=1h.1g;QB.1d.2m.4c.fK.cu=47;QB.1d.2m.4c.fK.fD=1g.1h;QB.1d.2m.4c.fK.EZ="1V";QB.1d.2m.5Y()};J.wR=1a(e,1x){K 1M=1x.1M;K 2j=1x.2j;K 8X=1x.8X;K xD=QB.1d.2f.xB(1M.x7);if(xD==1c){$.2h(1M.5A,1a(i,f){if(fW(f.88,2j.88)){f.eJ=1n}});K 1x={1D:1M,8X:8X};J.l7(e,1x)}1i{xD.6j("iJ",2j.88,1n,1n)}};J.l7=1a(e,1x){1x.1D.6J=1n;K 1u=J.cv(1x);K 9k=1x.1D;if(1x.8X&&1x.8X.1e>=2){9k.X=1x.8X[0];9k.Y=1x.8X[1]}K 5c=$(1u).1h("me");if(5c!=1c){9k.66=5c.66}if(J.1V!=1c){J.1V.2c(QB.1d.2f.2l.xA,1u)}QB.1d.2m.EO(9k);QB.1d.2m.hn()};J.vC=1a(e,1h){K 1u=$(1h);K 9k=1u.1h("4s");QB.1d.2m.EL(9k);QB.1d.2m.hn()};J.Kt=1a(e,1h){QB.1d.2m.sS([1h.1I.1N()]);QB.1d.2m.hn()};J.KS=1a(e,1h){K 5a=1h.5a;QB.1d.2m.sS([5a]);QB.1d.2m.hn()};J.Fm=1a(1M,2j){K 3h="";3h+=!1K(1M.ki)?1M.ki:1M.3T;3h+="."+2j.88;1b 3h};J.xr=1a(e,1h){QB.1d.2m.F1(1h);QB.1d.2m.5Y()};J.xt=1a(e,1W){K 8s=QB.1d.2f.xB(1W.xH);if(8s!=1c){K $1V=$("#qb-ui-1V");if(8s[0].8p<$1V.4S()||(8s[0].9h<$1V.58()||(8s[0].8p+8s.1r()>$1V.4S()+$1V.1r()||8s[0].9h+8s.1y()>$1V.58()+$1V.1y()))){K x=8s[0].8p+8s.1r()/ 2 - $1V.1r() /2;K y=8s[0].9h+8s.1y()/ 2 - $1V.1y() /2;$1V.4K({4S:x,58:y},kO)}8s.2D(".qb-ui-1M-bd").Fe("sg",{},ss).Fe("sg",{},ss);1b}K 1x=1c;if(1W.jb==1c){1x={1D:{3f:1W.xH,6A:1W.6A,bR:1W}}}1i{1W.jb.bR=1W;1x={1D:1W.jb}}J.l7(1c,1x)};J.xx=1a(e,d){K 5h=d.5h;K 2V=[];1o(K i=0;i<5h.1e;i++){K 1h=5h[i];K 3B=1h.3B;K 3h=J.Fm(1h.1L,1h.1D);K si=J.3R.8A("su",3h);1o(K j=0;j<si.1e;j++){K 1I=si[j];if(3B){if(1I.fd(3B)){2V.1C(1I.1N())}}1i{if(1I.F3()){if(1I.fd(3B)){2V.1C(1I.1N())}}1i{2V.1C(1I.1N());J.3R.8A("hO",1I)}}}if(3B&&si.1e==0){K rL=1S QB.1d.2d.xl;rL.8P=3h;rL.bH=3B;K Hn=J.3R.8A("jI",rL);2V.1C(Hn.1N())}}};J.cv=1a(1x,5V){K 1u=QB.1d.2f.cv(1x,5V);if(5V===2O||5V==1c){1u.4N(QB.1d.78.2l.kt,J.xx,J);1u.4N(QB.1d.78.2l.kA,J.xr,J);1u.4N(QB.1d.78.2l.kD,J.xt,J);1u.4N(QB.1d.78.2l.kz,J.k2,J)}J.3R.8A("kN");1b 1u};J.gZ=1a(1x,5V,h2){K 1u=QB.1d.2f.gZ(1x,5V,h2);J.3R.8A("kN");1b 1u};J.tp=1a(1u){};J.kJ=1a(){QB.1d.2m.4c.gV.1C("kJ");J.xu();J.uF();QB.1d.2m.5Y()};J.LA=1a(){QB.1d.2m.4c.gV.1C("kJ");J.xu();QB.1d.2m.zL(1c);QB.1d.2m.5Y()};J.xu=1a(){QB.1d.2m.4c.7e=1S QB.1d.2d.kE;QB.1d.2m.4c.7e.cu="4u"};J.Ir=1a(){J.tY=1n;J.KV()};J.uF=1a(){K bN=1c;if(J.a9!=1c&&(J.a9.1e>0&&J.a9.is(":6K"))){bN=J.a9.2g()}1i{bN=J.sX}J.7N=bN;QB.1d.2m.zL(J.7N);1b 1n};J.Hb=1a(){QB.1d.2m.4c.9q=J.9q;1b 1n};J.u0=1a(1Y){J.9H.4f("9j 96");J.9H.2t("tC");J.9H.3X(1Y)};J.R3=1a(1Y){J.9H.4f("96 tC");J.9H.2t("9j");J.9H.3X(1Y)};J.Qv=1a(1Y){J.9H.4f("9j tC");J.9H.2t("96");J.9H.3X(1Y)};J.KI=1a(){if(J.tY){if(QB.1d.2m.j6!=J.a9.2g()){J.u0(QB.1d.2d.5b.5r.HK);QB.1d.2m.j6=J.a9.2g()}}};J.HZ=1a(e,1D){K 1x={1D:1D};J.l7(1c,1x)};J.k2=1a(e,9e){K me=J;if(QB.1d.2m.ex){6x(1a(){me.k2(e,9e)},50);1b}if(!1K(9e)){J.sV(9e);QB.1d.2m.4c.ek=9e;QB.1d.2m.5Y()}};J.HS=1a(e,47){QB.1d.5I.rX(47)};J.JG=1a(e,1h){J.3Z.iZ(1h)};J.CE=1a(4T){if(4T==1c){1b 1j}if(4T.1e==0){1b 1j}QB.1d.2f.72.zQ();1o(K 1P=0;1P<4T.1e;1P++){K 9G=4T[1P];K d0=1c;if(9G.4W!=1c&&9G.4V!=1c){d0=QB.1d.2f.72.zH(9G.4W.aV,9G.4V.aV)}if(d0==1c){QB.1d.2f.72.s3(9G)}1i{d0.s0=1j;QB.1d.2f.72.zA(d0,9G)}}QB.1d.2f.72.zE()};J.Dg=1a(i0){if(i0==1c){1b}K 8T=i0.3H();K iF=[];K iD=[];K iz=[];K me=J;1o(K i=QB.1d.2f.5J.1e-1;i>=0;i--){K 1u=QB.1d.2f.5J[i];K j4=1u.1h("1D");K cP=1c;1o(K j=8T.1e-1;j>=0;j--){K 8c=8T[j];if(QB.1d.2f.Ab(j4,8c)){8T.3u(j);cP=8c;1p}}if(cP==1c){1o(K j=8T.1e-1;j>=0;j--){K 8c=8T[j];if(QB.1d.2f.Ac(j4,8c)){8T.3u(j);cP=8c;1p}}}if(cP!=1c){iD.1C({1N:8c,5V:1u})}1i{iF.1C(1u)}}$.2h(8T,1a(1P,8c){iz.1C(8c)});$.2h(iD,1a(1P,1u){me.gZ({1D:1u.1N},1u.5V,1n)});$.2h(iF,1a(1P,1u){QB.1d.2f.tp(1u,1n)});$.2h(iz,1a(1P,1u){me.cv({1D:1u})})};J.uv=1a(e,1V){J.Dg(1V.hD);J.CE(1V.72);if(1V.sI!=1c){QB.1d.2f.Ec(1V.sI.dp)}if($("#qb-ui-1V").is(":6K")){QB.1d.2f.dq()}};J.JC=1a(e,9E){if(J.9E!=1c){J.9E.Ee(9E)}};J.K8=1a(e,cC){K me=J;if(1K(cC)){1b}J.hN=cC;if(J.hc!=1c){J.hc.wk(J.hN)}if(J.9E!=1c){J.9E.E8(J.hN)}};J.JY=1a(e,1T){if(J.2f!=1c){J.2f.g0(1T.2f);J.2f.DZ(1T.E0);J.2f.E3(1T.cb)}J.3R.8A("g0",1T.2W);J.g0(1T.Ew,"#qb-ui-1V-dO-lJ-3C");J.g0(1T.fA,"#qb-ui-1V-fI-lJ-3C")};J.JQ=1a(e,sK){if(sK==1c){1b}K me=J;K sF=0;if(J.a7.1e>0){sF=J.a7[J.a7.1e-1].Id}1o(K 1P=0;1P<sK.2P.1e;1P++){K c9=sK.2P[1P];if(sF==1c||c9.Id>sF){J.a7.1C(c9);K yQ="RY";if(c9.4B==2){yQ="RR"}if(c9.4B==3){yQ="9n"}K Ro=sC(c9.zl).6v("H:i:s")}}};J.ux=1a(e,3R){if(3R==1c||3R.c7==1c){1b}K me=J;me.3R.8A("Ev",3R);me.3R.8A("CQ")};J.K0=1a(e,bN){if(bN!==" "&&1K(bN)){1b}J.a9.2g(bN);J.sX=bN;J.j6=bN};J.Js=1a(e,9r){if(1K(9r)){1b}if(J.7u==1c){1b}J.7u.iZ(9r)};J.Rw=1a(1Z){J.uS(1a(1h){if(1Z&&7I(1Z)=="1a"){1Z(1h.fG)}})};J.RA=1a(1v,1Z){QB.1d.2m.4c.fG=1v;1b QB.1d.2m.sQ(1Z)};J.M8=1a(Mb,Ma){};J.vX=1a(e,1h){K 1I=1h.1I;K 1q=1h.1q;K 5x=1h.5x;K 4g=1h.4g;K 2V=[];K 5a=1I.1N();if(1I.7L){K 3h=5a.8P;if(!1K(3h)&&3h.4Y(".")!=-1){K 8q=3h.71(0,3h.4Y("."));K 9y=3h.71(3h.4Y(".")+1);K 1M=QB.1d.2f.lE(8q);if(1M!=1c){1M.6j("iJ",9y,1j)}}}3r(1q){1l 1R.2i.1Q:K 3h=5a.8P;if(!1K(3h)&&3h.4Y(".")!=-1){K 8q=3h.71(0,3h.4Y("."));K 9y=3h.71(3h.4Y(".")+1);K 1M=QB.1d.2f.lE(8q);if(1M!=1c){1M.6j("iJ",9y,4g)}}2V.1C(5a);1p;1l 1R.2i.3h:K 1Q=5a.bH;if(1K(5x)&&5x!=4g){1Q=1n;5a.bH=1n}K 3h=5x;if(!1K(3h)&&3h.4Y(".")!=-1){K 8q=3h.71(0,3h.4Y("."));K 9y=3h.71(3h.4Y(".")+1);K 1M=QB.1d.2f.lE(8q);if(1M!=1c){1M.6j("iJ",9y,1j)}}3h=4g;if(1Q&&(!1K(3h)&&3h.4Y(".")!=-1)){K 8q=3h.71(0,3h.4Y("."));K 9y=3h.71(3h.4Y(".")+1);K 1M=QB.1d.2f.lE(8q);if(1M!=1c){1M.6j("iJ",9y,1Q)}}2V.1C(5a);1p;1l 1R.2i.8K:;1l 1R.2i.6N:K z8=J.3R.8A("LY");1o(K i=0;i<z8.1e;i++){2V.1C(z8[i].1N())}1p;5o:2V.1C(5a)}QB.1d.2m.sS(2V);QB.1d.2m.5Y()};J.uE=1a(6U){if(6U==1c||6U.1e==0){1b 1c}K 1F={};K 4R;1o(K i=0;i<6U.1e;i++){4R=6U[i];if(4R.3T!=1c&&4R.3T.71(0,1)=="-"){1F[4R.ck]=4R.3T}1i{1F[4R.ck]={1z:4R.3T,3K:4R.ck,1F:J.uE(4R.2P),1h:4R.3f}}}1b 1F};J.g0=1a(1T,5t){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.uE(1T.2P);K $5t=$(5t);if($5t.1e>0){$5t[0].Me=0}$5t.3C().1k("Me",0).7V(1a(e){if(e.3F==13||e.3F==32){$(e.3k).2c("3J")}});$.2L("6d",5t);$.2L({3S:5t,4o:cf,6O:{6S:0},1Z:1a(47,1x){K 1g=1c;7n{1g=1x.$1Q.1h().2L.1F[47]}7p(e){}6x(1a(){me.vU(J,{47:47,1g:1g})},0)},1F:1F});$5t.3J(1a(){$(5t).2L();$1T=$(5t).2L("1f");if($1T){$1T.2J({my:"2a 1O",at:"2a 4I",of:J})}})};J.Pi=1a(1Z){if(J.7u.hS()){J.7u.5Y(1Z);1b 1n}1i{1b 1j}};J.L5=1a(1Z){QB.1d.2m.5Y(1Z)};J.Pp=1a(1Z){J.sV(QB.1d.2m.ij);QB.1d.2m.4c.ek=QB.1d.2m.ij;QB.1d.2m.5Y(1Z)};J.Pu=1a(1Z){QB.1d.2m.4c.7u=1c;QB.1d.2m.5Y(1Z)};J.w6=1a(1Z){J.uF();QB.1d.2m.5Y(1Z)};J.uS=1a(1Z){K me=J;if(J.a6<0){J.a6=0}if(J.a6>0){6x(1a(){me.uS(1Z)},100);1b}J.w6(1Z)};J.7Q=1a(1Z){QB.1d.2m.7Q(1Z)};J.ht=1a(1Z){QB.1d.2m.ht(1Z)};J.80=1a(){lT=!($(".lR").1k("lT")===2O);if(!lT){J.IM()}QB.1d.2m.bQ=$(".lR").1k("bQ");Lx=$(".lR").1k("Lv")=="1n";J.lZ=$(".lR").1k("lZ")=="1n";K ve=$(".lR").1k("ON");if(!1K(ve)){t5=ve}J.sH=$("#qb-ui-1V").4E("sH");K me=J;J.a7=[];J.ai=1j;if(!J.lZ){$.jR(t5+"?47=P0",t9,1a(1h){})}J.9H=$("#qb-ui-a9-P5-P4");J.3R=$("#qb-ui-3R").8A();J.2f=QB.1d.2f.80();J.1V=J.2f!=1c?J.2f.1V:1c;J.3Z=1S QB.1d.7e;J.hc=1c;J.9E=1c;if(ML){J.hc=1S QB.1d.lW;J.9E=1S QB.1d.9F}if(J.hc!=1c){J.Nb=J.hc.wk();J.Nb.4N(QB.1d.lW.2l.rZ,J.k2,J)}if(J.9E!=1c){J.9E.2Z.4N(QB.1d.9F.2l.rG,J.k2,J);J.9E.2Z.4N(QB.1d.9F.2l.sv,J.HS,J)}J.vx=J.3Z.HT();J.vx.4N(QB.1d.7e.2l.s6,J.HZ,J);J.a9=$("#qb-ui-a9 7W");J.a9.4N("w8",J.Ir,J);$("#qb-ui-a9-9t-jR").4N("3J",J.w6,J);$("#qb-ui-a9-9t-ht").4N("3J",1a(){QB.1d.2m.ht()},J);if(J.1V!=1c){J.1V.4N(QB.1d.2f.2l.s9,J.l7,J);J.1V.4N(QB.1d.2f.2l.sf,J.vC,J);J.1V.4N(QB.1d.2f.2l.sa,J.wR,J);J.1V.4N(QB.1d.2f.2l.sb,J.vU,J);$("#qb-ui-1V-7z").4N(QB.1d.2f.bR.2l.kR,J.Ip,J)}J.3R.4N(QB.1d.2W.2l.f7,J.vX,J);J.3R.4N(QB.1d.2W.2l.vY,J.Kt,J);J.3R.4N(QB.1d.2W.2l.vu,J.KS,J);J.3R.4N(QB.1d.2W.2l.tK,J.vC,J);J.3R.4N(QB.1d.2W.2l.tA,J.wR,J);J.KV=$.gQ(J.KI,kO,J);J.7u=1S QB.1d.7u;QB.1d.2m.cL.2C(QB.1d.2m.cL.2l.6z,J.JG,J);QB.1d.2m.9F.2C(QB.1d.2m.9F.2l.6z,J.JC,J);QB.1d.2m.2W.2C(QB.1d.2m.2W.2l.6z,J.ux,J);QB.1d.2m.2f.2C(QB.1d.2m.2f.2l.6z,J.uv,J);QB.1d.2m.7u.2C(QB.1d.2m.7u.2l.6z,J.Js,J);QB.1d.2m.2C(QB.1d.2m.2l.tz,J.K8,J);QB.1d.2m.2C(QB.1d.2m.2l.uk,J.JQ,J);QB.1d.2m.2C(QB.1d.2m.2l.u6,J.JY,J);QB.1d.2m.2C(QB.1d.2m.2l.ud,J.K0,J);QB.1d.2m.cL.2C(QB.1d.2m.2l.u8,1a(e,1h){J.u0(QB.1d.2d.5b.5r.JL)},J);QB.1d.2m.2C(QB.1d.2m.2l.6z,1a(e,1h){if(1K(1h)){1b}J.tY=1j;J.cJ=1h.cJ;if(!1K(1h.9q)){J.9q=1h.9q}if(!1K(1h.fG)){J.fG=1h.fG}if(!1K(1h.9b)){J.9b=1h.9b;if(!1K(1h.9b.Kd)&&!1h.9b.Kd){$("#qb-ui-1V-dO-lr-KF").3L()}if(!1K(1h.9b.KO)&&!1h.9b.KO){$("#qb-ui-1V-dO-Qb-KF").3L()}me.3R.8A("KH")}if(!1K(1h.hE)){J.hE=1h.hE}J.9H.4f("9j 96 tC");J.9H.2t(1h.jx.68);J.9H.3X("");J.9H.3X(1h.jx.9Q)},J);QB.1d.2m.cL.2C(QB.1d.2m.cL.2l.lh,1a(e,1h){K AD=$("#cX-7C",1L.2N.3U);if(AD.1e){AD.3L()}},J)};J.ec=1a(76){1b 63(76.3g(/(\\.|^)(\\d)(?=\\.|$)/g,"$10$2").3g(/(\\d+)\\.(?:(\\d+)\\.*)/,"$1.$2"))};J.IM=1a(){if(7I(IF)=="2O"){dL(IE)}if(!($&&($.fn&&$.fn.iB))){dL(BC)}if(!($&&($.fn&&$.fn.iB))){dL(BC)}1i{if(J.ec($.fn.iB)<J.ec(C7)||J.ec($.fn.iB)>J.ec(IX)){dL(IW.3g("$1",$.fn.iB).3g("$2",C7))}}if(!($&&($.ui&&$.ui.5M))){dL(IU)}1i{if(J.ec($.ui.5M)<J.ec(B7)||J.ec($.ui.5M)>J.ec(IT)){dL(Nf.3g("$1",$.ui.5M).3g("$2",B7))}}if($&&($.fn&&$.fn.iB)){if($.fn.cK===2O){dL(MX)}}}};QB.1d.P2={Nu:"Nu",NT:"NT"};if(!3Q.cp){3Q.cp={}}if(!3Q.cp.j3){3Q.cp.j3=1a(){}}if(!3Q.cp.Bs){3Q.cp.Bs=1a(){}}K nQ;K jq=1c;K sR=0;1a BZ(){if(sR==1c){sR=0}1b sR++}2v(2N).Rv(1a(){QB.1d.5I=1S 5I;QB.1d.5I.80();nQ=QB.1d.5I;LQ();nQ.LA()});$.ui.6P.2T.Rx=1a(1H,Dz){J.2J=J.Rp(1H);J.Ri=J.Rd("8t");if(J.1x.Ej){if(J.1x.5k){J.1x.5k()}}1i{if(!Dz){K ui=J.eV();if(J.7w("5k",1H,ui)===1j){J.RV({});1b 1j}J.2J=ui.2J}}if(!J.1x.rR||J.1x.rR!="y"){J.4w[0].3b.2a=J.2J.2a+"px"}if(!J.1x.rR||J.1x.rR!="x"){J.4w[0].3b.1O=J.2J.1O+"px"}if($.ui.gB){$.ui.gB.5k(J,1H)}1b 1j};',62,3863,'|||||||||||||||||||||||||||||||||||||||||||||this|var||||||||||||||||||||||||||function|return|null|Web|length|element|item|data|else|false|attr|case|value|true|for|break|key|width|node||obj|params|type|options|height|name|res|opt|push|object||items|path|event|row|result|isEmpty|parent|table|dto|top|index|selected|MetaData|new|menu|_|canvas|link|stroke|text|callback|||||||||fill|input|left|attrs|trigger|Dto|args|Canvas|val|each|FieldParamType|field|out|Events|Core|self|select|root|arguments|nbsp|from|addClass|paper|jQuery|call|disabled|offset||anim|class|bind|find|div|span|opacity|values|start|position|typeof|contextMenu|font|document|undefined|Items|option|eve|focus|prototype|Enum|rows|Grid|bbox|doc|control||css|||||||||append|style|apply|elproto|match|Guid|replace|expression|selectmenu|dialog|target|context|next|parentNode|has|none|split|switch|toString|color|remove|clr|math|concat|label|toFloat|transform|checked|button|Math|rgb|keyCode|appendChild|slice|array|click|icon|hide|Utils|toLowerCase|gradient|prev|window|grid|selector|Name|body|pos|settings|html|Str|tree||svg|delete|Array|method|while|raphael|action||container|abs|src|ExchangeObject|tableDnD|string|removeClass|newValue|preventDefault|arg|deg|rect|extend|Parent|hitarea|zIndex|filter|toFixed|appendTo|metaDataObject|events|get|matrix|helper|first|max|end|arrows|Type|_engine|criteria|hasClass|builder|round|join|bottom|Object|animate|list|handle|bindEx|blur|CLASSES|mmax|dtoItem|scrollLeft|links|constructor|Right|Left|animationElements|indexOf|state||box||newIndex|add||size|dots|scrollTop|show|rowDto|Localizer|href|removed|url|splice|contextmenu|fields|pathArray|win|drag|String|Date|separator|default|display|rotate|Strings|close|menuSelector|mouseup|set|aria|oldValue|p1x||Fields|stop|current|textControl|easing|diff|rowChanged|vml|Application|Objects|resizable|pow|version|Criteria|cells|column|min|clone|mdo|wrapper|Value1|existingObject|mmin|not|sendDataToServer|p1y||title|paperproto|Number|c1x|that|TempId|hex|Class|tabindex|uiDialog|len|tagName|destroy|newelement|c1y|KindOfField|clip|elem|qbtable|graphics|auto|minHeight|_editControl|all|parseInt|layer|point|CriteriaBuilderConditionOperator|Column|ConditionOperator|format|children|setTimeout|hover|DataReceived|Caption|config|att|editControl|count|getBBox|status|http|zoom|IsNew|visible|setproto|dot|sortingOrder|animation|draggable|open|pageX|duration|prop|menuItems|bbox2|__set__|bbox1|insertBefore|ValueKinds|Value2|substr|Links|last|c2y||str|c2x|TableObject|resize|block|now|implement|hidden|Tree|mousedown|lineCoord|names|pageY|guid|getValue|angle|p2y|try|removeChild|catch|p2x|crp|Operator|JoinType|CriteriaBuilder|subElement|_trigger|_g|Visible|graph|handler|buildElement|overlay|cell|firstChild|ValuesCount|pth|dragi|typeOf|dirty|cache|IsDeleted|right|SQL|checkbox|hasOwnProperty|update|currentTrigger|ret|operation|create|keydown|textarea|stopPropagation|unbind|newObject|init|keys|scale|command|family|containment|_optionLis|DrawOrder|NameStr|percents|header|currentTarget|newDatasourceDto|_ulwrapdiv|condition|skew|selectOptionData|path2|tmp|cellName|vector|pathString|destX|Alias|sin|offsetLeft|tableName|360|existing|absolute|setValue|selectDto|toUpperCase|radio|found|bez2|QBGrid|cos|toggleClass|bg_iframe|customAttributes|forEach|bez1|par|matches|buttons|sorting|tabbable|widget|timer|image|Expression|face|rad|nodeName|newObjects|caller|Index|1E3|coordinates|red|JunctionType||All|ctx|contextMenuRoot|matrixproto|jPag|error||dasharray||namespace|SyntaxProviderData|Function|currentLayout|unionSubQuery|_key|namespaces|offsetTop|maxHeight|warning|dataSource|touch|circle|Error|mooType|objectBorder|QueryProperties|criteriaBuilder|colour|controls|elements|proxy|throw|EditableSelectStatic|fieldName|toInt|build|SmartPush|wrapperId|trg|navBar|NavBar|linkDto|statusBar|selects|Element|weight|el2|sqrt|path1|amt|JunctionItemType|Text|dragObject|documentElement|mousemove|valueElement1|test|fit|green|meshY|corner|clear||||methods|blue|Lock|Messages|content|editor|isNaN|tstr|meshX|percent|hoveract|source|arrow|continue|loaded|clientX||expandable|||Condition|clientY|u2007||||x09|u2006|u2004|||u2005|u2008|u205f|u3000|u202f|u2009|u200a|u2003|u1680|u180e|xa0|x0d|x20|ellipse|x0a|u2002|u2001|x0c|x0b|outerHeight|_editBlock|cnvs|FieldGuid|navigator|con|u2000|tt1|alias|setAttribute|u2028|u2029|active|pathClone|cacher|_selectedOptionLi|tableDnDConfig|currentTable|offsetHeight||dialogId|titlebar||shift||Extends|selectedIndex|line|Raphael|Prefix|collapsable|inFocus|valueHTML|glow|markerCounter||charAt|current_value|getTotalLength|thisObject|fieldsContainer|||getPath|ele|initialize|editable|filteredUi|addArrow|instances|subkey|Select|group|icons|checkTrigger|addEventListener|getRGB|sql|className|counter|SessionID|Link|_value|aggregate|droppable|support|pattern|times|bot|groupingCriterion|eventName|||minWidth|token|SVG|180|Rows|createElement|msg||Table|previous|fillpos||6E3|order|getElementsByTagName|||Key|number|000|defaultWidth||console|createNode|DatasourceGuid|||Action|addObject|textpath|||shape|linecap|direction|queryStructure|parents|img|itemsPageSize|Postfix|toggle|empty|SyntaxProviderName|valEx|MetadataTree|Inner|stopImmediatePropagation|defaults|matchDatasourceDto|pop|xlink|_drag|Animation|optionDto|ids|tlen|iframe|RegExp|tt2|existingLink|originalEvent||defs|currentPage|parseFloat|linkBox|isInput|_viewBlock|alpha|rec|hasChanges|_events||getKeyName||cssClass|_cellEditEnd|||marker|tolerance|fonts|Outer||Active|redraw|change|editableSelectOverlay|grouping|filtredItems|JSON|Value1IsValid|||valueNumber|ActiveDatabaseSoftware|attrs2|nextIndex|move|down|titleBar|setFillAndStroke|listeners|fontSize|Server|getPrevTabbable|alert|property3|property2|navbar|docElem|property1|isEnd|dialogs|off|UnionSubQuery|SortType|easyeasy|offsetParent|instanceof|Aggregate|255|a_css|json|activeItem|sib|hover_css|to2|insertAfter|marked|results|mouseout|Matrix|versionToNumber|getDate|pathi||getElementById|myAt|valueElement2|isFunction|ActiveUnionSubQuery||||_parent|scaley||getTimezoneOffset||time|bgiframe||userAgent|wait|Cancel|linkedObject|defaultHeight|outerWidth|methodname|selectElement||scope|round1000|inver|_moveFocus|IsSelected|scrollX|properties|getNextTabbable|scrollY|tableBox|CriteriaBuilderItemType|map|milli|Numeric|Not|filtered|_uiHash|justCount|_viewBox|overloadSetter|sort|origin|||Unknown|isURL|objectGuid|offsetWidth|GridOnRowChanged|keyStop|dirtyT|force|glyphs|translate|check|curve|200|animated|oldObj|precision|redrawT|cssText|oRec|getRec||delay|longclick|pRec|isResizable|attrType|Value2IsValid|handles|bb2|bb1|||tspan|Add|closest|updateElement|Data|guidHash|realPath|QueryParams|LinkExpression|subquery|intr|ContextMenu|maxWidth|onSelect|userEdit|getHours|setViewBox|computedStyle|simulateMouseEvent|isDropDown||scalex|classes|strcmp|with|substring|paths|updateContextMenu|thisLi|border|linejoin|isPointInside|thefont|fontcopy|vbs|Field|VisiblePaginationLinksCount|overflow|onload|tspans|u00ebl|attachEvent|pane|fillsize|asterisk||_global_timer_|Rapha|minContentHeight|collapsed|VML|dialogTarget|updateFields|visibility|ObjectType|objectType||enumerables|QBWebCoreBindable|instantEdit|base|globalFieldDragHelper|markedMeshCells|toJSON|ddmanager|subItem|jsp|markerId|floor|fillString|dstyle|use|pathId|Supported|itemsListIncomplete|bezlen|keypress|QueryStructureContainer|newClass|debounce|orColumnCount|branches|replaceClass|Grouping|Actions|list_is_visible|_typeAhead_chars|CriteriaBuilderJunctionItemType|updateObject|selecter|updateTable|skipEvents|strings|Delete|getFormat|lastCollapsable|shear|equal|role|indexed|prevItem|treeStructure|contains|cur|menus|current_event|eldata|recursive|optionClasses|_ul||lastExpandable|sendDataToServerDelayed|accesskeys|nextItem|touches|||reconnect|listWrap|mousePos|CssClass|||isInAnim|currentRow|dropdown|totalOrigin|DataSources|QueryTransformerSQL|getDto|iLen|__args|parentObject|from2|buffer|mouseover|path2curve|QueryStructure|removeRow|flip|newf|proto|isValid|treeview|getMonth|clientLeft|None|valueElement|TString|clientTop|dataSources|||isActive|triangle|appendElement|vals|inputLabel|Boolean|prepend|background|isOpen|Move||parentElement|||list_item||RootQuery|seg2|joinType|seg||glob|getButtonContextMenuItems|butt|queue|||removeAttr|toLower|random||DOMload|objectsToAdd|cancel|jquery|getListValue|objectsToUpdate|dj1|objectsToRemove|contentWidth|defaultView|nextSibling|checkField|which|di1|over|cursor|JunctionPostfix||the|dragMaxX|editEnd|Properties|rowId|replaceChars|_path2string|getSelectedListItem|destY|importData|percentScrolled|showEditor|hooks|log|canvasDatasourceDto|ceil|ClientSQL|textpathStyle|background_hover_color|9999em|fff|DataSource|coordorigin|background_color|text_color|wrongRow|skipEvent|text_hover_color|tryAddEmptyRow||Copy|draw|startString|define|titleBarText|updateRowControl|globalTempLink|valueA||rvml|valueB|_moveSelection|__pad|Message|strConversion|updateContextMenuItems|globalIndex|Filter|Set|runAnimation|Selects|initstatus|linkMenuCallback|appendBefore|addOrUpdateRow|GridRowCell|currentValue|letters|updateTabindex|repeat|margin|keyToUpdate|__getType|refresh|popup|selectable|newObj|activeID|activeClass|related|_availableAttrs|fltr|dto2|clearTimeout|onTreeStructureClick|1px|types|hook|metadata|dto1|sweep_flag|sub|safari|SortOrder|deleting|endString|stops|removeByIndex|mouseProto|touchHandled|NameInQuery|propSize||toggler|setSize|move_scope|obj1|original|parentOptGroup|menuWidth|configEnds|TableObjectOnCheckField|dis|bgImage|onDragClass|||TableObjectOnSubqueryClick|TableObjectOnLinkCreate|buttonLink|_typeAhead_cycling|TableObjectOnLinkedObjectSelected|ExchangeTreeDto|LinkedObjects|typeahead|_removedFactory|matchee|fullUpdate|_typeAhead_timer|AllowJoinTypeChanging|Direction|updateExpressionControl|500|clientWidth|optionsMarkColumnOptions|CanvasLinkOnChanged|optionsNameColumnOptions|minutes|hours|_removeGraph|swapClass|seconds|dirX|callbacks|dirY|||abortevent|Path|Height|relatedTarget|onAddTableToCanvas|layout|Width|itemHtml|itemsHtml|fieldsHtml|getPaddingLength|__def_precision|serverSideFilter|itemsCount|Loaded||Options|Value||mdoToTable|month|day|itemsPagePreload|mdoFromTable|union|getPaddingString||UpdateGuids|isAlternate|getString|_obj|initialized|arr|opts|selectedpage|prevComputedStyle|step|findTableByName|parentSelector|paneWidth|scrollAmount|yOffset|plus|collision|schema|nodes|showFields|setInterval|removeEventListener|onDragStart|QueryBuilderControl|boolean|suppressConfigurationWarning|reset|list_height|TreeStructure|scrollTimeout|mouseenter|DisableSessionKeeper|mouseleave|||||deltaX|selobj|Child|showList|deltaY|items_then_scroll|NameNotQuoted|_divwrapright|getFullYear||Yet|_position|findDotAtSegment|pcom|seglen|l2c|ValueKind|lowerCase|_13|_23|classic|_minHeight|nonContentHeight||touchMap|supportsTouch|maxZ|seg2len|||_setOption|tear|tdata|IsEqualTo|linear|CriteriaBuilderItem|Any|addGradientFill|x1m|ActiveQueryBuilder2|py2|Models|ActiveQueryBuilder|relative|solid|dim|validateValue|_pathToAbsolute|clipRect|brect|y1m|x2m|miterlimit|y2m|_vbSize|readyState|epsilon|timestamp|||notfirst|curr|fieldValue|rowItems|testRow|refX|CurrentEditCell|dragHandle|glyph|shiftKey|||_focusedOptionLi|arglen|GridRow|forValues|deleted|longClickContextMenu|stretch|createUUID|start_scope||updatePosition|invert|conditionOr1||||setAttributeNS||||www|onChange|_blur|innerHTML|groupColumns|showGrouping|getSubpath|getPointAtLength|Sorting|binded|bboxwt|mapPath|findDotsAtSegment|finite|px2|RightToLeft|fieldsTable|application|postprocessor|setCoords|_getBBox|toHex|PreviousItem|clrToString|numPerPage|contentW|_refreshValue|_disabled|||funcs|touchend|rem|DescriptionColumnOptions|rectPath|and|handlers|PrimaryKey|RootJunctionPrefix|touchstart|trim|touchmove||bod||ShowPrefixes|setDto|hsb2rgb|400|subpaths||_isOpen||scroll||GetPropertyDialog|getColor|paramCounts|_createTitleButton||obj2|thisArg|strong|dif|pathDimensions|clientHeight|hits|query|hovering|getPointAtSegmentLength|optGroupName|o2t|ShowPropertyDialog|needFilter||ItemsCount|oldRaphael|_safemouseup|_fired_|getBoxToParent|dragMove|itemsArray|zin|selectors|itemdata|retainFocus|hideshow|dragUp|lastExpandableHitarea|lastCollapsableHitarea|||||xi1|tail|thisAAttr|collector|elementFromPoint||yi1|filterRegExp|subpath|initWin|toColour|del|needInvoke||||availableAnimAttrs|||_selectedIndex||recIndex|frame||_mouseInit|flag|line_spacing|letter_spacing|||coordsize|lineHeight|localIndex|transformPath|getKey|timeout|lastI|renderfix|isType|getLengthFactory|normal|isInAnimSet|parse|o1t|getPrecision|instanceOf|delta|upto255|nes|positionDefault|insidewidth|mdoTo|fontName|mdoFrom|getSubpathsAtLength|currIndex|globalMenu|currentContext|ymin|getPosition|pickListItem|typeMismatch|commaSpaces|oldt|_outer|protected|thumbs_mouse_interval|xmin||rowY|rowHeight|oval|rx2|are|ry2|diamond|curChar|ver|returnStr|getDay|ie7|checkScroll|dots1|clrs|selectOptions|mouseOffset|dots2|usePlural|overlays|OnApplicationReadyHandlers|||sleep|radial|clearInterval|hideList|leftcol|dragObj|interHelper|interPathHelper|rightcol|oldY|001|browser|getComputedStyle|hsl2rgb|klass|_name|bit|_top|Remove|_left|Event|docum|asin|fun|targetTouches|nextcommand|The|identifier|idx|oldGuid|end_scope|updateGuidHash|org|ActiveXObject|f_in|f_out|commands|denominator|norm|||getMatchItems|selectListItem||selectmenuId|regex|dontEnums|propertyIsEnumerable|instance|1e12|wrappers|droppedRow||bbx|inputs|parseTransformString|delayedSend|itemMouseleave|itemMouseenter|location|||altKey|_path2curve|total|parameters|POST|visibleMenu|5E3|NavBarBreadCrumbSelectNode|optionsTypeColumnOptions|autoOpen|optionsDescriptionColumnOptions|cursorWait|gridItemDto|HideColumnDescription|collspan|DenyLinkManipulations|newShowGrouping|_cellEditStart|axis|NameStrNotQuoted|Description|UseLongDescription|sortBy|srcAlias|DoAction|fieldCheckbox|TreeStructureSelectNode|ToDelete|||CreateLink|parentTable|filterChangeRoutine|TreeDoubleClickNode|HideColumnName|HideColumnMark|CanvasOnAddTable|CanvasOnAddTableField|CanvasContextMenuCommand|than|structureItem||CanvasOnRemoveTable|highlight|TypeColumnOptions|gridRows|buttonSubquery|Output|HideColumnType|small|CriteriaItem|||Disabled||800||findRowsByExpression|NavBarAction||||scrollHeight||cellNameKey|eval|editableSelectControl|margins|lastId|onFieldCheck|DisableLinkedObjectsButton|Layout|dragging|messages|1E5|resizeT|_blockFrames|||sendDataToServerWithLock|GlobalTempId|updateGridRows|iframeBlocks|TableObjectOnMoved|ChangeActiveUnionSubquery|TableObjectOnDestroy|hiddenSQL|TableObjectOnClose|objectOptions|||||cellspacing|QBHandlers|QuickFilterInExpressionMatchFromBeginning|hoverClass|cellpadding|300||rowIsEmpty|iconClass||disable|onDrop|_create||isEqual|generateEvent|GetUID|doNotGenerateEvent|removeData|GridRowCellOnChanged||removeObject|||blockFocus||parentGuid|GroupingCriterion|_importDto|buildItems|contextMenuCallback|QueryStructureChanged|GridOnAddTableField|enter|information|Columns|mouse|datepicker|ShowLoadingItems|jQueryUI|contentHeight|loading|GridOnAddTable|invalid|module|contentPositionX|general|getJoinPrefix|paginate|conditions|parentItem|itemIndex|scrollToY|NotAll|getButtonContextMenuItemsMove|Group|editorChangesEnabled|ConditionIsValid|MessageInfo|fillDto|CriteriaBuilderItemGroup|TypedObject|positionDragX|Loading|ContextMenuReceived|plusButton|DataSending|itemsElement|positionDragY|fillSelects|CriteriaBuilderItemPlus|SQLReceived|ItemsStart|scrollToX|fillDtoItems|after||primary|MessagesReceived||ascending||square||rgbtoString|selectedOptions|_ISURL|_preload|addOption|importCanvas|strokeColor|importGrid|checkAllField|GetWrapper|cookie|editStart|newField|_getPath|generateContextMenuItems|prepareSyncSQL|toggleCallback|selectNewListItem|newpath|clearSelectedListItem|exclude|cookieId|UpdateValues|needResize|newFieldsCount|stored|_tear|checkedFields|refreshSqlWithLock|borderLeftWidth|li_text|borderTopWidth|list_item_height|menuChildren|inited|_parseDots|pairs|align|center|dirtyattrs|anchor|newstroke|_radial_gradient|li_value|selectFirstListItem|isGrad|isSimple||u2026|_extractTransform|handlersPath|moveToTop|EditableSelect|bbt|_escapeable|heightBeforeDrag|_oid|fxfy|dragStop|quoteString|dragStart|raphaelid|domElement|andSelf|relativeRec|built|GridOnRemoveRow|contextMenuKey|shortLeg|treeControl|calculateBox|getBoundingClientRect|contextMenuActive|AriaLabel|onRemoveObjectFromCanvas|param|_init|was|dblclick|QueryGuid|paneHeight|ownerDocument|contentPositionY|Close|submenu|structure|GUID|bindItemsEvents|secondary|noop|buildElements||onCanvasContextMenuCommand|nodeCount|load|onGridRowChanged|GridOnAddRow|endD|thin|accesskey|startD||OnApplicationReadyFlag|endType|refreshSql|startType|keyup|topOffset|buttonClose|prepareBranches|FieldListSortType|LongDescription|ShortDescription|_rectPath|applyClasses|HideAsteriskItem|cssDot|KeyFieldsFirst|buildTree|TableObjectField|scrollBy|_insertafter|_toback|_grid|_tofront|detachEvent|contextMenuAutoHide|_insertbefore|scrollByX|scrollByY|FieldListOptions|static|busy|expandableHitarea|fixed|600|disableSelection|buttonProperties|collapsableHitarea|intersect|prevcommand|closed|_params|com|thatMethod|contentH|titleW|_Paper|modal|_getContainer|component|onAddTableFieldToCanvas|getEventPosition|Actions1|oldstop|SqlErrorEventArgs|wildcard|subname|onstart|onmove|onend|||||does|scope_in|MetadataGuid|factory|IsInList|toMatrix|CriteriaBuilderItemDto|fixM|prevIndex|IsNotInList|touchcancel|mag|normalize|getEmpty|pathToRelative|fromCharCode|GridRowDto|_toggle|istotal|x_y_w_h|offsetx|offsety|onLinkCreate||onLinkedObjectSelected|prepareSyncMetadata|amp|newelementWrap|onCheckFieldInTable||CriteriaType|MetadataObjectAdded|findTableByDataSourceGuid|conditionOr|tableObj|_refreshPosition|newOptionClasses|isBBoxIntersect|MetadataObjectGuid|_scrollPage|opera|optgroup|_toggleEnabled|bezierBBox|setColumn|actionAddItem|xbase|ybase|sum|page|Clear|CriteriaBuilderItemGroupDto|isArray|Paper|cross|newwin|CriteriaBuilderDto|buildControlItems|||||getJunctionItemType|packageRGB|prepareRGB|junctionType|t12|atan2|base3|fieldContextMenuCallback|pathValues|t13|newres|curveDim|operator|_120|JavaScript|before|q2c|processPath|fixArc|pathToAbsolute|a2c|CriteriaBuilderItemRow|getOperatorObject||CriteriaBuilderItemGeneralDto|General|rel|isPointInsideBBox|xmax|ymax|catmullRom2bezier|crz|ellipsePath|parsePathString|CriteriaBuilderItemGeneral|upperCase|eventType|docPos|blank|getMouseOffset|NONE|viewBlock|dashes|lastReturn|getAttribute|setup|makeDraggable|msgType|addDashes|currentSorting|_fy|dir|movingDown|draggedRow|rgba|_fx|global|_switchToView|needUpdate||_createEditBlock|xb0|mouseCoords|clmz|highlightSelected|allRows|Microsoft|progid|_size|_makeDraggable|listIsVisible|running|_makeResizable|adjustWrapper|compensation|_unblockFrames|editableSelectInstances|editableSelect|DateTime|texts|leading|getControl|isFloating|createTextNode|desc|middle|TableObjectOnUpdated|dispatchEvent|newAnim|srcExpression|findRowsByDto|sampleCurveX|_reCreateEditBlock|UpdateLink|rowToDelete|csv|emptyRow|removeAllMarked|pathes|extractTransform|getByGuid|ease|back|winH|updateSQL|_typeAhead|maxH|nogo|presentation|markAllForDelete|UpdateWrapper|tableValue|newRows|srcAggregate|onCellChanged|shifty|ConditionType|units|per|isLoaded|serialize|nodrop|serializeTable|serializeRegexp|every|prependTo|GridRowOnChanged|hasEmpty|Widget|thisLiAttr|dtoIsEqual|dtoIsSimilar|drop|accept|todel|requestAnimFrame|paused|stopAnimation|freeY2|fieldIcon|freeY1|freeX1|freeX2|annul|hexToRgb|_click_|getNextEmptyPlaceRoutine_Test|Title|LastItemId|horizontalDragPosition|MAX_CAPTION_LENGTH|success|__repr|lower|Database|trimCaption|Schema|View|iFrameOverlay|triggerEvents|DisableLinkPropertiesDialog|brackets|called|pass|DisableDatasourcePropertiesDialog|createButton|breadcrumbClick||periodical|DisableQueryPropertiesDialog|optionsHtml|SelectAllRowsFrom|rgbToHex|acces|FieldTypeName|allEvents|scrollWidth|regexp|bound|schedule|childButton|propertyName|VisiblePaginationLinksCountAttr|testWidth|UpdateObjects|cloneOf|LinkPart|applystyle|jQueryUIMinVersion|forGroup|test_interval|extended|border_color|database|currval|_rotright|mHide|_rotleft|doScroll|GetFullFieldName|outsidewidth|border_hover_color|mergeOne|centercol|isFirst|0000|cRec|generic|ajax|debug|toExponential|150|hooksOf|optionsFixedColumnMode|generateNavBarContextMenuItems||invokeAsap|SQLError|4E3|errNoJQ|outsidewidth_tmp|UserDataReceived|protect|SQLUpdatedServerFlag|Checked|SQLChanged|applyFilter|merge|descriptionHtml|fieldElement|MarkColumnOptions|parentOffset|simulatedEvent|prototyping|_touchMoved|spanField|SelectOptionDto|LoadDataByFilter|currentSelect|parts|selectsDto|Metadata|GetTempId|images|__arg|FixedColumnMode|New|loadingItemsOverlay|targetId|toLocaleString|jQueryMinVersion|filtredItemsCount|throttle|buildBreadcrumbElements|NameColumnOptions|Mutators|srcUrl|setRequestHeader|linkNode|tan|UID|updateTables|screenY|some|isAsterisk|library|methodName|wrap|2000|ItemsPerPage|Refresh|TableObjectOnLinkDelete|objNotationRegex|pathBBox|Editor|quotedName|isFunc|quote|fireEvent|need|f2old|Query|retain|importCanvasLinks|y2old|owner|formatrg|tableId|Incorrect|LEFT|DOWN|Synonyms|createSVGMatrix|aspectRatio|preserveAspectRatio|updateExpression|createEvent|RIGHT|Tables|HOME|glowConfig|you|Views|Procedures|DXImageTransform|shape2|initObject|branch|_exportDto|required|Int32|higher|detected|serializeTables|screenX|getFont|PreloadedPagesCount|fillDefaultValues|GetLinkExpression|initMouseEvent|TableObjectOnCreate|importCanvasObjects|createRowControl|PAGE_UP|tokenRegex|LinkPropertiesForm|tuneText|compatMode|needLoadItems|vis|CriteriaBuilderItemAdded|destLeft|You|cssrule|_getCssClass|rest|markers|startMarker|||noPropagation|Common|getPropertyValue|Invalid|windowHeight|innerHeight|ASC|arrowScroll|aliases|attempt|nodeValue|Enclose|_getDto|DataSourceLinkDto|TryLoadItems|_setDto|able|startdx|500px|createGraph|CriteriaBuilderChanged|enddx|_switchToEdit|Marker|press|will|updateLinkContextMenu|CanvasLink|operatorText|onAllowDrop|updateTableContextMenu|AggregateList|clean|findDropTargetRow|showDescriptions|updateBreadcrumb|include|x2old|replacer|setLayout|collection|updateUnionControls|onDropStyle|flatten|escapeHTML|operatorObj|fastDrag|edit|onDragStyle|_createViewBlock|LoadDataByPager|view|startPath|endPath|endMarker|DataSourceType|Reconnect|Content|importDto|CTE|suppressEnter|cannot|large_arc_flag|SubQuery|_createEditControl|PAGE_DOWN|getter|activedescendant|unmousemove|DataSourceLinkPartDto|StartsWith|findRowByExpression|about|CriteriaOr|removeDataSource|currentOptionClasses|unmouseup|addDataSource|DoesNotEndWith|positionOptions|DoesNotContain|layerY|updateLink|numsort|Contains|post_error|layerX|DoesNotStartWith|ActiveMenu|EndsWith|addLink|QueryPropertiesForm|hasAggregateOrCriteria|nodeType|isPointInsidePath|filterChangeStub|isWithoutTransform|actionMoveUp|getRowHeaderList|_formatText|description|escapeHtml|getTatLen|effect|canvasMenuCallback|CopyInner|pageYOffset|getElementByPoint|getOffset|isNumeric|propertyValue|getTableFieldExpression|enable|IntoControls|getById|Line|filterClear|rightGuid|IsBetween|removeByTableGuid|acos|1e9|IsGreaterThanOrEqualTo|TotalCount|greater|exports|shorter|itemId|updateFilter|Infinity|IsNotBetween|findByTableGuid|maxlength|DocumentTouch|createFromDto|Url|Please|your|filterChangeRoutineT|leftGuid|detacher|IsNotNull|addEvent|stopTouch|_f|IsLessThan|IsNotEqualTo|Errors|scope_out|IsNull|TreeSelectNode|error_alert|vendor|Union|Inc|CanvasOnDropObject|UnionNavBar|IsGreaterThan|IsLessThanOrEqualTo|olde|preventTouch|less|Arial|redrawD|typeCheck|real|thisA|_positionDragX|fired|toPath|equaliseTransform|easing_formulas|between|bezierrg|actionClear|methodsEnumerable|actionAddGeneral|sortByNumber|onObjectClose|objGuid|solve|getLayout|fieldGuid|findRowByDto|getLastRowControl|UnionNavBarVisible|availableAttrs|onObjectDestroy|optionValue|CubicBezierAtTime|ENTER|targetPlace|END|CreateConnection|errHandlersConfiguration|CriteriaBuilderItemRowDto|UpdateConnection|isFinite|animateWith|filterChange|usr_vXXX|responseText|oldIndex|lastIndexOf|actionAddGroup|pipe|Time|whitespace|SPACE|pause|resume|TAB|tableDragConfig|selection|objX2|objX1|thisText|70158|fieldType|075|refreshTimeout|isEnumerable|backIn|code|prepareSyncQueryProperties|actionMoveDown|generateHeaders|toggleGroupColumn|rowSorter|onlystart|selectelement|_closeOthers|typeAhead|objY2|objY1|reCreateEditBlock|newRow|fieldSelect|fieldDescription|itemDto|getNextEmptyPlaceRoutine_Find|getEmptyPlaceCoord|fieldText|getNextEmptyPlaceRoutine_Fill|getNextEmptyPlaceRoutine_Find_RTL|hasIcon|FieldCount|DataSourceLayoutDto|solveCurveX|TABLE|TableObjectFieldOnCheckField|getObjectByGuid|handleWidth|getObjectFieldByGuid|listH|backOut|actionDelete|onRowChanged|selectmenuIcon|SqlChanged|getObjectHeader|Now|updateSortingOrderColumn|sendDataToServerDelayedWrapper|toType|complete|focusInput|onNavBarAction|buildNewTree|QBWebCanvasLink|000000|aks|fromType|__formatToken|onTreeDoubleClick|1252|createFieldSelect|eventSelectstart|updateLinkObjectsMenu|menuItem|triggerObject|rightBox|hasTypes|blurInput|clearSync|getLineCoord|leftBox|getHTTPObject||QBWebCoreNavBar|getInactiveItems|getActiveItem|QBWebCoreCriteriaBuilder|QBWebCoreGrid|QBWebCoreCanvas|createButtonMenu|XMLHttpRequest|selectsParent|Incompatible|isCurrentQuery|onCanvasLinkChanged|flush|onEditorChange|autoHide|thinBg|01|clearSyncDebounce|positionSubmenu|siblings|QBWebCoreMetadataTree|zindex|delayed|sendDataToServerInternal|uiQBTableClasses|menuMouseenter|errNoScript|check_usr|DataSourcePropertiesForm|menuMouseleave|updateDataSource|hideMenu|QBWebCore|lastHeight|checkProjectConfigure|padding|inline|itemClick|adjustSize|For|microsoft|jQueryUIMaxVersion|errNoJQUI|342|errWrongJQ|jQueryMaxVersion|ObjectReadOnly|inputClick|512|collapseTable|minLeg|layerClick|3678|specified|splitAccesskey|5873|tabbableFirst|parentBox|qbtableClass|MultipleQueriesPerSession|tabbableLast|NeedRebindUserInit|callee|9816|parentId|classObject|odd|createLinkObjectsMenu|updateNavBarContextMenu|9041|7699|sepcified|__getInput|isEmptyObject|sel|stringify|importCriteriaBuilder|u00b0|selectedValues|setMonth|ShowLoadingSelect|hsrg|_meta|hsba|colourRegExp|removeOption|importNavBar|XMLHTTP|heightToggle|plusItem|importMetadata|heightHide|c1Elements|May|arguments2Array|Updating|prerendered|hsla|range|scrollToElement|importMessages|getSeconds|longMonths|HideLoadingItems|shortMonths|stickToTop|year|9999|importContextMenu|getMinutes|importSQL|shortDays|longDays|p2s|selectChange|repush|charCodeAt|hsbtoString|importQueryStructure|rgb2hsb|hsltoString|destPercentX|rgb2hsl|IsSupportUnions|maintain|determinePosition|getOperationContextMenuItems|IsChanged|tagValue|triggerIsFixed|getJunctionTypeContextMenuItems|createChildMenu|junctionTypeContextMenuCallback|hasDontEnumBug|pathCommand|operationContextMenuCallback|one|Clone|contextMenuShow|onGridRowAdded|GlobalUID|dragMaxY|TreeSelectDto|SelectedValue|tCommand|DeepCopy|SubQueries|dontEnumsLength|prevOffsetParent|treeController|cls|panel|proxyEx|updateAggregateColumn|onEditorChangeDebounced|deserialize|getTime|hsb|hsl|destPercentY|IsSupportCTE|__entityMap|16777216|isObject|onGridRowRemoved|isPrototypeOf|valueOf|onEditorChangeDebouncedCall|dynamicSort|subqueryPlusButton|Argument|getFieldsContextMenuItems|stepCallback|initEvents|ShowAllItemInGroupingSelectLists|EditableSelectWrapper|showAllItemInGroupingSelectLists|sync|scheduled|fontStyle|unselectListItem|fontWeight|scrollToListItem|fontFamily|objectToString|adj|originalPosition|originalSize|resizeHandles|duplicateOptions|buildPager|touch_enabled|elementParent|isnan|parentIndexId|Plus|createJunctionTypeMenu|_touchcancel_|helperProportions|_touchmove_|clearHighlightMatches|_touchend_|adjustHeight|trial|revert|QBTRIAL|buildSelects|fromMenu|updateOnLoad|Default|getMatchItemPrev|_mousemove_|Sort|_mousedown_|getMatchItemNext|_touchstart_||textContent|_contextmenu_|_mouseup_|_mouseout_|Your|adjustWrapperSize|lined|OnApplicationReadyTrigger|simulatedType|adjustWrapperPosition|dialogClass|changedTouches|nYou|Procedure|current_options_value|getAllRows|getInstance||lastJ||positionElements|ariaName|||setWidths|ajaxFinish|hideOtherLists|textStatus|jqXHR|bites|isMove|tabIndex|_touchEnd|isOval|path2vml|_touchStart|_touchMove|autoShow|_fn_click|resizeStart|newfill|resizeStop|resizing|ovalTypes|offsetPosition|wide|beforeclose|onTextboxChanged|medium|narrow|initInputEvents|pathTypes|Relations|long|short|Blur|Container|1601|showArrow|blurregexp|2032|tile|NotPrimaryKey|parentObj|SUBQUERY_ENABLED|2335|1069|recreateSelect|Tvalues|_divwrapleft|selectDataRefresh|reCreate|toFront|0472|hideArrow|carat|errWrongScriptOrder|toBack|AllFieldsSelected|blurItem|behavior|componentW|_viewBoxShift|hasScroll|titleText|schemas|From|urn|focusItem|xmlns|treeStructureElement|2491|generateFields|jspActive|errWrongJQUI|MetadataFieldDto|generateTitle|titleH|typeName|componentH|heightMax|titleButtonW|comb||spreviousclass|globalCount|setWindow|Where|saveScroll|sqlChanged|sprevious|previousclass|toFilter|vbt|uuidRegEx|ActionDto|bVer|isPatt|menuitem|createOperationMenu|uuidReplacer|noRotation|globalStart|localCount|def|snext|oldWidth|oldHeight|Cvalues|nextclass|htmlMenuitem|htmlCommand|oldFieldsCount|snextclass|sqlError|send|SVGAngle|radial_gradient|rstm|write|Connection|65280|_availableAnimAttrs|hasFeature|bezier|achlmqrstvxz|cubic|implementation|16711680|ff0066|yxxx|HTTP|xxxx|4xxx|achlmrqstvz|xxxxxxxxxxxx|must|letter|script|spacing|form||snapTo|onreadystatechange|BasicStructure|_id|Wrong|uid||createTextRange|raphaeljs|ForeColor|queryCommandValue|xxxxxxxx|_blank|sortByKey|10px|urlencoded|Msxml2|feature|SVG11|createPopup|htmlfile|wrapper1|setInputValues|slide|html5||maincol|wrapper2|HandlersPath|MSIE|appVersion|getInputValues|black|8cc59d|pages|reserved|date|left2|0x|fixedPosition|Cannot|ping|front|ApplicationEvents|jPaginate|message|statusbar|padding_right|options_value|ipod|teardown|hide_on_blur_timeout|WebkitUserSelect|ipad|iphone|special|autocomplete|_hidden_select|frameborder|syncCriteriaBuilder|radiogroup|_timer_|_duration_|appName|bName|meta|switchToRootQuery|trigger_jquery_event|case_sensitive|innerText|dispatch|updateCriteriaBuilder|disableTextSelect|ajaxAddOption|getJSON|sortOptions|x1f|x7f|x9f|selectedTexts|child|unique|getUTCMonth|copyOptions|containsOption||x00|bfnrtu|getUTCMinutes||SyntaxError|evalJSON|secureEvalJSON|getUTCSeconds|getUTCFullYear|u00|getUTCDate|parsing|getUTCHours|valid|999|escape|decodeURIComponent|6001|slideDown|slideUp|UTF8encode|calc|selectstart|UTF8decode|encodeURIComponent|unescape|onselectstart|getFlags|cte|__max_precision|binary|matc|persist|HTMLCommandElement|render|tpl|isString|Treeview|HTMLMenuItemElement|wrapperCleared|toPrecision|reduceRight|ESCAPE|defineProperties|defineProperty|exec|search|forEachMethod|MessageError|reduce|unshift|reverse|getPrototypeOf|labelledby||isFrozen|freeze|haspopup|owns|listbox|preventExtensions|getOwnPropertyNames|getOwnPropertyDescriptor|isSealed|seal|isExtensible|Eve|amd|file|nts|errordialog|once|configuration|ISURL|NaN|web|ontouchstart|incorrect|Click|widgetName|overloadGetter|textnode|MessageWarning|Android|mirror|axd|clientError|errors|ab8ea8824dc3b24b6666867a2c4ed58ebb762cf0|MooTools|encodeURI|WhiteSpace|_convertPositionTo|GET|178|err|Read|positionAbs|limit|tDnD_whileDrag|serializeParamName|exp|atan|msgTime|_generatePosition|_mouseCapture|MouseEvents|ontouchend|reset_options_value|me2|ready|getQueryParams|_mouseDrag|MouseEvent|Implements|setQueryParamValues|oldInstances|associate|tableDnDUpdate|invoke|combine|getRandom|getLast|uniqueId|Collection|TextNode|uniqueID|tableDnDSerialize|Arguments|erase|capitalize|BackCompat|Warning|substitute|getUTCMilliseconds|escapeRegExp|_mouseUp|transparent|pick|Info|hyphenate|camelCase|Colour|LeftColumn|RightColumn|SelectAllFromRight|getGrid|_makeDraggableOriginal|addClasses|JoinExpression|Join|Datasource|LeftObject|textpathok|Kind|SelectAllFromLeft|runtimeStyle|RightObject|pixelradius|CacheOptions|paddingLeft|GroupBy|colors|color2|paddingTop|kern|RemoveBrackets|oindex|270|focusposition|Cache|Option|_setContainment|Order|focussize|gradientTitle|FieldType|fixOutsideBounds|ItemsListIncomplete|linked|ItemsPacketSize|Label|left16|00000000|000000000000|Nullable|Precision|Command|AltName|Size|uncheck|ReadOnly|Scale|Switch|Test|readonly|Selected|Expanded|addRule|createStyleSheet|OutputColumnDto|titleTextW|ContextMenuDto|objects|Linked|UnionsAdd|ContextMenuItemDto|QueryStructureDto|DIV|clearfix|EncloseWithBrackets|Provider|rotation|doesn|Syntax|MetadataObjectCount|uiDialogTitlebar|dxdy|proceed|closeText|uiDialogTitlebarCloseText|ObjectTypeUnknown|_createButtons|SelectSyntaxProvider|u2019t|Falling|uiDialogClasses|160|SelectAll|viewBox|uuid|getScreenCTM|CheckAll|removeAttribute|xMinYMin|meet|ahqstv|21600|_size1|tables|Created|_allowInteraction||views|procedures|ObjectTypeProcedure|dash|shortdashdotdot|dashdot|longdash|shortdash|flat|shortdashdot|shortdot|MoveBackward|backward||CopyToNewUnionSubQuery|NewUnionSubQuery|longdashdotdot|longdashdot|MoveForward|dashstyle|forward|Insert|ObjectTypeTable|RemoveItem|InsertEmptyItem|ObjectTypeView|beforeClose|arrowwidth|arrowlength|joinstyle|MoveUp|endcap|miter|diagonal|MoveDown|alsoResize|grip|Sunday|groups|Tuesday|Monday|Thu|old|Sat|Fri|SUM|Having|MAX|MIN|Thursday|Wednesday|Saturday|Friday|Wed|primaryKey|nullable|October|September|June|April|August|July|objid|Mon|Tue|ObjectField|December|November|Sun|int|LAST|unload|hellip||liveConvert|liveEx|contentType|toTimeString|dataType|buttonset|TypeError|non|x2F|quot|live|nextAll|GLOBAL_DEBUG|breadcrumb|submit|removeGridRows|scrollToPercentX|addGridRows|scrollTo|COUNT|FIRST|Synonym|DESC|errorThrown|initialise|reinitialise|00|async|removeLink|myType|reload|March|OnApplicationReady|GetName|scrollToBottom|hijackInternalLinks|mdc|CanvasDto|setGlobalOnLoad|LoadFromObject|SmartAdd|equalWidth|getIsScrollableV|isScrollableV|getContentPane|getRec1|GetFullName|equalHeight|GridDto|stack|144|RightField|using|setDataSwitch|MetaDataDto|DataSourceGuid|Cardinality|addHandler|AliasNotQuoted|DataSourceDto|removeHandler|tableNameTemplate|LeftField|System|LinkObjectDto|isScrollableH|Mar|Feb|Jun|Apr|GenerateClass|superclass|Jan|scrollToPercentY|Dec|Nov|February|January|Aug|Jul|Oct|Sep|animateDuration|doesAddBorderForTableAndCells|doesNotAddBorder|subtractsBorderForOverflowNotVisible|getPercentScrolledX|offsetWithParent|getIsScrollableH|getPercentScrolledY|bodyOffset|delegate|getContentPositionX|animateEase|toUpper|inArray|getContentHeight|getContentPositionY|getContentWidth|stdDeviation|returnValue|cancelBubble|AnsiStringFixedLength|Google|Computer|platform|StringFixedLength|VarNumeric|contain|ends|starts|unmouseout|getData|unhover|unmouseover|M21|M22|DateTime2|M12|pixelHeight|DateTimeOffset|M11|Xml|Version|Chrome|Apple|toTransformString|sizingmethod|expand|isSuperSimple|UInt64|Int64|Int16|Double|u00d7|SByte|getElementsByPoint|x_y|curveslengths|colspan|thead|AnsiString|Binary|Decimal|Currency|Byte|unmousedown|onRemoveRow|onAddRow|undrag|UInt32|findRow|onDragOver|setStart|getIntersectionList|Single|getElementsByBBox|UInt16|setFinish|pageXOffset|createSVGRect|pixelWidth|000B9D|updateLinks|removeAll|showDescriptons|following|inter|interCount|removeByGraphics|segment2|calling|u201c|segment1|pathIntersection|pathIntersectionNumber|getByLink|fillSelectOptions1|fillSelectOptions2|criteriaBuilderFieldSelect|onerror|Picker|u2400|preload|dataRefresh|onclick|MAX_SELECTS|succeed|2573AF|level|pager|79B5E3|u201d||NumericFrac|KindOfType|parseDots|NumericInt|horizontalDrag|isAtLeft|isAtRight|tofront|any|_equaliseTransform|notall|NextItem|toback|insertafter|insertbefore|animportCanvasimation|DenyIntoClause|Into|offsetX|_pathToRelative|offsetY|120|350|32E3|inst|updateObjects|onClose|props|Universal|nowrap|DOMContentLoaded|strColumnNameAlreadyUsed|strRemove|1999|ninja|fullfill|getArrowScroll|GridRowCellOnDeleted|0A2|strAddNewCTE|supports|0z|strCopyToNewUnionSubQuery|strEncloseWithBrackets|strUnionSubMenu|strNewUnionSubQuery|bolder|lighter|already|print|onGridRowCellChanged|exists|700|bold|sortOrder|_UID|focusout|onDeleted|descent|baseline|isEmptyRow|same|userSpaceOnUse|patternUnits|own|paid|updated|clipPath|Uncheck|changed|feGaussianBlur|finally|Check|UncheckAll|rid|them|Random|limitation|Gradient|focusin|gradientTransform|derived|webkitTapHighlightColor|createElementNS|onChanged|strAddCTE|refY|orient|Update|strAddSubQuery|patternTransform|fillOpacity|markerWidth|markerHeight|checkRow|finish|ItemSortType|Asc|mozRequestAnimationFrame|webkitRequestAnimationFrame|msRequestAnimationFrame|oRequestAnimationFrame|check_lib|Other|StoredProc|onAnimation|Many|LinkSideType|LinkCardinality|One|requestAnimationFrame|elastic|Allow|bounce|LinkManipulations|04|DbType|Deny|1734|easeOut|easeIn|Desc|easeInOut|9375|5625|984375||625|findRowByGuid|True|insertion|insert|u2018s|findEmptyRow|rowIndex|currentLanguage|TreeSelectTypeDto|u2019s|setTime|rowsHeaders|index2|registerFont|currentEdit|removeRowByDto|mlcxtrv'.split('|'),0,{}))

