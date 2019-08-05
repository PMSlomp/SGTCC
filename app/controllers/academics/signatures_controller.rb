class Academics::SignaturesController < Academics::BaseController
  include SignatureConfirm
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :academics_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :academics_signatures_signed_path,
                 only: :signed

  def pending
    @signatures = current_academic.signatures_pending(params[:page])
  end

  def signed
    @signatures = current_academic.signatures_signed(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), academics_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(current_academic, current_academic.ra)
  end

  private

  def set_signature
    @signature = current_academic.signatures.find_by(id: params[:id])
  end

  def can_view
    return if @signature.present?
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to academics_signatures_pending_path
  end
end