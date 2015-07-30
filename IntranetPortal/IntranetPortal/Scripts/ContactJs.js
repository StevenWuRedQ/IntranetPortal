
$.fn.accordion = function (options) {
    var settings = $.extend({
        autoCollapse: false
    }, options);

    var
      $accordion = $(this),
      blockName = $accordion.attr('data-block'),
      $items = $('.' + blockName + '__item', $accordion);

    $accordion.delegate('.' + blockName + '__title', 'click', triggerAccordion);

    function triggerAccordion() {
        var
          $that = $(this),
          $parent = $that.parent(),
          $content = $parent.children('.' + blockName + '__content'),
          isOpen = $that.hasClass('js-accordion--open'),
          autoCollapse = true,
          contentHeight = $content.prop('scrollHeight');

        if (isOpen) {
            $that.removeClass('js-accordion--open');
            $parent.removeClass('js-accordion--open');
            $content.css('height', contentHeight);
            setTimeout(function () {
                $content.removeClass('js-accordion--open').css('height', '');
            }, 4);
        } else {
            if (settings.autoCollapse) {
                //auto collapse open accordions
            }
            $that.addClass('js-accordion--open');
            $parent.addClass('js-accordion--open');
            $content.addClass('js-accordion--open').css('height', contentHeight).one('webkitTransitionEnd', event, function () {
                if (event.propertyName === 'height') {
                    $(this).css('height', '');
                }
            });
        }
    }
};

$(document).ready(function () {
    $('.js-sidebar').accordion();

});
