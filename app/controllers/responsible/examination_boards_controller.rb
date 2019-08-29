class Responsible::ExaminationBoardsController < Responsible::BaseController
  before_action :set_examination_board, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.one.index'),
                 :responsible_examination_boards_tcc_one_path,
                 only: :tcc_one

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.two.index'),
                 :responsible_examination_boards_tcc_two_path,
                 only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.two.new'),
                 :new_responsible_examination_board_path,
                 only: [:new]

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    @examination_boards = paginate(ExaminationBoard.tcc_one)
    @search_url = responsible_examination_boards_tcc_one_search_path
    render :index
  end

  def tcc_two
    @examination_boards = paginate(ExaminationBoard.tcc_two)
    @search_url = responsible_examination_boards_tcc_two_search_path
    render :index
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, responsible_examination_board_path
  end

  def new
    @examination_board = ExaminationBoard.new
  end

  def edit
    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.edit"),
                   edit_responsible_examination_board_path
  end

  def create
    @examination_board = ExaminationBoard.new(examination_board_params)

    if @examination_board.save
      feminine_success_create_message
      redirect_to responsible_examination_boards_tcc_two_path
    else
      error_message
      render :new
    end
  end

  def update
    if @examination_board.update(examination_board_params)
      feminine_success_update_message
      redirect_to responsible_examination_board_path(@examination_board)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @examination_board.destroy
    feminine_success_destroy_message

    redirect_to responsible_examination_boards_path
  end

  private

  def paginate(data)
    data.search(params[:term])
        .page(params[:page])
        .order(created_at: :desc)
        .with_relationships
  end

  def set_examination_board
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
  end

  def examination_board_params
    params.require(:examination_board)
          .permit(:place, :date, :orientation_id, :tcc,
                  professor_ids: [], external_member_ids: [])
  end
end