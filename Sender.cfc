component accessors="true" displayname="Sender" hint="Implementations of the send side of the channel" {

    // Shared state of the channel
    property name="shared";


    /**
    * Create new Sender
    * @returns Sender
    */
    public Sender function init(required Shared shared) {
        variables.shared = shared;
        return this;
    }

    /**
    * Clone Sender side of the channel, but DO NOT clone shared state of it
    * This function pass shared state of the channel into new cloned Sender
    * @returns cloned instance of existing Sender
    */
    public Sender function clone() {
        var mutex = variables.shared.getMutex();

        try {
            mutex.lock();

            variables.shared.getInner().incSenders();

            return new Sender(variables.shared.clone());
        }
        finally {
            mutex.unlock();
        }
    }


    /**
    * Close this Sender, notify others
    */
    public void function close() {
        finalize();
    }

    /**
    * Drop Sender side of the channel, notify others
    */
    void function finalize() {
        var mutex = variables.shared.getMutex();

        try {
            mutex.lock();

            var inner = variables.shared.getInner();
            inner.decrSenders();
            var wasLast = inner.getSenders() == 0;

            if (wasLast) {
                // notify receiver that there are no senders left
                variables.shared.getAvailable().signal();
            }
        }
        finally {
            mutex.unlock();
        }
    }


    /**
    * Send item into the channel
    */
    public void function send(required any item) {
        var mutex = variables.shared.getMutex();

        try {
            mutex.lock();

            var inner = variables.shared.getInner();
            inner.push(item);

            // notify receiver about a new item in the channel
            variables.shared.getAvailable().signal();
        }
        finally {
            mutex.unlock();
        }
    }

}
