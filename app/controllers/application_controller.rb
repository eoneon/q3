class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  
  def get_klass
    parent_klasses = %w[category, dimension]
    if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
      klass
    end
  end

  def fieldables
    get_klass.pluralize
  end

  def categorizable
    get_klass.pluralize
  end

  def fieldable
    get_klass.camelize.constantize.find params[:"#{get_klass}_id"]
  end

  def categorizable
    get_klass.camelize.constantize.find params[:"#{get_klass}_id"]
  end
end
