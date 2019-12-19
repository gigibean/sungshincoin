$(".textlogin").on('propertychange change keyup paste input', function() {
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1
        });
    }
    else {
        $(this).css({
            opacity: 0.4
        });
    }
});

$("#psswdlogin").on('propertychange change keyup paste input', function() {
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
    }
});

$("#idsignup").on('propertychange change keyup paste input', function() {
    $(".back").css({
        opacity: 1,
    });
    if ($(this).val().length != 0) {

        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});

$("#psswdsignup").on('propertychange change keyup paste input', function() {
    $(".back").css({
        opacity: 1,
    });
    // Do this when value changes
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});

$("#namesignup").on('propertychange change keyup paste input', function() {
    // Do this when value changes
    $(".back").css({
        opacity: 1,
    });
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});

$("#emailsignup").on('propertychange change keyup paste input', function() {
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});

$("#phonesignup").on('propertychange change keyup paste input', function() {
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});

$("#psswdcheck").on('propertychange change keyup paste input', function() {
    if ($(this).val().length != 0) {
        $(this).css({
            opacity: 1,
        });
        $(".next").css({
            opacity: 1,
        });
    }
    else {
        $(this).css({
            opacity: 0.4,
        });
        $(".next").css({
            opacity: 0.4,
        });
    }
});


(function ($) {
    var originalVal = $.fn.val;
    $.fn.val = function (value) {
        var res = originalVal.apply(this, arguments);

        if (this.is('input:text') && arguments.length >= 1) {
            // this is input type=text setter
            this.trigger("input");
        }

        return res;
    };
})(jQuery);
