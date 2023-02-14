class Vector
    attr_accessor :x
    attr_accessor :y
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
    def distance_to(vector2)
        (self - vector2).magnitude
    end
    def clone
        Vector.new(@x, @y)
    end
end

class PhysicsObject
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
    def tick!(time_interval)
        move!(time_interval)
    end
    def apply_force!(force_vector, time_interval = 0.1)
        if @mass != 0
            accel = force_vector / @mass
        end
        @vel += accel * time_interval
    end
end
class GravityObject < PhysicsObject
    @@gravity_objects = []
    def initialize(args)
        
        super(args)
        @floor = args[:floor] || 800
        @width = args[:width] || 1500
        @@gravity_objects << self
    end
    def move!(time_interval = 0.1)
        if calc_next_pos.y > @floor || calc_next_pos.y < 0
            @vel.y *= -0.8
        end
        if calc_next_pos.x < 0 || calc_next_pos.x > width
            @vel.x *= -0.8
        end
        super(time_interval)
    end
    def apply_gravity!(grav_vector=Vector.new(0,1), time_interval = 0.1)
        @vel += grav_vector * time_interval
    end
    def delete_self
        @@gravity_objects.delete(self)
    end
    def self.apply_gravity_to_everything(grav_vector=Vector.new(0,1), time_interval = 0.1)
        for obj in @@gravity_objects
            obj.apply_gravity!(grav_vector, time_interval)
        end
    end
    def calc_next_pos
        @pos + @vel
    end
end