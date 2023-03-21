json.extract! board, :id, :title, :description, :created_at, :updated_at
json.url board_url(board, format: :json)
