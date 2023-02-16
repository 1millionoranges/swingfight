require 'ruby2d'
require './physics.rb'
require './level.rb'
require './swinger.rb'
require './rope.rb'
require './screen.rb'
set title: "Spaceship thing"
set height: 800
set width: 1500

level = Level.new('args')
piece = Piece.new(pos: Vector.new(200,200), size: 30)
piece2 = Piece.new(pos: Vector.new(1000,200), size: 30)
piece3 = Piece.new(pos: Vector.new(200,500), size: 30)
piece4 = Piece.new(pos: Vector.new(1000,500), size: 30)

for i in (0..20) do 
    for j in (0..20) do
    piece = Piece.new(pos: Vector.new(i * 400, j * 400), size: 30, imageurl: "cloud")
    level.add_piece(piece)
    end
end
level.add_piece(piece)
level.add_piece(piece2)
level.add_piece(piece3)
level.add_piece(piece4)
level.draw_init
s = Swinger.new(pos: Vector.new(300,300), size: 10, rope_speed: 10, level: level)
s.throw_rope(Vector.new(600,600))
s.draw_init
#screen = Screen.new()
on :mouse_down do |event|
    case event.button
    when :left
        level.reverse_transform(Vector.new(event.x, event.y)) do |newpos|
            s.throw_rope(newpos)
        end
    when :right
        s.remove_all_ropes
    end
end
keys_pressed = []
on :key_down do |event|
    keys_pressed << event.key
    if event.key == "escape"
        close
    end

    case event.key
    when "a"
        s.swing_back
    when "w" 
        s.throw_rope_left(Vector.new(-2,-1))
    when "e"
        s.throw_rope_left(Vector.new(0,-1))
    when "r"
        s.throw_rope_left(Vector.new(2,-1))
    when "c"
        s.drop_left_rope
    when "u"
        s.throw_rope_right(Vector.new(-2,-1))
    when "i"
        s.throw_rope_right(Vector.new(0,-1))
    when "o"
        s.throw_rope_right(Vector.new(2,-1))
    when "n"
        s.drop_right_rope
    when "l"
        s.swing_forward
    when "d"
        s.swing_forward
    when "6"
        s.remove_all_ropes
    end
end

on :key_up do |event|
    keys_pressed.delete(event.key)
end

update do
    GravityObject.apply_gravity_to_everything
    level.draw_frame
   # screen.draw_frame
    s.draw_frame
    s.tick!(keys_pressed)
end
show