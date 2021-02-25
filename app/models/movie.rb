class Movie < ActiveRecord::Base
    def Movie.all_ratings
        return self.select(:rating).map {|m| m.rating}.uniq.sort
    end
end

