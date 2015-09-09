<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSurveyAndContin.ascx.vb" Inherits="IntranetPortal.TitleSurveyAndContin" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">CONTINS</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Title Contin</label>
               <%--  <input class="ss_form_input " ng-model="FormData.surveyAndContin.Title_Contin"> --%>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Requested</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.Title_Date_Requested">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Received</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.Title_Date_Received">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Tax and Water Contin</label>
               <%-- <input class="ss_form_input " ng-model="FormData.surveyAndContin.Tax_and_Water_Contin">  --%>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Requested</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.Tax_and_Water_Date_Requested">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Received</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.Tax_and_Water_Date_Received">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">ER Contin</label>
              <%--  <input class="ss_form_input " ng-model="FormData.surveyAndContin.ER_Contin"> --%>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Requested</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.ER_Date_Requested">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date Received</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.ER_Date_Received">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">SURVEYS</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Survey Located</label>
                <pt-radio name="Survey_Located" model="FormData.surveyAndContin.Survey_Located"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">New Survey Needed</label>
                <pt-radio name="New_Survey_Needed" model="FormData.surveyAndContin.New_Survey_Needed"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Order Date</label>
                <input class="ss_form_input " ss-date ng-model="FormData.surveyAndContin.Survey_Order_Date">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Received Date</label>
                <input class="ss_form_input " ng-model="FormData.surveyAndContin.Survey_Received_Date">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Submitted to Title Company</label>
                <pt-radio name="Submitted_to_Title_Company" model="FormData.surveyAndContin.Submitted_to_Title_Company"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Survery Reading Recevied</label>
                <pt-radio name="Survery_Reading_Recevied" model="FormData.surveyAndContin.Survery_Reading_Recevied"></pt-radio>
            </li>
        </ul>
    </div>
</div>
