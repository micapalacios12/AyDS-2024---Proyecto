class AddAvatarToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar, :string  # Añade una columna de tipo string para almacenar la ruta del avatar
  end
end
