require 'line/bot'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #protect_from_forgery with: :null_session
  #before_filter :basic

  #  For Line
  #  before_action :validate_signature
  #
  #  def validate_signature
  #    body = request.body.read
  #    signature = request.env['HTTP_X_LINE_SIGNATURE']
  #    unless client.validate_signature(body, signature)
  #      error 400 do 'Bad Request' end
  #    end
  #  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = 'a6d984f5eb9e6aaf8da518757c6f43e9'
      config.channel_token = '3Pz7B0d5DzzVndFPsA6hMkQerbpd0fERm7O1NzpW80M5KhI6KpAGQPYxzjE7R0fXa3vLqHbYhLWRet8fXlkdf4GaKrfsQKaTzgh8Fu9cnqR+wiHMOJ5mzzLUVeLXuaT7yuFxgCiq6Kd19TVj8ZnxQAdB04t89/1O/w1cDnyilFU='
      }
  end

  private
    def basic
      authenticate_or_request_with_http_basic do |user, pass|
        user == 'kousei' && pass == '20160603'
      end
    end
end
