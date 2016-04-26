exports.config = {
    framework: 'jasmine',
    seleniumAddress: 'http://localhost:4444/wd/hub',
    specs: ['*.js', '!conf.js'],
    capabilities: {
        'browserName': 'chrome'
    }
};