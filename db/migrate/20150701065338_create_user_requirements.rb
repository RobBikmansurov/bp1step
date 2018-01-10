class CreateUserRequirements < ActiveRecord::Migration[4.2]
  def change
    create_table :user_requirements do |t|
      t.references :user, index: true
      t.references :requirement, index: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
