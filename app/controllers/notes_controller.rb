class NotesController < ApplicationController
  respond_to :json
  def index
  	@notes = current_user.notes.where(list_id: nil)
  	respond_with @notes
  end 

  def destroy
  	@note = Note.find(params[:id])
  	@note.destroy()
  	respond_with status: :ok
  end

  def update
    note = Note.find(params[:id])
    note.update(note_params)
    respond_with status: :ok
  end

  def note_params
    params.require(:note).permit(:content, :list_id)
  end
end