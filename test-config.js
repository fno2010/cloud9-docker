module.exports = function(options, optimist) {
  var plugins = require("./standalone")(options, optimist);

  var includes = [
    /*
     * Add plugins you want to pre-install and test in to this list.
     * Like the following format:
     */

    // {
    //   packagePath: "./plugin.test/test"
    // },
  ];

  whitelist = {
    /*
     * Add plugins you want to serve on the static server.
     * Like the following format:
     */
    // "plugin.test": true
  };

  excludes = {
    /*
     * Add plugins you want to disable.
     * For example:
     */

    // "./plugin.test.disabled/test.disabled": true,
  };

  blacklist = {
    /*
     * Add plugins you don't want to serve on the static server.
     * For example:
     */
    // "plugin.test.disabled": true
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
