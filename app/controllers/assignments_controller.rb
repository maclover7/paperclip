class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :login_required
  before_action :is_teacher, only: [:index, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = Assignment.where(user_id: current_user.id).all
  end


  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @submissions = Submission.where(assignment_id: current_assignment.id).all
  end

  # GET /assignments/new
  def new
    @assignment = current_user.assignments.build #@assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = current_user.assignments.build(assignment_params) #@assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def is_teacher
      if current_user.teacher == false
        redirect_to root_path, notice: "Not authorized"
      end
    end

    def current_assignment
      @current_assignment ||= Assignment.find(params[:id])
    end

    def correct_user
      @assignment = current_user.assignments.find_by(id: params[:id])
      redirect_to assignments_path, notice: "Not authorized to edit this assignment" if @assignment.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :prompt, :work_allowed, :user_id)
    end
end
