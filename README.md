# Net::IMAP::Multiappend

Adds IMAP MULTIAPPEND to the net-imap gem.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add net-imap-multiappend

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install net-imap-multiappend

## Example Usage

Use Podman to run a test IMAP server

```sh
podman run --detach --env=MAILNAME=example.com --env=MAIL_ADDRESS=address@example.com --env=MAIL_PASS=pass -p 7993:993 antespi/docker-imap-devel:latest
```

...or use Docker

```sh
docker run --detach --env=MAILNAME=example.com --env=MAIL_ADDRESS=address@example.com --env=MAIL_PASS=pass -p 7993:993 antespi/docker-imap-devel:latest
```

In the root directory of this project, install dependencies

```sh
bundle
```

Run a Ruby shell

```sh
pry
```

Connect

```ruby
> require "net/imap/multiappend"

> imap = Net::IMAP.new("localhost", {port: 7993, ssl: {verify_mode:0}})
> imap.login("address@example.com", "pass")
```

Check the server accepts MULTIAPPEND

```ruby
> imap.can_multiappend?
```

Send two messages

```ruby
> m1 = Net::IMAP::Multiappend::Message.new("From: me\r\n\r\nHi 1\r\n")
> m2 = Net::IMAP::Multiappend::Message.new("From: me\r\n\r\nHi 2\r\n", flags: [:Seen])
> imap.multiappend("INBOX", [m1, m2])
```

Check they're there

```ruby
> imap.examine("INBOX")
> uids = imap.uid_search(["ALL"])
> imap.uid_fetch(uids.last(2), ["BODY[]", "FLAGS"])
```

## Development

After checking out the repo, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joeyates/net-imap-multiappend.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joeyates/net-imap-multiappend/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Net::IMAP::Multiappend project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joeyates/net-imap-multiappend/blob/main/CODE_OF_CONDUCT.md).
