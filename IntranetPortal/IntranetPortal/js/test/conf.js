// Karma configuration
// Generated on Mon Nov 30 2015 14:30:40 GMT-0500 (Eastern Standard Time)

module.exports = function (config) {
    config.set({

        // base path that will be used to resolve all patterns (eg. files, exclude)
        basePath: '../..',


        // frameworks to use
        // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ['jasmine'],


        // list of files / patterns to load in the browser
        files: [
            'https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js',
            'http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/globalize/0.1.1/globalize.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.10.1/lodash.min.js',
            'bower_components/moment/moment.js',
            'https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-route.min.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-resource.min.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-animate.min.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-aria.min.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-sanitize.js',
            'https://ajax.googleapis.com/ajax/libs/angularjs/1.3.20/angular-mocks.js',
            'https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.3.1/angular-ui-router.min.js',
            'http://cdn3.devexpress.com/jslib/16.1.6/js/dx.all.js',
            'https://cdnjs.cloudflare.com/ajax/libs/angular-ui-select/0.12.1/select.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.14.3/ui-bootstrap-tpls.min.js',
            'http://cdn.ckeditor.com/4.5.1/standard/ckeditor.js',
            'https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/0.9.0/jquery.mask.min.js',
            'https://cdn.firebase.com/js/client/2.2.4/firebase.js',
            'https://cdn.firebase.com/libs/angularfire/1.1.4/angularfire.min.js',
            'bower_components/angular-ui-layout/src/ui-layout.js',
            'bower_components/ngMask/dist/ngMask.min.js',
            'bower_components/jquery-formatcurrency/jquery.formatCurrency-1.4.0.js',
            'bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js',
            'Scripts/*.js',
            'js/*.js',
            'js/common/*.js',
            'js/models/*.js',
            'js/controllers/*.js',
            'js/directives/*.js',
            'js/filters/*.js',
            'js/services/*.js',
            'js/test/*.js',
            'js/templates/*.html'
        ],


        // list of files to exclude
        exclude: [
        ],


        // preprocess matching files before serving them to the browser
        // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors: {
            'js/templates/*.html': ['ng-html2js']
        },


        // test results reporter to use
        // possible values: 'dots', 'progress'
        // available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ['progress'],


        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,


        // start these browsers
        // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: ['Chrome'],


        // Continuous Integration mode
        // if true, Karma captures browsers, runs the tests and exits
        singleRun: false,

        // Concurrency level
        // how many browser should be started simultanous
        concurrency: Infinity,

        plugins: [
            'karma-chrome-launcher',
            'karma-jasmine',
            'karma-ng-html2js-preprocessor'
        ]
    })
}