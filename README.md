# rb-dayone

A means to create DayOne entries in ruby.

## Examples

You can create an entry pretty simply:

    e = DayOne::Entry.new "# Hello, world!"
  
You can also set up other values via a hash:

    e = DayOne::Entry.new "I totally posted this an hour ago", creation_date: Time.now-3600

Otherwise, you can set values using simple accessor methods, as you'd expect:

    e = DayOne::Entry.new "I need to remember this."
    e.starred = true

When you're ready to save your entry, just run the `create!` method:

    e.create!

### Searching

You can now search your DayOne archives. Use the `DayOne::Search` object to start a search:

    s = DayOne::Search.new do
        entry_text.include "Foo" # Entry must have "foo" in the entry text
        entry_text.exclude "Bar" # Entry cannot have "bar" in the entry text
        tag.include "baz"        # Entry must be tagged "baz"
        tag.exclude "caz"        # Entry cannot be tagged "caz"
        starred.is true          # Entry is starred
        starred.is false         # Entry is not starred
        creation_date.after t    # Entry created after +t+
        creation_date.before t   # Entry created before +t+
    end

    s.results # Retrieve an array of search results

Most of these methods can be combined, e.g.:

    s = DayOne::Search.new do
        entry_text.include "Eggs"
        entry_text.include "Milk"
    end

This will only find posts that contain both the words "Eggs" and "Milk" in the entry text.

## Binary

Rb-dayone ships with a binary, `dayone`. Run `dayone --help` for instructions on how to use it.

## Install

    gem install rb-dayone

## Author

Original author: [Jan-Yves Ruzicka](http://www.1klb.com). Get in touch [via email](mailto:jan@1klb.com).