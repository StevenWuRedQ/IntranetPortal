(function () {
    var that = this;

    // dictionary to store 
    var functions = {
        'helloworld': function () { }
    };

    function compile(rules) {
        var result = [];
        for (var i = 0; i < rules.length; i++) {

        }
    }

    function parse(rule) {

    }


    function run(compiled_rules) {
        for (var i = 0; i < compiled_rules.length; i++) {
            execute(compiled_rules[i]);
        }
    }

    function execute(compiled_rule) {

    }
    
    // factory
    var Engine = function (options) {
        this.dataSource = options.dataSource || {};
        this.rules = [];
        this.compiled_rules = [];
        this.isCompiled = false;
        this.compile = function() {
            this.compiled_rules = compile(this.rules);
        }
        this.run = function() {
            if(!this.isCompiled) {
                this.compile();
            }
            run(this.compiled_rules);
        }
    }

    return {
        Engine: Engine
    }
})();