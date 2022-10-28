server {
	listen 80;
	server_name rsetsite.com www.rsetsite.com;
	return 302 https://rsetsite.com;
}

server {
	listen 443 ssl;
	server_name rsetsite.com www.rsetsite.com;
	include snippets/self-signed.conf;
	include snippets/ssl-params.conf;
	root /var/www/rsetsite.com;
	index index.html index.htm;
	
	location / {
		try_files $uri $uri/ =404;
		auth_basic	"Basic Authenthication";
		auth_basic_user_file /etc/nginx/.htpasswd;
	}
}
	
