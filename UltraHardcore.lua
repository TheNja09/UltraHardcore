SavedHP = 150
Ready = 0
function _OnFrame()
    World = ReadByte(Now + 0x00)
    Room = ReadByte(Now + 0x01)
    Place = ReadShort(Now + 0x00)
    Door = ReadShort(Now + 0x02)
    Map = ReadShort(Now + 0x04)
    Btl = ReadShort(Now + 0x06)
    Evt = ReadShort(Now + 0x08)
    Cheats()
end

function _OnInit()
    if GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301 and ENGINE_TYPE == "ENGINE" then--PCSX2
        Platform = 'PS2'
        Now = 0x032BAE0 --Current Location
        Save = 0x032BB30 --Save File
        Obj0 = 0x1C94100 --00objentry.bin
        Sys3 = 0x1CCB300 --03system.bin
        Btl0 = 0x1CE5D80 --00battle.bin
        Slot1 = 0x1C6C750 --Unit Slot 1
    elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then--PC
        Platform = 'PC'
        Now = 0x0714DB8 - 0x56454E
        Save = 0x09A7070 - 0x56450E
        Obj0 = 0x2A22B90 - 0x56450E
        Sys3 = 0x2A59DB0 - 0x56450E
        Btl0 = 0x2A74840 - 0x56450E
        Slot1 = 0x2A20C58 - 0x56450E
    end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function Cheats()
	if ReadShort(Now+0) == 0x2002 and ReadShort(Now+8) == 0x01 then -- Sets your HP in the first room of rando
		WriteByte(Slot1+0x4, 150)
		WriteByte(Slot1+0x0, 150)
		Ready = 0
		SavedHP = 150
	end
	if ReadByte(Slot1+0x0) == 0 and Ready == 0 then
		Ready = 1
		SavedHP = 10
		WriteByte(Slot1+0x4, 10)
	end
	if ReadByte(Slot1+0x0) < ReadByte(Slot1+0x4) and ReadByte(Slot1+0x4) > 1 and Ready ~= 1 then
		WriteByte(Slot1+0x4, ReadByte(Slot1+0x4) - 1)
		SavedHP = ReadByte(Slot1+0x4)
		WriteByte(Slot1+0x0, SavedHP)
	end
WriteByte(0x24BC8D6, 200) -- Defense Stat 
	if Ready == 1 and ReadByte(Slot1+0x4) < 10 and ReadByte(Slot1+0x0) > 0 then
		WriteByte(Slot1+0x4, 10)
		SavedHP = ReadByte(Slot1+0x4)
		Ready = 0
	elseif Ready == 1 and ReadByte(Slot1+0x0) > 0 and ReadByte(Slot1+0x4) >= 10 then
		SavedHP = ReadByte(Slot1+0x4)
		Ready = 0
	end
end
