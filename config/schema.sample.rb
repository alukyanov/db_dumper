# DbDumper.dump do
#   q('users').where(active: true).where(type: [1, 2, 3])
#   q('campaigns').joins('join users on users.id = campaigns.user_id').where(deleted: false)
# end
