class Rope
    def initialize(args)
        @rope_end = args[:rope_end]
        @level = args[:level]
        @length = args[:length] || 600
        @stuck = false
        @strength = args[:strength] || 9000
        parent = args[:parent] || nil
        if parent
            @parent = parent
        else
            @rope_start = args[:rope_start]
        end
    end
    def current_length
        @rope_end.pos.distance_to(@parent.pos)
    end
    def direction
        (@rope_end.pos - @parent.pos).normalize
    end
    def draw_init
        @shape = Line.new(x1: @rope_end.pos.x, y1: @rope_end.pos.y, x2: @parent.pos.x, y2: @parent.pos.y, width: 3, color: 'white')
    end
    def tick!(time_interval = 0.1)
        if !@stuck
            @rope_end.tick!(time_interval)
            check_stuck?
        else
            apply_tension
        end
        
        check_length

    end
    def draw_frame
        @level.transform(@rope_end.pos) do |newpos|
            @shape.x1 = newpos.x
            @shape.y1 = newpos.y
        end
        @level.transform(@parent.pos) do |newpos|
            @shape.x2 = newpos.x
            @shape.y2 = newpos.y
        end
        stretched = (current_length.to_f / @length.to_f)
        @shape.color = [stretched, 1-stretched,1-stretched,1]
    end
    def check_stuck?
        if @level.point_collides?(@rope_end.pos)
            @stuck = true
            @rope_end = PhysicsObject.new(pos: @rope_end.pos.clone)
        end
    end
    def check_length
        if !@stuck
            if @rope_end.pos.distance_to(@parent.pos) > @length
                @shape.width = 0
                @parent.remove_rope(self)
            end
        end
    end
    def pull(strength)
        if @stuck
            dir = (@rope_end.pos - @parent.pos).normalize
            @parent.apply_force!(dir * strength)
        end
    end
    def apply_tension    
        count = 0
        while @parent.calc_next_pos.distance_to(@rope_end.pos) > @length
            pull(0.1)
            count += 1
            if count > @strength
                remove_self
                break
            end
        end
    end
    def remove_self
        @shape.width = 0
        @parent.remove_rope(self)
    end
end


class DynamicRope < Rope

    def check_stuck?
        if @level.point_collides?(@rope_end.pos)
            @stuck = true
            @rope_end = PhysicsObject.new(pos: @rope_end.pos.clone)
            @length = @rope_end.pos.distance_to(@parent.pos)
        end
    end
end



class StretchyRope < DynamicRope
    def initialize(args)
        super(args)
        @elasticity = args[:elasticity] || 3
    end


    def apply_tension
        stretched = current_length / @length
        if stretched > 1
            pull((stretched * @elasticity))
        end
        count = 0
        while @parent.calc_next_pos.distance_to(@rope_end.pos) > @length
            pull(0.1)
            count += 1
            if count > 100
                break
            end
        end        
    end
end