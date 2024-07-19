class RemoveImageProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :avatar, :string
    remove_column :profiles, :header_image, :string
  end
end
