The goal of this project is to develop a comprehensive project template that includes:
- Deployment to a server using Docker containers (completed)
- SSL (completed)
- All deploy settings set via environmental variables (completed)
- Django with a Hello World home page (completed)
- Postgres database (completed)
- Celery (up next)
- Redis(up next)

This project template can be cloned from github as a baseline and easily extended to create private projects

Tutorials followed toward this goal
- Deploying Django with Docker Compose
	- video: https://www.youtube.com/watch?v=mScd-Pc_pX0
	- blog: https://londonappdeveloper.com/deploying-django-with-docker-compose/
	- PyCharm project: deploy-django-with-docker-compose
	- github repo: https://github.com/gregcompton/deploy-django-with-docker-compose
- Django Docker Deployment with HTTPS using Letsencrypt
	- video: https://www.youtube.com/watch?v=3_ZJWlf25bY
	- blog: https://londonappdeveloper.com/django-docker-deployment-with-https-using-letsencrypt/
	- PyCharm project: deploy-django-with-LetsEncrypt
	- github repo: 
- Django Celery Docker
	- video: https://www.youtube.com/watch?v=AQYnKn-i0q8&list=PLOLrQ9Pn6cayGytG1fgUPEsUp3Onol8V7
	- PyCharm project: django_celery_docker_VERYACADEMY
	- github repo: none

As of 10/23/23 I am using a Linode Ubuntu 22.04 LTS jammy server and gregcompton.com domain to test deployment templates.

HOW TO DEPLOY THIS REPOSITORY

For better instructions, go to the "Create a Server" section of the [London App Developer 
Tutorial](https://anvilproject.org/guides/content/creating-links#creating-links-in-markdown) and follow the instructions.

Requirements
- domain: e.g. gregcompton.com
- server exposed to the internet. SSL cert won't work on a local network.
- server with docker engine and docker compose (google or ask ChatGPT for instructions on how to install these)


Clone the repository to your server: 
You might want to change the default home page as it has my info on it 
```(app/app/home/templates/home/index.html)```

```git clone https://github.com/gregcompton/django-basePostgres-with-SSL-docker-deployment.git```

Then ```cd django-basePostgres-with-SSL-docker-deployment``` to get into the directory containing the project files.

Create a ```.env``` file by copying the sample ```cp .env.sample .env```

Edit the ```.env``` file and change settings per the project needs ```nano .env```

- SECRET KEY = a jumble of characters. Use keygen for production
- DOMAIN = <yourdomain.com>
- ACME EMAIL = <your email address>
- DB -> make these secure for production (for testing I use: dbname, rootuser, supersecretpassword)

GET THE FIRST CERTIFICATE (this process can take a while...up to a minute in my experience)
- ```docker compose -f docker-compose.deploy.yml run --rm certbot /opt/certify-init.sh```

STOP THEN START THE SERVICE SO THAT APPLICATION IS SERVED VIA HTTPS
- ```docker compose -f docker-compose.deploy.yml down```
- ```docker compose -f docker-compose.deploy.yml up```
- OR ```docker compose -f docker-compose.deploy.yml up -d```  # Add -d to run in the background

The first time the database service is started (and every time it is rebuilt) a superuser will need to be created

```docker compose -f docker-compose.deploy.yml run --rm app sh -c "python manage.py createsuperuser"```

VERIFY EVERYTHING IS WORKING PROPERLY
- Go to https://yourdomain.com and you should see the home page.
- Now go to https://youdomain.com/admin and login using the superuser credentials created earlier.
- Go to the Samples model, upload a file, save, then click the file link to verify that static files are being handled properly


MAKE CHANGES TO THE APP ONCE IT IS UP AND RUNNING

Run these commands to update only the app service without bringing down the proxy or database services

- ```docker compose -f docker-compose.deploy.yml build app```
- ```docker compose -f docker-compose.deploy.yml up --no-deps app```  
- OR ```docker compose -f docker-compose.deploy.yml up --no-deps -d app```    # Add -d to run in the background



