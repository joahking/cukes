class CreateCukes < ActiveRecord::Migration
  def self.up
    create_table :cukes do |t|
      t.string :cuke_version
      t.string :webrat_version

      t.timestamps
    end
  end

  def self.down
    drop_table :cukes
  end
end
