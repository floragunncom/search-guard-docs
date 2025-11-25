---
title: Customizing the login page
html_title: Customizing the Search Guard Kibana Plugin login page
permalink: kibana-login-customizing
layout: docs
edition: community
description: How to customize the Kibana login page with your own logo, corporate
  identity and messages.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Customizing the login page
{: .no_toc}

You can fully customize the login page to adapt it to your needs. Per default, the login page shows the following elements:

<p align="center">
<img src="
kibana_customize_login.jpg" style="width: 40%" class="md_image"/>
</p>

You can use `sg_frontend_authc` to customize the login page. Such a configuration can look like this:

```yaml
default:
  login_page:
    brand_image: "https://mycompany.example.com/mylogo.png"
    title: "<blink>Hello!</blink>"
    button_style: "background-color: green"
  authcz:
  - type: basic
```

Alternatively, you can use base64 encoded image string using the following configuration:

```yaml
default:
  login_page:
    brand_image: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAT4AAABVCAQAAAB6dUCWAAAAIGNIUk0AAHomAACAhAAA+gAAAIDoAAB1MAAA6mAAADqYAAAX..."
```

These options are available:

**login_page.brand_image:** An absolute URL to your brand image.

**login_page.show_brand_image:** Set this to `false` when you want to have no brand image at all on the login page.

**login_page.title:** Title of the login page. Can contain HTML tags.

**login_page.button_style:** Style attribute of the login button.
