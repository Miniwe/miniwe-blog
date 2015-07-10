Comments = new Mongo.Collection 'comments'

Comments.allow
  update: PermissionsHelpers.ownDoc
  remove: PermissionsHelpers.ownDoc

Meteor.methods
  comment: (commentAttributes) ->
    check commentAttributes,
      postId: String
      body: String

    user = Meteor.user()
    post = Posts.findOne _id: commentAttributes.postId

    throw new Meteor.Error(401, 'You need login to make comments.') unless user
    throw new Meteor.Error(422, 'Please write some content.') unless commentAttributes.body
    throw new Meteor.Error(422, 'You must comment on post.') unless post

    comment = _.extend _.pick(commentAttributes, 'postId', 'body'),
      userId: user._id
      author: user.username
      submitted: (new Date()).getTime()

    Posts.update comment.postId, $inc: {commentsCount: 1}

    comment._id = Comments.insert comment
    Notifications.createCommentNotification comment
    return comment._id