require 'spec_helper'

describe "StaticPages" do
  describe "Home Page" do
    it "should have the content 'VacationCalendar'" do
      visit '/static_pages/home'
      expect(page).to have_content('VacationCalendar')
    end
  end
end
