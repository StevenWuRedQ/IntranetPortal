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
            <tr ng-repeat="o in [{text:'Architectural',val:'Architectural'},{text:'Structural',val:'Structural'},{text:'Mechanical','val':'Mechanical'},{text:'Demo',val:'Demo'},{text:'Shoring & Underpinning',val:'ShoringUnderpinning'},{text:'Foundation',val:'Foundation'},{text:'Design',val:'Design'}, {text:'Sprinkler', val: 'Sprinkler'}]  track by $index">
                <td>{{o.text}}</td>
                <td>
                    <pt-file file-bble="CSCase.BBLE" file-id="Plans_{{o.val+'_InitialDrawing'}}" file-model="CSCase.CSCase.Plans[o.val+'_InitialDrawing']"></pt-file>
                </td>
                <td>
                    <pt-file file-bble="CSCase.BBLE" file-id="Plans_{{o.val+'_Revised'}}" file-model="CSCase.CSCase.Plans[o.val+'_Revised']"></pt-file>
                </td>
                <td>
                    <input type="text" class="form-control" ng-model="CSCase.CSCase.Plans[o.val+'Examiner']">
                </td>
                <td>
                    <input class=" form-control" ss-date ng-model="CSCase.CSCase.Plans[o.val+'ExaminationDate']">
                </td>
                <td>
                    <pt-file file-bble="CSCase.BBLE" file-id="Plans_{{o.val+'_DOBApproved'}}" file-model="CSCase.CSCase.Plans[o.val+'_DOBApproved']"></pt-file>
                </td>
            </tr>

        </table>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">PW1</label>
                <pt-file file-bble="CSCase.BBLE" file-id="Plans_PW1" file-model="CSCase.CSCase.Plans.PW1"></pt-file>
            </li>

        </ul>
    </div>
</div>
