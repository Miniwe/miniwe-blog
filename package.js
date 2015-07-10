Package.describe({
  name: 'miniwe:blog',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'Blog for site from book Discover Meteor',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use(['coffeescript', 'templating', 'mongo', 'underscore', 'iron:router', 'miniwe:helpers'], ['server','client']);
  api.addFiles([
    'lib/collections/blog_posts.coffee',
    'lib/collections/blog_comments.coffee',
    'lib/controllers/posts_list.coffee',
    'lib/blog_router.coffee'
  ], ['client', 'server']);
  api.addFiles([
    'client/views/blog.html',
    'client/views/blog.coffee',
    'client/views/comments.coffee'
  ], 'client');
  api.addFiles([
    'server/publications.coffee',
    'server/fixtures.coffee'
  ], ['server']);

  api.export('Posts', ['client', 'server']);
  api.export('Comments', ['client', 'server']);

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('miniwe:blog');
  api.addFiles('tests/blog_tests.coffee');
});
