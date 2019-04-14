---
title: Customizing the login page
slug: kibana-login-customizing
category: kibana-authentication
order: 250
layout: docs
edition: community
description: How to customize the Kibana login page with your own logo, corporate identity and messages.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Customizing the login page
{: .no_toc}

You can fully customize the login page to adapt it to your needs. Per default, the login page shows the following elements:

<p align="center">
<img src="
kibana_customize_login.jpg" style="width: 40%" class="md_image"/>
</p>

Use the following setting in kibana.yml to customize one or more elements:

| Name | Description |
|---|---|
| searchguard.basicauth.login.showbrandimage | boolean, show or hide the brand image, Default: true|
| searchguard.basicauth.login.brandimage | String, `src` of the brand image. Should be an absolute URL to your brand image, e.g. `http://mycompany.com/mylogo.jpg`.|
| searchguard.cookie.name | String, name of the cookie. Default: 'searchguard_authentication' |
| searchguard.basicauth.login.title | String, title of the login page. Can contain HTML tags|
| searchguard.basicauth.login.subtitle | String, subtitle of the login page. . Can contain HTML tags|
| searchguard.basicauth.login.buttonstyle | String, style attribute of the login button. |