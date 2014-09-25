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

// ..\..\src\Common\Client\js\release\usr_v2_5_14.js
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1;};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p;}('K ZQ=1o;K Ik={Hc:1a(){K 6q=1c;if(2L pM!="2O"){7D{6q=1S pM("OB.ER")}7C(e){7D{6q=1S pM("zg.ER")}7C(E){6q=1j}}}1i{if(3P.GX){7D{6q=1S GX}7C(e){6q=1c}}}1b 6q},vA:1a(C8,1Z,45){K 6q=J.Hc();if(!6q||!C8){1b}K 5b=C8;5b+=5b.4Y("?")+1?"&":"?";5b+="Pg="+(1S 5k).Kp();K oy=1c;if(45=="qP"){K Ca=5b.3p("?");5b=Ca[0];oy=Ca[1]}6q.6K(45,5b,1o);if(45=="qP"){6q.AQ("Gm-1w","lZ/x-mX-NY-Oi");6q.AQ("Gm-1e",oy.1e);6q.AQ("O4","5r")}6q.Oa=1a(){if(6q.n7==4){if(6q.6F==fN){K 1J="";if(6q.Gw){1J=6q.Gw}if(1Z){1Z(1J)}}}};6q.Rp(oy)},7u:1a(cD,5b,bO){K 96=\'<b 3b="3s:#RP">yi 9h</b>\\n<br/>\\n\'+"j6: "+cD+"\\n<br>\\n"+"FZ: "+5b+"\\n<br>\\n"+"FW: "+bO+"\\n<br>\\n";K HK="yi 9h\\n"+"j6: "+cD+"\\n\\n"+"FZ: "+5b+"\\n\\n"+"FW: "+bO+"\\n\\n";if(b1&&b1.eG){96=96+"eG: "+b1.eG}K 3i=2N.cb("2F");3i.bK="Rr";3i.mQ=96;if(2N&&(2N.3U&&2N.3U.3E)){2N.3U.3E(3i)}1i{dN(HK)}Ik.Iu({cD:cD,5b:5b,bO:bO,eG:b1.eG});1b 1o},Iu:1a(1v){K 5b="nf/PK.PR?";1n(K i in 1v){if(1v.7X(i)){5b+=i+"="+PQ(1v[i])+"&"}}J.vA(5b,1c,"qP")}};(1a(){J.QD={5N:"1.4.5",9z:"Qy"};K 7T=J.7T=1a(1g){if(1g==1c){1b"1c"}if(1g.$83!=1c){1b 1g.$83()}if(1g.8N){if(1g.HF==1){1b"1f"}if(1g.HF==3){1b/\\S/.9r(1g.Eo)?"Qz":"GH"}}1i{if(2L 1g.1e=="cJ"){if(1g.Jf){1b"2q"}if("1g"in 1g){1b"EZ"}}}1b 2L 1g};K oZ=J.oZ=1a(1g,1D){if(1g==1c){1b 1j}K 4V=1g.$4V||1g.4V;44(4V){if(4V===1D){1b 1o}4V=4V.1L}if(!1g.7X){1b 1j}1b 1g eH 1D};K 9n=J.9n;K gS=1o;1n(K i in{3r:1}){gS=1c}if(gS){gS=["7X","Kr","Kw","qX","C5","3r","4V"]}9n.2S.f7=1a(oD){K 2o=J;1b 1a(a,b){if(a==1c){1b J}if(oD||2L a!="4d"){1n(K k in a){2o.2w(J,k,a[k])}if(gS){1n(K i=gS.1e;i--;){k=gS[i];if(a.7X(k)){2o.2w(J,k,a[k])}}}}1i{2o.2w(J,a,b)}1b J}};9n.2S.QO=1a(oD){K 2o=J;1b 1a(a){K 2e,1J;if(2L a!="4d"){2e=a}1i{if(2q.1e>1){2e=2q}1i{if(oD){2e=[a]}}}if(2e){1J={};1n(K i=0;i<2e.1e;i++){1J[2e[i]]=2o.2w(J,2e[i])}}1i{1J=2o.2w(J,a)}1b 1J}};9n.2S.4m=1a(1q,1m){J[1q]=1m}.f7();9n.2S.7d=1a(1q,1m){J.2S[1q]=1m}.f7();K 3G=3Y.2S.3G;9n.2s=1a(1g){1b 7T(1g)=="1a"?1g:1a(){1b 1g}};3Y.2s=1a(1g){if(1g==1c){1b[]}1b 98.Dl(1g)&&2L 1g!="4d"?7T(1g)=="3K"?1g:3G.2w(1g):[1g]};5W.2s=1a(1g){K cJ=cZ(1g);1b EN(cJ)?cJ:1c};5h.2s=1a(1g){1b 1g+""};9n.7d({Bd:1a(){J.$70=1o;1b J},BJ:1a(){J.$pe=1o;1b J}});K 98=J.98=J.98=1a(1z,1D){if(1z){K BQ=1z.3R();K Hl=1a(1g){1b 7T(1g)==BQ};98["is"+1z]=Hl;if(1D!=1c){1D.2S.$83=1a(){1b BQ}.Bd()}}if(1D==1c){1b 1c}1D.4m(J);1D.$4V=98;1D.2S.$4V=1D;1b 1D};K 3r=4K.2S.3r;98.Dl=1a(1g){1b 1g!=1c&&(2L 1g.1e=="cJ"&&3r.2w(1g)!="[1D 9n]")};K jO={};K BS=1a(1D){K 1w=7T(1D.2S);1b jO[1w]||(jO[1w]=[])};K 7d=1a(1z,45){if(45&&45.$70){1b}K jO=BS(J);1n(K i=0;i<jO.1e;i++){K jG=jO[i];if(7T(jG)=="1w"){7d.2w(jG,1z,45)}1i{jG.2w(J,1z,45)}}K bZ=J.2S[1z];if(bZ==1c||!bZ.$pe){J.2S[1z]=45}if(J[1z]==1c&&7T(45)=="1a"){4m.2w(J,1z,1a(1g){1b 45.3d(1g,3G.2w(2q,1))})}};K 4m=1a(1z,45){if(45&&45.$70){1b}K bZ=J[1z];if(bZ==1c||!bZ.$pe){J[1z]=45}};98.7d({7d:7d.f7(),4m:4m.f7(),aa:1a(1z,8n){7d.2w(J,1z,J.2S[8n])}.f7(),Qp:1a(jG){BS(J).1C(jG);1b J}});1S 98("98",98);K fm=1a(1z,1D,9W){K p8=1D!=4K,2S=1D.2S;if(p8){1D=1S 98(1z,1D)}1n(K i=0,l=9W.1e;i<l;i++){K 1q=9W[i],BK=1D[1q],iF=2S[1q];if(BK){BK.BJ()}if(p8&&iF){1D.7d(1q,iF.BJ())}}if(p8){K Ck=2S.qX(9W[0]);1D.PV=1a(fn){if(!Ck){1n(K i=0,l=9W.1e;i<l;i++){fn.2w(2S,2S[9W[i]],9W[i])}}1n(K 1q in 2S){fn.2w(2S,2S[1q],1q)}}}1b fm};fm("5h",5h,["b6","KJ","3w","4Y","CU","3e","Fa","3f","PW","3G","3p","79","fJ","nn","3R","8u"])("3Y",3Y,["dw","1C","PG","bP","eU","5f","PJ","3w","4H","3G","4Y","CU","4s","8G","A4","eO","EF","Q7","Qa"])("5W",5W,["B4","4r","C5","Qd"])("9n",9n,["3d","2w","2B"])("dl",dl,["Qb","9r"])("4K",4K,["7K","PZ","PY","81","Q1","Q4","Q5","RB","RC","RA","RD","RG","RH"])("5k",5k,["7b"]);4K.4m=4m.f7();5k.4m("7b",1a(){1b+1S 5k});1S 98("k6",k6);5W.2S.$83=1a(){1b EN(J)?"cJ":"1c"}.Bd();5W.4m("iL",1a(5U,4y){1b 3F.gH(3F.iL()*(4y-5U+1)+5U)});K 7X=4K.2S.7X;4K.4m("8G",1a(1D,fn,2B){1n(K 1q in 1D){if(7X.2w(1D,1q)){fn.2w(2B,1D[1q],1q,1D)}}});4K.2g=4K.8G;3Y.7d({8G:1a(fn,2B){1n(K i=0,l=J.1e;i<l;i++){if(i in J){fn.2w(2B,J[i],i,J)}}},2g:1a(fn,2B){3Y.8G(J,fn,2B);1b J}});K Bh=1a(1g){3q(7T(1g)){1l"3K":1b 1g.5S();1l"1D":1b 4K.5S(1g);5n:1b 1g}};3Y.7d("5S",1a(){K i=J.1e,5S=1S 3Y(i);44(i--){5S[i]=Bh(J[i])}1b 5S});K Bc=1a(aZ,1q,5y){3q(7T(5y)){1l"1D":if(7T(aZ[1q])=="1D"){4K.B9(aZ[1q],5y)}1i{aZ[1q]=4K.5S(5y)}1p;1l"3K":aZ[1q]=5y.5S();1p;5n:aZ[1q]=5y}1b aZ};4K.4m({B9:1a(aZ,k,v){if(7T(k)=="4d"){1b Bc(aZ,k,v)}1n(K i=1,l=2q.1e;i<l;i++){K 1D=2q[i];1n(K 1q in 1D){Bc(aZ,1q,1D[1q])}}1b aZ},5S:1a(1D){K 5S={};1n(K 1q in 1D){5S[1q]=Bh(1D[1q])}1b 5S},3a:1a(kQ){1n(K i=1,l=2q.1e;i<l;i++){K Bg=2q[i]||{};1n(K 1q in Bg){kQ[1q]=Bg[1q]}}1b kQ}});["4K","RK","RM","R2","R7"].2g(1a(1z){1S 98(1z)});K EH=5k.7b();5h.4m("R4",1a(){1b(EH++).3r(36)})})();3Y.7d({A4:1a(fn,2B){1n(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&!fn.2w(2B,J[i],i,J)){1b 1j}}1b 1o},4s:1a(fn,2B){K eh=[];1n(K 1m,i=0,l=J.1e>>>0;i<l;i++){if(i in J){1m=J[i];if(fn.2w(2B,1m,i,J)){eh.1C(1m)}}}1b eh},4Y:1a(1g,2s){K 1e=J.1e>>>0;1n(K i=2s<0?3F.4y(0,1e+2s):2s||0;i<1e;i++){if(J[i]===1g){1b i}}1b-1},eO:1a(fn,2B){K 1e=J.1e>>>0,eh=3Y(1e);1n(K i=0;i<1e;i++){if(i in J){eh[i]=fn.2w(2B,J[i],i,J)}}1b eh},EF:1a(fn,2B){1n(K i=0,l=J.1e>>>0;i<l;i++){if(i in J&&fn.2w(2B,J[i],i,J)){1b 1o}}1b 1j},Ey:1a(){1b J.4s(1a(1g){1b 1g!=1c})},QU:1a(EW){K 2e=3Y.3G(2q,1);1b J.eO(1a(1g){1b 1g[EW].3d(1g,2e)})},QY:1a(81){K 1u={},1e=3F.5U(J.1e,81.1e);1n(K i=0;i<1e;i++){1u[81[i]]=J[i]}1b 1u},1W:1a(1D){K 1J={};1n(K i=0,l=J.1e;i<l;i++){1n(K 1q in 1D){if(1D[1q](J[i])){1J[1q]=J[i];41 1D[1q];1p}}}1b 1J},h8:1a(1g,2s){1b J.4Y(1g,2s)!=-1},3a:1a(3K){J.1C.3d(J,3K);1b J},QW:1a(){1b J.1e?J[J.1e-1]:1c},Ra:1a(){1b J.1e?J[5W.iL(0,J.1e-1)]:1c},Fg:1a(1g){if(!J.h8(1g)){J.1C(1g)}1b J},Rb:1a(3K){1n(K i=0,l=3K.1e;i<l;i++){J.Fg(3K[i])}1b J},R8:1a(1g){1n(K i=J.1e;i--;){if(J[i]===1g){J.5f(i,1)}}1b J},c0:1a(){J.1e=0;1b J},EY:1a(){K 3K=[];1n(K i=0,l=J.1e;i<l;i++){K 1w=7T(J[i]);if(1w=="1c"){ag}3K=3K.3w(1w=="3K"||(1w=="EZ"||(1w=="2q"||oZ(J[i],3Y)))?3Y.EY(J[i]):J[i])}1b 3K},Oc:1a(){1n(K i=0,l=J.1e;i<l;i++){if(J[i]!=1c){1b J[i]}}1b 1c},Bo:1a(3K){if(J.1e!=3){1b 1c}K 3D=J.eO(1a(1m){if(1m.1e==1){1m+=1m}1b 1m.9I(16)});1b 3K?3D:"3D("+3D+")"},Bt:1a(3K){if(J.1e<3){1b 1c}if(J.1e==4&&(J[3]==0&&!3K)){1b"O3"}K 6f=[];1n(K i=0;i<3;i++){K p7=(J[i]-0).3r(16);6f.1C(p7.1e==1?"0"+p7:p7)}1b 3K?6f:"#"+6f.4H("")}});5h.7d({9r:1a(p0,1v){1b(7T(p0)=="Bs"?p0:1S dl(""+p0,1v)).9r(J)},h8:1a(4d,5o){1b 5o?(5o+J+5o).4Y(5o+4d+5o)>-1:5h(J).4Y(4d)>-1},nn:1a(){1b 5h(J).3f(/^\\s+|\\s+$/g,"")},Ey:1a(){1b 5h(J).3f(/\\s+/g," ").nn()},O8:1a(){1b 5h(J).3f(/-\\D/g,1a(3e){1b 3e.b6(1).8u()})},O7:1a(){1b 5h(J).3f(/[A-Z]/g,1a(3e){1b"-"+3e.b6(0).3R()})},Oq:1a(){1b 5h(J).3f(/\\b[a-z]/g,1a(3e){1b 3e.8u()})},Pj:1a(){1b 5h(J).3f(/([-.*+?^${}()|[\\]\\/\\\\])/g,"\\\\$1")},9I:1a(go){1b 6i(J,go||10)},3z:1a(){1b cZ(J)},Bo:1a(3K){K 6f=5h(J).3e(/^#?(\\w{1,2})(\\w{1,2})(\\w{1,2})$/);1b 6f?6f.3G(1).Bo(3K):1c},Bt:1a(3K){K 3D=5h(J).3e(/\\d{1,3}/g);1b 3D?3D.Bt(3K):1c},Pv:1a(1D,Bs){1b 5h(J).3f(Bs||/\\\\?\\{([^{}]+)\\}/g,1a(3e,1z){if(3e.b6(0)=="\\\\"){1b 3e.3G(1)}1b 1D[1z]!=1c?1D[1z]:""})}});9n.4m({Es:1a(){1n(K i=0,l=2q.1e;i<l;i++){7D{1b 2q[i]()}7C(e){}}1b 1c}});9n.7d({Es:1a(2e,2B){7D{1b J.3d(2B,3Y.2s(2e))}7C(e){}1b 1c},2B:1a(6e){K 2o=J,2e=2q.1e>1?3Y.3G(2q,1):1c,F=1a(){};K Br=1a(){K 3l=6e,1e=2q.1e;if(J eH Br){F.2S=2o.2S;3l=1S F}K 1J=!2e&&!1e?2o.2w(3l):2o.3d(3l,2e&&1e?2e.3w(3Y.3G(2q)):2e||2q);1b 3l==6e?1J:3l};1b Br},Bk:1a(2e,2B){K 2o=J;if(2e!=1c){2e=3Y.2s(2e)}1b 1a(){1b 2o.3d(2B,2e||2q)}},eZ:1a(eZ,2B,2e){1b 6y(J.Bk(2e==1c?[]:2e,2B),eZ)},Bi:1a(Bi,2B,2e){1b l0(J.Bk(2e==1c?[]:2e,2B),Bi)}});5W.7d({OF:1a(5U,4y){1b 3F.5U(4y,3F.4y(5U,J))},4I:1a(fP){fP=3F.5M(10,fP||0).4r(fP<0?-fP:0);1b 3F.4I(J*fP)/fP},cf:1a(fn,2B){1n(K i=0;i<J;i++){fn.2w(2B,i,J)}},3z:1a(){1b cZ(J)},9I:1a(go){1b 6i(J,go||10)}});5W.aa("2g","cf");(1a(3y){K 9W={};3y.2g(1a(1z){if(!5W[1z]){9W[1z]=1a(){1b 3F[1z].3d(1c,[J].3w(3Y.2s(2q)))}}});5W.7d(9W)})(["4c","G0","pz","Ow","y9","jU","8I","OV","gH","io","4y","5U","5M","8r","9v","GM"]);(1a(){K 5X=J.5X=1S 98("5X",1a(1v){if(oZ(1v,9n)){1v={bJ:1v}}K hf=1a(){kF(J);if(hf.$Ba){1b J}J.$9g=1c;K 1m=J.bJ?J.bJ.3d(J,2q):J;J.$9g=J.9g=1c;1b 1m}.4m(J).7d(1v);hf.$4V=5X;hf.2S.$4V=hf;hf.2S.1L=1L;1b hf});K 1L=1a(){if(!J.$9g){9K 1S 9h(\'p5 45 "1L" Nn be C1.\')}K 1z=J.$9g.$1z,1L=J.$9g.$MP.1L,bZ=1L?1L.2S[1z]:1c;if(!bZ){9K 1S 9h(\'p5 45 "\'+1z+\'" 3o no 1L.\')}1b bZ.3d(J,2q)};K kF=1a(1D){1n(K 1q in 1D){K 1m=1D[1q];3q(7T(1m)){1l"1D":K F=1a(){};F.2S=1m;1D[1q]=kF(1S F);1p;1l"3K":1D[1q]=1m.5S();1p}}1b 1D};K Mr=1a(2o,1q,45){if(45.$fo){45=45.$fo}K 5O=1a(){if(45.$pe&&J.$9g==1c){9K 1S 9h(\'p5 45 "\'+1q+\'" Nn be C1.\')}K 9g=J.9g,5y=J.$9g;J.9g=5y;J.$9g=5O;K 1J=45.3d(J,2q);J.$9g=5y;J.9g=9g;1b 1J}.4m({$MP:2o,$fo:45,$1z:1q});1b 5O};K 7d=1a(1q,1m,MM){if(5X.B6.7X(1q)){1m=5X.B6[1q].2w(J,1m);if(1m==1c){1b J}}if(7T(1m)=="1a"){if(1m.$70){1b J}J.2S[1q]=MM?1m:Mr(J,1q,1m)}1i{4K.B9(J.2S,1q,1m)}1b J};K Nj=1a(ph){ph.$Ba=1o;K iF=1S ph;41 ph.$Ba;1b iF};5X.7d("7d",7d.f7());5X.B6={bN:1a(1L){J.1L=1L;J.2S=Nj(1L)},Re:1a(1F){3Y.2s(1F).2g(1a(1g){K qD=1S 1g;1n(K 1q in qD){7d.2w(J,1q,qD[1q],1o)}},J)}}})();(1a($){$.cn.9c="Rf"in 2N;if(!$.cn.9c){1b}K i5=$.ui.ts.2S;K pb=i5.pb;K ka;1a fe(1H,Nd){if(1H.cS.hi.1e>1){1b}1H.4g();K t=1H.cS.LY[0];K B8=2N.MY("R9");B8.MK(Nd,1o,1o,3P,1,t.MS,t.MV,t.aB,t.aT,1j,1j,1j,1j,0,1c);1H.3m.zr(B8)}i5.LZ=1a(1H){K me=J;if(ka||!me.Rk(1H.cS.LY[0])){1b}ka=1o;me.Bf=1j;fe(1H,"ha");fe(1H,"9x");fe(1H,"7i")};i5.Mw=1a(1H){if(!ka){1b}J.Bf=1o;fe(1H,"9x")};i5.MI=1a(1H){if(!ka){1b}fe(1H,"5u");fe(1H,"dL");if(!J.Bf){fe(1H,"3I")}ka=1j};i5.pb=1a(){K me=J;me.1f.2B("ni",$.9G(me,"LZ")).2B("nb",$.9G(me,"Mw")).2B("na",$.9G(me,"MI"));pb.2w(me)}})(2u);K gz=1c;(1a($){$.fn.nl=1a(){$(J).fv(1a(e){K t=e.8e;K o=$(e.8e).2y();if(e.6T-o.2a>t.nR){1b}K 1f=$(e.3m);1f.2M({x:e.aB,y:e.aT})})};K $MH=$.fn.3I;$.fn.3I=1a 3I(6O,7u){if(!7u){1b $MH.3d(J,2q)}1b $(J).2B(1w,7u)};$.fn.fv=1a fv(){K 2e=[].5f.2w(2q,0),7u=2e.dw(),6O=2e.dw(),$J=$(J);1b 7u?$J.3I(6O,7u):$J.2c(1w)};$.fv={6O:93};$.1H.Q3.fv={yL:1a(1h,9j){if(!/Qe|PN|PH/i.9r(b1.eG)){$(J).2B(Ny,BL).2B([Nw,NI,NL,N9].4H(" "),BM).2B(BN,3I)}1i{Ms(J).2B(N7,BL).2B([Nb,N2,N1].4H(" "),BM).2B(BN,3I).2Z({PE:"3t"})}},PT:1a(9j){$(J).7V(9e)}};1a Ms(1f){$.2g("ni nb na xi".3p(/ /),1a 2B(ix,it){1f.bi(it,1a PP(1H){$(1f).2c(it)},1j)});1b $(1f)}1a BL(1H){if(gz){1b}K 1f=J;K 2e=2q;$(J).1h(pd,1j);gz=6y(NF,$.fv.6O);1a NF(){$(1f).1h(pd,1o);1H.1w=1w;2u.1H.QF.3d(1f,2e)}}1a BM(1H){if(gz){jh(gz);gz=1c}}1a 3I(1H){if($(J).1h(pd)){1b 1H.cr()||1j}}K 1w="fv";K 9e="."+1w;K Ny="7i"+9e;K BN="3I"+9e;K Nw="9x"+9e;K NI="5u"+9e;K NL="dL"+9e;K N9="5i"+9e;K N7="ni"+9e;K Nb="na"+9e;K N2="nb"+9e;K N1="xi"+9e;K Qj="6O"+9e;K Qf="8E"+9e;K pd="Cj"+9e})(2u);(1a($){$.fn.te=1a(1x){K l6=$.4m({},$.fn.te.dh,1x);1b J.2g(1a(){$J=$(J);K o=$.Qt?$.4m({},l6,$J.1h()):l6;K mv=o.2J;$.fn.iT(o,$J,mv)})};K AX=0;K oO=0;K Qw=b1.Qs;K JE=b1.Qv;if(JE.4Y("Qh 7.0")>0){K oH="oT"}$.fn.te.dh={6x:5,2J:12,5q:5,f8:1o,Ay:"#jI",kf:"#Qn",kh:"Ql",AD:"#jI",jV:"#jI",jW:"#jI",5p:1o,BY:1o,ts:"QJ",mR:1a(){1b 1j}};$.fn.iT=1a(o,1u,mv){if(o.5q>o.6x){o.5q=o.6x}$J.c0();if(o.BY){K JK="9k-JL-c5";K Jq="9k-bZ-c5";K Jo="9k-Jp-c5";K Jt="9k-3k-c5"}1i{K JK="9k-JL";K Jq="9k-bZ";K Jo="9k-Jp";K Jt="9k-3k"}if(o.5p){K AB=$("<2F>&lt;</2F>").3C({b9:{s4:"ui-3L-K4-1-w"},1Y:1j})}$J.42(\'<2F id="QH">\'+\'<2F id="QL">\'+\'<2F id="QP">\'+\'<2F id="pc"></2F>\'+\'<2F id="oN"></2F>\'+\'<2F id="BH"></2F>\'+"</2F>"+"</2F>"+"</2F>");K Ju=$("#pc").2t("9k-31-zI");Ju.3a(AB);K 87=$(\'<1M sD="0" sG="0">\').2Z("gh","70");K hp=$("<tr>").2t("9k-QM");K c=(o.5q-1)/2;K 4t=mv-c;K oi;1n(K i=0;i<o.6x;i++){K 2h=i+1;if(2h==mv){K mr=$(\'<td 2C="li">\').42(\'<2E 2C="9k-5y">\'+2h+"</2E>");oi=mr;hp.3a(mr)}1i{K mr=$(\'<td 2C="li">\').42("<a>"+2h+"</a>");hp.3a(mr)}}87.3a(hp);if(o.5p){K AF=$("<2F>&gt;</2F>").3C({b9:{s4:"ui-3L-K4-1-e"},1Y:1j})}K nE=$("#oN").2t("9k-31-QA");nE.3a(AF);$("#BH").3a(87);K oM=$("#BH");K BE=1c;1a K1(){$("#pc").3J();$("#oN").3J()}1a K2(){$("#pc").5e();$("#oN").5e()}1a Ax(){if(oM.1r()==0){1b}rk(BE);if(87.1r()<=oM.1r()){K1()}1i{K2()}}if(oM.1r()==0){BE=l0(Ax,kI)}1i{Ax()}$J.2t("PO");if(!o.f8){if(o.kh=="3t"){K dY={"3s":o.kf}}1i{K dY={"3s":o.kf,"iH-3s":o.kh}}if(o.jW=="3t"){K dO={"3s":o.jV}}1i{K dO={"3s":o.jV,"iH-3s":o.jW}}}1i{if(o.kh=="3t"){K dY={"3s":o.kf,"f8":"k5 mi "+o.Ay}}1i{K dY={"3s":o.kf,"iH-3s":o.kh,"f8":"k5 mi "+o.Ay}}if(o.jW=="3t"){K dO={"3s":o.jV,"f8":"k5 mi "+o.AD}}1i{K dO={"3s":o.jV,"iH-3s":o.jW,"f8":"k5 mi "+o.AD}}}$.fn.As(o,$J,dY,dO,hp,87,nE);K Ak=AX-1;if(oH=="oT"){}1i{}if(o.ts=="Go"){AF.7i(1a(){oF=l0(1a(){K 2a=87.1L().4S()+5;87.1L().4S(2a)},20)}).5u(1a(){rk(oF)});AB.7i(1a(){oF=l0(1a(){K 2a=87.1L().4S()-5;87.1L().4S(2a)},20)}).5u(1a(){rk(oF)})}87.2D(".li").3I(1a(e){oi.42("<a>"+oi.2D(".9k-5y").42()+"</a>");K Aj=$(J).2D("a").42();$(J).42(\'<2E 2C="9k-5y">\'+Aj+"</2E>");oi=$(J);$.fn.As(o,$(J).1L().1L().1L(),dY,dO,hp,87,nE);K 2a=J.8l/2;K PF=87.4S()+2a;K 8f=2a-Ak/2;if(oH=="oT"){87.4J({4S:2a+8f+52+"px"})}1i{87.4J({4S:2a+8f+"px"})}o.mR(Aj)});K 6Z=87.2D(".li").eq(o.2J-1);6Z.1k("id","8f");K 2a=2N.dT("8f").8l/2;6Z.jX("id");K 8f=2a-Ak/2;if(oH=="oT"){87.4J({4S:2a+8f+52+"px"})}1i{87.4J({4S:2a+8f+"px"})}};$.fn.As=1a(o,1u,dY,dO,hp,87,nE){1u.2D("a").2Z(dY);1u.2D("2E.9k-5y").2Z(dO);1u.2D("a").6D(1a(){$(J).2Z(dO)},1a(){$(J).2Z(dY)});oO=0;1u.2D(".li").2g(1a(i,n){if(i==o.5q-1){AX=J.8l+J.fC}oO+=J.fC});oO+=3}})(2u);(1a($){$.4m({hn:1a(fn,oU,9o,AY){K 8E;1b 1a(){K 2e=2q;9o=9o||J;AY&&(!8E&&fn.3d(9o,2e));jh(8E);8E=6y(1a(){!AY&&fn.3d(9o,2e);8E=1c},oU)}},AG:1a(fn,oU,9o){K 8E,2e,oR;1b 1a(){2e=2q;oR=1o;9o=9o||J;if(!8E){(1a(){if(oR){fn.3d(9o,2e);oR=1j;8E=6y(2q.Jf,oU)}1i{8E=1c}})()}}}})})(2u);(1a($){K h6={ja:{B0:1a(i){3q(J.iU(i)){1l"3K":;1l"Rs":;1l"cJ":1b i.3r();1l"1D":K o=[];1n(x=0;x<i.1e;i++){o.1C(i+": "+J.B0(i[x]))}1b o.4H(", ");1l"4d":1b i;5n:1b i}},iU:1a(i){if(!i||!i.4V){1b 2L i}K 3e=i.4V.3r().3e(/3Y|5W|5h|4K|5k/);1b 3e&&3e[0].3R()||2L i},iG:1a(73,l,s,t){K p=s||" ";K o=73;if(l-73.1e>0){o=(1S 3Y(3F.jU(l/ p.1e))).4H(p).79(0, t = !t ? l : t == 1 ? 0 : 3F.jU(l /2))+73+p.79(0,l-t)}1b o},Jg:1a(4i,2e){K 1q=4i.oJ();3q(J.iU(2e)){1l"1D":K 81=1q.3p(".");K 1u=2e;1n(K bc=0;bc<81.1e;bc++){1u=1u[81[bc]]}if(2L 1u!="2O"){if(h6.ja.iU(1u)=="3K"){1b 4i.h9().3e(/\\.\\*/)&&1u[1]||1u}1b 1u}1i{}1p;1l"3K":1q=6i(1q,10);if(4i.h9().3e(/\\.\\*/)&&2L 2e[1q+1]!="2O"){1b 2e[1q+1]}1i{if(2L 2e[1q]!="2O"){1b 2e[1q]}1i{1b 1q}}1p}1b"{"+1q+"}"},L9:1a(c3,2e){K 4i=1S Kx(c3,2e);1b h6.ja[4i.h9().3G(-1)](J.Jg(4i,2e),4i)},d:1a(29,4i){K o=6i(29,10);K p=4i.lG();if(p){1b J.iG(o.3r(),p,4i.l4(),0)}1i{1b o}},i:1a(29,2e){1b J.d(29,2e)},o:1a(29,4i){K o=29.3r(8);if(4i.lk()){o=J.iG(o,o.1e+1,"0",0)}1b J.iG(o,4i.lG(),4i.l4(),0)},u:1a(29,2e){1b 3F.4c(J.d(29,2e))},x:1a(29,4i){K o=6i(29,10).3r(16);o=J.iG(o,4i.lG(),4i.l4(),0);1b 4i.lk()?"Rq"+o:o},X:1a(29,4i){1b J.x(29,4i).8u()},e:1a(29,4i){1b cZ(29,10).B4(4i.oG())},E:1a(29,4i){1b J.e(29,4i).8u()},f:1a(29,4i){1b J.iG(cZ(29,10).4r(4i.oG()),4i.lG(),4i.l4(),0)},F:1a(29,2e){1b J.f(29,2e)},g:1a(29,4i){K o=cZ(29,10);1b o.3r().1e>6?3F.4I(o.B4(4i.oG())):o},G:1a(29,2e){1b J.g(29,2e)},c:1a(29,2e){K 3e=29.3e(/\\w|\\d/);1b 3e&&3e[0]||""},r:1a(29,2e){1b J.B0(29)},s:1a(29,2e){1b 29.3r&&29.3r()||""+29}},6s:1a(73,2e){K 4x=0;K 2J=0;K 3e=1j;K gT=[];K c3="";K 8f=(73||"").3p("");1n(2J=0;2J<8f.1e;2J++){if(8f[2J]=="{"&&8f[2J+1]!="{"){4x=73.4Y("}",2J);c3=8f.3G(2J+1,4x).4H("");gT.1C(h6.ja.L9(c3,2L 2q[1]!="1D"?KV(2q,2):2e||[]))}1i{if(2J>4x||gT.1e<1){gT.1C(8f[2J])}}}1b gT.1e>1?gT.4H(""):gT[0]},QV:1a(73,2e){1b s5(6s(73,2e))},kl:1a(s,n){1b(1S 3Y(n+1)).4H(s)},Rh:1a(s){1b O9(Of(s))},Oe:1a(s){1b Od(O6(s))},Og:1a(){K 2m="",Ol=1o;if(2q.1e==2&&$.xU(2q[1])){J[2q[0]]=2q[1].4H("");1b 2u}if(2q.1e==2&&$.NZ(2q[1])){J[2q[0]]=2q[1];1b 2u}if(2q.1e==1){1b $(J[2q[0]])}if(2q.1e==2&&2q[1]==1j){1b J[2q[0]]}if(2q.1e==2&&$.Kt(2q[1])){1b $($.6s(J[2q[0]],2q[1]))}if(2q.1e==3&&$.Kt(2q[1])){1b 2q[2]==1o?$.6s(J[2q[0]],2q[1]):$($.6s(J[2q[0]],2q[1]))}}};K Kx=1a(4i,2e){J.Ce=4i;J.gO=2e;J.Pf=cZ("1."+(1S 3Y(32)).4H("1"),10).3r().1e-3;J.lJ=6;J.kW=1a(){1b J.Ce};J.oJ=1a(){1b J.Ce.3p(":")[0]};J.h9=1a(){K 3e=J.kW().3p(":");1b 3e&&3e[1]?3e[1]:"s"};J.oG=1a(){K 3e=J.h9().3e(/\\.(\\d+|\\*)/g);if(!3e){1b J.lJ}1i{3e=3e[0].3G(1);if(3e!="*"){1b 6i(3e,10)}1i{if(h6.ja.iU(J.gO)=="3K"){1b J.gO[1]&&J.gO[0]||J.lJ}1i{if(h6.ja.iU(J.gO)=="1D"){1b J.gO[J.oJ()]&&J.gO[J.oJ()][0]||J.lJ}1i{1b J.lJ}}}}};J.lG=1a(){K 3e=1j;if(J.lk()){3e=J.kW().3e(/0?#0?(\\d+)/);if(3e&&3e[1]){1b 6i(3e[1],10)}}3e=J.kW().3e(/(0|\\.)(\\d+|\\*)/g);1b 3e&&6i(3e[0].3G(1),10)||0};J.l4=1a(){K o="";if(J.lk()){o=" "}if(J.h9().3e(/#0|0#|^0|\\.\\d+/)){o="0"}1b o};J.Pa=1a(){K 3e=J.kW().Py(/^(0|\\#|\\-|\\+|\\s)+/);1b 3e&&3e[0].3p("")||[]};J.lk=1a(){1b!!J.h9().3e(/^0?#/)}};K KV=1a(2e,bP){K o=[];1n(l=2e.1e,x=(bP||0)-1;x<l;x++){o.1C(2e[x])}1b o};$.4m(h6)})(2u);(1a($){$.gd=1a(o){if(2L dF=="1D"&&dF.KT){1b dF.KT(o)}K 1w=2L o;if(o===1c){1b"1c"}if(1w=="2O"){1b 2O}if(1w=="cJ"||1w=="l5"){1b o+""}if(1w=="4d"){1b $.vJ(o)}if(1w=="1D"){if(2L o.gd=="1a"){1b $.gd(o.gd())}if(o.4V===5k){K l9=o.Pq()+1;if(l9<10){l9="0"+l9}K lD=o.Pr();if(lD<10){lD="0"+lD}K KO=o.OD();K lx=o.OZ();if(lx<10){lx="0"+lx}K ly=o.P0();if(ly<10){ly="0"+ly}K kv=o.OP();if(kv<10){kv="0"+kv}K fR=o.OU();if(fR<100){fR="0"+fR}if(fR<10){fR="0"+fR}1b\'"\'+KO+"-"+l9+"-"+lD+"T"+lx+":"+ly+":"+kv+"."+fR+\'Z"\'}if(o.4V===3Y){K 7Y=[];1n(K i=0;i<o.1e;i++){7Y.1C($.gd(o[i])||"1c")}1b"["+7Y.4H(",")+"]"}K vK=[];1n(K k in o){K 1z;K 1w=2L k;if(1w=="cJ"){1z=\'"\'+k+\'"\'}1i{if(1w=="4d"){1z=$.vJ(k)}1i{ag}}if(2L o[k]=="1a"){ag}K 2h=$.gd(o[k]);vK.1C(1z+":"+2h)}1b"{"+vK.4H(", ")+"}"}};$.OR=1a(4a){if(2L dF=="1D"&&dF.oE){1b dF.oE(4a)}1b s5("("+4a+")")};$.OQ=1a(4a){if(2L dF=="1D"&&dF.oE){1b dF.oE(4a)}K fO=4a;fO=fO.3f(/\\\\["\\\\\\/P3]/g,"@");fO=fO.3f(/"[^"\\\\\\n\\r]*"|1o|1j|1c|-?\\d+(?:\\.\\d*)?(?:[eE][+\\-]?\\d+)?/g,"]");fO=fO.3f(/(?:^|:|,)(?:\\s*\\[)+/g,"");if(/^[\\],:{}\\s]*$/.9r(fO)){1b s5("("+4a+")")}1i{9K 1S OY("9h OX dF, aZ is 5L OA.")}};$.vJ=1a(4d){if(4d.3e(vO)){1b\'"\'+4d.3f(vO,1a(a){K c=KZ[a];if(2L c==="4d"){1b c}c=a.KJ();1b"\\\\Oz"+3F.gH(c/16).3r(16)+(c%16).3r(16)})+\'"\'}1b\'"\'+4d+\'"\'};K vO=/["\\\\\\OE-\\OL\\OJ-\\ON]/g;K KZ={"\\b":"\\\\b","\\t":"\\\\t","\\n":"\\\\n","\\f":"\\\\f","\\r":"\\\\r",\'"\':\'\\\\"\',"\\\\":"\\\\\\\\"}})(2u);(1a($){$.fn.vF=1a(){K 51=1a(el,v,t,sO){K 2T=2N.cb("2T");2T.1m=v,2T.1Y=t;K o=el.1x;K oL=o.1e;if(!el.7N){el.7N={};1n(K i=0;i<oL;i++){el.7N[o[i].1m]=i}}if(2L el.7N[v]=="2O"){el.7N[v]=oL}el.1x[el.7N[v]]=2T;if(sO){2T.1Q=1o}};K a=2q;if(a.1e==0){1b J}K sO=1o;K m=1j;K 1F,v,t;if(2L a[0]=="1D"){m=1o;1F=a[0]}if(a.1e>=2){if(2L a[1]=="l5"){sO=a[1]}1i{if(2L a[2]=="l5"){sO=a[2]}}if(!m){v=a[0];t=a[1]}}J.2g(1a(){if(J.8N.3R()!="2n"){1b}if(m){1n(K 1g in 1F){51(J,1g,1F[1g],sO)}}1i{51(J,v,t,sO)}});1b J};$.fn.OM=1a(5b,1v,2n,fn,2e){if(2L 5b!="4d"){1b J}if(2L 1v!="1D"){1v={}}if(2L 2n!="l5"){2n=1o}J.2g(1a(){K el=J;$.OG(5b,1v,1a(r){$(el).vF(r,2n);if(2L fn=="1a"){if(2L 2e=="1D"){fn.3d(el,2e)}1i{fn.2w(el)}}})});1b J};$.fn.L4=1a(){K a=2q;if(a.1e==0){1b J}K ta=2L a[0];K v,1P;if(ta=="4d"||(ta=="1D"||ta=="1a")){v=a[0];if(v.4V==3Y){K l=v.1e;1n(K i=0;i<l;i++){J.L4(v[i],a[1])}1b J}}1i{if(ta=="cJ"){1P=a[0]}1i{1b J}}J.2g(1a(){if(J.8N.3R()!="2n"){1b}if(J.7N){J.7N=1c}K 3u=1j;K o=J.1x;if(!!v){K oL=o.1e;1n(K i=oL-1;i>=0;i--){if(v.4V==dl){if(o[i].1m.3e(v)){3u=1o}}1i{if(o[i].1m==v){3u=1o}}if(3u&&a[1]===1o){3u=o[i].1Q}if(3u){o[i]=1c}3u=1j}}1i{if(a[1]===1o){3u=o[1P].1Q}1i{3u=1o}if(3u){J.3u(1P)}}});1b J};$.fn.OI=1a(vN){K L2=$(J).KU();K a=2L vN=="2O"?1o:!!vN;J.2g(1a(){if(J.8N.3R()!="2n"){1b}K o=J.1x;K oL=o.1e;K sA=[];1n(K i=0;i<oL;i++){sA[i]={v:o[i].1m,t:o[i].1Y}}sA.eU(1a(o1,o2){oC=o1.t.3R(),ou=o2.t.3R();if(oC==ou){1b 0}if(a){1b oC<ou?-1:1}1i{1b oC>ou?-1:1}});1n(K i=0;i<oL;i++){o[i].1Y=sA[i].t;o[i].1m=sA[i].v}}).qC(L2,1o);1b J};$.fn.qC=1a(1m,af){K v=1m;K vT=2L 1m;if(vT=="1D"&&v.4V==3Y){K $J=J;$.2g(v,1a(){$J.qC(J,af)})}K c=af||1j;if(vT!="4d"&&(vT!="1a"&&vT!="1D")){1b J}J.2g(1a(){if(J.8N.3R()!="2n"){1b J}K o=J.1x;K oL=o.1e;1n(K i=0;i<oL;i++){if(v.4V==dl){if(o[i].1m.3e(v)){o[i].1Q=1o}1i{if(c){o[i].1Q=1j}}}1i{if(o[i].1m==v){o[i].1Q=1o}1i{if(c){o[i].1Q=1j}}}}});1b J};$.fn.Pm=1a(to,iE){K w=iE||"1Q";if($(to).54()==0){1b J}J.2g(1a(){if(J.8N.3R()!="2n"){1b J}K o=J.1x;K oL=o.1e;1n(K i=0;i<oL;i++){if(w=="6k"||w=="1Q"&&o[i].1Q){$(to).vF(o[i].1m,o[i].1Y)}}});1b J};$.fn.Pp=1a(1m,fn){K 8K=1j;K v=1m;K vT=2L v;K fT=2L fn;if(vT!="4d"&&(vT!="1a"&&vT!="1D")){1b fT=="1a"?J:8K}J.2g(1a(){if(J.8N.3R()!="2n"){1b J}if(8K&&fT!="1a"){1b 1j}K o=J.1x;K oL=o.1e;1n(K i=0;i<oL;i++){if(v.4V==dl){if(o[i].1m.3e(v)){8K=1o;if(fT=="1a"){fn.2w(o[i],i)}}}1i{if(o[i].1m==v){8K=1o;if(fT=="1a"){fn.2w(o[i],i)}}}}});1b fT=="1a"?J:8K};$.fn.KU=1a(){K v=[];J.vE().2g(1a(){v[v.1e]=J.1m});1b v};$.fn.Pu=1a(){K t=[];J.vE().2g(1a(){t[t.1e]=J.1Y});1b t};$.fn.vE=1a(){1b J.2D("2T:1Q")}})(2u);(1a($){$.4m($.fn,{kw:1a(c1,c2){K KS=J.4s("."+c1);J.4s("."+c2).4h(c2).2t(c1);KS.4h(c1).2t(c2);1b J},hm:1a(c1,c2){1b J.4s("."+c1).4h(c1).2t(c2).4x()},sk:1a(bK){bK=bK||"6D";1b J.6D(1a(){$(J).2t(bK)},1a(){$(J).4h(bK)})},KE:1a(fZ,1Z){fZ?J.4J({1y:"cA"},fZ,1Z):J.2g(1a(){2u(J)[2u(J).is(":70")?"5e":"3J"]();if(1Z){1Z.3d(J,2q)}})},Km:1a(fZ,1Z){if(fZ){J.4J({1y:"3J"},fZ,1Z)}1i{J.3J();if(1Z){J.2g(1Z)}}},w0:1a(3W){if(!3W.KW){J.4s(":6Z-Pz:5L(ul)").2t(4O.6Z);J.4s((3W.gx?"":"."+4O.vQ)+":5L(."+4O.6K+")").2D(">ul").3J()}1b J.4s(":3o(>ul)")},vZ:1a(3W,k9){if(!3W.KW){J.4s(":3o(>ul:70)").2t(4O.aH).hm(4O.6Z,4O.hI);J.5L(":3o(>ul:70)").2t(4O.bG).hm(4O.6Z,4O.hv);J.j5(\'<2F 2C="\'+4O.4o+\'"/>\').2D("2F."+4O.4o).2g(1a(){K fg="";$.2g($(J).1L().1k("2C").3p(" "),1a(){fg+=J+"-4o "});$(J).2t(fg)})}J.2D("2F."+4O.4o).3I(k9)},il:1a(3W){3W=$.4m({vI:"il"},3W);if(3W.51){1b J.2c("51",[3W.51])}if(3W.cA){K 1Z=3W.cA;3W.cA=1a(){1b 1Z.3d($(J).1L()[0],2q)}}1a Ki(3X,31){1a 7u(4s){1b 1a(){k9.3d($("2F."+4O.4o,3X).4s(1a(){1b 4s?$(J).1L("."+4s).1e:1o}));1b 1j}}$("a:eq(0)",31).3I(7u(4O.bG));$("a:eq(1)",31).3I(7u(4O.aH));$("a:eq(2)",31).3I(7u())}1a k9(){$(J).1L().2D(">.4o").kw(4O.vn,4O.vU).kw(4O.qR,4O.qQ).4x().kw(4O.bG,4O.aH).kw(4O.hv,4O.hI).2D(">ul").KE(3W.fZ,3W.cA);if(3W.PB){$(J).1L().LP().2D(">.4o").hm(4O.vn,4O.vU).hm(4O.qR,4O.qQ).4x().hm(4O.bG,4O.aH).hm(4O.hv,4O.hI).2D(">ul").Km(3W.fZ,3W.cA)}}1a A0(){1a Pw(4i){1b 4i?1:0}K 1h=[];hH.2g(1a(i,e){1h[i]=$(e).is(":3o(>ul:6H)")?1:0});$.vG(3W.vI,1h.4H(""))}1a Kk(){K vH=$.vG(3W.vI);if(vH){K 1h=vH.3p("");hH.2g(1a(i,e){$(e).2D(">ul")[6i(1h[i])?"5e":"3J"]()})}}J.2t("il");K hH=J.2D("li").w0(3W);3q(3W.Px){1l"vG":K vY=3W.cA;3W.cA=1a(){A0();if(vY){vY.3d(J,2q)}};Kk();1p;1l"oA":K 5y=J.2D("a").4s(1a(){1b J.5d.3R()==oA.5d.3R()});if(5y.1e){5y.2t("1Q").cB("ul, li").51(5y.3k()).5e()}1p}hH.vZ(3W,k9);if(3W.31){Ki(J,3W.31);$(3W.31).5e()}1b J.2B("51",1a(1H,hH){$(hH).3O().4h(4O.6Z).4h(4O.hv).4h(4O.hI).2D(">.4o").4h(4O.qR).4h(4O.qQ);$(hH).2D("li").wL().w0(3W).vZ(3W,k9)})}});K 4O=$.fn.il.fg={6K:"6K",vQ:"vQ",aH:"aH",vU:"aH-4o",qQ:"hI-4o",bG:"bG",vn:"bG-4o",qR:"hv-4o",hv:"hv",hI:"hI",6Z:"6Z",4o:"4o"};$.fn.NU=$.fn.il})(2u);(1a($,2O){$.cn.JI="O0"in 3P;$.cn.JJ="NV"in 3P;$.cn.Lj="Ot"in 2N.9Q;K $7P=1c,lm=1j,$5l=$(3P),bE=0,9j={},he={},kg={},dh={3T:1c,4p:1c,2c:"7S",Lf:1j,eZ:fN,LG:1a($1T){if($.ui&&$.ui.2G){$1T.2Z("5q","6X").2G({my:"uH 1O",at:"uH 4G",of:J,2y:"0 5",kV:"al"}).2Z("5q","3t")}1i{K 2y=J.2y();2y.1O+=J.b4();2y.2a+=J.eB()/ 2 - $1T.eB() /2;$1T.2Z(2y)}},2G:1a(1B,x,y){K $J=J,2y;if(!x&&!y){1B.LG.2w(J,1B.$1T);1b}1i{if(x==="LF"&&y==="LF"){2y=1B.$1T.2G()}1i{K LE=1B.$2c.cB().wL().4s(1a(){1b $(J).2Z("2G")=="vS"}).1e;if(LE){y-=$5l.5a();x-=$5l.4S()}2y={1O:y,2a:x}}}K 4G=$5l.5a()+$5l.1y(),7S=$5l.4S()+$5l.1r(),1y=1B.$1T.1y(),1r=1B.$1T.1r();if(2y.1O+1y>4G){2y.1O-=1y}if(2y.2a+1r>7S){2y.2a-=1r}1B.$1T.2Z(2y)},LO:1a($1T){if($.ui&&$.ui.2G){$1T.2Z("5q","6X").2G({my:"2a 1O",at:"7S 1O",of:J,kV:"al"}).2Z("5q","")}1i{K 2y={1O:0,2a:J.eB()};$1T.2Z(2y)}},4j:Ov,6M:{6O:0,5e:"Os",3J:"Oo"},4v:{5e:$.vi,3J:$.vi},1Z:1c,1F:{}},aV={8E:1c,6T:1c,7o:1c},Lw=1a($t){K qO=0,$tt=$t,z=0;1n(K i=0;i<Op;i++){z=6i($tt.2Z("z-1P"),10);if(aE(z)){z=0}qO=3F.4y(qO,z);$tt=$tt.1L();if(!$tt||(!$tt.1e||"42 3U".4Y($tt.6J("8N").3R())>-1)){1p}}1b qO},4M={lq:1a(e){e.4g();e.cr()},5i:1a(e){K $J=$(J);e.4g();e.cr();if(e.1h.2c!="7S"&&e.cS){1b}if(!$J.4D("3l-1T-2x")){$7P=$J;if(e.1h.9z){K vg=e.1h.9z($7P,e);if(vg===1j){1b}e.1h=$.4m(1o,{},dh,e.1h,vg||{});if(!e.1h.1F||$.Jl(e.1h.1F)){if(3P.ck){(ck.96||ck.io)("No 1F Jh to 5e in 2M")}9K 1S 9h("No 2P Jk")}e.1h.$2c=$7P;op.7K(e.1h)}op.5e.2w($J,e.1h,e.6T,e.7o)}},3I:1a(e){e.4g();e.cr();$(J).2c($.qz("5i",{1h:e.1h,6T:e.6T,7o:e.7o}))},7i:1a(e){K $J=$(J);if($7P&&($7P.1e&&!$7P.is($J))){$7P.1h("2M").$1T.2c("5i:3J")}if(e.3C==2){$7P=$J.1h("vf",1o)}},5u:1a(e){K $J=$(J);if($J.1h("vf")&&($7P&&($7P.1e&&($7P.is($J)&&!$J.4D("3l-1T-2x"))))){e.4g();e.cr();$7P=$J;$J.2c($.qz("5i",{1h:e.1h,6T:e.6T,7o:e.7o}))}$J.rQ("vf")},lK:1a(e){K $J=$(J),$kd=$(e.kt),$2N=$(2N);if($kd.is(".3l-1T-4L")||$kd.fQ(".3l-1T-4L").1e){1b}if($7P&&$7P.1e){1b}aV.6T=e.6T;aV.7o=e.7o;aV.1h=e.1h;$2N.on("9x.Lz",4M.9x);aV.8E=6y(1a(){aV.8E=1c;$2N.ex("9x.Lz");$7P=$J;$J.2c($.qz("5i",{1h:aV.1h,6T:aV.6T,7o:aV.7o}))},e.1h.eZ)},9x:1a(e){aV.6T=e.6T;aV.7o=e.7o},lO:1a(e){K $kd=$(e.kt);if($kd.is(".3l-1T-4L")||$kd.fQ(".3l-1T-4L").1e){1b}7D{jh(aV.8E)}7C(e){}aV.8E=1c},J0:1a(e){K $J=$(J),2p=$J.1h("9q"),5u=1j,3C=e.3C,x=e.6T,y=e.7o,3m,2y,qM;e.4g();e.cr();$J.on("5u",1a(){5u=1o});6y(1a(){K $3P,qN;if(2p.2c=="2a"&&3C==0||2p.2c=="7S"&&3C==2){if(2N.qq){2p.$6o.3J();3m=2N.qq(x-$5l.4S(),y-$5l.5a());2p.$6o.5e();qM=[];1n(K s in 9j){qM.1C(s)}3m=$(3m).fQ(qM.4H(", "));if(3m.1e){if(3m.is(2p.$2c[0])){2p.2G.2w(2p.$2c,2p,x,y);1b}}}1i{2y=2p.$2c.2y();$3P=$(3P);2y.1O+=$3P.5a();if(2y.1O<=e.7o){2y.2a+=$3P.4S();if(2y.2a<=e.6T){2y.4G=2y.1O+2p.$2c.b4();if(2y.4G>=e.7o){2y.7S=2y.2a+2p.$2c.eB();if(2y.7S>=e.6T){2p.2G.2w(2p.$2c,2p,x,y);1b}}}}}}qN=1a(e){if(e){e.4g();e.cr()}2p.$1T.2c("5i:3J");if(3m&&3m.1e){6y(1a(){3m.2M({x:x,y:y})},50)}};if(5u){qN()}1i{$J.on("5u",qN)}},50)},fD:1a(e,1B){if(!1B.d7){e.4g()}e.7L()},1q:1a(e){K 1B=$7P.1h("2M")||{},$6C=1B.$1T.6C(),$4I;3q(e.3H){1l 9:;1l 38:4M.fD(e,1B);if(1B.d7){if(e.3H==9&&e.nC){e.4g();1B.$1Q&&1B.$1Q.2D("29, 7O, 2n").4P();1B.$1T.2c("wc");1b}1i{if(e.3H==38&&1B.$1Q.2D("29, 7O, 2n").6J("1w")=="7W"){e.4g();1b}}}1i{if(e.3H!=9||e.nC){1B.$1T.2c("wc");1b}};1l 40:4M.fD(e,1B);if(1B.d7){if(e.3H==9){e.4g();1B.$1Q&&1B.$1Q.2D("29, 7O, 2n").4P();1B.$1T.2c("qA");1b}1i{if(e.3H==40&&1B.$1Q.2D("29, 7O, 2n").6J("1w")=="7W"){e.4g();1b}}}1i{1B.$1T.2c("qA");1b}1p;1l 37:4M.fD(e,1B);if(1B.d7||(!1B.$1Q||!1B.$1Q.1e)){1p}if(!1B.$1Q.1L().4D("3l-1T-2p")){K $1L=1B.$1Q.1L().1L();1B.$1Q.2c("5i:4P");1B.$1Q=$1L;1b}1p;1l 39:4M.fD(e,1B);if(1B.d7||(!1B.$1Q||!1B.$1Q.1e)){1p}K qS=1B.$1Q.1h("2M")||{};if(qS.$1T&&1B.$1Q.4D("3l-1T-wt")){1B.$1Q=1c;qS.$1Q=1c;qS.$1T.2c("qA");1b}1p;1l 35:;1l 36:if(1B.$1Q&&1B.$1Q.2D("29, 7O, 2n").1e){1b}1i{(1B.$1Q&&1B.$1Q.1L()||1B.$1T).6C(":5L(.2x, .5L-jR)")[e.3H==36?"4t":"6Z"]().2c("5i:2R");e.4g();1b}1p;1l 13:4M.fD(e,1B);if(1B.d7){if(1B.$1Q&&!1B.$1Q.is("7O, 2n")){e.4g();1b}1p}1B.$1Q&&1B.$1Q.2c("5u");1b;1l 32:;1l 33:;1l 34:4M.fD(e,1B);1b;1l 27:4M.fD(e,1B);1B.$1T.2c("5i:3J");1b;5n:K k=5h.xh(e.3H).8u();if(1B.hk[k]){1B.hk[k].$1s.2c(1B.hk[k].$1T?"5i:2R":"5u");1b}1p}e.7L();1B.$1Q&&1B.$1Q.2c(e)},h7:1a(e){e.7L();K 1B=$(J).1h("2M")||{};if(1B.$1Q){K $s=1B.$1Q;1B=1B.$1Q.1L().1h("2M")||{};1B.$1Q=$s}K $6C=1B.$1T.6C(),$3O=!1B.$1Q||!1B.$1Q.3O().1e?$6C.6Z():1B.$1Q.3O(),$4I=$3O;44($3O.4D("2x")||$3O.4D("5L-jR")){if($3O.3O().1e){$3O=$3O.3O()}1i{$3O=$6C.6Z()}if($3O.is($4I)){1b}}if(1B.$1Q){4M.qw.2w(1B.$1Q.4u(0),e)}4M.qB.2w($3O.4u(0),e);K $29=$3O.2D("29, 7O, 2n");if($29.1e){$29.2R()}},gK:1a(e){e.7L();K 1B=$(J).1h("2M")||{};if(1B.$1Q){K $s=1B.$1Q;1B=1B.$1Q.1L().1h("2M")||{};1B.$1Q=$s}K $6C=1B.$1T.6C(),$3k=!1B.$1Q||!1B.$1Q.3k().1e?$6C.4t():1B.$1Q.3k(),$4I=$3k;44($3k.4D("2x")||$3k.4D("5L-jR")){if($3k.3k().1e){$3k=$3k.3k()}1i{$3k=$6C.4t()}if($3k.is($4I)){1b}}if(1B.$1Q){4M.qw.2w(1B.$1Q.4u(0),e)}4M.qB.2w($3k.4u(0),e);K $29=$3k.2D("29, 7O, 2n");if($29.1e){$29.2R()}},Lp:1a(e){K $J=$(J).fQ(".3l-1T-1g"),1h=$J.1h(),1B=1h.2M,2p=1h.9q;2p.$1Q=1B.$1Q=$J;2p.d7=1B.d7=1o},Ll:1a(e){K $J=$(J).fQ(".3l-1T-1g"),1h=$J.1h(),1B=1h.2M,2p=1h.9q;2p.d7=1B.d7=1j},Ix:1a(e){K 2p=$(J).1h().9q;2p.qY=1o},Iv:1a(e){K 2p=$(J).1h().9q;if(2p.$6o&&2p.$6o.is(e.kt)){2p.qY=1j}},qB:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2M,2p=1h.9q;2p.qY=1o;if(e&&(2p.$6o&&2p.$6o.is(e.kt))){e.4g();e.cr()}(1B.$1T?1B:2p).$1T.6C(".6D").2c("5i:4P");if($J.4D("2x")||$J.4D("5L-jR")){1B.$1Q=1c;1b}$J.2c("5i:2R")},qw:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2M,2p=1h.9q;if(2p!==1B&&(2p.$6o&&2p.$6o.is(e.kt))){2p.$1Q&&2p.$1Q.2c("5i:4P");e.4g();e.cr();2p.$1Q=1B.$1Q=1B.$1s;1b}$J.2c("5i:4P")},IO:1a(e){K $J=$(J),1h=$J.1h(),1B=1h.2M,2p=1h.9q,1q=1h.wK,1Z;if(!1B.1F[1q]||($J.4D("2x")||$J.4D("3l-1T-wt"))){1b}e.4g();e.cr();if($.e6(2p.ks[1q])){1Z=2p.ks[1q]}1i{if($.e6(2p.1Z)){1Z=2p.1Z}1i{1b}}if(1Z.2w(2p.$2c,1q,2p)!==1j){2p.$1T.2c("5i:3J")}1i{if(2p.$1T.1L().1e){op.89.2w(2p.$2c,2p)}}},IP:1a(e){e.cr()},IV:1a(e,1h){K 2p=$(J).1h("9q");op.3J.2w(2p.$2c,2p,1h&&1h.fm)},IM:1a(e){e.7L();K $J=$(J),1h=$J.1h(),1B=1h.2M,2p=1h.9q;$J.2t("6D").LP(".6D").2c("5i:4P");1B.$1Q=2p.$1Q=$J;if(1B.$1s){2p.LO.2w(1B.$1s,1B.$1T)}},JX:1a(e){e.7L();K $J=$(J),1h=$J.1h(),1B=1h.2M,2p=1h.9q;$J.4h("6D");1B.$1Q=1c}},op={5e:1a(1B,x,y){if(2L qZ!="2O"&&qZ){1b}qZ=1o;K $J=$(J),2y,2Z={};$("#3l-1T-6o").2c("7i");1B.$2c=$J;if(1B.4v.5e.2w($J,1B)===1j){$7P=1c;1b}op.89.2w($J,1B);1B.2G.2w($J,1B,x,y);if(1B.4j){2Z.4j=Lw($J)+1B.4j}op.6o.2w(1B.$1T,1B,2Z.4j);1B.$1T.2D("ul").2Z("4j",2Z.4j+1);1B.$1T.2Z(2Z)[1B.6M.5e](1B.6M.6O);$J.1h("2M",1B);$(2N).ex("7U.2M").on("7U.2M",4M.1q);if(1B.Lf){K 3V=$J.2G();3V.7S=3V.2a+$J.eB();3V.4G=3V.1O+J.b4();$(2N).on("9x.wj",1a(e){if(1B.$6o&&(!1B.qY&&(!(e.6T>=3V.2a&&e.6T<=3V.7S)||!(e.7o>=3V.1O&&e.7o<=3V.4G)))){1B.$1T.2c("5i:3J")}})}},3J:1a(1B,fm){K $J=$(J);if(!1B){1B=$J.1h("2M")||{}}if(!fm&&(1B.4v&&1B.4v.3J.2w($J,1B)===1j)){1b}if(1B.$6o){6y(1a($6o){1b 1a(){$6o.3u()}}(1B.$6o),10);7D{41 1B.$6o}7C(e){1B.$6o=1c}}$7P=1c;1B.$1T.2D(".6D").2c("5i:4P");1B.$1Q=1c;$(2N).ex(".wj").ex("7U.2M");1B.$1T&&1B.$1T[1B.6M.3J](1B.6M.6O,1a(){if(1B.9z){1B.$1T.3u();$.2g(1B,1a(1q,1m){3q(1q){1l"ns":;1l"3T":;1l"9z":;1l"2c":1b 1o;5n:1B[1q]=2O;7D{41 1B[1q]}7C(e){}1b 1o}})}});qZ=1j},7K:1a(1B,2p){if(2p===2O){2p=1B}1B.$1T=$(\'<ul 2C="3l-1T-4L \'+(1B.bK||"")+\'"></ul>\').1h({"2M":1B,"9q":2p});$.2g(["ks","qW","qu"],1a(i,k){1B[k]={};if(!2p[k]){2p[k]={}}});2p.hk||(2p.hk={});$.2g(1B.1F,1a(1q,1g){K $t=$(\'<li 2C="3l-1T-1g \'+(1g.bK||"")+\'"></li>\'),$3x=1c,$29=1c;1g.$1s=$t.1h({"2M":1B,"9q":2p,"wK":1q});if(1g.wC){K L7=IZ(1g.wC);1n(K i=0,ak;ak=L7[i];i++){if(!2p.hk[ak]){2p.hk[ak]=1g;1g.qU=1g.1z.3f(1S dl("("+ak+")","i"),\'<2E 2C="3l-1T-wC">$1</2E>\');1p}}}if(2L 1g=="4d"){$t.2t("3l-1T-5o 5L-jR")}1i{if(1g.1w&&kg[1g.1w]){kg[1g.1w].2w($t,1g,1B,2p);$.2g([1B,2p],1a(i,k){k.qW[1q]=1g;if($.e6(1g.1Z)){k.ks[1q]=1g.1Z}})}1i{if(1g.1w=="42"){$t.2t("3l-1T-42 5L-jR")}1i{if(1g.1w){$3x=$("<3x></3x>").4p($t);$("<2E></2E>").42(1g.qU||1g.1z).4p($3x);$t.2t("3l-1T-29");1B.Lk=1o;$.2g([1B,2p],1a(i,k){k.qW[1q]=1g;k.qu[1q]=1g})}1i{if(1g.1F){1g.1w="jl"}}}3q(1g.1w){1l"1Y":$29=$(\'<29 1w="1Y" 1m="1" 1z="3l-1T-29-\'+1q+\'" 1m="">\').2h(1g.1m||"").4p($3x);1p;1l"7O":$29=$(\'<7O 1z="3l-1T-29-\'+1q+\'"></7O>\').2h(1g.1m||"").4p($3x);if(1g.1y){$29.1y(1g.1y)}1p;1l"7W":$29=$(\'<29 1w="7W" 1m="1" 1z="3l-1T-29-\'+1q+\'" 1m="">\').2h(1g.1m||"").6J("3B",!!1g.1Q).A5($3x);1p;1l"8q":$29=$(\'<29 1w="8q" 1m="1" 1z="3l-1T-29-\'+1g.8q+\'" 1m="">\').2h(1g.1m||"").6J("3B",!!1g.1Q).A5($3x);1p;1l"2n":$29=$(\'<2n 1z="3l-1T-29-\'+1q+\'">\').4p($3x);if(1g.1x){$.2g(1g.1x,1a(1m,1Y){$("<2T></2T>").2h(1m).1Y(1Y).4p($29)});$29.2h(1g.1Q)}1p;1l"jl":$("<2E></2E>").42(1g.qU||1g.1z).4p($t);1g.4p=1g.$1s;op.7K(1g,2p);$t.1h("2M",1g).2t("3l-1T-wt");1g.1Z=1c;1p;1l"42":$(1g.42).4p($t);1p;5n:$.2g([1B,2p],1a(i,k){k.qW[1q]=1g;if($.e6(1g.1Z)){k.ks[1q]=1g.1Z}});$("<2E></2E>").42(1g.qU||(1g.1z||"")).4p($t);1p}if(1g.1w&&(1g.1w!="jl"&&1g.1w!="42")){$29.on("2R",4M.Lp).on("4P",4M.Ll);if(1g.4v){$29.on(1g.4v,1B)}}if(1g.3L){$t.2t("3L 3L-"+1g.3L)}}}1g.$29=$29;1g.$3x=$3x;$t.4p(1B.$1T);if(!1B.Lk&&$.cn.Lj){$t.on("R6.RL",4M.lq)}});if(!1B.$1s){1B.$1T.2Z("5q","3t").2t("3l-1T-2p")}1B.$1T.4p(1B.4p||2N.3U)},89:1a(1B,2p){K $J=J;if(2p===2O){2p=1B;1B.$1T.2D("ul").wL().2Z({2G:"vm",5q:"6X"}).2g(1a(){K $J=$(J);$J.1r($J.2Z("2G","8x").1r()).2Z("2G","vm")}).2Z({2G:"",5q:""})}1B.$1T.6C().2g(1a(){K $1g=$(J),1q=$1g.1h("wK"),1g=1B.1F[1q],2x=$.e6(1g.2x)&&1g.2x.2w($J,1q,2p)||1g.2x===1o;$1g[2x?"2t":"4h"]("2x");if(1g.1w){$1g.2D("29, 2n, 7O").6J("2x",2x);3q(1g.1w){1l"1Y":;1l"7O":1g.$29.2h(1g.1m||"");1p;1l"7W":;1l"8q":1g.$29.2h(1g.1m||"").6J("3B",!!1g.1Q);1p;1l"2n":1g.$29.2h(1g.1Q||"");1p}}if(1g.$1T){op.89.2w($J,1g,2p)}})},6o:1a(1B,4j){$l=$("#3l-1T-6o");if($l){$l.3u()}K $6o=1B.$6o=$(\'<2F id="3l-1T-6o" 3b="2G:vS; z-1P:\'+4j+\'; 1O:0; 2a:0; 2I: 0; 4s: dt(2I=0); iH-3s: #c8;"></2F>\').2Z({1y:$5l.1y(),1r:$5l.1r(),5q:"6X"}).1h("9q",1B).76(J).on("5i",4M.lq).on("7i",4M.J0);if(!$.cn.RT){$6o.2Z({"2G":"8x","1y":$(2N).1y()})}1b $6o}};1a IZ(2h){K t=2h.3p(/\\s+/),81=[];1n(K i=0,k;k=t[i];i++){k=k[0].8u();81.1C(k)}1b 81}$.fn.2M=1a(7J){if(7J===2O){J.4t().2c("5i")}1i{if(7J.x&&7J.y){J.4t().2c($.qz("5i",{6T:7J.x,7o:7J.y}))}1i{if(7J==="3J"){K $1T=J.1h("2M").$1T;$1T&&$1T.2c("5i:3J")}1i{if(7J==="1f"){if(J.1h("2M")!=1c){1b J.1h("2M").$1T}1b[]}1i{if(7J){J.4h("3l-1T-2x")}1i{if(!7J){J.2t("3l-1T-2x")}}}}}}1b J};$.2M=1a(7J,1x){if(2L 7J!="4d"){1x=7J;7J="7K"}if(2L 1x=="4d"){1x={3T:1x}}1i{if(1x===2O){1x={}}}K o=$.4m(1o,{},dh,1x||{}),$2N=$(2N);3q(7J){1l"7K":if(!o.3T){9K 1S 9h("No 3T Jh")}if(o.3T.3e(/.3l-1T-(4L|1g|29)($|\\s)/)){9K 1S 9h(\'Rx 2B to 3T "\'+o.3T+\'" as it h8 a Ru bK\')}if(!o.9z&&(!o.1F||$.Jl(o.1F))){9K 1S 9h("No 2P Jk")}bE++;o.ns=".2M"+bE;9j[o.3T]=o.ns;he[o.ns]=o;if(!o.2c){o.2c="7S"}if(!lm){$2N.on({"5i:3J.2M":4M.IV,"wc.2M":4M.h7,"qA.2M":4M.gK,"5i.2M":4M.lq,"lK.2M":4M.Ix,"lO.2M":4M.Iv},".3l-1T-4L").on("5u.2M",".3l-1T-29",4M.IP).on({"5u.2M":4M.IO,"5i:2R.2M":4M.IM,"5i:4P.2M":4M.JX,"5i.2M":4M.lq,"lK.2M":4M.qB,"lO.2M":4M.qw},".3l-1T-1g");lm=1o}$2N.on("5i"+o.ns,o.3T,o,4M.5i);3q(o.2c){1l"6D":$2N.on("lK"+o.ns,o.3T,o,4M.lK).on("lO"+o.ns,o.3T,o,4M.lO);1p;1l"2a":$2N.on("3I"+o.ns,o.3T,o,4M.3I);1p}if(!o.9z){op.7K(o)}1p;1l"69":if(!o.3T){$2N.ex(".2M .wj");$.2g(9j,1a(1q,1m){$2N.ex(1m)});9j={};he={};bE=0;lm=1j;$("#3l-1T-6o, .3l-1T-4L").3u()}1i{if(9j[o.3T]){K $qt=$(".3l-1T-4L").4s(":6H");if($qt.1e&&$qt.1h().9q.$2c.is(o.3T)){$qt.2c("5i:3J",{fm:1o})}7D{if(he[9j[o.3T]].$1T){he[9j[o.3T]].$1T.3u()}41 he[9j[o.3T]]}7C(e){he[9j[o.3T]]=1c}$2N.ex(9j[o.3T])}}1p;1l"QI":if(!$.cn.JJ&&!$.cn.JI||2L 1x=="l5"&&1x){$(\'1T[1w="3l"]\').2g(1a(){if(J.id){$.2M({3T:"[5i="+J.id+"]",1F:$.2M.N0(J)})}}).2Z("5q","3t")}1p;5n:9K 1S 9h(\'fz 7J "\'+7J+\'"\')}1b J};$.2M.Qk=1a(1B,1h){if(1h===2O){1h={}}$.2g(1B.qu,1a(1q,1g){3q(1g.1w){1l"1Y":;1l"7O":1g.1m=1h[1q]||"";1p;1l"7W":1g.1Q=1h[1q]?1o:1j;1p;1l"8q":1g.1Q=(1h[1g.8q]||"")==1g.1m?1o:1j;1p;1l"2n":1g.1Q=1h[1q]||"";1p}})};$.2M.Qm=1a(1B,1h){if(1h===2O){1h={}}$.2g(1B.qu,1a(1q,1g){3q(1g.1w){1l"1Y":;1l"7O":;1l"2n":1h[1q]=1g.$29.2h();1p;1l"7W":1h[1q]=1g.$29.6J("3B");1p;1l"8q":if(1g.$29.6J("3B")){1h[1g.8q]=1g.1m}1p}});1b 1h};1a kj(1s){1b 1s.id&&$(\'3x[1n="\'+1s.id+\'"]\').2h()||1s.1z}1a uo(1F,$6C,bE){if(!bE){bE=0}$6C.2g(1a(){K $1s=$(J),1s=J,8N=J.8N.3R(),3x,1g;if(8N=="3x"&&$1s.2D("29, 7O, 2n").1e){3x=$1s.1Y();$1s=$1s.6C().4t();1s=$1s.4u(0);8N=1s.8N.3R()}3q(8N){1l"1T":1g={1z:$1s.1k("3x"),1F:{}};bE=uo(1g.1F,$1s.6C(),bE);1p;1l"a":;1l"3C":1g={1z:$1s.1Y(),2x:!!$1s.1k("2x"),1Z:1a(){1b 1a(){$1s.3I()}}()};1p;1l"JD":;1l"8h":3q($1s.1k("1w")){1l 2O:;1l"8h":;1l"JD":1g={1z:$1s.1k("3x"),2x:!!$1s.1k("2x"),1Z:1a(){1b 1a(){$1s.3I()}}()};1p;1l"7W":1g={1w:"7W",2x:!!$1s.1k("2x"),1z:$1s.1k("3x"),1Q:!!$1s.1k("3B")};1p;1l"8q":1g={1w:"8q",2x:!!$1s.1k("2x"),1z:$1s.1k("3x"),8q:$1s.1k("Qg"),1m:$1s.1k("id"),1Q:!!$1s.1k("3B")};1p;5n:1g=2O}1p;1l"hr":1g="-------";1p;1l"29":3q($1s.1k("1w")){1l"1Y":1g={1w:"1Y",1z:3x||kj(1s),2x:!!$1s.1k("2x"),1m:$1s.2h()};1p;1l"7W":1g={1w:"7W",1z:3x||kj(1s),2x:!!$1s.1k("2x"),1Q:!!$1s.1k("3B")};1p;1l"8q":1g={1w:"8q",1z:3x||kj(1s),2x:!!$1s.1k("2x"),8q:!!$1s.1k("1z"),1m:$1s.2h(),1Q:!!$1s.1k("3B")};1p;5n:1g=2O;1p}1p;1l"2n":1g={1w:"2n",1z:3x||kj(1s),2x:!!$1s.1k("2x"),1Q:$1s.2h(),1x:{}};$1s.6C().2g(1a(){1g.1x[J.1m]=$(J).1Y()});1p;1l"7O":1g={1w:"7O",1z:3x||kj(1s),2x:!!$1s.1k("2x"),1m:$1s.2h()};1p;1l"3x":1p;5n:1g={1w:"42",42:$1s.5S(1o)};1p}if(1g){bE++;1F["1q"+bE]=1g}});1b bE}$.2M.N0=1a(1f){K $J=$(1f),1F={};uo(1F,$J.6C());1b 1F};$.2M.dh=dh;$.2M.kg=kg})(2u);K Mo=1a(id){J.id=id;J.1f=1c;J.2H=1S 3Y;J.lc=0;J.uE=20;J.ur=1a(2H){41 J.2H;J.2H=1S 3Y;K li=1S 3Y;1n(K i=0;i<2H.1e;i++){K 1m=2H[i];li.1C(\'<li 1m="\'+i+\'" 2C="\'+1m.dv+\'">\'+1m.1Y+"</li>");J.2H.1C(1m.1m)}J.1f.42("<ul>"+li.4H("\\n")+"</ul>");K me=J;J.1f.4N("5u",1a(e){K li=e.3m;if(li.68.8u()!="LI"){1b}K $li=$(e.3m);e.7L();J.r0.qE($li.1Y(),me.r0.ib(li.1m))},J).4N("7i",1a(e){e.7L()},J);J.N6();J.ro(10)};J.N6=1a(){J.1f.2Z("gG","70");J.1f.5e();K 9C=J.1f.2D("li");if(9C.1e>0){J.uE=9C[0].bj}J.1f.2Z("gG","6H");J.1f.3J()};J.ro=1a(ku){if(J.1f.2D("li").1e>ku){J.lc=J.uE*ku;J.1f.2Z("1y",J.lc+"px");J.1f.2Z("gh","6p")}1i{J.1f.2Z("1y","6p");J.1f.2Z("gh","6H")}};J.ib=1a(1P){1b J.2H[1P]};J.N8=1a(){J.1f.2D("li").4h("3e")};J.z4=1a(1Y){K bh=ju(1Y);J.N8();K 8y=J.qH(bh);$(8y).2t("3e");if(8y.1e>0){J.qI($(8y[0]))}1i{J.uQ()}};J.NO=1a(1Y){K bh=ju(1Y);K 8y=J.qH(bh);K 5y=J.i3();if(5y.1e>0&&8y.1e>1){K 1P=8y.4Y(5y[0]);if(1P<8y.1e-1){1b $(8y[1P+1])}1i{1b $(8y[0])}}1b 1c};J.NN=1a(1Y){K bh=ju(1Y);K 8y=J.qH(bh);K 5y=J.i3();if(5y.1e>0&&8y.1e>1){K 1P=8y.4Y(5y[0]);if(1P>0){1b $(8y[1P-1])}1i{1b $(8y[8y.1e-1])}}1b 1c};J.qH=1a(1Y){K 1J=[];if(1K(1Y)){1b 1J}K cp=1Y.3f(/([$-/:-?{-~!"^1U`\\[\\]\\\\])/g, "\\\\$1");K 9C=J.1f.2D("li");1n(K i=0;i<9C.1e;i++){K li=9C[i];K uF=ju(!1K(li.Ns)?li.Ns:li.QK);K uw=ju(J.ib(li.1m));if(QB.1d.2U.sq){cp="(^"+1Y+")|([.]"+1Y+")"}if(1Y==uF||1Y==uw){1J.1C(li)}1i{if(uF.9r(cp)||uw.9r(cp)){1J.1C(li)}}}1b 1J};J.ut=1a(){J.1f.2D("li.1Q").4h("1Q")};J.uj=1a(1Y,cF,eT){K li=J.i3();if(!li.1e){li=J.uQ()}K eN=1c;if(cF=="cT"){if(eT){eN=J.NO(1Y)}if(eN==1c){eN=li.3k()}}1i{if(cF=="up"){if(eT){eN=J.NN(1Y)}if(eN==1c){eN=li.3O()}}}if(eN!=1c){J.qI(eN);J.MZ(li)}};J.qI=1a(li){J.ut();li.2t("1Q");J.Mi(li)};J.uQ=1a(){K 4t=J.1f.2D("li:4t");J.qI(4t);1b 4t};J.MZ=1a(k4){k4.4h("1Q")};J.i3=1a(){1b J.1f.2D("li.1Q")};J.Mi=1a(k4){if(J.lc&&(k4!=1c&&k4.1e>0)){J.1f.5a(k4[0].9p-J.lc/2)}};J.7I=1a(){J.1f=$(\'<2F 2C="ba-2n-1x"></2F>\').4p($(2N.3U))};J.7I()};K 9R={qJ:{},bd:[],nf:{},uY:1j,3l:1c,7I:1a(){J.Mu();J.uY=1o},Mu:1a(){},v7:1a(9E){if(1K(9E)||1K(J.qJ[9E])){J.qJ[9E]=1S Mo(9E)}1b J.qJ[9E]},zQ:1a(id,2H){J.v7(id).ur(2H)}};(1a($){$.fn.zh=1a(1x){if(!9R.uY){9R.7I()}K me=J;K dh={8Q:1j,fE:1o,ku:10,PU:1j};K 3W=$.4m(dh,1x);K qD=1j;$(J).2g(1a(i,uX){K 1f=$(uX);if(1f.1h("ba-hj")==2O){9R.bd.1C(1S uL(uX,3W));1f.1h("ba-hj",9R.bd.1e-1)}});1b $(J)};$.fn.zm=1a(){K 7Y=[];$(J).2g(1a(){if($(J).1h("ba-hj")!==2O){7Y[7Y.1e]=9R.bd[$(J).1h("ba-hj")]}});1b 7Y};K uL=1a(2n,3W){J.7I(2n,3W)};uL.2S={i0:1j,3W:1j,5A:1j,2n:1j,5O:1j,9E:1c,hh:1j,PL:1j,8Q:1j,Q9:13,bh:"",Q6:[],eT:1j,Mz:1j,7I:1a(2n,3W){J.3W=3W;J.9E=J.3W.9E;J.5O=9R.v7(J.9E);J.7u=J.3W.fE;if(!1K(J.9E)){9R.nf[J.9E]=J.3W.fE}J.1x=[];if(!1K(J.3W.1x)){J.1x=J.3W.1x}J.2n=$(2n);J.5A=$(\'<29 1w="1Y">\');J.5A.1k("5t-3x",J.2n.1k("5t-3x"));J.5A.2h(J.3W.1m);J.5A.1k("1z",J.2n.1k("1z"));J.5A.1h("ba-hj",J.2n.1h("ba-hj"));J.2n.1k("2x","2x");K id=J.2n.1k("id");if(!id){id="ba-2n"+9R.bd.1e}J.id=id;J.5A.1k("id",id);J.5A.1k("Qc","ex");J.5A.2t("ba-2n");J.2n.1k("id",id+"Q0");J.Nf(J.5A,J);J.MU();J.M3();J.M9();if(J.3W.8Q){K 8Q=$(\'<dG Q2="0" 2C="ba-2n-dG" 4a="Ic:yE;"></dG>\');$(2N.3U).3a(8Q);8Q.1r(J.2n.1r()+2);8Q.1y(J.5O.1f.1y());8Q.2Z({1O:J.5O.1f.2Z("1O"),2a:J.5O.1f.2Z("2a")});J.8Q=8Q}},MU:1a(){K me=J;K RE=1j;K 2H=1S 3Y;J.2n.2D("2T").2g(1a(1P,2T){K $2T=$(2T);K 1Y=$2T.1Y();K 2h=$2T.1k("1m");K 1Q=1j;if($2T.1k("1Q")||2T.1Q){me.5A.2h(1Y);me.bh=1Y;me.NG=2h;1Q=1o}K dv=$2T.1k("2C");2H.1C({1Q:1Q,1Y:1Y,1m:2h,dv:dv})});if(2H.1e>0){J.5O.ur(2H);J.5O.1f.2t("sE-CN");J.5O.ro(J.3W.ku)}},zl:1a(){1b J.5A},fE:1a(){K 3l=J.5O.r0;if(2L 3l.7u=="1a"){3l.7u.2w(3l,3l.5A)}},ux:1a(){if(J.i0){1b}J.i0=1o;J.bh=J.5A.2h();J.eT=1j;J.zd(J);if(J.Mz){J.le()}},hT:1a(){if(!J.i0){1b}J.5O.ut();J.rr();J.fE();J.i0=1j},M7:1a(RV){if(J.5A.2h()!=J.bh){J.eT=1o;J.bh=J.5A.2h();J.5O.z4(J.5A.2h())}},Nf:1a(5A,R1){K me=J;K 8E=1j;5A.2R(1a(e){me.ux()}).4P(1a(e){if(!me.hh){me.hT()}}).3I(1a(e){e.7L();me.ux();if(e.6T-$(J).2y().2a>$(J).1r()-16){if(me.hh){me.rr()}1i{me.le()}}}).7U(1a(e){me.i0=1o;3q(e.3H){1l 40:if(!me.za()){me.le()}1i{e.4g();me.5O.uj(me.5A.2h(),"cT",me.eT)}1p;1l 38:if(!me.za()){me.le()}1i{e.4g();me.5O.uj(me.5A.2h(),"up",me.eT)}1p;1l 9:K $li=me.5O.i3();if($li.1e){me.qE($li.1Y(),me.ib($li[0].1m))}1p;1l 27:e.4g();me.hT();1b 1j;1p;1l 13:e.4g();if(!me.hh){me.hT()}1i{K $li=me.5O.i3();if($li.1e){me.qE($li.1Y(),me.ib($li[0].1m))}}1b 1j;1p}}).wz($.hn(me.M7,100,me)).h3(1a(e){if(e.3H==13){e.4g();1b 1j}})},qE:1a(1Y,2h){J.bh=1Y;J.NG=2h;J.5A.2h(2h);J.hT()},za:1a(){1b J.hh},zd:1a(3l){J.NP();J.NR();9R.3l=3l;J.5O.r0=3l},NP:1a(){K 2y=J.5A.2y();2y.1O+=J.5A[0].bj;J.5O.1f.2Z({1O:2y.1O+"px",2a:2y.2a+"px"})},NR:1a(){K 1r=J.5A[0].nR;J.5O.1f.1r(1r);J.5A.1r(1r)},le:1a(){J.N4();J.7F=1S $.ui.da.7F(J);J.5O.1f.5e();J.zd(J);J.hh=1o;if(J.3W.8Q){J.8Q.5e()}J.5O.ro(10);J.5O.z4(J.5A.2h())},ib:1a(1P){1b J.5O.2H[1P]},rr:1a(){if(J.7F!=1c){J.7F.69()}J.5O.1f.3J();J.hh=1j;if(J.3W.8Q){J.8Q.3J()}},N4:1a(){1n(K i=0;i<9R.bd.1e;i++){if(i!=J.2n.1h("ba-hj")){9R.bd[i].rr()}}},M3:1a(){J.2n.tP(J.5A);J.2n.3J();$(2N.3U).3a(J.5O.1f)},M9:1a(){K 1r=J.2n.1r()+2*0;if(J.8Q){J.8Q.1r(1r+4)}}};$.ui.da={7F:1a(3i){J.$el=$.ui.da.7F.7K(3i)}};$.4m($.ui.da.7F,{2o:J,bd:[],NT:[],m5:BV,4v:$.eO("2R,7i,7U,h3".3p(","),1a(1H){1b 1H+".3i-7F"}).4H(" "),7K:1a(3i){if(J.bd.1e===0){$(3P).2B("71.3i-7F",$.ui.da.7F.71)}K $el=$(\'<2F 2C="ba-2n-1x-7F"></2F>\').4p(3i.5A.1L()).2Z({1r:J.1r(),1y:J.1y()});$el.2B("7i.3i-7F",1a(1H){3i.hT();K 1f=2N.qq(1H.aB,1H.aT);if(1f!=1c){7D{K cd="3I";if(1f.zr){K e=2N.MY("P9");e.MK(cd,1o,1o,3P,0,1H.MS,1H.MV,1H.aB,1H.aT,1j,1j,1j,1j,0,1c);1f.zr(e)}1i{if(1f.M4){1f.M4("on"+cd)}}}7C(Ox){}}});if($.fn.ey){$el.ey()}J.bd.1C($el);1b $el},69:1a($el){if($el!=1c){$el.3u()}if(J.bd.1e===0){$([2N,3P]).7V(".3i-7F")}},1y:1a(){K s6,bj;1b $(2N).1y()+"px"},1r:1a(){K BG,fC;1b $(2N).1r()+"px"},71:1a(){K $rn=$([]);$.2g($.ui.da.7F.bd,1a(){$rn=$rn.51(J)});$rn.2Z({1r:0,1y:0}).2Z({1r:$.ui.da.7F.1r(),1y:$.ui.da.7F.1y()})}});$.4m($.ui.da.7F.2S,{69:1a(){$.ui.da.7F.69(J.$el)}})})(2u);(1a($){K R=$.jd=$.fn.jd=1a(a,b,c){1b R.yL(l6.3d(J,2q))};1a l6(a,b,c){K r=$.4m({},R);if(2L a=="4d"){r.5b=a;if(b&&!$.e6(b)){r.dS=b}1i{c=b}if(c){r.B2=c}}1i{$.4m(r,a)}if(!r.45){r.45=$.Ej?"P4":"B5"}if(!r.3m){r.3m=J?J:$}if(!r.1w&&!$.Ej){r.1w="OW"}1b r}$.4m(R,{5N:"0.5",5b:1c,dS:OC,B2:1c,45:1c,yL:1a(r){if(r.hS){r.hS()}r.id=l0(1a(){r.jd(r)},r.dS*93);r.hS=1a(){rk(r.id);1b r};1b r},jd:1a(r){if(r.yP){41 r.yP}r.yP=r.3m[r.45](r)}})})(2u);2u.4e={bI:1c,9A:1c,rl:1c,rm:0,9z:1a(1x){J.2g(1a(){J.bH=2u.4m({E1:1c,F0:1c,lv:"Po",sF:1c,ln:1c,lF:5,A3:/[^\\-]*$/,PA:1c,nA:1c},1x||{});2u.4e.yG(J)});2u(2N).2B("9x",2u.4e.9x).2B("5u",2u.4e.5u);1b J},yG:1a(1M){K 6t=1M.bH;if(1M.bH.nA){$(2N).on("7i","#qb-ui-3M td."+1M.bH.nA,1a(ev){2u.4e.9A=J.3n;2u.4e.bI=1M;2u.4e.rl=2u.4e.yF(J,ev);if(6t.ln){6t.ln(1M,J)}1b 1j})}1i{K 2X=2u("tr",1M);$(2N).on("7i","#qb-ui-3M 1M td."+1M.bH.nA,1a(ev){if(ev.3m.68=="TD"){2u.4e.9A=J;2u.4e.bI=1M;2u.4e.rl=2u.4e.yF(J,ev);if(6t.ln){6t.ln(1M,J)}1b 1j}})}},EJ:1a(){J.2g(1a(){if(J.bH){2u.4e.yG(J)}})},z1:1a(ev){if(ev.6T||ev.7o){1b{x:ev.6T,y:ev.7o}}1b{x:ev.aB+2N.3U.4S-2N.3U.j4,y:ev.aT+2N.3U.5a-2N.3U.j2}},yF:1a(3m,ev){ev=ev||3P.1H;K yJ=J.rA(3m);K hd=J.z1(ev);1b{x:hd.x-yJ.x,y:hd.y-yJ.y}},rA:1a(e){K 2a=0;K 1O=0;if(e.bj==0){e=e.7A}44(e.e5){2a+=e.8l;1O+=e.9p;e=e.e5}2a+=e.8l;1O+=e.9p;1b{x:2a,y:1O}},9x:1a(ev){if(2u.4e.9A==1c){1b}K rs=2u(2u.4e.9A);K 6t=2u.4e.bI.bH;K hd=2u.4e.z1(ev);K y=hd.y-2u.4e.rl.y;K lE=3P.Ha;if(2N.6k){if(2L 2N.DO!="2O"&&2N.DO!="Pl"){lE=2N.9Q.5a}1i{if(2L 2N.3U!="2O"){lE=2N.3U.5a}}}if(hd.y-lE<6t.lF){3P.vX(0,-6t.lF)}1i{K DY=3P.DR?3P.DR:2N.9Q.rt?2N.9Q.rt:2N.3U.rt;if(DY-(hd.y-lE)<6t.lF){3P.vX(0,6t.lF)}}if(y!=2u.4e.rm){K yS=y>2u.4e.rm;2u.4e.rm=y;if(6t.lv){rs.2t(6t.lv)}1i{rs.2Z(6t.E1)}K gQ=2u.4e.F3(rs,y);if(gQ&&gQ.bK!="ui-qb-3M-1I-80"){if(yS&&2u.4e.9A!=gQ){2u.4e.9A.3n.76(2u.4e.9A,gQ.iN)}1i{if(!yS&&2u.4e.9A!=gQ){2u.4e.9A.3n.76(2u.4e.9A,gQ)}}}}1b 1j},F3:1a(zt,y){K 2X=2u.4e.bI.2X;1n(K i=0;i<2X.1e;i++){K 1I=2X[i];K rB=J.rA(1I).y;K ru=6i(1I.bj)/2;if(1I.bj==0){rB=J.rA(1I.7A).y;ru=6i(1I.7A.bj)/2}if(y>rB-ru&&y<rB+ru){if(1I==zt){1b 1c}K 6t=2u.4e.bI.bH;if(6t.F2){if(6t.F2(zt,1I)){1b 1I}1i{1b 1c}}1i{K A1=2u(1I).4D("A1");if(!A1){1b 1I}1i{1b 1c}}1b 1I}}1b 1c},5u:1a(e){if(2u.4e.bI&&2u.4e.9A){K rj=2u.4e.9A;K 6t=2u.4e.bI.bH;if(6t.lv){2u(rj).4h(6t.lv)}1i{2u(rj).2Z(6t.F0)}2u.4e.9A=1c;if(6t.sF){6t.sF(2u.4e.bI,rj)}2u.4e.bI=1c}},A0:1a(){if(2u.4e.bI){1b 2u.4e.A2(2u.4e.bI)}1i{1b"9h: No cM id 5v, Gh MO to 5v an id on Fq 1M nc A4 1I"}},A2:1a(1M){K 1J="";K Fb=1M.id;K 2X=1M.2X;1n(K i=0;i<2X.1e;i++){if(1J.1e>0){1J+="&"}K iz=2X[i].id;if(iz&&(iz&&(1M.bH&&1M.bH.A3))){iz=iz.3e(1M.bH.A3)[0]}1J+=Fb+"[]="+iz}1b 1J},EE:1a(){K 1J="";J.2g(1a(){1J+=2u.4e.A2(J)});1b 1J}};2u.fn.4m({4e:2u.4e.9z,QR:2u.4e.EJ,QZ:2u.4e.EE});(1a($){$.8F("ui.3j",{1x:{4p:"3U",Dp:93,3b:"hA",HP:1c,1r:1c,kO:1c,D2:26,8Z:1c,b9:1c,6s:1c,HC:1j,kG:1a(){}},sv:1a(){K 2o=J,o=J.1x;K r5=J.1f.RO().1k("id");J.d6=[r5,r5+"-3C",r5+"-1T"];J.r4=1o;J.iu=1j;J.64=$("<a />",{"2C":"ui-3j ui-8F ui-56-5n ui-aj-6k","id":J.d6[1],"ht":"3C","5d":"#zN","67":J.1f.1k("2x")?1:0,"5t-RS":1o,"5t-RU":J.d6[2]});J.xt=$("<2E />").3a(J.64).e7(J.1f);K 67=J.1f.1k("67");if(67){J.64.1k("67",67)}J.64.1h("Ht",J.1f);J.D7=$(\'<2E 2C="ui-3j-3L ui-3L"></2E>\').A5(J.64);J.64.j5(\'<2E 2C="ui-3j-6F" />\');J.1f.2B({"3I.3j":1a(1H){2o.64.2R();1H.4g()}});J.64.2B("7i.3j",1a(1H){2o.xj(1H,1o);if(o.3b=="iQ"){2o.r4=1j;6y(1a(){2o.r4=1o},sC)}1H.4g()}).2B("3I.3j",1a(1H){1H.4g()}).2B("7U.3j",1a(1H){K 7Y=1j;3q(1H.3H){1l $.ui.3H.CD:7Y=1o;1p;1l $.ui.3H.CF:2o.xj(1H);1p;1l $.ui.3H.UP:if(1H.r6){2o.6K(1H)}1i{2o.ij(-1)}1p;1l $.ui.3H.EQ:if(1H.r6){2o.6K(1H)}1i{2o.ij(1)}1p;1l $.ui.3H.EM:2o.ij(-1);1p;1l $.ui.3H.EL:2o.ij(1);1p;1l $.ui.3H.CW:7Y=1o;1p;1l $.ui.3H.CI:;1l $.ui.3H.EO:2o.1P(0);1p;1l $.ui.3H.CK:;1l $.ui.3H.CL:2o.1P(2o.8a.1e);1p;5n:7Y=1o}1b 7Y}).2B("h3.3j",1a(1H){if(1H.iE>0){2o.zL(1H.iE,"5u")}1b 1o}).2B("ha.3j",1a(){if(!o.2x){$(J).2t("ui-56-6D")}}).2B("dL.3j",1a(){if(!o.2x){$(J).4h("ui-56-6D")}}).2B("2R.3j",1a(){if(!o.2x){$(J).2t("ui-56-2R")}}).2B("4P.3j",1a(){if(!o.2x){$(J).4h("ui-56-2R")}});$(2N).2B("7i.3j-"+J.d6[0],1a(1H){if(2o.iu&&!$(1H.3m).fQ("#"+2o.d6[1]).1e){2o.5r(1H)}});J.1f.2B("3I.3j",1a(){2o.nQ()}).2B("2R.3j",1a(){if(2o.64){2o.64[0].2R()}});if(!o.1r){o.1r=J.1f.eB()}J.64.1r(o.1r);J.1f.3J();J.4L=$("<ul />",{"2C":"ui-8F ui-8F-ab","5t-70":1o,"ht":"Rw","5t-Rt":J.d6[1],"id":J.d6[2]});J.hw=$("<2F />",{"2C":"ui-3j-1T"}).3a(J.4L).4p(o.4p);J.4L.2B("7U.3j",1a(1H){K 7Y=1j;3q(1H.3H){1l $.ui.3H.UP:if(1H.r6){2o.5r(1H,1o)}1i{2o.eA(-1)}1p;1l $.ui.3H.EQ:if(1H.r6){2o.5r(1H,1o)}1i{2o.eA(1)}1p;1l $.ui.3H.EM:2o.eA(-1);1p;1l $.ui.3H.EL:2o.eA(1);1p;1l $.ui.3H.EO:2o.eA(":4t");1p;1l $.ui.3H.CI:2o.xF("up");1p;1l $.ui.3H.CK:2o.xF("cT");1p;1l $.ui.3H.CL:2o.eA(":6Z");1p;1l $.ui.3H.CD:;1l $.ui.3H.CF:2o.5r(1H,1o);$(1H.3m).cB("li:eq(0)").2c("5u");1p;1l $.ui.3H.CW:7Y=1o;2o.5r(1H,1o);$(1H.3m).cB("li:eq(0)").2c("5u");1p;1l $.ui.3H.Q8:2o.5r(1H,1o);1p;5n:7Y=1o}1b 7Y}).2B("h3.3j",1a(1H){if(1H.iE>0){2o.zL(1H.iE,"2R")}1b 1o}).2B("7i.3j 5u.3j",1a(){1b 1j});$(3P).2B("71.3j-"+J.d6[0],$.9G(2o.5r,J))},wE:1a(){K 2o=J,o=J.1x;K 8g=[];J.1f.2D("2T").2g(1a(){K 1B=$(J);8g.1C({1m:1B.1k("1m"),1Y:2o.Ho(1B.1Y(),1B),1Q:1B.1k("1Q"),2x:1B.1k("2x"),fg:1B.1k("2C"),kr:1B.1k("kr"),kD:1B.1L("xH"),kG:o.kG.2w(1B)})});K j8=2o.1x.3b=="iQ"?" ui-56-ad":"";J.4L.42("");if(8g.1e){1n(K i=0;i<8g.1e;i++){K A9={ht:"zO"};if(8g[i].2x){A9["2C"]="ui-56-2x"}K r7={42:8g[i].1Y||"&2r;",5d:"#zN",67:-1,ht:"2T","5t-1Q":1j};if(8g[i].2x){r7["5t-2x"]=1o}if(8g[i].kr){r7["kr"]=8g[i].kr}K Co=$("<a/>",r7).2B("2R.3j",1a(){$(J).1L().ha()}).2B("4P.3j",1a(){$(J).1L().dL()});K fh=$("<li/>",A9).3a(Co).1h("1P",i).2t(8g[i].fg).1h("hC",8g[i].fg||"").2B("5u.3j",1a(1H){if(2o.r4&&(!2o.nO(1H.8e)&&!2o.nO($(1H.8e).cB("ul > li.ui-3j-bL ")))){2o.1P($(J).1h("1P"));2o.2n(1H);2o.5r(1H,1o)}1b 1j}).2B("3I.3j",1a(){1b 1j}).2B("ha.3j",1a(e){if(!$(J).4D("ui-56-2x")&&!$(J).1L("ul").1L("li").4D("ui-56-2x")){e.Cy=2o.1f[0].1x[$(J).1h("1P")].1m;2o.7z("6D",e,2o.f0());2o.bo().2t(j8);2o.nD().4h("ui-3j-1g-2R ui-56-6D");$(J).4h("ui-56-ad").2t("ui-3j-1g-2R ui-56-6D")}}).2B("dL.3j",1a(e){if($(J).is(2o.bo())){$(J).2t(j8)}e.Cy=2o.1f[0].1x[$(J).1h("1P")].1m;2o.7z("4P",e,2o.f0());$(J).4h("ui-3j-1g-2R ui-56-6D")});if(8g[i].kD.1e){K r1="ui-3j-bL-"+J.1f.2D("xH").1P(8g[i].kD);if(J.4L.2D("li."+r1).1e){J.4L.2D("li."+r1+":6Z ul").3a(fh)}1i{$(\'<li ht="zO" 2C="ui-3j-bL \'+r1+(8g[i].kD.1k("2x")?" "+\'ui-56-2x" 5t-2x="1o"\':\'"\')+\'><2E 2C="ui-3j-bL-3x">\'+8g[i].kD.1k("3x")+"</2E><ul></ul></li>").4p(J.4L).2D("ul").3a(fh)}}1i{fh.4p(J.4L)}if(o.b9){1n(K j in o.b9){if(fh.is(o.b9[j].2D)){fh.1h("hC",8g[i].fg+" ui-3j-Dn").2t("ui-3j-Dn");K sK=o.b9[j].3L||"";fh.2D("a:eq(0)").j5(\'<2E 2C="ui-3j-1g-3L ui-3L \'+sK+\'"></2E>\');if(8g[i].kG){fh.2D("2E").2Z("iH-8R",8g[i].kG)}}}}}}1i{$(\'<li ht="zO"><a 5d="#zN" 67="-1" ht="2T"></a></li>\').4p(J.4L)}K f6=o.3b=="hA";J.64.8M("ui-3j-hA",f6).8M("ui-3j-iQ",!f6);J.4L.8M("ui-3j-1T-hA ui-aj-4G",f6).8M("ui-3j-1T-iQ ui-aj-6k",!f6).2D("li:4t").8M("ui-aj-1O",!f6).4x().2D("li:6Z").2t("ui-aj-4G");J.D7.8M("ui-3L-ie-1-s",f6).8M("ui-3L-ie-2-n-s",!f6);if(o.3b=="hA"){J.4L.1r(o.kO?o.kO:o.1r)}1i{J.4L.1r(o.kO?o.kO:o.1r-o.D2)}if(!b1.eG.3e(/Qo 2/)){K Di=J.hw.1y();K zJ=$(3P).1y();K zM=o.8Z?3F.5U(o.8Z,zJ):zJ/3;if(Di>zM){J.4L.1y(zM)}}J.8a=J.4L.2D("li:5L(.ui-3j-bL)");if(J.1f.1k("2x")){J.sE()}1i{J.H3()}J.nQ();J.bo().2t("ui-3j-1g-2R");jh(J.Dg);J.Dg=3P.6y(1a(){2o.xB()},fN)},69:1a(){J.1f.rQ(J.Qi).4h("ui-3j-2x"+" "+"ui-56-2x").jX("5t-2x").7V(".3j");$(3P).7V(".3j-"+J.d6[0]);$(2N).7V(".3j-"+J.d6[0]);J.xt.3u();J.hw.3u();J.1f.7V(".3j").5e();$.A8.2S.69.3d(J,2q)},zL:1a(Dd,xr){K 2o=J,c=5h.xh(Dd).3R(),ko=1c,cO=1c;if(2o.kp){3P.jh(2o.kp);2o.kp=2O}2o.hJ=(2o.hJ===2O?"":2o.hJ).3w(c);if(2o.hJ.1e<2||2o.hJ.79(-2,1)===c&&2o.nG){2o.nG=1o;ko=c}1i{2o.nG=1j;ko=2o.hJ}K bQ=(xr!=="2R"?J.bo().1h("1P"):J.nD().1h("1P"))||0;1n(K i=0;i<J.8a.1e;i++){K De=J.8a.eq(i).1Y().79(0,ko.1e).3R();if(De===ko){if(2o.nG){if(cO===1c){cO=i}if(i>bQ){cO=i;1p}}1i{cO=i}}}if(cO!==1c){J.8a.eq(cO).2D("a").2c(xr)}2o.kp=3P.6y(1a(){2o.kp=2O;2o.hJ=2O;2o.nG=2O},2o.1x.Dp)},f0:1a(){K 1P=J.1P();1b{1P:1P,2T:$("2T",J.1f).4u(1P),1m:J.1f[0].1m}},6K:1a(1H){if(J.64.1k("5t-2x")!="1o"){K 2o=J,o=J.1x,1Q=J.bo(),1W=1Q.2D("a");2o.Hp(1H);2o.64.2t("ui-56-ad");2o.4L.1k("5t-70",1j);2o.hw.2t("ui-3j-6K");if(o.3b=="hA"){2o.64.4h("ui-aj-6k").2t("ui-aj-1O")}1i{J.4L.2Z("2a",-sX).5a(J.4L.5a()+1Q.2G().1O-J.4L.b4()/ 2 + 1Q.b4() /2).2Z("2a","6p")}2o.xB();if(1W.1e){1W[0].2R()}2o.iu=1o;2o.7z("6K",1H,2o.f0())}},5r:1a(1H,rh){if(J.64.is(".ui-56-ad")){J.64.4h("ui-56-ad");J.hw.4h("ui-3j-6K");J.4L.1k("5t-70",1o);if(J.1x.3b=="hA"){J.64.4h("ui-aj-1O").2t("ui-aj-6k")}if(rh){J.64.2R()}J.iu=1j;J.7z("5r",1H,J.f0())}},dD:1a(1H){J.1f.2c("dD");J.7z("dD",1H,J.f0())},2n:1a(1H){if(J.nO(1H.8e)){1b 1j}J.7z("2n",1H,J.f0())},8F:1a(){1b J.hw.51(J.xt)},Hp:1a(1H){$(".ui-3j.ui-56-ad").5L(J.64).2g(1a(){$(J).1h("Ht").3j("5r",1H)});$(".ui-3j.ui-56-6D").2c("dL")},xj:1a(1H,rh){if(J.iu){J.5r(1H,rh)}1i{J.6K(1H)}},Ho:1a(1Y,1B){if(J.1x.6s){1Y=J.1x.6s(1Y,1B)}1i{if(J.1x.HC){1Y=$("<2F />").1Y(1Y).42()}}1b 1Y},ra:1a(){1b J.1f[0].bQ},bo:1a(){1b J.8a.eq(J.ra())},nD:1a(){1b J.4L.2D(".ui-3j-1g-2R")},ij:1a(9U,re){if(!J.1x.2x){K ri=6i(J.bo().1h("1P")||0,10);K 4Z=ri+9U;if(4Z<0){4Z=0}if(4Z>J.8a.54()-1){4Z=J.8a.54()-1}if(4Z===re){1b 1j}if(J.8a.eq(4Z).4D("ui-56-2x")){9U>0?++9U:--9U;J.ij(9U,4Z)}1i{J.8a.eq(4Z).2c("ha").2c("5u")}}},eA:1a(9U,re){if(!aE(9U)){K ri=6i(J.nD().1h("1P")||0,10);K 4Z=ri+9U}1i{K 4Z=6i(J.8a.4s(9U).1h("1P"),10)}if(4Z<0){4Z=0}if(4Z>J.8a.54()-1){4Z=J.8a.54()-1}if(4Z===re){1b 1j}K j3="ui-3j-1g-"+3F.4I(3F.iL()*93);J.nD().2D("a:eq(0)").1k("id","");if(J.8a.eq(4Z).4D("ui-56-2x")){9U>0?++9U:--9U;J.eA(9U,4Z)}1i{J.8a.eq(4Z).2D("a:eq(0)").1k("id",j3).2R()}J.4L.1k("5t-Ib",j3)},xF:1a(cF){K nJ=3F.gH(J.4L.b4()/J.8a.4t().b4());nJ=cF=="up"?-nJ:nJ;J.eA(nJ)},lQ:1a(1q,1m){J.1x[1q]=1m;if(1q=="2x"){if(1m){J.5r()}J.1f.51(J.64).51(J.4L)[1m?"2t":"4h"]("ui-3j-2x "+"ui-56-2x").1k("5t-2x",1m).1k("67",1m?1:0)}},sE:1a(1P,1w){if(2L 1P=="2O"){J.lQ("2x",1o)}1i{J.xI(1w||"2T",1P,1j)}},H3:1a(1P,1w){if(2L 1P=="2O"){J.lQ("2x",1j)}1i{J.xI(1w||"2T",1P,1o)}},nO:1a(6l){1b $(6l).4D("ui-56-2x")},xI:1a(1w,1P,r9){K 1f=J.1f.2D(1w).eq(1P),9C=1w==="xH"?J.4L.2D("li.ui-3j-bL-"+1P):J.8a.eq(1P);if(9C){9C.8M("ui-56-2x",!r9).1k("5t-2x",!r9);if(r9){1f.jX("2x")}1i{1f.1k("2x","2x")}}},1P:1a(4Z){if(2q.1e){if(!J.nO($(J.8a[4Z]))&&4Z!=J.ra()){J.1f[0].bQ=4Z;J.nQ();J.dD()}1i{1b 1j}}1i{1b J.ra()}},1m:1a(4f){if(2q.1e&&4f!=J.1f[0].1m){J.1f[0].1m=4f;J.nQ();J.dD()}1i{1b J.1f[0].1m}},nQ:1a(){K j8=J.1x.3b=="iQ"?" ui-56-ad":"";K j3="ui-3j-1g-"+3F.4I(3F.iL()*93);J.4L.2D(".ui-3j-1g-1Q").4h("ui-3j-1g-1Q"+j8).2D("a").1k("5t-1Q","1j").1k("id","");J.bo().2t("ui-3j-1g-1Q"+j8).2D("a").1k("5t-1Q","1o").1k("id",j3);K Ig=J.64.1h("hC")?J.64.1h("hC"):"";K xC=J.bo().1h("hC")?J.bo().1h("hC"):"";J.64.4h(Ig).1h("hC",xC).2t(xC).2D(".ui-3j-6F").42(J.bo().2D("a:eq(0)").42());J.4L.1k("5t-Ib",j3)},xB:1a(){K o=J.1x,rb={of:J.64,my:"2a 1O",at:"2a 4G",kV:"i4"};if(o.3b=="iQ"){K 1Q=J.bo();rb.my="2a 1O"+(J.4L.2y().1O-1Q.2y().1O-(J.64.b4()+1Q.b4())/2);rb.kV="al"}J.hw.jX("3b").4j(J.1f.4j()+2).2G($.4m(rb,o.HP))}})})(2u);(1a(iI){K 5N="0.4.2",3o="7X",5o=/[\\.\\/]/,wT="*",pW=1a(){},HN=1a(a,b){1b a-b},hq,5D,4v={n:{}},2Q=1a(1z,eF){1z=5h(1z);K e=4v,wR=5D,2e=3Y.2S.3G.2w(2q,2),dH=2Q.dH(1z),z=0,f=1j,l,hB=[],jn={},2m=[],ce=hq,PX=[];hq=1z;5D=0;1n(K i=0,ii=dH.1e;i<ii;i++){if("4j"in dH[i]){hB.1C(dH[i].4j);if(dH[i].4j<0){jn[dH[i].4j]=dH[i]}}}hB.eU(HN);44(hB[z]<0){l=jn[hB[z++]];2m.1C(l.3d(eF,2e));if(5D){5D=wR;1b 2m}}1n(i=0;i<ii;i++){l=dH[i];if("4j"in l){if(l.4j==hB[z]){2m.1C(l.3d(eF,2e));if(5D){1p}do{z++;l=jn[hB[z]];l&&2m.1C(l.3d(eF,2e));if(5D){1p}}44(l)}1i{jn[l.4j]=l}}1i{2m.1C(l.3d(eF,2e));if(5D){1p}}}5D=wR;hq=ce;1b 2m.1e?2m:1c};2Q.d1=4v;2Q.dH=1a(1z){K 7e=1z.3p(5o),e=4v,1g,1F,k,i,ii,j,jj,pL,es=[e],2m=[];1n(i=0,ii=7e.1e;i<ii;i++){pL=[];1n(j=0,jj=es.1e;j<jj;j++){e=es[j].n;1F=[e[7e[i]],e[wT]];k=2;44(k--){1g=1F[k];if(1g){pL.1C(1g);2m=2m.3w(1g.f||[])}}}es=pL}1b 2m};2Q.on=1a(1z,f){1z=5h(1z);if(2L f!="1a"){1b 1a(){}}K 7e=1z.3p(5o),e=4v;1n(K i=0,ii=7e.1e;i<ii;i++){e=e.n;e=e.7X(7e[i])&&e[7e[i]]||(e[7e[i]]={n:{}})}e.f=e.f||[];1n(i=0,ii=e.f.1e;i<ii;i++){if(e.f[i]==f){1b pW}}e.f.1C(f);1b 1a(4j){if(+4j==+4j){f.4j=+4j}}};2Q.f=1a(1H){K 2b=[].3G.2w(2q,1);1b 1a(){2Q.3d(1c,[1H,1c].3w(2b).3w([].3G.2w(2q,0)))}};2Q.5D=1a(){5D=1};2Q.nt=1a(wU){if(wU){1b(1S dl("(?:\\\\.|\\\\/|^)"+wU+"(?:\\\\.|\\\\/|$)")).9r(hq)}1b hq};2Q.RF=1a(){1b hq.3p(5o)};2Q.ex=2Q.7V=1a(1z,f){if(!1z){2Q.d1=4v={n:{}};1b}K 7e=1z.3p(5o),e,1q,5f,i,ii,j,jj,hM=[4v];1n(i=0,ii=7e.1e;i<ii;i++){1n(j=0;j<hM.1e;j+=5f.1e-2){5f=[j,1];e=hM[j].n;if(7e[i]!=wT){if(e[7e[i]]){5f.1C(e[7e[i]])}}1i{1n(1q in e){if(e[3o](1q)){5f.1C(e[1q])}}}hM.5f.3d(hM,5f)}}1n(i=0,ii=hM.1e;i<ii;i++){e=hM[i];44(e.n){if(f){if(e.f){1n(j=0,jj=e.f.1e;j<jj;j++){if(e.f[j]==f){e.f.5f(j,1);1p}}!e.f.1e&&41 e.f}1n(1q in e.n){if(e.n[3o](1q)&&e.n[1q].f){K ng=e.n[1q].f;1n(j=0,jj=ng.1e;j<jj;j++){if(ng[j]==f){ng.5f(j,1);1p}}!ng.1e&&41 e.n[1q].f}}}1i{41 e.f;1n(1q in e.n){if(e.n[3o](1q)&&e.n[1q].f){41 e.n[1q].f}}}e=e.n}}};2Q.Ry=1a(1z,f){K f2=1a(){2Q.7V(1z,f2);1b f.3d(J,2q)};1b 2Q.on(1z,f2)};2Q.5N=5N;2Q.3r=1a(){1b"Ec pl zb Rv "+5N};2L ub!="2O"&&ub.G4?ub.G4=2Q:2L jK!="2O"?jK("2Q",[],1a(){1b 2Q}):iI.2Q=2Q})(3P||J);(1a(iI,xf){if(2L jK==="1a"&&jK.RR){jK(["2Q"],1a(2Q){1b xf(iI,2Q)})}1i{xf(iI,iI.2Q)}})(J,1a(3P,2Q){1a R(4t){if(R.is(4t,"1a")){1b 9Z?4t():2Q.on("46.iZ",4t)}1i{if(R.is(4t,3K)){1b R.4C.7K[3d](R,4t.5f(0,3+R.is(4t[0],nu))).51(4t)}1i{K 2e=3Y.2S.3G.2w(2q,0);if(R.is(2e[2e.1e-1],"1a")){K f=2e.dw();1b 9Z?f.2w(R.4C.7K[3d](R,2e)):2Q.on("46.iZ",1a(){f.2w(R.4C.7K[3d](R,2e))})}1i{1b R.4C.7K[3d](R,2q)}}}}R.5N="2.1.2";R.2Q=2Q;K 9Z,5o=/[, ]+/,9C={9i:1,4l:1,1G:1,a0:1,1Y:1,8R:1},Fd=/\\{(\\d+)\\}/g,iF="2S",3o="7X",g={2Y:2N,5l:3P},rv={wI:4K.2S[3o].2w(g.5l,"bf"),is:g.5l.bf},xV=1a(){J.ca=J.8P={}},62,3E="3E",3d="3d",3w="3w",mS="RX"in g.5l||g.5l.Fs&&g.2Y eH Fs,E="",S=" ",3Z=5h,3p="3p",4v="3I wN 7i 9x dL ha 5u ni nb na xi"[3p](S),mW={7i:"ni",9x:"nb",5u:"na"},mq=3Z.2S.3R,3y=3F,4Q=3y.4y,5J=3y.5U,4c=3y.4c,5M=3y.5M,PI=3y.PI,nu="cJ",4d="4d",3K="3K",3r="3r",g6="28",I1=4K.2S.3r,2v={},1C="1C",RQ=R.v4=/^5b\\([\'"]?([^\\)]+?)[\'"]?\\)$/i,E0=/^\\s*((#[a-f\\d]{6})|(#[a-f\\d]{3})|yU?\\(\\s*([\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+%?(?:\\s*,\\s*[\\d\\.]+%?)?)\\s*\\)|E3?\\(\\s*([\\d\\.]+(?:4n|\\z0|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\)|EC?\\(\\s*([\\d\\.]+(?:4n|\\z0|%)?\\s*,\\s*[\\d\\.]+%?\\s*,\\s*[\\d\\.]+(?:%?\\s*,\\s*[\\d\\.]+)?)%?\\s*\\))\\s*$/i,HW={"RN":1,"Fp":1,"-Fp":1},CB=/^(?:R0-)?R3\\(([^,]+),([^,]+),([^,]+),([^\\)]+)\\)/,4I=3y.4I,aL="aL",3z=cZ,9I=6i,yD=3Z.2S.8u,Cv=R.j1={"b0-4x":"3t","b0-2J":"3t",4P:0,"5Z-4l":"0 0 FD FD",hO:"5n",cx:0,cy:0,28:"#jI","28-2I":1,2K:\'R5 "FH"\',"2K-83":\'"FH"\',"2K-54":"10","2K-3b":"q8","2K-9M":kB,3Q:0,1y:0,5d:"6q://QS.w8/","QT-QQ":0,2I:1,1G:"M0,0",r:0,rx:0,ry:0,4a:"",1X:"#c8","1X-91":"","1X-cH":"iq","1X-gj":"iq","1X-o3":0,"1X-2I":1,"1X-1r":1,3m:"QX","1Y-uB":"zj",66:"bf",3A:"",1r:0,x:0,y:0},q0=R.Rj={4P:nu,"5Z-4l":"zB",cx:nu,cy:nu,28:"9B","28-2I":nu,"2K-54":nu,1y:nu,2I:nu,1G:"1G",r:nu,rx:nu,ry:nu,1X:"9B","1X-2I":nu,"1X-1r":nu,3A:"3A",1r:nu,x:nu,y:nu},GH=/[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]/g,pI=/[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*,[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*/,DN={hs:1,rg:1},En=/,?([Ri]),?/gi,DA=/([Rl])[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*,?[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*)+)/ig,D8=/([Ro])[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*,?[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*)+)/ig,yc=/(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*,?[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*/ig,Rm=R.uC=/^r(?:\\(([^,]+?)[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*,[\\a9\\ai\\ah\\ae\\aw\\av\\ac\\a4\\a5\\aJ\\aY\\aU\\b2\\aD\\aR\\aS\\aW\\aX\\aG\\aM\\aO\\aQ\\aP\\aK\\aF]*([^\\)]+?)\\))?/,h4={},O5=1a(a,b){1b a.1q-b.1q},Ct=1a(a,b){1b 3z(a)-3z(b)},pW=1a(){},CS=1a(x){1b x},nk=R.wg=1a(x,y,w,h,r){if(r){1b[["M",x+r,y],["l",w-r*2,0],["a",r,r,0,0,1,r,r],["l",0,h-r*2],["a",r,r,0,0,1,-r,r],["l",r*2-w,0],["a",r,r,0,0,1,-r,-r],["l",0,r*2-h],["a",r,r,0,0,1,r,-r],["z"]]}1b[["M",x,y],["l",w,0],["l",0,h],["l",-w,0],["z"]]},yA=1a(x,y,rx,ry){if(ry==1c){ry=rx}1b[["M",x,y],["m",0,-ry],["a",rx,ry,0,1,1,0,2*ry],["a",rx,ry,0,1,1,0,-2*ry],["z"]]},bz=R.uh={1G:1a(el){1b el.1k("1G")},9i:1a(el){K a=el.2b;1b yA(a.cx,a.cy,a.r)},a0:1a(el){K a=el.2b;1b yA(a.cx,a.cy,a.rx,a.ry)},4l:1a(el){K a=el.2b;1b nk(a.x,a.y,a.1r,a.1y,a.r)},8R:1a(el){K a=el.2b;1b nk(a.x,a.y,a.1r,a.1y)},1Y:1a(el){K 2W=el.nm();1b nk(2W.x,2W.y,2W.1r,2W.1y)},5v:1a(el){K 2W=el.nm();1b nk(2W.x,2W.y,2W.1r,2W.1y)}},mw=R.mw=1a(1G,4w){if(!4w){1b 1G}K x,y,i,j,ii,jj,eL;1G=gV(1G);1n(i=0,ii=1G.1e;i<ii;i++){eL=1G[i];1n(j=1,jj=eL.1e;j<jj;j+=2){x=4w.x(eL[j],eL[j+1]);y=4w.y(eL[j],eL[j+1]);eL[j]=x;eL[j+1]=y}}1b 1G};R.7y=g;R.1w=g.5l.Oj||g.2Y.On.Om("6q://mX.w3.qj/TR/NX/NW#Ph","1.1")?"c4":"g9";if(R.1w=="g9"){K d=g.2Y.cb("2F"),b;d.mQ=\'<v:c7 FJ="1"/>\';b=d.7A;b.3b.Jm="5b(#5n#g9)";if(!(b&&2L b.FJ=="1D")){1b R.1w=E}d=1c}R.43=!(R.5H=R.1w=="g9");R.w5=xV;R.fn=62=xV.2S=R.2S;R.Pk=0;R.ve=0;R.is=1a(o,1w){1w=mq.2w(1w);if(1w=="mC"){1b!HW[3o](+o)}if(1w=="3K"){1b o eH 3Y}1b 1w=="1c"&&o===1c||(1w==2L o&&o!==1c||(1w=="1D"&&o===4K(o)||(1w=="3K"&&(3Y.xU&&3Y.xU(o))||I1.2w(o).3G(8,-1).3R()==1w)))};1a 5S(1u){if(2L 1u=="1a"||4K(1u)!==1u){1b 1u}K 1A=1S 1u.4V;1n(K 1q in 1u){if(1u[3o](1q)){1A[1q]=5S(1u[1q])}}1b 1A}R.7l=1a(x1,y1,x2,y2,x3,y3){if(x3==1c){K x=x1-x2,y=y1-y2;if(!x&&!y){1b 0}1b(cC+3y.y9(-y,-x)*cC/PI+8t)%8t}1i{1b R.7l(x1,y1,x3,y3)-R.7l(x2,y2,x3,y3)}};R.8D=1a(4n){1b 4n%8t*PI/cC};R.4n=1a(8D){1b 8D*cC/PI%8t};R.Pd=1a(2H,1m,d4){d4=R.is(d4,"mC")?d4:10;if(R.is(2H,3K)){K i=2H.1e;44(i--){if(4c(2H[i]-1m)<=d4){1b 2H[i]}}}1i{2H=+2H;K nr=1m%2H;if(nr<d4){1b 1m-nr}if(nr>2H-d4){1b 1m-nr+2H}}1b 1m};K n6=R.n6=1a(Ir,I6){1b 1a(){1b"P7-P8-P6-Pb-Pc".3f(Ir,I6).8u()}}(/[xy]/g,1a(c){K r=3y.iL()*16|0,v=c=="x"?r:r&3|8;1b v.3r(16)});R.H7=1a(xX){2Q("46.H7",R,g.5l,xX);g.5l=xX;g.2Y=g.5l.2N;if(R.4C.rf){R.4C.rf(g.5l)}};K ol=1a(3s){if(R.5H){K nn=/^\\s+|\\s+$/g;K nz;7D{K pN=1S pM("Pn");pN.Pt("<3U>");pN.5r();nz=pN.3U}7C(e){nz=OH().2N.3U}K DS=nz.Oy();ol=bn(1a(3s){7D{nz.3b.3s=3Z(3s).3f(nn,E);K 1m=DS.P1("P2");1m=(1m&dM)<<16|1m&OO|(1m&Ob)>>>16;1b"#"+("Lb"+1m.3r(16)).3G(-6)}7C(e){1b"3t"}})}1i{K i=g.2Y.cb("i");i.66="gC\\gD S0 XK";i.3b.5q="3t";g.2Y.3U.3E(i);ol=bn(1a(3s){i.3b.3s=3s;1b g.2Y.km.qv(i,E).El("3s")})}1b ol(3s)},Ev=1a(){1b"CJ("+[J.h,J.s,J.b]+")"},Ew=1a(){1b"CO("+[J.h,J.s,J.l]+")"},vL=1a(){1b J.6f},y6=1a(r,g,b){if(g==1c&&(R.is(r,"1D")&&("r"in r&&("g"in r&&"b"in r)))){b=r.b;g=r.g;r=r.r}if(g==1c&&R.is(r,4d)){K 3v=R.b5(r);r=3v.r;g=3v.g;b=3v.b}if(r>1||(g>1||b>1)){r/=dM;g/=dM;b/=dM}1b[r,g,b]},y5=1a(r,g,b,o){r*=dM;g*=dM;b*=dM;K 3D={r:r,g:g,b:b,6f:R.3D(r,g,b),3r:vL};R.is(o,"mC")&&(3D.2I=o);1b 3D};R.3s=1a(3v){K 3D;if(R.is(3v,"1D")&&("h"in 3v&&("s"in 3v&&"b"in 3v))){3D=R.ot(3v);3v.r=3D.r;3v.g=3D.g;3v.b=3D.b;3v.6f=3D.6f}1i{if(R.is(3v,"1D")&&("h"in 3v&&("s"in 3v&&"l"in 3v))){3D=R.pJ(3v);3v.r=3D.r;3v.g=3D.g;3v.b=3D.b;3v.6f=3D.6f}1i{if(R.is(3v,"4d")){3v=R.b5(3v)}if(R.is(3v,"1D")&&("r"in 3v&&("g"in 3v&&"b"in 3v))){3D=R.Ex(3v);3v.h=3D.h;3v.s=3D.s;3v.l=3D.l;3D=R.Et(3v);3v.v=3D.b}1i{3v={6f:"3t"};3v.r=3v.g=3v.b=3v.h=3v.s=3v.v=3v.l=-1}}}3v.3r=vL;1b 3v};R.ot=1a(h,s,v,o){if(J.is(h,"1D")&&("h"in h&&("s"in h&&"b"in h))){v=h.b;s=h.s;h=h.h;o=h.o}h*=8t;K R,G,B,X,C;h=h%8t/60;C=v*s;X=C*(1-4c(h%2-1));R=G=B=v-C;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b y5(R,G,B,o)};R.pJ=1a(h,s,l,o){if(J.is(h,"1D")&&("h"in h&&("s"in h&&"l"in h))){l=h.l;s=h.s;h=h.h}if(h>1||(s>1||l>1)){h/=8t;s/=100;l/=100}h*=8t;K R,G,B,X,C;h=h%8t/60;C=2*s*(l<0.5?l:1-l);X=C*(1-4c(h%2-1));R=G=B=l-C/2;h=~~h;R+=[C,X,0,0,X,C][h];G+=[X,C,C,X,0,0][h];B+=[0,0,X,C,C,X][h];1b y5(R,G,B,o)};R.Et=1a(r,g,b){b=y6(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,V,C;V=4Q(r,g,b);C=V-5J(r,g,b);H=C==0?1c:V==r?(g-b)/ C : V == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8t)%6*60/8t;S=C==0?0:C/V;1b{h:H,s:S,b:V,3r:Ev}};R.Ex=1a(r,g,b){b=y6(r,g,b);r=b[0];g=b[1];b=b[2];K H,S,L,M,m,C;M=4Q(r,g,b);m=5J(r,g,b);C=M-m;H=C==0?1c:M==r?(g-b)/ C : M == g ? (b - r) /C+2:(r-g)/C+4;H=(H+8t)%6*60/8t;L=(M+m)/2;S=C==0?0:L<0.5?C/ (2 * L) : C /(2-2*L);1b{h:H,s:S,l:L,3r:Ew}};R.ic=1a(){1b J.4H(",").3f(En,"$1")};1a DV(3K,1g){1n(K i=0,ii=3K.1e;i<ii;i++){if(3K[i]===1g){1b 3K.1C(3K.5f(i,1)[0])}}}1a bn(f,eF,oj){1a iB(){K 4i=3Y.2S.3G.2w(2q,0),2e=4i.4H("\\XL"),7N=iB.7N=iB.7N||{},6x=iB.6x=iB.6x||[];if(7N[3o](2e)){DV(6x,2e);1b oj?oj(7N[2e]):7N[2e]}6x.1e>=93&&41 7N[6x.bP()];6x.1C(2e);7N[2e]=f[3d](eF,4i);1b oj?oj(7N[2e]):7N[2e]}1b iB}K XM=R.v5=1a(4a,f){K c5=g.2Y.cb("c5");c5.3b.fl="2G:8x;2a:-iJ;1O:-iJ";c5.gp=1a(){f.2w(J);J.gp=1c;g.2Y.3U.7g(J)};c5.XJ=1a(){g.2Y.3U.7g(J)};g.2Y.3U.3E(c5);c5.4a=4a};1a og(){1b J.6f}R.b5=bn(1a(9B){if(!9B||!!((9B=3Z(9B)).4Y("-")+1)){1b{r:-1,g:-1,b:-1,6f:"3t",96:1,3r:og}}if(9B=="3t"){1b{r:-1,g:-1,b:-1,6f:"3t",3r:og}}!(DN[3o](9B.3R().fJ(0,2))||9B.b6()=="#")&&(9B=ol(9B));K 1A,8Y,9Y,9X,2I,t,2H,3D=9B.3e(E0);if(3D){if(3D[2]){9X=9I(3D[2].fJ(5),16);9Y=9I(3D[2].fJ(3,5),16);8Y=9I(3D[2].fJ(1,3),16)}if(3D[3]){9X=9I((t=3D[3].b6(3))+t,16);9Y=9I((t=3D[3].b6(2))+t,16);8Y=9I((t=3D[3].b6(1))+t,16)}if(3D[4]){2H=3D[4][3p](pI);8Y=3z(2H[0]);2H[0].3G(-1)=="%"&&(8Y*=2.55);9Y=3z(2H[1]);2H[1].3G(-1)=="%"&&(9Y*=2.55);9X=3z(2H[2]);2H[2].3G(-1)=="%"&&(9X*=2.55);3D[1].3R().3G(0,4)=="yU"&&(2I=3z(2H[3]));2H[3]&&(2H[3].3G(-1)=="%"&&(2I/=100))}if(3D[5]){2H=3D[5][3p](pI);8Y=3z(2H[0]);2H[0].3G(-1)=="%"&&(8Y*=2.55);9Y=3z(2H[1]);2H[1].3G(-1)=="%"&&(9Y*=2.55);9X=3z(2H[2]);2H[2].3G(-1)=="%"&&(9X*=2.55);(2H[0].3G(-3)=="4n"||2H[0].3G(-1)=="\\EA")&&(8Y/=8t);3D[1].3R().3G(0,4)=="E3"&&(2I=3z(2H[3]));2H[3]&&(2H[3].3G(-1)=="%"&&(2I/=100));1b R.ot(8Y,9Y,9X,2I)}if(3D[6]){2H=3D[6][3p](pI);8Y=3z(2H[0]);2H[0].3G(-1)=="%"&&(8Y*=2.55);9Y=3z(2H[1]);2H[1].3G(-1)=="%"&&(9Y*=2.55);9X=3z(2H[2]);2H[2].3G(-1)=="%"&&(9X*=2.55);(2H[0].3G(-3)=="4n"||2H[0].3G(-1)=="\\EA")&&(8Y/=8t);3D[1].3R().3G(0,4)=="EC"&&(2I=3z(2H[3]));2H[3]&&(2H[3].3G(-1)=="%"&&(2I/=100));1b R.pJ(8Y,9Y,9X,2I)}3D={r:8Y,g:9Y,b:9X,3r:og};3D.6f="#"+(Cq|9X|9Y<<8|8Y<<16).3r(16).3G(1);R.is(2I,"mC")&&(3D.2I=2I);1b 3D}1b{r:-1,g:-1,b:-1,6f:"3t",96:1,3r:og}},R);R.CJ=bn(1a(h,s,b){1b R.ot(h,s,b).6f});R.CO=bn(1a(h,s,l){1b R.pJ(h,s,l).6f});R.3D=bn(1a(r,g,b){1b"#"+(Cq|b|g<<8|r<<16).3r(16).3G(1)});R.os=1a(1m){K 2J=J.os.2J=J.os.2J||{h:0,s:1,b:1m||0.75},3D=J.ot(2J.h,2J.s,2J.b);2J.h+=0.CZ;if(2J.h>1){2J.h=0;2J.s-=0.2;2J.s<=0&&(J.os.2J={h:0,s:1,b:2J.b})}1b 3D.6f};R.os.kF=1a(){41 J.2J};1a yy(7s,z){K d=[];1n(K i=0,gL=7s.1e;gL-2*!z>i;i+=2){K p=[{x:+7s[i-2],y:+7s[i-1]},{x:+7s[i],y:+7s[i+1]},{x:+7s[i+2],y:+7s[i+3]},{x:+7s[i+4],y:+7s[i+5]}];if(z){if(!i){p[0]={x:+7s[gL-2],y:+7s[gL-1]}}1i{if(gL-4==i){p[3]={x:+7s[0],y:+7s[1]}}1i{if(gL-2==i){p[2]={x:+7s[0],y:+7s[1]};p[3]={x:+7s[2],y:+7s[3]}}}}}1i{if(gL-4==i){p[3]=p[2]}1i{if(!i){p[0]={x:+7s[i],y:+7s[i+1]}}}}d.1C(["C",(-p[0].x+6*p[1].x+p[2].x)/ 6, (-p[0].y + 6 * p[1].y + p[2].y) /6,(p[1].x+6*p[2].x-p[3].x)/ 6, (p[1].y + 6 * p[2].y - p[3].y) /6,p[2].x,p[2].y])}1b d}R.yB=1a(8j){if(!8j){1b 1c}K 7E=fG(8j);if(7E.ld){1b bp(7E.ld)}K oq={a:7,c:6,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,z:0},1h=[];if(R.is(8j,3K)&&R.is(8j[0],3K)){1h=bp(8j)}if(!1h.1e){3Z(8j).3f(DA,1a(a,b,c){K 1v=[],1z=b.3R();c.3f(yc,1a(a,b){b&&1v.1C(+b)});if(1z=="m"&&1v.1e>2){1h.1C([b][3w](1v.5f(0,2)));1z="l";b=b=="m"?"l":"L"}if(1z=="r"){1h.1C([b][3w](1v))}1i{44(1v.1e>=oq[1z]){1h.1C([b][3w](1v.5f(0,oq[1z])));if(!oq[1z]){1p}}}})}1h.3r=R.ic;7E.ld=bp(1h);1b 1h};R.pF=bn(1a(jb){if(!jb){1b 1c}K oq={r:3,s:4,t:2,m:6},1h=[];if(R.is(jb,3K)&&R.is(jb[0],3K)){1h=bp(jb)}if(!1h.1e){3Z(jb).3f(D8,1a(a,b,c){K 1v=[],1z=mq.2w(b);c.3f(yc,1a(a,b){b&&1v.1C(+b)});1h.1C([b][3w](1v))})}1h.3r=R.ic;1b 1h});K fG=1a(ps){K p=fG.ps=fG.ps||{};if(p[ps]){p[ps].pU=100}1i{p[ps]={pU:100}}6y(1a(){1n(K 1q in p){if(p[3o](1q)&&1q!=ps){p[1q].pU--;!p[1q].pU&&41 p[1q]}}});1b p[ps]};R.mM=1a(5B,6a,6d,6c,77,7a,7k,7n,t){K t1=1-t,yd=5M(t1,3),y8=5M(t1,2),t2=t*t,t3=t2*t,x=yd*5B+y8*3*t*6d+t1*3*t*t*77+t3*7k,y=yd*6a+y8*3*t*6c+t1*3*t*t*7a+t3*7n,mx=5B+2*t*(6d-5B)+t2*(77-2*6d+5B),my=6a+2*t*(6c-6a)+t2*(7a-2*6c+6a),nx=6d+2*t*(77-6d)+t2*(7k-2*77+6d),ny=6c+2*t*(7a-6c)+t2*(7n-2*7a+6c),ax=t1*5B+t*6d,ay=t1*6a+t*6c,cx=t1*77+t*7k,cy=t1*7a+t*7n,dt=90-3y.y9(mx-nx,my-ny)*cC/PI;(mx>nx||my<ny)&&(dt+=cC);1b{x:x,y:y,m:{x:mx,y:my},n:{x:nx,y:ny},2J:{x:ax,y:ay},4x:{x:cx,y:cy},dt:dt}};R.xL=1a(5B,6a,6d,6c,77,7a,7k,7n){if(!R.is(5B,"3K")){5B=[5B,6a,6d,6c,77,7a,7k,7n]}K 2W=yf.3d(1c,5B);1b{x:2W.5U.x,y:2W.5U.y,x2:2W.4y.x,y2:2W.4y.y,1r:2W.4y.x-2W.5U.x,1y:2W.4y.y-2W.5U.y}};R.yv=1a(2W,x,y){1b x>=2W.x&&(x<=2W.x2&&(y>=2W.y&&y<=2W.y2))};R.xJ=1a(6R,6P){K i=R.yv;1b i(6P,6R.x,6R.y)||(i(6P,6R.x2,6R.y)||(i(6P,6R.x,6R.y2)||(i(6P,6R.x2,6R.y2)||(i(6R,6P.x,6P.y)||(i(6R,6P.x2,6P.y)||(i(6R,6P.x,6P.y2)||(i(6R,6P.x2,6P.y2)||(6R.x<6P.x2&&6R.x>6P.x||6P.x<6R.x2&&6P.x>6R.x)&&(6R.y<6P.y2&&6R.y>6P.y||6P.y<6R.y2&&6P.y>6R.y))))))))};1a ya(t,p1,p2,p3,p4){K t1=-3*p1+9*p2-9*p3+3*p4,t2=t*t1+6*p1-12*p2+6*p3;1b t*t2-3*p1+3*p2}1a gI(x1,y1,x2,y2,x3,y3,x4,y4,z){if(z==1c){z=1}z=z>1?1:z<0?0:z;K z2=z/2,n=12,GY=[-0.Hr,0.Hr,-0.Hs,0.Hs,-0.Hm,0.Hm,-0.HB,0.HB,-0.Hx,0.Hx,-0.Hv,0.Hv],Hf=[0.Hz,0.Hz,0.H1,0.H1,0.H4,0.H4,0.GV,0.GV,0.GU,0.GU,0.GZ,0.GZ],xQ=0;1n(K i=0;i<n;i++){K ct=z2*GY[i]+z2,xO=ya(ct,x1,x2,x3,x4),xP=ya(ct,y1,y2,y3,y4),H8=xO*xO+xP*xP;xQ+=Hf[i]*3y.9v(H8)}1b z2*xQ}1a HD(x1,y1,x2,y2,x3,y3,x4,y4,ll){if(ll<0||gI(x1,y1,x2,y2,x3,y3,x4,y4)<ll){1b}K t=1,lI=t/2,t2=t-lI,l,e=0.Lc;l=gI(x1,y1,x2,y2,x3,y3,x4,y4,t2);44(4c(l-ll)>e){lI/=2;t2+=(l<ll?1:-1)*lI;l=gI(x1,y1,x2,y2,x3,y3,x4,y4,t2)}1b t2}1a wb(x1,y1,x2,y2,x3,y3,x4,y4){if(4Q(x1,x2)<5J(x3,x4)||(5J(x1,x2)>4Q(x3,x4)||(4Q(y1,y2)<5J(y3,y4)||5J(y1,y2)>4Q(y3,y4)))){1b}K nx=(x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4),ny=(x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4),pV=(x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);if(!pV){1b}K px=nx/ pV, py = ny /pV,nZ=+px.4r(2),nY=+py.4r(2);if(nZ<+5J(x1,x2).4r(2)||(nZ>+4Q(x1,x2).4r(2)||(nZ<+5J(x3,x4).4r(2)||(nZ>+4Q(x3,x4).4r(2)||(nY<+5J(y1,y2).4r(2)||(nY>+4Q(y1,y2).4r(2)||(nY<+5J(y3,y4).4r(2)||nY>+4Q(y3,y4).4r(2)))))))){1b}1b{x:px,y:py}}1a Xw(8z,8A){1b pR(8z,8A)}1a Xx(8z,8A){1b pR(8z,8A,1)}1a pR(8z,8A,fW){K 6R=R.xL(8z),6P=R.xL(8A);if(!R.xJ(6R,6P)){1b fW?0:[]}K l1=gI.3d(0,8z),l2=gI.3d(0,8A),n1=4Q(~~(l1/ 5), 1), n2 = 4Q(~~(l2 /5),1),pS=[],pP=[],xy={},1A=fW?0:[];1n(K i=0;i<n1+1;i++){K p=R.mM.3d(R,8z.3w(i/n1));pS.1C({x:p.x,y:p.y,t:i/n1})}1n(i=0;i<n2+1;i++){p=R.mM.3d(R,8A.3w(i/n2));pP.1C({x:p.x,y:p.y,t:i/n2})}1n(i=0;i<n1;i++){1n(K j=0;j<n2;j++){K di=pS[i],iW=pS[i+1],dj=pP[j],iX=pP[j+1],ci=4c(iW.x-di.x)<0.pQ?"y":"x",cj=4c(iX.x-dj.x)<0.pQ?"y":"x",is=wb(di.x,di.y,iW.x,iW.y,dj.x,dj.y,iX.x,iX.y);if(is){if(xy[is.x.4r(4)]==is.y.4r(4)){ag}xy[is.x.4r(4)]=is.y.4r(4);K t1=di.t+4c((is[ci]-di[ci])/ (iW[ci] - di[ci])) * (iW.t - di.t), t2 = dj.t + 4c((is[cj] - dj[cj]) /(iX[cj]-dj[cj]))*(iX.t-dj.t);if(t1>=0&&(t1<=1.pQ&&(t2>=0&&t2<=1.pQ))){if(fW){1A++}1i{1A.1C({x:is.x,y:is.y,t1:5J(t1,1),t2:5J(t2,1)})}}}}}1b 1A}R.XD=1a(9H,86){1b pG(9H,86)};R.XE=1a(9H,86){1b pG(9H,86,1)};1a pG(9H,86,fW){9H=R.pE(9H);86=R.pE(86);K x1,y1,x2,y2,o6,o5,mj,ml,8z,8A,1A=fW?0:[];1n(K i=0,ii=9H.1e;i<ii;i++){K pi=9H[i];if(pi[0]=="M"){x1=o6=pi[1];y1=o5=pi[2]}1i{if(pi[0]=="C"){8z=[x1,y1].3w(pi.3G(1));x1=8z[6];y1=8z[7]}1i{8z=[x1,y1,x1,y1,o6,o5,o6,o5];x1=o6;y1=o5}1n(K j=0,jj=86.1e;j<jj;j++){K pj=86[j];if(pj[0]=="M"){x2=mj=pj[1];y2=ml=pj[2]}1i{if(pj[0]=="C"){8A=[x2,y2].3w(pj.3G(1));x2=8A[6];y2=8A[7]}1i{8A=[x2,y2,x2,y2,mj,ml,mj,ml];x2=mj;y2=ml}K fX=pR(8z,8A,fW);if(fW){1A+=fX}1i{1n(K k=0,kk=fX.1e;k<kk;k++){fX[k].XC=i;fX[k].Xz=j;fX[k].8z=8z;fX[k].8A=8A}1A=1A.3w(fX)}}}}}1b 1A}R.Hy=1a(1G,x,y){K 2W=R.Ga(1G);1b R.yv(2W,x,y)&&pG(1G,[["M",x,y],["H",2W.x2+10]],1)%2==1};R.kq=1a(ec){1b 1a(){2Q("46.io",1c,"gC\\gD: Gh pl XA to 45 \\XB"+ec+"\\XV of 5c 1D",ec)}};K qp=R.Ga=1a(1G){K 7E=fG(1G);if(7E.2W){1b 5S(7E.2W)}if(!1G){1b{x:0,y:0,1r:0,1y:0,x2:0,y2:0}}1G=gV(1G);K x=0,y=0,X=[],Y=[],p;1n(K i=0,ii=1G.1e;i<ii;i++){p=1G[i];if(p[0]=="M"){x=p[1];y=p[2];X.1C(x);Y.1C(y)}1i{K mc=yf(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);X=X[3w](mc.5U.x,mc.4y.x);Y=Y[3w](mc.5U.y,mc.4y.y);x=p[5];y=p[6]}}K pt=5J[3d](0,X),pv=5J[3d](0,Y),yw=4Q[3d](0,X),yx=4Q[3d](0,Y),1r=yw-pt,1y=yx-pv,bb={x:pt,y:pv,x2:yw,y2:yx,1r:1r,1y:1y,cx:pt+1r/ 2, cy:pv + 1y /2};7E.2W=5S(bb);1b bb},bp=1a(5j){K 1A=5S(5j);1A.3r=R.ic;1b 1A},xg=R.Yg=1a(5j){K 7E=fG(5j);if(7E.yu){1b bp(7E.yu)}if(!R.is(5j,3K)||!R.is(5j&&5j[0],3K)){5j=R.yB(5j)}K 1A=[],x=0,y=0,mx=0,my=0,2J=0;if(5j[0][0]=="M"){x=5j[0][1];y=5j[0][2];mx=x;my=y;2J++;1A.1C(["M",x,y])}1n(K i=2J,ii=5j.1e;i<ii;i++){K r=1A[i]=[],pa=5j[i];if(pa[0]!=mq.2w(pa[0])){r[0]=mq.2w(pa[0]);3q(r[0]){1l"a":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]-x).4r(3);r[7]=+(pa[7]-y).4r(3);1p;1l"v":r[1]=+(pa[1]-y).4r(3);1p;1l"m":mx=pa[1];my=pa[2];5n:1n(K j=1,jj=pa.1e;j<jj;j++){r[j]=+(pa[j]-(j%2?x:y)).4r(3)}}}1i{r=1A[i]=[];if(pa[0]=="m"){mx=pa[1]+x;my=pa[2]+y}1n(K k=0,kk=pa.1e;k<kk;k++){1A[i][k]=pa[k]}}K 6b=1A[i].1e;3q(1A[i][0]){1l"z":x=mx;y=my;1p;1l"h":x+=+1A[i][6b-1];1p;1l"v":y+=+1A[i][6b-1];1p;5n:x+=+1A[i][6b-2];y+=+1A[i][6b-1]}}1A.3r=R.ic;7E.yu=bp(1A);1b 1A},yn=R.mg=1a(5j){K 7E=fG(5j);if(7E.4c){1b bp(7E.4c)}if(!R.is(5j,3K)||!R.is(5j&&5j[0],3K)){5j=R.yB(5j)}if(!5j||!5j.1e){1b[["M",0,0]]}K 1A=[],x=0,y=0,mx=0,my=0,2J=0;if(5j[0][0]=="M"){x=+5j[0][1];y=+5j[0][2];mx=x;my=y;2J++;1A[0]=["M",x,y]}K yz=5j.1e==3&&(5j[0][0]=="M"&&(5j[1][0].8u()=="R"&&5j[2][0].8u()=="Z"));1n(K r,pa,i=2J,ii=5j.1e;i<ii;i++){1A.1C(r=[]);pa=5j[i];if(pa[0]!=yD.2w(pa[0])){r[0]=yD.2w(pa[0]);3q(r[0]){1l"A":r[1]=pa[1];r[2]=pa[2];r[3]=pa[3];r[4]=pa[4];r[5]=pa[5];r[6]=+(pa[6]+x);r[7]=+(pa[7]+y);1p;1l"V":r[1]=+pa[1]+y;1p;1l"H":r[1]=+pa[1]+x;1p;1l"R":K 57=[x,y][3w](pa.3G(1));1n(K j=2,jj=57.1e;j<jj;j++){57[j]=+57[j]+x;57[++j]=+57[j]+y}1A.dw();1A=1A[3w](yy(57,yz));1p;1l"M":mx=+pa[1]+x;my=+pa[2]+y;5n:1n(j=1,jj=pa.1e;j<jj;j++){r[j]=+pa[j]+(j%2?x:y)}}}1i{if(pa[0]=="R"){57=[x,y][3w](pa.3G(1));1A.dw();1A=1A[3w](yy(57,yz));r=["R"][3w](pa.3G(-2))}1i{1n(K k=0,kk=pa.1e;k<kk;k++){r[k]=pa[k]}}}3q(r[0]){1l"Z":x=mx;y=my;1p;1l"H":x=r[1];1p;1l"V":y=r[1];1p;1l"M":mx=r[r.1e-2];my=r[r.1e-1];5n:x=r[r.1e-2];y=r[r.1e-1]}}1A.3r=R.ic;7E.4c=bp(1A);1b 1A},lR=1a(x1,y1,x2,y2){1b[x1,y1,x2,y2,x2,y2]},yk=1a(x1,y1,ax,ay,x2,y2){K mm=1/ 3, mp = 2 /3;1b[mm*x1+mp*ax,mm*y1+mp*ay,mm*x2+mp*ax,mm*y2+mp*ay,x2,y2]},yo=1a(x1,y1,rx,ry,7l,G8,ia,x2,y2,h5){K yh=PI*Yi/ cC, 8D = PI /cC*(+7l||0),1A=[],xy,5p=bn(1a(x,y,8D){K X=x*3y.8I(8D)-y*3y.8r(8D),Y=x*3y.8r(8D)+y*3y.8I(8D);1b{x:X,y:Y}});if(!h5){xy=5p(x1,y1,-8D);x1=xy.x;y1=xy.y;xy=5p(x2,y2,-8D);x2=xy.x;y2=xy.y;K 8I=3y.8I(PI/ cC * 7l), 8r = 3y.8r(PI /cC*7l),x=(x1-x2)/ 2, y = (y1 - y2) /2;K h=x*x/ (rx * rx) + y * y /(ry*ry);if(h>1){h=3y.9v(h);rx=h*rx;ry=h*ry}K po=rx*rx,pq=ry*ry,k=(G8==ia?-1:1)*3y.9v(4c((po*pq-po*y*y-pq*x*x)/ (po * y * y + pq * x * x))), cx = k * rx * y /ry+(x1+x2)/ 2, cy = k * -ry * x /rx+(y1+y2)/ 2, f1 = 3y.pz(((y1 - cy) /ry).4r(9)),f2=3y.pz(((y2-cy)/ry).4r(9));f1=x1<cx?PI-f1:f1;f2=x2<cx?PI-f2:f2;f1<0&&(f1=PI*2+f1);f2<0&&(f2=PI*2+f2);if(ia&&f1>f2){f1=f1-PI*2}if(!ia&&f2>f1){f2=f2-PI*2}}1i{f1=h5[0];f2=h5[1];cx=h5[2];cy=h5[3]}K df=f2-f1;if(4c(df)>yh){K Gv=f2,Ge=x2,Gf=y2;f2=f1+yh*(ia&&f2>f1?1:-1);x2=cx+rx*3y.8I(f2);y2=cy+ry*3y.8r(f2);1A=yo(x2,y2,rx,ry,7l,0,ia,Ge,Gf,[f2,Gv,cx,cy])}df=f2-f1;K c1=3y.8I(f1),s1=3y.8r(f1),c2=3y.8I(f2),s2=3y.8r(f2),t=3y.GM(df/ 4), hx = 4 /3*rx*t,hy=4/3*ry*t,m1=[x1,y1],m2=[x1+hx*s1,y1-hy*c1],m3=[x2+hx*s2,y2-hy*c2],m4=[x2,y2];m2[0]=2*m1[0]-m2[0];m2[1]=2*m1[1]-m2[1];if(h5){1b[m2,m3,m4][3w](1A)}1i{1A=[m2,m3,m4][3w](1A).4H()[3p](",");K ye=[];1n(K i=0,ii=1A.1e;i<ii;i++){ye[i]=i%2?5p(1A[i-1],1A[i],8D).y:5p(1A[i],1A[i+1],8D).x}1b ye}},lX=1a(5B,6a,6d,6c,77,7a,7k,7n,t){K t1=1-t;1b{x:5M(t1,3)*5B+5M(t1,2)*3*t*6d+t1*3*t*t*77+5M(t,3)*7k,y:5M(t1,3)*6a+5M(t1,2)*3*t*6c+t1*3*t*t*7a+5M(t,3)*7n}},yf=bn(1a(5B,6a,6d,6c,77,7a,7k,7n){K a=77-2*6d+5B-(7k-2*77+6d),b=2*(6d-5B)-2*(77-6d),c=5B-6d,t1=(-b+3y.9v(b*b-4*a*c))/ 2 /a,t2=(-b-3y.9v(b*b-4*a*c))/ 2 /a,y=[6a,7n],x=[5B,7k],6N;4c(t1)>"pw"&&(t1=0.5);4c(t2)>"pw"&&(t2=0.5);if(t1>0&&t1<1){6N=lX(5B,6a,6d,6c,77,7a,7k,7n,t1);x.1C(6N.x);y.1C(6N.y)}if(t2>0&&t2<1){6N=lX(5B,6a,6d,6c,77,7a,7k,7n,t2);x.1C(6N.x);y.1C(6N.y)}a=7a-2*6c+6a-(7n-2*7a+6c);b=2*(6c-6a)-2*(7a-6c);c=6a-6c;t1=(-b+3y.9v(b*b-4*a*c))/ 2 /a;t2=(-b-3y.9v(b*b-4*a*c))/ 2 /a;4c(t1)>"pw"&&(t1=0.5);4c(t2)>"pw"&&(t2=0.5);if(t1>0&&t1<1){6N=lX(5B,6a,6d,6c,77,7a,7k,7n,t1);x.1C(6N.x);y.1C(6N.y)}if(t2>0&&t2<1){6N=lX(5B,6a,6d,6c,77,7a,7k,7n,t2);x.1C(6N.x);y.1C(6N.y)}1b{5U:{x:5J[3d](0,x),y:5J[3d](0,y)},4y:{x:4Q[3d](0,x),y:4Q[3d](0,y)}}}),gV=R.pE=bn(1a(1G,86){K 7E=!86&&fG(1G);if(!86&&7E.ff){1b bp(7E.ff)}K p=yn(1G),p2=86&&yn(86),2b={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},cW={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:1c,qy:1c},yl=1a(1G,d,lU){K nx,ny,tq={T:1,Q:1};if(!1G){1b["C",d.x,d.y,d.x,d.y,d.x,d.y]}!(1G[0]in tq)&&(d.qx=d.qy=1c);3q(1G[0]){1l"M":d.X=1G[1];d.Y=1G[2];1p;1l"A":1G=["C"][3w](yo[3d](0,[d.x,d.y][3w](1G.3G(1))));1p;1l"S":if(lU=="C"||lU=="S"){nx=d.x*2-d.bx;ny=d.y*2-d.by}1i{nx=d.x;ny=d.y}1G=["C",nx,ny][3w](1G.3G(1));1p;1l"T":if(lU=="Q"||lU=="T"){d.qx=d.x*2-d.qx;d.qy=d.y*2-d.qy}1i{d.qx=d.x;d.qy=d.y}1G=["C"][3w](yk(d.x,d.y,d.qx,d.qy,1G[1],1G[2]));1p;1l"Q":d.qx=1G[1];d.qy=1G[2];1G=["C"][3w](yk(d.x,d.y,1G[1],1G[2],1G[3],1G[4]));1p;1l"L":1G=["C"][3w](lR(d.x,d.y,1G[1],1G[2]));1p;1l"H":1G=["C"][3w](lR(d.x,d.y,1G[1],d.y));1p;1l"V":1G=["C"][3w](lR(d.x,d.y,d.x,1G[1]));1p;1l"Z":1G=["C"][3w](lR(d.x,d.y,d.X,d.Y));1p}1b 1G},ym=1a(pp,i){if(pp[i].1e>7){pp[i].bP();K pi=pp[i];44(pi.1e){pp.5f(i++,0,["C"][3w](pi.5f(0,6)))}pp.5f(i,1);ii=4Q(p.1e,p2&&p2.1e||0)}},xK=1a(9H,86,a1,a2,i){if(9H&&(86&&(9H[i][0]=="M"&&86[i][0]!="M"))){86.5f(i,0,["M",a2.x,a2.y]);a1.bx=0;a1.by=0;a1.x=9H[i][1];a1.y=9H[i][2];ii=4Q(p.1e,p2&&p2.1e||0)}};1n(K i=0,ii=4Q(p.1e,p2&&p2.1e||0);i<ii;i++){p[i]=yl(p[i],2b);ym(p,i);p2&&(p2[i]=yl(p2[i],cW));p2&&ym(p2,i);xK(p,p2,2b,cW,i);xK(p2,p,cW,2b,i);K i9=p[i],jc=p2&&p2[i],lT=i9.1e,lS=p2&&jc.1e;2b.x=i9[lT-2];2b.y=i9[lT-1];2b.bx=3z(i9[lT-4])||2b.x;2b.by=3z(i9[lT-3])||2b.y;cW.bx=p2&&(3z(jc[lS-4])||cW.x);cW.by=p2&&(3z(jc[lS-3])||cW.y);cW.x=p2&&jc[lS-2];cW.y=p2&&jc[lS-1]}if(!p2){7E.ff=bp(p)}1b p2?[p,p2]:p},1c,bp),XZ=R.uJ=bn(1a(3Q){K 57=[];1n(K i=0,ii=3Q.1e;i<ii;i++){K 6N={},8C=3Q[i].3e(/^([^:]*):?([\\d\\.]*)/);6N.3s=R.b5(8C[1]);if(6N.3s.96){1b 1c}6N.3s=6N.3s.6f;8C[2]&&(6N.2y=8C[2]+"%");57.1C(6N)}1n(i=1,ii=57.1e-1;i<ii;i++){if(!57[i].2y){K 2J=3z(57[i-1].2y||0),4x=0;1n(K j=i+1;j<ii;j++){if(57[j].2y){4x=57[j].2y;1p}}if(!4x){4x=100;j=ii}4x=3z(4x);K d=(4x-2J)/(j-i+1);1n(;i<j;i++){2J+=d;57[i].2y=2J+"%"}}}1b 57}),m9=R.v9=1a(el,2v){el==2v.1O&&(2v.1O=el.3O);el==2v.4G&&(2v.4G=el.3k);el.3k&&(el.3k.3O=el.3O);el.3O&&(el.3O.3k=el.3k)},Y4=R.us=1a(el,2v){if(2v.1O===el){1b}m9(el,2v);el.3k=1c;el.3O=2v.1O;2v.1O.3k=el;2v.1O=el},Y9=R.uG=1a(el,2v){if(2v.4G===el){1b}m9(el,2v);el.3k=2v.4G;el.3O=1c;2v.4G.3O=el;2v.4G=el},Ya=R.uv=1a(el,9u,2v){m9(el,2v);9u==2v.1O&&(2v.1O=el);9u.3k&&(9u.3k.3O=el);el.3k=9u.3k;el.3O=9u;9u.3k=el},Yb=R.uy=1a(el,9u,2v){m9(el,2v);9u==2v.4G&&(2v.4G=el);9u.3O&&(9u.3O.3k=el);el.3O=9u.3O;9u.3O=el;el.3k=9u},x7=R.x7=1a(1G,3A){K bb=qp(1G),el={1U:{3A:E},6v:1a(){1b bb}};zF(el,3A);1b el.4w},pY=R.pY=1a(1G,3A){1b mw(1G,x7(1G,3A))},zF=R.uO=1a(el,aA){if(aA==1c){1b el.1U.3A}aA=3Z(aA).3f(/\\.{3}|\\uR/g,el.1U.3A||E);K m0=R.pF(aA),4n=0,dx=0,dy=0,sx=1,sy=1,1U=el.1U,m=1S dQ;1U.3A=m0||[];if(m0){1n(K i=0,ii=m0.1e;i<ii;i++){K t=m0[i],cP=t.1e,8h=3Z(t[0]).3R(),8x=t[0]!=8h,eQ=8x?m.n4():0,x1,y1,x2,y2,bb;if(8h=="t"&&cP==3){if(8x){x1=eQ.x(0,0);y1=eQ.y(0,0);x2=eQ.x(t[1],t[2]);y2=eQ.y(t[1],t[2]);m.fk(x2-x1,y2-y1)}1i{m.fk(t[1],t[2])}}1i{if(8h=="r"){if(cP==2){bb=bb||el.6v(1);m.5p(t[1],bb.x+bb.1r/ 2, bb.y + bb.1y /2);4n+=t[1]}1i{if(cP==4){if(8x){x2=eQ.x(t[2],t[3]);y2=eQ.y(t[2],t[3]);m.5p(t[1],x2,y2)}1i{m.5p(t[1],t[2],t[3])}4n+=t[1]}}}1i{if(8h=="s"){if(cP==2||cP==3){bb=bb||el.6v(1);m.82(t[1],t[cP-1],bb.x+bb.1r/ 2, bb.y + bb.1y /2);sx*=t[1];sy*=t[cP-1]}1i{if(cP==5){if(8x){x2=eQ.x(t[3],t[4]);y2=eQ.y(t[3],t[4]);m.82(t[1],t[2],x2,y2)}1i{m.82(t[1],t[2],t[3],t[4])}sx*=t[1];sy*=t[2]}}}1i{if(8h=="m"&&cP==7){m.51(t[1],t[2],t[3],t[4],t[5],t[6])}}}}1U.f5=1;el.4w=m}}el.4w=m;1U.sx=sx;1U.sy=sy;1U.4n=4n;1U.dx=dx=m.e;1U.dy=dy=m.f;if(sx==1&&(sy==1&&(!4n&&1U.2W))){1U.2W.x+=+dx;1U.2W.y+=+dy}1i{1U.f5=1}},x9=1a(1g){K l=1g[0];3q(l.3R()){1l"t":1b[l,0,0];1l"m":1b[l,1,0,0,1,0,0];1l"r":if(1g.1e==4){1b[l,0,1g[2],1g[3]]}1i{1b[l,0]};1l"s":if(1g.1e==5){1b[l,1,1,1g[3],1g[4]]}1i{if(1g.1e==3){1b[l,1,1]}1i{1b[l,1]}}}},Cg=R.Y6=1a(t1,t2){t2=3Z(t2).3f(/\\.{3}|\\uR/g,t1);t1=R.pF(t1)||[];t2=R.pF(t2)||[];K Fk=4Q(t1.1e,t2.1e),2s=[],to=[],i=0,j,jj,b3,cQ;1n(;i<Fk;i++){b3=t1[i]||x9(t2[i]);cQ=t2[i]||x9(b3);if(b3[0]!=cQ[0]||(b3[0].3R()=="r"&&(b3[2]!=cQ[2]||b3[3]!=cQ[3])||b3[0].3R()=="s"&&(b3[3]!=cQ[3]||b3[4]!=cQ[4]))){1b}2s[i]=[];to[i]=[];1n(j=0,jj=4Q(b3.1e,cQ.1e);j<jj;j++){j in b3&&(2s[i][j]=b3[j]);j in cQ&&(to[i][j]=cQ[j])}}1b{2s:2s,to:to}};R.w4=1a(x,y,w,h){K 4b;4b=h==1c&&!R.is(x,"1D")?g.2Y.dT(x):x;if(4b==1c){1b}if(4b.68){if(y==1c){1b{4b:4b,1r:4b.3b.Xq||4b.fC,1y:4b.3b.WK||4b.bj}}1i{1b{4b:4b,1r:y,1y:w}}}1b{4b:1,x:x,y:y,1r:w,1y:h}};R.xg=xg;R.4C={};R.gV=gV;R.4w=1a(a,b,c,d,e,f){1b 1S dQ(a,b,c,d,e,f)};1a dQ(a,b,c,d,e,f){if(a!=1c){J.a=+a;J.b=+b;J.c=+c;J.d=+d;J.e=+e;J.f=+f}1i{J.a=1;J.b=0;J.c=0;J.d=1;J.e=0;J.f=0}}(1a(8U){8U.51=1a(a,b,c,d,e,f){K 2m=[[],[],[]],m=[[J.a,J.c,J.e],[J.b,J.d,J.f],[0,0,1]],4w=[[a,c,e],[b,d,f],[0,0,1]],x,y,z,1A;if(a&&a eH dQ){4w=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1]]}1n(x=0;x<3;x++){1n(y=0;y<3;y++){1A=0;1n(z=0;z<3;z++){1A+=m[x][z]*4w[z][y]}2m[x][y]=1A}}J.a=2m[0][0];J.b=2m[1][0];J.c=2m[0][1];J.d=2m[1][1];J.e=2m[0][2];J.f=2m[1][2]};8U.n4=1a(){K me=J,x=me.a*me.d-me.b*me.c;1b 1S dQ(me.d/ x, -me.b /x,-me.c/ x, me.a /x,(me.c*me.f-me.d*me.e)/ x, (me.b * me.e - me.a * me.f) /x)};8U.5S=1a(){1b 1S dQ(J.a,J.b,J.c,J.d,J.e,J.f)};8U.fk=1a(x,y){J.51(1,0,0,1,x,y)};8U.82=1a(x,y,cx,cy){y==1c&&(y=x);(cx||cy)&&J.51(1,0,0,1,cx,cy);J.51(x,0,0,y,0,0);(cx||cy)&&J.51(1,0,0,1,-cx,-cy)};8U.5p=1a(a,x,y){a=R.8D(a);x=x||0;y=y||0;K 8I=+3y.8I(a).4r(9),8r=+3y.8r(a).4r(9);J.51(8I,8r,-8r,8I,x,y);J.51(1,0,0,1,-x,-y)};8U.x=1a(x,y){1b x*J.a+y*J.c+J.e};8U.y=1a(x,y){1b x*J.b+y*J.d+J.f};8U.4u=1a(i){1b+J[3Z.xh(97+i)].4r(4)};8U.3r=1a(){1b R.43?"4w("+[J.4u(0),J.4u(1),J.4u(2),J.4u(3),J.4u(4),J.4u(5)].4H()+")":[J.4u(0),J.4u(2),J.4u(1),J.4u(3),0,0].4H()};8U.JG=1a(){1b"z7:Nr.zg.dQ(WM="+J.4u(0)+", WJ="+J.4u(2)+", WG="+J.4u(1)+", WH="+J.4u(3)+", Dx="+J.4u(4)+", Dy="+J.4u(5)+", WS=\'6p WT\')"};8U.2y=1a(){1b[J.e.4r(4),J.f.4r(4)]};1a pC(a){1b a[0]*a[0]+a[1]*a[1]}1a xe(a){K xd=3y.9v(pC(a));a[0]&&(a[0]/=xd);a[1]&&(a[1]/=xd)}8U.3p=1a(){K 2m={};2m.dx=J.e;2m.dy=J.f;K 1I=[[J.a,J.c],[J.b,J.d]];2m.fj=3y.9v(pC(1I[0]));xe(1I[0]);2m.h1=1I[0][0]*1I[1][0]+1I[0][1]*1I[1][1];1I[1]=[1I[1][0]-1I[0][0]*2m.h1,1I[1][1]-1I[0][1]*2m.h1];2m.eJ=3y.9v(pC(1I[1]));xe(1I[1]);2m.h1/=2m.eJ;K 8r=-1I[0][1],8I=1I[1][1];if(8I<0){2m.5p=R.4n(3y.G0(8I));if(8r<0){2m.5p=8t-2m.5p}}1i{2m.5p=R.4n(3y.pz(8r))}2m.uV=!+2m.h1.4r(9)&&(2m.fj.4r(9)==2m.eJ.4r(9)||!2m.5p);2m.WU=!+2m.h1.4r(9)&&(2m.fj.4r(9)==2m.eJ.4r(9)&&!2m.5p);2m.JB=!+2m.h1.4r(9)&&!2m.5p;1b 2m};8U.WR=1a(G5){K s=G5||J[3p]();if(s.uV){s.fj=+s.fj.4r(4);s.eJ=+s.eJ.4r(4);s.5p=+s.5p.4r(4);1b(s.dx||s.dy?"t"+[s.dx,s.dy]:E)+(s.fj!=1||s.eJ!=1?"s"+[s.fj,s.eJ,0,0]:E)+(s.5p?"r"+[s.5p,0,0]:E)}1i{1b"m"+[J.4u(0),J.4u(1),J.4u(2),J.4u(3),J.4u(4),J.4u(5)]}}})(dQ.2S);K 5N=b1.eG.3e(/WO\\/(.*?)\\s/)||b1.eG.3e(/WP\\/(\\d+)/);if(b1.FN=="WQ Wv, FL."&&(5N&&5N[1]<4||b1.Ww.3G(0,2)=="iP")||b1.FN=="Wu FL."&&(5N&&5N[1]<8)){62.jo=1a(){K 4l=J.4l(-99,-99,J.1r+99,J.1y+99).1k({1X:"3t"});6y(1a(){4l.3u()})}}1i{62.jo=pW}K 4g=1a(){J.Wr=1j},HX=1a(){1b J.cS.4g()},7L=1a(){J.Ws=1o},HY=1a(){1b J.cS.7L()},wV=1a(e){K dX=g.2Y.9Q.5a||g.2Y.3U.5a,e0=g.2Y.9Q.4S||g.2Y.3U.4S;1b{x:e.aB+e0,y:e.aT+dX}},I4=1a(){if(g.2Y.bi){1b 1a(1u,1w,fn,1f){K f=1a(e){K 3V=wV(e);1b fn.2w(1f,e,3V.x,3V.y)};1u.bi(1w,f,1j);if(mS&&mW[1w]){K HT=1a(e){K 3V=wV(e),FR=e;1n(K i=0,ii=e.qi&&e.qi.1e;i<ii;i++){if(e.qi[i].3m==1u){e=e.qi[i];e.cS=FR;e.4g=HX;e.7L=HY;1p}}1b fn.2w(1f,e,3V.x,3V.y)};1u.bi(mW[1w],HT,1j)}1b 1a(){1u.lj(1w,f,1j);if(mS&&mW[1w]){1u.lj(mW[1w],f,1j)}1b 1o}}}1i{if(g.2Y.gu){1b 1a(1u,1w,fn,1f){K f=1a(e){e=e||g.5l.1H;K dX=g.2Y.9Q.5a||g.2Y.3U.5a,e0=g.2Y.9Q.4S||g.2Y.3U.4S,x=e.aB+e0,y=e.aT+dX;e.4g=e.4g||4g;e.7L=e.7L||7L;1b fn.2w(1f,e,x,y)};1u.gu("on"+1w,f);K HV=1a(){1u.vw("on"+1w,f);1b 1o};1b HV}}}}(),5g=[],qf=1a(e){K x=e.aB,y=e.aT,dX=g.2Y.9Q.5a||g.2Y.3U.5a,e0=g.2Y.9Q.4S||g.2Y.3U.4S,7q,j=5g.1e;44(j--){7q=5g[j];if(mS&&e.hi){K i=e.hi.1e,9c;44(i--){9c=e.hi[i];if(9c.qh==7q.el.d3.id){x=9c.aB;y=9c.aT;(e.cS?e.cS:e).4g();1p}}}1i{e.4g()}K 1s=7q.el.1s,o,3k=1s.iN,1L=1s.3n,5q=1s.3b.5q;g.5l.xA&&1L.7g(1s);1s.3b.5q="3t";o=7q.el.2v.H6(x,y);1s.3b.5q=5q;g.5l.xA&&(3k?1L.76(1s,3k):1L.3E(1s));o&&2Q("46.5g.iS."+7q.el.id,7q.el,o);x+=e0;y+=dX;2Q("46.5g.cV."+7q.el.id,7q.jp||7q.el,x-7q.el.d3.x,y-7q.el.d3.y,x,y,e)}},qg=1a(e){R.I8(qf).Ih(qg);K i=5g.1e,7q;44(i--){7q=5g[i];7q.el.d3={};2Q("46.5g.4x."+7q.el.id,7q.qe||(7q.n9||(7q.jp||7q.el)),e)}5g=[]},3c=R.el={};1n(K i=4v.1e;i--;){(1a(cd){R[cd]=3c[cd]=1a(fn,eF){if(R.is(fn,"1a")){J.4v=J.4v||[];J.4v.1C({1z:cd,f:fn,7V:I4(J.c7||(J.1s||g.2Y),cd,fn,eF||J)})}1b J};R["un"+cd]=3c["un"+cd]=1a(fn){K 4v=J.4v||[],l=4v.1e;44(l--){if(4v[l].1z==cd&&(R.is(fn,"2O")||4v[l].f==fn)){4v[l].7V();4v.5f(l,1);!4v.1e&&41 J.4v}}1b J}})(4v[i])}3c.1h=1a(1q,1m){K 1h=h4[J.id]=h4[J.id]||{};if(2q.1e==0){1b 1h}if(2q.1e==1){if(R.is(1q,"1D")){1n(K i in 1q){if(1q[3o](i)){J.1h(i,1q[i])}}1b J}2Q("46.1h.4u."+J.id,J,1h[1q],1q);1b 1h[1q]}1h[1q]=1m;2Q("46.1h.5v."+J.id,J,1m,1q);1b J};3c.rQ=1a(1q){if(1q==1c){h4[J.id]={}}1i{h4[J.id]&&41 h4[J.id][1q]}1b J};3c.WD=1a(){1b 5S(h4[J.id]||{})};3c.6D=1a(qk,ox,wZ,HH){1b J.ha(qk,wZ).dL(ox,HH||wZ)};3c.WE=1a(qk,ox){1b J.WF(qk).WC(ox)};K 6W=[];3c.5g=1a(wW,x5,wX,jp,n9,qe){1a 2J(e){(e.cS||e).4g();K x=e.aB,y=e.aT,dX=g.2Y.9Q.5a||g.2Y.3U.5a,e0=g.2Y.9Q.4S||g.2Y.3U.4S;J.d3.id=e.qh;if(mS&&e.hi){K i=e.hi.1e,9c;44(i--){9c=e.hi[i];J.d3.id=9c.qh;if(9c.qh==J.d3.id){x=9c.aB;y=9c.aT;1p}}}J.d3.x=x+e0;J.d3.y=y+dX;!5g.1e&&R.9x(qf).5u(qg);5g.1C({el:J,jp:jp,n9:n9,qe:qe});x5&&2Q.on("46.5g.2J."+J.id,x5);wW&&2Q.on("46.5g.cV."+J.id,wW);wX&&2Q.on("46.5g.4x."+J.id,wX);2Q("46.5g.2J."+J.id,n9||(jp||J),e.aB+e0,e.aT+dX,e)}J.d3={};6W.1C({el:J,2J:2J});J.7i(2J);1b J};3c.Xh=1a(f){f?2Q.on("46.5g.iS."+J.id,f):2Q.7V("46.5g.iS."+J.id)};3c.Xe=1a(){K i=6W.1e;44(i--){if(6W[i].el==J){J.Xb(6W[i].2J);6W.5f(i,1);2Q.7V("46.5g.*."+J.id)}}!6W.1e&&R.I8(qf).Ih(qg);5g=[]};62.9i=1a(x,y,r){K 2m=R.4C.9i(J,x||0,y||0,r||0);J.6I&&J.6I.1C(2m);1b 2m};62.4l=1a(x,y,w,h,r){K 2m=R.4C.4l(J,x||0,y||0,w||0,h||0,r||0);J.6I&&J.6I.1C(2m);1b 2m};62.a0=1a(x,y,rx,ry){K 2m=R.4C.a0(J,x||0,y||0,rx||0,ry||0);J.6I&&J.6I.1C(2m);1b 2m};62.1G=1a(8j){8j&&(!R.is(8j,4d)&&(!R.is(8j[0],3K)&&(8j+=E)));K 2m=R.4C.1G(R.6s[3d](R,2q),J);J.6I&&J.6I.1C(2m);1b 2m};62.8R=1a(4a,x,y,w,h){K 2m=R.4C.8R(J,4a||"Ic:yE",x||0,y||0,w||0,h||0);J.6I&&J.6I.1C(2m);1b 2m};62.1Y=1a(x,y,1Y){K 2m=R.4C.1Y(J,x||0,y||0,3Z(1Y));J.6I&&J.6I.1C(2m);1b 2m};62.5v=1a(ql){!R.is(ql,"3K")&&(ql=3Y.2S.5f.2w(2q,0,2q.1e));K 2m=1S jT(ql);J.6I&&J.6I.1C(2m);2m["2v"]=J;2m["1w"]="5v";1b 2m};62.Xi=1a(5v){J.6I=5v||J.5v()};62.Xn=1a(5v){K 2m=J.6I;41 J.6I;1b 2m};62.hR=1a(1r,1y){1b R.4C.hR.2w(J,1r,1y)};62.fc=1a(x,y,w,h,al){1b R.4C.fc.2w(J,x,y,w,h,al)};62.1O=62.4G=1c;62.46=R;K Hd=1a(6l){K 53=6l.vj(),2Y=6l.vo,3U=2Y.3U,eg=2Y.9Q,j2=eg.j2||(3U.j2||0),j4=eg.j4||(3U.j4||0),1O=53.1O+(g.5l.Ha||(eg.5a||3U.5a))-j2,2a=53.2a+(g.5l.Xo||(eg.4S||3U.4S))-j4;1b{y:1O,x:2a}};62.H6=1a(x,y){K 2v=J,43=2v.1V,3m=g.2Y.qq(x,y);if(g.5l.xA&&3m.68=="43"){K so=Hd(43),sr=43.Xp();sr.x=x-so.x;sr.y=y-so.y;sr.1r=sr.1y=1;K qs=43.Xj(sr,1c);if(qs.1e){3m=qs[qs.1e-1]}}if(!3m){1b 1c}44(3m.3n&&(3m!=43.3n&&!3m.46)){3m=3m.3n}3m==2v.1V.3n&&(3m=43);3m=3m&&3m.46?2v.H5(3m.va):1c;1b 3m};62.Xl=1a(2W){K 5v=J.5v();J.8G(1a(el){if(R.xJ(el.6v(),2W)){5v.1C(el)}});1b 5v};62.H5=1a(id){K c6=J.4G;44(c6){if(c6.id==id){1b c6}c6=c6.3k}1b 1c};62.8G=1a(1Z,q7){K c6=J.4G;44(c6){if(1Z.2w(q7,c6)===1j){1b J}c6=c6.3k}1b J};62.X1=1a(x,y){K 5v=J.5v();J.8G(1a(el){if(el.ge(x,y)){5v.1C(el)}});1b 5v};1a X2(){1b J.x+S+J.y}1a xw(){1b J.x+S+J.y+S+J.1r+" \\WZ "+J.1y}3c.ge=1a(x,y){K rp=J.fF=bz[J.1w](J);if(J.1k("3A")&&J.1k("3A").1e){rp=R.pY(rp,J.1k("3A"))}1b R.Hy(rp,x,y)};3c.6v=1a(HA){if(J.5c){1b{}}K 1U=J.1U;if(HA){if(1U.7M||!1U.mF){J.fF=bz[J.1w](J);1U.mF=qp(J.fF);1U.mF.3r=xw;1U.7M=0}1b 1U.mF}if(1U.7M||(1U.f5||!1U.2W)){if(1U.7M||!J.fF){1U.mF=0;J.fF=bz[J.1w](J)}1U.2W=qp(mw(J.fF,J.4w));1U.2W.3r=xw;1U.7M=1U.f5=0}1b 1U.2W};3c.5S=1a(){if(J.5c){1b 1c}K 2m=J.2v[J.1w]().1k(J.1k());J.6I&&J.6I.1C(2m);1b 2m};3c.bR=1a(bR){if(J.1w=="1Y"){1b 1c}bR=bR||{};K s={1r:(bR.1r||10)+(+J.1k("1X-1r")||1),28:bR.28||1j,2I:bR.2I||0.5,xm:bR.xm||0,xn:bR.xn||0,3s:bR.3s||"#c8"},c=s.1r/2,r=J.2v,2m=r.5v(),1G=J.fF||bz[J.1w](J);1G=J.4w?mw(1G,J.4w):1G;1n(K i=1;i<c+1;i++){2m.1C(r.1G(1G).1k({1X:s.3s,28:s.28?s.3s:"3t","1X-gj":"4I","1X-cH":"4I","1X-1r":+(s.1r/ c * i).4r(3), 2I:+(s.2I /c).4r(3)}))}1b 2m.76(J).fk(s.xm,s.xn)};K X3={},qm=1a(5B,6a,6d,6c,77,7a,7k,7n,1e){if(1e==1c){1b gI(5B,6a,6d,6c,77,7a,7k,7n)}1i{1b R.mM(5B,6a,6d,6c,77,7a,7k,7n,HD(5B,6a,6d,6c,77,7a,7k,7n,1e))}},qd=1a(xk,qn){1b 1a(1G,1e,Hj){1G=gV(1G);K x,y,p,l,sp="",mA={},6m,6b=0;1n(K i=0,ii=1G.1e;i<ii;i++){p=1G[i];if(p[0]=="M"){x=+p[1];y=+p[2]}1i{l=qm(x,y,p[1],p[2],p[3],p[4],p[5],p[6]);if(6b+l>1e){if(qn&&!mA.2J){6m=qm(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-6b);sp+=["C"+6m.2J.x,6m.2J.y,6m.m.x,6m.m.y,6m.x,6m.y];if(Hj){1b sp}mA.2J=sp;sp=["M"+6m.x,6m.y+"C"+6m.n.x,6m.n.y,6m.4x.x,6m.4x.y,p[5],p[6]].4H();6b+=l;x=+p[5];y=+p[6];ag}if(!xk&&!qn){6m=qm(x,y,p[1],p[2],p[3],p[4],p[5],p[6],1e-6b);1b{x:6m.x,y:6m.y,dt:6m.dt}}}6b+=l;x=+p[5];y=+p[6]}sp+=p.bP()+p}mA.4x=sp;6m=xk?6b:qn?mA:R.mM(x,y,p[0],p[1],p[2],p[3],p[4],p[5],1);6m.dt&&(6m={x:6m.x,y:6m.y,dt:6m.dt});1b 6m}};K bC=qd(1),mJ=qd(),q1=qd(0,1);R.bC=bC;R.mJ=mJ;R.mN=1a(1G,2s,to){if(J.bC(1G)-to<1E-6){1b q1(1G,2s).4x}K a=q1(1G,to,1);1b 2s?q1(a,2s).4x:a};3c.bC=1a(){K 1G=J.bz();if(!1G){1b}if(J.1s.bC){1b J.1s.bC()}1b bC(1G)};3c.mJ=1a(1e){K 1G=J.bz();if(!1G){1b}1b mJ(1G,1e)};3c.bz=1a(){K 1G,bz=R.uh[J.1w];if(J.1w=="1Y"||J.1w=="5v"){1b}if(bz){1G=bz(J)}1b 1G};3c.mN=1a(2s,to){K 1G=J.bz();if(!1G){1b}1b R.mN(1G,2s,to)};K ef=R.Ch={nS:1a(n){1b n},"<":1a(n){1b 5M(n,1.7)},">":1a(n){1b 5M(n,0.48)},"<>":1a(n){K q=0.48-n/ 1.106, Q = 3y.9v(0.ZW + q * q), x = Q - q, X = 5M(4c(x), 1 /3)*(x<0?-1:1),y=-Q-q,Y=5M(4c(y),1/3)*(y<0?-1:1),t=X+Y+0.5;1b(1-t)*3*t*t+t*t*t},Dj:1a(n){K s=1.D5;1b n*n*((s+1)*n-s)},Da:1a(n){n=n-1;K s=1.D5;1b n*n*((s+1)*n+s)+1},10h:1a(n){if(n==!!n){1b n}1b 5M(2,-10*n)*3y.8r((n-0.CZ)*(2*PI)/0.3)+1},10e:1a(n){K s=7.10c,p=2.75,l;if(n<1/p){l=s*n*n}1i{if(n<2/p){n-=1.5/p;l=s*n*n+0.75}1i{if(n<2.5/p){n-=2.25/p;l=s*n*n+0.ZC}1i{n-=2.ZB/p;l=s*n*n+0.ZA}}}1b l}};ef.Zz=ef["zH-in"]=ef["<"];ef.Zv=ef["zH-2m"]=ef[">"];ef.Zu=ef["zH-in-2m"]=ef["<>"];ef["zI-in"]=ef.Dj;ef["zI-2m"]=ef.Da;K 4W=[],Af=3P.Zy||(3P.Zx||(3P.ZS||(3P.ZK||(3P.ZL||1a(1Z){6y(1Z,16)})))),6M=1a(){K D3=+1S 5k,l=0;1n(;l<4W.1e;l++){K e=4W[l];if(e.el.5c||e.Ag){ag}K dS=D3-e.2J,ms=e.ms,5w=e.5w,2s=e.2s,5x=e.5x,to=e.to,t=e.t,6e=e.el,5v={},7b,7I={},1q;if(e.k1){dS=(e.k1*e.2A.1O-e.3O)/(e.a7-e.3O)*ms;e.6F=e.k1;41 e.k1;e.5D&&4W.5f(l--,1)}1i{e.6F=(e.3O+(e.a7-e.3O)*(dS/ ms)) /e.2A.1O}if(dS<0){ag}if(dS<ms){K 3V=5w(dS/ms);1n(K 1k in 2s){if(2s[3o](1k)){3q(q0[1k]){1l nu:7b=+2s[1k]+3V*ms*5x[1k];1p;1l"9B":7b="3D("+[q2(4I(2s[1k].r+3V*ms*5x[1k].r)),q2(4I(2s[1k].g+3V*ms*5x[1k].g)),q2(4I(2s[1k].b+3V*ms*5x[1k].b))].4H(",")+")";1p;1l"1G":7b=[];1n(K i=0,ii=2s[1k].1e;i<ii;i++){7b[i]=[2s[1k][i][0]];1n(K j=1,jj=2s[1k][i].1e;j<jj;j++){7b[i][j]=+2s[1k][i][j]+3V*ms*5x[1k][i][j]}7b[i]=7b[i].4H(S)}7b=7b.4H(S);1p;1l"3A":if(5x[1k].Cn){7b=[];1n(i=0,ii=2s[1k].1e;i<ii;i++){7b[i]=[2s[1k][i][0]];1n(j=1,jj=2s[1k][i].1e;j<jj;j++){7b[i][j]=2s[1k][i][j]+3V*ms*5x[1k][i][j]}}}1i{K 4u=1a(i){1b+2s[1k][i]+3V*ms*5x[1k][i]};7b=[["m",4u(0),4u(1),4u(2),4u(3),4u(4),4u(5)]]}1p;1l"zB":if(1k=="5Z-4l"){7b=[];i=4;44(i--){7b[i]=+2s[1k][i]+3V*ms*5x[1k][i]}}1p;5n:K gU=[][3w](2s[1k]);7b=[];i=6e.2v.8P[1k].1e;44(i--){7b[i]=+gU[i]+3V*ms*5x[1k][i]}1p}5v[1k]=7b}}6e.1k(5v);(1a(id,6e,2A){6y(1a(){2Q("46.2A.q3."+id,6e,2A)})})(6e.id,6e,e.2A)}1i{(1a(f,el,a){6y(1a(){2Q("46.2A.q3."+el.id,el,a);2Q("46.2A.ZM."+el.id,el,a);R.is(f,"1a")&&f.2w(el)})})(e.1Z,6e,e.2A);6e.1k(to);4W.5f(l--,1);if(e.kl>1&&!e.3k){1n(1q in to){if(to[3o](1q)){7I[1q]=e.hz[1q]}}e.el.1k(7I);kc(e.2A,e.el,e.2A.8d[0],1c,e.hz,e.kl-1)}if(e.3k&&!e.5D){kc(e.2A,e.el,e.3k,1c,e.hz,e.kl)}}}R.43&&(6e&&(6e.2v&&6e.2v.jo()));4W.1e&&Af(6M)},q2=1a(3s){1b 3s>dM?dM:3s<0?0:3s};3c.CM=1a(el,2A,1v,ms,5w,1Z){K 1f=J;if(1f.5c){1Z&&1Z.2w(1f);1b 1f}K a=1v eH de?1v:R.6M(1v,ms,5w,1Z),x,y;kc(a,1f,a.8d[0],1c,1f.1k());1n(K i=0,ii=4W.1e;i<ii;i++){if(4W[i].2A==2A&&4W[i].el==el){4W[ii-1].2J=4W[i].2J;1p}}1b 1f};1a CR(t,5B,6a,7k,7n,6O){K cx=3*5B,bx=3*(7k-5B)-cx,ax=1-cx-bx,cy=3*6a,by=3*(7n-6a)-cy,ay=1-cy-by;1a zx(t){1b((ax*t+bx)*t+cx)*t}1a Dv(x,mE){K t=DK(x,mE);1b((ay*t+by)*t+cy)*t}1a DK(x,mE){K t0,t1,t2,x2,d2,i;1n(t2=x,i=0;i<8;i++){x2=zx(t2)-x;if(4c(x2)<mE){1b t2}d2=(3*ax*t2+2*bx)*t2+cx;if(4c(d2)<1E-6){1p}t2=t2-x2/d2}t0=0;t1=1;t2=x;if(t2<t0){1b t0}if(t2>t1){1b t1}44(t0<t1){x2=zx(t2);if(4c(x2-x)<mE){1b t2}if(x>x2){t0=t2}1i{t1=t2}t2=(t1-t0)/2+t0}1b t2}1b Dv(t,1/(fN*6O))}3c.ZG=1a(f){f?2Q.on("46.2A.q3."+J.id,f):2Q.7V("46.2A.q3."+J.id);1b J};1a de(2A,ms){K 8d=[],zu={};J.ms=ms;J.cf=1;if(2A){1n(K 1k in 2A){if(2A[3o](1k)){zu[3z(1k)]=2A[1k];8d.1C(3z(1k))}}8d.eU(Ct)}J.2A=zu;J.1O=8d[8d.1e-1];J.8d=8d}de.2S.eZ=1a(eZ){K a=1S de(J.2A,J.ms);a.cf=J.cf;a.qa=+eZ||0;1b a};de.2S.kl=1a(cf){K a=1S de(J.2A,J.ms);a.qa=J.qa;a.cf=3y.gH(4Q(cf,0))||1;1b a};1a kc(2A,1f,a7,6F,hz,cf){a7=3z(a7);K 1v,hG,q5,8d=[],3k,3O,mh,ms=2A.ms,2s={},to={},5x={};if(6F){1n(i=0,ii=4W.1e;i<ii;i++){K e=4W[i];if(e.el.id==1f.id&&e.2A==2A){if(e.a7!=a7){4W.5f(i,1);q5=1}1i{hG=e}1f.1k(e.hz);1p}}}1i{6F=+to}1n(K i=0,ii=2A.8d.1e;i<ii;i++){if(2A.8d[i]==a7||2A.8d[i]>6F*2A.1O){a7=2A.8d[i];3O=2A.8d[i-1]||0;ms=ms/2A.1O*(a7-3O);3k=2A.8d[i+1];1v=2A.2A[a7];1p}1i{if(6F){1f.1k(2A.2A[2A.8d[i]])}}}if(!1v){1b}if(!hG){1n(K 1k in 1v){if(1v[3o](1k)){if(q0[3o](1k)||1f.2v.8P[3o](1k)){2s[1k]=1f.1k(1k);2s[1k]==1c&&(2s[1k]=Cv[1k]);to[1k]=1v[1k];3q(q0[1k]){1l nu:5x[1k]=(to[1k]-2s[1k])/ms;1p;1l"9B":2s[1k]=R.b5(2s[1k]);K pX=R.b5(to[1k]);5x[1k]={r:(pX.r-2s[1k].r)/ ms, g:(pX.g - 2s[1k].g) /ms,b:(pX.b-2s[1k].b)/ms};1p;1l"1G":K zE=gV(2s[1k],to[1k]),Cf=zE[1];2s[1k]=zE[0];5x[1k]=[];1n(i=0,ii=2s[1k].1e;i<ii;i++){5x[1k][i]=[0];1n(K j=1,jj=2s[1k][i].1e;j<jj;j++){5x[1k][i][j]=(Cf[i][j]-2s[1k][i][j])/ms}}1p;1l"3A":K 1U=1f.1U,eq=Cg(1U[1k],to[1k]);if(eq){2s[1k]=eq.2s;to[1k]=eq.to;5x[1k]=[];5x[1k].Cn=1o;1n(i=0,ii=2s[1k].1e;i<ii;i++){5x[1k][i]=[2s[1k][i][0]];1n(j=1,jj=2s[1k][i].1e;j<jj;j++){5x[1k][i][j]=(to[1k][i][j]-2s[1k][i][j])/ms}}}1i{K m=1f.4w||1S dQ,e2={1U:{3A:1U.3A},6v:1a(){1b 1f.6v(1)}};2s[1k]=[m.a,m.b,m.c,m.d,m.e,m.f];zF(e2,to[1k]);to[1k]=e2.1U.3A;5x[1k]=[(e2.4w.a-m.a)/ ms, (e2.4w.b - m.b) /ms,(e2.4w.c-m.c)/ ms, (e2.4w.d - m.d) /ms,(e2.4w.e-m.e)/ ms, (e2.4w.f - m.f) /ms]}1p;1l"zB":K 2H=3Z(1v[1k])[3p](5o),gU=3Z(2s[1k])[3p](5o);if(1k=="5Z-4l"){2s[1k]=gU;5x[1k]=[];i=gU.1e;44(i--){5x[1k][i]=(2H[i]-2s[1k][i])/ms}}to[1k]=2H;1p;5n:2H=[][3w](1v[1k]);gU=[][3w](2s[1k]);5x[1k]=[];i=1f.2v.8P[1k].1e;44(i--){5x[1k][i]=((2H[i]||0)-(gU[i]||0))/ms}1p}}}}K 5w=1v.5w,dZ=R.Ch[5w];if(!dZ){dZ=3Z(5w).3e(CB);if(dZ&&dZ.1e==5){K ff=dZ;dZ=1a(t){1b CR(t,+ff[1],+ff[2],+ff[3],+ff[4],ms)}}1i{dZ=CS}}mh=1v.2J||(2A.2J||+1S 5k);e={2A:2A,a7:a7,mh:mh,2J:mh+(2A.qa||0),6F:0,k1:6F||0,5D:1j,ms:ms,5w:dZ,2s:2s,5x:5x,to:to,el:1f,1Z:1v.1Z,3O:3O,3k:3k,kl:cf||2A.cf,fo:1f.1k(),hz:hz};4W.1C(e);if(6F&&(!hG&&!q5)){e.5D=1o;e.2J=1S 5k-ms*6F;if(4W.1e==1){1b 6M()}}if(q5){e.2J=1S 5k-e.ms*6F}4W.1e==1&&Af(6M)}1i{hG.k1=6F;hG.2J=1S 5k-hG.ms*6F}2Q("46.2A.2J."+1f.id,1f,2A)}R.6M=1a(1v,ms,5w,1Z){if(1v eH de){1b 1v}if(R.is(5w,"1a")||!5w){1Z=1Z||(5w||1c);5w=1c}1v=4K(1v);ms=+ms||0;K p={},ez,1k;1n(1k in 1v){if(1v[3o](1k)&&(3z(1k)!=1k&&3z(1k)+"%"!=1k)){ez=1o;p[1k]=1v[1k]}}if(!ez){1b 1S de(1v,ms)}1i{5w&&(p.5w=5w);1Z&&(p.1Z=1Z);1b 1S de({100:p},ms)}};3c.4J=1a(1v,ms,5w,1Z){K 1f=J;if(1f.5c){1Z&&1Z.2w(1f);1b 1f}K 2A=1v eH de?1v:R.6M(1v,ms,5w,1Z);kc(2A,1f,2A.8d[0],1c,1f.1k());1b 1f};3c.ZZ=1a(2A,1m){if(2A&&1m!=1c){J.6F(2A,5J(1m,2A.ms)/2A.ms)}1b J};3c.6F=1a(2A,1m){K 2m=[],i=0,6b,e;if(1m!=1c){kc(2A,J,-1,5J(1m,1));1b J}1i{6b=4W.1e;1n(;i<6b;i++){e=4W[i];if(e.el.id==J.id&&(!2A||e.2A==2A)){if(2A){1b e.6F}2m.1C({2A:e.2A,6F:e.6F})}}if(2A){1b 0}1b 2m}};3c.CG=1a(2A){1n(K i=0;i<4W.1e;i++){if(4W[i].el.id==J.id&&(!2A||4W[i].2A==2A)){if(2Q("46.2A.CG."+J.id,J,4W[i].2A)!==1j){4W[i].Ag=1o}}}1b J};3c.CC=1a(2A){1n(K i=0;i<4W.1e;i++){if(4W[i].el.id==J.id&&(!2A||4W[i].2A==2A)){K e=4W[i];if(2Q("46.2A.CC."+J.id,J,e.2A)!==1j){41 e.Ag;J.6F(e.2A,e.6F)}}}1b J};3c.5D=1a(2A){1n(K i=0;i<4W.1e;i++){if(4W[i].el.id==J.id&&(!2A||4W[i].2A==2A)){if(2Q("46.2A.5D."+J.id,J,4W[i].2A)!==1j){4W.5f(i--,1)}}}1b J};1a Ah(2v){1n(K i=0;i<4W.1e;i++){if(4W[i].el.2v==2v){4W.5f(i--,1)}}}2Q.on("46.3u",Ah);2Q.on("46.af",Ah);3c.3r=1a(){1b"gC\\gD\\101 1D"};K jT=1a(1F){J.1F=[];J.1e=0;J.1w="5v";if(1F){1n(K i=0,ii=1F.1e;i<ii;i++){if(1F[i]&&(1F[i].4V==3c.4V||1F[i].4V==jT)){J[J.1F.1e]=J.1F[J.1F.1e]=1F[i];J.1e++}}}},6L=jT.2S;6L.1C=1a(){K 1g,6b;1n(K i=0,ii=2q.1e;i<ii;i++){1g=2q[i];if(1g&&(1g.4V==3c.4V||1g.4V==jT)){6b=J.1F.1e;J[6b]=J.1F[6b]=1g;J.1e++}}1b J};6L.dw=1a(){J.1e&&41 J[J.1e--];1b J.1F.dw()};6L.8G=1a(1Z,q7){1n(K i=0,ii=J.1F.1e;i<ii;i++){if(1Z.2w(q7,J.1F[i],i)===1j){1b J}}1b J};1n(K 45 in 3c){if(3c[3o](45)){6L[45]=1a(ec){1b 1a(){K 4i=2q;1b J.8G(1a(el){el[ec][3d](el,4i)})}}(45)}}6L.1k=1a(1z,1m){if(1z&&(R.is(1z,3K)&&R.is(1z[0],"1D"))){1n(K j=0,jj=1z.1e;j<jj;j++){J.1F[j].1k(1z[j])}}1i{1n(K i=0,ii=J.1F.1e;i<ii;i++){J.1F[i].1k(1z,1m)}}1b J};6L.af=1a(){44(J.1e){J.dw()}};6L.5f=1a(1P,6x,ZX){1P=1P<0?4Q(J.1e+1P,0):1P;6x=4Q(0,5J(J.1e-1P,6x));K r3=[],Ae=[],2e=[],i;1n(i=2;i<2q.1e;i++){2e.1C(2q[i])}1n(i=0;i<6x;i++){Ae.1C(J[1P+i])}1n(;i<J.1e-1P;i++){r3.1C(J[1P+i])}K nH=2e.1e;1n(i=0;i<nH+r3.1e;i++){J.1F[1P+i]=J[1P+i]=i<nH?2e[i]:r3[i-nH]}i=J.1F.1e=J.1e-=6x-nH;44(J[i]){41 J[i++]}1b 1S jT(Ae)};6L.uZ=1a(el){1n(K i=0,ii=J.1e;i<ii;i++){if(J[i]==el){J.5f(i,1);1b 1o}}};6L.4J=1a(1v,ms,5w,1Z){(R.is(5w,"1a")||!5w)&&(1Z=5w||1c);K 6b=J.1F.1e,i=6b,1g,5v=J,q6;if(!6b){1b J}1Z&&(q6=1a(){!--6b&&1Z.2w(5v)});5w=R.is(5w,4d)?5w:q6;K 2A=R.6M(1v,ms,5w,q6);1g=J.1F[--i].4J(2A);44(i--){J.1F[i]&&(!J.1F[i].5c&&J.1F[i].CM(1g,2A,2A));J.1F[i]&&!J.1F[i].5c||6b--}1b J};6L.e7=1a(el){K i=J.1F.1e;44(i--){J.1F[i].e7(el)}1b J};6L.6v=1a(){K x=[],y=[],x2=[],y2=[];1n(K i=J.1F.1e;i--;){if(!J.1F[i].5c){K 53=J.1F[i].6v();x.1C(53.x);y.1C(53.y);x2.1C(53.x+53.1r);y2.1C(53.y+53.1y)}}x=5J[3d](0,x);y=5J[3d](0,y);x2=4Q[3d](0,x2);y2=4Q[3d](0,y2);1b{x:x,y:y,x2:x2,y2:y2,1r:x2-x,1y:y2-y}};6L.5S=1a(s){s=J.2v.5v();1n(K i=0,ii=J.1F.1e;i<ii;i++){s.1C(J.1F[i].5S())}1b s};6L.3r=1a(){1b"gC\\gD\\107 5v"};6L.bR=1a(DM){K 7Y=J.2v.5v();J.8G(1a(c7,1P){K g=c7.bR(DM);if(g!=1c){g.8G(1a(EP,105){7Y.1C(EP)})}});1b 7Y};6L.ge=1a(x,y){K ge=1j;J.8G(1a(el){if(el.ge(x,y)){ge=1o;1b 1j}});1b ge};R.103=1a(2K){if(!2K.8B){1b 2K}J.cR=J.cR||{};K gc={w:2K.w,8B:{},fp:{}},83=2K.8B["2K-83"];1n(K 6J in 2K.8B){if(2K.8B[3o](6J)){gc.8B[6J]=2K.8B[6J]}}if(J.cR[83]){J.cR[83].1C(gc)}1i{J.cR[83]=[gc]}if(!2K.43){gc.8B["zX-zY-em"]=9I(2K.8B["zX-zY-em"],10);1n(K nq in 2K.fp){if(2K.fp[3o](nq)){K 1G=2K.fp[nq];gc.fp[nq]={w:1G.w,k:{},d:1G.d&&"M"+1G.d.3f(/[104]/g,1a(8h){1b{l:"L",c:"C",x:"z",t:"m",r:"l",v:"c"}[8h]||"M"})+"z"};if(1G.k){1n(K k in 1G.k){if(1G[3o](k)){gc.fp[nq].k[k]=1G.k[k]}}}}}}1b 2K};62.EB=1a(83,9M,3b,od){od=od||"q8";3b=3b||"q8";9M=+9M||({q8:kB,YO:YN,YI:sC,YH:rL}[9M]||kB);if(!R.cR){1b}K 2K=R.cR[83];if(!2K){K 1z=1S dl("(^|\\\\s)"+83.3f(/[^\\w\\d\\s+!~.:1U-]/g,E)+"(\\\\s|$)","i");1n(K qc in R.cR){if(R.cR[3o](qc)){if(1z.9r(qc)){2K=R.cR[qc];1p}}}}K gy;if(2K){1n(K i=0,ii=2K.1e;i<ii;i++){gy=2K[i];if(gy.8B["2K-9M"]==9M&&((gy.8B["2K-3b"]==3b||!gy.8B["2K-3b"])&&gy.8B["2K-od"]==od)){1p}}}1b gy};62.YK=1a(x,y,4d,2K,54,fo,pZ,q4){fo=fo||"zj";pZ=4Q(5J(pZ||0,1),-1);q4=4Q(5J(q4||1,3),1);K jg=3Z(4d)[3p](E),bP=0,m8=0,1G=E,82;R.is(2K,"4d")&&(2K=J.EB(2K));if(2K){82=(54||16)/2K.8B["zX-zY-em"];K bb=2K.8B.2W[3p](5o),1O=+bb[0],q9=bb[3]-bb[1],zV=0,1y=+bb[1]+(fo=="YU"?q9+ +2K.8B.YT:q9/2);1n(K i=0,ii=jg.1e;i<ii;i++){if(jg[i]=="\\n"){bP=0;m6=0;m8=0;zV+=q9*q4}1i{K 3O=m8&&2K.fp[jg[i-1]]||{},m6=2K.fp[jg[i]];bP+=m8?(3O.w||2K.w)+(3O.k&&3O.k[jg[i]]||0)+2K.w*pZ:0;m8=1}if(m6&&m6.d){1G+=R.pY(m6.d,["t",bP*82,zV*82,"s",82,82,1O,1y,"t",(x-1O)/ 82, (y - 1y) /82])}}}1b J.1G(1G).1k({28:"#c8",1X:"3t"})};62.51=1a(ez){if(R.is(ez,"3K")){K 1A=J.5v(),i=0,ii=ez.1e,j;1n(;i<ii;i++){j=ez[i]||{};9C[3o](j.1w)&&1A.1C(J[j.1w]().1k(j))}}1b 1A};R.6s=1a(c3,1v){K 2e=R.is(1v,3K)?[0][3w](1v):2q;c3&&(R.is(c3,4d)&&(2e.1e-1&&(c3=c3.3f(Fd,1a(73,i){1b 2e[++i]==1c?E:2e[i]}))));1b c3||E};R.Yw=1a(){K Fj=/\\{([^\\}]+)\\}/g,F9=/(?:(?:^|\\.)(.+?)(?=\\[|\\.|$|\\()|\\[(\'|")(.+?)\\2\\])(\\(\\))?/g,Fh=1a(6k,1q,1u){K 1A=1u;1q.3f(F9,1a(6k,1z,Fa,Fe,Fi){1z=1z||Fe;if(1A){if(1z in 1A){1A=1A[1z]}2L 1A=="1a"&&(Fi&&(1A=1A()))}});1A=(1A==1c||1A==1u?6k:1A)+"";1b 1A};1b 1a(73,1u){1b 5h(73).3f(Fj,1a(6k,1q){1b Fh(6k,1q,1u)})}}();R.Yv=1a(){rv.wI?g.5l.bf=rv.is:41 bf;1b R};R.st=6L;(1a(2Y,9Z,f){if(2Y.n7==1c&&2Y.bi){2Y.bi(9Z,f=1a(){2Y.lj(9Z,f,1j);2Y.n7="Ls"},1j);2Y.n7="u8"}1a zZ(){/in/.9r(2Y.n7)?6y(zZ,9):R.2Q("46.iZ")}zZ()})(2N,"Ys");2Q.on("46.iZ",1a(){9Z=1o});(1a(){if(!R.43){1b}K 3o="7X",3Z=5h,3z=cZ,9I=6i,3y=3F,4Q=3y.4y,4c=3y.4c,5M=3y.5M,5o=/[, ]+/,2Q=R.2Q,E="",S=" ";K dA="6q://mX.w3.qj/Yr/dA",E6={6X:"M5,0 0,2.5 5,5z",mu:"M5,0 0,2.5 5,5 3.5,3 3.5,2z",pu:"M2.5,0 5,2.5 2.5,5 0,2.5z",6K:"M6,1 1,3.5 6,6",pr:"M2.5,YA.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,Yz"},bt={};R.3r=1a(){1b"NH qF YC c4.\\Nx pl zb gC\\gD "+J.5N};K $=1a(el,1k){if(1k){if(2L el=="4d"){el=$(el)}1n(K 1q in 1k){if(1k[3o](1q)){if(1q.fJ(0,6)=="dA:"){el.mU(dA,1q.fJ(6),3Z(1k[1q]))}1i{el.aL(1q,3Z(1k[1q]))}}}}1i{el=R.7y.2Y.YB("6q://mX.w3.qj/ML/43",el);el.3b&&(el.3b.Zi="yU(0,0,0,0)")}1b el},o8=1a(1f,3Q){K 1w="nS",id=1f.id+3Q,fx=0.5,fy=0.5,o=1f.1s,c4=1f.2v,s=o.3b,el=R.7y.2Y.dT(id);if(!el){3Q=3Z(3Q).3f(R.uC,1a(6k,yV,yW){1w="pO";if(yV&&yW){fx=3z(yV);fy=3z(yW);K yR=(fy>0.5)*2-1;5M(fx-0.5,2)+5M(fy-0.5,2)>0.25&&((fy=3y.9v(0.25-5M(fx-0.5,2))*yR+0.5)&&(fy!=0.5&&(fy=fy.4r(5)-1E-5*yR)))}1b E});3Q=3Q.3p(/\\s*\\-\\s*/);if(1w=="nS"){K 7l=3Q.bP();7l=-3z(7l);if(aE(7l)){1b 1c}K 8v=[0,0,3y.8I(R.8D(7l)),3y.8r(R.8D(7l))],4y=1/(4Q(4c(8v[2]),4c(8v[3]))||1);8v[2]*=4y;8v[3]*=4y;if(8v[2]<0){8v[0]=-8v[2];8v[2]=0}if(8v[3]<0){8v[1]=-8v[3];8v[3]=0}}K 57=R.uJ(3Q);if(!57){1b 1c}id=id.3f(/[\\(\\)\\s,\\z0#]/g,"1U");if(1f.3Q&&id!=1f.3Q.id){c4.d0.7g(1f.3Q);41 1f.3Q}if(!1f.3Q){el=$(1w+"Ze",{id:id});1f.3Q=el;$(el,1w=="pO"?{fx:fx,fy:fy}:{x1:8v[0],y1:8v[1],x2:8v[2],y2:8v[3],Zg:1f.4w.n4()});c4.d0.3E(el);1n(K i=0,ii=57.1e;i<ii;i++){el.3E($("5D",{2y:57[i].2y?57[i].2y:i?"100%":"0%","5D-3s":57[i].3s||"#jI"}))}}}$(o,{28:"5b(#"+id+")",2I:1,"28-2I":1});s.28=E;s.2I=1;s.Zf=1;1b 1},n8=1a(o){K 2W=o.6v(1);$(o.cp,{Zq:o.4w.n4()+" fk("+2W.x+","+2W.y+")"})},bu=1a(o,1m,ei){if(o.1w=="1G"){K 2H=3Z(1m).3R().3p("-"),p=o.2v,se=ei?"4x":"2J",1s=o.1s,2b=o.2b,1X=2b["1X-1r"],i=2H.1e,1w="mu",2s,to,dx,mO,1k,w=3,h=3,t=5;44(i--){3q(2H[i]){1l"6X":;1l"mu":;1l"pr":;1l"pu":;1l"6K":;1l"3t":1w=2H[i];1p;1l"MW":h=5;1p;1l"MX":h=2;1p;1l"MB":w=5;1p;1l"MA":w=2;1p}}if(1w=="6K"){w+=2;h+=2;t+=2;dx=1;mO=ei?4:1;1k={28:"3t",1X:2b.1X}}1i{mO=dx=w/2;1k={28:2b.1X,1X:"3t"}}if(o.1U.4B){if(ei){o.1U.4B.E8&&bt[o.1U.4B.E8]--;o.1U.4B.E9&&bt[o.1U.4B.E9]--}1i{o.1U.4B.E7&&bt[o.1U.4B.E7]--;o.1U.4B.E5&&bt[o.1U.4B.E5]--}}1i{o.1U.4B={}}if(1w!="3t"){K gg="46-db-"+1w,gl="46-db-"+se+1w+w+h;if(!R.7y.2Y.dT(gg)){p.d0.3E($($("1G"),{"1X-cH":"4I",d:E6[1w],id:gg}));bt[gg]=1}1i{bt[gg]++}K db=R.7y.2Y.dT(gl),gr;if(!db){db=$($("db"),{id:gl,Zp:h,Zs:w,Zr:"6p",mO:mO,Zm:h/2});gr=$($("gr"),{"dA:5d":"#"+gg,3A:(ei?"5p(cC "+w/ 2 + " " + h /2+") ":E)+"82("+w/ t + "," + h /t+")","1X-1r":(1/ ((w /t+h/ t) /2)).4r(4)});db.3E(gr);p.d0.3E(db);bt[gl]=1}1i{bt[gl]++;gr=db.bY("gr")[0]}$(gr,1k);K qo=dx*(1w!="pu"&&1w!="pr");if(ei){2s=o.1U.4B.DU*1X||0;to=R.bC(2b.1G)-qo*1X}1i{2s=qo*1X;to=R.bC(2b.1G)-(o.1U.4B.Eq*1X||0)}1k={};1k["db-"+se]="5b(#"+gl+")";if(to||2s){1k.d=R.mN(2b.1G,2s,to)}$(1s,1k);o.1U.4B[se+"kL"]=gg;o.1U.4B[se+"Ep"]=gl;o.1U.4B[se+"dx"]=qo;o.1U.4B[se+"4A"]=1w;o.1U.4B[se+"5h"]=1m}1i{if(ei){2s=o.1U.4B.DU*1X||0;to=R.bC(2b.1G)-2s}1i{2s=0;to=R.bC(2b.1G)-(o.1U.4B.Eq*1X||0)}o.1U.4B[se+"kL"]&&$(1s,{d:R.mN(2b.1G,2s,to)});41 o.1U.4B[se+"kL"];41 o.1U.4B[se+"Ep"];41 o.1U.4B[se+"dx"];41 o.1U.4B[se+"4A"];41 o.1U.4B[se+"5h"]}1n(1k in bt){if(bt[3o](1k)&&!bt[1k]){K 1g=R.7y.2Y.dT(1k);1g&&1g.3n.7g(1g)}}}},91={"":[0],"3t":[0],"-":[3,1],".":[1,1],"-.":[3,1,1,1],"-..":[3,1,1,1,1,1],". ":[1,3],"- ":[4,3],"--":[8,3],"- .":[4,3,1,3],"--.":[8,3,1,3],"--..":[8,3,1,3,1,3]},yO=1a(o,1m,1v){1m=91[3Z(1m).3R()];if(1m){K 1r=o.2b["1X-1r"]||"1",iq={4I:1r,uP:1r,iq:0}[o.2b["1X-cH"]||1v["1X-cH"]]||0,yI=[],i=1m.1e;44(i--){yI[i]=1m[i]*1r+(i%2?1:-1)*iq}$(o.1s,{"1X-91":yI.4H(",")})}},dB=1a(o,1v){K 1s=o.1s,2b=o.2b,Eg=1s.3b.gG;1s.3b.gG="70";1n(K 6z in 1v){if(1v[3o](6z)){if(!R.j1[3o](6z)){ag}K 1m=1v[6z];2b[6z]=1m;3q(6z){1l"4P":o.4P(1m);1p;1l"66":K 66=1s.bY("66");if(66.1e&&(66=66[0])){66.7A.Eo=1m}1i{66=$("66");K 2h=R.7y.2Y.zn(1m);66.3E(2h);1s.3E(66)}1p;1l"5d":;1l"3m":K pn=1s.3n;if(pn.68.3R()!="a"){K hl=$("a");pn.76(hl,1s);hl.3E(1s);pn=hl}if(6z=="3m"){pn.mU(dA,"5e",1m=="yE"?"1S":1m)}1i{pn.mU(dA,6z,1m)}1p;1l"hO":1s.3b.hO=1m;1p;1l"3A":o.3A(1m);1p;1l"b0-2J":bu(o,1m);1p;1l"b0-4x":bu(o,1m,1);1p;1l"5Z-4l":K 4l=3Z(1m).3p(5o);if(4l.1e==4){o.5Z&&o.5Z.3n.3n.7g(o.5Z.3n);K el=$("Z2"),rc=$("4l");el.id=R.n6();$(rc,{x:4l[0],y:4l[1],1r:4l[2],1y:4l[3]});el.3E(rc);o.2v.d0.3E(el);$(1s,{"5Z-1G":"5b(#"+el.id+")"});o.5Z=rc}if(!1m){K 1G=1s.yK("5Z-1G");if(1G){K 5Z=R.7y.2Y.dT(1G.3f(/(^5b\\(#|\\)$)/g,E));5Z&&5Z.3n.7g(5Z);$(1s,{"5Z-1G":E});41 o.5Z}}1p;1l"1G":if(o.1w=="1G"){$(1s,{d:1m?2b.1G=R.mg(1m):"M0,0"});o.1U.7M=1;if(o.1U.4B){"jQ"in o.1U.4B&&bu(o,o.1U.4B.jQ);"jJ"in o.1U.4B&&bu(o,o.1U.4B.jJ,1)}}1p;1l"1r":1s.aL(6z,1m);o.1U.7M=1;if(2b.fx){6z="x";1m=2b.x}1i{1p};1l"x":if(2b.fx){1m=-2b.x-(2b.1r||0)};1l"rx":if(6z=="rx"&&o.1w=="4l"){1p};1l"cx":1s.aL(6z,1m);o.cp&&n8(o);o.1U.7M=1;1p;1l"1y":1s.aL(6z,1m);o.1U.7M=1;if(2b.fy){6z="y";1m=2b.y}1i{1p};1l"y":if(2b.fy){1m=-2b.y-(2b.1y||0)};1l"ry":if(6z=="ry"&&o.1w=="4l"){1p};1l"cy":1s.aL(6z,1m);o.cp&&n8(o);o.1U.7M=1;1p;1l"r":if(o.1w=="4l"){$(1s,{rx:1m,ry:1m})}1i{1s.aL(6z,1m)}o.1U.7M=1;1p;1l"4a":if(o.1w=="8R"){1s.mU(dA,"5d",1m)}1p;1l"1X-1r":if(o.1U.sx!=1||o.1U.sy!=1){1m/=4Q(4c(o.1U.sx),4c(o.1U.sy))||1}if(o.2v.mV){1m*=o.2v.mV}1s.aL(6z,1m);if(2b["1X-91"]){yO(o,2b["1X-91"],1v)}if(o.1U.4B){"jQ"in o.1U.4B&&bu(o,o.1U.4B.jQ);"jJ"in o.1U.4B&&bu(o,o.1U.4B.jJ,1)}1p;1l"1X-91":yO(o,1m,1v);1p;1l"28":K eV=3Z(1m).3e(R.v4);if(eV){el=$("cp");K ig=$("8R");el.id=R.n6();$(el,{x:0,y:0,YY:"YX",1y:1,1r:1});$(ig,{x:0,y:0,"dA:5d":eV[1]});el.3E(ig);(1a(el){R.v5(eV[1],1a(){K w=J.fC,h=J.bj;$(el,{1r:w,1y:h});$(ig,{1r:w,1y:h});o.2v.jo()})})(el);o.2v.d0.3E(el);$(1s,{28:"5b(#"+el.id+")"});o.cp=el;o.cp&&n8(o);1p}K 3v=R.b5(1m);if(!3v.96){41 1v.3Q;41 2b.3Q;!R.is(2b.2I,"2O")&&(R.is(1v.2I,"2O")&&$(1s,{2I:2b.2I}));!R.is(2b["28-2I"],"2O")&&(R.is(1v["28-2I"],"2O")&&$(1s,{"28-2I":2b["28-2I"]}))}1i{if((o.1w=="9i"||(o.1w=="a0"||3Z(1m).b6()!="r"))&&o8(o,1m)){if("2I"in 2b||"28-2I"in 2b){K 3Q=R.7y.2Y.dT(1s.yK("28").3f(/^5b\\(#|\\)$/g,E));if(3Q){K jL=3Q.bY("5D");$(jL[jL.1e-1],{"5D-2I":("2I"in 2b?2b.2I:1)*("28-2I"in 2b?2b["28-2I"]:1)})}}2b.3Q=1m;2b.28="3t";1p}}3v[3o]("2I")&&$(1s,{"28-2I":3v.2I>1?3v.2I/100:3v.2I});1l"1X":3v=R.b5(1m);1s.aL(6z,3v.6f);6z=="1X"&&(3v[3o]("2I")&&$(1s,{"1X-2I":3v.2I>1?3v.2I/100:3v.2I}));if(6z=="1X"&&o.1U.4B){"jQ"in o.1U.4B&&bu(o,o.1U.4B.jQ);"jJ"in o.1U.4B&&bu(o,o.1U.4B.jJ,1)}1p;1l"3Q":(o.1w=="9i"||(o.1w=="a0"||3Z(1m).b6()!="r"))&&o8(o,1m);1p;1l"2I":if(2b.3Q&&!2b[3o]("1X-2I")){$(1s,{"1X-2I":1m>1?1m/100:1m})};1l"28-2I":if(2b.3Q){3Q=R.7y.2Y.dT(1s.yK("28").3f(/^5b\\(#|\\)$/g,E));if(3Q){jL=3Q.bY("5D");$(jL[jL.1e-1],{"5D-2I":1m})}1p};5n:6z=="2K-54"&&(1m=9I(1m,10)+"px");K Eb=6z.3f(/(\\-.)/g,1a(w){1b w.fJ(1).8u()});1s.3b[Eb]=1m;o.1U.7M=1;1s.aL(6z,1m);1p}}}Ek(o,1v);1s.3b.gG=Eg},zk=1.2,Ek=1a(el,1v){if(el.1w!="1Y"||!(1v[3o]("1Y")||(1v[3o]("2K")||(1v[3o]("2K-54")||(1v[3o]("x")||1v[3o]("y")))))){1b}K a=el.2b,1s=el.1s,cX=1s.7A?9I(R.7y.2Y.km.qv(1s.7A,E).El("2K-54"),10):10;if(1v[3o]("1Y")){a.1Y=1v.1Y;44(1s.7A){1s.7g(1s.7A)}K yM=3Z(1v.1Y).3p("\\n"),gf=[],fL;1n(K i=0,ii=yM.1e;i<ii;i++){fL=$("fL");i&&$(fL,{dy:cX*zk,x:a.x});fL.3E(R.7y.2Y.zn(yM[i]));1s.3E(fL);gf[i]=fL}}1i{gf=1s.bY("fL");1n(i=0,ii=gf.1e;i<ii;i++){if(i){$(gf[i],{dy:cX*zk,x:a.x})}1i{$(gf[0],{dy:0})}}}$(1s,{x:a.x,y:a.y});el.1U.7M=1;K bb=el.nm(),qr=a.y-(bb.y+bb.1y/2);qr&&(R.is(qr,"mC")&&$(gf[0],{dy:qr}))},9T=1a(1s,43){K X=0,Y=0;J[0]=J.1s=1s;1s.46=1o;J.id=R.ve++;1s.va=J.id;J.4w=R.4w();J.fF=1c;J.2v=43;J.2b=J.2b||{};J.1U={3A:[],sx:1,sy:1,4n:0,dx:0,dy:0,7M:1};!43.4G&&(43.4G=J);J.3O=43.1O;43.1O&&(43.1O.3k=J);43.1O=J;J.3k=1c},3c=R.el;9T.2S=3c;3c.4V=9T;R.4C.1G=1a(8j,c4){K el=$("1G");c4.1V&&c4.1V.3E(el);K p=1S 9T(el,c4);p.1w="1G";dB(p,{28:"3t",1X:"#c8",1G:8j});1b p};3c.5p=1a(4n,cx,cy){if(J.5c){1b J}4n=3Z(4n).3p(5o);if(4n.1e-1){cx=3z(4n[1]);cy=3z(4n[2])}4n=3z(4n[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2W=J.6v(1);cx=2W.x+2W.1r/2;cy=2W.y+2W.1y/2}J.3A(J.1U.3A.3w([["r",4n,cx,cy]]));1b J};3c.82=1a(sx,sy,cx,cy){if(J.5c){1b J}sx=3Z(sx).3p(5o);if(sx.1e-1){sy=3z(sx[1]);cx=3z(sx[2]);cy=3z(sx[3])}sx=3z(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2W=J.6v(1)}cx=cx==1c?2W.x+2W.1r/2:cx;cy=cy==1c?2W.y+2W.1y/2:cy;J.3A(J.1U.3A.3w([["s",sx,sy,cx,cy]]));1b J};3c.fk=1a(dx,dy){if(J.5c){1b J}dx=3Z(dx).3p(5o);if(dx.1e-1){dy=3z(dx[1])}dx=3z(dx[0])||0;dy=+dy||0;J.3A(J.1U.3A.3w([["t",dx,dy]]));1b J};3c.3A=1a(aA){K 1U=J.1U;if(aA==1c){1b 1U.3A}R.uO(J,aA);J.5Z&&$(J.5Z,{3A:J.4w.n4()});J.cp&&n8(J);J.1s&&$(J.1s,{3A:J.4w});if(1U.sx!=1||1U.sy!=1){K sw=J.2b[3o]("1X-1r")?J.2b["1X-1r"]:1;J.1k({"1X-1r":sw})}1b J};3c.3J=1a(){!J.5c&&J.2v.jo(J.1s.3b.5q="3t");1b J};3c.5e=1a(){!J.5c&&J.2v.jo(J.1s.3b.5q="");1b J};3c.3u=1a(){if(J.5c||!J.1s.3n){1b}K 2v=J.2v;2v.6I&&2v.6I.uZ(J);2Q.7V("46.*.*."+J.id);if(J.3Q){2v.d0.7g(J.3Q)}R.v9(J,2v);if(J.1s.3n.68.3R()=="a"){J.1s.3n.3n.7g(J.1s.3n)}1i{J.1s.3n.7g(J.1s)}1n(K i in J){J[i]=2L J[i]=="1a"?R.kq(i):1c}J.5c=1o};3c.nm=1a(){if(J.1s.3b.5q=="3t"){J.5e();K 3J=1o}K 2W={};7D{2W=J.1s.6v()}7C(e){}Z6{2W=2W||{}}3J&&J.3J();1b 2W};3c.1k=1a(1z,1m){if(J.5c){1b J}if(1z==1c){K 1A={};1n(K a in J.2b){if(J.2b[3o](a)){1A[a]=J.2b[a]}}1A.3Q&&(1A.28=="3t"&&((1A.28=1A.3Q)&&41 1A.3Q));1A.3A=J.1U.3A;1b 1A}if(1m==1c&&R.is(1z,"4d")){if(1z=="28"&&(J.2b.28=="3t"&&J.2b.3Q)){1b J.2b.3Q}if(1z=="3A"){1b J.1U.3A}K 7e=1z.3p(5o),2m={};1n(K i=0,ii=7e.1e;i<ii;i++){1z=7e[i];if(1z in J.2b){2m[1z]=J.2b[1z]}1i{if(R.is(J.2v.8P[1z],"1a")){2m[1z]=J.2v.8P[1z].Jx}1i{2m[1z]=R.j1[1z]}}}1b ii-1?2m:2m[7e[0]]}if(1m==1c&&R.is(1z,"3K")){2m={};1n(i=0,ii=1z.1e;i<ii;i++){2m[1z[i]]=J.1k(1z[i])}1b 2m}if(1m!=1c){K 1v={};1v[1z]=1m}1i{if(1z!=1c&&R.is(1z,"1D")){1v=1z}}1n(K 1q in 1v){2Q("46.1k."+1q+"."+J.id,J,1v[1q])}1n(1q in J.2v.8P){if(J.2v.8P[3o](1q)&&(1v[3o](1q)&&R.is(J.2v.8P[1q],"1a"))){K 8C=J.2v.8P[1q].3d(J,[].3w(1v[1q]));J.2b[1q]=1v[1q];1n(K bc in 8C){if(8C[3o](bc)){1v[bc]=8C[bc]}}}}dB(J,1v);1b J};3c.Jv=1a(){if(J.5c){1b J}if(J.1s.3n.68.3R()=="a"){J.1s.3n.3n.3E(J.1s.3n)}1i{J.1s.3n.3E(J.1s)}K 43=J.2v;43.1O!=J&&R.us(J,43);1b J};3c.Jw=1a(){if(J.5c){1b J}K 1L=J.1s.3n;if(1L.68.3R()=="a"){1L.3n.76(J.1s.3n,J.1s.3n.3n.7A)}1i{if(1L.7A!=J.1s){1L.76(J.1s,J.1s.3n.7A)}}R.uG(J,J.2v);K 43=J.2v;1b J};3c.e7=1a(1f){if(J.5c){1b J}K 1s=1f.1s||1f[1f.1e-1].1s;if(1s.iN){1s.3n.76(J.1s,1s.iN)}1i{1s.3n.3E(J.1s)}R.uv(J,1f,J.2v);1b J};3c.76=1a(1f){if(J.5c){1b J}K 1s=1f.1s||1f[0].1s;1s.3n.76(J.1s,1s);R.uy(J,1f,J.2v);1b J};3c.4P=1a(54){K t=J;if(+54!==0){K jS=$("4s"),4P=$("Z5");t.2b.4P=54;jS.id=R.n6();$(4P,{Wq:+54||1.5});jS.3E(4P);t.2v.d0.3E(jS);t.mT=jS;$(t.1s,{4s:"5b(#"+jS.id+")"})}1i{if(t.mT){t.mT.3n.7g(t.mT);41 t.mT;41 t.2b.4P}t.1s.Tt("4s")}1b t};R.4C.9i=1a(43,x,y,r){K el=$("9i");43.1V&&43.1V.3E(el);K 1A=1S 9T(el,43);1A.2b={cx:x,cy:y,r:r,28:"3t",1X:"#c8"};1A.1w="9i";$(el,1A.2b);1b 1A};R.4C.4l=1a(43,x,y,w,h,r){K el=$("4l");43.1V&&43.1V.3E(el);K 1A=1S 9T(el,43);1A.2b={x:x,y:y,1r:w,1y:h,r:r||0,rx:r||0,ry:r||0,28:"3t",1X:"#c8"};1A.1w="4l";$(el,1A.2b);1b 1A};R.4C.a0=1a(43,x,y,rx,ry){K el=$("a0");43.1V&&43.1V.3E(el);K 1A=1S 9T(el,43);1A.2b={cx:x,cy:y,rx:rx,ry:ry,28:"3t",1X:"#c8"};1A.1w="a0";$(el,1A.2b);1b 1A};R.4C.8R=1a(43,4a,x,y,w,h){K el=$("8R");$(el,{x:x,y:y,1r:w,1y:h,ME:"3t"});el.mU(dA,"5d",4a);43.1V&&43.1V.3E(el);K 1A=1S 9T(el,43);1A.2b={x:x,y:y,1r:w,1y:h,4a:4a};1A.1w="8R";1b 1A};R.4C.1Y=1a(43,x,y,1Y){K el=$("1Y");43.1V&&43.1V.3E(el);K 1A=1S 9T(el,43);1A.2b={x:x,y:y,"1Y-uB":"zj",1Y:1Y,2K:R.j1.2K,1X:"3t",28:"#c8"};1A.1w="1Y";dB(1A,1A.2b);1b 1A};R.4C.hR=1a(1r,1y){J.1r=1r||J.1r;J.1y=1y||J.1y;J.1V.aL("1r",J.1r);J.1V.aL("1y",J.1y);if(J.f4){J.fc.3d(J,J.f4)}1b J};R.4C.7K=1a(){K aN=R.w4.3d(0,2q),4b=aN&&aN.4b,x=aN.x,y=aN.y,1r=aN.1r,1y=aN.1y;if(!4b){9K 1S 9h("c4 4b 5L 8K.")}K aI=$("43"),2Z="gh:70;",zs;x=x||0;y=y||0;1r=1r||IR;1y=1y||Iy;$(aI,{1y:1y,5N:1.1,1r:1r,IN:"6q://mX.w3.qj/ML/43"});if(4b==1){aI.3b.fl=2Z+"2G:8x;2a:"+x+"px;1O:"+y+"px";R.7y.2Y.3U.3E(aI);zs=1}1i{aI.3b.fl=2Z+"2G:ob";if(4b.7A){4b.76(aI,4b.7A)}1i{4b.3E(aI)}}4b=1S R.w5;4b.1r=1r;4b.1y=1y;4b.1V=aI;4b.af();4b.pB=4b.pA=0;zs&&(4b.r2=1a(){});4b.r2();1b 4b};R.4C.fc=1a(x,y,w,h,al){2Q("46.fc",J,J.f4,[x,y,w,h,al]);K 54=4Q(w/ J.1r, h /J.1y),1O=J.1O,MF=al?"Tv":"Tu",vb,sw;if(x==1c){if(J.mV){54=1}41 J.mV;vb="0 0 "+J.1r+S+J.1y}1i{J.mV=54;vb=x+S+y+S+w+S+h}$(J.1V,{Tp:vb,ME:MF});44(54&&1O){sw="1X-1r"in 1O.2b?1O.2b["1X-1r"]:1;1O.1k({"1X-1r":sw});1O.1U.7M=1;1O.1U.f5=1;1O=1O.3O}J.f4=[x,y,w,h,!!al];1b J};R.2S.r2=1a(){K aI=J.1V,s=aI.3b,3V;7D{3V=aI.Tr()||aI.Md()}7C(e){3V=aI.Md()}K 2a=-3V.e%1,1O=-3V.f%1;if(2a||1O){if(2a){J.pB=(J.pB+2a)%1;s.2a=J.pB+"px"}if(1O){J.pA=(J.pA+1O)%1;s.1O=J.pA+"px"}}};R.2S.af=1a(){R.2Q("46.af",J);K c=J.1V;44(c.7A){c.7g(c.7A)}J.4G=J.1O=1c;(J.zo=$("zo")).3E(R.7y.2Y.zn("TA fY gC\\gD "+R.5N));c.3E(J.zo);c.3E(J.d0=$("d0"))};R.2S.3u=1a(){2Q("46.3u",J);J.1V.3n&&J.1V.3n.7g(J.1V);1n(K i in J){J[i]=2L J[i]=="1a"?R.kq(i):1c}};K 6L=R.st;1n(K 45 in 3c){if(3c[3o](45)&&!6L[3o](45)){6L[45]=1a(ec){1b 1a(){K 4i=2q;1b J.8G(1a(el){el[ec].3d(el,4i)})}}(45)}}})();(1a(){if(!R.5H){1b}K 3o="7X",3Z=5h,3z=cZ,3y=3F,4I=3y.4I,4Q=3y.4y,5J=3y.5U,4c=3y.4c,g6="28",5o=/[, ]+/,2Q=R.2Q,ms=" z7:Nr.zg",S=" ",E="",eO={M:"m",L:"l",C:"c",Z:"x",m:"t",l:"r",c:"v",z:"x"},Nv=/([z9]),?([^z9]*)/gi,K5=/ z7:\\S+K6\\([^\\)]+\\)/g,2h=/-?[^,\\s-]+/g,wr="2G:8x;2a:0;1O:0;1r:k5;1y:k5",6w=Tx,Nk={1G:1,4l:1,8R:1},Nm={9i:1,a0:1},Mn=1a(1G){K pD=/[Tw]/ig,8h=R.mg;3Z(1G).3e(pD)&&(8h=R.pE);pD=/[z9]/g;if(8h==R.mg&&!3Z(1G).3e(pD)){K 1A=3Z(1G).3f(Nv,1a(6k,8h,2e){K hZ=[],Nt=8h.3R()=="m",1A=eO[8h];2e.3f(2h,1a(1m){if(Nt&&hZ.1e==2){1A+=hZ+eO[8h=="m"?"l":"L"];hZ=[]}hZ.1C(4I(1m*6w))});1b 1A+hZ});1b 1A}K pa=8h(1G),p,r;1A=[];1n(K i=0,ii=pa.1e;i<ii;i++){p=pa[i];r=pa[i][0].3R();r=="z"&&(r="x");1n(K j=1,jj=p.1e;j<jj;j++){r+=4I(p[j]*6w)+(j!=jj-1?",":E)}1A.1C(r)}1b 1A.4H(S)},ze=1a(4n,dx,dy){K m=R.4w();m.5p(-4n,0.5,0.5);1b{dx:m.x(dx,dy),dy:m.y(dx,dy)}},nK=1a(p,sx,sy,dx,dy,4n){K 1U=p.1U,m=p.4w,cm=1U.cm,o=p.1s,s=o.3b,y=1,i4="",Td,kx=6w/ sx, ky = 6w /sy;s.gG="70";if(!sx||!sy){1b}o.r8=4c(kx)+S+4c(ky);s.T8=4n*(sx*sy<0?-1:1);if(4n){K c=ze(4n,dx,dy);dx=c.dx;dy=c.dy}sx<0&&(i4+="x");sy<0&&((i4+=" y")&&(y=-1));s.i4=i4;o.hP=dx*-kx+S+dy*-ky;if(cm||1U.g4){K 28=o.bY(g6);28=28&&28[0];o.7g(28);if(cm){c=ze(4n,m.x(cm[0],cm[1]),m.y(cm[0],cm[1]));28.2G=c.dx*y+S+c.dy*y}if(1U.g4){28.54=1U.g4[0]*4c(sx)+S+1U.g4[1]*4c(sy)}o.3E(28)}s.gG="6H"};R.3r=1a(){1b"NH qF T9\\Tk cn c4. Tl cT to g9.\\Nx pl zb gC\\gD "+J.5N};K bu=1a(o,1m,ei){K 2H=3Z(1m).3R().3p("-"),se=ei?"4x":"2J",i=2H.1e,1w="mu",w="M8",h="M8";44(i--){3q(2H[i]){1l"6X":;1l"mu":;1l"pr":;1l"pu":;1l"6K":;1l"3t":1w=2H[i];1p;1l"MW":;1l"MX":h=2H[i];1p;1l"MB":;1l"MA":w=2H[i];1p}}K 1X=o.1s.bY("1X")[0];1X[se+"b0"]=1w;1X[se+"U5"]=w;1X[se+"U4"]=h},dB=1a(o,1v){o.2b=o.2b||{};K 1s=o.1s,a=o.2b,s=1s.3b,xy,uq=Nk[o.1w]&&(1v.x!=a.x||(1v.y!=a.y||(1v.1r!=a.1r||(1v.1y!=a.1y||(1v.cx!=a.cx||(1v.cy!=a.cy||(1v.rx!=a.rx||(1v.ry!=a.ry||1v.r!=a.r)))))))),MC=Nm[o.1w]&&(a.cx!=1v.cx||(a.cy!=1v.cy||(a.r!=1v.r||(a.rx!=1v.rx||a.ry!=1v.ry)))),1A=o;1n(K 8C in 1v){if(1v[3o](8C)){a[8C]=1v[8C]}}if(uq){a.1G=R.uh[o.1w](o);o.1U.7M=1}1v.5d&&(1s.5d=1v.5d);1v.66&&(1s.66=1v.66);1v.3m&&(1s.3m=1v.3m);1v.hO&&(s.hO=1v.hO);"4P"in 1v&&o.4P(1v.4P);if(1v.1G&&o.1w=="1G"||uq){1s.1G=Mn(~3Z(a.1G).3R().4Y("r")?R.mg(a.1G):a.1G);if(o.1w=="8R"){o.1U.cm=[a.x,a.y];o.1U.g4=[a.1r,a.1y];nK(o,1,1,0,0,0)}}"3A"in 1v&&o.3A(1v.3A);if(MC){K cx=+a.cx,cy=+a.cy,rx=+a.rx||(+a.r||0),ry=+a.ry||(+a.r||0);1s.1G=R.6s("ar{0},{1},{2},{3},{4},{1},{4},{1}x",4I((cx-rx)*6w),4I((cy-ry)*6w),4I((cx+rx)*6w),4I((cy+ry)*6w),4I(cx*6w));o.1U.7M=1}if("5Z-4l"in 1v){K 4l=3Z(1v["5Z-4l"]).3p(5o);if(4l.1e==4){4l[2]=+4l[2]+ +4l[0];4l[3]=+4l[3]+ +4l[1];K 2F=1s.md||R.7y.2Y.cb("2F"),gn=2F.3b;gn.5Z=R.6s("4l({1}px {2}px {3}px {0}px)",4l);if(!1s.md){gn.2G="8x";gn.1O=0;gn.2a=0;gn.1r=o.2v.1r+"px";gn.1y=o.2v.1y+"px";1s.3n.76(2F,1s);2F.3E(1s);1s.md=2F}}if(!1v["5Z-4l"]){1s.md&&(1s.md.3b.5Z="6p")}}if(o.c9){K hU=o.c9.3b;1v.2K&&(hU.2K=1v.2K);1v["2K-83"]&&(hU.Mh=\'"\'+1v["2K-83"].3p(",")[0].3f(/^[\'"]+|[\'"]+$/g,E)+\'"\');1v["2K-54"]&&(hU.cX=1v["2K-54"]);1v["2K-9M"]&&(hU.Mk=1v["2K-9M"]);1v["2K-3b"]&&(hU.Ml=1v["2K-3b"])}if("b0-2J"in 1v){bu(1A,1v["b0-2J"])}if("b0-4x"in 1v){bu(1A,1v["b0-4x"],1)}if(1v.2I!=1c||(1v["1X-1r"]!=1c||(1v.28!=1c||(1v.4a!=1c||(1v.1X!=1c||(1v["1X-1r"]!=1c||(1v["1X-2I"]!=1c||(1v["28-2I"]!=1c||(1v["1X-91"]!=1c||(1v["1X-o3"]!=1c||(1v["1X-gj"]!=1c||1v["1X-cH"]!=1c))))))))))){K 28=1s.bY(g6),MJ=1j;28=28&&28[0];!28&&(MJ=28=cz(g6));if(o.1w=="8R"&&1v.4a){28.4a=1v.4a}1v.28&&(28.on=1o);if(28.on==1c||(1v.28=="3t"||1v.28===1c)){28.on=1j}if(28.on&&1v.28){K eV=3Z(1v.28).3e(R.v4);if(eV){28.3n==1s&&1s.7g(28);28.5p=1o;28.4a=eV[1];28.1w="Kb";K 2W=o.6v(1);28.2G=2W.x+S+2W.y;o.1U.cm=[2W.x,2W.y];R.v5(eV[1],1a(){o.1U.g4=[J.fC,J.bj]})}1i{28.3s=R.b5(1v.28).6f;28.4a=E;28.1w="mi";if(R.b5(1v.28).96&&((1A.1w in{9i:1,a0:1}||3Z(1v.28).b6()!="r")&&o8(1A,1v.28,28))){a.28="3t";a.3Q=1v.28;28.5p=1j}}}if("28-2I"in 1v||"2I"in 1v){K 2I=((+a["28-2I"]+1||2)-1)*((+a.2I+1||2)-1)*((+R.b5(1v.28).o+1||2)-1);2I=5J(4Q(2I,0),1);28.2I=2I;if(28.4a){28.3s="3t"}}1s.3E(28);K 1X=1s.bY("1X")&&1s.bY("1X")[0],uM=1j;!1X&&(uM=1X=cz("1X"));if(1v.1X&&1v.1X!="3t"||(1v["1X-1r"]||(1v["1X-2I"]!=1c||(1v["1X-91"]||(1v["1X-o3"]||(1v["1X-gj"]||1v["1X-cH"])))))){1X.on=1o}(1v.1X=="3t"||(1v.1X===1c||(1X.on==1c||(1v.1X==0||1v["1X-1r"]==0))))&&(1X.on=1j);K v2=R.b5(1v.1X);1X.on&&(1v.1X&&(1X.3s=v2.6f));2I=((+a["1X-2I"]+1||2)-1)*((+a.2I+1||2)-1)*((+v2.o+1||2)-1);K 1r=(3z(1v["1X-1r"])||1)*0.75;2I=5J(4Q(2I,0),1);1v["1X-1r"]==1c&&(1r=a["1X-1r"]);1v["1X-1r"]&&(1X.9M=1r);1r&&(1r<1&&((2I*=1r)&&(1X.9M=1)));1X.2I=2I;1v["1X-gj"]&&(1X.U6=1v["1X-gj"]||"U9");1X.o3=1v["1X-o3"]||8;1v["1X-cH"]&&(1X.U8=1v["1X-cH"]=="iq"?"TL":1v["1X-cH"]=="uP"?"uP":"4I");if("1X-91"in 1v){K 91={"-":"TK",".":"TN","-.":"TM","-..":"TH",". ":"6N","- ":"TG","--":"TJ","- .":"TI","--.":"TU","--..":"TT"};1X.TW=91[3o](1v["1X-91"])?91[1v["1X-91"]]:E}uM&&1s.3E(1X)}if(1A.1w=="1Y"){1A.2v.1V.3b.5q=E;K 2E=1A.2v.2E,m=100,cX=a.2K&&a.2K.3e(/\\d+(?:\\.\\d*)?(?=px)/);s=2E.3b;a.2K&&(s.2K=a.2K);a["2K-83"]&&(s.Mh=a["2K-83"]);a["2K-9M"]&&(s.Mk=a["2K-9M"]);a["2K-3b"]&&(s.Ml=a["2K-3b"]);cX=3z(a["2K-54"]||cX&&cX[0])||10;s.cX=cX*m+"px";1A.c9.4d&&(2E.mQ=3Z(1A.c9.4d).3f(/</g,"&#60;").3f(/&/g,"&#38;").3f(/\\n/g,"<br>"));K o7=2E.vj();1A.W=a.w=(o7.7S-o7.2a)/m;1A.H=a.h=(o7.4G-o7.1O)/m;1A.X=a.x;1A.Y=a.y+1A.H/2;("x"in 1v||"y"in 1v)&&(1A.1G.v=R.6s("m{0},{1}l{2},{1}",4I(a.x*6w),4I(a.y*6w),4I(a.x*6w)+1));K uD=["x","y","1Y","2K","2K-83","2K-9M","2K-3b","2K-54"];1n(K d=0,dd=uD.1e;d<dd;d++){if(uD[d]in 1v){1A.1U.7M=1;1p}}3q(a["1Y-uB"]){1l"2J":1A.c9.3b["v-1Y-uk"]="2a";1A.pK=1A.W/2;1p;1l"4x":1A.c9.3b["v-1Y-uk"]="7S";1A.pK=-1A.W/2;1p;5n:1A.c9.3b["v-1Y-uk"]="uH";1A.pK=0;1p}1A.c9.3b["v-1Y-Sn"]=1o}},o8=1a(o,3Q,28){o.2b=o.2b||{};K 2b=o.2b,5M=3F.5M,2I,Sp,1w="nS",uu=".5 .5";o.2b.3Q=3Q;3Q=3Z(3Q).3f(R.uC,1a(6k,fx,fy){1w="pO";if(fx&&fy){fx=3z(fx);fy=3z(fy);5M(fx-0.5,2)+5M(fy-0.5,2)>0.25&&(fy=3y.9v(0.25-5M(fx-0.5,2))*((fy>0.5)*2-1)+0.5);uu=fx+S+fy}1b E});3Q=3Q.3p(/\\s*\\-\\s*/);if(1w=="nS"){K 7l=3Q.bP();7l=-3z(7l);if(aE(7l)){1b 1c}}K 57=R.uJ(3Q);if(!57){1b 1c}o=o.c7||o.1s;if(57.1e){o.7g(28);28.on=1o;28.45="3t";28.3s=57[0].3s;28.Sl=57[57.1e-1].3s;K pT=[];1n(K i=0,ii=57.1e;i<ii;i++){57[i].2y&&pT.1C(57[i].2y+S+57[i].3s)}28.Sk=pT.1e?pT.4H():"0% "+28.3s;if(1w=="pO"){28.1w="Sx";28.2R="100%";28.Sw="0 0";28.Sr=uu;28.7l=0}1i{28.1w="3Q";28.7l=(Sq-7l)%8t}o.3E(28)}1b 1},9T=1a(1s,5H){J[0]=J.1s=1s;1s.46=1o;J.id=R.ve++;1s.va=J.id;J.X=0;J.Y=0;J.2b={};J.2v=5H;J.4w=R.4w();J.1U={3A:[],sx:1,sy:1,dx:0,dy:0,4n:0,7M:1,f5:1};!5H.4G&&(5H.4G=J);J.3O=5H.1O;5H.1O&&(5H.1O.3k=J);5H.1O=J;J.3k=1c};K 3c=R.el;9T.2S=3c;3c.4V=9T;3c.3A=1a(aA){if(aA==1c){1b J.1U.3A}K gk=J.2v.JZ,JF=gk?"s"+[gk.82,gk.82]+"-1-1t"+[gk.dx,gk.dy]:E,pH;if(gk){pH=aA=3Z(aA).3f(/\\.{3}|\\uR/g,J.1U.3A||E)}R.uO(J,JF+aA);K 4w=J.4w.5S(),85=J.85,o=J.1s,3p,uW=~3Z(J.2b.28).4Y("-"),JA=!3Z(J.2b.28).4Y("5b(");4w.fk(1,1);if(JA||(uW||J.1w=="8R")){85.4w="1 0 0 1";85.2y="0 0";3p=4w.3p();if(uW&&3p.JB||!3p.uV){o.3b.4s=4w.JG();K bb=J.6v(),uS=J.6v(1),dx=bb.x-uS.x,dy=bb.y-uS.y;o.hP=dx*-6w+S+dy*-6w;nK(J,1,1,dx,dy,0)}1i{o.3b.4s=E;nK(J,3p.fj,3p.eJ,3p.dx,3p.dy,3p.5p)}}1i{o.3b.4s=E;85.4w=3Z(4w);85.2y=4w.2y()}pH&&(J.1U.3A=pH);1b J};3c.5p=1a(4n,cx,cy){if(J.5c){1b J}if(4n==1c){1b}4n=3Z(4n).3p(5o);if(4n.1e-1){cx=3z(4n[1]);cy=3z(4n[2])}4n=3z(4n[0]);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2W=J.6v(1);cx=2W.x+2W.1r/2;cy=2W.y+2W.1y/2}J.1U.f5=1;J.3A(J.1U.3A.3w([["r",4n,cx,cy]]));1b J};3c.fk=1a(dx,dy){if(J.5c){1b J}dx=3Z(dx).3p(5o);if(dx.1e-1){dy=3z(dx[1])}dx=3z(dx[0])||0;dy=+dy||0;if(J.1U.2W){J.1U.2W.x+=dx;J.1U.2W.y+=dy}J.3A(J.1U.3A.3w([["t",dx,dy]]));1b J};3c.82=1a(sx,sy,cx,cy){if(J.5c){1b J}sx=3Z(sx).3p(5o);if(sx.1e-1){sy=3z(sx[1]);cx=3z(sx[2]);cy=3z(sx[3]);aE(cx)&&(cx=1c);aE(cy)&&(cy=1c)}sx=3z(sx[0]);sy==1c&&(sy=sx);cy==1c&&(cx=cy);if(cx==1c||cy==1c){K 2W=J.6v(1)}cx=cx==1c?2W.x+2W.1r/2:cx;cy=cy==1c?2W.y+2W.1y/2:cy;J.3A(J.1U.3A.3w([["s",sx,sy,cx,cy]]));J.1U.f5=1;1b J};3c.3J=1a(){!J.5c&&(J.1s.3b.5q="3t");1b J};3c.5e=1a(){!J.5c&&(J.1s.3b.5q=E);1b J};3c.nm=1a(){if(J.5c){1b{}}1b{x:J.X+(J.pK||0)-J.W/2,y:J.Y-J.H,1r:J.W,1y:J.H}};3c.3u=1a(){if(J.5c||!J.1s.3n){1b}J.2v.6I&&J.2v.6I.uZ(J);R.2Q.7V("46.*.*."+J.id);R.v9(J,J.2v);J.1s.3n.7g(J.1s);J.c7&&J.c7.3n.7g(J.c7);1n(K i in J){J[i]=2L J[i]=="1a"?R.kq(i):1c}J.5c=1o};3c.1k=1a(1z,1m){if(J.5c){1b J}if(1z==1c){K 1A={};1n(K a in J.2b){if(J.2b[3o](a)){1A[a]=J.2b[a]}}1A.3Q&&(1A.28=="3t"&&((1A.28=1A.3Q)&&41 1A.3Q));1A.3A=J.1U.3A;1b 1A}if(1m==1c&&R.is(1z,"4d")){if(1z==g6&&(J.2b.28=="3t"&&J.2b.3Q)){1b J.2b.3Q}K 7e=1z.3p(5o),2m={};1n(K i=0,ii=7e.1e;i<ii;i++){1z=7e[i];if(1z in J.2b){2m[1z]=J.2b[1z]}1i{if(R.is(J.2v.8P[1z],"1a")){2m[1z]=J.2v.8P[1z].Jx}1i{2m[1z]=R.j1[1z]}}}1b ii-1?2m:2m[7e[0]]}if(J.2b&&(1m==1c&&R.is(1z,"3K"))){2m={};1n(i=0,ii=1z.1e;i<ii;i++){2m[1z[i]]=J.1k(1z[i])}1b 2m}K 1v;if(1m!=1c){1v={};1v[1z]=1m}1m==1c&&(R.is(1z,"1D")&&(1v=1z));1n(K 1q in 1v){2Q("46.1k."+1q+"."+J.id,J,1v[1q])}if(1v){1n(1q in J.2v.8P){if(J.2v.8P[3o](1q)&&(1v[3o](1q)&&R.is(J.2v.8P[1q],"1a"))){K 8C=J.2v.8P[1q].3d(J,[].3w(1v[1q]));J.2b[1q]=1v[1q];1n(K bc in 8C){if(8C[3o](bc)){1v[bc]=8C[bc]}}}}if(1v.1Y&&J.1w=="1Y"){J.c9.4d=1v.1Y}dB(J,1v)}1b J};3c.Jv=1a(){!J.5c&&J.1s.3n.3E(J.1s);J.2v&&(J.2v.1O!=J&&R.us(J,J.2v));1b J};3c.Jw=1a(){if(J.5c){1b J}if(J.1s.3n.7A!=J.1s){J.1s.3n.76(J.1s,J.1s.3n.7A);R.uG(J,J.2v)}1b J};3c.e7=1a(1f){if(J.5c){1b J}if(1f.4V==R.st.4V){1f=1f[1f.1e-1]}if(1f.1s.iN){1f.1s.3n.76(J.1s,1f.1s.iN)}1i{1f.1s.3n.3E(J.1s)}R.uv(J,1f,J.2v);1b J};3c.76=1a(1f){if(J.5c){1b J}if(1f.4V==R.st.4V){1f=1f[0]}1f.1s.3n.76(J.1s,1f.1s);R.uy(J,1f,J.2v);1b J};3c.4P=1a(54){K s=J.1s.Se,f=s.4s;f=f.3f(K5,E);if(+54!==0){J.2b.4P=54;s.4s=f+S+ms+".K6(Sg="+(+54||1.5)+")";s.jz=R.6s("-{0}px 0 0 -{0}px",4I(+54||1.5))}1i{s.4s=f;s.jz=0;41 J.2b.4P}1b J};R.4C.1G=1a(8j,5H){K el=cz("c7");el.3b.fl=wr;el.r8=6w+S+6w;el.hP=5H.hP;K p=1S 9T(el,5H),1k={28:"3t",1X:"#c8"};8j&&(1k.1G=8j);p.1w="1G";p.1G=[];p.kL=E;dB(p,1k);5H.1V.3E(el);K 85=cz("85");85.on=1o;el.3E(85);p.85=85;p.3A(E);1b p};R.4C.4l=1a(5H,x,y,w,h,r){K 1G=R.wg(x,y,w,h,r),1A=5H.1G(1G),a=1A.2b;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1r=w;1A.H=a.1y=h;a.r=r;a.1G=1G;1A.1w="4l";1b 1A};R.4C.a0=1a(5H,x,y,rx,ry){K 1A=5H.1G(),a=1A.2b;1A.X=x-rx;1A.Y=y-ry;1A.W=rx*2;1A.H=ry*2;1A.1w="a0";dB(1A,{cx:x,cy:y,rx:rx,ry:ry});1b 1A};R.4C.9i=1a(5H,x,y,r){K 1A=5H.1G(),a=1A.2b;1A.X=x-r;1A.Y=y-r;1A.W=1A.H=r*2;1A.1w="9i";dB(1A,{cx:x,cy:y,r:r});1b 1A};R.4C.8R=1a(5H,4a,x,y,w,h){K 1G=R.wg(x,y,w,h),1A=5H.1G(1G).1k({1X:"3t"}),a=1A.2b,1s=1A.1s,28=1s.bY(g6)[0];a.4a=4a;1A.X=a.x=x;1A.Y=a.y=y;1A.W=a.1r=w;1A.H=a.1y=h;a.1G=1G;1A.1w="8R";28.3n==1s&&1s.7g(28);28.5p=1o;28.4a=4a;28.1w="Kb";1A.1U.cm=[x,y];1A.1U.g4=[w,h];1s.3E(28);nK(1A,1,1,0,0,0);1b 1A};R.4C.1Y=1a(5H,x,y,1Y){K el=cz("c7"),1G=cz("1G"),o=cz("c9");x=x||0;y=y||0;1Y=1Y||"";1G.v=R.6s("m{0},{1}l{2},{1}",4I(x*6w),4I(y*6w),4I(x*6w)+1);1G.Sb=1o;o.4d=3Z(1Y);o.on=1o;el.3b.fl=wr;el.r8=6w+S+6w;el.hP="0 0";K p=1S 9T(el,5H),1k={28:"#c8",1X:"3t",2K:R.j1.2K,1Y:1Y};p.c7=el;p.1G=1G;p.c9=o;p.1w="1Y";p.2b.1Y=3Z(1Y);p.2b.x=x;p.2b.y=y;p.2b.w=1;p.2b.h=1;dB(p,1k);el.3E(o);el.3E(1G);5H.1V.3E(el);K 85=cz("85");85.on=1o;el.3E(85);p.85=85;p.3A(E);1b p};R.4C.hR=1a(1r,1y){K cs=J.1V.3b;J.1r=1r;J.1y=1y;1r==+1r&&(1r+="px");1y==+1y&&(1y+="px");cs.1r=1r;cs.1y=1y;cs.5Z="4l(0 "+1r+" "+1y+" 0)";if(J.f4){R.4C.fc.3d(J,J.f4)}1b J};R.4C.fc=1a(x,y,w,h,al){R.2Q("46.fc",J,J.f4,[x,y,w,h,al]);K 1r=J.1r,1y=J.1y,54=1/ 4Q(w /1r,h/1y),H,W;if(al){H=1y/h;W=1r/w;if(w*H<1r){x-=(1r-w*H)/ 2 /H}if(h*W<1y){y-=(1y-h*W)/ 2 /W}}J.f4=[x,y,w,h,!!al];J.JZ={dx:-x,dy:-y,82:54};J.8G(1a(el){el.3A("...")});1b J};K cz;R.4C.rf=1a(5l){K 2Y=5l.2N;2Y.SV().SU(".hY","Jm:5b(#5n#g9)");7D{!2Y.9j.hY&&2Y.9j.51("hY","II:IJ-IK-w8:5H");cz=1a(68){1b 2Y.cb("<hY:"+68+\' 2C="hY">\')}}7C(e){cz=1a(68){1b 2Y.cb("<"+68+\' IN="II:IJ-IK.w8:5H" 2C="hY">\')}}};R.4C.rf(R.7y.5l);R.4C.7K=1a(){K aN=R.w4.3d(0,2q),4b=aN.4b,1y=aN.1y,s,1r=aN.1r,x=aN.x,y=aN.y;if(!4b){9K 1S 9h("g9 4b 5L 8K.")}K 1A=1S R.w5,c=1A.1V=R.7y.2Y.cb("2F"),cs=c.3b;x=x||0;y=y||0;1r=1r||IR;1y=1y||Iy;1A.1r=1r;1A.1y=1y;1r==+1r&&(1r+="px");1y==+1y&&(1y+="px");1A.r8=6w*93+S+6w*93;1A.hP="0 0";1A.2E=R.7y.2Y.cb("2E");1A.2E.3b.fl="2G:8x;2a:-iJ;1O:-iJ;IC:0;jz:0;bO-1y:1;";c.3E(1A.2E);cs.fl=R.6s("1O:0;2a:0;1r:{0};1y:{1};5q:ID-6X;2G:ob;5Z:4l(0 {0} {1} 0);gh:70",1r,1y);if(4b==1){R.7y.2Y.3U.3E(c);cs.2a=x+"px";cs.1O=y+"px";cs.2G="8x"}1i{if(4b.7A){4b.76(c,4b.7A)}1i{4b.3E(c)}}1A.r2=1a(){};1b 1A};R.2S.af=1a(){R.2Q("46.af",J);J.1V.mQ=E;J.2E=R.7y.2Y.cb("2E");J.2E.3b.fl="2G:8x;2a:-iJ;1O:-iJ;IC:0;jz:0;bO-1y:1;5q:ID;";J.1V.3E(J.2E);J.4G=J.1O=1c};R.2S.3u=1a(){R.2Q("46.3u",J);J.1V.3n.7g(J.1V);1n(K i in J){J[i]=2L J[i]=="1a"?R.kq(i):1c}1b 1o};K 6L=R.st;1n(K 45 in 3c){if(3c[3o](45)&&!6L[3o](45)){6L[45]=1a(ec){1b 1a(){K 4i=2q;1b J.8G(1a(el){el[ec].3d(el,4i)})}}(45)}}})();rv.wI?g.5l.bf=R:bf=R;1b R});K La=1a(wF){J.3s=1c;J.wB=1c;J.bg=1c;J.bO=1c;J.wD=1c;J.2J=1c;J.wy=1c;J.4x=1c;J.1D=1c;J.6h=1c;J.wE=1a(wF){};J.wE(wF)};1a 6v(1u){K 53={x:0,y:0,1r:0,1y:0};if(!1u.1e){1b 53}K o=1u[0];1a rw(1f,Jj){53={x:0,y:0,1r:1f.nR,1y:1f.rt};44(1f){if(1f.id==Jj){1p}53.x+=1f.8l-1f.4S+1f.j4;53.y+=1f.9p-1f.5a+1f.j2;1f=1f.e5}1b 53}if(o.68=="TR"){53=rw(o,"qb-ui-1V")}1i{if(o.68=="DE"){53=rw(o,"qb-ui-1V")}1i{if(o.68=="T5"){53=rw(o,"qb-ui-1V")}}}1b 53}1a e8(x){1b 3F.4I(x*93)/93}1a Lm(fi,eS){K Ji=20;K p1=[{x:fi.x,y:fi.y+fi.1y/ 2}, {x:fi.x + fi.1r, y:fi.y + fi.1y /2}];K p2=[{x:eS.x,y:eS.y+eS.1y/ 2}, {x:eS.x + eS.1r, y:eS.y + eS.1y /2}];K d=[],lP=[];1n(K i1=0;i1<p1.1e;i1++){1n(K i2=0;i2<p2.1e;i2++){K dx=3F.4c(p1[i1].x-p2[i2].x);K dy=3F.4c(p1[i1].y-p2[i2].y);K 6b=dx*dx+dy*dy;lP.1C(6b);d.1C({i1:i1,i2:i2})}}K 1A={i1:0,i2:0};K rz=-1;K 5U=-1;1n(K i=0;i<lP.1e;i++){if(5U==-1||lP[i]<5U){5U=lP[i];rz=i}}if(rz>0){1A=d[rz]}K x1=p1[1A.i1].x,y1=p1[1A.i1].y,x4=p2[1A.i2].x,y4=p2[1A.i2].y,y2=y1,y3=y4;K dx=3F.4y(3F.4c(x1-x4)/2,Ji);K x2=[x1-dx,x1+dx][1A.i1];K x3=[x4-dx,x4+dx][1A.i2];1b{x1:e8(x1),y1:e8(y1),x2:e8(x2),y2:e8(y2),x3:e8(x3),y3:e8(y3),x4:e8(x4),y4:e8(y4)}}1a Sz(53,IX){K R=bf==1c?dh:bf;K 4t=53;if(R.is(53,"1a")){1b IX?4t():2Q.on("46.iZ",4t)}1i{if(R.is(4t,1o)){1b R.4C.7K[53](R,4t.5f(0,3+R.is(4t[0],1c))).51(4t)}1i{K 2e=3Y.2S.3G.2w(2q,0);if(R.is(2e[2e.1e-1],"1a")){K f=2e.dw();1b 4t?f.2w(R.4C.7K[53](R,2e)):2Q.on("46.iZ",1a(){f.2w(R.4C.7K[53](R,2e))})}1i{1b R.4C.7K[53](R,2q)}}}}bf.fn.GA=1a(1W){if(!1W.4U||!1W.4T){1b 1j}if(!1W.4U.2j||!1W.4T.2j){1b 1j}if(!1W.4U.2j.1f||!1W.4T.2j.1f){1b 1j}K 7B=1W.6h;K ww=8;K 3s=7B.3s;K Lr=1W.4U.4A;K Lu=1W.4T.4A;1a wv(1W){K cU=6v(1W.2j.1f);if(1W.1M){K e9=6v(1W.1M.1f);cU.x=e9.x-1;cU.1r=e9.1r+2;if(cU.y<e9.y){cU.y=e9.y}1i{if(cU.y>e9.y+e9.1y-cU.1y){cU.y=e9.y+e9.1y-cU.1y}}}1b cU}K Ln=wv(1W.4U);K Lo=wv(1W.4T);K 7j=Lm(Ln,Lo);K wx=7j.x1<7j.x2?1:-1;K wu=7j.x4<7j.x3?1:-1;K 1G=["M",7j.x1,7j.y1,"L",7j.x1+ww*wx,7j.y1,"C",7j.x2,7j.y2,7j.x3,7j.y3,7j.x4+ww*wu,7j.y4,"L",7j.x4,7j.y4].4H(",");7B.2J=kT(7B.2J,Lu,3s,7j.x1,7j.y1,wx);7B.4x=kT(7B.4x,Lr,3s,7j.x4,7j.y4,wu);if(7B.1G=1G&&(7B.bO&&7B.bg)){7B.bg.1k({1G:1G});7B.bO.1k({1G:1G});$(7B.bg.1s).2t("1W-3l")}1b 1o};bf.fn.GF=1a(1u,1k){K 1W=1S La;1W.3s=1k.3p("|")[0]||"#Lb";1W.wB=1k.3p("|")[1]||3;1W.L8=15;1W.bO=J.1G("M,0,0").1k({1X:1W.3s,28:"3t","1X-1r":1W.wB,"1X-cH":"4I","1X-gj":"4I"});1W.bg=J.1G("M,0,0").1k({1X:1W.3s,28:"3t","1X-1r":1W.L8,"1X-2I":0.Lc});1W.wD=1u.4T.4A;1W.2J=kT(1c,1W.wD,1W.3s);1W.wy=1u.4U.4A;1W.4x=kT(1c,1W.wy,1W.3s);1W.1D=1u;1b 1W};1a kT(1u,1w,3s,x,y,d){if(!x){x=0}if(!y){y=0}if(!d){d=1}K rq=1j;if(1u!=1c&&1u.1s){3q(1w){1l 1R.7p.bW:rq=1u.1s.8N!="9i";1p;1l 1R.7p.dr:rq=1u.1s.8N!="1G";1p}}if(rq){if(1u&&1u.3u){1u.3u()}1u=1c}if(1u==1c){3q(1w){1l 1R.7p.bW:1u=QB.1d.2f.r.9i(0,0,5);1u.1k({28:3s,"1X-1r":0});1p;1l 1R.7p.dr:1u=QB.1d.2f.r.1G("M,0,0");1u.1k({28:3s,"1X-1r":0});1p}}3q(1w){1l 1R.7p.bW:1u.1k({cx:x,cy:y});1p;1l 1R.7p.dr:K dx=8;K dy=5;K 1G=["M",x,y,"L",x,y+1,x+dx*d,y+dy,x+dx*d,y-dy,x,y-1,"Z"].4H(",");1u.1k({1G:1G});1p}1b 1u};K IH=1o;1a VK(1D,1H,7u){if(2L 1D.bi!="2O"){1D.bi(1H,7u,1j)}1i{if(2L 1D.gu!="2O"){1D.gu("on"+1H,7u)}1i{9K"LX qF"}}}1a VN(1D,1H,7u){if(2L 1D.lj!="2O"){1D.lj(1H,7u,1j)}1i{if(2L 1D.vw!="2O"){1D.vw("on"+1H,7u)}1i{9K"LX qF"}}}1a Vr(fn){K 2p=3P.bi||3P.gu?3P:2N.bi?2N:2N.1L||1c;if(2p){if(2p.bi){2p.bi("vA",fn,1j)}1i{if(2p.gu){2p.gu("gp",fn)}}}1i{if(2L 3P.gp=="1a"){K 8n=3P.gp;3P.gp=1a(){8n();fn()}}1i{3P.gp=fn}}}K qG=[];K vy=1j;1a Vl(fn){if(!vy){qG.1C(fn)}1i{fn()}}1a Ng(){vy=1o;1n(K i=0;i<qG.1e;i++){qG[i]()}};K LA=0;if(!3Y.4Y){3Y.2S.4Y=1a(1u){1n(K i=0;i<J.1e;i++){if(J[i]==1u){1b i}}1b-1}}3N={sj:1a(){1b++LA},3r:1a(1u){if(1u==2O||1u==1c){1b""}1b 1u.3r()}};3N.j7=1a(4a,9O){K p,v;1n(p in 4a){if(2L 4a[p]==="1a"){9O[p]=4a[p]}1i{v=4a[p];9O[p]=v}}1b 9O};3N.FE=1a(4a,9O){K p,v;1n(p in 4a){if(9O[p]===2O){ag}if(2L 4a[p]==="1a"){9O[p]=4a[p]}1i{v=4a[p];9O[p]=v}}1b 9O};3N.wM=1a($1f,3x){if($1f.1e&&!1K(3x)){$1f.1k("5t-3x",3x.3f(/&2r;/g," ").3f(/&xl;/g,"&"))}};3N.Ly=1a(4a,9O){K p,v;1n(p in 4a){if(2L 4a[p]==="1a"){9O[p]=4a[p]}1i{if(4a.7X(p)){v=4a[p];if(v&&"1D"===2L v){9O[p]=3N.LC(v)}1i{9O[p]=v}}}}1b 9O};3N.LC=1a(o){if(!o||"1D"!==2L o){1b o}K c=o eH 3Y?[]:{};1b 3N.Ly(o,c)};3N.Vn=1a(el,1L){K 1J={2a:el.4S,1r:el.BG,1O:el.5a,1y:el.s6};1J.7S=1J.1r-1J.2a;1J.4G=1J.1y-1J.1O;if(1L){1J=3N.vk(1J,1L)}1b 1J};3N.ft=1a(el,1L){K r=el.vj();K 1J={2a:r.2a,7S:r.7S,1O:r.1O,4G:r.4G};if(!r.1r){1J.1r=r.7S-r.2a}1i{1J.1r=r.1r}if(!r.1y){1J.1y=r.4G-r.1O}1i{1J.1y=r.1y}if(1L){1J=3N.vk(1J,1L)}1b 1J};3N.vk=1a(r,p){1b{2a:r.2a-p.2a,1O:r.1O-p.1O,7S:r.7S-p.2a,4G:r.4G-p.1O,1y:r.1y,1r:r.1r}};3N.Vy=1a(3T){K 4y=0;$(3T).2g(1a(){4y=3F.4y(4y,$(J).1y())}).1y(4y)};3N.Vx=1a(3T){K 4y=0;$(3T).2g(1a(){4y=3F.4y(4y,$(J).1r())}).1r(4y)};3N.VA=1a(1u){if(1u){if(2L 1u=="4d"){if(1u!=""){1b 1u}}}1b""};3N.9t=1a(ld,1u){if(1u){if(2L 1u=="4d"){if(1u!=""){ld.1C(1u)}}}};2u.fn.cL=1a(1m){K fS=J.1k("1w");fS=1K(fS)?"":fS.3R();if(1m===2O){if(fS=="7W"){1b J[0].3B}1i{if(fS=="8q"){if(J[0].3B){1b J.1k("1m")}1i{1b 1c}}}1b J.2h()}if(fS=="7W"){if(1m==1o&&!J.1k("3B")){J.1k("3B","3B")}if(1m!=1o&&J.1k("3B")){J.jX("3B")}if(1m==1o&&!J.6J("3B")){J.6J("3B",1o)}if(1m!=1o&&J.6J("3B")){J.6J("3B",1j)}1b}1i{if(fS=="8q"){K LK=J.1k("1m");if(LK==1m){J.1k("3B","1o");J[0].3B=1o}1i{J.jX("3B")}1b}1i{K 68="";if(!1K(J[0])&&!1K(J[0].68)){68=J[0].68}if(68.3R()=="2n"){J.qC(1K(1m)?"0":1m.3r());1b}}}if(1m==1c){1m=""}J.2h(1m)};2u.fn.VS=1a(lf){if(!J[0]){1b{1O:0,2a:0}}if(J[0]===J[0].vo.3U){1b 2u.2y.Wf(J[0])}2u.2y.lm||2u.2y.bJ();if(2L lf=="4d"){if(lf!=""){K 1L=J.cB(lf);if(1L.1e){41 1L}}}1i{K 1L=lf}K 6l=J[0],e5=6l.e5,Ku=6l,2Y=6l.vo,g2,eg=2Y.9Q,3U=2Y.3U,km=2Y.km,kY=km.qv(6l,1c),1O=6l.9p,2a=6l.8l;44((6l=6l.3n)&&(6l!==3U&&6l!==eg)){g2=km.qv(6l,1c);1O-=6l.5a,2a-=6l.4S;if(6l===e5){1O+=6l.9p,2a+=6l.8l;if(2u.2y.Wg&&!(2u.2y.Wb&&/^t(Ef|d|h)$/i.9r(6l.68))){1O+=6i(g2.uA,10)||0,2a+=6i(g2.uI,10)||0}Ku=e5,e5=6l.e5}if(2u.2y.Wd&&g2.gh!=="6H"){1O+=6i(g2.uA,10)||0,2a+=6i(g2.uI,10)||0}kY=g2;if($.Wc(6l,1L)>=0){1p}}if(kY.2G==="ob"||kY.2G==="vm"){1O+=3U.9p,2a+=3U.8l}if(kY.2G==="vS"){1O+=3F.4y(eg.5a,3U.5a),2a+=3F.4y(eg.4S,3U.4S)}1b{1O:1O,2a:2a}};1a Wo(6e,vP){if(2q.1e>2){K vV=[];1n(K n=2;n<2q.1e;++n){vV.1C(2q[n])}1b 1a(){1b vP.3d(6e,vV)}}1i{1b 1a(){1b vP.2w(6e)}}}K 1K=1a(1u){if(1u===2O){1b 1o}if(1u==1c){1b 1o}if(1u===""){1b 1o}1b 1j};K ju=1a(73){if(!1K(73)){1b 73.3R()}1b 73};K Wi=1a(73){if(!1K(73)){1b 73.8u()}1b 73};K 2r=1a(1u){if(1u===2O){1b""}if(1u==1c){1b""}if(1u==""){1b""}1b 1u.3f(/ /g,"&2r;")};1a KC(er,ew,eu){1b 1a(a,b){if(!1K(er)&&a[er]<b[er]){1b-1}if(!1K(er)&&a[er]>b[er]){1b 1}if(!1K(ew)&&a[ew]<b[ew]){1b-1}if(!1K(ew)&&a[ew]>b[ew]){1b 1}if(!1K(eu)&&a[eu]<b[eu]){1b-1}if(!1K(eu)&&a[eu]>b[eu]){1b 1}1b 0}}3Y.2S.sB=1a(er,ew,eu){1b J.eU(KC(er,ew,eu))};K fa=1a(a,b){if(1K(a)&&1K(b)){1b 1o}if(1K(a)||1K(b)){1b 1j}1b a.3R()==b.3R()};3N.sW=1a(a,b){if(1K(a)&&1K(b)){1b 1o}1b a==b};1a 4m(lL,4k){K F=1a(){};F.2S=4k.2S;lL.2S=1S F;lL.2S.4V=lL;lL.VY=4k.2S}1a VX(Kj,9W){1n(K 45 in 9W){Kj.2S[45]=9W[45]}}5k.2S.6s=1a(6s){K qV="";K 3f=5k.jH;1n(K i=0;i<6s.1e;i++){K qK=6s.b6(i);if(3f[qK]){qV+=3f[qK].2w(J)}1i{qV+=qK}}1b qV};5k.jH={KL:["W0","VZ","VU","VT","KX","VW","VV","W6","W5","W8","W7","W2"],KF:["W1","W4","W3","Vk","KX","UA","Uz","UC","UB","Uy","Ux","UI"],L1:["UH","UJ","UE","UF","Uu","Ui","Ul"],KI:["Uk","Ue","Uh","Ug","Ur","Uq","Ut"],d:1a(){1b(J.ej()<10?"0":"")+J.ej()},D:1a(){1b 5k.jH.L1[J.qT()]},j:1a(){1b J.ej()},l:1a(){1b 5k.jH.KI[J.qT()]},N:1a(){1b J.qT()+1},S:1a(){1b J.ej()%10==1&&J.ej()!=11?"st":J.ej()%10==2&&J.ej()!=12?"nd":J.ej()%10==3&&J.ej()!=13?"rd":"th"},w:1a(){1b J.qT()},z:1a(){1b"g0 kM gA"},W:1a(){1b"g0 kM gA"},F:1a(){1b 5k.jH.KF[J.jN()]},m:1a(){1b(J.jN()<9?"0":"")+(J.jN()+1)},M:1a(){1b 5k.jH.KL[J.jN()]},n:1a(){1b J.jN()+1},t:1a(){1b"g0 kM gA"},L:1a(){1b J.kn()%4==0&&J.kn()%100!=0||J.kn()%kB==0?"1":"0"},o:1a(){1b"g0 gA"},Y:1a(){1b J.kn()},y:1a(){1b(""+J.kn()).79(2)},a:1a(){1b J.fV()<12?"am":"pm"},A:1a(){1b J.fV()<12?"AM":"PM"},B:1a(){1b"g0 kM gA"},g:1a(){1b J.fV()%12||12},G:1a(){1b J.fV()},h:1a(){1b((J.fV()%12||12)<10?"0":"")+(J.fV()%12||12)},H:1a(){1b(J.fV()<10?"0":"")+J.fV()},i:1a(){1b(J.KM()<10?"0":"")+J.KM()},s:1a(){1b(J.KQ()<10?"0":"")+J.KQ()},e:1a(){1b"g0 kM gA"},I:1a(){1b"g0 gA"},O:1a(){1b(-J.ep()<0?"-":"+")+(3F.4c(J.ep()/ 60) < 10 ? "0" : "") + 3F.4c(J.ep() /60)+"Vd"},P:1a(){1b(-J.ep()<0?"-":"+")+(3F.4c(J.ep()/ 60) < 10 ? "0" : "") + 3F.4c(J.ep() /60)+":"+(3F.4c(J.ep()%60)<10?"0":"")+3F.4c(J.ep()%60)},T:1a(){K m=J.jN();J.KY(0);K 1J=J.Ve().3f(/^.+ \\(?([^\\)]+)\\)?$/,"$1");J.KY(m);1b 1J},Z:1a(){1b-J.ep()*60},c:1a(){1b J.6s("Y-m-d")+"T"+J.6s("H:i:sP")},r:1a(){1b J.3r()},U:1a(){1b J.Kp()/93}};2u.fn.4N=1a(1w,1h,fn,bk){if(2L 1w==="1D"){1n(K 1q in 1w){J.2B(1q,1h,1w[1q],fn)}1b J}if(2u.e6(1h)){bk=fn;fn=1h;1h=2O}fn=bk===2O?fn:2u.1H.Ke(fn,bk);1b 1w==="UN"?J.LU(1w,1h,fn,bk):J.2g(1a(){2u.1H.51(J,1w,fn,1h)})};2u.fn.UM=1a(1w,1h,fn,bk){if(2u.e6(1h)){if(fn!==2O){bk=fn}fn=1h;1h=2O}2u(J.3l).2B(UQ(1w,J.3T),{1h:1h,3T:J.3T,UO:1w},fn,bk);1b J};2u.1H.Ke=1a(fn,9G,bk){if(9G!==2O&&!2u.e6(9G)){bk=9G;9G=2O}9G=9G||1a(){1b fn.3d(bk!==2O?bk:J,2q)};9G.7f=fn.7f=fn.7f||(9G.7f||J.7f++);1b 9G};3Y.2S.3u=1a(2s,to){if(2L 2s=="1D"){2s=J.4Y(2s)}J.5f(2s,!to||1+to-2s+(!(to<0^2s>=0)&&(to<0||-1)*J.1e));1b J.1e};K Ks={"&":"&xl;","<":"&lt;",">":"&gt;",\'"\':"&UV;","\'":"&#39;","/":"&#UX;"};Mm=1a(s){if(1K(s)){1b s}1b(s+"").3f(/[&<>"\'\\/]/g,1a(s){1b Ks[s]})};if(!4K.81){4K.81=1a(){K 7X=4K.2S.7X,L5=!{3r:1c}.qX("3r"),qL=["3r","C5","Kr","7X","Kw","qX","4V"],LJ=qL.1e;1b 1a(1u){if(2L 1u!=="1D"&&(2L 1u!=="1a"||1u===1c)){9K 1S UW("4K.81 C1 on V1-1D")}K 1J=[],6J,i;1n(6J in 1u){if(7X.2w(1u,6J)){1J.1C(6J)}}if(L5){1n(i=0;i<LJ;i++){if(7X.2w(1u,qL[i])){1J.1C(qL[i])}}}1b 1J}}()};QB={};QB.1d={};QB.1d.2V={};QB.1d.2d={};if(2L ck=="2O"){ck={io:1a(){},BT:1a(){}}}K V2=1o;49={hK:[],wQ:[],j6:"",B7:{},7Q:1c,2f:{gX:[],74:[]},2U:{cw:[]},bD:1c,3h:1c,fd:1c,au:{2P:[],AI:0},cu:"",9b:1c,LD:[],gR:1c,f9:{},eC:1c,ed:1j,rO:1j,IW:1j,J1:1j,fM:[],gJ:1c,9d:1c,AW:1j,x6:1c,9y:1c,kb:1c,hD:{},7r:1c,7h:1c,Li:1a(){J.j6="";J.B7={};J.7Q=1c;J.hQ=1c;J.2f={gX:[],74:[]};J.2U={cw:[]};J.hK=[];J.wQ=[];J.au={2P:[],AI:0};J.7h=1c;J.fd=1c;J.cu="";J.9b=1c;J.LD=[];J.eC=1c;J.f9={};J.hD={};J.7r=1c}};g8=1S 5X({d1:{},2B:1a(1H,1Z,3l){J.d1||(J.d1={});K 4v=J.d1[1H]||(J.d1[1H]=[]);4v.1C({1Z:1Z,3l:3l,9o:3l||J});1b J},2c:1a(1H){if(!J.d1){1b J}K 2e=3Y.2S.3G.2w(2q,1);K 4v=J.d1[1H];K AT=J.d1.6k;if(4v){J.AS(1H,4v,2e)}if(AT){J.AS(1H,AT,2q)}1b J},AS:1a(1H,4v,2e){K ev,i=-1,l=4v.1e,a1=2e[0],a2=2e[1],a3=2e[2];3q(2e.1e){1l 0:44(++i<l){(ev=4v[i]).1Z.2w(ev.9o,1H)}1b;1l 1:44(++i<l){(ev=4v[i]).1Z.2w(ev.9o,1H,a1)}1b;1l 2:44(++i<l){(ev=4v[i]).1Z.2w(ev.9o,1H,a1,a2)}1b;1l 3:44(++i<l){(ev=4v[i]).1Z.2w(ev.9o,1H,a1,a2,a3)}1b;5n:44(++i<l){(ev=4v[i]).1Z.3d(ev.9o,[1H].3w(2e))}1b}},bJ:1a(){}});LW=1S 5X({bN:g8,2l:{6A:"6A"}});LV=1S 5X({bN:g8,2l:{6A:"6A"}});LM=1S 5X({bN:g8,2l:{ls:"ls",6A:"6A"}});LR=1S 5X({bN:g8,2l:{6A:"6A"}});LN=1S 5X({bN:g8,2l:{6A:"6A"}});Jc=1S 5X({bN:g8,9y:1S LW,2f:1S LV,2U:1S LR,7r:1S LN,cv:1S LM,2l:{tB:"tB",6A:"6A",B3:"B3",tL:"tL",AV:"AV",AZ:"AZ",tX:"tX",tI:"tI",tG:"tG"},49:49,kb:1c,cu:"",9d:{},gR:1c,9b:1c,gJ:1c,eC:1c,7Q:"",hQ:"",ty:"",bD:"",lH:1j,3h:1c,9Z:1j,ao:0,au:[],ed:1j,oz:1j,bJ:1a(){J.Lh=$.hn(J.J5,sX,J);J.Lt=$.hn(J.LL,93,J)},tn:1a(1Z){K me=J;if(J.ao<0){J.ao=0}if(J.ao>0){6y(1a(){me.tn(1Z)},100);1b}1b me.61(1Z)},LL:1a(1Z){J.61(1Z,1o)},61:1a(1Z,LQ){if(!QB.1d.2k.oz&&LQ){1b}QB.1d.2k.oz=1j;K me=J;if(J.ao<0){J.ao=0}J.49.bD=J.bD;J.49.3h=J.3h;if(1K(J.49.2f)){J.49.2f={}}J.49.2f.rT={dn:QB.1d.2f.Du()};if(J.au.1e>0){J.49.au.AI=J.au[J.au.1e-1].Id}J.2c(J.2l.tB,J.49);K 1h=$.gd(J.49);me.49.Li();J.ao++;J.Lh();$.B5({5b:sn+"?47=Mq",1w:"qP",UU:"ez",UR:"lZ/ez",7N:1j,1h:1h,B2:1a(1h){QB.1d.2k.2c(QB.1d.2k.2l.6A,1h);if(1Z&&7T(1Z)=="1a"){1Z(1h)}me.hW(1h)},96:1a(NC,Np,Vc){if(!l7){dN(Gx)}},Ls:me.NA});me.ed=1j},89:1a(1Z){J.49.hK.1C("89");J.tn(1Z)},hu:1a(1Z){J.49.hK.1C("hu");J.61(1Z)},kP:1a(1Z){J.49.hK.1C("kP");J.61(1Z)},ho:1a(1Z){QB.1d.2k.ed=1o;QB.1d.2k.oz=1o;1b J.Lt(1Z)},J5:1a(){J.ao=0;1b},bA:1a(J4,1H,1h){if(!1K(1h)){J4.2c(1H,1h)}},hW:1a(1h){if(1h!=1c&&1h!==2O){K me=J;if(1K(J.bD)){J.bD=1h.bD}if(1K(J.3h)){J.3h=1h.3h}if(1h.IW||(1K(1h.bD)||J.bD!=1h.bD||(1K(1h.3h)||J.3h!=1h.3h))){if(1h.J1){oA.Vi()}1i{$.B5({5b:3P.oA.5d,V6:1j});J.3h=1c;J.49.7Q=QB.1d.2k.hQ;J.hu()}1b}J.kb=1h.kb;J.cu=1h.cu;J.9b=1h.9b;J.fM=1h.fM;J.9d=1h.9d;J.gJ=1h.gJ;if(!1K(1h.hD)&&4K.81(1h.hD).1e>0){J.hD=1h.hD}if(!1K(1h.eC)){J.eC=1h.eC}J.bA(J.cv,J.cv.2l.6A,1h.7h);if(!1K(J.cv)&&!J.9Z){J.9Z=1o;J.cv.2c(J.cv.2l.ls,1o)}J.bA(J,J.2l.tL,1h.7Q);J.bA(J.7r,J.7r.2l.6A,1h.7r);J.bA(J.2f,J.2f.2l.6A,1h.2f);J.bA(J.2U,J.2U.2l.6A,1h.2U);J.bA(J,J.2l.tX,1h.gR);J.bA(J.9y,J.9y.2l.6A,1h.9y);J.bA(J,J.2l.tG,1h.f9);J.bA(J,J.2l.tI,1h.au);J.bA(J,J.2l.B3,1h.fd);if(1h.AW!=1c&&1h.AW){J.2c(J.2l.AV,1h.7Q)}J.bA(J,J.2l.AZ,1h.x6)}J.ao--},Ii:1a(9m){9m.6U=1o;J.49.2f.gX.1C(9m)},If:1a(9m){9m.7Z=1o;J.49.2f.gX.1C(9m)},Iw:1a(9m){J.49.2f.gX.1C(9m)},H9:1a(1W){1W.6U=1o;J.49.2f.74.1C(1W)},V7:1a(1W){1W.7Z=1o;J.49.2f.74.1C(1W)},HJ:1a(1W){J.49.2f.74.1C(1W)},zK:1a(bF){J.49.7Q=bF},V4:1a(2X){1n(K i=0;i<2X.1e;i++){2X[i].6U=1o}QB.1d.2k.49.2U.cw=QB.1d.2k.49.2U.cw.3w(2X)},tR:1a(2X){QB.1d.2k.49.2U.cw=QB.1d.2k.49.2U.cw.3w(2X)},V5:1a(2X){1n(K i=0;i<2X.1e;i++){2X[i].7Z=1o}QB.1d.2k.49.2U.cw=QB.1d.2k.49.2U.cw.3w(2X)}});QB.1d.2k=1S Jc;K 1R={gB:{Bp:0,Bq:1,cM:2,Bb:3,Mt:4,Va:5,bs:6,gm:7},2i:{47:-1,jP:0,1Q:1,3g:2,bT:3,aa:4,8H:5,6S:6,dz:7,bX:8,8c:9,n3:10,2g:1a(1Z){1n(K i=-1;i<=9;i++){1Z(i,J.dq(i))}1n(K i=0;i<QB.1d.2U.gN;i++){1Z(10+i,"xz"+(i+1))}},dq:1a(2h){1n(K 1q in J){if(J[1q]==2h){1b 1q}}1b 1c}},7Q:{mI:{yQ:0,DX:1,Vb:2,2g:1a(1Z){1n(K i=0;i<=2;i++){1Z(i,J.dq(i))}},dq:1a(2h){1n(K 1q in J){if(J[1q]==2h){1b 1q}}1b 1c}},dV:[" ","V8","V9","Uo","Up","Um","Un"],sN:{mo:"Is",Ar:"Us",2g:1a(1Z){1Z(J.mo,J.dq(J.mo));1Z(J.Ar,J.dq(J.Ar))},dq:1a(2h){if(2h==J.mo){1b"Iz 2H"}1b"Iz Uf"}}},7p:{bW:0,dr:1,cA:1a(1u){K Uj=1u;if(1u==1R.7p.bW){1u=1R.7p.dr}1i{1u=1R.7p.bW}1b 1u}},4K:1a(2T){J.gF={};J.lg="";J.AE="";J.1z="";J.aa="";J.1w="";J.JW="";J.Kd=1c;J.id=3N.sj();if(2T){3N.j7(2T,J)}},UG:1a(2T){J.1z="UD";J.JW="UK";J.1w="EI";J.54="4";J.fP="10";J.Uv="1";J.Uw=1j;if(2T){3N.j7(2T,J)}},Vz:1a(1u){K 1J=[];if(1u.gF==1R.gB.cM){3N.9t(1J,1u.AE);3N.9t(1J,1u.lg);3N.9t(1J,1u.1z)}if(1u.gF==1R.gB.gm){K 1L=1u.1L;if(1L){3N.9t(1J,1L.AE);3N.9t(1J,1L.lg);3N.9t(1J,1L.1z);3N.9t(1J,1u.1z)}}1b 1J.4H(".")},Az:1a(2j,1M){K 1J=[];if(1M){1K(1M.8w)?3N.9t(1J,1M.3S):3N.9t(1J,1M.8w);3N.9t(1J,2j.88)}1b 1J.4H(".")},Vm:1a(1u){if(1u==1c){1b""}K 1J=[];if(1u.gF==1R.gB.cM){3N.9t(1J,1u.1z)}if(1u.gF==1R.gB.gm){K 1L=1u.Kd;if(1L){3N.9t(1J,1L.1z);3N.9t(1J,1u.1z)}}1b 1J.4H(".")},GP:1a(3g,oK,o4,oW,mf){if(3g!=""){1b 3g}K 1J=1R.Az(oK,o4)+" = "+1R.Az(oW,mf);1b 1J},K7:1a(){J.5F=[];J.xS=1a(){41 J.5F;J.5F=[]};J.Vs=1a(jq){if(!jq.5F){1b}J.xS();K me=J;1n(K i=0;i<jq.5F.1e;i++){J.5F.1C(jq.5F[i])}}}};Vp=1S 1R.K7;QB.1d.2d={};QB.1d.2d.Vq=1a(){1b{"gX":1c,"74":1c,"rT":1c}};QB.1d.2d.VB=1a(){1b{"cw":1c}};QB.1d.2d.xo=1a(){1b{"dV":1c,"8w":1c,"zW":1c,"5R":[],"8T":1c,"gM":1j,"3h":1c,"7Z":1j,"6U":1j,"b8":1j,"jk":1c,"dP":1c,"8V":0,"65":1c}};QB.1d.2d.VM=1a(){1b{"8w":1c,"VL":1c,"6G":1c,"iR":1c,"E4":0,"6j":[],"3h":1c,"3S":1c,"4K":1c,"IU":1o,"sm":1c,"nL":"","VQ":1j,"Bp":1c,"Bq":1c,"7Z":1j,"6U":1j,"65":1c,"K8":1c,"wP":1c,"wn":{"Ap":{"7H":1o,"84":0,"b7":"","cE":""},"Ao":{"84":1,"7H":1o,"b7":"","cE":""},"rW":{"84":2,"7H":1o,"b7":"","cE":""},"nM":{"sH":1j,"84":3,"7H":1o,"b7":"","cE":""},"wm":1j,"dP":0,"wp":1o,"Ai":1j},"lu":[],"bs":1c,"X":1c,"Y":1c,"x0":1c}};QB.1d.2d.VR=1a(){1b{"kZ":2,"6G":"","VP":1c,"VE":1c,"rJ":1j,"xE":1c,"VJ":1c}};QB.1d.2d.Gp=1a(){1b{"7Z":1c,"6U":1c,"4U":1c,"fq":1c,"4T":1c}};QB.1d.2d.Fo=1a(){1b{"VH":0,"4A":0,"cq":1c,"aC":1c}};QB.1d.2d.SK=1a(){1b{"5F":1c,"SH":1c}};QB.1d.2d.K9=1a(){1b{"SI":1c,"8T":1c,"Al":1c,"3h":1c,"eD":1j,"wh":1c,"88":1c,"sl":1c,"SN":1j,"SO":0,"nN":1j,"Kc":1j,"SL":1j,"SM":0,"wl":1c,"SB":0}};QB.1d.2d.Dt=1a(){1b{"6G":1c,"X":1c,"Y":1c,"la":1c,"l3":1c,"Ds":1c}};QB.1d.2d.kC=1a(){1b{"jw":[],"2P":1c,"oX":1c,"SC":30,"tM":0,"cc":"","jZ":"","SF":1j,"kL":"","I0":1j}};QB.1d.2d.DG=1a(){1b{"mZ":[],"Dk":1c,"3h":"SD-Bz-Bz-Bz-SE","SP":1c,"4A":0,"Dh":1j}};QB.1d.2d.Cb=1a(){1b{"mH":1c,"9P":1c,"eD":1c,"rJ":1j}};QB.1d.2d.f9=1a(){1b{"cc":1c,"fd":1c,"In":1c,"2f":1c,"F7":1c,"eR":1c,"F4":1c,"T1":1c,"cM":1c,"2U":1c}};QB.1d.2d.SY=1a(){1b{"2P":[]}};QB.1d.2d.JC=1a(){1b{"cK":"JC","6G":1c,"3h":1c,"fd":1c}};QB.1d.2d.G3=1a(){1b{"2P":[]}};QB.1d.2d.T2=1a(){1b{"cK":1c,"3S":1c,"fd":1c,"Av":1j,"2P":[],"3h":1c,"cc":1c}};QB.1d.2d.T3=1a(){1b{"3h":1c,"eM":1c,"E2":1c,"dn":1j,"SS":1j,"7H":1o,"6G":1c,"5X":1c,"7Q":1c,"ST":1j,"2P":[]}};QB.1d.2d.xY=1a(){1b{"tZ":[],"4A":3,"94":0,"SQ":1c,"2P":[],"6r":1c,"7v":0,"5V":1c,"78":1c}};QB.1d.2d.x8=1a(){1b{"2P":[],"6r":1c,"7v":0,"5V":1c,"78":1c,"4A":0}};QB.1d.2d.GB=1a(){1b{"4A":1,"2P":[],"6r":1c,"7v":0,"5V":1c,"78":1c}};QB.1d.2d.xT=1a(){1b{"4A":3,"94":0,"2P":[],"6r":1c,"7v":0,"5V":1c,"78":1c}};QB.1d.2d.yr=1a(){1b{"4A":2,"az":1c,"2P":[],"6r":1c,"7v":0,"5V":1c,"78":1c}};QB.1d.2d.SW=1a(){1b{"3S":1c,"Sy":0,"Sc":1,"mn":1}};QB.1d.2d.wn=1a(){1b{"Ap":{"7H":1o,"84":0,"b7":"","cE":""},"Ao":{"84":1,"7H":1o,"b7":"","cE":""},"rW":{"84":2,"7H":1o,"b7":"","cE":""},"nM":{"sH":1j,"84":3,"7H":1o,"b7":"","cE":""},"wm":1j,"dP":0,"wp":1o,"Ai":1j}};QB.1d.2d.58={"IA":{"BI":"S9&2r;iV","4K":"4K:","8w":"8w:","Ok":"OK","eb":"eb"},"G7":{"BI":"bs&2r;iV","Sa":"4U&2r;4K","Sf":"4T&2r;4K","Sd":"b8&2r;92&2r;Nc&2r;4U","S3":"b8&2r;92&2r;Nc&2r;4T","S1":"4U&2r;6r","S2":"4T&2r;6r","S7":"S8&2r;8T","Ok":"OK","eb":"eb"},"HE":{"BI":"Mg&2r;iV","NS":"NS","Sh":"Ss&2r;St:","Ok":"OK","eb":"eb"},"5m":{"5R":{"rV":"rV","8T":"8T","dV":"dV","8w":"8w","dP":"Nz&2r;4A","jk":"Nz&2r;Sv","gM":"gM","Sj":"tD&2r;By","xG":"5R&2r;1n","rI":"5R","Ie":"Or..."},"p6":"p6","So":"p6&2r;Bm","T6":"Em&2r;fY&2r;Bm","TQ":"j7&2r;kS&2r;eW","TS":"Bl&2r;kS&2r;jl-oP","TO":"k7&2r;TP","TV":"k7&2r;TX","U7":"k7&2r;up","Ub":"k7&2r;cT","U0":"hc&2r;1g","U1":"TY&2r;c0&2r;1g","6j":"6j","NQ":"NQ","TZ":"cM","U2":"Bb","TF":"Mt","Th":"fz","Tj":"Fv&2r;2n&2r;Ta&2r;T7&2r;to&2r;Te.","Tb":"ls&2r;B7:&2r;{0}&2r;Tz,&2r;{1}&2r;TC,&2r;{2}&2r;TE.","iV":"iV","hc":"hc","To":"b8&2r;92","b8":"b8...","92":"92","Me":"Me","NJ":"NJ","Nq":"Nq","NM":"NM","Ts":"Z7&2r;92","Z8":"Z3&2r;92","Au":"b8&2r;6k&2r;2X&2r;2s&2r;{0}","D6":"Mg&2r;is&2r;Z4,&2r;MO&2r;to&2r;be&2r;Z1","Kq":"Zn","tF":"tF...","Mv":"Mv","Ma":"Ma","iY":"fd&2r;aZ","gm":"gm","wO":"wO","Zo":"eR&2r;Zl&2r;1M","Zd":"eR&2r;NE&2r;cM&2r;8T","Zh":"eR&2r;Bl&2r;NE&2r;cM&2r;8T","YF":"FO","YG":"Bl&2r;kS&2r;jl-oP","YD":"j7&2r;kS&2r;eW","YE":"Em&2r;fY&2r;Bm","Yt":"p6","Yu":"p5&2r;5T&2r;fY&2r;Yx&2r;1z&2r;YW&2r;YJ&2r;in&2r;iM&2r;5y&2r;jl-oP."},"YM":"en"};QB.1d.2V.10b={Bp:0,Bq:1,4A:2};QB.1d.2V.E4={cM:0,Bb:1,10d:2,9n:3,E2:4,ZP:5};QB.1d.2V.ZO={fz:0,ZT:1,ZR:2};QB.1d.2V.ZN={bW:0,dr:1};QB.1d.2V.ZJ={k3:0,ZI:1,Zt:2};QB.1d.2V.10a={10g:1,ZY:2,kA:3};QB.1d.2V.108={X6:0,X7:1,Xa:2,k6:3,X9:4,5k:5,zi:6,X8:7,WY:8,3h:9,WX:10,EI:11,WW:12,4K:13,X0:14,Xk:15,5h:16,CY:17,Xm:18,Xf:19,WV:20,Wy:21,Wt:22,Wx:23,WN:25,WI:26,WL:27};QB.1d.2V.6B={Iq:0,Ij:1,Io:2,ma:3,Im:4,I5:5,HO:6,xc:7,xb:8,HL:9,HZ:10,I3:11,FY:12,HU:13,FQ:14,FM:15,G6:16,Ft:17};QB.1d.2V.5Y={fz:0,9P:1,fw:2,5k:3,k6:4};QB.1d.2V.XY={fz:0,5h:1,XW:2,Y0:3,5k:4,CY:5,zi:6,k6:7};QB.1d.2V.9L={92:0,tm:1,o9:2,k3:3};QB.1d.2V.wi={k3:0,3S:1,sm:2};K 9a=15;QB.1d.2f={6H:1j,1V:1c,6h:1c,5F:[],4X:[],r:1c,nh:1j,sT:1j,kA:1j,rS:1j,s9:1j,rF:1j,sa:1j,xx:1a(7f){1n(K i=0;i<J.5F.1e;i++){K 1u=J.5F[i];K jq=1u.1h("4q");if(3N.sW(7f,jq.x0)){1b 1u}}1b 1c},Aa:1a(ke,k2){1b ke.3h==k2.3h||(ke.6U||k2.6U)&&ke.65==k2.65},Ab:1a(ke,k2){1b ke.6G==k2.6G},lh:1a(8o){K 1J=1c;if(1K(8o)){1b 1J}$.2g(J.5F,1a(1P,1u){K 1M=1u.1h("1D");if(fa(1M.8w,8o)||(fa(1M.3S,8o)||(fa(1M.nL,8o)||fa(1M.iR,8o)))){1J=1u;1b 1j}});1b 1J},Y2:1a(iO){if(iO==1c){1b}K 8J=iO.3G();K iv=[];K iw=[];K ir=[];K me=J;1n(K i=J.5F.1e-1;i>=0;i--){K 1u=J.5F[i];K iK=1u.1h("1D");K dC=1c;1n(K j=8J.1e-1;j>=0;j--){K 8b=8J[j];if(J.Aa(iK,8b)){8J.3u(j);dC=8b;1p}}if(dC==1c){1n(K j=8J.1e-1;j>=0;j--){K 8b=8J[j];if(J.Ab(iK,8b)){8J.3u(j);dC=8b;1p}}}if(dC!=1c){iw.1C({1N:8b,5P:1u})}1i{iv.1C(1u)}}$.2g(8J,1a(1P,8b){ir.1C(8b)});K bS=1a(1x,5P){K 1u=J.bS(1x,5P);if(5P===2O||5P==1c){1u.4N(QB.1d.7c.2l.nI,J.xu,J);1u.4N(QB.1d.7c.2l.nF,J.xv,J);1u.4N(QB.1d.7c.2l.kN,J.xp,J);1u.4N(QB.1d.7c.2l.kE,J.jC,J)}J.3M.8L("kR");1b 1u};K gW=1a(1x,5P,hL){K 1u=J.gW(1x,5P,hL);J.3M.8L("kR");1b 1u};$.2g(iw,1a(1P,1u){gW({1D:1u.1N},1u.5P,1o)});$.2g(iv,1a(1P,1u){J.t5(1u,1o)});$.2g(ir,1a(1P,1u){bS({1D:1u})})},gW:1a(1x,5P,hL){K 2y=5P.2y();K p9={};K pg=1c;if(5P!=1c){K g1=5P.1h("1D");K k8=1x.1D;if(g1&&k8){p9[g1.3h]=k8.3h;pg=g1.3h;if(g1.6j&&k8.6j){$.2g(g1.6j,1a(i,2j){if(g1.6j[i]&&k8.6j[i]){p9[g1.6j[i].3h]=k8.6j[i].3h}})}}}1x.hL=hL;5P.6V("Jz",1x);if(pg){$.2g(QB.1d.2f.74.Fu(pg),1a(i,1W){1W.lV(p9)})}7D{5P.2y(2y)}7C(e){}1b 5P},bS:1a(1x,5P){if(5P==1c){K 7R=$("<2F></2F>");if(J.1V!=1c&&J.1V.1e>0){J.1V.3a(7R)}1i{1x.6H=1j}7R.6V(1x);7R.4N(QB.1d.7c.2l.u3,{1u:7R},J.Ci,J);7R.4N(QB.1d.7c.2l.ue,{1u:7R},J.Cr,J);if(!1x.2G&&!1x.8W){K 2G=J.DL(7R);7R.8l=2G[0];7R.9p=2G[1];7R.6V("2G",2G)}J.5F.1C(7R);1b 7R}1i{5P.6V("89",1x);1b 5P}},t5:1a(1D,rN){1D.6V("5r",1c,rN)},Ci:1a(e,1h){K 1u=e.1h.1u;K Cz=1u.1h("f3");J.5F.3u(1u);QB.1d.2f.74.FV(Cz)},Cr:1a(e,1h){K 1u=e.1h.1u;J.1V.2c(QB.1d.2f.2l.rZ,1u)},FF:1a(3h){K 1u=1c;$.2g(J.5F,1a(1P,o){if(o.1h("f3")==3h){1u=o.1h("J9");1b 1j}});1b 1u},Fx:1a(1M,Cs){K 1J=1c;if(1M==1c){1b 1J}$.2g(1M.5K,1a(1P,2j){if(2j.1D.3h==Cs){1J=2j;1b 1j}});1b 1J},Du:1a(){K 1J=[];$.2g(J.5F,1a(1P,1u){K 1M=1u.1h("1D");if(1M==1c){1b 1o}K l=1S QB.1d.2d.Dt;K p=1u.2G();if(1M.6j){l.Ds=1M.6j.1e}l.6G=1M.6G;l.X=p.2a;l.Y=p.1O;l.la=1u.1r();l.l3=1u.1y();1J.1C(l)});1b 1J},Ff:1a(l8){if(l8==1c){1b}if(l8.1e==0){1b}$.2g(J.5F,1a(1P,1u){K 1M=1u.1h("1D");if(1M==1c){1b 1o}K 9l=1c;1n(K 1P=0;1P<l8.1e;1P++){K l=l8[1P];if(l.6G==1M.6G){9l=l;1p}}if(9l!=1c){if(9l.X!=0&&(!1K(9l.X)&&(9l.Y!=0&&!1K(9l.Y)))){1u.6V("2G",[9l.X,9l.Y])}if(9l.la!=0&&!1K(9l.la)){1u.6V("2T","1r",9l.la)}if(9l.l3!=0&&!1K(9l.l3)){1u.6V("2T","1y",9l.l3)}}})},Fz:1a(1M){if(1M==1c){1b 1c}1b 1M.dI},DL:1a(7R){K 1r=J.1V.1r();if(1r<fN){1r=rL}K ap=[0,1r];K aq=[0,Yk];K gs=[];K ow=7R.1r();K oh=7R.1y();if(ow==0){ow=fN}if(oh==0){oh=BP}K w=ow+9a*2;K h=oh+9a*2;J.DF(ap,aq,gs,7R);if(J.nh){1b J.DB(ap,aq,gs,w,h)}1i{1b J.DC(ap,aq,gs,w,h)}},DC:1a(xs,ys,dR,w,h){1n(K j=0;j<ys.1e;j++){1n(K i=0;i<xs.1e;i++){if(dR[i][j]==0){if(J.Bx(xs,ys,dR,i,j,w,h)){1b[xs[i]+9a,ys[j]+9a]}}}}1b[9a,9a]},DB:1a(xs,ys,dR,w,h){1n(K j=0;j<ys.1e;j++){1n(K i=xs.1e-1;i>=0;i--){if(dR[i][j]==0){if(J.Bx(xs,ys,dR,i,j,w,h)){if(i+1<xs.1e){1b[xs[i+1]+9a-w,ys[j]+9a]}}}}}1b[9a,9a]},DF:1a(ap,aq,gs,7R){$.2g(J.5F,1a(){if(J==7R){1b 1o}K 1u=J[0];ap.1C(1u.8l-9a);aq.1C(1u.9p-9a);K ow=1u.fC;K oh=1u.bj;if(ow==0){ow=fN}if(oh==0){oh=BP}ap.1C(1u.8l+ow+9a);aq.1C(1u.9p+oh+9a)});ap.eU(1a(a,b){1b a-b});aq.eU(1a(a,b){1b a-b});1n(K i=0;i<ap.1e;i++){K 1I=[];1n(K j=0;j<aq.1e;j++){1I.1C(i==ap.1e-1||j==aq.1e-1?1:0)}gs.1C(1I)}$.2g(J.5F,1a(){K 1u=J[0];K Db=1u.8l;K D4=1u.9p;K ow=1u.fC;K oh=1u.bj;if(ow==0){ow=fN}if(oh==0){oh=BP}K Df=1u.8l+ow;K DI=1u.9p+oh;K BA=0;K BB=0;1n(K i=0;i<ap.1e;i++){if(ap[i]<=Db){BA=i}if(Df<=ap[i]){BB=i;1p}}K Bv=0;K Bw=0;1n(K j=0;j<aq.1e;j++){if(aq[j]<=D4){Bv=j}if(DI<=aq[j]){Bw=j;1p}}1n(K i=BA;i<BB;i++){1n(K j=Bv;j<Bw;j++){gs[i][j]=1}}})},Bx:1a(xs,ys,dR,oS,oI,w,h){if(dR[oS][oI]==1){1b 1j}1n(K j=oI;j<=ys.1e;j++){if(ys[j]-ys[oI]>=h){1p}1n(K i=oS;i<xs.1e;i++){if(xs[i]-xs[oS]>=w){1p}if(dR[i][j]==1){1b 1j}}}1b 1o},71:1a(){if(J.1V==1c||J.1V.1e==0){1b 1c}K c=J.1V[0];J.6h.1r(1);J.6h.1y(1);J.r.hR(1,1);K w=c.BG-2;K h=c.s6-2;if(w<0){w=0}if(h<0){h=0}J.6h.1r(w);J.6h.1y(h);J.r.hR(w,h)},oV:1a(){K 3i=J.kH();if(3i){3i.3i("6K")}J.71()},GW:1a(47,1g,1x){3q(47){1l"ea":J.oV();1p;5n:J.1V.2c(QB.1d.2f.2l.rY,{47:47,1g:1g})}},kH:1a(){if(QB.1d.5G.cu==""||QB.1d.5G.cu=="Yp"){1b 1c}K bM="#qb-ui-oP-Yo-"+QB.1d.5G.cu;K $gb=$(bM);if($gb.1e){if(1K(QB.1d.5G.eP[bM])){K 8S={};8S[" OK "]=1a(){$(J).2D("[1z]").2g(1a(i,2j){K $2j=$(2j);K 9N=$2j.1k("1z");K mB=$2j.cL();if(mB!=1c){QB.1d.5G.9b[9N]=mB}});$(J).3i("5r");QB.1d.5G.Dc();QB.1d.2k.61()};8S[QB.1d.2d.58.HE.eb]=1a(){$(J).3i("5r")};QB.1d.5G.eP[bM]=$gb.3i({t7:1j,5I:1j,w6:1o,4j:sX,fu:wd,8Z:Yj,1r:"Gb",6K:1a(e,ui){K $3i=$(e.3m);1n(K BD in QB.1d.5G.9b){K H2=QB.1d.5G.9b[BD];K 5K=$3i.2D("[1z="+BD+"]");1n(K i=0;i<5K.1e;i++){K $2j=$(5K[i]);$2j.cL(H2)}K H0=$(\'29[1z^="Ye"]\',$gb);H0.2g(1a(){J.2x=QB.1d.5G.9b.Yd})}},8S:8S})}}1b QB.1d.5G.eP[bM]},k0:1a(6Q){if(6Q==1c||6Q.1e==0){1b 1c}K 1F={};K 4R;1n(K i=0;i<6Q.1e;i++){4R=6Q[i];if(4R.3S!=1c&&4R.3S.79(0,1)=="-"){1F[4R.cK+i]=4R.3S}1i{1F[4R.cK]={1z:4R.3S,3L:4R.cK+(4R.Av?" 3B":""),1F:J.k0(4R.2P),1h:4R.3h,1q:4R.cK}}}1b 1F},eY:1a(1T){K me=J;if(J.AC){1b}if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.k0(1T.2P);$.2M("69","#qb-ui-1V");$.2M({3T:"#qb-ui-1V",4j:cG,Yc:{6O:0},1Z:1a(47,1x){K 1g=1c;7D{1g=1x.$1Q.1h().2M.1F[47]}7C(e){}me.GW(47,1g,1x)},1F:1F})},F6:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}if(J.AA){1b}K 3T="#qb-ui-1V-7B 43 1G, #qb-ui-1V-7B .1W-3l";K 1F=J.k0(1T.2P);$.2M("69",3T);$.2M({3T:3T,4j:cG,6M:{6O:0},9z:1a($2c,e){K me=$2c.1h("me");if(2L me=="2O"){1b}K 1g=1F["6k-2s"];if(1g){1g.1z=QB.1d.2d.58.5m.Au.3f("{0}","<oQ>"+me.4U.1M.4q.6G+"</oQ>");if(me.4U.4A==1R.7p.bW){1g.3L=1g.1q}1i{1g.3L=1g.1q+" 3B"}}1g=1F["6k-to"];if(1g){1g.1z=QB.1d.2d.58.5m.Au.3f("{0}","<oQ>"+me.4T.1M.4q.6G+"</oQ>");if(me.4T.4A==1R.7p.bW){1g.3L=1g.1q}1i{1g.3L=1g.1q+" 3B"}}1b{1F:1F}},1Z:1a(47,1x){K me=J.1h("me");if(me){me.jY(47)}},1F:1F})},F5:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}if(J.Aw){1b}K 3T=".qb-ui-1M";K 1F=J.k0(1T.2P);$.2M("69",3T);$.2M({3T:3T,4j:cG,6M:{6O:0},1Z:1a(47,1x){K me=J.1h("me");if(me){me.jY(47)}},1F:1F})},7I:1a(){K me=J;K Am="qb-ui-1V-7B";J.1V=$("#qb-ui-1V");J.nh=J.1V.4D("nh");J.sT=J.1V.4D("sT");J.kA=J.1V.4D("kA");J.rS=J.1V.4D("rS");J.s9=J.1V.4D("s9");J.rF=J.1V.4D("rF");J.sa=J.1V.4D("sa");J.Aw=J.1V.4D("Aw");J.AA=J.1V.4D("AA");J.AC=J.1V.4D("AC");if(!J.1V.1e){1b 1c}J.6H=1o;J.6h=$("#"+Am);J.r=bf(Am,J.6h.1L().1r(),J.6h.1L().1y());K cI=J.1V.1k("cI");if(!1K(cI)){$.ui.6V.2S.1x.cI=cI}K ek=J.1V.1k("ek");if(!1K(ek)){$.ui.6V.2S.1x.ek=ek}J.1V.3I(1a(e){K iD=26;if(e.8e.id=="qb-ui-1V"||e.8e.68=="43"){K An=$(J).2y();K x=e.6T-An.2a;K y=e.7o-An.1O;if(x>=J.nR-iD&&y<iD){me.oV()}}});$("#qb-ui-1V-7B").3I(1a(e){K iD=26;if(e.3m.id=="qb-ui-1V-7B"||e.3m.68=="43"){K x=!1K(e.Ip)?e.Ip:e.Yf;K y=!1K(e.It)?e.It:e.Yh;if(x>=J.nR-iD&&y<iD){me.oV()}}});J.1V.bU({sk:"qb-ui-1V-6D",Ad:".qb-ui-1V-bU",d4:"9c",Ac:1a(e,ui){if(ui.4z.4D("qb-ui-3X-2j-4z")){K 1D=ui.4z.1h("1D");K hE=ui.4z.1h("hE");K dJ=3N.ft(ui.4z[0],3N.ft(J));$(J).2c(QB.1d.2f.2l.s0,{1M:hE,2j:1D,8W:[dJ.2a,dJ.1O]})}1i{K CH=$(J);K 1D=ui.4z.1h("1D");K dJ=3N.ft(ui.4z[0],3N.ft(J));if(dJ.2a<0){dJ.2a=0}if(dJ.1O<0){dJ.1O=0}K sJ={1D:1D,8W:[dJ.2a,dJ.1O]};$(J).2c(QB.1d.2f.2l.s8,sJ)}}});J.tT=$.AG(J.71,93,J);J.fU=$.AG(J.dp,5,J);J.FP=$.hn(J.dp,kI,J);J.1V.om(1a(){me.fU()});$(3P).71(1a(){me.fU()});J.71();1b J},dp:1a(){if(J.1V==1c||J.1V.1e==0){1b 1c}QB.1d.2f.74.iT();if(ik===2O){1b}J.tT()},tT:1a(){},fU:1a(){},FP:1a(){}};QB.1d.2f.2l={s8:"s8",xD:"xD",rZ:"rZ",FU:"FU",s0:"s0",rY:"rY"};QB.1d.2f.74={4X:[],t4:1a(1N){K 1W=1S QB.1d.2f.bs(1N);QB.1d.2f.74.1C(1W);1b 1W},zz:1a(1W,1N){1W.1N(1N)},iT:1a(){if(!QB.1d.2f.6H){1b 1c}$.2g(J.4X,1a(1P,1W){1W.iT()})},1C:1a(1u){J.4X.1C(1u)},XF:1a(1W){1n(K i=0;i<J.4X.1e;i++){if(J.4X[i].1W==1W){1b J.4X[i]}}1b 1c},zG:1a(G2,G1){1n(K i=J.4X.1e-1;i>=0;i--){K 1W=J.4X[i];if(1W.4U&&1W.4T){if(1W.4U.aC==G2&&1W.4T.aC==G1){1b J.4X[i]}}}1b 1c},Xy:1a(6h){1n(K i=0;i<J.4X.1e;i++){if(J.4X[i].6h==6h){J.iy(i);1p}}},FV:1a(7f){1n(K i=J.4X.1e-1;i>=0;i--){K 1W=J.4X[i];if(1W.4U!=1c&&1W.4T!=1c){if(1W.4U.cq==7f||1W.4T.cq==7f){J.iy(i)}}}},3u:1a(1W){if(1W===2O){1b}if(1W==1c){1b}1n(K i=0;i<J.4X.1e;i++){if(J.4X[i]==1W){J.iy(i);1p}}1W=1c},Xt:1a(){1n(K i=J.4X.1e-1;i>=0;i--){J.iy(i)}},zD:1a(){1n(K i=J.4X.1e-1;i>=0;i--){if(J.4X[i].su){J.iy(i)}}},iy:1a(1P){K 1W=J.4X[1P];if(1W.6h!=1c){J.oo(1W.6h.bO);J.oo(1W.6h.bg);J.oo(1W.6h.2J);J.oo(1W.6h.4x);41 1W.6h}41 1W;J.4X.5f(1P,1)},Fu:1a(7f){K 1J=[];1n(K i=J.4X.1e-1;i>=0;i--){K 1W=J.4X[i];if(1W.4U!=1c&&1W.4T!=1c){if(1W.4U.cq==7f||1W.4T.cq==7f){1J.1C(1W)}}}1b 1J},Xs:1a(4X){if(4X==1c){1b 1j}if(4X.1e==0){1b 1j}J.zP();1n(K 1P=0;1P<4X.1e;1P++){K 9w=4X[1P];K d5=1c;if(9w.4U!=1c&&9w.4T!=1c){d5=J.zG(9w.4U.aC,9w.4T.aC)}if(d5==1c){J.t4(9w)}1i{d5.su=1j;J.zz(d5,9w)}}J.zD()},zP:1a(){1n(K i=J.4X.1e-1;i>=0;i--){J.4X[i].su=1o}},oo:1a(1u){if(1u){if(1u.3u){1u.3u();1u=1c}}}};QB.1d.2f.AH=1a(1N){J.2j=1c;J.1M=1c;J.1N=1a(2h){if(2h===2O){K 1N=1S QB.1d.2d.Fo;3N.FE(J,1N);1b 1N}1i{J.1M=1c;J.2j=1c;3N.j7(2h,J);J.AN()}};J.AN=1a(){if(1K(J.1M)){J.1M=QB.1d.2f.FF(J.cq)}if(1K(J.2j)){J.2j=QB.1d.2f.Fx(J.1M,J.aC);if(J.2j==1c){J.2j={};J.2j.1f=QB.1d.2f.Fz(J.1M)}}};J.lV=1a(fr){if(fr[J.cq]){J.1M=1c;J.cq=fr[J.cq]}if(fr[J.aC]){J.2j=1c;J.aC=fr[J.aC]}J.AN()};if(1N!=1c){J.1N(1N)}};QB.1d.2f.bs=1a(1N){if(!QB.1d.2f.6H){1b 1c}K me=J;J.fq="";J.7Z=1j;J.6U=1N.6U==1o;J.4U=1S QB.1d.2f.AH;J.4T=1S QB.1d.2f.AH;J.6h=1c;J.id=3N.sj();J.Gj=1a(6t){if(me.6h!=1c){1b}me.6h=QB.1d.2f.6H?QB.1d.2f.r.GF(me,"#Xr|2"):1c};J.iT=1a(){if(QB.1d.2f.6H){QB.1d.2f.r.GA(me)}};J.jY=1a(47){K d9=1j;3q(47){1l"6k-2s":me.4U.4A=1R.7p.cA(me.4U.4A);d9=1o;1p;1l"6k-to":me.4T.4A=1R.7p.cA(me.4T.4A);d9=1o;1p;1l"41":me.7Z=1o;d9=1o;1p;1l"ea":K 3i=$("#1W-ea-3i");K oK=me.4U.2j.1D;K oW=me.4T.2j.1D;K o4=me.4U.1M.4q;K mf=me.4T.1M.4q;$("29[1z=2s-1D]",3i).2h(o4.6G);$("29[1z=to-1D]",3i).2h(mf.6G);$("29[1z=2s-1D-2n]",3i)[0].3B=me.4U.4A==1R.7p.dr;$("29[1z=to-1D-2n]",3i)[0].3B=me.4T.4A==1R.7p.dr;$("29[1z=1D-3g-29]",3i).2h(1R.GP(me.fq,oK,o4,oW,mf));K 8S={};8S[" OK "]=1a(){me.4U.4A=$("29[1z=2s-1D-2n]",3i).cL()?1R.7p.dr:1R.7p.bW;me.4T.4A=$("29[1z=to-1D-2n]",3i).cL()?1R.7p.dr:1R.7p.bW;me.fq=$("29[1z=1D-3g-29]",3i).2h();K 1f=me.6h.1G[0];$("#qb-ui-1V-7B").2c(QB.1d.2f.bs.2l.kz,me);QB.1d.2f.dp();$(J).3i("5r")};8S[QB.1d.2d.58.G7.eb]=1a(){$(J).3i("5r")};3i.3i({5I:1j,4j:BV,fu:wd,1r:"Gb",w6:1o,8S:8S});1p}if(d9){K 1f=me.6h.1G[0];$("#qb-ui-1V-7B").2c(QB.1d.2f.bs.2l.kz,me)}QB.1d.2f.dp()};J.Gs=1a(){K 1N=1S QB.1d.2d.Gp;1N.4U=J.4U.1N();1N.4T=J.4T.1N();1N.7Z=J.7Z;1N.6U=J.6U;1N.fq=J.fq;1b 1N};J.Gl=1a(1N){J.4U.1N(1N.4U);J.4T.1N(1N.4T);J.7Z=1N.7Z;J.6U=1N.6U;J.fq=1N.fq};J.1N=1a(2h){if(2h===2O){1b J.Gs()}1i{J.Gl(2h)}};J.lV=1a(fr){J.4U.lV(fr);J.4T.lV(fr)};J.7I=1a(){J.1N(1N);J.Gj();K BU=$(J.6h.bg.1s);BU.1h("me",J);BU.nl()};J.7I()};QB.1d.2f.bs.2l={kz:"kz"};QB.1d.7h=1a(){J.XP=10;J.3X=1c;J.lb=1j;J.9V=1S 3Y;J.1F=1S 3Y;J.dg=J.1F;J.4s="";J.gE=6;J.cN=24;J.mk=3;J.rC=$("#qb-ui-3X-1F");J.C0=$("#qb-ui-3X-1g-u8-7F");J.o0=0;J.hg=1j;J.C4=0;J.d8=1;J.I2=1j;J.tx=1a(){K me=J;K n0=1S 3Y;n0.1C("<ul>");J.rC.42("");if(!1K(J.dg)){K 6x=J.dg.1e;K 2J=3F.5U((J.d8-1)*J.cN,6x);K 4x=3F.5U(J.d8*J.cN,6x);K n5="";1n(K i=2J;i<4x;i++){K 1g=J.dg[i];K pf=i+1==4x?" 6Z":"";if(1g!=1c){K Cc=J.Gg?\'<br><2E 2C="HG">\'+1g.sm+"</2E>":"";K Gu=QB.1d.2d.58.5m.iY+" "+1g.nL;K 1z=1g.nL.3f(/ /g,"&2r;");K 2E=\'<2E 67="0" 2C="qb-ui-1V-bU 1M" 5t-3x="\'+Gu+\'">\'+1z+"</2E>";if(!J.lb){n5=\'<li 2C="qb-ui-1D qb-ui-1D-1M\'+pf+\'" id="qb-ui-3X-1g-\'+i+\'">\'+2E+Cc+"</li>"}1i{K mY="";K BW="";K 2j=1c;K BZ="";1n(K j=0;j<1g.6j.1e;j++){2j=1g.6j[j];BZ="<2E 2C=\'2j\'>"+2j.sl.3f(/ /g,"&2r;")+"</2E>";K Gi=j+1==1g.6j.1e?" 6Z":"";BW=\'<li 2C="qb-ui-1D-2j qb-ui-3M-bU qb-ui-1V-bU GE\'+Gi+\'" id="qb-ui-3X-1g-2j-\'+j+\'">\'+BZ+"</li>";mY+=BW}mY=\'<ul 2C="qb-ui-3X 70">\'+mY+"</ul>";n5=\'<li 2C="qb-ui-1D qb-ui-1D-1M aH GE\'+pf+\'" id="qb-ui-3X-1g-\'+i+\'">\'+"<2F 2C=\\"4o qb-ui-1D-4o qb-ui-1D-1M-4o aH-4o\\" XO=\\"$J = $(J); if ($J.4D(\'bG-4o\')) { $J.1L().8M(\'bG\');$J.1L().8M(\'aH\'); $J.8M(\'bG-4o\'); $J.8M(\'aH-4o\'); $(\'~ul\', $(J)).3J(); } 1i {$J.1L().8M(\'bG\');$J.1L().8M(\'aH\'); $J.8M(\'bG-4o\'); $J.8M(\'aH-4o\'); $(\'~ul\', $(J)).5e(); }\\"></2F>"+2E+Cc+mY+"</li>"}}1i{n5=\'<li 2C="qb-ui-1D qb-ui-1D-1M\'+pf+\'" id="qb-ui-3X-1g-\'+i+\'">\'+\'<2E 2C="1M">\'+QB.1d.2d.58.5m.tF+"</2E></li>"}n0.1C(n5)}}n0.1C("</ul>");J.rC.42(n0.4H(""));J.vv();J.FK();$("#qb-ui-3X-1g-6X").wH()};J.HM=1a(1h){K im=$("#qb-ui-3X-9V");im.42("");J.9V=1S 3Y;1n(K i=0;i<1h.jw.1e;i++){K 8p=1h.jw[i];K e4=J.Hh(i+1,8p);e4.1h("1w",8p.4A);e4.1h("7f",8p.3h);K je=e4.cL();K C7=1S 3Y;K bQ=-1;1n(K j=0;j<8p.mZ.1e;j++){K 2T=8p.mZ[j];if(bQ==-1&&(!1K(je)&&fa(2T.mH,je))){bQ=j}if(bQ==-1&&2T.eD){bQ=j}}if(bQ==-1){bQ=0}1n(K j=0;j<8p.mZ.1e;j++){K 2T=8p.mZ[j];K 2x="";if(2T.rJ==1o){2x=" 2x"}K 1Q="";if(bQ==j){1Q=" 1Q"}C7.1C(\'<2T 1m="\'+2T.mH+\'"\'+2x+1Q+">"+2T.9P+"</2T>")}e4.42(C7.4H(""));e4.3j();J.9V.1C(e4)}};J.hW=1a(1h){if(1h==1c||1h===2O){1b}K me=J;J.o0=1h.oX;J.I2=1h.I0==1o;J.hg=1j;K lY=1j;if(1h.jZ!=""&&(1h.jZ!=2O&&1h.jZ!=1c)){lY=1o;J.hg=1o}if(1h.tM==0){J.d8=1;J.HM(1h);J.1F=[];if(1h.2P.1e!=1h.oX){J.hg=1o}}K Il=1h.2P.1e;K HR=1h.tM;K HS=1h.oX;1n(K jM=HR,oY=0;jM<HS;jM++,oY++){if(oY<Il){J.1F[jM]=1h.2P[oY]}1i{if(J.1F[jM]==2O){J.1F[jM]=1c;J.hg=1o}}}J.Cd(lY);J.tx();J.Eu()};J.Gt=1a(){if(J.1F.1e<J.o0){1b 1o}K 2J=3F.4y(0,(J.d8-1)*J.cN);K 4x=3F.5U(J.o0,J.d8*J.cN);1n(K i=2J;i<4x;i++){if(J.1F[i]==1c){1b 1o}}1b 1j};J.Hh=1a(i,8p){K im=$("#qb-ui-3X-9V");K id="qb-ui-3X-9V-2n-"+i;K 1f=$("#"+id);if(1f.6x){1b 1f}K me=J;K 42=$(\'<2F 2C="qb-ui-3X-9V-6X XS-\'+i+" 2n-1w-"+8p.4A+\'">                         <2F 2C="qb-ui-3X-9V-3x"></2F>                         <2F 2C="qb-ui-3X-9V-2n">                             <2n id="\'+id+\'"></2n>                         </2F>                     </2F>\');im.3a(42);1f=$("#"+id);1f.1h("1P",i);1f.1h("7f",8p.3h);1f.4N("dD",me.DW,me);1f.4N("XN",me.EX,me);1b 1f};J.tN=1a(C2){K Dw=$("#qb-ui-3X-9V");K 9V=$("2n",Dw);K C6=[];9V.2g(1a(i,s){K 8p=1S QB.1d.2d.DG;8p.Dk=s.1m;if(!1K(C2)){8p.Dh=s.id==C2.id}8p.4A=$(s).1h("1w");8p.3h=$(s).1h("7f");C6.1C(8p)});1b C6};J.XH=1a(2n,1x){K me=J;K 1f=2n[0];1n(K i=0;i<1f.1x.1e;i++){K 2T=1f.1x[i];K dm=1S QB.1d.2d.Cb;dm.mH=2T.1m;dm.9P=2T.1Y;dm.eD=2T.1Q;1x.1C(dm)}};J.XG=1a(2n,1x){K me=J;K 1f=2n[0];1n(K i=0;i<1f.1x.1e;i++){K 2T=1f.1x[i];K dm=1S QB.1d.2d.Cb;dm.mH=2T.1m;dm.9P=2T.1Y;dm.eD=2T.1Q;1x.1C(dm)}};J.Fl=1a(){J.4s=$("#qb-ui-3X-1g-4s-29").2h()};J.Gy=1a(e){$("#qb-ui-3X-1g-4s-29").2h("");J.4s="";J.s7(e)};J.Cd=1a(lY){K oB=1c;K ov=!1K(J.4s);if(ov){7D{oB=1S dl(J.4s,"i")}7C(e){oB=1c;ov=1j}}if(!ov||lY){J.dg=J.1F;J.C4=J.o0}1i{if(!1K(J.1F)){J.dg=1S 3Y;1n(K i=0;i<J.1F.1e;i++){K 1g=J.1F[i];if(1g==1c){J.C3();1b}if(!oB.9r(1g.nL)){ag}J.dg.1C(1g)}}}};J.GO=1a(e){if(e.3H==13){e.7L();1b 1j}if(J.hg){J.Fr(e)}1i{J.s7(e)}};J.GQ=1a(e){if(e.3H==13){e.7L();1b 1j}};J.s7=1a(e){J.d8=1;J.4s=e.8e.1m;if(!J.hg){J.Cd();J.tx()}1i{J.C3()}};J.tH=1a(){J.rC.42("");J.C0.5e()};J.Eu=1a(){J.C0.3J()};J.C3=1a(){J.tH();K 1h=QB.1d.2k.49;1h.7h=1S QB.1d.2d.kC;1h.7h.jw=J.tN();1h.7h.cc="4u";1h.7h.jZ=J.4s;QB.1d.2k.61()};J.Gr=1a(){J.tH();K 1h=QB.1d.2k.49;1h.7h=1S QB.1d.2d.kC;1h.7h.jw=J.tN();1h.7h.cc="4u";1h.7h.jZ=J.4s;1h.7h.tM=(J.d8-1)*J.cN;QB.1d.2k.61()};J.DW=1a(e){K me=J;K 1P=$(e.8e).1h("1P");K 1h=QB.1d.2k.49;1h.7h=1S QB.1d.2d.kC;1h.7h.jw=J.tN(e.3m);J.DQ(1P);QB.1d.2k.61()};J.DQ=1a(1P){1n(K i=1P;i<J.9V.1e;i++){K e4=J.9V[i];e4.42("<2T>tF...</2T>")}J.tH()};J.EX=1a(){};J.vv=1a(){K me=J;$(".qb-ui-1D>2E").6W({2I:0.8,4p:"3U",Hg:"u0",2J:1a(1H,ui){$(ui.4z).2Z("jz-2a",1H.aB-$(1H.3m).2y().2a-$(ui.4z).1r()/2);$(ui.4z).2Z("jz-1O",1H.aT-$(1H.3m).2y().1O-10)},4z:1a(e){K 1f=e.8e.3n;K tk=1f.id.79("qb-ui-3X-1g-".1e);K 1g=me.dg[tk];K 4z=$("<2F ></2F>");1g.6U=1o;4z.6V({1D:1g,4j:BV});4z.2t("qb-ui-1V-bU");1b 4z[0]}});$(".qb-ui-1D-2j").6W({2I:0.8,4p:"3U",Hg:"u0",4z:1a(e){K 1f=e.8e;K tk=1f.id.79("qb-ui-3X-1g-2j-".1e);K Hb=$(1f).cB("li");K HI=Hb.1k("id").79("qb-ui-3X-1g-".1e);K tp=me.dg[HI];if(tp==1c){1b}K 1g=tp.6j[tk];if(1g==1c){1b}K 4z=$(\'<2E 2C="qb-ui-3X-2j-4z qb-ui-3M-bU qb-ui-1V-bU">\'+1g.88.3f(/ /g,"&2r;")+"</2E>");4z.1h("1D",1g);4z.1h("hE",tp);1b 4z[0]}});$(".4o",J.3X).3I(1a(e){})};J.FK=1a(){K me=J;K 6x=3F.jU(J.C4/J.cN);K 1f=$("#qb-ui-3X-1g-XT-6X");if(6x<=1){1f.42("");1b}1f.te({6x:6x,2J:J.d8,5q:me.gE,f8:1j,kf:"#XU",kh:"3t",jV:"#XR",jW:"3t",BY:1o,ts:"Go",mR:1a(xR){me.d8=5W(xR);me.Gk();me.tx()}})};J.Gk=1a(){if(!J.Gt()){1b}J.Gr()};J.Lq=1a(){K me=J;K 1f=$(".qb-ui-3X");J.lb=1f.4D("lb");J.Gg=1f.4D("Xu");if(1f.1k("GL")!=""){J.cN=1f.1k("GL")}if(J.cN<=0||J.cN==""){J.cN=24}if(1f.1k("GT")!=""){J.mk=1f.1k("GT")}if(J.mk<=0||J.mk==""){J.mk=3}K AJ=1f.1k("gE");if(AJ!=""){7D{K gE=5W(AJ);if(gE>0){J.gE=gE}}7C(e){}}$("#qb-ui-3X-1g-4s-29").4N("wz",me.GO,me);$("#qb-ui-3X-1g-4s-29").4N("7U",me.GQ,me);$("#qb-ui-3X-1g-4s-af").4N("3I",me.Gy,me);1a bS(1f){K FG=1f.id.79("qb-ui-3X-1g-".1e);K 1g=me.dg[FG];me.3X.2c(QB.1d.7h.2l.sd,1g)}$(2N).on("wN","#qb-ui-3X-1F .qb-ui-1D 2E",1a(e){if($(e.8e).4D("2j")){1b 1j}bS(e.8e.3n)});$(2N).on("7U","#qb-ui-3X-1F .qb-ui-1D 2E",1a(e){if(e.3H==13){bS(e.8e.3n)}});J.Fl();J.3X=1f;1b 1f};J.Fr=$.hn(J.s7,kI,J);1b J.3X};QB.1d.7h.2l={FI:"FI",sd:"sd"};QB.1d.wk=1a(2j,6Y,sg,1x){K me=J;J.gF=1R.gB.gm;J.1D=2j;J.1M=sg;J.1L=6Y;J.3B=2j.eD;J.1f=$(\'<tr 67="-1" />\').2t("qb-ui-1M-2j 8O").1h("J",J).1h("1D",2j).1h("1M",sg).1h("f3",2j.3h).1h("1L",6Y).1h("t9",6Y.3h);3N.wM(J.1f,QB.1d.2d.58.5m.gm+" "+2j.88);if(2j.88=="*"){J.1f.2t("qb-ui-1M-2j-g3")}J.t8=$(\'<29 1w="7W" 1m="1" 67="-1" \'+(2j.eD?" 3B":"")+"/>").3I(1a(){me.3B=J.3B;sg.rE([me])});J.1f.7U(1a(e){3q(e.3H){1l 13:;1l 32:me.t8.2c("3I");e.4g()}});J.BF=$(\'<2E 2C="qb-ui-1M-2j-3L"></2E>\');if(2j.nN){J.BF.2t("qb-ui-1M-2j-3L-pk")}K lw=1x.Ap;K lz=1x.Ao;K BO=1x.Ai;K sU=1x.rW;K sQ=1x.nM;J.Hk=$(\'<2E 2C="qb-ui-1M-2j-2n">\'+lw.b7+"</2E>").2t(QB.1d.2f.sa?"70":"").3a(J.t8);J.9N=$(\'<2E 2C="qb-ui-1M-2j-1z">\'+lz.b7+2r(2j.sl)+lz.cE+"</2E>").2t(QB.1d.2f.s9?"70":"");J.Hu=$(\'<2E 2C="qb-ui-1M-2j-1w">\'+(2j.88!="*"&&2j.Al!="1c"?sU.b7+2j.Al+1x.rW.cE:"")+"</2E>").2t(QB.1d.2f.rF?"70":"");J.D1=$(\'<2E 2C="qb-ui-1M-2j-HG">\'+lw.b7+(sQ.sH?2j.wh:2r(2j.wl))+1x.nM.cE+"</2E>").2t(QB.1d.2f.rS?"70":"");K 5Q=[];5Q.1C({31:J.BF,84:-1,7H:1o});5Q.1C({31:J.Hk,84:lw.84,7H:lw.7H});5Q.1C({31:J.9N,84:lz.84,7H:lz.7H});5Q.1C({31:J.Hu,84:sU.84,7H:sU.7H});5Q.1C({31:J.D1,84:sQ.84,7H:sQ.7H});5Q.sB("84");K 7G;if(BO){7G=me.1f}1i{7G=$("<td Yq />");7G.4p(me.1f)}1n(K i=0;i<5Q.1e;i++){K 7w=5Q[i];if(BO){7G.3a($("<td td"+(i+1)+\'" />\').3a(7w.31))}1i{7G.3a(7w.31)}}J.fb=1a(1m){J.3B=1m;J.t8[0].3B=J.3B};J.6v=1a(){K 53={x:0,y:0,1r:0,1y:0};K o=J.1f;K BR=ft(QB.1d.2f.1V[0]);K fs=ft(o,BR);K 1L=o;do{if(1L.68.8u()=="DE"){1L=1L.3n;if(1L){1L=1L.3n}1p}1L=1L.3n}44(1L!=1c);K fK=fs;if(1L!=1c){fK=ft(1L,BR)}if(fs.1O<fK.1O){53.y=fK.1O}1i{if(fs.1O>fK.4G-fs.1y/2){53.y=fK.4G-fs.1y/2}1i{53.y=fs.1O}}53.1y=fs.1y;53.1r=fK.1r;53.x=fK.2a;1b 53}};QB.1d.wk.2l={DH:"DH"};K B1=20;QB.1d.9y=1a(){J.31=$("#qb-ui-1V-dW");J.1T=1c;K gw=J;K gq=J.31;K ki=0;K kX=0;K jB=0;J.F8=1a(9S){if(J.31.1k("Do")&&J.31.1k("Do").3R()=="1j"){1b}K $4b=$("#qb-ui-1V-dW-9J");if(!$4b){1b}K $9C=[];1n(K i=0;i<9S.2P.1e;i++){K 1g=9S.2P[i];K 1Y=1g.9P;if(1K(1Y)){1Y="&2r;"}K $1f=$(\'<2F 2C="31" id="qb-ui-1V-dW-9J\'+(i+1)+\'">\'+1Y+"</2F>").2t(1g.gY);$1f.3C();if(1g.dn){$1f.2t("ui-56-ad");$1f.1k("67",-1)}1i{$1f.1k("67",0);$1f.7U(1a(e){if(e.3H==32||e.3H==13){$(e.3m).2c("3I")}})}$1f.1h("1g",1g);$1f.3I(1a(e){K $1f=$(e.8e);if($1f.1h("Cj.fv")){1b}K 1g=$1f.1h("1g");if(1g&&1g.cc){QB.1d.5G.t6(1g.cc)}1i{$("#"+$1f[0].id).2M()}if(1g&&1g.dn){$1f.2t("ui-56-ad");e.4g();1b 1j}});$1f.6D(1a(e){K $1f=$(e.8e);K 1g=$1f.1h("1g");if(1g&&1g.dn){$1f.2t("ui-56-ad");e.4g();1b 1j}});$1f.4P(1a(e){K $1f=$(e.8e);K 1g=$1f.1h("1g");if(1g&&1g.dn){$1f.2t("ui-56-ad");e.4g();1b 1j}});$1f.nl();J.JU($1f,1g.f9);$9C.1C($1f)}$4b.c0();$gq=$(\'<2F id="qb-ui-1V-dW-9J-gq">\');$gq.4p($4b).3a($9C)};1a tz(8s,4J){if(8s<0){8s=0}1i{if(8s>jB){8s=jB}}Cm(8s)}1a Cm(8s){if(8s===2O){8s=Ym.2G().2a}Bu=8s;K Y1=Bu===0,Y3=Bu==jB,ji=8s/jB,CT=-ji*(ki-kX);gq.2Z("2a",CT)}1a ua(){1b-gq.2G().2a}1a Zw(lM,lA,bl){1b 1a(){Ea(lM,lA,J,bl);J.4P();1b 1j}}1a Ea(lM,lA,b0,bl){b0=$(b0).2t("JH");K 2Q,kJ,Bj=1o,Bn=1a(){if(lM!==0){gw.vW(lM*30)}if(lA!==0){gw.w1(lA*30)}kJ=6y(Bn,Bj?sC:50);Bj=1j};Bn();2Q=bl?"dL.gw":"5u.gw";bl=bl||$("42");bl.2B(2Q,1a(){b0.4h("JH");kJ&&jh(kJ);kJ=1c;bl.7V(2Q)})}J.AU=1a(6Q){if(6Q==1c||6Q.1e==0){1b 1c}K 1F={};K 4R;1n(K i=0;i<6Q.1e;i++){4R=6Q[i];K 1q=4R.cK;if(4R.3S!=1c&&4R.3S.79(0,1)=="-"){1F[1q]=4R.3S}1i{1F[1q]={1z:4R.3S,3L:1q+(4R.Av?" 3B":""),1F:J.AU(4R.2P),1h:4R}}}1b 1F};J.JU=1a($1f,1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.AU(1T.2P);K 3T="#"+$1f[0].id;$.2M("69",3T);$.2M({3T:3T,4j:cG,6M:{6O:0},1F:1F,1Z:1a(47,1x){K 4R=1x.1F[47].1h;me.tV(47,4R)}});$.2M.kg.Vh=1a(1g,1B,2p){J.on("7U",1a(e){})}};J.tV=1a(1q,1g){K 47=1c;if(1g!=1c&&2L 1g.cc!="2O"){47=1g.cc}J.31.2c(QB.1d.9y.2l.rK,47)};J.AL=1a(s){if(s==1c){1b s}if(s.1e<=B1){1b s}1b s.79(0,B1)+"&V3;"};J.Lg=1a(1L){K 1F=[];$.2g(1L.2P,1a(1P,1g){if(!1g.7H){1b}if(1g.dn){1b}1F.1C(1g)});1b 1F};J.Le=1a(1L){K eK=1c;$.2g(1L.2P,1a(1P,1g){if(1g.dn){eK=1g}});1b eK};J.AR=1a($3C){$3C.1k("67",0);$3C.7U(1a(e){if(e.3H==32||e.3H==13){$(e.3m).2c("3I")}})};J.AP=1a(1g,2x){K me=J;K 3L="ui-3L-qb-"+1g.5X;K $3C=$(\'<2F 2C="eW">\'+J.AL(1g.6G)+"</2F>").1h("vz",1g.3h).1h("eM",1g.eM).3C({2x:2x,b9:{s4:3L}}).3I(1a(e){me.BX(e)});if(2x){$3C.2t("ui-56-ad").2t("ui-56-6D")}1i{J.AR($3C)}1b $3C};J.LH=1a(1F){K me=J;K $ul=$("<ul/>");$.2g(1F,1a(1P,g7){K 3L="ui-3L-qb-"+g7.5X;K $3C=$(\'<li><a 5d="#"><2E 2C="ui-3L \'+3L+\'"></2E>\'+me.AL(g7.6G)+"</a></li>").1h("vz",g7.3h).1h("eM",g7.eM);$ul.3a($3C)});$ul.1T({2n:1a(e,ui){$ul.3J();me.BX(e)}});1b $ul};J.C9=1a(1g,1L){K me=J;K 9J=[];if(1g==1c){1b 9J}K 1F=J.Lg(1g);K eK=J.Le(1g);K LS=eK===1c;K $3C=J.AP(1g,LS);9J.1C($3C);if(1F.1e>0){if(eK!=1c){K $AO=$("<2F>&2r;</2F>").3C({1Y:1j,b9:{s4:"ui-3L-ie-1-s"}}).3I(1a(e){if(me.1T!=1c){me.1T.3J()}me.1T=$(J).3k().5e().2G({my:"2a 1O",at:"2a 4G",of:$(J).UT(".ui-3C")[0]});$(2N).LU("3I",1a(){me.1T.3J()});1b 1j});J.AR($AO);9J.1C($AO);K $ul=J.LH(1F);9J.1C($ul)}1i{$3C.3C("2T","b9.vu","ui-3L-ie-1-e");$.2g(1F,1a(1P,g7){9J.1C(me.AP(g7))})}}1i{if(eK!=1c){$3C.3C("2T","b9.vu","ui-3L-ie-1-e")}}if(eK!=1c){9J=9J.3w(J.C9(eK,1g))}1b 9J};J.BX=1a(e){K $1f=$(e.8e);K 9f=$1f.1h("eM");if(!1K(9f)){J.31.2c(QB.1d.9y.2l.sR,9f)}1b 1j};J.F1=1a(bV){K me=J;K $31=$("#qb-ui-1V-dW-UY-4b");if(bV!=1c&&bV.2P!=1c){$31.c0();K $1F=me.C9(bV);$31.3a($1F);K KB=$("<2F id=\'qb-ui-1V-eW-lN-3C\'>+</2F>").3C();$31.3a(KB);$31.UZ({1F:"3C, 29[1w=3C], 29[1w=V0], 29[1w=kF], 29[1w=7W], 29[1w=8q], :1h(ui-3C)"});$31.2D("ul").1k("67",-1);$31.2D("a").1k("67",0)}1b $31};$.4m(J,{US:1a(s){s=$.4m({},3W,s);Vf(s)},L0:1a(bl,KG,4J){L0(bl,KG,4J)},Vj:1a(8s,jy,4J){tJ(8s,4J);tW(jy,4J)},tJ:1a(8s,4J){tJ(8s,4J)},tW:1a(jy,4J){tW(jy,4J)},Vg:1a(KH,4J){tJ(KH*(ki-kX),4J)},UL:1a(Kg,4J){tW(Kg*(u1-vp),4J)},vX:1a(lB,lC,4J){gw.vW(lB,4J);gw.w1(lC,4J)},vW:1a(lB,4J){K 8s=ua()+3F[lB<0?"gH":"jU"](lB);K ji=8s/(ki-kX);tz(ji*jB,4J)},w1:1a(lC,4J){K jy=vq()+3F[lC<0?"gH":"jU"](lC),ji=jy/(u1-vp);tc(ji*Lx,4J)},tz:1a(x,4J){tz(x,4J)},tc:1a(y,4J){tc(y,4J)},4J:1a(bl,6J,1m,Ky){K 1v={};1v[6J]=1m;bl.4J(1v,{"6O":3W.W9,"5w":3W.Wk,"jn":1j,"lI":Ky})},Wl:1a(){1b ua()},Wj:1a(){1b vq()},Wp:1a(){1b ki},Wm:1a(){1b u1},Wn:1a(){1b ua()/(ki-kX)},Wa:1a(){1b vq()/(u1-vp)},Wh:1a(){1b We},Vv:1a(){1b Vw},Vt:1a(){1b gq},Vu:1a(4J){tc(Lx,4J)},Vo:$.vi,69:1a(){69()}});1b J};QB.1d.lo=1a(){J.3X=1c;J.lb=1j;J.vt=1a(lr){if(lr==1c||lr.1e<=0){1b 1c}K vB=0;K $1f=$("<ul />");1n(K i=0;i<lr.1e;i++){K 1s=lr[i];if(!1s.7H){ag}vB++;K $li=$("<li />");$li.1h("vz",1s.3h);$li.1h("eM",1s.eM);$li.42(\'<2E 2C="\'+1s.5X+(1s.dn?" ad":"")+\'">\'+1s.6G+"</2E>");$li.3a(J.vt(1s.2P));$1f.3a($li)}if(vB>0){1b $1f}1b 1c};J.wq=1a(bV){K me=J;K 31=$("#qb-ui-3X-vr");if(bV!=1c&&bV.2P!=1c){31.42("");31.3a(me.vt([bV]));K 1f=$("#qb-ui-3X-vr>ul");J.3X=1f.il({});1f.2D("*").wH();$("#qb-ui-3X-vr 2E").3I(1a(){K $1f=1c;K 9f=1c;if(J.im!=1c){$1f=$(J.im);9f=$1f.1h("eM")}if(!1K(9f)){me.3X.2c(QB.1d.lo.2l.sY,9f)}1b 1j})}1b 31};J.vv=1a(){K me=J;$(".4o",J.3X).3I(1a(e){})};$("#qb-ui-1V-dW-lN-3C").3C({b9:{vu:"ui-3L-ie-1-s"}});1b J.3X};QB.1d.lo.2l={sY:"sY"};QB.1d.9y.2l={sR:"sR",rK:"rK"};K ga=1c;QB.1d.7c={4q:1c,1x:{VO:"<2K 2C=\'qb-ui-1M-bq-1Y-lg-1z\'>{lg}</2K>.<2K 2C=\'qb-ui-1M-bq-1Y-1M-1z\'>{1z}</2K>",t7:1o,ey:1j,J6:"",6W:1o,3J:1c,1y:"6p",1r:"6p",6n:5,cl:60,8Z:1j,fu:1j,6H:1o,2G:{my:"2a 1O",at:"2a+15 1O+15",of:"#qb-ui-1V",kV:"3t",VF:1a(3V){K wA=$(J).2Z(3V).2y().1O;if(wA<0){$(J).2Z("1O",3V.1O-wA)}}},5I:1o,5e:1c,VC:1o,66:"",4j:93,ek:VD,cI:"6p"},VI:{v8:"2J.6W",5g:"5g.6W",v1:"5D.6W",8Z:"8Z.5I",6n:"6n.5I",fu:"fu.5I",cl:"cl.5I",My:"2J.5I",71:"5g.5I",MD:"5D.5I"},7G:1c,bw:1c,J7:"qb-ui-1M "+"ui-8F "+"ui-8F-ab "+"ui-aj-6k ",bB:1j,jY:1a(47){K me=J;if(me.4q!=1c&&me.4q.6U){1b 1j}3q(47){1l"fb":me.uN(1o);1p;1l"VG":me.uN(1j);1p;1l"41":me.5r();1p;1l"ea":K 3i=me.kH(me);if(3i!=1c){3i.3i("6K")}1p}},J8:1a(){K me=J;K 5s=".bq-3C.3C-1W";$.2M("69",5s);K 1F={};K cF=1c;1n(K i=0;i<me.4q.lu.1e;i++){K ee=me.4q.lu[i];if(cF==1c){cF=ee.kZ}if(cF!=ee.kZ){1F["5o-"+i]="---------";cF=ee.kZ}1F[ee.6G]={1z:ee.6G,3L:"SJ-1D-cF-"+ee.kZ,1h:ee,bK:ee.rJ?"sb":""}}$.2M({3T:5s,4j:cG,6M:{6O:0},1Z:1a(47,1x){K J3=1x.$1Q.1h().2M.1F[47];me.1f.2c(QB.1d.7c.2l.kN,J3.1h)},1F:1F});1b 5s},Jb:1a(3C){K me=J;K 5s=".bq-3C.3C-1W";if(me.4q==1c){1b}3C.7i(1a(){me.J8();$(5s).2M();K $1T=$(5s).2M("1f");if($1T){$1T.2G({my:"2a 1O",at:"2a 4G",of:J})}})},8O:".8O:6H",J2:".8O:6H:4t",IY:".8O:6H:6Z",sv:1a(89){K me=J;me.5K=[];J.4q=me.1x.1D;J.ed=1j;K 6Y=J.4q;if(J.4q!=1c&&!1K(J.4q.65)){J.65=J.4q.65}1i{J.65=Be()}6Y.65=J.65;$(me.1f).1h("4q",6Y);$(me.1f).1h("me",J);me.1f.2t(J.J7+me.1x.J6).2Z({2G:"8x",4j:me.1x.4j});me.1f.1k("67",0);if(!89){me.1f.2R(1a(e){me.bB=1j})}1a e1(2R){K 1J=1c;if(2R.4D("qb-ui-1M")){1J=2R}1i{1J=2R.3k()}44(1o){if(1J.1e==0){1p}if(1J.is(me.8O)){1b 1J}K 8K=1J.2D(me.J2);if(8K.1e){1b 8K}1J=1J.3k()}K 1L=2R.1L();if(1L.4D("qb-ui-1M")){1b $()}1b e1(1L)}1a dK(2R){K 1J=1c;if(2R.4D("qb-ui-1M")){1J=2R}1i{1J=2R.3O()}44(1o){if(1J.1e==0){1p}if(1J.is(me.8O)){1b 1J}K 8K=1J.2D(me.IY);if(8K.1e){1b 8K}1J=1J.3O()}K 1L=2R.1L();if(1L.4D("qb-ui-1M")){1b $()}1b dK(1L)}if(!89){me.1f.7U(1a(e){3q(e.3H){1l 13:if(me.bB){1b}me.bB=1o;e1(me.1f).2R();e.4g();1p;1l 9:if(!me.bB){1b}K 2R=me.1f.2D(":2R");if(!2R.1e){2R=me.1f}K 1f=1c;if(e.nC){1f=dK(2R)}1i{1f=e1(2R)}if(1f.1e){1f.2R();e.4g();1b 1j}1i{me.bB=1j}}})}J.63=me.1f;if(me.1x.8W){me.1x.2G.at="2a+"+me.1x.8W[0]+" 1O+"+me.1x.8W[1];me.2G.2y=me.1x.2G.2y;me.lW(me.2G);me.1x.8W=1c}if(J.i8==1c){J.i8=$(\'<2E 2C="qb-ui-1M-bq-1Y"></2E>\')}K 66=J.JS();3N.wM(me.1f,QB.1d.2d.58.5m.iY+" "+66);J.i8.42(66);if(J.dI==1c){J.rM=[];if(!1K(J.4q)&&!1K(J.4q.wP)){J.i8.2t("SA");J.rM=J.nj("eW","ui-3L-eW-rD").1k("5t-3x","").1k("5t-3x","SG to eW");J.rM.3I(1a(1H){me.1f.2c(QB.1d.7c.2l.kE,me.4q.wP);1b 1j})}J.lp=J.nj("1W","ui-3L-1W-rD").1k("5t-3x","").1k("5t-3x","T0 SZ");J.wJ=J.nj("ea","ui-3L-ea-rD").1k("5t-3x",QB.1d.2d.58.5m.iV);J.wG=J.nj("5r","ui-3L-5r-rD").1k("5t-3x","").1k("5t-3x","wO");J.dI=$(\'<2F 2C="qb-ui-1M-bq ui-8F-80 ui-aj-6k ui-4z-T4 6s-1M"></2F>\').3a(J.rM).3a(J.i8).3a(J.lp).3a(J.wJ).3a(J.wG).2B("wN",1a(){me.Je()});J.dI.4p(me.1f).2t("qb-ui-1M-2j-66");J.dI.1h("gx",1j);J.wG.3I(1a(1H){me.5r(1H);1b 1j});J.wJ.3I(1a(1H){if(me.4q!=1c&&me.4q.6U){1b 1j}K 3i=me.kH(me);if(3i!=1c){3i.3i("6K")}1b 1j});J.Jb(J.lp)}if(J.4q!=1c&&J.4q.6U){J.dI.2D(".3C-ea").3J();J.dI.2D(".3C-1W").3J()}1i{J.dI.2D(".3C-ea").5e();J.dI.2D(".3C-1W").5e()}if(!QB.1d.5G.rO&&(6Y!=1c&&(6Y.lu!=1c&&6Y.lu.1e>0))){J.lp.5e()}1i{J.lp.3J()}if(me.bw!=1c){me.bw.3u()}me.bw=$(\'<2F 2C="qb-ui-1M-2j-4b ui-3i-ab ui-8F-ab"></2F>\').om(1a(){QB.1d.2f.fU()}).1k("67",-1);if(J.4q.6U){me.bw.2t("sM")}1i{me.bw.4h("sM")}me.7G=me.bw;me.nP=$(\'<1M sG="1" sD="0"></1M>\').4p(me.bw);if(6Y&&6Y.6j){J.JR(6Y,me.nP)}me.bw.4p(me.1f);me.bw.nl();me.g5=me.1f.1y()-me.7G.1y();me.1x.6n=3F.4y(me.1x.6n,me.g5);me.2T.8Z=1j;$(".qb-ui-1M-2j:Ja",me.nP).2t("Ja");me.1x.6W&&($.fn.6W&&J.zf());me.1x.5I&&($.fn.5I&&J.z6());J.ok=1j;me.1x.ey&&($.fn.ey&&me.7G.ey());me.1x.ey&&($.fn.ey&&me.1f.ey());me.IS();me.2T.8Z=1j;me.1x.t7&&J.6K();J.gF=1R.gB.cM;me.1f.1h("J9",me);me.1f.1h("1D",6Y);me.1f.1h("f3",6Y.3h);me.1f.2D("*").wH();me.1f.7i(1a(1H){me.uU(1j,1H)});J.Je=1a(){if(me.1f.1h("gx")){me.1f.1h("gx",1j);me.gx=1j;me.2T("1y",J.Jd)}1i{me.1f.1h("gx",1o);me.gx=1o;J.Jd=J.2T("1y");me.2T("1y",16)}QB.1d.2f.dp();1b 1j};K 5K=$(".qb-ui-1M-2j",me.1f).4s(":5L(.qb-ui-1M-2j-g3)");if(!QB.1d.2f.sT&&!QB.1d.2f.kA){5K.6W({4z:1a(1H){K 3m=1H.3m;K tr=1c;if(3m.68.8u()=="TR"){tr=$(3m).5S()}1i{K 1L=3m;do{if(1L.68.8u()=="TR"){1p}1L=1L.3n}44(1L!=1c);if(1L){tr=$(1L).5S()}}K 4z=$(\'<1M 2C="qb-ui-1M ui-8F ui-8F-ab qb-ui-6W-4z-2j" sD="0" sG="0"></1M>\').3a(tr);ga=4z;1b 4z},4p:"#qb-ui-1V",2I:0.8,2J:1a(1H,ui){me.1f.1h("we",1o);K 4z=$(ui.4z);K kQ=$(J);ui.4z.1r($(J).1r());QB.1d.2f.74.3u(ik);ik=1S QB.1d.2f.bs({4U:{2j:{1f:kQ},1M:me},4T:{2j:{1f:4z}}});QB.1d.2f.74.1C(ik);J.ed=1j},5D:1a(1H,ui){QB.1d.2f.74.3u(ik);QB.1d.2f.dp();me.1f.1h("we",1j);ga=1c},5g:1a(1H,ui){QB.1d.2f.fU()}}).bU({Ad:".qb-ui-1M-2j",sk:"qb-ui-1M-2j-sb",d4:"wb",Ac:1a(1H,ui){if(me.4q.6U){1b 1j}K wa=$(ui.6W);K wf=$(J);K 1W=QB.1d.2f.74.t4({6U:1o,4U:{cq:wa.1h("t9"),aC:wa.1h("f3")},4T:{cq:wf.1h("t9"),aC:wf.1h("f3")}});QB.1d.2f.dp();K 1N=1W.1N();me.1f.2c(QB.1d.7c.2l.nF,1N);me.1f.1h("we",1j);me.ed=1j},iS:1a(1H,ui){if(me.4q.6U){$(ui.4z).2t("sM")}1i{$(ui.4z).4h("sM")}}})}},kH:1a(3l){K bM="#1M-ea-3i";if(1K(QB.1d.5G.eP[bM])){K $gb=$(bM);if($gb.1e){K 8S={};8S[" OK "]=1a(){K 4q=$(J).1h("4q");4q.8w=$("29[1z=1D-aa]",$(J)).cL();4q.4K=$("29[1z=1D-1z]",$(J)).cL();$(J).3i("5r");QB.1d.2k.Iw(4q);QB.1d.2k.61()};8S[QB.1d.2d.58.IA.eb]=1a(){$(J).3i("5r")};QB.1d.5G.eP[bM]=$gb.3i({5I:1j,4j:sX,fu:wd,t7:1j,1r:kB,w6:1o,6K:1a(e,ui){K 4q=$(J).1h("4q");$("29[1z=1D-1z]",$(J)).2h(4q.4K);$("29[1z=1D-1z]").1k("SR",4q.IU);$("29[1z=1D-aa]",$(J)).2h(4q.8w)},8S:8S})}}if(!1K(QB.1d.5G.eP[bM])){QB.1d.5G.eP[bM].1h("4q",3l.4q)}1b QB.1d.5G.eP[bM]},IS:1a(){if(J.1f.1y()>J.1x.ek){J.2T("1y",J.1x.ek)}if(J.1f.1r()>J.1x.cI){J.2T("1r",J.1x.cI)}K JO=40;K ab=J.nP;K w9=J.1f;K 66=J.dI;K IL=J.i8;K wo=ab.b4();K JP=w9.b4();K JQ=66.b4();K nB=ab.1r();K JV=w9.eB();K w7=66.eB();K SX=IL.1r();if(wo==0&&nB==0){1b}K K0=nB>JV-w7;if(K0){nB+=16}K 1r=3F.4y(w7,nB);if(!1K(J.1x.cI)&&J.1x.cI!="6p"){1r=J.1x.cI}K JT=wo+JQ;K 1y=3F.5U(JP,J.1x.ek);if(1r>JO){J.2T("1r",5W(1r));J.nP.1r("100%")}if(1y>0){J.2T("1y",1y);J.2T("8Z",JT)}},JS:1a(){if(!1K(J.4q.6G)){1b J.4q.6G.3f(/ /g,"&2r;")}1i{1b""}},JR:1a(6Y,bw){K me=J;K 1x=6Y.wn;if(1K(1x)){1x={}}K 5K=[];if(!1x.wm){K g3=1S QB.1d.2d.K9;g3.88="*";g3.sl="*";g3.eD=6Y.K8;5K.1C(g3)}K nN=1x.wp?"Kc":"";3q(1x.dP){1l QB.1d.2V.wi.3S:6Y.6j.sB(nN,"88");1p;1l QB.1d.2V.wi.sm:6Y.6j.sB(nN,1x.nM.sH?"wh":"wl");1p}5K=5K.3w(6Y.6j);$.2g(5K,1a(1q,2j){K f=1S QB.1d.wk(2j,6Y,me,1x);me.5K.1C(f);bw.3a(f.1f)})},nj:1a(dv,sK){1b $(\'<a 5d="#"></a>\').2t("ui-aj-6k bq-3C 3C-"+dv+" 8O").6D(1a(){$(J).2t("ui-56-6D")},1a(){$(J).4h("ui-56-6D")}).7i(1a(ev){ev.7L()}).3a($("<2E/>").2t("ui-3L "+sK)).1k("67",-1)},S4:1a(){if(!J.uK){J.uK=$("#qb-ui-3M")}1b J.uK},6v:1a(){1b{x:J.2y().2a,y:J.2y().1O,1r:J.1r(),1y:J.1y()}},89:1a(1h){if(!1K(ga)){ga.2c("5u")}K me=J;K 1u=1h.1D;me.1f.1h("f3",1u.3h);$(".qb-ui-1M-2j",me.1f).2g(1a(){K 2j=$(J);2j.1h("t9",1u.3h);K 7f=1c;$.2g(1u.6j,1a(1q,v6){if(fa(v6.88,2j.1h("1D").88)){7f=v6.3h;1b 1j}});2j.1h("f3",7f)});J.1f.2c(QB.1d.7c.2l.zq)},Jz:1a(1x){if(!1K(ga)){ga.2c("5u")}J.1x=$.4m(J.1x,1x);K Jn=J.1f.1r();K Js=J.7G.1y();K Jy=J.5K.1e;K v3=0;if(1x!=1c&&(1x.1D!=1c&&1x.1D.6j!=1c)){v3=1x.1D.6j.1e+1}K vc=v3!=Jy;if(vc){J.1x.1y="6p";J.1x.1r="6p"}K om=J.7G.5a();J.sv(1o);if(!vc){J.1f.1r(Jn);J.7G.1y(Js)}J.7G.5a(om)},69:1a(){K me=J;J.1f.2c(QB.1d.7c.2l.u3);me.1f.42("").3J().7V(".6V").rQ("6V").4p("3U").6C().3u()},5r:1a(1H,rN){K me=J;if(!rN){me.1f.2c(QB.1d.7c.2l.ue)}if(1j===me.7z("Mf",1H)){1b}me.1f.7V("h3.qb-ui-1M");me.1f.3J()&&me.7z("5r",1H);me.ok=1j;me.69()},iu:1a(){1b J.ok},uU:1a(fm,1H){K me=J;if(J.1x.4j>$.ui.6V.m5){$.ui.6V.m5=J.1x.4j}K JM={5a:me.1f.1k("5a"),4S:me.1f.1k("4S")};me.1f.2Z("z-1P",++$.ui.6V.m5).1k(JM);J.7z("2R",1H)},rE:1a(5K){J.1f.2c(QB.1d.7c.2l.nI,{5K:5K})},uN:1a(3B){K me=J;K 5K=J.5K;K eh=[];$.2g(5K,1a(){K 2j=J;if(2j.1D.88!="*"&&J.3B!=3B){J.fb(3B);eh.1C(J)}});me.rE(eh)},ih:1a(9N,3B,sV){K me=J;K 5K=J.5K;K uT=[];$.2g(5K,1a(1P,2j){if(2j.1D.88==9N){$(".qb-ui-1M-2j-2n 29",2j.1f).2g(1a(){if(J.3B!=3B){J.3B=3B;2j.3B=3B;uT.1C(2j)}})}});if(sV){me.rE(uT)}},6K:1a(){if(J.ok){1b}K 1x=J.1x;J.z8();J.lW(1x.2G);J.uU(1o);J.7z("6K");J.ok=1o},S5:1a(){K 6e=J,1x=J.1x;1a bv(ui){1b{2G:ui.2G,2y:ui.2y}}J.63.6W({hS:".ui-3i-ab, .ui-3i-bq-5r",4M:".qb-ui-1M-bq",8i:"2N",2J:1a(1H,ui){$(J).2t("ui-3i-sf");6e.tg();6e.7z("v8",1H,bv(ui))},5g:1a(1H,ui){6e.7z("5g",1H,bv(ui))},5D:1a(1H,ui){1x.2G=[ui.2G.2a-6e.2N.4S(),ui.2G.1O-6e.2N.5a()];$(J).4h("ui-3i-sf");6e.zp();6e.7z("v1",1H,bv(ui))}})},zf:1a(){K me=J;K 2Y=$(2N),vd;1a bv(ui){1b{2G:ui.2G,2y:ui.2y}}me.63.6W({S6:1j,Nu:1j,hS:".ui-3i-ab, .ui-3i-bq-5r",4M:".qb-ui-1M-bq",8i:"1L",om:1o,2J:1a(1H,ui){K c=$(J);vd=me.1x.1y==="6p"?"6p":c.1y();c.1y(c.1y()).2t("ui-3i-sf");if($.ui.hF.5y!=1c&&($.ui.hF.5y.8i!=1c&&$.ui.hF.5y.8i.1e>3)){$.ui.hF.5y.8i[2]=u7;$.ui.hF.5y.8i[3]=u7}me.tg();me.7z("v8",1H,bv(ui))},5g:1a(1H,ui){QB.1d.2f.fU();me.7z("5g",1H,bv(ui))},5D:1a(1H,ui){QB.1d.2f.71();QB.1d.2f.dp();me.1x.2G.at="2a+"+(ui.2G.2a-2Y.4S())+" 1O+"+(ui.2G.1O-2Y.5a());$(J).4h("ui-3i-sf").1y(vd);me.1f.2c(QB.1d.7c.2l.u4,me);QB.1d.2k.ho();me.zp();me.7z("v1",1H,bv(ui))}})},Su:1a(){K ce,co,iS,o=J.1x;if(o.8i==="1L"){o.8i=J.4z[0].3n}if(o.8i==="2N"||o.8i==="3P"){J.8i=[0-J.2y.ob.2a-J.2y.1L.2a,0-J.2y.ob.1O-J.2y.1L.1O,$(o.8i==="2N"?2N:3P).1r()-J.Na.1r-J.u6.2a,($(o.8i==="2N"?2N:3P).1y()||2N.3U.3n.s6)-J.Na.1y-J.u6.1O]}if(!/^(2N|3P|1L)$/.9r(o.8i)){ce=$(o.8i)[0];co=$(o.8i).2y();iS=$(ce).2Z("gh")!=="70";J.8i=[co.2a+(6i($(ce).2Z("uI"),10)||0)+(6i($(ce).2Z("Si"),10)||0)-J.u6.2a,co.1O+(6i($(ce).2Z("uA"),10)||0)+(6i($(ce).2Z("Sm"),10)||0)-J.u6.1O,u7,u7]}},z6:1a(fI){fI=fI===2O?J.1x.5I:fI;K me=J,1x=me.1x,2G=me.63.2Z("2G"),Mx=2L fI==="4d"?fI:"n,e,s,w,se,sw,ne,nw";1a bv(ui){1b{MQ:ui.MQ,MN:ui.MN,2G:ui.2G,54:ui.54}}me.63.5I({hS:".ui-3i-ab",8i:"2N",Uc:me.7G,8Z:5W(1x.8Z),cl:1x.cl,6n:me.m7(),fI:Mx,2J:1a(1H,ui){$(J).2t("ui-3i-MG");me.tg();me.7z("My",1H,bv(ui))},71:1a(1H,ui){me.7z("71",1H,bv(ui));QB.1d.2f.tT();QB.1d.2f.fU()},5D:1a(1H,ui){$(J).4h("ui-3i-MG");1x.1y=$(J).1y();1x.1r=$(J).1r();me.7z("MD",1H,bv(ui));me.1f.2c(QB.1d.7c.2l.u4,me);QB.1d.2k.ho()}}).2Z("2G",2G).2D(".ui-5I-se").2t("ui-3L ui-3L-Ud-Ua-se")},m7:1a(){K 1x=J.1x;K 1y=J.g5;if(1x.1y==="6p"){if(!aE(1x.6n)){1y=3F.4y(1y,1x.6n)}}1i{K h=0;if(!aE(1x.6n)){h=1x.6n}if(!aE(1x.1y)){1y=3F.5U(h,1x.1y)}1y=3F.4y(1y,h)}1b 1y},2G:1a(3V){J.lW(3V)},lW:1a(3V){if(!J.1x.6H){1b}if(!$("#qb-ui-1V").is(":6H")){1b}K et=[],2y=[0,0];if(3V){if(2L 3V==="4d"||2L 3V==="1D"&&"0"in 3V){et=3V.3p?3V.3p(" "):[3V[0],3V[1]];if(et.1e===1){et[1]=et[0]}$.2g(["2a","1O"],1a(i,Mb){if(+et[i]===et[i]){2y[i]=et[i];et[i]=Mb}});3V={my:"2a 1O",of:"#qb-ui-1V",at:"2a+"+2y[0]+" 1O+"+2y[1]}}3V=$.4m({},J.1x.2G,3V)}1i{3V=J.1x.2G}J.1x.2G=3V;if(J.1x.6H&&(J.1x.2G.of==1c||$(J.1x.2G.of).1e>0)){J.63.5e();3V.of="#qb-ui-1V";J.63.2G(3V)}},lQ:1a(1q,1m){K me=J,63=me.63,fH=63.is(":1h(ui-5I)"),71=1j;3q(1q){1l"Mf":1q="U3";1p;1l"8S":me.Ti(1m);71=1o;1p;1l"Tf":me.Tg.1Y(""+1m);1p;1l"NB":63.4h(me.1x.NB).2t(Tm+1m);1p;1l"2x":if(1m){63.2t("ui-3i-2x")}1i{63.4h("ui-3i-2x")}1p;1l"6W":if(1m){me.zf()}1i{63.6W("69")}1p;1l"1y":71=1o;1p;1l"8Z":if(fH){63.5I("2T","8Z",1m)}71=1o;1p;1l"fu":if(fH){63.5I("2T","fu",1m)}71=1o;1p;1l"6n":if(fH){63.5I("2T","6n",1m)}71=1o;1p;1l"cl":if(fH){63.5I("2T","cl",1m)}71=1o;1p;1l"2G":me.lW(1m);1p;1l"5I":if(fH&&!1m){63.5I("69")}if(fH&&2L 1m==="4d"){63.5I("2T","fI",1m)}if(!fH&&1m!==1j){me.z6(1m)}1p;1l"66":$(".ui-3i-66",me.Tc).42(""+(1m||"&#Tn;"));1p;1l"1r":71=1o;1p}$.A8.2S.lQ.3d(me,2q);if(71){me.z8()}},Ty:1a(){K 1x=J.1x;J.7G.2Z({1r:"6p",6n:0,1y:0});if(1x.cl>1x.1r){1x.1r=1x.cl}K mb=J.63.2Z({1y:"6p",1r:"6p"}).1y();K 6n=J.m7();J.7G.2Z(1x.1y==="6p"?{6n:6n,1y:$.cn.6n?"6p":6n}:{6n:0,1y:"6p"}).5e();if(J.63.is(":1h(ui-5I)")){J.63.5I("2T","6n",J.m7())}},z8:1a(){K o=J.1x;J.7G.5e().2Z({1r:"6p",6n:0,8Z:"3t",1y:0,cl:o.cl});K mb=J.63.2Z({1y:"6p",1r:o.1r}).1y()+1;K g5=0;if(aE(o.6n)){g5=mb}1i{g5=3F.4y(o.6n,mb)}if(o.1y==="6p"){J.7G.2Z({6n:g5,1y:"6p"})}1i{J.7G.1y(3F.4y(0,o.1y-mb))}if(J.63.is(":1h(ui-5I)")){J.63.5I("2T","6n",J.m7())}},tg:1a(){J.tw=J.2N.2D("dG").eO(1a(){K dG=$(J);1b $("<2F>").2Z({2G:"8x",1r:dG.eB(),1y:dG.b4()}).4p(dG.1L()).2y(dG.2y())[0]})},zp:1a(){if(J.tw){J.tw.3u();41 J.tw}},TB:1a(1H){if($(1H.3m).fQ(".ui-3i").1e){1b 1o}1b!!$(1H.3m).fQ(".ui-u5").1e}};(1a($){$.8F("ui.6V",QB.1d.7c);$.4m($.ui.6V,{5N:"1.8.2",Ia:"2G",Tq:0,m5:0,6v:1a(){K 1V=$("#qb-ui-1V");1b{x:J.2y().2a-1V.2y().2a,y:J.2y().1O-1V.2y().1O,1r:J.1r(),1y:J.1y()}}})})(2u);QB.1d.7c.2l={nI:"nI",MT:"MT",ue:"ue",u3:"u3",u4:"u4",zq:"zq",nF:"nF",Mc:"Mc",kN:"kN",kE:"kE"};QB.1d.M1={};QB.1d.M1.2l={mR:"mR"};QB.1d.jf=1a(1q,1L){J.31=1c;J.dc=1c;J.a8=1c;J.6g=1c;J.8X=1q;J.dU=1L;J.ch=1c;J.1m=1a(4f){if(4f===2O){1b J.ch}J.ch=4f};J.bm=1a(){K bm=J.ch;if(!1K(J.ch)){3q(J.8X){1l 1R.2i.bT:bm=J.ch;1p;1l 1R.2i.8H:bm=1R.7Q.mI.dq(J.ch);if(bm=="yQ"){bm=""}1p;1l 1R.2i.6S:K 1m=J.dU.7m(1R.2i.8H);if(1K(1m)||1m==0){bm=""}1p;1l 1R.2i.bX:bm=1R.7Q.sN.dq(J.ch);1p}}if(1K(bm)){bm=" "}1b bm};J.3u=1a(){};J.89=1a(){if(J.dc!=1c){J.dc[0].mQ=Mm(J.bm())}if(J.6g!=1c){J.6g.cL(J.ch)}};J.Er=1a(){if(J.dc!=1c){J.dc.3J()}if(J.a8!=1c){J.a8.5e()}if(J.6g!=1c){J.6g.2R()}};J.yX=1a(){if(J.dc==1c){1b}QB.1d.2U.ss=1o;J.dc.5e();if(J.a8!=1c){J.a8.3J()}QB.1d.2U.ss=1j};J.Nh=1a(){K 6E=1c;K me=J;3q(J.8X){1l 1R.2i.jP:6E=$("<2F></2F>");6E.gv=1o;6E.2B("3I",1a(e){$(me).2c(QB.1d.jf.2l.sS,{1q:me.8X,4f:1o,5C:1j})});me.31.2B("7U",1a(e){if(e.3H==13||e.3H==32){me.6g.2c("3I")}});1p;1l 1R.2i.47:6E=$("<2F></2F>");6E.gv=1o;1p;1l 1R.2i.1Q:6E=$(\'<29 1w="7W" 1m="1o" />\');6E.1k("67",-1);6E.gv=1o;1p;1l 1R.2i.dz:6E=$(\'<29 1w="7W" 1m="1o" />\');6E.1k("67",-1);6E.gv=1o;1p;1l 1R.2i.3g:6E=$("<2n />");1p;1l 1R.2i.bT:K 2n=["<2n>"];if(!1K(QB.1d.5G.9d)&&!1K(QB.1d.5G.9d.ND)){K 1Q="";$.2g(QB.1d.5G.9d.ND,1a(1P,2h){1Q=2h==me.ch?\' 1Q="1Q" \':"";2n.1C(\'<2T 1m="\'+2h+\'"\'+1Q+">"+(2h==1c?"":2h)+"</2T>")})}2n.1C("</2n>");6E=$(2n.4H(""));6E.2B("dD",1a(){me.ds()});1p;1l 1R.2i.8H:K 2n=["<2n>"];1R.7Q.mI.2g(1a(1P,2h){2n.1C(\'<2T 1m="\'+1P+\'">\'+(2h==1c?"":2h)+"</2T>")});2n.1C("</2n>");6E=$(2n.4H(""));6E.2B("dD",1a(){me.ds()});1p;1l 1R.2i.6S:6E=$("<2n />");1p;1l 1R.2i.bX:K 2n=["<2n>"];1R.7Q.sN.2g(1a(1P,2h){2n.1C(\'<2T 1m="\'+1P+\'">\'+(2h==1c?"":2h)+"</2T>")});2n.1C("</2n>");6E=$(2n.4H(""));6E.2B("dD",1a(){me.ds()});1p;5n:6E=$(\'<29 1w="1Y" 1m="" />\');6E.4N("7U",me.Nl,me);1p}6E.YR(1a(e){me.31.4h("ui-z3-2R")});1b 6E};J.Nl=1a(e){if(e.3H==13){e.7L();J.ds();1b 1j}};J.yT=1a(){K me=J;if(J.a8==1c){J.a8=$(\'<2F 2C="ui-qb-3M-1I-7w-EV-6X"></2F>\');J.a8.4p(J.31)}J.6g=J.Nh(J.8X);J.6g.4p(J.a8);J.6g.1k("5t-3x",QB.1d.2U.8m[J.8X]);if(!J.6g.gv){J.a8.3J()}if(J.8X==1R.2i.3g){K u9=J.6g.zh({9E:"3M-3g",1m:me.ch,fE:1a(){me.ds()}});K 8f=u9.zm()[0];J.6g=8f.zl();J.6g.mG=1o}if(J.8X==1R.2i.6S){K u9=J.6g.zh({9E:"3M-6S",fE:1a(){me.ds()}});K 8f=u9.zm()[0];J.6g=8f.zl();J.6g.mG=1o}J.6g.2t("ui-qb-3M-1I-7w-EV-31");if(!J.6g.mG){if(J.6g.gv){J.6g.dD(1a(){me.ds()});J.6g.mG=1o}1i{J.6g.4P(1a(){me.ds()});J.6g.mG=1o}}};J.zy=1a(){J.a8.6C().3u();J.a8.3u();J.a8=1c;J.yT()};J.DZ=1a(){K me=J;3q(J.8X){1l 1R.2i.jP:;1l 1R.2i.47:;1l 1R.2i.1Q:;1l 1R.2i.dz:1b 1c}K $yH=$("<2F></2F>").2t("ui-qb-3M-1I-7w-Ei-6X").2t("ui-qb-3M-1I-7w-Ei-31");$yH.3I(1a(e){if(gz){1b}if(N5&&me.8X==1R.2i.aa){QB.1d.5G.tQ("Zb Ee is iM Zc of iM N3 5N. Ec Ed 4u Z9 of Za nc Ed be Ef to jK YZ Ee in iM Z0 5N.");1b 1j}me.tb()});1b $yH};J.tb=1a(){QB.1d.2U.bB=1o;if(QB.1d.2U.mD!=1c){QB.1d.2U.mD.ds()}if(J.8X==1R.2i.3g||!J.dU.1K()&&!J.dU.EG()){J.Er();QB.1d.2U.mD=J}J.31.2t("ui-z3-2R")};J.ds=1a(){K yY=1o;K 5C=J.1m();K 4f=J.6g.cL();if(!3N.sW(5C,4f)&&!(5C==1c&&(4f==" "||4f==0))){K yZ=J.dU.7m(1R.2i.8H);3q(J.8X){1l 1R.2i.6S:if(1K(4f)||4f==0){if(!1K(yZ)){J.dU.8k(1R.2i.8H,1R.7Q.mI.yQ)}}1i{5C=1K(5C)?DT:5W(5C);4f=5W(4f);if(aE(4f)){4f=0}if(aE(5C)){5C=DT}4f+=4f<5C?-0.5:+0.5;if(1K(yZ)){J.dU.8k(1R.2i.8H,1R.7Q.mI.DX);J.dU.jE(1R.2i.8H)}yY=1j}1p}J.1m(4f);if(yY){J.dU.jE()}J.yX();$(J).2c(QB.1d.jf.2l.sS,{1q:J.8X,4f:4f,5C:5C})}1i{J.yX()}QB.1d.2U.mD=1c;if(!J.6g.gv){J.31.4h("ui-z3-2R")}};J.DP=1a(1q){K go="ui-qb-3M-1I-";if(1q>=1R.2i.n3){1b go+"xz"}1b go+1R.2i.dq(1q)};J.e1=1a(2R){if(!2R.1e){1b $()}K 1J=2R.3k();if(1J.is(":8O")){1b 1J}1J=1J.2D(":8O:4t");if(1J.1e){1b 1J}K 1L=2R.1L();1b J.e1(1L)};J.dK=1a(2R){if(!2R.1e){1b $()}K 1J=2R.3O();if(1J.is(":8O")){1b 1J}1J=1J.2D(":8O:6Z");if(1J.1e){1b 1J}K 1L=2R.1L();1b J.dK(1L)};J.7I=1a(1q,1L){K me=J;J.31=$(\'<td 2C="ui-8F-ab ui-qb-3M-1I-7w \'+J.DP(J.8X)+\'" />\');J.31.1k("67",0);K si=J.8X;if(si>1R.2i.8c){si=1R.2i.8c}J.31.1k("5t-3x",QB.1d.2U.8m[si]);J.dc=J.DZ();if(J.dc!=1c){J.dc.4p(J.31)}J.yT();J.31.Zj(1a(e){if(QB.1d.2U!=1c&&QB.1d.2U.2x){1b}if(QB.1d.2U.ss){1b}if(me.31[0]!=e.3m){1b}me.tb()});J.31.7U(1a(e){3q(e.3H){1l 9:if(e.nC){me.dK(me.31).2R();e.4g()}}})};J.7I(1q,1L)};QB.1d.jf.2l={sS:"Zk",Yy:"YS"};QB.1d.nW=1a(1N){J.YP=1;J.5Q={};J.YQ=3N.sj();J.3h=1c;J.31=1c;J.oe=1j;J.65=Be();J.YV=1j;J.1K=1a(){1b 1K(J.5Q[1R.2i.3g].1m())};J.EG=1a(){K 2h=J.5Q[1R.2i.3g].1m();if(1K(2h)){1b 1j}1b 2h.4Y(".*")>=0};J.fb=1a(2h){K je=J.5Q[1R.2i.1Q].1m();if(2h===2O){1b je}1i{if(je!=2h){J.5Q[1R.2i.1Q].1m(2h);J.zU(1c,{1q:1R.2i.1Q,4f:2h});1b 1o}}1b 1j};J.7m=1a(1q){1b J.5Q[1q].1m()};J.Hw=1a(){1b!1K(J.7m(1R.2i.bT))||!1K(J.7m(1R.2i.8c))};J.8k=1a(1q,1m,sV){if(1m===2O){1m=1c}K 4f=1m;K 5C=J.5Q[1q].1m();if(3N.sW(4f,5C)){1b 1j}3q(1q){1l 1R.2i.8H:J.8k(1R.2i.6S,1c,sV);1p;1l 1R.2i.6S:if(1K(4f)||4f==0){4f=""}1p;5n:}J.5Q[1q].1m(4f);1b 1o};J.zU=1a(e,1h){K 1q=1h.1q;K 4f=1h.4f;K 5C=1h.5C;$(J).2c(QB.1d.nW.2l.A6,{1q:1q,4f:4f,5C:5C,1I:J});J.jt()};J.jt=1a(){K me=J;K sI=me.1K();1n(K 1q in me.5Q){if(1q==1R.2i.3g){ag}K 7w=me.5Q[1q];7w.31.1k("67",sI?-1:0)}};J.EK=1a(){K me=J;K 42=$(\'<tr 2C="ui-qb-3M-1I" />\');1R.2i.2g(1a(1q){K 7w=1S QB.1d.jf(1q,me);$(7w).4N(QB.1d.jf.2l.sS,me.zU,me);7w.31.4p(42);me.5Q[1q]=7w});J.jt();42.1h("1D",J);42.1h("me",J);1b 42};J.3u=1a(){J.oe=1o;J.31.6C().3u();J.31.3u();J.31.42("")};J.jE=1a(jx){K me=J;1n(K 1q in me.5Q){K 7w=me.5Q[1q];if(jx===2O||jx==1q){7w.89()}}J.jt()};J.Cl=1a(jx){K me=J;1n(K 1q in me.5Q){K 7w=me.5Q[1q];if(jx===2O||jx==1q){7w.zy()}}J.jt()};J.ES=1a(){J.8k(1R.2i.1Q,!J.1K());J.8k(1R.2i.dz,1j);J.8k(1R.2i.bX,1R.7Q.sN.mo)};J.h2=1a(zv,zT,sz){if(3N.3r(J.7m(1R.2i.3g)).3R()==3N.3r(zv).3R()){if(zT===2O||zT==3N.3r(J.7m(1R.2i.bT)).3R()){if(sz===2O||sz==3N.3r(J.7m(1R.2i.aa)).3R()){1b 1o}}}1b 1j};J.1N=1a(1m){if(1m===2O){1b J.Ez()}1i{1b J.sZ(1m)}};J.89=1a(1N){K 5E=J.sZ(1N);if(5E){J.jE()}1b 5E};J.sZ=1a(1N){K 5E=1j;if(1K(1N)){1b 5E}5E=J.8k(1R.2i.3g,1N.8T)||5E;5E=J.8k(1R.2i.bT,1N.dV)||5E;5E=J.8k(1R.2i.aa,1N.8w)||5E;5E=J.8k(1R.2i.dz,1N.gM)||5E;5E=J.8k(1R.2i.bX,1N.zW)||5E;5E=J.8k(1R.2i.8H,1N.dP)||5E;5E=J.8k(1R.2i.6S,1N.jk)||5E;1n(K i=0;i<QB.1d.2U.gN+1;i++){5E=J.8k(1R.2i.8c+i,1N.5R[i])||5E}if(J.3h!=1N.3h){J.3h=1N.3h;5E=1o}if(!1K(1N.65)&&J.65!=1N.65){J.65=1N.65;5E=1o}if(!1K(1N.3h)&&J.65!=1c){if(!1K(1N.3h)){J.65=1c}5E=1o}if(J.oe!=1N.7Z){J.oe=1N.7Z;5E=1o}if(J.8V!=1N.8V){J.8V=1N.8V;5E=1o}5E=J.8k(1R.2i.1Q,1N.b8&&!J.1K())||5E;J.jt();1b 5E};J.Ez=1a(){K 1N=1S QB.1d.2d.xo;1N.b8=J.7m(1R.2i.1Q);1N.8T=J.7m(1R.2i.3g);1N.dV=J.7m(1R.2i.bT);1N.8w=J.7m(1R.2i.aa);1N.gM=J.7m(1R.2i.dz);1N.zW=J.7m(1R.2i.bX);1N.dP=J.7m(1R.2i.8H);1N.jk=J.7m(1R.2i.6S);1N.5R[0]=J.7m(1R.2i.8c);1n(K i=0;i<QB.1d.2U.gN;i++){1N.5R[1+i]=J.7m(1R.2i.n3+i)}1N.3h=J.3h;1N.7Z=J.oe;1N.65=J.65;1N.8V=J.31==1c?0:J.31.1P();1b 1N};J.7I=1a(EU){J.31=J.EK();J.31.nl();J.ES();J.sZ(EU);J.jE()};J.7I(1N)};QB.1d.nW.2l={A6:"YL"};QB.1d.2U={2X:[],gN:2,sq:1j,ZU:1c,mP:1c,bB:1j,102:[],2x:1j,ss:1j,e1:1a(2R){if(!2R.1e){1b $()}K 1J=2R.3k();if(1J.is(":8O")){1b 1J}1J=1J.2D(":8O:4t");if(1J.1e){1b 1J}K 1L=2R.1L();1b J.e1(1L)},dK:1a(2R){if(!2R.1e){1b $()}K 1J=2R.3O();if(1J.is(":8O")){1b 1J}1J=1J.2D(":8O:6Z");if(1J.1e){1b 1J}K 1L=2R.1L();1b J.dK(1L)},sv:1a(){K me=J;K x=J.1f.1k("gN");if(x!=1c&&(x!=""&&!aE(x))){QB.1d.2U.gN=5W(x)}if(J.1f.1k("sq")=="ZV"){QB.1d.2U.sq=1o}J.1f.2t("ui-8F").2t("ui-qb-3M");J.1f.bU({sk:"qb-ui-3M-6D",Ad:".qb-ui-3M-bU",d4:"9c",Ac:1a(e,ui){if(ui.4z.4D("qb-ui-3X-2j-4z")){K 1D=ui.4z.1h("1D");K hE=ui.4z.1h("hE");$(J).2c(QB.1d.2U.2l.uf,{1M:hE,2j:1D})}1i{K CH=$(J);K 1D=ui.4z.1h("1D");K sJ={1D:1D};$(J).2c(QB.1d.2U.2l.u2,sJ)}}});J.1M=$(\'<1M sG="0" sD="0" f8="0" />\').2t("ui-8F-ab").2t("sE-CN").4p(J.1f);J.Hq().4p(J.1M);J.jF();J.gZ();J.CV();me.1f.2R(1a(e){QB.1d.2U.bB=1j});me.1f.1k("67",0);me.1f.7U(1a(e){3q(e.3H){1l 13:if(QB.1d.2U.bB){1b}QB.1d.2U.bB=1o;me.1f.2D("[67]:6H:4t").2R();e.4g();1p;1l 9:if(!QB.1d.2U.bB){if(!e.nC){me.e1(me.1f).2R()}1i{me.dK(me.1f).2R()}e.4g()}}})},CV:1a(){K me=J;me.1M.4e({sF:1a(1M,1I){K 1u=$(1I).1h("1D");if(!1u.1K()){me.1f.2c(QB.1d.2U.2l.fA,{1I:1u})}},nA:"ui-qb-3M-1I-47"})},69:1a(){J.1f.4h("ui-qb-3M").7V(".8L");J.1M.3u();$.A8.2S.69.3d(J,2q)},jF:1a(1I){K A7=1j;$.2g(J.2X,1a(1q,1I){if(1I.1K()){A7=1o;1b 1j}});if(!A7){J.ip(1c)}},eY:1a(1T){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 3T=".ui-qb-3M-1I";K 1F=QB.1d.2f.k0(1T.2P);$.2M("69",3T);$.2M({3T:3T,4j:cG,6M:{6O:0},1Z:1a(47,1x){K 1I=J.1h("me");me.jY(47,1I)},1F:1F})},jY:1a(47,1I){K me=J;K el=1I.31;3q(47){1l"cV-up":if(el.3k().1e){el.76(el.3O());if(!1I.1K()){me.1f.2c(QB.1d.2U.2l.fA,{1I:1I})}}1p;1l"cV-cT":K 3k=el.3k();if(3k.1e&&3k.3k().1e){el.e7(3k);if(!1I.1K()){me.1f.2c(QB.1d.2U.2l.fA,{1I:1I})}}1p;1l"1I-41":if(me.2X.1e>1){me.hN(1I)}1i{if(1I.1K()){1b}1i{me.hN(1I);me.jF()}}me.jF(1I);me.gZ();me.1f.2c(QB.1d.2U.2l.fA,{1I:1I,1q:1R.2i.jP,4f:1o,5C:1j});1p;1l"1I-10f":me.ip(1c,el);1p}},ip:1a(59,jr,4Z,jm){K d9=1j;K 1I=J.Cx(59);if(1I==1c){d9=1o;1I=1S QB.1d.nW(59);$(1I).4N(QB.1d.nW.2l.A6,{1I:1I},J.D9,J);if(1I!=1c&&(!1I.1K()&&1K(jr))){jr=J.Cp()}if(4Z===0||!1K(4Z)){4Z=5W(4Z)+1;K jv=$("tr",J.1M).eq(4Z);if(jv.1e){jv.yj(1I.31)}1i{1I.31.4p(J.1M)}}1i{if(jr!=1c&&jr.1e){1I.31.76(jr)}1i{1I.31.4p(J.1M)}}if(!jm){J.1f.2c(QB.1d.2U.2l.vx,{1I:1I})}J.2X.1C(1I)}1i{if(4Z===0||!1K(4Z)){4Z=5W(4Z)+1;K CX=1I.31[0].109;if(4Z!=CX){K jv=$("tr",J.1M).eq(4Z);if(jv.1e){jv.yj(1I.31)}}}d9=1I.89(59);if(!jm&&d9){J.1f.2c(QB.1d.2U.2l.fA,{1I:1I})}}if(1I!=1c&&1I.31!=1c){K mL=$(".ui-qb-3M-1I-bX",1I.31);if(mL.1e>0){mL.2Z("5q",J.mP?"":"3t")}}if(!jm&&d9){J.gZ()}1b 1I},Ni:1a(){1b J.2X},ZF:1a(){K zC=1c;$.2g(J.2X,1a(1q,1I){K sI=1I.1K();if(sI){zC=1I;1b 1j}});1b zC},hN:1a(zA,jm){K 59;1n(K i=J.2X.1e-1;i>=0;i--){K 1I=J.2X[i];if(1I.3h==zA.3h){if(!1K(1I.3h)||1K(1I.3h)&&1I.31==zA.31){J.2X.3u(1I);1I.7Z=1o;1I.3u();59=1I.1N()}}}J.gZ();if(59){59.7Z=1o;if(!jm){J.1f.2c(QB.1d.2U.2l.vh,{59:59})}}},ZE:1a(1N){K 2X=J.zw(1N);1n(K 1I in 2X){1I.3u();J.2X.3u(1I);41 1I}J.gZ()},ZD:1a(7f){K 1J=1c;$.2g(J.2X,1a(1q,1I){if(1I.3h==7f){1J=1I;1b 1j}});1b 1J},Cp:1a(){1b J.1M.2D("tr:6Z:5L(.ui-qb-3M-1I-80)")},Cx:1a(59){K 2X=J.zw(59);if(2X.1e>0){1b 2X[0]}1b 1c},zw:1a(59){K 1J=[];if(59==1c){1b 1J}K zv=3N.3r(59.8T).3R();K sz=3N.3r(59.8w).3R();1n(K i=0;i<J.2X.1e;i++){K 1I=J.2X[i];if(!1K(1I.3h)&&(!1K(59.3h)&&1I.3h==59.3h)){1J.1C(1I)}1i{if(!1K(1I.65)&&(!1K(59.65)&&1I.65==59.65)){1J.1C(1I)}1i{if(1I.h2(59.8T,59.dV,59.8w)){1J.1C(1I)}}}}1b 1J},kR:1a(){$.2g(J.2X,1a(1q,1I){1I.5Q[1R.2i.3g].zy();if(QB.1d.2U.mD==1I.5Q[1R.2i.3g]){1I.5Q[1R.2i.3g].tb()}})},I9:1a(3g){K 2X=J.rH(3g);if(2X.1e>0){1b 2X[0]}1b 1c},rH:1a(3g){K 1J=[];$.2g(J.2X,1a(1q,1I){if(1I.h2(3g,"")){1J.1C(1I)}});1b 1J},NK:1a(1N){K 2R=$(":2R");$("#qb-ui-3M").2R();QB.1d.2U.2x=1o;K me=J;if(1K(1N)){1b}K zS=[];$.2g(1N.cw,1a(1P,DD){zS.1C(me.ip(DD,1c,1P,1o))});1n(K i=J.2X.1e-1;i>=0;i--){if(i>J.2X.1e-1){ag}K mz=J.2X[i];if(mz!=1c){if(zS.4Y(mz)==-1&&!mz.1K()){J.hN(mz,1o)}}}QB.1d.2U.2x=1j},MR:1a(){K 2H=[];if(QB.1d.2f.5F!=1c&&QB.1d.2f.5F.1e!=1c){1n(K i=0;i<QB.1d.2f.5F.1e;i++){K 1u=QB.1d.2f.5F[i];K 1M=1u.1h("1D");K 8o=!1K(1M.iR)?1M.iR:1M.3S;K zR=8o+".*";2H.1C({1Q:1j,1Y:zR,1m:zR,dv:"1M"});$(1M.6j).2g(1a(){K 2j=J;K mB=8o+"."+2j.88;K Dm=2j.88;2H.1C({1Q:1j,1Y:Dm,1m:mB,dv:"2j"})})}}9R.zQ("3M-3g",2H)},ZH:1a(1I,3B){1I.fb(3B)},D9:1a(e,1h){K 1I=e.1h.1I;K 1q=1c;K 4f=1c;K 5C=1c;if(1h){1q=1h.1q;4f=1h.4f;5C=1h.5C}if(1q==1R.2i.jP&&4f){if(J.2X.1e>1){J.hN(1I,1o)}1i{if(1I.1K()){1b}1i{J.hN(1I,1o);J.jF()}}}J.jF(1I);J.gZ(1I);J.1f.2c(QB.1d.2U.2l.fA,{1I:1I,1q:1q,4f:4f,5C:5C})},gZ:1a(1I){J.CE(1I);J.D0(1I)},D0:1a(){K mK=[];1n(K i=0;i<J.2X.1e;i++){K 1I=J.2X[i];K 1m=1I.7m(1R.2i.8H);if(1m!=1c&&1m>0){mK.1C({1I:1I,6S:1I.7m(1R.2i.6S)})}}mK.eU(J.CQ);K 2H=[];1n(K i=0;i<mK.1e;i++){2H.1C({1Q:1j,1Y:5h(i+1),1m:5h(i+1),dv:"6S"});K 1I=mK[i].1I;1I.8k(1R.2i.6S,i+1,1o);1I.jE(1R.2i.6S)}2H.1C({1Q:1j,1Y:5h(i+1),1m:5h(i+1),dv:"6S"});9R.zQ("3M-6S",2H)},Kz:1a(){1n(K i=0;i<J.2X.1e;i++){K 1I=J.2X[i];1I.Cl(1R.2i.bT)}},CQ:1a(a,b){K jA=b.6S;K jD=a.6S;if(1K(jD)||jD<0){1b 1}if(1K(jA)||jA<0){1b-1}jD=5W(jD);jA=5W(jA);1b jD-jA},CE:1a(1I){K rP=1j;1n(K i=0;i<J.2X.1e;i++){if(J.2X[i].7m(1R.2i.dz)){rP=1o;1p}}if(J.mP==rP){1b 1j}J.mP=rP;K mL=$(".ui-qb-3M-1I-bX",J.1M);mL.2Z("5q",J.mP?"":"3t");1b 1o},Hq:1a(){K 80=$("<X5 />");K tr=$("<tr />").2t("ui-qb-3M-1I-80").4p(80);K 4t=1o;K rR="";QB.1d.2U.8m={};QB.1d.2U.8m[1R.2i.47]="";QB.1d.2U.8m[1R.2i.jP]=QB.1d.2d.58.5m.hc;QB.1d.2U.8m[1R.2i.1Q]=QB.1d.2d.58.5m.5R.rV;QB.1d.2U.8m[1R.2i.3g]=QB.1d.2d.58.5m.5R.8T;QB.1d.2U.8m[1R.2i.bT]=QB.1d.2d.58.5m.5R.dV;QB.1d.2U.8m[1R.2i.aa]=QB.1d.2d.58.5m.5R.8w;QB.1d.2U.8m[1R.2i.8H]=QB.1d.2d.58.5m.5R.dP;QB.1d.2U.8m[1R.2i.6S]=QB.1d.2d.58.5m.5R.jk;QB.1d.2U.8m[1R.2i.dz]=QB.1d.2d.58.5m.5R.gM;QB.1d.2U.8m[1R.2i.bX]=QB.1d.2d.58.5m.5R.xG;QB.1d.2U.8m[1R.2i.8c]=QB.1d.2d.58.5m.5R.rI;QB.1d.2U.8m[1R.2i.n3]=QB.1d.2d.58.5m.5R.rI;$.2g(QB.1d.2U.8m,1a(i,7w){QB.1d.2U.8m[i]=7w.3f("&2r;"," ").3f("&xl;","&")});$.2g(J.Hn(),1a(){if(4t){rR=\'X4="3"\';4t=1j}1i{rR=""}$(\'<th 2C="ui-56-5n ui-qb-3M-1I-\'+J.1z+\'" \'+rR+">"+J.80+"</th>").4p(tr)});1b 80},Hn:1a(){K 2X={};2X[1R.2i.1Q]={cg:1,1z:"1Q",80:QB.1d.2d.58.5m.5R.rV,1w:"7W"};2X[1R.2i.3g]={cg:2,1z:"3g",80:QB.1d.2d.58.5m.5R.8T,1w:"3g"};2X[1R.2i.bT]={cg:3,1z:"bT",80:QB.1d.2d.58.5m.5R.dV,1w:"2n"};2X[1R.2i.aa]={cg:4,1z:"aa",80:QB.1d.2d.58.5m.5R.8w,1w:"1Y"};2X[1R.2i.8H]={cg:5,1z:"8H",80:QB.1d.2d.58.5m.5R.dP,1w:"2n"};2X[1R.2i.6S]={cg:6,1z:"6S",80:QB.1d.2d.58.5m.5R.jk,1w:"2n"};2X[1R.2i.dz]={cg:7,1z:"dz",80:QB.1d.2d.58.5m.5R.gM,1w:"7W"};2X[1R.2i.bX]={cg:8,1z:"bX",80:QB.1d.2d.58.5m.5R.xG,1w:"2n"};2X[1R.2i.8c]={cg:9,1z:"8c",80:QB.1d.2d.58.5m.5R.rI,1w:"1Y"};1n(K i=0;i<QB.1d.2U.gN;i++){2X[1R.2i.n3+i]={cg:10+i,1z:"xz",80:QB.1d.2d.58.5m.5R.Ie,1w:"1Y"}}1b 2X}};QB.1d.2U.2l={vx:"Xd",vh:"Xc",fA:"vC",u2:"u2",uf:"uf"};(1a($){$.8F("ui.8L",QB.1d.2U);$.4m($.ui.8L,{Ia:"Xg I9 rH ip eY",5N:"1.7.1"})})(2u);QB.1d.2d.eI={fz:0,6r:1,yt:2,tD:3,FS:4};QB.1d.2d.6u={};QB.1d.2d.6u[QB.1d.2V.6B.Iq]={3S:"WB fY",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.Ij]={3S:"h8",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.Io]={3S:"WA fY",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.ma]={3S:"is h2 to",7x:1,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.Im]={3S:"wS 5L 2J fY",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.I5]={3S:"wS 5L Wz",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.HO]={3S:"wS 5L 4x fY",7x:1,72:[QB.1d.2V.5Y.9P]};QB.1d.2d.6u[QB.1d.2V.6B.xc]={3S:"is in 4L",7x:1,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.HL]={3S:"is 5L h2 to",7x:1,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.xb]={3S:"is 5L in 4L",7x:1,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.HZ]={3S:"is 1c",7x:0,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.I3]={3S:"is 5L 1c",7x:0,72:[]};QB.1d.2d.6u[QB.1d.2V.6B.HU]={3S:"is FT s3",7x:1,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.6u[QB.1d.2V.6B.FQ]={3S:"is FT s3 or h2 to",7x:1,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.6u[QB.1d.2V.6B.FM]={3S:"is FX s3",7x:1,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.6u[QB.1d.2V.6B.G6]={3S:"is FX s3 or h2 to",7x:1,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.6u[QB.1d.2V.6B.FY]={3S:"is Fm",7x:2,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.6u[QB.1d.2V.6B.Ft]={3S:"is 5L Fm",7x:2,72:[QB.1d.2V.5Y.fw,QB.1d.2V.5Y.5k]};QB.1d.2d.hb={};QB.1d.2d.hb[QB.1d.2V.9L.92]={3S:"92",gY:"6k"};QB.1d.2d.hb[QB.1d.2V.9L.tm]={3S:"g0 92",gY:"Y7"};QB.1d.2d.hb[QB.1d.2V.9L.o9]={3S:"o9",gY:"Y5"};QB.1d.2d.hb[QB.1d.2V.9L.k3]={3S:"k3",gY:"3t"};QB.1d.ug=1a(){J.$1w=1c};QB.1d.oa=1S 5X({$1w:"dE.nU.1d.cY.nV.x8, dE.nT.1d.cY",4k:1c,2P:[],4A:QB.1d.2d.eI.fz,6r:1c,7v:QB.1d.2V.6B.ma,5V:1c,78:1c,dk:1j,fB:1j,1f:1c,9s:1a(){K 9s=J;44(9s.4k!=1c){9s=9s.4k}1b 9s},tA:1a(1N){1N.$1w=J.$1w;1N.4A=J.4A;1N.6r=J.6r;1N.7v=J.7v;1N.5V=J.5V;1N.78=J.78},ti:1a(1N){1N.2P=[];$.2g(J.2P,1a(1P,1g){1N.2P.1C(1g.h0())})},h0:1a(){K 1N=$.4m(1S QB.1d.ug,1S QB.1d.2d.x8);J.tA(1N);J.ti(1N);1b 1N},Fn:1a(1N){K 1J=1c;if(1N==1c){1b 1J}3q(1N.4A){1l QB.1d.2d.eI.6r:1J=1S QB.1d.yp(J);1J.nX(1N);1p;1l QB.1d.2d.eI.yt:1J=1S QB.1d.yC(J);1J.nX(1N);1p;1l QB.1d.2d.eI.tD:1J=1S QB.1d.tS(J);1J.nX(1N);1p}1b 1J},nX:1a(1N){K me=J;J.4A=1N.4A;J.6r=1N.6r;J.7v=1N.7v;J.az=1N.az;J.94=1N.94;J.5V=1N.5V;J.78=1N.78;$.2g(1N.2P,1a(1P,1g){me.2P.1C(me.Fn(1g))})},xM:1a(5T){J.6r=5T;if(J.6r!=1c){if(QB.1d.2d.6u[J.7v].72.1e!=0&&!QB.1d.2d.6u[J.7v].72.h8(J.7v)){J.7v=QB.1d.2V.6B.ma}}1i{J.7v=QB.1d.2V.6B.ma}},8V:1a(){if(J.4k==1c){1b-1}1b J.4k.2P.4Y(J)},Y8:1a(){if(J.4k==1c){1b 1c}K i=J.4k.2P.4Y(J);if(i>=J.4k.2P.1e-1){1b 1c}1b J.4k.2P[i+1]},oc:1a(){if(J.4k==1c){1b 1c}K i=J.4k.2P.4Y(J);if(i<=0){1b 1c}1b J.4k.2P[i-1]},FC:1a(){if(J.4k==1c){1b 0}1b J.4k.2P.1e},yq:1a(){1b QB.1d.2d.6u[J.7v]},tf:1a(){K 1J="";if(!J.9s().nv){1b 1J}if(J.oc()==1c){1b 1J}if(J.4k==1c){1b 1J}3q(5W(J.4k.94)){1l QB.1d.2V.9L.92:;1l QB.1d.2V.9L.tm:1J=$("<2E> nc </2E>");1p;1l QB.1d.2V.9L.o9:;1l QB.1d.2V.9L.k3:1J=$("<2E> or </2E>");1p}1b 1J},CA:1a(){K 1F={};$.2g(J.9s().tZ,1a(1P,5T){1F[5T.3S]={1z:5T.3S,3L:"2j",1h:5T}});1b 1F},DJ:1a(1g){K 1F={};$.2g(QB.1d.2d.6u,1a(1P,1f){if(1g.6r!=1c){if(1f.72.1e!=0){if(1g.6r!=1c&&1f.72.h8(1g.6r.mn)){1F[1P]={1z:1f.3S,3L:"",1h:1f}}}1i{1F[1P]={1z:1f.3S,3L:"",1h:1f}}}});1b 1F},Dz:1a(1g){K 1F={};$.2g(QB.1d.2d.hb,1a(1P,1f){1F[1P]={1z:1f.3S,3L:"",1h:1f}});1b 1F},tj:1a(){K 1F={};1F["cV-up"]={1z:"k7 up",3L:"cV-up",2x:J.8V()<=0};1F["cV-cT"]={1z:"k7 cT",3L:"cV-cT",2x:J.8V()>=J.FC()-1};1F["5o"]="---------";1b 1F},7t:1a(){J.mt()},i7:1a(){1b 1o},mt:1a(){if(J.6r==1c){J.dk=1o;J.fB=1o;1b}if(J.7v==QB.1d.2V.6B.xc||J.7v==QB.1d.2V.6B.xb){1b!1K(J.5V)}3q(J.6r.mn){1l QB.1d.2V.5Y.k6:;1l QB.1d.2V.5Y.5k:;1l QB.1d.2V.5Y.9P:;1l QB.1d.2V.5Y.fz:J.dk=!1K(J.5V);J.fB=!1K(J.78);1p;1l QB.1d.2V.5Y.fw:J.dk=!1K(J.5V)&&$.Fy(J.5V);J.fB=!1K(J.78)&&$.Fy(J.78);1p}},eX:1a(){J.7t()},j9:1a(){1b{}},Fw:1a(){K 1P=J.8V();K 1g=J.4k.2P[1P];if(1P<=0||(J.4k==1c||J.1f==1c)){1b 1j}K xa=1P-1;K h7=J.4k.2P[xa];if(h7==1c||h7.1f==1c){1b 1j}J.1f.76(h7.1f);J.4k.2P[1P]=h7;J.4k.2P[xa]=1g;1b 1o},FB:1a(){K 1P=J.8V();K 1g=J.4k.2P[1P];if(J.4k==1c||(J.1f==1c||1P>=J.4k.2P.1e-1)){1b 1j}K cO=1P+1;K gK=J.4k.2P[cO];if(gK==1c||gK.1f==1c){1b 1j}gK.1f.76(J.1f);J.4k.2P[1P]=gK;J.4k.2P[cO]=1g;1b 1o},FA:1a(){K 1P=J.8V();J.4k.2P.3u(1P);J.1f.3u();1b 1o},GD:1a(){$.2g(J.2P,1a(1P,1g){1g.1f.3u()});J.2P=[];1b 1o},i6:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.j5(1g.7t())}1i{1g.oc().1f.tP(1g.7t())}},xN:1a(){K 1g=1S QB.1d.yp(J.4k);J.4k.2P.1C(1g);J.4k.i6(1g);1b 1g},GC:1a(){K 1g=1S QB.1d.yC(J.4k);J.4k.2P.1C(1g);J.4k.i6(1g);1b 1g},GG:1a(){K 1g=1S QB.1d.tS(J.4k);J.4k.2P.1C(1g);J.4k.i6(1g);1b 1g},tV:1a(1q){3q(1q){1l"cV-up":1b J.Fw();1p;1l"cV-cT":1b J.FB();1p;1l"41":1b J.FA();1p;1l"af":1b J.GD();1p;1l"51-8c-1n-5T":1b J.xN();1p;1l"51-tl-8c":1b J.GC();1p;1l"51-bL-of-tE":1b J.GG();1p}1b 1j},yb:1a(1q,5T){J.xM(5T);J.eX();1b 1o},Dq:1a(1q){J.7v=1q;J.eX();1b 1o},Cu:1a(1q){J.94=1q;J.eX();1b 1o},bJ:1a(1L){if(1L!==2O){J.4k=1L}}});QB.1d.yp=1S 5X({bN:QB.1d.oa,4A:QB.1d.2d.eI.6r,$1w:"dE.nU.1d.cY.nV.GB, dE.nT.1d.cY",j9:1a(){K 1F=J.tj();1F["41"]={1z:"hc",3L:"xW"};1b 1F},i7:1a(){if(J.6r==1c){1b 1j}K yg=J.yq();if(yg!=1c){3q(yg.7x){1l 2:1b J.dk&&J.fB;1p;1l 1:1b J.dk;1p;1l 0:1b 1o;1p}}1b 1o},hV:1a($1f,du,5T){K me=J;if(1K(du)){du=1}K 2h="";if(du==2){if(!1K(J.78)){2h=J.78}}1i{if(!1K(J.5V)){2h=J.5V}}K $29=$(\'<29 1m="\'+2h+\'">\').h3(1a(1H){if(1H.3H==10||1H.3H==13){1H.4g();J.4P()}});if(!1K(5T)&&5T.mn==QB.1d.2V.5Y.5k){$29.u5({fE:1a(2h,Yl){$29.2h(2h);if(du==2){me.78=2h}1i{me.5V=2h}me.mt(2h,du)},Yn:1a(){2h=$29.2h();if(du==2){me.78=2h}1i{me.5V=2h}me.eX()}});$29.e7($1f).2R()}1i{$29.e7($1f);$29.2R();6y(1a(){$29.4P(1a(){K 2h=$29.2h();if(du==2){me.78=2h}1i{me.5V=2h}me.mt(2h,du);me.eX()})},93)}},7t:1a(){K me=J;J.1L(2q);if(J.1f==1c){J.1f=$(\'<2F 2C="qb-ui-4F-4E-6X 1g">\')}J.1f.c0();J.1f.1h("1g",J);J.1f.3a($(\'<2F 2C="qb-ui-4F-4E-3C 6N">\'));J.1f.3a(" ");J.1f.3a(J.tf());K 5T=J.6r;if(1K(5T)){J.1f.3a($(\'<a 2C="qb-ui-4F-4E-1W-2j-2n 95" 5d="#">[2n 5T]</a>\'))}1i{J.1f.3a($(\'<a 2C="qb-ui-4F-4E-1W-2j-2n" 5d="#">\'+5T.3S+"</a>"))}J.1f.3a(" ");K Gd=QB.1d.2d.6u[J.7v].3S;J.1f.3a($(\'<a 2C="qb-ui-4F-4E-1W-7J" 5d="#">\'+Gd+"</a>"));J.1f.3a(" ");K G9=J.yq();K $9D;K $eo;3q(5W(G9.7x)){1l 1:if(1K(J.5V)){$9D=$(\'<a 2C="qb-ui-4F-4E-1W-1m 95" 5d="#">[tv 1m]</a>\')}1i{$9D=$(\'<a 2C="qb-ui-4F-4E-1W-1m" 5d="#">\'+J.5V+"</a>")}$9D.3I(1a(e){K $1f=$(J);me.hV($1f,1,5T);$1f.3J()});J.1f.3a($9D);if(!1K(J.5V)&&!J.dk){$9D.2t("95");J.1f.3a(\' <2E 2C="u0-1m">Gc 1m</2E>\')}1p;1l 2:if(1K(J.5V)){$9D=$(\'<a 2C="qb-ui-4F-4E-1W-1m 95" 5d="#">[tv 1m]</a>\')}1i{$9D=$(\'<a 2C="qb-ui-4F-4E-1W-1m" 5d="#">\'+J.5V+"</a>")}if(!J.dk){$9D.2t("95")}$9D.3I(1a(e){K $1f=$(J);me.hV($1f,1,5T);$1f.3J()});J.1f.3a($9D);J.1f.3a($("<2E> nc </2E>"));if(1K(J.78)){$eo=$(\'<a 2C="qb-ui-4F-4E-1W-1m 95" 5d="#">[tv 1m]</a>\')}1i{$eo=$(\'<a 2C="qb-ui-4F-4E-1W-1m" 5d="#">\'+J.78+"</a>")}if(!J.fB){$eo.2t("95")}$eo.3I(1a(e){K $1f=$(J);me.hV($1f,2,5T);$1f.3J()});J.1f.3a($eo);if(!1K(J.5V)&&!J.dk||!1K(J.78)&&!J.fB){if(!1K(J.5V)&&!J.dk){$9D.2t("95")}if(!1K(J.78)&&!J.fB){$eo.2t("95")}J.1f.3a(\' <2E 2C="u0-1m">Gc 1m</2E>\')}1p}if(!1K(5T)&&5T.mn==QB.1d.2V.5Y.5k){if(!1K($9D)){$9D.u5()}if(!1K($eo)){$eo.u5()}}1b J.1f},bJ:1a(1L){J.1L(1L)}});QB.1d.yC=1S 5X({bN:QB.1d.oa,4A:QB.1d.2d.eI.yt,$1w:"dE.nU.1d.cY.nV.yr, dE.nT.1d.cY",az:"",tC:1j,j9:1a(){K 1F=J.tj();1F["41"]={1z:"hc",3L:"xW"};1b 1F},h0:1a(){K 1N=$.4m(1S QB.1d.ug,1S QB.1d.2d.yr);J.tA(1N);1N.az=J.az;J.ti(1N);1b 1N},i7:1a(){1b J.tC},mt:1a(2h,du){J.tC=!1K(J.az)},hV:1a($1f){K me=J;K 2h="";if(!1K(J.az)){2h=J.az}K $29=$(\'<29 1m="\'+2h+\'">\').h3(1a(1H){if(1H.3H==10||1H.3H==13){1H.4g();J.4P()}}).4P(1a(){me.az=$29.2h();me.5V=me.az;me.eX()}).e7($1f).2R()},7t:1a(){K me=J;J.1L(2q);if(J.1f==1c){J.1f=$(\'<2F 2C="qb-ui-4F-4E-6X 1g">\').1h("1g",J)}J.1f.c0();J.1f.3a($(\'<2F 2C="qb-ui-4F-4E-3C 6N">\'));K $hX;J.1f.3a(J.tf());if(1K(J.az)){$hX=$(\'<a 2C="qb-ui-4F-4E-1W-1m 95" 5d="#">[tv 8c]</a>\')}1i{$hX=$(\'<a 2C="qb-ui-4F-4E-1W-1m" 5d="#">\'+J.az+"</a>")}if(!J.tC){$hX.2t("95")}$hX.3I(1a(e){K $1f=$(J);$1f.3J();me.hV($1f)});J.1f.3a($hX);1b J.1f},bJ:1a(1L){J.1L(1L)}});QB.1d.tS=1S 5X({bN:QB.1d.oa,4A:QB.1d.2d.eI.tD,$1w:"dE.nU.1d.cY.nV.xT, dE.nT.1d.cY",94:QB.1d.2V.9L.92,h0:1a(){K 1N=$.4m(1S QB.1d.ug,1S QB.1d.2d.xT);J.tA(1N);1N.94=J.94;J.ti(1N);1b 1N},i7:1a(){K 1J=1o;if(J.2P.1e==0&&J.4k!=1c){1b 1j}$.2g(J.2P,1a(1P,1g){if(!1g.i7()){1J=1j;1b 1j}});1b 1J},j9:1a(){K 1F=J.tj();1F["af"]={1z:"xS",3L:"xR",2x:J.2P.1e<=0};1F["41"]={1z:"hc",3L:"xW"};1b 1F},i6:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.6C(".qb-ui-4F-4E-4o").j5(1g.7t())}1i{1g.oc().1f.tP(1g.7t())}},y0:1a(){1b QB.1d.2d.hb[J.94]},7t:1a(){J.1L(2q);if(J.1f==1c){J.1f=$(\'<2F 2C="qb-ui-4F-4E-6X bL">\')}J.1f.1h("1g",J);J.1f.c0();J.1f.3a($(\'<2F 2C="qb-ui-4F-4E-3C aj">\'));K iA=J.y0();K $3x=$(\'<2F id="qb-ui-4F-4E-3x">\');$3x.3a(J.tf());K $a=$(\'<a 2C="qb-ui-4F-4E-1W-y7" 5d="#">\'+iA.3S+"</a>");$3x.3a($a);$3x.3a($("<2E> "+J.9s().iC+"</2E>"));J.1f.3a($3x);K $4o=$(\'<2F 2C="qb-ui-4F-4E-4o \'+iA.gY+\'">\');$.2g(J.2P,1a(1P,1g){$4o.3a(1g.7t())});K tK=1S QB.1d.tO(J);$4o.3a(tK.7t());J.1f.3a($4o);1b J.1f},bJ:1a(1L){J.1L(1L);if(1L!=1c){3q(5W(1L.94)){1l QB.1d.2V.9L.92:;1l QB.1d.2V.9L.tm:J.94=QB.1d.2V.9L.o9;1p;5n:J.94=QB.1d.2V.9L.92}}}});QB.1d.tO=1S 5X({bN:QB.1d.oa,4A:QB.1d.2d.eI.FS,j9:1a(){K 1F={"51-8c-1n-5T":{1z:"eR 8c 1n 5T",3L:"51-8c-1n-5T"},"51-tl-8c":{1z:"eR tl 8c",3L:"51-tl-8c"},"5o":"---------","51-bL-of-tE":{1z:"eR bL of tE",3L:"51-bL-of-tE"}};1b 1F},7t:1a(){if(J.1f==1c){J.1f=$(\'<2F 2C="qb-ui-4F-4E-6X 51">\').1h("1g",J)}J.1f.c0();J.1f.3a($(\'<2F 2C="qb-ui-4F-4E-3C lN">\'));J.1f.3a($(\'<a 2C="qb-ui-4F-4E-1W-2j-2n" 5d="#">[...]</a>\'));1b J.1f},yb:1a(1q,5T){K 1g=J.xN();1g.xM(5T);1g.eX();1b 1o},bJ:1a(1L){J.1L(1L)}});QB.1d.7r=1S 5X({bN:QB.1d.tS,$1w:"dE.nU.1d.cY.nV.xY, dE.nT.1d.cY",4k:1c,np:"Is",iC:"of iM Xv XQ",nv:1o,2P:[],hW:1a(1h){J.tZ=1h.tZ;J.2P=[];J.nX(1h);J.xZ()},Dr:1a(){K me=J;K 5s=".qb-ui-4F-4E-3C";$.2M("69",5s);$.2M({3T:5s,4j:cG,6M:{6O:0},2c:"2a",1F:{},9z:1a($2c,e){K 1g=$2c.cB(".qb-ui-4F-4E-6X:4t").1h("1g");if(1g==1c){1b 1j}K 1F=1g.j9();if(1F==1c||4K.81(1F).1e==0){1b 1j}1b{1Z:1a(1q){1g.tV(1q,1F[1q].1h)},1F:1F}}})},I7:1a(){K me=J;K 5s=".qb-ui-4F-4E-1W-7J";$.2M("69",5s);$.2M({3T:5s,4j:cG,6M:{6O:0},2c:"2a",1F:{},9z:1a($2c,e){K 1g=$2c.cB(".qb-ui-4F-4E-6X:4t").1h("1g");if(1g==1c){1b 1j}K 6Q=1g.DJ(1g);if(6Q==1c||4K.81(6Q).1e==0){1b 1j}1b{1Z:1a(1q){1g.Dq(1q)},1F:6Q}}})},HQ:1a(){K me=J;K 5s=".qb-ui-4F-4E-1W-y7";$.2M("69",5s);$.2M({3T:5s,4j:cG,6M:{6O:0},2c:"2a",1F:{},9z:1a($2c,e){K 1g=$2c.cB(".qb-ui-4F-4E-6X:4t").1h("1g");if(1g==1c){1b 1j}K 6Q=1g.Dz(1g);if(6Q==1c||4K.81(6Q).1e==0){1b 1j}1b{1Z:1a(1q){1g.Cu(1q)},1F:6Q}}})},CP:1a(){K me=J;K 5s=".qb-ui-4F-4E-1W-2j-2n";$.2M("69",5s);K 1T=$.2M({3T:5s,4j:cG,6M:{6O:0},2c:"2a",1F:{},bK:"XI",9z:1a($2c,e){K 1g=$2c.cB(".qb-ui-4F-4E-6X:4t").1h("1g");if(1g==1c){1b 1j}K 1F=1g.CA();if(1F==1c||4K.81(1F).1e==0){1b 1j}1b{1Z:1a(1q){1g.yb(1q,1F[1q].1h)},1F:1F}}})},xZ:1a(){K me=J;J.2p.c0();J.2p.3a(J.7t());1b;K $4o=$(\'<2F 2C="qb-ui-4F-4E-4o 6k">\');$.2g(J.2P,1a(1P,1g){$4o.3a(1g.7t())});K ET=1S QB.1d.tO(J);$4o.3a(ET.7t());J.2p.3a($4o);J.1f=$4o},i6:1a(1g){K 1P=1g.8V();if(1P==0){J.1f.6C(".qb-ui-4F-4E-4o").j5(1g.7t())}1i{1g.oc().1f.tP(1g.7t())}},7t:1a(){if(J.1f==1c){J.1f=$(\'<2F 2C="qb-ui-4F-4E-6X bL 2p">\').1h("1g",J)}J.1f.c0();K iA=J.y0();K $3x=$(\'<2F id="qb-ui-4F-4E-3x">\');$3x.3a("<2E>"+J.9s().np+" </2E>");K $a=$(\'<a 2C="qb-ui-4F-4E-1W-y7" 5d="#">\'+iA.3S+"</a>");$3x.3a($a);$3x.3a($("<2E> "+J.9s().iC+"</2E>"));J.1f.3a($3x);K $4o=$(\'<2F 2C="qb-ui-4F-4E-4o \'+iA.gY+\'">\');$.2g(J.2P,1a(1P,1g){$4o.3a(1g.7t())});K tK=1S QB.1d.tO(J);$4o.3a(tK.7t());J.1f.3a($4o);1b J.1f},h0:1a(){K 1N=1S QB.1d.2d.xY;1N.94=J.94;1N.2P=[];$.2g(J.2P,1a(1P,1g){1N.2P.1C(1g.h0())});1b 1N},61:1a(1Z){QB.1d.2k.49.7r=J.h0();QB.1d.2k.61(1Z)},89:1a(1Z){QB.1d.2k.49.7r=1c;QB.1d.2k.61(1Z)},bJ:1a(1L){J.2p=$("#qb-ui-4F-4E");if(J.2p.1e){if(!1K(J.2p.1k("iC"))){J.iC=J.2p.1k("iC")}if(!1K(J.2p.1k("np"))){J.np=J.2p.1k("np")}if(!1K(J.2p.1k("nv"))){J.nv=J.2p.1k("nv").3R()=="1o"}}J.1L(1c);J.xZ();J.Dr();J.CP();J.I7();J.HQ()}});QB.1d.7r.2l={Gn:"Gn",Gq:"Gq"};K 5N=4;K K3=1o;K sn="nf/";K At="1.11.0";K IF="1.99.99";K BC="1.11.0";K IT="1.99.99";K IG="yi ub Gz.js is 5L 9Z.";K Aq="2u GN is 5L 8K.";K IQ="ud GN is 5L 8K.";K IB="GI 2u 5N v.$1 GJ! 2u v.$2 or GK 2s 1.XX GR is GS.";K Ka="GI ud 5N v.$1 GJ! ud v.$2 or GK 2s 1.XX GR is GS.";K JN=\'Rd Rg u8 cg. 2u nc ud Rc be 9Z yj u8 iM "Gz.js"\';K Gx=\'Rn nf RJ is RI. Fv fb Fq "RW.6t" RZ.\';K l7=1j;K 5G=1a(){J.3X=1c;J.ws=1c;J.1V=1c;J.3M=1c;J.4X=[];J.eP={};J.5F=[];J.7Q=1c;J.ty=1c;J.lH=1j;J.3h=1c;J.gP=1c;J.cu="";J.9d={};J.gR=1c;J.9b=1c;J.7r=1c;J.x6=1c;J.nh=1j;J.ao=0;J.tU=1o;J.uc=1a(9f){K rX=QB.1d.2k.hD[9f];if(!1K(rX)){J.vM(1c,rX.2f);J.vD(1c,rX.2U)}QB.1d.2k.eC=9f};J.t6=1a(47){K me=J;if(47.cK=="G3-FO-Rz"){J.uc(47.3h)}if(QB.1d.2k.ed){6y(1a(){me.t6(47)},50);1b}QB.1d.2k.49.wQ.1C(47);QB.1d.2k.61()};J.LT=1a(e,1W){K 1N=1W.1N();if(1W.7Z){QB.1d.2f.74.3u(1W)}QB.1d.2k.HJ(1N);QB.1d.2k.61()};J.vs=1a(e,1h){K 47=1h.47;K 1g=1h.1g;QB.1d.2k.49.f9.cc=47;QB.1d.2k.49.f9.fd=1g.1h;QB.1d.2k.49.f9.In="1V";QB.1d.2k.61()};J.vR=1a(e,1x){K 1M=1x.1M;K 2j=1x.2j;K 8W=1x.8W;K wY=QB.1d.2f.xx(1M.x0);if(wY==1c){$.2g(1M.6j,1a(i,f){if(fa(f.88,2j.88)){f.eD=1o}});K 1x={1D:1M,8W:8W};J.kK(e,1x)}1i{wY.6V("ih",2j.88,1o,1o)}};J.kK=1a(e,1x){1x.1D.6U=1o;K 1u=J.bS(1x);K 9m=1x.1D;if(1x.8W&&1x.8W.1e>=2){9m.X=1x.8W[0];9m.Y=1x.8W[1]}K 5d=$(1u).1h("me");if(5d!=1c){9m.65=5d.65}if(J.1V!=1c){J.1V.2c(QB.1d.2f.2l.xD,1u)}QB.1d.2k.Ii(9m);QB.1d.2k.ho()};J.vl=1a(e,1h){K 1u=$(1h);K 9m=1u.1h("4q");QB.1d.2k.If(9m);QB.1d.2k.ho()};J.LB=1a(e,1h){QB.1d.2k.tR([1h.1I.1N()]);QB.1d.2k.ho()};J.Kv=1a(e,1h){K 59=1h.59;QB.1d.2k.tR([59]);QB.1d.2k.ho()};J.Hi=1a(1M,2j){K 3g="";3g+=!1K(1M.iR)?1M.iR:1M.3S;3g+="."+2j.88;1b 3g};J.xv=1a(e,1h){QB.1d.2k.H9(1h);QB.1d.2k.61()};J.xp=1a(e,1W){K 8n=QB.1d.2f.xx(1W.xE);if(8n!=1c){K $1V=$("#qb-ui-1V");if(8n[0].8l<$1V.4S()||(8n[0].9p<$1V.5a()||(8n[0].8l+8n.1r()>$1V.4S()+$1V.1r()||8n[0].9p+8n.1y()>$1V.5a()+$1V.1y()))){K x=8n[0].8l+8n.1r()/ 2 - $1V.1r() /2;K y=8n[0].9p+8n.1y()/ 2 - $1V.1y() /2;$1V.4J({4S:x,5a:y},kI)}8n.2D(".qb-ui-1M-bq").He("sb",{},rL).He("sb",{},rL);1b}K 1x=1c;if(1W.iY==1c){1x={1D:{3h:1W.xE,6G:1W.6G,bs:1W}}}1i{1W.iY.bs=1W;1x={1D:1W.iY}}J.kK(1c,1x)};J.xu=1a(e,d){K 5K=d.5K;K 2X=[];1n(K i=0;i<5K.1e;i++){K 1h=5K[i];K 3B=1h.3B;K 3g=J.Hi(1h.1L,1h.1D);K rG=J.3M.8L("rH",3g);1n(K j=0;j<rG.1e;j++){K 1I=rG[j];if(3B){if(1I.fb(3B)){2X.1C(1I.1N())}}1i{if(1I.Hw()){if(1I.fb(3B)){2X.1C(1I.1N())}}1i{2X.1C(1I.1N());J.3M.8L("hN",1I)}}}if(3B&&rG.1e==0){K rU=1S QB.1d.2d.xo;rU.8T=3g;rU.b8=3B;K Cw=J.3M.8L("ip",rU);2X.1C(Cw.1N())}}};J.bS=1a(1x,5P){K 1u=QB.1d.2f.bS(1x,5P);if(5P===2O||5P==1c){1u.4N(QB.1d.7c.2l.nI,J.xu,J);1u.4N(QB.1d.7c.2l.nF,J.xv,J);1u.4N(QB.1d.7c.2l.kN,J.xp,J);1u.4N(QB.1d.7c.2l.kE,J.jC,J)}J.3M.8L("kR");1b 1u};J.gW=1a(1x,5P,hL){K 1u=QB.1d.2f.gW(1x,5P,hL);J.3M.8L("kR");1b 1u};J.t5=1a(1u){};J.kP=1a(){QB.1d.2k.49.hK.1C("kP");J.xq();J.um();QB.1d.2k.61()};J.Mj=1a(){QB.1d.2k.49.hK.1C("kP");J.xq();QB.1d.2k.zK(1c);QB.1d.2k.61()};J.xq=1a(){QB.1d.2k.49.7h=1S QB.1d.2d.kC;QB.1d.2k.49.7h.cc="4u"};J.Ld=1a(){J.tU=1o;J.KD()};J.um=1a(){K bF=1c;if(J.a6!=1c&&(J.a6.1e>0&&J.a6.is(":6H"))){bF=J.a6.2h()}1i{bF=J.ty}J.7Q=bF;QB.1d.2k.zK(J.7Q);1b 1o};J.Dc=1a(){QB.1d.2k.49.9b=J.9b;1b 1o};J.tQ=1a(1Y){J.9F.4h("95 96");J.9F.2t("tu");J.9F.42(1Y)};J.Qq=1a(1Y){J.9F.4h("96 tu");J.9F.2t("95");J.9F.42(1Y)};J.Qr=1a(1Y){J.9F.4h("95 tu");J.9F.2t("96");J.9F.42(1Y)};J.Kh=1a(){if(J.tU){if(QB.1d.2k.hQ!=J.a6.2h()){J.tQ(QB.1d.2d.58.5m.D6);QB.1d.2k.hQ=J.a6.2h()}}};J.L6=1a(e,1D){K 1x={1D:1D};J.kK(1c,1x)};J.jC=1a(e,9f){K me=J;if(QB.1d.2k.ed){6y(1a(){me.jC(e,9f)},50);1b}if(!1K(9f)){J.uc(9f);QB.1d.2k.49.eC=9f;QB.1d.2k.61()}};J.Lv=1a(e,47){QB.1d.5G.t6(47)};J.Kl=1a(e,1h){J.3X.hW(1h)};J.Fc=1a(4X){if(4X==1c){1b 1j}if(4X.1e==0){1b 1j}QB.1d.2f.74.zP();1n(K 1P=0;1P<4X.1e;1P++){K 9w=4X[1P];K d5=1c;if(9w.4U!=1c&&9w.4T!=1c){d5=QB.1d.2f.74.zG(9w.4U.aC,9w.4T.aC)}if(d5==1c){QB.1d.2f.74.t4(9w)}1i{d5.su=1j;QB.1d.2f.74.zz(d5,9w)}}QB.1d.2f.74.zD()};J.ED=1a(iO){if(iO==1c){1b}K 8J=iO.3G();K iv=[];K iw=[];K ir=[];K me=J;1n(K i=QB.1d.2f.5F.1e-1;i>=0;i--){K 1u=QB.1d.2f.5F[i];K iK=1u.1h("1D");K dC=1c;1n(K j=8J.1e-1;j>=0;j--){K 8b=8J[j];if(QB.1d.2f.Aa(iK,8b)){8J.3u(j);dC=8b;1p}}if(dC==1c){1n(K j=8J.1e-1;j>=0;j--){K 8b=8J[j];if(QB.1d.2f.Ab(iK,8b)){8J.3u(j);dC=8b;1p}}}if(dC!=1c){iw.1C({1N:8b,5P:1u})}1i{iv.1C(1u)}}$.2g(8J,1a(1P,8b){ir.1C(8b)});$.2g(iw,1a(1P,1u){me.gW({1D:1u.1N},1u.5P,1o)});$.2g(iv,1a(1P,1u){QB.1d.2f.t5(1u,1o)});$.2g(ir,1a(1P,1u){me.bS({1D:1u})})};J.vM=1a(e,1V){J.ED(1V.gX);J.Fc(1V.74);if(1V.rT!=1c){QB.1d.2f.Ff(1V.rT.dn)}if($("#qb-ui-1V").is(":6H")){QB.1d.2f.dp()}};J.Kn=1a(e,9S){if(J.9S!=1c){J.9S.F8(9S)}};J.KK=1a(e,bV){K me=J;if(1K(bV)){1b}J.gR=bV;if(J.gP!=1c){J.gP.wq(J.gR)}if(J.9S!=1c){J.9S.F1(J.gR)}};J.KR=1a(e,1T){if(J.2f!=1c){J.2f.eY(1T.2f);J.2f.F6(1T.F7);J.2f.F5(1T.cM)}J.3M.8L("eY",1T.2U);J.eY(1T.F4,"#qb-ui-1V-dW-lN-3C");J.eY(1T.eR,"#qb-ui-1V-eW-lN-3C")};J.KP=1a(e,sc){if(sc==1c){1b}K me=J;K sh=0;if(J.au.1e>0){sh=J.au[J.au.1e-1].Id}1n(K 1P=0;1P<sc.2P.1e;1P++){K cD=sc.2P[1P];if(sh==1c||cD.Id>sh){J.au.1C(cD);K yN="Ou";if(cD.4A==2){yN="Oh"}if(cD.4A==3){yN="9h"}K Ps=s5(cD.zi).6s("H:i:s")}}};J.vD=1a(e,3M){if(3M==1c||3M.cw==1c){1b}K me=J;me.3M.8L("NK",3M);me.3M.8L("MR")};J.KN=1a(e,bF){if(bF!==" "&&1K(bF)){1b}J.a6.2h(bF);J.ty=bF;J.hQ=bF};J.L3=1a(e,9s){if(1K(9s)){1b}if(J.7r==1c){1b}J.7r.hW(9s)};J.Pi=1a(1Z){J.uz(1a(1h){if(1Z&&7T(1Z)=="1a"){1Z(1h.fM)}})};J.O1=1a(1v,1Z){QB.1d.2k.49.fM=1v;1b QB.1d.2k.tn(1Z)};J.NA=1a(NC,Np){};J.vC=1a(e,1h){K 1I=1h.1I;K 1q=1h.1q;K 5C=1h.5C;K 4f=1h.4f;K 2X=[];K 59=1I.1N();if(1I.7Z){K 3g=59.8T;if(!1K(3g)&&3g.4Y(".")!=-1){K 8o=3g.79(0,3g.4Y("."));K 9N=3g.79(3g.4Y(".")+1);K 1M=QB.1d.2f.lh(8o);if(1M!=1c){1M.6V("ih",9N,1j)}}}3q(1q){1l 1R.2i.1Q:K 3g=59.8T;if(!1K(3g)&&3g.4Y(".")!=-1){K 8o=3g.79(0,3g.4Y("."));K 9N=3g.79(3g.4Y(".")+1);K 1M=QB.1d.2f.lh(8o);if(1M!=1c){1M.6V("ih",9N,4f)}}2X.1C(59);1p;1l 1R.2i.3g:K 1Q=59.b8;if(1K(5C)&&5C!=4f){1Q=1o;59.b8=1o}K 3g=5C;if(!1K(3g)&&3g.4Y(".")!=-1){K 8o=3g.79(0,3g.4Y("."));K 9N=3g.79(3g.4Y(".")+1);K 1M=QB.1d.2f.lh(8o);if(1M!=1c){1M.6V("ih",9N,1j)}}3g=4f;if(1Q&&(!1K(3g)&&3g.4Y(".")!=-1)){K 8o=3g.79(0,3g.4Y("."));K 9N=3g.79(3g.4Y(".")+1);K 1M=QB.1d.2f.lh(8o);if(1M!=1c){1M.6V("ih",9N,1Q)}}2X.1C(59);1p;1l 1R.2i.8H:;1l 1R.2i.6S:K z5=J.3M.8L("Ni");1n(K i=0;i<z5.1e;i++){2X.1C(z5[i].1N())}1p;5n:2X.1C(59)}QB.1d.2k.tR(2X);QB.1d.2k.61()};J.zc=1a(6Q){if(6Q==1c||6Q.1e==0){1b 1c}K 1F={};K 4R;1n(K i=0;i<6Q.1e;i++){4R=6Q[i];if(4R.3S!=1c&&4R.3S.79(0,1)=="-"){1F[4R.cK]=4R.3S}1i{1F[4R.cK]={1z:4R.3S,3L:4R.cK,1F:J.zc(4R.2P),1h:4R.3h}}}1b 1F};J.eY=1a(1T,5s){K me=J;if(1K(1T)||1T.2P.1e==0){1b}K 1F=J.zc(1T.2P);K $5s=$(5s);if($5s.1e>0){$5s[0].Mp=0}$5s.3C().1k("Mp",0).7U(1a(e){if(e.3H==13||e.3H==32){$(e.3m).2c("3I")}});$.2M("69",5s);$.2M({3T:5s,4j:cG,6M:{6O:0},1Z:1a(47,1x){K 1g=1c;7D{1g=1x.$1Q.1h().2M.1F[47]}7C(e){}6y(1a(){me.vs(J,{47:47,1g:1g})},0)},1F:1F});$5s.3I(1a(){$(5s).2M();$1T=$(5s).2M("1f");if($1T){$1T.2G({my:"2a 1O",at:"2a 4G",of:J})}})};J.PD=1a(1Z){if(J.7r.i7()){J.7r.61(1Z);1b 1o}1i{1b 1j}};J.Mq=1a(1Z){QB.1d.2k.61(1Z)};J.PS=1a(1Z){J.uc(QB.1d.2k.kb);QB.1d.2k.49.eC=QB.1d.2k.kb;QB.1d.2k.61(1Z)};J.QG=1a(1Z){QB.1d.2k.49.7r=1c;QB.1d.2k.61(1Z)};J.w2=1a(1Z){J.um();QB.1d.2k.61(1Z)};J.uz=1a(1Z){K me=J;if(J.ao<0){J.ao=0}if(J.ao>0){6y(1a(){me.uz(1Z)},100);1b}J.w2(1Z)};J.89=1a(1Z){QB.1d.2k.89(1Z)};J.hu=1a(1Z){QB.1d.2k.hu(1Z)};J.7I=1a(){l7=!($(".kU").1k("l7")===2O);if(!l7){J.IE()}QB.1d.2k.bD=$(".kU").1k("bD");N5=$(".kU").1k("N3")=="1o";J.lH=$(".kU").1k("lH")=="1o";K v0=$(".kU").1k("Qu");if(!1K(v0)){sn=v0}J.rO=$("#qb-ui-1V").4D("rO");K me=J;J.au=[];J.9Z=1j;if(!J.lH){$.jd(sn+"?47=Qx",sC,1a(1h){})}J.9F=$("#qb-ui-a6-QC-QE");J.3M=$("#qb-ui-3M").8L();J.2f=QB.1d.2f.7I();J.1V=J.2f!=1c?J.2f.1V:1c;J.3X=1S QB.1d.7h;J.gP=1c;J.9S=1c;if(K3){J.gP=1S QB.1d.lo;J.9S=1S QB.1d.9y}if(J.gP!=1c){J.JY=J.gP.wq();J.JY.4N(QB.1d.lo.2l.sY,J.jC,J)}if(J.9S!=1c){J.9S.31.4N(QB.1d.9y.2l.sR,J.jC,J);J.9S.31.4N(QB.1d.9y.2l.rK,J.Lv,J)}J.ws=J.3X.Lq();J.ws.4N(QB.1d.7h.2l.sd,J.L6,J);J.a6=$("#qb-ui-a6 7O");J.a6.4N("wz",J.Ld,J);$("#qb-ui-a6-9J-jd").4N("3I",J.w2,J);$("#qb-ui-a6-9J-hu").4N("3I",1a(){QB.1d.2k.hu()},J);if(J.1V!=1c){J.1V.4N(QB.1d.2f.2l.s8,J.kK,J);J.1V.4N(QB.1d.2f.2l.rZ,J.vl,J);J.1V.4N(QB.1d.2f.2l.s0,J.vR,J);J.1V.4N(QB.1d.2f.2l.rY,J.vs,J);$("#qb-ui-1V-7B").4N(QB.1d.2f.bs.2l.kz,J.LT,J)}J.3M.4N(QB.1d.2U.2l.fA,J.vC,J);J.3M.4N(QB.1d.2U.2l.vx,J.LB,J);J.3M.4N(QB.1d.2U.2l.vh,J.Kv,J);J.3M.4N(QB.1d.2U.2l.u2,J.vl,J);J.3M.4N(QB.1d.2U.2l.uf,J.vR,J);J.KD=$.hn(J.Kh,kI,J);J.7r=1S QB.1d.7r;QB.1d.2k.cv.2B(QB.1d.2k.cv.2l.6A,J.Kl,J);QB.1d.2k.9y.2B(QB.1d.2k.9y.2l.6A,J.Kn,J);QB.1d.2k.2U.2B(QB.1d.2k.2U.2l.6A,J.vD,J);QB.1d.2k.2f.2B(QB.1d.2k.2f.2l.6A,J.vM,J);QB.1d.2k.7r.2B(QB.1d.2k.7r.2l.6A,J.L3,J);QB.1d.2k.2B(QB.1d.2k.2l.tX,J.KK,J);QB.1d.2k.2B(QB.1d.2k.2l.tI,J.KP,J);QB.1d.2k.2B(QB.1d.2k.2l.tG,J.KR,J);QB.1d.2k.2B(QB.1d.2k.2l.tL,J.KN,J);QB.1d.2k.cv.2B(QB.1d.2k.2l.tB,1a(e,1h){J.tQ(QB.1d.2d.58.5m.Kq)},J);QB.1d.2k.2B(QB.1d.2k.2l.6A,1a(e,1h){if(1K(1h)){1b}J.tU=1j;J.cu=1h.cu;if(!1K(1h.9b)){J.9b=1h.9b}if(!1K(1h.fM)){J.fM=1h.fM}if(!1K(1h.9d)){J.9d=1h.9d;if(!1K(1h.9d.Ko)&&!1h.9d.Ko){$("#qb-ui-1V-dW-kS-KA").3J()}if(!1K(1h.9d.Kf)&&!1h.9d.Kf){$("#qb-ui-1V-dW-P5-KA").3J()}me.3M.8L("Kz")}if(!1K(1h.gJ)){J.gJ=1h.gJ}J.9F.4h("95 96 tu");J.9F.2t(1h.j6.5X);J.9F.42("");J.9F.42(1h.j6.9P)},J);QB.1d.2k.cv.2B(QB.1d.2k.cv.2l.ls,1a(e,1h){K AK=$("#dG-7F",1L.2N.3U);if(AK.1e){AK.3J()}},J)};J.e3=1a(73){1b 5W(73.3f(/(\\.|^)(\\d)(?=\\.|$)/g,"$10$2").3f(/(\\d+)\\.(?:(\\d+)\\.*)/,"$1.$2"))};J.IE=1a(){if(7T(IH)=="2O"){dN(IG)}if(!($&&($.fn&&$.fn.j0))){dN(Aq)}if(!($&&($.fn&&$.fn.j0))){dN(Aq)}1i{if(J.e3($.fn.j0)<J.e3(At)||J.e3($.fn.j0)>J.e3(IF)){dN(IB.3f("$1",$.fn.j0).3f("$2",At))}}if(!($&&($.ui&&$.ui.5N))){dN(IQ)}1i{if(J.e3($.ui.5N)<J.e3(BC)||J.e3($.ui.5N)>J.e3(IT)){dN(Ka.3f("$1",$.ui.5N).3f("$2",BC))}}if($&&($.fn&&$.fn.j0)){if($.fn.cL===2O){dN(JN)}}}};QB.1d.QN={Jr:"Jr",Ne:"Ne"};if(!3P.ck){3P.ck={}}if(!3P.ck.io){3P.ck.io=1a(){}}if(!3P.ck.BT){3P.ck.BT=1a(){}}K lZ;K ik=1c;K tY=0;1a Be(){if(tY==1c){tY=0}1b tY++}2u(2N).RY(1a(){QB.1d.5G=1S 5G;QB.1d.5G.7I();lZ=QB.1d.5G;Ng();lZ.Mj()});$.ui.6W.2S.Pe=1a(1H,Eh){J.2G=J.PC(1H);J.OS=J.OT("8x");if(J.1x.Nu){if(J.1x.5g){J.1x.5g()}}1i{if(!Eh){K ui=J.f0();if(J.7z("5g",1H,ui)===1j){J.O2({});1b 1j}J.2G=ui.2G}}if(!J.1x.sL||J.1x.sL!="y"){J.4z[0].3b.2a=J.2G.2a+"px"}if(!J.1x.sL||J.1x.sL!="x"){J.4z[0].3b.1O=J.2G.1O+"px"}if($.ui.hF){$.ui.hF.5g(J,1H)}1b 1j};',62,3862,'|||||||||||||||||||||||||||||||||||||||||||||this|var||||||||||||||||||||||||||function|return|null|Web|length|element|item|data|else|false|attr|case|value|for|true|break|key|width|node||obj|params|type|options|height|name|res|opt|push|object||items|path|event|row|result|isEmpty|parent|table|dto|top|index|selected|MetaData|new|menu|_|canvas|link|stroke|text|callback|||||||||fill|input|left|attrs|trigger|Dto|args|Canvas|each|val|FieldParamType|field|Core|Events|out|select|self|root|arguments|nbsp|from|addClass|jQuery|paper|call|disabled|offset||anim|bind|class|find|span|div|position|values|opacity|start|font|typeof|contextMenu|document|undefined|Items|eve|focus|prototype|option|Grid|Enum|bbox|rows|doc|css||control|||||||||append|style|elproto|apply|match|replace|expression|Guid|dialog|selectmenu|next|context|target|parentNode|has|split|switch|toString|color|none|remove|clr|concat|label|math|toFloat|transform|checked|button|rgb|appendChild|Math|slice|keyCode|click|hide|array|icon|grid|Utils|prev|window|gradient|toLowerCase|Name|selector|body|pos|settings|tree|Array|Str||delete|html|svg|while|method|raphael|action||ExchangeObject|src|container|abs|string|tableDnD|newValue|preventDefault|removeClass|arg|zIndex|Parent|rect|extend|deg|hitarea|appendTo|metaDataObject|toFixed|filter|first|get|events|matrix|end|max|helper|Type|arrows|_engine|hasClass|builder|criteria|bottom|join|round|animate|Object|list|handle|bindEx|CLASSES|blur|mmax|dtoItem|scrollLeft|Right|Left|constructor|animationElements|links|indexOf|newIndex||add||box|size||state|dots|Localizer|rowDto|scrollTop|url|removed|href|show|splice|drag|String|contextmenu|pathArray|Date|win|Strings|default|separator|rotate|display|close|menuSelector|aria|mouseup|set|easing|diff|current||textControl|p1x|oldValue|stop|rowChanged|Objects|Application|vml|resizable|mmin|fields|not|pow|version|wrapper|existingObject|cells|Criteria|clone|column|min|Value1|Number|Class|KindOfField|clip||sendDataToServer|paperproto|uiDialog|newelement|TempId|title|tabindex|tagName|destroy|p1y|len|c1y|c1x|that|hex|_editControl|graphics|parseInt|Fields|all|elem|point|minHeight|layer|auto|http|Column|format|config|CriteriaBuilderConditionOperator|getBBox|zoom|count|setTimeout|att|DataReceived|ConditionOperator|children|hover|editControl|status|Caption|visible|__set__|prop|open|setproto|animation|dot|duration|bbox2|menuItems|bbox1|sortingOrder|pageX|IsNew|qbtable|draggable|block|mdo|last|hidden|resize|ValueKinds|str|Links||insertBefore|c2x|Value2|substr|c2y|now|TableObject|implement|names|guid|removeChild|Tree|mousedown|lineCoord|p2x|angle|getValue|p2y|pageY|JoinType|dragi|CriteriaBuilder|crp|buildElement|handler|Operator|cell|ValuesCount|_g|_trigger|firstChild|graph|catch|try|pth|overlay|subElement|Visible|init|operation|create|stopPropagation|dirty|cache|textarea|currentTrigger|SQL|newObject|right|typeOf|keydown|unbind|checkbox|hasOwnProperty|ret|IsDeleted|header|keys|scale|family|DrawOrder|skew|path2|_ulwrapdiv|NameStr|update|_optionLis|newDatasourceDto|condition|percents|currentTarget|tmp|selectOptionData|command|containment|pathString|setValue|offsetLeft|cellName|existing|tableName|selectDto|radio|sin|destX|360|toUpperCase|vector|Alias|absolute|matches|bez1|bez2|face|par|rad|timer|widget|forEach|sorting|cos|newObjects|found|QBGrid|toggleClass|nodeName|tabbable|customAttributes|bg_iframe|image|buttons|Expression|matrixproto|Index|coordinates|_key|red|maxHeight||dasharray|All|1E3|JunctionType|warning|error||mooType||objectBorder|QueryProperties|touch|SyntaxProviderData|namespace|unionSubQuery|caller|Error|circle|namespaces|jPag|currentLayout|dataSource|Function|ctx|offsetTop|contextMenuRoot|test|criteriaBuilder|SmartPush|el2|sqrt|linkDto|mousemove|NavBar|build|dragObject|colour|elements|valueElement1|wrapperId|statusBar|proxy|path1|toInt|controls|throw|JunctionItemType|weight|fieldName|trg|Text|documentElement|EditableSelectStatic|navBar|Element|amt|selects|methods|blue|green|loaded|ellipse||||u1680|u180e|editor|percent|_editBlock|x09|alias|content|xa0|active|x0c|clear|continue|x0b|x0a|corner||fit|||Lock|meshX|meshY||||Messages|x20|x0d|||Condition|tstr|clientX|FieldGuid|u2004|isNaN|u2029|u2009|expandable|cnvs|u2000|u2028|setAttribute|u200a|con|u202f|u3000|u205f|u2005|u2006|clientY|u2002|hoveract|u2007|u2008|u2001|source|arrow|navigator|u2003|tt1|outerHeight|getRGB|charAt|Prefix|Select|icons|editable||subkey|instances||Raphael||current_value|addEventListener|offsetHeight|thisObject|ele|valueHTML|cacher|_selectedOptionLi|pathClone|titlebar||Link|markerCounter|addArrow|filteredUi|fieldsContainer|||getPath|checkTrigger|inFocus|getTotalLength|SessionID|counter|sql|collapsable|tableDnDConfig|currentTable|initialize|className|group|dialogId|Extends|line|shift|selectedIndex|glow|addObject|aggregate|droppable|queryStructure|Inner|groupingCriterion|getElementsByTagName|previous|empty|||token|SVG|img|bot|shape|000|textpath||createElement|Action|eventName||times|order|_value|||console|minWidth|fillpos|support||pattern|DatasourceGuid|stopImmediatePropagation|||SyntaxProviderName|MetadataTree|Rows|||createNode|toggle|parents|180|msg|Postfix|direction|6E3|linecap|defaultWidth|number|Key|valEx|Table|itemsPageSize|nextIndex|tlen|tt2|fonts|originalEvent|down|linkBox|move|attrs2|fontSize|Server|parseFloat|defs|_events||_drag|tolerance|existingLink|ids|isInput|currentPage|hasChanges|editableSelectOverlay|marker|_viewBlock||Animation||filtredItems|defaults|||Value1IsValid|RegExp|optionDto|Active||redraw|getKeyName|Outer|_cellEditEnd|alpha|valueNumber|cssClass|pop|||grouping|xlink|setFillAndStroke|matchDatasourceDto|change|ActiveDatabaseSoftware|JSON|iframe|listeners|titleBar|rec|getPrevTabbable|mouseout|255|alert|hover_css|SortType|Matrix|marked|time|getElementById|_parent|Aggregate|navbar|scrollY|a_css|easyeasy|scrollX|getNextTabbable|to2|versionToNumber|selectElement|offsetParent|isFunction|insertAfter|round1000|tableBox|properties|Cancel|methodname|wait|linkedObject||docElem|results|isEnd|getDate|defaultHeight||||valueElement2|getTimezoneOffset||property1||myAt|property3||property2|off|bgiframe|json|_moveFocus|outerWidth|ActiveUnionSubQuery|IsSelected||scope|userAgent|instanceof|CriteriaBuilderItemType|scaley|activeItem|pathi|UnionSubQuery|sib|map|dialogs|inver|Add|bb2|userEdit|sort|isURL|subquery|updateElement|updateContextMenu|delay|_uiHash|||objectGuid|_viewBox|dirtyT|isDropDown|overloadSetter|border|ContextMenu|strcmp|check|setViewBox|Data|simulateMouseEvent|curve|classes|thisLi|bb1|scalex|translate|cssText|force||origin|glyphs|LinkExpression|guidHash|oRec|getRec|maxWidth|longclick|Numeric|||Unknown|GridOnRowChanged|Value2IsValid|offsetWidth|keyStop|onSelect|realPath|paths|isResizable|handles|substring|pRec|tspan|QueryParams|200|filtered|precision|closest|milli|attrType||redrawT|getHours|justCount|intr|with|animated|Not|oldObj|computedStyle|asterisk|fillsize|minContentHeight|fillString|subItem|QBWebCoreBindable|VML|globalFieldDragHelper|dialogTarget|fontcopy|toJSON|isPointInside|tspans|pathId|overflow||linejoin|vbs|markerId|Field|dstyle|base|onload|pane|use|markedMeshCells||attachEvent|instantEdit|jsp|collapsed|thefont|_global_timer_|Supported|ObjectType|Rapha|u00ebl|VisiblePaginationLinksCount|objectType|visibility|floor|bezlen|QueryTransformerSQL|nextItem|iLen|Grouping|orColumnCount|__args|treeStructure|currentRow|QueryStructure|enumerables|buffer|from2|path2curve|updateObject|DataSources|CssClass|updateTable|getDto|shear|equal|keypress|eldata|recursive|strings|prevItem|contains|getFormat|mouseover|CriteriaBuilderJunctionItemType|Delete|mousePos|menus|newClass|itemsListIncomplete|list_is_visible|touches|selecter|accesskeys||replaceClass|debounce|sendDataToServerDelayed|_ul|current_event|||role|reconnect|lastCollapsable|listWrap|||totalOrigin|dropdown|indexed|optionClasses|QueryStructureContainer|parentObject|ddmanager|isInAnim|branches|lastExpandable|_typeAhead_chars|Actions|skipEvents|cur|removeRow|cursor|coordorigin|ClientSQL|setSize|cancel|editEnd|textpathStyle|showEditor|importData|valueElement|rvml|vals|isActive|||getSelectedListItem|flip|mouseProto|appendElement|isValid|titleBarText|seg|sweep_flag|getListValue|_path2string||triangle|||checkField||_moveSelection|globalTempLink|treeview|parentElement||log|addOrUpdateRow|butt|objectsToAdd|||isOpen|objectsToRemove|objectsToUpdate||removeByIndex|rowId|joinType|newf|JunctionPostfix|propSize|which|proto|__pad|background|glob|9999em|canvasDatasourceDto|random|the|nextSibling|dataSources||popup|NameInQuery|over|draw|__getType|Properties|di1|dj1|DataSource|DOMload|jquery|_availableAttrs|clientTop|activeID|clientLeft|prepend|Message|Copy|activeClass|getButtonContextMenuItems|strConversion|TString|seg2|refresh|currentValue|GridRowCell|letters|clearTimeout|percentScrolled||SortOrder|sub|skipEvent|queue|safari|move_scope|metadata|appendBefore||updateTabindex|toLower|wrongRow|Selects|keyToUpdate|destY|margin|valueB|dragMaxX|onTreeStructureClick|valueA|updateRowControl|tryAddEmptyRow|hook|replaceChars|fff|endString|define|stops|globalIndex|getMonth|hooks|deleting|startString|selectable|fltr|Set|ceil|text_hover_color|background_hover_color|removeAttr|linkMenuCallback|Filter|updateContextMenuItems|initstatus|dto2|None|list_item|1px|Boolean|Move|newObj|toggler|touchHandled|RootQuery|runAnimation|related|dto1|text_color|types|background_color|contentWidth|inputLabel||repeat|defaultView|getFullYear|matchee|_typeAhead_timer|_removedFactory|typeahead|callbacks|relatedTarget|items_then_scroll|seconds|swapClass|||CanvasLinkOnChanged|AllowJoinTypeChanging|400|ExchangeTreeDto|parentOptGroup|TableObjectOnSubqueryClick|reset|bgImage|GetPropertyDialog|500|scrollTimeout|onAddTableToCanvas|Path|Yet|TableObjectOnLinkedObjectSelected|menuWidth|fullUpdate|original|updateExpressionControl|union|configEnds|QueryBuilderControl|collision|getString|paneWidth|prevComputedStyle|Direction|setInterval|||Height|getPaddingString|boolean|opts|suppressConfigurationWarning|layout|month|Width|showFields|list_height|arr|showList|parentSelector|schema|findTableByName||removeEventListener|isAlternate||initialized|onDragStart|TreeStructure|buttonLink|abortevent|nodes|Loaded||LinkedObjects|onDragClass|optionsMarkColumnOptions|hours|minutes|optionsNameColumnOptions|dirY|deltaX|deltaY|day|yOffset|scrollAmount|getPaddingLength|DisableSessionKeeper|step|__def_precision|mouseenter|Child|dirX|plus|mouseleave|dis|_setOption|l2c|seg2len|seglen|pcom|UpdateGuids|_position|findDotAtSegment|serverSideFilter|application|tdata|||||maxZ|curr|_minHeight|notfirst|tear|IsEqualTo|nonContentHeight|dim|clipRect||mdoToTable|_pathToAbsolute|timestamp|solid|x2m|itemsPagePreload|y2m|_13|ValueKind|forValues|_23|lowerCase|_obj||validateValue|classic|selectedpage|mapPath|||testRow|subpaths|fieldValue|finite|CurrentEditCell|epsilon|bboxwt|binded|Value|Sorting|getPointAtLength|rowItems|groupColumns|findDotsAtSegment|getSubpath|refX|showGrouping|innerHTML|onChange|supportsTouch|_blur|setAttributeNS|_vbSize|touchMap|www|fieldsHtml|Options|itemsHtml|||conditionOr1|invert|itemHtml|createUUID|readyState|updatePosition|start_scope|touchend|touchmove|and|||handlers|funcs|RightToLeft|touchstart|_createTitleButton|rectPath|longClickContextMenu|_getBBox|trim||RootJunctionPrefix|glyph|rem||||ShowPrefixes||||bod|dragHandle|contentW|shiftKey|_focusedOptionLi|_divwrapright|TableObjectOnLinkCreate|_typeAhead_cycling|arglen|TableObjectOnCheckField|numPerPage|setCoords|NameNotQuoted|DescriptionColumnOptions|PrimaryKey|_disabled|fieldsTable|_refreshValue|clientWidth|linear|ActiveQueryBuilder2|ActiveQueryBuilder|Models|GridRow|setDto|py2|px2|itemsCount|||miterlimit|mdoFromTable|y1m|x1m|brect|addGradientFill|Any|CriteriaBuilderItem|relative|PreviousItem|stretch|deleted||clrToString||selobj|postprocessor|_isOpen|toHex|scroll||_removeGraph||paramCounts||getColor|hsb2rgb|o2t|needFilter||f_out|parameters|delayedSend|location|filterRegExp|o1t|usePlural|parse|thumbs_mouse_interval|getPrecision|ver|yi1|getKey|mdoFrom||_outer|rightcol|insidewidth|query|strong|needInvoke|xi1|ie7|timeout|ShowPropertyDialog|mdoTo|ItemsCount|localIndex|instanceOf|regex|||||The|Remove|bit|isType|updateGuidHash||_mouseInit|leftcol|_fired_|protected|lastI|oldGuid|klass||||are|||rx2||ry2|oval||xmin|diamond|ymin|1e12|||asin|_top|_left|norm|total|_path2curve|parseTransformString|interPathHelper|oldt|commaSpaces|hsl2rgb|bbx|nes|ActiveXObject|docum|radial|dots2|001|interHelper|dots1|clrs|sleep|denominator|fun|toColour|transformPath|letter_spacing|availableAnimAttrs|getSubpathsAtLength|upto255|frame|line_spacing|isInAnimSet|collector|thisArg|normal|lineHeight|del||fontName|getLengthFactory|end_scope|dragMove|dragUp|identifier|targetTouches|org|f_in|itemsArray|getPointAtSegmentLength|subpath|delta|pathDimensions|elementFromPoint|dif|hits|visibleMenu|inputs|getComputedStyle|itemMouseleave|||Event|nextcommand|itemMouseenter|selectOptions|instance|pickListItem|browser|OnApplicationReadyHandlers|getMatchItems|selectListItem|wrappers|curChar|dontEnums|selectors|hideshow|zin|POST|lastExpandableHitarea|lastCollapsableHitarea|itemdata|getDay|_name|returnStr|commands|propertyIsEnumerable|hovering|globalMenu|currentContext|optGroupName|renderfix|tail|_safemouseup|selectmenuId|altKey|thisAAttr|coordsize|flag|_selectedIndex|positionDefault|||recIndex|initWin||retainFocus|currIndex|droppedRow|clearInterval|mouseOffset|oldY|overlays|checkScroll||typeMismatch|hideList|dragObj|clientHeight|rowHeight|oldRaphael|getBoxToParent|||idx|getPosition|rowY|itemsElement|small|onFieldCheck|HideColumnType|gridRows|findRowsByExpression|CriteriaItem|Disabled|NavBarAction|800|buttonSubquery|doNotGenerateEvent|DisableLinkedObjectsButton|newShowGrouping|removeData|collspan|HideColumnDescription|Layout|gridItemDto|Output|TypeColumnOptions|structureItem|CanvasContextMenuCommand|CanvasOnRemoveTable|CanvasOnAddTableField|||than|primary|eval|scrollHeight|filterChangeRoutine|CanvasOnAddTable|HideColumnName|HideColumnMark|highlight|messages|TreeDoubleClickNode||dragging|parentTable|lastId|cellNameKey|GetUID|hoverClass|NameStrNotQuoted|Description|QBHandlers|||QuickFilterInExpressionMatchFromBeginning||blockFocus||ToDelete|_create||||srcAlias||sortBy|300|cellpadding|disable|onDrop|cellspacing|UseLongDescription|rowIsEmpty|objectOptions|iconClass|axis|cursorWait|GroupingCriterion|||optionsDescriptionColumnOptions|NavBarBreadCrumbSelectNode|GridRowCellOnChanged|DenyLinkManipulations|optionsTypeColumnOptions|generateEvent|isEqual|5E3|TreeStructureSelectNode|_importDto|||||CreateLink|removeObject|DoAction|autoOpen|fieldCheckbox|parentGuid||_cellEditStart|positionDragY||paginate|getJoinPrefix|_blockFrames||fillDtoItems|getButtonContextMenuItemsMove|itemIndex|general|NotAll|sendDataToServerWithLock||parentItem|||mouse||information|enter|iframeBlocks|buildItems|hiddenSQL|positionDragX|fillDto|DataSending|ConditionIsValid|Group|conditions|Loading|ContextMenuReceived|ShowLoadingItems|MessagesReceived|scrollToX|plusButton|SQLReceived|ItemsStart|fillSelects|CriteriaBuilderItemPlus|after|MessageInfo|updateGridRows|CriteriaBuilderItemGroup|resizeT|editorChangesEnabled|contextMenuCallback|scrollToY|QueryStructureChanged|GlobalTempId|Columns|invalid|contentHeight|GridOnAddTable|TableObjectOnDestroy|TableObjectOnMoved|datepicker|margins|1E5|loading|editableSelectControl|contentPositionX|module|ChangeActiveUnionSubquery|jQueryUI|TableObjectOnClose|GridOnAddTableField|TypedObject|_getPath||selectNewListItem|align||prepareSyncSQL||menuChildren||newpath|UpdateValues|_tofront|clearSelectedListItem|fxfy|_insertafter|li_value|editStart|_insertbefore|refreshSqlWithLock|borderTopWidth|anchor|_radial_gradient|dirtyattrs|list_item_height|li_text|_toback|center|borderLeftWidth|_parseDots|_grid|EditableSelect|newstroke|checkAllField|_extractTransform|square|selectFirstListItem|u2026|bbt|checkedFields|moveToTop|isSimple|isGrad|domElement|inited|exclude|handlersPath|dragStop|strokeColor|newFieldsCount|_ISURL|_preload|newField|GetWrapper|dragStart|_tear|raphaelid||needResize|heightBeforeDrag|_oid|contextMenuActive|built|GridOnRemoveRow|noop|getBoundingClientRect|relativeRec|onRemoveObjectFromCanvas|static|collapsableHitarea|ownerDocument|paneHeight|contentPositionY|structure|onCanvasContextMenuCommand|buildElements|secondary|bindItemsEvents|detachEvent|GridOnAddRow|OnApplicationReadyFlag|GUID|load|nodeCount|onGridRowChanged|importGrid|selectedOptions|addOption|cookie|stored|cookieId|quoteString|pairs|rgbtoString|importCanvas|ascending|_escapeable|thatMethod|closed|onAddTableFieldToCanvas|fixed||expandableHitarea|_params|scrollByX|scrollBy|toggleCallback|applyClasses|prepareBranches|scrollByY|refreshSql||_getContainer|_Paper|modal|titleW|com|component|obj1|intersect|prevcommand|600|busy|obj2|_rectPath|LongDescription|FieldListSortType|contextMenuAutoHide|TableObjectField|ShortDescription|HideAsteriskItem|FieldListOptions|contentH|KeyFieldsFirst|buildTree|cssDot|treeControl|submenu|endD|calculateBox|shortLeg|startD|endType|keyup|topOffset|thin|accesskey|startType|_init|param|buttonClose|disableSelection|was|buttonProperties|contextMenuKey|andSelf|AriaLabel|dblclick|Close|QueryGuid|Actions1|oldstop|does|wildcard|subname|getEventPosition|onmove|onend|tableObj|scope_in|MetadataGuid|||||onstart|SqlErrorEventArgs|toMatrix|CriteriaBuilderItemDto|getEmpty|prevIndex|IsNotInList|IsInList|mag|normalize|factory|pathToRelative|fromCharCode|touchcancel|_toggle|istotal|amp|offsetx|offsety|GridRowDto|onLinkedObjectSelected|prepareSyncMetadata|eventType||newelementWrap|onCheckFieldInTable|onLinkCreate|x_y_w_h|findTableByDataSourceGuid||conditionOr|opera|_refreshPosition|newOptionClasses|MetadataObjectAdded|MetadataObjectGuid|_scrollPage|CriteriaType|optgroup|_toggleEnabled|isBBoxIntersect|fixM|bezierBBox|setColumn|actionAddItem|xbase|ybase|sum|page|Clear|CriteriaBuilderItemGroupDto|isArray|Paper|cross|newwin|CriteriaBuilderDto|buildControlItems|getJunctionItemType|||||packageRGB|prepareRGB|junctionType|t12|atan2|base3|fieldContextMenuCallback|pathValues|t13|newres|curveDim|operator|_120|JavaScript|before|q2c|processPath|fixArc|pathToAbsolute|a2c|CriteriaBuilderItemRow|getOperatorObject|CriteriaBuilderItemGeneralDto||General|rel|isPointInsideBBox|xmax|ymax|catmullRom2bezier|crz|ellipsePath|parsePathString|CriteriaBuilderItemGeneral|upperCase|blank|getMouseOffset|makeDraggable|viewBlock|dashes|docPos|getAttribute|setup|texts|msgType|addDashes|lastReturn|NONE|dir|movingDown|_createEditBlock|rgba|_fx|_fy|_switchToView|needUpdate|currentSorting|xb0|mouseCoords||global|highlightSelected|allRows|_makeResizable|progid|_size|clmz|listIsVisible|running|generateContextMenuItems|adjustWrapper|compensation|_makeDraggable|Microsoft|editableSelect|DateTime|middle|leading|getControl|editableSelectInstances|createTextNode|desc|_unblockFrames|TableObjectOnUpdated|dispatchEvent|isFloating|draggedRow|newAnim|srcExpression|findRowsByDto|sampleCurveX|_reCreateEditBlock|UpdateLink|rowToDelete|csv|emptyRow|removeAllMarked|pathes|extractTransform|getByGuid|ease|back|winH|updateSQL|_typeAhead|maxH|nogo|presentation|markAllForDelete|UpdateWrapper|tableValue|newRows|srcAggregate|onCellChanged|shifty|ConditionType|units|per|isLoaded|serialize|nodrop|serializeTable|serializeRegexp|every|prependTo|GridRowOnChanged|hasEmpty|Widget|thisLiAttr|dtoIsEqual|dtoIsSimilar|drop|accept|todel|requestAnimFrame|paused|stopAnimation|FixedColumnMode|currval|outsidewidth|FieldTypeName|targetId|parentOffset|NameColumnOptions|MarkColumnOptions|errNoJQ|forGroup|applystyle|jQueryMinVersion|SelectAllRowsFrom|Checked|DisableDatasourcePropertiesDialog|testWidth|border_color|GetFullFieldName|DisableLinkPropertiesDialog|_rotleft|DisableQueryPropertiesDialog|border_hover_color|database|_rotright|throttle|LinkPart|LastItemId|VisiblePaginationLinksCountAttr|iFrameOverlay|trimCaption||UpdateObjects|childButton|createButton|setRequestHeader|acces|triggerEvents|allEvents|generateNavBarContextMenuItems|SQLChanged|SQLUpdatedServerFlag|outsidewidth_tmp|invokeAsap|SQLError|__repr|MAX_CAPTION_LENGTH|success|UserDataReceived|toExponential|ajax|Mutators|Metadata|simulatedEvent|merge|prototyping|View|mergeOne|mHide|GetTempId|_touchMoved|extended|cloneOf|periodical|isFirst|pass|New|brackets|doScroll|hexToRgb|Database|Schema|bound|regexp|rgbToHex|horizontalDragPosition|freeY1|freeY2|getNextEmptyPlaceRoutine_Test||0000|freeX1|freeX2|jQueryUIMinVersion|propertyName|test_interval|fieldIcon|scrollWidth|centercol|Title|protect|generic|schedule|annul|_click_|optionsFixedColumnMode|150|lower|cRec|hooksOf|debug|linkNode|4E3|fieldElement|breadcrumbClick|images|spanField|loadingItemsOverlay|called|currentSelect|LoadDataByFilter|filtredItemsCount|toLocaleString|selectsDto|optionsHtml|srcUrl|buildBreadcrumbElements|parts|SelectOptionDto|descriptionHtml|applyFilter|__arg|toPath|equaliseTransform|easing_formulas|onObjectDestroy|fired|methodsEnumerable|reCreateEditBlock|_positionDragX|real|thisA|getLastRowControl|16777216|onObjectClose|fieldGuid|sortByNumber|junctionTypeContextMenuCallback|availableAttrs|newRow|findRowByDto|optionValue|objGuid|getFieldsContextMenuItems|bezierrg|resume|ENTER|toggleGroupColumn|SPACE|pause|targetPlace|PAGE_UP|hsb|PAGE_DOWN|END|animateWith|selection|hsl|createFieldSelect|rowSorter|CubicBezierAtTime|pipe|destLeft|lastIndexOf|tableDragConfig|TAB|oldIndex|Time|075|updateSortingOrderColumn|fieldDescription|handleWidth|Now|objY1|70158|SqlChanged|selectmenuIcon|tCommand|onRowChanged|backOut|objX1|prepareSyncQueryProperties|code|thisText|objX2|refreshTimeout|IsChanged|listH|backIn|SelectedValue|isEnumerable|fieldText|hasIcon|UnionNavBarVisible|typeAhead|operationContextMenuCallback|createButtonMenu|FieldCount|DataSourceLayoutDto|getLayout|solve|selectsParent|||getJunctionTypeContextMenuItems|pathCommand|getNextEmptyPlaceRoutine_Find_RTL|getNextEmptyPlaceRoutine_Find|itemDto|TABLE|getNextEmptyPlaceRoutine_Fill|TreeSelectDto|TableObjectFieldOnCheckField|objY2|getOperationContextMenuItems|solveCurveX|getEmptyPlaceCoord|glowConfig|hsrg|compatMode|_getCssClass|ShowLoadingSelect|innerHeight|range|9999|startdx|repush|selectChange|ASC|windowHeight|_createViewBlock|colourRegExp|onDragStyle|SubQuery|hsba|DataSourceType|startMarker|markers|startPath|endPath|endMarker|arrowScroll|cssrule|You|will|aliases|able|vis|noPropagation|view|rest|tuneText|getPropertyValue|Enclose|p2s|nodeValue|Marker|enddx|_switchToEdit|attempt|rgb2hsb|HideLoadingItems|hsbtoString|hsltoString|rgb2hsl|clean|_exportDto|u00b0|getFont|hsla|importCanvasObjects|serializeTables|some|isAsterisk|UID|Int32|updateTables|createRowControl|RIGHT|LEFT|isFinite|HOME|shape2|DOWN|XMLHTTP|fillDefaultValues|plusItem|initObject|edit|methodName|selectDataRefresh|flatten|collection|onDropStyle|updateBreadcrumb|onAllowDrop|findDropTargetRow|CTE|updateTableContextMenu|updateLinkContextMenu|CanvasLink|updateUnionControls|objNotationRegex|quote|tableId|importCanvasLinks|formatrg|quotedName|setLayout|include|replacer|isFunc|tokenRegex|maxlength|updateFilter|between|createFromDto|DataSourceLinkPartDto|Infinity|your|filterChangeRoutineT|DocumentTouch|IsNotBetween|findByTableGuid|Please|actionMoveUp|getObjectFieldByGuid|isNumeric|getObjectHeader|actionDelete|actionMoveDown|TotalCount|1e9|CopyInner|getObjectByGuid|itemId|Arial|TreeSelectNode|adj|buildPager|Inc|IsGreaterThan|vendor|Union|redrawD|IsLessThanOrEqualTo|olde|Plus|less|CanvasOnDropObject|removeByTableGuid|Line|greater|IsBetween|Url|acos|rightGuid|leftGuid|UnionNavBar|exports|shorter|IsGreaterThanOrEqualTo|LinkPropertiesForm|large_arc_flag|operatorObj|pathBBox|500px|Invalid|operatorText|x2old|y2old|showDescriptions|you|lastJ|createGraph|TryLoadItems|_setDto|Content|CriteriaBuilderItemAdded|press|DataSourceLinkDto|CriteriaBuilderChanged|LoadDataByPager|_getDto|needLoadItems|ariaName|f2old|responseText|errHandlersConfiguration|filterClear|usr_vXXX|UpdateConnection|CriteriaBuilderItemRowDto|actionAddGeneral|actionClear|lined|CreateConnection|actionAddGroup|whitespace|Incorrect|detected|higher|ItemsPerPage|tan|library|filterChange|GetLinkExpression|filterChangeStub|branch|required|PreloadedPagesCount|1069|1601|canvasMenuCallback|XMLHttpRequest|Tvalues|0472|IntoControls|2335|propertyValue|enable|2032|getById|getElementByPoint|setWindow|comb|addLink|pageYOffset|elementParent|getHTTPObject|getOffset|effect|Cvalues|revert|recreateSelect|getTableFieldExpression|onlystart|fieldSelect|typeCheck|5873|getRowHeaderList|_formatText|_closeOthers|generateHeaders|1252|3678|selectelement|fieldType|9816|hasAggregateOrCriteria|9041|isPointInsidePath|2491|isWithoutTransform|7699|escapeHtml|getTatLen|QueryPropertiesForm|nodeType|description|scope_out|parentIndexId|updateLink|error_alert|IsNotEqualTo|buildSelects|numsort|DoesNotEndWith|positionOptions|createJunctionTypeMenu|globalStart|globalCount|_f|IsLessThan|detacher|isnan|preventTouch|stopTouch|IsNull|ShowAllItemInGroupingSelectLists|objectToString|showAllItemInGroupingSelectLists|IsNotNull|addEvent|DoesNotContain|uuidReplacer|createOperationMenu|unmousemove|findRowByExpression|getter|activedescendant|about||CriteriaOr|removeDataSource|currentOptionClasses|unmouseup|addDataSource|Contains|Errors|localCount|DoesNotStartWith|ActiveMenu|EndsWith|layerX|StartsWith|uuidRegEx|Where|layerY|post_error|menuMouseleave|updateDataSource|menuMouseenter|342|For|DataSourcePropertiesForm|errWrongJQ|padding|inline|checkProjectConfigure|jQueryMaxVersion|errNoScript|check_usr|urn|schemas|microsoft|titleText|focusItem|xmlns|itemClick|inputClick|errNoJQUI|512|adjustSize|jQueryUIMaxVersion|ObjectReadOnly|hideMenu|NeedRebindUserInit|parentBox|tabbableLast|splitAccesskey|layerClick|MultipleQueriesPerSession|tabbableFirst|menuItem|triggerObject|clearSync|qbtableClass|uiQBTableClasses|updateLinkObjectsMenu|classObject|odd|createLinkObjectsMenu|QBWebCore|lastHeight|collapseTable|callee|__getInput|specified|minLeg|parentId|sepcified|isEmptyObject|behavior|oldWidth|snextclass|snext|previousclass|sqlChanged|oldHeight|nextclass|_divwrapleft|toFront|toBack|def|oldFieldsCount|reCreate|isPatt|noRotation|ActionDto|menuitem|bVer|vbt|toFilter|jspActive|htmlMenuitem|htmlCommand|spreviousclass|sprevious|saveScroll|errWrongScriptOrder|titleButtonW|componentH|titleH|generateFields|generateTitle|heightMax|updateNavBarContextMenu|componentW|typeName|blurItem|treeStructureElement|_viewBoxShift|hasScroll|hideArrow|showArrow|SUBQUERY_ENABLED|carat|blurregexp|Blur|Container|AllFieldsSelected|MetadataFieldDto|errWrongJQUI|tile|NotPrimaryKey|parentObj|proxyEx|IsSupportCTE|destPercentY|onEditorChangeDebounced|treeController|cls|deserialize|importMetadata|heightHide|importNavBar|IsSupportUnions|getTime|Updating|valueOf|__entityMap|isObject|prevOffsetParent|onGridRowRemoved|isPrototypeOf|Argument|stepCallback|updateAggregateColumn|panel|subqueryPlusButton|dynamicSort|onEditorChangeDebouncedCall|heightToggle|longMonths|stickToTop|destPercentX|longDays|charCodeAt|importQueryStructure|shortMonths|getMinutes|importSQL|year|importMessages|getSeconds|importContextMenu|c1Elements|stringify|selectedValues|arguments2Array|prerendered|May|setMonth|_meta|scrollToElement|shortDays|sel|importCriteriaBuilder|removeOption|hasDontEnumBug|onTreeDoubleClick|aks|thinBg|__formatToken|QBWebCanvasLink|000000|01|onEditorChange|getActiveItem|autoHide|getInactiveItems|clearSyncDebounce|flush|eventSelectstart|hasTypes|blurInput|getLineCoord|leftBox|rightBox|focusInput|buildNewTree|fromType|complete|sendDataToServerDelayedWrapper|toType|onNavBarAction|zindex|dragMaxY|DeepCopy|contextMenuShow|GlobalUID|onGridRowAdded|Clone|SubQueries|triggerIsFixed|maintain|determinePosition|createChildMenu||dontEnumsLength|tagValue|sendDataToServerInternal|QBWebCoreMetadataTree|QBWebCoreCriteriaBuilder|positionSubmenu|siblings|delayed|QBWebCoreGrid|isCurrentQuery|onCanvasLinkChanged|one|QBWebCoreCanvas|QBWebCoreNavBar|Incompatible|changedTouches|_touchStart||Editor||positionElements|fireEvent|||onTextboxChanged|medium|setWidths|Reconnect|offsetPosition|TableObjectOnLinkDelete|createSVGMatrix|Tables|beforeclose|Query|fontFamily|scrollToListItem|updateOnLoad|fontWeight|fontStyle|escapeHTML|path2vml|EditableSelectWrapper|tabIndex|sync|wrap|touch_enabled|Procedure|initEvents|Refresh|_touchMove|resizeHandles|resizeStart|autoShow|short|long|isOval|resizeStop|preserveAspectRatio|aspectRatio|resizing|_fn_click|_touchEnd|newfill|initMouseEvent|2000|retain|originalSize|need|owner|originalPosition|updateExpression|screenX|TableObjectOnCreate|duplicateOptions|screenY|wide|narrow|createEvent|unselectListItem|fromMenu|_touchcancel_|_touchmove_|trial|hideOtherLists|QBTRIAL|adjustHeight|_touchstart_|clearHighlightMatches|_contextmenu_|helperProportions|_touchend_|From|simulatedType|sqlError|initInputEvents|OnApplicationReadyTrigger|_createEditControl|getAllRows|getInstance|pathTypes|suppressEnter|ovalTypes|cannot||textStatus|Procedures|DXImageTransform|textContent|isMove|fastDrag|bites|_mousemove_|nYou|_mousedown_|Sort|ajaxFinish|dialogClass|jqXHR|AggregateList|Common|scheduled|current_options_value|Your|_mouseup_|Views|importDto|_mouseout_|Synonyms|getMatchItemPrev|getMatchItemNext|adjustWrapperPosition|Relations|adjustWrapperSize|Default|oldInstances|Treeview|HTMLCommandElement|feature|SVG11|form|isString|HTMLMenuItemElement|setQueryParamValues|_mouseUp|transparent|Connection|sortByKey|escape|hyphenate|camelCase|unescape|onreadystatechange|16711680|pick|decodeURIComponent|UTF8decode|encodeURIComponent|tpl|Warning|urlencoded|SVGAngle||render|hasFeature|implementation|slideUp|999|capitalize||slideDown|onselectstart|Info|6001|atan|err|createTextRange|u00|valid|Msxml2|178|getUTCFullYear|x00|limit|getJSON|createPopup|sortOptions|x7f||x1f|ajaxAddOption|x9f|65280|getUTCSeconds|secureEvalJSON|evalJSON|positionAbs|_convertPositionTo|getUTCMilliseconds|exp|GET|parsing|SyntaxError|getUTCHours|getUTCMinutes|queryCommandValue|ForeColor|bfnrtu|Read|cte|4xxx|xxxxxxxx|xxxx|MouseEvent|getFlags|yxxx|xxxxxxxxxxxx|snapTo|_mouseDrag|__max_precision|uid|BasicStructure|getQueryParams|escapeRegExp|_id|BackCompat|copyOptions|htmlfile|tDnD_whileDrag|containsOption|getUTCMonth|getUTCDate|msgTime|write|selectedTexts|substitute|binary|persist|matc|child|serializeParamName|unique|_generatePosition|syncCriteriaBuilder|WebkitUserSelect|left2|reverse|ipod||unshift|clientError|hide_on_blur_timeout||ipad|jPaginate|trigger_jquery_event|encodeURI|axd|switchToRootQuery|teardown|case_sensitive|forEachMethod|search|errors|defineProperties|defineProperty|_hidden_select|getPrototypeOf|frameborder|special|getOwnPropertyDescriptor|getOwnPropertyNames|options_value|reduce|ESCAPE|padding_right|reduceRight|exec|autocomplete|toPrecision|iphone|_timer_|radiogroup|MSIE|widgetName|_duration_|setInputValues|black|getInputValues|8cc59d|Android|mirror|MessageWarning|MessageError|appName|meta|HandlersPath|appVersion|bName|ping|ab8ea8824dc3b24b6666867a2c4ed58ebb762cf0|textnode|front||statusbar|MooTools|message|dispatch|updateCriteriaBuilder|wrapper1|html5|slide|innerText|wrapper2|pages|ApplicationEvents|overloadGetter|maincol|spacing|tableDnDUpdate|raphaeljs|letter|invoke|calc|getLast|_blank|associate|tableDnDSerialize|cubic|me2|Collection|bezier|uniqueID|10px|selectstart|Arguments|erase|MouseEvents|getRandom|combine|must|Wrong|Implements|ontouchend|script|UTF8encode|achlmqrstvxz|_availableAnimAttrs|_mouseCapture|achlmrqstvz|radial_gradient|HTTP|rstm|send|0x|errordialog|date|labelledby|reserved|Eve|listbox|Cannot|once|Click|seal|preventExtensions|isExtensible|isSealed|wrapperCleared|nts|freeze|isFrozen|incorrect|configuration|WhiteSpace|disableTextSelect|TextNode|NaN|uniqueId|ff0066|ISURL|amd|haspopup|fixedPosition|owns|reset_options_value|web|ontouchstart|ready|file|Colour|LeftColumn|RightColumn|SelectAllFromRight|getGrid|_makeDraggableOriginal|addClasses|JoinExpression|Join|Datasource|LeftObject|textpathok|Kind|SelectAllFromLeft|runtimeStyle|RightObject|pixelradius|CacheOptions|paddingLeft|GroupBy|colors|color2|paddingTop|kern|RemoveBrackets|oindex|270|focusposition|Cache|Option|_setContainment|Order|focussize|gradientTitle|FieldType|fixOutsideBounds|left16|Size|ItemsPacketSize|00000000|000000000000|ItemsListIncomplete|Switch|Command|AltName|linked|MetaDataDto|ReadOnly|Scale|Nullable|Precision|Label|Test|readonly|Selected|Expanded|addRule|createStyleSheet|OutputColumnDto|titleTextW|ContextMenuDto|objects|Linked|UnionsAdd|ContextMenuItemDto|QueryStructureDto|clearfix|DIV|EncloseWithBrackets|Provider|rotation|doesn|Syntax|MetadataObjectCount|uiDialogTitlebar|dxdy|proceed|closeText|uiDialogTitlebarCloseText|ObjectTypeUnknown|_createButtons|SelectSyntaxProvider|u2019t|Falling|uiDialogClasses|160|SelectAll|viewBox|uuid|getScreenCTM|CheckAll|removeAttribute|xMinYMin|meet|ahqstv|21600|_size1|tables|Created|_allowInteraction|views||procedures|ObjectTypeProcedure|dash|shortdashdotdot|dashdot|longdash|shortdash|flat|shortdashdot|shortdot|MoveBackward|backward|CopyToNewUnionSubQuery||NewUnionSubQuery|longdashdotdot|longdashdot|MoveForward|dashstyle|forward|Insert|ObjectTypeTable|RemoveItem|InsertEmptyItem|ObjectTypeView|beforeClose|arrowwidth|arrowlength|joinstyle|MoveUp|endcap|miter|diagonal|MoveDown|alsoResize|grip|Monday|groups|Wednesday|Tuesday|Fri|old|Sunday|Sat|MIN|SUM|LAST|MAX|Friday|Thursday|Having|Saturday|Thu|primaryKey|nullable|November|October|July|June|September|August|objid|Tue|Wed|ObjectField|Sun|December|Mon|int|scrollToPercentY|liveEx|unload|live||liveConvert|contentType|reinitialise|nextAll|dataType|quot|TypeError|x2F|breadcrumb|buttonset|submit|non|GLOBAL_DEBUG|hellip|addGridRows|removeGridRows|async|removeLink|COUNT|FIRST|Synonym|DESC|errorThrown|00|toTimeString|initialise|scrollToPercentX|myType|reload|scrollTo|April|OnApplicationReady|GetName|getRec1|hijackInternalLinks|mdc|CanvasDto|setGlobalOnLoad|LoadFromObject|getContentPane|scrollToBottom|getIsScrollableV|isScrollableV|equalWidth|equalHeight|GetFullName|SmartAdd|GridDto|stack|144|RightField|using|uncheck|Cardinality|setDataSwitch|DataSourceGuid|addHandler|AliasNotQuoted|DataSourceDto|removeHandler|tableNameTemplate|LeftField|System|LinkObjectDto|offsetWithParent|Apr|Mar|Jul|Jun|GenerateClass|superclass|Feb|Jan|January|Dec|March|February|Sep|Aug|Nov|Oct|animateDuration|getPercentScrolledY|doesAddBorderForTableAndCells|inArray|subtractsBorderForOverflowNotVisible|isScrollableH|bodyOffset|doesNotAddBorder|getIsScrollableH|toUpper|getContentPositionY|animateEase|getContentPositionX|getContentHeight|getPercentScrolledX|delegate|getContentWidth|stdDeviation|returnValue|cancelBubble|AnsiStringFixedLength|Google|Computer|platform|StringFixedLength|VarNumeric|contain|ends|starts|unmouseout|getData|unhover|unmouseover|M21|M22|DateTime2|M12|pixelHeight|DateTimeOffset|M11|Xml|Version|Chrome|Apple|toTransformString|sizingmethod|expand|isSuperSimple|UInt64|Int64|Int16|Double|u00d7|SByte|getElementsByPoint|x_y|curveslengths|colspan|thead|AnsiString|Binary|Decimal|Currency|Byte|unmousedown|onRemoveRow|onAddRow|undrag|UInt32|findRow|onDragOver|setStart|getIntersectionList|Single|getElementsByBBox|UInt16|setFinish|pageXOffset|createSVGRect|pixelWidth|000B9D|updateLinks|removeAll|showDescriptons|following|inter|interCount|removeByGraphics|segment2|calling|u201c|segment1|pathIntersection|pathIntersectionNumber|getByLink|fillSelectOptions1|fillSelectOptions2|criteriaBuilderFieldSelect|onerror|Picker|u2400|preload|dataRefresh|onclick|MAX_SELECTS|succeed|2573AF|level|pager|79B5E3|u201d|NumericFrac||KindOfType|parseDots|NumericInt|isAtLeft|updateObjects|isAtRight|tofront|any|_equaliseTransform|notall|NextItem|toback|insertafter|insertbefore|animportCanvasimation|DenyIntoClause|Into|offsetX|_pathToRelative|offsetY|120|350|32E3|inst|horizontalDrag|onClose|props|Universal|nowrap|1999|DOMContentLoaded|strRemove|strColumnNameAlreadyUsed|ninja|fullfill|same|GridRowCellOnDeleted|0z|0A2|createElementNS|supports|strCopyToNewUnionSubQuery|strEncloseWithBrackets|strUnionSubMenu|strNewUnionSubQuery|bolder|lighter|exists|print|onGridRowCellChanged|currentLanguage|700|bold|sortOrder|_UID|focusout|onDeleted|descent|baseline|isEmptyRow|already|userSpaceOnUse|patternUnits|own|paid|updated|clipPath|Uncheck|changed|feGaussianBlur|finally|Check|UncheckAll|rid|them|Random|limitation|strAddCTE|Gradient|fillOpacity|gradientTransform|strAddNewCTE|webkitTapHighlightColor|focusin|onChanged|derived|refY|Update|strAddSubQuery|markerHeight|patternTransform|orient|markerWidth|Desc|easeInOut|easeOut|getArrowScroll|webkitRequestAnimationFrame|requestAnimationFrame|easeIn|984375|625|9375|findRowByGuid|removeRowByDto|findEmptyRow|onAnimation|checkRow|Asc|ItemSortType|oRequestAnimationFrame|msRequestAnimationFrame|finish|LinkSideType|LinkCardinality|Other|check_lib|Many|mozRequestAnimationFrame|One|currentEdit|True|1734|insertion|Deny|setTime||u2019s|rowsHeaders|registerFont|mlcxtrv|index2|04|u2018s|DbType|rowIndex|LinkManipulations|TreeSelectTypeDto|5625|StoredProc|bounce|insert|Allow|elastic'.split('|'),0,{}))

