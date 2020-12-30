component accessors="true" displayname="Channel" hint="Implementations of the unbounded channel" {

    property name="sender";
    property name="receiver";

    /**
    * Crate new unbounded channel
    */
    public Channel function init() {
        var shared = new Shared();
        variables.sender = new Sender(shared);
        variables.receiver = new Receiver(shared);

        return this;
    }

}
