class UserSerializer < ActiveModel::Serializer
  attributes :id, :phone, :email, :prompt
end
