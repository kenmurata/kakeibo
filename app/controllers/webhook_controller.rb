require 'date'

class WebhookController < ApplicationController

  protect_from_forgery :except => [:sample]

  def callback

    body = request.body.read
    events = client.parse_events_from(body)
    echo_usage = "使い方\n\n----------\n支出\n{分類}\n{金額}\n{使途}\n{日時} ※省略可\n\n例\n------------\n支出\n住宅費用\n100000\n家賃\n2018-01-01"

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text

          # POSTされたテキストの内容をパース
          post_message = event.message['text']

	  # テキストの内容が支出登録か収入登録か確認
	  if post_message =~ /支出/
                
                # 入力データを改行で区切って配列にパース
                data = post_message.lines

                ### 機体する入力値は
                # 支出
                # {分類}*
                # {金額}*
                # {使途}*
                # {日時} (省略した場合、今日)
                #if data.length == 4 || data.length == 5
          	bunrui = data[1].chomp
          	price = data[2].chomp.to_i
		use = data[3].chomp

		# 日時は省略可なので、なければ当日の日付を取得
		if data[4] == nil
			date = Date.today
		else
			# 正しい形式で来ているかはDate形式でparseできるかで判断
			if date_valid?(data[4].chomp)
				date = Date.parse(data[4].chomp)
			else
				# できなかった場合は文字列を格納しておき、この後のバリデーションでエラーにする
				date = 'error'
			end
		end

		# バリデーション
		if bunrui.class == String && price.class == Fixnum && use.class == String && date.class == Date

			balance = Balance.new
			balance.balance_class = bunrui
			balance.value = price
			balance.column = use
			balance.balance_date = date.strftime('%Y-%m-%d')
			balance.save
			text = "この内容で登録しました。\n\n分類: " + bunrui + "\n金額: " + price.to_s + "\n使途: " + use + "\n日付: " + date.strftime('%Y-%m-%d')
		else
			text = echo_usage
		end
                
          elsif  post_message == '収入'
          	text = 'いいいい'
          else
          	text = echo_usage
          end
          message = {
            type: 'text',
            #text: event.message['text'] + 'aaaaa'
            text: text
          }
          client.reply_message(event['replyToken'], message)
       
        # 画像や動画の場合は
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          ### オウム返しのコード
          #response = client.get_message_content(event.message['id'])
          #tf = Tempfile.open("content")
          #tf.write(response.body)
          message = {
            type: 'text',
            text: '支出/収入を登録できます'
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }
    "OK"
  end

  private def date_valid?(str)
    !! Date.parse(str) rescue false
  end
end
