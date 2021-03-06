package.path = "../?.lua"

local GDIWindow = require "GDIWindow"
local Stopwatch = require "StopWatch"
local GDI32 = require("GDI32")
local Functor = require("Functor")

local Animite = require("gamewindow.animite")
local bouncers = require("gamewindow.bouncers")


local sin = math.sin
local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local deg, rad = math.deg, math.rad
local RGB = GDI32.RGB;
local sw = Stopwatch();

local animites = {}


-- The routine that gets called for any
-- mouse activity messages
function mouseinteraction(msg, wparam, lparam)
	--print(string.format("Mouse: 0x%x", msg))
end

function keyboardinteraction(msg, wparam, lparam)
	print(string.format("Keyboard: 0x%x", msg))
end

function oncreated(win)
	print("Window Created")
end

local tickCount = 0;

function ontick(win)
	tickCount = tickCount + 1;
--print("ONTICK")
	
	local winctxt = win.GDIContext

	local bbfr = win:getBackBuffer()
	local ctxt, err = bbfr:getDeviceContext();
	--local ctxt = winctxt;

	-- Make sure we're using DC Brush and pen to start
	ctxt:UseDCBrush(true);
	ctxt:UseDCPen(true);
	
	local sangle = ceil(abs(sin(rad(tickCount % 360)))*255)
	--print(sangle)
	ctxt:SetDCBrushColor(RGB(sangle,sangle,sangle))
	ctxt:Rectangle(0,0,win.Width-1, win.Height-1)

	-- draw each bouncer
	local millis = sw:Milliseconds();
	for name, mite in pairs(animites) do
		mite(ctxt, millis);
	end

	local stats = string.format("Seconds: %f  Frame: %d  FPS: %f", sw:Seconds(), tickCount, tickCount/sw:Seconds())
	ctxt:Text(stats)


	-- blit the backbuffer to the window's context
	local nXDest = 0;
	local nYDest = 0;
	local nHeight = win.Height;
	local nWidth = win.Width;
	local hdcSrc = ctxt.Handle
	local nXSrc = 0;
	local nYSrc = 0;

	winctxt:BitBlt(nXDest, nYDest, nWidth, nHeight, hdcSrc, nXSrc, nYSrc, dwRop)
end


function onquit(win)
	print("ON QUIT!")
	
	return true;
end




local win = GDIWindow({
		Title = "Bouncers",
		--KeyboardInteractor = keyboardinteraction,
		--MouseInteractor = mouseinteraction,
		OnTickDelegate = ontick,
		OnQuitDelegate = onquit,
		Extent = {1024,768},
		})



-- create some bouncers
for i=1,5000 do
	animites[tostring(i)] = bouncers.bouncer({Left=0, Top=20, Width = win.Width, Height = win.Height-20})
end


--Task:setMessageQuanta(0)
periodic(Functor(ontick,win), 1000/30)
win:run()

