var $nav_slider = $('#nav_slider').slider({
    max: 5,
    min: 1,
    value: 3 //set initialization value on 3
});

var slideshow;
var count_img = $('img').length;
var num_img;
var current_img;
var current_nav_slider_val = $('#nav_slider').slider("option", "value") ;

initializeSlideShow();

function initializeSlideShow() {
    num_img = 1;
    current_img = $('img').first();
    current_img.fadeIn(250);
    startSlideShow();
}

function startSlideShow() {
    slideshow = setInterval(function(){
        // checking for any changes of nav_slider value
        if (current_nav_slider_val != $('#nav_slider').slider("option", "value")) {
            current_nav_slider_val = $('#nav_slider').slider("option", "value");
            updateSlideShow();
        }
        if (num_img < count_img) {
            current_img.fadeOut(250);
            current_img = current_img.next();
            current_img.delay(300).fadeIn(250);
            num_img++;
        }
        else {
            current_img.fadeOut(250);
            current_img = $('img').first();
            current_img.delay(300).fadeIn(250);
            num_img = 1;
        }
    },current_nav_slider_val * 1000);
}

//pause SlideShow
function pauseSlideShow() {
    clearInterval(slideshow);
}

//update SlideShow when nav_slider value was changed
function updateSlideShow() {
    pauseSlideShow();
    startSlideShow();
}

//add events 
$('#slider').on("mouseenter",pauseSlideShow);
$('#slider').on("mouseleave",startSlideShow);