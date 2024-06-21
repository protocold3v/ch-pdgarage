local carOut = false

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
         TargetPdGarag()
    end
 end)
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then 
    end
end)

function PtcPdCreatePed(pedModel, pedCoords)
    local pedModel = joaat(pedModel) 
    local pedCoords = pedCoords 
    lib.requestModel(pedModel, 5000) 
    local peds = CreatePed(0, pedModel, pedCoords.x, pedCoords.y, pedCoords.z -1, pedCoords.w, false, false)
    while not DoesEntityExist(peds) do Wait(50) end 
    SetBlockingOfNonTemporaryEvents(peds, true) TaskStartScenarioInPlace(peds, "WORLD_HUMAN_CLIPBOARD", 0, false) FreezeEntityPosition(peds, true) SetEntityInvincible(peds, true)
    return peds
end 

function TargetPdGarag()
    for k, v in pairs(Ptc.ConfigPdGarage) do  
        local configped = Ptc.ConfigPdGarage[k]
        ped = PtcPdCreatePed(configped.TargetZone.ped.model, configped.TargetZone.ped.coords)
        exports['ox_target']:addModel(v.TargetZone.ped.model, {
            name = 'ptc',
            label = v.TargetZone.ped.label,
            icon = v.TargetZone.ped.icon,
            groups = { ['police'] = v.TargetZone.ped.grade },
            distance = 2.5,
            onSelect = function()
                lib.showContext('ptc_menu_garade')
            end
        })
    end
end

garagemenu = {}

for k,v in ipairs(Ptc.GarageMenu) do
    table.insert(garagemenu, {
        title = v.label,
        onSelect = function()
            if not carOut then
                if not IsModelInCdimage(v.name) then return end
                RequestModel(v.name) 
                while not HasModelLoaded(v.name) do 
                  Wait(0)
                end
                currentCar = CreateVehicle(v.name, Ptc.VehSpawnCoords, false, false) 
                SetVehicleNumberPlateText(currentCar, v.platename)
                SetPedIntoVehicle(PlayerPedId(),currentCar,-1)  
                carOut = true
                lib.notify({
                    title = 'Véhicule Sortie !',
                    description = 'Votre véhicule de service est sortie',
                    type = 'success'
                })
                if Ptc.Framework == 'qb' then    
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(currentCar)) 
                end
                if Ptc.CleVehicule then
                    local plate = GetVehicleNumberPlateText(currentCar)
                    keyusingget(plate)
                end
            else
                lib.notify({
                    title = 'Véhicule déja sortie !',
                    description = 'Un véhicule est déja sortie ranger le avant de sortire un autre !',
                    type = 'error'
                })
            end
        end
    })
end

lib.registerContext({
    id = 'ptc_menu_garade',
    title = 'Garage Police', 
    options = {
        {
            title = 'Sortir un véhicule',
            icon = 'right-from-bracket',
            onSelect = function()
                lib.showContext('ptc_menu_garade_car')
            end
        },
        {
            title = 'Ranger un véhicule',
            icon = 'square-parking',
            onSelect = function()
                DeleteVehicle(currentCar)
                lib.notify({
                    title = 'Véhicule ranger !',
                    description = 'Votre véhicule de service est ranger',
                    type = 'success'
                })
                carOut = false
            end
        },
        {
            title = 'Signaler disparaition',
            description = 'signaler un véhicule disparu !',
            icon = 'bell',
            onSelect = function()
                lib.notify({
                    title = 'Véhicule signalé !',
                    description = 'Vous avez signaler la dispairation de votre véhicule !',
                    type = 'success'
                })
                DeleteVehicle(currentCar)
                carOut = false
            end,
        },
    }
}) 

lib.registerContext({
    id = 'ptc_menu_garade_car',
    title = 'Garage Police', 
    menu = 'menu2',
    onBack = function()
        lib.showContext('ptc_menu_garade')
    end,
    options = garagemenu
}) 
