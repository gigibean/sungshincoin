document.addEventListener("DOMContentLoaded", function(event) {
    function cloudFront() {
        var tl = new TimelineMax({
            repeat: -1
        });

        tl.to("#cloud-front", 52, {
            backgroundPosition: "2199px 0px",
            force3D:true,
            rotation:0.01,
            z:0.01,
            autoRound:false,
            ease: Linear.easeNone
        });

        return tl;
    }

    var masterTL = new TimelineMax({
        repeat: -1
    });

// window load event makes sure image is
// loaded before running animation
    window.onload = function() {
        masterTL
            .add(cloudFront(),0)
            .timeScale(0.7)
            .progress(1).progress(0)
            .play();

    };

});