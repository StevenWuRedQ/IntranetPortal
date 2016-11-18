/// <reference path="./libs/jquery.d.ts" />
/// <reference path="./libs/devextreme.d.ts" />
/// <reference path="./libs/lodash.d.ts" />
"use strict";
var app;
(function (app) {
    var DashBoard = (function () {
        function DashBoard() {
            var opt = {
                height: 500,
                scrolling: { mode: 'virtual' },
                headerFilter: {
                    visible: true
                },
                dataSource: [1, 2, 3]
            };
            var grid = $('<div />');
            grid.dxDataGrid(opt);
        }
        DashBoard.prototype.setName = function (name) {
            this.Name = name;
        };
        DashBoard.prototype.update = function (iDashboard) {
            this.Name = iDashboard.Name;
            this.Id = iDashboard.Id;
        };
        DashBoard.prototype.hasId = function () {
            return this.Id > 0;
        };
        DashBoard.prototype.testId = function () {
            return true;
        };
        return DashBoard;
    }());
    app.DashBoard = DashBoard;
    var Main = (function () {
        function Main() {
        }
        Main.main = function () {
            var d = new DashBoard();
            var rd = [];
            _.range(1, 10).forEach(function (x) {
                var _d = new DashBoard();
                _d.setName("test " + x);
                rd.push(_d);
            });
            d.update({ Name: "test", Id: 2 });
            rd = [];
            rd = _.chain(rd)
                .filter(function (o) { return o.hasId(); }).value();
            return 0;
        };
        return Main;
    }());
    app.Main = Main;
})(app || (app = {}));
app.Main.main();
function itemClick(s, args) {
    //var underlyingData = [];
    //args.RequestUnderlyingData(function (data) {
    //    let dataMembers = data.GetDataMembers();
    //    dataMembers = _.filter(dataMembers, function (o) {
    //        //return ['MoveOutHot', 'MoveInHot', 'MovInHot'].indexOf(o) < 0
    //    });
    //    for (var i = 0; i < data.GetRowCount(); i++) {
    //        var dataTableRow = {};
    //        $.each(dataMembers, function (__, dataMember) {
    //            dataTableRow[dataMember] = data.GetRowValue(i, dataMember);
    //        });
    //        underlyingData.push(dataTableRow);
    //    }
    //    var $grid = $('<div/>');
    //    $grid.dxDataGrid({
    //        height: 500,
    //        scrolling: {
    //            mode: 'virtual'
    //        },
    //        headerFilter: {
    //            visible: true
    //        },
    //        dataSource: underlyingData
    //    });
    //    var popup = $("#myPopup").dxPopup();
    //    //let $popupContent = popup.content();
    //    //$popupContent.empty();
    //    //$popupContent.append($grid);
    //    // popup.show();
    //}
}
exports.itemClick = itemClick;
