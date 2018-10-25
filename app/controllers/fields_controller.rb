class FieldsController < ApplicationController
  def index
    @fields = Field.all

    respond_to do |format|
      format.html
      format.csv { send_data @fields.to_csv, filename: "Fields.csv"}
      format.xls { send_data @fields.to_csv(col_sep: "\t") }
    end
  end

  def create
    @fieldable = set_fieldable
    @field = Field.new(field_params)

    @fieldable.fields << @field

    if @field.save
      @field_group = @field.field_groups.first

      respond_to do |format|
        format.html
        format.js
      end

    else
    end
  end

  def update
    @field = Field.find(params[:id])
    @field.assign_attributes(field_params)

    if @field.save
      @fieldable = set_fieldable
      #flash[:notice] = "✔"
      #redirect_to action: :index

    else
      flash.now[:alert] = "Error updated field. Please try again."
      #render :edit
    end
    respond_to do |format|
      #flash[:notice] = "updated"
      format.js
    end
  end

  def destroy
    @fieldable = set_fieldable
    field = Field.find(params[:id])
    @field_group = field.field_groups.first
    sort = @field_group.sort

    if field.destroy
      reset_sort(@fieldable, sort)

      respond_to do |format|
        format.js
      end

    else
    end
  end

  def import
    Field.import(params[:file])
    redirect_to fields_path, notice: 'Fields imported.'
  end

  private

  def field_params
    params.require(:field).permit!
  end
end
