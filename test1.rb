require 'gosu'

require 'pry'
require 'byebug'

def media_path(file)
	File.join(File.dirname(File.dirname(__FILE__)), 'media', file)
end

class Sprite

	FRAME_DELAY = 180
	SPRITE = media_path('character1-large.png')
	TILE_WIDTH = 32
	GRAVITY = 0.5

	def load_animation(window)
    Gosu::Image.load_tiles(window, SPRITE, 64, 64, false)
  end

	def initialize(window)
		@window = window
		@animation = load_animation(@window)
		@ground = @window.height - TILE_WIDTH * 2

		@x_position = @window.height / 2
		@y_position = @ground
		@x_velocity = 0
		@y_velocity = 0

		@on_ground = true
		@direction = :right
		@current_frame = 0
	end

	def can_move_left?
		return true if @x_position > (TILE_WIDTH) * 1.7
	end

	def can_move_right?
		return true if @x_position < (@window.width - (TILE_WIDTH * 1.7))
	end

	def platforms
	end

	def on_platform?
		if @y_position == @window.height - TILE_WIDTH * 4
			# left boxes
			if @x_position > 64 && @x_position < 96
				@on_ground = true
			# right boxes
			elsif @x_position < 576 && @x_position > 546
				@on_ground = true
			else
				@on_ground = false
			end
		end
	end

	def move_left
		if @window.button_down?(Gosu::KbLeft) && can_move_left?
			if @direction == :right
				@direction = :left
			elsif @direction == :left
				@x_position -= 4
			end
			@current_frame += 1 if frame_expired?
		end
	end

	def move_right
		if @window.button_down?(Gosu::KbRight) && can_move_right?
			if @direction == :left
				@direction = :right
			elsif @direction == :right
				@x_position += 4
			end
			@current_frame += 1 if frame_expired?
		end
	end

	def jump
		if @window.button_down?(Gosu::KbUp)
			if @on_ground
				@y_velocity = -12.0
				@on_ground = false
				if @y_velocity < -10.0
					@y_velocity = -10.0
				end
			end
			on_platform?
		end
	end

	def update
		jump
		move_left
		move_right

		if @current_frame == 3
			@current_frame = 0
		end

	end


	def draw
		on_platform?
		
		if @on_ground == false
			@y_velocity += GRAVITY
			@y_position += @y_velocity
			@x_position += @x_velocity
		end

		if @y_position >= @ground
			@y_position = @ground
			@on_ground = true
		end

		# if !on_platform?
		# 	@on_ground = false
		# end

		if @direction == :left
			@animation[@current_frame].draw_rot(@x_position, @y_position, 1, 0, 0.5, 0.5, -1)
		elsif @direction == :right
			@animation[@current_frame].draw_rot(@x_position, @y_position, 1, 0)
		end

		@info = Gosu::Image.from_text(@window, info, Gosu.default_font_name, 30)
		@info.draw(0, 0, 1)
	end

	private

	def info
		"x:#{@x_position} y:#{@y_position}"
	end

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
  	@sprite.update
  end

  def draw
  	@background_image.draw(0, 0, 0)
  	@sprite.draw
  end

end

window = GameWindow.new
window.show