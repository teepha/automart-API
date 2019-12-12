class FlagSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :car_id, :reason, :description
end
