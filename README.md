# Checkout

To install:

    bundle

To run the tests:

    bundle exec rspec

## Explanation for some design decisions

The decision to use ActiveModel, rather than implementing these models as pure Ruby was primarily to get access to the hashlike constructors (and also some validation) which would make it easier to replace these models with an ORM like ActiveRecord in the future.

Prices are always stored as an integer number of "cents" (the currency-independent name is chosen intentionally) because money is really an integer amount and we don't want to be subject to float errors. We use the Money gem to render the amounts as '£x.xx' because it's likely we'd need this functionality in a real system.

The classes Product, GlobalDiscount and BulkDiscount are ever-so-slightly cumbersome (the discount rules could just be a hash) because it makes them more like models in case we want them to be backed by a database in a future release. Storing all the rules in the checkout from the outset would require a much bigger refactor when that time comes.

The Checkout class is lightweight and doesn't look like a model (for example, it uses actual objects as keys in its in internal hashes, rather than their IDs). This is because in a real system, the Checkout is likely to be an ephemeral object and not necessarily stored in the database, so any design decisions about how to store the data here would be premature.

In the tests (checkout_spec.rb) I add a couple of additional discounts outside of the thresholds of the tests in checkout.md - that allows me to test that having multiple discounts active at the same time works (e.g. they're not double-applied) while still allowing the three test cases in the checkout.md file to pass as expected.
