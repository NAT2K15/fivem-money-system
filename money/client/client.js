// http://cdn.nat2k15.xyz/img/FiveM_GTAProcess_3Cbocn7D2w.png \\ 

let stuff = []
let start = false


setTick(() => {
    Delay(0)
    if (start) {
        draw()
    }
})

RegisterNetEvent('NAT2K15:UPDATECLIENTMONEY')
on('NAT2K15:UPDATECLIENTMONEY', (coolarray) => {
    stuff = coolarray
    if (stuff) {
        start = true
    }
})


RegisterNetEvent('NAT2K15:UPDATEPAYCHECK')
on('NAT2K15:UPDATEPAYCHECK', (id, moneyarray) => {
    stuff = moneyarray
    if (stuff) {
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName("You have received your daily pay check. Amount: $" + stuff.cycle.toLocaleString())
        EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Daily Pay Check")
        EndTextCommandThefeedPostTicker(true, false)
    }

})

RegisterNetEvent('NAT2K15:UPDATEPAY')
on('NAT2K15:UPDATEPAY', (id, money) => {
    stuff = money
})


RegisterNetEvent('NAT2K15:BANKNOTIFY')
on('NAT2K15:BANKNOTIFY', (msg) => {
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Account Notification")
    EndTextCommandThefeedPostTicker(true, false)
})


function draw() {
    if (stuff) {
        SetTextFont(4)
        SetTextScale(0.44, 0.44)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(`Cash: ~c~${stuff.amount.toLocaleString()} ~s~| Bank: ~c~${stuff.bank.toLocaleString()}`)
        DrawText(0.16, 0.845)
    }
}

function Delay(ms) { //Use this function instead of Wait()
    return new Promise((res) => {
        setTimeout(res, ms)
    })
}

exports('getclientaccount', (id) => {
    if (id) {
        if (stuff) {
            return stuff
        } else {
            return false
        }
    } else {
        return false
    }
})
