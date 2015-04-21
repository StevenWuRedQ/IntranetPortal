function mip() {
	$('.featured-agents-desc').hide();
	var fa_link_target_status = 0;
	$('.featured-agents-list-item-link').click(function() {
		fa_link_target_status ++;
		if (fa_link_target_status > 1) return false;
		var fa_this_link = $(this);
		var fa_link_target = fa_this_link.attr('href');
		if ($('.featured-agents-desc').is(':visible') && $('.featured-agents-desc:visible').attr('id') != fa_link_target.substr(1) ) {
			$('.featured-agents-desc:visible').slideUp("slow", function() {
				$('.falil-current').removeClass('falil-current');
				$(fa_link_target).slideDown("slow", function() {
					fa_this_link.addClass('falil-current');
					fa_link_target_status = 0;
				});
			});
		} else {
			$(fa_link_target).slideToggle("slow", function() {
				if ($(fa_link_target).is(':visible')) fa_this_link.addClass('falil-current');
				else fa_this_link.removeClass('falil-current');
				fa_link_target_status = 0;
			});
		}
		return false;
	});



    var faWidth = 0;
    var faID = 0;
    $('li.featured-agents-list-item').each(function() {
        faWidth += $(this).outerWidth( true );
        faID++;
        $(this).children('a').attr('id', 'featured-agent-' + faID);
    });
    $('ul.featured-agents-list').css({
        'width' : faWidth
    });

    $('li.featured-agents-list-item:first').before($('li.featured-agents-list-item:last'));

    $('.featured-agents-nav.fan-left').bind('click', faPrevious);
    $('.featured-agents-nav.fan-right').bind('click', faNext);

    function faPrevious() {
        $('.featured-agents-nav.fan-left').unbind('click');
        $('.featured-agents-nav.fan-left').click(function() {
            return false;
        });
        var item_width = $('li.featured-agents-list-item:first').outerWidth();
        var left_indent = parseInt($('ul.featured-agents-list').css('left')) + item_width;
        $('ul.featured-agents-list').animate({
            'left' : left_indent
        }, {
            queue: false,
            duration: 200,
            complete: function() {
                $('li.featured-agents-list-item:first').before($('li.featured-agents-list-item:last'));
                $('ul.featured-agents-list').css({
                    'left' : '-140px'
                });
                $('.featured-agents-nav.fan-left').bind('click', faPrevious);
            }
        });
        return false;
    }
    function faNext() {
        $('.featured-agents-nav.fan-right').unbind('click');
        $('.featured-agents-nav.fan-right').click(function() {
            return false;
        });
        var item_width = $('li.featured-agents-list-item:first').outerWidth();
        var left_indent = parseInt($('ul.featured-agents-list').css('left')) - item_width;
        $('ul.featured-agents-list').animate({
            'left' : left_indent
        }, {
            queue: false,
            duration: 200,
            complete: function() {
                $('li.featured-agents-list-item:last').after($('li.featured-agents-list-item:first'));
                $('ul.featured-agents-list').css({
                    'left' : '-140px'
                });
                $('.featured-agents-nav.fan-right').bind('click', faNext);
            }
        });
        return false;
    }

}
$(document).ready(mip);