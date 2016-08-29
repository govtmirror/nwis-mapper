﻿'use strict';

//load dependencies
var gulp = require('gulp'),
    git = require('gulp-git'),
    bump = require('gulp-bump'),
    jshint = require('gulp-jshint'),
    size = require('gulp-size'),
    uglify = require('gulp-uglify'),
    connect = require('gulp-connect'),
    del= require('del'),
    open = require('open'),
    wiredep = require('wiredep').stream,
    semver = require('semver');

//get current app version
var version = require('./package.json').version;

function inc(importance) {
    //get new version number
    var newVer = semver.inc(version, importance);

    // get all the files to bump version in 
    return gulp.src(['./package.json', './bower.json', './tsd.json'])
        // bump the version number in those files 
        .pipe(bump({ type: importance }))
        // save it back to filesystem 
        .pipe(gulp.dest('./'))
        // commit the changed version number 
        .pipe(git.commit('Release v' + newVer))
        // **tag it in the repository** 
        //.pipe(git.tag('v' + newVer));
        .pipe(git.tag('v' + newVer, 'Version message', function (err) {
            if (err) throw err;
        }));
}

//copy Views folder
gulp.task('dist', function () {
    return gulp.src('test/**/*')
        .pipe(gulp.dest('dist'));
});

gulp.task('patch', ['dist'], function () { return inc('patch'); })
gulp.task('feature', ['dist'], function () { return inc('minor'); })
gulp.task('release', ['dist'], function () { return inc('major'); })

gulp.task('push', function () {
    console.info('Pushing...');
    return git.push('USGS-OWI', 'master', { args: " --tags" }, function (err) {
        if (err) {
            console.error(err);
            throw err;
        } else {
            console.info('done pushing to github!');
        }
    });
});

//copy Views folder
gulp.task('views', function () {
    return gulp.src('src/Views/**/*')
        .pipe(gulp.dest('test/Views'));
});

// Styles
gulp.task('styles', function () {
    return gulp.src(['src/styles/main.css'])
        .pipe(autoprefixer('last 1 version'))
        .pipe(gulp.dest('test/styles'))
        .pipe(size());
});

// Icons
gulp.task('icons', function () {
    return gulp.src(['bower_components/bootstrap/dist/fonts/*.*', 'bower_components/font-awesome/fonts/*.*'])
        .pipe(gulp.dest('test/fonts'));
});

// Scripts
gulp.task('scripts', function () {
    return gulp.src(['src/**/*.js'])
    .pipe(jshint('.jshintrc'))
    .pipe(jshint.reporter('default'))
    .pipe(size());
});

// HTML
gulp.task('html', ['styles', 'scripts', 'icons', 'views'], function () {
    var jsFilter = filter('**/*.js');
    var cssFilter = filter('**/*.css');

    return gulp.src('src/*.html')
        .pipe(useref.assets())
        .pipe(jsFilter)
        .pipe(uglify())
        .pipe(jsFilter.restore())
        .pipe(cssFilter)
        .pipe(csso())
        .pipe(cssFilter.restore())
        .pipe(useref.restore())
        .pipe(useref())
        .pipe(gulp.dest('test'))
        .pipe(size());
});

// Images
gulp.task('images', function () {
    return gulp.src([
    		'src/images/**/*',
    		'src/lib/images/*',
            'bower_components/leaflet/dist/images/*.*'])
        .pipe(gulp.dest('test/images'))
        .pipe(size());
});

// Clean
gulp.task('clean', function (cb) {
    del([
      'test/styles/**',
      'test/scripts/**',
      'test/images/**',
    ], cb);
});

// build test
gulp.task('test', ['html', 'images']);

// Default task
gulp.task('default', ['clean'], function () {
    gulp.start('test');
});

// Watch
gulp.task('watch', ['connect', 'serve'], function () {
    // start up
});

// Connect
gulp.task('connect', function () {
    connect.server({
        root: 'test',
        port: 9000
    });
});

// Open
gulp.task('serve', ['connect'], function () {
    open("http://localhost:9000");
});

// Inject Bower components
/*
gulp.task('wiredep', function () {
    gulp.src('src/styles/*.css')
        .pipe(wiredep({
            directory: 'src/bower_components',
            ignorePath: 'src/bower_components/'
        }))
        .pipe(gulp.dest('src/styles'));

    gulp.src('src/*.html')
        .pipe(wiredep({
            directory: 'src/bower_components',
            ignorePath: 'src/'
        }))
        .pipe(gulp.dest('src'));
});
*/