class NoteSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :content
  has_one :list
end
