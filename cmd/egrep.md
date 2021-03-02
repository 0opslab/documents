find /webapp01/nginxlog/ -mmin -5 | xargs egrep -i '(cgi|manager|password|passwd|select.*from*|.*union.*|exec|runtime|bash|cmd=)'

find /webapp01/nginxlog/ -mmin -10 | xargs egrep -i '(cgi|manager|password|passwd|select.*from*|.*union.*|exec|runtime|bash|cmd=)'