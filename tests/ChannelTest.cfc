component extends="testbox.system.BaseSpec" {

    function run() {

        describe( "Usage cases tests", function() {

            it( "clones", function() {
                var channel = new Channel();
                var sender = channel.getSender();
                var clonedSender = sender.clone();
                expect(clonedSender.getShared().getInner().getSenders()).toBe(sender.getShared().getInner().getSenders());
            });

            it( "sends", function() {
                var channel = new Channel();
                var sender = channel.getSender();
                var clonedSender = sender.clone();
                sender.send("a");
                clonedSender.send("b");
                expect(sender.getShared().getInner().getQueue().size()).toBe(2);
            });

            it( "receives", function() {
                var channel = new Channel();
                var sender = channel.getSender();
                var receiver = channel.getReceiver();
                sender.send(1);
                expect(receiver.recv()).toBe(1);
            });

            it( "not waits forever on closed sender", function() {
                var channel = new Channel();
                var sender = channel.getSender();
                var receiver = channel.getReceiver();
                for (var i = 0; i < 5; i++) {
                    sender.send(i);
                }

                sender.close();

                expect(isNull(receiver.recv())).toBeTrue();
            });

            it( "iterates", function() {
                var channel = new Channel();
                var sender = channel.getSender();
                var receiver = channel.getReceiver();

                thread action="run" name="#CreateUUID()#" sender = "#sender#" {
                    for (var i = 0; i < 5; i++) {
                        sender.send(i);
                    }
                }

                var success = false;
                var stop = false;
                var counter = 0;
                while (!stop) {
                    var next = receiver.recv();
                    if (isNull(next)) {
                        stop = true;
                    }
                    counter++;
                    if (counter == 5) {
                        stop = true;
                        success = true;
                    }

                }

                expect(success).toBeTrue();
            });

        });

    }

}
