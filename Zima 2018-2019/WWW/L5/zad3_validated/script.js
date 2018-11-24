var picture = document.getElementsByClassName("pic_square");

initialize();

function initialize() {
    picture[0].style.left = "100px";
    picture[0].style.transform =  "rotate(45deg)";
    picture[0].style.top = "200px";

    picture[1].style.left = "200px";
    picture[1].style.transform = "rotate(30deg)";
    picture[1].style.top = "150px";

    picture[2].style.left = "580px";
    picture[2].style.transform = "rotate(60deg)";
    picture[2].style.top = "400px";

    picture[3].style.left = "350px";
    picture[3].style.transform = "rotate(80deg)";
    picture[3].style.top = "400px"

    picture[4].style.left = "620px";
    picture[4].style.transform = "rotate(170deg)";
    picture[4].style.top = "40px";

    picture[5].style.left = "350px";
    picture[5].style.transform = "rotate(170deg)";
    picture[5].style.top = "200px";
}


function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    ev.target.appendChild(document.getElementById(data));
}