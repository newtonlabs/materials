// http://terrcin.io/2017/04/16/phoenix-1.3-with_bootstrap_4_and_font_awesome/
// Great help for below

exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //   "js/app.js": /^js/,
      //   "js/vendor.js": /^(?!js)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "vendor/js/jquery-2.1.1.js",
      //     "vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["priv/static/css/app.scss"] // concat app.scss last
      },
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    sass: {
      options: {
        includePaths: ["node_modules/bootstrap/scss", "node_modules/font-awesome/scss"], // tell sass-brunch where to look for files to @import
        precision: 8 // minimum precision required by bootstrap
      }
    },
    copycat: {
      "fonts": [
        "node_modules/font-awesome/fonts"
        // "node_modules/bootstrap-sass/assets/fonts/bootstrap",
      ] // copy these files into priv/static/fonts/
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"]
    }
  },

  npm: {
    enabled: true,
    globals: { // Bootstrap JavaScript requires both '$', 'jQuery', and Tether in global scope
      $: 'jquery',
      jQuery: 'jquery',
      Popper: 'popper.js',
      bootstrap: 'bootstrap',
      dragula: 'dragula',
      d3: 'd3'
    }
    // styles: {
    //   "bootstrap-table": ["dist/bootstrap-table.css"],
    //   "jquery-ui": ["themes/base/all.css"]
    // } // included these styles into the build
  }
};
