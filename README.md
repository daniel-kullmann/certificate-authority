# Simple way to create your own certificate authority

This is for development purposes, if you are tired of the "invalid certificate"
warnings in browsers. This happens when you use server certificates that are not
signed by a known certificate authority (CA).

Quick usage:

```
./generate-server-key.sh server-name
```

This will create a CA key and CRT if there is none, asking you for a name of
that CA (The name is not really important, but it is nice to choose your own).

In subsequent calls, that CA will be re-used. Remove
`./certificate-authority.conf` if you want to create a new one.

Then, a key, certificate signing request and certificate for the server
"server-name" will be created.

For both CA ertificate and server certificate, you will be asked for some values.
You can leave most of them blank; only the "Common Name" setting for the server
certificate is really important; it must be the name of the server (e.g. my-server.local).

To actually use the generated certificate, you must do two things:
* Make the certificate of the CA known to the applications that want to check
  the server certificate, e.g. Firefox. You can import the certificate in
  Firefox by going to settings, section "Certificate", click on button "View
  Certificates", choose tab "Authorities", click button "Import.." and choose
  the ca.crt file.
* Make your web server use the server certificate. Consult the docs of your web
  server for how to do it; e.g. for Nginx, the `server` section will look something
  like this (replace "my-server.local" with your server name, and copy the 
  `my-server.local.crt` and `my-server.local.key` files to `/etc/nginx/ssl`):
```
server {
    listen              443 ssl;
    listen              [::]:443 ssl;
    server_name         my-server.local;
    keepalive_timeout   70;

    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         AES128-SHA:AES256-SHA:RC4-SHA:DES-CBC3-SHA:RC4-MD5;
    ssl_certificate     /etc/nginx/ssl/my-server.local.crt;
    ssl_certificate_key /etc/nginx/ssl/my-server.local.key;
    ssl_session_cache   shared:SSL:10m;
    
    # More nginx configuration ...
}
```
* Tell your computer the IP of the server name that you used; the easiest way to
  do this is to add a line like the following (change `my-server.local` to your
  server name) to the `/etc/hosts` file:
```
127.0.1.2 my-server.local
```

