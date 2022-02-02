$(function(){
    function display (bool) {
        if(bool){
            $("body").show()
            $("container").show()
            $("#details").hide()
        } else {
            $("body").hide()
            $("container").hide()
            $("#details").hide()
        }
    }
    display(false)
    window.addEventListener("message", function(event) {
        const item = event.data;
        if(item.type === "ordre"){
            if(item.status){
                display(true)
                $('#table').empty();
                $('#name').text("Byens Pizza")
                $("#details").hide()
                for (const [key, value] of Object.entries(event.data.ordre)) {
                    var table = document.getElementById("table");
                    var row = table.insertRow(0);
                    var cell1 = row.insertCell(0);
                    var cell2 = row.insertCell(1);
                    cell1.innerHTML = '<p> Leveres til: ' + value.firstname + ' ' + value.lastname + '</p>';
                    cell2.innerHTML = '<button class="ordre2" id="ordre2' + value.callid + '">Ordre Oplysninger</button>';
                }
                
            } else {
                display(false)
            }
        }
        if(item.type === "details"){
            for (const [key, details] of Object.entries(event.data.details)) {
                $("body").show()
                $("container").show()
                $("#details").show()
                $('.details').html(
                '<div class="details-info-box"><span id="info-label">Leveres til: </span><span class="details-info-js">'+details.firstname+' '+details.lastname+'</span></div>' +
                '<div class="details-info-box"><span id="info-label">Vej: </span><span class="details-info-js">'+details.street+'</span></div>' +
                '<div class="details-info-box"><span id="info-label">Pizzaer: </span><span class="details-info-js">'+details.pizza+'</span></div>' +
                '<div class="details-info-box"><span id="info-label">Kebab: </span><span class="details-info-js">'+details.kebab+'</span></div>' +
                '<div class="details-info-box"><span id="info-label">Drikkevarer: </span><span class="details-info-js">'+details.drinks+'</span></div>' +
                '<div class="details-info-box"><span id="info-label">Ordrenummer: </span><span class="details-info-js">'+details.callid+'</span></div>' +
                '<button class="info-button" id="info-button' + details.callid + '">Tag Levering</button>' +
                '<button onclick="closeDetails()" class="info-button2" id="info-button2">Afbryd</button>');
            }
        }
    
    })
        
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post("http://rz_fooddelivery/exit", JSON.stringify({}));
        }
    }

    $('#table').on('click', '.ordre2', function () {
		var index = $(this).attr('id');
        index = index.replace("ordre2", "")
        $.post("http://rz_fooddelivery/detaljer", JSON.stringify({
            callid: index
        }))
        return;
    });
    $('#details').on('click', '.info-button', function () {
		var index = $(this).attr('id');
        index = index.replace("info-button", "")
        CloseImg()
        closeDetails()
        $.post("http://rz_fooddelivery/gps", JSON.stringify({
            callid: index
        }))
        return;
    });
})

function CloseImg(){
    $("body").hide()
    $("container").hide()
    closeDetails()
    $.post("http://rz_fooddelivery/exit", JSON.stringify({}));
};  

function sendGPS(){
    var index = $(this).attr('id');
        index = index.replace("info-button", "")
        CloseImg()
        $.post("http://rz_fooddelivery/gps", JSON.stringify({
            callid: index
        }))
    return;
}

function closeDetails(){
    $("body").show()
    $("container").show()
    $("#details").hide()
}




