# Proof of Concept - DMP1.5 Task architecture

Supporting ticket: https://crowncommercialservice.atlassian.net/browse/GMBP-177

The DMP1.5 (and 1.0) task architecture is as follows: a Supervisord task which runs Nginx, uWSGI and awslogs. Some points about this:

* We do not require an awslogs router task anymore, rather just to write the logs to stdout / stderr and let Docker and the ECS-included awslogs driver route these naturally to CloudWatch Logs
* Supervisord is a poor task manager for an ECS task because it maintains the pretence of a healthy container even when a sub-process (e.g. uWSGI) has died (zombie tasks are pretty common in this case)

We must therefore arrive at an alternative architecture for the ECS Tasks - This POC is to investigate that.
