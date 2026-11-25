# A network ACL for the private subnets: stateless, so every reply needs its own rule.

# TODO(task 10): aws_network_acl "private" for both private subnets, with the ingress rule for the app port
#                from the public subnets and the egress rule for the replies.

# TODO(task 17): the rules the internal load balancer needs.

# TODO(task 19): the rules the endpoints and package downloads need (ACLs cannot use prefix lists).
