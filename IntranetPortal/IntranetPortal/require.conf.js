require.config({
  baseUrl: "/",
  shim: {
      "angular": {
          exports: "angular"
      },
      "angular-resource": {
          deps: ["angular"]
      },
      "angular-route": {
          deps: ["angular"]
      },
      "angular-animate": {
          deps: ["angular"]
      },
      "angular-sanitize": {
          deps: ["angular"]
      },
      "angular-aria": {
          deps: ["angular"]
      },
      "angular-bootstrap-tpls": {
          deps: ["angular"]
      },
      "angular-bootstrap": {
          deps: ["angular"]
      },
  },
  paths: {
    "jquery-backstretch": "bower_components/jquery-backstretch/jquery.backstretch",
    modernizr: "bower_components/modernizr/modernizr",
    signalr: "bower_components/signalr/jquery.signalR",
    "angular-mocks": "bower_components/angular-mocks/angular-mocks",
    bootstrap: "bower_components/bootstrap/dist/js/bootstrap",
    "malihu-custom-scrollbar-plugin": "bower_components/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar",
    moment: "bower_components/moment/moment",
    globalize: "bower_components/globalize/lib/globalize",
    "ionic-angular": "bower_components/ionic/release/js/ionic-angular",
    "jQuery-Collapse": "bower_components/jQuery-Collapse/src/jquery.collapse",
    "jquery-form": "bower_components/jquery-form/jquery.form",
    "jquery-ui": "bower_components/jquery-ui/jquery-ui",
    "webui-popover": "bower_components/webui-popover/dist/jquery.webui-popover",
    prototype: "bower_components/prototypejs/dist/prototype.min",
    "angular-ui-layout": "bower_components/angular-ui-layout/src/ui-layout",
    "jquery-mousewheel": "bower_components/jquery-mousewheel/jquery.mousewheel",
    ionic: "bower_components/ionic/release/js/ionic",
    "bootstrap-datepicker": "bower_components/bootstrap-datepicker/js/bootstrap-datepicker",
    requirejs: "bower_components/requirejs/require",
    "jquery-steps": "bower_components/jquery-steps/build/jquery.steps",
    "jquery.easing": "bower_components/jquery-easing/jquery.easing.min",
    literallycanvas: "bower_components/literallycanvas/js/literallycanvas.min",
    jquery: "bower_components/jquery/dist/jquery",
    lodash: "bower_components/lodash/lodash",
    angular: "bower_components/angular/angular",
    Ionicons: "bower_components/Ionicons/fonts/*",
    controllers: "js/controllers",
    models: "js/models",
    js: "js",
    "jquery.steps": "bower_components/jquery.steps/build/jquery.steps",
    "angular-resource": "bower_components/angular-resource/angular-resource",
    "angular-route": "bower_components/angular-route/angular-route",
    "angular-animate": "bower_components/angular-animate/angular-animate",
    "angular-sanitize": "bower_components/angular-sanitize/angular-sanitize",
    "angular-aria": "bower_components/angular-aria/angular-aria",
    "angular-bootstrap-tpls": "bower_components/angular-bootstrap/ui-bootstrap-tpls",
    "angular-bootstrap": "bower_components/angular-bootstrap/ui-bootstrap"
  },
  packages: [
    {
      name: "ngMask",
      main: "dist/ngMask.js"
    }
  ]
});
