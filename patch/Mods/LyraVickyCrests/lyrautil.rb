class PokeBattle_Battle
  def pbLVC_OpposingCrestCheck(mon,crest)
    for battler in @battlers
        next if battler.isFainted?
        next if !battler.pbIsOpposing?(mon.index)
        next if battler == mon
        return true if battler.crested == crest
    end
    return false
  end
end