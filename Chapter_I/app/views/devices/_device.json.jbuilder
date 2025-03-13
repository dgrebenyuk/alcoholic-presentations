json.extract! device, :id, :ip, :netmask, :vendor, :channels, :description, :created_at, :updated_at
json.url device_url(device, format: :json)
