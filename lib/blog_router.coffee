Router.map ->
  @route 'PostSubmit',
    path: '/blog/posts/submit'
    disableProgress: true

  @route 'PostPage',
    path: '/blog/posts/:_id'
    data: -> Posts.findOne @params._id
    onAfterAction: ->
      data = @data()
      Meta.setTitle (@data()).title if data
    waitOn: ->
      Meteor.subscribe 'singlePost', @params._id
      Meteor.subscribe 'comments', @params._id

  @route 'PostEdit',
    path: '/blog/posts/:_id/edit'
    data: -> Posts.findOne @params._id
    waitOn: ->
      Meteor.subscribe 'singlePost', @params._id

  @route 'BlogPage',
    path: '/blog/:postsLimit?'
    controller: 'PostsListController'

Router.onBeforeAction 'dataNotFound', only: 'PostPage'
Router.onBeforeAction IR_BeforeHooks.requireLogin, only: 'PostSubmit'
