json.array!(@events) do |event|
  json.extract! event, :id, :type, :start, :end, :uid
  json.url event_url(event, format: :json)
end
