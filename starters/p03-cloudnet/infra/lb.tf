# The internal Application Load Balancer in front of the app servers.

# TODO(task 17): aws_lb "app" (internal, application, both private subnets, the alb group),
#                aws_lb_target_group "app" with its health check, an attachment per app server,
#                and an aws_lb_listener on port 80.
