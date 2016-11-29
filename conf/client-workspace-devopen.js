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
  var config = require("./client-devopen")(options);
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
    },
    {
      packagePath: "plugins/snlab.devopen.topoeditor/topoeditor",
      staticPrefix: options.staticPrefix + "/plugins/snlab.devopen.topoeditor"
    },
  ].filter(Boolean);

  excludes = {
    "plugins/c9.ide.newresource/newresource": true
  };

  config = config.concat(includes).filter(function (p) {
    return !excludes[p] && !excludes[p.packagePath];
  });

  return config;
};
