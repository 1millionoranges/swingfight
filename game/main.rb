require 'ruby2d'
require './physics.rb'
require './level.rb'

set title: "Spaceship thing"
set height: 800
set width: 1500

level = Level.new('args')
piece = Piece.new(pos: Vector.new(200,200), size: 30)
level.add_piece(piece)
level.draw_init
update do
    level.draw_frame
end
show