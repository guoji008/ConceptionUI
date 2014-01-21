local C, D = unpack(select(2,...))

function D.LOAD.M:LoadCombatEvent()
	
	local API, FUNC = D.API, C.FUNC.UNIT
	local Frame, Icon, DropShadow, String = API.Frame, API.Icon, API.DropShadow, API.String
	local cfg = D.CFG['COMBAT_EVENT']

	local  function Finished(self)
		self.parent:Hide()
		if self.ae then
			self.ae = 0
		end
	end

	local function CreateAni_H(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.moveIni = AG:CreateAnimation('Translation')
			AG.moveIni:SetDuration(0)
			AG.moveIni:SetOrder(0)
			
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(1)
			AG.fadeIn:SetDuration(.1)
			AG.fadeIn:SetOrder(1)
			AG.moveIn = AG:CreateAnimation('Translation')
			AG.moveIn:SetSmoothing('OUT_IN')
			AG.moveIn:SetDuration(.1)
			AG.moveIn:SetOrder(1)

			AG.moveStay = AG:CreateAnimation('Translation')
			AG.moveStay:SetDuration(.4)
			AG.moveStay:SetOrder(2)

			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.1)
			AG.fadeOut:SetOrder(3)
			AG.moveOut = AG:CreateAnimation('Translation')
			AG.moveOut:SetSmoothing('OUT_IN')
			AG.moveOut:SetDuration(.1)
			AG.moveOut:SetOrder(3)
			
			AG.ae = 0
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateAni_FADE(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(1)
			AG.fadeIn:SetDuration(.2)
			AG.fadeIn:SetOrder(1)
			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetStartDelay(.5)
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.3)
			AG.fadeOut:SetOrder(2)
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateAni_Scroll(frame)
		local AG = frame:CreateAnimationGroup()
			AG.fadeIni = AG:CreateAnimation('Alpha')
			AG.fadeIni:SetChange(-1)
			AG.fadeIni:SetDuration(0)
			AG.fadeIni:SetOrder(0)
			AG.moveIni = AG:CreateAnimation('Translation')
			AG.moveIni:SetDuration(0)
			AG.moveIni:SetOrder(0)
			AG.moveIni:SetOffset(0, -100)
			AG.moveUp = AG:CreateAnimation('Translation')
			AG.moveUp:SetDuration(1.2)
			AG.moveUp:SetOffset(0, 200)
			AG.moveUp:SetOrder(1)
			AG.moveUp:SetSmoothing('IN_OUT')
			AG.fadeIn = AG:CreateAnimation('Alpha')
			AG.fadeIn:SetChange(.7)
			AG.fadeIn:SetDuration(.2)
			AG.fadeIn:SetOrder(1)
			AG.fadeOut = AG:CreateAnimation('Alpha')
			AG.fadeOut:SetStartDelay(.8)
			AG.fadeOut:SetChange(-1)
			AG.fadeOut:SetDuration(.2)
			AG.fadeOut:SetOrder(2)
			AG.parent = frame
			AG:SetScript('OnFinished', Finished)
		return AG
	end

	local function CreateDisplay(parent, align1, align2, x, y, factor, scale)
		local frame = Frame(nil, parent, align1, parent, align2, x*factor, y, 20, 20)
			frame:SetScale(scale)
			frame.icon = Icon(frame, 20, 'ARTWORK')
			frame.shadow = DropShadow(frame)
			frame.amount = String(frame, align1, frame, align2, 4*factor, 0, cfg.font, 20, cfg.fontFlag)
			frame.spellname = String(frame, align1, frame, align2, 4*factor, 0, cfg.spellname_font, 18, cfg.spellname_fontFlag)
			frame.IN = CreateAni_H(frame)
			frame.IN.moveIni:SetOffset(10*factor, 0)
			frame.IN.moveIn:SetOffset(-10*factor, 0)
			frame.IN.moveStay:SetOffset(-2*factor, 0)
			frame.IN.moveOut:SetOffset(-10*factor, 0)
			frame.OUT = CreateAni_H(frame)
			frame.OUT.moveIni:SetOffset(-10*factor, 0)
			frame.OUT.moveIn:SetOffset(10*factor, 0)
			frame.OUT.moveStay:SetOffset(2*factor, 0)
			frame.OUT.moveOut:SetOffset(10*factor, 0)
			frame:Hide()
		return frame
	end

	local function UpdateNotification(self, elapsed)
		local a, b, c, x, y = self:GetPoint()
		self:SetPoint(a, b, c, x, .1+y)
	end

	local function ResetNotification(self)
		self:SetPoint('BOTTOM', UIParent, 'CENTER', 0, self.offset)
	end

	local function CreateNotification(offset)
		local frame = Frame(nil, C)
			frame:SetSize(1,1)
			frame.offset = offset
			frame.text = String(frame, 'CENTER', frame, 'CENTER', 0, 0, cfg.spellname_font, 16, cfg.spellname_fontFlag)
			frame.FADE = CreateAni_FADE(frame)
			frame:SetScript('OnUpdate', UpdateNotification)
			frame:SetScript('OnShow', ResetNotification)
			frame:Hide()
		return frame
	end

	--[[
	local function CreateScroll(frame, i)
		local line = 'line'..i
		frame[line] = Frame(nil, C, 'CENTER', UIParent, 'CENTER', 0, 0, 16, 16)
		frame[line]:SetAlpha(0)
		frame[line].icon = Icon(frame[line], 16, 'ARTWORK')
		frame[line].shadow = DropShadow(frame[line])
		frame[line].amount = String(frame[line], 'TOP', frame[line], 'BOTTOM', 0, 0, cfg.font, cfg.fontSize-4, cfg.fontFlag, 0, 0)
		frame[line].UP = CreateAni_V(frame[line])
		frame[line]:Hide()
	end

	for i = 1, 10 do
		CreateScroll(PlayerEvent, i)
		local line = 'line'..i
		PlayerEvent[line]:ClearAllPoints()
		PlayerEvent[line]:SetPoint('RIGHT', UIParent, 'CENTER', -cfg.x-32, cfg.y)
		PlayerEvent[line].amount:ClearAllPoints()
		PlayerEvent[line].amount:SetPoint('RIGHT', PlayerEvent[line].icon, 'LEFT', -2, 0)
		CreateScroll(TargetEvent, i)
		TargetEvent[line]:ClearAllPoints()
		TargetEvent[line]:SetPoint('LEFT', UIParent, 'CENTER', cfg.x+32, cfg.y)
		TargetEvent[line].amount:ClearAllPoints()
		TargetEvent[line].amount:SetPoint('LEFT', TargetEvent[line].icon, 'RIGHT', 2, 0)
	end
	]]
	local CombatEvent = CreateFrame('Frame', 'CombatEvent', C)
		CombatEvent:RegisterEvent('PLAYER_LOGIN')
		CombatEvent:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
		CombatEvent:Hide()
		CombatEvent.EVENT_FRAMES = {}
		for i = 1, 3 do
			CombatEvent.EVENT_FRAMES['player'..i] = CreateDisplay(C.UNITFRAME.Major['player'], 'LEFT', 'RIGHT', 11*(i-1), -11, 1, 1)
			CombatEvent.EVENT_FRAMES['playersub'..i] = CreateDisplay(C.UNITFRAME.Major['player'], 'LEFT', 'RIGHT', 11*(i-1)+10, -62, 1, .8)
			CombatEvent.EVENT_FRAMES['target'..i] = CreateDisplay(C.UNITFRAME.Major['target'], 'RIGHT', 'LEFT', 11*(i-1), -11, -1, 1)
			CombatEvent.EVENT_FRAMES['targetsub'..i] = CreateDisplay(C.UNITFRAME.Major['target'], 'RIGHT', 'LEFT', 11*(i-1)+10, -62, -1, .8)
			CombatEvent.EVENT_FRAMES['focus'..i] = CreateDisplay(C.UNITFRAME.Minor['focus'], 'LEFT', 'RIGHT', 11*(i-1), -10, 1, .8)
			CombatEvent.EVENT_FRAMES['focussub'..i] = CreateDisplay(C.UNITFRAME.Minor['focus'], 'LEFT', 'RIGHT', -11*(i-1)+10, -56, 1, .8)
			CombatEvent.EVENT_FRAMES['targettarget'..i] = CreateDisplay(C.UNITFRAME.Minor['targettarget'], 'RIGHT', 'LEFT', 11*(i-1), -10, -1, .8)
			CombatEvent.EVENT_FRAMES['targettargetsub'..i] = CreateDisplay(C.UNITFRAME.Minor['targettarget'], 'RIGHT', 'LEFT', -11*(i-1)+10, -56, -1, .8)
			CombatEvent.EVENT_FRAMES['notification'..i] = CreateNotification(140-(10*i))
		end

	local GetSpellTexture = GetSpellTexture
	local function GetSpellIcon(spellID)
		return ('|T%s:0|t'):format(GetSpellTexture(spellID))
	end
	CombatEvent.GetSpellIcon = GetSpellIcon

	function CombatEvent:GetUnitChannel(unit)
		if unit:match('raid%d') then
			return CombatEvent.CHANNEL
		elseif unit:match('party%d') and CombatEvent.CHANNEL == 'PARTY' then
			return 'PARTY'
		elseif unit == 'player' and CombatEvent.CHANNEL == 'PARTY' then
			return 'PARTY'
		else
			return nil
		end
	end

	local SendChatMessage = SendChatMessage
	function CombatEvent:AddMessage(channel, text, ...)
		if not channel then return end
		SendChatMessage(text:format(...), channel, nil)
	end

	function CombatEvent:AddNotice(r, g, b, text, ...)
		--[[local current_frame, next_frame = nil, nil
		for i = 1, 3 do
			current_frame = self.EVENT_FRAMES['notification'..i]
			if current_frame:IsShown() then
				current_frame:SetFrameLevel(self:GetFrameLevel()-1)
				current_frame:SetAlpha(self:GetAlpha()*.33)
				if i ~= 3 then
					next_frame = self.EVENT_FRAMES['notification'..(1+i)]
				else
					next_frame = self.EVENT_FRAMES['notification1']
				end
			else
				break
			end
		end
		frame = next_frame or current_frame]]
		local frame = self:GetNextDisplay('notification')
		frame:Hide()
		frame['FADE']:Stop()
		frame.text:SetText(text:format(...))
		frame.text:SetTextColor(r, g, b)
		frame:SetFrameLevel(11)
		frame:SetAlpha(1)
		frame['FADE']:Play()
		frame:Show()
	end
	--[[
	local GetSpellTexture = GetSpellTexture
	local function DisplayScroll(line, icon, text, r, g, b)
		if line.UP:IsPlaying() then return end
		line.icon:SetTexture(icon)
		line.amount:SetText(text)
		line.amount:SetTextColor(r, g, b)
		line.UP:Play()
		line:Show()
	end

	function CombatEvent:AddScroll(frame, iconID, text, r, g, b)
		frame = CombatEvent[frame]
		for i = 1, 10 do
			DisplayScroll(frame['line'..i], GetSpellTexture(iconID), text, r, g, b)
		end
	end
	]]

	function CombatEvent:GetNextDisplay(unit)
		local frame, counter = nil, nil
		for i = 1, 3 do
			frame = self.EVENT_FRAMES[unit..i]
			counter = i
			if not frame:IsShown() then
				break
			else
				frame:SetFrameLevel(8+i)
				frame:SetAlpha(.33)
			end
		end
		return self.EVENT_FRAMES[unit..(counter==3 and 1 or counter)]
	end

	function CombatEvent:Display(unit, animation, iconID, spellname, amount, r, g, b)
		if not unit then return end
		local frame = self:GetNextDisplay(unit)
		frame:Hide()
		frame[animation]:Stop()
		frame.icon:SetTexture(GetSpellTexture(iconID))
		frame.spellname:SetText(spellname)
		frame.spellname:SetTextColor(r, g, b)
		frame.amount:SetText(amount)
		frame.amount:SetTextColor(r, g, b)
		frame:SetFrameLevel(11)
		frame:SetAlpha(1)
		frame[animation]:Play()
		frame:Show()
	end

	function CombatEvent:COMBAT_LOG_EVENT_UNFILTERED(timeStamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, ...)
		if (sourceGUID ~= C.UNIT['player']) and (destGUID ~= C.UNIT['player']) then return end
		self.CLEU[combatEvent](self, sourceGUID, sourceName, sourceFlags1, sourceFlags2, destGUID, destName, destFlags1, destFlags2, spellID, spellName, ...)
	end

	local collectgarbage, SetCVar = collectgarbage, SetCVar
	function CombatEvent:PLAYER_REGEN_DISABLED()
		self:UnregisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		self:AddNotice(1, 0, 0, '+ COMBAT +')
		if self.HideFriendlyNameplatesInCombat then
			SetCVar('nameplateShowFriends', 0)
		end
	end

	function CombatEvent:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:AddNotice(0, 1, 0, '- COMBAT -')
		if self.HideFriendlyNameplatesInCombat then
			SetCVar('nameplateShowFriends', 1)
		end
	end

	local UnitName, GetSpellLink = UnitName, GetSpellLink
	local ColoredName = C.FUNC.UNIT.ColoredName
	local COMMON = D.CFG.COMBAT_EVENT['common'] or {}
	function CombatEvent:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, rank, line, spellID)
		if not unit then return end
		if not COMMON[spellID] then return end
		self:AddNotice(1, 1, 1, '%s > %s%s', ColoredName(unit), GetSpellIcon(spellID), spellName)
		self:AddMessage(self:GetUnitChannel(unit), '[%s] > %s', UnitName(unit), GetSpellLink(spellID))
		return	
	end

	function CombatEvent:ITEM_PUSH(bagID, itemIcon)
		self:AddNotice(1, 1, 1, ('|T%s:0|t'):format(itemIcon))
	end

	function CombatEvent:UI_INFO_MESSAGE(...)
		self:AddNotice(1, 1, 0, ...)
	end

	local IsInGroup, IsInRaid = IsInGroup, IsInRaid
	local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
	function CombatEvent:GROUP_ROSTER_UPDATE()
		local NAMEPLATE = C.NAMEPLATE
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			self.CHANNEL = 'INSTANCE_CHAT'
			NAMEPLATE.group = 'raid%d'
		elseif IsInRaid() then
			self.CHANNEL = 'RAID'
			NAMEPLATE.group = 'raid%d'
		elseif IsInGroup() then
			self.CHANNEL = 'PARTY'
			NAMEPLATE.group = 'party%d'
		else
			self.CHANNEL = nil
			NAMEPLATE.group = false
		end
	end

	function CombatEvent:PLAYER_LOGIN()
		RAID_NOTICE_FADE_OUT_TIME = .2
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('GROUP_ROSTER_UPDATE')
		self:RegisterEvent('UI_INFO_MESSAGE')
		self:RegisterEvent('ITEM_PUSH')
		self:UnregisterEvent('PLAYER_LOGIN')
		self.HideFriendlyNameplatesInCombat = ConceptionCFG['HideFriendlyNameplatesInCombat']
		self:GROUP_ROSTER_UPDATE()
	end

	C.COMBATEVENT = CombatEvent
end