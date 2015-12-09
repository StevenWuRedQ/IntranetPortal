@Code
    ViewBag.Title = "ConfirmAccount"
End Code

<h2>@ViewBag.Title.</h2>
<div>
    <p>
        Thank you for confirming your account. Please @Html.ActionLink("click here to log in", "Login", "Account", routeValues:=Nothing, htmlAttributes:=New With {Key .id = "loginLink"})
    </p>
</div>
