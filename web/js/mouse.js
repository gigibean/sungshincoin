var $circle = $('.mouse-circle');

function moveCircle(e) {
    TweenLite.to($circle, 0.3, {
        css: {
            x: e.clientX,
            y: e.clientY
        }
    });
}

$(window).on('mousemove', moveCircle);