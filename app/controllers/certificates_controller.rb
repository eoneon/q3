class CertificatesController < ApplicationController
  def index
    @certificates = Certificate.all.order(sort: 'asc')

    respond_to do |format|
      format.html
      format.csv { send_data @certificates.to_csv(['sort', 'name']), filename: "Certificates.csv" }
      format.xls { send_data @certificates.to_csv(['sort', 'name'], col_sep: "\t") }
    end
  end

  def create
    @category = Category.find(params[:category_id])
    @categorizable = Certificate.create(certificate_params)

    @category.certificates << @categorizable

    if @category.save
      respond_to do |format|
        format.html
        format.js
      end
    else
    end
  end

  def update
    @category = Category.find(params[:category_id])
    @certificate = Certificate.find(params[:id])
    @certificate.assign_attributes(certificate_params)

    if @certificate.save
    else
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @certificate = Certificate.find(params[:id])

    if @certificate.destroy
    else
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def import
    Certificate.import(params[:file])
    redirect_to certificates_path, notice: 'Certificate imported.'
  end

  private

  def certificate_params
    params.require(:certificate).permit!
  end
end
