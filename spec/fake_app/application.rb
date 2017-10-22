require "active_record"
require "action_controller"
require "stateful_field_for"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

module FakeApp
  class Application < Rails::Application
    config.eager_load = false
  end
end

FakeApp::Application.initialize!

class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :title
      t.datetime :published_at
      t.datetime :hidden_at

      t.timestamps
    end
  end
end

class Picture < ActiveRecord::Base
  stateful_field_for :published_at, scope: true do
    enable  :publish,   to: :published, initial: true
    disable :unpublish, to: :unpublished
  end

  stateful_field_for :hidden_at do
    enable  :hide, to: :hidden
    disable :show, to: :visible
  end
end
