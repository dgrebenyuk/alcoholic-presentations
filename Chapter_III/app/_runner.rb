# frozen_string_literal: true

customer = Customer.new({ email: 'john@example.com' })
customer.increase_balance(105)
# customer.buy_a_car

developer = Developer.new({ name: 'Tom', email: 'tom@gmail.com' })
developer.customers = [customer]
developer.can_fix?

devops = Devops.new({ name: 'Frank' })
devops.can_support?

customer.assign_supporter(devops)
