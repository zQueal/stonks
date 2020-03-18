Rails.application.routes.draw do
  get "/:ticker" => "root#ticker"
  get "/crypto/:fiat/:crypto" => "root#crypto"
end
