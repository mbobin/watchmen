ConnectionSchema = Dry::Schema.Params do
  required(:ip).filled(:string)
  required(:port).filled(:integer)
  required(:username).maybe(:string)
end