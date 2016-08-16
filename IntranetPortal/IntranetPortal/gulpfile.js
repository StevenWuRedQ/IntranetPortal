var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var del = require('del');
var watch = require('gulp-watch');
var batch = require('gulp-batch');
var rename = require('gulp-rename');

var config = {
    //Include all js files 
    src: ['js/*.js', 'js/controllers/*.js','js/models/*.js','js/Views/**/*.js','!js/PortalHttpFactory.js'],
}

//delete the output file(s)
gulp.task('clean', function () {
    //del is an async function and not a gulp plugin (just standard nodejs)
    //It returns a promise, so make sure you return that from this task function
    //  so gulp knows when the delete is complete
    //return del(['js/build/intranetportal.min.js']);
});

gulp.task('watch', function () {
    watch('js/controllers/*.js', batch(function (events, done) {
        gulp.start('scripts', done);
    }));
    watch('js/*.js', batch(function (events, done) {
        gulp.start('scripts', done);
    }));
    watch('js/models/*.js', batch(function (events, done) {
        gulp.start('scripts', done);
    }));
    watch('js/Views/**/*.js', batch(function (events, done) {
        gulp.start('scripts', done);
    }));
});

// Combine and minify all files from the app folder
// This tasks depends on the clean task which means gulp will ensure that the 
// Clean task is completed before running the scripts task.
gulp.task('scripts', ['clean'], function () {

    return gulp.src(config.src)
      //.pipe(uglify())
      .pipe(concat('intranetportal.js'))
      .pipe(gulp.dest('js/build/'))
      .pipe(rename('intranetportal.min.js'))
      .pipe(uglify())
      .pipe(gulp.dest('js/build/'));
});

//Set a default tasks
gulp.task('default', ['scripts'], function () { });