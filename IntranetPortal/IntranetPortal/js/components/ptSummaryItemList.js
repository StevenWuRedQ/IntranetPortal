/***
 * @property listStatusId: id used for properties list filter
 * @property itemFiled: field in json to displayed in html.
 */
angular.module("PortalApp").component("ptSummaryItemList",
{
    templateUrl: "/js/components/ptSummaryItemList.tpl.html",
    bindings: {
        listName: "@",
        listShortName: "@",
        listDataUrl: "@",
        listHref: "@",
        listFilter: "@",
        itemField: "@",
        itemClick: "&"
    },
    controller: function ($window, $element, $attrs, $http) {
        // debugger;
        var ctrl = this;
        ctrl.window = $window;
        ctrl.gridInstance = null;
        ctrl.listOptions = {
            columns: [
                {
                    dataField: ctrl.itemField,
                    cellTemplate: function (container, options) {
                        var result = $("<div>").addClass("list-item");
                        $("<a>").text(options.data[ctrl.itemField])
                            .css("padding-left", "10px")
                            .click({ data: options, filter: ctrl.listFilter }, ctrl.itemClick())
                            .appendTo(result);
                        result.appendTo(container);
                    }
                }
            ],
            rowAlternationEnabled: true,
            showColumnHeaders: false,
            pager: {
                showInfo: true
            },
            paging: {
                enabled: true
            },
            onRowPrepared: function (rowInfo) {
                if (rowInfo.rowType !== "data")
                    return;
                rowInfo.rowElement
                    .addClass("myRow");
            },
            onInitialized: function (e) {
                ctrl.gridInstance = e.component;
            }
        };
        var bindList = function () {
            $http({
                method: "GET",
                url: ctrl.listDataUrl
            }).then(function (d) {
                ctrl.gridInstance.option('dataSource', d.data.data);
                var spanTotal = $("#" + ctrl.listShortName + "List").find(".total-count")[0];
                if (spanTotal) {
                    $(spanTotal).html(d.data.count);
                }
            });
        };
        bindList();
    }
})