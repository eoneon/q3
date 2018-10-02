class FieldGroupsController < ApplicationController
  def create
    @fieldable = set_fieldable
    @field_group = @fieldable.field_groups.build(field_group_params)

    if @field_group.save
      respond_to do |format|
        format.js
      end
    else
      #flash.now[:alert] = "Error creating Field chain. Please try again."
      #redirect_to @fieldable
    end
  end

  def sort_up
    @fieldable = set_fieldable
    swap_sort(@fieldable, -1)

    respond_to do |format|
      format.js
    end
  end

  def sort_down
    @fieldable = set_fieldable
    swap_sort(@fieldable, 1)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @fieldable = set_fieldable
    field_group = FieldGroup.find(params[:id])
    sort = field_group.sort

    if field_group.destroy
      reset_sort(@fieldable, sort)

      respond_to do |format|
        format.js
      end
    else
    end
  end

  private

  def field_group_params
    params.require(:field_group).permit!
  end

  # def reset_sort(fieldable, sort)
  #   fieldable.field_groups.where("sort > ?", sort).each do |field|
  #     field.update(sort: field.sort - 1)
  #   end
  # end

  # def set_fieldable
  #   parent_klasses = %w[category dimension]
  #   if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
  #     klass.camelize.constantize.find params[:"#{klass}_id"]
  #   end
  # end

  # def target_obj
  #   params[:controller].singularize.camelize.constantize
  # end

  # def swap_sort(fieldable, pos)
  #   field_group = target_obj.find(params[:id])
  #   sort = field_group.sort
  #   sort2 = pos == -1 ? sort - 1 : sort + 1
  #
  #   field_group2 = fieldable.field_groups.where(sort: sort2)
  #   field_group2.update(sort: sort)
  #   field_group.update(sort: sort2)
  # end
end
