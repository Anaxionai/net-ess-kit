# Security groups: one per tier, no inline rules. Every rule is its own resource and matches a row of ACCESS.md.

# TODO(task 9): groups "web" and "app" in the VPC, and only the rules your traffic matrix allows:
#               the internet to web, web to app, and web's way out. app gets no egress rule yet.

# TODO(task 17): group "alb", its rules, and the app rule changed to come from alb instead of web.

# TODO(task 19): group "endpoints" (TCP 443 in from app), and app's two egress rules on 443:
#               to the S3 endpoint's prefix list and to the endpoints group.
