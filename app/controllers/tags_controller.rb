class TagsController < ApplicationController
    before_action :set_tag, only: %i[ show edit update destroy ]

    def index
        @tags=Tag.all
    end
    def new 
        @tag=Tag.new
    end
    
    def create
        @tag = Tag.new(tag_params)
        respond_to do |format|
            if @tag.save
                add_flash_message('notice', "Tag was successfully created.")
                format.html { redirect_to tag_url(@tag) }
              format.json { render :show, status: :created, location: @tag }
            else
                
                @tag.errors.each do |error|
                    add_flash_message('error',  error.full_message)
                end
  
              format.html { redirect_to new_tag_url, status: :unprocessable_entity }
             end
        end
    end
    def edit
    end
    def update
        f=0
    respond_to do |format|
      if @tag.update(tag_params)
        if(f==1)
            @tag.where(tag_type: tag_params[:tag_type])
        end
        add_flash_message('notice', "Book was successfully updated.")
        format.html { redirect_to tag_url(@tag) }
        format.json { render :show, status: :ok, location: @book }
      else

        @tag.errors.each do |error|
            add_flash_message('error',  error.full_message)
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
        p "-----------"
    end
    
    private 
    def set_tag
        @tag=Tag.find_by(id:params[:id])
    end
    def tag_params
        params.require(:tag).permit(:tag_name, :tag_type,:color)
    end
end
