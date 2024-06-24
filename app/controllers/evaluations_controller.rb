class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: %i[ show edit update destroy ]

  def index
    @evaluations = Section.grab_all_evaluations
  end


  def show
    @question = Question.new
  end

  def new
    @evaluation = Section.new
  end

  def edit
  end

  def create
    @evaluation = current_user.sections.build(evaluation_params)
    @evaluation.section_type = 1

    respond_to do |format|
      if @evaluation.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('evaluations_all', partial: 'evaluations/evaluations', locals: { evaluations: Section.grab_all_evaluations }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('modal', partial: 'errors/new_evaluation', locals: {}) }
      end
    end
  end

  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
        format.html { redirect_to evaluation_url(@evaluation), notice: "Evaluation was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to evaluations_url, notice: "Evaluation was successfully destroyed." }
    end
  end

  private
    def set_evaluation
      @evaluation = Section.find(params[:id])
    end

    def evaluation_params
      params.require(:section).permit(:name, :description, :body)
    end
end
