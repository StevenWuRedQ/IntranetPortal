angular.module("PortalApp").service("ptTime", [function () {
    var that = this;

    this.isPassByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days > count) {
            return true;
        }

        return false;
    }
    this.isPassOrEqualByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days >= count) {
            return true;
        }

        return false;
    }
    this.isLessOrEqualByDays = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);

        // Do the math.
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = end_date.getTime() - start_date.getTime();
        var days = millisBetween / millisecondsPerDay;

        if (days >= 0 && days <= count) {
            return true;
        }

        return false;
    }
    this.isPassByMonths = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);
        var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

        if (months > count) return true;
        else return false;
    }
    this.isPassOrEqualByMonths = function (start, end, count) {
        var start_date = new Date(start);
        var end_date = new Date(end);
        var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

        if (months >= count) return true;
        else return false;
    }

    }])