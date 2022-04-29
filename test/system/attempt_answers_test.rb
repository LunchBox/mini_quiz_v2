require "application_system_test_case"

class AttemptAnswersTest < ApplicationSystemTestCase
  setup do
    @attempt_answer = attempt_answers(:one)
  end

  test "visiting the index" do
    visit attempt_answers_url
    assert_selector "h1", text: "Attempt answers"
  end

  test "should create attempt answer" do
    visit attempt_answers_url
    click_on "New attempt answer"

    click_on "Create Attempt answer"

    assert_text "Attempt answer was successfully created"
    click_on "Back"
  end

  test "should update Attempt answer" do
    visit attempt_answer_url(@attempt_answer)
    click_on "Edit this attempt answer", match: :first

    click_on "Update Attempt answer"

    assert_text "Attempt answer was successfully updated"
    click_on "Back"
  end

  test "should destroy Attempt answer" do
    visit attempt_answer_url(@attempt_answer)
    click_on "Destroy this attempt answer", match: :first

    assert_text "Attempt answer was successfully destroyed"
  end
end
