component accessors="true" displayname="Shared" hint="Shared state of the channel" {

    // Channel data holder
    property name="inner";
    // CondVar
    property name="available";
    // Mutex lock
    property name="mutex";


    /**
    * Create new Shared
    * @returns Shared
    */
    public Shared function init() {
        variables.mutex = createObject("java", "java.util.concurrent.locks.ReentrantLock");
        variables.inner = new Inner();
        variables.available = getMutex().newCondition();
        return this;
    }

    /**
    * Clone shared state of the channel
    * @returns cloned instance of existing Shared
    */
    public Shared function clone() {
        var shared = new Shared();
        shared.setInner(getInner());
        shared.setAvailable(getAvailable());
        shared.setMutex(getMutex());
        return shared;
    }

}
