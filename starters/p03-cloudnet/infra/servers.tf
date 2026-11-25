# The servers: Amazon Linux 2023, t3.micro, the skeleton's instance profile, no SSH key.

# TODO(task 9): data "aws_ssm_parameter" "al2023" for the Amazon Linux 2023 image.

# TODO(task 9): aws_instance "app" with count = 2, one per private subnet, the app group,
#               the instance profile, a Name tag per server, and user_data from ../app/app-init.sh.

# TODO(task 9): aws_instance "web" in public_a, the web group, the instance profile,
#               user_data_replace_on_change, and user_data from templatefile on ../app/web-init.sh
#               with site and upstream.

# TODO(task 9): aws_eip "web" for the web server.

# TODO(task 17): the web server's upstream becomes the load balancer.

# TODO(task 18): the web server's site becomes var.site_name.
