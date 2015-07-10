@PostsListController = RouteController.extend
  template: 'BlogPage'
  increment: 5
  limit: ->
    parseInt(@params.postsLimit, 10) or @increment
  findOptions: ->
    sort: {submitted: -1}, limit: @limit()
  onBeforeAction: ->
    @postsSub = Meteor.subscribe 'posts', @findOptions()
    @next()
  posts: ->
    Posts.find {}, @findOptions()
  data: ->
    hasMore = @posts().fetch().length == @limit()
    nextPath = @route.path postsLimit: @limit() + @increment
    return {
      posts: @posts()
      ready: if @postsSub then @postsSub.ready else null
      nextPath: if hasMore then nextPath else null
    }
