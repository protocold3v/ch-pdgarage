Ptc = {}

Ptc.Framework = 'qb' --- esx or qb
Ptc.ProgressBar = true -- true or false (progressbar quand tu sort le vehicule)
Ptc.ProgressType = 'bar' -- bar or circle
Ptc.CleVehicule = false -- false or true

Ptc.VehSpawnCoords = vector4(449.1787, -981.3781, 25.6998, 72.6402) --- position spawn vehicule

function keyusingget(plate)
    exports['mono_garage']:ClientInventoryKeys(plate, 'add')
end

function clevehremove(plate)
    exports['mono_garage']:ClientInventoryKeys(plate, 'remove')
end

Ptc.GarageMenu = { 
    {name = 'police', label = 'Police', platename = 'CHAPO'}, 
    {name = 'police2', label = 'Police 2', platename = 'POLICE'},
    {name = 'sultan', label = 'Sultan', platename = 'POLICE'},
}

Ptc.ConfigPdGarage = {
    [1] = { 
        TargetZone = {
			ped = {
				label = 'Ouvrir le garage',
				icon = 'fas fa-square-parking',
				model = 's_m_y_cop_01',
                coords = vector4(460.0473, -986.4806, 25.6998, 101.5342),
                grade = 0,
			}
        }
    },
}
