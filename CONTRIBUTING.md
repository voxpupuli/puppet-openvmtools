Contributing
============

1. [Fork](http://help.github.com/forking/) puppet-openvmtools.
2. Create a topic branch against the develop branch.
   `git checkout develop; git checkout -b my_branch`
3. Make your change.
4. Add a test for your change. Only refactoring and documentation changes
   require no new tests. If you are adding functionality or fixing a bug,
   please add a test.
5. Run the tests. We only take pull requests with passing tests.
   `bundle exec rake spec SPEC_OPTS='--format documentation'`
6. Add or update documentation.
7. Squash your commits down into logical components. Make sure to rebase
   against the current `develop` branch. `git pull --rebase upstream develop`
8. Push to your branch. `git push origin my_branch`
9. Create a [Pull Request](http://help.github.com/pull-requests/) from your
   branch against the develop branch.

Testing
-------

Tests are written with [rspec-puppet](http://rspec-puppet.com/). CI is covered
by [Travis CI](http://about.travis-ci.org/) and the current status is visible
[here](http://travis-ci.org/voxpupuli/puppet-openvmtools).

To install the test system, pick one of the following:

```sh
PUPPET_GEM_VERSION="~> 4.0" bundle install --path=.vendor --without system_tests
PUPPET_GEM_VERSION="~> 5.0" bundle install --path=.vendor --without system_tests
PUPPET_GEM_VERSION="~> 6.0" bundle install --path=.vendor --without system_tests
```

To run all tests:

```sh
bundle exec rake validate && \
bundle exec rake lint && \
bundle exec rake metadata_lint && \
bundle exec rake spec SPEC_OPTS='--format documentation' STRICT_VARIABLES=no
```

Versioning
----------

This project is versioned with the help of the
[Semantic Versioning Specification](http://semver.org/) using 0.0.1 as the
initial version. Please make sure you have read the guidelines before increasing
a version number either for a release or a hotfix.
