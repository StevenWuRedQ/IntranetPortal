<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="IntranetPortal.WebForm1" %>

<!DOCTYPE html>
<html ng-app="myApp">
<head>
    <title>Add a Widget - Angular Approach</title>
    <meta charset="utf-8" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <![endif]-->
    <!--[if gte IE 9]><!-->
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <!--<![endif]-->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.16/angular.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.16/angular-sanitize.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/globalize/0.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="http://cdn3.devexpress.com/jslib/15.1.6/js/dx.webappjs.js"></script>
    <script type="text/javascript" src="script.js"></script>
    <link rel="stylesheet" type="text/css" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.common.css" />
    <link rel="stylesheet" type="text/css" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.light.css" />
    <link rel="stylesheet" type="text/css" href="styles.css" />
</head>
<body>
    <button onclick='angular.element(document.getElementById("contorller")).scope().popupVisible=true'>Test javascript</button>
    <div id='contorller' ng-controller="demoController">

        <button value="test" ng-click='test.popupVisible=true'>test</button>
        <div dx-popup="{
        fullScreen: true,
        bindingOptions: {
            visible:'popupVisible'
        }
    }">
            <div data-options="dxTemplate:{ name: 'title' }">
                <h1>{{popupTitle}}</h1>
                <div dx-check-box="{
                text: 'Show &quot;Hide popup&quot; button',
                bindingOptions: { 
                    value: 'buttonVisible'
                }
            }">
                </div>
            </div>
            <div data-options="dxTemplate:{ name: 'content' }">
                <p>The popup content.</p>
            </div>
        </div>
    </div>
</body>
</html>
