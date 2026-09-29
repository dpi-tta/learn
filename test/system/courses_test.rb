require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    find('a[aria-label="New course"]').click

    fill_in "Description", with: @course.description
    fill_in "Title", with: @course.title
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    find('a[aria-label="Edit this course"]').click

    fill_in "Description", with: @course.description
    fill_in "Title", with: @course.title
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    find('button[aria-label="Destroy this course"]').click

    assert_text "Course was successfully destroyed"
  end
end
