/*    =====================================
                   loader
     ====================================== */

$(window).on("load", function () {
    "use strict";
    setTimeout(function () {
        $(".loader").fadeOut(800);
    }, 1000);

});

jQuery(function ($) {
    "use strict";
    /*===================================
                   fixed navbar
    ======================================*/

    $(window).on('scroll', function () {
        if ($(this).scrollTop() > 80) {
            $('header').addClass('fixed-top');
            $('header').addClass('fix-top');
        } else {
            $('header').removeClass('fixed-top');
            $('header').removeClass('fix-top');
        }
    });

    /* =====================================
                    speaker  carousel
        ====================================== */

    $('#app-slider').owlCarousel({

        loop: true,
        margin: 0,
        slideSpeed: 5000,
        slideTransition: 'linear',
        nav: false,
        dots: false,
        autoplay: true,
        autoplayTimeout: 8000,
        autoplayHoverPause: true,
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 1
            },
            1000: {
                items: 1
            },
            1500: {
                items: 1
            },
        }

    });

    $('.app-clips-slider').owlCarousel({

        loop: true,
        margin: 20,
        slideSpeed: 5000,
        slideTransition: 'linear',
        nav: false,
        dots: false,
        autoplay: true,
        autoplayTimeout: 8000,
        autoplayHoverPause: true,
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 2
            },
            1000: {
                items: 4
            },
            1500: {
                items: 4
            },
        }

    });


    /* =====================================
                      Parallaxie js
        ====================================== */

    if ($(window).width() < 780) {

        $('.get-app-sec').addClass("parallax-disable");

    } else {
        $('.get-app-sec').removeClass("parallax-disable");

        // parallax
        $('.get-app-sec').parallaxie({
            speed: 0.5,
            offset: -50,
        });

    }

    /* =====================================
          Broad nav
     ====================================== */

    $(".toggle-btn").on("click", function () {
        $("header .broad").addClass('broad-nav');
    });
    $(".close-nav").on("click", function () {
        $("header .broad").addClass('broad-rem');
        setTimeout(function () {
            $("header .broad").removeClass('broad-nav');
            $("header .broad").removeClass('broad-rem');
        }, 500);
    });
    $(".broad .nav-link").on("click", function () {
        $("header .broad").addClass('broad-rem');
        setTimeout(function () {
            $("header .broad").removeClass('broad-nav');
            $("header .broad").removeClass('broad-rem');
        }, 500);
    });

    /*************************************/
    /*********  wow animation ***********/
    /**************************************/

    var wow = new WOW(
        {
            boxClass: 'wow',      // default
            animateClass: 'animated', // default
            offset: 0,          // default
            mobile: false,       // default
            live: true        // default
        }
    );
    wow.init();

});
