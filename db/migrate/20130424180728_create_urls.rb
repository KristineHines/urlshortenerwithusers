class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :long_url, :unique => true
      t.string :short_url
      t.integer :click_count, :default => 0
      t.references :user
    end
  end
end
