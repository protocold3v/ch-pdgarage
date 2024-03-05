AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
         TargetPdGarag()
    end
 end)
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then 
    end
end)

function ChapoPdCreatePed(pedModel, pedCoords)
    local pedModel = joaat(pedModel) 
    local pedCoords = pedCoords 
    lib.requestModel(pedModel, 5000) 
    local peds = CreatePed(0, pedModel, pedCoords.x, pedCoords.y, pedCoords.z -1, pedCoords.w, false, false)
    while not DoesEntityExist(peds) do Wait(50) end 
    SetBlockingOfNonTemporaryEvents(peds, true) TaskStartScenarioInPlace(peds, "WORLD_HUMAN_CLIPBOARD", 0, false) FreezeEntityPosition(peds, true) SetEntityInvincible(peds, true)
    return peds
end 

function TargetPdGarag()
    for k, v in pairs(Chapo.ConfigPdGarage) do  
        local configped = Chapo.ConfigPdGarage[k]
        ped = ChapoPdCreatePed(configped.TargetZone.ped.model, configped.TargetZone.ped.coords)
        exports['ox_target']:addModel(v.TargetZone.ped.model, {
            name = 'chapoleplusbeau',
            label = v.TargetZone.ped.label,
            icon = v.TargetZone.ped.icon,
            groups = { ['police'] = v.TargetZone.ped.grade },
            distance = 2.5,
            onSelect = function()
                lib.showContext('chpd_menu_garade')
            end
        })
    end
end

garagemenu = {}

for k,v in ipairs(Chapo.GarageMenu) do
    table.insert(garagemenu, {
        title = v.label,
        onSelect = function()
            if not IsModelInCdimage(v.name) then return end
            RequestModel(v.name) 
            while not HasModelLoaded(v.name) do 
              Wait(0)
            end
            currentCar = CreateVehicle(v.name, Chapo.VehSpawnCoords, false, false) 
            SetVehicleNumberPlateText(currentCar, v.platename)
            SetPedIntoVehicle(PlayerPedId(),currentCar,-1)  
            lib.notify({
                title = 'Véhicule Sortie !',
                description = 'Votre véhicule de service est sortie',
                type = 'success'
            })
            if Chapo.Framework == 'qb' then    
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(currentCar)) 
            end
            if Chapo.CleVehicule then
                local plate = GetVehicleNumberPlateText(currentCar)
                keyusingget(plate)
            end
        end
    })
end

lib.registerContext({
    id = 'chpd_menu_garade',
    title = 'Garage Police', 
    options = {
        {
            title = 'Sortir un véhicule',
            onSelect = function()
                lib.showContext('chpd_menu_garade_car')
            end
        },
        {
            title = 'Ranger un véhicule',
            onSelect = function()
                DeleteVehicle(currentCar)
                lib.notify({
                    title = 'Véhicule ranger !',
                    description = 'Votre véhicule de service est ranger',
                    type = 'success'
                })
            end
        },
    }
}) 

lib.registerContext({
    id = 'chpd_menu_garade_car',
    title = 'Garage Police', 
    menu = 'menu2',
    onBack = function()
        lib.showContext('chpd_menu_garade')
    end,
    options = garagemenu
}) 
