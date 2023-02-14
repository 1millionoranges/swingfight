class Vector
    attr_reader :x
    attr_reader :y
    def initialize(x, y)
        @x = x
        @y = y
    end
    def +(vector2)
        x = @x + vector2.x
        y = @y + vector2.y
        Vector.new(x,y)
    end
    def add!(vector2)
        @x += vector2.x
        @y += vector2.y
    end
    def -(vector2)
        x = @x - vector2.x
        y = @y - vector2.y
        Vector.new(x,y)
    end
    def /(scalar)
        Vector.new(@x / scalar, @y / scalar)
    end
    def *(scalar)
        Vector.new(@x * scalar, @y * scalar)
    end
    def minus!(vector2)
        @x -= vector2.x
        @y -= vector2.y
    end
    def magnitude
        Math.sqrt(@x**2 + @y**2)
    end
    def normalize
        mag = magnitude
        Vector.new(@x / mag, @y / mag)
    end
end

def PhysicsObject
    attr_reader :pos
    attr_reader :vel
    attr_reader :mass
    def initialize(args)
        @mass = args[:mass] || 1
        @pos = args[:pos] || Vector.new(0,0)
        @vel = args[:vel] || Vector.new(0,0)
        @gravity = args[:gravity] || 0
    end
    def move!(time_interval = 0.1)
        @pos.add!(@vel)
    end
    def apply_force(force_vector, time_interval = 0.1)
        if @mass != 0
            accel = force_vector / @mass
        end
        @vel += accel * time_interval
    end
end
