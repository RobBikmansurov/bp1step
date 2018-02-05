class AddFieldAuthorToLetter < ActiveRecord::Migration[4.2]
  def change
    add_reference :letters, :author, index: true
  end
end
