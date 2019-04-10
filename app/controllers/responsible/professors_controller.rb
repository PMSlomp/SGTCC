class Responsible::ProfessorsController < Responsible::BaseController
  before_action :set_professor, only: [:show, :edit, :update, :destroy]
  before_action :set_resource_name, only: [:create, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.professors.index'),
                 :responsible_professors_path

  add_breadcrumb I18n.t('breadcrumbs.professors.new'),
                 :new_responsible_professor_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.professors.show'),
                 :responsible_professor_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.professors.edit'),
                 :edit_responsible_professor_path,
                 only: [:edit]

  def index
    @professors = Professor.page(params[:page]).search(params[:term]).order(:name)
  end

  def show; end

  def new
    @professor = Professor.new
  end

  def edit; end

  def create
    @professor = Professor.new(professor_params)
    @professor.define_singleton_method(:password_required?) { false }

    if @professor.save
      flash[:success] = I18n.t('flash.actions.create.m', resource_name: @resource_name)
      redirect_to responsible_professors_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @professor.update(professor_params)
      flash[:success] = I18n.t('flash.actions.update.m', resource_name: @resource_name)
      redirect_to responsible_professor_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @professor.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m', resource_name: @resource_name)

    redirect_to responsible_professors_url
  end

  private

  def set_professor
    @professor = Professor.find(params[:id])
  end

  def set_resource_name
    @resource_name = Professor.model_name.human
  end

  def professor_params
    params.require(:professor).permit(
      :name, :email,
      :username, :lattes,
      :gender, :is_active,
      :working_area, :available_advisor,
      :professor_type_id, :scholarity_id,
      role_ids: []
    )
  end
end