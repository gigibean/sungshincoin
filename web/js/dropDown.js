$("#dropdownImg").on("click", function() {
    
    $(this).hide();
    $("#dropupImg").show();

    // t1 = new TimelineMax();
    // t1.to($(".sidebar-brand-drop"), 1, {opacity:0 , ease:Expo.easeInOut});
    // // t1.to($(".sidebar-brand-drop"), 1, {opacity:1 , ease:Expo.easeInOut});
    // t1.from($(".sidebar-brand-drop"), 2 , {css: {
    //     display: none , ease:Expo.easeInOut}
    // }, "-=2");
    $(".sidebar-brand-drop").show();


    
});

$("#dropupImg").on("click", function() {
    // $(".sidebar-brand-drop").hide();
    $(this).hide();
    $("#dropdownImg").show();
    $(".sidebar-brand-drop").hide();

});