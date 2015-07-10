Posts = new Mongo.Collection 'posts'

Posts.allow
  update: PermissionsHelpers.ownDoc
  remove: PermissionsHelpers.ownDoc

Posts.deny
  update: (userId, post, fieldNames) ->
    (_.without fieldNames, 'url', 'title').length > 0

Meteor.methods
  postInsert: (postAttributes) ->
    check Meteor.userId(), String
    check postAttributes,
      title: String
      url: String
      message: String

    postsWithSameLinks = Posts.findOne url: postAttributes.url

    if postAttributes.url and postsWithSameLinks
      return {
        postExists: true
        _id: postsWithSameLinks._id
      }

    user = Meteor.user()
    post = _.extend postAttributes,
      userId: user._id
      author: user.username
      submitted: new Date()
      commentsCount: 0
      upvoters: []
      votes: 0

    postId = Posts.insert post

    return {
      _id: postId
    }
  upvote: (postId) ->
    check @userId, String
    check postId, String
    affected = Posts.update({
      _id: postId
      upvoters: $ne: @userId
    },
      $addToSet: upvoters: @userId
      $inc: votes: 1)
    unless affected
      throw new (Meteor.Error)('invalid', 'You weren\'t able to upvote that post')
    return