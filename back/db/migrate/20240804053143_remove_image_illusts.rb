class RemoveImageIllusts < ActiveRecord::Migration[7.1]
  def change
    remove_column :illusts, :image, :string
  end
end
