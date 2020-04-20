json.key_format! camelize: :lower

json.total_views @user.impressions.count
json.total_shares @user.shares.count
json.blogs @user.blogs
