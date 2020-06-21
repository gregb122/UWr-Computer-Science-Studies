var main_square = document.getElementById("center_square")
var square_array = document.getElementsByClassName("square")
var timer = document.getElementById("time_counter")
var score_text = document.getElementById("scores")
var best_scores = document.getElementById("best_scores")
var ul_best_scores = document.getElementById("ul_highscores")
var countdown;
var timer_enabled = true;
var main_square_visited = true;
var score = 0;
var visited_square_count = 0;
var highscores = []
var seconds;
var minutes;

load_game();

/////GAME MANAGER FUNCTIONS/////
function load_game()
{
    //add event listener for main square
    main_square.addEventListener("mouseover",function () {timer_enabled = false; main_square_visited = true;} )
    main_square.addEventListener("mouseout",function () {timer_enabled = true;} )
        //and for small squares
    for (let i = 0; i< square_array.length; i++)
    {
        square_array[i].style.backgroundColor = "blue";
        square_array[i].addEventListener("mouseover", function () { square_selected(i)});
    }

    initialize_new_game();
}

function initialize_new_game()
{
    timer_init();
    score_text.innerHTML = "Your score: " + score;
    //set position for each square in randomly in sectors
    random_position(square_array[0], 150, 0, 100, 0);
    random_position(square_array[1], 300, 200, 100, 0);
    random_position(square_array[2], 500, 400, 100, 0);
    random_position(square_array[3], 750, 600, 100 , 0);
    random_position(square_array[4], 100, 0, 400, 200);
    random_position(square_array[5], 300, 200, 400, 300);
    random_position(square_array[6], 500, 400, 500, 400);
    random_position(square_array[7], 700, 600, 400, 300);
    for (let i = 0; i< square_array.length; i++)
    {
        square_array[i].style.backgroundColor = "blue";
    }
        
}

function finish_game()
{
    var list_elem = document.createElement("li");
    list_elem_text = document.createTextNode("Czas: " + minutes + "m " + seconds + "s; Wynik: " + score)
    list_elem.appendChild(list_elem_text);
    ul_best_scores.appendChild(list_elem);
    timer_enabled = true;
    main_square_visited = true;
    score = 0;
    visited_square_count = 0;
    timer_clear();
    initialize_new_game()
}



/////GAME LOGIC FUNCTIONS////////
function random_position(square, max_left, min_left, max_top, min_top)
{        
    square.style.position = "absolute"
    square.style.left = Math.floor((Math.random() * (max_left-min_left+1) )+ min_left) + 'px'
    square.style.top = Math.floor((Math.random() * (max_top-min_top+1) )+ min_top) + 'px'
}



function square_selected(i)
{
    if(main_square_visited)
    {
        if (square_array[i].style.backgroundColor == "red") {
            score -= 5;
        }
        else {  
            score += 10;
            visited_square_count ++;
        }
        square_array[i].style.backgroundColor = "red";
        main_square_visited = false;
        score_text.innerHTML = "Your score: " + score;
    }
    else
    {
        if (square_array[i].style.backgroundColor == "red") {
            score -= 5;
            score_text.innerHTML = "Your score: " + score;
        }
    }
    //when all squares was visited, win game
    if (visited_square_count == square_array.length)
        finish_game()
}


//////TIMING COUNTER FUNCTIONS////////
function timer_init() {
    seconds = 0;
    minutes = 0;
    timer_trigger();
}

function timer_trigger() {

        if (timer_enabled)
            seconds++;
        if (seconds >= 60)
        {
            seconds = 0;
            minutes++;
        }
        if (minutes >= 60)
            timer_clear()
        timer.innerHTML = "Your time: " + minutes + "m" + ":" + seconds + "s";
        countdown = setTimeout('timer_trigger()', 1000);
        
    
}

function timer_clear() {
    clearTimeout(countdown);
}