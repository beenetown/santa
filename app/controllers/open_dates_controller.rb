class OpenDatesController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    respond_to do |format|
      if @group.update(open_date: params[:open_date])
        format.html { redirect_to @group, notice: 'Open Date now set.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @group = Group.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @group = Group.find(params[:group_id])
    respond_to do |format|
      if @group.update(open_date: params[:open_date])
        format.html { redirect_to @group, notice: 'Open Date was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
end
