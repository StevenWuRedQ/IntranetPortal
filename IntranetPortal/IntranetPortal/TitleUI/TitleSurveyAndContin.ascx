<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSurveyAndContin.ascx.vb" Inherits="IntranetPortal.TitleSurveyAndContin" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">CONTINS</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Title Contin</label>
            <input class="ss_form_input " ng-model="undefined.Title_Contin">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Requested</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Requested">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Received</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Received">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Tax and Water Contin</label>
            <input class="ss_form_input " ng-model="undefined.Tax_and_Water_Contin">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Requested</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Requested">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Received</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Received">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">ER Contin</label>
            <input class="ss_form_input " ng-model="undefined.ER_Contin">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Requested</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Requested">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date Received</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Date_Received">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">SURVEYS</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Survey Located</label>
            <pt-radio name="SURVEYS_SurveyLocated0" model="undefined.Survey_Located"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">New Survey Needed</label>
            <pt-radio name="SURVEYS_NewSurveyNeeded0" model="undefined.New_Survey_Needed"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Order Date</label>
            <input class="ss_form_input " ss-date ng-model="undefined.Order_Date">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Received Date</label>
            <input class="ss_form_input " ng-model="undefined.Received_Date">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Submitted to Title Company</label>
            <pt-radio name="SURVEYS_SubmittedtoTitleCompany0" model="undefined.Submitted_to_Title_Company"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Survery Reading Recevied</label>
            <pt-radio name="SURVEYS_SurveryReadingRecevied0" model="undefined.Survery_Reading_Recevied"></pt-radio>
        </li>
    </ul>
</div>
