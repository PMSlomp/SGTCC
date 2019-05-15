class Professors::OrientationsController < Professors::BaseController
  before_action :set_orientation, only: [:show, :edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                 :professors_orientations_path

  add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                 :professors_orientation_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.orientations.new'),
                 :new_professors_orientation_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.orientations.edit'),
                 :edit_professors_orientation_path,
                 only: [:edit]

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    @orientations = current_professor.orientations
                                     .current_tcc_one
                                     .page(params[:page])
                                     .search(params[:term])
                                     .includes(:academic, :calendar)
    @search_url = professors_orientations_search_tcc_one_path

    render :index
  end

  def tcc_two
    @orientations = current_professor.orientations
                                     .current_tcc_two
                                     .page(params[:page])
                                     .search(params[:term])
                                     .includes(:academic, :calendar)
    @search_url = professors_orientations_search_tcc_two_path

    render :index
  end

  def history
    orientations = current_professor.orientations.includes(:academic, :calendar)
    supervisions = current_professor.professor_supervisors
                                    .includes(:orientation)
    supervisions = supervisions.map(&:orientation)
    @orientations = (orientations + supervisions).uniq
  end

  def show; end

  def new
    @orientation = Orientation.new
  end

  def edit; end

  def create
    @orientation = Orientation.new(orientation_params)

    if @orientation.save
      feminine_success_create_message
      redirect_to professors_orientations_path
    else
      error_message
      render :new
    end
  end

  def update
    if @orientation.update(orientation_params)
      feminine_success_update_message
      redirect_to professors_orientation_path(@orientation)
    else
      error_message
      render :edit
    end
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def orientation_params
    params.require(:orientation).permit(
      :title, :calendar_id, :academic_id,
      :advisor_id, :institution_id,
      professor_supervisor_ids: [],
      external_member_supervisor_ids: []
    )
  end
end
