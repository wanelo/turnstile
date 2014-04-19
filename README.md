[![Build status](https://secure.travis-ci.org/wanelo/turnstile.png)](http://travis-ci.org/wanelo/turnstile)

# Turnstile

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'turnstile'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install turnstile

## Usage

You can start a log-watcher process that will tail the log in wanelo format and will
update redis database.

```ruby
Usage: bundle exec log-watcher -f <file> [options]

    -v, --verbose                    Print status to stdout
    -f, --file FILE                  File to watch
    -h, --redis-host HOST            Redis server host
    -p, --redis-port PORT            Redis server port
    -n, --redis-db DB                Redis server db
    -d, --daemonize                  Should we daemonize
    -b, --buffer-interval INTERVAL   Buffer for this many seconds
    -i, --flush-interval INTERVAL    Flush then sleep for this many seconds
    -?, --help                       Show this message
```

For example:

```
> bundle exec log-watcher -v -f log/production/log -d -h 127.0.0.1 -p 6432

2014-04-12 05:16:41 -0700: updater:flush        - nothing to flush, sleeping 6s..
2014-04-12 05:16:41 -0700: updater:queue        - nothing in the queue, sleeping 5s...
2014-04-12 05:16:41 -0700: log-reader           - starting to tail file log....
2014-04-12 05:16:46 -0700: updater:queue        - nothing in the queue, sleeping 5s...
2014-04-12 05:16:53 -0700: updater:flush        - nothing to flush, sleeping 6s..
2014-04-12 05:16:56 -0700: updater:queue        - (     0.65ms) caching [746] keys locally
2014-04-12 05:16:59 -0700: updater:flush        - (    91.73ms) flushing cache with [602] keys
2014-04-12 05:17:05 -0700: updater:flush        - nothing to flush, sleeping 6s..
^Ctrl-C
```

## Circonus NAD Integration

We use Circonus to collect and graph data. You can use ```log-watcher```
to dump the current aggregate statistics from redis to standard output,
which is a tab-delimited format consumable by the nad daemon.

(below output is formatted to show tabs as aligned for readability).

```ruby
> bin/log-watcher -h 127.0.0.1 -p 6432 -s
turnstile.iphone	 s      383
turnstile.ipad       s	    34
turnstile.android    s      108
turnstile.ipod_touch s      34
turnstile.unknown    s      36
turnstile.total      s      595
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/turnstile/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
