var div_menu = document.getElementById("menu");

var link1 = document.createElement('a');
var link1_text = document.createTextNode("Czerwony");
link1.href = '#'
link1.appendChild(link1_text);
link1.addEventListener("click",function () {change_color('red')});
div_menu.appendChild(link1);

var link2 = document.createElement('a');
var link2_text = document.createTextNode("Czarny");
link2.href = '#'
link2.appendChild(link2_text);
link2.addEventListener("click",function () {change_color('black')});
div_menu.appendChild(link2);

var link3 = document.createElement('a');
var link3_text = document.createTextNode("Brązowy");
link3.href = '#'
link3.appendChild(link3_text);
link3.addEventListener("click",function () {change_color('brown')});
div_menu.appendChild(link3);

function change_color(color) {
    div_menu.style.borderColor = color;
};

