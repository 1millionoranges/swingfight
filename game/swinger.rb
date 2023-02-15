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
        @shape = Image.new('../char_back_t.png', width: 160, height: 160)
        @shape2 = Image.new('../char_back_backwards_t.png', width: 160, height: 160)
        @shape3 = Image.new('../char_for.png', width: 160, height: 160)
        @shape4 = Image.new('../char_for_back.png', width: 160, height: 160)
        @swinging_forward = true
        for r in @ropes do
            r.draw_init
        end
    end
    def swing_back
        if @swinging_forward
            if @vel.x > 0
                @vel.x += Math.sin(@rotate)
                @vel.y += Math.cos(@rotate)
            else
                @vel.x -= Math.sin(@rotate)
                @vel.y -= Math.cos(@rotate)
            end
            @swinging_forward = false
        end        
    end
    def swing_forward
        if !@swinging_forward
            if @vel.x <= 0
                @vel.x += Math.sin(@rotate)
                @vel.y += Math.cos(@rotate)
            else
                @vel.x -= Math.sin(@rotate)
                @vel.y -= Math.cos(@rotate)
            end
            @swinging_forward = true
        end 
    end
    def drop_rope_and_pull
        while @ropes.size > 0
            r = @ropes[0]
            r.pull(10)
            r.remove_self
        end
    end
    def draw_frame
        if @ropes.size == 0
            if @rotate > @vel.get_angle
                @rotate -= 0.03
            elsif @rotate < @vel.get_angle
                @rotate += 0.03
            end
            @swinging_forward = false
        end
        for r in @ropes do
            @rotate = r.direction.get_angle

            
           

            r.draw_frame
        end
        upside_down = !(@ropes.size == 0) && (@rotate < -Math::PI || @rotate >= 0)
        if @swinging_forward
            @shape.x = -500
            @shape2.x = -500
            
            if @vel.x < 0 &&  !upside_down || (upside_down && @vel.x > 0)
                @shape4.x = @pos.x - 80

                @shape4.y = @pos.y - 80
                @shape3.x = -200
                @shape3.y = -200
                @shape4.rotate = 90 + @rotate * (180 / Math::PI)
            else
                @shape3.x = @pos.x - 80
                @shape3.y = @pos.y - 80
                @shape3.rotate = 90 + @rotate * (180 / Math::PI)
                @shape4.x = -200
                @shape4.y = -200
            end
        else
            @shape3.x = -500
            @shape4.x = -500
            if @vel.x < 0 &&  !upside_down || (upside_down && @vel.x > 0)
                @shape2.x = @pos.x - 80
                @shape2.y = @pos.y - 80
                @shape.x = -200
                @shape.y = -200
                @shape2.rotate = 90 + @rotate * (180 / Math::PI)
            else
                @shape.x = @pos.x - 80
                @shape.y = @pos.y - 80
                @shape.rotate = 90 + @rotate * (180 / Math::PI)
                @shape2.x = -200
                @shape2.y = -200
            end
       
        end
    end
    def pull(strength)
        for r in @ropes
            r.pull(strength)
        end

    end
end