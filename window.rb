require_relative('sprite')
require_relative('test1')

class GameWindow < Gosu::Window

  def initialize(width = 640, height = 640, fullscreen = false)
    super
    self.caption = "zZzZzZz"
    @background_image = Gosu::Image.new('media/town-dungeon.png', :tileable => true)
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