# POSTS
Meteor.publish 'posts', (options) ->
  check options,
    sort: Object
    limit: Number
  Posts.find {}, options

# - SINGLE
Meteor.publish 'singlePost', (id) ->
  check id, String
  id and Posts.find id

# COMMENTS
Meteor.publish 'comments', (postId) ->
  check postId, String
  Comments.find {postId: postId}
