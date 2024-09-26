module MyModule::FreelanceMarketplace {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct Job has store, key {
        employer: address,
        freelancer: address,
        payment_amount: u64,
        is_completed: bool,
    }

    // Function to post a job
    public fun post_job(account: &signer,freelancer: address, payment_amount: u64) {
        let employer = signer::address_of(account);
        let job = Job {
            employer,
            freelancer,
            payment_amount,
            is_completed: false,
        };
        move_to(account, job);
    }

    // Function to complete a job and release payment
    public fun complete_job(employer: &signer) acquires Job {
        let job = borrow_global_mut<Job>(signer::address_of(employer));

        // Ensure the job is not already completed
        assert!(!job.is_completed, 1);

        // Transfer payment to freelancer
        coin::transfer<AptosCoin>(employer, job.freelancer, job.payment_amount);

        // Mark job as completed
        job.is_completed = true;
    }
}
