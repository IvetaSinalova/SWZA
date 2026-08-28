# Password protection for preview

These files are for protecting the preview deployment with HTTP Basic Auth.

## Where to upload

- Upload `auth/.htaccess` as `startupweekendzilina.sk/web/preview/.htaccess`.
- Upload the real `.htpasswd-preview` as `startupweekendzilina.sk/.htpasswd-preview`.

Keep `.htpasswd-preview` outside the `web` folder.

## How to find the absolute server path

Deploy the site once with `public/path.php`, then open:

```text
https://www.startupweekendzilina.sk/preview/path.php
```

It prints the absolute path to the preview directory. Use that path to update `AuthUserFile` in `auth/.htaccess`.

Example:

```apache
AuthUserFile /data/u/u/uuid/startupweekendzilina.sk/.htpasswd-preview
```

After the path is known, delete `public/path.php` from the project and from the server.

## How to create the password file

Use an htpasswd generator and create one user, for example:

```text
preview
```

Save the generated line into `.htpasswd-preview`.
