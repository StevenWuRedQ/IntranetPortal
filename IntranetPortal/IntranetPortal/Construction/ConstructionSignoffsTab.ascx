<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionSignoffsTab.ascx.vb" Inherits="IntranetPortal.ConstructionSignoffsTab" %>
<div class="animate-show">
    <div>
        <h4 class="ss_form_title">Plumbing</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Permit is Issued</label>
                <input class="ss_form_input" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Schedule B</label>
                <button class="btn" type="button">Upload</button>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">PW2</label>
                <button class="btn" type="button">Upload</button>
            </li>

            <li class="ss_form_item" style="width: 97%; height: auto">
                <label class="ss_form_input_title">Inspection</label>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Inspection</th>
                            <th>Date</th>
                            <th>Remider me</th>
                            <th>Passed Inspection</th>
                        </tr>
                    </thead>
                    <tr>
                        <td>Roughing</td>
                        <td>
                            <input ss_date class="form-control"></td>
                        <td>
                            <button class="btn" type="button">Remider me</button></td>
                        <td>

                            <select class="form-control">
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Gas Test</td>
                        <td>
                            <input ss_date class="form-control"></td>
                        <td>
                            <button class="btn" type="button">Remider me</button></td>
                        <td>

                            <select class="form-control">
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Hydrant Flow test</td>
                        <td>
                            <input ss_date class="form-control"></td>
                        <td>
                            <button class="btn" type="button">Remider me</button></td>
                        <td>

                            <select class="form-control">
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>RPZ test</td>
                        <td>
                            <input ss_date class="form-control"></td>
                        <td>
                            <button class="btn" type="button">Remider me</button></td>
                        <td>

                            <select class="form-control">
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </li>
            <li class="ss_form_item">

                <label class="ss_form_input_title">OP98</label>
                <button class="btn" ng-click='UploadTest?UploadTest=null:UploadTest="123image"' type="button">Upload</button>
            </li>



            <li class="ss_form_item" ng-show="UploadTest!=null">
                <label class="ss_form_input_title">Objections POP</label>
                <button class="btn" type="button">Upload</button>
            </li>


            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">PAA <i class="fa icon_btn text-primary" ng-class="PAAcollapse?'fa-compress':'fa-expand'" ng-click="PAAcollapse=!PAAcollapse"></i></label>
                <button class="btn" type="button" ng-click="PAAcollapse=true">Upload</button>
            </li>
            <li class="ss_form_item" style="width: 97%,height:auto" ng-show="PAAcollapse">
                <div class="arrow_box">
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item">
                            <label class="ss_form_input_title">date fee paid</label>
                            <input class="ss_form_input" ss-date>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Date Approval</label>
                            <input class="ss_form_input" ss-date>
                        </li>
                    </ul>

                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">LAA</label>
                <button class="btn" type="button">Upload</button>
            </li>
        </ul>

    </div>
</div>
