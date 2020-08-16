require "insta/version"
require 'net/http'
require 'uri'
require 'json'

module Insta
  class Error < StandardError; end
  class Client
    attr_accessor :redirect_uri, :client_id, :client_secret, :scope
    def initialize(options = {})
      @redirect_uri  = options[:redirect_uri]
      @client_id     = options[:client_id]
      @client_secret = options[:client_secret]
      @scope         = options[:scope] || 'user_profile,user_media'
    end

    def auth_url
      "https://api.instagram.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=code"
    end

    def access_token(code = '')
      uri = URI.parse("https://api.instagram.com/oauth/access_token")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(
        "client_id" => client_id,
        "client_secret" => client_secret,
        "code" => code,
        "grant_type" => "authorization_code",
        "redirect_uri" => redirect_uri,
      )

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      response = JSON.parse(response.body)
      OpenStruct.new(response)
    end

    def long_lived_access_token(access_token)
      url = "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=#{client_secret}&access_token=#{access_token}"
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      response = JSON.parse(response.body)
      OpenStruct.new(response)
    end
  end
  class API
    attr_accessor :access_token, :next_url
    def initialize(access_token)
      @access_token  = access_token
      @next_url = nil
    end

    def me
      url = "https://graph.instagram.com/me?fields=account_type,media_count,username,id&access_token=#{access_token}"
      get(url)
    end

    def media(limit = 100)
      url = "https://graph.instagram.com/me/media?fields=id,media_type,caption,permalink,thumbnail_url,media_url,username,timestamp&access_token=#{access_token}&limit=#{limit}"
      response  = get(url)
      puts response.dig('paging', 'next')
      @next_url = response.dig('paging', 'next') unless response.dig('paging', 'next').nil?
      response
    end

    def next_page
      return {} if next_url.nil?
      response  = get(next_url)
      if response.dig('paging', 'next').nil?
        @next_url = nil
      else
        @next_url = response.dig('paging', 'next')
      end
      response
    end

    private

    def get(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      response = JSON.parse(response.body)
      OpenStruct.new(response)
    end
  end
end
