local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network 	= modules.load("network")
local utilities = modules.load("utilities")

local util = {}
util.network = network

local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local ui = playerGui.gameUI.loreBook

local onPage = 1
local currentPages = {}

local textContent = ui.bookHolder.pages.lore.info.textcontent

function module.init(Modules)

	local function updatePage()

		if currentPages[onPage] and currentPages[onPage].text then
			textContent.Text = currentPages[onPage].text
			if onPage >= #currentPages then
				onPage = #currentPages -- to be sure
				ui.bookHolder.pages.lore.next.Visible = false
			else
				ui.bookHolder.pages.lore.next.Visible = true
			end

			if onPage <= 1 then
				onPage = 1
				ui.bookHolder.pages.lore.prev.Visible = false
			else
				ui.bookHolder.pages.lore.prev.Visible = true
			end
			ui.bookHolder.pages.lore.title.Text = "Page "..onPage

			if currentPages[onPage].openFunc then
				currentPages[onPage].openFunc(util)
			end
			return true
		end
		return false
	end

	local function createBook(pages, color)
		ui.bookCover.ImageColor3 = color or Color3.fromRGB(38, 42, 58)
		currentPages = pages
		onPage = 1
		local success = updatePage()
		if success then
			module.open()
		end
		return true
	end


	local function main()

		network:create("openLoreBookFromClient", "BindableFunction")
		network:connect("openLoreBookFromClient", "OnInvoke", createBook)


		network:connect("openLoreBookFromServer", "OnClientEvent", createBook)



		ui.bookHolder.pages.lore.next.MouseButton1Click:connect(function()
			if onPage < #currentPages then
				onPage = onPage + 1
				updatePage()
			end
		end)

		ui.bookHolder.pages.lore.prev.MouseButton1Click:connect(function()
			if onPage > 1 then
				onPage = onPage - 1
				updatePage()
			end
		end)

		ui.close.MouseButton1Click:connect(function()
			if ui.Visible then
				Modules.focus.toggle(ui)
			end

		end)
	end

	function module.open()
		if not ui.Visible then
			ui.UIScale.Scale = (Modules.input.menuScale + .15 or 1.25) --* 0.75
		--	Modules.tween(ui.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end
		Modules.focus.toggle(ui)

	end

	main()

end





return module