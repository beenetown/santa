class SpendingLimitsController < ApplicationController
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
      if @group.update(spending_limit: clean_spending_limit)
        format.html { redirect_to @group, notice: 'Spending Limit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @group = Group.find(params[:group_id])
    respond_to do |format|
      if @group.update(spending_limit: clean_spending_limit)
        format.html { redirect_to @group, notice: 'Spending Limit now set.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def clean_spending_limit 
    params[:spending_limit].gsub(/^[\D]|[,]|[a-zA-Z]/, '')
  end
end
