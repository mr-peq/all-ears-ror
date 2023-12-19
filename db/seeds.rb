puts "Clearing database..."

UserMatch.destroy_all
Match.destroy_all
User.destroy_all


puts "Creating 3 users..."

peq = User.create!(nickname: "peq")
sam = User.create!(nickname: "sam")
joe = User.create!(nickname: "joe")

USERS = [peq, sam, joe]


puts "Creating 2 matches..."

match_1 = Match.create!(number_of_rounds: 3)
match_2 = Match.create!(number_of_rounds: 5)


puts "Assigning matches and points scored to users..."

SCORES = [0, 1, 2, 3]

USERS.each do |user|
  UserMatch.create!(user:, match: match_1, score: SCORES.sample)
  UserMatch.create!(user:, match: match_2, score: SCORES.sample)
end
