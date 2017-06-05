#SERVER - Seeds.rb

# Order Hook
Hook.create(name: 'Customer Purchased Product', identifier: 'order_create')

# Refund Hook
Hook.create(name: 'Customer Refunded Product', identifier: 'refund_create')

# Abandoned Checkout "Hook"
Hook.create(name: 'Customer Abandoned Checkout', identifier: 'abandoned_checkout')