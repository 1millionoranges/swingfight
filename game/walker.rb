class Walker < Swinger

    def initialize(args)
        super(args)
        @grounded = false
        @spritesheet = Sprite.new('../assets/images/walking_spritesheet_test.png',width: 50,height: 80, time: 250,
        animations: {walk: [
            {x: 0, y: 80, width: 50, height: 80, time: 100},
            {x: 50, y: 80, width: 50, height: 80, time: 100},
            {x: 100, y: 80, width: 50, height: 80, time: 100}],
            nothing: [{x: 0, y: 0, width: 1, height: 1, time: 1000}],
            stand: [{x: 0, y: 0, width: 50, height: 80, time: 1000}]
        })
        @spritesheet.x = -300
        @spritesheet.y = 10
        @spritesheet.play animation: :walk, loop: true;
    end
    def draw_frame
        if ! @grounded
            super
        else
            @level.transform(@pos) do |newpos|
                @spritesheet.x = newpos.x - 30
                @spritesheet.y = newpos.y - 30
            end
            @level.keep_in_focus(@pos)
        end
    end
    def tick!(keys_pressed, time_interval=0.1)

        
        if !@grounded
      #      become_grounded if keys_pressed.include?('7')
            super(keys_pressed, time_interval)
        else
            jump if keys_pressed.include?('space')
            if keys_pressed.include?('shift')
                walk_speed = 10
            else
                walk_speed = 10
            end
            if keys_pressed.include?("a")
                walk_left
                @pos.x -= walk_speed
            elsif keys_pressed.include?("d")
                walk_right
                @pos.x += walk_speed
            else
                stand
            end
        end
    end
    def become_grounded
        remove_all_ropes
        @grounded = true
        @shape.x = -200
        @shape2.x = -200
        @shape3.x = -200
        @shape4.x = -200
        @spritesheet.play animation: :stand, loop: true
    end
    def stand
        @spritesheet.play animation: :stand, loop: true
        @vel.x = 0 
    end
    def walk_right
        @spritesheet.play animation: :walk, loop: true
        @vel.x = 6
    end
    def walk_left
        @spritesheet.play animation: :walk, loop: true, flip: :horizontal
        @vel.x = -6
    end
    def jump
        @spritesheet.x = -400
        @vel.y = -15
        @rotate = -3
        @grounded = false
    end

end