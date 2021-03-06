
# OmniAuth Intercom

Intercom OAuth2 Strategy for OmniAuth.

Supports the OAuth 2.0 server-side and client-side flows. Read the [Intercom OAuth docs](https://developers.intercom.io/reference#oauth) for more details:

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-intercom'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Intercom` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :intercom, ENV['INTERCOM_KEY'], ENV['INTERCOM_SECRET']
end
```
To start the authentication process with Intercom you simply need to access `/auth/intercom` route.
You can start the authentication process directly with the signup page by accessing `/auth/intercom?signup=1`

**Important** You need the `read_admins` permissions to use this middleware.   
**Important** Your `redirect_url` should be `/auth/intercom/callback`

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'intercom',
  :uid => '342324',
  :info => {
    :email => 'kevin.antoine@intercom.io',
    :name => 'Kevin Antoine'
  },
  :credentials => {
    :token => 'dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=', # OAuth 2.0 access_token, which you may wish to store
    :expires => false
  },
  :extra => {
    :raw_info => {
      :name => 'Kevin Antoine',
      :email => 'kevin.antoine@intercom.io',
      :type => 'admin',
      :id => '342324',
      :app => {
        :id_code => 'abc123', # Company app_id
        :type: 'app'
      }
      :avatar => {
        :image_url => "https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491"
      }
    }
  }
}
```

### Intercom Button / Popup authentication

To use `Intercom Button` to display authentication in a popup it is simple :

- Add the following code in the html file in which you want to start to authenticate with Intercom ( `/views/home/index.html.erb` if you want to authenticate with Intercom in `home#index`)

```html
<a href="javascript:void(0)" class="intercom-oauth-cta">
  <img src="https://static.intercomassets.com/assets/oauth/primary-7edb2ebce84c088063f4b86049747c3a.png" srcset="https://static.intercomassets.com/assets/oauth/primary-7edb2ebce84c088063f4b86049747c3a.png 1x, https://static.intercomassets.com/assets/oauth/primary@2x-0d69ca2141dfdfa0535634610be80994.png 2x, https://static.intercomassets.com/assets/oauth/primary@3x-788ed3c44d63a6aec3927285e920f542.png 3x"/>
</a>
<script type="text/javascript">
$('.intercom-oauth-cta').unbind('click').click(function() {
	var auth_window = window.open('/auth/intercom', 'Sign in', 'width=700,height=450');
	var checkWindow = function() {
	  if (auth_window.closed) {
      window.location = '/';
	  } else if (window.oauth_success === undefined) {
	    setTimeout(checkWindow, 200);
    }
	};
  checkWindow();
});
</script>
```

Create a `views/home/intercom_callback.html.erb` file ( if your callback route is `home#intercom_callback`)

```html
<html>
  <head>
    <title>Authorized</title>
  </head>
  <body>
    <script type="text/javascript">
      setTimeout(function() {
        if (window.opener) {
          window.opener.oauth_success = true;
        }
        window.close();
      }, 1000);
    </script>
  </body>
</html>
```


### Example application

[testapp-intercom-omniauth](https://github.com/Skaelv/testapp-intercom-omniauth) is a simple application implementing the authentication process with Intercom with a popup display.
