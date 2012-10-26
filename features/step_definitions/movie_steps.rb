# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  @movie_rows = Movie.count
  @all_ratings =Movie.select(:rating).map(&:rating).uniq
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #page.content(e1)
  p1 = page.text =~ /#{Regexp.escape(e1)}/ 
  p2 = page.text =~ /#{Regexp.escape(e2)}/
  assert p1.should < p2
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    uncheck ? uncheck("ratings_"+rating) : check("ratings_"+rating)
  end
end

When /I (un)?check all/ do |uncheck|
  @all_ratings.each do |rating|
    uncheck ? uncheck("ratings_"+rating) : check("ratings_"+rating)
  end
end

Then /I should see all of the movies/ do
  assert @movie_rows.should < all("table#movies tr").count
end

Then /I should see no changes in movies/ do
  assert all("table#movies tr").count > 1
end