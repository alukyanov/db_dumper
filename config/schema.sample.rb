# How config/schema.rb may look

# DbDumper.dump do
#   dump 'roles'
#   user_id = 1
#   copy q('users').where(id: user_id)
#   campaigns_q = q('campaigns').where('user_id = ? OR for_all IS TRUE', user_id)
#   copy campaigns_q
#   copy q('offices').where(campaign_id: campaigns_q.ar)
# end
