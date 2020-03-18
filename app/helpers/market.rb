class Market
  @@client = IEX::Api::Client.new
  def self.get(ticker)
    ticker.upcase!
    a = Rails.cache.fetch("get_ticker_#{ticker}",
                          expires_in: 5.minutes) do
      puts "Cache miss"
      StatsD.measure("iex.lookup_time") do
        begin
          @@client.quote(ticker)
        rescue IEX::Errors::SymbolNotFoundError => e
          nil
        end
      end
    end
  end

  def self.crypto(fiat, crypt)
    return nil unless fiat =~ /\A\p{Alnum}+\z/
    return nil unless crypt =~ /\A\p{Alnum}+\z/
    Rails.cache.fetch("get_crypto_#{fiat}#{crypt}",
                      expires_in: 5.minutes) do
      puts "Crypto cache miss"
      Cryptocompare::Price.full(crypt, fiat).dig("DISPLAY", crypt, fiat)
    end
  end
end
