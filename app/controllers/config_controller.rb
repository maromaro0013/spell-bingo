class ConfigController < ApplicationController
  def index
    ret = {}
    ret[:spell_max] = SpellBingo::Application.config.spell_max
    ret[:spell_row_max] = SpellBingo::Application.config.spell_row_max
    ret[:spell_col_max] = SpellBingo::Application.config.spell_col_max
    ret[:spell_center] = SpellBingo::Application.config.spell_center
    ret[:status] = "succeed"

    respond_to do |format|
      format.json {
        render :json => ret
      }
    end
  end
end
