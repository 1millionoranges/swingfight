class Screen
    @@screenpos = 0
    def initialize
        @@screenpos = 0
        @width = 1500
        @image1 = Image.new('../citybackground.png', z: -100)
        @image2 = Image.new('../citybackground.png', z: -100)
    end

    def draw_frame
        @@screenpos -= 1
    #    p @image1.x
   #     p @image2.x
        @image1.x = @@screenpos % (@width * 2) - @width
        @image2.x = (@@screenpos + @width) % (width * 2) - @width
    end
    def set_screenpos(x)
        @@screenpos = x
    end
    def transform(x)
        @@screenpos - x
    end
end