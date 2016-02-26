class SpellController < ApplicationController
  def edit
    spell = Spell.find(params[:id])
    new_name = params[:name]
    spell.name = new_name
    spell.save

    status = "succeed"
    respond_to do |format|
      format.json {
        ret = {'status' => status}
        render :json => ret
      }
    end
  end
end
