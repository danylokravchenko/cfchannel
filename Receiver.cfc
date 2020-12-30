component accessors="true" displayname="Receiver" hint="Implementations of the receive side of the channel" {

    // Shared state of the channel
    property name="shared";
    // Inner.queue copy to prevent extra lock
    property name="buffer";


    /**
    * Create new Receiver
    * @returns Receiver
    */
    public Receiver function init(required Shared shared) {
        variables.shared = shared;
        variables.buffer = createObject("java", "java.util.ArrayDeque");
        return this;
    }


    /**
    * Receive item from the channel
    * @returns item or null if there are no senders
    */
    public any function recv() {
        if (!variables.buffer.isEmpty()) {
            return variables.buffer.removeFirst();
        }

        var mutex = variables.shared.getMutex();

        try {
            mutex.lock();

            var inner = variables.shared.getInner();

            // if there are no senders there is no need to wait
            if (inner.getSenders() == 0) {
                return javacast("null", "");
            }

            // wait for items in the channel
            while (inner.getQueue().isEmpty()) {
                variables.shared.getAvailable().await();
                inner = variables.shared.getInner();
                // if there are no senders there is no need to wait more
                if (inner.getSenders() == 0) {
                    return javacast("null", "");
                }
            }

            variables.buffer = inner.getQueue().clone();

            inner.setQueue(createObject("java", "java.util.ArrayDeque"));

            return variables.buffer.removeFirst();
        }
        finally {
            mutex.unlock();
        }
    }


    /**
    * Execute function for each item in the channel
    * @f function to apply
    */
    public void function forEach(required function f) {
        while (true) {
            var next = recv();
            if (isNull(next)) {
                break;
            }
            f(next);
        }
    }

}
