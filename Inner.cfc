component accessors="true" displayname="Inner" hint="Channel data holder" {

    // Number of available senders at the moment
    property name="senders" default="0";
    // Deque to hold items in the channel
    property name="queue";

    /**
    * Create new Inner
    * @returns Inner
    */
    public Inner function init() {
        variables.senders = 1;
        variables.queue = createObject("java", "java.util.ArrayDeque");   // or java.util.concurrent.ConcurrentLinkedDeque
        return this;
    }


    /**
    * Increment number of senders
    */
    public void function incSenders() {
        variables.senders++;
    }


    /**
    * Decrement number of senders
    */
    public void function decrSenders() {
        variables.senders--;
    }


    /**
    * Push item to the end of the queue
    */
    public void function push(required any item) {
        variables.queue.offerLast(item);
    }

}
