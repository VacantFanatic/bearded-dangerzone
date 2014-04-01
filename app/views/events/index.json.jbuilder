json.array!(@events) do |event|
  json.extract! event, :id, :uid, :type, :startDate, :endDate
  json.url event_url(event, format: :json)
end
