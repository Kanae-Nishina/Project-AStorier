ActiveSupport.on_load(:active_storage_blob) do
  validates :byte_size, numericality: { less_than: 10.megabytes }
end