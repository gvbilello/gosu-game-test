require 'gosu'

require 'pry'
require 'byebug'


def media_path(file)
	File.join(File.dirname(File.dirname(__FILE__)), 'media', file)
end

class Sprite

	FRAME_DELAY = 120
	SPRITE = media_path('characters.png')
	TILE_WIDTH = 32
	GRAVITY = 0.5

	def load_animation(window)
    Gosu::Image.load_tiles(window, SPRITE, 32, 32, false)
  end

	def initialize(window)
		@window = window
		@animation = load_animation(@window)
		@x_position = @window.height / 2
		@y_position = @window.height - (TILE_WIDTH * 2)
		@x_velocity = 0
		@y_velocity = 0
		@on_ground = true
		@direction = :right
		@current_frame = 23
	end

	def move_left
		if @window.button_down?(Gosu::KbLeft) && @x_position > (TILE_WIDTH * 2)
			if @direction == :right
				@direction = :left
				@x_position = @x_position + TILE_WIDTH
			elsif @direction == :left
				@x_position -= 5
			end
		end
	end

	def move_right
		if @window.button_down?(Gosu::KbRight) && @x_position < (@window.width - TILE_WIDTH * 2)
			if @direction == :left
				@direction = :right
				@x_position = @x_position - TILE_WIDTH
			elsif @direction == :right
				@x_position += 5
			end
		end
	end

	def jump
		if @window.button_down?(Gosu::KbUp)
			if @on_ground
				@y_velocity = -12.0
				@on_ground = false
			end

			if @y_velocity < -6.0
				@y_velocity = -6.0
			end

			if @y_position ==	@window.height - (TILE_WIDTH * 2)
				@on_ground = true
			end

			@y_velocity += GRAVITY
			@y_position += @y_velocity
			@x_position += @x_velocity
		end
	end

	def update
		# idle jump animation
		jump

		move_left
		move_right

		@current_frame += 1 if frame_expired?

		if @current_frame == 25
			@current_frame = 23
		end

	end

	def draw
		if @direction == :left
			@animation[@current_frame].draw(@x_position, @y_position, 1, -1)
		elsif @direction == :right
			@animation[@current_frame].draw(@x_position, @y_position, 1)
		end
	end

	private

	def current_frame
		@animation[@current_frame]
	end

	def frame_expired?
		now = Gosu.milliseconds
		@last_frame ||= now
		if (now - @last_frame) > FRAME_DELAY
			@last_frame = now
		end
	end

end

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
  	# binding.pry
  	@sprite.update
  end

  def draw
  	@background_image.draw(0, 0, 0)
  	@sprite.draw
  end

end

window = GameWindow.new
window.show