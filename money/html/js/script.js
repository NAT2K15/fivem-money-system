let cash = undefined;
let bank = undefined;
$(() => {

    window.addEventListener('message', function(event) {
        if (event.data.action = "update_money") {
            cash = event.data.amount
            bank = event.data.bank
                // console.log(bank, cash)
            updateeverything()
        }
    })
})

function updateeverything() {
    $('.money').html('');
    $(".money").append(`<img style="position: relative; top: 9.0px;" width="45px" height="45px" src="img/logo.png" /><a >&nbsp;$${cash.toLocaleString()}</a>`)
    $('.bank').html('');
    $(".bank").append(`<img style="position: relative; top: 9.0px;" width="45px" height="45px" src="img/bank.png" /><a >&nbsp;$${bank.toLocaleString()}</a>`)
}