module Rallycat
  class Cat

    def story(story_number)
      <<-STORY


------------------------------------------------
## [#{story_number}] Rally Title
------------------------------------------------

As a user
ISBAT be able to update a record

* [TA1234] I should be able to go to a page
* [TA1234] I should be able to go to a page
* [TA1234] I should be able to go to a page


------------------------------------------------

      STORY
    end

  end
end