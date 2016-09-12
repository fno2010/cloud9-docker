var join = require("path").join;
var fs = require("fs");

function readRunners(base, path) {
  var results = {};
  var runnersPath = base + "/" + path + "/";
  fs.readdirSync(runnersPath).forEach(function (name) {
    var runner = fs.readFileSync(runnersPath + name, "utf8");
    try {
      // handle symlinks on windows
      if (/^..\//.test(runner))
        runner = fs.readFileSync(runnersPath + runner.trim(), "utf8");
      var json = JSON.parse(runner.replace(/(^|\n)\s*\/\/.*$/mg, ""));
      json.caption = name.replace(/\.run$/, "");
      json.$builtin = true;
      results[json.caption] = json;
    } catch (e) {
      console.error("Syntax error in runner", runnersPath + name, e);
    }
  });
  return results;
}

module.exports = function(options) {
  options.collab = false;
  var config = require("./client-default")(options);
  return module.exports.makeLocal(config, options);
};

module.exports.makeLocal = function(config, options) {

  // Add deploy runner
  var extRunners = readRunners(__dirname + "/../plugins/snlab.devopen.controller", "runners");
  for (var name in extRunners) {
    options.runners[name] = extRunners[name];
  }

  // Add local modules
  var includes = [
    /*
     * Add plugins you want to install and test in your own workspace.
     * Like following format:
     */

    // {
    //   packagePath: "plugins/plugin.test/test.static",
    //   staticPrefix: options.staticPrefix + "/plugins/c9.ide.test"
    // },
    // {
    //   packagePath: "plugins/plugin.test/test",
    //   options: options
    // },
    {
      packagePath: "plugins/snlab.devopen.newresource/newresource",
      options: options
    },
    {
      packagePath: "plugins/snlab.devopen.newresource/progress",
      options: options
    },
    {
      packagePath: "plugins/snlab.devopen.controller/management",
      staticPrefix: options.staticPrefix + "/plugins/snlab.devopen.controller"
    }
  ].filter(Boolean);

  excludes = {
    /*
     * Add plugins you want to disable.
     * For example:
     */

    // "./plugin.test.disabled/test.disabled": true,
    "plugins/c9.ide.newresource/newresource": true
  };

  config = config.concat(includes).filter(function (p) {
    return !excludes[p] && !excludes[p.packagePath];
  });

  return config;
};
