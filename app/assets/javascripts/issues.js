// main JS runner

$(function() {
    $(".tbody").append("content");
});


function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    var interval_id = setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.textContent = minutes + ":" + seconds + " seconds remaining, ";

        if (--timer < 0) {
            display.textContent = "";
        }
    }, 1000);
};