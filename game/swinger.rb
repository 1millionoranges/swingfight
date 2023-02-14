require './physics.rb'
class Swinger < GravityObject
    
    def initialize(args)
        super(args)
        @rope_speed = args[:rope_speed] || 6
        @level = args[:level]
        @ropes = []
    end
    def throw_rope(target)
        direction = (target - self.pos).normalize * @rope_speed
        rope_end = GravityObject.new(pos: self.pos.clone, vel: direction)
        r = DynamicRope.new(rope_end: rope_end, parent: self, level: @level)
        r.draw_init
        @ropes << r
    end
    
    def remove_rope(rope)
        @ropes.delete(rope)
    end
    def remove_all_ropes
        while @ropes.size > 0
            r = @ropes[0]
            r.remove_self
        end
    end
    def tick!(keys_pressed, time_interval=0.1)
        if keys_pressed.include?('space')
            pull(2)
        end
        super(time_interval)
        for r in @ropes do
            r.tick!(time_interval)
        end
    end
    def draw_init
        @shape = Circle.new(x: @pos.x, y: @pos.y, radius: 10, color: 'red')
        for r in @ropes do
            r.draw_init
        end
    end
    def draw_frame
        @shape.x = @pos.x
        @shape.y = @pos.y
        for r in @ropes do
            r.draw_frame
        end
    end
    def pull(strength)
        for r in @ropes
            r.pull(strength)
        end

    end
end