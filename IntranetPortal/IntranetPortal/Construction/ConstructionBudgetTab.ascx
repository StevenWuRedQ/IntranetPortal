<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetTab.ascx.vb" Inherits="IntranetPortal.ConstructionBudgetTab" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpreadsheet.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpreadsheet" TagPrefix="dx" %>
<div>
    <link rel="stylesheet" media="screen" href="/Scripts/handsontable-master/dist/handsontable.full.css" />
    <script src="/Scripts/handsontable-master/dist/handsontable.full.js"></script>
    <script src="/Scripts/ruleJS-0.0.5/dist/full/ruleJS.all.full.js"></script>



    <div id="budgetTable" style="overflow: auto"></div>
</div>
<script>

    var budgetControl = (function () {
        var ht, initData;

        getNewData = function () {
            var newData = _.clone(initData, true);
            return newData;
        }
        reload = function () {
            var newData = getNewData();
            ht.loadData(newData);
        }

        initData = [
            { "balance": "=SUM(F1:G1)", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Pre-Construction" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Asbestos" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Survey" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Borings" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Exhibits" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Architectual Fees" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Structural Engineer " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Mechanical Engineer" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Expeditor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "DOB fees" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "sprinkler plans" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Construction Permits" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "SITE WORK" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Demolition 100%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Demo Work 50%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Garbadge/Clean 50%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Sewers" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Blasting" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Sidewalks" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Water Main Dig" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "BUILDING FRAME/ENVELOPE" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Foundation " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Framing Material/Metal" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Metal Joist/Studs/Track" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Wood Joists" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Framing labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Roofing/Deck" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Gutters" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Insulation + Soundproofing" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Siding/Façade" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Material" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Capping" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Windows/Skylights" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Interior Glass" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Front Door/Glass/Metal Doors" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Roof Deck" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Railings (internal/Roof)" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Staircases" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Railings " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Bulkhead" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Metal Gates/ front and window" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "INTERIOR WALLS" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Sheetrock " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Tape " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Plaster" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Molding" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Insulation + Soundproofing" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "INTERIOR DOORS" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Handles" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Closet Knobs" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Front Door" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Rear Door" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Metal Doors" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Interior Painting/Material" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "PLUMBING " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "General" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Meters" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Toilets " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Vanities" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Mirrors" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Shower Glass" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "  Tubs" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Water Meter" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "RPZ Testing " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Hydrant Test Flow" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Fire Sprinkler System" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Sump Pump" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Back Valve" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Plumbing Permits" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "HVAC Labor/Black" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "General" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "ELECTRIC" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "labor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "General Wiring" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Permits" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Meters" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Electric Permits" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "KITCHENS" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Kitchen Cabinets" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Granite Countertops/Windowsills" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Faucets" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Appliances" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "TILE" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Tile Kitchens/BackSplash/Floor" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Tile Baths" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Cellar" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "FLOORS" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Wood Flooring" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "EXTRA" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "GC salary" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Fireplaces" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Closet Systems" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Mirror Work" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Backyard Work/Structure/Fence" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Steel Deck " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Landscaping" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Paint" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Iron Deck" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Finishes (inc: lighting,vanities, etc.)" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "TOTALS:" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Signing Contract - 10% " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Finish Framing - 10%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Finish Plumbing and Elctrical Roughing - 10%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Finish Sheetrock, Tiling, and Paining - 20%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Install Kitchens and Doors - 20%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Complete all Outisde work (decks, garden, facade) - 20%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Contingency - 10%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Turn Key - 5%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Punch List Completed - 5%" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "" },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Start Job - " },
{ "balance": "", "estimate": "", "qty": "", "materials": "", "labor": "", "contract": "", "paid": "", "Description": "Anticipated Completion -" }];

        ht = new Handsontable(document.getElementById('budgetTable'), {

            data: getNewData(),
            minCols: 8,
            rowHeaders: false,
            colHeaders: true,
            colWidths: [180, 65, 50, 60, 60, 90, 60, 60],
            colHeaders: ["Description", "Estimate", "Qty", "Materials", "Labor", "Contract Price", "Paid", "Balance"],
            columns: [
                {
                    data: 'Description'
                },
                {
                    data: 'estimate',
                    type: 'numeric',
                    format: '$0,0.00'

                },
                {
                    data: 'qty',
                    type: 'numeric'
                },
                {

                    data: 'materials',
                    type: 'numeric',
                    format: '$0,0.00'
                },
                {
                    data: 'labor',
                    type: 'numeric',
                    format: '$0,0.00'
                },
                {
                    data: 'contract',
                    type: 'numeric',
                    format: '$0,0.00'

                },
                {
                    data: 'paid',
                    type: 'numeric',
                    format: '$0,0.00'

                },
                {
                    data: 'balance',
                    type: 'numeric',
                    format: '$0,0.00'

                }],
            manualColumnResize: true,
            formulas: true

        })

        return {
            reload: reload,
            getData: ht.getData,
            load: ht.loadData
        }

    })();


</script>

