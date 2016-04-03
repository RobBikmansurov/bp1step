class AddFieldAuthorToLetter < ActiveRecord::Migration
  def change
    add_reference :letters, :author, index: true
  end
end
