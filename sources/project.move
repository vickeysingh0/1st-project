module MyModule::AnonymousMessaging {
    use std::signer;
    struct Message has store, key {
        content: vector<u8>,
    }

    // Store the latest message in the contract
    public fun send_message(sender: &signer, content: vector<u8>) {
        // Store the message on the blockchain anonymously without recording sender
        move_to(sender, Message { content });
    }

    // Retrieve the message
    public fun get_message(account: &signer): vector<u8> acquires Message {
        let signer = signer::address_of(account);
        let msg = borrow_global<Message>(signer);
        msg.content
    }
}
