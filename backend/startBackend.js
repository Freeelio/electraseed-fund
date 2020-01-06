const strapi = require('strapi');
strapi().start();

// pm2 start startApi.js
// run strapi in the background otherwise stops working when i log off.
