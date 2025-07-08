class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy ]
  before_action :set_course_lesson, only: %i[ show ]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    @breadcrumbs = []
    @breadcrumbs << { content: @course.to_s, href: course_path(@course) } if @course.present?
    @breadcrumbs << { content: "Lessons", href: lessons_path } unless @course.present?
    @breadcrumbs << { content: @lesson.to_s }
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new

    @breadcrumbs = [
      { content: "Lessons", href: lessons_path },
      { content: "New" }
    ]
  end

  # GET /lessons/1/edit
  def edit
    @breadcrumbs = [
      { content: "Lessons", href: lessons_path },
      { content: @lesson.to_s, href: lesson_path(@lesson) },
      { content: "Edit" }
    ]
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: "Lesson was successfully updated." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy!

    respond_to do |format|
      format.html { redirect_to lessons_path, status: :see_other, notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_lesson
    @lesson = Lesson.find_by_id(params.expect(:id)) || Lesson.find_by_slug(params.expect(:id))

    raise ActiveRecord::RecordNotFound unless @lesson.present?
  end

  def set_course_lesson
    if params[:course_id].present?
      @course = Course.find(params[:course_id])
      @course_lesson = CourseLesson.find_by(lesson: @lesson, course: @course)
    end
  end

  def lesson_params
    params.expect(lesson: [ :title, :description, :content, :github_repository_url, :github_repository_branch ])
  end
end
