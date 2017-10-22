module StatefulFieldFor
  class Railtie < ::Rails::Railtie
    initializer :stateful_field_for do
      ActiveSupport.on_load :active_record do
        extend StatefulFieldFor
      end
    end
  end
end
