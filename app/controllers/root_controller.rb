class RootController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  def ticker
    info = Market.get(params[:ticker])
    if info.nil?
      render body: "Unknown ticker \"#{params[:ticker]}\"\r\n"
      return
    end
    s = "#{params[:ticker]}: #{number_to_currency(info.latest_price)} #{info.change_percent_s}\n"
    if params[:f] == "i3"
      ticker_i3(s, info.change_percent)
      return
    end
    if info.change_percent > 0
      s = green s
    elsif info.change_percent < 0
      s = red s
    end
    render body: s
  end

  private

  def ticker_i3(s, delta)
    if delta > 0
      s = s + "\n#00FF00\n"
    elsif delta < 0
      s = s + "\n#FF0000\n"
    end
    render body: s
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
end
