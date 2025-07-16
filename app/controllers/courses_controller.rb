class CoursesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action { authorize @course || Course }

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    @breadcrumbs = [
      { content: "Courses", href: courses_path },
      { content: @course.to_s }
    ]
  end

  # GET /courses/new
  def new
    @course = Course.new
    @breadcrumbs = [
      { content: "Courses", href: courses_path },
      { content: "New" }
    ]
  end

  # GET /courses/1/edit
  def edit
    @breadcrumbs = [
      { content: "Courses", href: courses_path },
      { content: @course.to_s, href: course_path(@course) },
      { content: "Edit" }
    ]
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.find(params.expect(:id))
  end

  def course_params
    params.expect(course: [ :title, :description, lesson_ids: [] ])
  end
end
