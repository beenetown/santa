class SelectionDatesController < ApplicationController
  def create
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update(select_date: params[:selection_date][:select_date])
        format.html { redirect_to @group, notice: 'Selection Date now set.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update(select_date: params[:selection_date][:select_date])
        format.html { redirect_to @group, notice: 'Selection Date was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
end
