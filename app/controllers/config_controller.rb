class ConfigController < ApplicationController
  def index
    status = "succeed"
    spell_max = SpellBingo::Application.config.spell_max

    respond_to do |format|
      format.json {
        ret = {'status' => status, 'spell_max' => spell_max}
        render :json => ret
      }
    end
  end
end
