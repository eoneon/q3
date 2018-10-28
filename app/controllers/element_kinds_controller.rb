class ElementKindsController < ApplicationController
  def create
    @elementable = set_parent
    @element_kind = ElementKind.new(element_kind_params)
    @elementable.element_kinds << @element_kind

    if @element_kind.save
      #@element_group = @element_kind.element_groups.first

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @element_kind = ElementKind.find(params[:id])
    @element_kind.assign_attributes(element_kind_params)

    if @element_kind.save
      @elementable = set_parent

      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @elementable = set_parent
    element_kind = ElementKind.find(params[:id])
    @element_kind_group = element_kind.element_groups.first
    sort = @element_kind_group.sort

    if element_kind.destroy
      reset_sort(@elementable, sort)

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def element_kind_params
    params.require(:element_kind).permit!
  end
end
