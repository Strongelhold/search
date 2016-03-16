class CreateSearchers < ActiveRecord::Migration
  def change
    create_table :searchers do |t|

      t.timestamps null: false
    end
  end
end
