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
}).call(this)({"asserts": function(exports, require, module) {
  module.exports = {
    assertEqual: function(val1, val2) {
      return this.store_assert('equal', val1 === val2, {
        val1: val1,
        val2: val2
      });
    },
    assert: function(exp) {
      return this.store_assert('true', exp, {
        exp: exp
      });
    },
    assertThrows: function(callback, check) {
      var caught, error, success;
      caught = false;
      error = null;
      try {
        callback();
      } catch (thrown_error) {
        caught = true;
        error = thrown_error;
      }
      success = caught && (!check || check(error));
      return this.store_assert('throw', success, {
        callback: callback,
        error: error
      });
    },
    assertContains: function(container, value) {
      var result;
      result = container.indexOf(value) !== -1;
      return this.store_assert('contains', result, {
        container: container,
        value: value
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

    _Class.prototype.outputFailedAssert = function(failed_assert) {
      var el, text;
      text = this.failedAssertDescription(failed_assert);
      el = $('<div>').text(text);
      el.css({
        color: 'red'
      });
      return $(this.options.el).append(el);
    };

    _Class.prototype.complete = function() {
      return $(this.options.el).append($('<div>').text(this.summaryMessage()));
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

    _Class.prototype.presenter_class = BrowserPresenter;

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

    _Class.prototype.outputFailedAssert = function(failed_assert) {
      return console.log(this.failedAssertDescription(failed_assert));
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
}, "failed_assert_message_resolver": function(exports, require, module) {
  module.exports = (function() {

    function _Class(failed_assert) {
      this.type = failed_assert.type;
      this.options = failed_assert.options;
    }

    _Class.prototype.message = function() {
      if (this[this.type]) {
        return this[this.type]();
      } else {
        return "Unknown assert fail: " + this.type;
      }
    };

    _Class.prototype.equal = function() {
      return "" + this.options.val1 + " does not equal " + this.options.val2;
    };

    _Class.prototype["true"] = function() {
      return "" + this.options.exp + " is not true";
    };

    return _Class;

  })();
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

    _Class.prototype.presenter_class = ConsolePresenter;

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
  var FailedAssertMessageResolver;

  FailedAssertMessageResolver = require('./failed_assert_message_resolver');

  module.exports = (function() {

    function _Class(tests, options) {
      var Test, _i, _len, _ref;
      var _this = this;
      this.tests = tests;
      this.options = options;
      this.completed = 0;
      this.succeeded_asserts = 0;
      this.failed_asserts = 0;
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
      var failed_assert, _i, _len, _ref, _results;
      this.asserts += run.failed_asserts.length + run.succeeded_asserts_count;
      this.failed_asserts += run.failed_asserts.length;
      this.succeeded_asserts += run.succeeded_asserts_count;
      _ref = run.failed_asserts;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        failed_assert = _ref[_i];
        _results.push(this.outputFailedAssert(failed_assert));
      }
      return _results;
    };

    _Class.prototype.checkComplete = function() {
      this.completed += 1;
      if (this.completed === this.tests.length) return this.complete();
    };

    _Class.prototype.failedAssertDescription = function(failed_assert) {
      return "" + failed_assert.run.constructor.name + "[" + failed_assert.run.method_name + "]: " + (this.failedAssertMessage(failed_assert));
    };

    _Class.prototype.failedAssertMessage = function(failed_assert) {
      return new FailedAssertMessageResolver(failed_assert).message();
    };

    _Class.prototype.summaryMessage = function() {
      return "COMPLETE: " + this.asserts + " asserts, " + this.failed_asserts + " failed, " + this.succeeded_asserts + " succeeded";
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
      new this.presenter_class(this.tests(), this.options);
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
  var Asserts, EventEmitter, Utils;

  Asserts = require('./asserts');

  EventEmitter = require('./event_emitter');

  Utils = require('./utils');

  module.exports = (function() {

    _Class.runs = [];

    _Class.runAll = function() {
      var method_name, _i, _len, _ref, _results;
      this.completed = 0;
      if (this.testMethodNames().length > 0) {
        _ref = this.testMethodNames();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          method_name = _ref[_i];
          _results.push(this.run(method_name));
        }
        return _results;
      } else {
        return this.complete();
      }
    };

    _Class.run = function(method_name) {
      var run;
      var _this = this;
      run = new this(method_name);
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
      var method_name, _i, _len, _ref, _results;
      _ref = Object.keys(this.prototype);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        method_name = _ref[_i];
        if (method_name.substr(0, 5) === 'test ' || this.methodNameIsAsync(method_name)) {
          _results.push(method_name);
        }
      }
      return _results;
    };

    _Class.methodNameIsAsync = function(method_name) {
      return method_name.substr(0, 11) === 'async test ';
    };

    function _Class(method_name) {
      this.method_name = method_name;
      this.succeeded_asserts_count = 0;
      this.failed_asserts = [];
    }

    _Class.prototype.run = function() {
      if (this.setup) this.setup();
      this[this.method_name]();
      if (this.teardown) this.teardown();
      if (!this.async()) return this.complete();
    };

    _Class.prototype.async = function() {
      return this.constructor.methodNameIsAsync(this.method_name);
    };

    _Class.prototype.complete = function() {
      this.completed = true;
      return this.trigger('completed');
    };

    _Class.prototype.store_assert = function(type, succeeded, options) {
      if (options == null) options = {};
      if (succeeded) {
        return this.succeeded_asserts_count += 1;
      } else {
        return this.failed_asserts.push({
          type: type,
          succeeded: succeeded,
          options: options,
          run: this
        });
      }
    };

    _Class.prototype.succeeded = function() {
      return this.completed && this.failed_asserts === 0;
    };

    return _Class;

  })();

  Utils.extend(module.exports.prototype, Asserts);

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
