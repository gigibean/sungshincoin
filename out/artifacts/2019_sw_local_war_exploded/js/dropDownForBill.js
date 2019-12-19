$("#dropdownText").on("click", function () {
        $(this).hide();
        $("#dropupText").show();

    var rule = CSSRulePlugin.getRule("#agreeText"); //get the rule
    TweenLite.to(rule, 1, {cssRule:{height: 200px;}});
})

