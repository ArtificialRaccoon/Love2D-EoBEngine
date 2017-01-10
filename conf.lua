function love.conf(t)
	t.author = "Bernard Walker"
	t.title = "Engine Prototype v0.1"
	t.window.width = 1024/1 --256
	t.window.height = 576/1 --144
	t.window.highdpi = true
	t.window.vsync = false
	t.window.fullscreen = false
	t.modules.joystick = false
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = false
	t.console = true
	t.identity = 'myGame'
end