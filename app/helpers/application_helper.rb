# frozen_string_literal: true

module ApplicationHelper  
  def flash_messages
    capture do
      flash.each do |key, value|
        concat tag.div(
            
            data: {
            controller: :flash, flash_key: key, flash_value: value
          }
        )
      end
    end
  end        


end
