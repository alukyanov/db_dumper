# How config/schema.rb may look

# DbDumper.dump do
#   user_id = 1
#   dump('users').where(id: user_id)
#   campaigns_q = q('campaigns').where('user_id = ? OR for_all IS TRUE', user_id)
#   dump(campaigns_q)
#   dump('offices').where(campaign_id: campaigns_q.ar)
# end
