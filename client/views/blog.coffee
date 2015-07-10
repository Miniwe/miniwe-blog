Template.PostItem.helpers
  domain: ->
    a = document.createElement 'a'
    a.href = @url
    a.hostname
  ownPost: ->
    @userId == Meteor.userId()
  upvotedClass: ->
    userId = Meteor.userId()
    if userId and !_.include @upvoters, userId
      'btn-material-indigo upvotable'
    else
      'disabled'

Template.PostItem.events
  'click .upvote': (event) ->
    event.preventDefault()
    Meteor.call 'upvote', @_id

Template.PostPage.helpers
  submittedText: ->
    new Date(@submitted).toString()

initBall = ->
  # @todo сделать движение за мышкой правильно
  $ball = $('.ball')
  radius = $ball.outerWidth()
  d_max = $(window).height()
  ball_point = $ball.offset()
  ball_point.top += radius / 2
  ball_point.left += radius / 2
  $(window).on 'mousemove', (event) ->
    deltaX = (event.pageX - ball_point.left)
    deltaY = (event.pageY - ball_point.top)
    d = Math.sqrt(Math.pow(deltaY,2) + Math.pow(deltaX,2))
    d_circle = (radius / d_max) * d
    d_circle_X = d_circle * Math.cos(deltaX)
    d_circle_Y = d_circle * Math.sin(deltaY)
    console.log 'pos', event.pageX, event.pageY, d, d_circle,d_circle_X,d_circle_Y
    $ball.css {'box-shadow': "inset -#{d_circle_X}px -#{d_circle_Y}px 17px #{d_circle}px rgba(0, 0, 0, 0.6)"}, 'fast'

Template.PostsList.onRendered ->
  # initBall()

Template.PostSubmit.onRendered ->
  $('textarea').autoGrow()

Template.PostEdit.onRendered ->
  $('textarea').autoGrow()

Template.PostSubmit.events
 'submit form': (event) ->
    event.preventDefault()
    post =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()
      message: $(event.target).find('[name=message]').val()

    Meteor.call 'postInsert', post, (error, result) ->
      return Errors.throwError(error.reason) if error
      if result.postExists
        Errors.throwError('This link has already been posted')

      return Router.go 'PostPage', _id: result._id

Template.PostEdit.events
 'submit form': (event) ->
    event.preventDefault()
    curPostId = @_id
    post =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    Posts.update curPostId, {$set: post}, (error) ->
      if error
        alert error.reason
      else
        Router.go 'PostPage', _id: curPostId
  'click .btn-delete': (event) ->
    event.preventDefault()

    if confirm 'Delete this post ?'
      curPostId = @_id
      Posts.remove curPostId
      Router.go 'BlogPage'
