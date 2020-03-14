Rails.application.routes.draw do
  get "/:ticker" => "root#ticker"
end
