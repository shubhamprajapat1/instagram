# Instagram
The [Instagram Basic Display API](https://developers.facebook.com/docs/instagram-basic-display-api) allows users of your app to get basic profile information, photos, and videos in their Instagram accounts.
The API can be used to access any type of Instagram account but only provides read-access to basic data.

## Source
- [Facebook developers docs](https://developers.facebook.com/docs/instagram-basic-display-api)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'insta'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install insta

## Usage
##### Step 1: Authorization Window URL
Construct the Authorization Window URL below, replacing {app-id} with your Instagram app’s ID (from the App `Dashboard > Products > Instagram > Basic Display > Instagram App ID field`), replacing {app-secret} with your Instagram app’s ID (from the App `Dashboard > Products > Instagram > Basic Display > Instagram App Secret`) and {redirect-uri} with your website URL that you provided in Step 2 (`Valid OAuth Redirect URIs`). The URL must be exactly the same.
```sh
> options = { redirect_uri: `redirect-uri`, client_id: `app-id`, client_secret: `app-secret` }
> client = Insta::Client.new(options)
> client.auth_url 
    # output: 
    # https://api.instagram.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=code
```
Authenticate your Instagram user by signing into the Authorization Window, then click Authorize to grant your app access to your profile data. Upon success, the page will redirect you to the redirect URI you included in the previous step and append an Authorization Code. For example:

`https://socialsizzle.herokuapp.com/auth/?code=AQDp3TtBQQ...#_`

Note that `#_` has been appended to the end of the redirect URI, but it is not part of the `code` itself. Copy the code (without the `#_` portion) so you can use it in the next step.

##### Step 2: Exchange the Code for a Token
code => ....auth/?`code=AQDp3TtBQQ...`#_
```sh
> client.access_token(code)
# output:
# {
#    "access_token": "IGQVJ...",
#    "user_id": 17841405793187218
# }
```
##### Step 3: Exchange a short-lived Instagram User Access Token for a long-lived Instagram User Access Token.
 long-lived valid only 60day 
```sh
    > access_token = "IGQVJ..."
    > client.long_lived_access_token(access_token)
    # output:
    # {
    #   "access_token": "{access-token}",
    #   "token_type": "{token-type}",
    #   "expires_in": {expires-in}
    # }
```

##### Step 4: User Info, Media Data

- create new client
```sh
    > access_token = "IGQVJ..."
    > client = Insta::API.new(access_token)
```
- user info
```sh
    > client.me
```
- user media
```sh
    > client.media
    > # or
    > client.media(25)
    > # for pagination after above method call, run below method for getting next 25 media
    > client.next_page
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
