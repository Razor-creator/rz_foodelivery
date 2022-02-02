Yo!

Glad for at du gad at downloade denne opkaldsliste...

Først og fremmest vil jeg sige, at jeg har taget udgangspunkt i DevoNetworks gcphone.. så opsætningen til Devos gcphone er derfor her.

Jeg har også lavet, at hvis du f.eks. ikke bruger en gcphone på din server, kan du slå den fra i config filen.. ved Config.UseGcPhone

Opsætning til gcphone:

Find dette event i gcphone -> server -> addons.lua

RegisterServerEvent('service:startCall')
AddEventHandler('service:startCall', function (number, message, coords)
end)

Erstat det derefter med dette:

RegisterServerEvent('service:startCall')
AddEventHandler('service:startCall', function (number, message, coords)
    local source = source
    local user_id = vRP.getUserId({source})
    if number == "Politi-Job" then
        vRP.getUserIdentity({user_id, function(identity)
            TriggerEvent('opkaldsliste:sendcall', source, user_id, message, identity.phone, coords.x, coords.y, coords.z)
        end})
    end
end)

(Jeg har taget udgangspunkt i at opkaldslisten er koblet til politiet.. derfor har jeg ikke lavet en til lægerne, mekanikerne eller andet.. kommer måske i fremtiden.)

Jeg har virkelig sørget for, at opkaldslisten er let at konfigurere ift. brugere som måske ikke har den bredeste viden ift. udvikling. Derfor kan du tjekke config filen ud, hvor du stort set kan finde alt.

For at opsætte den 100%, skal du også smide database filen ind i din database.. da jeg har lavet opkaldslisten database sided.. så efter genstart, vil opkaldene stadig være der.

Du skal importere database filen, og derefter er du good to go... 

HUSK at hvis du vælger at være så dum, at du simpelthen skifter navnet på filen.. skal du naturligvis også skifte det i js filen..

Hvis du ønsker logs, er der naturligvis også lavet det.. tjek config filen "Config.Webhook"

<3 - Værsgo