'use strict';

module.exports = function(grunt) {
    require('load-grunt-config')(grunt);

    grunt.registerTask('server', function() {
        grunt.task.run([
            'configureProxies',
            'connect:server',
            'esteWatch'
        ]);
    });

    grunt.registerTask('dev', function() {
        grunt.task.run([
            'clean:temp',
            'browserify',
            'coffeelint',
            'copy:img',
            'copy:audio',
            'jade:compile',
            'compass:dev',
            'server'
        ]);
    });

    grunt.registerTask('build', function() {
        grunt.task.run([
            'clean:prod',
            'browserify',
            'coffeelint',
            'uglify:apps',
            'copy:imgProd',
            'copy:audioProd',
            'compass:prod',
            'jade:prod'
        ]);
    });
};
