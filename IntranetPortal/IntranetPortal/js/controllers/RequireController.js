
if (typeof requirejs === "function")
{
    
    define(['angular'], function (angular) {
        function RequireController() {
            alert("set up sucessfully !");
        }

        return RequireController
    });
}

