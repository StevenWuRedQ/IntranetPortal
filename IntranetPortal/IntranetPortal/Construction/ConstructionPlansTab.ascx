<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPlansTab.ascx.vb" Inherits="IntranetPortal.ConstructionPlansTab" %>
<div>
    <div class="">
        
        <h4 class="ss_form_title">Electrical</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Title
                    </th>
                    <th>Initial Drawing</th>
                    <th>Revised</th>
                    <th>Examiner</th>
                    <th>Examination Date</th>
                    <th>DOB Approved</th>


                </tr>
            </thead>
            <tr ng-repeat="o in [{'text':'Architectural','val':'Architectural'},{'text':'Structural',val:'Structural'},{'text':'Mechanical','val':'Mechanical'},{text:'Demo',val:'Demo'},{text:'Shoring & Underpinning',val:'ShoringUnderpinning'},{text:'Foundation',val:'Foundation'},{text:'Design',val:'Design'}]  track by $index">
                <td>{{o.text}}</td>
                <td>
                    <button class="btn" type="button">Upload</button>

                </td>
                <td>
                    <button class="btn" type="button">Upload</button>

                </td>
                <td>
                    <input type="text" class="form-control" ng-model="CSCase.CSCase.Plans[o.val+'Examiner']">
                </td>
                <td>
                    <input class=" form-control" ss-date ng-model="CSCase.CSCase.Plans[o.val+'ExaminationDate']">
                </td>
                <td>
                    <input class="btn" type="file">
                </td>
            </tr>

        </table>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">PW1</label>
                <input class="btn" type="file">
            </li>

        </ul>
    </div>
</div>
