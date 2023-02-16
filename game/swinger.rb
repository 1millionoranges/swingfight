require './physics.rb'
class Swinger < GravityObject
    
    def initialize(args)
        super(args)
        @screen = args[:screen]
        @rope_speed = args[:rope_speed] || 6
        @level = args[:level]
        @ropes = []
        @maxropes = args[:maxropes] || 2

        
    end
    def throw_rope(target)
        if @ropes.size < @maxropes
            direction = (target - self.pos).normalize * @rope_speed
            rope_end = PhysicsObject.new(pos: self.pos.clone, vel: direction)
            r = StretchyRope.new(rope_end: rope_end, parent: self, level: @level)
            r.draw_init
            @ropes << r
        end
        return r
    end
    
    def remove_rope(rope)
        @ropes.delete(rope)
    end
    def remove_all_ropes
        while @ropes.size > 0
            r = @ropes[0]
            r.remove_self
        end
        swing_back
    end
    def tick!(keys_pressed, time_interval=0.1)
        if keys_pressed.include?('space')
            pull(2)
        end
        
        for r in @ropes do
            r.tick!(time_interval)
        
        end
        super(time_interval)
    end

    def throw_rope_left(dir)
        
        @left_rope = throw_rope(@pos + dir) if !@left_rope
    end
    def throw_rope_right(dir)
        @right_rope = throw_rope(@pos + dir) if !@right_rope
    end
    def drop_left_rope
        @left_rope.remove_self if @left_rope
        @left_rope = nil
    end
    def drop_right_rope
        
        @right_rope.remove_self if @right_rope
        @right_rope = nil
    end
    def draw_init
        @shape = Image.new('../assets/images/char_back_t.png', width: 160, height: 160)
        @shape2 = Image.new('../assets/images/char_back_backwards_t.png', width: 160, height: 160)
        @shape3 = Image.new('../assets/images/char_for.png', width: 160, height: 160)
        @shape4 = Image.new('../assets/images/char_for_back.png', width: 160, height: 160)
        @swinging_forward = false
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
                @vel.x += Math.sin(@rotate) * 2
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
          #  @swinging_forward = false
        end
        for r in @ropes do
            @rotate = r.direction.get_angle

            
           

            r.draw_frame
        end
        upside_down = !(@ropes.size == 0) && (@rotate < -Math::PI || @rotate >= 0)
        @level.transform(@pos - Vector.new(80,80)) do |newpos|
            if @swinging_forward
                @shape.x = -500
                @shape2.x = -500
                
                if @vel.x < 0 &&  !upside_down || (upside_down && @vel.x > 0)
                    
                        
                    @shape4.x = newpos.x
                    @shape4.y = newpos.y
                    @shape3.x = -200
                    @shape3.y = -200
                    @shape4.rotate = 90 + @rotate * (180 / Math::PI)
                else
                    @shape3.x = newpos.x
                    @shape3.y = newpos.y
                    @shape3.rotate = 90 + @rotate * (180 / Math::PI)
                    @shape4.x = -200
                    @shape4.y = -200
                end
            else
                @shape3.x = -500
                @shape4.x = -500
                if @vel.x < 0 &&  !upside_down || (upside_down && @vel.x > 0)
                    @shape2.x = newpos.x
                    @shape2.y = newpos.y
                    @shape.x = -200
                    @shape.y = -200
                    @shape2.rotate = 90 + @rotate * (180 / Math::PI)
                else
                    @shape.x = newpos.x
                    @shape.y = newpos.y
                    @shape.rotate = 90 + @rotate * (180 / Math::PI)
                    @shape2.x = -200
                    @shape2.y = -200
                end
        
            end
        end
        @level.keep_in_focus(self.pos)

    end
    

    def pull(strength)
        for r in @ropes
            r.pull(strength)
        end

    end

end