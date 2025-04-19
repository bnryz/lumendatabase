Topic.transaction do
  Topic.create!(name: 'Uncategorized')

  Topic.find_or_create_by!(name: 'Request')
  Topic.find_or_create_by!(name: 'Ban')
  Topic.find_or_create_by!(name: 'Takedown')
  Topic.find_or_create_by!(name: 'Appeal')
  Topic.find_or_create_by!(name: 'Response')
end
