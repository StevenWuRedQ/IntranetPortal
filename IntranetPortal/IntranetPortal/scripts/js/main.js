function mip() {
    if (window.devicePixelRatio > 1) {
        $('.go-retina').each(function (i) {
            var lowres = $(this).attr('src');
            var highres = lowres.replace('.', '@2x.');
            $(this).attr('src', highres);
        });
    }

    function submenu_height_reset() {
        var max_submenu_height = $(window).height() - $('#global-nav .navbar-header').outerHeight() - ($('#main-nav .nav .category').outerHeight() * $('#main-nav .nav .category').length) - $('#global-footer').outerHeight() - 10;
        $('#main-nav .nav .nav-level-2-container').each(function () {
            if ($(this).outerHeight() > (max_submenu_height + 10)) {
                $(this).addClass('tall-submenu');
                $(this).css({ 'max-height': max_submenu_height + 'px', 'padding-bottom': '10px' });
                $(this).mCustomScrollbar({
                    theme: "minimal-dark"
                });
            }
        });
    }

    submenu_height_reset();

    $(window).on('debouncedresize', function (event) {
        var max_submenu_height = $(window).height() - $('#global-nav .navbar-header').outerHeight() - ($('#main-nav .nav .category').outerHeight() * $('#main-nav .nav .category').length) - $('#global-footer').outerHeight() - 10;
        $('.tall-submenu').each(function () {
            $(this).css({ 'max-height': max_submenu_height + 'px' });
            $(this).children('.mCustomScrollBox').css({ 'max-height': max_submenu_height + 'px' });
        });
    });

    $('#main-nav .nav .nav-level-2-container:not(#main-nav .nav .current + .nav-level-2-container), #main-nav .nav .nav-level-3').hide();

    $('#main-nav .nav .category').click(function () {
        var current_category = $(this);
        if (!$(this).hasClass('current')) {
            $('#main-nav .nav .category').removeClass('current');
            $(this).addClass('current');
            if ($('#main-nav .nav .nav-level-2-container').is(':visible')) {
                $('#main-nav .nav .nav-level-2-container:visible').slideUp('slow', 'easeOutCirc', function () {
                    current_category.next('.nav-level-2-container').slideDown('slow', 'easeOutCirc');
                });
            } else {
                current_category.next('.nav-level-2-container').slideDown('slow', 'easeOutCirc');
            }
        } else {
            current_category.next('.nav-level-2-container').slideToggle('slow', 'easeOutCirc');
        }
        return false;
    });

    $('#main-nav .nav .nav-level-2 .has-level-3-menu').click(function () {
        var current_menu_item = $(this);
        var target_menu = $(this).next('.nav-level-3');
        target_menu.slideToggle('slow', 'easeOutCirc', function () {
            if (target_menu.is(':visible')) current_menu_item.find('.fa-caret-right').removeClass('fa-caret-right').addClass('fa-caret-down');
            else current_menu_item.find('.fa-caret-down').removeClass('fa-caret-down').addClass('fa-caret-right');
        });
        return false;
    });

    $('.landing').hide();

    // FORM HANDLING

    $('div.landing').append('<div class="form-validation-message"><i class="fa fa-exclamation-circle fa-lg"></i> Authentication failed, please check your username and password.</div>');

    var form_options = {
        
        success: afterloginsubmission
    }
    $('#portal-sign-in-form').ajaxForm(form_options);

   
    



    $(window).load(function () {
        $('#landing-loader').fadeOut('slow', function () {
            setTimeout(function () {
                $('.landing').show();
                $('#username').focus();

                $('.landing-bg').backstretch([
					  '/images/img/landing_bg/1.jpg'
					, '/images/img/landing_bg/2.jpg'
					, '/images/img/landing_bg/3.jpg'
					, '/images/img/landing_bg/4.jpg'
					, '/images/img/landing_bg/5.jpg'
                ], { duration: 2000, fade: 4000 });
            }, 0);
        });
        
    });
}

function afterloginsubmission() {
   
    $('.form-validation-message').animate({ "top": "0" }, 500, 'easeOutCirc');
    $(':input').focus(function () {
        if ($('.form-validation-message').is(':visible')) $('.form-validation-message').animate({ "top": "-80px" }, 500, 'easeOutCirc');
    });
}

$(document).ready(mip);
