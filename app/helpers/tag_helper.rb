module TagHelper
    def get_font_color(background)
        return "white" if(background.paint.dark? )
        return "balck" 
        
    end
end
