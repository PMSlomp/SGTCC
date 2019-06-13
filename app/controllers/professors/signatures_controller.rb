class Professors::SignaturesController < Professors::BaseController
  before_action :set_signature, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :professors_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :professors_signatures_signed_path,
                 only: :signed

  def pending
    signatures_by_status(false)
  end

  def signed
    signatures_by_status(true)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@signature)
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def signatures_by_status(status)
    signatures = Signature.where(
      user_id: current_professor.id,
      user_type: 'P',
      status: status
    ).includes(:orientation, document: [:document_type])
    @signatures = Signature.paginate_array(signatures, params[:page])
  end
end
