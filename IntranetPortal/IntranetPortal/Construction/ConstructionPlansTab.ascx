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
            <tr ng-repeat="o in ['Architectural','Structural','Mechanical','Demo','Shoring & Underpinning','Foundation','Design']  track by $index">
                <td>{{o}}</td>
                <td>
                    <button class="btn" type="button">Upload</button>

                </td>
                <td>
                    <button class="btn" type="button">Upload</button>

                </td>
                <td>
                    <input type="text" class="form-control">
                </td>
                <td>
                    <input class=" form-control" ss-date ng-model="CSCase.FakeDate">
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
