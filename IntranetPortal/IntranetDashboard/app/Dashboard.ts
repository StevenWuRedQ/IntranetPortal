/// <reference path="./libs/jquery.d.ts" />
/// <reference path="./libs/devextreme.d.ts" />
/// <reference path="./libs/lodash.d.ts" />



namespace app {
    interface DashBoadModel {
       Name: string;
       Id: number;
      
    }
    export class DashBoard implements DashBoadModel{
        public Name: string;
        public Id: number;
        public constructor() {
            let opt: DevExpress.ui.dxDataGridOptions = {
                height: 500,
                scrolling: { mode: 'virtual' },
                headerFilter:
                {
                    visible: true
                },
                dataSource: [1, 2, 3]
            };
            let grid = $('<div />');
            grid.dxDataGrid(opt)

        }

        public setName(name:string): void {
            this.Name = name;
        }
        public update(iDashboard:DashBoadModel): void {
            this.Name = iDashboard.Name;
            this.Id = iDashboard.Id;
        }
        public hasId(): boolean {
            return this.Id > 0;
        }
        public testId(): boolean {
            return true;
        }
    }

    export class Main {
        public static main(): number {
            let d = new DashBoard();
            let rd: DashBoard[] = [];
            _.range(1, 10).forEach(x => {
                let _d = new DashBoard();
                _d.setName("test " + x);
                rd.push(_d)
            });
            d.update({ Name: "test", Id: 2 });
            rd = [];
            rd = _.chain(rd)
                .filter(o => o.hasId()).value();
                
            return 0;
        }
    }
}
app.Main.main();
export function itemClick(s: any, args: any) {
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