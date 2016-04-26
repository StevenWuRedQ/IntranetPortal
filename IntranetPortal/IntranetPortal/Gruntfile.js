module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        concat:{
            generated: {
                files: [
                    {
                        src: ['js/controllers/*.js'],
                        dest: 'js/build/controllers.js'
                    },
                    {
                        src: ['js/app.js', 'js/services.js', 'js/filters.js', 'js/directives.js', 'js/build/controllers.js'],
                        dest: 'js/build/<%= pkg.name %>.js'
                    }
                ]
                
            }
        },
        watch: {
            scripts: {
                files: ['js/controllers/*.js'],
                tasks: ['concat', 'uglify', 'replace'],
                
            },
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            build: {
                src: 'js/build/<%= pkg.name %>.js',
                dest: 'js/build/<%= pkg.name %>.min.js'
            }
        },
        karma: {
            unit: {
                configFile: 'js/test/conf.js'
            }
        },
        replace: {
            change_content_master: {
                src: ['Content.Master','Root.Master'],
                overwrite: true,
                replacements: [{
                    from: /src="\/js\/build\/intranetportal.js(\?v=\d{0,8})?"/g,
                    to: 'src="/js/build\/intranetportal.js?v=<%= grunt.template.today("ddmmyyyy") %>"'
                }, {
                    from: /src="\/Scripts\/autosave.js(\?v=\d{0,8})?"/g,
                    to: 'src="/Scripts\/autosave.js?v=<%= grunt.template.today("ddmmyyyy") %>"'
                }, {
                    from: /src="\/Scripts\/stevenjs.js(\?v=\d{0,8})?"/g,
                    to: 'src="/Scripts\/stevenjs.js?v=<%= grunt.template.today("ddmmyyyy") %>"'
                }, {
                    from: /src="\/Scripts\/autologout.js(\?v=\d{0,8})?"/g,
                    to: 'src="/Scripts\/autologout.js?v=<%= grunt.template.today("ddmmyyyy") %>"'
                },{
                    from: /href="\/css\/stevencss.css(\?v=\d{0,8})?"/g,
                    to: 'href="/css\/stevencss.css?v=<%= grunt.template.today("ddmmyyyy") %>"'
                }]

            }

        }
    });


    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-karma');
    grunt.loadNpmTasks('grunt-text-replace');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-protractor-runner');

    // Default task(s).
    grunt.registerTask('default', ['concat', 'uglify', 'replace']);
    grunt.registerTask('unittest', ['karma']);
    grunt.registerTask('e2etest', ['protractor']);
    grunt.registerTask('watch', ['watch'])
   
};