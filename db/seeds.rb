# The following four lines may spit out "Index does not
# exist" errors, but they don't matter.
Notice.__elasticsearch__.delete_index! force: true
Notice.__elasticsearch__.create_index! force: true

Entity.__elasticsearch__.delete_index! force: true
Entity.__elasticsearch__.create_index! force: true

# Execute seeds in a logical order
seed_files = %w[
  topics.rb
]

seed_files.each { |file| load("db/seeds/#{file}") }
