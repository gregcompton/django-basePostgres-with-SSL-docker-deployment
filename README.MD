The goal of this project is to develop a comprehensive project template that includes:
- [x] Deployment to a server using Docker containers (completed) :heavy_check_mark:
- [x] SSL (completed) :heavy_check_mark:
  - [ ] Automate certificate renewal (todo: see 
["Handling Renewals"](https://londonappdeveloper.com/django-docker-deployment-with-https-using-letsencrypt/)
at the bottom of the page)
- [x] All deploy settings set via environmental variables (completed) :heavy_check_mark:
- [x] Django with a Hello World home page (completed) :heavy_check_mark:
- [x] Postgres database (completed) :heavy_check_mark:
- [ ] Celery (up next)
- [ ] Redis(up next)

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
	- github repo: https://github.com/gregcompton/deploy-django-with-LetsEncrypt
- Django Celery Docker Playlist by VERY ACADEMY
	- playlist: https://youtube.com/playlist?list=PLOLrQ9Pn6cayGytG1fgUPEsUp3Onol8V7&si=AcASkX2e2hkwZJd6
	- PyCharm project: django_celery_docker_VERYACADEMY
	- github repo: none

As of 10/23/23 I am using a Linode Ubuntu 22.04 LTS jammy server and [gregcompton.com](https://gregcompton.com) domain to test deployment templates.

# HOW TO DEPLOY THIS REPOSITORY

For better instructions, go to the "Create a Server" section of the [London App Developer 
Tutorial](https://anvilproject.org/guides/content/creating-links#creating-links-in-markdown) and follow the instructions.

Requirements
- domain: e.g. gregcompton.com
- server exposed to the internet. SSL cert won't work on a local network.
- server with docker engine and docker compose (google or ask ChatGPT for instructions on how to install these)

## Step 1: Set up your server. 
If you don't know how, this repository is NOT for you :-)

## Step 2: Point your domain to the server (A Record)
This is a good time to point your domain to your server's ip address so that the change has time to propagate. 
I don't believe SSL cert will succeed until DNS propagation is complete (I might be wrong though). 

Note: I am using linode nameservers and deploying to a Linode server, so the process was nearly instantaneous for me. Your mileage may vary. 

## Step3: Clone the repository to your server. 

	sudo git clone https://github.com/gregcompton/django-basePostgres-with-SSL-docker-deployment.git

## Step 4: Setup the environmental variables file
- Go to the directory containing the project files. 

		cd django-basePostgres-with-SSL-docker-deployment
- Create a `.env` file by copying the sample 

        sudo cp .env.sample .env
- Edit the `.env` file and change settings per the project needs  

        sudo nano .env
  - SECRET KEY = a jumble of characters. Use keygen for production
  - DOMAIN = yourdomain.com
  - ACME EMAIL = your email address
  - DB -> make these secure for production (for testing I use: dbname, rootuser, supersecretpassword)

  *Note: "ctrl+x" then "y" to save or "n" exit without saving*

## Step 4b (optional): Put your info on the home page
You might want to change the default home page as it has my info.

	sudo nano app/home/templates/home/index.html

## Step 5: Get the first certificate
This process can take a while...up to a minute in my experience

	docker compose -f docker-compose.deploy.yml run --rm certbot /opt/certify-init.sh

### STOP then START the service so that the application is served via https
- `sudo docker compose -f docker-compose.deploy.yml down`
- `sudo docker compose -f docker-compose.deploy.yml up`
  - OR `sudo docker compose -f docker-compose.deploy.yml up -d`  # Add -d to run in the background


  *Note: I like to run services in the foreground until I am sure that they are working*

## Step 5b: Create a database super user
The first time the database service is started (**and every time it is rebuilt**) a superuser will need to be created

	sudo docker compose -f docker-compose.deploy.yml run --rm app sh -c "python manage.py createsuperuser"

## Step 6: Verify everything is working properly
- Go to https://yourdomain.com and you should see the home page.
- Now go to https://youdomain.com/admin and login using the superuser credentials created earlier.
- Go to the Samples model, upload a file, save, then click the file link to verify that static files are being handled properly

## Step 7: Make changes to the app once it is deployed
The whole idea is to use this as a quickstart jumping off point to start developing an app/website/whatever. 
So, as you edit the project, run these commands to update only the app service without bringing down the proxy or 
database services

- `sudo docker compose -f docker-compose.deploy.yml build app`
- `sudo docker compose -f docker-compose.deploy.yml up --no-deps app` 
  - OR `sudo docker compose -f docker-compose.deploy.yml up --no-deps -d app`    # Add -d to run in the background

## Step 8: Setup cronjob to automate certificate renewal
*todo: see 
["Handling Renewals"](https://londonappdeveloper.com/django-docker-deployment-with-https-using-letsencrypt/)
at the bottom of the page*


