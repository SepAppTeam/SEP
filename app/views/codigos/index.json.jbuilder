json.array!(@codigos) do |codigo|
  json.extract! codigo, :estudiante_id, :codigo_evaluacion, :estado
  json.url codigo_url(codigo, format: :json)
end
