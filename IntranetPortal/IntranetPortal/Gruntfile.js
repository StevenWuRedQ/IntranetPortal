module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        concat:{
            generated: {
                files: [
                    {
                        src: ['js/controllers/*.js'],
                        dest: 'js/controllers.js'
                    },
                    {
                        src: ['js/app.js', 'js/services.js', 'js/filters.js', 'js/directives.js', 'js/controllers.js'],
                        dest: 'js/<%= pkg.name %>.js'
                    }
                ]
                
            }
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            build: {
                src: 'js/<%= pkg.name %>.js',
                dest: 'js/build/<%= pkg.name %>.min.js'
            }
        },
        karma: {
            unit: {
                configFile: 'js/test/conf.js'
            }
        }
    });


    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-karma');

    // Default task(s).
    grunt.registerTask('default', ['concat', 'uglify']);
    grunt.registerTask('unittest', ['karma']);
    grunt.registerTask('e2etest', ['protractor']);

};