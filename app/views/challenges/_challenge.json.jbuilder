json.extract! challenge, :id, :description, :created_at, :updated_at
json.url challenge_url(challenge, format: :json)
json.description challenge.description.to_s
