module.exports = function(options, optimist) {
  var plugins = require("./devopen")(options, optimist);

  var includes = [
    "./snlab.devopen.server/managerd",
    "./snlab.devopen.topoeditor/static",
  ];

  whitelist = {
    "snlab.devopen.layout": true,
    "snlab.devopen.newresource": true,
    "snlab.devopen.controller": true,
    "snlab.devopen.topoeditor": true
  };

  excludes = {
  };

  blacklist = {
    "snlab.devopen.server": true
  };

  plugins = plugins.concat(includes).filter(function (p) {
    if (p.packagePath === "./c9.ide.server/plugins") {
      for (plugin in whitelist) {
        p.whitelist[plugin] = whitelist[plugin];
      }
      for (plugin in blacklist) {
        p.blacklist[plugin] = blacklist[plugin];
      }
    }
    return !excludes[p] && !excludes[p.packagePath];
  });

  return plugins;
};

if (!module.parent) require("../server")([__filename].concat(process.argv.slice(2)));
