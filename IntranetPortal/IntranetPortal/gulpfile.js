var p = require('./package.json')
var del = require('del')
var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require('gulp-uglifyjs');
var replace = require('gulp-replace');

var buffer = '';
var config = {
    //Include all js files 
    src: ['js/*.js', 'js/controllers/*.js', 'js/models/*.js', 'js/Views/**/*.js', '!js/PortalHttpFactory.js'],
}


var getTimeString = function () {
    if (buffer) return buffer;
    var now = new Date();
    buffer = buffer + now.getFullYear() + (now.getMonth() + 1) + now.getDate()
    return buffer;
}

gulp.task('clean', function () {
    del('js/build/*.js')
})

gulp.task('concat', function () {
    gulp.src('js/controllers/*.js')
       .pipe(concat('controllers.js'))
       .pipe(gulp.dest('js/build/'))

    gulp.src('js/models/*.js')
       .pipe(concat('model.js'))
       .pipe(gulp.dest('js/build/'))


    gulp.src('js/Views/**/*.js')
       .pipe(concat('views.js'))
       .pipe(gulp.dest('js/build/'))

    gulp.src(['js/app.js', 'js/common/*.js',
                'js/build/model.js',
                'js/build/views.js', 'js/services.js',
                'js/filters.js', 'js/directives.js',
                'js/build/controllers.js'])
        .pipe(concat(p.name + '.js'))
        .pipe(gulp.dest('js/build/'))
})

gulp.task('uglify', function () {
    gulp.src('js/build/' + p.name + '.js')
    .pipe(uglify(p.name + '.min.js'))
    .pipe(gulp.dest('js/build/'))

})

gulp.task('replace', function () {

    gulp.src('Content.Master')
        .pipe(replace(/src="\/js\/build\/intranetportal.js(\?v=\d{0,8})?"/g,
        'src="/js/build\/intranetportal.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/autosave.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/autosave.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/stevenjs.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/stevenjs.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/autologout.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/autologout.js?v=' + getTimeString() + '"'))
        .pipe(replace(/href="\/css\/stevencss.css(\?v=\d{0,8})?"/g,
        'href="/css\/stevencss.css?v=' + getTimeString() + '"'))
        .pipe(gulp.dest(''), {overwrite:true})

    gulp.src('Root.Master')
        .pipe(replace(/src="\/js\/build\/intranetportal.js(\?v=\d{0,8})?"/g,
        'src="/js/build\/intranetportal.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/autosave.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/autosave.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/stevenjs.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/stevenjs.js?v=' + getTimeString() + '"'))
        .pipe(replace(/src="\/Scripts\/autologout.js(\?v=\d{0,8})?"/g,
        'src="/Scripts\/autologout.js?v=' + getTimeString() + '"'))
        .pipe(replace(/href="\/css\/stevencss.css(\?v=\d{0,8})?"/g,
        'href="/css\/stevencss.css?v=' + getTimeString() + '"'))
        .pipe(gulp.dest(''), {overwrite:true})

})

gulp.task('default', ['concat', 'uglify', 'replace'])