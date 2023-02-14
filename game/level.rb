class Piece
    attr_reader :size
    def initialize(args)
        @size = args[:size] || 0
        @pos = args[:pos] || 0
    end
    def contains_point(point)
        @pos.distance_to(point) < @size
    end
    def collides_with(other_piece)
        @pos.distance_to(other_piece.pos) < @size + other_piece.size
    end
    def draw_init
        Circle.new(x: @pos.x, y: @pos.y, radius: @size, color: 'blue')
    end
    def draw_frame

    end
end
class Level

    def initialize(args)
        @pieces = []
    end
    def add_piece(piece)
        @pieces << piece
    end
    def draw_init
        for piece in @pieces
            piece.draw_init
        end
    end
    def draw_frame
        for piece in @pieces
            piece.draw_frame
        end

    end
    def point_collides?(point)
        for piece in @pieces
            return true if piece.contains_point(point)
        end
        return false
    end
end