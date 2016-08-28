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

  excludes = {
    /*
     * Add plugins you want to disable.
     * For example:
     */

    // "./plugin.test.disabled/test.disabled": true,
  };

  plugins = plugins.concat(includes).filter(function (p) {
    return !excludes[p] && !excludes[p.packagePath];
  });

  return plugins;
};

if (!module.parent) require("../server")([__filename].concat(process.argv.slice(2)));
