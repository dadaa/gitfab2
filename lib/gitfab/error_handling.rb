module Gitfab::ErrorHandling
  extend ActiveSupport::Concern
  included do
    Rack::Utils::SYMBOL_TO_STATUS_CODE.keys.each do |status|
      define_singleton_method("handle_as_#{status}") do |*args|
        rescue_from *args do |e|
          render "public/#{Rack::Utils::SYMBOL_TO_STATUS_CODE[status]}", status: status
        end
      end
    end
  end
end
