if Posts.find().count() == 0
  now = new Date().getTime()

  tomId = Meteor.users.insert
    createdAt: now
    profile: {username: 'Tom Coleman'}
    emails: [
      {
        address: 'tom@coleman.com'
        verified: false
      }
    ]
  tom = Meteor.users.findOne tomId

  sachaId = Meteor.users.insert
    createdAt: now
    profile: {username: 'Sacha Greiff'}
    emails: [
      {
        address: 'sacha@greiff.com'
        verified: false
      }
    ]
  sacha = Meteor.users.findOne sachaId

  telescopeId = Posts.insert
    title: 'Introducing Telescope'
    userId: sacha._id
    author: sacha.profile.name
    url: 'http://sachagreiff.com/introducing-telescope/'
    submitted: now - 7 * 3600 * 1000
    commentsCount: 2
    upvoters: [], votes: 0

  Comments.insert
    postId: telescopeId
    userId: tom._id
    author: tom.profile.name
    submitted: now - 5 * 3600 * 1000
    body: 'Interesting project, Sacha, can I get involved?'

  Comments.insert
    postId: telescopeId
    userId: sacha._id
    author: sacha.profile.name
    submitted: now - 3 * 3600 * 1000
    body: 'You sure can, Tom!'

  Posts.insert
    title: 'Meteor'
    userId: tom._id
    author: tom.profile.name
    url: 'http://meteor.com/'
    submitted: now - 10 * 3600 * 1000
    commentsCount: 0
    upvoters: [], votes: 0

  Posts.insert
    title: 'The Meteor Book'
    userId: tom._id
    author: tom.profile.name
    url: 'http://themeteorbook.com/'
    submitted: now - 12 * 3600 * 1000
    commentsCount: 0
    upvoters: [], votes: 0

  _(20).times (k) ->
    Posts.insert
      title: Fake.sentence 10
      author: Fake.fromArray [sacha.profile.name, tom.profile.name]
      userId: Fake.fromArray [sacha._id, tom._id]
      url: "http://google.com/?q=test-#{k}"
      submitted: now - k * 3600 * 1000
      commentsCount: 0
      upvoters: [], votes: 0
