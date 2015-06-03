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
  if (!$.ui || !$.ui.widget) {
    var _cleanData = $.cleanData;
    $.cleanData = function(elems) {
      for (var i = 0, elem;(elem = elems[i]) != null;i++) {
        try {
          $(elem).triggerHandler("remove");
        } catch (e) {
        }
      }
      _cleanData(elems);
    };
  }
  var $currentTrigger = null, initialized = false, $win = $(window), counter = 0, namespaces = {}, menus = {}, types = {}, defaults = {selector:null, appendTo:null, trigger:"right", autoHide:false, delay:200, reposition:false, determinePosition:function($menu) {
    if ($.ui && $.ui.position) {
      $menu.css("display", "block").position({my:"left top", at:"left bottom", of:this, offset:"0 5", collision:"fit"}).css("display", "none");
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
        offset = {top:y, left:x};
      }
    }
    var bottom = $win.scrollTop() + $win.height(), right = $win.scrollLeft() + $win.width(), height = opt.$menu.height(), width = opt.$menu.width();
    if (offset.top + height > bottom) {
      offset.top -= height;
    }
    if (offset.top < 0) {
      offset.top = 0;
    }
    if (offset.left + width > right) {
      offset.left -= width;
    }
    opt.$menu.css(offset);
  }, positionSubmenu:function($menu) {
    if ($.ui && $.ui.position) {
      $menu.css("display", "block").position({my:"left top", at:"right top", of:this, collision:"flipfit fit"}).css("display", "");
    } else {
      var offset = {top:0, left:this.outerWidth()};
      $menu.css(offset);
    }
  }, zIndex:6101, animation:{duration:0, show:"slideDown", hide:"slideUp"}, events:{show:$.noop, hide:$.noop}, callback:null, items:{}}, hoveract = {timer:null, pageX:null, pageY:null}, zindex = function($t) {
    return 6100;
    var zin = 0, $tt = $t;
    while (true) {
      zin = Math.max(zin, parseInt($tt.css("z-index"), 10) || 0);
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
    if (e.data.trigger == "right") {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
    if (e.data.trigger != "right" && e.originalEvent) {
      return;
    }
    if ($this.hasClass("context-menu-active")) {
      return;
    }
    if (!$this.hasClass("context-menu-disabled")) {
      $currentTrigger = $this;
      if (e.data.build) {
        var built = e.data.build($currentTrigger, e);
        if (built === false) {
          return;
        }
        if (built.callback !== undefined && built.callback != null) {
          e.data.callback = built.callback;
        }
        e.data = $.extend(true, {}, built, defaults, e.data || {});
        if (!e.data.items || $.isEmptyObject(e.data.items)) {
          if (window.console) {
            (console.error || console.log).call(console, "No items specified to show in contextMenu");
          }
          throw new Error("No Items specified");
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
    var $this = $(this), root = $this.data("contextMenuRoot"), button = e.button, x = e.pageX, y = e.pageY, target, offset;
    e.preventDefault();
    e.stopImmediatePropagation();
    setTimeout(function() {
      var $window;
      var triggerAction = root.trigger == "left" && button === 0 || root.trigger == "right" && button === 2;
      if (document.elementFromPoint && root.$layer) {
        root.$layer.hide();
        target = document.elementFromPoint(x - $win.scrollLeft(), y - $win.scrollTop());
        root.$layer.show();
      }
      if (root.reposition && triggerAction) {
        if (document.elementFromPoint) {
          if (root.$trigger.is(target) || root.$trigger.has(target).length) {
            root.position.call(root.$trigger, root, x, y);
            return;
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
      if (target && triggerAction) {
        root.$trigger.one("contextmenu:hidden", function() {
          $(target).contextMenu({x:x, y:y});
        });
      }
      root.$menu.trigger("contextmenu:hide");
    }, 50);
  }, keyStop:function(e, opt) {
    if (!opt.isInput) {
      e.preventDefault();
    }
    e.stopPropagation();
  }, key:function(e) {
    var opt = {};
    if ($currentTrigger) {
      opt = $currentTrigger.data("contextMenu") || {};
    }
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
        if (opt.accesskeys && opt.accesskeys[k]) {
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
    if (!opt.items[key] || $this.is(".disabled, .context-menu-submenu, .context-menu-separator, .not-selectable")) {
      return;
    }
    e.preventDefault();
    e.stopImmediatePropagation();
    if ($.isFunction(root.callbacks[key]) && Object.prototype.hasOwnProperty.call(root.callbacks, key)) {
      callback = root.callbacks[key];
    } else {
      if ($.isFunction(root.callback)) {
        callback = root.callback;
      } else {
        return;
      }
    }
    if (callback.call(root.$trigger, key, root, data) !== false) {
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
    var $this = $(this), data = $this.data(), opt = data.contextMenu;
    $this.removeClass("hover");
    opt.$selected = null;
  }}, op = {show:function(opt, x, y) {
    if (typeof globalMenu != "undefined" && globalMenu) {
      return;
    }
    globalMenu = true;
    var $trigger = $(this), css = {};
    $("#context-menu-layer").trigger("mousedown");
    opt.$trigger = $trigger;
    if (opt.events.show.call($trigger, opt) === false) {
      $currentTrigger = null;
      return;
    }
    op.update.call($trigger, opt);
    opt.position.call($trigger, opt, x, y);
    if (opt.zIndex) {
      css.zIndex = zindex($trigger) + opt.zIndex;
    }
    op.layer.call(opt.$menu, opt, css.zIndex);
    opt.$menu.find("ul").css("zIndex", css.zIndex + 1);
    opt.$menu.css(css)[opt.animation.show](opt.animation.duration, function() {
      $trigger.trigger("contextmenu:visible");
    });
    $trigger.data("contextMenu", opt).addClass("context-menu-active");
    $(document).off("keydown.contextMenu").on("keydown.contextMenu", handle.key);
    if (opt.autoHide) {
      $(document).on("mousemove.contextMenuAutoHide", function(e) {
        var pos = $trigger.offset();
        pos.right = pos.left + $trigger.outerWidth();
        pos.bottom = pos.top + $trigger.outerHeight();
        if (opt.$layer && (!opt.hovering && (!(e.pageX >= pos.left && e.pageX <= pos.right) || !(e.pageY >= pos.top && e.pageY <= pos.bottom)))) {
          opt.$menu.trigger("contextmenu:hide");
        }
      });
    }
  }, hide:function(opt, force) {
    var $trigger = $(this);
    if (!opt) {
      opt = $trigger.data("contextMenu") || {};
    }
    if (!force && (opt.events && opt.events.hide.call($trigger, opt) === false)) {
      return;
    }
    $trigger.removeData("contextMenu").removeClass("context-menu-active");
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
      setTimeout(function() {
        $trigger.trigger("contextmenu:hidden");
      }, 10);
    });
    globalMenu = false;
  }, create:function(opt, root) {
    if (root === undefined) {
      root = opt;
    }
    opt.$menu = $('<ul class="context-menu-list"></ul>').addClass(opt.className || "").data({"contextMenu":opt, "contextMenuRoot":root});
    $.each(["callbacks", "commands", "inputs"], function(i, k) {
      opt[k] = {};
      if (!root[k]) {
        root[k] = {};
      }
    });
    root.accesskeys || (root.accesskeys = {});
    $.each(opt.items, function(key, item) {
      var $t = $('<li class="context-menu-item"></li>').addClass(item.className || ""), $label = null, $input = null;
      $t.on("click", $.noop);
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
              $input = $('<input type="text" value="1" name="" value="">').attr("name", "context-menu-input-" + key).val(item.value || "").appendTo($label);
              break;
            case "textarea":
              $input = $('<textarea name=""></textarea>').attr("name", "context-menu-input-" + key).val(item.value || "").appendTo($label);
              if (item.height) {
                $input.height(item.height);
              }
              break;
            case "checkbox":
              $input = $('<input type="checkbox" value="1" name="" value="">').attr("name", "context-menu-input-" + key).val(item.value || "").prop("checked", !!item.selected).prependTo($label);
              break;
            case "radio":
              $input = $('<input type="radio" value="1" name="" value="">').attr("name", "context-menu-input-" + item.radio).val(item.value || "").prop("checked", !!item.selected).prependTo($label);
              break;
            case "select":
              $input = $('<select name="">').attr("name", "context-menu-input-" + key).appendTo($label);
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
  }, resize:function($menu, nested) {
    $menu.css({position:"absolute", display:"block"});
    $menu.data("width", Math.ceil($menu.width()) + 1);
    $menu.css({position:"static", minWidth:"0px", maxWidth:"100000px"});
    $menu.find("> li > ul").each(function() {
      op.resize($(this), true);
    });
    if (!nested) {
      $menu.find("ul").addBack().css({position:"", display:"", minWidth:"", maxWidth:""}).width(function() {
        return $(this).data("width");
      });
    }
  }, update:function(opt, root) {
    var $trigger = this;
    if (root === undefined) {
      root = opt;
      op.resize(opt.$menu);
    }
    opt.$menu.children().each(function() {
      var $item = $(this), key = $item.data("contextMenuKey"), item = opt.items[key], disabled = $.isFunction(item.disabled) && item.disabled.call($trigger, key, root) || item.disabled === true;
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
        op.update.call($trigger, item, root);
      }
    });
  }, layer:function(opt, zIndex) {
    var $l = $("#context-menu-layer");
    if ($l) {
      $l.remove();
    }
    var $layer = opt.$layer = $('<div id="context-menu-layer" style="position:fixed; z-index:' + zIndex + '; top:0; left:0; opacity: 0; filter: alpha(opacity=0); background-color: #000;"></div>').css({height:$win.height(), width:$win.width(), display:"block"}).data("contextMenuRoot", opt).insertBefore(this).on("contextmenu", handle.abortevent).on("mousedown", handle.layerClick);
    if (document.body.style.maxWidth === undefined) {
      $layer.css({"position":"absolute", "height":$(document).height()});
    }
    return $layer;
  }};
  function splitAccesskey(val) {
    var t = val.split(/\s+/), keys = [];
    for (var i = 0, k;k = t[i];i++) {
      k = k.charAt(0).toUpperCase();
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
          var $menu = this.first().data("contextMenu") ? this.first().data("contextMenu").$menu : null;
          $menu && $menu.trigger("contextmenu:hide");
        } else {
          if (operation === "destroy") {
            $.contextMenu("destroy", {context:this});
          } else {
            if (operation === "element") {
              if (this.data("contextMenu") != null) {
                return this.data("contextMenu").$menu;
              }
              return[];
            } else {
              if ($.isPlainObject(operation)) {
                operation.context = this;
                $.contextMenu("create", operation);
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
    var o = $.extend(true, {}, defaults, options || {});
    var $document = $(document);
    var $context = $document;
    var _hasContext = false;
    if (!o.context || !o.context.length) {
      o.context = document;
    } else {
      $context = $(o.context).first();
      o.context = $context.get(0);
      _hasContext = o.context !== document;
    }
    switch(operation) {
      case "create":
        if (!o.selector) {
          throw new Error("No selector specified");
        }
        if (o.selector.match(/.context-menu-(list|item|input)($|\s)/)) {
          throw new Error('Cannot bind to selector "' + o.selector + '" as it contains a reserved className');
        }
        if (!o.build && (!o.items || $.isEmptyObject(o.items))) {
          throw new Error("No Items specified");
        }
        counter++;
        o.ns = ".contextMenu" + counter;
        if (!_hasContext) {
          namespaces[o.selector] = o.ns;
        }
        menus[o.ns] = o;
        if (!o.trigger) {
          o.trigger = "right";
        }
        if (!initialized) {
          $document.on({"contextmenu:hide.contextMenu":handle.hideMenu, "prevcommand.contextMenu":handle.prevItem, "nextcommand.contextMenu":handle.nextItem, "contextmenu.contextMenu":handle.abortevent, "mouseenter.contextMenu":handle.menuMouseenter, "mouseleave.contextMenu":handle.menuMouseleave}, ".context-menu-list").on("mouseup.contextMenu", ".context-menu-input", handle.inputClick).on({"mouseup.contextMenu":handle.itemClick, "contextmenu:focus.contextMenu":handle.focusItem, "contextmenu:blur.contextMenu":handle.blurItem, 
          "contextmenu.contextMenu":handle.abortevent, "mouseenter.contextMenu":handle.itemMouseenter, "mouseleave.contextMenu":handle.itemMouseleave}, ".context-menu-item");
          initialized = true;
        }
        $context.on("contextmenu" + o.ns, o.selector, o, handle.contextmenu);
        if (_hasContext) {
          $context.on("remove" + o.ns, function() {
            $(this).contextMenu("destroy");
          });
        }
        switch(o.trigger) {
          case "hover":
            $context.on("mouseenter" + o.ns, o.selector, o, handle.mouseenter).on("mouseleave" + o.ns, o.selector, o, handle.mouseleave);
            break;
          case "left":
            $context.on("click" + o.ns, o.selector, o, handle.click);
            break;
        }
        if (!o.build) {
          op.create(o);
        }
        break;
      case "destroy":
        var $visibleMenu;
        if (_hasContext) {
          var context = o.context;
          $.each(menus, function(ns, o) {
            if (o.context !== context) {
              return true;
            }
            $visibleMenu = $(".context-menu-list").filter(":visible");
            if ($visibleMenu.length && $visibleMenu.data().contextMenuRoot.$trigger.is($(o.context).find(o.selector))) {
              $visibleMenu.trigger("contextmenu:hide", {force:true});
            }
            try {
              if (menus[o.ns].$menu) {
                menus[o.ns].$menu.remove();
              }
              delete menus[o.ns];
            } catch (e) {
              menus[o.ns] = null;
            }
            $(o.context).off(o.ns);
            return true;
          });
        } else {
          if (!o.selector) {
            $document.off(".contextMenu .contextMenuAutoHide");
            $.each(menus, function(ns, o) {
              $(o.context).off(o.ns);
            });
            namespaces = {};
            menus = {};
            counter = 0;
            initialized = false;
            $("#context-menu-layer, .context-menu-list").remove();
          } else {
            if (namespaces[o.selector]) {
              $visibleMenu = $(".context-menu-list").filter(":visible");
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
        label = $node.html();
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
          item = {name:$node.html(), disabled:!!$node.attr("disabled"), callback:function() {
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
            item.options[this.value] = $(this).html();
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
  $.contextMenu.handle = handle;
  $.contextMenu.op = op;
  $.contextMenu.menus = menus;
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
  }, onSelect:function(e) {
    var context = this.wrapper.currentContext;
    if (typeof context.handler == "function") {
      context.handler.call(context, context.textControl, e);
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
  }, editEnd:function(e) {
    if (!this.isActive) {
      return;
    }
    this.wrapper.clearSelectedListItem();
    this.hideList();
    this.onSelect(e);
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
        me.editEnd(e);
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
          if (me.listIsVisible()) {
            e.preventDefault();
            me.wrapper.selectNewListItem(me.textControl.val(), "up", me.userEdit);
          } else {
            me.showList();
          }
          break;
        case 9:
          if (me.listIsVisible()) {
            var $li = me.wrapper.getSelectedListItem();
            if ($li.length) {
              me.pickListItem($li.text(), me.getListValue($li[0].value));
            }
          } else {
            me.editEnd();
          }
          break;
        case 27:
          e.preventDefault();
          me.editEnd();
          return false;
          break;
        case 13:
          e.preventDefault();
          if (me.list_is_visible) {
            var $li = me.wrapper.getSelectedListItem();
            if ($li.length) {
              me.pickListItem($li.text(), me.getListValue($li[0].value));
            }
          } else {
            me.editEnd();
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
      if ($(ev.currentTarget).parents("tr:first").next().length == 0) {
        return;
      }
      jQuery.tableDnD.dragObject = this.parentNode;
      jQuery.tableDnD.currentTable = table;
      jQuery.tableDnD.mouseOffset = jQuery.tableDnD.getMouseOffset(this, ev);
      if (config.onDragStart) {
        config.onDragStart(table, this);
      }
      return false;
    });
  } else {
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
    if ($(row).next().length == 0) {
      return;
    }
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
(function(factory) {
  if (typeof define === "function" && define.amd) {
    define(["jquery"], factory);
  } else {
    factory(jQuery);
  }
})(function($) {
  var table = $.widget("aw.table", {DEFAULT_HEADER_BORDERS:5, alwaysScrollY:false, defaultElement:"<table>", isVisible:false, colgroup:null, innerTable:null, headerRow:null, innerTableTbody:null, lastScrollY:false, options:{scrollable:["y"], columns:{resizable:null, minWidths:null, maxWidths:null}, width:null, height:null, keepColumnsTableWidth:true}, _getWidth:function(e) {
    var $e;
    if (e.length) {
      $e = e;
      e = e[0];
    } else {
      $e = $(e);
    }
    if (e.style.display == "none") {
      if (isEmpty(e.style.width)) {
        return 0;
      }
      return parseInt(e.style.width);
    }
    return $e.outerWidth();
  }, _setWidth:function(e, width, outerWidthDiff) {
    var $e;
    if (e.length) {
      $e = e;
      e = e[0];
    } else {
      $e = $(e);
    }
    if (outerWidthDiff == undefined) {
      if (e.style.display != "none") {
        outerWidthDiff = $e.outerWidth() - $e.width();
      } else {
        outerWidthDiff = this.DEFAULT_HEADER_BORDERS;
      }
    }
    var trueWidth = width - outerWidthDiff;
    $e.width(trueWidth);
  }, _getHeight:function(e) {
    return $(e).outerHeight();
  }, _setHeight:function(e, outer) {
    var $e = $(e);
    var height = outer - ($e.outerHeight() - $e.height());
    $e.height(height);
  }, getHeaderCellByBodyCellIndexFiltered:function(cellIndex, headerCells) {
    var headerCell = this.getHeaderCellByBodyCellIndex(cellIndex, headerCells);
    if (headerCell != null) {
      if (headerCell.style.display == "none" || (!isEmpty(headerCell.attributes["colspan"]) || headerCell.nextSibling == null)) {
        headerCell = null;
      }
    }
    return headerCell;
  }, getHeaderCellByBodyCellIndex:function(cellIndex, headerCells) {
    var trueIndex = 0;
    var totalspan = 0;
    for (var i = 0;i < headerCells.length;i++) {
      var $th = headerCells[i];
      trueIndex = i + totalspan;
      if ($th.attributes["colspan"]) {
        var span = 0 + $th.attributes["colspan"].value - 1;
        if (trueIndex <= cellIndex && cellIndex <= trueIndex + span) {
          return $th;
        }
        totalspan += span;
      }
      if (trueIndex == cellIndex) {
        return $th;
      }
    }
    return null;
  }, _initWidths:function() {
    var that = this;
    var result = this._getBodyFirstRowCells().map(function(i, e) {
      var width = 0;
      if (e.style.display == "none") {
        width = $(e).outerWidth();
      } else {
        width = that._getWidth(e);
      }
      return width;
    }).get();
    return result;
  }, _getHeaderRow:function() {
    if (this.headerRow == null) {
      this.headerRow = this.element.find("> thead > tr:first-child,> tbody > tr:first-child").first();
    }
    if (this.headerRow.length == 0) {
      this.headerRow = 0;
    }
    return this.headerRow;
  }, _getColgroup:function() {
    if (this.colgroup == null) {
      this.colgroup = this.element.find("colgroup");
    }
    if (this.colgroup.length == 0) {
      this.colgroup = null;
    }
    return this.colgroup;
  }, _geInnerTableTbody:function() {
    if (this.innerTableTbody == null) {
      this.innerTableTbody = this.element.find("> tbody tbody:first");
    }
    if (this.innerTableTbody.length == 0) {
      this.innerTableTbody = null;
    }
    return this.innerTableTbody;
  }, _getInnerTable:function() {
    if (this.innerTable == null) {
      this.innerTable = this.element.find("> tbody table");
    }
    if (this.innerTable.length == 0) {
      this.innerTable = null;
    }
    return this.innerTable;
  }, _getBodyFirstRow:function() {
    return this.element.find("> tbody tr.ui-qb-grid-row:first-child");
  }, _getHeaderCells:function() {
    return this._getHeaderRow().children();
  }, _getBodyFirstRowCells:function() {
    return this._getBodyFirstRow().children();
  }, _getColgroupCells:function() {
    return this._getColgroup().children();
  }, _hasScroll:function(element) {
    var $element = $(element);
    return{"x":$element.outerWidth() < $element.prop("scrollWidth"), "y":$element.outerHeight() < $element.prop("scrollHeight")};
  }, _hasScrollY:function() {
    if (this.alwaysScrollY) {
      return true;
    }
    var tbody = this._getOuterTbody()[0];
    return tbody.offsetHeight < tbody.scrollHeight;
  }, updateHeaderCellWidth:function(hasScrollY) {
    var that = this;
    if (hasScrollY == undefined) {
      hasScrollY = this._hasScrollY();
    }
    this._setTableHeaderWidth(this._getTotalWidthStatic(), hasScrollY);
    var colspan = 0;
    this._getHeaderCells().each(function(i, e) {
      var trueIndex = i + colspan;
      var width = 0;
      if (e.attributes["colspan"]) {
        var span = 0 + e.attributes["colspan"].value - 1;
        for (var j = 0;j <= span;j++) {
          width += that.columnWidths[trueIndex + j];
        }
        colspan += span;
      } else {
        width = that.columnWidths[trueIndex];
      }
      if (trueIndex == that.columnWidths.length - 1) {
        width += hasScrollY ? that.sbwidth : 0;
      }
      that._setWidth(e, width);
    });
  }, syncTable:function() {
    if (!this.element.is(":visible")) {
      return;
    }
    this._syncColWidths();
    this._setTableHeaderWidth();
  }, _setColCellWidth:function() {
    var that = this;
    this._getColgroupCells().each(function(i, e) {
      that._setWidth(e, that.columnWidths[i]);
    });
  }, _syncColWidths:function() {
    var that = this;
    var scrollY = this._hasScrollY();
    var width = this._getTotalWidthStatic();
    if (scrollY && !this.lastScrollY) {
      width -= this.sbwidth;
    }
    this.lastScrollY = scrollY;
    this._setTableBodyWidth(width);
    this._setColCellWidth();
    that.columnWidths = this._getBodyCellWidths();
    this.updateHeaderCellWidth();
    that.columnWidths = this._getBodyAndHeaderCellWidths();
    this._setColCellWidth();
    this.updateHeaderCellWidth();
    this._setTableBodyWidth(this.columnWidths);
  }, _getBodyAndHeaderCellWidths:function() {
    var that = this;
    var headerCells = this._getHeaderCells();
    var result = this._getBodyFirstRowCells().map(function(i, e) {
      var width = 0;
      if (e.style.display == "none") {
        width = $(e).outerWidth();
      } else {
        width = that._getWidth(e);
      }
      var headerCell = that.getHeaderCellByBodyCellIndexFiltered(i, headerCells);
      if (headerCell) {
        var headerWidth = that._getWidth(headerCell);
        width = Math.max(width, headerWidth);
      }
      return width;
    }).get();
    return result;
  }, _getBodyCellWidths:function() {
    var that = this;
    var result = this._getBodyFirstRowCells().map(function(i, e) {
      var width = 0;
      if (e.style.display == "none") {
        width = $(e).outerWidth();
      } else {
        width = that._getWidth(e);
      }
      return width;
    }).get();
    return result;
  }, _getTotalWidthStatic:function(columnWidths) {
    if (columnWidths == undefined) {
      columnWidths = this.columnWidths;
    }
    var total = 0;
    var cells = this._getColgroupCells();
    for (var i = 0;i < columnWidths.length;i++) {
      if (cells[i].style.display != "none") {
        total += columnWidths[i];
      }
    }
    return total;
  }, _setTableWidth:function(width, hasScrollY) {
    if (width == undefined) {
      width = this.columnWidths;
    }
    if (Array.isArray(width)) {
      width = this._getTotalWidthStatic(width);
    }
    this._setTableBodyWidth(width);
    this._setTableHeaderWidth(width, hasScrollY);
  }, _setTableBodyWidth:function(width) {
    if (width == undefined) {
      width = this.columnWidths;
    }
    if (Array.isArray(width)) {
      width = this._getTotalWidthStatic(width);
    }
    var body = this._getInnerTable();
    var colgroup = this._getColgroup();
    body.width(width - 1);
    if (colgroup != null) {
      colgroup.width(width);
    }
  }, _setTableHeaderWidth:function(width, hasScrollY) {
    if (width == undefined) {
      width = this.columnWidths;
    }
    if (Array.isArray(width)) {
      width = this._getTotalWidthStatic(width);
    }
    if (hasScrollY == undefined) {
      hasScrollY = this._hasScrollY();
    }
    var headerRow = this._getHeaderRow();
    var headerWidth = width + (hasScrollY ? this.sbwidth : 0);
    headerWidth = Math.max(headerWidth, headerRow.parent().width());
    headerRow.width(headerWidth);
  }, _getOuterTbody:function() {
    if (this.outerTbody == null) {
      this.outerTbody = this.element.find("> tbody");
    }
    return this.outerTbody;
  }, _setBodyBounds:function() {
    var tbody_height = this.element.height() - this.element.find("thead").map(function(i, e) {
      return $(e).length ? $(e).outerHeight() : 0;
    }).get().reduce(function(prev, current) {
      return prev + current;
    }, 0);
    this._getOuterTbody().css({"height":tbody_height + "px"});
  }, _createColGroup:function(widths) {
    var colgroup = $("<colgroup/>");
    var headerCells = this._getBodyFirstRowCells();
    for (var i = 0;i < headerCells.length;i++) {
      var cell = $(headerCells[i]);
      var col = $("<col />");
      var colspan = cell.attr("colspan");
      if (isEmpty(colspan)) {
        colspan = 1;
      } else {
        colspan = parseInt(colspan);
      }
      col.attr("span", colspan);
      col.attr("class", cell.attr("class"));
      if (cell.css("display") == "none") {
        col.css("display", cell.css("display"));
      }
      var width = widths[i];
      col.width(width);
      colgroup.append(col);
    }
    return colgroup;
  }, _create:function() {
    this._super();
    var that = this;
    this.columnWidths = [];
    this.resizeLock = false;
    var $table = this.$element = this.element;
    this.isVisible = this.element.is(":visible");
    this.sbwidth = jQuery.position.scrollbarWidth();
    this.size = this._parseSize(this.options.width, this.options.height);
    this.scrollable = this._parseScrollable(this.options.scrollable);
    this.columnCount = $table.find("> tbody > tr").children().length;
    this.columns = this._parseColumns(this.options.columns);
    this.styles = {};
    this.styles.table = $table.attr("style");
    this.styles.thead = $table.find("> thead").attr("style");
    this.styles.thead_tr = $table.find("> thead > tr").attr("style");
    this.styles.tfoot = $table.find("> tfoot").attr("style");
    this.styles.tfoot_tr = $table.find("> tfoot > tr").attr("style");
    this.styles.tbody = $table.find("> tbody").attr("style");
    this.size = {"width":this.size.width !== null ? this.size.width : this._getWidth($table), "height":this.size.height !== null ? this.size.height : this._getHeight($table)};
    this.innerSize = {"width":this.size.width - ($table.outerWidth() - $table.width()), "height":this.size.height - ($table.outerHeight() - $table.height())};
    if (this.isVisible) {
      $table.css({"height":this.size.height + "px"});
    }
    var scrollY = this.alwaysScrollY ? "scroll" : "auto";
    this.columnWidths = this._initWidths();
    $table.css({"position":"relative", "box-sizing":"border-box", "display":"block", "overflow":"hidden"});
    if (this.isVisible) {
      $table.find("> thead").css({"height":$table.find("thead > tr").outerHeight() + "px"});
    }
    $table.find("> thead").css({"display":"table-row", "position":"absolute", "top":$table.css("padding-top"), "overflow":"hidden"}).find("> tr").css({"left":"0px", "top":"0px", "position":"absolute"}).end().end().find("> tbody").wrap('<tbody style="display: block; position:absolute; overflow-x: ' + (this.scrollable.x ? "auto" : "hidden") + "; overflow-y: " + (this.scrollable.y ? scrollY : "hidden") + "; top: " + ($table.find("thead").outerHeight() + parseFloat($table.css("padding-top"))) + 'px;"><tr><td style="padding: 0;">' + 
    '<table cellspacing="0" cellpadding="0"  style="box-sizing: border-box; display: block; border: 0 none;"></table></td></tr></tbody>');
    this._getInnerTable().attr("class", $table.attr("class"));
    if (this.isVisible) {
      this._setBodyBounds();
    }
    this.hasScroll = {};
    this._setTableWidth(this._getInnerTable().width());
    if (this.columns.resizable != null) {
      var resizable_params = this._getResizeableParams();
      this._getHeaderCells().each(function(i, e) {
        if (that.columns.resizable[i] && $(e).hasClass("allow-resize")) {
          if (that.columns.minWidths != null) {
            resizable_params["minWidth"] = that.columns.minWidths[i];
          }
          if (that.columns.maxWidths != null) {
            resizable_params["maxWidth"] = that.columns.maxWidths[i];
          }
          $(e).resizable(resizable_params);
        }
      });
    }
    if (!that.hasScroll.x) {
      that._on($table.find("> tbody").get(0), {"scroll":function(event) {
        var offset = -1 * $(event.target).scrollLeft();
        that._getHeaderRow().css("left", offset + "px");
      }});
      that.hasScroll.x = true;
    }
    var colgroup = this._createColGroup(this.columnWidths);
    this._geInnerTableTbody().before(colgroup);
    this.syncTable();
    if (true) {
      $(window).on("show", function() {
        if (!that.isVisible) {
          if (that.element.is(":visible")) {
            that.isVisible = true;
            that.syncTable();
          }
        }
      });
    }
    QBWebCoreGridResizeLock = false;
    $(window).resize(function() {
      if (QBWebCoreGridResizeLock === true) {
        return;
      }
      that.syncTable();
    });
  }, _destroy:function() {
    var that = this;
    if (this.columns.resizable !== null) {
      this._getHeaderCells().each(function(i, e) {
        if (that.columns.resizable[i]) {
          $(e).resizable("destroy");
        }
      });
    }
    this._getInnerTable().find("tbody").unwrap().unwrap().unwrap().unwrap();
    this.element.find("> thead").find("> tr").attr("style", typeof this.styles.thead_tr === "undefined" ? null : this.styles.thead_tr).end().attr("style", typeof this.styles.thead === "undefined" ? null : this.styles.thead).end().find("> tfoot").find("> tr").attr("style", typeof this.styles.tfoot_tr === "undefined" ? null : this.styles.tfoot_tr).end().attr("style", typeof this.styles.tfoot === "undefined" ? null : this.styles.tfoot).end().find("> tbody").attr("style", typeof this.styles.tbody === 
    "undefined" ? null : this.styles.tbody).end().attr("style", typeof this.styles.table === "undefined" ? null : this.styles.table);
    this._getHeaderCells().each(function(i, e) {
      $(e).css("width", "");
    });
  }, _isNullorUndefined:function(value) {
    return value === null || typeof value == "undefined";
  }, _parseSize:function(width, height) {
    var size = {};
    if (this._isNullorUndefined(width) || !this._isPositiveNonZeroInt(width)) {
      size.width = null;
    } else {
      size.width = width;
    }
    if (this._isNullorUndefined(height) || !this._isPositiveNonZeroInt(height)) {
      size.height = null;
    } else {
      size.height = height;
    }
    return size;
  }, _parseScrollable:function(value) {
    var scrollable;
    if (value === true) {
      scrollable = {"x":true, "y":true};
    } else {
      if (value == "x") {
        scrollable = {"x":true, "y":false};
      } else {
        if (value == "y") {
          scrollable = {"x":false, "y":true};
        } else {
          if ($.isArray(value)) {
            scrollable = {"x":$.inArray("x", value), "y":$.inArray("y", value)};
          } else {
            scrollable = {"x":false, "y":false};
          }
        }
      }
    }
    return scrollable;
  }, _parseColumns:function(columns) {
    var temp = {};
    temp["resizable"] = this._isNullorUndefined(columns) ? null : this._parseResizable(columns.resizable);
    temp["minWidths"] = this._isNullorUndefined(columns) ? null : this._parseWidth(columns.minWidths);
    temp["maxWidths"] = this._isNullorUndefined(columns) ? null : this._parseWidth(columns.maxWidths);
    return temp;
  }, _parseResizable:function(resizable) {
    var temp = [];
    if (this._isNullorUndefined(resizable)) {
      return null;
    } else {
      if ($.isFunction(resizable)) {
        temp = resizable();
      } else {
        if ($.isArray(resizable)) {
          temp = resizable;
        } else {
          if (resizable === true) {
            for (var i = 0;i < this.columnCount;i++) {
              temp[i] = true;
            }
            return temp;
          } else {
            return null;
          }
        }
      }
    }
    if (!$.isArray(temp) || (temp.length != this.columnCount || !temp.every(function(value) {
      return value === true || value === false;
    }))) {
      return null;
    }
    return temp;
  }, _isInt:function(value) {
    return+value == Math.floor(+value);
  }, _isPositiveInt:function(value) {
    return+value == Math.floor(+value) && +value >= 0;
  }, _isPositiveNonZeroInt:function(value) {
    return+value == Math.floor(+value) && +value > 0;
  }, _parseWidth:function(width) {
    var temp = [];
    if (this._isNullorUndefined(width)) {
      return null;
    } else {
      if ($.isFunction(width)) {
        temp = width();
      } else {
        if ($.isArray(width)) {
          temp = width;
        } else {
          if (this._isPositiveInt(width)) {
            var value = +width;
            for (var i = 0;i < this.columnCount;i++) {
              temp[i] = value;
            }
            return temp;
          } else {
            return null;
          }
        }
      }
    }
    var that = this;
    if (!$.isArray(temp) || (temp.length != this.columnCount || !temp.every(function(value) {
      return that._isPositiveInt(value);
    }))) {
      return null;
    }
    return temp;
  }, _scale:function(widths, finalTotal, currentTotal) {
    if (typeof currentTotal == "undefined") {
      currentTotal = 0;
      for (var i = 0;i < widths.length;i++) {
        currentTotal += widths[i];
      }
    }
    var scale = finalTotal / currentTotal;
    var newWidths = [];
    var newTotal = 0;
    for (var i = 0;i < widths.length - 1;i++) {
      newWidths[i] = Math.round(scale * widths[i]);
      newTotal += newWidths[i];
    }
    newWidths[i] = finalTotal - newTotal;
    return newWidths;
  }, resize:function(width, height) {
    var that = this;
    var newsize = this._parseSize(width, height);
    var $table = this.element;
    if (newsize.width != null) {
      $table.css("width", width);
      this.size.width = newsize.width;
      this.innerSize.width = newsize.width - ($table.outerWidth() - $table.width());
      var total = this._getTotalWidthStatic();
      if (this.scrollable.x) {
        if (this.hasScroll.x || !this.options.keepColumnsTableWidth) {
          var hadScroll_x = this.hasScroll.x;
          var hasScroll_x = this._hasScroll($table.find("> tbody")).x;
          if (!hadScroll_x && hasScroll_x) {
            this._on($table.find("> tbody").get(0), {"scroll":function(event) {
              var offset = -1 * $(event.target).scrollLeft();
              that._getHeaderRow().css("left", offset + "px");
            }});
            this._setTableWidth(total);
            this.hasScroll.x = true;
          } else {
            if (hadScroll_x && !hasScroll_x) {
              this._off($table.find("> tbody"), "scroll");
              this.hasScroll.x = false;
            }
          }
        } else {
          this.columnWidths = this._scale(this.columnWidths, this.innerSize.width, total);
          if (this.hasScroll.x) {
            this._getInnerTable().find("tbody").css("width", "");
            this._getHeaderRow().width(this.innerSize.width + "px");
            this._off($table.find("> tbody"), "scroll");
            this.hasScroll.x = false;
          }
        }
      } else {
        if (total != this.innerSize.width) {
          this.columnWidths = this._scale(this.columnWidths, this.innerSize.width, total);
        }
      }
      $table.children().css("width", this.innerSize.width + "px");
    }
    if (height != null) {
      $table.css("height", height);
      this.size.height = newsize.height;
      this.innerSize.height = newsize.height - ($table.outerHeight() - $table.height());
      this._setBodyBounds();
    }
    this.refresh();
  }, refresh:function() {
    this._syncColWidths();
  }, body:function(rows) {
    this._getInnerTable().find("tbody").html(rows);
    this.refresh();
  }, _getHeaderCellsIndex:function(element) {
    return $(element).index();
  }, _getHeaderCellsIndexTrue:function(element) {
    var headerCells = this._getHeaderCells();
    var result = 0;
    for (var i = 0;i < headerCells.length;i++) {
      var cell = headerCells[i];
      if (cell.attributes["colspan"]) {
        result += 0 + cell.attributes["colspan"].value - 1;
      }
      if (cell == element) {
        break;
      }
      result++;
    }
    return result;
  }, _getResizeableParams:function() {
    var that = this;
    var $table = this.element;
    var $headerCell;
    var bodyCell;
    var colIndex;
    var cellIndex;
    var resized_widths = [];
    var diff = 0;
    var hasScrollY;
    var cellOuterDiff;
    var totalWidth = 0;
    var colCell;
    var newWidth;
    var originalSize = 0;
    return{handles:"e", start:function(event, ui) {
      $headerCell = ui.element;
      originalSize = that._getWidth($headerCell);
      colIndex = that._getHeaderCellsIndexTrue(ui.element[0]);
      cellIndex = that._getHeaderCellsIndexTrue(ui.element[0]);
      colCell = that._getColgroupCells()[colIndex];
      bodyCell = that._getBodyFirstRowCells()[cellIndex];
      that.resizeLock = false;
      QBWebCoreGridResizeLock = true;
      hasScrollY = that._hasScrollY();
      cellOuterDiff = $(bodyCell).outerWidth() - $(bodyCell).width();
      totalWidth = that._getTotalWidthStatic();
    }, resize:function(event, ui) {
      if (that.resizeLock) {
        return;
      }
      that.resizeLock = true;
      var newDiff = ui.size.width - ui.originalSize.width;
      if (newDiff == diff) {
        return;
      }
      diff = newDiff;
      for (var i = 0;i < that.columnWidths.length;i++) {
        resized_widths[i] = that.columnWidths[i];
      }
      that._setTableWidth(totalWidth + diff, hasScrollY);
      that._setWidth(colCell, resized_widths[cellIndex] + diff);
      that._setWidth(bodyCell, resized_widths[cellIndex] + diff);
      newWidth = Math.max(that._getWidth(bodyCell), that._getWidth($headerCell));
      if (resized_widths[cellIndex] + diff < newWidth) {
        diff = newWidth - originalSize;
        that._setTableWidth(totalWidth + diff, hasScrollY);
        that._setWidth(colCell, resized_widths[cellIndex] + diff);
        that._setWidth(ui.element, resized_widths[cellIndex] + diff);
        that._setTableWidth(totalWidth + diff, hasScrollY);
      }
      that.resizeLock = false;
      resized_widths[cellIndex] += diff;
    }, stop:function(event, ui) {
      QBWebCoreGridResizeLock = false;
      that.resizeLock = false;
      for (var i = 0;i < that.columnWidths.length;i++) {
        that.columnWidths[i] = resized_widths[i];
      }
      that.syncTable();
    }};
  }});
  this.ResizeSensor = function(element, callback) {
    function EventQueue() {
      this.q = [];
      this.add = function(ev) {
        this.q.push(ev);
      };
      var i, j;
      this.call = function() {
        for (i = 0, j = this.q.length;i < j;i++) {
          this.q[i].call();
        }
      };
    }
    function getComputedStyle(element, prop) {
      if (element.currentStyle) {
        return element.currentStyle[prop];
      } else {
        if (window.getComputedStyle) {
          return window.getComputedStyle(element, null).getPropertyValue(prop);
        } else {
          return element.style[prop];
        }
      }
    }
    function attachResizeEvent(element, resized) {
      if (!element.resizedAttached) {
        element.resizedAttached = new EventQueue;
        element.resizedAttached.add(resized);
      } else {
        if (element.resizedAttached) {
          element.resizedAttached.add(resized);
          return;
        }
      }
      element.resizeSensor = document.createElement("div");
      element.resizeSensor.className = "resize-sensor";
      var style = "position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: scroll; z-index: -1; visibility: hidden;";
      var styleChild = "position: absolute; left: 0; top: 0;";
      element.resizeSensor.style.cssText = style;
      element.resizeSensor.innerHTML = '<div class="resize-sensor-expand" style="' + style + '">' + '<div style="' + styleChild + '"></div>' + "</div>" + '<div class="resize-sensor-shrink" style="' + style + '">' + '<div style="' + styleChild + ' width: 200%; height: 200%"></div>' + "</div>";
      element.appendChild(element.resizeSensor);
      if (!{fixed:1, absolute:1}[getComputedStyle(element, "position")]) {
        element.style.position = "relative";
      }
      var expand = element.resizeSensor.childNodes[0];
      var expandChild = expand.childNodes[0];
      var shrink = element.resizeSensor.childNodes[1];
      var shrinkChild = shrink.childNodes[0];
      var lastWidth, lastHeight;
      var reset = function() {
        expandChild.style.width = expand.offsetWidth + 10 + "px";
        expandChild.style.height = expand.offsetHeight + 10 + "px";
        expand.scrollLeft = expand.scrollWidth;
        expand.scrollTop = expand.scrollHeight;
        shrink.scrollLeft = shrink.scrollWidth;
        shrink.scrollTop = shrink.scrollHeight;
        lastWidth = element.offsetWidth;
        lastHeight = element.offsetHeight;
      };
      reset();
      var changed = function() {
        element.resizedAttached.call();
      };
      var addEvent = function(el, name, cb) {
        if (el.attachEvent) {
          el.attachEvent("on" + name, cb);
        } else {
          el.addEventListener(name, cb);
        }
      };
      addEvent(expand, "scroll", function() {
        if (element.offsetWidth > lastWidth || element.offsetHeight > lastHeight) {
          changed();
        }
        reset();
      });
      addEvent(shrink, "scroll", function() {
        if (element.offsetWidth < lastWidth || element.offsetHeight < lastHeight) {
          changed();
        }
        reset();
      });
    }
    if ("[object Array]" === Object.prototype.toString.call(element) || ("undefined" !== typeof jQuery && element instanceof jQuery || "undefined" !== typeof Elements && element instanceof Elements)) {
      var i = 0, j = element.length;
      for (;i < j;i++) {
        attachResizeEvent(element[i], callback);
      }
    } else {
      attachResizeEvent(element, callback);
    }
  };
});
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
Raphael.fn.UpdateConnection;
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

// ..\..\src\Common\Client\js\release\usr_v2_8_7.js
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1;};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p;}('K Sg=1m;K G8={FV:1a(){K 6S=1c;if(2s rl!="2p"){7a{6S=1T rl("Se.G1")}7b(e){7a{6S=1T rl("wJ.G1")}7b(E){6S=1j}}}1i{if(3n.G2){7a{6S=1T G2}7b(e){6S=1c}}}1b 6S},A2:1a(yu,1V,4f){K 6S=J.FV();if(!6S||!yu){1b}K 58=yu;58+=58.51("?")+1?"&":"?";58+="Sk="+(1T 5A).M3();K wr=1c;if(4f=="rV"){K xD=58.3w("?");58=xD[0];wr=xD[1]}6S.76(4f,58,1m);if(4f=="rV"){6S.xY("FX-1z","pR/x-pE-Si-S6");6S.xY("FX-1e",wr.1e);6S.xY("S7","5J")}6S.S4=1a(){if(6S.nK==4){if(6S.6J==ep){K 1J="";if(6S.Ga){1J=6S.Ga}if(1V){1V(1J)}}}};6S.S5(wr)},7X:1a(9P,58,bU){K 9s=\'<b 2l="3B:#Sb">AV 9R</b>\\n<br/>\\n\'+"lw: "+9P+"\\n<br>\\n"+"xh: "+58+"\\n<br>\\n"+"Gd: "+bU+"\\n<br>\\n";K G9="AV 9R\\n"+"lw: "+9P+"\\n\\n"+"xh: "+58+"\\n\\n"+"Gd: "+bU+"\\n\\n";if(bw&&bw.fP){9s=9s+"fP: "+bw.fP}K 3y=2N.c4("2E");3y.aV="S9";3y.jM=9s;if(2N&&(2N.3s&&2N.3s.3Q)){2N.3s.3Q(3y)}1i{eL(G9)}G8.FF({9P:9P,58:58,bU:bU,fP:bw.fP});1b 1m},FF:1a(1y){K 58="nO/Sy.Sl?";1o(K i in 1y){if(1y.7K(i)){58+=i+"="+RV(1y[i])+"&"}}J.A2(58,1c,"rV")}};(1a(){J.RT={6c:"1.4.5",8O:"RR"};K 7F=J.7F=1a(1h){if(1h==1c){1b"1c"}if(1h.$8C!=1c){1b 1h.$8C()}if(1h.8A){if(1h.FE==1){1b"1f"}if(1h.FE==3){1b/\\S/.96(1h.GT)?"Tq":"IM"}}1i{if(2s 1h.1e=="c6"){if(1h.IU){1b"2t"}if("1h"in 1h){1b"FL"}}}1b 2s 1h};K w5=J.w5=1a(1h,1C){if(1h==1c){1b 1j}K 5e=1h.$5e||1h.5e;43(5e){if(5e===1C){1b 1m}5e=5e.1N}if(!1h.7K){1b 1j}1b 1h dc 1C};K 9T=J.9T;K hc=1m;1o(K i in{3u:1}){hc=1c}if(hc){hc=["7K","Lx","Lu","rz","yD","3u","5e"]}9T.2V.go=1a(vS){K 2w=J;1b 1a(a,b){if(a==1c){1b J}if(vS||2s a!="4i"){1o(K k in a){2w.2v(J,k,a[k])}if(hc){1o(K i=hc.1e;i--;){k=hc[i];if(a.7K(k)){2w.2v(J,k,a[k])}}}}1i{2w.2v(J,a,b)}1b J}};9T.2V.Tn=1a(vS){K 2w=J;1b 1a(a){K 2j,1J;if(2s a!="4i"){2j=a}1i{if(2t.1e>1){2j=2t}1i{if(vS){2j=[a]}}}if(2j){1J={};1o(K i=0;i<2j.1e;i++){1J[2j[i]]=2w.2v(J,2j[i])}}1i{1J=2w.2v(J,a)}1b 1J}};9T.2V.4n=1a(1q,1n){J[1q]=1n}.go();9T.2V.7g=1a(1q,1n){J.2V[1q]=1n}.go();K 3J=3D.2V.3J;9T.2D=1a(1h){1b 7F(1h)=="1a"?1h:1a(){1b 1h}};3D.2D=1a(1h){if(1h==1c){1b[]}1b 9J.FA(1h)&&2s 1h!="4i"?7F(1h)=="3Z"?1h:3J.2v(1h):[1h]};6p.2D=1a(1h){K c6=cq(1h);1b FC(c6)?c6:1c};5w.2D=1a(1h){1b 1h+""};9T.7g({ye:1a(){J.$5S=1m;1b J},yB:1a(){J.$w4=1m;1b J}});K 9J=J.9J=J.9J=1a(1x,1C){if(1x){K xN=1x.3N();K FI=1a(1h){1b 7F(1h)==xN};9J["is"+1x]=FI;if(1C!=1c){1C.2V.$8C=1a(){1b xN}.ye()}}if(1C==1c){1b 1c}1C.4n(J);1C.$5e=9J;1C.2V.$5e=1C;1b 1C};K 3u=4D.2V.3u;9J.FA=1a(1h){1b 1h!=1c&&(2s 1h.1e=="c6"&&3u.2v(1h)!="[1C 9T]")};K kp={};K xG=1a(1C){K 1z=7F(1C.2V);1b kp[1z]||(kp[1z]=[])};K 7g=1a(1x,4f){if(4f&&4f.$5S){1b}K kp=xG(J);1o(K i=0;i<kp.1e;i++){K ko=kp[i];if(7F(ko)=="1z"){7g.2v(ko,1x,4f)}1i{ko.2v(J,1x,4f)}}K dH=J.2V[1x];if(dH==1c||!dH.$w4){J.2V[1x]=4f}if(J[1x]==1c&&7F(4f)=="1a"){4n.2v(J,1x,1a(1h){1b 4f.3h(1h,3J.2v(2t,1))})}};K 4n=1a(1x,4f){if(4f&&4f.$5S){1b}K dH=J[1x];if(dH==1c||!dH.$w4){J[1x]=4f}};9J.7g({7g:7g.go(),4n:4n.go(),b6:1a(1x,8J){7g.2v(J,1x,J.2V[8J])}.go(),TT:1a(ko){xG(J).1H(ko);1b J}});1T 9J("9J",9J);K eP=1a(1x,1C,bo){K vF=1C!=4D,2V=1C.2V;if(vF){1C=1T 9J(1x,1C)}1o(K i=0,l=bo.1e;i<l;i++){K 1q=bo[i],yw=1C[1q],jS=2V[1q];if(yw){yw.yB()}if(vF&&jS){1C.7g(1q,jS.yB())}}if(vF){K FB=2V.rz(bo[0]);1C.SP=1a(fn){if(!FB){1o(K i=0,l=bo.1e;i<l;i++){fn.2v(2V,2V[bo[i]],bo[i])}}1o(K 1q in 2V){fn.2v(2V,2V[1q],1q)}}}1b eP};eP("5w",5w,["bq","JQ","3I","51","FD","3k","Jm","3l","SM","3J","3w","7l","gT","oJ","3N","8P"])("3D",3D,["e3","1H","SU","c0","h3","5t","ST","3I","53","3J","51","FD","4H","9m","nP","bS","FP","qN","SS"])("6p",6p,["AY","4G","yD","SF"])("9T",9T,["3h","2v","2O"])("e7",e7,["SE","96"])("4D",4D,["7V","Tc","T2","84","T1","T3","T5","T4","SX","SW","T0","Td","Tf"])("5A",5A,["6X"]);4D.4n=4n.go();5A.4n("6X",1a(){1b+1T 5A});1T 9J("lv",lv);6p.2V.$8C=1a(){1b FC(J)?"c6":"1c"}.ye();6p.4n("jx",1a(5U,47){1b 3o.e8(3o.jx()*(47-5U+1)+5U)});K 7K=4D.2V.7K;4D.4n("9m",1a(1C,fn,2O){1o(K 1q in 1C){if(7K.2v(1C,1q)){fn.2v(2O,1C[1q],1q,1C)}}});4D.2e=4D.9m;3D.7g({9m:1a(fn,2O){1o(K i=0,l=J.1e;i<l;i++){if(i in J){fn.2v(2O,J[i],i,J)}}},2e:1a(fn,2O){3D.9m(J,fn,2O);1b J}});K wU=1a(1h){3x(7F(1h)){1p"3Z":1b 1h.6e();1p"1C":1b 4D.6e(1h);5v:1b 1h}};3D.7g("6e",1a(){K i=J.1e,6e=1T 3D(i);43(i--){6e[i]=wU(J[i])}1b 6e});K yj=1a(aP,1q,5F){3x(7F(5F)){1p"1C":if(7F(aP[1q])=="1C"){4D.B4(aP[1q],5F)}1i{aP[1q]=4D.6e(5F)}1r;1p"3Z":aP[1q]=5F.6e();1r;5v:aP[1q]=5F}1b aP};4D.4n({B4:1a(aP,k,v){if(7F(k)=="4i"){1b yj(aP,k,v)}1o(K i=1,l=2t.1e;i<l;i++){K 1C=2t[i];1o(K 1q in 1C){yj(aP,1q,1C[1q])}}1b aP},6e:1a(1C){K 6e={};1o(K 1q in 1C){6e[1q]=wU(1C[1q])}1b 6e},2Y:1a(mP){1o(K i=1,l=2t.1e;i<l;i++){K wP=2t[i]||{};1o(K 1q in wP){mP[1q]=wP[1q]}}1b mP}});["4D","Ta","T9","SH","SL"].2e(1a(1x){1T 9J(1x)});K FQ=5A.6X();5w.4n("SK",1a(){1b(FQ++).3u(36)})})();3D.7g({nP:1a(fn,2O){1o(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&!fn.2v(2O,J[i],i,J)){1b 1j}}1b 1m},4H:1a(fn,2O){K f8=[];1o(K 1n,i=0,l=J.1e>>>0;i<l;i++){if(i in J){1n=J[i];if(fn.2v(2O,1n,i,J)){f8.1H(1n)}}}1b f8},51:1a(1h,2D){K 1e=J.1e>>>0;1o(K i=2D<0?3o.47(0,1e+2D):2D||0;i<1e;i++){if(J[i]===1h){1b i}}1b-1},bS:1a(fn,2O){K 1e=J.1e>>>0,f8=3D(1e);1o(K i=0;i<1e;i++){if(i in J){f8[i]=fn.2v(2O,J[i],i,J)}}1b f8},FP:1a(fn,2O){1o(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&fn.2v(2O,J[i],i,J)){1b 1m}}1b 1j},FN:1a(){1b J.4H(1a(1h){1b 1h!=1c})},SR:1a(FT){K 2j=3D.3J(2t,1);1b J.bS(1a(1h){1b 1h[FT].3h(1h,2j)})},SN:1a(84){K 1v={},1e=3o.5U(J.1e,84.1e);1o(K i=0;i<1e;i++){1v[84[i]]=J[i]}1b 1v},1Y:1a(1C){K 1J={};1o(K i=0,l=J.1e;i<l;i++){1o(K 1q in 1C){if(1C[1q](J[i])){1J[1q]=J[i];46 1C[1q];1r}}}1b 1J},jg:1a(1h,2D){1b J.51(1h,2D)!=-1},2Y:1a(3Z){J.1H.3h(J,3Z);1b J},SO:1a(){1b J.1e?J[J.1e-1]:1c},Tg:1a(){1b J.1e?J[6p.jx(0,J.1e-1)]:1c},FS:1a(1h){if(!J.jg(1h)){J.1H(1h)}1b J},TI:1a(3Z){1o(K i=0,l=3Z.1e;i<l;i++){J.FS(3Z[i])}1b J},TE:1a(1h){1o(K i=J.1e;i--;){if(J[i]===1h){J.5t(i,1)}}1b J},dn:1a(){J.1e=0;1b J},FK:1a(){K 3Z=[];1o(K i=0,l=J.1e;i<l;i++){K 1z=7F(J[i]);if(1z=="1c"){bn}3Z=3Z.3I(1z=="3Z"||(1z=="FL"||(1z=="2t"||w5(J[i],3D)))?3D.FK(J[i]):J[i])}1b 3Z},TV:1a(){1o(K i=0,l=J.1e;i<l;i++){if(J[i]!=1c){1b J[i]}}1b 1c},xa:1a(3Z){if(J.1e!=3){1b 1c}K 3W=J.bS(1a(1n){if(1n.1e==1){1n+=1n}1b 1n.aB(16)});1b 3Z?3W:"3W("+3W+")"},Aj:1a(3Z){if(J.1e<3){1b 1c}if(J.1e==4&&(J[3]==0&&!3Z)){1b"TN"}K 6t=[];1o(K i=0;i<3;i++){K vX=(J[i]-0).3u(16);6t.1H(vX.1e==1?"0"+vX:vX)}1b 3Z?6t:"#"+6t.53("")}});5w.7g({96:1a(w2,1y){1b(7F(w2)=="Ae"?w2:1T e7(""+w2,1y)).96(J)},jg:1a(4i,5u){1b 5u?(5u+J+5u).51(5u+4i+5u)>-1:5w(J).51(4i)>-1},oJ:1a(){1b 5w(J).3l(/^\\s+|\\s+$/g,"")},FN:1a(){1b 5w(J).3l(/\\s+/g," ").oJ()},Ti:1a(){1b 5w(J).3l(/-\\D/g,1a(3k){1b 3k.bq(1).8P()})},Tj:1a(){1b 5w(J).3l(/[A-Z]/g,1a(3k){1b"-"+3k.bq(0).3N()})},Tx:1a(){1b 5w(J).3l(/\\b[a-z]/g,1a(3k){1b 3k.8P()})},Tu:1a(){1b 5w(J).3l(/([-.*+?^${}()|[\\]\\/\\\\])/g,"\\\\$1")},aB:1a(hi){1b 5R(J,hi||10)},3P:1a(){1b cq(J)},xa:1a(3Z){K 6t=5w(J).3k(/^#?(\\w{1,2})(\\w{1,2})(\\w{1,2})$/);1b 6t?6t.3J(1).xa(3Z):1c},Aj:1a(3Z){K 3W=5w(J).3k(/\\d{1,3}/g);1b 3W?3W.Aj(3Z):1c},RX:1a(1C,Ae){1b 5w(J).3l(Ae||/\\\\?\\{([^{}]+)\\}/g,1a(3k,1x){if(3k.bq(0)=="\\\\"){1b 3k.3J(1)}1b 1C[1x]!=1c?1C[1x]:""})}});9T.4n({GA:1a(){1o(K i=0,l=2t.1e;i<l;i++){7a{1b 2t[i]()}7b(e){}}1b 1c}});9T.7g({GA:1a(2j,2O){7a{1b J.3h(2O,3D.2D(2j))}7b(e){}1b 1c},2O:1a(2P){K 2w=J,2j=2t.1e>1?3D.3J(2t,1):1c,F=1a(){};K Ad=1a(){K 2L=2P,1e=2t.1e;if(J dc Ad){F.2V=2w.2V;2L=1T F}K 1J=!2j&&!1e?2w.2v(2L):2w.3h(2L,2j&&1e?2j.3I(3D.3J(2t)):2j||2t);1b 2L==2P?1J:2L};1b Ad},Ap:1a(2j,2O){K 2w=J;if(2j!=1c){2j=3D.2D(2j)}1b 1a(){1b 2w.3h(2O,2j||2t)}},h6:1a(h6,2O,2j){1b 6K(J.Ap(2j==1c?[]:2j,2O),h6)},Ak:1a(Ak,2O,2j){1b oN(J.Ap(2j==1c?[]:2j,2O),Ak)}});6p.7g({xE:1a(5U,47){1b 3o.5U(47,3o.47(5U,J))},4R:1a(fX){fX=3o.66(10,fX||0).4G(fX<0?-fX:0);1b 3o.4R(J*fX)/fX},dD:1a(fn,2O){1o(K i=0;i<J;i++){fn.2v(2O,i,J)}},3P:1a(){1b cq(J)},aB:1a(hi){1b 5R(J,hi||10)}});6p.b6("2e","dD");(1a(3L){K bo={};3L.2e(1a(1x){if(!6p[1x]){bo[1x]=1a(){1b 3o[1x].3h(1c,[J].3I(3D.2D(2t)))}}});6p.7g(bo)})(["4j","G0","rZ","Sq","Bj","j8","9l","Ss","e8","ld","47","5U","66","8F","aC","Ip"]);(1a(){K 6n=J.6n=1T 9J("6n",1a(1y){if(w5(1y,9T)){1y={cz:1y}}K i9=1a(){eS(J);if(i9.$Au){1b J}J.$9I=1c;K 1n=J.cz?J.cz.3h(J,2t):J;J.$9I=J.9I=1c;1b 1n}.4n(J).7g(1y);i9.$5e=6n;i9.2V.$5e=i9;i9.2V.1N=1N;1b i9});K 1N=1a(){if(!J.$9I){8U 1T 9R(\'rT 4f "1N" GE be yo.\')}K 1x=J.$9I.$1x,1N=J.$9I.$GD.1N,dH=1N?1N.2V[1x]:1c;if(!dH){8U 1T 9R(\'rT 4f "\'+1x+\'" 3t no 1N.\')}1b dH.3h(J,2t)};K eS=1a(1C){1o(K 1q in 1C){K 1n=1C[1q];3x(7F(1n)){1p"1C":K F=1a(){};F.2V=1n;1C[1q]=eS(1T F);1r;1p"3Z":1C[1q]=1n.6e();1r}}1b 1C};K BP=1a(2w,1q,4f){if(4f.$gA){4f=4f.$gA}K 64=1a(){if(4f.$w4&&J.$9I==1c){8U 1T 9R(\'rT 4f "\'+1q+\'" GE be yo.\')}K 9I=J.9I,5F=J.$9I;J.9I=5F;J.$9I=64;K 1J=4f.3h(J,2t);J.$9I=5F;J.9I=9I;1b 1J}.4n({$GD:2w,$gA:4f,$1x:1q});1b 64};K 7g=1a(1q,1n,GQ){if(6n.Aw.7K(1q)){1n=6n.Aw[1q].2v(J,1n);if(1n==1c){1b J}}if(7F(1n)=="1a"){if(1n.$5S){1b J}J.2V[1q]=GQ?1n:BP(J,1q,1n)}1i{4D.B4(J.2V,1q,1n)}1b J};K Gl=1a(w8){w8.$Au=1m;K jS=1T w8;46 w8.$Au;1b jS};6n.7g("7g",7g.go());6n.Aw={bY:1a(1N){J.1N=1N;J.2V=Gl(1N)},W6:1a(1F){3D.2D(1F).2e(1a(1h){K kU=1T 1h;1o(K 1q in kU){7g.2v(J,1q,kU[1q],1m)}},J)}}})();(1a($){$.e4.9p="W9"in 2N;if(!$.e4.9p){1b}K lW=$.ui.wm.2V;K wu=lW.wu;K m6;1a g9(1I,Gk){if(1I.eC.j0.1e>1){1b}1I.4r();K t=1I.eC.Gf[0];K z3=2N.Jt("W8");z3.Jq(Gk,1m,1m,3n,1,t.Jr,t.JA,t.b7,t.bi,1j,1j,1j,1j,0,1c);1I.3e.CY(z3)}lW.Gv=1a(1I){K me=J;if(m6||!me.W1(1I.eC.Gf[0])){1b}m6=1m;me.yN=1j;g9(1I,"j7");g9(1I,"9X");g9(1I,"7t")};lW.Gx=1a(1I){if(!m6){1b}J.yN=1m;g9(1I,"9X")};lW.Gr=1a(1I){if(!m6){1b}g9(1I,"6A");g9(1I,"fB");if(!J.yN){g9(1I,"3R")}m6=1j};lW.wu=1a(){K me=J;me.1f.2O("pV",$.av(me,"Gv")).2O("pS",$.av(me,"Gx")).2O("pO",$.av(me,"Gr"));wu.2v(me)}})(2A);K hv=1c;(1a($){$.fn.ox=1a(){$(J).gD(1a(e){K t=e.8b;K o=$(e.8b).2n();if(e.77-o.1Z>t.nW){1b}K 1f=$(e.3e);1f.2G({x:e.b7,y:e.bi})})};K $Gs=$.fn.3R;$.fn.3R=1a 3R(5b,7X){if(!7X){1b $Gs.3h(J,2t)}1b $(J).2O(1z,7X)};$.fn.gD=1a gD(){K 2j=[].5t.2v(2t,0),7X=2j.e3(),5b=2j.e3(),$J=$(J);1b 7X?$J.3R(5b,7X):$J.1O(1z)};$.gD={5b:9q};$.1I.W3.gD={Dc:1a(1g,bQ){if(!/W2|Wi|Wl/i.96(bw.fP)){$(J).2O(Fe,zu).2O([Ft,Fv,Fn,Fi].53(" "),zz).2O(zw,3R)}1i{Gu(J).2O(Fq,zu).2O([Fp,Fm,Fl].53(" "),zz).2O(zw,3R).2I({We:"3j"})}},VH:1a(bQ){$(J).8d(9Q)}};1a Gu(1f){$.2e("pV pS pO D3".3w(/ /),1a 2O(ix,it){1f.bF(it,1a VL(1I){$(1f).1O(it)},1j)});1b $(1f)}1a zu(1I){if(hv){1b}K 1f=J;K 2j=2t;$(J).1g(tZ,1j);hv=6K(Fj,$.gD.5b);1a Fj(){$(1f).1g(tZ,1m);1I.1z=1z;2A.1I.VF.3h(1f,2j)}}1a zz(1I){if(hv){jQ(hv);hv=1c}}1a 3R(1I){if($(J).1g(tZ)){1b 1I.dI()||1j}}K 1z="gD";K 9Q="."+1z;K Fe="7t"+9Q;K zw="3R"+9Q;K Ft="9X"+9Q;K Fv="6A"+9Q;K Fn="fB"+9Q;K Fi="5j"+9Q;K Fq="pV"+9Q;K Fp="pO"+9Q;K Fm="pS"+9Q;K Fl="D3"+9Q;K WX="5b"+9Q;K WW="9e"+9Q;K tZ="OI"+9Q})(2A);(1a($){$.fn.r2=1a(1w){K iV=$.4n({},$.fn.r2.cc,1w);1b J.2e(1a(){$J=$(J);K o=$.WO?$.4n({},iV,$J.1g()):iV;K nM=o.2S;$.fn.jV(o,$J,nM)})};K AF=0;K sZ=0;K WQ=bw.X9;K Fx=bw.X2;if(Fx.51("Ww 7.0")>0){K ue="u6"}$.fn.r2.cc={6l:5,2S:12,4u:5,cI:1m,zG:"#lF",jO:"#Wv",jr:"Wu",zh:"#lF",jw:"#lF",ly:"#lF",5B:1m,y5:1m,wm:"Wx",p0:1a(){1b 1j}};$.fn.jV=1a(o,1v,nM){if(o.4u>o.6l){o.4u=o.6l}$J.dn();if(o.y5){K Fs="9U-Fr-dt";K Fd="9U-dH-dt";K GV="9U-J7-dt";K Ja="9U-3p-dt"}1i{K Fs="9U-Fr";K Fd="9U-dH";K GV="9U-J7";K Ja="9U-3p"}if(o.5B){K yS=$("<2E>&lt;</2E>").3z({bG:{oz:"ui-3C-Jb-1-w"},2a:1j})}$J.3F(\'<2E id="WF">\'+\'<2E id="WD">\'+\'<2E id="Us">\'+\'<2E id="tI"></2E>\'+\'<2E id="tP"></2E>\'+\'<2E id="oS"></2E>\'+"</2E>"+"</2E>"+"</2E>");K J1=$("#tI").2y("9U-3g-wE");J1.2Y(yS);K 8q=$(\'<1B oe="0" od="0">\').2I("cO","5S");K ic=$("<tr>").2y("9U-Uw");K c=(o.4u-1)/2;K 4a=nM-c;K nA;1o(K i=0;i<o.6l;i++){K 2c=i+1;if(2c==nM){K nG=$(\'<td 2C="li">\').3F(\'<2B 2C="9U-5F">\'+2c+"</2B>");nA=nG;ic.2Y(nG)}1i{K nG=$(\'<td 2C="li">\').3F("<a>"+2c+"</a>");ic.2Y(nG)}}8q.2Y(ic);if(o.5B){K yR=$("<2E>&gt;</2E>").3z({bG:{oz:"ui-3C-Jb-1-e"},2a:1j})}K n7=$("#tP").2y("9U-3g-Un");n7.2Y(yR);$("#oS").2Y(8q);K tN=$("#oS");K zI=1c;1a Jl(){$("#tI").3S();$("#tP").3S()}1a Je(){$("#tI").5i();$("#tP").5i()}1a zF(){if(tN.1k()==0){1b}ts(zI);if(8q.1k()<=tN.1k()){Jl()}1i{Je()}}if(tN.1k()==0){zI=oN(zF,nk)}1i{zF()}$J.2y("UF");if(!o.cI){if(o.jr=="3j"){K f5={"3B":o.jO}}1i{K f5={"3B":o.jO,"jL-3B":o.jr}}if(o.ly=="3j"){K f4={"3B":o.jw}}1i{K f4={"3B":o.jw,"jL-3B":o.ly}}}1i{if(o.jr=="3j"){K f5={"3B":o.jO,"cI":"lG qd "+o.zG}}1i{K f5={"3B":o.jO,"jL-3B":o.jr,"cI":"lG qd "+o.zG}}if(o.ly=="3j"){K f4={"3B":o.jw,"cI":"lG qd "+o.zh}}1i{K f4={"3B":o.jw,"jL-3B":o.ly,"cI":"lG qd "+o.zh}}}$.fn.z9(o,$J,f5,f4,ic,8q,n7);K yQ=AF-1;if(ue=="u6"){}1i{}if(o.wm=="N2"){yR.7t(1a(){ud=oN(1a(){K 1Z=8q.1N().4I()+5;8q.1N().4I(1Z)},20)}).6A(1a(){ts(ud)});yS.7t(1a(){ud=oN(1a(){K 1Z=8q.1N().4I()-5;8q.1N().4I(1Z)},20)}).6A(1a(){ts(ud)})}8q.2g(".li").3R(1a(e){nA.3F("<a>"+nA.2g(".9U-5F").3F()+"</a>");K yP=$(J).2g("a").3F();$(J).3F(\'<2B 2C="9U-5F">\'+yP+"</2B>");nA=$(J);$.fn.z9(o,$(J).1N().1N().1N(),f5,f4,ic,8q,n7);K 1Z=J.8H/2;K UD=8q.4I()+1Z;K 8x=1Z-yQ/2;if(ue=="u6"){8q.4z({4I:1Z+8x+52+"px"})}1i{8q.4z({4I:1Z+8x+"px"})}o.p0(yP)});K 7i=8q.2g(".li").eq(o.2S-1);7i.1l("id","8x");K 1Z=2N.fu("8x").8H/2;7i.l8("id");K 8x=1Z-yQ/2;if(ue=="u6"){8q.4z({4I:1Z+8x+52+"px"})}1i{8q.4z({4I:1Z+8x+"px"})}};$.fn.z9=1a(o,1v,f5,f4,ic,8q,n7){1v.2g("a").2I(f5);1v.2g("2B.9U-5F").2I(f4);1v.2g("a").6Q(1a(){$(J).2I(f4)},1a(){$(J).2I(f5)});sZ=0;1v.2g(".li").2e(1a(i,n){if(i==o.4u-1){AF=J.8H+J.cR}sZ+=J.cR});sZ+=3}})(2A);(1a($){$.4n({hJ:1a(fn,t9,9t,AL){K 9e;1b 1a(){K 2j=2t;9t=9t||J;AL&&(!9e&&fn.3h(9t,2j));jQ(9e);9e=6K(1a(){!AL&&fn.3h(9t,2j);9e=1c},t9)}},CF:1a(fn,t9,9t){K 9e,2j,sX;1b 1a(){2j=2t;sX=1m;9t=9t||J;if(!9e){(1a(){if(sX){fn.3h(9t,2j);sX=1j;9e=6K(2t.IU,t9)}1i{9e=1c}})()}}}})})(2A);(1a($){K iD={kz:{AZ:1a(i){3x(J.lp(i)){1p"3Z":;1p"U8":;1p"c6":1b i.3u();1p"1C":K o=[];1o(x=0;x<i.1e;i++){o.1H(i+": "+J.AZ(i[x]))}1b o.53(", ");1p"4i":1b i;5v:1b i}},lp:1a(i){if(!i||!i.5e){1b 2s i}K 3k=i.5e.3u().3k(/3D|6p|5w|4D|5A/);1b 3k&&3k[0].3N()||2s i},kF:1a(7o,l,s,t){K p=s||" ";K o=7o;if(l-7o.1e>0){o=(1T 3D(3o.j8(l/ p.1e))).53(p).7l(0, t = !t ? l : t == 1 ? 0 : 3o.j8(l /2))+7o+p.7l(0,l-t)}1b o},IT:1a(4s,2j){K 1q=4s.tH();3x(J.lp(2j)){1p"1C":K 84=1q.3w(".");K 1v=2j;1o(K cd=0;cd<84.1e;cd++){1v=1v[84[cd]]}if(2s 1v!="2p"){if(iD.kz.lp(1v)=="3Z"){1b 4s.iH().3k(/\\.\\*/)&&1v[1]||1v}1b 1v}1i{}1r;1p"3Z":1q=5R(1q,10);if(4s.iH().3k(/\\.\\*/)&&2s 2j[1q+1]!="2p"){1b 2j[1q+1]}1i{if(2s 2j[1q]!="2p"){1b 2j[1q]}1i{1b 1q}}1r}1b"{"+1q+"}"},IO:1a(dG,2j){K 4s=1T IQ(dG,2j);1b iD.kz[4s.iH().3J(-1)](J.IT(4s,2j),4s)},d:1a(2f,4s){K o=5R(2f,10);K p=4s.mq();if(p){1b J.kF(o.3u(),p,4s.ml(),0)}1i{1b o}},i:1a(2f,2j){1b J.d(2f,2j)},o:1a(2f,4s){K o=2f.3u(8);if(4s.mr()){o=J.kF(o,o.1e+1,"0",0)}1b J.kF(o,4s.mq(),4s.ml(),0)},u:1a(2f,2j){1b 3o.4j(J.d(2f,2j))},x:1a(2f,4s){K o=5R(2f,10).3u(16);o=J.kF(o,4s.mq(),4s.ml(),0);1b 4s.mr()?"U7"+o:o},X:1a(2f,4s){1b J.x(2f,4s).8P()},e:1a(2f,4s){1b cq(2f,10).AY(4s.tG())},E:1a(2f,4s){1b J.e(2f,4s).8P()},f:1a(2f,4s){1b J.kF(cq(2f,10).4G(4s.tG()),4s.mq(),4s.ml(),0)},F:1a(2f,2j){1b J.f(2f,2j)},g:1a(2f,4s){K o=cq(2f,10);1b o.3u().1e>6?3o.4R(o.AY(4s.tG())):o},G:1a(2f,2j){1b J.g(2f,2j)},c:1a(2f,2j){K 3k=2f.3k(/\\w|\\d/);1b 3k&&3k[0]||""},r:1a(2f,2j){1b J.AZ(2f)},s:1a(2f,2j){1b 2f.3u&&2f.3u()||""+2f}},6W:1a(7o,2j){K 4g=0;K 2S=0;K 3k=1j;K iv=[];K dG="";K 8x=(7o||"").3w("");1o(2S=0;2S<8x.1e;2S++){if(8x[2S]=="{"&&8x[2S+1]!="{"){4g=7o.51("}",2S);dG=8x.3J(2S+1,4g).53("");iv.1H(iD.kz.IO(dG,2s 2t[1]!="1C"?JV(2t,2):2j||[]))}1i{if(2S>4g||iv.1e<1){iv.1H(8x[2S])}}}1b iv.1e>1?iv.53(""):iv[0]},TZ:1a(7o,2j){1b tM(6W(7o,2j))},lb:1a(s,n){1b(1T 3D(n+1)).53(s)},TY:1a(s){1b Uh(Ug(s))},Uk:1a(s){1b Uj(Ui(s))},Ub:1a(){K 2q="",Ua=1m;if(2t.1e==2&&$.aF(2t[1])){J[2t[0]]=2t[1].53("");1b 2A}if(2t.1e==2&&$.U9(2t[1])){J[2t[0]]=2t[1];1b 2A}if(2t.1e==1){1b $(J[2t[0]])}if(2t.1e==2&&2t[1]==1j){1b J[2t[0]]}if(2t.1e==2&&$.IS(2t[1])){1b $($.6W(J[2t[0]],2t[1]))}if(2t.1e==3&&$.IS(2t[1])){1b 2t[2]==1m?$.6W(J[2t[0]],2t[1]):$($.6W(J[2t[0]],2t[1]))}}};K IQ=1a(4s,2j){J.AQ=4s;J.iE=2j;J.Vj=cq("1."+(1T 3D(32)).53("1"),10).3u().1e-3;J.mY=6;J.mi=1a(){1b J.AQ};J.tH=1a(){1b J.AQ.3w(":")[0]};J.iH=1a(){K 3k=J.mi().3w(":");1b 3k&&3k[1]?3k[1]:"s"};J.tG=1a(){K 3k=J.iH().3k(/\\.(\\d+|\\*)/g);if(!3k){1b J.mY}1i{3k=3k[0].3J(1);if(3k!="*"){1b 5R(3k,10)}1i{if(iD.kz.lp(J.iE)=="3Z"){1b J.iE[1]&&J.iE[0]||J.mY}1i{if(iD.kz.lp(J.iE)=="1C"){1b J.iE[J.tH()]&&J.iE[J.tH()][0]||J.mY}1i{1b J.mY}}}}};J.mq=1a(){K 3k=1j;if(J.mr()){3k=J.mi().3k(/0?#0?(\\d+)/);if(3k&&3k[1]){1b 5R(3k[1],10)}}3k=J.mi().3k(/(0|\\.)(\\d+|\\*)/g);1b 3k&&5R(3k[0].3J(1),10)||0};J.ml=1a(){K o="";if(J.mr()){o=" "}if(J.iH().3k(/#0|0#|^0|\\.\\d+/)){o="0"}1b o};J.Vf=1a(){K 3k=J.mi().Ve(/^(0|\\#|\\-|\\+|\\s)+/);1b 3k&&3k[0].3w("")||[]};J.mr=1a(){1b!!J.iH().3k(/^0?#/)}};K JV=1a(2j,c0){K o=[];1o(l=2j.1e,x=(c0||0)-1;x<l;x++){o.1H(2j[x])}1b o};$.4n(iD)})(2A);(1a($){$.hH=1a(o){if(2s eF=="1C"&&eF.JU){1b eF.JU(o)}K 1z=2s o;if(o===1c){1b"1c"}if(1z=="2p"){1b 2p}if(1z=="c6"||1z=="ot"){1b o+""}if(1z=="4i"){1b $.A4(o)}if(1z=="1C"){if(2s o.hH=="1a"){1b $.hH(o.hH())}if(o.5e===5A){K md=o.Vx()+1;if(md<10){md="0"+md}K m7=o.Vw();if(m7<10){m7="0"+m7}K JZ=o.Vp();K mO=o.Vr();if(mO<10){mO="0"+mO}K mQ=o.Va();if(mQ<10){mQ="0"+mQ}K mW=o.UU();if(mW<10){mW="0"+mW}K g1=o.UT();if(g1<100){g1="0"+g1}if(g1<10){g1="0"+g1}1b\'"\'+JZ+"-"+md+"-"+m7+"T"+mO+":"+mQ+":"+mW+"."+g1+\'Z"\'}if(o.5e===3D){K 83=[];1o(K i=0;i<o.1e;i++){83.1H($.hH(o[i])||"1c")}1b"["+83.53(",")+"]"}K AS=[];1o(K k in o){K 1x;K 1z=2s k;if(1z=="c6"){1x=\'"\'+k+\'"\'}1i{if(1z=="4i"){1x=$.A4(k)}1i{bn}}if(2s o[k]=="1a"){bn}K 2c=$.hH(o[k]);AS.1H(1x+":"+2c)}1b"{"+AS.53(", ")+"}"}};$.UM=1a(4k){if(2s eF=="1C"&&eF.tp){1b eF.tp(4k)}1b tM("("+4k+")")};$.UO=1a(4k){if(2s eF=="1C"&&eF.tp){1b eF.tp(4k)}K g4=4k;g4=g4.3l(/\\\\["\\\\\\/V6]/g,"@");g4=g4.3l(/"[^"\\\\\\n\\r]*"|1m|1j|1c|-?\\d+(?:\\.\\d*)?(?:[eE][+\\-]?\\d+)?/g,"]");g4=g4.3l(/(?:^|:|,)(?:\\s*\\[)+/g,"");if(/^[\\],:{}\\s]*$/.96(g4)){1b tM("("+4k+")")}1i{8U 1T V8("9R V3 eF, aP is 5L V1.")}};$.A4=1a(4i){if(4i.3k(A5)){1b\'"\'+4i.3l(A5,1a(a){K c=JO[a];if(2s c==="4i"){1b c}c=a.JQ();1b"\\\\V2"+3o.e8(c/16).3u(16)+(c%16).3u(16)})+\'"\'}1b\'"\'+4i+\'"\'};K A5=/["\\\\\\UY-\\UZ\\V0-\\V7]/g;K JO={"\\b":"\\\\b","\\t":"\\\\t","\\n":"\\\\n","\\f":"\\\\f","\\r":"\\\\r",\'"\':\'\\\\"\',"\\\\":"\\\\\\\\"}})(2A);(1a($){$.fn.zY=1a(){K 56=1a(el,v,t,sO){K 2Z=2N.c4("2Z");2Z.1n=v,2Z.2a=t;K o=el.1w;K oL=o.1e;if(!el.8j){el.8j={};1o(K i=0;i<oL;i++){el.8j[o[i].1n]=i}}if(2s el.8j[v]=="2p"){el.8j[v]=oL}el.1w[el.8j[v]]=2Z;if(sO){2Z.1U=1m}};K a=2t;if(a.1e==0){1b J}K sO=1m;K m=1j;K 1F,v,t;if(2s a[0]=="1C"){m=1m;1F=a[0]}if(a.1e>=2){if(2s a[1]=="ot"){sO=a[1]}1i{if(2s a[2]=="ot"){sO=a[2]}}if(!m){v=a[0];t=a[1]}}J.2e(1a(){if(J.8A.3N()!="2u"){1b}if(m){1o(K 1h in 1F){56(J,1h,1F[1h],sO)}}1i{56(J,v,t,sO)}});1b J};$.fn.V9=1a(58,1y,2u,fn,2j){if(2s 58!="4i"){1b J}if(2s 1y!="1C"){1y={}}if(2s 2u!="ot"){2u=1m}J.2e(1a(){K el=J;$.V4(58,1y,1a(r){$(el).zY(r,2u);if(2s fn=="1a"){if(2s 2j=="1C"){fn.3h(el,2j)}1i{fn.2v(el)}}})});1b J};$.fn.JS=1a(){K a=2t;if(a.1e==0){1b J}K ta=2s a[0];K v,1S;if(ta=="4i"||(ta=="1C"||ta=="1a")){v=a[0];if(v.5e==3D){K l=v.1e;1o(K i=0;i<l;i++){J.JS(v[i],a[1])}1b J}}1i{if(ta=="c6"){1S=a[0]}1i{1b J}}J.2e(1a(){if(J.8A.3N()!="2u"){1b}if(J.8j){J.8j=1c}K 3v=1j;K o=J.1w;if(!!v){K oL=o.1e;1o(K i=oL-1;i>=0;i--){if(v.5e==e7){if(o[i].1n.3k(v)){3v=1m}}1i{if(o[i].1n==v){3v=1m}}if(3v&&a[1]===1m){3v=o[i].1U}if(3v){o[i]=1c}3v=1j}}1i{if(a[1]===1m){3v=o[1S].1U}1i{3v=1m}if(3v){J.3v(1S)}}});1b J};$.fn.V5=1a(zW){K Ka=$(J).K2();K a=2s zW=="2p"?1m:!!zW;J.2e(1a(){if(J.8A.3N()!="2u"){1b}K o=J.1w;K oL=o.1e;K sA=[];1o(K i=0;i<oL;i++){sA[i]={v:o[i].1n,t:o[i].2a}}sA.h3(1a(o1,o2){ty=o1.t.3N(),tv=o2.t.3N();if(ty==tv){1b 0}if(a){1b ty<tv?-1:1}1i{1b ty>tv?-1:1}});1o(K i=0;i<oL;i++){o[i].2a=sA[i].t;o[i].1n=sA[i].v}}).sW(Ka,1m);1b J};$.fn.sW=1a(1n,aN){K v=1n;K vT=2s 1n;if(vT=="1C"&&v.5e==3D){K $J=J;$.2e(v,1a(){$J.sW(J,aN)})}K c=aN||1j;if(vT!="4i"&&(vT!="1a"&&vT!="1C")){1b J}J.2e(1a(){if(J.8A.3N()!="2u"){1b J}K o=J.1w;K oL=o.1e;1o(K i=0;i<oL;i++){if(v.5e==e7){if(o[i].1n.3k(v)){o[i].1U=1m}1i{if(c){o[i].1U=1j}}}1i{if(o[i].1n==v){o[i].1U=1m}1i{if(c){o[i].1U=1j}}}}});1b J};$.fn.UR=1a(to,kd){K w=kd||"1U";if($(to).3M()==0){1b J}J.2e(1a(){if(J.8A.3N()!="2u"){1b J}K o=J.1w;K oL=o.1e;1o(K i=0;i<oL;i++){if(w=="6D"||w=="1U"&&o[i].1U){$(to).zY(o[i].1n,o[i].2a)}}});1b J};$.fn.UL=1a(1n,fn){K 98=1j;K v=1n;K vT=2s v;K fT=2s fn;if(vT!="4i"&&(vT!="1a"&&vT!="1C")){1b fT=="1a"?J:98}J.2e(1a(){if(J.8A.3N()!="2u"){1b J}if(98&&fT!="1a"){1b 1j}K o=J.1w;K oL=o.1e;1o(K i=0;i<oL;i++){if(v.5e==e7){if(o[i].1n.3k(v)){98=1m;if(fT=="1a"){fn.2v(o[i],i)}}}1i{if(o[i].1n==v){98=1m;if(fT=="1a"){fn.2v(o[i],i)}}}}});1b fT=="1a"?J:98};$.fn.K2=1a(){K v=[];J.zZ().2e(1a(){v[v.1e]=J.1n});1b v};$.fn.UN=1a(){K t=[];J.zZ().2e(1a(){t[t.1e]=J.2a});1b t};$.fn.zZ=1a(){1b J.2g("2Z:1U")}})(2A);(1a($){$.4n($.fn,{q3:1a(c1,c2){K K5=J.4H("."+c1);J.4H("."+c2).4o(c2).2y(c1);K5.4o(c1).2y(c2);1b J},i7:1a(c1,c2){1b J.4H("."+c1).4o(c1).2y(c2).4g()},uG:1a(aV){aV=aV||"6Q";1b J.6Q(1a(){$(J).2y(aV)},1a(){$(J).4o(aV)})},Jw:1a(gY,1V){gY?J.4z({1s:"d3"},gY,1V):J.2e(1a(){2A(J)[2A(J).is(":5S")?"5i":"3S"]();if(1V){1V.3h(J,2t)}})},JG:1a(gY,1V){if(gY){J.4z({1s:"3S"},gY,1V)}1i{J.3S();if(1V){J.2e(1V)}}},xj:1a(2X){if(!2X.Jx){J.4H(":7i-wo:5L(ul)").2y(59.7i);J.4H((2X.hS?"":"."+59.xn)+":5L(."+59.76+")").2g(">ul").3S()}1b J.4H(":3t(>ul)")},xg:1a(2X,lu){if(!2X.Jx){J.4H(":3t(>ul:5S)").2y(59.bT).i7(59.7i,59.j9);J.5L(":3t(>ul:5S)").2y(59.cG).i7(59.7i,59.ja);J.lf(\'<2E 2C="\'+59.4y+\'"/>\').2g("2E."+59.4y).2e(1a(){K gK="";$.2e($(J).1N().1l("2C").3w(" "),1a(){gK+=J+"-4y "});$(J).2y(gK)})}J.2g("2E."+59.4y).3R(lu)},jE:1a(2X){2X=$.4n({x0:"jE"},2X);if(2X.56){1b J.1O("56",[2X.56])}if(2X.d3){K 1V=2X.d3;2X.d3=1a(){1b 1V.3h($(J).1N()[0],2t)}}1a HI(4e,3g){1a 7X(4H){1b 1a(){lu.3h($("2E."+59.4y,4e).4H(1a(){1b 4H?$(J).1N("."+4H).1e:1m}));1b 1j}}$("a:eq(0)",3g).3R(7X(59.cG));$("a:eq(1)",3g).3R(7X(59.bT));$("a:eq(2)",3g).3R(7X())}1a lu(){$(J).1N().2g(">.4y").q3(59.wC,59.wF).q3(59.vp,59.vr).4g().q3(59.cG,59.bT).q3(59.ja,59.j9).2g(">ul").Jw(2X.gY,2X.d3);if(2X.US){$(J).1N().Hg().2g(">.4y").i7(59.wC,59.wF).i7(59.vp,59.vr).4g().i7(59.cG,59.bT).i7(59.ja,59.j9).2g(">ul").JG(2X.gY,2X.d3)}}1a Bp(){1a Vq(4s){1b 4s?1:0}K 1g=[];i3.2e(1a(i,e){1g[i]=$(e).is(":3t(>ul:5X)")?1:0});$.xo(2X.x0,1g.53(""))}1a HE(){K xr=$.xo(2X.x0);if(xr){K 1g=xr.3w("");i3.2e(1a(i,e){$(e).2g(">ul")[5R(1g[i])?"5i":"3S"]()})}}J.2y("jE");K i3=J.2g("li").xj(2X);3x(2X.Vn){1p"xo":K xw=2X.d3;2X.d3=1a(){Bp();if(xw){xw.3h(J,2t)}};HE();1r;1p"hC":K 5F=J.2g("a").4H(1a(){1b J.5d.3N()==hC.5d.3N()});if(5F.1e){5F.2y("1U").aT("ul, li").56(5F.3p()).5i()}1r}i3.xg(2X,lu);if(2X.3g){HI(J,2X.3g);$(2X.3g).5i()}1b J.2O("56",1a(1I,i3){$(i3).3H().4o(59.7i).4o(59.ja).4o(59.j9).2g(">.4y").4o(59.vp).4o(59.vr);$(i3).2g("li").Vu().xj(2X).xg(2X,lu)})}});K 59=$.fn.jE.gK={76:"76",xn:"xn",bT:"bT",wF:"bT-4y",vr:"j9-4y",cG:"cG",wC:"cG-4y",vp:"ja-4y",ja:"ja",j9:"j9",7i:"7i",4y:"4y"};$.fn.Vh=$.fn.jE})(2A);(1a($,2p){$.e4.HZ="Vi"in 3n;$.e4.I9="UK"in 3n;$.e4.Ig="Uc"in 2N.8m;if(!$.ui||!$.ui.8l){K GY=$.H5;$.H5=1a(wR){1o(K i=0,49;(49=wR[i])!=1c;i++){7a{$(49).Ue("3v")}7b(e){}}GY(wR)}}K $7L=1c,mf=1j,$5n=$(3n),cm=0,bQ={},9M={},kn={},cc={3X:1c,4E:1c,1O:"7w",Hi:1j,h6:ep,kI:1j,GW:1a($1Q){if($.ui&&$.ui.2K){$1Q.2I("4u","6C").2K({my:"1Z 1L",at:"1Z 4p",of:J,2n:"0 5",nJ:"bM"}).2I("4u","3j")}1i{K 2n=J.2n();2n.1L+=J.7k();2n.1Z+=J.8r()/ 2 - $1Q.8r() /2;$1Q.2I(2n)}},2K:1a(1D,x,y){K $J=J,2n;if(!x&&!y){1D.GW.2v(J,1D.$1Q);1b}1i{if(x==="H1"&&y==="H1"){2n=1D.$1Q.2K()}1i{2n={1L:y,1Z:x}}}K 4p=$5n.4T()+$5n.1s(),7w=$5n.4I()+$5n.1k(),1s=1D.$1Q.1s(),1k=1D.$1Q.1k();if(2n.1L+1s>4p){2n.1L-=1s}if(2n.1L<0){2n.1L=0}if(2n.1Z+1k>7w){2n.1Z-=1k}1D.$1Q.2I(2n)},Hf:1a($1Q){if($.ui&&$.ui.2K){$1Q.2I("4u","6C").2K({my:"1Z 1L",at:"7w 1L",of:J,nJ:"Uf bM"}).2I("4u","")}1i{K 2n={1L:0,1Z:J.8r()};$1Q.2I(2n)}},4w:U0,6R:{5b:0,5i:"U1",3S:"U2"},4M:{5i:$.wi,3S:$.wi},1V:1c,1F:{}},bu={9e:1c,77:1c,7B:1c},Hk=1a($t){1b TX;K vg=0,$tt=$t;43(1m){vg=3o.47(vg,5R($tt.2I("z-1S"),10)||0);$tt=$tt.1N();if(!$tt||(!$tt.1e||"3F 3s".51($tt.5D("8A").3N())>-1)){1r}}1b vg},4Z={oB:1a(e){e.4r();e.dI()},5j:1a(e){K $J=$(J);if(e.1g.1O=="7w"){e.4r();e.dI()}if(e.1g.1O!="7w"&&e.eC){1b}if($J.4L("2L-1Q-8X")){1b}if(!$J.4L("2L-1Q-2J")){$7L=$J;if(e.1g.8O){K lx=e.1g.8O($7L,e);if(lx===1j){1b}if(lx.1V!==2p&&lx.1V!=1c){e.1g.1V=lx.1V}e.1g=$.4n(1m,{},lx,cc,e.1g||{});if(!e.1g.1F||$.Iu(e.1g.1F)){if(3n.c7){(c7.9s||c7.ld).2v(c7,"No 1F uE to 5i in 2G")}8U 1T 9R("No 2W uE")}e.1g.$1O=$7L;op.7V(e.1g)}op.5i.2v($J,e.1g,e.77,e.7B)}},3R:1a(e){e.4r();e.dI();$(J).1O($.uD("5j",{1g:e.1g,77:e.77,7B:e.7B}))},7t:1a(e){K $J=$(J);if($7L&&($7L.1e&&!$7L.is($J))){$7L.1g("2G").$1Q.1O("5j:3S")}if(e.3z==2){$7L=$J.1g("wM",1m)}},6A:1a(e){K $J=$(J);if($J.1g("wM")&&($7L&&($7L.1e&&($7L.is($J)&&!$J.4L("2L-1Q-2J"))))){e.4r();e.dI();$7L=$J;$J.1O($.uD("5j",{1g:e.1g,77:e.77,7B:e.7B}))}$J.qt("wM")},oH:1a(e){K $J=$(J),$lm=$(e.qA),$2N=$(2N);if($lm.is(".2L-1Q-4V")||$lm.hB(".2L-1Q-4V").1e){1b}if($7L&&$7L.1e){1b}bu.77=e.77;bu.7B=e.7B;bu.1g=e.1g;$2N.on("9X.GZ",4Z.9X);bu.9e=6K(1a(){bu.9e=1c;$2N.dS("9X.GZ");$7L=$J;$J.1O($.uD("5j",{1g:bu.1g,77:bu.77,7B:bu.7B}))},e.1g.h6)},9X:1a(e){bu.77=e.77;bu.7B=e.7B},oO:1a(e){K $lm=$(e.qA);if($lm.is(".2L-1Q-4V")||$lm.hB(".2L-1Q-4V").1e){1b}7a{jQ(bu.9e)}7b(e){}bu.9e=1c},In:1a(e){K $J=$(J),2r=$J.1g("9S"),3z=e.3z,x=e.77,y=e.7B,3e,2n;e.4r();e.dI();6K(1a(){K $3n;K wN=2r.1O=="1Z"&&3z===0||2r.1O=="7w"&&3z===2;if(2N.ql&&2r.$6r){2r.$6r.3S();3e=2N.ql(x-$5n.4I(),y-$5n.4T());2r.$6r.5i()}if(2r.kI&&wN){if(2N.ql){if(2r.$1O.is(3e)||2r.$1O.3t(3e).1e){2r.2K.2v(2r.$1O,2r,x,y);1b}}1i{2n=2r.$1O.2n();$3n=$(3n);2n.1L+=$3n.4T();if(2n.1L<=e.7B){2n.1Z+=$3n.4I();if(2n.1Z<=e.77){2n.4p=2n.1L+2r.$1O.7k();if(2n.4p>=e.7B){2n.7w=2n.1Z+2r.$1O.8r();if(2n.7w>=e.77){2r.2K.2v(2r.$1O,2r,x,y);1b}}}}}}if(3e&&wN){2r.$1O.Bg("5j:5S",1a(){$(3e).2G({x:x,y:y})})}2r.$1Q.1O("5j:3S")},50)},gJ:1a(e,1D){if(!1D.dK){e.4r()}e.88()},1q:1a(e){K 1D={};if($7L){1D=$7L.1g("2G")||{}}3x(e.3V){1p 9:;1p 38:4Z.gJ(e,1D);if(1D.dK){if(e.3V==9&&e.oc){e.4r();1D.$1U&&1D.$1U.2g("2f, 8c, 2u").5c();1D.$1Q.1O("xH");1b}1i{if(e.3V==38&&1D.$1U.2g("2f, 8c, 2u").5D("1z")=="8f"){e.4r();1b}}}1i{if(e.3V!=9||e.oc){1D.$1Q.1O("xH");1b}};1p 40:4Z.gJ(e,1D);if(1D.dK){if(e.3V==9){e.4r();1D.$1U&&1D.$1U.2g("2f, 8c, 2u").5c();1D.$1Q.1O("uC");1b}1i{if(e.3V==40&&1D.$1U.2g("2f, 8c, 2u").5D("1z")=="8f"){e.4r();1b}}}1i{1D.$1Q.1O("uC");1b}1r;1p 37:4Z.gJ(e,1D);if(1D.dK||(!1D.$1U||!1D.$1U.1e)){1r}if(!1D.$1U.1N().4L("2L-1Q-2r")){K $1N=1D.$1U.1N().1N();1D.$1U.1O("5j:5c");1D.$1U=$1N;1b}1r;1p 39:4Z.gJ(e,1D);if(1D.dK||(!1D.$1U||!1D.$1U.1e)){1r}K vh=1D.$1U.1g("2G")||{};if(vh.$1Q&&1D.$1U.4L("2L-1Q-y8")){1D.$1U=1c;vh.$1U=1c;vh.$1Q.1O("uC");1b}1r;1p 35:;1p 36:if(1D.$1U&&1D.$1U.2g("2f, 8c, 2u").1e){1b}1i{(1D.$1U&&1D.$1U.1N()||1D.$1Q).6a(":5L(.2J, .5L-jf)")[e.3V==36?"4a":"7i"]().1O("5j:3b");e.4r();1b}1r;1p 13:4Z.gJ(e,1D);if(1D.dK){if(1D.$1U&&!1D.$1U.is("8c, 2u")){e.4r();1b}1r}1D.$1U&&1D.$1U.1O("6A");1b;1p 32:;1p 33:;1p 34:4Z.gJ(e,1D);1b;1p 27:4Z.gJ(e,1D);1D.$1Q.1O("5j:3S");1b;5v:K k=5w.DU(e.3V).8P();if(1D.gP&&1D.gP[k]){1D.gP[k].$1u.1O(1D.gP[k].$1Q?"5j:3b":"6A");1b}1r}e.88();1D.$1U&&1D.$1U.1O(e)},hZ:1a(e){e.88();K 1D=$(J).1g("2G")||{};if(1D.$1U){K $s=1D.$1U;1D=1D.$1U.1N().1g("2G")||{};1D.$1U=$s}K $6a=1D.$1Q.6a(),$3H=!1D.$1U||!1D.$1U.3H().1e?$6a.7i():1D.$1U.3H(),$4R=$3H;43($3H.4L("2J")||$3H.4L("5L-jf")){if($3H.3H().1e){$3H=$3H.3H()}1i{$3H=$6a.7i()}if($3H.is($4R)){1b}}if(1D.$1U){4Z.wp.2v(1D.$1U.44(0),e)}4Z.ut.2v($3H.44(0),e);K $2f=$3H.2g("2f, 8c, 2u");if($2f.1e){$2f.3b()}},i0:1a(e){e.88();K 1D=$(J).1g("2G")||{};if(1D.$1U){K $s=1D.$1U;1D=1D.$1U.1N().1g("2G")||{};1D.$1U=$s}K $6a=1D.$1Q.6a(),$3p=!1D.$1U||!1D.$1U.3p().1e?$6a.4a():1D.$1U.3p(),$4R=$3p;43($3p.4L("2J")||$3p.4L("5L-jf")){if($3p.3p().1e){$3p=$3p.3p()}1i{$3p=$6a.4a()}if($3p.is($4R)){1b}}if(1D.$1U){4Z.wp.2v(1D.$1U.44(0),e)}4Z.ut.2v($3p.44(0),e);K $2f=$3p.2g("2f, 8c, 2u");if($2f.1e){$2f.3b()}},Il:1a(e){K $J=$(J).hB(".2L-1Q-1h"),1g=$J.1g(),1D=1g.2G,2r=1g.9S;2r.$1U=1D.$1U=$J;2r.dK=1D.dK=1m},Ib:1a(e){K $J=$(J).hB(".2L-1Q-1h"),1g=$J.1g(),1D=1g.2G,2r=1g.9S;2r.dK=1D.dK=1j},It:1a(e){K 2r=$(J).1g().9S;2r.vn=1m},Is:1a(e){K 2r=$(J).1g().9S;if(2r.$6r&&2r.$6r.is(e.qA)){2r.vn=1j}},ut:1a(e){K $J=$(J),1g=$J.1g(),1D=1g.2G,2r=1g.9S;2r.vn=1m;if(e&&(2r.$6r&&2r.$6r.is(e.qA))){e.4r();e.dI()}(1D.$1Q?1D:2r).$1Q.6a(".6Q").1O("5j:5c");if($J.4L("2J")||$J.4L("5L-jf")){1D.$1U=1c;1b}$J.1O("5j:3b")},wp:1a(e){K $J=$(J),1g=$J.1g(),1D=1g.2G,2r=1g.9S;if(2r!==1D&&(2r.$6r&&2r.$6r.is(e.qA))){2r.$1U&&2r.$1U.1O("5j:5c");e.4r();e.dI();2r.$1U=1D.$1U=1D.$1u;1b}$J.1O("5j:5c")},HS:1a(e){K $J=$(J),1g=$J.1g(),1D=1g.2G,2r=1g.9S,1q=1g.yy,1V;if(!1D.1F[1q]||$J.is(".2J, .2L-1Q-y8, .2L-1Q-5u, .5L-jf")){1b}e.4r();e.dI();if($.aQ(2r.lo[1q])&&4D.2V.7K.2v(2r.lo,1q)){1V=2r.lo[1q]}1i{if($.aQ(2r.1V)){1V=2r.1V}1i{1b}}if(1V.2v(2r.$1O,1q,2r,1g)!==1j){2r.$1Q.1O("5j:3S")}1i{if(2r.$1Q.1N().1e){op.85.2v(2r.$1O,2r)}}},HT:1a(e){e.dI()},Iq:1a(e,1g){K 2r=$(J).1g("9S");op.3S.2v(2r.$1O,2r,1g&&1g.eP)},HW:1a(e){e.88();K $J=$(J),1g=$J.1g(),1D=1g.2G,2r=1g.9S;$J.2y("6Q").Hg(".6Q").1O("5j:5c");1D.$1U=2r.$1U=$J;if(1D.$1u){2r.Hf.2v(1D.$1u,1D.$1Q)}},HN:1a(e){e.88();K $J=$(J),1g=$J.1g(),1D=1g.2G;$J.4o("6Q");1D.$1U=1c}},op={5i:1a(1D,x,y){if(2s vl!="2p"&&vl){1b}vl=1m;K $1O=$(J),2I={};$("#2L-1Q-6r").1O("7t");1D.$1O=$1O;if(1D.4M.5i.2v($1O,1D)===1j){$7L=1c;1b}op.85.2v($1O,1D);1D.2K.2v($1O,1D,x,y);if(1D.4w){2I.4w=Hk($1O)+1D.4w}op.6r.2v(1D.$1Q,1D,2I.4w);1D.$1Q.2g("ul").2I("4w",2I.4w+1);1D.$1Q.2I(2I)[1D.6R.5i](1D.6R.5b,1a(){$1O.1O("5j:5X")});$1O.1g("2G",1D).2y("2L-1Q-8X");$(2N).dS("8k.2G").on("8k.2G",4Z.1q);if(1D.Hi){$(2N).on("9X.xS",1a(e){K 3G=$1O.2n();3G.7w=3G.1Z+$1O.8r();3G.4p=3G.1L+$1O.7k();if(1D.$6r&&(!1D.vn&&(!(e.77>=3G.1Z&&e.77<=3G.7w)||!(e.7B>=3G.1L&&e.7B<=3G.4p)))){1D.$1Q.1O("5j:3S")}})}},3S:1a(1D,eP){K $1O=$(J);if(!1D){1D=$1O.1g("2G")||{}}if(!eP&&(1D.4M&&1D.4M.3S.2v($1O,1D)===1j)){1b}$1O.qt("2G").4o("2L-1Q-8X");if(1D.$6r){6K(1a($6r){1b 1a(){$6r.3v()}}(1D.$6r),10);7a{46 1D.$6r}7b(e){1D.$6r=1c}}$7L=1c;1D.$1Q.2g(".6Q").1O("5j:5c");1D.$1U=1c;$(2N).dS(".xS").dS("8k.2G");1D.$1Q&&1D.$1Q[1D.6R.3S](1D.6R.5b,1a(){if(1D.8O){1D.$1Q.3v();$.2e(1D,1a(1q,1n){3x(1q){1p"ns":;1p"3X":;1p"8O":;1p"1O":1b 1m;5v:1D[1q]=2p;7a{46 1D[1q]}7b(e){}1b 1m}})}6K(1a(){$1O.1O("5j:5S")},10)});vl=1j},7V:1a(1D,2r){if(2r===2p){2r=1D}1D.$1Q=$(\'<ul 2C="2L-1Q-4V"></ul>\').2y(1D.aV||"").1g({"2G":1D,"9S":2r});$.2e(["lo","uy","uN"],1a(i,k){1D[k]={};if(!2r[k]){2r[k]={}}});2r.gP||(2r.gP={});$.2e(1D.1F,1a(1q,1h){K $t=$(\'<li 2C="2L-1Q-1h"></li>\').2y(1h.aV||""),$3K=1c,$2f=1c;$t.on("3R",$.wi);1h.$1u=$t.1g({"2G":1D,"9S":2r,"yy":1q});if(1h.yb){K He=Iv(1h.yb);1o(K i=0,ak;ak=He[i];i++){if(!2r.gP[ak]){2r.gP[ak]=1h;1h.uz=1h.1x.3l(1T e7("("+ak+")","i"),\'<2B 2C="2L-1Q-yb">$1</2B>\');1r}}}if(2s 1h=="4i"){$t.2y("2L-1Q-5u 5L-jf")}1i{if(1h.1z&&kn[1h.1z]){kn[1h.1z].2v($t,1h,1D,2r);$.2e([1D,2r],1a(i,k){k.uy[1q]=1h;if($.aQ(1h.1V)){k.lo[1q]=1h.1V}})}1i{if(1h.1z=="3F"){$t.2y("2L-1Q-3F 5L-jf")}1i{if(1h.1z){$3K=$("<3K></3K>").4E($t);$("<2B></2B>").3F(1h.uz||1h.1x).4E($3K);$t.2y("2L-1Q-2f");1D.Ia=1m;$.2e([1D,2r],1a(i,k){k.uy[1q]=1h;k.uN[1q]=1h})}1i{if(1h.1F){1h.1z="j3"}}}3x(1h.1z){1p"2a":$2f=$(\'<2f 1z="2a" 1n="1" 1x="" 1n="">\').1l("1x","2L-1Q-2f-"+1q).2c(1h.1n||"").4E($3K);1r;1p"8c":$2f=$(\'<8c 1x=""></8c>\').1l("1x","2L-1Q-2f-"+1q).2c(1h.1n||"").4E($3K);if(1h.1s){$2f.1s(1h.1s)}1r;1p"8f":$2f=$(\'<2f 1z="8f" 1n="1" 1x="" 1n="">\').1l("1x","2L-1Q-2f-"+1q).2c(1h.1n||"").5D("3T",!!1h.1U).EC($3K);1r;1p"8M":$2f=$(\'<2f 1z="8M" 1n="1" 1x="" 1n="">\').1l("1x","2L-1Q-2f-"+1h.8M).2c(1h.1n||"").5D("3T",!!1h.1U).EC($3K);1r;1p"2u":$2f=$(\'<2u 1x="">\').1l("1x","2L-1Q-2f-"+1q).4E($3K);if(1h.1w){$.2e(1h.1w,1a(1n,2a){$("<2Z></2Z>").2c(1n).2a(2a).4E($2f)});$2f.2c(1h.1U)}1r;1p"j3":$("<2B></2B>").3F(1h.uz||1h.1x).4E($t);1h.4E=1h.$1u;op.7V(1h,2r);$t.1g("2G",1h).2y("2L-1Q-y8");1h.1V=1c;1r;1p"3F":$(1h.3F).4E($t);1r;5v:$.2e([1D,2r],1a(i,k){k.uy[1q]=1h;if($.aQ(1h.1V)){k.lo[1q]=1h.1V}});$("<2B></2B>").3F(1h.uz||(1h.1x||"")).4E($t);1r}if(1h.1z&&(1h.1z!="j3"&&1h.1z!="3F")){$2f.on("3b",4Z.Il).on("5c",4Z.Ib);if(1h.4M){$2f.on(1h.4M,1D)}}if(1h.3C){$t.2y("3C 3C-"+1h.3C)}}}1h.$2f=$2f;1h.$3K=$3K;$t.4E(1D.$1Q);if(!1D.Ia&&$.e4.Ig){$t.on("UA.UH",4Z.oB)}});if(!1D.$1u){1D.$1Q.2I("4u","3j").2y("2L-1Q-2r")}1D.$1Q.4E(1D.4E||2N.3s)},5s:1a($1Q,Ie){$1Q.2I({2K:"6F",4u:"6C"});$1Q.1g("1k",3o.j8($1Q.1k())+1);$1Q.2I({2K:"Pl",ae:"BO",cS:"UI"});$1Q.2g("> li > ul").2e(1a(){op.5s($(J),1m)});if(!Ie){$1Q.2g("ul").UJ().2I({2K:"",4u:"",ae:"",cS:""}).1k(1a(){1b $(J).1g("1k")})}},85:1a(1D,2r){K $1O=J;if(2r===2p){2r=1D;op.5s(1D.$1Q)}1D.$1Q.6a().2e(1a(){K $1h=$(J),1q=$1h.1g("yy"),1h=1D.1F[1q],2J=$.aQ(1h.2J)&&1h.2J.2v($1O,1q,2r)||1h.2J===1m;$1h[2J?"2y":"4o"]("2J");if(1h.1z){$1h.2g("2f, 2u, 8c").5D("2J",2J);3x(1h.1z){1p"2a":;1p"8c":1h.$2f.2c(1h.1n||"");1r;1p"8f":;1p"8M":1h.$2f.2c(1h.1n||"").5D("3T",!!1h.1U);1r;1p"2u":1h.$2f.2c(1h.1U||"");1r}}if(1h.$1Q){op.85.2v($1O,1h,2r)}})},6r:1a(1D,4w){K $l=$("#2L-1Q-6r");if($l){$l.3v()}K $6r=1D.$6r=$(\'<2E id="2L-1Q-6r" 2l="2K:Ab; z-1S:\'+4w+\'; 1L:0; 1Z:0; 2R: 0; 4H: dQ(2R=0); jL-3B: #de;"></2E>\').2I({1s:$5n.1s(),1k:$5n.1k(),4u:"6C"}).1g("9S",1D).7h(J).on("5j",4Z.oB).on("7t",4Z.In);if(2N.3s.2l.cS===2p){$6r.2I({"2K":"6F","1s":$(2N).1s()})}1b $6r}};1a Iv(2c){K t=2c.3w(/\\s+/),84=[];1o(K i=0,k;k=t[i];i++){k=k.bq(0).8P();84.1H(k)}1b 84}$.fn.2G=1a(6Z){if(6Z===2p){J.4a().1O("5j")}1i{if(6Z.x&&6Z.y){J.4a().1O($.uD("5j",{77:6Z.x,7B:6Z.y}))}1i{if(6Z==="3S"){K $1Q=J.4a().1g("2G")?J.4a().1g("2G").$1Q:1c;$1Q&&$1Q.1O("5j:3S")}1i{if(6Z==="5M"){$.2G("5M",{2L:J})}1i{if(6Z==="1f"){if(J.1g("2G")!=1c){1b J.1g("2G").$1Q}1b[]}1i{if($.LC(6Z)){6Z.2L=J;$.2G("7V",6Z)}1i{if(6Z){J.4o("2L-1Q-2J")}1i{if(!6Z){J.2y("2L-1Q-2J")}}}}}}}}1b J};$.2G=1a(6Z,1w){if(2s 6Z!="4i"){1w=6Z;6Z="7V"}if(2s 1w=="4i"){1w={3X:1w}}1i{if(1w===2p){1w={}}}K o=$.4n(1m,{},cc,1w||{});K $2N=$(2N);K $2L=$2N;K oP=1j;if(!o.2L||!o.2L.1e){o.2L=2N}1i{$2L=$(o.2L).4a();o.2L=$2L.44(0);oP=o.2L!==2N}3x(6Z){1p"7V":if(!o.3X){8U 1T 9R("No 3X uE")}if(o.3X.3k(/.2L-1Q-(4V|1h|2f)($|\\s)/)){8U 1T 9R(\'UG 2O to 3X "\'+o.3X+\'" as it jg a Up aV\')}if(!o.8O&&(!o.1F||$.Iu(o.1F))){8U 1T 9R("No 2W uE")}cm++;o.ns=".2G"+cm;if(!oP){bQ[o.3X]=o.ns}9M[o.ns]=o;if(!o.1O){o.1O="7w"}if(!mf){$2N.on({"5j:3S.2G":4Z.Iq,"xH.2G":4Z.hZ,"uC.2G":4Z.i0,"5j.2G":4Z.oB,"oH.2G":4Z.It,"oO.2G":4Z.Is},".2L-1Q-4V").on("6A.2G",".2L-1Q-2f",4Z.HT).on({"6A.2G":4Z.HS,"5j:3b.2G":4Z.HW,"5j:5c.2G":4Z.HN,"5j.2G":4Z.oB,"oH.2G":4Z.ut,"oO.2G":4Z.wp},".2L-1Q-1h");mf=1m}$2L.on("5j"+o.ns,o.3X,o,4Z.5j);if(oP){$2L.on("3v"+o.ns,1a(){$(J).2G("5M")})}3x(o.1O){1p"6Q":$2L.on("oH"+o.ns,o.3X,o,4Z.oH).on("oO"+o.ns,o.3X,o,4Z.oO);1r;1p"1Z":$2L.on("3R"+o.ns,o.3X,o,4Z.3R);1r}if(!o.8O){op.7V(o)}1r;1p"5M":K $eO;if(oP){K 2L=o.2L;$.2e(9M,1a(ns,o){if(o.2L!==2L){1b 1m}$eO=$(".2L-1Q-4V").4H(":5X");if($eO.1e&&$eO.1g().9S.$1O.is($(o.2L).2g(o.3X))){$eO.1O("5j:3S",{eP:1m})}7a{if(9M[o.ns].$1Q){9M[o.ns].$1Q.3v()}46 9M[o.ns]}7b(e){9M[o.ns]=1c}$(o.2L).dS(o.ns);1b 1m})}1i{if(!o.3X){$2N.dS(".2G .xS");$.2e(9M,1a(ns,o){$(o.2L).dS(o.ns)});bQ={};9M={};cm=0;mf=1j;$("#2L-1Q-6r, .2L-1Q-4V").3v()}1i{if(bQ[o.3X]){$eO=$(".2L-1Q-4V").4H(":5X");if($eO.1e&&$eO.1g().9S.$1O.is(o.3X)){$eO.1O("5j:3S",{eP:1m})}7a{if(9M[bQ[o.3X]].$1Q){9M[bQ[o.3X]].$1Q.3v()}46 9M[bQ[o.3X]]}7b(e){9M[bQ[o.3X]]=1c}$2N.dS(bQ[o.3X])}}}1r;1p"WB":if(!$.e4.I9&&!$.e4.HZ||2s 1w=="ot"&&1w){$(\'1Q[1z="2L"]\').2e(1a(){if(J.id){$.2G({3X:"[5j="+J.id+"]",1F:$.2G.I4(J)})}}).2I("4u","3j")}1r;5v:8U 1T 9R(\'gv 6Z "\'+6Z+\'"\')}1b J};$.2G.WL=1a(1D,1g){if(1g===2p){1g={}}$.2e(1D.uN,1a(1q,1h){3x(1h.1z){1p"2a":;1p"8c":1h.1n=1g[1q]||"";1r;1p"8f":1h.1U=1g[1q]?1m:1j;1r;1p"8M":1h.1U=(1g[1h.8M]||"")==1h.1n?1m:1j;1r;1p"2u":1h.1U=1g[1q]||"";1r}})};$.2G.WG=1a(1D,1g){if(1g===2p){1g={}}$.2e(1D.uN,1a(1q,1h){3x(1h.1z){1p"2a":;1p"8c":;1p"2u":1g[1q]=1h.$2f.2c();1r;1p"8f":1g[1q]=1h.$2f.5D("3T");1r;1p"8M":if(1h.$2f.5D("3T")){1g[1h.8M]=1h.1n}1r}});1b 1g};1a lY(1u){1b 1u.id&&$(\'3K[1o="\'+1u.id+\'"]\').2c()||1u.1x}1a E6(1F,$6a,cm){if(!cm){cm=0}$6a.2e(1a(){K $1u=$(J),1u=J,8A=J.8A.3N(),3K,1h;if(8A=="3K"&&$1u.2g("2f, 8c, 2u").1e){3K=$1u.3F();$1u=$1u.6a().4a();1u=$1u.44(0);8A=1u.8A.3N()}3x(8A){1p"1Q":1h={1x:$1u.1l("3K"),1F:{}};cm=E6(1h.1F,$1u.6a(),cm);1r;1p"a":;1p"3z":1h={1x:$1u.3F(),2J:!!$1u.1l("2J"),1V:1a(){1b 1a(){$1u.3R()}}()};1r;1p"I1":;1p"8t":3x($1u.1l("1z")){1p 2p:;1p"8t":;1p"I1":1h={1x:$1u.1l("3K"),2J:!!$1u.1l("2J"),1V:1a(){1b 1a(){$1u.3R()}}()};1r;1p"8f":1h={1z:"8f",2J:!!$1u.1l("2J"),1x:$1u.1l("3K"),1U:!!$1u.1l("3T")};1r;1p"8M":1h={1z:"8M",2J:!!$1u.1l("2J"),1x:$1u.1l("3K"),8M:$1u.1l("WI"),1n:$1u.1l("id"),1U:!!$1u.1l("3T")};1r;5v:1h=2p}1r;1p"hr":1h="-------";1r;1p"2f":3x($1u.1l("1z")){1p"2a":1h={1z:"2a",1x:3K||lY(1u),2J:!!$1u.1l("2J"),1n:$1u.2c()};1r;1p"8f":1h={1z:"8f",1x:3K||lY(1u),2J:!!$1u.1l("2J"),1U:!!$1u.1l("3T")};1r;1p"8M":1h={1z:"8M",1x:3K||lY(1u),2J:!!$1u.1l("2J"),8M:!!$1u.1l("1x"),1n:$1u.2c(),1U:!!$1u.1l("3T")};1r;5v:1h=2p;1r}1r;1p"2u":1h={1z:"2u",1x:3K||lY(1u),2J:!!$1u.1l("2J"),1U:$1u.2c(),1w:{}};$1u.6a().2e(1a(){1h.1w[J.1n]=$(J).3F()});1r;1p"8c":1h={1z:"8c",1x:3K||lY(1u),2J:!!$1u.1l("2J"),1n:$1u.2c()};1r;1p"3K":1r;5v:1h={1z:"3F",3F:$1u.6e(1m)};1r}if(1h){cm++;1F["1q"+cm]=1h}});1b cm}$.2G.I4=1a(1f){K $J=$(1f),1F={};E6(1F,$J.6a());1b 1F};$.2G.cc=cc;$.2G.kn=kn;$.2G.4Z=4Z;$.2G.op=op;$.2G.9M=9M})(2A);K Io=1a(id){J.id=id;J.1f=1c;J.2Q=1T 3D;J.pv=0;J.Ea=20;J.EK=1a(2Q){46 J.2Q;J.2Q=1T 3D;K li=1T 3D;1o(K i=0;i<2Q.1e;i++){K 1n=2Q[i];li.1H(\'<li 1n="\'+i+\'" 2C="\'+1n.ex+\'">\'+1n.2a+"</li>");J.2Q.1H(1n.1n)}J.1f.3F("<ul>"+li.53("\\n")+"</ul>");K me=J;J.1f.4O("6A",1a(e){K li=e.3e;if(li.6v.8P()!="LI"){1b}K $li=$(e.3e);e.88();J.vs.vx($li.2a(),me.vs.k2(li.1n))},J).4O("7t",1a(e){e.88()},J);J.HO();J.uX(10)};J.HO=1a(){J.1f.2I("gc","5S");J.1f.5i();K ag=J.1f.2g("li");if(ag.1e>0){J.Ea=ag[0].8z}J.1f.2I("gc","5X");J.1f.3S()};J.uX=1a(p6){if(J.1f.2g("li").1e>p6){J.pv=J.Ea*p6;J.1f.2I("1s",J.pv+"px");J.1f.2I("cO","5T")}1i{J.1f.2I("1s","5T");J.1f.2I("cO","5X")}};J.k2=1a(1S){1b J.2Q[1S]};J.HP=1a(){J.1f.2g("li").4o("3k")};J.BB=1a(2a){K cD=lc(2a);J.HP();K 93=J.uP(cD);$(93).2y("3k");if(93.1e>0){J.uk($(93[0]))}1i{J.Dl()}};J.HL=1a(2a){K cD=lc(2a);K 93=J.uP(cD);K 5F=J.jC();if(5F.1e>0&&93.1e>1){K 1S=93.51(5F[0]);if(1S<93.1e-1){1b $(93[1S+1])}1i{1b $(93[0])}}1b 1c};J.HU=1a(2a){K cD=lc(2a);K 93=J.uP(cD);K 5F=J.jC();if(5F.1e>0&&93.1e>1){K 1S=93.51(5F[0]);if(1S>0){1b $(93[1S-1])}1i{1b $(93[93.1e-1])}}1b 1c};J.uP=1a(2a){K 1J=[];if(1M(2a)){1b 1J}K cY=2a.3l(/([$-/:-?{-~!"^1X`\\[\\]\\\\])/g, "\\\\$1");K ag=J.1f.2g("li");1o(K i=0;i<ag.1e;i++){K li=ag[i];K Dr=lc(!1M(li.HQ)?li.HQ:li.Wz);K Dq=lc(J.k2(li.1n));if(QB.1d.2H.uJ){cY="(^"+2a+")|([.]"+2a+")"}if(2a==Dr||2a==Dq){1J.1H(li)}1i{if(Dr.96(cY)||Dq.96(cY)){1J.1H(li)}}}1b 1J};J.EB=1a(){J.1f.2g("li.1U").4o("1U")};J.Es=1a(2a,dB,h1){K li=J.jC();if(!li.1e){li=J.Dl()}K fj=1c;if(dB=="dX"){if(h1){fj=J.HL(2a)}if(fj==1c){fj=li.3p()}}1i{if(dB=="up"){if(h1){fj=J.HU(2a)}if(fj==1c){fj=li.3H()}}}if(fj!=1c){J.uk(fj);J.HV(li)}};J.uk=1a(li){J.EB();li.2y("1U");J.HR(li)};J.Dl=1a(){K 4a=J.1f.2g("li:4a");J.uk(4a);1b 4a};J.HV=1a(lN){lN.4o("1U")};J.jC=1a(){1b J.1f.2g("li.1U")};J.HR=1a(lN){if(J.pv&&(lN!=1c&&lN.1e>0)){J.1f.4T(lN[0].8V-J.pv/2)}};J.8h=1a(){J.1f=$(\'<2E 2C="cB-2u-1w"></2E>\').4E($(2N.3s))};J.8h()};K a4={uB:{},cT:[],nO:{},EZ:1j,2L:1c,8h:1a(){J.Ir();J.EZ=1m},Ir:1a(){},Ex:1a(az){if(1M(az)||1M(J.uB[az])){J.uB[az]=1T Io(az)}1b J.uB[az]},yt:1a(id,2Q){J.Ex(id).EK(2Q)}};(1a($){$.fn.EQ=1a(1w){if(!a4.EZ){a4.8h()}K me=J;K cc={95:1j,h8:1m,p6:10,X8:1j};K 2X=$.4n(cc,1w);K kU=1j;$(J).2e(1a(i,EX){K 1f=$(EX);if(1f.1g("cB-hp")==2p){a4.cT.1H(1T Ek(EX,2X));1f.1g("cB-hp",a4.cT.1e-1)}});1b $(J)};$.fn.ER=1a(){K 83=[];$(J).2e(1a(){if($(J).1g("cB-hp")!==2p){83[83.1e]=a4.cT[$(J).1g("cB-hp")]}});1b 83};K Ek=1a(2u,2X){J.8h(2u,2X)};Ek.2V={jG:1j,2X:1j,61:1j,2u:1j,64:1j,az:1c,hA:1j,X5:1j,95:1j,X6:13,cD:"",X7:[],h1:1j,Hb:1j,8h:1a(2u,2X){J.2X=2X;J.az=J.2X.az;J.64=a4.Ex(J.az);J.7X=J.2X.h8;if(!1M(J.az)){a4.nO[J.az]=J.2X.h8}J.1w=[];if(!1M(J.2X.1w)){J.1w=J.2X.1w}J.2u=$(2u);J.61=$(\'<2f 1z="2a">\');J.61.1l("5N-3K",J.2u.1l("5N-3K"));J.61.2c(J.2X.1n);J.61.1l("1x",J.2u.1l("1x"));J.61.1g("cB-hp",J.2u.1g("cB-hp"));J.2u.1l("2J","2J");K id=J.2u.1l("id");if(!id){id="cB-2u"+a4.cT.1e}J.id=id;J.61.1l("id",id);J.61.1l("WR","dS");J.61.2y("cB-2u");J.2u.1l("id",id+"WS");J.Hh(J.61,J);J.Hc();J.JB();J.Js();if(J.2X.95){K 95=$(\'<dE WN="0" 2C="cB-2u-dE" 4k="Ik:B3;"></dE>\');$(2N.3s).2Y(95);95.1k(J.2u.1k()+2);95.1s(J.64.1f.1s());95.2I({1L:J.64.1f.2I("1L"),1Z:J.64.1f.2I("1Z")});J.95=95}},Hc:1a(){K me=J;K WP=1j;K 2Q=1T 3D;J.2u.2g("2Z").2e(1a(1S,2Z){K $2Z=$(2Z);K 2a=$2Z.2a();K 2c=$2Z.1l("1n");K 1U=1j;if($2Z.1l("1U")||2Z.1U){me.61.2c(2a);me.cD=2a;me.GX=2c;1U=1m}K ex=$2Z.1l("2C");2Q.1H({1U:1U,2a:2a,1n:2c,ex:ex})});if(2Q.1e>0){J.64.EK(2Q);J.64.1f.2y("uT-Kl");J.64.uX(J.2X.p6)}},EO:1a(){1b J.61},h8:1a(e){K 2L=J.64.vs;if(2s 2L.7X=="1a"){2L.7X.2v(2L,2L.61,e)}},Eu:1a(){if(J.jG){1b}J.jG=1m;J.cD=J.61.2c();J.h1=1j;J.Bv(J);if(J.Hb){J.pg()}},hn:1a(e){if(!J.jG){1b}J.64.EB();J.vc();J.h8(e);J.jG=1j},H0:1a(WU){if(J.61.2c()!=J.cD){J.h1=1m;J.cD=J.61.2c();J.64.BB(J.61.2c())}},Hh:1a(61,WV){K me=J;K 9e=1j;61.3b(1a(e){me.Eu()}).5c(1a(e){if(!me.hA){me.hn(e)}}).3R(1a(e){e.88();me.Eu();if(e.77-$(J).2n().1Z>$(J).1k()-16){if(me.hA){me.vc()}1i{me.pg()}}}).8k(1a(e){me.jG=1m;3x(e.3V){1p 40:if(!me.vq()){me.pg()}1i{e.4r();me.64.Es(me.61.2c(),"dX",me.h1)}1r;1p 38:if(me.vq()){e.4r();me.64.Es(me.61.2c(),"up",me.h1)}1i{me.pg()}1r;1p 9:if(me.vq()){K $li=me.64.jC();if($li.1e){me.vx($li.2a(),me.k2($li[0].1n))}}1i{me.hn()}1r;1p 27:e.4r();me.hn();1b 1j;1r;1p 13:e.4r();if(me.hA){K $li=me.64.jC();if($li.1e){me.vx($li.2a(),me.k2($li[0].1n))}}1i{me.hn()}1b 1j;1r}}).zE($.hJ(me.H0,100,me)).hY(1a(e){if(e.3V==13){e.4r();1b 1j}})},vx:1a(2a,2c){J.cD=2a;J.GX=2c;J.61.2c(2c);J.hn()},vq:1a(){1b J.hA},Bv:1a(2L){J.JH();J.JD();a4.2L=2L;J.64.vs=2L},JH:1a(){K 2n=J.61.2n();2n.1L+=J.61[0].8z;J.64.1f.2I({1L:2n.1L+"px",1Z:2n.1Z+"px"})},JD:1a(){K 1k=J.61[0].nW;J.64.1f.1k(1k)},pg:1a(){J.JI();J.7N=1T $.ui.eo.7N(J);J.64.1f.5i();J.Bv(J);J.hA=1m;if(J.2X.95){J.95.5i()}J.64.uX(10);J.64.BB(J.61.2c())},k2:1a(1S){1b J.64.2Q[1S]},vc:1a(){if(J.7N!=1c){J.7N.5M()}J.64.1f.3S();J.hA=1j;if(J.2X.95){J.95.3S()}},JI:1a(){1o(K i=0;i<a4.cT.1e;i++){if(i!=J.2u.1g("cB-hp")){a4.cT[i].vc()}}},JB:1a(){J.2u.tu(J.61);J.2u.3S();$(2N.3s).2Y(J.64.1f)},Js:1a(){K 1k=J.2u.1k()+2*0;if(J.95){J.95.1k(1k+4)}}};$.ui.eo={7N:1a(3y){J.$el=$.ui.eo.7N.7V(3y)}};$.4n($.ui.eo.7N,{2w:J,cT:[],VJ:[],oT:DG,4M:$.bS("3b,7t,8k,hY".3w(","),1a(1I){1b 1I+".3y-7N"}).53(" "),7V:1a(3y){if(J.cT.1e===0){$(3n).2O("5s.3y-7N",$.ui.eo.7N.5s)}K $el=$(\'<2E 2C="cB-2u-1w-7N"></2E>\').4E(3y.61.1N()).2I({1k:J.1k(),1s:J.1s()});$el.2O("7t.3y-7N",1a(1I){3y.hn();K 1f=2N.ql(1I.b7,1I.bi);if(1f!=1c){7a{K dk="3R";if(1f.CY){K e=2N.Jt("VI");e.Jq(dk,1m,1m,3n,0,1I.Jr,1I.JA,1I.b7,1I.bi,1j,1j,1j,1j,0,1c);1f.CY(e)}1i{if(1f.K4){1f.K4("on"+dk)}}}7b(Wf){}}});if($.fn.fe){$el.fe()}J.cT.1H($el);1b $el},5M:1a($el){if($el!=1c){$el.3v()}if(J.cT.1e===0){$([2N,3n]).8d(".3y-7N")}},1s:1a(){K gj,8z;1b $(2N).1s()+"px"},1k:1a(){K kl,cR;1b $(2N).1k()+"px"},5s:1a(){K $uj=$([]);$.2e($.ui.eo.7N.cT,1a(){$uj=$uj.56(J)});$uj.2I({1k:0,1s:0}).2I({1k:$.ui.eo.7N.1k(),1s:$.ui.eo.7N.1s()})}});$.4n($.ui.eo.7N.2V,{5M:1a(){$.ui.eo.7N.5M(J.$el)}})})(2A);(1a($){K R=$.fV=$.fn.fV=1a(a,b,c){1b R.Dc(iV.3h(J,2t))};1a iV(a,b,c){K r=$.4n({},R);if(2s a=="4i"){r.58=a;if(b&&!$.aQ(b)){r.fm=b}1i{c=b}if(c){r.DW=c}}1i{$.4n(r,a)}if(!r.4f){r.4f=$.K0?"Wb":"E3"}if(!r.3e){r.3e=J?J:$}if(!r.1z&&!$.K0){r.1z="Wc"}1b r}$.4n(R,{6c:"0.5",58:1c,fm:Wd,DW:1c,4f:1c,Dc:1a(r){if(r.oi){r.oi()}r.id=oN(1a(){r.fV(r)},r.fm*9q);r.oi=1a(){ts(r.id);1b r};1b r},fV:1a(r){if(r.D6){46 r.D6}r.D6=r.3e[r.4f](r)}})})(2A);2A.4m={bV:1c,a5:1c,tz:1c,tC:0,8O:1a(1w){J.2e(1a(){J.ch=2A.4n({IY:1c,IJ:1c,pN:"Wh",uW:1c,oA:1c,qi:5,Bl:/[^\\-]*$/,Wj:1c,oj:1c},1w||{});2A.4m.Co(J)});2A(2N).2O("9X",2A.4m.9X).2O("6A",2A.4m.6A);1b J},Co:1a(1B){K 6O=1B.ch;if(1B.ch.oj){$(2N).on("7t","#qb-ui-3A td."+1B.ch.oj,1a(ev){if($(ev.8b).aT("tr:4a").3p().1e==0){1b}2A.4m.a5=J.3r;2A.4m.bV=1B;2A.4m.tz=2A.4m.Cc(J,ev);if(6O.oA){6O.oA(1B,J)}1b 1j})}1i{$(2N).on("7t","#qb-ui-3A 1B td."+1B.ch.oj,1a(ev){if(ev.3e.6v=="TD"){2A.4m.a5=J;2A.4m.bV=1B;2A.4m.tz=2A.4m.Cc(J,ev);if(6O.oA){6O.oA(1B,J)}1b 1j}})}},II:1a(){J.2e(1a(){if(J.ch){2A.4m.Co(J)}})},Cf:1a(ev){if(ev.77||ev.7B){1b{x:ev.77,y:ev.7B}}1b{x:ev.b7+2N.3s.4I-2N.3s.kN,y:ev.bi+2N.3s.4T-2N.3s.kW}},Cc:1a(3e,ev){ev=ev||3n.1I;K Ch=J.tl(3e);K j6=J.Cf(ev);1b{x:j6.x-Ch.x,y:j6.y-Ch.y}},tl:1a(e){K 1Z=0;K 1L=0;if(e.8z==0){e=e.7Z}43(e.eg){1Z+=e.8H;1L+=e.8V;e=e.eg}1Z+=e.8H;1L+=e.8V;1b{x:1Z,y:1L}},9X:1a(ev){if(2A.4m.a5==1c){1b}K t6=2A(2A.4m.a5);K 6O=2A.4m.bV.ch;K j6=2A.4m.Cf(ev);K y=j6.y-2A.4m.tz.y;K qn=3n.Im;if(2N.6D){if(2s 2N.IN!="2p"&&2N.IN!="VZ"){qn=2N.8m.4T}1i{if(2s 2N.3s!="2p"){qn=2N.3s.4T}}}if(j6.y-qn<6O.qi){3n.CU(0,-6O.qi)}1i{K IW=3n.wx?3n.wx:2N.8m.oq?2N.8m.oq:2N.3s.oq;if(IW-(j6.y-qn)<6O.qi){3n.CU(0,6O.qi)}}if(y!=2A.4m.tC){K CG=y>2A.4m.tC;2A.4m.tC=y;if(6O.pN){t6.2y(6O.pN)}1i{t6.2I(6O.IY)}K jl=2A.4m.IA(t6,y);if(jl&&jl.aV!="ui-qb-3A-1G-7q"){if(CG&&2A.4m.a5!=jl){2A.4m.a5.3r.7h(2A.4m.a5,jl.ir)}1i{if(!CG&&2A.4m.a5!=jl){2A.4m.a5.3r.7h(2A.4m.a5,jl)}}}}1b 1j},IA:1a(Br,y){K 3c=2A.4m.bV.3c;1o(K i=0;i<3c.1e;i++){K 1G=3c[i];if($(1G).3p().1e==0){1b}K tk=J.tl(1G).y;K tg=5R(1G.8z)/2;if(1G.8z==0){tk=J.tl(1G.7Z).y;tg=5R(1G.7Z.8z)/2}if(y>tk-tg&&y<tk+tg){if(1G==Br){1b 1c}K 6O=2A.4m.bV.ch;if(6O.IC){if(6O.IC(Br,1G)){1b 1G}1i{1b 1c}}1i{K Bq=2A(1G).4L("Bq");if(!Bq){1b 1G}1i{1b 1c}}1b 1G}}1b 1c},6A:1a(e){if(2A.4m.bV&&2A.4m.a5){K te=2A.4m.a5;K 6O=2A.4m.bV.ch;if(6O.pN){2A(te).4o(6O.pN)}1i{2A(te).2I(6O.IJ)}2A.4m.a5=1c;if(6O.uW){6O.uW(2A.4m.bV,te)}2A.4m.bV=1c}},Bp:1a(){if(2A.4m.bV){1b 2A.4m.C3(2A.4m.bV)}1i{1b"9R: No d9 id 5G, Ha O5 to 5G an id on Ra 1B mp nP 1G"}},C3:1a(1B){K 1J="";K IG=1B.id;K 3c=1B.3c;1o(K i=0;i<3c.1e;i++){if(1J.1e>0){1J+="&"}K jP=3c[i].id;if(jP&&(jP&&(1B.ch&&1B.ch.Bl))){jP=jP.3k(1B.ch.Bl)[0]}1J+=IG+"[]="+jP}1b 1J},Jf:1a(){K 1J="";J.2e(1a(){1J+=2A.4m.C3(J)});1b 1J}};2A.fn.4n({4m:2A.4m.8O,W7:2A.4m.II,Sd:2A.4m.Jf});(1a($){$.8l("ui.3q",{1w:{4E:"3s",Gm:9q,2l:"hD",FH:1c,1k:1c,n5:1c,Gw:26,9B:1c,bG:1c,6W:1c,GK:1j,n8:1a(){}},ou:1a(){K 2w=J,o=J.1w;K u9=J.1f.Sj().1l("id");J.et=[u9,u9+"-3z",u9+"-1Q"];J.tV=1m;J.kj=1j;J.6f=$("<a />",{"2C":"ui-3q ui-8l ui-5g-5v ui-aU-6D","id":J.et[1],"ie":"3z","5d":"#CA","6i":J.1f.1l("2J")?1:0,"5N-Sc":1m,"5N-Sw":J.et[2]});J.Bs=$("<2B />").2Y(J.6f).fI(J.1f);K 6i=J.1f.1l("6i");if(6i){J.6f.1l("6i",6i)}J.6f.1g("GN",J.1f);J.Gz=$(\'<2B 2C="ui-3q-3C ui-3C"></2B>\').EC(J.6f);J.6f.lf(\'<2B 2C="ui-3q-6J" />\');J.1f.2O({"3R.3q":1a(1I){2w.6f.3b();1I.4r()}});J.6f.2O("7t.3q",1a(1I){2w.BC(1I,1m);if(o.2l=="jN"){2w.tV=1j;6K(1a(){2w.tV=1m},tT)}1I.4r()}).2O("3R.3q",1a(1I){1I.4r()}).2O("8k.3q",1a(1I){K 83=1j;3x(1I.3V){1p $.ui.3V.J9:83=1m;1r;1p $.ui.3V.J5:2w.BC(1I);1r;1p $.ui.3V.UP:if(1I.uc){2w.76(1I)}1i{2w.jp(-1)}1r;1p $.ui.3V.Jc:if(1I.uc){2w.76(1I)}1i{2w.jp(1)}1r;1p $.ui.3V.Ji:2w.jp(-1);1r;1p $.ui.3V.Jj:2w.jp(1);1r;1p $.ui.3V.J6:83=1m;1r;1p $.ui.3V.J2:;1p $.ui.3V.Jk:2w.1S(0);1r;1p $.ui.3V.J0:;1p $.ui.3V.J8:2w.1S(2w.8D.1e);1r;5v:83=1m}1b 83}).2O("hY.3q",1a(1I){if(1I.kd>0){2w.CM(1I.kd,"6A")}1b 1m}).2O("j7.3q",1a(){if(!o.2J){$(J).2y("ui-5g-6Q")}}).2O("fB.3q",1a(){if(!o.2J){$(J).4o("ui-5g-6Q")}}).2O("3b.3q",1a(){if(!o.2J){$(J).2y("ui-5g-3b")}}).2O("5c.3q",1a(){if(!o.2J){$(J).4o("ui-5g-3b")}});$(2N).2O("7t.3q-"+J.et[0],1a(1I){if(2w.kj&&!$(1I.3e).hB("#"+2w.et[1]).1e){2w.5J(1I)}});J.1f.2O("3R.3q",1a(){2w.mb()}).2O("3b.3q",1a(){if(2w.6f){2w.6f[0].3b()}});if(!o.1k){o.1k=J.1f.8r()}J.6f.1k(o.1k);J.1f.3S();J.4V=$("<ul />",{"2C":"ui-8l ui-8l-cv","5N-5S":1m,"ie":"Su","5N-Sv":J.et[1],"id":J.et[2]});J.hw=$("<2E />",{"2C":"ui-3q-1Q"}).2Y(J.4V).4E(o.4E);J.4V.2O("8k.3q",1a(1I){K 83=1j;3x(1I.3V){1p $.ui.3V.UP:if(1I.uc){2w.5J(1I,1m)}1i{2w.fN(-1)}1r;1p $.ui.3V.Jc:if(1I.uc){2w.5J(1I,1m)}1i{2w.fN(1)}1r;1p $.ui.3V.Ji:2w.fN(-1);1r;1p $.ui.3V.Jj:2w.fN(1);1r;1p $.ui.3V.Jk:2w.fN(":4a");1r;1p $.ui.3V.J2:2w.BX("up");1r;1p $.ui.3V.J0:2w.BX("dX");1r;1p $.ui.3V.J8:2w.fN(":7i");1r;1p $.ui.3V.J9:;1p $.ui.3V.J5:2w.5J(1I,1m);$(1I.3e).aT("li:eq(0)").1O("6A");1r;1p $.ui.3V.J6:83=1m;2w.5J(1I,1m);$(1I.3e).aT("li:eq(0)").1O("6A");1r;1p $.ui.3V.Sr:2w.5J(1I,1m);1r;5v:83=1m}1b 83}).2O("hY.3q",1a(1I){if(1I.kd>0){2w.CM(1I.kd,"3b")}1b 1m}).2O("7t.3q 6A.3q",1a(){1b 1j});$(3n).2O("5s.3q-"+J.et[0],$.av(2w.5J,J))},yG:1a(){K 2w=J,o=J.1w;K 8o=[];J.1f.2g("2Z").2e(1a(){K 1D=$(J);8o.1H({1n:1D.1l("1n"),2a:2w.GR(1D.2a(),1D),1U:1D.1l("1U"),2J:1D.1l("2J"),gK:1D.1l("2C"),nS:1D.1l("nS"),nI:1D.1N("BH"),n8:o.n8.2v(1D)})});K jZ=2w.1w.2l=="jN"?" ui-5g-8X":"";J.4V.3F("");if(8o.1e){1o(K i=0;i<8o.1e;i++){K Ef={ie:"CB"};if(8o[i].2J){Ef["2C"]="ui-5g-2J"}K tW={3F:8o[i].2a||"&2x;",5d:"#CA",6i:-1,ie:"2Z","5N-1U":1j};if(8o[i].2J){tW["5N-2J"]=1m}if(8o[i].nS){tW["nS"]=8o[i].nS}K Fy=$("<a/>",tW).2O("3b.3q",1a(){$(J).1N().j7()}).2O("5c.3q",1a(){$(J).1N().fB()});K gs=$("<li/>",Ef).2Y(Fy).1g("1S",i).2y(8o[i].gK).1g("iR",8o[i].gK||"").2O("6A.3q",1a(1I){if(2w.tV&&(!2w.mj(1I.8b)&&!2w.mj($(1I.8b).aT("ul > li.ui-3q-cw ")))){2w.1S($(J).1g("1S"));2w.2u(1I);2w.5J(1I,1m)}1b 1j}).2O("3R.3q",1a(){1b 1j}).2O("j7.3q",1a(e){if(!$(J).4L("ui-5g-2J")&&!$(J).1N("ul").1N("li").4L("ui-5g-2J")){e.Ff=2w.1f[0].1w[$(J).1g("1S")].1n;2w.8v("6Q",e,2w.eH());2w.cM().2y(jZ);2w.mV().4o("ui-3q-1h-3b ui-5g-6Q");$(J).4o("ui-5g-8X").2y("ui-3q-1h-3b ui-5g-6Q")}}).2O("fB.3q",1a(e){if($(J).is(2w.cM())){$(J).2y(jZ)}e.Ff=2w.1f[0].1w[$(J).1g("1S")].1n;2w.8v("5c",e,2w.eH());$(J).4o("ui-3q-1h-3b ui-5g-6Q")});if(8o[i].nI.1e){K tS="ui-3q-cw-"+J.1f.2g("BH").1S(8o[i].nI);if(J.4V.2g("li."+tS).1e){J.4V.2g("li."+tS+":7i ul").2Y(gs)}1i{$(\'<li ie="CB" 2C="ui-3q-cw \'+tS+(8o[i].nI.1l("2J")?" "+\'ui-5g-2J" 5N-2J="1m"\':\'"\')+\'><2B 2C="ui-3q-cw-3K">\'+8o[i].nI.1l("3K")+"</2B><ul></ul></li>").4E(J.4V).2g("ul").2Y(gs)}}1i{gs.4E(J.4V)}if(o.bG){1o(K j in o.bG){if(gs.is(o.bG[j].2g)){gs.1g("iR",8o[i].gK+" ui-3q-Fh").2y("ui-3q-Fh");K t7=o.bG[j].3C||"";gs.2g("a:eq(0)").lf(\'<2B 2C="ui-3q-1h-3C ui-3C \'+t7+\'"></2B>\');if(8o[i].n8){gs.2g("2B").2I("jL-9n",8o[i].n8)}}}}}}1i{$(\'<li ie="CB"><a 5d="#CA" 6i="-1" ie="2Z"></a></li>\').4E(J.4V)}K gw=o.2l=="hD";J.6f.9b("ui-3q-hD",gw).9b("ui-3q-jN",!gw);J.4V.9b("ui-3q-1Q-hD ui-aU-4p",gw).9b("ui-3q-1Q-jN ui-aU-6D",!gw).2g("li:4a").9b("ui-aU-1L",!gw).4g().2g("li:7i").2y("ui-aU-4p");J.Gz.9b("ui-3C-jt-1-s",gw).9b("ui-3C-jt-2-n-s",!gw);if(o.2l=="hD"){J.4V.1k(o.n5?o.n5:o.1k)}1i{J.4V.1k(o.n5?o.n5:o.1k-o.Gw)}if(!bw.fP.3k(/Tt 2/)){K Gj=J.hw.1s();K D9=$(3n).1s();K CQ=o.9B?3o.5U(o.9B,D9):D9/3;if(Gj>CQ){J.4V.1s(CQ)}}J.8D=J.4V.2g("li:5L(.ui-3q-cw)");if(J.1f.1l("2J")){J.uT()}1i{J.GC()}J.mb();J.cM().2y("ui-3q-1h-3b");jQ(J.Gh);J.Gh=3n.6K(1a(){2w.Ep()},ep)},5M:1a(){J.1f.qt(J.Ty).4o("ui-3q-2J"+" "+"ui-5g-2J").l8("5N-2J").8d(".3q");$(3n).8d(".3q-"+J.et[0]);$(2N).8d(".3q-"+J.et[0]);J.Bs.3v();J.hw.3v();J.1f.8d(".3q").5i();$.xL.2V.5M.3h(J,2t)},CM:1a(Gg,CT){K 2w=J,c=5w.DU(Gg).3N(),o9=1c,dZ=1c;if(2w.o5){3n.jQ(2w.o5);2w.o5=2p}2w.hE=(2w.hE===2p?"":2w.hE).3I(c);if(2w.hE.1e<2||2w.hE.7l(-2,1)===c&&2w.nQ){2w.nQ=1m;o9=c}1i{2w.nQ=1j;o9=2w.hE}K bX=(CT!=="3b"?J.cM().1g("1S"):J.mV().1g("1S"))||0;1o(K i=0;i<J.8D.1e;i++){K Gn=J.8D.eq(i).2a().7l(0,o9.1e).3N();if(Gn===o9){if(2w.nQ){if(dZ===1c){dZ=i}if(i>bX){dZ=i;1r}}1i{dZ=i}}}if(dZ!==1c){J.8D.eq(dZ).2g("a").1O(CT)}2w.o5=3n.6K(1a(){2w.o5=2p;2w.hE=2p;2w.nQ=2p},2w.1w.Gm)},eH:1a(){K 1S=J.1S();1b{1S:1S,2Z:$("2Z",J.1f).44(1S),1n:J.1f[0].1n}},76:1a(1I){if(J.6f.1l("5N-2J")!="1m"){K 2w=J,o=J.1w,1U=J.cM(),1Y=1U.2g("a");2w.GO(1I);2w.6f.2y("ui-5g-8X");2w.4V.1l("5N-5S",1j);2w.hw.2y("ui-3q-76");if(o.2l=="hD"){2w.6f.4o("ui-aU-6D").2y("ui-aU-1L")}1i{J.4V.2I("1Z",-u4).4T(J.4V.4T()+1U.2K().1L-J.4V.7k()/ 2 + 1U.7k() /2).2I("1Z","5T")}2w.Ep();if(1Y.1e){1Y[0].3b()}2w.kj=1m;2w.8v("76",1I,2w.eH())}},5J:1a(1I,w7){if(J.6f.is(".ui-5g-8X")){J.6f.4o("ui-5g-8X");J.hw.4o("ui-3q-76");J.4V.1l("5N-5S",1m);if(J.1w.2l=="hD"){J.6f.4o("ui-aU-1L").2y("ui-aU-6D")}if(w7){J.6f.3b()}J.kj=1j;J.8v("5J",1I,J.eH())}},dT:1a(1I){J.1f.1O("dT");J.8v("dT",1I,J.eH())},2u:1a(1I){if(J.mj(1I.8b)){1b 1j}J.8v("2u",1I,J.eH())},8l:1a(){1b J.hw.56(J.Bs)},GO:1a(1I){$(".ui-3q.ui-5g-8X").5L(J.6f).2e(1a(){$(J).1g("GN").3q("5J",1I)});$(".ui-3q.ui-5g-6Q").1O("fB")},BC:1a(1I,w7){if(J.kj){J.5J(1I,w7)}1i{J.76(1I)}},GR:1a(2a,1D){if(J.1w.6W){2a=J.1w.6W(2a,1D)}1i{if(J.1w.GK){2a=$("<2E />").2a(2a).3F()}}1b 2a},w0:1a(){1b J.1f[0].bX},cM:1a(){1b J.8D.eq(J.w0())},mV:1a(){1b J.4V.2g(".ui-3q-1h-3b")},jp:1a(a7,vW){if(!J.1w.2J){K vV=5R(J.cM().1g("1S")||0,10);K 5l=vV+a7;if(5l<0){5l=0}if(5l>J.8D.3M()-1){5l=J.8D.3M()-1}if(5l===vW){1b 1j}if(J.8D.eq(5l).4L("ui-5g-2J")){a7>0?++a7:--a7;J.jp(a7,5l)}1i{J.8D.eq(5l).1O("j7").1O("6A")}}},fN:1a(a7,vW){if(!cP(a7)){K vV=5R(J.mV().1g("1S")||0,10);K 5l=vV+a7}1i{K 5l=5R(J.8D.4H(a7).1g("1S"),10)}if(5l<0){5l=0}if(5l>J.8D.3M()-1){5l=J.8D.3M()-1}if(5l===vW){1b 1j}K jv="ui-3q-1h-"+3o.4R(3o.jx()*9q);J.mV().2g("a:eq(0)").1l("id","");if(J.8D.eq(5l).4L("ui-5g-2J")){a7>0?++a7:--a7;J.fN(a7,5l)}1i{J.8D.eq(5l).2g("a:eq(0)").1l("id",jv).3b()}J.4V.1l("5N-FJ",jv)},BX:1a(dB){K nb=3o.e8(J.4V.7k()/J.8D.4a().7k());nb=dB=="up"?-nb:nb;J.fN(nb)},pB:1a(1q,1n){J.1w[1q]=1n;if(1q=="2J"){if(1n){J.5J()}J.1f.56(J.6f).56(J.4V)[1n?"2y":"4o"]("ui-3q-2J "+"ui-5g-2J").1l("5N-2J",1n).1l("6i",1n?1:0)}},uT:1a(1S,1z){if(2s 1S=="2p"){J.pB("2J",1m)}1i{J.BK(1z||"2Z",1S,1j)}},GC:1a(1S,1z){if(2s 1S=="2p"){J.pB("2J",1j)}1i{J.BK(1z||"2Z",1S,1m)}},mj:1a(49){1b $(49).4L("ui-5g-2J")},BK:1a(1z,1S,w1){K 1f=J.1f.2g(1z).eq(1S),ag=1z==="BH"?J.4V.2g("li.ui-3q-cw-"+1S):J.8D.eq(1S);if(ag){ag.9b("ui-5g-2J",!w1).1l("5N-2J",!w1);if(w1){1f.l8("2J")}1i{1f.1l("2J","2J")}}},1S:1a(5l){if(2t.1e){if(!J.mj($(J.8D[5l]))&&5l!=J.w0()){J.1f[0].bX=5l;J.mb();J.dT()}1i{1b 1j}}1i{1b J.w0()}},1n:1a(4b){if(2t.1e&&4b!=J.1f[0].1n){J.1f[0].1n=4b;J.mb();J.dT()}1i{1b J.1f[0].1n}},mb:1a(){K jZ=J.1w.2l=="jN"?" ui-5g-8X":"";K jv="ui-3q-1h-"+3o.4R(3o.jx()*9q);J.4V.2g(".ui-3q-1h-1U").4o("ui-3q-1h-1U"+jZ).2g("a").1l("5N-1U","1j").1l("id","");J.cM().2y("ui-3q-1h-1U"+jZ).2g("a").1l("5N-1U","1m").1l("id",jv);K FR=J.6f.1g("iR")?J.6f.1g("iR"):"";K EJ=J.cM().1g("iR")?J.cM().1g("iR"):"";J.6f.4o(FR).1g("iR",EJ).2y(EJ).2g(".ui-3q-6J").3F(J.cM().2g("a:eq(0)").3F());J.4V.1l("5N-FJ",jv)},Ep:1a(){K o=J.1w,vO={of:J.6f,my:"1Z 1L",at:"1Z 4p",nJ:"lX"};if(o.2l=="jN"){K 1U=J.cM();vO.my="1Z 1L"+(J.4V.2n().1L-1U.2n().1L-(J.6f.7k()+1U.7k())/2);vO.nJ="bM"}J.hw.l8("2l").4w(J.1f.4w()+2).2K($.4n(vO,o.FH))}})})(2A);(1a(eA){if(2s bZ==="1a"&&bZ.xI){bZ(["eN"],eA)}1i{eA(2A)}})(1a($){K 1B=$.8l("aw.1B",{FG:5,F1:1j,SD:"<1B>",hV:1j,92:1c,kc:1c,fE:1c,k6:1c,Ee:1j,1w:{a9:["y"],8e:{4t:1c,mD:1c,mw:1c},1k:1c,1s:1c,yq:1m},fv:1a(e){K $e;if(e.1e){$e=e;e=e[0]}1i{$e=$(e)}if(e.2l.4u=="3j"){if(1M(e.2l.1k)){1b 0}1b 5R(e.2l.1k)}1b $e.8r()},iI:1a(e,1k,oI){K $e;if(e.1e){$e=e;e=e[0]}1i{$e=$(e)}if(oI==2p){if(e.2l.4u!="3j"){oI=$e.8r()-$e.1k()}1i{oI=J.FG}}K G7=1k-oI;$e.1k(G7)},FM:1a(e){1b $(e).7k()},SI:1a(e,G5){K $e=$(e);K 1s=G5-($e.7k()-$e.1s());$e.1s(1s)},FU:1a(9L,bK){K a6=J.Gb(9L,bK);if(a6!=1c){if(a6.2l.4u=="3j"||(!1M(a6.ik["8B"])||a6.ir==1c)){a6=1c}}1b a6},Gb:1a(9L,bK){K fi=0;K E7=0;1o(K i=0;i<bK.1e;i++){K $th=bK[i];fi=i+E7;if($th.ik["8B"]){K 2B=0+$th.ik["8B"].1n-1;if(fi<=9L&&9L<=fi+2B){1b $th}E7+=2B}if(fi==9L){1b $th}}1b 1c},FO:1a(){K 2P=J;K 1J=J.kb().bS(1a(i,e){K 1k=0;if(e.2l.4u=="3j"){1k=$(e).8r()}1i{1k=2P.fv(e)}1b 1k}).44();1b 1J},jK:1a(){if(J.fE==1c){J.fE=J.1f.2g("> b8 > tr:4a-wo,> 67 > tr:4a-wo").4a()}if(J.fE.1e==0){J.fE=0}1b J.fE},Dt:1a(){if(J.92==1c){J.92=J.1f.2g("92")}if(J.92.1e==0){J.92=1c}1b J.92},GH:1a(){if(J.k6==1c){J.k6=J.1f.2g("> 67 67:4a")}if(J.k6.1e==0){J.k6=1c}1b J.k6},io:1a(){if(J.kc==1c){J.kc=J.1f.2g("> 67 1B")}if(J.kc.1e==0){J.kc=1c}1b J.kc},FY:1a(){1b J.1f.2g("> 67 tr.ui-qb-3A-1G:4a-wo")},jn:1a(){1b J.jK().6a()},kb:1a(){1b J.FY().6a()},sc:1a(){1b J.Dt().6a()},Gi:1a(1f){K $1f=$(1f);1b{"x":$1f.8r()<$1f.5D("kl"),"y":$1f.7k()<$1f.5D("gj")}},nL:1a(){if(J.F1){1b 1m}K 67=J.Fc()[0];1b 67.8z<67.gj},DA:1a(9a){K 2P=J;if(9a==2p){9a=J.nL()}J.qY(J.ha(),9a);K 8B=0;J.jn().2e(1a(i,e){K fi=i+8B;K 1k=0;if(e.ik["8B"]){K 2B=0+e.ik["8B"].1n-1;1o(K j=0;j<=2B;j++){1k+=2P.65[fi+j]}8B+=2B}1i{1k=2P.65[fi]}if(fi==2P.65.1e-1){1k+=9a?2P.qO:0}2P.iI(e,1k)})},kT:1a(){if(!J.1f.is(":5X")){1b}J.CE();J.qY()},E0:1a(){K 2P=J;J.sc().2e(1a(i,e){2P.iI(e,2P.65[i])})},CE:1a(){K 2P=J;K ap=J.nL();K 1k=J.ha();if(ap&&!J.Ee){1k-=J.qO}J.Ee=ap;J.r7(1k);J.E0();2P.65=J.FW();J.DA();2P.65=J.FZ();J.E0();J.DA();J.r7(J.65)},FZ:1a(){K 2P=J;K bK=J.jn();K 1J=J.kb().bS(1a(i,e){K 1k=0;if(e.2l.4u=="3j"){1k=$(e).8r()}1i{1k=2P.fv(e)}K a6=2P.FU(i,bK);if(a6){K jy=2P.fv(a6);1k=3o.47(1k,jy)}1b 1k}).44();1b 1J},FW:1a(){K 2P=J;K 1J=J.kb().bS(1a(i,e){K 1k=0;if(e.2l.4u=="3j"){1k=$(e).8r()}1i{1k=2P.fv(e)}1b 1k}).44();1b 1J},ha:1a(65){if(65==2p){65=J.65}K cH=0;K 5Q=J.sc();1o(K i=0;i<65.1e;i++){if(5Q[i].2l.4u!="3j"){cH+=65[i]}}1b cH},k9:1a(1k,9a){if(1k==2p){1k=J.65}if(3D.aF(1k)){1k=J.ha(1k)}J.r7(1k);J.qY(1k,9a)},r7:1a(1k){if(1k==2p){1k=J.65}if(3D.aF(1k)){1k=J.ha(1k)}K 3s=J.io();K 92=J.Dt();3s.1k(1k-1);if(92!=1c){92.1k(1k)}},qY:1a(1k,9a){if(1k==2p){1k=J.65}if(3D.aF(1k)){1k=J.ha(1k)}if(9a==2p){9a=J.nL()}K fE=J.jK();K jy=1k+(9a?J.qO:0);jy=3o.47(jy,fE.1N().1k());fE.1k(jy)},Fc:1a(){if(J.EP==1c){J.EP=J.1f.2g("> 67")}1b J.EP},CH:1a(){K Fz=J.1f.1s()-J.1f.2g("b8").bS(1a(i,e){1b $(e).1e?$(e).7k():0}).44().qN(1a(3H,5F){1b 3H+5F},0);J.Fc().2I({"1s":Fz+"px"})},GF:1a(hK){K 92=$("<92/>");K bK=J.kb();1o(K i=0;i<bK.1e;i++){K 5E=$(bK[i]);K j2=$("<j2 />");K 8B=5E.1l("8B");if(1M(8B)){8B=1}1i{8B=5R(8B)}j2.1l("2B",8B);j2.1l("2C",5E.1l("2C"));if(5E.2I("4u")=="3j"){j2.2I("4u",5E.2I("4u"))}K 1k=hK[i];j2.1k(1k);92.2Y(j2)}1b 92},ou:1a(){J.T8();K 2P=J;J.65=[];J.ki=1j;K $1B=J.$1f=J.1f;J.hV=J.1f.is(":5X");J.qO=2A.2K.SG();J.3M=J.De(J.1w.1k,J.1w.1s);J.a9=J.GS(J.1w.a9);J.mt=$1B.2g("> 67 > tr").6a().1e;J.8e=J.GU(J.1w.8e);J.86={};J.86.1B=$1B.1l("2l");J.86.b8=$1B.2g("> b8").1l("2l");J.86.C9=$1B.2g("> b8 > tr").1l("2l");J.86.jB=$1B.2g("> jB").1l("2l");J.86.BD=$1B.2g("> jB > tr").1l("2l");J.86.67=$1B.2g("> 67").1l("2l");J.3M={"1k":J.3M.1k!==1c?J.3M.1k:J.fv($1B),"1s":J.3M.1s!==1c?J.3M.1s:J.FM($1B)};J.h5={"1k":J.3M.1k-($1B.8r()-$1B.1k()),"1s":J.3M.1s-($1B.7k()-$1B.1s())};if(J.hV){$1B.2I({"1s":J.3M.1s+"px"})}K ap=J.F1?"7P":"5T";J.65=J.FO();$1B.2I({"2K":"iZ","4Y-GG":"cI-4Y","4u":"6C","cO":"5S"});if(J.hV){$1B.2g("> b8").2I({"1s":$1B.2g("b8 > tr").7k()+"px"})}$1B.2g("> b8").2I({"4u":"1B-1G","2K":"6F","1L":$1B.2I("nr-1L"),"cO":"5S"}).2g("> tr").2I({"1Z":"BO","1L":"BO","2K":"6F"}).4g().4g().2g("> 67").BP(\'<67 2l="4u: 6C; 2K:6F; cO-x: \'+(J.a9.x?"5T":"5S")+"; cO-y: "+(J.a9.y?ap:"5S")+"; 1L: "+($1B.2g("b8").7k()+cq($1B.2I("nr-1L")))+\'px;"><tr><td 2l="nr: 0;">\'+\'<1B od="0" oe="0"  2l="4Y-GG: cI-4Y; 4u: 6C; cI: 0 3j;"></1B></td></tr></67>\');J.io().1l("2C",$1B.1l("2C"));if(J.hV){J.CH()}J.cZ={};J.k9(J.io().1k());if(J.8e.4t!=1c){K r1=J.Fw();J.jn().2e(1a(i,e){if(2P.8e.4t[i]&&$(e).4L("KD-5s")){if(2P.8e.mD!=1c){r1["ae"]=2P.8e.mD[i]}if(2P.8e.mw!=1c){r1["cS"]=2P.8e.mw[i]}$(e).4t(r1)}})}if(!2P.cZ.x){2P.Gp($1B.2g("> 67").44(0),{"7P":1a(1I){K 2n=-1*$(1I.3e).4I();2P.jK().2I("1Z",2n+"px")}});2P.cZ.x=1m}K 92=J.GF(J.65);J.GH().tF(92);J.kT();if(1m){$(3n).on("5i",1a(){if(!2P.hV){if(2P.1f.is(":5X")){2P.hV=1m;2P.kT()}}})}sL=1j;$(3n).5s(1a(){if(sL===1m){1b}2P.kT()})},RM:1a(){K 2P=J;if(J.8e.4t!==1c){J.jn().2e(1a(i,e){if(2P.8e.4t[i]){$(e).4t("5M")}})}J.io().2g("67").qQ().qQ().qQ().qQ();J.1f.2g("> b8").2g("> tr").1l("2l",2s J.86.C9==="2p"?1c:J.86.C9).4g().1l("2l",2s J.86.b8==="2p"?1c:J.86.b8).4g().2g("> jB").2g("> tr").1l("2l",2s J.86.BD==="2p"?1c:J.86.BD).4g().1l("2l",2s J.86.jB==="2p"?1c:J.86.jB).4g().2g("> 67").1l("2l",2s J.86.67==="2p"?1c:J.86.67).4g().1l("2l",2s J.86.1B==="2p"?1c:J.86.1B);J.jn().2e(1a(i,e){$(e).2I("1k","")})},gr:1a(1n){1b 1n===1c||2s 1n=="2p"},De:1a(1k,1s){K 3M={};if(J.gr(1k)||!J.Bz(1k)){3M.1k=1c}1i{3M.1k=1k}if(J.gr(1s)||!J.Bz(1s)){3M.1s=1c}1i{3M.1s=1s}1b 3M},GS:1a(1n){K a9;if(1n===1m){a9={"x":1m,"y":1m}}1i{if(1n=="x"){a9={"x":1m,"y":1j}}1i{if(1n=="y"){a9={"x":1j,"y":1m}}1i{if($.aF(1n)){a9={"x":$.rb("x",1n),"y":$.rb("y",1n)}}1i{a9={"x":1j,"y":1j}}}}}1b a9},GU:1a(8e){K 74={};74["4t"]=J.gr(8e)?1c:J.GM(8e.4t);74["mD"]=J.gr(8e)?1c:J.BA(8e.mD);74["mw"]=J.gr(8e)?1c:J.BA(8e.mw);1b 74},GM:1a(4t){K 74=[];if(J.gr(4t)){1b 1c}1i{if($.aQ(4t)){74=4t()}1i{if($.aF(4t)){74=4t}1i{if(4t===1m){1o(K i=0;i<J.mt;i++){74[i]=1m}1b 74}1i{1b 1c}}}}if(!$.aF(74)||(74.1e!=J.mt||!74.nP(1a(1n){1b 1n===1m||1n===1j}))){1b 1c}1b 74},Sa:1a(1n){1b+1n==3o.e8(+1n)},CV:1a(1n){1b+1n==3o.e8(+1n)&&+1n>=0},Bz:1a(1n){1b+1n==3o.e8(+1n)&&+1n>0},BA:1a(1k){K 74=[];if(J.gr(1k)){1b 1c}1i{if($.aQ(1k)){74=1k()}1i{if($.aF(1k)){74=1k}1i{if(J.CV(1k)){K 1n=+1k;1o(K i=0;i<J.mt;i++){74[i]=1n}1b 74}1i{1b 1c}}}}K 2P=J;if(!$.aF(74)||(74.1e!=J.mt||!74.nP(1a(1n){1b 2P.CV(1n)}))){1b 1c}1b 74},Cr:1a(hK,Db,np){if(2s np=="2p"){np=0;1o(K i=0;i<hK.1e;i++){np+=hK[i]}}K 7J=Db/np;K nl=[];K D8=0;1o(K i=0;i<hK.1e-1;i++){nl[i]=3o.4R(7J*hK[i]);D8+=nl[i]}nl[i]=Db-D8;1b nl},5s:1a(1k,1s){K 2P=J;K jo=J.De(1k,1s);K $1B=J.1f;if(jo.1k!=1c){$1B.2I("1k",1k);J.3M.1k=jo.1k;J.h5.1k=jo.1k-($1B.8r()-$1B.1k());K cH=J.ha();if(J.a9.x){if(J.cZ.x||!J.1w.yq){K D4=J.cZ.x;K D5=J.Gi($1B.2g("> 67")).x;if(!D4&&D5){J.Gp($1B.2g("> 67").44(0),{"7P":1a(1I){K 2n=-1*$(1I.3e).4I();2P.jK().2I("1Z",2n+"px")}});J.k9(cH);J.cZ.x=1m}1i{if(D4&&!D5){J.Gy($1B.2g("> 67"),"7P");J.cZ.x=1j}}}1i{J.65=J.Cr(J.65,J.h5.1k,cH);if(J.cZ.x){J.io().2g("67").2I("1k","");J.jK().1k(J.h5.1k+"px");J.Gy($1B.2g("> 67"),"7P");J.cZ.x=1j}}}1i{if(cH!=J.h5.1k){J.65=J.Cr(J.65,J.h5.1k,cH)}}$1B.6a().2I("1k",J.h5.1k+"px")}if(1s!=1c){$1B.2I("1s",1s);J.3M.1s=jo.1s;J.h5.1s=jo.1s-($1B.7k()-$1B.1s());J.CH()}J.fV()},fV:1a(){J.CE()},3s:1a(3c){J.io().2g("67").3F(3c);J.fV()},12p:1a(1f){1b $(1f).1S()},BW:1a(1f){K bK=J.jn();K 1J=0;1o(K i=0;i<bK.1e;i++){K 5E=bK[i];if(5E.ik["8B"]){1J+=0+5E.ik["8B"].1n-1}if(5E==1f){1r}1J++}1b 1J},Fw:1a(){K 2P=J;K $1B=J.1f;K $a6;K k7;K Dk;K 9L;K fK=[];K 4F=0;K 9a;K Fg;K ma=0;K sa;K s9;K hu=0;1b{fJ:"e",2S:1a(1I,ui){$a6=ui.1f;hu=2P.fv($a6);Dk=2P.BW(ui.1f[0]);9L=2P.BW(ui.1f[0]);sa=2P.sc()[Dk];k7=2P.kb()[9L];2P.ki=1j;sL=1m;9a=2P.nL();Fg=$(k7).8r()-$(k7).1k();ma=2P.ha()},5s:1a(1I,ui){if(2P.ki){1b}2P.ki=1m;K DP=ui.3M.1k-ui.hu.1k;if(DP==4F){1b}4F=DP;1o(K i=0;i<2P.65.1e;i++){fK[i]=2P.65[i]}2P.k9(ma+4F,9a);2P.iI(sa,fK[9L]+4F);2P.iI(k7,fK[9L]+4F);s9=3o.47(2P.fv(k7),2P.fv($a6));if(fK[9L]+4F<s9){4F=s9-hu;2P.k9(ma+4F,9a);2P.iI(sa,fK[9L]+4F);2P.iI(ui.1f,fK[9L]+4F);2P.k9(ma+4F,9a)}2P.ki=1j;fK[9L]+=4F},5I:1a(1I,ui){sL=1j;2P.ki=1j;1o(K i=0;i<2P.65.1e;i++){2P.65[i]=fK[i]}2P.kT()}}}});J.129=1a(1f,1V){1a IH(){J.q=[];J.56=1a(ev){J.q.1H(ev)};K i,j;J.2v=1a(){1o(i=0,j=J.q.1e;i<j;i++){J.q[i].2v()}}}1a gp(1f,5D){if(1f.Jg){1b 1f.Jg[5D]}1i{if(3n.gp){1b 3n.gp(1f,1c).yF(5D)}1i{1b 1f.2l[5D]}}}1a Bf(1f,BG){if(!1f.jX){1f.jX=1T IH;1f.jX.56(BG)}1i{if(1f.jX){1f.jX.56(BG);1b}}1f.hM=2N.c4("2E");1f.hM.aV="5s-BE";K 2l="2K: 6F; 1Z: 0; 1L: 0; 7w: 0; 4p: 0; cO: 7P; z-1S: -1; gc: 5S;";K BF="2K: 6F; 1Z: 0; 1L: 0;";1f.hM.2l.eI=2l;1f.hM.jM=\'<2E 2C="5s-BE-cX" 2l="\'+2l+\'">\'+\'<2E 2l="\'+BF+\'"></2E>\'+"</2E>"+\'<2E 2C="5s-BE-g3" 2l="\'+2l+\'">\'+\'<2E 2l="\'+BF+\' 1k: ep%; 1s: ep%"></2E>\'+"</2E>";1f.3Q(1f.hM);if(!{Ab:1,6F:1}[gp(1f,"2K")]){1f.2l.2K="iZ"}K cX=1f.hM.sS[0];K C2=cX.sS[0];K g3=1f.hM.sS[1];K 123=g3.sS[0];K sC,jW;K eS=1a(){C2.2l.1k=cX.cR+10+"px";C2.2l.1s=cX.8z+10+"px";cX.4I=cX.kl;cX.4T=cX.gj;g3.4I=g3.kl;g3.4T=g3.gj;sC=1f.cR;jW=1f.8z};eS();K rQ=1a(){1f.jX.2v()};K oK=1a(el,1x,cb){if(el.ft){el.ft("on"+1x,cb)}1i{el.bF(1x,cb)}};oK(cX,"7P",1a(){if(1f.cR>sC||1f.8z>jW){rQ()}eS()});oK(g3,"7P",1a(){if(1f.cR<sC||1f.8z<jW){rQ()}eS()})}if("[1C 3D]"===4D.2V.3u.2v(1f)||("2p"!==2s 2A&&1f dc 2A||"2p"!==2s IL&&1f dc IL)){K i=0,j=1f.1e;1o(;i<j;i++){Bf(1f[i],1V)}}1i{Bf(1f,1V)}}});(1a(jR){K 6c="0.4.2",3t="7K",5u=/[\\.\\/]/,CW="*",hG=1a(){},IK=1a(a,b){1b a-b},jh,5I,4M={n:{}},31=1a(1x,ao){1x=5w(1x);K e=4M,Bb=5I,2j=3D.2V.3J.2v(2t,2),dM=31.dM(1x),z=0,f=1j,l,ia=[],d7={},2q=[],ce=jh,12a=[];jh=1x;5I=0;1o(K i=0,ii=dM.1e;i<ii;i++){if("4w"in dM[i]){ia.1H(dM[i].4w);if(dM[i].4w<0){d7[dM[i].4w]=dM[i]}}}ia.h3(IK);43(ia[z]<0){l=d7[ia[z++]];2q.1H(l.3h(ao,2j));if(5I){5I=Bb;1b 2q}}1o(i=0;i<ii;i++){l=dM[i];if("4w"in l){if(l.4w==ia[z]){2q.1H(l.3h(ao,2j));if(5I){1r}do{z++;l=d7[ia[z]];l&&2q.1H(l.3h(ao,2j));if(5I){1r}}43(l)}1i{d7[l.4w]=l}}1i{2q.1H(l.3h(ao,2j));if(5I){1r}}}5I=Bb;jh=ce;1b 2q.1e?2q:1c};31.dO=4M;31.dM=1a(1x){K 7H=1x.3w(5u),e=4M,1h,1F,k,i,ii,j,jj,sF,es=[e],2q=[];1o(i=0,ii=7H.1e;i<ii;i++){sF=[];1o(j=0,jj=es.1e;j<jj;j++){e=es[j].n;1F=[e[7H[i]],e[CW]];k=2;43(k--){1h=1F[k];if(1h){sF.1H(1h);2q=2q.3I(1h.f||[])}}}es=sF}1b 2q};31.on=1a(1x,f){1x=5w(1x);if(2s f!="1a"){1b 1a(){}}K 7H=1x.3w(5u),e=4M;1o(K i=0,ii=7H.1e;i<ii;i++){e=e.n;e=e.7K(7H[i])&&e[7H[i]]||(e[7H[i]]={n:{}})}e.f=e.f||[];1o(i=0,ii=e.f.1e;i<ii;i++){if(e.f[i]==f){1b hG}}e.f.1H(f);1b 1a(4w){if(+4w==+4w){f.4w=+4w}}};31.f=1a(1I){K 2h=[].3J.2v(2t,1);1b 1a(){31.3h(1c,[1I,1c].3I(2h).3I([].3J.2v(2t,0)))}};31.5I=1a(){5I=1};31.nt=1a(CR){if(CR){1b(1T e7("(?:\\\\.|\\\\/|^)"+CR+"(?:\\\\.|\\\\/|$)")).96(jh)}1b jh};31.12b=1a(){1b jh.3w(5u)};31.dS=31.8d=1a(1x,f){if(!1x){31.dO=4M={n:{}};1b}K 7H=1x.3w(5u),e,1q,5t,i,ii,j,jj,jb=[4M];1o(i=0,ii=7H.1e;i<ii;i++){1o(j=0;j<jb.1e;j+=5t.1e-2){5t=[j,1];e=jb[j].n;if(7H[i]!=CW){if(e[7H[i]]){5t.1H(e[7H[i]])}}1i{1o(1q in e){if(e[3t](1q)){5t.1H(e[1q])}}}jb.5t.3h(jb,5t)}}1o(i=0,ii=jb.1e;i<ii;i++){e=jb[i];43(e.n){if(f){if(e.f){1o(j=0,jj=e.f.1e;j<jj;j++){if(e.f[j]==f){e.f.5t(j,1);1r}}!e.f.1e&&46 e.f}1o(1q in e.n){if(e.n[3t](1q)&&e.n[1q].f){K pT=e.n[1q].f;1o(j=0,jj=pT.1e;j<jj;j++){if(pT[j]==f){pT.5t(j,1);1r}}!pT.1e&&46 e.n[1q].f}}}1i{46 e.f;1o(1q in e.n){if(e.n[3t](1q)&&e.n[1q].f){46 e.n[1q].f}}}e=e.n}}};31.12R=1a(1x,f){K f2=1a(){31.8d(1x,f2);1b f.3h(J,2t)};1b 31.on(1x,f2)};31.6c=6c;31.3u=1a(){1b"KO r3 xX 12S "+6c};2s iy!="2p"&&iy.ri?iy.ri=31:2s bZ!="2p"?bZ("31",[],1a(){1b 31}):jR.31=31})(3n||J);(1a(jR,eA){if(2s bZ==="1a"&&bZ.xI){bZ(["31"],1a(31){1b eA(jR,31)})}1i{eA(jR,jR.31)}})(J,1a(3n,31){1a R(4a){if(R.is(4a,"1a")){1b bL?4a():31.on("4h.kv",4a)}1i{if(R.is(4a,3Z)){1b R.4S.7V[3h](R,4a.5t(0,3+R.is(4a[0],nu))).56(4a)}1i{K 2j=3D.2V.3J.2v(2t,0);if(R.is(2j[2j.1e-1],"1a")){K f=2j.e3();1b bL?f.2v(R.4S.7V[3h](R,2j)):31.on("4h.kv",1a(){f.2v(R.4S.7V[3h](R,2j))})}1i{1b R.4S.7V[3h](R,2t)}}}}R.6c="2.1.2";R.31=31;K bL,5u=/[, ]+/,ag={9y:1,4q:1,1K:1,bO:1,2a:1,9n:1},Jh=/\\{(\\d+)\\}/g,jS="2V",3t="7K",g={3a:2N,5n:3n},ss={yI:4D.2V[3t].2v(g.5n,"bR"),is:g.5n.bR},Ce=1a(){J.ca=J.8W={}},6u,3Q="3Q",3h="3h",3I="3I",qs="12M"in g.5n||g.5n.IB&&g.3a dc IB,E="",S=" ",4d=5w,3w="3w",4M="3R DD 7t 9X fB j7 6A pV pS pO D3"[3w](S),ob={7t:"pV",9X:"pS",6A:"pO"},oZ=4d.2V.3N,3L=3o,5a=3L.47,6d=3L.5U,4j=3L.4j,66=3L.66,PI=3L.PI,nu="c6",4i="4i",3Z="3Z",3u="3u",hI="2b",JY=4D.2V.3u,2F={},1H="1H",12Z=R.wA=/^58\\([\'"]?([^\\)]+?)[\'"]?\\)$/i,Jz=/^\\s*((#[a-f\\d]{6})|(#[a-f\\d]{3})|zJ?\\(\\s*([\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?(?:\\s*,\\s*[\\d\\.]+%?)?)\\s*\\)|Jy?\\(\\s*([\\d\\.]+(?:4x|\\zs|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\)|Ju?\\(\\s*([\\d\\.]+(?:4x|\\zs|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\))\\s*$/i,JW={"12X":1,"IF":1,"-IF":1},JF=/^(?:12V-)?12W\\(([^,]+),([^,]+),([^,]+),([^\\)]+)\\)/,4R=3L.4R,aE="aE",3P=cq,aB=5R,F6=4d.2V.8P,Ho=R.lU={"aO-4g":"3j","aO-2S":"3j",5c:0,"6h-4q":"0 0 IE IE",ln:"5v",cx:0,cy:0,2b:"#lF","2b-2R":1,2T:\'12C "ID"\',"2T-8C":\'"ID"\',"2T-3M":"10","2T-2l":"s8","2T-9Z":qc,41:0,1s:0,5d:"6S://12A.zQ/","12x-12y":0,2R:1,1K:"M0,0",r:0,rx:0,ry:0,4k:"",28:"#de","28-9w":"","28-dg":"l5","28-iG":"l5","28-mH":0,"28-2R":1,"28-1k":1,3e:"12E","2a-A7":"xM",6o:"bR",3U:"",1k:0,x:0,y:0},sI=R.12J={5c:nu,"6h-4q":"x5",cx:nu,cy:nu,2b:"ac","2b-2R":nu,"2T-3M":nu,1s:nu,2R:nu,1K:"1K",r:nu,rx:nu,ry:nu,28:"ac","28-2R":nu,"28-1k":nu,3U:"3U",1k:nu,x:nu,y:nu},IM=/[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]/g,rU=/[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*,[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*/,Jv={hs:1,rg:1},K1=/,?([12I]),?/gi,JM=/([12F])[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*,?[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*)+)/ig,JC=/([12H])[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*,?[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*)+)/ig,B6=/(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*,?[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*/ig,11n=R.AN=/^r(?:\\(([^,]+?)[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*,[\\bt\\bs\\bv\\bh\\b2\\b1\\b3\\aX\\aY\\bc\\ba\\bf\\bd\\b9\\b5\\bm\\aZ\\aW\\b0\\bB\\bC\\bA\\bl\\bj\\bp]*([^\\)]+?)\\))?/,iX={},11i=1a(a,b){1b a.1q-b.1q},HF=1a(a,b){1b 3P(a)-3P(b)},hG=1a(){},JL=1a(x){1b x},oD=R.zx=1a(x,y,w,h,r){if(r){1b[["M",x+r,y],["l",w-r*2,0],["a",r,r,0,0,1,r,r],["l",0,h-r*2],["a",r,r,0,0,1,-r,r],["l",r*2-w,0],["a",r,r,0,0,1,-r,-r],["l",0,r*2-h],["a",r,r,0,0,1,r,-r],["z"]]}1b[["M",x,y],["l",w,0],["l",0,h],["l",-w,0],["z"]]},Ci=1a(x,y,rx,ry){if(ry==1c){ry=rx}1b[["M",x,y],["m",0,-ry],["a",rx,ry,0,1,1,0,2*ry],["a",rx,ry,0,1,1,0,-2*ry],["z"]]},cp=R.yA={1K:1a(el){1b el.1l("1K")},9y:1a(el){K a=el.2h;1b Ci(a.cx,a.cy,a.r)},bO:1a(el){K a=el.2h;1b Ci(a.cx,a.cy,a.rx,a.ry)},4q:1a(el){K a=el.2h;1b oD(a.x,a.y,a.1k,a.1s,a.r)},9n:1a(el){K a=el.2h;1b oD(a.x,a.y,a.1k,a.1s)},2a:1a(el){K 3d=el.mJ();1b oD(3d.x,3d.y,3d.1k,3d.1s)},5G:1a(el){K 3d=el.mJ();1b oD(3d.x,3d.y,3d.1k,3d.1s)}},qv=R.qv=1a(1K,4N){if(!4N){1b 1K}K x,y,i,j,ii,jj,eV;1K=hW(1K);1o(i=0,ii=1K.1e;i<ii;i++){eV=1K[i];1o(j=1,jj=eV.1e;j<jj;j+=2){x=4N.x(eV[j],eV[j+1]);y=4N.y(eV[j],eV[j+1]);eV[j]=x;eV[j+1]=y}}1b 1K};R.7Q=g;R.1z=g.5n.11e||g.3a.11R.11S("6S://pE.w3.r5/TR/11T/11Q#11N","1.1")?"dA":"hq";if(R.1z=="hq"){K d=g.3a.c4("2E"),b;d.jM=\'<v:dp Jo="1"/>\';b=d.7Z;b.2l.QG="58(#5v#hq)";if(!(b&&2s b.Jo=="1C")){1b R.1z=E}d=1c}R.4c=!(R.5Y=R.1z=="hq");R.zA=Ce;R.fn=6u=Ce.2V=R.2V;R.11U=0;R.z5=0;R.is=1a(o,1z){1z=oZ.2v(1z);if(1z=="mS"){1b!JW[3t](+o)}if(1z=="3Z"){1b o dc 3D}1b 1z=="1c"&&o===1c||(1z==2s o&&o!==1c||(1z=="1C"&&o===4D(o)||(1z=="3Z"&&(3D.aF&&3D.aF(o))||JY.2v(o).3J(8,-1).3N()==1z)))};1a 6e(1v){if(2s 1v=="1a"||4D(1v)!==1v){1b 1v}K 1A=1T 1v.5e;1o(K 1q in 1v){if(1v[3t](1q)){1A[1q]=6e(1v[1q])}}1b 1A}R.7z=1a(x1,y1,x2,y2,x3,y3){if(x3==1c){K x=x1-x2,y=y1-y2;if(!x&&!y){1b 0}1b(ds+3L.Bj(-y,-x)*ds/PI+8Q)%8Q}1i{1b R.7z(x1,y1,x3,y3)-R.7z(x2,y2,x3,y3)}};R.9h=1a(4x){1b 4x%8Q*PI/ds};R.4x=1a(9h){1b 9h*ds/PI%8Q};R.121=1a(2Q,1n,e0){e0=R.is(e0,"mS")?e0:10;if(R.is(2Q,3Z)){K i=2Q.1e;43(i--){if(4j(2Q[i]-1n)<=e0){1b 2Q[i]}}}1i{2Q=+2Q;K oF=1n%2Q;if(oF<e0){1b 1n-oF}if(oF>2Q-e0){1b 1n-oF+2Q}}1b 1n};K qC=R.qC=1a(JX,JP){1b 1a(){1b"122-11Y-11V-11W-11X".3l(JX,JP).8P()}}(/[xy]/g,1a(c){K r=3L.jx()*16|0,v=c=="x"?r:r&3|8;1b v.3u(16)});R.JT=1a(D2){31("4h.JT",R,g.5n,D2);g.5n=D2;g.3a=g.5n.2N;if(R.4S.sh){R.4S.sh(g.5n)}};K oy=1a(3B){if(R.5Y){K oJ=/^\\s+|\\s+$/g;K oQ;7a{K rE=1T rl("11z");rE.11A("<3s>");rE.5J();oQ=rE.3s}7b(e){oQ=11K().2N.3s}K K8=oQ.11L();oy=cr(1a(3B){7a{oQ.2l.3B=4d(3B).3l(oJ,E);K 1n=K8.11J("11G");1n=(1n&fd)<<16|1n&11H|(1n&11I)>>>16;1b"#"+("QE"+1n.3u(16)).3J(-6)}7b(e){1b"3j"}})}1i{K i=g.3a.c4("i");i.6o="hf\\ht 14g 14m";i.2l.4u="3j";g.3a.3s.3Q(i);oy=cr(1a(3B){i.2l.3B=3B;1b g.3a.kR.gp(i,E).yF("3B")})}1b oy(3B)},Kc=1a(){1b"JK("+[J.h,J.s,J.b]+")"},K3=1a(){1b"JJ("+[J.h,J.s,J.l]+")"},CZ=1a(){1b J.6t},CP=1a(r,g,b){if(g==1c&&(R.is(r,"1C")&&("r"in r&&("g"in r&&"b"in r)))){b=r.b;g=r.g;r=r.r}if(g==1c&&R.is(r,4i)){K 3E=R.cQ(r);r=3E.r;g=3E.g;b=3E.b}if(r>1||(g>1||b>1)){r/=fd;g/=fd;b/=fd}1b[r,g,b]},CO=1a(r,g,b,o){r*=fd;g*=fd;b*=fd;K 3W={r:r,g:g,b:b,6t:R.3W(r,g,b),3u:CZ};R.is(o,"mS")&&(3W.2R=o);1b 3W};R.3B=1a(3E){K 3W;if(R.is(3E,"1C")&&("h"in 3E&&("s"in 3E&&"b"in 3E))){3W=R.po(3E);3E.r=3W.r;3E.g=3W.g;3E.b=3W.b;3E.6t=3W.6t}1i{if(R.is(3E,"1C")&&("h"in 3E&&("s"in 3E&&"l"in 3E))){3W=R.rY(3E);3E.r=3W.r;3E.g=3W.g;3E.b=3W.b;3E.6t=3W.6t}1i{if(R.is(3E,"4i")){3E=R.cQ(3E)}if(R.is(3E,"1C")&&("r"in 3E&&("g"in 3E&&"b"in 3E))){3W=R.Kb(3E);3E.h=3W.h;3E.s=3W.s;3E.l=3W.l;3W=R.K7(3E);3E.v=3W.b}1i{3E={6t:"3j"};3E.r=3E.g=3E.b=3E.h=3E.s=3E.v=3E.l=-1}}}3E.3u=CZ;1b 3E};R.po=1a(h,s,v,o){if(J.is(h,"1C")&&("h"in h&&("s"in h&&"b"in h))){v=h.b;s=h.s;h=h.h;o=h.o}h*=8Q;K R,G,B,X,C;h=h%8Q/60;C=v*s;X=C*(1-4j(h%2-1));R=G=B=v-C;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b CO(R,G,B,o)};R.rY=1a(h,s,l,o){if(J.is(h,"1C")&&("h"in h&&("s"in h&&"l"in h))){l=h.l;s=h.s;h=h.h}if(h>1||(s>1||l>1)){h/=8Q;s/=100;l/=100}h*=8Q;K R,G,B,X,C;h=h%8Q/60;C=2*s*(l<0.5?l:1-l);X=C*(1-4j(h%2-1));R=G=B=l-C/2;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b CO(R,G,B,o)};R.K7=1a(r,g,b){b=CP(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,V,C;V=5a(r,g,b);C=V-6d(r,g,b);H=C==0?1c:V==r?(g-b)/ C : V == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8Q)%6*60/8Q;S=C==0?0:C/V;1b{h:H,s:S,b:V,3u:Kc}};R.Kb=1a(r,g,b){b=CP(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,L,M,m,C;M=5a(r,g,b);m=6d(r,g,b);C=M-m;H=C==0?1c:M==r?(g-b)/ C : M == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8Q)%6*60/8Q;L=(M+m)/2;S=C==0?0:L<0.5?C/ (2 * L) : C /(2-2*L);1b{h:H,s:S,l:L,3u:K3}};R.lC=1a(){1b J.53(",").3l(K1,"$1")};1a K6(3Z,1h){1o(K i=0,ii=3Z.1e;i<ii;i++){if(3Z[i]===1h){1b 3Z.1H(3Z.5t(i,1)[0])}}}1a cr(f,ao,oM){1a jF(){K 4s=3D.2V.3J.2v(2t,0),2j=4s.53("\\146"),8j=jF.8j=jF.8j||{},6l=jF.6l=jF.6l||[];if(8j[3t](2j)){K6(6l,2j);1b oM?oM(8j[2j]):8j[2j]}6l.1e>=9q&&46 8j[6l.c0()];6l.1H(2j);8j[2j]=f[3h](ao,4s);1b oM?oM(8j[2j]):8j[2j]}1b jF}K 14l=R.wy=1a(4k,f){K dt=g.3a.c4("dt");dt.2l.eI="2K:6F;1Z:-lI;1L:-lI";dt.iB=1a(){f.2v(J);J.iB=1c;g.3a.3s.7C(J)};dt.13Z=1a(){g.3a.3s.7C(J)};g.3a.3s.3Q(dt);dt.4k=4k};1a om(){1b J.6t}R.cQ=cr(1a(ac){if(!ac||!!((ac=4d(ac)).51("-")+1)){1b{r:-1,g:-1,b:-1,6t:"3j",9s:1,3u:om}}if(ac=="3j"){1b{r:-1,g:-1,b:-1,6t:"3j",3u:om}}!(Jv[3t](ac.3N().gT(0,2))||ac.bq()=="#")&&(ac=oy(ac));K 1A,9u,bz,aM,2R,t,2Q,3W=ac.3k(Jz);if(3W){if(3W[2]){aM=aB(3W[2].gT(5),16);bz=aB(3W[2].gT(3,5),16);9u=aB(3W[2].gT(1,3),16)}if(3W[3]){aM=aB((t=3W[3].bq(3))+t,16);bz=aB((t=3W[3].bq(2))+t,16);9u=aB((t=3W[3].bq(1))+t,16)}if(3W[4]){2Q=3W[4][3w](rU);9u=3P(2Q[0]);2Q[0].3J(-1)=="%"&&(9u*=2.55);bz=3P(2Q[1]);2Q[1].3J(-1)=="%"&&(bz*=2.55);aM=3P(2Q[2]);2Q[2].3J(-1)=="%"&&(aM*=2.55);3W[1].3N().3J(0,4)=="zJ"&&(2R=3P(2Q[3]));2Q[3]&&(2Q[3].3J(-1)=="%"&&(2R/=100))}if(3W[5]){2Q=3W[5][3w](rU);9u=3P(2Q[0]);2Q[0].3J(-1)=="%"&&(9u*=2.55);bz=3P(2Q[1]);2Q[1].3J(-1)=="%"&&(bz*=2.55);aM=3P(2Q[2]);2Q[2].3J(-1)=="%"&&(aM*=2.55);(2Q[0].3J(-3)=="4x"||2Q[0].3J(-1)=="\\Jp")&&(9u/=8Q);3W[1].3N().3J(0,4)=="Jy"&&(2R=3P(2Q[3]));2Q[3]&&(2Q[3].3J(-1)=="%"&&(2R/=100));1b R.po(9u,bz,aM,2R)}if(3W[6]){2Q=3W[6][3w](rU);9u=3P(2Q[0]);2Q[0].3J(-1)=="%"&&(9u*=2.55);bz=3P(2Q[1]);2Q[1].3J(-1)=="%"&&(bz*=2.55);aM=3P(2Q[2]);2Q[2].3J(-1)=="%"&&(aM*=2.55);(2Q[0].3J(-3)=="4x"||2Q[0].3J(-1)=="\\Jp")&&(9u/=8Q);3W[1].3N().3J(0,4)=="Ju"&&(2R=3P(2Q[3]));2Q[3]&&(2Q[3].3J(-1)=="%"&&(2R/=100));1b R.rY(9u,bz,aM,2R)}3W={r:9u,g:bz,b:aM,3u:om};3W.6t="#"+(JN|aM|bz<<8|9u<<16).3u(16).3J(1);R.is(2R,"mS")&&(3W.2R=2R);1b 3W}1b{r:-1,g:-1,b:-1,6t:"3j",9s:1,3u:om}},R);R.JK=cr(1a(h,s,b){1b R.po(h,s,b).6t});R.JJ=cr(1a(h,s,l){1b R.rY(h,s,l).6t});R.3W=cr(1a(r,g,b){1b"#"+(JN|b|g<<8|r<<16).3u(16).3J(1)});R.pl=1a(1n){K 2S=J.pl.2S=J.pl.2S||{h:0,s:1,b:1n||0.75},3W=J.po(2S.h,2S.s,2S.b);2S.h+=0.H7;if(2S.h>1){2S.h=0;2S.s-=0.2;2S.s<=0&&(J.pl.2S={h:0,s:1,b:2S.b})}1b 3W.6t};R.pl.eS=1a(){46 J.2S};1a F8(7W,z){K d=[];1o(K i=0,hk=7W.1e;hk-2*!z>i;i+=2){K p=[{x:+7W[i-2],y:+7W[i-1]},{x:+7W[i],y:+7W[i+1]},{x:+7W[i+2],y:+7W[i+3]},{x:+7W[i+4],y:+7W[i+5]}];if(z){if(!i){p[0]={x:+7W[hk-2],y:+7W[hk-1]}}1i{if(hk-4==i){p[3]={x:+7W[0],y:+7W[1]}}1i{if(hk-2==i){p[2]={x:+7W[0],y:+7W[1]};p[3]={x:+7W[2],y:+7W[3]}}}}}1i{if(hk-4==i){p[3]=p[2]}1i{if(!i){p[0]={x:+7W[i],y:+7W[i+1]}}}}d.1H(["C",(-p[0].x+6*p[1].x+p[2].x)/ 6, (-p[0].y + 6 * p[1].y + p[2].y) /6,(p[1].x+6*p[2].x-p[3].x)/ 6, (p[1].y + 6 * p[2].y - p[3].y) /6,p[2].x,p[2].y])}1b d}R.Ev=1a(8I){if(!8I){1b 1c}K 7U=gW(8I);if(7U.mT){1b cJ(7U.mT)}K ph={a:7,c:6,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,z:0},1g=[];if(R.is(8I,3Z)&&R.is(8I[0],3Z)){1g=cJ(8I)}if(!1g.1e){4d(8I).3l(JM,1a(a,b,c){K 1y=[],1x=b.3N();c.3l(B6,1a(a,b){b&&1y.1H(+b)});if(1x=="m"&&1y.1e>2){1g.1H([b][3I](1y.5t(0,2)));1x="l";b=b=="m"?"l":"L"}if(1x=="r"){1g.1H([b][3I](1y))}1i{43(1y.1e>=ph[1x]){1g.1H([b][3I](1y.5t(0,ph[1x])));if(!ph[1x]){1r}}}})}1g.3u=R.lC;7U.mT=cJ(1g);1b 1g};R.rX=cr(1a(kf){if(!kf){1b 1c}K ph={r:3,s:4,t:2,m:6},1g=[];if(R.is(kf,3Z)&&R.is(kf[0],3Z)){1g=cJ(kf)}if(!1g.1e){4d(kf).3l(JC,1a(a,b,c){K 1y=[],1x=oZ.2v(b);c.3l(B6,1a(a,b){b&&1y.1H(+b)});1g.1H([b][3I](1y))})}1g.3u=R.lC;1b 1g});K gW=1a(ps){K p=gW.ps=gW.ps||{};if(p[ps]){p[ps].rI=100}1i{p[ps]={rI:100}}6K(1a(){1o(K 1q in p){if(p[3t](1q)&&1q!=ps){p[1q].rI--;!p[1q].rI&&46 p[1q]}}});1b p[ps]};R.mL=1a(5P,6m,6g,6j,7n,7j,7G,7x,t){K t1=1-t,Bh=66(t1,3),Bk=66(t1,2),t2=t*t,t3=t2*t,x=Bh*5P+Bk*3*t*6g+t1*3*t*t*7n+t3*7G,y=Bh*6m+Bk*3*t*6j+t1*3*t*t*7j+t3*7x,mx=5P+2*t*(6g-5P)+t2*(7n-2*6g+5P),my=6m+2*t*(6j-6m)+t2*(7j-2*6j+6m),nx=6g+2*t*(7n-6g)+t2*(7G-2*7n+6g),ny=6j+2*t*(7j-6j)+t2*(7x-2*7j+6j),ax=t1*5P+t*6g,ay=t1*6m+t*6j,cx=t1*7n+t*7G,cy=t1*7j+t*7x,dQ=90-3L.Bj(mx-nx,my-ny)*ds/PI;(mx>nx||my<ny)&&(dQ+=ds);1b{x:x,y:y,m:{x:mx,y:my},n:{x:nx,y:ny},2S:{x:ax,y:ay},4g:{x:cx,y:cy},dQ:dQ}};R.BN=1a(5P,6m,6g,6j,7n,7j,7G,7x){if(!R.is(5P,"3Z")){5P=[5P,6m,6g,6j,7n,7j,7G,7x]}K 3d=DC.3h(1c,5P);1b{x:3d.5U.x,y:3d.5U.y,x2:3d.47.x,y2:3d.47.y,1k:3d.47.x-3d.5U.x,1s:3d.47.y-3d.5U.y}};R.Ey=1a(3d,x,y){1b x>=3d.x&&(x<=3d.x2&&(y>=3d.y&&y<=3d.y2))};R.yf=1a(78,79){K i=R.Ey;1b i(79,78.x,78.y)||(i(79,78.x2,78.y)||(i(79,78.x,78.y2)||(i(79,78.x2,78.y2)||(i(78,79.x,79.y)||(i(78,79.x2,79.y)||(i(78,79.x,79.y2)||(i(78,79.x2,79.y2)||(78.x<79.x2&&78.x>79.x||79.x<78.x2&&79.x>78.x)&&(78.y<79.y2&&78.y>79.y||79.y<78.y2&&79.y>78.y))))))))};1a BU(t,p1,p2,p3,p4){K t1=-3*p1+9*p2-9*p3+3*p4,t2=t*t1+6*p1-12*p2+6*p3;1b t*t2-3*p1+3*p2}1a iU(x1,y1,x2,y2,x3,y3,x4,y4,z){if(z==1c){z=1}z=z>1?1:z<0?0:z;K z2=z/2,n=12,HD=[-0.Hs,0.Hs,-0.Hr,0.Hr,-0.Hn,0.Hn,-0.Hm,0.Hm,-0.Hl,0.Hl,-0.Hq,0.Hq],HC=[0.Hp,0.Hp,0.Hx,0.Hx,0.HG,0.HG,0.HH,0.HH,0.Hz,0.Hz,0.Hy,0.Hy],BR=0;1o(K i=0;i<n;i++){K ct=z2*HD[i]+z2,BJ=BU(ct,x1,x2,x3,x4),BL=BU(ct,y1,y2,y3,y4),H3=BJ*BJ+BL*BL;BR+=HC[i]*3L.aC(H3)}1b z2*BR}1a Hj(x1,y1,x2,y2,x3,y3,x4,y4,ll){if(ll<0||iU(x1,y1,x2,y2,x3,y3,x4,y4)<ll){1b}K t=1,nm=t/2,t2=t-nm,l,e=0.QA;l=iU(x1,y1,x2,y2,x3,y3,x4,y4,t2);43(4j(l-ll)>e){nm/=2;t2+=(l<ll?1:-1)*nm;l=iU(x1,y1,x2,y2,x3,y3,x4,y4,t2)}1b t2}1a EN(x1,y1,x2,y2,x3,y3,x4,y4){if(5a(x1,x2)<6d(x3,x4)||(6d(x1,x2)>5a(x3,x4)||(5a(y1,y2)<6d(y3,y4)||6d(y1,y2)>5a(y3,y4)))){1b}K nx=(x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4),ny=(x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4),rJ=(x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);if(!rJ){1b}K px=nx/ rJ, py = ny /rJ,pz=+px.4G(2),oW=+py.4G(2);if(pz<+6d(x1,x2).4G(2)||(pz>+5a(x1,x2).4G(2)||(pz<+6d(x3,x4).4G(2)||(pz>+5a(x3,x4).4G(2)||(oW<+6d(y1,y2).4G(2)||(oW>+5a(y1,y2).4G(2)||(oW<+6d(y3,y4).4G(2)||oW>+5a(y3,y4).4G(2)))))))){1b}1b{x:px,y:py}}1a 13F(8Y,8Z){1b qP(8Y,8Z)}1a 13v(8Y,8Z){1b qP(8Y,8Z,1)}1a qP(8Y,8Z,ga){K 78=R.BN(8Y),79=R.BN(8Z);if(!R.yf(78,79)){1b ga?0:[]}K l1=iU.3h(0,8Y),l2=iU.3h(0,8Z),n1=5a(~~(l1/ 5), 1), n2 = 5a(~~(l2 /5),1),rK=[],rO=[],xy={},1A=ga?0:[];1o(K i=0;i<n1+1;i++){K p=R.mL.3h(R,8Y.3I(i/n1));rK.1H({x:p.x,y:p.y,t:i/n1})}1o(i=0;i<n2+1;i++){p=R.mL.3h(R,8Z.3I(i/n2));rO.1H({x:p.x,y:p.y,t:i/n2})}1o(i=0;i<n1;i++){1o(K j=0;j<n2;j++){K di=rK[i],jJ=rK[i+1],dj=rO[j],jI=rO[j+1],ci=4j(jJ.x-di.x)<0.rL?"y":"x",cj=4j(jI.x-dj.x)<0.rL?"y":"x",is=EN(di.x,di.y,jJ.x,jJ.y,dj.x,dj.y,jI.x,jI.y);if(is){if(xy[is.x.4G(4)]==is.y.4G(4)){bn}xy[is.x.4G(4)]=is.y.4G(4);K t1=di.t+4j((is[ci]-di[ci])/ (jJ[ci] - di[ci])) * (jJ.t - di.t), t2 = dj.t + 4j((is[cj] - dj[cj]) /(jI[cj]-dj[cj]))*(jI.t-dj.t);if(t1>=0&&(t1<=1.rL&&(t2>=0&&t2<=1.rL))){if(ga){1A++}1i{1A.1H({x:is.x,y:is.y,t1:6d(t1,1),t2:6d(t2,1)})}}}}}1b 1A}R.13e=1a(9W,8u){1b rM(9W,8u)};R.Ys=1a(9W,8u){1b rM(9W,8u,1)};1a rM(9W,8u,ga){9W=R.qR(9W);8u=R.qR(8u);K x1,y1,x2,y2,p8,pc,pb,p7,8Y,8Z,1A=ga?0:[];1o(K i=0,ii=9W.1e;i<ii;i++){K pi=9W[i];if(pi[0]=="M"){x1=p8=pi[1];y1=pc=pi[2]}1i{if(pi[0]=="C"){8Y=[x1,y1].3I(pi.3J(1));x1=8Y[6];y1=8Y[7]}1i{8Y=[x1,y1,x1,y1,p8,pc,p8,pc];x1=p8;y1=pc}1o(K j=0,jj=8u.1e;j<jj;j++){K pj=8u[j];if(pj[0]=="M"){x2=pb=pj[1];y2=p7=pj[2]}1i{if(pj[0]=="C"){8Z=[x2,y2].3I(pj.3J(1));x2=8Z[6];y2=8Z[7]}1i{8Z=[x2,y2,x2,y2,pb,p7,pb,p7];x2=pb;y2=p7}K g2=qP(8Y,8Z,ga);if(ga){1A+=g2}1i{1o(K k=0,kk=g2.1e;k<kk;k++){g2[k].Yz=i;g2[k].YA=j;g2[k].8Y=8Y;g2[k].8Z=8Z}1A=1A.3I(g2)}}}}}1b 1A}R.HK=1a(1K,x,y){K 3d=R.H9(1K);1b R.Ey(3d,x,y)&&rM(1K,[["M",x,y],["H",3d.x2+10]],1)%2==1};R.nq=1a(fH){1b 1a(){31("4h.ld",1c,"hf\\ht: Ha r3 Yd to 4f \\Ye"+fH+"\\Yf of 5o 1C",fH)}};K rr=R.H9=1a(1K){K 7U=gW(1K);if(7U.3d){1b 6e(7U.3d)}if(!1K){1b{x:0,y:0,1k:0,1s:0,x2:0,y2:0}}1K=hW(1K);K x=0,y=0,X=[],Y=[],p;1o(K i=0,ii=1K.1e;i<ii;i++){p=1K[i];if(p[0]=="M"){x=p[1];y=p[2];X.1H(x);Y.1H(y)}1i{K p5=DC(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);X=X[3I](p5.5U.x,p5.47.x);Y=Y[3I](p5.5U.y,p5.47.y);x=p[5];y=p[6]}}K rN=6d[3h](0,X),rP=6d[3h](0,Y),EL=5a[3h](0,X),EI=5a[3h](0,Y),1k=EL-rN,1s=EI-rP,bb={x:rN,y:rP,x2:EL,y2:EI,1k:1k,1s:1s,cx:rN+1k/ 2, cy:rP + 1s /2};7U.3d=6e(bb);1b bb},cJ=1a(5x){K 1A=6e(5x);1A.3u=R.lC;1b 1A},DT=R.Yl=1a(5x){K 7U=gW(5x);if(7U.EV){1b cJ(7U.EV)}if(!R.is(5x,3Z)||!R.is(5x&&5x[0],3Z)){5x=R.Ev(5x)}K 1A=[],x=0,y=0,mx=0,my=0,2S=0;if(5x[0][0]=="M"){x=5x[0][1];y=5x[0][2];mx=x;my=y;2S++;1A.1H(["M",x,y])}1o(K i=2S,ii=5x.1e;i<ii;i++){K r=1A[i]=[],pa=5x[i];if(pa[0]!=oZ.2v(pa[0])){r[0]=oZ.2v(pa[0]);3x(r[0]){1p"a":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]-x).4G(3);r[7]=+(pa[7]-y).4G(3);1r;1p"v":r[1]=+(pa[1]-y).4G(3);1r;1p"m":mx=pa[1];my=pa[2];5v:1o(K j=1,jj=pa.1e;j<jj;j++){r[j]=+(pa[j]-(j%2?x:y)).4G(3)}}}1i{r=1A[i]=[];if(pa[0]=="m"){mx=pa[1]+x;my=pa[2]+y}1o(K k=0,kk=pa.1e;k<kk;k++){1A[i][k]=pa[k]}}K 5O=1A[i].1e;3x(1A[i][0]){1p"z":x=mx;y=my;1r;1p"h":x+=+1A[i][5O-1];1r;1p"v":y+=+1A[i][5O-1];1r;5v:x+=+1A[i][5O-2];y+=+1A[i][5O-1]}}1A.3u=R.lC;7U.EV=cJ(1A);1b 1A},DM=R.pW=1a(5x){K 7U=gW(5x);if(7U.4j){1b cJ(7U.4j)}if(!R.is(5x,3Z)||!R.is(5x&&5x[0],3Z)){5x=R.Ev(5x)}if(!5x||!5x.1e){1b[["M",0,0]]}K 1A=[],x=0,y=0,mx=0,my=0,2S=0;if(5x[0][0]=="M"){x=+5x[0][1];y=+5x[0][2];mx=x;my=y;2S++;1A[0]=["M",x,y]}K F9=5x.1e==3&&(5x[0][0]=="M"&&(5x[1][0].8P()=="R"&&5x[2][0].8P()=="Z"));1o(K r,pa,i=2S,ii=5x.1e;i<ii;i++){1A.1H(r=[]);pa=5x[i];if(pa[0]!=F6.2v(pa[0])){r[0]=F6.2v(pa[0]);3x(r[0]){1p"A":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]+x);r[7]=+(pa[7]+y);1r;1p"V":r[1]=+pa[1]+y;1r;1p"H":r[1]=+pa[1]+x;1r;1p"R":K 5p=[x,y][3I](pa.3J(1));1o(K j=2,jj=5p.1e;j<jj;j++){5p[j]=+5p[j]+x;5p[++j]=+5p[j]+y}1A.e3();1A=1A[3I](F8(5p,F9));1r;1p"M":mx=+pa[1]+x;my=+pa[2]+y;5v:1o(j=1,jj=pa.1e;j<jj;j++){r[j]=+pa[j]+(j%2?x:y)}}}1i{if(pa[0]=="R"){5p=[x,y][3I](pa.3J(1));1A.e3();1A=1A[3I](F8(5p,F9));r=["R"][3I](pa.3J(-2))}1i{1o(K k=0,kk=pa.1e;k<kk;k++){r[k]=pa[k]}}}3x(r[0]){1p"Z":x=mx;y=my;1r;1p"H":x=r[1];1r;1p"V":y=r[1];1r;1p"M":mx=r[r.1e-2];my=r[r.1e-1];5v:x=r[r.1e-2];y=r[r.1e-1]}}1A.3u=R.lC;7U.4j=cJ(1A);1b 1A},pD=1a(x1,y1,x2,y2){1b[x1,y1,x2,y2,x2,y2]},DJ=1a(x1,y1,ax,ay,x2,y2){K oR=1/ 3, oX = 2 /3;1b[oR*x1+oX*ax,oR*y1+oX*ay,oR*x2+oX*ax,oR*y2+oX*ay,x2,y2]},DK=1a(x1,y1,rx,ry,7z,Iw,lL,x2,y2,ho){K EY=PI*120/ ds, 9h = PI /ds*(+7z||0),1A=[],xy,5B=cr(1a(x,y,9h){K X=x*3L.9l(9h)-y*3L.8F(9h),Y=x*3L.8F(9h)+y*3L.9l(9h);1b{x:X,y:Y}});if(!ho){xy=5B(x1,y1,-9h);x1=xy.x;y1=xy.y;xy=5B(x2,y2,-9h);x2=xy.x;y2=xy.y;K 9l=3L.9l(PI/ ds * 7z), 8F = 3L.8F(PI /ds*7z),x=(x1-x2)/ 2, y = (y1 - y2) /2;K h=x*x/ (rx * rx) + y * y /(ry*ry);if(h>1){h=3L.aC(h);rx=h*rx;ry=h*ry}K rG=rx*rx,rF=ry*ry,k=(Iw==lL?-1:1)*3L.aC(4j((rG*rF-rG*y*y-rF*x*x)/ (rG * y * y + rF * x * x))), cx = k * rx * y /ry+(x1+x2)/ 2, cy = k * -ry * x /rx+(y1+y2)/ 2, f1 = 3L.rZ(((y1 - cy) /ry).4G(9)),f2=3L.rZ(((y2-cy)/ry).4G(9));f1=x1<cx?PI-f1:f1;f2=x2<cx?PI-f2:f2;f1<0&&(f1=PI*2+f1);f2<0&&(f2=PI*2+f2);if(lL&&f1>f2){f1=f1-PI*2}if(!lL&&f2>f1){f2=f2-PI*2}}1i{f1=ho[0];f2=ho[1];cx=ho[2];cy=ho[3]}K df=f2-f1;if(4j(df)>EY){K Ix=f2,Iz=x2,Iy=y2;f2=f1+EY*(lL&&f2>f1?1:-1);x2=cx+rx*3L.9l(f2);y2=cy+ry*3L.8F(f2);1A=DK(x2,y2,rx,ry,7z,0,lL,Iz,Iy,[f2,Ix,cx,cy])}df=f2-f1;K c1=3L.9l(f1),s1=3L.8F(f1),c2=3L.9l(f2),s2=3L.8F(f2),t=3L.Ip(df/ 4), hx = 4 /3*rx*t,hy=4/3*ry*t,m1=[x1,y1],m2=[x1+hx*s1,y1-hy*c1],m3=[x2+hx*s2,y2-hy*c2],m4=[x2,y2];m2[0]=2*m1[0]-m2[0];m2[1]=2*m1[1]-m2[1];if(ho){1b[m2,m3,m4][3I](1A)}1i{1A=[m2,m3,m4][3I](1A).53()[3w](",");K DF=[];1o(K i=0,ii=1A.1e;i<ii;i++){DF[i]=i%2?5B(1A[i-1],1A[i],9h).y:5B(1A[i],1A[i+1],9h).x}1b DF}},pu=1a(5P,6m,6g,6j,7n,7j,7G,7x,t){K t1=1-t;1b{x:66(t1,3)*5P+66(t1,2)*3*t*6g+t1*3*t*t*7n+66(t,3)*7G,y:66(t1,3)*6m+66(t1,2)*3*t*6j+t1*3*t*t*7j+66(t,3)*7x}},DC=cr(1a(5P,6m,6g,6j,7n,7j,7G,7x){K a=7n-2*6g+5P-(7G-2*7n+6g),b=2*(6g-5P)-2*(7n-6g),c=5P-6g,t1=(-b+3L.aC(b*b-4*a*c))/ 2 /a,t2=(-b-3L.aC(b*b-4*a*c))/ 2 /a,y=[6m,7x],x=[5P,7G],71;4j(t1)>"rH"&&(t1=0.5);4j(t2)>"rH"&&(t2=0.5);if(t1>0&&t1<1){71=pu(5P,6m,6g,6j,7n,7j,7G,7x,t1);x.1H(71.x);y.1H(71.y)}if(t2>0&&t2<1){71=pu(5P,6m,6g,6j,7n,7j,7G,7x,t2);x.1H(71.x);y.1H(71.y)}a=7j-2*6j+6m-(7x-2*7j+6j);b=2*(6j-6m)-2*(7j-6j);c=6m-6j;t1=(-b+3L.aC(b*b-4*a*c))/ 2 /a;t2=(-b-3L.aC(b*b-4*a*c))/ 2 /a;4j(t1)>"rH"&&(t1=0.5);4j(t2)>"rH"&&(t2=0.5);if(t1>0&&t1<1){71=pu(5P,6m,6g,6j,7n,7j,7G,7x,t1);x.1H(71.x);y.1H(71.y)}if(t2>0&&t2<1){71=pu(5P,6m,6g,6j,7n,7j,7G,7x,t2);x.1H(71.x);y.1H(71.y)}1b{5U:{x:6d[3h](0,x),y:6d[3h](0,y)},47:{x:5a[3h](0,x),y:5a[3h](0,y)}}}),hW=R.qR=cr(1a(1K,8u){K 7U=!8u&&gW(1K);if(!8u&&7U.h2){1b cJ(7U.h2)}K p=DM(1K),p2=8u&&DM(8u),2h={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},ek={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},Dh=1a(1K,d,pC){K nx,ny,tq={T:1,Q:1};if(!1K){1b["C",d.x,d.y,d.x,d.y,d.x,d.y]}!(1K[0]in tq)&&(d.qx=d.qy=1c);3x(1K[0]){1p"M":d.X=1K[1];d.Y=1K[2];1r;1p"A":1K=["C"][3I](DK[3h](0,[d.x,d.y][3I](1K.3J(1))));1r;1p"S":if(pC=="C"||pC=="S"){nx=d.x*2-d.bx;ny=d.y*2-d.by}1i{nx=d.x;ny=d.y}1K=["C",nx,ny][3I](1K.3J(1));1r;1p"T":if(pC=="Q"||pC=="T"){d.qx=d.x*2-d.qx;d.qy=d.y*2-d.qy}1i{d.qx=d.x;d.qy=d.y}1K=["C"][3I](DJ(d.x,d.y,d.qx,d.qy,1K[1],1K[2]));1r;1p"Q":d.qx=1K[1];d.qy=1K[2];1K=["C"][3I](DJ(d.x,d.y,1K[1],1K[2],1K[3],1K[4]));1r;1p"L":1K=["C"][3I](pD(d.x,d.y,1K[1],1K[2]));1r;1p"H":1K=["C"][3I](pD(d.x,d.y,1K[1],d.y));1r;1p"V":1K=["C"][3I](pD(d.x,d.y,d.x,1K[1]));1r;1p"Z":1K=["C"][3I](pD(d.x,d.y,d.X,d.Y));1r}1b 1K},Di=1a(pp,i){if(pp[i].1e>7){pp[i].c0();K pi=pp[i];43(pi.1e){pp.5t(i++,0,["C"][3I](pi.5t(0,6)))}pp.5t(i,1);ii=5a(p.1e,p2&&p2.1e||0)}},Dj=1a(9W,8u,a1,a2,i){if(9W&&(8u&&(9W[i][0]=="M"&&8u[i][0]!="M"))){8u.5t(i,0,["M",a2.x,a2.y]);a1.bx=0;a1.by=0;a1.x=9W[i][1];a1.y=9W[i][2];ii=5a(p.1e,p2&&p2.1e||0)}};1o(K i=0,ii=5a(p.1e,p2&&p2.1e||0);i<ii;i++){p[i]=Dh(p[i],2h);Di(p,i);p2&&(p2[i]=Dh(p2[i],ek));p2&&Di(p2,i);Dj(p,p2,2h,ek,i);Dj(p2,p,ek,2h,i);K lT=p[i],lR=p2&&p2[i],pt=lT.1e,pe=p2&&lR.1e;2h.x=lT[pt-2];2h.y=lT[pt-1];2h.bx=3P(lT[pt-4])||2h.x;2h.by=3P(lT[pt-3])||2h.y;ek.bx=p2&&(3P(lR[pe-4])||ek.x);ek.by=p2&&(3P(lR[pe-3])||ek.y);ek.x=p2&&lR[pe-2];ek.y=p2&&lR[pe-1]}if(!p2){7U.h2=cJ(p)}1b p2?[p,p2]:p},1c,cJ),Xe=R.AC=cr(1a(41){K 5p=[];1o(K i=0,ii=41.1e;i<ii;i++){K 71={},91=41[i].3k(/^([^:]*):?([\\d\\.]*)/);71.3B=R.cQ(91[1]);if(71.3B.9s){1b 1c}71.3B=71.3B.6t;91[2]&&(71.2n=91[2]+"%");5p.1H(71)}1o(i=1,ii=5p.1e-1;i<ii;i++){if(!5p[i].2n){K 2S=3P(5p[i-1].2n||0),4g=0;1o(K j=i+1;j<ii;j++){if(5p[j].2n){4g=5p[j].2n;1r}}if(!4g){4g=100;j=ii}4g=3P(4g);K d=(4g-2S)/(j-i+1);1o(;i<j;i++){2S+=d;5p[i].2n=2S+"%"}}}1b 5p}),pf=R.zR=1a(el,2F){el==2F.1L&&(2F.1L=el.3H);el==2F.4p&&(2F.4p=el.3p);el.3p&&(el.3p.3H=el.3H);el.3H&&(el.3H.3p=el.3p)},Xc=R.zy=1a(el,2F){if(2F.1L===el){1b}pf(el,2F);el.3p=1c;el.3H=2F.1L;2F.1L.3p=el;2F.1L=el},Xd=R.zr=1a(el,2F){if(2F.4p===el){1b}pf(el,2F);el.3p=2F.4p;el.3H=1c;2F.4p.3H=el;2F.4p=el},Xm=R.An=1a(el,au,2F){pf(el,2F);au==2F.1L&&(2F.1L=el);au.3p&&(au.3p.3H=el);el.3p=au.3p;el.3H=au;au.3p=el},Xn=R.zt=1a(el,au,2F){pf(el,2F);au==2F.4p&&(2F.4p=el);au.3H&&(au.3H.3p=el);el.3H=au.3H;au.3H=el;el.3p=au},E9=R.E9=1a(1K,3U){K bb=rr(1K),el={1X:{3U:E},6N:1a(){1b bb}};wZ(el,3U);1b el.4N},sm=R.sm=1a(1K,3U){1b qv(1K,E9(1K,3U))},wZ=R.z8=1a(el,aK){if(aK==1c){1b el.1X.3U}aK=4d(aK).3l(/\\.{3}|\\z1/g,el.1X.3U||E);K pr=R.rX(aK),4x=0,dx=0,dy=0,sx=1,sy=1,1X=el.1X,m=1T ff;1X.3U=pr||[];if(pr){1o(K i=0,ii=pr.1e;i<ii;i++){K t=pr[i],ea=t.1e,8t=4d(t[0]).3N(),6F=t[0]!=8t,fq=6F?m.mu():0,x1,y1,x2,y2,bb;if(8t=="t"&&ea==3){if(6F){x1=fq.x(0,0);y1=fq.y(0,0);x2=fq.x(t[1],t[2]);y2=fq.y(t[1],t[2]);m.h4(x2-x1,y2-y1)}1i{m.h4(t[1],t[2])}}1i{if(8t=="r"){if(ea==2){bb=bb||el.6N(1);m.5B(t[1],bb.x+bb.1k/ 2, bb.y + bb.1s /2);4x+=t[1]}1i{if(ea==4){if(6F){x2=fq.x(t[2],t[3]);y2=fq.y(t[2],t[3]);m.5B(t[1],x2,y2)}1i{m.5B(t[1],t[2],t[3])}4x+=t[1]}}}1i{if(8t=="s"){if(ea==2||ea==3){bb=bb||el.6N(1);m.7J(t[1],t[ea-1],bb.x+bb.1k/ 2, bb.y + bb.1s /2);sx*=t[1];sy*=t[ea-1]}1i{if(ea==5){if(6F){x2=fq.x(t[3],t[4]);y2=fq.y(t[3],t[4]);m.7J(t[1],t[2],x2,y2)}1i{m.7J(t[1],t[2],t[3],t[4])}sx*=t[1];sy*=t[2]}}}1i{if(8t=="m"&&ea==7){m.56(t[1],t[2],t[3],t[4],t[5],t[6])}}}}1X.gS=1;el.4N=m}}el.4N=m;1X.sx=sx;1X.sy=sy;1X.4x=4x;1X.dx=dx=m.e;1X.dy=dy=m.f;if(sx==1&&(sy==1&&(!4x&&1X.3d))){1X.3d.x+=+dx;1X.3d.y+=+dy}1i{1X.gS=1}},DS=1a(1h){K l=1h[0];3x(l.3N()){1p"t":1b[l,0,0];1p"m":1b[l,1,0,0,1,0,0];1p"r":if(1h.1e==4){1b[l,0,1h[2],1h[3]]}1i{1b[l,0]};1p"s":if(1h.1e==5){1b[l,1,1,1h[3],1h[4]]}1i{if(1h.1e==3){1b[l,1,1]}1i{1b[l,1]}}}},Hv=R.XX=1a(t1,t2){t2=4d(t2).3l(/\\.{3}|\\z1/g,t1);t1=R.rX(t1)||[];t2=R.rX(t2)||[];K I5=5a(t1.1e,t2.1e),2D=[],to=[],i=0,j,jj,aI,eD;1o(;i<I5;i++){aI=t1[i]||DS(t2[i]);eD=t2[i]||DS(aI);if(aI[0]!=eD[0]||(aI[0].3N()=="r"&&(aI[2]!=eD[2]||aI[3]!=eD[3])||aI[0].3N()=="s"&&(aI[3]!=eD[3]||aI[4]!=eD[4]))){1b}2D[i]=[];to[i]=[];1o(j=0,jj=5a(aI.1e,eD.1e);j<jj;j++){j in aI&&(2D[i][j]=aI[j]);j in eD&&(to[i][j]=eD[j])}}1b{2D:2D,to:to}};R.zP=1a(x,y,w,h){K 4l;4l=h==1c&&!R.is(x,"1C")?g.3a.fu(x):x;if(4l==1c){1b}if(4l.6v){if(y==1c){1b{4l:4l,1k:4l.2l.Y5||4l.cR,1s:4l.2l.Y6||4l.8z}}1i{1b{4l:4l,1k:y,1s:w}}}1b{4l:1,x:x,y:y,1k:w,1s:h}};R.DT=DT;R.4S={};R.hW=hW;R.4N=1a(a,b,c,d,e,f){1b 1T ff(a,b,c,d,e,f)};1a ff(a,b,c,d,e,f){if(a!=1c){J.a=+a;J.b=+b;J.c=+c;J.d=+d;J.e=+e;J.f=+f}1i{J.a=1;J.b=0;J.c=0;J.d=1;J.e=0;J.f=0}}(1a(9v){9v.56=1a(a,b,c,d,e,f){K 2q=[[],[],[]],m=[[J.a,J.c,J.e],[J.b,J.d,J.f],[0,0,1]],4N=[[a,c,e],[b,d,f],[0,0,1]],x,y,z,1A;if(a&&a dc ff){4N=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1]]}1o(x=0;x<3;x++){1o(y=0;y<3;y++){1A=0;1o(z=0;z<3;z++){1A+=m[x][z]*4N[z][y]}2q[x][y]=1A}}J.a=2q[0][0];J.b=2q[1][0];J.c=2q[0][1];J.d=2q[1][1];J.e=2q[0][2];J.f=2q[1][2]};9v.mu=1a(){K me=J,x=me.a*me.d-me.b*me.c;1b 1T ff(me.d/ x, -me.b /x,-me.c/ x, me.a /x,(me.c*me.f-me.d*me.e)/ x, (me.b * me.e - me.a * me.f) /x)};9v.6e=1a(){1b 1T ff(J.a,J.b,J.c,J.d,J.e,J.f)};9v.h4=1a(x,y){J.56(1,0,0,1,x,y)};9v.7J=1a(x,y,cx,cy){y==1c&&(y=x);(cx||cy)&&J.56(1,0,0,1,cx,cy);J.56(x,0,0,y,0,0);(cx||cy)&&J.56(1,0,0,1,-cx,-cy)};9v.5B=1a(a,x,y){a=R.9h(a);x=x||0;y=y||0;K 9l=+3L.9l(a).4G(9),8F=+3L.8F(a).4G(9);J.56(9l,8F,-8F,9l,x,y);J.56(1,0,0,1,-x,-y)};9v.x=1a(x,y){1b x*J.a+y*J.c+J.e};9v.y=1a(x,y){1b x*J.b+y*J.d+J.f};9v.44=1a(i){1b+J[4d.DU(97+i)].4G(4)};9v.3u=1a(){1b R.4c?"4N("+[J.44(0),J.44(1),J.44(2),J.44(3),J.44(4),J.44(5)].53()+")":[J.44(0),J.44(2),J.44(1),J.44(3),0,0].53()};9v.PV=1a(){1b"wQ:G3.wJ.ff(Y1="+J.44(0)+", Y2="+J.44(2)+", Y3="+J.44(1)+", XT="+J.44(3)+", Dx="+J.44(4)+", Dy="+J.44(5)+", XJ=\'5T cX\')"};9v.2n=1a(){1b[J.e.4G(4),J.f.4G(4)]};1a rW(a){1b a[0]*a[0]+a[1]*a[1]}1a DZ(a){K DV=3L.aC(rW(a));a[0]&&(a[0]/=DV);a[1]&&(a[1]/=DV)}9v.3w=1a(){K 2q={};2q.dx=J.e;2q.dy=J.f;K 1G=[[J.a,J.c],[J.b,J.d]];2q.ge=3L.aC(rW(1G[0]));DZ(1G[0]);2q.hz=1G[0][0]*1G[1][0]+1G[0][1]*1G[1][1];1G[1]=[1G[1][0]-1G[0][0]*2q.hz,1G[1][1]-1G[0][1]*2q.hz];2q.fD=3L.aC(rW(1G[1]));DZ(1G[1]);2q.hz/=2q.fD;K 8F=-1G[0][1],9l=1G[1][1];if(9l<0){2q.5B=R.4x(3L.G0(9l));if(8F<0){2q.5B=8Q-2q.5B}}1i{2q.5B=R.4x(3L.rZ(8F))}2q.yL=!+2q.hz.4G(9)&&(2q.ge.4G(9)==2q.fD.4G(9)||!2q.5B);2q.XQ=!+2q.hz.4G(9)&&(2q.ge.4G(9)==2q.fD.4G(9)&&!2q.5B);2q.PQ=!+2q.hz.4G(9)&&!2q.5B;1b 2q};9v.XR=1a(I2){K s=I2||J[3w]();if(s.yL){s.ge=+s.ge.4G(4);s.fD=+s.fD.4G(4);s.5B=+s.5B.4G(4);1b(s.dx||s.dy?"t"+[s.dx,s.dy]:E)+(s.ge!=1||s.fD!=1?"s"+[s.ge,s.fD,0,0]:E)+(s.5B?"r"+[s.5B,0,0]:E)}1i{1b"m"+[J.44(0),J.44(1),J.44(2),J.44(3),J.44(4),J.44(5)]}}})(ff.2V);K 6c=bw.fP.3k(/XS\\/(.*?)\\s/)||bw.fP.3k(/XP\\/(\\d+)/);if(bw.I3=="XM XN, HY."&&(6c&&6c[1]<4||bw.XO.3J(0,2)=="iP")||bw.I3=="Z6 HY."&&(6c&&6c[1]<8)){6u.ls=1a(){K 4q=J.4q(-99,-99,J.1k+99,J.1s+99).1l({28:"3j"});6K(1a(){4q.3v()})}}1i{6u.ls=hG}K 4r=1a(){J.10p=1j},I7=1a(){1b J.eC.4r()},88=1a(){J.10q=1m},I8=1a(){1b J.eC.88()},wT=1a(e){K ap=g.3a.8m.4T||g.3a.3s.4T,eM=g.3a.8m.4I||g.3a.3s.4I;1b{x:e.b7+eM,y:e.bi+ap}},oK=1a(){if(g.3a.bF){1b 1a(1v,1z,fn,1f){K f=1a(e){K 3G=wT(e);1b fn.2v(1f,e,3G.x,3G.y)};1v.bF(1z,f,1j);if(qs&&ob[1z]){K I6=1a(e){K 3G=wT(e),I0=e;1o(K i=0,ii=e.rR&&e.rR.1e;i<ii;i++){if(e.rR[i].3e==1v){e=e.rR[i];e.eC=I0;e.4r=I7;e.88=I8;1r}}1b fn.2v(1f,e,3G.x,3G.y)};1v.bF(ob[1z],I6,1j)}1b 1a(){1v.mU(1z,f,1j);if(qs&&ob[1z]){1v.mU(ob[1z],f,1j)}1b 1m}}}1i{if(g.3a.ft){1b 1a(1v,1z,fn,1f){K f=1a(e){e=e||g.5n.1I;K ap=g.3a.8m.4T||g.3a.3s.4T,eM=g.3a.8m.4I||g.3a.3s.4I,x=e.b7+eM,y=e.bi+ap;e.4r=e.4r||4r;e.88=e.88||88;1b fn.2v(1f,e,x,y)};1v.ft("on"+1z,f);K HX=1a(){1v.AT("on"+1z,f);1b 1m};1b HX}}}}(),5m=[],rB=1a(e){K x=e.b7,y=e.bi,ap=g.3a.8m.4T||g.3a.3s.4T,eM=g.3a.8m.4I||g.3a.3s.4I,81,j=5m.1e;43(j--){81=5m[j];if(qs&&e.j0){K i=e.j0.1e,9p;43(i--){9p=e.j0[i];if(9p.rf==81.el.dR.id){x=9p.b7;y=9p.bi;(e.eC?e.eC:e).4r();1r}}}1i{e.4r()}K 1u=81.el.1u,o,3p=1u.ir,1N=1u.3r,4u=1u.2l.4u;g.5n.yz&&1N.7C(1u);1u.2l.4u="3j";o=81.el.2F.Ih(x,y);1u.2l.4u=4u;g.5n.yz&&(3p?1N.7h(1u,3p):1N.3Q(1u));o&&31("4h.5m.e6."+81.el.id,81.el,o);x+=eM;y+=ap;31("4h.5m.dW."+81.el.id,81.kw||81.el,x-81.el.dR.x,y-81.el.dR.y,x,y,e)}},rD=1a(e){R.If(rB).Ic(rD);K i=5m.1e,81;43(i--){81=5m[i];81.el.dR={};31("4h.5m.4g."+81.el.id,81.rA||(81.qr||(81.kw||81.el)),e)}5m=[]},3i=R.el={};1o(K i=4M.1e;i--;){(1a(dk){R[dk]=3i[dk]=1a(fn,ao){if(R.is(fn,"1a")){J.4M=J.4M||[];J.4M.1H({1x:dk,f:fn,8d:oK(J.dp||(J.1u||g.3a),dk,fn,ao||J)})}1b J};R["un"+dk]=3i["un"+dk]=1a(fn){K 4M=J.4M||[],l=4M.1e;43(l--){if(4M[l].1x==dk&&(R.is(fn,"2p")||4M[l].f==fn)){4M[l].8d();4M.5t(l,1);!4M.1e&&46 J.4M}}1b J}})(4M[i])}3i.1g=1a(1q,1n){K 1g=iX[J.id]=iX[J.id]||{};if(2t.1e==0){1b 1g}if(2t.1e==1){if(R.is(1q,"1C")){1o(K i in 1q){if(1q[3t](i)){J.1g(i,1q[i])}}1b J}31("4h.1g.44."+J.id,J,1g[1q],1q);1b 1g[1q]}1g[1q]=1n;31("4h.1g.5G."+J.id,J,1n,1q);1b J};3i.qt=1a(1q){if(1q==1c){iX[J.id]={}}1i{iX[J.id]&&46 iX[J.id][1q]}1b J};3i.10w=1a(){1b 6e(iX[J.id]||{})};3i.6Q=1a(rn,rj,xW,HM){1b J.j7(rn,xW).fB(rj,HM||xW)};3i.10y=1a(rn,rj){1b J.10v(rn).10s(rj)};K 7c=[];3i.5m=1a(yp,yv,yr,kw,qr,rA){1a 2S(e){(e.eC||e).4r();K x=e.b7,y=e.bi,ap=g.3a.8m.4T||g.3a.3s.4T,eM=g.3a.8m.4I||g.3a.3s.4I;J.dR.id=e.rf;if(qs&&e.j0){K i=e.j0.1e,9p;43(i--){9p=e.j0[i];J.dR.id=9p.rf;if(9p.rf==J.dR.id){x=9p.b7;y=9p.bi;1r}}}J.dR.x=x+eM;J.dR.y=y+ap;!5m.1e&&R.9X(rB).6A(rD);5m.1H({el:J,kw:kw,qr:qr,rA:rA});yv&&31.on("4h.5m.2S."+J.id,yv);yp&&31.on("4h.5m.dW."+J.id,yp);yr&&31.on("4h.5m.4g."+J.id,yr);31("4h.5m.2S."+J.id,qr||(kw||J),e.b7+eM,e.bi+ap,e)}J.dR={};7c.1H({el:J,2S:2S});J.7t(2S);1b J};3i.10h=1a(f){f?31.on("4h.5m.e6."+J.id,f):31.8d("4h.5m.e6."+J.id)};3i.10i=1a(){K i=7c.1e;43(i--){if(7c[i].el==J){J.10j(7c[i].2S);7c.5t(i,1);31.8d("4h.5m.*."+J.id)}}!7c.1e&&R.If(rB).Ic(rD);5m=[]};6u.9y=1a(x,y,r){K 2q=R.4S.9y(J,x||0,y||0,r||0);J.7f&&J.7f.1H(2q);1b 2q};6u.4q=1a(x,y,w,h,r){K 2q=R.4S.4q(J,x||0,y||0,w||0,h||0,r||0);J.7f&&J.7f.1H(2q);1b 2q};6u.bO=1a(x,y,rx,ry){K 2q=R.4S.bO(J,x||0,y||0,rx||0,ry||0);J.7f&&J.7f.1H(2q);1b 2q};6u.1K=1a(8I){8I&&(!R.is(8I,4i)&&(!R.is(8I[0],3Z)&&(8I+=E)));K 2q=R.4S.1K(R.6W[3h](R,2t),J);J.7f&&J.7f.1H(2q);1b 2q};6u.9n=1a(4k,x,y,w,h){K 2q=R.4S.9n(J,4k||"Ik:B3",x||0,y||0,w||0,h||0);J.7f&&J.7f.1H(2q);1b 2q};6u.2a=1a(x,y,2a){K 2q=R.4S.2a(J,x||0,y||0,4d(2a));J.7f&&J.7f.1H(2q);1b 2q};6u.5G=1a(rC){!R.is(rC,"3Z")&&(rC=3D.2V.5t.2v(2t,0,2t.1e));K 2q=1T lz(rC);J.7f&&J.7f.1H(2q);2q["2F"]=J;2q["1z"]="5G";1b 2q};6u.10f=1a(5G){J.7f=5G||J.5G()};6u.10z=1a(5G){K 2q=J.7f;46 J.7f;1b 2q};6u.ke=1a(1k,1s){1b R.4S.ke.2v(J,1k,1s)};6u.gn=1a(x,y,w,h,bM){1b R.4S.gn.2v(J,x,y,w,h,bM)};6u.1L=6u.4p=1c;6u.4h=R;K Ii=1a(49){K 4Y=49.ol(),3a=49.rm,3s=3a.3s,fh=3a.8m,kW=fh.kW||(3s.kW||0),kN=fh.kN||(3s.kN||0),1L=4Y.1L+(g.5n.Im||(fh.4T||3s.4T))-kW,1Z=4Y.1Z+(g.5n.10U||(fh.4I||3s.4I))-kN;1b{y:1L,x:1Z}};6u.Ih=1a(x,y){K 2F=J,4c=2F.1W,3e=g.3a.ql(x,y);if(g.5n.yz&&3e.6v=="4c"){K so=Ii(4c),sr=4c.10R();sr.x=x-so.x;sr.y=y-so.y;sr.1k=sr.1s=1;K rw=4c.110(sr,1c);if(rw.1e){3e=rw[rw.1e-1]}}if(!3e){1b 1c}43(3e.3r&&(3e!=4c.3r&&!3e.4h)){3e=3e.3r}3e==2F.1W.3r&&(3e=4c);3e=3e&&3e.4h?2F.Ij(3e.z4):1c;1b 3e};6u.111=1a(3d){K 5G=J.5G();J.9m(1a(el){if(R.yf(el.6N(),3d)){5G.1H(el)}});1b 5G};6u.Ij=1a(id){K b4=J.4p;43(b4){if(b4.id==id){1b b4}b4=b4.3p}1b 1c};6u.9m=1a(1V,sK){K b4=J.4p;43(b4){if(1V.2v(sK,b4)===1j){1b J}b4=b4.3p}1b J};6u.10W=1a(x,y){K 5G=J.5G();J.9m(1a(el){if(el.ih(x,y)){5G.1H(el)}});1b 5G};1a 10X(){1b J.x+S+J.y}1a yn(){1b J.x+S+J.y+S+J.1k+" \\10O "+J.1s}3i.ih=1a(x,y){K rp=J.gC=cp[J.1z](J);if(J.1l("3U")&&J.1l("3U").1e){rp=R.sm(rp,J.1l("3U"))}1b R.HK(rp,x,y)};3i.6N=1a(Hd){if(J.5o){1b{}}K 1X=J.1X;if(Hd){if(1X.89||!1X.qE){J.gC=cp[J.1z](J);1X.qE=rr(J.gC);1X.qE.3u=yn;1X.89=0}1b 1X.qE}if(1X.89||(1X.gS||!1X.3d)){if(1X.89||!J.gC){1X.qE=0;J.gC=cp[J.1z](J)}1X.3d=rr(qv(J.gC,J.4N));1X.3d.3u=yn;1X.89=1X.gS=0}1b 1X.3d};3i.6e=1a(){if(J.5o){1b 1c}K 2q=J.2F[J.1z]().1l(J.1l());J.7f&&J.7f.1H(2q);1b 2q};3i.cL=1a(cL){if(J.1z=="2a"){1b 1c}cL=cL||{};K s={1k:(cL.1k||10)+(+J.1l("28-1k")||1),2b:cL.2b||1j,2R:cL.2R||0.5,ym:cL.ym||0,wz:cL.wz||0,3B:cL.3B||"#de"},c=s.1k/2,r=J.2F,2q=r.5G(),1K=J.gC||cp[J.1z](J);1K=J.4N?qv(1K,J.4N):1K;1o(K i=1;i<c+1;i++){2q.1H(r.1K(1K).1l({28:s.3B,2b:s.2b?s.3B:"3j","28-iG":"4R","28-dg":"4R","28-1k":+(s.1k/ c * i).4G(3), 2R:+(s.2R /c).4G(3)}))}1b 2q.7h(J).h4(s.ym,s.wz)};K 10B={},rq=1a(5P,6m,6g,6j,7n,7j,7G,7x,1e){if(1e==1c){1b iU(5P,6m,6g,6j,7n,7j,7G,7x)}1i{1b R.mL(5P,6m,6g,6j,7n,7j,7G,7x,Hj(5P,6m,6g,6j,7n,7j,7G,7x,1e))}},rt=1a(wL,rs){1b 1a(1K,1e,H8){1K=hW(1K);K x,y,p,l,sp="",pP={},6z,5O=0;1o(K i=0,ii=1K.1e;i<ii;i++){p=1K[i];if(p[0]=="M"){x=+p[1];y=+p[2]}1i{l=rq(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);if(5O+l>1e){if(rs&&!pP.2S){6z=rq(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-5O);sp+=["C"+6z.2S.x,6z.2S.y,6z.m.x,6z.m.y,6z.x,6z.y];if(H8){1b sp}pP.2S=sp;sp=["M"+6z.x,6z.y+"C"+6z.n.x,6z.n.y,6z.4g.x,6z.4g.y,p[5],p[6]].53();5O+=l;x=+p[5];y=+p[6];bn}if(!wL&&!rs){6z=rq(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-5O);1b{x:6z.x,y:6z.y,dQ:6z.dQ}}}5O+=l;x=+p[5];y=+p[6]}sp+=p.c0()+p}pP.4g=sp;6z=wL?5O:rs?pP:R.mL(x,y,p[0],p[1],p[2],p[3],p[4],p[5],1);6z.dQ&&(6z={x:6z.x,y:6z.y,dQ:6z.dQ});1b 6z}};K cA=rt(1),pI=rt(),sG=rt(0,1);R.cA=cA;R.pI=pI;R.nn=1a(1K,2D,to){if(J.cA(1K)-to<1E-6){1b sG(1K,2D).4g}K a=sG(1K,to,1);1b 2D?sG(a,2D).4g:a};3i.cA=1a(){K 1K=J.cp();if(!1K){1b}if(J.1u.cA){1b J.1u.cA()}1b cA(1K)};3i.pI=1a(1e){K 1K=J.cp();if(!1K){1b}1b pI(1K,1e)};3i.cp=1a(){K 1K,cp=R.yA[J.1z];if(J.1z=="2a"||J.1z=="5G"){1b}if(cp){1K=cp(J)}1b 1K};3i.nn=1a(2D,to){K 1K=J.cp();if(!1K){1b}1b R.nn(1K,2D,to)};K ef=R.Ht={mZ:1a(n){1b n},"<":1a(n){1b 66(n,1.7)},">":1a(n){1b 66(n,0.48)},"<>":1a(n){K q=0.48-n/ 1.Zt, Q = 3L.aC(0.Zu + q * q), x = Q - q, X = 66(4j(x), 1 /3)*(x<0?-1:1),y=-Q-q,Y=66(4j(y),1/3)*(y<0?-1:1),t=X+Y+0.5;1b(1-t)*3*t*t+t*t*t},H2:1a(n){K s=1.H6;1b n*n*((s+1)*n-s)},H4:1a(n){n=n-1;K s=1.H6;1b n*n*((s+1)*n+s)+1},Zl:1a(n){if(n==!!n){1b n}1b 66(2,-10*n)*3L.8F((n-0.H7)*(2*PI)/0.3)+1},Zd:1a(n){K s=7.Za,p=2.75,l;if(n<1/p){l=s*n*n}1i{if(n<2/p){n-=1.5/p;l=s*n*n+0.75}1i{if(n<2.5/p){n-=2.25/p;l=s*n*n+0.Z7}1i{n-=2.Z9/p;l=s*n*n+0.Zi}}}1b l}};ef.Zj=ef["wD-in"]=ef["<"];ef.Zk=ef["wD-2q"]=ef[">"];ef.Zh=ef["wD-in-2q"]=ef["<>"];ef["wE-in"]=ef.H2;ef["wE-2q"]=ef.H4;K 5f=[],Am=3n.ZV||(3n.ZW||(3n.ZT||(3n.ZQ||(3n.ZR||1a(1V){6K(1V,16)})))),6R=1a(){K HB=+1T 5A,l=0;1o(;l<5f.1e;l++){K e=5f[l];if(e.el.5o||e.A8){bn}K fm=HB-e.2S,ms=e.ms,5W=e.5W,2D=e.2D,4F=e.4F,to=e.to,t=e.t,2P=e.el,5G={},6X,8h={},1q;if(e.l9){fm=(e.l9*e.2M.1L-e.3H)/(e.aR-e.3H)*ms;e.6J=e.l9;46 e.l9;e.5I&&5f.5t(l--,1)}1i{e.6J=(e.3H+(e.aR-e.3H)*(fm/ ms)) /e.2M.1L}if(fm<0){bn}if(fm<ms){K 3G=5W(fm/ms);1o(K 1l in 2D){if(2D[3t](1l)){3x(sI[1l]){1p nu:6X=+2D[1l]+3G*ms*4F[1l];1r;1p"ac":6X="3W("+[sH(4R(2D[1l].r+3G*ms*4F[1l].r)),sH(4R(2D[1l].g+3G*ms*4F[1l].g)),sH(4R(2D[1l].b+3G*ms*4F[1l].b))].53(",")+")";1r;1p"1K":6X=[];1o(K i=0,ii=2D[1l].1e;i<ii;i++){6X[i]=[2D[1l][i][0]];1o(K j=1,jj=2D[1l][i].1e;j<jj;j++){6X[i][j]=+2D[1l][i][j]+3G*ms*4F[1l][i][j]}6X[i]=6X[i].53(S)}6X=6X.53(S);1r;1p"3U":if(4F[1l].Hw){6X=[];1o(i=0,ii=2D[1l].1e;i<ii;i++){6X[i]=[2D[1l][i][0]];1o(j=1,jj=2D[1l][i].1e;j<jj;j++){6X[i][j]=2D[1l][i][j]+3G*ms*4F[1l][i][j]}}}1i{K 44=1a(i){1b+2D[1l][i]+3G*ms*4F[1l][i]};6X=[["m",44(0),44(1),44(2),44(3),44(4),44(5)]]}1r;1p"x5":if(1l=="6h-4q"){6X=[];i=4;43(i--){6X[i]=+2D[1l][i]+3G*ms*4F[1l][i]}}1r;5v:K hX=[][3I](2D[1l]);6X=[];i=2P.2F.8W[1l].1e;43(i--){6X[i]=+hX[i]+3G*ms*4F[1l][i]}1r}5G[1l]=6X}}2P.1l(5G);(1a(id,2P,2M){6K(1a(){31("4h.2M.sJ."+id,2P,2M)})})(2P.id,2P,e.2M)}1i{(1a(f,el,a){6K(1a(){31("4h.2M.sJ."+el.id,el,a);31("4h.2M.104."+el.id,el,a);R.is(f,"1a")&&f.2v(el)})})(e.1V,2P,e.2M);2P.1l(to);5f.5t(l--,1);if(e.lb>1&&!e.3p){1o(1q in to){if(to[3t](1q)){8h[1q]=e.hL[1q]}}e.el.1l(8h);l0(e.2M,e.el,e.2M.8p[0],1c,e.hL,e.lb-1)}if(e.3p&&!e.5I){l0(e.2M,e.el,e.3p,1c,e.hL,e.lb)}}}R.4c&&(2P&&(2P.2F&&2P.2F.ls()));5f.1e&&Am(6R)},sH=1a(3B){1b 3B>fd?fd:3B<0?0:3B};3i.IR=1a(el,2M,1y,ms,5W,1V){K 1f=J;if(1f.5o){1V&&1V.2v(1f);1b 1f}K a=1y dc eu?1y:R.6R(1y,ms,5W,1V),x,y;l0(a,1f,a.8p[0],1c,1f.1l());1o(K i=0,ii=5f.1e;i<ii;i++){if(5f[i].2M==2M&&5f[i].el==el){5f[ii-1].2S=5f[i].2S;1r}}1b 1f};1a JE(t,5P,6m,7G,7x,5b){K cx=3*5P,bx=3*(7G-5P)-cx,ax=1-cx-bx,cy=3*6m,by=3*(7x-6m)-cy,ay=1-cy-by;1a xi(t){1b((ax*t+bx)*t+cx)*t}1a HJ(x,pK){K t=HA(x,pK);1b((ay*t+by)*t+cy)*t}1a HA(x,pK){K t0,t1,t2,x2,d2,i;1o(t2=x,i=0;i<8;i++){x2=xi(t2)-x;if(4j(x2)<pK){1b t2}d2=(3*ax*t2+2*bx)*t2+cx;if(4j(d2)<1E-6){1r}t2=t2-x2/d2}t0=0;t1=1;t2=x;if(t2<t0){1b t0}if(t2>t1){1b t1}43(t0<t1){x2=xi(t2);if(4j(x2-x)<pK){1b t2}if(x>x2){t0=t2}1i{t1=t2}t2=(t1-t0)/2+t0}1b t2}1b HJ(t,1/(ep*5b))}3i.ZK=1a(f){f?31.on("4h.2M.sJ."+J.id,f):31.8d("4h.2M.sJ."+J.id);1b J};1a eu(2M,ms){K 8p=[],xu={};J.ms=ms;J.dD=1;if(2M){1o(K 1l in 2M){if(2M[3t](1l)){xu[3P(1l)]=2M[1l];8p.1H(3P(1l))}}8p.h3(HF)}J.2M=xu;J.1L=8p[8p.1e-1];J.8p=8p}eu.2V.h6=1a(h6){K a=1T eu(J.2M,J.ms);a.dD=J.dD;a.sT=+h6||0;1b a};eu.2V.lb=1a(dD){K a=1T eu(J.2M,J.ms);a.sT=J.sT;a.dD=3L.e8(5a(dD,0))||1;1b a};1a l0(2M,1f,aR,6J,hL,dD){aR=3P(aR);K 1y,hN,sU,8p=[],3p,3H,qf,ms=2M.ms,2D={},to={},4F={};if(6J){1o(i=0,ii=5f.1e;i<ii;i++){K e=5f[i];if(e.el.id==1f.id&&e.2M==2M){if(e.aR!=aR){5f.5t(i,1);sU=1}1i{hN=e}1f.1l(e.hL);1r}}}1i{6J=+to}1o(K i=0,ii=2M.8p.1e;i<ii;i++){if(2M.8p[i]==aR||2M.8p[i]>6J*2M.1L){aR=2M.8p[i];3H=2M.8p[i-1]||0;ms=ms/2M.1L*(aR-3H);3p=2M.8p[i+1];1y=2M.2M[aR];1r}1i{if(6J){1f.1l(2M.2M[2M.8p[i]])}}}if(!1y){1b}if(!hN){1o(K 1l in 1y){if(1y[3t](1l)){if(sI[3t](1l)||1f.2F.8W[3t](1l)){2D[1l]=1f.1l(1l);2D[1l]==1c&&(2D[1l]=Ho[1l]);to[1l]=1y[1l];3x(sI[1l]){1p nu:4F[1l]=(to[1l]-2D[1l])/ms;1r;1p"ac":2D[1l]=R.cQ(2D[1l]);K sE=R.cQ(to[1l]);4F[1l]={r:(sE.r-2D[1l].r)/ ms, g:(sE.g - 2D[1l].g) /ms,b:(sE.b-2D[1l].b)/ms};1r;1p"1K":K xq=hW(2D[1l],to[1l]),Hu=xq[1];2D[1l]=xq[0];4F[1l]=[];1o(i=0,ii=2D[1l].1e;i<ii;i++){4F[1l][i]=[0];1o(K j=1,jj=2D[1l][i].1e;j<jj;j++){4F[1l][i][j]=(Hu[i][j]-2D[1l][i][j])/ms}}1r;1p"3U":K 1X=1f.1X,eq=Hv(1X[1l],to[1l]);if(eq){2D[1l]=eq.2D;to[1l]=eq.to;4F[1l]=[];4F[1l].Hw=1m;1o(i=0,ii=2D[1l].1e;i<ii;i++){4F[1l][i]=[2D[1l][i][0]];1o(j=1,jj=2D[1l][i].1e;j<jj;j++){4F[1l][i][j]=(to[1l][i][j]-2D[1l][i][j])/ms}}}1i{K m=1f.4N||1T ff,fg={1X:{3U:1X.3U},6N:1a(){1b 1f.6N(1)}};2D[1l]=[m.a,m.b,m.c,m.d,m.e,m.f];wZ(fg,to[1l]);to[1l]=fg.1X.3U;4F[1l]=[(fg.4N.a-m.a)/ ms, (fg.4N.b - m.b) /ms,(fg.4N.c-m.c)/ ms, (fg.4N.d - m.d) /ms,(fg.4N.e-m.e)/ ms, (fg.4N.f - m.f) /ms]}1r;1p"x5":K 2Q=4d(1y[1l])[3w](5u),hX=4d(2D[1l])[3w](5u);if(1l=="6h-4q"){2D[1l]=hX;4F[1l]=[];i=hX.1e;43(i--){4F[1l][i]=(2Q[i]-2D[1l][i])/ms}}to[1l]=2Q;1r;5v:2Q=[][3I](1y[1l]);hX=[][3I](2D[1l]);4F[1l]=[];i=1f.2F.8W[1l].1e;43(i--){4F[1l][i]=((2Q[i]||0)-(hX[i]||0))/ms}1r}}}}K 5W=1y.5W,fz=R.Ht[5W];if(!fz){fz=4d(5W).3k(JF);if(fz&&fz.1e==5){K h2=fz;fz=1a(t){1b JE(t,+h2[1],+h2[2],+h2[3],+h2[4],ms)}}1i{fz=JL}}qf=1y.2S||(2M.2S||+1T 5A);e={2M:2M,aR:aR,qf:qf,2S:qf+(2M.sT||0),6J:0,l9:6J||0,5I:1j,ms:ms,5W:fz,2D:2D,4F:4F,to:to,el:1f,1V:1y.1V,3H:3H,3p:3p,lb:dD||2M.dD,gA:1f.1l(),hL:hL};5f.1H(e);if(6J&&(!hN&&!sU)){e.5I=1m;e.2S=1T 5A-ms*6J;if(5f.1e==1){1b 6R()}}if(sU){e.2S=1T 5A-e.ms*6J}5f.1e==1&&Am(6R)}1i{hN.l9=6J;hN.2S=1T 5A-hN.ms*6J}31("4h.2M.2S."+1f.id,1f,2M)}R.6R=1a(1y,ms,5W,1V){if(1y dc eu){1b 1y}if(R.is(5W,"1a")||!5W){1V=1V||(5W||1c);5W=1c}1y=4D(1y);ms=+ms||0;K p={},fo,1l;1o(1l in 1y){if(1y[3t](1l)&&(3P(1l)!=1l&&3P(1l)+"%"!=1l)){fo=1m;p[1l]=1y[1l]}}if(!fo){1b 1T eu(1y,ms)}1i{5W&&(p.5W=5W);1V&&(p.1V=1V);1b 1T eu({100:p},ms)}};3i.4z=1a(1y,ms,5W,1V){K 1f=J;if(1f.5o){1V&&1V.2v(1f);1b 1f}K 2M=1y dc eu?1y:R.6R(1y,ms,5W,1V);l0(2M,1f,2M.8p[0],1c,1f.1l());1b 1f};3i.10L=1a(2M,1n){if(2M&&1n!=1c){J.6J(2M,6d(1n,2M.ms)/2M.ms)}1b J};3i.6J=1a(2M,1n){K 2q=[],i=0,5O,e;if(1n!=1c){l0(2M,J,-1,6d(1n,1));1b J}1i{5O=5f.1e;1o(;i<5O;i++){e=5f[i];if(e.el.id==J.id&&(!2M||e.2M==2M)){if(2M){1b e.6J}2q.1H({2M:e.2M,6J:e.6J})}}if(2M){1b 0}1b 2q}};3i.K9=1a(2M){1o(K i=0;i<5f.1e;i++){if(5f[i].el.id==J.id&&(!2M||5f[i].2M==2M)){if(31("4h.2M.K9."+J.id,J,5f[i].2M)!==1j){5f[i].A8=1m}}}1b J};3i.JR=1a(2M){1o(K i=0;i<5f.1e;i++){if(5f[i].el.id==J.id&&(!2M||5f[i].2M==2M)){K e=5f[i];if(31("4h.2M.JR."+J.id,J,e.2M)!==1j){46 e.A8;J.6J(e.2M,e.6J)}}}1b J};3i.5I=1a(2M){1o(K i=0;i<5f.1e;i++){if(5f[i].el.id==J.id&&(!2M||5f[i].2M==2M)){if(31("4h.2M.5I."+J.id,J,5f[i].2M)!==1j){5f.5t(i--,1)}}}1b J};1a At(2F){1o(K i=0;i<5f.1e;i++){if(5f[i].el.2F==2F){5f.5t(i--,1)}}}31.on("4h.3v",At);31.on("4h.aN",At);3i.3u=1a(){1b"hf\\ht\\10G 1C"};K lz=1a(1F){J.1F=[];J.1e=0;J.1z="5G";if(1F){1o(K i=0,ii=1F.1e;i<ii;i++){if(1F[i]&&(1F[i].5e==3i.5e||1F[i].5e==lz)){J[J.1F.1e]=J.1F[J.1F.1e]=1F[i];J.1e++}}}},73=lz.2V;73.1H=1a(){K 1h,5O;1o(K i=0,ii=2t.1e;i<ii;i++){1h=2t[i];if(1h&&(1h.5e==3i.5e||1h.5e==lz)){5O=J.1F.1e;J[5O]=J.1F[5O]=1h;J.1e++}}1b J};73.e3=1a(){J.1e&&46 J[J.1e--];1b J.1F.e3()};73.9m=1a(1V,sK){1o(K i=0,ii=J.1F.1e;i<ii;i++){if(1V.2v(sK,J.1F[i],i)===1j){1b J}}1b J};1o(K 4f in 3i){if(3i[3t](4f)){73[4f]=1a(fH){1b 1a(){K 4s=2t;1b J.9m(1a(el){el[fH][3h](el,4s)})}}(4f)}}73.1l=1a(1x,1n){if(1x&&(R.is(1x,3Z)&&R.is(1x[0],"1C"))){1o(K j=0,jj=1x.1e;j<jj;j++){J.1F[j].1l(1x[j])}}1i{1o(K i=0,ii=J.1F.1e;i<ii;i++){J.1F[i].1l(1x,1n)}}1b J};73.aN=1a(){43(J.1e){J.e3()}};73.5t=1a(1S,6l,10Z){1S=1S<0?5a(J.1e+1S,0):1S;6l=5a(0,6d(J.1e-1S,6l));K sM=[],AU=[],2j=[],i;1o(i=2;i<2t.1e;i++){2j.1H(2t[i])}1o(i=0;i<6l;i++){AU.1H(J[1S+i])}1o(;i<J.1e-1S;i++){sM.1H(J[1S+i])}K m8=2j.1e;1o(i=0;i<m8+sM.1e;i++){J.1F[1S+i]=J[1S+i]=i<m8?2j[i]:sM[i-m8]}i=J.1F.1e=J.1e-=6l-m8;43(J[i]){46 J[i++]}1b 1T lz(AU)};73.zC=1a(el){1o(K i=0,ii=J.1e;i<ii;i++){if(J[i]==el){J.5t(i,1);1b 1m}}};73.4z=1a(1y,ms,5W,1V){(R.is(5W,"1a")||!5W)&&(1V=5W||1c);K 5O=J.1F.1e,i=5O,1h,5G=J,su;if(!5O){1b J}1V&&(su=1a(){!--5O&&1V.2v(5G)});5W=R.is(5W,4i)?5W:su;K 2M=R.6R(1y,ms,5W,su);1h=J.1F[--i].4z(2M);43(i--){J.1F[i]&&(!J.1F[i].5o&&J.1F[i].IR(1h,2M,2M));J.1F[i]&&!J.1F[i].5o||5O--}1b J};73.fI=1a(el){K i=J.1F.1e;43(i--){J.1F[i].fI(el)}1b J};73.6N=1a(){K x=[],y=[],x2=[],y2=[];1o(K i=J.1F.1e;i--;){if(!J.1F[i].5o){K 4Y=J.1F[i].6N();x.1H(4Y.x);y.1H(4Y.y);x2.1H(4Y.x+4Y.1k);y2.1H(4Y.y+4Y.1s)}}x=6d[3h](0,x);y=6d[3h](0,y);x2=5a[3h](0,x2);y2=5a[3h](0,y2);1b{x:x,y:y,x2:x2,y2:y2,1k:x2-x,1s:y2-y}};73.6e=1a(s){s=J.2F.5G();1o(K i=0,ii=J.1F.1e;i<ii;i++){s.1H(J.1F[i].6e())}1b s};73.3u=1a(){1b"hf\\ht\\10Q 5G"};73.cL=1a(IP){K 83=J.2F.5G();J.9m(1a(dp,1S){K g=dp.cL(IP);if(g!=1c){g.9m(1a(IX,10P){83.1H(IX)})}});1b 83};73.ih=1a(x,y){K ih=1j;J.9m(1a(el){if(el.ih(x,y)){ih=1m;1b 1j}});1b ih};R.10S=1a(2T){if(!2T.9g){1b 2T}J.dP=J.dP||{};K ij={w:2T.w,9g:{},gf:{}},8C=2T.9g["2T-8C"];1o(K 5D in 2T.9g){if(2T.9g[3t](5D)){ij.9g[5D]=2T.9g[5D]}}if(J.dP[8C]){J.dP[8C].1H(ij)}1i{J.dP[8C]=[ij]}if(!2T.4c){ij.9g["AJ-AI-em"]=aB(2T.9g["AJ-AI-em"],10);1o(K o3 in 2T.gf){if(2T.gf[3t](o3)){K 1K=2T.gf[o3];ij.gf[o3]={w:1K.w,k:{},d:1K.d&&"M"+1K.d.3l(/[10V]/g,1a(8t){1b{l:"L",c:"C",x:"z",t:"m",r:"l",v:"c"}[8t]||"M"})+"z"};if(1K.k){1o(K k in 1K.k){if(1K[3t](k)){ij.gf[o3].k[k]=1K.k[k]}}}}}}1b 2T};6u.IV=1a(8C,9Z,2l,o7){o7=o7||"s8";2l=2l||"s8";9Z=+9Z||({s8:qc,10c:10u,10m:tT,10l:ti}[9Z]||qc);if(!R.dP){1b}K 2T=R.dP[8C];if(!2T){K 1x=1T e7("(^|\\\\s)"+8C.3l(/[^\\w\\d\\s+!~.:1X-]/g,E)+"(\\\\s|$)","i");1o(K s4 in R.dP){if(R.dP[3t](s4)){if(1x.96(s4)){2T=R.dP[s4];1r}}}}K ib;if(2T){1o(K i=0,ii=2T.1e;i<ii;i++){ib=2T[i];if(ib.9g["2T-9Z"]==9Z&&((ib.9g["2T-2l"]==2l||!ib.9g["2T-2l"])&&ib.9g["2T-o7"]==o7)){1r}}}1b ib};6u.10r=1a(x,y,4i,2T,3M,gA,s6,s5){gA=gA||"xM";s6=5a(6d(s6||0,1),-1);s5=5a(6d(s5||1,3),1);K kG=4d(4i)[3w](E),c0=0,ng=0,1K=E,7J;R.is(2T,"4i")&&(2T=J.IV(2T));if(2T){7J=(3M||16)/2T.9g["AJ-AI-em"];K bb=2T.9g.3d[3w](5u),1L=+bb[0],s3=bb[3]-bb[1],za=0,1s=+bb[1]+(gA=="XF"?s3+ +2T.9g.XL:s3/2);1o(K i=0,ii=kG.1e;i<ii;i++){if(kG[i]=="\\n"){c0=0;g6=0;ng=0;za+=s3*s5}1i{K 3H=ng&&2T.gf[kG[i-1]]||{},g6=2T.gf[kG[i]];c0+=ng?(3H.w||2T.w)+(3H.k&&3H.k[kG[i]]||0)+2T.w*s6:0;ng=1}if(g6&&g6.d){1K+=R.sm(g6.d,["t",c0*7J,za*7J,"s",7J,7J,1L,1s,"t",(x-1L)/ 7J, (y - 1s) /7J])}}}1b J.1K(1K).1l({2b:"#de",28:"3j"})};6u.56=1a(fo){if(R.is(fo,"3Z")){K 1A=J.5G(),i=0,ii=fo.1e,j;1o(;i<ii;i++){j=fo[i]||{};ag[3t](j.1z)&&1A.1H(J[j.1z]().1l(j))}}1b 1A};R.6W=1a(dG,1y){K 2j=R.is(1y,3Z)?[0][3I](1y):2t;dG&&(R.is(dG,4i)&&(2j.1e-1&&(dG=dG.3l(Jh,1a(7o,i){1b 2j[++i]==1c?E:2j[i]}))));1b dG||E};R.Y0=1a(){K J4=/\\{([^\\}]+)\\}/g,Jd=/(?:(?:^|\\.)(.+?)(?=\\[|\\.|$|\\()|\\[(\'|")(.+?)\\2\\])(\\(\\))?/g,IZ=1a(6D,1q,1v){K 1A=1v;1q.3l(Jd,1a(6D,1x,Jm,Jn,J3){1x=1x||Jn;if(1A){if(1x in 1A){1A=1A[1x]}2s 1A=="1a"&&(J3&&(1A=1A()))}});1A=(1A==1c||1A==1v?6D:1A)+"";1b 1A};1b 1a(7o,1v){1b 5w(7o).3l(J4,1a(6D,1q){1b IZ(6D,1q,1v)})}}();R.XZ=1a(){ss.yI?g.5n.bR=ss.is:46 bR;1b R};R.st=73;(1a(3a,bL,f){if(3a.nK==1c&&3a.bF){3a.bF(bL,f=1a(){3a.mU(bL,f,1j);3a.nK="E2"},1j);3a.nK="tE"}1a zK(){/in/.96(3a.nK)?6K(zK,9):R.31("4h.kv")}zK()})(2N,"XY");31.on("4h.kv",1a(){bL=1m});(1a(){if(!R.4c){1b}K 3t="7K",4d=5w,3P=cq,aB=5R,3L=3o,5a=3L.47,4j=3L.4j,66=3L.66,5u=/[, ]+/,31=R.31,E="",S=" ";K ed="6S://pE.w3.r5/Xk/ed",Gq={6C:"M5,0 0,2.5 5,5z",oC:"M5,0 0,2.5 5,5 3.5,3 3.5,2z",qH:"M2.5,0 5,2.5 2.5,5 0,2.5z",76:"M6,1 1,3.5 6,6",qM:"M2.5,Xr.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,Xt"},c3={};R.3u=1a(){1b"R1 sR Xw dA.\\Rg r3 xX hf\\ht "+J.6c};K $=1a(el,1l){if(1l){if(2s el=="4i"){el=$(el)}1o(K 1q in 1l){if(1l[3t](1q)){if(1q.gT(0,6)=="ed:"){el.qq(ed,1q.gT(6),4d(1l[1q]))}1i{el.aE(1q,4d(1l[1q]))}}}}1i{el=R.7Q.3a.Xv("6S://pE.w3.r5/G6/4c",el);el.2l&&(el.2l.YQ="zJ(0,0,0,0)")}1b el},o8=1a(1f,41){K 1z="mZ",id=1f.id+41,fx=0.5,fy=0.5,o=1f.1u,dA=1f.2F,s=o.2l,el=R.7Q.3a.fu(id);if(!el){41=4d(41).3l(R.AN,1a(6D,zM,zL){1z="r8";if(zM&&zL){fx=3P(zM);fy=3P(zL);K zi=(fy>0.5)*2-1;66(fx-0.5,2)+66(fy-0.5,2)>0.25&&((fy=3L.aC(0.25-66(fx-0.5,2))*zi+0.5)&&(fy!=0.5&&(fy=fy.4G(5)-1E-5*zi)))}1b E});41=41.3w(/\\s*\\-\\s*/);if(1z=="mZ"){K 7z=41.c0();7z=-3P(7z);if(cP(7z)){1b 1c}K 8G=[0,0,3L.9l(R.9h(7z)),3L.8F(R.9h(7z))],47=1/(5a(4j(8G[2]),4j(8G[3]))||1);8G[2]*=47;8G[3]*=47;if(8G[2]<0){8G[0]=-8G[2];8G[2]=0}if(8G[3]<0){8G[1]=-8G[3];8G[3]=0}}K 5p=R.AC(41);if(!5p){1b 1c}id=id.3l(/[\\(\\)\\s,\\zs#]/g,"1X");if(1f.41&&id!=1f.41.id){dA.dL.7C(1f.41);46 1f.41}if(!1f.41){el=$(1z+"YG",{id:id});1f.41=el;$(el,1z=="r8"?{fx:fx,fy:fy}:{x1:8G[0],y1:8G[1],x2:8G[2],y2:8G[3],YJ:1f.4N.mu()});dA.dL.3Q(el);1o(K i=0,ii=5p.1e;i<ii;i++){el.3Q($("5I",{2n:5p[i].2n?5p[i].2n:i?"100%":"0%","5I-3B":5p[i].3B||"#lF"}))}}}$(o,{2b:"58(#"+id+")",2R:1,"2b-2R":1});s.2b=E;s.2R=1;s.YI=1;1b 1},q8=1a(o){K 3d=o.6N(1);$(o.cY,{YH:o.4N.mu()+" h4("+3d.x+","+3d.y+")"})},c9=1a(o,1n,eJ){if(o.1z=="1K"){K 2Q=4d(1n).3N().3w("-"),p=o.2F,se=eJ?"4g":"2S",1u=o.1u,2h=o.2h,28=2h["28-1k"],i=2Q.1e,1z="oC",2D,to,dx,mE,1l,w=3,h=3,t=5;43(i--){3x(2Q[i]){1p"6C":;1p"oC":;1p"qM":;1p"qH":;1p"76":;1p"3j":1z=2Q[i];1r;1p"Re":h=5;1r;1p"R9":h=2;1r;1p"R3":w=5;1r;1p"QX":w=2;1r}}if(1z=="76"){w+=2;h+=2;t+=2;dx=1;mE=eJ?4:1;1l={2b:"3j",28:2h.28}}1i{mE=dx=w/2;1l={2b:2h.28,28:"3j"}}if(o.1X.4Q){if(eJ){o.1X.4Q.Fo&&c3[o.1X.4Q.Fo]--;o.1X.4Q.Fk&&c3[o.1X.4Q.Fk]--}1i{o.1X.4Q.Fu&&c3[o.1X.4Q.Fu]--;o.1X.4Q.Gt&&c3[o.1X.4Q.Gt]--}}1i{o.1X.4Q={}}if(1z!="3j"){K hP="4h-ee-"+1z,hU="4h-ee-"+se+1z+w+h;if(!R.7Q.3a.fu(hP)){p.dL.3Q($($("1K"),{"28-dg":"4R",d:Gq[1z],id:hP}));c3[hP]=1}1i{c3[hP]++}K ee=R.7Q.3a.fu(hU),hQ;if(!ee){ee=$($("ee"),{id:hU,YT:h,YX:w,Yu:"5T",mE:mE,113:h/2});hQ=$($("hQ"),{"ed:5d":"#"+hP,3U:(eJ?"5B(ds "+w/ 2 + " " + h /2+") ":E)+"7J("+w/ t + "," + h /t+")","28-1k":(1/ ((w /t+h/ t) /2)).4G(4)});ee.3Q(hQ);p.dL.3Q(ee);c3[hU]=1}1i{c3[hU]++;hQ=ee.dv("hQ")[0]}$(hQ,1l);K qU=dx*(1z!="qH"&&1z!="qM");if(eJ){2D=o.1X.4Q.Go*28||0;to=R.cA(2h.1K)-qU*28}1i{2D=qU*28;to=R.cA(2h.1K)-(o.1X.4Q.GP*28||0)}1l={};1l["ee-"+se]="58(#"+hU+")";if(to||2D){1l.d=R.nn(2h.1K,2D,to)}$(1u,1l);o.1X.4Q[se+"oU"]=hP;o.1X.4Q[se+"GL"]=hU;o.1X.4Q[se+"dx"]=qU;o.1X.4Q[se+"4P"]=1z;o.1X.4Q[se+"5w"]=1n}1i{if(eJ){2D=o.1X.4Q.Go*28||0;to=R.cA(2h.1K)-2D}1i{2D=0;to=R.cA(2h.1K)-(o.1X.4Q.GP*28||0)}o.1X.4Q[se+"oU"]&&$(1u,{d:R.nn(2h.1K,2D,to)});46 o.1X.4Q[se+"oU"];46 o.1X.4Q[se+"GL"];46 o.1X.4Q[se+"dx"];46 o.1X.4Q[se+"4P"];46 o.1X.4Q[se+"5w"]}1o(1l in c3){if(c3[3t](1l)&&!c3[1l]){K 1h=R.7Q.3a.fu(1l);1h&&1h.3r.7C(1h)}}}},9w={"":[0],"3j":[0],"-":[3,1],".":[1,1],"-.":[3,1,1,1],"-..":[3,1,1,1,1,1],". ":[1,3],"- ":[4,3],"--":[8,3],"- .":[4,3,1,3],"--.":[8,3,1,3],"--..":[8,3,1,3,1,3]},AO=1a(o,1n,1y){1n=9w[4d(1n).3N()];if(1n){K 1k=o.2h["28-1k"]||"1",l5={4R:1k,xe:1k,l5:0}[o.2h["28-dg"]||1y["28-dg"]]||0,Av=[],i=1n.1e;43(i--){Av[i]=1n[i]*1k+(i%2?1:-1)*l5}$(o.1u,{"28-9w":Av.53(",")})}},ej=1a(o,1y){K 1u=o.1u,2h=o.2h,GI=1u.2l.gc;1u.2l.gc="5S";1o(K 6I in 1y){if(1y[3t](6I)){if(!R.lU[3t](6I)){bn}K 1n=1y[6I];2h[6I]=1n;3x(6I){1p"5c":o.5c(1n);1r;1p"6o":K 6o=1u.dv("6o");if(6o.1e&&(6o=6o[0])){6o.7Z.GT=1n}1i{6o=$("6o");K 2c=R.7Q.3a.yC(1n);6o.3Q(2c);1u.3Q(6o)}1r;1p"5d":;1p"3e":K pn=1u.3r;if(pn.6v.3N()!="a"){K hl=$("a");pn.7h(hl,1u);hl.3Q(1u);pn=hl}if(6I=="3e"){pn.qq(ed,"5i",1n=="B3"?"1T":1n)}1i{pn.qq(ed,6I,1n)}1r;1p"ln":1u.2l.ln=1n;1r;1p"3U":o.3U(1n);1r;1p"aO-2S":c9(o,1n);1r;1p"aO-4g":c9(o,1n,1);1r;1p"6h-4q":K 4q=4d(1n).3w(5u);if(4q.1e==4){o.6h&&o.6h.3r.3r.7C(o.6h.3r);K el=$("13N"),rc=$("4q");el.id=R.qC();$(rc,{x:4q[0],y:4q[1],1k:4q[2],1s:4q[3]});el.3Q(rc);o.2F.dL.3Q(el);$(1u,{"6h-1K":"58(#"+el.id+")"});o.6h=rc}if(!1n){K 1K=1u.Al("6h-1K");if(1K){K 6h=R.7Q.3a.fu(1K.3l(/(^58\\(#|\\)$)/g,E));6h&&6h.3r.7C(6h);$(1u,{"6h-1K":E});46 o.6h}}1r;1p"1K":if(o.1z=="1K"){$(1u,{d:1n?2h.1K=R.pW(1n):"M0,0"});o.1X.89=1;if(o.1X.4Q){"kE"in o.1X.4Q&&c9(o,o.1X.4Q.kE);"lh"in o.1X.4Q&&c9(o,o.1X.4Q.lh,1)}}1r;1p"1k":1u.aE(6I,1n);o.1X.89=1;if(2h.fx){6I="x";1n=2h.x}1i{1r};1p"x":if(2h.fx){1n=-2h.x-(2h.1k||0)};1p"rx":if(6I=="rx"&&o.1z=="4q"){1r};1p"cx":1u.aE(6I,1n);o.cY&&q8(o);o.1X.89=1;1r;1p"1s":1u.aE(6I,1n);o.1X.89=1;if(2h.fy){6I="y";1n=2h.y}1i{1r};1p"y":if(2h.fy){1n=-2h.y-(2h.1s||0)};1p"ry":if(6I=="ry"&&o.1z=="4q"){1r};1p"cy":1u.aE(6I,1n);o.cY&&q8(o);o.1X.89=1;1r;1p"r":if(o.1z=="4q"){$(1u,{rx:1n,ry:1n})}1i{1u.aE(6I,1n)}o.1X.89=1;1r;1p"4k":if(o.1z=="9n"){1u.qq(ed,"5d",1n)}1r;1p"28-1k":if(o.1X.sx!=1||o.1X.sy!=1){1n/=5a(4j(o.1X.sx),4j(o.1X.sy))||1}if(o.2F.ok){1n*=o.2F.ok}1u.aE(6I,1n);if(2h["28-9w"]){AO(o,2h["28-9w"],1y)}if(o.1X.4Q){"kE"in o.1X.4Q&&c9(o,o.1X.4Q.kE);"lh"in o.1X.4Q&&c9(o,o.1X.4Q.lh,1)}1r;1p"28-9w":AO(o,1n,1y);1r;1p"2b":K h9=4d(1n).3k(R.wA);if(h9){el=$("cY");K ig=$("9n");el.id=R.qC();$(el,{x:0,y:0,13Q:"13M",1s:1,1k:1});$(ig,{x:0,y:0,"ed:5d":h9[1]});el.3Q(ig);(1a(el){R.wy(h9[1],1a(){K w=J.cR,h=J.8z;$(el,{1k:w,1s:h});$(ig,{1k:w,1s:h});o.2F.ls()})})(el);o.2F.dL.3Q(el);$(1u,{2b:"58(#"+el.id+")"});o.cY=el;o.cY&&q8(o);1r}K 3E=R.cQ(1n);if(!3E.9s){46 1y.41;46 2h.41;!R.is(2h.2R,"2p")&&(R.is(1y.2R,"2p")&&$(1u,{2R:2h.2R}));!R.is(2h["2b-2R"],"2p")&&(R.is(1y["2b-2R"],"2p")&&$(1u,{"2b-2R":2h["2b-2R"]}))}1i{if((o.1z=="9y"||(o.1z=="bO"||4d(1n).bq()!="r"))&&o8(o,1n)){if("2R"in 2h||"2b-2R"in 2h){K 41=R.7Q.3a.fu(1u.Al("2b").3l(/^58\\(#|\\)$/g,E));if(41){K lg=41.dv("5I");$(lg[lg.1e-1],{"5I-2R":("2R"in 2h?2h.2R:1)*("2b-2R"in 2h?2h["2b-2R"]:1)})}}2h.41=1n;2h.2b="3j";1r}}3E[3t]("2R")&&$(1u,{"2b-2R":3E.2R>1?3E.2R/100:3E.2R});1p"28":3E=R.cQ(1n);1u.aE(6I,3E.6t);6I=="28"&&(3E[3t]("2R")&&$(1u,{"28-2R":3E.2R>1?3E.2R/100:3E.2R}));if(6I=="28"&&o.1X.4Q){"kE"in o.1X.4Q&&c9(o,o.1X.4Q.kE);"lh"in o.1X.4Q&&c9(o,o.1X.4Q.lh,1)}1r;1p"41":(o.1z=="9y"||(o.1z=="bO"||4d(1n).bq()!="r"))&&o8(o,1n);1r;1p"2R":if(2h.41&&!2h[3t]("28-2R")){$(1u,{"28-2R":1n>1?1n/100:1n})};1p"2b-2R":if(2h.41){41=R.7Q.3a.fu(1u.Al("2b").3l(/^58\\(#|\\)$/g,E));if(41){lg=41.dv("5I");$(lg[lg.1e-1],{"5I-2R":1n})}1r};5v:6I=="2T-3M"&&(1n=aB(1n,10)+"px");K GB=6I.3l(/(\\-.)/g,1a(w){1b w.gT(1).8P()});1u.2l[GB]=1n;o.1X.89=1;1u.aE(6I,1n);1r}}}GJ(o,1y);1u.2l.gc=GI},xd=1.2,GJ=1a(el,1y){if(el.1z!="2a"||!(1y[3t]("2a")||(1y[3t]("2T")||(1y[3t]("2T-3M")||(1y[3t]("x")||1y[3t]("y")))))){1b}K a=el.2h,1u=el.1u,ez=1u.7Z?aB(R.7Q.3a.kR.gp(1u.7Z,E).yF("2T-3M"),10):10;if(1y[3t]("2a")){a.2a=1y.2a;43(1u.7Z){1u.7C(1u.7Z)}K x9=4d(1y.2a).3w("\\n"),iM=[],gL;1o(K i=0,ii=x9.1e;i<ii;i++){gL=$("gL");i&&$(gL,{dy:ez*xd,x:a.x});gL.3Q(R.7Q.3a.yC(x9[i]));1u.3Q(gL);iM[i]=gL}}1i{iM=1u.dv("gL");1o(i=0,ii=iM.1e;i<ii;i++){if(i){$(iM[i],{dy:ez*xd,x:a.x})}1i{$(iM[0],{dy:0})}}}$(1u,{x:a.x,y:a.y});el.1X.89=1;K bb=el.mJ(),qK=a.y-(bb.y+bb.1s/2);qK&&(R.is(qK,"mS")&&$(iM[0],{dy:qK}))},a0=1a(1u,4c){K X=0,Y=0;J[0]=J.1u=1u;1u.4h=1m;J.id=R.z5++;1u.z4=J.id;J.4N=R.4N();J.gC=1c;J.2F=4c;J.2h=J.2h||{};J.1X={3U:[],sx:1,sy:1,4x:0,dx:0,dy:0,89:1};!4c.4p&&(4c.4p=J);J.3H=4c.1L;4c.1L&&(4c.1L.3p=J);4c.1L=J;J.3p=1c},3i=R.el;a0.2V=3i;3i.5e=a0;R.4S.1K=1a(8I,dA){K el=$("1K");dA.1W&&dA.1W.3Q(el);K p=1T a0(el,dA);p.1z="1K";ej(p,{2b:"3j",28:"#de",1K:8I});1b p};3i.5B=1a(4x,cx,cy){if(J.5o){1b J}4x=4d(4x).3w(5u);if(4x.1e-1){cx=3P(4x[1]);cy=3P(4x[2])}4x=3P(4x[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 3d=J.6N(1);cx=3d.x+3d.1k/2;cy=3d.y+3d.1s/2}J.3U(J.1X.3U.3I([["r",4x,cx,cy]]));1b J};3i.7J=1a(sx,sy,cx,cy){if(J.5o){1b J}sx=4d(sx).3w(5u);if(sx.1e-1){sy=3P(sx[1]);cx=3P(sx[2]);cy=3P(sx[3])}sx=3P(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 3d=J.6N(1)}cx=cx==1c?3d.x+3d.1k/2:cx;cy=cy==1c?3d.y+3d.1s/2:cy;J.3U(J.1X.3U.3I([["s",sx,sy,cx,cy]]));1b J};3i.h4=1a(dx,dy){if(J.5o){1b J}dx=4d(dx).3w(5u);if(dx.1e-1){dy=3P(dx[1])}dx=3P(dx[0])||0;dy=+dy||0;J.3U(J.1X.3U.3I([["t",dx,dy]]));1b J};3i.3U=1a(aK){K 1X=J.1X;if(aK==1c){1b 1X.3U}R.z8(J,aK);J.6h&&$(J.6h,{3U:J.4N.mu()});J.cY&&q8(J);J.1u&&$(J.1u,{3U:J.4N});if(1X.sx!=1||1X.sy!=1){K sw=J.2h[3t]("28-1k")?J.2h["28-1k"]:1;J.1l({"28-1k":sw})}1b J};3i.3S=1a(){!J.5o&&J.2F.ls(J.1u.2l.4u="3j");1b J};3i.5i=1a(){!J.5o&&J.2F.ls(J.1u.2l.4u="");1b J};3i.3v=1a(){if(J.5o||!J.1u.3r){1b}K 2F=J.2F;2F.7f&&2F.7f.zC(J);31.8d("4h.*.*."+J.id);if(J.41){2F.dL.7C(J.41)}R.zR(J,2F);if(J.1u.3r.6v.3N()=="a"){J.1u.3r.3r.7C(J.1u.3r)}1i{J.1u.3r.7C(J.1u)}1o(K i in J){J[i]=2s J[i]=="1a"?R.nq(i):1c}J.5o=1m};3i.mJ=1a(){if(J.1u.2l.4u=="3j"){J.5i();K 3S=1m}K 3d={};7a{3d=J.1u.6N()}7b(e){}11B{3d=3d||{}}3S&&J.3S();1b 3d};3i.1l=1a(1x,1n){if(J.5o){1b J}if(1x==1c){K 1A={};1o(K a in J.2h){if(J.2h[3t](a)){1A[a]=J.2h[a]}}1A.41&&(1A.2b=="3j"&&((1A.2b=1A.41)&&46 1A.41));1A.3U=J.1X.3U;1b 1A}if(1n==1c&&R.is(1x,"4i")){if(1x=="2b"&&(J.2h.2b=="3j"&&J.2h.41)){1b J.2h.41}if(1x=="3U"){1b J.1X.3U}K 7H=1x.3w(5u),2q={};1o(K i=0,ii=7H.1e;i<ii;i++){1x=7H[i];if(1x in J.2h){2q[1x]=J.2h[1x]}1i{if(R.is(J.2F.8W[1x],"1a")){2q[1x]=J.2F.8W[1x].Pj}1i{2q[1x]=R.lU[1x]}}}1b ii-1?2q:2q[7H[0]]}if(1n==1c&&R.is(1x,"3Z")){2q={};1o(i=0,ii=1x.1e;i<ii;i++){2q[1x[i]]=J.1l(1x[i])}1b 2q}if(1n!=1c){K 1y={};1y[1x]=1n}1i{if(1x!=1c&&R.is(1x,"1C")){1y=1x}}1o(K 1q in 1y){31("4h.1l."+1q+"."+J.id,J,1y[1q])}1o(1q in J.2F.8W){if(J.2F.8W[3t](1q)&&(1y[3t](1q)&&R.is(J.2F.8W[1q],"1a"))){K 91=J.2F.8W[1q].3h(J,[].3I(1y[1q]));J.2h[1q]=1y[1q];1o(K cd in 91){if(91[3t](cd)){1y[cd]=91[cd]}}}}ej(J,1y);1b J};3i.Pd=1a(){if(J.5o){1b J}if(J.1u.3r.6v.3N()=="a"){J.1u.3r.3r.3Q(J.1u.3r)}1i{J.1u.3r.3Q(J.1u)}K 4c=J.2F;4c.1L!=J&&R.zy(J,4c);1b J};3i.Pi=1a(){if(J.5o){1b J}K 1N=J.1u.3r;if(1N.6v.3N()=="a"){1N.3r.7h(J.1u.3r,J.1u.3r.3r.7Z)}1i{if(1N.7Z!=J.1u){1N.7h(J.1u,J.1u.3r.7Z)}}R.zr(J,J.2F);K 4c=J.2F;1b J};3i.fI=1a(1f){if(J.5o){1b J}K 1u=1f.1u||1f[1f.1e-1].1u;if(1u.ir){1u.3r.7h(J.1u,1u.ir)}1i{1u.3r.3Q(J.1u)}R.An(J,1f,J.2F);1b J};3i.7h=1a(1f){if(J.5o){1b J}K 1u=1f.1u||1f[0].1u;1u.3r.7h(J.1u,1u);R.zt(J,1f,J.2F);1b J};3i.5c=1a(3M){K t=J;if(+3M!==0){K kA=$("4H"),5c=$("11D");t.2h.5c=3M;kA.id=R.qC();$(5c,{11q:+3M||1.5});kA.3Q(5c);t.2F.dL.3Q(kA);t.qp=kA;$(t.1u,{4H:"58(#"+kA.id+")"})}1i{if(t.qp){t.qp.3r.7C(t.qp);46 t.qp;46 t.2h.5c}t.1u.11j("4H")}1b t};R.4S.9y=1a(4c,x,y,r){K el=$("9y");4c.1W&&4c.1W.3Q(el);K 1A=1T a0(el,4c);1A.2h={cx:x,cy:y,r:r,2b:"3j",28:"#de"};1A.1z="9y";$(el,1A.2h);1b 1A};R.4S.4q=1a(4c,x,y,w,h,r){K el=$("4q");4c.1W&&4c.1W.3Q(el);K 1A=1T a0(el,4c);1A.2h={x:x,y:y,1k:w,1s:h,r:r||0,rx:r||0,ry:r||0,2b:"3j",28:"#de"};1A.1z="4q";$(el,1A.2h);1b 1A};R.4S.bO=1a(4c,x,y,rx,ry){K el=$("bO");4c.1W&&4c.1W.3Q(el);K 1A=1T a0(el,4c);1A.2h={cx:x,cy:y,rx:rx,ry:ry,2b:"3j",28:"#de"};1A.1z="bO";$(el,1A.2h);1b 1A};R.4S.9n=1a(4c,4k,x,y,w,h){K el=$("9n");$(el,{x:x,y:y,1k:w,1s:h,Ge:"3j"});el.qq(ed,"5d",4k);4c.1W&&4c.1W.3Q(el);K 1A=1T a0(el,4c);1A.2h={x:x,y:y,1k:w,1s:h,4k:4k};1A.1z="9n";1b 1A};R.4S.2a=1a(4c,x,y,2a){K el=$("2a");4c.1W&&4c.1W.3Q(el);K 1A=1T a0(el,4c);1A.2h={x:x,y:y,"2a-A7":"xM",2a:2a,2T:R.lU.2T,28:"3j",2b:"#de"};1A.1z="2a";ej(1A,1A.2h);1b 1A};R.4S.ke=1a(1k,1s){J.1k=1k||J.1k;J.1s=1s||J.1s;J.1W.aE("1k",J.1k);J.1W.aE("1s",J.1s);if(J.gU){J.gn.3h(J,J.gU)}1b J};R.4S.7V=1a(){K aH=R.zP.3h(0,2t),4l=aH&&aH.4l,x=aH.x,y=aH.y,1k=aH.1k,1s=aH.1s;if(!4l){8U 1T 9R("dA 4l 5L 98.")}K bP=$("4c"),2I="cO:5S;",xV;x=x||0;y=y||0;1k=1k||Qi;1s=1s||Qj;$(bP,{1s:1s,6c:1.1,1k:1k,QJ:"6S://pE.w3.r5/G6/4c"});if(4l==1){bP.2l.eI=2I+"2K:6F;1Z:"+x+"px;1L:"+y+"px";R.7Q.3a.3s.3Q(bP);xV=1}1i{bP.2l.eI=2I+"2K:iZ";if(4l.7Z){4l.7h(bP,4l.7Z)}1i{4l.3Q(bP)}}4l=1T R.zA;4l.1k=1k;4l.1s=1s;4l.1W=bP;4l.aN();4l.qX=4l.r9=0;xV&&(4l.sg=1a(){});4l.sg();1b 4l};R.4S.gn=1a(x,y,w,h,bM){31("4h.gn",J,J.gU,[x,y,w,h,bM]);K 3M=5a(w/ J.1k, h /J.1s),1L=J.1L,Gc=bM?"12z":"12D",vb,sw;if(x==1c){if(J.ok){3M=1}46 J.ok;vb="0 0 "+J.1k+S+J.1s}1i{J.ok=3M;vb=x+S+y+S+w+S+h}$(J.1W,{130:vb,Ge:Gc});43(3M&&1L){sw="28-1k"in 1L.2h?1L.2h["28-1k"]:1;1L.1l({"28-1k":sw});1L.1X.89=1;1L.1X.gS=1;1L=1L.3H}J.gU=[x,y,w,h,!!bM];1b J};R.2V.sg=1a(){K bP=J.1W,s=bP.2l,3G;7a{3G=bP.12P()||bP.G4()}7b(e){3G=bP.G4()}K 1Z=-3G.e%1,1L=-3G.f%1;if(1Z||1L){if(1Z){J.qX=(J.qX+1Z)%1;s.1Z=J.qX+"px"}if(1L){J.r9=(J.r9+1L)%1;s.1L=J.r9+"px"}}};R.2V.aN=1a(){R.31("4h.aN",J);K c=J.1W;43(c.7Z){c.7C(c.7Z)}J.4p=J.1L=1c;(J.yE=$("yE")).3Q(R.7Q.3a.yC("124 iT hf\\ht "+R.6c));c.3Q(J.yE);c.3Q(J.dL=$("dL"))};R.2V.3v=1a(){31("4h.3v",J);J.1W.3r&&J.1W.3r.7C(J.1W);1o(K i in J){J[i]=2s J[i]=="1a"?R.nq(i):1c}};K 73=R.st;1o(K 4f in 3i){if(3i[3t](4f)&&!73[3t](4f)){73[4f]=1a(fH){1b 1a(){K 4s=2t;1b J.9m(1a(el){el[fH].3h(el,4s)})}}(4f)}}})();(1a(){if(!R.5Y){1b}K 3t="7K",4d=5w,3P=cq,3L=3o,4R=3L.4R,5a=3L.47,6d=3L.5U,4j=3L.4j,hI="2b",5u=/[, ]+/,31=R.31,ms=" wQ:G3.wJ",S=" ",E="",bS={M:"m",L:"l",C:"c",Z:"x",m:"t",l:"r",c:"v",z:"x"},Rp=/([wI]),?([^wI]*)/gi,Px=/ wQ:\\S+Pq\\([^\\)]+\\)/g,2c=/-?[^,\\s-]+/g,zj="2K:6F;1Z:0;1L:0;1k:lG;1s:lG",6T=12m,RG={1K:1,4q:1,9n:1},Rz={9y:1,bO:1},QW=1a(1K){K cH=/[12v]/ig,8t=R.pW;4d(1K).3k(cH)&&(8t=R.qR);cH=/[wI]/g;if(8t==R.pW&&!4d(1K).3k(cH)){K 1A=4d(1K).3l(Rp,1a(6D,8t,2j){K lS=[],Rn=8t.3N()=="m",1A=bS[8t];2j.3l(2c,1a(1n){if(Rn&&lS.1e==2){1A+=lS+bS[8t=="m"?"l":"L"];lS=[]}lS.1H(4R(1n*6T))});1b 1A+lS});1b 1A}K pa=8t(1K),p,r;1A=[];1o(K i=0,ii=pa.1e;i<ii;i++){p=pa[i];r=pa[i][0].3N();r=="z"&&(r="x");1o(K j=1,jj=p.1e;j<jj;j++){r+=4R(p[j]*6T)+(j!=jj-1?",":E)}1A.1H(r)}1b 1A.53(S)},xQ=1a(4x,dx,dy){K m=R.4N();m.5B(-4x,0.5,0.5);1b{dx:m.x(dx,dy),dy:m.y(dx,dy)}},mc=1a(p,sx,sy,dx,dy,4x){K 1X=p.1X,m=p.4N,d6=1X.d6,o=p.1u,s=o.2l,y=1,lX="",125,kx=6T/ sx, ky = 6T /sy;s.gc="5S";if(!sx||!sy){1b}o.sf=4j(kx)+S+4j(ky);s.12h=4x*(sx*sy<0?-1:1);if(4x){K c=xQ(4x,dx,dy);dx=c.dx;dy=c.dy}sx<0&&(lX+="x");sy<0&&((lX+=" y")&&(y=-1));s.lX=lX;o.lK=dx*-kx+S+dy*-ky;if(d6||1X.iK){K 2b=o.dv(hI);2b=2b&&2b[0];o.7C(2b);if(d6){c=xQ(4x,m.x(d6[0],d6[1]),m.y(d6[0],d6[1]));2b.2K=c.dx*y+S+c.dy*y}if(1X.iK){2b.3M=1X.iK[0]*4j(sx)+S+1X.iK[1]*4j(sy)}o.3Q(2b)}s.gc="5X"};R.3u=1a(){1b"R1 sR 12N\\12U e4 dA. 12L dX to hq.\\Rg r3 xX hf\\ht "+J.6c};K c9=1a(o,1n,eJ){K 2Q=4d(1n).3N().3w("-"),se=eJ?"4g":"2S",i=2Q.1e,1z="oC",w="Rf",h="Rf";43(i--){3x(2Q[i]){1p"6C":;1p"oC":;1p"qM":;1p"qH":;1p"76":;1p"3j":1z=2Q[i];1r;1p"Re":;1p"R9":h=2Q[i];1r;1p"R3":;1p"QX":w=2Q[i];1r}}K 28=o.1u.dv("28")[0];28[se+"aO"]=1z;28[se+"12G"]=w;28[se+"11o"]=h},ej=1a(o,1y){o.2h=o.2h||{};K 1u=o.1u,a=o.2h,s=1u.2l,xy,yc=RG[o.1z]&&(1y.x!=a.x||(1y.y!=a.y||(1y.1k!=a.1k||(1y.1s!=a.1s||(1y.cx!=a.cx||(1y.cy!=a.cy||(1y.rx!=a.rx||(1y.ry!=a.ry||1y.r!=a.r)))))))),Rl=Rz[o.1z]&&(a.cx!=1y.cx||(a.cy!=1y.cy||(a.r!=1y.r||(a.rx!=1y.rx||a.ry!=1y.ry)))),1A=o;1o(K 91 in 1y){if(1y[3t](91)){a[91]=1y[91]}}if(yc){a.1K=R.yA[o.1z](o);o.1X.89=1}1y.5d&&(1u.5d=1y.5d);1y.6o&&(1u.6o=1y.6o);1y.3e&&(1u.3e=1y.3e);1y.ln&&(s.ln=1y.ln);"5c"in 1y&&o.5c(1y.5c);if(1y.1K&&o.1z=="1K"||yc){1u.1K=QW(~4d(a.1K).3N().51("r")?R.pW(a.1K):a.1K);if(o.1z=="9n"){o.1X.d6=[a.x,a.y];o.1X.iK=[a.1k,a.1s];mc(o,1,1,0,0,0)}}"3U"in 1y&&o.3U(1y.3U);if(Rl){K cx=+a.cx,cy=+a.cy,rx=+a.rx||(+a.r||0),ry=+a.ry||(+a.r||0);1u.1K=R.6W("ar{0},{1},{2},{3},{4},{1},{4},{1}x",4R((cx-rx)*6T),4R((cy-ry)*6T),4R((cx+rx)*6T),4R((cy+ry)*6T),4R(cx*6T));o.1X.89=1}if("6h-4q"in 1y){K 4q=4d(1y["6h-4q"]).3w(5u);if(4q.1e==4){4q[2]=+4q[2]+ +4q[0];4q[3]=+4q[3]+ +4q[1];K 2E=1u.q9||R.7Q.3a.c4("2E"),j1=2E.2l;j1.6h=R.6W("4q({1}px {2}px {3}px {0}px)",4q);if(!1u.q9){j1.2K="6F";j1.1L=0;j1.1Z=0;j1.1k=o.2F.1k+"px";j1.1s=o.2F.1s+"px";1u.3r.7h(2E,1u);2E.3Q(1u);1u.q9=2E}}if(!1y["6h-4q"]){1u.q9&&(1u.q9.2l.6h="5T")}}if(o.dr){K l7=o.dr.2l;1y.2T&&(l7.2T=1y.2T);1y["2T-8C"]&&(l7.R5=\'"\'+1y["2T-8C"].3w(",")[0].3l(/^[\'"]+|[\'"]+$/g,E)+\'"\');1y["2T-3M"]&&(l7.ez=1y["2T-3M"]);1y["2T-9Z"]&&(l7.R0=1y["2T-9Z"]);1y["2T-2l"]&&(l7.Rq=1y["2T-2l"])}if("aO-2S"in 1y){c9(1A,1y["aO-2S"])}if("aO-4g"in 1y){c9(1A,1y["aO-4g"],1)}if(1y.2R!=1c||(1y["28-1k"]!=1c||(1y.2b!=1c||(1y.4k!=1c||(1y.28!=1c||(1y["28-1k"]!=1c||(1y["28-2R"]!=1c||(1y["2b-2R"]!=1c||(1y["28-9w"]!=1c||(1y["28-mH"]!=1c||(1y["28-iG"]!=1c||1y["28-dg"]!=1c))))))))))){K 2b=1u.dv(hI),Rb=1j;2b=2b&&2b[0];!2b&&(Rb=2b=du(hI));if(o.1z=="9n"&&1y.4k){2b.4k=1y.4k}1y.2b&&(2b.on=1m);if(2b.on==1c||(1y.2b=="3j"||1y.2b===1c)){2b.on=1j}if(2b.on&&1y.2b){K h9=4d(1y.2b).3k(R.wA);if(h9){2b.3r==1u&&1u.7C(2b);2b.5B=1m;2b.4k=h9[1];2b.1z="Pt";K 3d=o.6N(1);2b.2K=3d.x+S+3d.y;o.1X.d6=[3d.x,3d.y];R.wy(h9[1],1a(){o.1X.iK=[J.cR,J.8z]})}1i{2b.3B=R.cQ(1y.2b).6t;2b.4k=E;2b.1z="qd";if(R.cQ(1y.2b).9s&&((1A.1z in{9y:1,bO:1}||4d(1y.2b).bq()!="r")&&o8(1A,1y.2b,2b))){a.2b="3j";a.41=1y.2b;2b.5B=1j}}}if("2b-2R"in 1y||"2R"in 1y){K 2R=((+a["2b-2R"]+1||2)-1)*((+a.2R+1||2)-1)*((+R.cQ(1y.2b).o+1||2)-1);2R=6d(5a(2R,0),1);2b.2R=2R;if(2b.4k){2b.3B="3j"}}1u.3Q(2b);K 28=1u.dv("28")&&1u.dv("28")[0],Aq=1j;!28&&(Aq=28=du("28"));if(1y.28&&1y.28!="3j"||(1y["28-1k"]||(1y["28-2R"]!=1c||(1y["28-9w"]||(1y["28-mH"]||(1y["28-iG"]||1y["28-dg"])))))){28.on=1m}(1y.28=="3j"||(1y.28===1c||(28.on==1c||(1y.28==0||1y["28-1k"]==0))))&&(28.on=1j);K wH=R.cQ(1y.28);28.on&&(1y.28&&(28.3B=wH.6t));2R=((+a["28-2R"]+1||2)-1)*((+a.2R+1||2)-1)*((+wH.o+1||2)-1);K 1k=(3P(1y["28-1k"])||1)*0.75;2R=6d(5a(2R,0),1);1y["28-1k"]==1c&&(1k=a["28-1k"]);1y["28-1k"]&&(28.9Z=1k);1k&&(1k<1&&((2R*=1k)&&(28.9Z=1)));28.2R=2R;1y["28-iG"]&&(28.11F=1y["28-iG"]||"14i");28.mH=1y["28-mH"]||8;1y["28-dg"]&&(28.145=1y["28-dg"]=="l5"?"142":1y["28-dg"]=="xe"?"xe":"4R");if("28-9w"in 1y){K 9w={"-":"13W",".":"14j","-.":"13k","-..":"13p",". ":"71","- ":"13r","--":"13m","- .":"13o","--.":"134","--..":"135"};28.13b=9w[3t](1y["28-9w"])?9w[1y["28-9w"]]:E}Aq&&1u.3Q(28)}if(1A.1z=="2a"){1A.2F.1W.2l.4u=E;K 2B=1A.2F.2B,m=100,ez=a.2T&&a.2T.3k(/\\d+(?:\\.\\d*)?(?=px)/);s=2B.2l;a.2T&&(s.2T=a.2T);a["2T-8C"]&&(s.R5=a["2T-8C"]);a["2T-9Z"]&&(s.R0=a["2T-9Z"]);a["2T-2l"]&&(s.Rq=a["2T-2l"]);ez=3P(a["2T-3M"]||ez&&ez[0])||10;s.ez=ez*m+"px";1A.dr.4i&&(2B.jM=4d(1A.dr.4i).3l(/</g,"&#60;").3l(/&/g,"&#38;").3l(/\\n/g,"<br>"));K nR=2B.ol();1A.W=a.w=(nR.7w-nR.1Z)/m;1A.H=a.h=(nR.4p-nR.1L)/m;1A.X=a.x;1A.Y=a.y+1A.H/2;("x"in 1y||"y"in 1y)&&(1A.1K.v=R.6W("m{0},{1}l{2},{1}",4R(a.x*6T),4R(a.y*6T),4R(a.x*6T)+1));K zX=["x","y","2a","2T","2T-8C","2T-9Z","2T-2l","2T-3M"];1o(K d=0,dd=zX.1e;d<dd;d++){if(zX[d]in 1y){1A.1X.89=1;1r}}3x(a["2a-A7"]){1p"2S":1A.dr.2l["v-2a-A6"]="1Z";1A.sj=1A.W/2;1r;1p"4g":1A.dr.2l["v-2a-A6"]="7w";1A.sj=-1A.W/2;1r;5v:1A.dr.2l["v-2a-A6"]="13L";1A.sj=0;1r}1A.dr.2l["v-2a-13I"]=1m}},o8=1a(o,41,2b){o.2h=o.2h||{};K 2h=o.2h,66=3o.66,2R,13R,1z="mZ",AD=".5 .5";o.2h.41=41;41=4d(41).3l(R.AN,1a(6D,fx,fy){1z="r8";if(fx&&fy){fx=3P(fx);fy=3P(fy);66(fx-0.5,2)+66(fy-0.5,2)>0.25&&(fy=3L.aC(0.25-66(fx-0.5,2))*((fy>0.5)*2-1)+0.5);AD=fx+S+fy}1b E});41=41.3w(/\\s*\\-\\s*/);if(1z=="mZ"){K 7z=41.c0();7z=-3P(7z);if(cP(7z)){1b 1c}}K 5p=R.AC(41);if(!5p){1b 1c}o=o.dp||o.1u;if(5p.1e){o.7C(2b);2b.on=1m;2b.4f="3j";2b.3B=5p[0].3B;2b.13P=5p[5p.1e-1].3B;K ra=[];1o(K i=0,ii=5p.1e;i<ii;i++){5p[i].2n&&ra.1H(5p[i].2n+S+5p[i].3B)}2b.13t=ra.1e?ra.53():"0% "+2b.3B;if(1z=="r8"){2b.1z="13u";2b.3b="100%";2b.13y="0 0";2b.13C=AD;2b.7z=0}1i{2b.1z="41";2b.7z=(13D-7z)%8Q}o.3Q(2b)}1b 1},a0=1a(1u,5Y){J[0]=J.1u=1u;1u.4h=1m;J.id=R.z5++;1u.z4=J.id;J.X=0;J.Y=0;J.2h={};J.2F=5Y;J.4N=R.4N();J.1X={3U:[],sx:1,sy:1,dx:0,dy:0,4x:0,89:1,gS:1};!5Y.4p&&(5Y.4p=J);J.3H=5Y.1L;5Y.1L&&(5Y.1L.3p=J);5Y.1L=J;J.3p=1c};K 3i=R.el;a0.2V=3i;3i.5e=a0;3i.3U=1a(aK){if(aK==1c){1b J.1X.3U}K hO=J.2F.Qu,PS=hO?"s"+[hO.7J,hO.7J]+"-1-1t"+[hO.dx,hO.dy]:E,qG;if(hO){qG=aK=4d(aK).3l(/\\.{3}|\\z1/g,J.1X.3U||E)}R.z8(J,PS+aK);K 4N=J.4N.6e(),8E=J.8E,o=J.1u,3w,yM=~4d(J.2h.2b).51("-"),PR=!4d(J.2h.2b).51("58(");4N.h4(1,1);if(PR||(yM||J.1z=="9n")){8E.4N="1 0 0 1";8E.2n="0 0";3w=4N.3w();if(yM&&3w.PQ||!3w.yL){o.2l.4H=4N.PV();K bb=J.6N(),yK=J.6N(1),dx=bb.x-yK.x,dy=bb.y-yK.y;o.lK=dx*-6T+S+dy*-6T;mc(J,1,1,dx,dy,0)}1i{o.2l.4H=E;mc(J,3w.ge,3w.fD,3w.dx,3w.dy,3w.5B)}}1i{o.2l.4H=E;8E.4N=4d(4N);8E.2n=4N.2n()}qG&&(J.1X.3U=qG);1b J};3i.5B=1a(4x,cx,cy){if(J.5o){1b J}if(4x==1c){1b}4x=4d(4x).3w(5u);if(4x.1e-1){cx=3P(4x[1]);cy=3P(4x[2])}4x=3P(4x[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 3d=J.6N(1);cx=3d.x+3d.1k/2;cy=3d.y+3d.1s/2}J.1X.gS=1;J.3U(J.1X.3U.3I([["r",4x,cx,cy]]));1b J};3i.h4=1a(dx,dy){if(J.5o){1b J}dx=4d(dx).3w(5u);if(dx.1e-1){dy=3P(dx[1])}dx=3P(dx[0])||0;dy=+dy||0;if(J.1X.3d){J.1X.3d.x+=dx;J.1X.3d.y+=dy}J.3U(J.1X.3U.3I([["t",dx,dy]]));1b J};3i.7J=1a(sx,sy,cx,cy){if(J.5o){1b J}sx=4d(sx).3w(5u);if(sx.1e-1){sy=3P(sx[1]);cx=3P(sx[2]);cy=3P(sx[3]);cP(cx)&&(cx=1c);cP(cy)&&(cy=1c)}sx=3P(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 3d=J.6N(1)}cx=cx==1c?3d.x+3d.1k/2:cx;cy=cy==1c?3d.y+3d.1s/2:cy;J.3U(J.1X.3U.3I([["s",sx,sy,cx,cy]]));J.1X.gS=1;1b J};3i.3S=1a(){!J.5o&&(J.1u.2l.4u="3j");1b J};3i.5i=1a(){!J.5o&&(J.1u.2l.4u=E);1b J};3i.mJ=1a(){if(J.5o){1b{}}1b{x:J.X+(J.sj||0)-J.W/2,y:J.Y-J.H,1k:J.W,1s:J.H}};3i.3v=1a(){if(J.5o||!J.1u.3r){1b}J.2F.7f&&J.2F.7f.zC(J);R.31.8d("4h.*.*."+J.id);R.zR(J,J.2F);J.1u.3r.7C(J.1u);J.dp&&J.dp.3r.7C(J.dp);1o(K i in J){J[i]=2s J[i]=="1a"?R.nq(i):1c}J.5o=1m};3i.1l=1a(1x,1n){if(J.5o){1b J}if(1x==1c){K 1A={};1o(K a in J.2h){if(J.2h[3t](a)){1A[a]=J.2h[a]}}1A.41&&(1A.2b=="3j"&&((1A.2b=1A.41)&&46 1A.41));1A.3U=J.1X.3U;1b 1A}if(1n==1c&&R.is(1x,"4i")){if(1x==hI&&(J.2h.2b=="3j"&&J.2h.41)){1b J.2h.41}K 7H=1x.3w(5u),2q={};1o(K i=0,ii=7H.1e;i<ii;i++){1x=7H[i];if(1x in J.2h){2q[1x]=J.2h[1x]}1i{if(R.is(J.2F.8W[1x],"1a")){2q[1x]=J.2F.8W[1x].Pj}1i{2q[1x]=R.lU[1x]}}}1b ii-1?2q:2q[7H[0]]}if(J.2h&&(1n==1c&&R.is(1x,"3Z"))){2q={};1o(i=0,ii=1x.1e;i<ii;i++){2q[1x[i]]=J.1l(1x[i])}1b 2q}K 1y;if(1n!=1c){1y={};1y[1x]=1n}1n==1c&&(R.is(1x,"1C")&&(1y=1x));1o(K 1q in 1y){31("4h.1l."+1q+"."+J.id,J,1y[1q])}if(1y){1o(1q in J.2F.8W){if(J.2F.8W[3t](1q)&&(1y[3t](1q)&&R.is(J.2F.8W[1q],"1a"))){K 91=J.2F.8W[1q].3h(J,[].3I(1y[1q]));J.2h[1q]=1y[1q];1o(K cd in 91){if(91[3t](cd)){1y[cd]=91[cd]}}}}if(1y.2a&&J.1z=="2a"){J.dr.4i=1y.2a}ej(J,1y)}1b J};3i.Pd=1a(){!J.5o&&J.1u.3r.3Q(J.1u);J.2F&&(J.2F.1L!=J&&R.zy(J,J.2F));1b J};3i.Pi=1a(){if(J.5o){1b J}if(J.1u.3r.7Z!=J.1u){J.1u.3r.7h(J.1u,J.1u.3r.7Z);R.zr(J,J.2F)}1b J};3i.fI=1a(1f){if(J.5o){1b J}if(1f.5e==R.st.5e){1f=1f[1f.1e-1]}if(1f.1u.ir){1f.1u.3r.7h(J.1u,1f.1u.ir)}1i{1f.1u.3r.3Q(J.1u)}R.An(J,1f,J.2F);1b J};3i.7h=1a(1f){if(J.5o){1b J}if(1f.5e==R.st.5e){1f=1f[0]}1f.1u.3r.7h(J.1u,1f.1u);R.zt(J,1f,J.2F);1b J};3i.5c=1a(3M){K s=J.1u.YR,f=s.4H;f=f.3l(Px,E);if(+3M!==0){J.2h.5c=3M;s.4H=f+S+ms+".Pq(YD="+(+3M||1.5)+")";s.gH=R.6W("-{0}px 0 0 -{0}px",4R(+3M||1.5))}1i{s.4H=f;s.gH=0;46 J.2h.5c}1b J};R.4S.1K=1a(8I,5Y){K el=du("dp");el.2l.eI=zj;el.sf=6T+S+6T;el.lK=5Y.lK;K p=1T a0(el,5Y),1l={2b:"3j",28:"#de"};8I&&(1l.1K=8I);p.1z="1K";p.1K=[];p.oU=E;ej(p,1l);5Y.1W.3Q(el);K 8E=du("8E");8E.on=1m;el.3Q(8E);p.8E=8E;p.3U(E);1b p};R.4S.4q=1a(5Y,x,y,w,h,r){K 1K=R.zx(x,y,w,h,r),1A=5Y.1K(1K),a=1A.2h;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1k=w;1A.H=a.1s=h;a.r=r;a.1K=1K;1A.1z="4q";1b 1A};R.4S.bO=1a(5Y,x,y,rx,ry){K 1A=5Y.1K(),a=1A.2h;1A.X=x-rx;1A.Y=y-ry;1A.W=rx*2;1A.H=ry*2;1A.1z="bO";ej(1A,{cx:x,cy:y,rx:rx,ry:ry});1b 1A};R.4S.9y=1a(5Y,x,y,r){K 1A=5Y.1K(),a=1A.2h;1A.X=x-r;1A.Y=y-r;1A.W=1A.H=r*2;1A.1z="9y";ej(1A,{cx:x,cy:y,r:r});1b 1A};R.4S.9n=1a(5Y,4k,x,y,w,h){K 1K=R.zx(x,y,w,h),1A=5Y.1K(1K).1l({28:"3j"}),a=1A.2h,1u=1A.1u,2b=1u.dv(hI)[0];a.4k=4k;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1k=w;1A.H=a.1s=h;a.1K=1K;1A.1z="9n";2b.3r==1u&&1u.7C(2b);2b.5B=1m;2b.4k=4k;2b.1z="Pt";1A.1X.d6=[x,y];1A.1X.iK=[w,h];1u.3Q(2b);mc(1A,1,1,0,0,0);1b 1A};R.4S.2a=1a(5Y,x,y,2a){K el=du("dp"),1K=du("1K"),o=du("dr");x=x||0;y=y||0;2a=2a||"";1K.v=R.6W("m{0},{1}l{2},{1}",4R(x*6T),4R(y*6T),4R(x*6T)+1);1K.YE=1m;o.4i=4d(2a);o.on=1m;el.2l.eI=zj;el.sf=6T+S+6T;el.lK="0 0";K p=1T a0(el,5Y),1l={2b:"#de",28:"3j",2T:R.lU.2T,2a:2a};p.dp=el;p.1K=1K;p.dr=o;p.1z="2a";p.2h.2a=4d(2a);p.2h.x=x;p.2h.y=y;p.2h.w=1;p.2h.h=1;ej(p,1l);el.3Q(o);el.3Q(1K);5Y.1W.3Q(el);K 8E=du("8E");8E.on=1m;el.3Q(8E);p.8E=8E;p.3U(E);1b p};R.4S.ke=1a(1k,1s){K cs=J.1W.2l;J.1k=1k;J.1s=1s;1k==+1k&&(1k+="px");1s==+1s&&(1s+="px");cs.1k=1k;cs.1s=1s;cs.6h="4q(0 "+1k+" "+1s+" 0)";if(J.gU){R.4S.gn.3h(J,J.gU)}1b J};R.4S.gn=1a(x,y,w,h,bM){R.31("4h.gn",J,J.gU,[x,y,w,h,bM]);K 1k=J.1k,1s=J.1s,3M=1/ 5a(w /1k,h/1s),H,W;if(bM){H=1s/h;W=1k/w;if(w*H<1k){x-=(1k-w*H)/ 2 /H}if(h*W<1s){y-=(1s-h*W)/ 2 /W}}J.gU=[x,y,w,h,!!bM];J.Qu={dx:-x,dy:-y,7J:3M};J.9m(1a(el){el.3U("...")});1b J};K du;R.4S.sh=1a(5n){K 3a=5n.2N;3a.YF().YP(".lQ","QG:58(#5v#hq)");7a{!3a.bQ.lQ&&3a.bQ.56("lQ","Ql:Qq-Qh-zQ:5Y");du=1a(6v){1b 3a.c4("<lQ:"+6v+\' 2C="lQ">\')}}7b(e){du=1a(6v){1b 3a.c4("<"+6v+\' QJ="Ql:Qq-Qh.zQ:5Y" 2C="lQ">\')}}};R.4S.sh(R.7Q.5n);R.4S.7V=1a(){K aH=R.zP.3h(0,2t),4l=aH.4l,1s=aH.1s,s,1k=aH.1k,x=aH.x,y=aH.y;if(!4l){8U 1T 9R("hq 4l 5L 98.")}K 1A=1T R.zA,c=1A.1W=R.7Q.3a.c4("2E"),cs=c.2l;x=x||0;y=y||0;1k=1k||Qi;1s=1s||Qj;1A.1k=1k;1A.1s=1s;1k==+1k&&(1k+="px");1s==+1s&&(1s+="px");1A.sf=6T*9q+S+6T*9q;1A.lK="0 0";1A.2B=R.7Q.3a.c4("2B");1A.2B.2l.eI="2K:6F;1Z:-lI;1L:-lI;nr:0;gH:0;bU-1s:1;";c.3Q(1A.2B);cs.eI=R.6W("1L:0;1Z:0;1k:{0};1s:{1};4u:Qg-6C;2K:iZ;6h:4q(0 {0} {1} 0);cO:5S",1k,1s);if(4l==1){R.7Q.3a.3s.3Q(c);cs.1Z=x+"px";cs.1L=y+"px";cs.2K="6F"}1i{if(4l.7Z){4l.7h(c,4l.7Z)}1i{4l.3Q(c)}}1A.sg=1a(){};1b 1A};R.2V.aN=1a(){R.31("4h.aN",J);J.1W.jM=E;J.2B=R.7Q.3a.c4("2B");J.2B.2l.eI="2K:6F;1Z:-lI;1L:-lI;nr:0;gH:0;bU-1s:1;4u:Qg;";J.1W.3Q(J.2B);J.4p=J.1L=1c};R.2V.3v=1a(){R.31("4h.3v",J);J.1W.3r.7C(J.1W);1o(K i in J){J[i]=2s J[i]=="1a"?R.nq(i):1c}1b 1m};K 73=R.st;1o(K 4f in 3i){if(3i[3t](4f)&&!73[3t](4f)){73[4f]=1a(fH){1b 1a(){K 4s=2t;1b J.9m(1a(el){el[fH].3h(el,4s)})}}(4f)}}})();ss.yI?g.5n.bR=R:bR=R;1b R});K QD=1a(yH){J.3B=1c;J.B0=1c;J.bg=1c;J.bU=1c;J.B2=1c;J.2S=1c;J.AP=1c;J.4g=1c;J.1C=1c;J.6B=1c;J.yG=1a(yH){};J.yG(yH)};1a 6N(1v){K 4Y={x:0,y:0,1k:0,1s:0};if(!1v.1e){1b 4Y}K o=1v[0];1a sn(1f,Qo){4Y={x:0,y:0,1k:1f.nW,1s:1f.oq};43(1f){if(1f.id==Qo){1r}4Y.x+=1f.8H-1f.4I+1f.kN;4Y.y+=1f.8V-1f.4T+1f.kW;1f=1f.eg}1b 4Y}if(o.6v=="TR"){4Y=sn(o,"qb-ui-1W")}1i{if(o.6v=="OB"){4Y=sn(o,"qb-ui-1W")}1i{if(o.6v=="Y7"){4Y=sn(o,"qb-ui-1W")}}}1b 4Y}1a f7(x){1b 3o.4R(x*9q)/9q}1a Qc(gQ,gI){K Qm=20;K p1=[{x:gQ.x,y:gQ.y+gQ.1s/ 2}, {x:gQ.x + gQ.1k, y:gQ.y + gQ.1s /2}];K p2=[{x:gI.x,y:gI.y+gI.1s/ 2}, {x:gI.x + gI.1k, y:gI.y + gI.1s /2}];K d=[],n6=[];1o(K i1=0;i1<p1.1e;i1++){1o(K i2=0;i2<p2.1e;i2++){K dx=3o.4j(p1[i1].x-p2[i2].x);K dy=3o.4j(p1[i1].y-p2[i2].y);K 5O=dx*dx+dy*dy;n6.1H(5O);d.1H({i1:i1,i2:i2})}}K 1A={i1:0,i2:0};K sl=-1;K 5U=-1;1o(K i=0;i<n6.1e;i++){if(5U==-1||n6[i]<5U){5U=n6[i];sl=i}}if(sl>0){1A=d[sl]}K x1=p1[1A.i1].x,y1=p1[1A.i1].y,x4=p2[1A.i2].x,y4=p2[1A.i2].y,y2=y1,y3=y4;K dx=3o.47(3o.4j(x1-x4)/2,Qm);K x2=[x1-dx,x1+dx][1A.i1];K x3=[x4-dx,x4+dx][1A.i2];1b{x1:f7(x1),y1:f7(y1),x2:f7(x2),y2:f7(y2),x3:f7(x3),y3:f7(y3),x4:f7(x4),y4:f7(y4)}}1a XK(4Y,Q8){K R=bR==1c?cc:bR;K 4a=4Y;if(R.is(4Y,"1a")){1b Q8?4a():31.on("4h.kv",4a)}1i{if(R.is(4a,1m)){1b R.4S.7V[4Y](R,4a.5t(0,3+R.is(4a[0],1c))).56(4a)}1i{K 2j=3D.2V.3J.2v(2t,0);if(R.is(2j[2j.1e-1],"1a")){K f=2j.e3();1b 4a?f.2v(R.4S.7V[4Y](R,2j)):31.on("4h.kv",1a(){f.2v(R.4S.7V[4Y](R,2j))})}1i{1b R.4S.7V[4Y](R,2t)}}}}bR.fn.CL=1a(1Y){if(!1Y.4U||!1Y.54){1b 1j}if(!1Y.4U.2m||!1Y.54.2m){1b 1j}if(!1Y.4U.2m.1f||!1Y.54.2m.1f){1b 1j}K 7T=1Y.6B;K Ay=8;K 3B=7T.3B;K Qs=1Y.4U.4P;K QN=1Y.54.4P;1a AK(1Y){K dU=6N(1Y.2m.1f);if(1Y.1B){K eK=6N(1Y.1B.1f);dU.x=eK.x-1;dU.1k=eK.1k+2;if(dU.y<eK.y){dU.y=eK.y}1i{if(dU.y>eK.y+eK.1s-dU.1s){dU.y=eK.y+eK.1s-dU.1s}}}1b dU}K Q9=AK(1Y.4U);K Qa=AK(1Y.54);K 7A=Qc(Q9,Qa);K AA=7A.x1<7A.x2?1:-1;K AX=7A.x4<7A.x3?1:-1;K 1K=["M",7A.x1,7A.y1,"L",7A.x1+Ay*AA,7A.y1,"C",7A.x2,7A.y2,7A.x3,7A.y3,7A.x4+Ay*AX,7A.y4,"L",7A.x4,7A.y4].53(",");7T.2S=nE(7T.2S,QN,3B,7A.x1,7A.y1,AA);7T.4g=nE(7T.4g,Qs,3B,7A.x4,7A.y4,AX);if(7T.1K=1K&&(7T.bU&&7T.bg)){7T.bg.1l({1K:1K});7T.bU.1l({1K:1K});$(7T.bg.1u).2y("1Y-2L")}1b 1m};bR.fn.CL;bR.fn.Ny=1a(1v,1l){K 1Y=1T QD;1Y.3B=1l.3w("|")[0]||"#QE";1Y.B0=1l.3w("|")[1]||3;1Y.Qz=15;1Y.bU=J.1K("M,0,0").1l({28:1Y.3B,2b:"3j","28-1k":1Y.B0,"28-dg":"4R","28-iG":"4R"});1Y.bg=J.1K("M,0,0").1l({28:1Y.3B,2b:"3j","28-1k":1Y.Qz,"28-2R":0.QA});1Y.B2=1v.54.4P;1Y.2S=nE(1c,1Y.B2,1Y.3B);1Y.AP=1v.4U.4P;1Y.4g=nE(1c,1Y.AP,1Y.3B);1Y.1C=1v;1b 1Y};1a nE(1v,1z,3B,x,y,d){if(!x){x=0}if(!y){y=0}if(!d){d=1}K sd=1j;if(1v!=1c&&1v.1u){3x(1z){1p 1R.80.da:sd=1v.1u.8A!="9y";1r;1p 1R.80.dY:sd=1v.1u.8A!="1K";1r}}if(sd){if(1v&&1v.3v){1v.3v()}1v=1c}if(1v==1c){3x(1z){1p 1R.80.da:1v=QB.1d.2d.r.9y(0,0,5);1v.1l({2b:3B,"28-1k":0});1r;1p 1R.80.dY:1v=QB.1d.2d.r.1K("M,0,0");1v.1l({2b:3B,"28-1k":0});1r}}3x(1z){1p 1R.80.da:1v.1l({cx:x,cy:y});1r;1p 1R.80.dY:K dx=8;K dy=5;K 1K=["M",x,y,"L",x,y+1,x+dx*d,y+dy,x+dx*d,y-dy,x,y-1,"Z"].53(",");1v.1l({1K:1K});1r}1b 1v};K Qt=1m;1a 112(1C,1I,7X){if(2s 1C.bF!="2p"){1C.bF(1I,7X,1j)}1i{if(2s 1C.ft!="2p"){1C.ft("on"+1I,7X)}1i{8U"Pu sR"}}}1a 10Y(1C,1I,7X){if(2s 1C.mU!="2p"){1C.mU(1I,7X,1j)}1i{if(2s 1C.AT!="2p"){1C.AT("on"+1I,7X)}1i{8U"Pu sR"}}}1a 10D(fn){K 2r=3n.bF||3n.ft?3n:2N.bF?2N:2N.1N||1c;if(2r){if(2r.bF){2r.bF("A2",fn,1j)}1i{if(2r.ft){2r.ft("iB",fn)}}}1i{if(2s 3n.iB=="1a"){K 8J=3n.iB;3n.iB=1a(){8J();fn()}}1i{3n.iB=fn}}}K sV=[];K Aa=1j;1a 10A(fn){if(!Aa){sV.1H(fn)}1i{fn()}}1a PG(){Aa=1m;1o(K i=0;i<sV.1e;i++){sV[i]()}};K Pr=0;if(!3D.51){3D.2V.51=1a(1v){1o(K i=0;i<J.1e;i++){if(J[i]==1v){1b i}}1b-1}}42={uV:1a(){1b++Pr},3u:1a(1v){if(1v==2p||1v==1c){1b""}1b 1v.3u()}};42.ni=1a(4k,aq){K p,v;1o(p in 4k){if(2s 4k[p]==="1a"){aq[p]=4k[p]}1i{v=4k[p];aq[p]=v}}1b aq};42.ND=1a(4k,aq){K p,v;1o(p in 4k){if(aq[p]===2p){bn}if(2s 4k[p]==="1a"){aq[p]=4k[p]}1i{v=4k[p];aq[p]=v}}1b aq};42.E5=1a($1f,3K){if($1f.1e&&!1M(3K)){$1f.1l("5N-3K",3K.3l(/&2x;/g," ").3l(/&yx;/g,"&"))}};42.Pz=1a(4k,aq){K p,v;1o(p in 4k){if(2s 4k[p]==="1a"){aq[p]=4k[p]}1i{if(4k.7K(p)){v=4k[p];if(v&&"1C"===2s v){aq[p]=42.Py(v)}1i{aq[p]=v}}}}1b aq};42.Py=1a(o){if(!o||"1C"!==2s o){1b o}K c=o dc 3D?[]:{};1b 42.Pz(o,c)};42.10C=1a(el,1N){K 1J={1Z:el.4I,1k:el.kl,1L:el.4T,1s:el.gj};1J.7w=1J.1k-1J.1Z;1J.4p=1J.1s-1J.1L;if(1N){1J=42.zT(1J,1N)}1b 1J};42.h0=1a(el,1N){K r=el.ol();K 1J={1Z:r.1Z,7w:r.7w,1L:r.1L,4p:r.4p};if(!r.1k){1J.1k=r.7w-r.1Z}1i{1J.1k=r.1k}if(!r.1s){1J.1s=r.4p-r.1L}1i{1J.1s=r.1s}if(1N){1J=42.zT(1J,1N)}1b 1J};42.zT=1a(r,p){1b{1Z:r.1Z-p.1Z,1L:r.1L-p.1L,7w:r.7w-p.1Z,4p:r.4p-p.1L,1s:r.1s,1k:r.1k}};42.10M=1a(3X){K 47=0;$(3X).2e(1a(){47=3o.47(47,$(J).1s())}).1s(47)};42.10N=1a(3X){K 47=0;$(3X).2e(1a(){47=3o.47(47,$(J).1k())}).1k(47)};42.10K=1a(1v){if(1v){if(2s 1v=="4i"){if(1v!=""){1b 1v}}}1b""};42.af=1a(mT,1v){if(1v){if(2s 1v=="4i"){if(1v!=""){mT.1H(1v)}}}};2A.fn.cE=1a(1n){K g7=J.1l("1z");g7=1M(g7)?"":g7.3N();if(1n===2p){if(g7=="8f"){1b J[0].3T}1i{if(g7=="8M"){if(J[0].3T){1b J.1l("1n")}1i{1b 1c}}}1b J.2c()}if(g7=="8f"){if(1n==1m&&!J.1l("3T")){J.1l("3T","3T")}if(1n!=1m&&J.1l("3T")){J.l8("3T")}if(1n==1m&&!J.5D("3T")){J.5D("3T",1m)}if(1n!=1m&&J.5D("3T")){J.5D("3T",1j)}1b}1i{if(g7=="8M"){K Pg=J.1l("1n");if(Pg==1n){J.1l("3T","1m");J[0].3T=1m}1i{J.l8("3T")}1b}1i{K 6v="";if(!1M(J[0])&&!1M(J[0].6v)){6v=J[0].6v}if(6v.3N()=="2u"){J.sW(1M(1n)?"0":1n.3u());1b}}}if(1n==1c){1n=""}J.2c(1n)};2A.fn.10H=1a(oa){if(!J[0]){1b{1L:0,1Z:0}}if(J[0]===J[0].rm.3s){1b 2A.2n.10I(J[0])}2A.2n.mf||2A.2n.cz();if(2s oa=="4i"){if(oa!=""){K 1N=J.aT(oa);if(1N.1e){46 1N}}}1i{K 1N=oa}K 49=J[0],eg=49.eg,Po=49,3a=49.rm,gl,fh=3a.8m,3s=3a.3s,kR=3a.kR,pZ=kR.gp(49,1c),1L=49.8V,1Z=49.8H;43((49=49.3r)&&(49!==3s&&49!==fh)){gl=kR.gp(49,1c);1L-=49.4T,1Z-=49.4I;if(49===eg){1L+=49.8V,1Z+=49.8H;if(2A.2n.10J&&!(2A.2n.105&&/^t(Kp|d|h)$/i.96(49.6v))){1L+=5R(gl.Df,10)||0,1Z+=5R(gl.Dd,10)||0}Po=eg,eg=49.eg}if(2A.2n.Zq&&gl.cO!=="5X"){1L+=5R(gl.Df,10)||0,1Z+=5R(gl.Dd,10)||0}pZ=gl;if($.rb(49,1N)>=0){1r}}if(pZ.2K==="iZ"||pZ.2K==="Pl"){1L+=3s.8V,1Z+=3s.8H}if(pZ.2K==="Ab"){1L+=3o.47(fh.4T,3s.4T),1Z+=3o.47(fh.4I,3s.4I)}1b{1L:1L,1Z:1Z}};1a Zr(2P,Ag){if(2t.1e>2){K Ai=[];1o(K n=2;n<2t.1e;++n){Ai.1H(2t[n])}1b 1a(){1b Ag.3h(2P,Ai)}}1i{1b 1a(){1b Ag.2v(2P)}}}K yT=1a(a,b){1b $.4n(a,b,a)};K 1M=1a(1v){if(1v===2p){1b 1m}if(1v==1c){1b 1m}if(1v===""){1b 1m}1b 1j};K lc=1a(7o){if(!1M(7o)){1b 7o.3N()}1b 7o};K Zs=1a(7o){if(!1M(7o)){1b 7o.8P()}1b 7o};K 2x=1a(1v){if(1v===2p){1b""}if(1v==1c){1b""}if(1v==""){1b""}1b 1v.3l(/ /g,"&2x;")};1a PT(fR,fQ,fL){1b 1a(a,b){if(!1M(fR)&&a[fR]<b[fR]){1b-1}if(!1M(fR)&&a[fR]>b[fR]){1b 1}if(!1M(fQ)&&a[fQ]<b[fQ]){1b-1}if(!1M(fQ)&&a[fQ]>b[fQ]){1b 1}if(!1M(fL)&&a[fL]<b[fL]){1b-1}if(!1M(fL)&&a[fL]>b[fL]){1b 1}1b 0}}3D.2V.t5=1a(fR,fQ,fL){1b J.h3(PT(fR,fQ,fL))};K gN=1a(a,b){if(1M(a)&&1M(b)){1b 1m}if(1M(a)||1M(b)){1b 1j}1b a.3N()==b.3N()};42.uH=1a(a,b){if(1M(a)&&1M(b)){1b 1m}1b a==b};1a 4n(qa,4A){K F=1a(){};F.2V=4A.2V;qa.2V=1T F;qa.2V.5e=qa;qa.Zp=4A.2V}1a Zm(PZ,bo){1o(K 4f in bo){PZ.2V[4f]=bo[4f]}}5A.2V.6W=1a(6W){K sz="";K 3l=5A.lk;1o(K i=0;i<6W.1e;i++){K sv=6W.bq(i);if(3l[sv]){sz+=3l[sv].2v(J)}1i{sz+=sv}}1b sz};5A.lk={R2:["Zn","Zo","Zx","Zy","PN","Zz","Zw","Zv","Zb","Zc","Z8","ZA"],R4:["ZF","ZH","ZE","ZB","PN","ZC","ZM","ZN","ZO","ZJ","ZI","ZL"],R6:["ZD","ZG","ZP","ZZ","ZY","ZX","101"],R8:["103","102","ZS","ZU","Zg","Zf","Ze"],d:1a(){1b(J.fW()<10?"0":"")+J.fW()},D:1a(){1b 5A.lk.R6[J.ru()]},j:1a(){1b J.fW()},l:1a(){1b 5A.lk.R8[J.ru()]},N:1a(){1b J.ru()+1},S:1a(){1b J.fW()%10==1&&J.fW()!=11?"st":J.fW()%10==2&&J.fW()!=12?"nd":J.fW()%10==3&&J.fW()!=13?"rd":"th"},w:1a(){1b J.ru()},z:1a(){1b"gy qw iW"},W:1a(){1b"gy qw iW"},F:1a(){1b 5A.lk.R4[J.lq()]},m:1a(){1b(J.lq()<9?"0":"")+(J.lq()+1)},M:1a(){1b 5A.lk.R2[J.lq()]},n:1a(){1b J.lq()+1},t:1a(){1b"gy qw iW"},L:1a(){1b J.qz()%4==0&&J.qz()%100!=0||J.qz()%qc==0?"1":"0"},o:1a(){1b"gy iW"},Y:1a(){1b J.qz()},y:1a(){1b(""+J.qz()).7l(2)},a:1a(){1b J.gO()<12?"am":"pm"},A:1a(){1b J.gO()<12?"AM":"PM"},B:1a(){1b"gy qw iW"},g:1a(){1b J.gO()%12||12},G:1a(){1b J.gO()},h:1a(){1b((J.gO()%12||12)<10?"0":"")+(J.gO()%12||12)},H:1a(){1b(J.gO()<10?"0":"")+J.gO()},i:1a(){1b(J.LP()<10?"0":"")+J.LP()},s:1a(){1b(J.LS()<10?"0":"")+J.LS()},e:1a(){1b"gy qw iW"},I:1a(){1b"gy iW"},O:1a(){1b(-J.fa()<0?"-":"+")+(3o.4j(J.fa()/ 60) < 10 ? "0" : "") + 3o.4j(J.fa() /60)+"10F"},P:1a(){1b(-J.fa()<0?"-":"+")+(3o.4j(J.fa()/ 60) < 10 ? "0" : "") + 3o.4j(J.fa() /60)+":"+(3o.4j(J.fa()%60)<10?"0":"")+3o.4j(J.fa()%60)},T:1a(){K m=J.lq();J.LL(0);K 1J=J.10E().3l(/^.+ \\(?([^\\)]+)\\)?$/,"$1");J.LL(m);1b 1J},Z:1a(){1b-J.fa()*60},c:1a(){1b J.6W("Y-m-d")+"T"+J.6W("H:i:sP")},r:1a(){1b J.3u()},U:1a(){1b J.M3()/9q}};2A.fn.4O=1a(1z,1g,fn,ck){if(2s 1z==="1C"){1o(K 1q in 1z){J.2O(1q,1g,1z[1q],fn)}1b J}if(2A.aQ(1g)){ck=fn;fn=1g;1g=2p}fn=ck===2p?fn:2A.1I.LW(fn,ck);1b 1z==="10T"?J.Bg(1z,1g,fn,ck):J.2e(1a(){2A.1I.56(J,1z,fn,1g)})};2A.fn.10e=1a(1z,1g,fn,ck){if(2A.aQ(1g)){if(fn!==2p){ck=fn}fn=1g;1g=2p}2A(J.2L).2O(10d(1z,J.3X),{1g:1g,3X:J.3X,10g:1z},fn,ck);1b J};2A.1I.LW=1a(fn,av,ck){if(av!==2p&&!2A.aQ(av)){ck=av;av=2p}av=av||1a(){1b fn.3h(ck!==2p?ck:J,2t)};av.7u=fn.7u=fn.7u||(av.7u||J.7u++);1b av};3D.2V.3v=1a(2D,to){if(2s 2D=="1C"){2D=J.51(2D)}J.5t(2D,!to||1+to-2D+(!(to<0^2D>=0)&&(to<0||-1)*J.1e));1b J.1e};K Ly={"&":"&yx;","<":"&lt;",">":"&gt;",\'"\':"&108;","\'":"&#39;","/":"&#107;"};Ln=1a(s){if(1M(s)){1b s}1b(s+"").3l(/[&<>"\'\\/]/g,1a(s){1b Ly[s]})};if(!4D.84){4D.84=1a(){K 7K=4D.2V.7K,Lq=!{3u:1c}.rz("3u"),rh=["3u","yD","Lx","7K","Lu","rz","5e"],Lt=rh.1e;1b 1a(1v){if(2s 1v!=="1C"&&(2s 1v!=="1a"||1v===1c)){8U 1T rS("4D.84 yo on 106-1C")}K 1J=[],5D,i;1o(5D in 1v){if(7K.2v(1v,5D)){1J.1H(5D)}}if(Lq){1o(i=0;i<Lt;i++){if(7K.2v(1v,rh[i])){1J.1H(rh[i])}}}1b 1J}}()}(1a($){$.2e(["5i","3S"],1a(i,ev){K el=$.fn[ev];$.fn[ev]=1a(){K 1J=el.3h(J,2t);J.1O(ev);1b 1J}})})(2A);(1a(eA){if(2s bZ==="1a"&&bZ.xI){bZ(["eN"],eA)}1i{if(2s iy!=="2p"&&iy.ri){iy.ri=eA(109("eN"))}1i{eA(2A)}}})(1a($){K $eb=$.eb=1a(3e,5b,2X){1b $(3n).eb(3e,5b,2X)};$eb.cc={aA:"xy",5b:0,xE:1m};1a xZ(49){1b!49.8A||$.rb(49.8A.3N(),["dE","#2N","3F","3s"])!==-1}$.fn.eb=1a(3e,5b,2X){if(2s 5b==="1C"){2X=5b;5b=0}if(2s 2X==="1a"){2X={LA:2X}}if(3e==="47"){3e=10b}2X=$.4n({},$eb.cc,2X);5b=5b||2X.5b;K d7=2X.d7&&2X.aA.1e>1;if(d7){5b/=2}2X.2n=rk(2X.2n);2X.e6=rk(2X.e6);1b J.2e(1a(){if(3e===1c){1b}K 5n=xZ(J),49=5n?J.10a||3n:J,$49=$(49),8g=3e,1l={},re;3x(2s 8g){1p"c6":;1p"4i":if(/^([+-]=?)?\\d+(\\.\\d+)?(px|%)?$/.96(8g)){8g=rk(8g);1r}8g=5n?$(8g):$(8g,49);if(!8g.1e){1b};1p"1C":if(8g.is||8g.2l){re=(8g=$(8g)).2n()}}K 2n=$.aQ(2X.2n)&&2X.2n(49,8g)||2X.2n;$.2e(2X.aA.3w(""),1a(i,aA){K oE=aA==="x"?"4U":"10k",3G=oE.3N(),1q="7P"+oE,3H=$49[1q](),47=$eb.47(49,aA);if(re){1l[1q]=re[3G]+(5n?0:3H-$49.2n()[3G]);if(2X.gH){1l[1q]-=5R(8g.2I("gH"+oE),10)||0;1l[1q]-=5R(8g.2I("cI"+oE+"fc"),10)||0}1l[1q]+=2n[3G]||0;if(2X.e6[3G]){1l[1q]+=8g[aA==="x"?"1k":"1s"]()*2X.e6[3G]}}1i{K 2c=8g[3G];1l[1q]=2c.3J&&2c.3J(-1)==="%"?cq(2c)/100*47:2c}if(2X.xE&&/^\\d+$/.96(1l[1q])){1l[1q]=1l[1q]<=0?0:3o.5U(1l[1q],47)}if(!i&&2X.aA.1e>1){if(3H===1l[1q]){1l={}}1i{if(d7){4z(2X.10t);1l={}}}}});4z(2X.LA);1a 4z(1V){K iV=$.4n({},2X,{d7:1m,5b:5b,E2:1V&&1a(){1V.2v(49,8g,2X)}});$49.4z(1l,iV)}})};$eb.47=1a(49,aA){K ro=aA==="x"?"fc":"gu",7P="7P"+ro;if(!xZ(49)){1b 49[7P]-$(49)[ro.3N()]()}K 3M="10x"+ro,3a=49.rm||49.2N,3F=3a.8m,3s=3a.3s;1b 3o.47(3F[7P],3s[7P])-3o.5U(3F[3M],3s[3M])};1a rk(2c){1b $.aQ(2c)||$.LC(2c)?2c:{1L:2c,1Z:2c}}$.LB.M4.4I=$.LB.M4.4T={44:1a(t){1b $(t.49)[t.5D]()},5G:1a(t){K g6=J.44(t);if(t.1w.10n&&(t.xO&&t.xO!==g6)){1b $(t.49).5I()}K 3p=3o.4R(t.6X);if(g6!==3p){$(t.49)[t.5D](3p);t.xO=J.44(t)}}};1b $eb});if(!3D.2V.qN){3D.2V.qN=1a(hG){K 5O=J.1e;if(2s hG!="1a"){8U 1T rS}if(5O==0&&2t.1e==1){8U 1T rS}K i=0;if(2t.1e>=2){K rv=2t[1]}1i{do{if(i in J){rv=J[i++];1r}if(++i>=5O){8U 1T rS}}43(1m)}1o(;i<5O;i++){if(i in J){rv=hG.2v(1c,rv,J[i],i,J)}}1b rv}}if(!3D.aF){3D.aF=1a(4s){1b 4D.2V.3u.2v(4s)==="[1C 3D]"}};QB={};QB.1d={};QB.1d.2U={};QB.1d.29={};if(2s c7=="2p"){c7={ld:1a(){},wO:1a(){}}}K 10o=1m;3Y={9Y:0,im:[],AW:[],lw:"",Bx:{},8a:1c,2d:{gM:[],7r:[]},2H:{bk:[]},cf:1c,3m:1c,cC:1c,bH:{2W:[],xv:0},dC:"",9H:1c,My:[],iO:1c,gV:{},d8:1c,eX:1j,tR:1j,Mg:1j,Mj:1j,fZ:[],i4:1c,9O:1c,Eg:1j,B1:1c,9F:1c,lE:1c,iF:{},7I:1c,7v:1c,MB:1a(){J.lw="";J.Bx={};J.8a=1c;J.lP=1c;J.2d={gM:[],7r:[]};J.2H={bk:[]};J.im=[];J.AW=[];J.bH={2W:[],xv:0};J.7v=1c;J.cC=1c;J.dC="";J.9H=1c;J.My=[];J.d8=1c;J.gV={};J.iF={};J.7I=1c}};hh=1T 6n({dO:{},2O:1a(1I,1V,2L){J.dO||(J.dO={});K 4M=J.dO[1I]||(J.dO[1I]=[]);4M.1H({1V:1V,2L:2L,9t:2L||J});1b J},1O:1a(1I){if(!J.dO){1b J}K 2j=3D.2V.3J.2v(2t,1);K 4M=J.dO[1I];K ya=J.dO.6D;if(4M){J.yl(1I,4M,2j)}if(ya){J.yl(1I,ya,2t)}1b J},yl:1a(1I,4M,2j){K ev,i=-1,l=4M.1e,a1=2j[0],a2=2j[1],a3=2j[2];3x(2j.1e){1p 0:43(++i<l){(ev=4M[i]).1V.2v(ev.9t,1I)}1b;1p 1:43(++i<l){(ev=4M[i]).1V.2v(ev.9t,1I,a1)}1b;1p 2:43(++i<l){(ev=4M[i]).1V.2v(ev.9t,1I,a1,a2)}1b;1p 3:43(++i<l){(ev=4M[i]).1V.2v(ev.9t,1I,a1,a2,a3)}1b;5v:43(++i<l){(ev=4M[i]).1V.3h(ev.9t,[1I].3I(2j))}1b}},cz:1a(){}});Mr=1T 6n({bY:hh,2k:{6U:"6U"}});Mq=1T 6n({bY:hh,2k:{6U:"6U"}});MH=1T 6n({bY:hh,2k:{mg:"mg",6U:"6U"}});MF=1T 6n({bY:hh,2k:{6U:"6U"}});ME=1T 6n({bY:hh,2k:{6U:"6U"}});KE=1T 6n({bY:hh,9F:1T Mr,2d:1T Mq,2H:1T MF,7I:1T ME,cU:1T MH,2k:{w6:"w6",6U:"6U",Ei:"Ei",wg:"wg",Eb:"Eb",E4:"E4",vD:"vD",vE:"vE",wb:"wb",xK:"xK"},3Y:3Y,lE:1c,dC:"",9O:{},iO:1c,9H:1c,i4:1c,d8:1c,8a:"",lP:"",tL:"",cf:"",mK:1j,3m:1c,bL:1j,aS:0,bH:[],eX:1j,s0:1j,9Y:0,cz:1a(){J.Mp=$.hJ(J.M8,u4,J);J.Mb=$.hJ(J.MD,9q,J)},tK:1a(1V){K me=J;if(J.aS<0){J.aS=0}if(J.aS>0){6K(1a(){me.tK(1V)},100);1b}1b me.5y(1V)},MD:1a(1V){J.5y(1V,1m)},5y:1a(1V,Mz){if(!QB.1d.2o.s0&&Mz){1b}QB.1d.2o.s0=1j;K me=J;if(J.aS<0){J.aS=0}K d5=J.9Y++;K 58=3n.hC.5d;if(3n.1L&&3n.1L.hC){58=3n.1L.hC.5d}J.3Y.xh=58;J.3Y.9Y=d5;J.3Y.cf=J.cf;J.3Y.3m=J.3m;if(1M(J.3Y.2d)){J.3Y.2d={}}J.3Y.2d.ug={dV:QB.1d.2d.MQ()};QB.1d.5k.nF.2d.jd[d5]={};if(J.3Y.2H!=1c&&(J.3Y.2H.bk!=1c&&J.3Y.2H.bk.1e)){QB.1d.5k.nF.2H.jd[d5]={}}if(J.bH.1e>0){J.3Y.bH.xv=J.bH[J.bH.1e-1].Id}J.1O(J.2k.w6,J.3Y);K 1g=$.hH(J.3Y);me.3Y.MB();J.aS++;J.Mp();$.E3({58:tU+"?3O=Ps",1z:"rV",XH:"fo",XG:"pR/fo",8j:1j,1g:1g,DW:1a(1g){QB.1d.2o.1O(QB.1d.2o.2k.6U,1g);if(1V&&7F(1V)=="1a"){1V(1g)}me.lO(1g)},9s:1a(Pk,Pn,XI){if($(".iS").1e==0){1b}if(!mX){eL(Rm)}},E2:me.PB});me.eX=1j},85:1a(1V){J.3Y.im.1H("85");J.tK(1V)},iJ:1a(1V){J.3Y.im.1H("iJ");J.5y(1V)},n0:1a(1V){J.3Y.im.1H("n0");J.5y(1V)},AH:1a(1V){QB.1d.2o.eX=1m;QB.1d.2o.s0=1m;1b J.Mb(1V)},M8:1a(){J.aS=0;1b},cn:1a(M7,1I,DO,Mn){if(!1M(DO)){M7.1O(1I,DO,Mn)}},lO:1a(1g){if(1g!=1c&&1g!==2p){K me=J;if(1M(J.cf)){J.cf=1g.cf}if(1M(J.3m)){J.3m=1g.3m}if(1g.Y4&&1g.Mg||(1M(1g.cf)||J.cf!=1g.cf||(1M(1g.3m)||J.3m!=1g.3m))){if(1g.Mj){hC.XW()}1i{$.E3({58:3n.hC.5d,XV:1j});J.3m=1c;J.3Y.8a=QB.1d.2o.lP;J.iJ()}1b}J.lE=1g.lE;J.dC=1g.dC;J.9H=1g.9H;J.fZ=1g.fZ;J.9O=1g.9O;J.i4=1g.i4;if(!1M(1g.iF)&&4D.84(1g.iF).1e>0){J.iF=1g.iF}if(!1M(1g.d8)){J.d8=1g.d8}J.cn(J.cU,J.cU.2k.6U,1g.7v);if(!1M(J.cU)&&!J.bL){J.bL=1m;J.cU.1O(J.cU.2k.mg,1m)}J.cn(J,J.2k.wg,1g.8a,1g.9Y);J.cn(J.7I,J.7I.2k.6U,1g.7I,1g.9Y);J.cn(J.2d,J.2d.2k.6U,1g.2d,1g.9Y);J.cn(J.2H,J.2H.2k.6U,1g.2H,1g.9Y);J.cn(J,J.2k.vD,1g.iO,1g.9Y);J.cn(J.9F,J.9F.2k.6U,1g.9F,1g.9Y);J.cn(J,J.2k.wb,1g.gV,1g.9Y);J.cn(J,J.2k.vE,1g.bH,1g.9Y);J.cn(J,J.2k.Ei,1g.cC,1g.9Y);if(1g.Eg!=1c&&1g.Eg){J.1O(J.2k.Eb,1g.8a,1g.9Y)}J.cn(J,J.2k.E4,1g.B1)}J.aS--;J.9F.2k},Rt:1a(7R){7R.6Y=1m;J.3Y.2d.gM.1H(7R)},Rx:1a(7R){7R.87=1m;J.3Y.2d.gM.1H(7R)},Rr:1a(7R){7R.Ks=1m;J.3Y.2d.gM.1H(7R)},O3:1a(7R){J.3Y.2d.gM.1H(7R)},Rw:1a(1Y){1Y.6Y=1m;J.3Y.2d.7r.1H(1Y)},XU:1a(1Y){1Y.87=1m;J.3Y.2d.7r.1H(1Y)},RK:1a(1Y){J.3Y.2d.7r.1H(1Y)},zc:1a(aa){J.3Y.8a=aa},XE:1a(3c){1o(K i=0;i<3c.1e;i++){3c[i].6Y=1m}QB.1d.2o.3Y.2H.bk=QB.1d.2o.3Y.2H.bk.3I(3c)},mh:1a(3c){QB.1d.2o.3Y.2H.bk=QB.1d.2o.3Y.2H.bk.3I(3c)},Xj:1a(3c){1o(K i=0;i<3c.1e;i++){3c[i].87=1m}QB.1d.2o.3Y.2H.bk=QB.1d.2o.3Y.2H.bk.3I(3c)}});QB.1d.2o=1T KE;1R={iA:{CI:0,Cl:1,d9:2,Cj:3,Ol:4,Xi:5,cg:6,hb:7},2i:{3O:-1,kB:0,1U:1,3f:2,b6:3,9o:4,7e:5,dz:6,dJ:7,dw:8,6V:9,qD:10,2e:1a(1V){1o(K i=-1;i<=9;i++){1V(i,J.eh(i))}1o(K i=0;i<QB.1d.2H.iL;i++){1V(10+i,"y9"+(i+1))}},eh:1a(2c){1o(K 1q in J){if(J[1q]==2c){1b 1q}}1b 1c}},8a:{pA:{Dn:0,Kt:1,Xl:2,2e:1a(1V){1o(K i=0;i<=2;i++){1V(i,J.eh(i))}},eh:1a(2c){1o(K 1q in J){if(J[1q]==2c){1b 1q}}1b 1c}},eT:[" ","Xo","Xb","Xh","Xg","Xf","Xp"],uK:{os:"LX",Du:"Xz",2e:1a(1V){1V(J.os,J.eh(J.os));1V(J.Du,J.eh(J.Du))},eh:1a(2c){if(2c==J.os){1b QB.1d.29.4J.57.P1.3l("&2x;"," ")}1b QB.1d.29.4J.57.P0.3l("&2x;"," ")}}},80:{da:0,dY:1,d3:1a(1v){K Xy=1v;if(1v==1R.80.da){1v=1R.80.dY}1i{1v=1R.80.da}1b 1v}},4D:1a(2Z){J.iC={};J.o6="";J.Dw="";J.1x="";J.b6="";J.1z="";J.KM="";J.Kj=1c;J.id=42.uV();if(2Z){42.ni(2Z,J)}},Xx:1a(2Z){J.1x="XA";J.KM="XD";J.1z="P7";J.3M="4";J.fX="10";J.XC="1";J.XB=1j;if(2Z){42.ni(2Z,J)}},Xs:1a(1v){K 1J=[];if(1v.iC==1R.iA.d9){42.af(1J,1v.Dw);42.af(1J,1v.o6);42.af(1J,1v.1x)}if(1v.iC==1R.iA.hb){K 1N=1v.1N;if(1N){42.af(1J,1N.Dw);42.af(1J,1N.o6);42.af(1J,1N.1x);42.af(1J,1v.1x)}}1b 1J.53(".")},DH:1a(2m,1B){K 1J=[];if(1B){1M(1B.8R)?42.af(1J,1B.45):42.af(1J,1B.8R);42.af(1J,2m.70)}1b 1J.53(".")},Xq:1a(1v){if(1v==1c){1b""}K 1J=[];if(1v.iC==1R.iA.d9){42.af(1J,1v.1x)}if(1v.iC==1R.iA.hb){K 1N=1v.Kj;if(1N){42.af(1J,1N.1x);42.af(1J,1v.1x)}}1b 1J.53(".")},Me:1a(3f,sq,nC,sk,nV){if(3f!=""){1b 3f}K 1J=1R.DH(sq,nC)+" = "+1R.DH(sk,nV);1b 1J},Kh:1a(){J.62=[];J.Ah=1a(){46 J.62;J.62=[]};J.Xu=1a(k1){if(!k1.62){1b}J.Ah();K me=J;1o(K i=0;i<k1.62.1e;i++){J.62.1H(k1.62[i])}}}};Y8=1T 1R.Kh;QB.1d.29.YM=1a(){J.gM=1c;J.7r=1c;J.ug=1c};QB.1d.29.YL=1a(){J.bk=1c};QB.1d.29.yY=1a(){J.eT=1c;J.8R=1c;J.xf=1c;J.63=[];J.9f=1c;J.iN=1j;J.3m=1c;J.87=1j;J.6Y=1j;J.cu=1j;J.kX=1c;J.eZ=1c;J.9c=0;J.6s=1c;J.KK=1c;J.Pm=1c;J.zo=0;J.zn=1c;J.aJ=1c;J.aG=1c};QB.1d.29.YK=1a(){J.8R=1c;J.YN=1c;J.6q=1c;J.ku=1c;J.OZ=0;J.5V=[];J.3m=1c;J.45=1c;J.4D=1c;J.Ov=1m;J.sY=1c;J.qm="";J.YO=1j;J.CI=1c;J.Cl=1c;J.87=1j;J.Ks=1j;J.6Y=1j;J.NV=1c;J.6s=1c;J.Om=1c;J.DL=1c;J.CJ={EW:{7S:1m,8n:0,cN:"",dl:""},Fa:{8n:1,7S:1m,cN:"",dl:""},vU:{8n:2,7S:1m,cN:"",dl:""},qg:{t8:1j,8n:3,7S:1m,cN:"",dl:""},CK:1j,eZ:0,D7:1m,Fb:1j};J.mM=[];J.cg=1c;J.X=1c;J.Y=1c;J.Az=1c};QB.1d.29.Z1=1a(){J.nN=2;J.6q="";J.Z0=1c;J.YZ=1c;J.tX=1j;J.z7=1c;J.Z2=1c};QB.1d.29.Np=1a(){J.87=1c;J.6Y=1c;J.4U=1c;J.gz=1c;J.54=1c};QB.1d.29.NA=1a(){J.Z5=0;J.4P=0;J.dh=1c;J.Z4=1c;J.9N=1c;J.uf=1c};QB.1d.29.Z3=1a(){J.62=1c;J.YU=1c};QB.1d.29.Op=1a(){J.YS=1c;J.9f=1c;J.F5=1c;J.3m=1c;J.eQ=1j;J.Cw=1c;J.70=1c;J.t4=1c;J.YV=1j;J.YY=0;J.pQ=1j;J.On=1j;J.YW=1j;J.YC=0;J.Cx=1c;J.Yi=0};QB.1d.29.MN=1a(){J.6q=1c;J.X=1c;J.Y=1c;J.fc=1c;J.gu=1c;J.MJ=1c};QB.1d.29.n4=1a(){J.jA=[];J.2W=1c;J.qJ=1c;J.Yh=30;J.r4=0;J.cV="";J.jH="";J.Yg=1j;J.oU="";J.NG=1j};QB.1d.29.ML=1a(){J.o4=[];J.MM=1c;J.3m="Yj-Em-Em-Em-Ym";J.Yk=1c;J.4P=0;J.MK=1j};QB.1d.29.EG=1a(){J.qe=1c;J.aj=1c;J.eQ=1c;J.tX=1j};QB.1d.29.gV=1a(){J.cV=1c;J.cC=1c;J.RI=1c;J.2d=1c;J.PH=1c;J.eU=1c;J.lB=1c;J.PX=1c;J.Yb=1c;J.d9=1c;J.2H=1c};QB.1d.29.Ya=1a(){J.2W=[]};QB.1d.29.Lg=1a(){J.dF="Lg";J.6q=1c;J.3m=1c;J.cC=1c};QB.1d.29.Rk=1a(){J.2W=[]};QB.1d.29.Y9=1a(){J.dF=1c;J.45=1c;J.cC=1c;J.C8=1j;J.2W=[];J.3m=1c;J.cV=1c};QB.1d.29.Yc=1a(){J.3m=1c;J.eW=1c;J.OW=1c;J.dV=1j;J.Yn=1j;J.7S=1m;J.6q=1c;J.6n=1c;J.8a=1c;J.Yx=1j;J.uS=1c;J.2W=[]};QB.1d.29.A9=1a(){J.v9=[];J.4P=3;J.9G=0;J.Yw=1c;J.2W=[];J.6L=1c;J.7M=0;J.68=1c;J.7s=1c};QB.1d.29.wB=1a(){J.2W=[];J.6L=1c;J.7M=0;J.68=1c;J.7s=1c;J.4P=0};QB.1d.29.Lw=1a(){J.4P=1;J.2W=[];J.6L=1c;J.7M=0;J.68=1c;J.7s=1c};QB.1d.29.x7=1a(){J.4P=3;J.9G=0;J.2W=[];J.6L=1c;J.7M=0;J.68=1c;J.7s=1c};QB.1d.29.xc=1a(){J.4P=2;J.aL=1c;J.2W=[];J.6L=1c;J.7M=0;J.68=1c;J.7s=1c};QB.1d.29.Yv=1a(){J.45=1c;J.Yy=0;J.YB=1;J.q6=1};QB.1d.29.CJ=1a(){J.EW={7S:1m,8n:0,cN:"",dl:""};J.Fa={8n:1,7S:1m,cN:"",dl:""};J.vU={8n:2,7S:1m,cN:"",dl:""};J.qg={t8:1j,8n:3,7S:1m,cN:"",dl:""};J.CK=1j;J.eZ=0;J.D7=1m;J.Fb=1j};QB.1d.29.4J={Os:{Dg:"Yq&2x;k8",4D:"4D:",8R:"8R:",Ok:"OK",fp:"fp"},Nx:{Dg:"cg&2x;k8",Yp:"4U&2x;4D",Yo:"54&2x;4D",Yr:"cu&2x;9C&2x;Li&2x;4U",Yt:"cu&2x;9C&2x;Li&2x;54",13B:"4U&2x;6L",13A:"54&2x;6L",13z:"13E&2x;9f",Ok:"OK",fp:"fp"},NJ:{Dg:"O2&2x;k8",Lj:"Lj",13s:"13x&2x;13w:",Ok:"OK",fp:"fp"},57:{63:{uw:"uw",9f:"9f",eT:"eT",8R:"8R",eZ:"KQ&2x;4P",kX:"KQ&2x;13O",iN:"iN",13S:"v1&2x;By",yd:"63&2x;1o",vm:"63",KC:"Or..."},BI:"BI",13H:"BI&2x;KR",13G:"13K&2x;iT&2x;KR",13J:"ni&2x;A0&2x;9k",13a:"Oc&2x;A0&2x;j3-mo",139:"lr&2x;138",13d:"lr&2x;13c",137:"lr&2x;up",133:"lr&2x;dX",132:"g0&2x;1h",131:"Oe&2x;dn&2x;1h",5V:"5V",L1:"L1",136:"d9",13n:"Cj",13q:"Ol",13l:"gv",13h:"Rj&2x;2u&2x;13g&2x;13f&2x;to&2x;13j.",13i:"mg&2x;Bx:&2x;{0}&2x;14h,&2x;{1}&2x;14c,&2x;{2}&2x;14e.",k8:"k8",g0:"g0",14b:"g0&2x;lB",13Y:"cu&2x;9C",cu:"cu...",9C:"9C",Oq:"Oq",Ou:"Ou",Ot:"Ot",Of:"Of",13X:"148&2x;9C",147:"143&2x;9C",Ed:"cu&2x;6D&2x;3c&2x;2D&2x;{0}",PK:"O2&2x;is&2x;rQ,&2x;O5&2x;to&2x;be&2x;141",QQ:"13T",qS:"qS...",O1:"O1",NY:"NY",ks:"cC&2x;aP",hb:"hb",DB:"DB",13U:"eU&2x;14d&2x;1B",14f:"eU&2x;Ob&2x;d9&2x;9f",14n:"eU&2x;Oc&2x;Ob&2x;d9&2x;9f",149:"RE",Kv:"Oe&2x;j3-mo",14a:"rT&2x;5q&2x;iT&2x;13V&2x;1x&2x;140&2x;14k&2x;in&2x;lj&2x;5F&2x;j3-mo.",lB:"lB",O8:"O8",OA:"OA",11M:"eU lB",P1:"P3&2x;2Q",P0:"P3&2x;11y",xC:"D0&2x;j3-mo",L9:"D0&2x;3f",Lc:"D0&2x;6V"},11E:"en"};QB.1d.2U.11C={CI:0,Cl:1,4P:2};QB.1d.2U.OZ={d9:0,Cj:1,11Z:2,9T:3,OW:4,11P:5};QB.1d.2U.11O={gv:0,11d:1,11c:2};QB.1d.2U.11f={da:0,dY:1};QB.1d.2U.11h={ji:0,11g:1,11b:2};QB.1d.2U.hm={ji:0,vk:1,vo:2};QB.1d.2U.116={115:1,114:2,mv:3};QB.1d.2U.117={11a:0,119:1,118:2,lv:3,11t:4,5A:5,zO:6,11s:7,11r:8,3m:9,11u:10,P7:11,11x:12,4D:13,11w:14,11v:15,5w:16,Nf:17,11l:18,11k:19,11m:20,11p:21,12K:22,12B:23,12Y:25,12T:26,12O:27};QB.1d.2U.6G={Mk:0,Mo:1,Ml:2,pF:3,Mm:4,M9:5,Ma:6,xl:7,xk:8,RH:9,Mf:10,Mc:11,Mu:12,Md:13,MC:14,MG:15,Ms:16,Mx:17};QB.1d.2U.6k={gv:0,aj:1,gB:2,5A:3,lv:4};QB.1d.2U.12Q={gv:0,5w:1,12d:2,12c:3,5A:4,Nf:5,zO:6,lv:7};QB.1d.2U.ah={9C:0,ve:1,q0:2,ji:3};QB.1d.2U.Cy={ji:0,45:1,sY:2};K 9D=15;QB.1d.2d={5X:1j,1W:1c,6B:1c,62:[],4K:[],r:1c,nH:1j,ua:1j,mv:1j,12e:0,12g:0,w9:1j,vG:1j,wa:1j,vy:1j,AG:1a(7u){1o(K i=0;i<J.62.1e;i++){K 1v=J.62[i];K k1=1v.1g("4v");if(42.uH(7u,k1.Az)){1b 1v}}1b 1c},yV:1a(k0,jY){1b k0.3m==jY.3m||(k0.6Y||jY.6Y)&&k0.6s==jY.6s},yU:1a(k0,jY){1b k0.6q==jY.6q},mk:1a(8L){K 1J=1c;if(1M(8L)){1b 1J}$.2e(J.62,1a(1S,1v){K 1B=1v.1g("1C");if(gN(1B.8R,8L)||(gN(1B.45,8L)||(gN(1B.qm,8L)||gN(1B.ku,8L)))){1J=1v;1b 1j}});1b 1J},12f:1a(kO){if(kO==1c){1b}K 9i=kO.3J();K m5=[];K kM=[];K m0=[];K me=J;1o(K i=J.62.1e-1;i>=0;i--){K 1v=J.62[i];K kL=1v.1g("1C");K e5=1c;1o(K j=9i.1e-1;j>=0;j--){K 8w=9i[j];if(J.yV(kL,8w)){9i.3v(j);e5=8w;1r}}if(e5==1c){1o(K j=9i.1e-1;j>=0;j--){K 8w=9i[j];if(J.yU(kL,8w)){9i.3v(j);e5=8w;1r}}}if(e5!=1c){kM.1H({1P:8w,6b:1v})}1i{m5.1H(1v)}}$.2e(9i,1a(1S,8w){m0.1H(8w)});K d0=1a(1w,6b){K 1v=J.d0(1w,6b);if(6b===2p||6b==1c){1v.4O(QB.1d.6P.2k.na,J.ze,J);1v.4O(QB.1d.6P.2k.n9,J.zd,J);1v.4O(QB.1d.6P.2k.nc,J.zg,J);1v.4O(QB.1d.6P.2k.nf,J.eR,J)}J.3A.8y("n3");1b 1v};K i8=1a(1w,6b,ip){K 1v=J.i8(1w,6b,ip);J.3A.8y("n3");1b 1v};$.2e(kM,1a(1S,1v){i8({1C:1v.1P},1v.6b,1m)});$.2e(m5,1a(1S,1v){J.uh(1v,1m)});$.2e(m0,1a(1S,1v){d0({1C:1v})})},i8:1a(1w,6b,ip){K 2n=6b.2n();K sD={};K sB=1c;if(6b!=1c){K h7=6b.1g("1C");K k4=1w.1C;if(h7&&k4){sD[h7.3m]=k4.3m;sB=h7.3m;if(h7.5V&&k4.5V){$.2e(h7.5V,1a(i,2m){if(h7.5V[i]&&k4.5V[i]){sD[h7.5V[i].3m]=k4.5V[i].3m}})}}}1w.ip=ip;6b.6E("MI",1w);if(sB){$.2e(QB.1d.2d.7r.Nn(sB),1a(i,1Y){1Y.m9(sD)})}7a{6b.2n(2n)}7b(e){}1b 6b},d0:1a(1w,6b){if(6b==1c){K 7y=$("<2E></2E>");if(J.1W!=1c&&J.1W.1e>0){J.1W.2Y(7y)}1i{1w.5X=1j}7y.6E(1w);7y.4O(QB.1d.6P.2k.vi,{1v:7y},J.Nd,J);7y.4O(QB.1d.6P.2k.vu,{1v:7y},J.MP,J);7y.4O(QB.1d.6P.2k.vv,{1v:7y},J.MO,J);if(!1w.2K&&!1w.9r){K 2K=J.MX(7y);7y.8H=2K[0];7y.8V=2K[1];7y.6E("2K",2K)}J.62.1H(7y);1b 7y}1i{6b.6E("85",1w);1b 6b}},uh:1a(1C,kg){1C.6E("5J",1c,kg)},Nd:1a(e,1g){K 1v=e.1g.1v;K N1=1v.1g("gx");J.62.3v(1v);QB.1d.2d.7r.Nl(N1)},MP:1a(e,1g){K 1v=e.1g.1v;J.1W.1O(QB.1d.2d.2k.vN,1v)},MO:1a(e,1g){K 1v=e.1g.1v;J.1W.1O(QB.1d.2d.2k.vL,1v)},NC:1a(3m){K 1v=1c;$.2e(J.62,1a(1S,o){if(o.1g("gx")==3m){1v=o.1g("NX");1b 1j}});1b 1v},Nz:1a(1B,MR){K 1J=1c;if(1B==1c){1b 1J}$.2e(1B.5r,1a(1S,2m){if(2m.1C.3m==MR){1J=2m;1b 1j}});1b 1J},Nw:1a(1B,9j){K 1J=1c;if(1B==1c){1b 1J}$.2e(1B.5r,1a(1S,2m){if(2m.1C.70==9j){1J=2m;1b 1j}});1b 1J},MQ:1a(){K 1J=[];$.2e(J.62,1a(1S,1v){K 1B=1v.1g("1C");if(1B==1c){1b 1m}K l=1T QB.1d.29.MN;K p=1v.2K();if(1B.5V){l.MJ=1B.5V.1e}l.6q=1B.6q;l.X=p.1Z;l.Y=p.1L;l.fc=1v.6E("2Z","1k");if(l.fc=="5T"){l.fc=1c}l.gu=1v.6E("2Z","1s");if(l.gu=="5T"){l.gu=1c}1J.1H(l)});1b 1J},PO:1a(pX){if(pX==1c){1b}if(pX.1e==0){1b}$.2e(J.62,1a(1S,1v){K 1B=1v.1g("1C");if(1B==1c){1b 1m}K 9A=1c;1o(K 1S=0;1S<pX.1e;1S++){K l=pX[1S];if(l.6q==1B.6q){9A=l;1r}}if(9A!=1c){if(9A.X!=0&&(!1M(9A.X)&&(9A.Y!=0&&!1M(9A.Y)))){1v.6E("2K",[9A.X,9A.Y])}if(9A.fc!=0&&!1M(9A.fc)){1v.6E("2Z","1k",9A.fc)}if(9A.gu!=0&&!1M(9A.gu)){1v.6E("2Z","1s",9A.gu)}}})},Nv:1a(1B){if(1B==1c){1b 1c}1b 1B.ey},MX:1a(7y){K 1k=J.1W.1k();if(1k<ep){1k=ti}K bD=[0,1k];K bN=[0,126];K iz=[];K ow=7y.1k();K oh=7y.1s();if(ow==0){ow=ep}if(oh==0){oh=Ej}K w=ow+9D*2;K h=oh+9D*2;J.MW(bD,bN,iz,7y);if(J.nH){1b J.MZ(bD,bN,iz,w,h)}1i{1b J.N0(bD,bN,iz,w,h)}},N0:1a(xs,ys,fU,w,h){1o(K j=0;j<ys.1e;j++){1o(K i=0;i<xs.1e;i++){if(fU[i][j]==0){if(J.Dz(xs,ys,fU,i,j,w,h)){1b[xs[i]+9D,ys[j]+9D]}}}}1b[9D,9D]},MZ:1a(xs,ys,fU,w,h){1o(K j=0;j<ys.1e;j++){1o(K i=xs.1e-1;i>=0;i--){if(fU[i][j]==0){if(J.Dz(xs,ys,fU,i,j,w,h)){if(i+1<xs.1e){1b[xs[i+1]+9D-w,ys[j]+9D]}}}}}1b[9D,9D]},MW:1a(bD,bN,iz,7y){$.2e(J.62,1a(){if(J==7y){1b 1m}K 1v=J[0];bD.1H(1v.8H-9D);bN.1H(1v.8V-9D);K ow=1v.cR;K oh=1v.8z;if(ow==0){ow=ep}if(oh==0){oh=Ej}bD.1H(1v.8H+ow+9D);bN.1H(1v.8V+oh+9D)});bD.h3(1a(a,b){1b a-b});bN.h3(1a(a,b){1b a-b});1o(K i=0;i<bD.1e;i++){K 1G=[];1o(K j=0;j<bN.1e;j++){1G.1H(i==bD.1e-1||j==bN.1e-1?1:0)}iz.1H(1G)}$.2e(J.62,1a(){K 1v=J[0];K MV=1v.8H;K Nk=1v.8V;K ow=1v.cR;K oh=1v.8z;if(ow==0){ow=ep}if(oh==0){oh=Ej}K MU=1v.8H+ow;K NL=1v.8V+oh;K En=0;K Eq=0;1o(K i=0;i<bD.1e;i++){if(bD[i]<=MV){En=i}if(MU<=bD[i]){Eq=i;1r}}K F4=0;K F3=0;1o(K j=0;j<bN.1e;j++){if(bN[j]<=Nk){F4=j}if(NL<=bN[j]){F3=j;1r}}1o(K i=En;i<Eq;i++){1o(K j=F4;j<F3;j++){iz[i][j]=1}}})},5s:1a(){if(J.1W==1c||J.1W.1e==0){1b 1c}K c=J.1W[0];J.6B.1k(1);J.6B.1s(1);J.r.ke(1,1);K w=c.kl-2;K h=c.gj-2;if(w<0){w=0}if(h<0){h=0}J.6B.1k(w);J.6B.1s(h);J.r.ke(w,h)},Dz:1a(xs,ys,fU,sN,sQ,w,h){if(fU[sN][sQ]==1){1b 1j}1o(K j=sQ;j<=ys.1e;j++){if(ys[j]-ys[sQ]>=h){1r}1o(K i=sN;i<xs.1e;i++){if(xs[i]-xs[sN]>=w){1r}if(fU[i][j]==1){1b 1j}}}1b 1m},dm:1a(){if(J.1W==1c||J.1W.1e==0){1b 1c}QB.1d.2d.7r.jV();if(l4===2p){1b}J.ka()},s7:1a(){K 3y=J.q1();if(3y){3y.3y("76")}J.5s()},NT:1a(3O,1h,1w){3x(3O){1p"fw":J.s7();1r;5v:J.1W.1O(QB.1d.2d.2k.vR,{3O:3O,1h:1h})}},q1:1a(){if(QB.1d.5k.dC==""||QB.1d.5k.dC=="128"){1b 1c}K cl="#qb-ui-mo-127-"+QB.1d.5k.dC;K $i6=$(cl);if($i6.1e){if(1M(QB.1d.5k.fl[cl])){K 9d={};9d[" OK "]=1a(){$(J).2g("[1x]").2e(1a(i,2m){K $2m=$(2m);K 9j=$2m.1l("1x");K qu=$2m.cE();if(qu!=1c){QB.1d.5k.9H[9j]=qu}});$(J).3y("5J");QB.1d.5k.PL();QB.1d.2o.5y()};9d[QB.1d.29.4J.NJ.fp]=1a(){$(J).3y("5J")};QB.1d.5k.fl[cl]=$i6.3y({u7:1j,4t:1j,B8:1m,4w:u4,cS:C0,9B:12s,1k:"NB",76:1a(e,ui){K $3y=$(e.3e);1o(K Ec in QB.1d.5k.9H){K NF=QB.1d.5k.9H[Ec];K 5r=$3y.2g("[1x="+Ec+"]");1o(K i=0;i<5r.1e;i++){K $2m=$(5r[i]);$2m.cE(NF)}K NH=$(\'2f[1x^="12r"]\',$i6);NH.2e(1a(){J.2J=QB.1d.5k.9H.12q})}},9d:9d})}}1b QB.1d.5k.fl[cl]},hd:1a(7d){if(7d==1c||7d.1e==0){1b 1c}K 1F={};K 5h;1o(K i=0;i<7d.1e;i++){5h=7d[i];if(5h.45!=1c&&5h.45.7l(0,1)=="-"){1F[5h.dF+i]=5h.45}1i{1F[5h.dF]={1x:5h.45,3C:5h.dF+(5h.C8?" 3T":""),1F:J.hd(5h.2W),1g:5h.3m,1q:5h.dF}}}1b 1F},gb:1a(1Q){K me=J;if(J.EU){1b}if(1M(1Q)||1Q.2W.1e==0){1b}K 1F=J.hd(1Q.2W);$.2G("5M","#qb-ui-1W");$.2G({3X:"#qb-ui-1W",4w:cK,12t:{5b:0},1V:1a(3O,1w){K 1h=1c;7a{1h=1w.$1U.1g().2G.1F[3O]}7b(e){}me.NT(3O,1h,1w)},1F:1F})},PC:1a(1Q){K me=J;if(1M(1Q)||1Q.2W.1e==0){1b}if(J.DE){1b}K 3X="#qb-ui-1W-7T 4c 1K, #qb-ui-1W-7T .1Y-2L";K 1F=J.hd(1Q.2W);$.2G("5M",3X);$.2G({3X:3X,4w:cK,6R:{5b:0},kI:1j,8O:1a($1O,e){K me=$1O.1g("me");if(2s me=="2p"){1b}K 1h=1F["6D-2D"];if(1h){1h.1x=QB.1d.29.4J.57.Ed.3l("{0}","<sb>"+me.4U.1B.4v.6q+"</sb>");if(me.4U.4P==1R.80.da){1h.3C=1h.1q}1i{1h.3C=1h.1q+" 3T"}}1h=1F["6D-to"];if(1h){1h.1x=QB.1d.29.4J.57.Ed.3l("{0}","<sb>"+me.54.1B.4v.6q+"</sb>");if(me.54.4P==1R.80.da){1h.3C=1h.1q}1i{1h.3C=1h.1q+" 3T"}}1b{1F:1F}},1V:1a(3O,1w){K me=J.1g("me");if(me){me.kJ(3O)}},1F:{}})},PF:1a(1Q,NW){K me=J;if(1M(1Q)||1Q.2W.1e==0){1b}if(J.DI){1b}K 3X=".qb-ui-1B";K 1F=J.hd(1Q.2W);K NS=J.hd(NW.2W);$.2G("5M",3X);$.2G({3X:3X,4w:cK,6R:{5b:0},kI:1j,8O:1a($1O,e){K 1B=$1O.1g("me");if(1B&&(1B.4v&&1B.4v.NV)){e.1g.1F=NS}1i{e.1g.1F=1F}1b{}},1V:1a(3O,1w){K me=J.1g("me");if(me){me.kJ(3O)}},1F:1F})},8h:1a(){K me=J;K F0="qb-ui-1W-7T";J.1W=$("#qb-ui-1W");J.nH=J.1W.4L("nH");J.ua=J.1W.4L("ua");J.mv=J.1W.4L("mv");J.w9=J.1W.4L("w9");J.vG=J.1W.4L("vG");J.wa=J.1W.4L("wa");J.vy=J.1W.4L("vy");J.DI=J.1W.4L("DI");J.DE=J.1W.4L("DE");J.EU=J.1W.4L("EU");if(!J.1W.1e){1b 1c}J.5X=1m;J.6B=$("#"+F0);J.r=bR(F0,J.6B.1N().1k(),J.6B.1N().1s());K d1=J.1W.1l("d1");if(!1M(d1)){$.ui.6E.2V.1w.d1=d1}K fk=J.1W.1l("fk");if(!1M(fk)){$.ui.6E.2V.1w.fk=fk}J.1W.3R(1a(e){K jD=26;if(e.8b.id=="qb-ui-1W"||e.8b.6v=="4c"){K ET=$(J).2n();K x=e.77-ET.1Z;K y=e.7B-ET.1L;if(x>=J.nW-jD&&y<jD){me.s7()}}});$("#qb-ui-1W-7T").3R(1a(e){K jD=26;if(e.3e.id=="qb-ui-1W-7T"||e.3e.6v=="4c"){K x=!1M(e.NO)?e.NO:e.12w;K y=!1M(e.NQ)?e.NQ:e.12u;if(x>=J.nW-jD&&y<jD){me.s7()}}});J.1W.dq({uG:"qb-ui-1W-6Q",yi:".qb-ui-1W-dq",e0:"9p",yg:1a(e,ui){if(ui.4B.4L("qb-ui-4e-2m-4B")){K 1C=ui.4B.1g("1C");K hF=ui.4B.1g("hF");K ec=42.h0(ui.4B[0],42.h0(J));$(J).1O(QB.1d.2d.2k.vK,{1B:hF,2m:1C,9r:[ec.1Z,ec.1L]})}1i{K Kk=$(J);K 1C=ui.4B.1g("1C");K ec=42.h0(ui.4B[0],42.h0(J));if(ec.1Z<0){ec.1Z=0}if(ec.1L<0){ec.1L=0}K uU={1C:1C,9r:[ec.1Z,ec.1L]};$(J).1O(QB.1d.2d.2k.vM,uU)}}});J.ka=$.CF(J.5s,9q,J);J.gX=$.CF(J.dm,5,J);J.NE=$.hJ(J.dm,nk,J);J.1W.7P(1a(){me.gX()});J.1W.5s(1a(e,ui){me.gX()});J.ka();$(3n).5s(1a(){me.ka()});1b J},ka:1a(){},gX:1a(){},NE:1a(){}};QB.1d.2d.2k={vM:"vM",Ax:"Ax",vN:"vN",vL:"vL",Nr:"Nr",vK:"vK",vR:"vR"};QB.1d.2d.7r={4K:[],nv:1a(1P){K 1Y=1T QB.1d.2d.cg(1P);QB.1d.2d.7r.1H(1Y);1b 1Y},u0:1a(1Y,1P){1Y.1P(1P)},jV:1a(){if(!QB.1d.2d.5X){1b 1c}$.2e(J.4K,1a(1S,1Y){1Y.jV()})},1H:1a(1v){J.4K.1H(1v)},12k:1a(1Y){1o(K i=0;i<J.4K.1e;i++){if(J.4K[i].1Y==1Y){1b J.4K[i]}}1b 1c},12j:1a(4K){if(4K==1c){1b 1j}if(4K.1e==0){1b 1j}J.u8();1o(K 1S=0;1S<4K.1e;1S++){K 7D=4K[1S];K 9E=1c;if(7D.4U!=1c&&7D.54!=1c){9E=J.u1(7D.4U.9N,7D.54.9N)}if(9E==1c){J.nv(7D)}1i{9E.nj=1j;J.u0(9E,7D)}}J.u3();QB.1d.2d.dm()},u1:1a(Nt,Nq){1o(K i=J.4K.1e-1;i>=0;i--){K 1Y=J.4K[i];if(1Y.4U&&1Y.54){if(1Y.4U.9N==Nt&&1Y.54.9N==Nq){1b J.4K[i]}}}1b 1c},12i:1a(6B){1o(K i=0;i<J.4K.1e;i++){if(J.4K[i].6B==6B){J.jz(i);1r}}},Nl:1a(7u){1o(K i=J.4K.1e-1;i>=0;i--){K 1Y=J.4K[i];if(1Y.4U!=1c&&1Y.54!=1c){if(1Y.4U.dh==7u||1Y.54.dh==7u){J.jz(i)}}}},3v:1a(1Y){if(1Y===2p){1b}if(1Y==1c){1b}1o(K i=0;i<J.4K.1e;i++){if(J.4K[i]==1Y){J.jz(i);1r}}1Y=1c},12l:1a(){1o(K i=J.4K.1e-1;i>=0;i--){J.jz(i)}},u3:1a(){1o(K i=J.4K.1e-1;i>=0;i--){if(J.4K[i].nj){J.jz(i)}}},jz:1a(1S){K 1Y=J.4K[1S];if(1Y.6B!=1c){J.nD(1Y.6B.bU);J.nD(1Y.6B.bg);J.nD(1Y.6B.2S);J.nD(1Y.6B.4g);46 1Y.6B}46 1Y;J.4K.5t(1S,1)},Nn:1a(7u){K 1J=[];1o(K i=J.4K.1e-1;i>=0;i--){K 1Y=J.4K[i];if(1Y.4U!=1c&&1Y.54!=1c){if(1Y.4U.dh==7u||1Y.54.dh==7u){1J.1H(1Y)}}}1b 1J},12o:1a(4K){if(4K==1c){1b 1j}if(4K.1e==0){1b 1j}J.u8();1o(K 1S=0;1S<4K.1e;1S++){K 7D=4K[1S];K 9E=1c;if(7D.4U!=1c&&7D.54!=1c){9E=J.u1(7D.4U.9N,7D.54.9N)}if(9E==1c){J.nv(7D)}1i{9E.nj=1j;J.u0(9E,7D)}}J.u3()},u8:1a(){1o(K i=J.4K.1e-1;i>=0;i--){J.4K[i].nj=1m}},nD:1a(1v){if(1v){if(1v.3v){1v.3v();1v=1c}}}};QB.1d.2d.CN=1a(1P){J.2m=1c;J.1B=1c;J.1P=1a(2c){if(2c===2p){K 1P=1T QB.1d.29.NA;42.ND(J,1P);1b 1P}1i{J.1B=1c;J.2m=1c;42.ni(2c,J);J.Da()}};J.Da=1a(){if(1M(J.1B)){J.1B=QB.1d.2d.NC(J.dh)}if(1M(J.2m)){J.2m=QB.1d.2d.Nz(J.1B,J.9N);if(J.2m==1c){J.2m=QB.1d.2d.Nw(J.1B,J.uf)}if(J.2m==1c){J.2m={};J.2m.1f=QB.1d.2d.Nv(J.1B)}}};J.m9=1a(gF){if(gF[J.dh]){J.1B=1c;J.dh=gF[J.dh]}if(gF[J.9N]){J.2m=1c;J.9N=gF[J.9N]}J.Da()};if(1P!=1c){J.1P(1P)}};QB.1d.2d.cg=1a(1P){if(!QB.1d.2d.5X){1b 1c}K me=J;J.gz="";J.87=1j;J.6Y=1P.6Y==1m;J.4U=1T QB.1d.2d.CN;J.54=1T QB.1d.2d.CN;J.6B=1c;J.id=42.uV();J.Ns=1a(6O){if(me.6B!=1c){1b}me.6B=QB.1d.2d.5X?QB.1d.2d.r.Ny(me,"#12n|2"):1c};J.jV=1a(){if(QB.1d.2d.5X){QB.1d.2d.r.CL(me)}};J.kJ=1a(3O){K aD=1j;3x(3O){1p"6D-2D":me.4U.4P=1R.80.d3(me.4U.4P);aD=1m;1r;1p"6D-to":me.54.4P=1R.80.d3(me.54.4P);aD=1m;1r;1p"46":me.87=1m;aD=1m;1r;1p"fw":K 3y=$("#1Y-fw-3y");K sq=me.4U.2m.1C;K sk=me.54.2m.1C;K nC=me.4U.1B.4v;K nV=me.54.1B.4v;$("2f[1x=2D-1C]",3y).2c(nC.6q);$("2f[1x=to-1C]",3y).2c(nV.6q);$("2f[1x=2D-1C-2u]",3y)[0].3T=me.4U.4P==1R.80.dY;$("2f[1x=to-1C-2u]",3y)[0].3T=me.54.4P==1R.80.dY;$("2f[1x=1C-3f-2f]",3y).2c(1R.Me(me.gz,sq,nC,sk,nV));K 9d={};9d[" OK "]=1a(){me.4U.4P=$("2f[1x=2D-1C-2u]",3y).cE()?1R.80.dY:1R.80.da;me.54.4P=$("2f[1x=to-1C-2u]",3y).cE()?1R.80.dY:1R.80.da;me.gz=$("2f[1x=1C-3f-2f]",3y).2c();K 1f=me.6B.1K[0];$("#qb-ui-1W-7T").1O(QB.1d.2d.cg.2k.o0,me);QB.1d.2d.dm();$(J).3y("5J")};9d[QB.1d.29.4J.Nx.fp]=1a(){$(J).3y("5J")};3y.3y({4t:1j,4w:DG,cS:C0,1k:"NB",B8:1m,9d:9d});1r}if(aD){K 1f=me.6B.1K[0];$("#qb-ui-1W-7T").1O(QB.1d.2d.cg.2k.o0,me)}QB.1d.2d.dm()};J.Nm=1a(){K 1P=1T QB.1d.29.Np;1P.4U=J.4U.1P();1P.54=J.54.1P();1P.87=J.87;1P.6Y=J.6Y;1P.gz=J.gz;1b 1P};J.Nu=1a(1P){J.4U.1P(1P.4U);J.54.1P(1P.54);J.87=1P.87;J.6Y=1P.6Y;J.gz=1P.gz};J.1P=1a(2c){if(2c===2p){1b J.Nm()}1i{J.Nu(2c)}};J.m9=1a(gF){J.4U.m9(gF);J.54.m9(gF)};J.8h=1a(){J.1P(1P);J.Ns();K Bc=$(J.6B.bg.1u);Bc.1g("me",J);Bc.ox()};J.8h()};QB.1d.2d.cg.2k={o0:"o0"};QB.1d.7v=1a(){J.Sx=10;J.4e=1c;J.nh=1j;J.ai=1T 3D;J.1F=1T 3D;J.dN=J.1F;J.4H="";J.hg=6;J.db=24;J.oo=3;J.qT=$("#qb-ui-4e-1F");J.F2=$("#qb-ui-4e-1h-tE-7N");J.pJ=0;J.jk=1j;J.Eh=0;J.ei=1;J.NI=1j;J.wl=1a(){K me=J;K mF=1T 3D;mF.1H("<ul>");J.qT.3F("");if(!1M(J.dN)){K 6l=J.dN.1e;K 2S=3o.5U((J.ei-1)*J.db,6l);K 4g=3o.5U(J.ei*J.db,6l);K mA="";1o(K i=2S;i<4g;i++){K 1h=J.dN[i];K si=i+1==4g?" 7i":"";if(1h!=1c){K BZ=J.Na?\'<br><2B 2C="OQ">\'+1h.sY+"</2B>":"";K NR=QB.1d.29.4J.57.ks+" "+1h.qm;K 1x=1h.qm.3l(/ /g,"&2x;");K 2B=\'<2B 6i="0" 2C="qb-ui-1W-dq 1B" 5N-3K="\'+NR+\'">\'+1x+"</2B>";if(!J.nh){mA=\'<li 2C="qb-ui-1C qb-ui-1C-1B\'+si+\'" id="qb-ui-4e-1h-\'+i+\'">\'+2B+BZ+"</li>"}1i{K mz="";K Bd="";K 2m=1c;K Be="";1o(K j=0;j<1h.5V.1e;j++){2m=1h.5V[j];Be="<2B 2C=\'2m\'>"+2m.t4.3l(/ /g,"&2x;")+"</2B>";K NP=j+1==1h.5V.1e?" 7i":"";Bd=\'<li 2C="qb-ui-1C-2m qb-ui-3A-dq qb-ui-1W-dq NU\'+NP+\'" id="qb-ui-4e-1h-2m-\'+j+\'">\'+Be+"</li>";mz+=Bd}mz=\'<ul 2C="qb-ui-4e 5S">\'+mz+"</ul>";mA=\'<li 2C="qb-ui-1C qb-ui-1C-1B bT NU\'+si+\'" id="qb-ui-4e-1h-\'+i+\'">\'+"<2E 2C=\\"4y qb-ui-1C-4y qb-ui-1C-1B-4y bT-4y\\" RP=\\"$J = $(J); if ($J.4L(\'cG-4y\')) { $J.1N().9b(\'cG\');$J.1N().9b(\'bT\'); $J.9b(\'cG-4y\'); $J.9b(\'bT-4y\'); $(\'~ul\', $(J)).3S(); } 1i {$J.1N().9b(\'cG\');$J.1N().9b(\'bT\'); $J.9b(\'cG-4y\'); $J.9b(\'bT-4y\'); $(\'~ul\', $(J)).5i(); }\\"></2E>"+2B+BZ+mz+"</li>"}}1i{mA=\'<li 2C="qb-ui-1C qb-ui-1C-1B\'+si+\'" id="qb-ui-4e-1h-\'+i+\'">\'+\'<2B 2C="1B">\'+QB.1d.29.4J.57.qS+"</2B></li>"}mF.1H(mA)}}mF.1H("</ul>");J.qT.3F(mF.53(""));J.D1();J.N4();$("#qb-ui-4e-1h-6C").Er()};J.NM=1a(1g){K jq=$("#qb-ui-4e-ai");jq.3F("");J.ai=1T 3D;1o(K i=0;i<1g.jA.1e;i++){K 8K=1g.jA[i];K fO=J.MT(i+1,8K);fO.1g("1z",8K.4P);fO.1g("7u",8K.3m);K lA=fO.cE();K C7=1T 3D;K bX=-1;1o(K j=0;j<8K.o4.1e;j++){K 2Z=8K.o4[j];if(bX==-1&&(!1M(lA)&&gN(2Z.qe,lA))){bX=j}if(bX==-1&&2Z.eQ){bX=j}}if(bX==-1){bX=0}1o(K j=0;j<8K.o4.1e;j++){K 2Z=8K.o4[j];K 2J="";if(2Z.tX==1m){2J=" 2J"}K 1U="";if(bX==j){1U=" 1U"}C7.1H(\'<2Z 1n="\'+2Z.qe+\'"\'+2J+1U+">"+2Z.aj+"</2Z>")}fO.3F(C7.53(""));fO.3q();J.ai.1H(fO)}};J.lO=1a(1g){if(1g==1c||1g===2p){1b}K me=J;J.pJ=1g.qJ;J.NI=1g.NG==1m;J.jk=1j;K pL=1j;if(1g.jH!=""&&(1g.jH!=2p&&1g.jH!=1c)){pL=1m;J.jk=1m}if(1g.r4==0){J.ei=1;J.NM(1g);J.1F=[];if(1g.2W.1e!=1g.qJ){J.jk=1m}}K MS=1g.2W.1e;K NN=1g.r4;K NK=1g.qJ;1o(K k3=NN,qW=0;k3<NK;k3++,qW++){if(qW<MS){J.1F[k3]=1g.2W[qW]}1i{if(J.1F[k3]==2p){J.1F[k3]=1c;J.jk=1m}}}J.Et(pL);J.wl();J.Ne()};J.N6=1a(){if(J.1F.1e<J.pJ){1b 1m}K 2S=3o.47(0,(J.ei-1)*J.db);K 4g=3o.5U(J.pJ,J.ei*J.db);1o(K i=2S;i<4g;i++){if(J.1F[i]==1c){1b 1m}}1b 1j};J.MT=1a(i,8K){K jq=$("#qb-ui-4e-ai");K id="qb-ui-4e-ai-2u-"+i;K 1f=$("#"+id);if(1f.6l){1b 1f}K me=J;K 3F=$(\'<2E 2C="qb-ui-4e-ai-6C TU-\'+i+" 2u-1z-"+8K.4P+\'">                         <2E 2C="qb-ui-4e-ai-3K"></2E>                         <2E 2C="qb-ui-4e-ai-2u">                             <2u id="\'+id+\'"></2u>                         </2E>                     </2E>\');jq.2Y(3F);1f=$("#"+id);1f.1g("1S",i);1f.1g("7u",8K.3m);1f.4O("dT",me.Nb,me);1f.4O("TB",me.Ni,me);1b 1f};J.qI=1a(ED){K MY=$("#qb-ui-4e-ai");K ai=$("2u",MY);K Ez=[];ai.2e(1a(i,s){K 8K=1T QB.1d.29.ML;8K.MM=s.1n;if(!1M(ED)){8K.MK=s.id==ED.id}8K.4P=$(s).1g("1z");8K.3m=$(s).1g("7u");Ez.1H(8K)});1b Ez};J.SJ=1a(2u,1w){K me=J;K 1f=2u[0];1o(K i=0;i<1f.1w.1e;i++){K 2Z=1f.1w[i];K e9=1T QB.1d.29.EG;e9.qe=2Z.1n;e9.aj=2Z.2a;e9.eQ=2Z.1U;1w.1H(e9)}};J.T7=1a(2u,1w){K me=J;K 1f=2u[0];1o(K i=0;i<1f.1w.1e;i++){K 2Z=1f.1w[i];K e9=1T QB.1d.29.EG;e9.qe=2Z.1n;e9.aj=2Z.2a;e9.eQ=2Z.1U;1w.1H(e9)}};J.OP=1a(){J.4H=$("#qb-ui-4e-1h-4H-2f").2c()};J.OL=1a(e){$("#qb-ui-4e-1h-4H-2f").2c("");J.4H="";J.vP(e)};J.Et=1a(pL){K qZ=1c;K r6=!1M(J.4H);if(r6){7a{qZ=1T e7(J.4H,"i")}7b(e){qZ=1c;r6=1j}}if(!r6||pL){J.dN=J.1F;J.Eh=J.pJ}1i{if(!1M(J.1F)){J.dN=1T 3D;1o(K i=0;i<J.1F.1e;i++){K 1h=J.1F[i];if(1h==1c){J.F7();1b}if(!qZ.96(1h.qm)){bn}J.dN.1H(1h)}}}};J.ON=1a(e){if(e.3V==13){e.88();1b 1j}if(J.jk){J.OS(e)}1i{J.vP(e)}};J.OO=1a(e){if(e.3V==13){e.88();1b 1j}};J.vP=1a(e){J.ei=1;J.4H=e.8b.1n;if(!J.jk){J.Et();J.wl()}1i{J.F7()}};J.qL=1a(){J.qT.3F("");J.F2.5i()};J.Ne=1a(){J.F2.3S()};J.F7=1a(){J.qL();K 1g=QB.1d.2o.3Y;1g.7v=1T QB.1d.29.n4;1g.7v.jA=J.qI();1g.7v.cV="44";1g.7v.jH=J.4H;QB.1d.2o.5y()};J.N9=1a(){J.qL();K 1g=QB.1d.2o.3Y;1g.7v=1T QB.1d.29.n4;1g.7v.jA=J.qI();1g.7v.cV="44";1g.7v.jH=J.4H;1g.7v.r4=(J.ei-1)*J.db;QB.1d.2o.5y()};J.Nb=1a(e){K me=J;K 1S=$(e.8b).1g("1S");K 1g=QB.1d.2o.3Y;1g.7v=1T QB.1d.29.n4;1g.7v.jA=J.qI(e.3e);J.Nc(1S);QB.1d.2o.5y()};J.Nc=1a(1S){1o(K i=1S;i<J.ai.1e;i++){K fO=J.ai[i];fO.3F("<2Z>qS...</2Z>")}J.qL()};J.Ni=1a(){};J.D1=1a(){K me=J;$(".qb-ui-1C>2B").7c({2R:0.8,4E:"3s",Nj:"v3",2S:1a(1I,ui){$(ui.4B).2I("gH-1Z",1I.b7-$(1I.3e).2n().1Z-$(ui.4B).1k()/2);$(ui.4B).2I("gH-1L",1I.bi-$(1I.3e).2n().1L-10)},4B:1a(e){K 1f=e.8b.3r;K r0=1f.id.7l("qb-ui-4e-1h-".1e);K 1h=me.dN[r0];K 4B=$("<2E ></2E>");1h.6Y=1m;4B.6E({1C:1h,4w:DG});4B.2y("qb-ui-1W-dq");1b 4B[0]}});$(".qb-ui-1C-2m").7c({2R:0.8,4E:"3s",Nj:"v3",4B:1a(e){K 1f=e.8b;K r0=1f.id.7l("qb-ui-4e-1h-2m-".1e);K Ng=$(1f).aT("li");K Nh=Ng.1l("id").7l("qb-ui-4e-1h-".1e);K qV=me.dN[Nh];if(qV==1c){1b}K 1h=qV.5V[r0];if(1h==1c){1b}K 4B=$(\'<2B 2C="qb-ui-4e-2m-4B qb-ui-3A-dq qb-ui-1W-dq">\'+1h.70.3l(/ /g,"&2x;")+"</2B>");4B.1g("1C",1h);4B.1g("hF",qV);1b 4B[0]}});$(".4y",J.4e).3R(1a(e){})};J.N4=1a(){K me=J;K 6l=3o.j8(J.Eh/J.db);K 1f=$("#qb-ui-4e-1h-SY-6C");if(6l<=1){1f.3F("");1b}if(me.N5==6l){me.DR=$("#oS").4I()}1i{me.N5=6l;me.DR=0}1f.r2({6l:6l,2S:J.ei,4u:me.hg,cI:1j,jO:"#SZ",jr:"3j",jw:"#Tb",ly:"3j",y5:1m,wm:"N2",p0:1a(Af){me.ei=6p(Af);me.N3();me.wl()}});$("#oS").4I(me.DR)};J.N3=1a(){if(!J.N6()){1b}J.N9()};J.Qr=1a(){K me=J;K 1f=$(".qb-ui-4e");J.nh=1f.4L("nh");J.Na=1f.4L("T6");if(1f.1l("N7")!=""){J.db=1f.1l("N7")}if(J.db<=0||J.db==""){J.db=24}if(1f.1l("N8")!=""){J.oo=1f.1l("N8")}if(J.oo<=0||J.oo==""){J.oo=3}K DN=1f.1l("hg");if(DN!=""){7a{K hg=6p(DN);if(hg>0){J.hg=hg}}7b(e){}}$("#qb-ui-4e-1h-4H-2f").4O("zE",me.ON,me);$("#qb-ui-4e-1h-4H-2f").4O("8k",me.OO,me);$("#qb-ui-4e-1h-4H-aN").4O("3R",me.OL,me);1a d0(1f){K OM=1f.id.7l("qb-ui-4e-1h-".1e);K 1h=me.dN[OM];me.4e.1O(QB.1d.7v.2k.wv,1h)}$(2N).on("DD","#qb-ui-4e-1F .qb-ui-1C 2B",1a(e){if($(e.8b).4L("2m")){1b 1j}d0(e.8b.3r)});$(2N).on("8k","#qb-ui-4e-1F .qb-ui-1C 2B",1a(e){if(e.3V==13){d0(e.8b.3r)}});J.OP();J.4e=1f;1b 1f};J.OS=$.hJ(J.vP,nk,J);1b J.4e};QB.1d.7v.2k={OT:"OT",wv:"wv"};QB.1d.Cz=1a(2m,69,vI,1w){K me=J;J.iC=1R.iA.hb;J.1C=2m;J.1B=vI;J.1N=69;J.3T=2m.eQ;J.1f=$(\'<tr 6i="-1" />\').2y("qb-ui-1B-2m 94").1g("J",J).1g("1C",2m).1g("1B",vI).1g("gx",2m.3m).1g("1N",69).1g("tB",69.3m);42.E5(J.1f,QB.1d.29.4J.57.hb+" "+2m.70);if(2m.70=="*"){J.1f.2y("qb-ui-1B-2m-jm")}J.wd=$(\'<2f 1z="8f" 1n="1" 6i="-1" \'+(2m.eQ?" 3T":"")+"/>").3R(1a(){me.3T=J.3T;vI.tD([me])});J.1f.8k(1a(e){3x(e.3V){1p 13:;1p 32:me.wd.1O("3R");e.4r()}});J.El=$(\'<2B 2C="qb-ui-1B-2m-3C"></2B>\');if(2m.pQ){J.El.2y("qb-ui-1B-2m-3C-pk")}K pU=1w.EW;K pG=1w.Fa;K EH=1w.Fb;K we=1w.vU;K wc=1w.qg;J.OR=$(\'<2B 2C="qb-ui-1B-2m-2u">\'+pU.cN+"</2B>").2y(QB.1d.2d.vy?"5S":"").2Y(J.wd);J.9j=$(\'<2B 2C="qb-ui-1B-2m-1x">\'+pG.cN+2x(2m.t4)+pG.dl+"</2B>").2y(QB.1d.2d.vG?"5S":"");J.OD=$(\'<2B 2C="qb-ui-1B-2m-1z">\'+(2m.70!="*"&&2m.F5!="1c"?we.cN+2m.F5+1w.vU.dl:"")+"</2B>").2y(QB.1d.2d.wa?"5S":"");J.OE=$(\'<2B 2C="qb-ui-1B-2m-OQ">\'+pU.cN+(wc.t8?2m.Cw:2x(2m.Cx))+1w.qg.dl+"</2B>").2y(QB.1d.2d.w9?"5S":"");K 5Q=[];5Q.1H({3g:J.El,8n:-1,7S:1m});5Q.1H({3g:J.OR,8n:pU.8n,7S:pU.7S});5Q.1H({3g:J.9j,8n:pG.8n,7S:pG.7S});5Q.1H({3g:J.OD,8n:we.8n,7S:we.7S});5Q.1H({3g:J.OE,8n:wc.8n,7S:wc.7S});5Q.t5("8n");K 7Y;if(EH){7Y=me.1f}1i{7Y=$("<td SV />");7Y.4E(me.1f)}1o(K i=0;i<5Q.1e;i++){K 5E=5Q[i];if(EH){7Y.2Y($("<td td"+(i+1)+\'" />\').2Y(5E.3g))}1i{7Y.2Y(5E.3g)}}J.gk=1a(1n){J.3T=1n;J.wd[0].3T=J.3T};J.6N=1a(){K 4Y={x:0,y:0,1k:0,1s:0};K o=J.1f;K EA=h0(QB.1d.2d.1W[0]);K gE=h0(o,EA);K 1N=o;do{if(1N.6v.8P()=="OB"){1N=1N.3r;if(1N){1N=1N.3r}1r}1N=1N.3r}43(1N!=1c);K gG=gE;if(1N!=1c){gG=h0(1N,EA)}if(gE.1L<gG.1L){4Y.y=gG.1L}1i{if(gE.1L>gG.4p-gE.1s/2){4Y.y=gG.4p-gE.1s/2}1i{4Y.y=gE.1L}}4Y.1s=gE.1s;4Y.1k=gG.1k;4Y.x=gG.1Z;1b 4Y}};QB.1d.Cz.2k={OC:"OC"};K BV=20;QB.1d.9F=1a(){J.3g=$("#qb-ui-1W-fG");J.1Q=1c;K iQ=J;K il=J.3g;K jU=0;K nB=0;K ju=0;J.PE=1a(al){if(J.3g.1l("OF")&&J.3g.1l("OF").3N()=="1j"){1b}K $4l=$("#qb-ui-1W-fG-9V");if(!$4l){1b}K $ag=[];1o(K i=0;i<al.2W.1e;i++){K 1h=al.2W[i];K 2a=1h.aj;if(1M(2a)){2a="&2x;"}K $1f=$(\'<2E 2C="3g" id="qb-ui-1W-fG-9V\'+(i+1)+\'">\'+2a+"</2E>").2y(1h.hT);$1f.3z();if(1h.dV){$1f.2y("ui-5g-8X");$1f.1l("6i",-1)}1i{$1f.1l("6i",0);$1f.8k(1a(e){if(e.3V==32||e.3V==13){$(e.3e).1O("3R")}})}$1f.1g("1h",1h);$1f.3R(1a(e){K $1f=$(e.8b);if($1f.1g("OI.gD")){1b}K 1h=$1f.1g("1h");if(1h&&1h.cV){QB.1d.5k.u5(1h.cV)}1i{$("#"+$1f[0].id).2G()}if(1h&&1h.dV){$1f.2y("ui-5g-8X");e.4r();1b 1j}});$1f.6Q(1a(e){K $1f=$(e.8b);K 1h=$1f.1g("1h");if(1h&&1h.dV){$1f.2y("ui-5g-8X");e.4r();1b 1j}});$1f.5c(1a(e){K $1f=$(e.8b);K 1h=$1f.1g("1h");if(1h&&1h.dV){$1f.2y("ui-5g-8X");e.4r();1b 1j}});$1f.ox();J.P6($1f,1h.gV);$ag.1H($1f)}$4l.dn();$il=$(\'<2E id="qb-ui-1W-fG-9V-il">\');$il.4E($4l).2Y($ag)};1a vA(8T,4z){if(8T<0){8T=0}1i{if(8T>ju){8T=ju}}OJ(8T)}1a OJ(8T){if(8T===2p){8T=TH.2K().1Z}BQ=8T;K TJ=BQ===0,TK=BQ==ju,jT=8T/ju,OG=-jT*(jU-nB);il.2I("1Z",OG)}1a vJ(){1b-il.2K().1Z}1a TG(nZ,nY,9z){1b 1a(){OH(nZ,nY,J,9z);J.5c();1b 1j}}1a OH(nZ,nY,aO,9z){aO=$(aO).2y("OU");K 31,nX,C4=1m,Ca=1a(){if(nZ!==0){iQ.CS(nZ*30)}if(nY!==0){iQ.CX(nY*30)}nX=6K(Ca,C4?tT:50);C4=1j};Ca();31=9z?"fB.iQ":"6A.iQ";9z=9z||$("3F");9z.2O(31,1a(){aO.4o("OU");nX&&jQ(nX);nX=1c;9z.8d(31)})}J.BY=1a(7d){if(7d==1c||7d.1e==0){1b 1c}K 1F={};K 5h;1o(K i=0;i<7d.1e;i++){5h=7d[i];K 1q=5h.dF;if(5h.45!=1c&&5h.45.7l(0,1)=="-"){1F[1q]=5h.45}1i{1F[1q]={1x:5h.45,3C:1q+(5h.C8?" 3T":""),1F:J.BY(5h.2W),1g:5h}}}1b 1F};J.P6=1a($1f,1Q){K me=J;if(1M(1Q)||1Q.2W.1e==0){1b}K 1F=J.BY(1Q.2W);K 3X="#"+$1f[0].id;$.2G("5M",3X);$.2G({3X:3X,4w:cK,6R:{5b:0},1F:1F,1V:1a(3O,1w){K 5h=1w.1F[3O].1g;me.v8(3O,5h)}});$.2G.kn.TS=1a(1h,1D,2r){J.on("8k",1a(e){})}};J.v8=1a(1q,1h){K 3O=1c;if(1h!=1c&&2s 1h.cV!="2p"){3O=1h.cV}3O.3m=QB.1d.2o.d8;J.3g.1O(QB.1d.9F.2k.wn,3O)};J.C1=1a(s){if(s==1c){1b s}if(s.1e<=BV){1b s}1b s.7l(0,BV)+"&TW;"};J.P4=1a(1N){K 1F=[];$.2e(1N.2W,1a(1S,1h){if(!1h.7S){1b}if(1h.dV){1b}1F.1H(1h)});1b 1F};J.P5=1a(1N){K fM=1c;$.2e(1N.2W,1a(1S,1h){if(1h.dV){fM=1h}});1b fM};J.Bi=1a($3z){$3z.1l("6i",0);$3z.8k(1a(e){if(e.3V==32||e.3V==13){$(e.3e).1O("3R")}})};J.B9=1a(1h,2J){K me=J;K 3C="ui-3C-qb-"+1h.6n;K $3z=$(\'<2E 2C="9k">\'+J.C1(1h.6q)+"</2E>").1g("Cb",1h.3m).1g("eW",1h.eW).3z({2J:2J,bG:{oz:3C}}).3R(1a(e){me.Bw(e)});if(2J){$3z.2y("ui-5g-8X").2y("ui-5g-6Q")}1i{J.Bi($3z)}1b $3z};J.Pb=1a(1F){K me=J;K $ul=$("<ul/>");$.2e(1F,1a(1S,iw){K 3C="ui-3C-qb-"+iw.6n;K $3z=$(\'<li><a 5d="#"><2B 2C="ui-3C \'+3C+\'"></2B>\'+me.C1(iw.6q)+"</a></li>").1g("Cb",iw.3m).1g("eW",iw.eW);$ul.2Y($3z)});$ul.1Q({2u:1a(e,ui){$ul.3S();me.Bw(e)}});1b $ul};J.Bo=1a(1h,1N){K me=J;K 9V=[];if(1h==1c){1b 9V}K 1F=J.P4(1h);K fM=J.P5(1h);K P8=fM===1c;K $3z=J.B9(1h,P8);9V.1H($3z);if(1F.1e>0){if(fM!=1c){K $B5=$("<2E>&2x;</2E>").3z({2a:1j,bG:{oz:"ui-3C-jt-1-s"}}).3R(1a(e){if(me.1Q!=1c){me.1Q.3S()}me.1Q=$(J).3p().5i().2K({my:"1Z 1L",at:"1Z 4p",of:$(J).TM(".ui-3z")[0]});$(2N).Bg("3R",1a(){me.1Q.3S()});1b 1j});J.Bi($B5);9V.1H($B5);K $ul=J.Pb(1F);9V.1H($ul)}1i{$3z.3z("2Z","bG.B7","ui-3C-jt-1-e");$.2e(1F,1a(1S,iw){9V.1H(me.B9(iw))})}}1i{if(fM!=1c){$3z.3z("2Z","bG.B7","ui-3C-jt-1-e")}}if(fM!=1c){9V=9V.3I(J.Bo(fM,1h))}1b 9V};J.Bw=1a(e){K $1f=$(e.8b);K 9x=$1f.1g("eW");if(!1M(9x)){J.3g.1O(QB.1d.9F.2k.wq,9x)}1b 1j};J.PD=1a(d4){K me=J;K $3g=$("#qb-ui-1W-fG-TO-4l");if(d4!=1c&&d4.2W!=1c){$3g.dn();K $1F=me.Bo(d4);$3g.2Y($1F);K Pc=$("<2E id=\'qb-ui-1W-9k-nT-3z\'>+</2E>").3z();$3g.2Y(Pc);$3g.TQ({1F:"3z, 2f[1z=3z], 2f[1z=TP], 2f[1z=eS], 2f[1z=8f], 2f[1z=8M], :1g(ui-3z)"});$3g.2g("ul").1l("6i",-1);$3g.2g("a").1l("6i",0)}1b $3g};$.4n(J,{Tm:1a(s){s=$.4n({},2X,s);To(s)},P9:1a(9z,Pa,4z){P9(9z,Pa,4z)},eb:1a(8T,kh,4z){vH(8T,4z);vz(kh,4z)},vH:1a(8T,4z){vH(8T,4z)},vz:1a(kh,4z){vz(kh,4z)},Tp:1a(OX,4z){vH(OX*(jU-nB),4z)},Th:1a(OY,4z){vz(OY*(wh-Cq),4z)},CU:1a(nU,nz,4z){iQ.CS(nU,4z);iQ.CX(nz,4z)},CS:1a(nU,4z){K 8T=vJ()+3o[nU<0?"e8":"j8"](nU);K jT=8T/(jU-nB);vA(jT*ju,4z)},CX:1a(nz,4z){K kh=Cp()+3o[nz<0?"e8":"j8"](nz),jT=kh/(wh-Cq);wj(jT*P2,4z)},vA:1a(x,4z){vA(x,4z)},wj:1a(y,4z){wj(y,4z)},4z:1a(9z,5D,1n,OV){K 1y={};1y[5D]=1n;9z.4z(1y,{"5b":2X.Tl,"5W":2X.Tk,"d7":1j,"nm":OV})},Tw:1a(){1b vJ()},TA:1a(){1b Cp()},Tz:1a(){1b jU},Ts:1a(){1b wh},Tr:1a(){1b vJ()/(jU-nB)},Tv:1a(){1b Cp()/(wh-Cq)},RL:1a(){1b RN},S1:1a(){1b RW},RU:1a(){1b il},RQ:1a(4z){wj(P2,4z)},RS:$.wi,5M:1a(){5M()}});1b J};QB.1d.mI=1a(){J.4e=1c;J.nh=1j;J.Cn=1a(mm){if(mm==1c||mm.1e<=0){1b 1c}K Cd=0;K $1f=$("<ul />");1o(K i=0;i<mm.1e;i++){K 1u=mm[i];if(!1u.7S){bn}Cd++;K $li=$("<li />");$li.1g("Cb",1u.3m);$li.1g("eW",1u.eW);$li.3F(\'<2B 2C="\'+1u.6n+(1u.dV?" 8X":"")+\'">\'+1u.6q+"</2B>");$li.2Y(J.Cn(1u.2W));$1f.2Y($li)}if(Cd>0){1b $1f}1b 1c};J.zm=1a(d4){K me=J;K 3g=$("#qb-ui-4e-Ck");if(d4!=1c&&d4.2W!=1c){3g.3F("");3g.2Y(me.Cn([d4]));K 1f=$("#qb-ui-4e-Ck>ul");J.4e=1f.jE({});1f.2g("*").Er();$("#qb-ui-4e-Ck 2B").3R(1a(){K $1f=1c;K 9x=1c;if(J.jq!=1c){$1f=$(J.jq);9x=$1f.1g("eW")}if(!1M(9x)){me.4e.1O(QB.1d.mI.2k.wk,9x)}1b 1j})}1b 3g};J.D1=1a(){K me=J;$(".4y",J.4e).3R(1a(e){})};$("#qb-ui-1W-fG-nT-3z").3z({bG:{B7:"ui-3C-jt-1-s"}});1b J.4e};QB.1d.mI.2k={wk:"wk"};QB.1d.9F.2k={wq:"wq",wn:"wn"};K j5=1c;QB.1d.6P={4v:1c,1w:{S2:"<2T 2C=\'qb-ui-1B-eB-2a-o6-1x\'>{o6}</2T>.<2T 2C=\'qb-ui-1B-eB-2a-1B-1x\'>{1x}</2T>",u7:1m,fe:1j,O7:"",7c:1m,3S:1c,1s:"5T",1k:"5T",6w:5,ae:60,9B:1j,cS:1j,5X:1m,2K:{my:"1Z 1L",at:"1Z+15 1L+15",of:"#qb-ui-1W",nJ:"3j",S3:1a(3G){K Eo=$(J).2I(3G).2n().1L;if(Eo<0){$(J).2I("1L",3G.1L-Eo)}}},4t:1m,5i:1c,S0:1m,6o:"",4w:9q,fk:144,d1:"5T"},RY:{L6:"2S.7c",5m:"5m.7c",L4:"5I.7c",9B:"9B.4t",6w:"6w.4t",cS:"cS.4t",ae:"ae.4t",KW:"2S.4t",5s:"5m.4t",KU:"5I.4t"},7Y:1c,bW:1c,O6:"qb-ui-1B "+"ui-8l "+"ui-8l-cv "+"ui-aU-6D ",c8:1j,kJ:1a(3O){K me=J;if(me.4v!=1c&&me.4v.6Y){1b 1j}3x(3O){1p"gk":me.CD(1m);1r;1p"RZ":me.CD(1j);1r;1p"46":me.5J();1r;1p"RO":me.L2();1r;1p"fw":K 3y=me.q1(me);if(3y!=1c){3y.3y("76")}1r}},O9:1a(){K me=J;K 5K=".eB-3z.3z-1Y";$.2G("5M",5K);K 1F={};K dB=1c;1o(K i=0;i<me.4v.mM.1e;i++){K fs=me.4v.mM[i];if(dB==1c){dB=fs.nN}if(dB!=fs.nN){1F["5u-"+i]="---------";dB=fs.nN}1F[fs.6q]={1x:fs.6q,3C:"Sp-1C-dB-"+fs.nN,1g:fs,aV:fs.tX?"tj":""}}$.2G({3X:5K,4w:cK,6R:{5b:0},1V:1a(3O,1w){K uO=1w.$1U.1g().2G.1F[3O];me.1f.1O(QB.1d.6P.2k.nc,uO.1g)},1F:1F});1b 5K},NZ:1a(3z){K me=J;K 5K=".eB-3z.3z-1Y";if(me.4v==1c){1b}3z.7t(1a(){me.O9();$(5K).2G();K $1Q=$(5K).2G("1f");if($1Q){$1Q.2K({my:"1Z 1L",at:"1Z 4p",of:J})}})},94:".94:5X",Oa:".94:5X:4a",Od:".94:5X:7i",ou:1a(85){K me=J;J.4v=me.1w.1C;J.eX=1j;if(!J.5r){J.5r=[]}K 69=J.4v;if(J.4v!=1c&&!1M(J.4v.6s)){J.6s=J.4v.6s}1i{J.6s=wK()}69.6s=J.6s;$(me.1f).1g("4v",69);$(me.1f).1g("me",J);me.1f.2y(J.O6+me.1w.O7).2I({2K:"6F",4w:me.1w.4w});me.1f.1l("6i",0);if(!85){me.1f.3b(1a(e){me.c8=1j})}1a f3(3b){K 1J=1c;if(3b.4L("qb-ui-1B")){1J=3b}1i{1J=3b.3p()}43(1m){if(1J.1e==0){1r}if(1J.is(me.94)){1b 1J}K 98=1J.2g(me.Oa);if(98.1e){1b 98}1J=1J.3p()}K 1N=3b.1N();if(1N.4L("qb-ui-1B")){1b $()}1b f3(1N)}1a fb(3b){K 1J=1c;if(3b.4L("qb-ui-1B")){1J=3b}1i{1J=3b.3H()}43(1m){if(1J.1e==0){1r}if(1J.is(me.94)){1b 1J}K 98=1J.2g(me.Od);if(98.1e){1b 98}1J=1J.3H()}K 1N=3b.1N();if(1N.4L("qb-ui-1B")){1b $()}1b fb(1N)}if(!85){me.1f.8k(1a(e){3x(e.3V){1p 13:if(me.c8){1b}me.c8=1m;f3(me.1f).3b();e.4r();1r;1p 9:if(!me.c8){1b}K 3b=me.1f.2g(":3b");if(!3b.1e){3b=me.1f}K 1f=1c;if(e.oc){1f=fb(3b)}1i{1f=f3(3b)}if(1f.1e){1f.3b();e.4r();1b 1j}1i{me.c8=1j}}})}J.6y=me.1f;if(me.1w.9r){me.1w.2K.at="1Z+"+me.1w.9r[0]+" 1L+"+me.1w.9r[1];me.2K.2n=me.1w.2K.2n;me.pq(me.2K);me.1w.9r=1c}if(J.k5==1c){J.k5=$(\'<2B 2C="qb-ui-1B-eB-2a"></2B>\')}K 6o=J.Oh();42.E5(me.1f,QB.1d.29.4J.57.ks+" "+6o);J.k5.3F(6o);if(J.ey==1c){J.tQ=[];if(!1M(J.4v)&&!1M(J.4v.DL)){J.k5.2y("So");J.tQ=J.qk("9k","ui-3C-9k-tJ").1l("5N-3K","").1l("5N-3K","Sn to 9k");J.tQ.3R(1a(1I){me.1f.1O(QB.1d.6P.2k.nf,me.4v.DL);1b 1j})}J.mR=J.qk("1Y","ui-3C-1Y-tJ").1l("5N-3K","").1l("5N-3K","St Sz");J.EE=J.qk("fw","ui-3C-fw-tJ").1l("5N-3K",QB.1d.29.4J.57.k8);J.ES=J.qk("5J","ui-3C-5J-tJ").1l("5N-3K","").1l("5N-3K","DB");J.ey=$(\'<2E 2C="qb-ui-1B-eB ui-8l-7q ui-aU-6D ui-4B-SB 6W-1B"></2E>\').2Y(J.tQ).2Y(J.k5).2Y(J.mR).2Y(J.EE).2Y(J.ES).2O("DD",1a(){me.O4()});J.ey.4E(me.1f).2y("qb-ui-1B-2m-6o");J.ey.1g("hS",1j);J.ES.3R(1a(1I){me.5J(1I);1b 1j});J.EE.3R(1a(1I){if(me.4v!=1c&&me.4v.6Y){1b 1j}K 3y=me.q1(me);if(3y!=1c){3y.3y("76")}1b 1j});J.NZ(J.mR)}if(J.4v!=1c&&J.4v.6Y){J.ey.2g(".3z-fw").3S();J.ey.2g(".3z-1Y").3S()}1i{J.ey.2g(".3z-fw").5i();J.ey.2g(".3z-1Y").5i()}if(!QB.1d.5k.tR&&(69!=1c&&(69.mM!=1c&&69.mM.1e>0))){J.mR.5i()}1i{J.mR.3S()}K km=1m;if(85){if(69&&69.5V){if(J.5r.1e==69.5V.1e+1){7a{if(J.5r.1e>1&&69.5V.1e>1){K g8=J.5r[1].1C;K gq=69.5V[1];if(g8.3m==gq.3m){km=1j}1i{km=1m}}}7b(e){km=1m}}1i{km=1m}}}if(km){if(me.bW!=1c){me.bW.3v()}me.bW=$(\'<2E 2C="qb-ui-1B-2m-4l ui-3y-cv ui-8l-cv"></2E>\').7P(1a(){QB.1d.2d.gX()}).1l("6i",-1);me.7Y=me.bW;me.pH=$(\'<1B od="1" oe="0"></1B>\').4E(me.bW);if(69&&69.5V){J.Oo(69,me.pH)}me.bW.4E(me.1f);me.bW.ox()}if(J.4v.6Y){me.bW.2y("u2")}1i{me.bW.4o("u2")}me.hj=me.1f.1s()-me.7Y.1s();me.1w.6w=3o.47(me.1w.6w,me.hj);me.2Z.9B=1j;$(".qb-ui-1B-2m:O0",me.pH).2y("O0");me.1w.7c&&($.fn.7c&&J.Bu());me.1w.4t&&($.fn.4t&&J.Ba());J.qF=1j;me.1w.fe&&($.fn.fe&&me.7Y.fe());me.1w.fe&&($.fn.fe&&me.1f.fe());me.Oy();me.2Z.9B=1j;me.1w.u7&&J.76();J.iC=1R.iA.d9;me.1f.1g("NX",me);me.1f.1g("1C",69);me.1f.1g("gx",69.3m);me.1f.2g("*").Er();me.1f.7t(1a(1I){me.Cg(1j,1I)});J.O4=1a(){if(me.1f.1g("hS")){me.1f.1g("hS",1j);me.hS=1j;me.2Z("1s",J.jW)}1i{me.1f.1g("hS",1m);me.hS=1m;J.jW=J.2Z("1s");me.2Z("1s",16)}QB.1d.2d.dm();1b 1j};K 5r=$(".qb-ui-1B-2m",me.1f).4H(":5L(.qb-ui-1B-2m-jm)");if(!QB.1d.2d.ua&&!QB.1d.2d.mv){5r.7c({7P:1j,4B:1a(1I){K 3e=1I.3e;K tr=1c;if(3e.6v.8P()=="TR"){tr=$(3e).6e()}1i{K 1N=3e;do{if(1N.6v.8P()=="TR"){1r}1N=1N.3r}43(1N!=1c);if(1N){tr=$(1N).6e()}}K 4B=$(\'<1B 2C="qb-ui-1B ui-8l ui-8l-cv qb-ui-7c-4B-2m" oe="0" od="0"></1B>\').2Y(tr);j5=4B;1b 4B},4E:"#qb-ui-1W",2R:0.8,2S:1a(1I,ui){me.1f.1g("C6",1m);K 4B=$(ui.4B);K mP=$(J);ui.4B.1k($(J).1k());QB.1d.2d.7r.3v(l4);l4=1T QB.1d.2d.cg({4U:{2m:{1f:mP},1B:me},54:{2m:{1f:4B}}});QB.1d.2d.7r.1H(l4);J.eX=1j},5I:1a(1I,ui){QB.1d.2d.7r.3v(l4);QB.1d.2d.dm();me.1f.1g("C6",1j);j5=1c},5m:1a(1I,ui){QB.1d.2d.gX()}}).dq({yi:".qb-ui-1B-2m",uG:"qb-ui-1B-2m-tj",e0:"EN",Sf:1m,yg:1a(1I,ui){if(me.4v.6Y){1b 1j}if(!RC(1I.3e,$("#qb-ui-1W").44(0))){1b 1j}K g8=$(ui.7c);K gq=$(J);K BM="";if(g8.1g("1C")&&g8.1g("1C").70){BM=g8.1g("1C").70}K C5="";if(gq.1g("1C")&&gq.1g("1C").70){C5=gq.1g("1C").70}K 1Y=QB.1d.2d.7r.nv({6Y:1m,4U:{dh:g8.1g("tB"),9N:g8.1g("gx"),uf:BM},54:{dh:gq.1g("tB"),9N:gq.1g("gx"),uf:C5}});QB.1d.2d.dm();K 1P=1Y.1P();me.1f.1O(QB.1d.6P.2k.n9,1P);me.1f.1g("C6",1j);me.eX=1j},e6:1a(1I,ui){if(me.4v.6Y){$(ui.4B).2y("u2")}1i{$(ui.4B).4o("u2")}}})}},q1:1a(2L){K cl="#1B-fw-3y";if(1M(QB.1d.5k.fl[cl])){K $i6=$(cl);if($i6.1e){K 9d={};9d[" OK "]=1a(){K 4v=$(J).1g("4v");4v.8R=$("2f[1x=1C-b6]",$(J)).cE();4v.4D=$("2f[1x=1C-1x]",$(J)).cE();$(J).3y("5J");QB.1d.2o.O3(4v);QB.1d.2o.5y()};9d[QB.1d.29.4J.Os.fp]=1a(){$(J).3y("5J")};QB.1d.5k.fl[cl]=$i6.3y({4t:1j,4w:u4,cS:C0,u7:1j,1k:qc,B8:1m,76:1a(e,ui){K 4v=$(J).1g("4v");$("2f[1x=1C-1x]",$(J)).2c(4v.4D);$("2f[1x=1C-1x]").1l("W5",4v.Ov);$("2f[1x=1C-b6]",$(J)).2c(4v.8R)},9d:9d})}}if(!1M(QB.1d.5k.fl[cl])){QB.1d.5k.fl[cl].1g("4v",2L.4v)}1b QB.1d.5k.fl[cl]},Oy:1a(){if(J.1f.1s()>J.1w.fk){J.2Z("1s",J.1w.fk)}if(J.1f.1k()>J.1w.d1){J.2Z("1k",J.1w.d1)}K Oj=40;K cv=J.pH;K Bm=J.1f;K 6o=J.ey;K Oz=J.k5;K Bt=cv.7k();K Oi=Bm.7k();K Ox=6o.7k();K pM=cv.1k();K Ow=Bm.8r();K Bn=6o.8r();K Wa=Oz.1k();if(Bt==0&&pM==0){1b}K cZ=pM>Ow-Bn;if(cZ){pM+=16}K 1k=3o.47(Bn,pM);if(!1M(J.1w.d1)&&J.1w.d1!="5T"){1k=J.1w.d1}K Og=Bt+Ox;K 1s=3o.5U(Oi,J.1w.fk);if(1k>Oj){J.2Z("1k",6p(1k));J.pH.1k("100%")}if(1s>0){J.2Z("1s",1s);J.2Z("9B",Og)}},Oh:1a(){if(!1M(J.4v.6q)){1b J.4v.6q.3l(/ /g,"&2x;")}1i{1b""}},Oo:1a(69,bW){K me=J;K 1w=69.CJ;if(1M(1w)){1w={}}K 5r=[];if(!1w.CK){K jm=1T QB.1d.29.Op;jm.70="*";jm.t4="*";jm.eQ=69.Om;5r.1H(jm)}K pQ=1w.D7?"On":"";3x(1w.eZ){1p QB.1d.2U.Cy.45:69.5V.t5(pQ,"70");1r;1p QB.1d.2U.Cy.sY:69.5V.t5(pQ,1w.qg.t8?"Cw":"Cx");1r}me.5r=[];5r=5r.3I(69.5V);$.2e(5r,1a(1q,2m){K f=1T QB.1d.Cz(2m,69,me,1w);me.5r.1H(f);bW.2Y(f.1f)})},qk:1a(ex,t7){1b $(\'<a 5d="#"></a>\').2y("ui-aU-6D eB-3z 3z-"+ex+" 94").6Q(1a(){$(J).2y("ui-5g-6Q")},1a(){$(J).4o("ui-5g-6Q")}).7t(1a(ev){ev.88()}).2Y($("<2B/>").2y("ui-3C "+t7)).1l("6i",-1)},W0:1a(){if(!J.Ct){J.Ct=$("#qb-ui-3A")}1b J.Ct},6N:1a(){1b{x:J.2n().1Z,y:J.2n().1L,1k:J.1k(),1s:J.1s()}},85:1a(1g){if(!1M(j5)){j5.1O("6A")}K me=J;K 1v=1g.1C;me.1f.1g("gx",1v.3m);$(".qb-ui-1B-2m",me.1f).2e(1a(){K 2m=$(J);2m.1g("tB",1v.3m);K 7u=1c;$.2e(1v.5V,1a(1q,Cs){if(gN(Cs.70,2m.1g("1C").70)){7u=Cs.3m;1b 1j}});2m.1g("gx",7u)});J.1f.1O(QB.1d.6P.2k.EM)},MI:1a(1w){if(!1M(j5)){j5.1O("6A")}J.1w=$.4n(J.1w,1w);K KY=J.1f.1k();K KZ=J.7Y.1s();K L0=J.5r.1e;K Cv=0;if(1w!=1c&&(1w.1C!=1c&&1w.1C.5V!=1c)){Cv=1w.1C.5V.1e+1}K Cu=Cv!=L0;if(Cu){J.1w.1s="5T";J.1w.1k="5T"}K 7P=J.7Y.4T();J.ou(1m);if(!Cu){J.1f.1k(KY);J.7Y.1s(KZ)}J.7Y.4T(7P)},5M:1a(){K me=J;J.1f.1O(QB.1d.6P.2k.vi);me.1f.3F("").3S().8d(".6E").qt("6E").4E("3s").6a().3v()},5J:1a(1I,kg){K me=J;if(!kg){me.1f.1O(QB.1d.6P.2k.vu)}if(1j===me.8v("L7",1I)){1b}me.1f.8d("hY.qb-ui-1B");me.1f.3S()&&me.8v("5J",1I);me.qF=1j;me.5M()},L2:1a(1I,kg){K me=J;if(!kg){me.1f.1O(QB.1d.6P.2k.vv)}J.5J(1I,1m)},kj:1a(){1b J.qF},Cg:1a(eP,1I){K me=J;if(J.1w.4w>$.ui.6E.oT){$.ui.6E.oT=J.1w.4w}K L5={4T:me.1f.1l("4T"),4I:me.1f.1l("4I")};me.1f.2I("z-1S",++$.ui.6E.oT).1l(L5);J.8v("3b",1I)},tD:1a(5r){J.1f.1O(QB.1d.6P.2k.na,{5r:5r})},CD:1a(3T){K me=J;K 5r=J.5r;K f8=[];$.2e(5r,1a(){K 2m=J;if(2m.1C.70!="*"&&J.3T!=3T){J.gk(3T);f8.1H(J)}});me.tD(f8)},lM:1a(9j,3T,uI){K me=J;K 5r=J.5r;K CC=[];$.2e(5r,1a(1S,2m){if(2m.1C.70==9j){$(".qb-ui-1B-2m-2u 2f",2m.1f).2e(1a(){if(J.3T!=3T){J.3T=3T;2m.3T=3T;CC.1H(2m)}})}});if(uI){me.tD(CC)}},76:1a(){if(J.qF){1b}K 1w=J.1w;J.BT();J.pq(1w.2K);J.Cg(1m);J.8v("76");J.qF=1m},Bu:1a(){K me=J;K 3a=$(2N),Cm;1a gR(ui){1b{2K:ui.2K,2n:ui.2n}}me.6y.7c({W4:1j,xx:1j,oi:".ui-3y-cv, .ui-3y-eB-5J",4Z:".qb-ui-1B-eB",8S:"1N",7P:1m,2S:1a(1I,ui){K c=$(J);Cm=me.1w.1s==="5T"?"5T":c.1s();c.1s(c.1s()).2y("ui-3y-L3");if($.ui.f9.5F!=1c&&($.ui.f9.5F.8S!=1c&&$.ui.f9.5F.8S.1e>3)){$.ui.f9.5F.8S[2]=tw;$.ui.f9.5F.8S[3]=tw}me.BS();me.8v("L6",1I,gR(ui))},5m:1a(1I,ui){QB.1d.2d.gX();me.8v("5m",1I,gR(ui))},5I:1a(1I,ui){QB.1d.2d.5s();QB.1d.2d.dm();me.1w.2K.at="1Z+"+(ui.2K.1Z-3a.4I())+" 1L+"+(ui.2K.1L-3a.4T());$(J).4o("ui-3y-L3").1s(Cm);me.1f.1O(QB.1d.6P.2k.vj,me);QB.1d.2o.5y();me.Lh();me.8v("L4",1I,gR(ui))}})},Wm:1a(){K ce,co,e6,o=J.1w;if(o.8S==="1N"){o.8S=J.4B[0].3r}if(o.8S==="2N"||o.8S==="3n"){J.8S=[0-J.2n.iZ.1Z-J.2n.1N.1Z,0-J.2n.iZ.1L-J.2n.1N.1L,$(o.8S==="2N"?2N:3n).1k()-J.KS.1k-J.tx.1Z,($(o.8S==="2N"?2N:3n).1s()||2N.3s.3r.gj)-J.KS.1s-J.tx.1L]}if(!/^(2N|3n|1N)$/.96(o.8S)){ce=$(o.8S)[0];co=$(o.8S).2n();e6=$(ce).2I("cO")!=="5S";J.8S=[co.1Z+(5R($(ce).2I("Dd"),10)||0)+(5R($(ce).2I("Wk"),10)||0)-J.tx.1Z,co.1L+(5R($(ce).2I("Df"),10)||0)+(5R($(ce).2I("Wg"),10)||0)-J.tx.1L,tw,tw]}},Ba:1a(fJ){fJ=fJ===2p?J.1w.4t:fJ;K me=J,1w=me.1w,2K=me.6y.2I("2K"),KT=2s fJ==="4i"?fJ:"n,e,s,w,se,sw,ne,nw";1a gR(ui){1b{KP:ui.KP,hu:ui.hu,2K:ui.2K,3M:ui.3M}}me.6y.4t({oi:".ui-3y-cv",8S:"2N",VY:me.7Y,9B:6p(1w.9B),ae:1w.ae,6w:me.pd(),fJ:KT,2S:1a(1I,ui){$(J).2y("ui-3y-KX");me.BS();me.8v("KW",1I,gR(ui))},5s:1a(1I,ui){me.8v("5s",1I,gR(ui));QB.1d.2d.ka();QB.1d.2d.gX()},5I:1a(1I,ui){$(J).4o("ui-3y-KX");1w.1s=$(J).1s();1w.1k=$(J).1k();me.8v("KU",1I,gR(ui));me.1f.1O(QB.1d.6P.2k.vj,me);QB.1d.2o.5y()}}).2I("2K",2K).2g(".ui-4t-se").2y("ui-3C ui-3C-VC-VB-se")},pd:1a(){K 1w=J.1w;K 1s=J.hj;if(1w.1s==="5T"){if(!cP(1w.6w)){1s=3o.47(1s,1w.6w)}}1i{K h=0;if(!cP(1w.6w)){h=1w.6w}if(!cP(1w.1s)){1s=3o.5U(h,1w.1s)}1s=3o.47(1s,h)}1b 1s},2K:1a(3G){J.pq(3G)},pq:1a(3G){if(!J.1w.5X){1b}if(!$("#qb-ui-1W").is(":5X")){1b}K fA=[],2n=[0,0];if(3G){if(2s 3G==="4i"||2s 3G==="1C"&&"0"in 3G){fA=3G.3w?3G.3w(" "):[3G[0],3G[1]];if(fA.1e===1){fA[1]=fA[0]}$.2e(["1Z","1L"],1a(i,KV){if(+fA[i]===fA[i]){2n[i]=fA[i];fA[i]=KV}});3G={my:"1Z 1L",of:"#qb-ui-1W",at:"1Z+"+2n[0]+" 1L+"+2n[1]}}3G=$.4n({},J.1w.2K,3G)}1i{3G=J.1w.2K}J.1w.2K=3G;if(J.1w.5X&&(J.1w.2K.of==1c||$(J.1w.2K.of).1e>0)){J.6y.5i();3G.of="#qb-ui-1W";J.6y.2K(3G)}},pB:1a(1q,1n){K me=J,6y=me.6y,gd=6y.is(":1g(ui-4t)"),5s=1j;3x(1q){1p"L7":1q="VE";1r;1p"9d":me.VD(1n);5s=1m;1r;1p"VU":me.VT.2a(""+1n);1r;1p"Lk":6y.4o(me.1w.Lk).2y(VX+1n);1r;1p"2J":if(1n){6y.2y("ui-3y-2J")}1i{6y.4o("ui-3y-2J")}1r;1p"7c":if(1n){me.Bu()}1i{6y.7c("5M")}1r;1p"1s":5s=1m;1r;1p"9B":if(gd){6y.4t("2Z","9B",1n)}5s=1m;1r;1p"cS":if(gd){6y.4t("2Z","cS",1n)}5s=1m;1r;1p"6w":if(gd){6y.4t("2Z","6w",1n)}5s=1m;1r;1p"ae":if(gd){6y.4t("2Z","ae",1n)}5s=1m;1r;1p"2K":me.pq(1n);1r;1p"4t":if(gd&&!1n){6y.4t("5M")}if(gd&&2s 1n==="4i"){6y.4t("2Z","fJ",1n)}if(!gd&&1n!==1j){me.Ba(1n)}1r;1p"6o":$(".ui-3y-6o",me.VW).3F(""+(1n||"&#VV;"));1r;1p"1k":5s=1m;1r}$.xL.2V.pB.3h(me,2t);if(5s){me.BT()}},VO:1a(){K 1w=J.1w;J.7Y.2I({1k:"5T",6w:0,1s:0});if(1w.ae>1w.1k){1w.1k=1w.ae}K pw=J.6y.2I({1s:"5T",1k:"5T"}).1s();K 6w=J.pd();J.7Y.2I(1w.1s==="5T"?{6w:6w,1s:$.e4.6w?"5T":6w}:{6w:0,1s:"5T"}).5i();if(J.6y.is(":1g(ui-4t)")){J.6y.4t("2Z","6w",J.pd())}},BT:1a(){K o=J.1w;J.7Y.5i().2I({1k:"5T",6w:0,9B:"3j",1s:0,ae:o.ae});K pw=J.6y.2I({1s:"5T",1k:o.1k}).1s();K hj=0;if(cP(o.6w)){hj=pw}1i{hj=3o.47(o.6w,pw)}if(o.1s==="5T"){J.7Y.2I({6w:hj,1s:"5T"})}1i{J.7Y.1s(3o.47(0,o.1s-pw))}if(J.6y.is(":1g(ui-4t)")){J.6y.4t("2Z","6w",J.pd())}},BS:1a(){J.vt=J.2N.2g("dE").bS(1a(){K dE=$(J);1b $("<2E>").2I({2K:"6F",1k:dE.8r(),1s:dE.7k()}).4E(dE.1N()).2n(dE.2n())[0]})},Lh:1a(){if(J.vt){J.vt.3v();46 J.vt}},VN:1a(1I){if($(1I.3e).hB(".ui-3y").1e){1b 1m}1b!!$(1I.3e).hB(".ui-v2").1e}};(1a($){$.8l("ui.6E",QB.1d.6P);$.4n($.ui.6E,{6c:"1.8.2",Mi:"2K",VM:0,oT:0,6N:1a(){K 1W=$("#qb-ui-1W");1b{x:J.2n().1Z-1W.2n().1Z,y:J.2n().1L-1W.2n().1L,1k:J.1k(),1s:J.1s()}}})})(2A);QB.1d.6P.2k={na:"na",Ll:"Ll",vu:"vu",vv:"vv",vi:"vi",vj:"vj",EM:"EM",n9:"n9",Lo:"Lo",nc:"nc",nf:"nf"};QB.1d.Lp={};QB.1d.Lp.2k={p0:"p0"};QB.1d.lJ=1a(1q,1N){J.3g=1c;J.er=1c;J.8s=1c;J.5Z=1c;J.6x=1q;J.7E=1N;J.bI=1c;J.VR=1a(4b){J.gm=1m;if(J.5Z){J.5Z.cE(4b)}J.c5()};J.1n=1a(4b){if(4b===2p){1b J.bI}J.bI=4b};J.cF=1a(){K cF=J.bI;if(!1M(J.bI)){3x(J.6x){1p 1R.2i.dz:cF=J.bI;1r;1p 1R.2i.9o:cF=1R.8a.pA.eh(J.bI);if(cF=="Dn"){cF=""}1r;1p 1R.2i.7e:K 1n=J.7E.7p(1R.2i.9o);if(1M(1n)||1n==0){cF=""}1r;1p 1R.2i.dw:cF=1R.8a.uK.eh(J.bI);1r}}if(1M(cF)){cF=" "}1b cF};J.3v=1a(){};J.Ew=1a(){K eY=1j;K bJ=1j;if(J.6x==1R.2i.3f){eY=J.7E.aJ&&J.7E.aJ.1e>0;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vk)!=0}1i{if(J.6x>=1R.2i.6V){eY=J.7E.aG&&J.7E.aG.1e>0;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vo)!=0}}if(eY||bJ){J.8s.2y("Lm")}1i{J.8s.4o("Lm")}};J.85=1a(){if(J.er!=1c){J.er[0].jM=Ln(J.cF())}if(J.5Z!=1c){J.5Z.cE(J.bI);J.Ew()}};J.Kn=1a(){if(J.er!=1c){J.er.3S()}if(J.8s!=1c){J.8s.5i()}if(J.5Z!=1c){J.5Z.3b()}};J.Ds=1a(){if(J.er==1c){1b}QB.1d.2H.uM=1m;J.er.5i();if(J.8s!=1c){J.8s.3S()}QB.1d.2H.uM=1j};J.Lf=1a(){K 6M=1c;K me=J;3x(J.6x){1p 1R.2i.kB:6M=$("<2E></2E>");6M.he=1m;6M.2O("3R",1a(e){$(me).1O(QB.1d.lJ.2k.uF,{1q:me.6x,4b:1m,5H:1j})});me.3g.2O("8k",1a(e){if(e.3V==13||e.3V==32){me.5Z.1O("3R")}});1r;1p 1R.2i.3O:6M=$("<2E></2E>");6M.he=1m;1r;1p 1R.2i.1U:6M=$(\'<2f 1z="8f" 1n="1m" />\');6M.1l("6i",-1);6M.he=1m;1r;1p 1R.2i.dJ:6M=$(\'<2f 1z="8f" 1n="1m" />\');6M.1l("6i",-1);6M.he=1m;1r;1p 1R.2i.3f:6M=$("<2u />");1r;1p 1R.2i.dz:K 2u=["<2u>"];if(!1M(QB.1d.5k.9O)&&!1M(QB.1d.5k.9O.La)){K 1U="";$.2e(QB.1d.5k.9O.La,1a(1S,2c){1U=2c==me.bI?\' 1U="1U" \':"";2u.1H(\'<2Z 1n="\'+2c+\'"\'+1U+">"+(2c==1c?"":2c)+"</2Z>")})}2u.1H("</2u>");6M=$(2u.53(""));6M.2O("dT",1a(){me.c5()});1r;1p 1R.2i.9o:K 2u=["<2u>"];1R.8a.pA.2e(1a(1S,2c){2u.1H(\'<2Z 1n="\'+1S+\'">\'+(2c==1c?"":2c)+"</2Z>")});2u.1H("</2u>");6M=$(2u.53(""));6M.2O("dT",1a(){me.c5()});1r;1p 1R.2i.7e:6M=$("<2u />");1r;1p 1R.2i.dw:K 2u=["<2u>"];1R.8a.uK.2e(1a(1S,2c){2u.1H(\'<2Z 1n="\'+1S+\'">\'+(2c==1c?"":2c)+"</2Z>")});2u.1H("</2u>");6M=$(2u.53(""));6M.2O("dT",1a(){me.c5()});1r;5v:6M=$(\'<2f 1z="2a" 1n="" />\');6M.4O("8k",me.Lb,me);1r}6M.Wn(1a(e){me.3g.4o("ui-Dp-3b")});1b 6M};J.Lb=1a(e){if(e.3V==13){e.88();J.c5();1b 1j}};J.Ld=1a(){K me=J;me.$EF=$(\'<3z 2C="L8">\').3z({bG:{oz:"ui-3C-WT"},2a:1j}).1g("me",J).7t(1a(1I){K eY=1j;K bJ=1j;K 72=[];if(me.6x==1R.2i.3f){72=me.7E.aJ;eY=72&&72.1e>0;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vk)!=0}1i{if(me.6x>=1R.2i.6V){72=me.7E.aG;eY=72&&72.1e>0;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vo)!=0}}if(bJ&&!eY){$(me.7E).1O(QB.1d.g5.2k.f0,{5q:me.6x,1n:me.bI,1P:me.7E.1P(),5E:me})}1i{if(1j&&(!bJ&&(eY&&72.1e==1))){QB.1d.5k.eR(1c,72[0].uS)}1i{me.$EF.2G()}}1I.4r();1b 1j}).3R(1a(1I){1I.4r();1b 1j});$.2G({3X:".L8",4w:cK,6R:{5b:0},kI:1j,8O:1a($1O,e){K me=$1O.1g("me");if(2s me=="2p"){1b{1F:{}}}K gg={};K bJ=1j;K 72=[];K 9P="";if(me.6x==1R.2i.3f){72=me.7E.aJ;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vk)!=0;9P=QB.1d.29.4J.57.L9}1i{if(me.6x>=1R.2i.6V){72=me.7E.aG;bJ=(QB.1d.2H.fF&QB.1d.2U.hm.vo)!=0;9P=QB.1d.29.4J.57.Lc}}if(bJ){K 1h={1x:9P,3C:"oY",1g:1c,1q:"oY"};gg[1h.1q]=1h}if(72&&72.1e){1o(K i=0;i<72.1e;i++){K kH=72[i];K 1h={1x:QB.1d.29.4J.57.xC+\' "\'+kH.6q+\'"\',3C:"je-9k",1g:kH.uS,1q:"je-9k-"+i};gg[1h.1q]=1h}}1b{1F:gg}},1V:1a(3O,1w){if(3O.51("je-9k")==0){QB.1d.2o.3Y.d8=1w.1F[3O].1g;if(!me.c5()){QB.1d.5k.eR(1c,1w.1F[3O].1g)}}1i{if(3O=="oY"){$(me.7E).1O(QB.1d.g5.2k.f0,{5q:me.6x,1n:me.bI,1P:me.7E.1P(),5E:me})}}},1F:{}});1b me.$EF};J.E8=1a(){K me=J;if(J.8s==1c){J.8s=$(\'<2E 2C="ui-qb-3A-1G-5E-oY-6C"></2E>\');J.8s.4E(J.3g)}J.5Z=J.Lf(J.6x);if(J.6x==1R.2i.3f||J.6x>=1R.2i.6V){K $3z=J.Ld();J.8s.2Y($3z);K $2B=$(\'<2B 2C="Xa"></2B>\');$2B.2Y(J.5Z);J.8s.2Y($2B);J.Ew()}1i{J.8s.2Y(J.5Z)}J.5Z.1l("5N-3K",QB.1d.2H.8N[J.6x]);if(!J.5Z.he){J.8s.3S()}if(J.6x==1R.2i.3f){K ux=J.5Z.EQ({az:"3A-3f",1n:me.bI,h8:1a(e){me.c5()}});K 8x=ux.ER()[0];J.5Z=8x.EO();J.5Z.oV=1m}1i{if(J.6x==1R.2i.7e){K ux=J.5Z.EQ({az:"3A-7e",h8:1a(){me.c5()}});K 8x=ux.ER()[0];J.5Z=8x.EO();J.5Z.oV=1m}}J.5Z.2y("ui-qb-3A-1G-5E-oY-3g");if(!J.5Z.oV){if(J.5Z.he){J.5Z.dT(1a(){me.c5()});J.5Z.oV=1m}1i{J.5Z.5c(1a(){me.c5()});J.5Z.oV=1m}}};J.xz=1a(){if(J.8s!=1c){J.8s.6a().3v();J.8s.3v();J.8s=1c}J.E8()};J.Kr=1a(){K me=J;3x(J.6x){1p 1R.2i.kB:;1p 1R.2i.3O:;1p 1R.2i.1U:;1p 1R.2i.dJ:1b 1c}K $Dm=$("<2E></2E>").2y("ui-qb-3A-1G-5E-Le-6C").2y("ui-qb-3A-1G-5E-Le-3g");$Dm.3R(1a(e){if(hv){1b}if(Q2&&me.6x==1R.2i.b6){QB.1d.5k.vY("X1 Km is lj X0 of lj Qy 6c. KO Ko 44 WZ of X4 mp Ko be Kp to bZ X3 Km in lj WM 6c.");1b 1j}me.uq()});1b $Dm};J.uq=1a(){QB.1d.2H.c8=1m;if(QB.1d.2H.oG!=1c){QB.1d.2H.oG.c5()}if(J.6x==1R.2i.3f||!J.7E.1M()&&!J.7E.Kf()){J.Kn();QB.1d.2H.oG=J}J.3g.2y("ui-Dp-3b")};J.c5=1a(){K aD=1j;K Dv=1m;K 5H=J.1n();K 4b=J.5Z.cE();if(!42.uH(5H,4b)&&!(5H==1c&&(4b==" "||4b==0))){aD=1m;K Do=J.7E.7p(1R.2i.9o);3x(J.6x){1p 1R.2i.7e:if(1M(4b)||4b==0){if(!1M(Do)){J.7E.8i(1R.2i.9o,1R.8a.pA.Dn)}}1i{5H=1M(5H)?Kq:6p(5H);4b=6p(4b);if(cP(4b)){4b=0}if(cP(5H)){5H=Kq}4b+=4b<5H?-0.5:+0.5;if(1M(Do)){J.7E.8i(1R.2i.9o,1R.8a.pA.Kt);J.7E.kq(1R.2i.9o)}Dv=1j}1r}J.1n(4b);if(Dv){J.7E.kq()}J.Ds();$(J).1O(QB.1d.lJ.2k.uF,{1q:J.6x,4b:4b,5H:5H,gm:J.gm});J.gm=1j}1i{J.Ds()}QB.1d.2H.oG=1c;if(!J.5Z.he){J.3g.4o("ui-Dp-3b")}1b aD};J.Ku=1a(1q){K hi="ui-qb-3A-1G-";if(1q>=1R.2i.qD){1b hi+"y9"}1b hi+1R.2i.eh(1q)};J.f3=1a(3b){if(!3b.1e){1b $()}K 1J=3b.3p();if(1J.is(":94")){1b 1J}1J=1J.2g(":94:4a");if(1J.1e){1b 1J}K 1N=3b.1N();1b J.f3(1N)};J.fb=1a(3b){if(!3b.1e){1b $()}K 1J=3b.3H();if(1J.is(":94")){1b 1J}1J=1J.2g(":94:7i");if(1J.1e){1b 1J}K 1N=3b.1N();1b J.fb(1N)};J.8h=1a(1q,1N){K me=J;J.3g=$(\'<td 2C="ui-8l-cv ui-qb-3A-1G-5E \'+J.Ku(J.6x)+\'" />\');J.3g.1l("6i",0);K uR=J.6x;if(uR>1R.2i.6V){uR=1R.2i.6V}J.3g.1l("5N-3K",QB.1d.2H.8N[uR]);J.er=J.Kr();if(J.er!=1c){J.er.4E(J.3g)}J.E8();J.3g.Wy(1a(e){if(QB.1d.2H!=1c&&QB.1d.2H.2J){1b}if(QB.1d.2H.uM){1b}if(me.3g[0]!=e.3e){1b}me.uq()});J.3g.8k(1a(e){3x(e.3V){1p 9:if(e.oc){me.fb(me.3g).3b();e.4r()}}})};J.8h(1q,1N)};QB.1d.lJ.2k={uF:"Wq",Wp:"Wo",f0:"f0"};QB.1d.g5=1a(1P){J.Wt=1;J.5Q={};J.Ws=42.uV();J.3m=1c;J.3g=1c;J.ov=1j;J.aJ=[];J.aG=[];J.6s=wK();J.Wr=1j;J.1M=1a(){1b 1M(J.5Q[1R.2i.3f].1n())};J.Kf=1a(){K 2c=J.5Q[1R.2i.3f].1n();if(1M(2c)){1b 1j}1b 2c.51(".*")>=0};J.gk=1a(2c){K lA=J.5Q[1R.2i.1U].1n();if(2c===2p){1b lA}1i{if(lA!=2c){J.5Q[1R.2i.1U].1n(2c);J.DQ(1c,{1q:1R.2i.1U,4b:2c});1b 1m}}1b 1j};J.7p=1a(1q){1b J.5Q[1q].1n()};J.RA=1a(){1b!1M(J.7p(1R.2i.dz))||!1M(J.7p(1R.2i.6V))};J.8i=1a(1q,1n,uI){if(1n===2p){1n=1c}K 4b=1n;K 5H=J.5Q[1q].1n();if(42.uH(4b,5H)){1b 1j}3x(1q){1p 1R.2i.9o:J.8i(1R.2i.7e,1c,uI);1r;1p 1R.2i.7e:if(1M(4b)||4b==0){4b=""}1r;5v:}J.5Q[1q].1n(4b);1b 1m};J.DQ=1a(e,1g){K 1q=1g.1q;K 4b=1g.4b;K 5H=1g.5H;$(J).1O(QB.1d.g5.2k.xT,{1q:1q,4b:4b,5H:5H,1G:J,gm:1g.gm});J.lZ()};J.lZ=1a(){K me=J;K uQ=me.1M();1o(K 1q in me.5Q){if(1q==1R.2i.3f){bn}K 5E=me.5Q[1q];5E.3g.1l("6i",uQ?-1:0)}};J.Kd=1a(){K me=J;K 3F=$(\'<tr 2C="ui-qb-3A-1G" />\');1R.2i.2e(1a(1q){K 5E=1T QB.1d.lJ(1q,me);$(5E).4O(QB.1d.lJ.2k.uF,me.DQ,me);5E.3g.4E(3F);me.5Q[1q]=5E});J.lZ();3F.1g("1C",J);3F.1g("me",J);1b 3F};J.3v=1a(){J.ov=1m;J.3g.6a().3v();J.3g.3v();J.3g.3F("")};J.kq=1a(lH){K me=J;1o(K 1q in me.5Q){K 5E=me.5Q[1q];if(lH===2p||lH==1q){5E.85()}}J.lZ()};J.Kz=1a(lH){K me=J;1o(K 1q in me.5Q){K 5E=me.5Q[1q];if(lH===2p||lH==1q){5E.xz()}}J.lZ()};J.Ke=1a(){J.8i(1R.2i.1U,!J.1M());J.8i(1R.2i.dJ,1j);J.8i(1R.2i.dw,1R.8a.uK.os)};J.jc=1a(y6,E1,us){if(42.3u(J.7p(1R.2i.3f)).3N()==42.3u(y6).3N()){if(E1===2p||E1==42.3u(J.7p(1R.2i.dz)).3N()){if(us===2p||us==42.3u(J.7p(1R.2i.b6)).3N()){1b 1m}}}1b 1j};J.1P=1a(1n){if(1n===2p){1b J.Kg()}1i{1b J.uL(1n)}};J.85=1a(1P){K 5C=J.uL(1P);if(5C){J.kq()}1b 5C};J.uL=1a(1P){K 5C=1j;if(1M(1P)){1b 5C}5C=J.8i(1R.2i.3f,1P.9f)||5C;5C=J.8i(1R.2i.dz,1P.eT)||5C;5C=J.8i(1R.2i.b6,1P.8R)||5C;5C=J.8i(1R.2i.dJ,1P.iN)||5C;5C=J.8i(1R.2i.dw,1P.xf)||5C;5C=J.8i(1R.2i.9o,1P.eZ)||5C;5C=J.8i(1R.2i.7e,1P.kX)||5C;1o(K i=0;i<QB.1d.2H.iL+1;i++){5C=J.8i(1R.2i.6V+i,1P.63[i])||5C}if(J.3m!=1P.3m){J.3m=1P.3m;5C=1m}if(!1M(1P.6s)&&J.6s!=1P.6s){J.6s=1P.6s;5C=1m}if(!1M(1P.3m)&&J.6s!=1c){if(!1M(1P.3m)){J.6s=1c}5C=1m}if(J.ov!=1P.87){J.ov=1P.87;5C=1m}if(J.9c!=1P.9c){J.9c=1P.9c;5C=1m}K DX=-1;K DY=-1;if(1P.aJ){DY=1P.aJ.1e}if(J.aJ){DX=J.aJ.1e}if(DX!=DY){5C=1m}J.aJ=1P.aJ;K x8=-1;K wV=-1;if(1P.aG){wV=1P.aG.1e}if(J.aG){x8=J.aG.1e}if(x8!=wV){5C=1m}J.aG=1P.aG;5C=J.8i(1R.2i.1U,1P.cu&&!J.1M())||5C;J.lZ();1b 5C};J.Kg=1a(){K 1P=1T QB.1d.29.yY;1P.cu=J.7p(1R.2i.1U);1P.9f=J.7p(1R.2i.3f);1P.eT=J.7p(1R.2i.dz);1P.8R=J.7p(1R.2i.b6);1P.iN=J.7p(1R.2i.dJ);1P.xf=J.7p(1R.2i.dw);1P.eZ=J.7p(1R.2i.9o);1P.kX=J.7p(1R.2i.7e);1P.63[0]=J.7p(1R.2i.6V);1o(K i=0;i<QB.1d.2H.iL;i++){1P.63[1+i]=J.7p(1R.2i.qD+i)}1P.3m=J.3m;1P.87=J.ov;1P.6s=J.6s;1P.9c=J.3g==1c?0:J.3g.1S();1b 1P};J.8h=1a(1P){J.3g=J.Kd();J.3g.ox();J.Ke();J.uL(1P);J.kq()};J.8h(1P)};QB.1d.g5.2k={xT:"WH",f0:"f0"};QB.1d.2H={3c:[],iL:2,uJ:1j,WK:1c,qh:1c,c8:1j,kr:0,WJ:[],2J:1j,uM:1j,fF:0,uo:1j,yh:1j,f3:1a(3b){if(!3b.1e){1b $()}K 1J=3b.3p();if(1J.is(":94")){1b 1J}1J=1J.2g(":94:4a");if(1J.1e){1b 1J}K 1N=3b.1N();1b J.f3(1N)},z6:1a(){J.kr++},z0:1a(){J.kr--;if(J.kr==0){J.fY();J.j4()}},fb:1a(3b){if(!3b.1e){1b $()}K 1J=3b.3H();if(1J.is(":94")){1b 1J}1J=1J.2g(":94:7i");if(1J.1e){1b 1J}K 1N=3b.1N();1b J.fb(1N)},ou:1a(){K me=J;QB.1d.2H.fF=J.1f.1l("fF");QB.1d.2H.uo=J.1f.1l("uo");K x=J.1f.1l("iL");if(x!=1c&&(x!=""&&!cP(x))){QB.1d.2H.iL=6p(x)}if(J.1f.1l("uJ")=="WC"){QB.1d.2H.uJ=1m}J.1f.2y("ui-8l").2y("ui-qb-3A");J.1f.dq({uG:"qb-ui-3A-6Q",yi:".qb-ui-3A-dq",e0:"9p",yg:1a(e,ui){if(ui.4B.4L("qb-ui-4e-2m-4B")){K 1C=ui.4B.1g("1C");K hF=ui.4B.1g("hF");$(J).1O(QB.1d.2H.2k.vC,{1B:hF,2m:1C})}1i{K Kk=$(J);K 1C=ui.4B.1g("1C");K uU={1C:1C};$(J).1O(QB.1d.2H.2k.vB,uU)}}});J.1B=$(\'<1B od="0" oe="0" cI="0" />\').2y("ui-8l-cv").2y("uT-Kl").4E(J.1f);J.KA().4E(J.1B);J.kS=$("<67/>").4E(J.1B);K me=J;J.iY();J.fY();me.1f.3b(1a(e){QB.1d.2H.c8=1j});me.1f.1l("6i",0);me.1f.8k(1a(e){3x(e.3V){1p 13:if(QB.1d.2H.c8){1b}QB.1d.2H.c8=1m;me.1f.2g("[6i]:5X:4a").3b();e.4r();1r;1p 9:if(!QB.1d.2H.c8){if(!e.oc){me.f3(me.1f).3b()}1i{me.fb(me.1f).3b()}e.4r()}}});K hu=0;J.yh=1m;J.1B.1B({a9:1m,yq:!1m,8e:{4t:1m}});J.Ki()},Ki:1a(){K me=J;me.1B.2g("1B").4m({uW:1a(1B,1G){K 1v=$(1G).1g("1C");if(!1v.1M()){me.1f.1O(QB.1d.2H.2k.fC,{1G:1v})}},oj:"ui-qb-3A-1G-3O"})},5M:1a(){J.1f.4o("ui-qb-3A").8d(".8y");J.1B.3v();$.xL.2V.5M.3h(J,2t)},iY:1a(){K xF=1j;$.2e(J.3c,1a(1q,1G){if(1G.1M()){xF=1m;1b 1j}});if(!xF){J.kt(1c)}},gb:1a(1Q){K me=J;if(1M(1Q)||1Q.2W.1e==0){1b}K 3X=".ui-qb-3A-1G";K 1F=QB.1d.2d.hd(1Q.2W);$.2G("5M",3X);$.2G({3X:3X,4w:cK,6R:{5b:0},kI:1j,8O:1a($1O,e){K me=$1O.1g("me");if(2s me=="2p"){1b{1F:1F}}K gg={};K 72=1c;if($(e.3e).aT().4L("ui-qb-3A-1G-3f")){72=me.aJ;K 1G=me;if(1G&&1M(1G.7p(1R.2i.3f))){K 1h={1x:QB.1d.29.4J.57.Kv,3C:"je-9k",1g:1c,1q:"xR-9k"};gg[1h.1q]=1h}}if($(e.3e).aT().4L("ui-qb-3A-1G-6V")){72=me.aG}if(72&&72.1e){1o(K i=0;i<72.1e;i++){K kH=72[i];K 1h={1x:QB.1d.29.4J.57.xC+" "+kH.6q,3C:"je-9k",1g:kH.uS,1q:"je-9k-"+i};gg[1h.1q]=1h}}1b{1F:gg}},1V:1a(3O,1w){K 1G=J.1g("me");me.kJ(3O,1G,1w.1F[3O])},1F:1F})},kJ:1a(3O,1G,uO){K me=J;K el=1G.3g;if(3O.51("je-9k")==0){QB.1d.5k.eR(1c,uO.1g)}3x(3O){1p"xR-9k":1G.8i(1R.2i.3f,"(2u *)",1m);1G.8i(1R.2i.1U,1m,1m);me.1f.1O(QB.1d.2H.2k.fC,{1G:1G});me.iY();1r;1p"dW-up":if(el.3p().1e){el.7h(el.3H());if(!1G.1M()){me.1f.1O(QB.1d.2H.2k.fC,{1G:1G})}}1r;1p"dW-dX":K 3p=el.3p();if(3p.1e&&3p.3p().1e){el.fI(3p);if(!1G.1M()){me.1f.1O(QB.1d.2H.2k.fC,{1G:1G})}}1r;1p"1G-46":if(me.3c.1e>1){me.iu(1G)}1i{if(1G.1M()){1b}1i{me.iu(1G);me.iY()}}me.iY(1G);me.fY();me.1f.1O(QB.1d.2H.2k.fC,{1G:1G,1q:1R.2i.kB,4b:1m,5H:1j});1r;1p"1G-xR":me.kt(1c,el);1r}},j4:1a(){if(!J.yh){1b}if(J.kr!=0){1b}if(J.1B.1B("kU")){J.1B.1B("kU").kT()}},kt:1a(4C,kV,5l,kP){K aD=1j;K 1G=J.KF(4C);if(1G==1c){aD=1m;1G=1T QB.1d.g5(4C);$(1G).4O(QB.1d.g5.2k.xT,{1G:1G},J.KN,J);$(1G).4O(QB.1d.g5.2k.f0,1G,J.f0,J);if(1G!=1c&&(!1G.1M()&&1M(kV))){kV=J.KI()}if(5l===0||!1M(5l)){5l=6p(5l);K kQ=$("tr:5L(.ui-qb-3A-1G-7q)",J.kS).eq(5l);if(kQ.1e){kQ.tF(1G.3g)}1i{1G.3g.4E(J.kS)}}1i{if(kV!=1c&&kV.1e){1G.3g.7h(kV)}1i{1G.3g.4E(J.kS)}}if(!kP){J.1f.1O(QB.1d.2H.2k.yJ,{1G:1G})}J.3c.1H(1G)}1i{if(5l===0||!1M(5l)){5l=6p(5l);K KH=1G.3g[0].WE-1;if(5l!=KH){K kQ=$("tr:5L(.ui-qb-3A-1G-7q)",J.kS).eq(5l);if(kQ.1e){kQ.tF(1G.3g)}}}aD=1G.85(4C);if(!kP&&aD){J.1f.1O(QB.1d.2H.2k.fC,{1G:1G})}}if(1G!=1c&&1G.3g!=1c){K qj=$(".ui-qb-3A-1G-dw",1G.3g);if(qj.1e>0){qj.2I("4u",J.qh?"":"3j")}}if(!kP&&aD){J.fY()}J.j4();1b 1G},Pf:1a(){1b J.3c},Vz:1a(){K xU=1c;$.2e(J.3c,1a(1q,1G){K uQ=1G.1M();if(uQ){xU=1G;1b 1j}});1b xU},iu:1a(xP,kP){K 4C;1o(K i=J.3c.1e-1;i>=0;i--){K 1G=J.3c[i];if(1G.3m==xP.3m){if(!1M(1G.3m)||1M(1G.3m)&&1G.3g==xP.3g){J.3c.3v(1G);1G.87=1m;1G.3v();4C=1G.1P()}}}J.fY();if(4C){4C.87=1m;if(!kP){J.1f.1O(QB.1d.2H.2k.yO,{4C:4C})}}J.j4()},Uu:1a(1P){K 3c=J.y7(1P);1o(K 1G in 3c){1G.3v();J.3c.3v(1G);46 1G}J.fY()},Ut:1a(7u){K 1J=1c;$.2e(J.3c,1a(1q,1G){if(1G.3m==7u){1J=1G;1b 1j}});1b 1J},KI:1a(){1b J.kS.2g("tr:7i:5L(.ui-qb-3A-1G-7q)")},KF:1a(4C){K 3c=J.y7(4C);if(3c.1e>0){1b 3c[0]}1b 1c},y7:1a(4C){K 1J=[];K uv=[];K uu=[];K ur=[];K um=[];if(4C==1c){1b 1J}K y6=42.3u(4C.9f).3N();K us=42.3u(4C.8R).3N();1o(K i=0;i<J.3c.1e;i++){K 1G=J.3c[i];if(!1M(1G.3m)&&(!1M(4C.3m)&&1G.3m==4C.3m)){uv.1H(1G)}1i{if(!1M(1G.6s)&&(!1M(4C.6s)&&1G.6s==4C.6s)){uu.1H(1G)}1i{if(1G.jc(4C.9f,4C.eT,4C.8R)){if(4C.9c==i){ur.1H(1G)}1i{um.1H(1G)}}}}}if(uv.1e>0){1J=uv}1i{if(uu.1e>0){1J=uu}}if(ur.1e>0){1J=ur}if(um.1e>0){1J=um}1b 1J},n3:1a(){$.2e(J.3c,1a(1q,1G){1G.5Q[1R.2i.3f].xz();if(QB.1d.2H.oG==1G.5Q[1R.2i.3f]){1G.5Q[1R.2i.3f].uq()}})},Mh:1a(3f){K 3c=J.tc(3f);if(3c.1e>0){1b 3c[0]}1b 1c},tc:1a(3f){K 1J=[];$.2e(J.3c,1a(1q,1G){if(1G.jc(3f,"")){1J.1H(1G)}});1b 1J},Q1:1a(1P){J.z6();K 3b=$(":3b");$("#qb-ui-1W").3b();QB.1d.2H.2J=1m;K me=J;if(1M(1P)){1b}K xB=[];$.2e(1P.bk,1a(1S,KG){xB.1H(me.kt(KG,1c,1S,1m))});1o(K i=J.3c.1e-1;i>=0;i--){if(i>J.3c.1e-1){bn}K qB=J.3c[i];if(qB!=1c){if(xB.51(qB)==-1&&!qB.1M()){J.iu(qB,1m)}}}J.z0();QB.1d.2H.2J=1j},Q0:1a(){K 2Q=[];if(QB.1d.2d.62!=1c&&QB.1d.2d.62.1e!=1c){1o(K i=0;i<QB.1d.2d.62.1e;i++){K 1v=QB.1d.2d.62[i];K 1B=1v.1g("1C");K 8L=!1M(1B.ku)?1B.ku:1B.45;K xA=8L+".*";2Q.1H({1U:1j,2a:xA,1n:xA,ex:"1B"});$(1B.5V).2e(1a(){K 2m=J;K qu=8L+"."+2m.70;K KJ=2m.70;2Q.1H({1U:1j,2a:KJ,1n:qu,ex:"2m"})})}}a4.yt("3A-3f",2Q)},Uv:1a(1G,3T){1G.gk(3T)},f0:1a(e,1g){1g.1G=e.1g.1G;J.1f.1O(QB.1d.2H.2k.yk,1g)},xK:1a(e,1g){J.j4()},KN:1a(e,1g){K 1G=e.1g.1G;K 1q=1c;K 4b=1c;K 5H=1c;if(1g){1q=1g.1q;4b=1g.4b;5H=1g.5H}1b J.KL(1G,1q,5H,4b,1g.gm)},Uo:1a(4C,5q,3f,1V){if(J.uo!="1m"){if(1V&&7F(1V)=="1a"){1V()}1b}4C.KK=1m;4C.zo=5q;4C.zn=3f;QB.1d.2o.mh([4C]);QB.1d.2o.5y(1V)},KL:1a(1G,5q,5H,4b,xJ){if(5q==1R.2i.kB&&4b){if(J.3c.1e>1){J.iu(1G,1m)}1i{if(1G.1M()){1b}1i{J.iu(1G,1m);J.iY()}}}J.iY(1G);J.fY(1G);J.1f.1O(QB.1d.2H.2k.fC,{1G:1G,1q:5q,4b:4b,5H:5H,xJ:xJ});J.j4()},fY:1a(1G){if(J.kr!=0){1b}J.Kx(1G);J.Ky(1G)},Ky:1a(){K qo=[];1o(K i=0;i<J.3c.1e;i++){K 1G=J.3c[i];K 1n=1G.7p(1R.2i.9o);if(1n!=1c&&1n>0){qo.1H({1G:1G,7e:1G.7p(1R.2i.7e)})}}qo.h3(J.Kw);K 2Q=[];1o(K i=0;i<qo.1e;i++){2Q.1H({1U:1j,2a:5w(i+1),1n:5w(i+1),ex:"7e"});K 1G=qo[i].1G;1G.8i(1R.2i.7e,i+1,1m);1G.kq(1R.2i.7e)}2Q.1H({1U:1j,2a:5w(i+1),1n:5w(i+1),ex:"7e"});a4.yt("3A-7e",2Q)},Qw:1a(){1o(K i=0;i<J.3c.1e;i++){K 1G=J.3c[i];1G.Kz(1R.2i.dz)}},Kw:1a(a,b){K kC=b.7e;K kD=a.7e;if(1M(kD)||kD<0){1b 1}if(1M(kC)||kC<0){1b-1}kD=6p(kD);kC=6p(kC);1b kD-kC},Kx:1a(1G){K uA=1j;1o(K i=0;i<J.3c.1e;i++){if(J.3c[i].7p(1R.2i.dJ)){uA=1m;1r}}if(J.qh==uA){1b 1j}J.qh=uA;K qj=$(".ui-qb-3A .ui-qb-3A-1G-dw");qj.2I("4u",J.qh?"":"3j");J.j4();1b 1m},KA:1a(){K 7q=$("<b8 />");K tr=$("<tr />").2y("ui-qb-3A-1G-7q").2y("ui-8l-7q").4E(7q);K 4a=1m;K UE="";QB.1d.2H.8N={};QB.1d.2H.8N[1R.2i.3O]="";QB.1d.2H.8N[1R.2i.kB]=QB.1d.29.4J.57.g0;QB.1d.2H.8N[1R.2i.1U]=QB.1d.29.4J.57.63.uw;QB.1d.2H.8N[1R.2i.3f]=QB.1d.29.4J.57.63.9f;QB.1d.2H.8N[1R.2i.dz]=QB.1d.29.4J.57.63.eT;QB.1d.2H.8N[1R.2i.b6]=QB.1d.29.4J.57.63.8R;QB.1d.2H.8N[1R.2i.9o]=QB.1d.29.4J.57.63.eZ;QB.1d.2H.8N[1R.2i.7e]=QB.1d.29.4J.57.63.kX;QB.1d.2H.8N[1R.2i.dJ]=QB.1d.29.4J.57.63.iN;QB.1d.2H.8N[1R.2i.dw]=QB.1d.29.4J.57.63.yd;QB.1d.2H.8N[1R.2i.6V]=QB.1d.29.4J.57.63.vm;QB.1d.2H.8N[1R.2i.qD]=QB.1d.29.4J.57.63.vm;$.2e(QB.1d.2H.8N,1a(i,5E){QB.1d.2H.8N[i]=5E.3l("&2x;"," ").3l("&yx;","&")});$.2e(J.KB(),1a(){if(4a){$(\'<th 2C="ui-5g-5v ui-qb-3A-1G-\'+J.1x+\'" 8B="3">\'+J.7q+"</th>").4E(tr);4a=1j}1i{$(\'<th 2C="KD-5s ui-5g-5v ui-qb-3A-1G-\'+J.1x+\'">\'+J.7q+"</th>").4E(tr)}});1b 7q},KB:1a(){K 3c={};3c[1R.2i.1U]={cW:1,1x:"1U",7q:QB.1d.29.4J.57.63.uw,1z:"8f"};3c[1R.2i.3f]={cW:2,1x:"3f",7q:QB.1d.29.4J.57.63.9f,1z:"3f"};3c[1R.2i.b6]={cW:3,1x:"b6",7q:QB.1d.29.4J.57.63.8R,1z:"2a"};3c[1R.2i.9o]={cW:4,1x:"9o",7q:QB.1d.29.4J.57.63.eZ,1z:"2u"};3c[1R.2i.7e]={cW:5,1x:"7e",7q:QB.1d.29.4J.57.63.kX,1z:"2u"};3c[1R.2i.dz]={cW:6,1x:"dz",7q:QB.1d.29.4J.57.63.eT,1z:"2u"};3c[1R.2i.dJ]={cW:7,1x:"dJ",7q:QB.1d.29.4J.57.63.iN,1z:"8f"};3c[1R.2i.dw]={cW:8,1x:"dw",7q:QB.1d.29.4J.57.63.yd,1z:"2u"};3c[1R.2i.6V]={cW:9,1x:"6V",7q:QB.1d.29.4J.57.63.vm,1z:"2a"};1o(K i=0;i<QB.1d.2H.iL;i++){3c[1R.2i.qD+i]={cW:10+i,1x:"y9",7q:QB.1d.29.4J.57.63.KC,1z:"2a"}}1b 3c}};QB.1d.2H.2k={yJ:"Uz",yO:"Uy",fC:"yX",vB:"vB",vC:"vC",yk:"yk"};(1a($){$.8l("ui.8y",QB.1d.2H);$.4n($.ui.8y,{Mi:"UC Mh tc kt gb",6c:"1.7.1"})})(2A);QB.1d.29.fr={gv:0,6L:1,wX:2,v1:3,LU:4};QB.1d.29.6H={};QB.1d.29.6H[QB.1d.2U.6G.Mk]={45:"UB iT",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.Mo]={45:"jg",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.Ml]={45:"U4 iT",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.pF]={45:"is jc to",7O:1,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.Mm]={45:"wS 5L 2S iT",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.M9]={45:"wS 5L U3",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.Ma]={45:"wS 5L 4g iT",7O:1,7m:[QB.1d.2U.6k.aj]};QB.1d.29.6H[QB.1d.2U.6G.xl]={45:"is in 4V",7O:1,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.RH]={45:"is 5L jc to",7O:1,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.xk]={45:"is 5L in 4V",7O:1,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.Mf]={45:"is 1c",7O:0,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.Mc]={45:"is 5L 1c",7O:0,7m:[]};QB.1d.29.6H[QB.1d.2U.6G.Md]={45:"is MA vw",7O:1,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.6H[QB.1d.2U.6G.MC]={45:"is MA vw or jc to",7O:1,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.6H[QB.1d.2U.6G.MG]={45:"is Mt vw",7O:1,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.6H[QB.1d.2U.6G.Ms]={45:"is Mt vw or jc to",7O:1,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.6H[QB.1d.2U.6G.Mu]={45:"is Mw",7O:2,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.6H[QB.1d.2U.6G.Mx]={45:"is 5L Mw",7O:2,7m:[QB.1d.2U.6k.gB,QB.1d.2U.6k.5A]};QB.1d.29.i5={};QB.1d.29.i5[QB.1d.2U.ah.9C]={45:"9C",hT:"6D"};QB.1d.29.i5[QB.1d.2U.ah.ve]={45:"gy 9C",hT:"Vl"};QB.1d.29.i5[QB.1d.2U.ah.q0]={45:"q0",hT:"Vd"};QB.1d.29.i5[QB.1d.2U.ah.ji]={45:"ji",hT:"3j"};QB.1d.uY=1a(){J.$1z=1c};QB.1d.pY=1T 6n({$1z:"e2.q4.1d.e1.q5.wB, e2.q2.1d.e1",4A:1c,2W:[],4P:QB.1d.29.fr.gv,6L:1c,7M:QB.1d.2U.6G.pF,68:1c,7s:1c,ew:1j,gZ:1j,1f:1c,ad:1a(){K ad=J;43(ad.4A!=1c){ad=ad.4A}1b ad},v0:1a(1P){1P.$1z=J.$1z;1P.4P=J.4P;1P.6L=J.6L;1P.7M=J.7M;1P.68=J.68;1P.7s=J.7s},uZ:1a(1P){1P.2W=[];$.2e(J.2W,1a(1S,1h){1P.2W.1H(1h.hR())})},hR:1a(){K 1P=$.4n(1T QB.1d.uY,1T QB.1d.29.wB);J.v0(1P);J.uZ(1P);1b 1P},Lz:1a(1P){K 1J=1c;if(1P==1c){1b 1J}3x(1P.4P){1p QB.1d.29.fr.6L:1J=1T QB.1d.xt(J);1J.mn(1P);1r;1p QB.1d.29.fr.wX:1J=1T QB.1d.wY(J);1J.mn(1P);1r;1p QB.1d.29.fr.v1:1J=1T QB.1d.v6(J);1J.mn(1P);1r}1b 1J},mn:1a(1P){K me=J;J.4P=1P.4P;J.6L=1P.6L;J.7M=1P.7M;J.aL=1P.aL;J.9G=1P.9G;J.68=1P.68;J.7s=1P.7s;$.2e(1P.2W,1a(1S,1h){me.2W.1H(me.Lz(1h))})},Ar:1a(5q){J.6L=5q;if(J.6L!=1c){if(QB.1d.29.6H[J.7M].7m.1e!=0&&!QB.1d.29.6H[J.7M].7m.jg(J.7M)){J.7M=QB.1d.2U.6G.pF}}1i{J.7M=QB.1d.2U.6G.pF}},9c:1a(){if(J.4A==1c){1b-1}1b J.4A.2W.51(J)},Vb:1a(){if(J.4A==1c){1b 1c}K i=J.4A.2W.51(J);if(i>=J.4A.2W.1e-1){1b 1c}1b J.4A.2W[i+1]},mG:1a(){if(J.4A==1c){1b 1c}K i=J.4A.2W.51(J);if(i<=0){1b 1c}1b J.4A.2W[i-1]},LD:1a(){if(J.4A==1c){1b 0}1b J.4A.2W.1e},x6:1a(){1b QB.1d.29.6H[J.7M]},vf:1a(){K 1J="";if(!J.ad().mB){1b 1J}if(J.mG()==1c){1b 1J}if(J.4A==1c){1b 1J}3x(6p(J.4A.9G)){1p QB.1d.2U.ah.9C:;1p QB.1d.2U.ah.ve:1J=$("<2B> mp </2B>");1r;1p QB.1d.2U.ah.q0:;1p QB.1d.2U.ah.ji:1J=$("<2B> or </2B>");1r}1b 1J},LN:1a(){K 1F={};$.2e(J.ad().v9,1a(1S,5q){1F[5q.45]={1x:5q.45,3C:"2m",1g:5q}});1b 1F},M1:1a(1h){K 1F={};$.2e(QB.1d.29.6H,1a(1S,1f){if(1h.6L!=1c){if(1f.7m.1e!=0){if(1h.6L!=1c&&1f.7m.jg(1h.6L.q6)){1F[1S]={1x:1f.45,3C:"",1g:1f}}}1i{1F[1S]={1x:1f.45,3C:"",1g:1f}}}});1b 1F},LZ:1a(1h){K 1F={};$.2e(QB.1d.29.i5,1a(1S,1f){1F[1S]={1x:1f.45,3C:"",1g:1f}});1b 1F},vd:1a(){K 1F={};1F["dW-up"]={1x:"lr up",3C:"dW-up",2J:J.9c()<=0};1F["dW-dX"]={1x:"lr dX",3C:"dW-dX",2J:J.9c()>=J.LD()-1};1F["5u"]="---------";1b 1F},82:1a(){J.q7()},lD:1a(){1b 1m},q7:1a(){if(J.6L==1c){J.ew=1m;J.gZ=1m;1b}if(J.7M==QB.1d.2U.6G.xl||J.7M==QB.1d.2U.6G.xk){1b!1M(J.68)}3x(J.6L.q6){1p QB.1d.2U.6k.lv:;1p QB.1d.2U.6k.5A:;1p QB.1d.2U.6k.aj:;1p QB.1d.2U.6k.gv:J.ew=!1M(J.68);J.gZ=!1M(J.7s);1r;1p QB.1d.2U.6k.gB:J.ew=!1M(J.68)&&$.LG(J.68);J.gZ=!1M(J.7s)&&$.LG(J.7s);1r}},gh:1a(){J.82()},la:1a(){1b{}},LH:1a(){K 1S=J.9c();K 1h=J.4A.2W[1S];if(1S<=0||(J.4A==1c||J.1f==1c)){1b 1j}K xm=1S-1;K hZ=J.4A.2W[xm];if(hZ==1c||hZ.1f==1c){1b 1j}J.1f.7h(hZ.1f);J.4A.2W[1S]=hZ;J.4A.2W[xm]=1h;1b 1m},LE:1a(){K 1S=J.9c();K 1h=J.4A.2W[1S];if(J.4A==1c||(J.1f==1c||1S>=J.4A.2W.1e-1)){1b 1j}K dZ=1S+1;K i0=J.4A.2W[dZ];if(i0==1c||i0.1f==1c){1b 1j}i0.1f.7h(J.1f);J.4A.2W[1S]=i0;J.4A.2W[dZ]=1h;1b 1m},LF:1a(){K 1S=J.9c();J.4A.2W.3v(1S);J.1f.3v();1b 1m},Ls:1a(){$.2e(J.2W,1a(1S,1h){1h.1f.3v()});J.2W=[];1b 1m},le:1a(1h){K 1S=1h.9c();if(1S==0){J.1f.lf(1h.82())}1i{1h.mG().1f.tu(1h.82())}},As:1a(){K 1h=1T QB.1d.xt(J.4A);J.4A.2W.1H(1h);J.4A.le(1h);1b 1h},Lr:1a(){K 1h=1T QB.1d.wY(J.4A);J.4A.2W.1H(1h);J.4A.le(1h);1b 1h},Lv:1a(){K 1h=1T QB.1d.v6(J.4A);J.4A.2W.1H(1h);J.4A.le(1h);1b 1h},v8:1a(1q){3x(1q){1p"dW-up":1b J.LH();1r;1p"dW-dX":1b J.LE();1r;1p"46":1b J.LF();1r;1p"aN":1b J.Ls();1r;1p"56-6V-1o-5q":1b J.As();1r;1p"56-va-6V":1b J.Lr();1r;1p"56-cw-of-v7":1b J.Lv();1r}1b 1j},A1:1a(1q,5q){J.Ar(5q);J.gh();1b 1m},LY:1a(1q){J.7M=1q;J.gh();1b 1m},LM:1a(1q){J.9G=1q;J.gh();1b 1m},cz:1a(1N){if(1N!==2p){J.4A=1N}}});QB.1d.xt=1T 6n({bY:QB.1d.pY,4P:QB.1d.29.fr.6L,$1z:"e2.q4.1d.e1.q5.Lw, e2.q2.1d.e1",la:1a(){K 1F=J.vd();1F["46"]={1x:"g0",3C:"Ac"};1b 1F},lD:1a(){if(J.6L==1c){1b 1j}K xp=J.x6();if(xp!=1c){3x(xp.7O){1p 2:1b J.ew&&J.gZ;1r;1p 1:1b J.ew;1r;1p 0:1b 1m;1r}}1b 1m},kZ:1a($1f,eG,5q){K me=J;if(1M(eG)){eG=1}K 2c="";if(eG==2){if(!1M(J.7s)){2c=J.7s}}1i{if(!1M(J.68)){2c=J.68}}K $2f=$(\'<2f 1n="\'+2c+\'">\').hY(1a(1I){if(1I.3V==10||1I.3V==13){1I.4r();J.5c()}});if(!1M(5q)&&5q.q6==QB.1d.2U.6k.5A){$2f.v2({h8:1a(2c,Vo){$2f.2c(2c);if(eG==2){me.7s=2c}1i{me.68=2c}me.q7(2c,eG)},Vs:1a(){2c=$2f.2c();if(eG==2){me.7s=2c}1i{me.68=2c}me.gh()}});$2f.fI($1f).3b()}1i{$2f.fI($1f);$2f.3b();6K(1a(){$2f.5c(1a(){K 2c=$2f.2c();if(eG==2){me.7s=2c}1i{me.68=2c}me.q7(2c,eG);me.gh()})},9q)}},82:1a(){K me=J;J.1N(2t);if(J.1f==1c){J.1f=$(\'<2E 2C="qb-ui-4X-4W-6C 1h">\')}J.1f.dn();J.1f.1g("1h",J);J.1f.2Y($(\'<2E 2C="qb-ui-4X-4W-3z 71">\'));J.1f.2Y(" ");J.1f.2Y(J.vf());K 5q=J.6L;if(1M(5q)){J.1f.2Y($(\'<a 2C="qb-ui-4X-4W-1Y-2m-2u 9K" 5d="#">[2u 5q]</a>\'))}1i{J.1f.2Y($(\'<a 2C="qb-ui-4X-4W-1Y-2m-2u" 5d="#">\'+5q.45+"</a>"))}J.1f.2Y(" ");K LJ=QB.1d.29.6H[J.7M].45;J.1f.2Y($(\'<a 2C="qb-ui-4X-4W-1Y-6Z" 5d="#">\'+LJ+"</a>"));J.1f.2Y(" ");K LV=J.x6();K $a8;K $fS;3x(6p(LV.7O)){1p 1:if(1M(J.68)){$a8=$(\'<a 2C="qb-ui-4X-4W-1Y-1n 9K" 5d="#">[v5 1n]</a>\')}1i{$a8=$(\'<a 2C="qb-ui-4X-4W-1Y-1n" 5d="#">\'+J.68+"</a>")}$a8.3R(1a(e){K $1f=$(J);$1f.3S();me.kZ($1f,1,5q)});J.1f.2Y($a8);if(!1M(J.68)&&!J.ew){$a8.2y("9K");J.1f.2Y(\' <2B 2C="v3-1n">LT 1n</2B>\')}1r;1p 2:if(1M(J.68)){$a8=$(\'<a 2C="qb-ui-4X-4W-1Y-1n 9K" 5d="#">[v5 1n]</a>\')}1i{$a8=$(\'<a 2C="qb-ui-4X-4W-1Y-1n" 5d="#">\'+J.68+"</a>")}if(!J.ew){$a8.2y("9K")}$a8.3R(1a(e){K $1f=$(J);$1f.3S();me.kZ($1f,1,5q)});J.1f.2Y($a8);J.1f.2Y($("<2B> mp </2B>"));if(1M(J.7s)){$fS=$(\'<a 2C="qb-ui-4X-4W-1Y-1n 9K" 5d="#">[v5 1n]</a>\')}1i{$fS=$(\'<a 2C="qb-ui-4X-4W-1Y-1n" 5d="#">\'+J.7s+"</a>")}if(!J.gZ){$fS.2y("9K")}$fS.3R(1a(e){K $1f=$(J);$1f.3S();me.kZ($1f,2,5q)});J.1f.2Y($fS);if(!1M(J.68)&&!J.ew||!1M(J.7s)&&!J.gZ){if(!1M(J.68)&&!J.ew){$a8.2y("9K")}if(!1M(J.7s)&&!J.gZ){$fS.2y("9K")}J.1f.2Y(\' <2B 2C="v3-1n">LT 1n</2B>\')}1r}if(!1M(5q)&&5q.q6==QB.1d.2U.6k.5A){if(!1M($a8)){$a8.v2()}if(!1M($fS)){$fS.v2()}}1b J.1f},cz:1a(1N){J.1N(1N)}});QB.1d.wY=1T 6n({bY:QB.1d.pY,4P:QB.1d.29.fr.wX,$1z:"e2.q4.1d.e1.q5.xc, e2.q2.1d.e1",aL:"",v4:1j,la:1a(){K 1F=J.vd();1F["46"]={1x:"g0",3C:"Ac"};1b 1F},hR:1a(){K 1P=$.4n(1T QB.1d.uY,1T QB.1d.29.xc);J.v0(1P);1P.aL=J.aL;J.uZ(1P);1b 1P},lD:1a(){1b J.v4},q7:1a(2c,eG){J.v4=!1M(J.aL)},kZ:1a($1f){K me=J;K 2c="";if(!1M(J.aL)){2c=J.aL}K $2f=$(\'<2f 1n="\'+2c+\'">\').hY(1a(1I){if(1I.3V==10||1I.3V==13){1I.4r();J.5c()}}).5c(1a(){me.aL=$2f.2c();me.68=me.aL;me.gh()}).fI($1f).3b()},82:1a(){K me=J;J.1N(2t);if(J.1f==1c){J.1f=$(\'<2E 2C="qb-ui-4X-4W-6C 1h">\')}J.1f.1g("1h",J);J.1f.dn();J.1f.2Y($(\'<2E 2C="qb-ui-4X-4W-3z 71">\'));K $kY;J.1f.2Y(J.vf());if(1M(J.aL)){$kY=$(\'<a 2C="qb-ui-4X-4W-1Y-1n 9K" 5d="#">[v5 6V]</a>\')}1i{$kY=$(\'<a 2C="qb-ui-4X-4W-1Y-1n" 5d="#">\'+J.aL+"</a>")}if(!J.v4){$kY.2y("9K")}$kY.3R(1a(e){K $1f=$(J);$1f.3S();me.kZ($1f)});J.1f.2Y($kY);1b J.1f},cz:1a(1N){J.1N(1N)}});QB.1d.v6=1T 6n({bY:QB.1d.pY,4P:QB.1d.29.fr.v1,$1z:"e2.q4.1d.e1.q5.x7, e2.q2.1d.e1",9G:QB.1d.2U.ah.9C,hR:1a(){K 1P=$.4n(1T QB.1d.uY,1T QB.1d.29.x7);J.v0(1P);1P.9G=J.9G;J.uZ(1P);1b 1P},lD:1a(){K 1J=1m;if(J.2W.1e==0&&J.4A!=1c){1b 1j}$.2e(J.2W,1a(1S,1h){if(!1h.lD()){1J=1j;1b 1j}});1b 1J},la:1a(){K 1F=J.vd();1F["aN"]={1x:"Ah",3C:"Af",2J:J.2W.1e<=0};1F["46"]={1x:"g0",3C:"Ac"};1b 1F},le:1a(1h){K 1S=1h.9c();if(1S==0){J.1f.6a(".qb-ui-4X-4W-4y").lf(1h.82())}1i{1h.mG().1f.tu(1h.82())}},zU:1a(){1b QB.1d.29.i5[J.9G]},82:1a(){J.1N(2t);if(J.1f==1c){J.1f=$(\'<2E 2C="qb-ui-4X-4W-6C cw">\')}J.1f.1g("1h",J);J.1f.dn();J.1f.2Y($(\'<2E 2C="qb-ui-4X-4W-3z aU">\'));K l3=J.zU();K $3K=$(\'<2E id="qb-ui-4X-4W-3K">\');$3K.2Y(J.vf());K $a=$(\'<a 2C="qb-ui-4X-4W-1Y-zV" 5d="#">\'+l3.45+"</a>");$3K.2Y($a);$3K.2Y($("<2B> "+J.ad().l6+"</2B>"));J.1f.2Y($3K);K $4y=$(\'<2E 2C="qb-ui-4X-4W-4y \'+l3.hT+\'">\');$.2e(J.2W,1a(1S,1h){$4y.2Y(1h.82())});K tm=1T QB.1d.tn(J);$4y.2Y(tm.82());J.1f.2Y($4y);1b J.1f},cz:1a(1N){J.1N(1N);if(1N!=1c){3x(6p(1N.9G)){1p QB.1d.2U.ah.9C:;1p QB.1d.2U.ah.ve:J.9G=QB.1d.2U.ah.q0;1r;5v:J.9G=QB.1d.2U.ah.9C}}}});QB.1d.tn=1T 6n({bY:QB.1d.pY,4P:QB.1d.29.fr.LU,la:1a(){K 1F={"56-6V-1o-5q":{1x:"eU 6V 1o 5q",3C:"56-6V-1o-5q"},"56-va-6V":{1x:"eU va 6V",3C:"56-va-6V"},"5u":"---------","56-cw-of-v7":{1x:"eU cw of v7",3C:"56-cw-of-v7"}};1b 1F},82:1a(){if(J.1f==1c){J.1f=$(\'<2E 2C="qb-ui-4X-4W-6C 56">\')}J.1f.1g("1h",J);J.1f.dn();J.1f.2Y($(\'<2E 2C="qb-ui-4X-4W-3z nT">\'));J.1f.2Y($(\'<a 2C="qb-ui-4X-4W-1Y-2m-2u" 5d="#">[...]</a>\'));1b J.1f},A1:1a(1q,5q){K 1h=J.As();1h.Ar(5q);1h.gh();1b 1m},cz:1a(1N){J.1N(1N)}});QB.1d.7I=1T 6n({bY:QB.1d.v6,$1z:"e2.q4.1d.e1.q5.A9, e2.q2.1d.e1",4A:1c,mC:"LX",l6:"of lj UX UW",mB:1m,2W:[],lO:1a(1g){J.v9=1g.v9;J.2W=[];J.mn(1g);J.A3()},LO:1a(){K me=J;K 5K=".qb-ui-4X-4W-3z";$.2G("5M",5K);$.2G({3X:5K,4w:cK,6R:{5b:0},1O:"1Z",1F:{},8O:1a($1O,e){K 1h=$1O.aT(".qb-ui-4X-4W-6C:4a").1g("1h");if(1h==1c){1b 1j}K 1F=1h.la();if(1F==1c||4D.84(1F).1e==0){1b 1j}1b{1V:1a(1q){1h.v8(1q,1F[1q].1g)},1F:1F}}})},LQ:1a(){K me=J;K 5K=".qb-ui-4X-4W-1Y-6Z";$.2G("5M",5K);$.2G({3X:5K,4w:cK,6R:{5b:0},1O:"1Z",1F:{},8O:1a($1O,e){K 1h=$1O.aT(".qb-ui-4X-4W-6C:4a").1g("1h");if(1h==1c){1b 1j}K 7d=1h.M1(1h);if(7d==1c||4D.84(7d).1e==0){1b 1j}1b{1V:1a(1q){1h.LY(1q)},1F:7d}}})},RD:1a(){K me=J;K 5K=".qb-ui-4X-4W-1Y-zV";$.2G("5M",5K);$.2G({3X:5K,4w:cK,6R:{5b:0},1O:"1Z",1F:{},8O:1a($1O,e){K 1h=$1O.aT(".qb-ui-4X-4W-6C:4a").1g("1h");if(1h==1c){1b 1j}K 7d=1h.LZ(1h);if(7d==1c||4D.84(7d).1e==0){1b 1j}1b{1V:1a(1q){1h.LM(1q)},1F:7d}}})},LR:1a(){K me=J;K 5K=".qb-ui-4X-4W-1Y-2m-2u";$.2G("5M",5K);K 1Q=$.2G({3X:5K,4w:cK,6R:{5b:0},1O:"1Z",1F:{},aV:"UQ",8O:1a($1O,e){K 1h=$1O.aT(".qb-ui-4X-4W-6C:4a").1g("1h");if(1h==1c){1b 1j}K 1F=1h.LN();if(1F==1c||4D.84(1F).1e==0){1b 1j}1b{1V:1a(1q){1h.A1(1q,1F[1q].1g)},1F:1F}}})},A3:1a(){K me=J;J.2r.dn();J.2r.2Y(J.82());1b;K $4y=$(\'<2E 2C="qb-ui-4X-4W-4y 6D">\');$.2e(J.2W,1a(1S,1h){$4y.2Y(1h.82())});K LK=1T QB.1d.tn(J);$4y.2Y(LK.82());J.2r.2Y($4y);J.1f=$4y},le:1a(1h){K 1S=1h.9c();if(1S==0){J.1f.6a(".qb-ui-4X-4W-4y").lf(1h.82())}1i{1h.mG().1f.tu(1h.82())}},82:1a(){if(J.1f==1c){J.1f=$(\'<2E 2C="qb-ui-4X-4W-6C cw 2r">\')}J.1f.1g("1h",J);J.1f.dn();K l3=J.zU();K $3K=$(\'<2E id="qb-ui-4X-4W-3K">\');$3K.2Y("<2B>"+J.ad().mC+" </2B>");K $a=$(\'<a 2C="qb-ui-4X-4W-1Y-zV" 5d="#">\'+l3.45+"</a>");$3K.2Y($a);$3K.2Y($("<2B> "+J.ad().l6+"</2B>"));J.1f.2Y($3K);K $4y=$(\'<2E 2C="qb-ui-4X-4W-4y \'+l3.hT+\'">\');$.2e(J.2W,1a(1S,1h){$4y.2Y(1h.82())});K tm=1T QB.1d.tn(J);$4y.2Y(tm.82());J.1f.2Y($4y);1b J.1f},hR:1a(){K 1P=1T QB.1d.29.A9;1P.9G=J.9G;1P.2W=[];$.2e(J.2W,1a(1S,1h){1P.2W.1H(1h.hR())});1b 1P},5y:1a(1V){QB.1d.2o.3Y.7I=J.hR();QB.1d.2o.5y(1V)},85:1a(1V){QB.1d.2o.3Y.7I=1c;QB.1d.2o.5y(1V)},cz:1a(1N){J.2r=$("#qb-ui-4X-4W");if(J.2r.1e){if(!1M(J.2r.1l("l6"))){J.l6=J.2r.1l("l6")}if(!1M(J.2r.1l("mC"))){J.mC=J.2r.1l("mC")}if(!1M(J.2r.1l("mB"))){J.mB=J.2r.1l("mB").3N()=="1m"}}J.1N(1c);J.A3();J.LO();J.LR();J.LQ();J.RD()}});QB.1d.7I.2k={RJ:"RJ",RB:"RB"};K 6c=4;K QF=1m;K tU="nO/";K wW="1.11.0";K Pp="2.99.99";K ww="1.11.0";K Ph="2.99.99";K QC="AV iy Ro.js is 5L bL.";K xb="2A QZ is 5L 98.";K Pv="UV QZ is 5L 98.";K PA="QS 2A 6c v.$1 QY! 2A v.$2 or QV is QU.";K Pe="QS AR 6c v.$1 QY! AR v.$2 or QV is QU.";K PU=\'Vy Vt tE cW. 2A mp AR Vv be bL tF tE lj "Ro.js"\';K Rm=\'Vg nO Vc is Vk. Rj gk Ra "Vm.6O" Ud.\';K mX=1j;K 5k=1a(){J.4e=1c;J.zD=1c;J.1W=1c;J.3A=1c;J.4K=[];J.fl={};J.62=[];J.8a=1c;J.tL=1c;J.mK=1j;J.3m=1c;J.iq=1c;J.dC="";J.9O={};J.iO=1c;J.9H=1c;J.7I=1c;J.B1=1c;J.nH=1j;J.aS=0;J.vZ=1m;J.nF={2H:{jd:{},cC:{}},2d:{jd:{},cC:{}}};J.tY=1a(9x){K tA=QB.1d.2o.iF[9x];if(!1M(tA)){J.AE(1c,tA.2d);J.zS(1c,tA.2H)}QB.1d.2o.d8=9x};J.u5=1a(3O){K me=J;if(3O.dF=="Rk-RE-U6"){J.tY(3O.3m)}if(QB.1d.2o.eX){6K(1a(){me.u5(3O)},50);1b}QB.1d.2o.3Y.AW.1H(3O);QB.1d.2o.5y()};J.Q4=1a(e,1Y){K 1P=1Y.1P();if(1Y.87){QB.1d.2d.7r.3v(1Y)}QB.1d.2o.RK(1P);QB.1d.2o.5y()};J.yW=1a(e,1g){K 3O=1g.3O;K 1h=1g.1h;QB.1d.2o.3Y.gV.cV=3O;QB.1d.2o.3Y.gV.cC=1h.1g;QB.1d.2o.3Y.gV.RI="1W";QB.1d.2o.5y()};J.yZ=1a(e,1w){K 1B=1w.1B;K 2m=1w.2m;K 9r=1w.9r;K AB=QB.1d.2d.AG(1B.Az);if(AB==1c){$.2e(1B.5V,1a(i,f){if(gN(f.70,2m.70)){f.eQ=1m}});K 1w={1C:1B,9r:9r};J.mN(e,1w)}1i{AB.6E("lM",2m.70,1m,1m)}};J.mN=1a(e,1w){1w.1C.6Y=1m;K 1v=J.d0(1w);K 7R=1w.1C;if(1w.9r&&1w.9r.1e>=2){7R.X=1w.9r[0];7R.Y=1w.9r[1]}K 5d=$(1v).1g("me");if(5d!=1c){7R.6s=5d.6s}if(J.1W!=1c){J.1W.1O(QB.1d.2d.2k.Ax,1v)}QB.1d.2o.Rt(7R);QB.1d.2o.5y()};J.zb=1a(e,1g){K 1v=$(1g);K 7R=1v.1g("4v");QB.1d.2o.Rx(7R);QB.1d.2o.5y()};J.Q5=1a(e,1g){K 1v=$(1g);K 7R=1v.1g("4v");QB.1d.2o.Rr(7R);QB.1d.2o.5y()};J.Q3=1a(e,1g){QB.1d.2o.mh([1g.1G.1P()]);QB.1d.2o.AH()};J.Q7=1a(e,1g){K 4C=1g.4C;QB.1d.2o.mh([4C]);QB.1d.2o.AH()};J.Rs=1a(1B,2m){K 3f="";3f+=!1M(1B.ku)?1B.ku:1B.45;3f+="."+2m.70;1b 3f};J.zd=1a(e,1g){QB.1d.2o.Rw(1g);QB.1d.2o.5y()};J.zg=1a(e,1Y){K 8J=QB.1d.2d.AG(1Y.z7);if(8J!=1c){K $1W=$("#qb-ui-1W");if(8J[0].8H<$1W.4I()||(8J[0].8V<$1W.4T()||(8J[0].8H+8J.1k()>$1W.4I()+$1W.1k()||8J[0].8V+8J.1s()>$1W.4T()+$1W.1s()))){K x=8J[0].8H+8J.1k()/ 2 - $1W.1k() /2;K y=8J[0].8V+8J.1s()/ 2 - $1W.1s() /2;$1W.4z({4I:x,4T:y},nk)}8J.2g(".qb-ui-1B-eB").Ry("tj",{},ti).Ry("tj",{},ti);1b}K 1w=1c;if(1Y.ks==1c){1w={1C:{3m:1Y.z7,6q:1Y.6q,cg:1Y}}}1i{1Y.ks.cg=1Y;1w={1C:1Y.ks}}J.mN(1c,1w)};J.ze=1a(e,d){K 5r=d.5r;K 3c=[];J.3A.8y("z6");1o(K i=0;i<5r.1e;i++){K 1g=5r[i];K 3T=1g.3T;K 3f=J.Rs(1g.1N,1g.1C);K tb=J.3A.8y("tc",3f);1o(K j=0;j<tb.1e;j++){K 1G=tb[j];if(3T){if(1G.gk(3T)){3c.1H(1G.1P())}}1i{if(1G.RA()){if(1G.gk(3T)){3c.1H(1G.1P())}}1i{3c.1H(1G.1P());J.3A.8y("iu",1G)}}}if(3T&&tb.1e==0){K tf=1T QB.1d.29.yY;tf.9f=3f;tf.cu=3T;K QR=J.3A.8y("kt",tf);3c.1H(QR.1P())}}J.3A.8y("z0")};J.d0=1a(1w,6b){K 1v=QB.1d.2d.d0(1w,6b);if(6b===2p||6b==1c){1v.4O(QB.1d.6P.2k.na,J.ze,J);1v.4O(QB.1d.6P.2k.n9,J.zd,J);1v.4O(QB.1d.6P.2k.nc,J.zg,J);1v.4O(QB.1d.6P.2k.nf,J.eR,J)}J.3A.8y("n3");1b 1v};J.i8=1a(1w,6b,ip){K 1v=QB.1d.2d.i8(1w,6b,ip);J.3A.8y("n3");1b 1v};J.uh=1a(1v){};J.n0=1a(){QB.1d.2o.3Y.im.1H("n0");J.zf();J.zl();QB.1d.2o.5y()};J.QT=1a(){QB.1d.2o.3Y.im.1H("n0");J.zf();QB.1d.2o.zc(1c);QB.1d.2o.5y()};J.zf=1a(){QB.1d.2o.3Y.7v=1T QB.1d.29.n4;QB.1d.2o.3Y.7v.cV="44"};J.Qe=1a(){J.vZ=1m;J.Q6()};J.zl=1a(){K aa=1c;if(J.bE!=1c&&(J.bE.1e>0&&J.bE.is(":5X"))){aa=J.bE.2c()}1i{aa=J.tL}J.8a=aa;QB.1d.2o.zc(J.8a);1b 1m};J.PL=1a(){QB.1d.2o.3Y.9H=J.9H;1b 1m};J.vY=1a(2a){J.ab.4o("9K 9s");J.ab.2y("wt");J.ab.3F(2a)};J.U5=1a(2a){J.ab.4o("9s wt");J.ab.2y("9K");J.ab.3F(2a)};J.Ul=1a(2a){J.ab.4o("9K wt");J.ab.2y("9s");J.ab.3F(2a)};J.Qn=1a(){if(J.vZ){if(QB.1d.2o.lP!=J.bE.2c()){J.vY(QB.1d.29.4J.57.PK);QB.1d.2o.lP=J.bE.2c()}}};J.Qb=1a(e,1C){K 1w={1C:1C};J.mN(1c,1w)};J.eR=1a(e,9x){K me=J;if(QB.1d.2o.eX){6K(1a(){me.eR(e,9x)},50);1b}if(!1M(9x)){J.tY(9x);QB.1d.2o.3Y.d8=9x;QB.1d.2o.5y()}};J.QI=1a(e,3O){QB.1d.5k.u5(3O)};J.Qp=1a(e,1g){J.4e.lO(1g)};J.PP=1a(4K){if(4K==1c){1b 1j}if(4K.1e==0){1b 1j}QB.1d.2d.7r.u8();1o(K 1S=0;1S<4K.1e;1S++){K 7D=4K[1S];K 9E=1c;if(7D.4U!=1c&&7D.54!=1c){9E=QB.1d.2d.7r.u1(7D.4U.9N,7D.54.9N)}if(9E==1c){QB.1d.2d.7r.nv(7D)}1i{9E.nj=1j;QB.1d.2d.7r.u0(9E,7D)}}QB.1d.2d.7r.u3()};J.PJ=1a(kO){if(kO==1c){1b}K 9i=kO.3J();K m5=[];K kM=[];K m0=[];K me=J;1o(K i=QB.1d.2d.62.1e-1;i>=0;i--){K 1v=QB.1d.2d.62[i];K kL=1v.1g("1C");K e5=1c;1o(K j=9i.1e-1;j>=0;j--){K 8w=9i[j];if(QB.1d.2d.yV(kL,8w)){9i.3v(j);e5=8w;1r}}if(e5==1c){1o(K j=9i.1e-1;j>=0;j--){K 8w=9i[j];if(QB.1d.2d.yU(kL,8w)){9i.3v(j);e5=8w;1r}}}if(e5!=1c){kM.1H({1P:8w,6b:1v})}1i{m5.1H(1v)}}$.2e(9i,1a(1S,8w){m0.1H(8w)});$.2e(kM,1a(1S,1v){me.i8({1C:1v.1P},1v.6b,1m)});$.2e(m5,1a(1S,1v){QB.1d.2d.uh(1v,1m)});$.2e(m0,1a(1S,1v){me.d0({1C:1v})})};J.zN=1a(lV,1g,d5){if(!1M(lV.jd[d5])){1g=yT(lV.cC,1g);46 lV.jd[d5]}if(!4D.84(lV.jd).1e){1g=yT(lV.cC,1g)}1b 1g};J.AE=1a(e,1g,d5){K 1W=J.zN(QB.1d.5k.nF.2d,1g,d5);if(1W==1c){1b}J.PJ(1W.gM);J.PP(1W.7r);if(1W.ug!=1c){QB.1d.2d.PO(1W.ug.dV)}if($("#qb-ui-1W").is(":5X")){QB.1d.2d.dm()}};J.Qf=1a(e,al){if(J.al!=1c){J.al.PE(al)}};J.Qd=1a(e,d4){K me=J;if(1M(d4)){1b}J.iO=d4;if(J.iq!=1c){J.iq.zm(J.iO)}if(J.al!=1c){J.al.PD(J.iO)}};J.QO=1a(e,1Q){if(J.2d!=1c){J.2d.gb(1Q.2d);J.2d.PC(1Q.PH);J.2d.PF(1Q.d9,1Q.PX)}J.3A.8y("gb",1Q.2H);J.gb(1Q.lB,"#qb-ui-1W-fG-nT-3z");J.gb(1Q.eU,"#qb-ui-1W-9k-nT-3z")};J.QH=1a(e,ub){if(ub==1c){1b}K me=J;K tO=0;if(J.bH.1e>0){tO=J.bH[J.bH.1e-1].Id}1o(K 1S=0;1S<ub.2W.1e;1S++){K 9P=ub.2W[1S];if(tO==1c||9P.Id>tO){J.bH.1H(9P);K zB="Uq";if(9P.4P==2){zB="Ur"}if(9P.4P==3){zB="9R"}K Um=tM(9P.zO).6W("H:i:s")}}};J.zS=1a(e,1g,d5){if(1g==1c||1g.bk==1c){1b}K 3A=J.zN(QB.1d.5k.nF.2H,1g,d5);if(3A==1c){1b}K me=J;me.3A.8y("Q1",3A);me.3A.8y("Q0")};J.QP=1a(e,aa){if(7F(e)=="4i"&&aa===2p){aa=e}if(aa!==" "&&1M(aa)){1b}J.bE.2c(aa);J.tL=aa;J.lP=aa};J.Qk=1a(e,ad){if(1M(ad)){1b}if(J.7I==1c){1b}J.7I.lO(ad)};J.Ux=1a(1V){J.zk(1a(1g){if(1V&&7F(1V)=="1a"){1V(1g.fZ)}})};J.WA=1a(1y,1V){QB.1d.2o.3Y.fZ=1y;1b QB.1d.2o.tK(1V)};J.PB=1a(Pk,Pn){};J.yX=1a(e,1g){K 1G=1g.1G;K 1q=1g.1q;K 5H=1g.5H;K 4b=1g.4b;K 3c=[];K 4C=1G.1P();4C.Pm=1g.gm;4C.zo=1q;4C.zn=4b;if(1G.87){K 3f=4C.9f;if(!1M(3f)&&3f.51(".")!=-1){K 8L=3f.7l(0,3f.51("."));K 9j=3f.7l(3f.51(".")+1);K 1B=QB.1d.2d.mk(8L);if(1B!=1c){1B.6E("lM",9j,1j)}}}3x(1q){1p 1R.2i.1U:K 3f=4C.9f;if(!1M(3f)&&3f.51(".")!=-1){K 8L=3f.7l(0,3f.51("."));K 9j=3f.7l(3f.51(".")+1);K 1B=QB.1d.2d.mk(8L);if(1B!=1c){1B.6E("lM",9j,4b)}}3c.1H(4C);1r;1p 1R.2i.3f:K 1U=4C.cu;if(1M(5H)&&5H!=4b){1U=1m;4C.cu=1m}K 3f=5H;if(!1M(3f)&&3f.51(".")!=-1){K 8L=3f.7l(0,3f.51("."));K 9j=3f.7l(3f.51(".")+1);K 1B=QB.1d.2d.mk(8L);if(1B!=1c){1B.6E("lM",9j,1j)}}3f=4b;if(1U&&(!1M(3f)&&3f.51(".")!=-1)){K 8L=3f.7l(0,3f.51("."));K 9j=3f.7l(3f.51(".")+1);K 1B=QB.1d.2d.mk(8L);if(1B!=1c){1B.6E("lM",9j,1U)}}3c.1H(4C);1r;1p 1R.2i.9o:;1p 1R.2i.7e:K zq=J.3A.8y("Pf");1o(K i=0;i<zq.1e;i++){3c.1H(zq[i].1P())}1r;5v:3c.1H(4C)}QB.1d.2o.mh(3c);QB.1d.2o.5y()};J.zp=1a(7d){if(7d==1c||7d.1e==0){1b 1c}K 1F={};K 5h;1o(K i=0;i<7d.1e;i++){5h=7d[i];if(5h.45!=1c&&5h.45.7l(0,1)=="-"){1F[5h.dF]=5h.45}1i{1F[5h.dF]={1x:5h.45,3C:5h.dF,1F:J.zp(5h.2W),1g:5h.3m}}}1b 1F};J.gb=1a(1Q,5K){K me=J;if(1M(1Q)||1Q.2W.1e==0){1b}K 1F=J.zp(1Q.2W);K $5K=$(5K);if($5K.1e>0){$5K[0].Pw=0}$5K.3z().1l("Pw",0).8k(1a(e){if(e.3V==13||e.3V==32){$(e.3e).1O("3R")}});$.2G("5M",5K);$.2G({3X:5K,4w:cK,6R:{5b:0},1V:1a(3O,1w){K 1h=1c;7a{1h=1w.$1U.1g().2G.1F[3O]}7b(e){}6K(1a(){me.yW(J,{3O:3O,1h:1h})},0)},1F:1F});$5K.3R(1a(){$(5K).2G();$1Q=$(5K).2G("1f");if($1Q){$1Q.2K({my:"1Z 1L",at:"1Z 4p",of:J})}})};J.WY=1a(1V){if(J.7I.lD()){J.7I.5y(1V);1b 1m}1i{1b 1j}};J.Ps=1a(1V){QB.1d.2o.5y(1V)};J.VP=1a(1V){J.tY(QB.1d.2o.lE);QB.1d.2o.3Y.d8=QB.1d.2o.lE;QB.1d.2o.5y(1V)};J.VQ=1a(1V){QB.1d.2o.3Y.7I=1c;QB.1d.2o.5y(1V)};J.zH=1a(1V){J.zl();QB.1d.2o.5y(1V)};J.zk=1a(1V){K me=J;if(J.aS<0){J.aS=0}if(J.aS>0){6K(1a(){me.zk(1V)},100);1b}J.zH(1V)};J.85=1a(1V){QB.1d.2o.85(1V)};J.iJ=1a(1V){QB.1d.2o.iJ(1V)};J.8h=1a(){mX=!($(".iS").1l("mX")===2p);if(!mX){J.Qx()}QB.1d.2o.cf=$(".iS").1l("cf");Q2=$(".iS").1l("Qy")=="1m";J.mK=$(".iS").1l("mK")=="1m";K zv=$(".iS").1l("VS");if(!1M(zv)){tU=zv}J.tR=$("#qb-ui-1W").4L("tR");K me=J;J.bH=[];J.bL=1j;if(!J.mK){$.fV(tU+"?3O=VA",tT,1a(1g){})}J.ab=$("#qb-ui-bE-VK-VG");J.3A=$("#qb-ui-3A").8y();J.2d=QB.1d.2d.8h();J.1W=J.2d!=1c?J.2d.1W:1c;J.4e=1T QB.1d.7v;J.iq=1c;J.al=1c;if(QF){J.iq=1T QB.1d.mI;J.al=1T QB.1d.9F}if(J.iq!=1c){J.QK=J.iq.zm();J.QK.4O(QB.1d.mI.2k.wk,J.eR,J)}if(J.al!=1c){J.al.3g.4O(QB.1d.9F.2k.wq,J.eR,J);J.al.3g.4O(QB.1d.9F.2k.wn,J.QI,J)}J.zD=J.4e.Qr();J.zD.4O(QB.1d.7v.2k.wv,J.Qb,J);J.bE=$("#qb-ui-bE 8c");J.bE.4O("zE",J.Qe,J);$("#qb-ui-bE-9V-fV").4O("3R",J.zH,J);$("#qb-ui-bE-9V-iJ").4O("3R",1a(){QB.1d.2o.iJ()},J);if(J.1W!=1c){J.1W.4O(QB.1d.2d.2k.vM,J.mN,J);J.1W.4O(QB.1d.2d.2k.vN,J.zb,J);J.1W.4O(QB.1d.2d.2k.vL,J.Q5,J);J.1W.4O(QB.1d.2d.2k.vK,J.yZ,J);J.1W.4O(QB.1d.2d.2k.vR,J.yW,J);$("#qb-ui-1W-7T").4O(QB.1d.2d.cg.2k.o0,J.Q4,J)}J.3A.4O(QB.1d.2H.2k.fC,J.yX,J);J.3A.4O(QB.1d.2H.2k.yJ,J.Q3,J);J.3A.4O(QB.1d.2H.2k.yO,J.Q7,J);J.3A.4O(QB.1d.2H.2k.vB,J.zb,J);J.3A.4O(QB.1d.2H.2k.vC,J.yZ,J);J.Q6=$.hJ(J.Qn,nk,J);J.7I=1T QB.1d.7I;QB.1d.2o.cU.2O(QB.1d.2o.cU.2k.6U,J.Qp,J);QB.1d.2o.9F.2O(QB.1d.2o.9F.2k.6U,J.Qf,J);QB.1d.2o.2H.2O(QB.1d.2o.2H.2k.6U,J.zS,J);QB.1d.2o.2d.2O(QB.1d.2o.2d.2k.6U,J.AE,J);QB.1d.2o.7I.2O(QB.1d.2o.7I.2k.6U,J.Qk,J);QB.1d.2o.2O(QB.1d.2o.2k.vD,J.Qd,J);QB.1d.2o.2O(QB.1d.2o.2k.vE,J.QH,J);QB.1d.2o.2O(QB.1d.2o.2k.wb,J.QO,J);QB.1d.2o.2O(QB.1d.2o.2k.wg,J.QP,J);QB.1d.2o.cU.2O(QB.1d.2o.2k.w6,1a(e,1g){J.vY(QB.1d.29.4J.57.QQ)},J);QB.1d.2o.2O(QB.1d.2o.2k.6U,1a(e,1g){if(1M(1g)){1b}J.vZ=1j;J.dC=1g.dC;if(!1M(1g.9H)){J.9H=1g.9H}if(!1M(1g.fZ)){J.fZ=1g.fZ}if(!1M(1g.9O)){J.9O=1g.9O;if(!1M(1g.9O.QL)&&!1g.9O.QL){$("#qb-ui-1W-fG-A0-Qv").3S()}if(!1M(1g.9O.QM)&&!1g.9O.QM){$("#qb-ui-1W-fG-Sm-Qv").3S()}me.3A.8y("Qw")}if(!1M(1g.i4)){J.i4=1g.i4}J.ab.4o("9K 9s wt");J.ab.2y(1g.lw.6n);J.ab.3F("");J.ab.3F(1g.lw.aj)},J);QB.1d.2o.cU.2O(QB.1d.2o.cU.2k.mg,1a(e,1g){K Ao=$("#dE-7N",1N.2N.3s);if(Ao.1e){Ao.3S()}},J)};J.f6=1a(7o){1b 6p(7o.3l(/(\\.|^)(\\d)(?=\\.|$)/g,"$10$2").3l(/(\\d+)\\.(?:(\\d+)\\.*)/,"$1.$2"))};J.Qx=1a(){if($(".iS").1e==0){1b}if(7F(Qt)=="2p"){eL(QC)}if(!($&&($.fn&&$.fn.eN))){eL(xb)}if(!($&&($.fn&&$.fn.eN))){eL(xb)}1i{if(J.f6($.fn.eN)<J.f6(wW)||J.f6($.fn.eN)>J.f6(Pp)){eL(PA.3l("$1",$.fn.eN).3l("$2",wW))}}if(!($&&($.ui&&$.ui.6c))){eL(Pv)}1i{if(J.f6($.ui.6c)<J.f6(ww)||J.f6($.ui.6c)>J.f6(Ph)){eL(Pe.3l("$1",$.ui.6c).3l("$2",ww))}}if($&&($.fn&&$.fn.eN)){if($.fn.cE===2p){eL(PU)}}}};QB.1d.SC={PW:"PW",PY:"PY"};if(!3n.c7){3n.c7={}}if(!3n.c7.ld){3n.c7.ld=1a(){}}if(!3n.c7.wO){3n.c7.wO=1a(){}}K pR;K l4=1c;K wf=0;1a wK(){if(wf==1c){wf=0}1b wf++}2A(2N).Te(1a(){QB.1d.5k=1T 5k;QB.1d.5k.8h();pR=QB.1d.5k;PG();pR.QT()});$.ui.7c.2V.SQ=1a(1I,vQ){J.2K=J.R7(1I);J.Rc=J.Rd("6F");if(J.1w.xx){if(J.1w.5m){J.1w.5m()}}1i{if(!vQ){K ui=J.eH();if(J.8v("5m",1I,ui)===1j){J.Ri({});1b 1j}J.2K=ui.2K}}if(!J.1w.aA||J.1w.aA!="y"){J.4B[0].2l.1Z=J.2K.1Z+"px"}if(!J.1w.aA||J.1w.aA!="x"){J.4B[0].2l.1L=J.2K.1L+"px"}if($.ui.f9){$.ui.f9.5m(J,1I)}1b 1j};$.ui.7c.2V.TL=1a(1I,vQ){if(J.TC){J.2n.1N=J.TF()}J.2K=J.R7(1I,1m);J.Rc=J.Rd("6F");if(J.1w.xx){if(J.1w.5m){J.1w.5m()}}1i{if(!vQ){K ui=J.eH();if(J.8v("5m",1I,ui)===1j){J.Ri({});1b 1j}J.2K=ui.2K}}J.4B[0].2l.1Z=J.2K.1Z+"px";J.4B[0].2l.1L=J.2K.1L+"px";if($.ui.f9){$.ui.f9.5m(J,1I)}1b 1j};2A.fn.SA=1a(ao){K 1f=J;if(!1f){1b}K 3e=$(1f);if(3e.is(":5X")==1j){1b 1j}ao=$(ao||3n);K 1L=ao.4T();K b4=1L+ao.1s();K y0=3e.2n().1L;K Rh=y0+3e.1s();1b Rh<=b4&&y0>=1L};1a S8($9z){K kK=$(3n).4T(),og=kK+$(3n).1s(),1L=$9z.2n().1L,4p=1L+$9z.7k(1m);1b 1L>kK&&1L<og||(4p>kK&&4p<og||(kK>=1L&&kK<=4p||og>=1L&&og<=4p))}1a Ru(1f){K 2n=0;43(1f){2n+=1f["8V"];1f=1f.eg}1b 2n}K RC=1a(el,RF){K 1L=el.ol().1L,4q,el=el.3r;do{4q=el.ol();if(1L<=4q.4p===1j){1b 1j}if(el==RF){1b 1m}el=el.3r}43(el!=2N.3s);1b 1L<=2N.8m.oq};1a Sh(ws){if(!ws){1b 1j}K wG=Ru(ws);K Rv=wG+ws.8z;K p9=0;if(2N.8m.4T){p9=2N.8m.4T}1i{p9=2N.3s.4T}K Mv=p9+3n.wx;1b Rv>=p9&&wG<=Mv};',62,4116,'|||||||||||||||||||||||||||||||||||||||||||||this|var||||||||||||||||||||||||||function|return|null|Web|length|element|data|item|else|false|width|attr|true|value|for|case|key|break|height||node|obj|options|name|params|type|res|table|object|opt||items|row|push|event|result|path|top|isEmpty|parent|trigger|dto|menu|MetaData|index|new|selected|callback|canvas|_|link|left|||||||||stroke|Dto|text|fill|val|Canvas|each|input|find|attrs|FieldParamType|args|Events|style|field|offset|Core|undefined|out|root|typeof|arguments|select|call|self|nbsp|addClass||jQuery|span|class|from|div|paper|contextMenu|Grid|css|disabled|position|context|anim|document|bind|that|values|opacity|start|font|Enum|prototype|Items|settings|append|option||eve|||||||||doc|focus|rows|bbox|target|expression|control|apply|elproto|none|match|replace|Guid|window|Math|next|selectmenu|parentNode|body|has|toString|remove|split|switch|dialog|button|grid|color|icon|Array|clr|html|pos|prev|concat|slice|label|math|size|toLowerCase|action|toFloat|appendChild|click|hide|checked|transform|keyCode|rgb|selector|ExchangeObject|array||gradient|Utils|while|get|Name|delete|max||elem|first|newValue|svg|Str|tree|method|end|raphael|string|abs|src|container|tableDnD|extend|removeClass|bottom|rect|preventDefault|arg|resizable|display|metaDataObject|zIndex|deg|hitarea|animate|Parent|helper|rowDto|Object|appendTo|diff|toFixed|filter|scrollLeft|Localizer|links|hasClass|events|matrix|bindEx|Type|arrows|round|_engine|scrollTop|Left|list|builder|criteria|box|handle||indexOf||join|Right||add|Strings|url|CLASSES|mmax|duration|blur|href|constructor|animationElements|state|dtoItem|show|contextmenu|Application|newIndex|drag|win|removed|dots|column|fields|resize|splice|separator|default|String|pathArray|sendDataToServer||Date|rotate|rowChanged|prop|cell|current|set|oldValue|stop|close|menuSelector|not|destroy|aria|len|p1x|cells|parseInt|hidden|auto|min|Fields|easing|visible|vml|_editControl||textControl|Objects|Criteria|wrapper|columnWidths|pow|tbody|Value1|mdo|children|existingObject|version|mmin|clone|newelement|c1x|clip|tabindex|c1y|KindOfField|count|p1y|Class|title|Number|Caption|layer|TempId|hex|paperproto|tagName|minHeight|_key|uiDialog|point|mouseup|graphics|block|all|qbtable|absolute|ConditionOperator|CriteriaBuilderConditionOperator|att|status|setTimeout|Column|editControl|getBBox|config|TableObject|hover|animation|http|zoom|DataReceived|condition|format|now|IsNew|operation|NameStr|dot|subQueries|setproto|temp||open|pageX|bbox1|bbox2|try|catch|draggable|menuItems|sortingOrder|__set__|implement|insertBefore|last|c2y|outerHeight|substr|ValueKinds|c2x|str|getValue|header|Links|Value2|mousedown|guid|Tree|right|p2y|newObject|angle|lineCoord|pageY|removeChild|linkDto|_parent|typeOf|p2x|names|CriteriaBuilder|scale|hasOwnProperty|currentTrigger|Operator|overlay|ValuesCount|scroll|_g|dataSource|Visible|graph|pth|create|crp|handler|subElement|firstChild|JoinType|dragi|buildElement|ret|keys|update|styles|IsDeleted|stopPropagation|dirty|SQL|currentTarget|textarea|unbind|columns|checkbox|targ|init|setValue|cache|keydown|widget|documentElement|DrawOrder|selectOptionData|percents|_ulwrapdiv|outerWidth|_editBlock|command|path2|_trigger|newDatasourceDto|tmp|QBGrid|offsetHeight|nodeName|colspan|family|_optionLis|skew|sin|vector|offsetLeft|pathString|existing|selectDto|tableName|radio|cellName|build|toUpperCase|360|Alias|containment|destX|throw|offsetTop|customAttributes|active|bez1|bez2||par|colgroup|matches|tabbable|bg_iframe|test||found||hasScrollY|toggleClass|Index|buttons|timer|Expression|face|rad|newObjects|fieldName|subquery|cos|forEach|image|sorting|touch|1E3|coordinates|error|ctx|red|matrixproto|dasharray|unionSubQuery|circle|ele|currentLayout|maxHeight|All|objectBorder|existingLink|NavBar|JunctionType|QueryProperties|caller|mooType|warning|cellIndex|menus|FieldGuid|SyntaxProviderData|msg|namespace|Error|contextMenuRoot|Function|jPag|controls|path1|mousemove|RequestID|weight|Element||||EditableSelectStatic|dragObject|headerCell|amt|valueElement1|scrollable|sql|statusBar|colour|criteriaBuilder|minWidth|SmartPush|elements|JunctionItemType|selects|Text||navBar|||scope|scrollY|trg||||el2|proxy||||wrapperId|axis|toInt|sqrt|hasChanges|setAttribute|isArray|ConditionSubQueries|con|tt1|ExpressionSubQueries|tstr|Condition|blue|clear|arrow|source|isFunction|percent|Lock|parents|corner|className|u2008|u1680|u180e|u2007|u2009|x20|x0d|xa0|bot|u2005|alias|clientX|thead|u2004|u2001||u2000|u2003||u2002||x0c|clientY|u2028|Rows|u3000|u2006|continue|methods|u2029|charAt||x0a|x09|hoveract|x0b|navigator|||green|u205f|u200a|u202f|meshX|editor|addEventListener|icons|Messages|_value|hasExpressionBuilder|headerCells|loaded|fit|meshY|ellipse|cnvs|namespaces|Raphael|map|expandable|line|currentTable|fieldsContainer|selectedIndex|Extends|define|shift|||markerCounter|createElement|_cellEditEnd|number|console|inFocus|addArrow|||defaults|subkey||SessionID|Link|tableDnDConfig|||thisObject|dialogId|counter|checkTrigger||getPath|parseFloat|cacher|||Select|content|group|||initialize|getTotalLength|editable|Data|current_value|valEx|valueHTML|collapsable|total|border|pathClone|6E3|glow|_selectedOptionLi|Prefix|overflow|isNaN|getRGB|offsetWidth|maxWidth|instances|MetadataTree|Action|order|expand|pattern|hasScroll|addObject|defaultWidth||toggle|queryStructure|requestID|fillpos|queue|ActiveUnionSubQuery|Table|Inner|itemsPageSize|instanceof||000||linecap|DatasourceGuid|||eventName|Postfix|redraw|empty||shape|droppable|textpath|180|img|createNode|getElementsByTagName|groupingCriterion|||aggregate|SVG|direction|SyntaxProviderName|times|iframe|Key|token|previous|stopImmediatePropagation|grouping|isInput|defs|listeners|filtredItems|_events|fonts|alpha|_drag|off|change|linkBox|Active|move|down|Outer|nextIndex|tolerance|Server|ActiveDatabaseSoftware|pop|support|matchDatasourceDto|over|RegExp|floor|optionDto|tlen|scrollTo|rec|xlink|marker||offsetParent|getKeyName|currentPage|setFillAndStroke|attrs2||||editableSelectOverlay|200||_viewBlock||ids|Animation||Value1IsValid|cssClass|titleBar|fontSize|factory|titlebar|originalEvent|tt2||JSON|valueNumber|_uiHash|cssText|isEnd|tableBox|alert|scrollX|jquery|visibleMenu|force|IsSelected|onTreeStructureClick|reset|Aggregate|Add|pathi|UnionSubQuery|wait|hasSubQuery|SortType|BeforeCustomEditCell|||getNextTabbable|hover_css|a_css|versionToNumber|round1000|results|ddmanager|getTimezoneOffset|getPrevTabbable|Width|255|bgiframe|Matrix|to2|docElem|trueIndex|sib|defaultHeight|dialogs|time||json|Cancel|inver|CriteriaBuilderItemType|linkedObject|attachEvent|getElementById|_getWidth|properties|||easyeasy|myAt|mouseout|GridOnRowChanged|scaley|headerRow|UseCustomExpressionBuilder|navbar|methodname|insertAfter|handles|resized_widths|property3|activeItem|_moveFocus|selectElement|userAgent|property2|property1|valueElement2||marked|refresh|getDate|precision|updateTable|QueryParams|Delete|milli|intr|shrink|filtered|GridRow|curr|attrType|obj1|simulateMouseEvent|justCount|updateContextMenu|visibility|isResizable|scalex|glyphs|additionalItems|updateElement||scrollHeight|check|computedStyle|afterCustomEdit|setViewBox|overloadSetter|getComputedStyle|obj2|_isNullorUndefined|thisLi||Height|Unknown|isDropDown|objectGuid|Not|LinkExpression|origin|Numeric|realPath|longclick|oRec|guidHash|pRec|margin|bb2|keyStop|classes|tspan|DataSources|strcmp|getHours|accesskeys|bb1|filteredUi|dirtyT|substring|_viewBox|ContextMenu|paths|redrawT|animated|Value2IsValid|getRec|userEdit|curve|sort|translate|innerSize|delay|oldObj|onSelect|isURL|_getTotalWidthStatic|Field|enumerables|updateContextMenuItems|instantEdit|Rapha|VisiblePaginationLinksCount|QBWebCoreBindable|base|minContentHeight|iLen||AffectedColumns|editEnd|recursive|selecter|VML|||u00ebl|originalSize|_global_timer_|listWrap|||shear|list_is_visible|closest|location|dropdown|_typeAhead_chars|parentObject|fun|toJSON|fillString|debounce|widths|totalOrigin|resizeSensor|isInAnim|vbs|pathId|use|getDto|collapsed|CssClass|markerId|isVisible|path2curve|from2|keypress|prevItem|nextItem|||branches|QueryTransformerSQL|CriteriaBuilderJunctionItemType|dialogTarget|replaceClass|updateObject|newClass|indexed|thefont|_ul||role|||isPointInside||fontcopy|attributes|pane|Actions||_getInnerTable|skipEvents|treeStructure|nextSibling|||removeRow|buffer|subItem||module|markedMeshCells|ObjectType|onload|objectType|strings|__args|QueryStructureContainer|linejoin|getFormat|_setWidth|reconnect|fillsize|orColumnCount|tspans|Grouping|QueryStructure||jsp|optionClasses|QueryBuilderControl|with|bezlen|opts|Supported|eldata|tryAddEmptyRow|relative|touches|dstyle|col|sub|updateTableHeader|globalFieldDragHelper|mousePos|mouseover|ceil|lastExpandable|lastCollapsable|cur|equal|Requests|goto|selectable|contains|current_event|None||itemsListIncomplete|currentRow|asterisk|_getHeaderCells|newsize|_moveSelection|parentElement|background_color||triangle|dragMaxX|activeID|text_hover_color|random|headerWidth|removeByIndex|Selects|tfoot|getSelectedListItem|propSize|treeview|newf|isActive|Filter|dj1|di1|_getHeaderRow|background|innerHTML|popup|text_color|rowId|clearTimeout|glob|proto|percentScrolled|contentWidth|draw|lastHeight|resizedAttached|dto2|activeClass|dto1|metadata|getListValue|globalIndex|newObj|titleBarText|innerTableTbody|bodyCell|Properties|_setTableWidth|resizeT|_getBodyFirstRowCells|innerTable|which|setSize|TString|doNotGenerateEvent|destY|resizeLock|isOpen||scrollWidth|updateFields|types|hook|hooks|updateRowControl|updateCount|DataSource|addOrUpdateRow|NameInQuery|DOMload|move_scope|||strConversion|fltr|deleting|valueB|valueA|startString|__pad|letters|subQuery|reposition|linkMenuCallback|lBound|canvasDatasourceDto|objectsToUpdate|clientLeft|dataSources|skipEvent|wrongRow|defaultView|tableBody|syncTable|instance|appendBefore|clientTop|SortOrder|valueElement|showEditor|runAnimation|||joinType|globalTempLink|butt|JunctionPostfix|textpathStyle|removeAttr|initstatus|getButtonContextMenuItems|repeat|toLower|log|appendElement|prepend|stops|endString||the|replaceChars||related|cursor|callbacks|__getType|getMonth|Move|safari||toggler|Boolean|Message|built|background_hover_color|Set|currentValue|CTE|_path2string|isValid|RootQuery|fff|1px|keyToUpdate|9999em|GridRowCell|coordorigin|sweep_flag|checkField|list_item|importData|ClientSQL|rvml|seg2|vals|seg|_availableAttrs|pendingObject|mouseProto|flip|inputLabel|updateTabindex|objectsToAdd|||||objectsToRemove|touchHandled|day|arglen|UpdateGuids|totalWidth|_refreshValue|setCoords|month||initialized|Loaded|updateGridRows|getString|_disabled|findTableByName|getPaddingString|nodes|setDto|query|and|getPaddingLength|isAlternate||columnCount|invert|AllowJoinTypeChanging|maxWidths|||fieldsHtml|itemHtml|ShowPrefixes|RootJunctionPrefix|minWidths|refX|itemsHtml|PreviousItem|miterlimit|TreeStructure|_getBBox|DisableSessionKeeper|findDotsAtSegment|LinkedObjects|onAddTableToCanvas|hours|original|minutes|buttonLink|finite|arr|removeEventListener|_focusedOptionLi|seconds|suppressConfigurationWarning|__def_precision|linear|fullUpdate|||updateExpressionControl|ExchangeTreeDto|menuWidth|dis|_divwrapright|bgImage|TableObjectOnLinkCreate|TableObjectOnCheckField|numPerPage|TableObjectOnLinkedObjectSelected|||TableObjectOnSubqueryClick|notfirst|showFields|Copy|ToDelete|500|newWidths|step|getSubpath||currentTotal|_removedFactory|padding||||CreateLink||||deltaY|selobj|paneWidth|mdoFromTable|_removeGraph|configEnds|pendingChanges|_obj|RightToLeft|parentOptGroup|collision|readyState|_hasScrollY|selectedpage|Direction|handlers|every|_typeAhead_cycling|brect|typeahead|plus|deltaX|mdoToTable|clientWidth|scrollTimeout|dirY|dirX|CanvasLinkOnChanged|||glyph|Options|_typeAhead_timer|schema|stretch|addGradientFill|matchee|parentSelector|touchMap|shiftKey|cellspacing|cellpadding||uBound||cancel|dragHandle|_vbSize|getBoundingClientRect|clrToString||itemsPagePreload||clientHeight||forValues|boolean|_create|deleted||longClickContextMenu|toHex|primary|onDragStart|abortevent|classic|rectPath|Pos|rem|CurrentEditCell|mouseenter|outerWidthDiff|trim|addEvent||postprocessor|setInterval|mouseleave|_hasContext|bod|_13|centercol|maxZ|Path|binded|py2|_23|edit|lowerCase|onChange|||||dim|items_then_scroll|y2m|x1m|visibleTop||x2m|y1m|_minHeight|seg2len|tear|showList|paramCounts||||getColor|||hsb2rgb||_position|tdata||seglen|findDotAtSegment|list_height|nonContentHeight|||px2|Sorting|_setOption|pcom|l2c|www|IsEqualTo|optionsNameColumnOptions|fieldsTable|getPointAtLength|itemsCount|epsilon|serverSideFilter|contentW|onDragClass|touchend|subpaths|PrimaryKey|application|touchmove|funcs|optionsMarkColumnOptions|touchstart|_pathToAbsolute|layout|CriteriaBuilderItem|prevComputedStyle|Any|GetPropertyDialog|ActiveQueryBuilder2|swapClass|ActiveQueryBuilder|Models|ValueKind|validateValue|updatePosition|clipRect|Child||400|solid|Value|timestamp|DescriptionColumnOptions|showGrouping|scrollAmount|groupColumns|_createTitleButton|elementFromPoint|NameNotQuoted|yOffset|rowItems|_blur|setAttributeNS|start_scope|supportsTouch|removeData|fieldValue|mapPath|Yet|||getFullYear|relatedTarget|testRow|createUUID|conditionOr1|bboxwt|_isOpen|oldt|diamond|fillSelects|ItemsCount|dif|ShowLoadingItems|oval|reduce|sbwidth|interHelper|unwrap|_path2curve|Loading|itemsElement|delta|parentItem|localIndex|_left|_setTableHeaderWidth|filterRegExp|itemIndex|resizable_params|paginate|are|ItemsStart|org|needFilter|_setTableBodyWidth|radial|_top|clrs|inArray|||toff|identifier||dontEnums|exports|f_out|both|ActiveXObject|ownerDocument|f_in|Dim||getPointAtSegmentLength|pathDimensions|subpath|getLengthFactory|getDay||hits|||propertyIsEnumerable|end_scope|dragMove|itemsArray|dragUp|docum|ry2|rx2|1e12|sleep|denominator|dots1|001|interPathHelper|xmin|dots2|ymin|changed|targetTouches|TypeError|The|commaSpaces|POST|norm|parseTransformString|hsl2rgb|asin|delayedSend|||lineHeight|fontName|line_spacing|letter_spacing|ShowPropertyDialog|normal|newWidth|colCell|strong|_getColgroupCells|typeMismatch||coordsize|renderfix|initWin|lastI|bbx|mdoTo|idx|transformPath|getBoxToParent|||mdoFrom||oldRaphael||collector|curChar||||returnStr||oldGuid|lastWidth|updateGuidHash|toColour|nes|getSubpathsAtLength|upto255|availableAnimAttrs|frame|thisArg|QBWebCoreGridResizeLock|tail|xi1|||yi1|browser|childNodes|del|isInAnimSet|OnApplicationReadyHandlers|selectOptions|needInvoke|Description|insidewidth|||||NameStrNotQuoted|sortBy|dragObj|iconClass|UseLongDescription|timeout||gridRows|findRowsByExpression||droppedRow|gridItemDto|rowHeight||800|highlight|rowY|getPosition|plusButton|CriteriaBuilderItemPlus||parse|||clearInterval||after|o2t|1E5|margins|o1t|mouseOffset|structureItem|parentGuid|oldY|onFieldCheck|loading|before|getPrecision|getKey|leftcol|small|sendDataToServerWithLock|hiddenSQL|eval|_outer|lastId|rightcol|buttonSubquery|DisableLinkedObjectsButton|optGroupName|300|QBHandlers|_safemouseup|thisAAttr|Disabled|ChangeActiveUnionSubquery|_fired_|UpdateLink|getByGuid|cursorWait|removeAllMarked|5E3|DoAction|ie7|autoOpen|markAllForDelete|selectmenuId|DenyLinkManipulations|messages|altKey|thumbs_mouse_interval|ver|FieldName|Layout|removeObject||overlays|selectListItem||result4||UseCustomExpressionBuilderServerEvents||_cellEditStart|result3|srcAlias|itemMouseenter|result2|result1|Output|editableSelectControl|commands|_name|newShowGrouping|wrappers|nextcommand|Event|specified|GridRowCellOnChanged|hoverClass|isEqual|generateEvent|QuickFilterInExpressionMatchFromBeginning|GroupingCriterion|_importDto|blockFocus|inputs|menuItem|getMatchItems|rowIsEmpty|cellNameKey|ActiveUnionSubqueryGuid|disable|objectOptions|GetUID|onDrop|checkScroll|TypedObject|fillDtoItems|fillDto|Group|datepicker|invalid|ConditionIsValid|enter|CriteriaBuilderItemGroup|conditions|contextMenuCallback|Columns|general||hideList|getButtonContextMenuItemsMove|NotAll|getJoinPrefix|zin|itemdata|TableObjectOnDestroy|TableObjectOnMoved|ExpressionColumn|globalMenu|CriteriaItem|hovering|ConditionColumns|lastCollapsableHitarea|listIsVisible|lastExpandableHitarea|currentContext|iframeBlocks|TableObjectOnClose|TableObjectOnTrash|than|pickListItem|HideColumnMark|scrollToY|positionDragX|GridOnAddTable|GridOnAddTableField|QueryStructureChanged|MessagesReceived|isType|HideColumnName|scrollToX|parentTable|contentPositionX|CanvasOnAddTableField|CanvasOnTrashTable|CanvasOnAddTable|CanvasOnRemoveTable|positionDefault|filterChangeRoutine|noPropagation|CanvasContextMenuCommand|usePlural||TypeColumnOptions|currIndex|recIndex|bit|MessageInfo|editorChangesEnabled|_selectedIndex|flag|regex||protected|instanceOf|DataSending|retainFocus|klass|HideColumnDescription|HideColumnType|ContextMenuReceived|optionsDescriptionColumnOptions|fieldCheckbox|optionsTypeColumnOptions|GlobalTempId|SQLReceived|contentHeight|noop|positionDragY|TreeStructureSelectNode|buildItems|mouse|NavBarAction|child|itemMouseleave|NavBarBreadCrumbSelectNode|parameters|elt|information|_mouseInit|TreeDoubleClickNode|jQueryUIMinVersion|innerHeight|_preload|offsety|_ISURL|CriteriaBuilderItemDto|collapsableHitarea|ease|back|expandableHitarea|posTop|strokeColor|clmz|Microsoft|GetTempId|istotal|contextMenuActive|triggerAction|debug|extended|progid|elems|does|getEventPosition|cloneOf|dtoConditionSubQueriesLength|jQueryMinVersion|General|CriteriaBuilderItemGeneral|extractTransform|cookieId|||||csv|getOperatorObject|CriteriaBuilderItemGroupDto|conditionSubQueriesLength|texts|hexToRgb|errNoJQ|CriteriaBuilderItemGeneralDto|leading|square|ConditionType|applyClasses|Url|sampleCurveX|prepareBranches|IsNotInList|IsInList|prevIndex|closed|cookie|operator|pathes|stored||CriteriaBuilderItemRow|newAnim|LastItemId|toggleCallback|fastDrag||_reCreateEditBlock|tableValue|newRows|GotoSubquery|parts|limit|hasEmpty|hooksOf|prevcommand|amd|customEdit|AfterCustomEditCell|Widget|middle|lower|_last|rowToDelete|compensation|insert|contextMenuAutoHide|GridRowOnChanged|emptyRow|isFloating|scope_in|running|setRequestHeader|isWin|elTop|||||images|srcExpression|findRowsByDto|submenu|conditionOr|allEvents|accesskey|newpath|CriteriaType|mHide|isBBoxIntersect|drop|tableHeaderFixed|accept|mergeOne|GridBeforeCustomEditCell|triggerEvents|offsetx|x_y_w_h|called|onmove|keepColumnsTableWidth|onend||UpdateWrapper|srcUrl|onstart|generic|amp|contextMenuKey|opera|_getPath|protect|createTextNode|toLocaleString|desc|getPropertyValue|_init|param|was|GridOnAddRow|bbt|isSimple|isGrad|_touchMoved|GridOnRemoveRow|currval|outsidewidth|_rotright|_rotleft|mergeObj|dtoIsSimilar|dtoIsEqual|onCanvasContextMenuCommand|onGridRowChanged|GridRowDto|onAddTableFieldToCanvas|endUpdate|u2026||simulatedEvent|raphaelid|_oid|beginUpdate|MetadataObjectGuid|_extractTransform|applystyle|shifty|onRemoveObjectFromCanvas|updateSQL|onLinkCreate|onCheckFieldInTable|prepareSyncMetadata|onLinkedObjectSelected|border_hover_color|dir|cssDot|refreshSqlWithLock|prepareSyncSQL|buildTree|ChangedCellValue|ChangedCellIndex|generateContextMenuItems|allRows|_toback|xb0|_insertbefore|schedule|handlersPath|_click_|_rectPath|_tofront|annul|_Paper|msgType|exclude|treeControl|keyup|testWidth|border_color|refreshSql|test_interval|rgba|isLoaded|_fy|_fx|checkPending|DateTime|_getContainer|com|_tear|importGrid|relativeRec|getJunctionItemType|junctionType|ascending|dirtyattrs|addOption|selectedOptions|union|fieldContextMenuCallback|load|buildControlItems|quoteString|_escapeable|align|anchor|paused|CriteriaBuilderDto|OnApplicationReadyFlag|fixed|cross|bound|regexp|page|thatMethod|Clear|_params|rgbToHex|periodical|getAttribute|requestAnimFrame|_insertafter|iFrameOverlay|pass|newstroke|setColumn|actionAddItem|stopAnimation|prototyping|dashes|Mutators|MetadataObjectAdded|shortLeg|MetadataGuid|startD|tableObj|_parseDots|fxfy|importCanvas|outsidewidth_tmp|findTableByDataSourceGuid|sendDataToServerDelayed|per|units|calculateBox|invokeAsap||_radial_gradient|addDashes|endType|__arg|jQueryUI|pairs|detachEvent|todel|JavaScript|Actions1|endD|toExponential|__repr|thin|SqlErrorEventArgs|startType|blank|merge|childButton|pathValues|secondary|modal|createButton|_makeResizable|oldstop|linkNode|fieldElement|spanField|attachResizeEvent|one|t13|acces|atan2|t12|serializeRegexp|component|titleW|buildBreadcrumbElements|serialize|nodrop|draggedRow|newelementWrap|contentH|_makeDraggable|adjustWrapper|breadcrumbClick|Metadata||_isPositiveNonZeroInt|_parseWidth|highlightSelected|_toggle|tfoot_tr|sensor|styleChild|resized|optgroup|Remove|xbase|_toggleEnabled|ybase|obj1FieldName|bezierBBox|0px|wrap|horizontalDragPosition|sum|_blockFrames|_size|base3|MAX_CAPTION_LENGTH|_getHeaderCellsIndexTrue|_scrollPage|generateNavBarContextMenuItems|descriptionHtml|600|trimCaption|expandChild|serializeTable|isFirst|obj2FieldName|busy|optionsHtml|Checked|thead_tr|doScroll|GUID|getMouseOffset|nodeCount|Paper|mouseCoords|moveToTop|docPos|ellipsePath|View|structure|Schema|heightBeforeDrag|buildElements|makeDraggable|contentPositionY|paneHeight|_scale|newField|_grid|needResize|newFieldsCount|LongDescription|ShortDescription|FieldListSortType|TableObjectField|nogo|presentation|checkedFields|checkAllField|_syncColWidths|throttle|movingDown|_setBodyBounds|Database|FieldListOptions|HideAsteriskItem|UpdateConnection|_typeAhead|LinkPart|packageRGB|prepareRGB|maxH|subname|scrollByX|eventType|scrollBy|_isPositiveInt|wildcard|scrollByY|dispatchEvent|rgbtoString|Edit|bindItemsEvents|newwin|touchcancel|hadScroll_x|hasScroll_x|lastReturn|KeyFieldsFirst|newTotal|winH|UpdateObjects|finalTotal|setup|borderLeftWidth|_parseSize|borderTopWidth|Title|processPath|fixArc|fixM|colIndex|selectFirstListItem|viewBlock|NONE|currentSorting|global|li_value|li_text|_switchToView|_getColgroup|forGroup|needUpdate|database|||getNextEmptyPlaceRoutine_Test|updateHeaderCellWidth|Close|curveDim|dblclick|DisableLinkPropertiesDialog|newres|4E3|GetFullFieldName|DisableDatasourcePropertiesDialog|q2c|a2c|QueryGuid|pathToAbsolute|VisiblePaginationLinksCountAttr|data1|newDiff|onCellChanged|laspPagerScrollLeft|getEmpty|pathToRelative|fromCharCode|mag|success|expressionSubQueriesLength|dtoExpressionSubQueriesLength|normalize|_setColCellWidth|srcAggregate|complete|ajax|SQLError|AriaLabel|menuChildren|totalspan|_createEditBlock|toMatrix|list_item_height|SQLChanged|propertyName|SelectAllRowsFrom|lastScrollY|thisLiAttr|SQLUpdatedServerFlag|filtredItemsCount|UserDataReceived|150|EditableSelect|fieldIcon|0000|freeX1|topOffset|_refreshPosition|freeX2|disableSelection|selectNewListItem|applyFilter|editStart|parsePathString|updateCustomEditButton|GetWrapper|isPointInsideBBox|selectsDto|cRec|clearSelectedListItem|prependTo|currentSelect|buttonProperties|customEditButton|SelectOptionDto|optionsFixedColumnMode|ymax|newOptionClasses|UpdateValues|xmax|TableObjectOnUpdated|intersect|getControl|outerTbody|editableSelect|editableSelectInstances|buttonClose|parentOffset|DisableQueryPropertiesDialog|rel|MarkColumnOptions|domElement|_120|inited|targetId|alwaysScrollY|loadingItemsOverlay|freeY2|freeY1|FieldTypeName|upperCase|LoadDataByFilter|catmullRom2bezier|crz|NameColumnOptions|FixedColumnMode|_getOuterTbody|previousclass|_mousedown_|optionValue|cellOuterDiff|hasIcon|_contextmenu_|scheduled|endMarker|_touchcancel_|_touchmove_|_mouseout_|endPath|_touchend_|_touchstart_|sprevious|spreviousclass|_mousemove_|startPath|_mouseup_|_getResizeableParams|bVer|thisA|tbody_height|isEnumerable|methodsEnumerable|isFinite|lastIndexOf|nodeType|post_error|DEFAULT_HEADER_BORDERS|positionOptions|typeCheck|activedescendant|flatten|collection|_getHeight|clean|_initWidths|some|UID|currentOptionClasses|include|methodName|getHeaderCellByBodyCellIndexFiltered|getHTTPObject|_getBodyCellWidths|Content|_getBodyFirstRow|_getBodyAndHeaderCellWidths|acos|XMLHTTP|XMLHttpRequest|DXImageTransform|createSVGMatrix|outer|2000|trueWidth|Errors|error_alert|responseText|getHeaderCellByBodyCellIndex|aspectRatio|Line|preserveAspectRatio|changedTouches|code|refreshTimeout|_hasScroll|listH|simulatedType|getInstance|typeAhead|thisText|startdx|_on|markers|_touchEnd|_fn_click|startMarker|touch_enabled|_touchStart|handleWidth|_touchMove|_off|selectmenuIcon|attempt|cssrule|enable|owner|cannot|_createColGroup|sizing|_geInnerTableTbody|vis|tuneText|escapeHtml|Marker|_parseResizable|selectelement|_closeOthers|enddx|retain|_formatText|_parseScrollable|nodeValue|_parseColumns|snextclass|determinePosition|current_options_value|_cleanData|contextMenuShow|onTextboxChanged|maintain|backIn|comb|backOut|cleanData|70158|075|onlystart|pathBBox|you|autoShow|duplicateOptions|isWithoutTransform|aks|positionSubmenu|siblings|initInputEvents|autoHide|getTatLen|zindex|9041|7699|5873|availableAttrs|2491|9816|3678|1252|easing_formulas|toPath|equaliseTransform|real|2335|0472|1069|solveCurveX|Now|Cvalues|Tvalues|deserialize|sortByNumber|2032|1601|treeController|solve|isPointInsidePath|getMatchItemNext|scope_out|blurItem|adjustHeight|clearHighlightMatches|textContent|scrollToListItem|itemClick|inputClick|getMatchItemPrev|unselectListItem|focusItem|detacher|Inc|htmlMenuitem|olde|menuitem|shorter|vendor|fromMenu|maxlength|_f|preventTouch|stopTouch|htmlCommand|hasTypes|blurInput|unmouseup||nested|unmousemove|eventSelectstart|getElementByPoint|getOffset|getById|about|focusInput|pageYOffset|layerClick|EditableSelectWrapper|tan|hideMenu|initEvents|menuMouseleave|menuMouseenter|isEmptyObject|splitAccesskey|large_arc_flag|f2old|y2old|x2old|findDropTargetRow|DocumentTouch|onAllowDrop|Arial|1e9|Infinity|tableId|EventQueue|updateTables|onDropStyle|numsort|Elements|whitespace|compatMode|__formatToken|glowConfig|Argument|animateWith|isObject|__getInput|callee|getFont|windowHeight|shape2|onDragStyle|replacer|PAGE_DOWN|_divwrapleft|PAGE_UP|isFunc|tokenRegex|SPACE|TAB|snext|END|ENTER|nextclass|carat|DOWN|objNotationRegex|showArrow|serializeTables|currentStyle|formatrg|LEFT|RIGHT|HOME|hideArrow|quote|quotedName|adj|u00b0|initMouseEvent|screenX|setWidths|createEvent|hsla|hsrg|heightToggle|prerendered|hsba|colourRegExp|screenY|positionElements|tCommand|adjustWrapperSize|CubicBezierAtTime|bezierrg|heightHide|adjustWrapperPosition|hideOtherLists|hsl|hsb|pipe|pathCommand|16777216|_meta|uuidReplacer|charCodeAt|resume|removeOption|setWindow|stringify|arguments2Array|isnan|uuidRegEx|objectToString|year|rest|p2s|selectedValues|hsltoString|fireEvent|c1Elements|repush|rgb2hsb|range|pause|sel|rgb2hsl|hsbtoString|createRowControl|fillDefaultValues|isAsterisk|_exportDto|Container|tableDragConfig|parentObj|targetPlace|selection|aliases|_switchToEdit|will|able|9999|_createViewBlock|IsTrashed|ASC|_getCssClass|InsertSubQuery|rowSorter|toggleGroupColumn|updateSortingOrderColumn|reCreateEditBlock|generateHeaders|getRowHeaderList|CriteriaOr|allow|QBWebCore|findRowByDto|itemDto|oldIndex|getLastRowControl|fieldText|BeforeCustomEdit|RowChanged|typeName|onRowChanged|You|originalPosition|Sort|brackets|helperProportions|resizeHandles|resizeStop|offsetPosition|resizeStart|resizing|oldWidth|oldHeight|oldFieldsCount|Relations|trash|dragging|dragStop|saveScroll|dragStart|beforeclose|customExpressionEdit|EditExpression|AggregateList|suppressEnter|EditCondition|createCombinedButton|view|_createEditControl|ActionDto|_unblockFrames|From|Default|dialogClass|TableObjectOnCreate|showCustomEdit|escapeHTML|TableObjectOnLinkDelete|Editor|hasDontEnumBug|actionAddGeneral|actionClear|dontEnumsLength|isPrototypeOf|actionAddGroup|CriteriaBuilderItemRowDto|valueOf|__entityMap|createFromDto|onAfter|Tween|isPlainObject|TotalCount|actionMoveDown|actionDelete|isNumeric|actionMoveUp||operatorText|plusItem|setMonth|junctionTypeContextMenuCallback|getFieldsContextMenuItems|createButtonMenu|getMinutes|createOperationMenu|createFieldSelect|getSeconds|Invalid|Plus|operatorObj|proxyEx|Where|operationContextMenuCallback|getJunctionTypeContextMenuItems||getOperationContextMenuItems||getTime|propHooks|||triggerObject|clearSync|DoesNotContain|DoesNotEndWith|sendDataToServerDelayedWrapper|IsNotNull|IsLessThan|GetLinkExpression|IsNull|NeedRebindUserInit|findRowByExpression|getter|MultipleQueriesPerSession|StartsWith|EndsWith|DoesNotStartWith|data2|Contains|clearSyncDebounce|QBWebCoreCanvas|QBWebCoreNavBar|IsGreaterThanOrEqualTo|greater|IsBetween|visibleBottom|between|IsNotBetween|SubQueries|delayed|less|flush|IsLessThanOrEqualTo|sendDataToServerInternal|QBWebCoreCriteriaBuilder|QBWebCoreGrid|IsGreaterThan|QBWebCoreMetadataTree|reCreate|FieldCount|IsChanged|TreeSelectDto|SelectedValue|DataSourceLayoutDto|onObjectTrash|onObjectClose|getLayout|fieldGuid|localCount|recreateSelect|objX2|objX1|getNextEmptyPlaceRoutine_Fill|getEmptyPlaceCoord|selectsParent|getNextEmptyPlaceRoutine_Find_RTL|getNextEmptyPlaceRoutine_Find|objGuid|press|TryLoadItems|buildPager|laspPagerCount|needLoadItems|ItemsPerPage|PreloadedPagesCount|LoadDataByPager|showDescriptions|selectChange|ShowLoadingSelect|onObjectDestroy|HideLoadingItems|Time|elementParent|parentIndexId|selectDataRefresh|revert|objY1|removeByTableGuid|_getDto|findByTableGuid||DataSourceLinkDto|rightGuid|CanvasOnDropObject|createGraph|leftGuid|_setDto|getObjectHeader|getObjectFieldByName|LinkPropertiesForm|CreateConnection|getObjectFieldByGuid|DataSourceLinkPartDto|500px|getObjectByGuid|CopyInner|redrawD|propertyValue|ShowAllItemInGroupingSelectLists|IntoControls|showAllItemInGroupingSelectLists|QueryPropertiesForm|globalCount|objY2|buildSelects|globalStart|layerX|lastJ|layerY|ariaName|itemsCTE|canvasMenuCallback|lined|IsCTE|menuCTE|classObject|Reconnect|createLinkObjectsMenu|odd|Refresh|Query|updateDataSource|collapseTable|need|uiQBTableClasses|qbtableClass|Subqueries|updateLinkObjectsMenu|tabbableFirst|Common|New|tabbableLast|Insert|Synonyms|heightMax|generateTitle|componentH|titleButtonW||Procedure|AllFieldsSelected|NotPrimaryKey|generateFields|MetadataFieldDto|Tables||DataSourcePropertiesForm|Procedures|Views|ObjectReadOnly|componentW|titleH|adjustSize|titleText|Unions|TABLE|TableObjectFieldOnCheckField|fieldType|fieldDescription|UnionNavBarVisible|destLeft|arrowScroll|fired|_positionDragX||filterClear|itemId|filterChange|filterChangeStub|updateFilter|description|fieldSelect|filterChangeRoutineT|TreeSelectNode|jspActive|stepCallback|SubQuery|destPercentX|destPercentY|DataSourceType|ConditionTypeHaving|ConditionTypeWhere|dragMaxY|For|getInactiveItems|getActiveItem|updateNavBarContextMenu|Int32|isCurrentQuery|scrollToElement|stickToTop|createChildMenu|subqueryPlusButton|toFront|errWrongJQUI|getAllRows|tagValue|jQueryUIMaxVersion|toBack|def|jqXHR|static|AfterCustomEdit|textStatus|prevOffsetParent|jQueryMaxVersion|Blur|GlobalUID|sync|tile|Incompatible|errNoJQUI|tabIndex|blurregexp|Clone|DeepCopy|errWrongJQ|ajaxFinish|updateLinkContextMenu|updateBreadcrumb|updateUnionControls|updateTableContextMenu|OnApplicationReadyTrigger|CanvasLink||importCanvasObjects|SqlChanged|prepareSyncQueryProperties||May|setLayout|importCanvasLinks|noRotation|isPatt|vbt|dynamicSort|errWrongScriptOrder|toFilter|sqlChanged|TableCTE|sqlError|cls|updateExpression|importDto|QBTRIAL|onGridRowAdded|onCanvasLinkChanged|onTrashObjectFromCanvas|onEditorChangeDebouncedCall|onGridRowRemoved|parentBox|leftBox|rightBox|onTreeDoubleClick|getLineCoord|importQueryStructure|onEditorChange|importNavBar|inline|microsoft|512|342|importCriteriaBuilder|urn|minLeg|onEditorChangeDebounced|parentId|importMetadata|schemas|buildNewTree|fromType|check_usr|_viewBoxShift|panel|updateAggregateColumn|checkProjectConfigure|trial|thinBg|01||errNoScript|QBWebCanvasLink|000000|SUBQUERY_ENABLED|behavior|importMessages|onNavBarAction|xmlns|treeStructureElement|IsSupportUnions|IsSupportCTE|toType|importContextMenu|importSQL|Updating|newRow|Incorrect|updateOnLoad|required|higher|path2vml|short|detected|library|fontWeight|Your|shortMonths|long|longMonths|fontFamily|shortDays|_generatePosition|longDays|narrow|your|newfill|positionAbs|_convertPositionTo|wide|medium|nYou|elBot|_mouseUp|Please|UnionNavBar|isOval|errHandlersConfiguration|isMove|usr_vXXX|bites|fontStyle|trashDataSource|getTableFieldExpression|addDataSource|getPositionTop|posBottom|addLink|removeDataSource|effect|ovalTypes|hasAggregateOrCriteria|CriteriaBuilderChanged|visibleY|createJunctionTypeMenu|Union|topParent|pathTypes|IsNotEqualTo|ActiveMenu|CriteriaBuilderItemAdded|updateLink|getIsScrollableH|_destroy|isScrollableH|deleteCTE|onclick|scrollToBottom|ab8ea8824dc3b24b6666867a2c4ed58ebb762cf0|hijackInternalLinks|MooTools|getContentPane|encodeURI|isScrollableV|substitute|setDataSwitch|uncheck|stack|getIsScrollableV|tableNameTemplate|using|onreadystatechange|send|urlencoded|Connection|inViewport|errordialog|_isInt|ff0066|haspopup|tableDnDSerialize|Msxml2|greedy|check_lib|isElementVisible|form|uniqueId|uid|axd|cte|Switch|left16|linked|atan|ESCAPE|exp|Linked|listbox|labelledby|owns|MAX_SELECTS|clientError|objects|isOnScreen|clearfix|ApplicationEvents|defaultElement|exec|toPrecision|scrollbarWidth|Collection|_setHeight|fillSelectOptions2|uniqueID|Arguments|search|associate|getLast|forEachMethod|_mouseDragOrig|invoke|reduceRight|unshift|reverse|nowrap|seal|isExtensible|pager|79B5E3|isSealed|getPrototypeOf|defineProperties|getOwnPropertyDescriptor|preventExtensions|getOwnPropertyNames|showDescriptons|fillSelectOptions1|_super|TextNode|WhiteSpace|2573AF|defineProperty|freeze|ready|isFrozen|getRandom|scrollToPercentY|camelCase|hyphenate|animateEase|animateDuration|reinitialise|overloadGetter|initialise|scrollToPercentX|textnode|getPercentScrolledX|getContentHeight|Android|escapeRegExp|getPercentScrolledY|getContentPositionX|capitalize|widgetName|getContentWidth|getContentPositionY|dataRefresh|hasFixedAncestor||erase|_getParentOffset|getArrowScroll|horizontalDrag|combine|isAtLeft|isAtRight|_mouseDrag|nextAll|transparent|breadcrumb|submit|buttonset||myType|mirror|level|pick|hellip|6100|UTF8encode|calc|6101|slideDown|slideUp|contain|ends|MessageWarning|Click|0x|date|isString|render|tpl|onselectstart|file|triggerHandler|flipfit|encodeURIComponent|unescape|escape|decodeURIComponent|UTF8decode|MessageError|msgTime|front|OnBeforeCustomEditCell|reserved|Info|Warning|maincol|findRowByGuid|removeRowByDto|checkRow|pages|getQueryParams|onRemoveRow|onAddRow|selectstart|starts|findRow|left2|collspan|jPaginate|Cannot|disableTextSelect|100000px|addBack|HTMLCommandElement|containsOption|evalJSON|selectedTexts|secureEvalJSON||criteriaBuilderFieldSelect|copyOptions|unique|getUTCMilliseconds|getUTCSeconds|jQu3eryUI|succeed|following|x00|x1f|x7f|valid|u00|parsing|getJSON|sortOptions|bfnrtu|x9f|SyntaxError|ajaxAddOption|getUTCMinutes|NextItem|configuration|any|matc|getFlags|HTTP|Treeview|HTMLMenuItemElement|__max_precision|incorrect|notall|web|persist|inst|getUTCFullYear|binary|getUTCHours|onClose|script|andSelf|must|getUTCDate|getUTCMonth|Wrong|findEmptyRow|ping|diagonal|grip|_createButtons|beforeClose|dispatch|message|teardown|MouseEvent|oldInstances|statusbar|trigger_jquery_event|uuid|_allowInteraction|_size1|switchToRootQuery|updateCriteriaBuilder|updateValue|HandlersPath|uiDialogTitlebarCloseText|closeText|160|uiDialogTitlebar|uiDialogClasses|alsoResize|BackCompat|getGrid|_mouseCapture|iphone|special|addClasses|readonly|Implements|tableDnDUpdate|MouseEvents|ontouchend|titleTextW|Read|GET|178|WebkitUserSelect|err|paddingTop|tDnD_whileDrag|ipad|serializeParamName|paddingLeft|ipod|_setContainment|focusout|onDeleted|GridRowCellOnDeleted|onChanged|isEmptyRow|_UID|sortOrder|black|8cc59d|MSIE|slide|focusin|innerText|setQueryParamValues|html5|True|wrapper2|rowIndex|wrapper1|getInputValues|onGridRowCellChanged|radiogroup|rowsHeaders|currentEdit|setInputValues|paid|frameborder|meta|wrapperCleared|bName|autocomplete|_hidden_select|pencil|reset_options_value|me2|_timer_|_duration_|syncCriteriaBuilder|rid|limitation|Random|appVersion|own|them|hide_on_blur_timeout|padding_right|options_value|case_sensitive|appName|inputSpan|FIRST|tofront|toback|parseDots|MIN|MAX|LAST|Synonym|removeGridRows|1999|DESC|insertafter|insertbefore|COUNT|SUM|GetName|0A2|GetFullName|0z|LoadFromObject|createElementNS|supports|ObjectField|old|Having|objid|nullable|primaryKey|int|addGridRows|baseline|contentType|dataType|errorThrown|sizingmethod|fixOutsideBounds|descent|Apple|Computer|platform|Chrome|isSuperSimple|toTransformString|Version|M22|removeLink|async|reload|_equaliseTransform|DOMContentLoaded|ninja|fullfill|M11|M12|M21|DisablePageReload|pixelWidth|pixelHeight|DIV|mdc|ContextMenuItemDto|ContextMenuDto|UnionsAdd|QueryStructureDto|calling|u201c|u201d|ItemsListIncomplete|ItemsPacketSize|Size|00000000|Label|_pathToRelative|000000000000|Selected|RightObject|LeftObject|Datasource|SelectAllFromLeft|pathIntersectionNumber|SelectAllFromRight|orient|OutputColumnDto|Test|Expanded|FieldType|segment1|segment2|Kind|Scale|pixelradius|textpathok|createStyleSheet|Gradient|patternTransform|fillOpacity|gradientTransform|DataSourceDto|GridDto|CanvasDto|AliasNotQuoted|System|addRule|webkitTapHighlightColor|runtimeStyle|AltName|markerHeight|Command|Nullable|ReadOnly|markerWidth|Precision|RightFields|LeftFields|LinkObjectDto|DataSourceGuid|MetaDataDto|DatasourceName|Cardinality|Google|9375|Nov|625|5625|Sep|Oct|bounce|Saturday|Friday|Thursday|easeInOut|984375|easeIn|easeOut|elastic|GenerateClass|Jan|Feb|superclass|subtractsBorderForOverflowNotVisible|delegate|toUpper|04|1734|Aug|Jul|Mar|Apr|Jun|Dec|April|June|Sun|March|January|Mon|February|November|October|onAnimation|December|July|August|September|Tue|oRequestAnimationFrame|msRequestAnimationFrame|Tuesday|mozRequestAnimationFrame|Wednesday|requestAnimationFrame|webkitRequestAnimationFrame|Fri|Thu|Wed||Sat|Monday|Sunday|finish|doesAddBorderForTableAndCells|non|x2F|quot|require|contentWindow|9E9|bold|liveConvert|liveEx|setStart|live|onDragOver|undrag|unmousedown|Top|bolder|lighter|interrupt|GLOBAL_DEBUG|returnValue|cancelBubble|print|unmouseout|onAfterFirst|700|unmouseover|getData|client|unhover|setFinish|OnApplicationReady|curveslengths|getRec1|setGlobalOnLoad|toTimeString|00|u2019s|offsetWithParent|bodyOffset|doesNotAddBorder|SmartAdd|setTime|equalHeight|equalWidth|u00d7|index2|u2018s|createSVGRect|registerFont|unload|pageXOffset|mlcxtrv|getElementsByPoint|x_y|removeHandler|insertion|getIntersectionList|getElementsByBBox|addHandler|refY|Deny|Allow|LinkManipulations|DbType|Byte|Binary|AnsiString|Desc|Many|One|SVGAngle|LinkSideType|Asc|ItemSortType|sortByKey|removeAttribute|UInt32|UInt16|UInt64|radial_gradient|arrowwidth|VarNumeric|stdDeviation|Double|Decimal|Currency|Int16|Single|SByte|Int64|groups|htmlfile|write|finally|TreeSelectTypeDto|feGaussianBlur|currentLanguage|joinstyle|ForeColor|65280|16711680|queryCommandValue|createPopup|createTextRange|AddCTEShort|BasicStructure|LinkCardinality|Other|feature|implementation|hasFeature|SVG11|_id|4xxx|yxxx|xxxxxxxxxxxx|xxxx|StoredProc||snapTo|xxxxxxxx|shrinkChild|Created|dxdy|32E3|props|Universal|ResizeSensor|errors|nts|NumericInt|NumericFrac|windowsSizeW|updateObjects|windowsSizeH|rotation|removeByGraphics|getByLinkNew|getByLink|removeAll|21600|000B9D|updateLinks|_getHeaderCellsIndex|DenyIntoClause|Into|350|animportCanvasimation|offsetY|ahqstv|offsetX|letter|spacing|meet|raphaeljs|StringFixedLength|10px|xMinYMin|_blank|achlmrqstvz|arrowlength|rstm|achlmqrstvxz|_availableAnimAttrs|AnsiStringFixedLength|Falling|ontouchstart|doesn|DateTimeOffset|getScreenCTM|KindOfType|once|Eve|DateTime2|u2019t|cubic|bezier|NaN|Xml|ISURL|viewBox|InsertEmptyItem|RemoveItem|MoveDown|longdashdot|longdashdotdot|ObjectTypeTable|MoveUp|backward|MoveBackward|NewUnionSubQuery|dashstyle|forward|MoveForward|pathIntersection|Provider|Syntax|SelectSyntaxProvider|MetadataObjectCount|proceed|shortdashdot|ObjectTypeUnknown|longdash|ObjectTypeView|dashdot|shortdashdotdot|ObjectTypeProcedure|dash|CacheOptions|colors|gradientTitle|interCount|Option|Cache|focussize|JoinExpression|RightColumn|LeftColumn|focusposition|270|Join|inter|EncloseWithBrackets|RemoveBrackets|kern|CopyToNewUnionSubQuery|Enclose|center|userSpaceOnUse|clipPath|Order|color2|patternUnits|oindex|GroupBy|Update|AddSubQuery|same|shortdash|CheckAll|SelectAll|onerror|already|updated|flat|Uncheck||endcap|u2400|UncheckAll|Check|UnionSubMenu|ColumnNameAlreadyUsed|DeleteCTE|views|derived|procedures|AddCTE|Colour|tables|miter|shortdot|exists|preload|Picker|AddNewCTE'.split('|'),0,{}))

