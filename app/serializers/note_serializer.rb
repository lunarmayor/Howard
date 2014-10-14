class NoteSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :content
end
