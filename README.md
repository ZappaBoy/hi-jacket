# hi-jacket
Hi-Jacket - A GPU cryptojacker script

# Getting Started
First of all clone the repository
```shell
git clone https://github.com/ZappaBoy/hi-jacket.git
cd hi-jacket
```
## Run testing environment
Run the testing enviroment through `docker-compose`.
```shell
cd ./remote-control
chmod +x ./run-test-environment.sh
./run-test-environment.sh
```
This will run a `DVWA` instance with its `mysql` database in two containers. 
After this, it will automatically run the dispatcher server (`dispatcher.py`).

# Use the remote control
Before running the remote control you need to define the attack targets in the `remote-control/sites-urls.txt`.
Simply edit the file using tabs as spacer:

1. Insert in the first column the attack method, you can choose between `GET` `POST` `ALL` `AUTO` `DEFAULT`;
2. In the second column insert the base url of the attack;
3. In the third column insert the string prams for the `GET` methods and the body for the `POST` one;
4. (optional) In the last column you can insert the cookies such as the `PHPSESSID`.

You can also use the hashtag (#) to comment a line and avoid the execution of the attack on that target.
Here is an example:

```shell
GET         http://xss-game.appspot.com                                     /level1/frame?query=XSS
POST        http://localhost:8060/vulnerabilities/xss_s/index.php           txtName=hijacked&mtxMessage=XSS&btnSign=Sign+Guestbook      PHPSESSID="YOURPHPSESSID;;security=low"
ALL         http://localhost:8060/vulnerabilities/xss_s/index.php
AUTO        http://xss-game.appspot.com                                     /level1/frame?query=XSS
DEFAULT     http://xss-game.appspot.com                                     /level1/frame?query=XSS
# This is a comment. The following line is ignored.
# GET     http://xss-game.appspot.com                                     /level1/frame?query=XSS
```

# Run the attack
Once defined the targets you can run the attack using the `remote-control.sh`
```shell
chmod +x ./remote-control.sh
./remote-control.sh -s -i -p very-danger-payload.txt
```

