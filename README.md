# cfchannel implementation in CFML

---

This module introduces MPSC channels for CFML.

[![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/tested-with-testbox.svg)](https://cfmlbadges.monkehworks.com)
[![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/tested-on-production.svg)](https://cfmlbadges.monkehworks.com)
[![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/modernize-or-die.svg)](https://cfmlbadges.monkehworks.com)
[![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/compatibility-lucee-5.svg)](https://cfmlbadges.monkehworks.com)
[![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/made-with-cfml.svg)](https://cfmlbadges.monkehworks.com)

## Authors

Developed by Danylo Kravchenko (aka UndeadBigUnicorn)

- https://github.com/UndeadBigUnicorn
- kravchel16@gmail.com

---


## Requirements

This package requires Lucee 5+.

## Examples

The module provides API for using MPSC channels in CFML. Here's a simple example of usage:

``` js
// create new unbounded channel
var channel = new Channel();
var tx = channel.getSender();
var rx = channel.getReceiver();

// since it MPSC channels, it is possible to clone sender
var clonedTx = tx.clone();

// send values into the channel
tx.send("a");
clonedTx.send("b");

// receive values
assert(rx.recv(), "a");
assert(rx.recv(), "b");

// next call of rx.recv() will block a current thread until new values will be send into the channel
// rx.recv();
```

Sender part of the channel could be closed and receiver is able to handle such cases. See the example below

``` js
var channel = new Channel();
var tx = channel.getSender();
var rx = channel.getReceiver();

// close sender part
tx.close();

// receiver returns null if there are 0 senders available
assert(isNull(rx.recv()));
```

MPSC channels are created for concurrent usage and example below show simple example:
```js
var channel = new Channel();
var tx = channel.getSender();
var rx = channel.getReceiver();

// create new thread to send values
thread action="run" name="#CreateUUID()#" tx = "#tx#" {
    for (var i = 0; i < 5; i++) {
        tx.send(i);
    }
}

// create new thread to receive values
thread action="run" name="#CreateUUID()#" rx = "#rx#" {
    // execute a function for each item in the channel
    rx.forEach((item) => WriteLog(type="information", text="#item#"));
}
```




# CommandBox Compatible

## Installation
This CF module can be installed as standalone or as a ColdBox Module. Either approach requires a simple CommandBox command:

`box install cfchannel`

Then follow either the standalone or module instructions below.

### Standalone
This wrapper will be installed into a directory called `cfchannel` and then can be instantiated via `new cfchannel.Channel()`.

### ColdBox Module
This package also is a ColdBox module as well.
Then you can leverage the CFC via the injection DSL: `cfchannel@cfchannel"`

## Useful Links

- https://en.wikipedia.org/wiki/Channel_(programming)
