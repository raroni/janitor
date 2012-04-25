window.Janitor = {};
window.Janitor.Stitch = {};
(function() {
  
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var module = cache[name], path = expand(root, name), fn;
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: name, exports: {}};
        try {
          cache[name] = module.exports;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return cache[name] = module.exports;
        } catch (err) {
          delete cache[name];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
  }
  return this.require.define;
}).call(this)({"assertions": function(exports, require, module) {
  module.exports = {
    assertEqual: function(expected, actual) {
      var success;
      success = expected === actual;
      return this.storeAssert('equal', success, {
        expected: expected,
        actual: actual
      });
    },
    assert: function(exp) {
      return this.storeAssert('true', exp, {
        exp: exp
      });
    },
    assertThrows: function(callback, check) {
      var caught, error, success;
      caught = false;
      error = null;
      try {
        callback();
      } catch (thrownError) {
        caught = true;
        error = thrownError;
      }
      success = caught && (!check || check(error));
      return this.storeAssert('throw', success, {
        callback: callback,
        error: error
      });
    },
    refuteThrows: function(callback) {
      var caught, error, success;
      caught = false;
      error = null;
      try {
        callback();
      } catch (thrownError) {
        caught = true;
        error = thrownError;
      }
      success = !caught;
      return this.storeAssert('refuteThrow', success, {
        callback: callback,
        error: error
      });
    },
    assertContains: function(container, value) {
      var result;
      result = container.indexOf(value) !== -1;
      return this.storeAssert('contains', result, {
        container: container,
        value: value
      });
    },
    assertAll: function(enumerable, callback) {
      var success;
      success = true;
      enumerable.forEach(function(item) {
        if (success) return success = callback(item);
      });
      return this.storeAssert('all', success, {
        callback: callback
      });
    },
    assertInDelta: function(expected, actual, delta) {
      var success;
      success = expected - delta < actual && expected + delta > actual;
      return this.storeAssert('inDelta', success, {
        expected: expected,
        actual: actual,
        delta: delta
      });
    },
    refuteEqual: function(expected, actual) {
      var success;
      success = expected !== actual;
      return this.storeAssert('refuteEqual', success, {
        expected: expected,
        actual: actual
      });
    }
  };
}, "browser_presenter": function(exports, require, module) {(function() {
  var Presenter;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Presenter = require('./presenter');

  module.exports = (function() {

    __extends(_Class, Presenter);

    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }

    _Class.prototype.outputFailedAssert = function(failedAssert) {
      var el, text;
      text = this.failedAssertDescription(failedAssert);
      el = document.createElement('div');
      el.innerHTML = text;
      el.style.color = 'red';
      return this.options.el.appendChild(el);
    };

    _Class.prototype.complete = function() {
      var el;
      el = document.createElement('div');
      el.innerHTML = this.summaryMessage();
      return this.options.el.appendChild(el);
    };

    return _Class;

  })();

}).call(this);
}, "browser_runner": function(exports, require, module) {(function() {
  var BrowserPresenter, Runner;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Runner = require('runner');

  BrowserPresenter = require('browser_presenter');

  module.exports = (function() {

    __extends(_Class, Runner);

    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }

    _Class.prototype.presenterClass = BrowserPresenter;

    _Class.prototype.tests = function() {
      var key, _i, _len, _ref, _results;
      _ref = Object.keys(window);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        if (key.substr(-4) === 'Test') _results.push(window[key]);
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
}, "console_presenter": function(exports, require, module) {(function() {
  var Presenter;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Presenter = require('./presenter');

  module.exports = (function() {

    __extends(_Class, Presenter);

    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }

    _Class.prototype.outputFailedAssert = function(failedAssert) {
      return console.log(this.failedAssertDescription(failedAssert));
    };

    _Class.prototype.complete = function() {
      return console.log(this.summaryMessage());
    };

    return _Class;

  })();

}).call(this);
}, "event_emitter": function(exports, require, module) {
  module.exports = {
    bind: function(event, callback) {
      var _base;
      this._callbacks || (this._callbacks = {});
      (_base = this._callbacks)[event] || (_base[event] = []);
      return this._callbacks[event].push(callback);
    },
    trigger: function(event, message) {
      var callback, list, _i, _len, _results;
      if (!(this._callbacks && (list = this._callbacks[event]))) return;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        callback = list[_i];
        _results.push(callback(message));
      }
      return _results;
    }
  };
}, "failed_assertion_message": function(exports, require, module) {(function() {
  var FailedAssertionMessage;

  module.exports = FailedAssertionMessage = (function() {

    function FailedAssertionMessage(failedAssert) {
      this.type = failedAssert.type;
      this.options = failedAssert.options;
    }

    FailedAssertionMessage.prototype.equal = function() {
      return "" + this.options.actual + " does not equal " + this.options.expected;
    };

    FailedAssertionMessage.prototype["true"] = function() {
      return "" + this.options.exp + " is not true";
    };

    FailedAssertionMessage.prototype.inDelta = function() {
      return "" + this.options.actual + " is not within " + this.options.expected + "±" + this.options.delta;
    };

    FailedAssertionMessage.prototype.refuteEqual = function() {
      return "" + this.options.actual + " equals " + this.options.expected;
    };

    FailedAssertionMessage.prototype.toString = function() {
      if (this[this.type]) {
        return this[this.type]();
      } else {
        return "Unknown assert fail: " + this.type;
      }
    };

    return FailedAssertionMessage;

  })();

}).call(this);
}, "main": function(exports, require, module) {
  module.exports = {
    TestCase: require('./test_case'),
    NodeRunner: require('./node_runner')
  };
}, "node_runner": function(exports, require, module) {(function() {
  var ConsolePresenter, Glob, Runner;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  ConsolePresenter = require('./console_presenter');

  Runner = require('./runner');

  Glob = require('glob');

  module.exports = (function() {

    __extends(_Class, Runner);

    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }

    _Class.prototype.presenterClass = ConsolePresenter;

    _Class.prototype.tests = function() {
      var file, _i, _len, _ref, _results;
      _ref = this.files();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        file = _ref[_i];
        _results.push(require(file));
      }
      return _results;
    };

    _Class.prototype.files = function() {
      return Glob.globSync("" + this.options.dir + "/**_test.coffee");
    };

    return _Class;

  })();

}).call(this);
}, "presenter": function(exports, require, module) {(function() {
  var FailedAssertionMessage;

  FailedAssertionMessage = require('./failed_assertion_message');

  module.exports = (function() {

    function _Class(tests, options) {
      var Test, _i, _len, _ref;
      var _this = this;
      this.tests = tests;
      this.options = options;
      this.completed = 0;
      this.succeeded_asserts = 0;
      this.failedAsserts = 0;
      this.asserts = 0;
      _ref = this.tests;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        Test = _ref[_i];
        Test.bind('runCompleted', function(test_run) {
          return _this.handleCompletedRun(test_run);
        });
        Test.bind('completed', function() {
          return _this.checkComplete();
        });
      }
    }

    _Class.prototype.handleCompletedRun = function(run) {
      var failedAssert, _i, _len, _ref, _results;
      this.asserts += run.failedAsserts.length + run.succeededAssertsCount;
      this.failedAsserts += run.failedAsserts.length;
      this.succeeded_asserts += run.succeededAssertsCount;
      _ref = run.failedAsserts;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        failedAssert = _ref[_i];
        _results.push(this.outputFailedAssert(failedAssert));
      }
      return _results;
    };

    _Class.prototype.checkComplete = function() {
      this.completed += 1;
      if (this.completed === this.tests.length) return this.complete();
    };

    _Class.prototype.failedAssertDescription = function(failedAssert) {
      return "" + failedAssert.run.constructor.name + "[" + failedAssert.run.methodName + "]: " + (this.failedAssertMessage(failedAssert));
    };

    _Class.prototype.failedAssertMessage = function(failedAssert) {
      return new FailedAssertionMessage(failedAssert).toString();
    };

    _Class.prototype.summaryMessage = function() {
      return "COMPLETE: " + this.asserts + " asserts, " + this.failedAsserts + " failed, " + this.succeeded_asserts + " succeeded";
    };

    return _Class;

  })();

}).call(this);
}, "runner": function(exports, require, module) {
  module.exports = (function() {

    function _Class(options) {
      this.options = options;
    }

    _Class.prototype.run = function() {
      var Test, _i, _len, _ref, _results;
      new this.presenterClass(this.tests(), this.options);
      _ref = this.tests();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        Test = _ref[_i];
        _results.push(Test.runAll());
      }
      return _results;
    };

    return _Class;

  })();
}, "test_case": function(exports, require, module) {(function() {
  var Assertsions, EventEmitter, Utils;

  Assertsions = require('./assertions');

  EventEmitter = require('./event_emitter');

  Utils = require('./utils');

  module.exports = (function() {

    _Class.runs = [];

    _Class.runAll = function() {
      var methodName, _i, _len, _ref, _results;
      this.completed = 0;
      if (this.testMethodNames().length > 0) {
        _ref = this.testMethodNames();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          methodName = _ref[_i];
          _results.push(this.run(methodName));
        }
        return _results;
      } else {
        return this.complete();
      }
    };

    _Class.run = function(methodName) {
      var run;
      var _this = this;
      run = new this(methodName);
      run.bind('completed', function() {
        return _this.runCompleted(run);
      });
      run.run();
      return this.runs.push(run);
    };

    _Class.runCompleted = function(run) {
      this.trigger('runCompleted', run);
      this.completed += 1;
      if (this.completed === this.testMethodNames().length) return this.complete();
    };

    _Class.complete = function() {
      return this.trigger('completed');
    };

    _Class.testMethodNames = function() {
      var methodName, _i, _len, _ref, _results;
      _ref = Object.keys(this.prototype);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        methodName = _ref[_i];
        if (methodName.substr(0, 5) === 'test ' || this.methodNameIsAsync(methodName)) {
          _results.push(methodName);
        }
      }
      return _results;
    };

    _Class.methodNameIsAsync = function(methodName) {
      return methodName.substr(0, 11) === 'async test ';
    };

    function _Class(methodName) {
      this.methodName = methodName;
      this.succeededAssertsCount = 0;
      this.failedAsserts = [];
    }

    _Class.prototype.run = function() {
      if (this.setup) this.setup();
      this[this.methodName]();
      if (this.teardown) this.teardown();
      if (!this.async()) return this.complete();
    };

    _Class.prototype.async = function() {
      return this.constructor.methodNameIsAsync(this.methodName);
    };

    _Class.prototype.complete = function() {
      this.completed = true;
      return this.trigger('completed');
    };

    _Class.prototype.storeAssert = function(type, succeeded, options) {
      if (options == null) options = {};
      if (succeeded) {
        return this.succeededAssertsCount += 1;
      } else {
        return this.failedAsserts.push({
          type: type,
          succeeded: succeeded,
          options: options,
          run: this
        });
      }
    };

    _Class.prototype.succeeded = function() {
      return this.completed && this.failedAsserts === 0;
    };

    return _Class;

  })();

  Utils.extend(module.exports.prototype, Assertsions);

  Utils.extend(module.exports.prototype, EventEmitter);

  Utils.extend(module.exports, EventEmitter);

}).call(this);
}, "utils": function(exports, require, module) {
  module.exports = {
    extend: function(obj1, obj2) {
      var key, value, _results;
      _results = [];
      for (key in obj2) {
        value = obj2[key];
        _results.push(obj1[key] = value);
      }
      return _results;
    }
  };
}});

}).call(window.Janitor.Stitch);
window.Janitor.TestCase = Janitor.Stitch.require('test_case'),
window.Janitor.BrowserRunner = Janitor.Stitch.require('browser_runner')
