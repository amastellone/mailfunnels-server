#SERVER - Seeds.rb

# Order
order_create_hook    = Hook.create(name: 'Customer purchased product', identifier: 'order_create')

# Refund
refund_create_hook    = Hook.create(name: 'Customer refunded product', identifier: 'refund_create')
