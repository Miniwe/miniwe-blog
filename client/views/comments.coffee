Template.PostPage.helpers
  comments: -> Comments.find {postId: @._id},
    sort:
      submitted: -1

Template.Comment.helpers
  submittedText: ->
    new Date(@submitted).toString()

Template.CommentsSubmit.onRendered ->
  $('textarea').autoGrow()

Template.CommentsSubmit.events
  'submit form': (event, template) ->
    event.preventDefault()

    $body = $(event.target).find('[name=comment]')

    comment =
      body: $body.val()
      postId: template.data._id


    Meteor.call 'comment', comment, (error, commentId) ->
      if error
        Errors.throwError error.reason
      else
        $body.val ''
