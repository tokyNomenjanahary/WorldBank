class AddFonctionToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :fonction, :string
  end
end
