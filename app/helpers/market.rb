class Market
  @client = IEX::Api::Client.new
  def self.get(ticker)
    ticker.upcase!
    a = Rails.cache.fetch("get_ticker_#{ticker}",
                          expires_in: 5.minutes) do
      puts "Cache miss"
      puts ticker
      begin
        @client.quote(ticker)
      rescue IEX::Errors::SymbolNotFoundError => e
        nil
      end
    end
  end
end
