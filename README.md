# 2Gaijin.com on Rails

2Gaijin.com just migrates the use of the website by utilizing Ruby on Rails 5.2.3 technology for hosting fast development with no downtime change

## Contents
* Getting Started
* More contents coming soon...

## Getting Started
- Ubuntu
    - Ubuntu Installation on Windows 10
- Installing Ruby 2.6.3 and Ruby on Rails 5.2.3
    - Ruby 2.6.3 Installation 
    - Ruby on Rails 5.2.3 Installation
- Installing and Configuring Git
    - Installing Git
    - Configuring Git
- Installing and Migrating Data to MongoDB
    - MongoDB Installation
    - MongoDB Data Migration
- Installing Redis Server
- Setting Up Ruby on Rails
    - Gems Bundle and Node Modules Installation
    - Credentials Configuration
    - Configuration for Local Development
        - MongoDB Connection Configuration
        - Redis Server Configuration

### Ubuntu
Ubuntu > 18.04 is recommended as we will use Ruby 2.6.3 and Ruby on Rails 5.2.3 that is released after Ubuntu 18.04. If you have your PC installed with Ubuntu 18.04, you can skip to the next section. This section is intended for Ubuntu installation on Windows 10.
#### Ubuntu Installation on Windows 10
**Windows 10 must be used** since the legitimate Ubuntu 18.04 installation for Windows is available for this version of Windows. If you already have Windows 10 as your main OS, you can follow the guide on the link below to install
##### [Installing Ubuntu on Windows 10](https://linuxconfig.org/how-to-install-ubuntu-18-04-on-windows-10)

### Installing Ruby 2.6.3 and Ruby on Rails 5.2.3
By the time this guide is written (November 11th 2019), Ruby 2.6.3 and Ruby on Rails 5.2.3 are used for web app development. The reason is at the start of the development (August 1st 2019), Ruby on Rails 6.0.0 is still on release candidate status. The steps on installing Ruby 2.6.3 and Ruby on Rails 5.2.3 will be explained on the following
#### Ruby 2.6.3 Installation
The first step is to install Ruby dependencies. To install the dependencies, you can run the following command
```bash
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
```
After the depedencies installation finishes, we can install Ruby. You can install Ruby using rbenv, rvm, or directly from the source. This guide will explain the step that should be taken to install Ruby using rbenv. Run the following command
```bash
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.6.3
rbenv global 2.6.3
ruby -v
```
Then install the bundler with the following command
```bash
gem install bundler
```
#### Ruby on Rails 5.2.3 Installation
Since Rails (especially in this project) uses so many dependencies, first step is to install NodeJS as the dependency manager that still abides with Rails' Assets Pipeline. To install NodeJS, simply run the command below
```bash
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```
And followed with Ruby on Rails installation by the following command
```bash
gem install rails -v 5.2.3
```
Since we use rbenv, we need to run the following command to make the rails executable available
```bash
rbenv rehash
```
Now that Rails has been installed on your PC, you can run the following command to check the Rails version
```bash
rails -v
```
### Installing and Configuring Git
Since we will use Git a lot for saving the progress of the project made so that everyone on the team can see the committed progress and to make changes on production server as well, Git will be hugely useful for the development. 
#### Installing Git
The installation can be started by running the following command
```bash
sudo apt-get update
sudo apt-get install git
```
Verify the installation by running the following command
```bash
git --version
```
#### Configuring Git
The following commands will set your git commit username and email address
```bash
git config --global user.name "Your Name"
git config --global user.email "youremail@yourdomain.com"
```
That is it for the Git configuration. You can clone this project to any folder you want by running the following command
```bash
git clone https://gitlab.com/kitalabs/rails-2gaijin.git
```
### Installing and Migrating Data to Local MongoDB
MongoDB as a NoSQL database is used to manage the data stored on 2Gaijin platform. The reason is its performance and scalability and you can make changes to the data structure of a model flexibly and in no time.
#### MongoDB Installation
The installation starts with importing the public key by the following command
```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 68818C72E52529D4
```
Then create source list by running this command
```bash
sudo echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
```
Then install MongoDB by running the following command
```bash
sudo apt-get update
sudo apt-get install -y mongodb-org
```
If the installation is successful, you can run the following command to start MongoDB on your PC
```bash
sudo service mongodb start
```
#### MongoDB Data Migration
The latest backup of 2Gaijin data was on November 7th 2019. The data is really useful for local development to perform debugging and to develop new features. The migration starts by first cloning the source file that contains dumped data by the following command
```bash
cd
git clone https://gitlab.com/kitalabs/rails-2gaijin-data-migration
```
Make sure you have your MongoDB running since we will use MongoDB command to migrate the data. Open MongoDB Console and create the database named **rails2gaijin_development** by running the following command
```bash
mongo console
use rails2gaijin_development
exit
```
After the database has been created, we can import the data by running the following command
```bash
cd
mongorestore --db rails2gaijin_development rails-2gaijin-data-migration/ --drop
```
That is pretty much it for the data migration to MongoDB

### Installing Redis Server
Redis is an in-memory key-value store that is used to accommodate the WebSocket connection used on the website to enable real-time data fetching from database (used for chat and notification). The complete installation for Redis can be performed by following the steps on this link
##### [Installing Redis on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04)
In order for the redis to work properly, a specific window of Ubuntu terminal must be provided. On a new Ubuntu terminal, run the Redis server by typing the command below
```bash
redis-server
```
Stay the window for redis open during the development

### Setting Up Ruby on Rails
Some of the configuration files are ignored due to the differences the configuration need to be performed on Production and Development Environment. In this case, the database, and the credentials configurations are different and would not be committed 
