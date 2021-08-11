sudo apt update        && \
sudo apt install python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface -y &&\
sudo apt install python3-certbot-nginx -y       &&\
sudo certbot --nginx -d web-streamer-main.mykenshomedia.com.au &&\        
sudo certbot renew --dry-run