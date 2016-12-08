require 'gosu'

class Sprite

	def initialize(window)
		@window = window
		@sprite = Gosu::Image.new(@window, "characters.png")
		@x = @window.width / 2
		@y = @window.height - 66
		@direction = :right
	end

	def update
		if @window.button_down?(Gosu::KbLeft)
			@direction = :left
			@x -= 5
		elsif @window.button_down?(Gosu::KbRight)
			@direction = :right
			@x += 5
		end
	end

	def draw
		@sprite.draw(@x, @y, 1, -1)
	end

end

class GameWindow < Gosu::Window

  def initialize(width = 640, height = 640, fullscreen = false)
    super
    self.caption = "zZzZzZz"
    @background_image = Gosu::Image.new("town-dungeon.png", :tileable => true)
    @sprite = Sprite.new(self)
  end

  def button_down(id)
  	close if id == Gosu::KbEscape
  end

  def update
  	@sprite.update
  end

  def draw
  	@background_image.draw(0, 0, 0)
  	@sprite.draw
  end

end

window = GameWindow.new
window.show