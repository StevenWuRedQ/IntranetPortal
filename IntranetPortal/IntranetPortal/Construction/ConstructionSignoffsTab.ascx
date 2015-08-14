<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionSignoffsTab.ascx.vb" Inherits="IntranetPortal.ConstructionSignoffsTab" %>
<div class="animate-show">
    <div>
        <h4 class="ss_form_title">Plumbing</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Permit is Issued</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
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
            <li class="ss_form_item" style="width: 97%; height: auto" ng-show="PAAcollapse">
                <div class="arrow_box">

                    <div class="ss_form">
                        <ul class="ss_form_box clearfix">


                            <li class="ss_form_item">
                                <label class="ss_form_input_title">date fee paid</label>
                                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
                            </li>
                            <li class="ss_form_item">
                                <label class="ss_form_input_title">Date Approval</label>
                                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
                            </li>
                        </ul>
                    </div>

                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">LAA</label>
                <button class="btn" type="button">Upload</button>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Plumbing job signed off date</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>

        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">notes</label>
                <textarea class="edit_text_area text_area_ss_form"></textarea>
            </li>

        </ul>
    </div>


    <div class="ss_form" style="margin-top: 70px">
        <h4 class="ss_form_title title_after_notes">Electrical</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Permit was pulled</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">PW2</label>
                <button class="btn" type="button">Upload</button>
            </li>
            <li class="ss_form_item" style="visibility: hidden">
                <label class="ss_form_input_title"></label>
                <input class="ss_form_input">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Inspection date requested</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">date of inspection</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">results</label>
                <select class="ss_form_input">
                    <option></option>
                    <option>Passed</option>
                    <option>Failed</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Completetion fee</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount due</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date paid</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title ss_warning">date electric signed of</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
        </ul>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form"></textarea>
            </li>

        </ul>
    </div>
    <div class="ss_form " style="margin-top: 70px">
        <h4 class="ss_form_title title_after_notes">Construction</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Permit was pulled</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">PW2</label>
                <button class="btn" type="button">Upload</button>
            </li>
            <li class="ss_form_item" style="visibility: hidden">
                <label class="ss_form_input_title"></label>
                <input class="ss_form_input">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">date inspection was requested</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">inspection date</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Objecteions</label>
                <button class="btn" type="button">Upload</button>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Constaction report</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">construction job jigned off date</label>
                <input class="ss_form_input" ss-date ng-model="CSCase.FakeDate">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form"></textarea>
            </li>

        </ul>

    </div>
</div>
