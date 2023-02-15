class Piece
    attr_reader :size
    attr_accessor :level
    def initialize(args)
        @size = args[:size] || 0
        @pos = args[:pos] || 0
        @level = args[:level] || nil

        @imageurl = args[:imageurl] || '../gargoyle.png'
        case @imageurl
        when "gargoyle"
            @imageurl = "../gargoyle.png"
        when "cloud"
            @imageurl = "../cloud.png"
        when "plane"
            @imageurl = "../airplane.png"
        end

    end
    def contains_point(point)
        @pos.distance_to(point) < @size
    end
    def collides_with(other_piece)
        @pos.distance_to(other_piece.pos) < @size + other_piece.size
    end
    def draw_init
        @image = Image.new(@imageurl, x: @pos.x - @size, y: @pos.y - @size, width: @size * 2, height: @size * 2)
  #      Circle.new(x: @pos.x, y: @pos.y, radius: @size, color: 'blue')
    end
    def draw_frame
        @level.transform(@pos - Vector.new(@size, @size)) do |newpos|
            @image.x = newpos.x
            @image.y = newpos.y
        end
    end
end
class Level
    

    def initialize(args)
        @image1 = Image.new('../cityforeground.png', z: -100)
        @backgroundimage1 = Image.new('../citybackground.png', z: -101)
        @backgroundimage2 = Image.new('../citybackground.png', z: -101)
        @pieces = []
        @screenpos = Vector.new(0,0)
        @margin = 400
        @width = 1500
        @height = 800
    end
    def add_piece(piece)
        @pieces << piece
        piece.level = self
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
        @image1.x = -@screenpos.x
        @image1.y = -@screenpos.y
        @backgroundimage1.x = -@screenpos.x / 3
        @backgroundimage2.x = -@screenpos.x / 3 + 4500

        @backgroundimage1.y = -@screenpos.y
        @backgroundimage2.y = -@screenpos.y
    end
    def point_collides?(point)
        for piece in @pieces
            return true if piece.contains_point(point)
        end
        return false
    end
    def transform(vector)
        new_vector = vector - @screenpos
        yield(new_vector)
    end
    def reverse_transform(vector)
        new_vector = vector + @screenpos
        yield(new_vector)
    end
    def move_screenpos(vector)
        @screenpos.x += vector.x
        @screenpos.y += vector.y
    end


    def keep_in_focus(vector)
        if vector.x > @screenpos.x + @width - @margin
            @screenpos.x = vector.x - @width + @margin
        end

        if vector.y > @screenpos.y + @height - @margin
            @screenpos.y = vector.y - @height + @margin
        end
        if vector.x < @screenpos.x + @margin
            @screenpos.x = vector.x - @margin
        end
        if vector.y < @screenpos.y + @margin
            @screenpos.y = vector.y - @margin
        end
    end
end