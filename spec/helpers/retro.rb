module Helpers
  def add_issues
    @types = ["Good", "Meh", "Bad"]
    @num_added = rand(5)
    for index in 0...@num_added
      @issue_type = rand(3)
      @issue = FactoryGirl.create(:issue)
      @issue.issue_type = @issue_type
      @issue.save!
    end
  end
end