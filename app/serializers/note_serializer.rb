class NoteSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :content
  belongs_to :list
end
