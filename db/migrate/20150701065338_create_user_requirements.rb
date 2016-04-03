class CreateUserRequirements < ActiveRecord::Migration
  def change
    create_table :user_requirements do |t|
      t.references :user, index: true
      t.references :requirement, index: true
      t.integer :status

      t.timestamps
    end
  end
end
