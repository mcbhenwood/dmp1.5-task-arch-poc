# Proof of Concept - DMP1.5 Task architecture

Supporting ticket: https://crowncommercialservice.atlassian.net/browse/GMBP-177

## Rationale

The DMP1.5 (and 1.0) task architecture is as follows: a Supervisord task which runs Nginx, uWSGI and awslogs. Some points about this:

* We do not require an awslogs router task anymore, rather just to write the logs to stdout / stderr and let Docker and the ECS-included awslogs driver route these naturally to CloudWatch Logs
* Supervisord is a poor task manager for an ECS task because it maintains the pretence of a healthy container even when a sub-process (e.g. uWSGI) has died (zombie tasks are pretty common in this case)

We must therefore arrive at an alternative architecture for the ECS Tasks - This POC is to investigate that.

## Initialise Terraform and backend

1. Copy file local.tfbackend.example to local.tfbackend. Edit the file to refer to the state bucket and table names. (This file is ignored by Git version control so you do not accidentally check your own settings into the repo.)

2. Now we are into the standard workflow for Terraform, although *note the need to stipulate the backend config file*:
   ```bash
   terraform init -backend-config=local.tfbackend
   ```

   If Terraform prompts you for a bucket / table name, you have missed off the `-backend-config=local.tfbackend` argument above.

## Summary of architecture

Two containers: one running Nginx, forwarding requests onto the other container which is running uWSGI in http-socket mode.

There are two types of service: API and Frontend. They differ slightly as follows:

### API

* Nginx: Simple proxy pass of all requests to the appropriate port on the uWSGI container

### Frontend

* Nginx: As for API except that we include static files within the Docker build and serve these directly from the Nginx local file system. (Previously the architecture worked on the basis that both Nginx and uWSGI ran on the same container and so Nginx was able to access the file tree for the WSGI app. In separated containers this will of course no longer be the case).
